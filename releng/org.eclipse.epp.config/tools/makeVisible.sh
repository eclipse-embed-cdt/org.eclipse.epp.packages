#!/usr/bin/env bash
#*******************************************************************************
# Copyright (c) 2016, 2017 IBM Corporation and others.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v2.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v20.html
#
# Contributors:
#     David Williams - initial API and implementation
#       Initial version based on similar file in Sim Release repository
#*******************************************************************************


# Small utility to more automatically do the renames the morning of "making visible",
# after artifacts have mirrored. In theory, could be done by a cron or at job.
#
# Note, copy is used, instead of move, so that the parent directory's "modified time" does not change.
# That way the mirroring script won't falsely report "no mirrors" (for a while).
#
# Plus, we "copy over" any existing files, under the assumption that previous labeled files are left in place,
# for a while, so they'd serve as backup. If that ever changes, should make a --backup of
# the original files ... just in case ... but then modified time of parent directory would be
# changed.
#
# And notice we do "artifacts" first, so by the time "content" can be retrieved, by p2, thre will be
# valid artifacts "pointed to". If anyone has already fetched 'content' and in the middle of getting
# artifacts, their downloads should nearly always continue to work (except we do keep only 3 milestones
# in composite, so in theory, they might have stale 'content' data that pointed to an old artifact that
# was no longer in (the newly copied) 'artifacts' file.

function usage ()
{
  printf "\n\t%s" "This utility, ${0##*/}, is to copy the two metadataXX.jars to their final name of metadata.jar." >&2
  printf "\n\t\t%s\n" "Example: ${0##*/} 'trainName' 'checkpoint'" >&2
  printf "\n\t%s" "Both arguments are required." >&2
  printf "\n\t%s" "'trainName' is the final directory segment of where the composite files reside," >&2
  printf "\n\t\t%s\n" "such as neon, oxygen, photon, etc." >&2
  printf "\n\t%s" "'checkpoint' is the pre-visibility label given to the metadata files," >&2
  printf "\n\t\t%s\n" "such as M4, RC1, etc. or simply R for final release, 1 for Update 1, etc.." >&2
  printf "\n\t\t%s\n" "For example, for Neon.1 the file content1.jar is copied to content.jar " >&2
  printf "\n\t\t\t%s\n" "and content1.xml.xz, if it exists, is copied to content.xml.xz" >&2
  printf "\n\t\t%s\n" "If the contentN.jar or artifactsN.jar do not exist, it is treated as an error." >&2
  printf "\n\t\t%s\n" "But if the corresponding "xz" versions do not exist, it is treated as a warning." >&2
}

function changeNamesByCopy ()
{

  REPO_ROOT=$1

  # be paranoid with sanity checks
  if [[ -z "${REPO_ROOT}"  ]]
  then
    printf "\n\t[ERROR] REPO_ROOT must be passed in to this function ${0##*/}\n"
    exit 1
  elif [[ ! -e "${REPO_ROOT}" ]]
  then
    printf "\n\t[ERROR] REPO_ROOT did not exist!\n\tREPO_ROOT: ${REPO_ROOT}\n"
    exit 1
  elif [[ ! -w "${REPO_ROOT}" ]]
  then
    printf "\n\t\[ERROR] We do not appear to have write access to REPO_ROOT\n"
  else
    printf "\n\t[INFO] REPO_ROOT existed as expected:\n\tREPO_ROOT: ${REPO_ROOT}\n\n"
  fi

  artifactsFileName="artifacts"
  contentFileName="content"
  oldArtifactsJarName="${artifactsFileName}${CHECKPOINT}.jar"
  oldContentJarName="${contentFileName}${CHECKPOINT}.jar"
  newArtifactsJarName="${artifactsFileName}.jar"
  newContentJarName="${contentFileName}.jar"
  oldArtifactsXZName="${artifactsFileName}${CHECKPOINT}.xml.xz"
  oldContentXZName="${contentFileName}${CHECKPOINT}.xml.xz"
  newArtifactsXZName="${artifactsFileName}.xml.xz"
  newContentXZName="${contentFileName}.xml.xz"
  
  # Note: we check for all error conditions first, so if there is any one error, we make no changes.
  if [[ ! -e "${REPO_ROOT}/${oldArtifactsJarName}" ]]
  then
    printf "\n\t[ERROR] ${oldArtifactsJarName} did not exist in REPO_ROOT!\n"
    exit 1
  fi
  if [[ ! -e "${REPO_ROOT}/${oldContentJarName}" ]]
  then
    printf "\n\t[ERROR] ${oldContentJarName} did not exist in REPO_ROOT!\n"
    exit 1
  fi

  # TODO: should these be errors?
  if [[ ! -e "${REPO_ROOT}/${oldArtifactsXZName}" ]]
  then
    printf "\n\t[WARNING] ${oldArtifactsXZName} did not exist in REPO_ROOT!\n"
  fi
  if [[ ! -e "${REPO_ROOT}/${oldContentXZName}" ]]
  then
    printf "\n\t[WARNING] ${oldContentXZName} did not exist in REPO_ROOT!\n"
  fi

  # The copy work begins here, still checking for errors on each
  # verbose doesn't help too much if out-format given
  verboseOutput=
  #verboseOutput="--verbose"
  # out-format gives us the names of files copied
  #outputFormat=
  # using %i gives details of "what" changed about existing item. 
  # In our case it typically says something like: '>f..T......artifacts1.jar'
  # Which means "transferred" "file" and its "Time" changed. 
  # (Does say say new name of file, though ... ll -tr will give "most recent" 
  # files at end of listing). 
  outputFormat="--out-format='%i%n%L'"
  rsync ${outputFormat} --group ${verboseOutput} ${REPO_ROOT}/${oldArtifactsJarName} ${REPO_ROOT}/${newArtifactsJarName}
  RC=$?
  if [[ $RC != 0 ]]
  then
    printf "\n\t[ERROR] copy returned a non zero return code for ${oldArtifactsJarName}. RC: $RC\n"
    exit $RC
  fi
  rsync ${outputFormat} --group ${verboseOutput} ${REPO_ROOT}/${oldContentJarName}   ${REPO_ROOT}/${newContentJarName}
  RC=$?
  if [[ $RC != 0 ]]
  then
    printf "\n\t[ERROR] copy returned a non zero return code for ${oldContentJarName}. RC: $RC\n"
    exit $RC
  fi

  if [[ -e ${REPO_ROOT}/${oldArtifactsXZName} ]]
  then
  rsync ${outputFormat} --group ${verboseOutput} ${REPO_ROOT}/${oldArtifactsXZName} ${REPO_ROOT}/${newArtifactsXZName}
  RC=$?
  if [[ $RC != 0 ]]
  then
    printf "\n\t[ERROR] copy returned a non zero return code for ${oldArtifactsXZName}. RC: $RC\n"
    exit $RC
  fi
  fi
  if [[ -e ${REPO_ROOT}/${oldContentXZName} ]]
  then
  rsync ${outputFormat} --group ${verboseOutput} ${REPO_ROOT}/${oldContentXZName}   ${REPO_ROOT}/${newContentXZName}
  RC=$?
  if [[ $RC != 0 ]]
  then
    printf "\n\t[ERROR] copy returned a non zero return code for ${oldContentXZName}. RC: $RC\n"
    exit $RC
  fi
fi

}

# This is entry point to "main" function
# We require both arguments, since to provide a default could lead to
# very bad errors if wrong value of "trainName" was used.

if [[ ! $# = 2 ]]
then
  printf "\n\t[ERROR] Wrong number of arguments to ${0##*/}\n"
  usage
  exit 1
fi


TRAIN_NAME=$1
CHECKPOINT=$2

printf "\n\tArguments to utility were:"
printf "\n\t\tTRAIN_NAME: ${TRAIN_NAME}"
printf "\n\t\tCHECKPOINT: ${CHECKPOINT}\n"

if [[ -z "${CHECKPOINT}" || -z "${TRAIN_NAME}" ]]
then
  # This would be rare. Equates to something like ./makevisible.sh "" M2
  # But, just in case. Note that something like ./makevisible "   " M2
  # is still not handled well.
  printf "\n\t%s\n" "[ERROR]: one or both required arguments were empty?!\n" >&2
  usage
  exit 1
fi

# Note: we do "Sim Rel repo" first, to avoid a small window of users getting
# EPP metadata for update, but the Sim Rel repo not being ready.
# Note: we allow "override" of the repo roots by env. variable to make testing easier.

EPP_REPO_ROOT=${EPP_REPO_ROOT:-/home/data/httpd/download.eclipse.org/technology/epp/packages/${TRAIN_NAME}}
changeNamesByCopy "${EPP_REPO_ROOT}"
RC=$?
if [[ $RC != 0 ]]
then
  printf "\n\t[ERROR] changeNamesByCopy returned non-zero return code. RC: $RC\n"
  exit $RC
fi
exit 0

