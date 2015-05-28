#!/bin/bash
#set -x
umask 0002
ulimit -n 2048

# Change this if building on build.eclipse.org to "server"; "local" otherwise
BUILDLOCATION="server"

# Location of the build input
HTTP_BASE="http://download.eclipse.org"
FILESYSTEM_BASE="file:///home/data/httpd/download.eclipse.org"

# Define the BASE_URL to be used
if [ ${BUILDLOCATION} = "server" ]
then
   BASE_URL=${FILESYSTEM_BASE}
   ECLIPSE="/shared/technology/epp/epp_build/mars/eclipse/eclipse"
   JRE="/usr/local/bin/java"
 else
   BASE_URL=${HTTP_BASE}
   ECLIPSE="eclipse"
   JRE="java"
fi

###############################################################################

# variables to adjust
BASE_DIR=/shared/technology/epp/epp_build/mars
RELEASE_NAME="-mars-RC2"

# variables
START_TIME=`date -u +%Y%m%d-%H%M`
MARKERFILENAME=".epp.nightlybuild"
STATUSFILENAME="status.stub"
GITURL="/gitroot/epp/org.eclipse.epp.packages.git"
GITBRANCH="HEAD"
GITPROJECTPATH="packages"
DOWNLOAD_BASE_URL="http://build.eclipse.org/technology/epp/epp_build/mars/download"

# directories and files
DOWNLOAD_BASE_DIR="${BASE_DIR}/download"
BUILD_DIR="${BASE_DIR}/build"
DOWNLOAD_DIR="${DOWNLOAD_BASE_DIR}/${START_TIME}"
EPPREPO_INPUT_DIR="/shared/technology/epp/epp_repo/mars/epp.build/buildresult/org.eclipse.epp.allpackages.feature_4.5.0-eclipse.feature/site.p2"
EPPREPO_WORKINGCOPY_DIR="${DOWNLOAD_DIR}/repository"
MARKERFILE="${DOWNLOAD_DIR}/${MARKERFILENAME}"
STATUSFILE="${DOWNLOAD_DIR}/${STATUSFILENAME}"
LOGFILE="${DOWNLOAD_DIR}/build.log"
LOCKFILE="/tmp/epp.build.mars.lock"

# repository locations
#REPO_ECLIPSE_URL="${BASE_URL}/eclipse/updates/4.5.x/"
#REPO_ECLIPSE_URL="${BASE_URL}/eclipse/updates/4.5milestones/"
#REPO_SIMRELEASE_URL="${BASE_URL}/releases/mars/"
REPO_STAGING_URL="${BASE_URL}/releases/staging/"
#REPO_EPP_URL="${BASE_URL}/technology/epp/packages/mars"
#REPO_EPP_URL="file://${EPPREPO_INPUT_DIR}"
REPO_EPP_WORKINGCOPY_URL="file://${EPPREPO_WORKINGCOPY_DIR}"

# repositories used in the build
METADATAREPOSITORIES="${REPO_STAGING_URL},${REPO_EPP_WORKINGCOPY_URL}"
ARTIFACTREPOSITORIES="${REPO_STAGING_URL},${REPO_EPP_WORKINGCOPY_URL}"

# definition of OS, WS, ARCH, FORMAT combinations - DO NOT FORGET to adjust the for loop
OSes=(   win32  win32   linux   linux   macosx  )
WSes=(   win32  win32   gtk     gtk     cocoa   )
ARCHes=( x86    x86_64  x86     x86_64  x86_64  )
FORMAT=( zip    zip     tar.gz  tar.gz  tar.gz  )

###############################################################################

# only one build process allowed
## using the Hudson EPP lock, but leave the code in there for now
#if [ -e ${LOCKFILE} ]; then
#    echo "${START_TIME} EPP build - lockfile ${LOCKFILE} exists" >/dev/stderr
#    exit 1
#fi
#trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
#touch ${LOCKFILE}

# create download directory and files, copy p2 repo to working location
mkdir -p ${DOWNLOAD_DIR}
touch ${MARKERFILE}
touch ${STATUSFILE}
cp -a ${EPPREPO_INPUT_DIR} ${EPPREPO_WORKINGCOPY_DIR}
NOVA_DIR=${BASE_DIR}/org.eclipse.epp.packages/releng/org.eclipse.epp.config/web
sed "s/XXXXXXXXXXXXXXXXXXXXXXXXXXXXX/EPP Build ${START_TIME}${RELEASE_NAME}/" ${NOVA_DIR}/novaHeader.html >${DOWNLOAD_DIR}/novaHeader.html
cp ${NOVA_DIR}/novaFooter.html ${DOWNLOAD_DIR}

# log to file
exec 2>&1 | tee ${LOGFILE}

# determine which packages to build
PACKAGES=""
if [ $# = "0" ]; then
  # generate the list from the packages checked into CVS
  echo "CVS CHECKOUT NOT WORKING ANY MORE... THIS PART NEEDS TO BE MIGRATED TO GIT"
  exit 1
  cvs -q -d :pserver:anonymous@dev.eclipse.org:/cvsroot/technology checkout -P ${CVSPROJECTPATH}
  for file in  $(ls ${CVSPROJECTPATH} | grep -v feature | grep -v common | grep -v CVS);  
  do
    PACKAGES="${PACKAGES} ${file##org.eclipse.}" 
  done
else
  # take the package names from the command lines if any given
  PACKAGES="$@"
fi
echo "...building the following packages: ${PACKAGES}"
echo "...using metadata repositories: ${METADATAREPOSITORIES}"
echo "...using artifact repositories: ${ARTIFACTREPOSITORIES}"

echo "...loading external functions"
git archive --format=tar --remote=${GITURL} ${GITBRANCH} releng/org.eclipse.epp.config/tools/functions.sh | tar xf - --to-stdout >functions.sh
. functions.sh

# check-out configuration
PACKAGES_MAP_FILE=packages_map.txt
echo "...checking out configuration map to ${PACKAGES_MAP_FILE}"
git archive --format=tar --remote=${GITURL} ${GITBRANCH} releng/org.eclipse.epp.config/packages_map.txt | tar xf - --to-stdout >${PACKAGES_MAP_FILE}
pullAllConfigFiles ${PACKAGES_MAP_FILE} ${DOWNLOAD_DIR}

# start statusfile
echo "<tr>" >>${STATUSFILE}
echo "<td>${START_TIME}</td>" >>${STATUSFILE}

# build the packages
for PACKAGE in ${PACKAGES};
do
  echo "Building package for IU ${PACKAGE}"
  mkdir -p ${BUILD_DIR}/${PACKAGE}
  
  # Start statusfile
  echo "<td>"  >>${STATUSFILE}

  for index in 0 1 2 3 4;
  do
    echo -n "...EPP building ${PACKAGE} ${OSes[$index]} ${WSes[$index]} ${ARCHes[$index]} "
    EXTENSION="${OSes[$index]}.${WSes[$index]}.${ARCHes[$index]}"
    PACKAGE_BUILD_DIR="${BUILD_DIR}/${PACKAGE}/${EXTENSION}"
    rm -rf ${PACKAGE_BUILD_DIR}
    mkdir -p ${PACKAGE_BUILD_DIR}
    ${ECLIPSE} -nosplash -consoleLog -application org.eclipse.equinox.p2.director \
      -m ${METADATAREPOSITORIES} -a ${ARTIFACTREPOSITORIES} \
      -installIU ${PACKAGE} \
      -destination ${PACKAGE_BUILD_DIR}/eclipse \
      -profile ${PACKAGE} \
      -flavor tooling \
      -profileproperties org.eclipse.update.install.features=true \
      -bundlepool ${PACKAGE_BUILD_DIR}/eclipse \
      -purgeHistory \
      -p2.os ${OSes[$index]} \
      -p2.ws ${WSes[$index]} \
      -p2.arch ${ARCHes[$index]} \
      -roaming \
      -vm ${JRE} \
      -vmargs -Declipse.p2.mirrors=false \
         2>&1 >${DOWNLOAD_DIR}/${PACKAGE}_${EXTENSION}.log
    if [ $? = "0" ]; then
      cd ${PACKAGE_BUILD_DIR}
      PACKAGE_SHORT=`echo ${PACKAGE} | cut -d "." -f 3`${RELEASE_NAME}
      if [ ${OSes[$index]} = "win32" ]; then
        PACKAGEFILE="${START_TIME}_eclipse-${PACKAGE_SHORT}-${EXTENSION}.zip"
        zip -r -o -q ${DOWNLOAD_DIR}/${PACKAGEFILE} eclipse
      else
        PACKAGEFILE="${START_TIME}_eclipse-${PACKAGE_SHORT}-${EXTENSION}.tar.gz"
        tar zc --owner=100 --group=100 -f ${DOWNLOAD_DIR}/${PACKAGEFILE} eclipse
      fi
      cd ..
      rm -r ${PACKAGE_BUILD_DIR}
      echo "...successfully finished ${OSes[$index]} ${WSes[$index]} ${ARCHes[$index]} package build: ${PACKAGEFILE}"
      echo ${PACKAGEFILE} >>${DOWNLOAD_DIR}/${PACKAGE}_${EXTENSION}.log
      echo "<small style=\"background-color: rgb(204, 255, 204);\"><a href=\"${DOWNLOAD_BASE_URL}/${START_TIME}/${PACKAGEFILE}\">${OSes[$index]}.${ARCHes[$index]}</a></small><br>"  >>${STATUSFILE}
    else
      echo "...failed while building package ${OSes[$index]} ${WSes[$index]} ${ARCHes[$index]}"
      echo "FAILED" >>${DOWNLOAD_DIR}/${PACKAGE}_${EXTENSION}.log
      echo "<small style=\"background-color: rgb(255, 204, 204);\"><a href=\"${DOWNLOAD_BASE_URL}/${START_TIME}/${PACKAGE}_${EXTENSION}.log\">${OSes[$index]}.${ARCHes[$index]}</a></small><br>"  >>${STATUSFILE}
    fi
  done
  echo "</td>"  >>${STATUSFILE}
done

# End statusfile
echo "</tr>" >>${STATUSFILE}

# remove 'some' (which?) files from the download server
echo "...remove oldest build from download directory ${DOWNLOAD_BASE_DIR}"
cd ${DOWNLOAD_BASE_DIR}
TOBEDELETED_TEMP=`find . -name ${MARKERFILENAME} | grep -v "\./${MARKERFILENAME}" | sort | head -n 1`
TOBEDELETED_DIR=`echo ${TOBEDELETED_TEMP} | cut -d "/" -f 2`
echo "......removing ${TOBEDELETED_DIR} from ${DOWNLOAD_BASE_DIR}"
rm -r ${TOBEDELETED_DIR}

# link results somehow in a single file
echo "...recreate ${DOWNLOAD_BASE_DIR}/${STATUSFILENAME}"
rm ${DOWNLOAD_BASE_DIR}/${STATUSFILENAME}
cd ${DOWNLOAD_BASE_DIR}
for FILE in `ls -r */${STATUSFILENAME}`
do
  echo "......adding $FILE"
  cat ${FILE} >>${DOWNLOAD_BASE_DIR}/${STATUSFILENAME}
done
cp -a --no-preserve=ownership ${DOWNLOAD_BASE_DIR}/${STATUSFILENAME} /home/data/httpd/download.eclipse.org/technology/epp/downloads/testing/statusMars.stub



###############################################################################

echo "EPP package build finished."

# remove lockfile
## using the Hudson EPP lock, but leave the code in there for now
#rm ${LOCKFILE}

## EOF
