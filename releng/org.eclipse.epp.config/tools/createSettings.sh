#!/bin/bash
#
#  Copyright (c) 2014, 2015 Innoopract Informationssysteme GmbH and others.
#  All rights reserved. This program and the accompanying materials
#  are made available under the terms of the Eclipse Public License v2.0
#  which accompanies this distribution, and is available at
#  http://www.eclipse.org/legal/epl-v20.html
# 
#  Contributors:
#     Innoopract Informationssysteme GmbH - initial API and implementation
#     EclipseSource - ongoing development
###############################################################################

###############################################################################
# The purpose of this little shell script is to generate a settings.xml
# for Maven that contains a list of packages (as activated profiles) based
# on the last commit to Git. The idea is that this helps to reduce the
# number of CPU cycles that are required in a Gerrit verification build job
# by building only the relevant packages. 
# (Relevant == the packages that are potentially affected by this change)
###############################################################################

WORKSPACE=${WORKSPACE:-"${PWD}"}
GIT_REPOSITORY=${GIT_REPOSITORY:-"org.eclipse.epp.packages"}
SETTINGS_FILE=${SETTINGS_FILE:-"${WORKSPACE}/settings.xml"}
IGNORED_PACKAGES=${IGNORED_PACKAGES:-""}
FULL_BUILD=${FULL_BUILD:-"false"}

echo "Creating ${SETTINGS_FILE}"
echo "Ignoring package(s): ${IGNORED_PACKAGES}"

### add initial content (proxy definition) from $HOME/.m2/settings.xml
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >$SETTINGS_FILE
echo "<settings xmlns=\"http://maven.apache.org/SETTINGS/1.0.0\"" >>$SETTINGS_FILE
echo "          xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" >>$SETTINGS_FILE
echo "          xsi:schemaLocation=\"http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd\">" >>$SETTINGS_FILE
echo "" >>$SETTINGS_FILE
echo "  <mirrors>" >>$SETTINGS_FILE
echo "    <mirror>" >>$SETTINGS_FILE
echo "      <id>eclipse.maven.central.mirror</id>" >>$SETTINGS_FILE
echo "      <name>Eclipse Central Proxy</name>" >>$SETTINGS_FILE
echo "      <url>https://repo.eclipse.org/content/repositories/maven_central/</url>" >>$SETTINGS_FILE
echo "      <mirrorOf>central</mirrorOf>" >>$SETTINGS_FILE
echo "    </mirror>" >>$SETTINGS_FILE
echo "    <mirror>" >>$SETTINGS_FILE
echo "      <id>example-mirror</id>" >>$SETTINGS_FILE
echo "      <mirrorOf>https://download.eclipse.org/</mirrorOf>" >>$SETTINGS_FILE
echo "      <url>file:/home/data/httpd/download.eclipse.org/</url>" >>$SETTINGS_FILE
echo "      <layout>p2</layout>" >>$SETTINGS_FILE
echo "      <mirrorOfLayouts>p2</mirrorOfLayouts>" >>$SETTINGS_FILE
echo "    </mirror>" >>$SETTINGS_FILE 
echo "  </mirrors>" >>$SETTINGS_FILE

echo "  <activeProfiles>" >>$SETTINGS_FILE

### use the HEAD commit to find out which package directories contain a change
PACKAGES="${IGNORED_PACKAGES}"
cd ${WORKSPACE}/${GIT_REPOSITORY}
for II in `git diff-tree --name-only --no-commit-id -r HEAD | cut -d "/" -f 2 | cut -d "." -f 5 | sort | uniq`; do
  if [[ "common" =~ ${II} ]]
  then
    echo "${II} found; will trigger a full package build."
    FULL_BUILD="true"
    continue
  fi
  if [[ ${IGNORED_PACKAGES} =~ ${II} ]]
  then
    echo "${II} contains changes, but is ignored or a duplicate."
    continue
  fi
  PACKAGE="epp.package.${II}"
  echo "Adding package $PACKAGE"
  echo "    <activeProfile>${PACKAGE}</activeProfile>" >>$SETTINGS_FILE
  PACKAGES="${PACKAGES} ${PACKAGE}"
done
cd ${WORKSPACE}

### if there are changes in other areas of the Git repo then build everything
cd ${WORKSPACE}/${GIT_REPOSITORY}
OTHERCHANGES="xxx`git diff-tree --name-only --no-commit-id -r HEAD | grep -v "^packages"`xxx"
if [ "${OTHERCHANGES}" != "xxxxxx" ] || [ "${FULL_BUILD}" == "true" ]
then
  echo "Full build required. Adding all packages"
  ALLPACKAGES=`ls packages | cut -d "." -f 5 | sort | uniq`
  for II in ${ALLPACKAGES}; do
    if [[ "common" =~ ${II} ]]
    then
      continue
    fi
    if [[ ${PACKAGES} =~ ${II} ]]
    then
      echo "${II} should be added for all packages, but it is ignored or a duplicate."
      continue
    else
      PACKAGE="epp.package.${II}"
      echo "Adding package $PACKAGE"
      echo "    <activeProfile>${PACKAGE}</activeProfile>" >>$SETTINGS_FILE
      PACKAGES="${PACKAGES}"
    fi
  done
fi
cd ${WORKSPACE}

### close the settings.xml file
echo "  </activeProfiles>" >>$SETTINGS_FILE
echo "" >>$SETTINGS_FILE
echo "</settings>" >>$SETTINGS_FILE

echo "Written new $SETTINGS_FILE"

