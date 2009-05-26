#!/bin/bash
#set -x
umask 0022
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
   ECLIPSE="/shared/technology/epp/epp_build/35/eclipse/eclipse"
   JRE="/opt/ibm/java2-ppc-50/bin/java"
 else
   BASE_URL=${HTTP_BASE}
   ECLIPSE="eclipse"
   JRE="java"
fi

# Galileo Repositories
REPO_ECLIPSE35="${BASE_URL}/eclipse/updates/3.5milestones/S-3.5RC2-200905221710/"
REPO_GALILEO="${BASE_URL}/releases/galileo/"
REPO_STAGING="${BASE_URL}/releases/staging/"
#REPO_EPP_GALILEO="${BASE_URL}/technology/epp/packages/galileo/milestones"
REPO_EPP_GALILEO="file:///shared/technology/epp/epp_repo/galileo/epp.build/buildresult/org.eclipse.epp.allpackages.feature_1.0.0-eclipse.feature/site.p2"

# Repositories (Galileo)
METADATAREPOSITORIES="${REPO_STAGING},${REPO_ECLIPSE35},${REPO_EPP_GALILEO}"
ARTIFACTREPOSITORIES="${REPO_STAGING},${REPO_ECLIPSE35},${REPO_EPP_GALILEO}"

OSes=( win32 linux linux macosx )
WSes=( win32 gtk gtk cocoa )
ARCHes=( x86 x86 x86_64 x86 )
FORMAT=( zip tar.gz tar.gz tar.gz )

BASE_DIR=/shared/technology/epp/epp_build/35
DOWNLOAD_BASE_DIR=${BASE_DIR}/download
DOWNLOAD_BASE_URL="http://build.eclipse.org/technology/epp/epp_build/35/download"
BUILD_DIR=${BASE_DIR}/build

###############################################################################

# variables
START_TIME=`date -u +%Y%m%d-%H%M`
LOCKFILE="/tmp/epp.build35.lock"
MARKERFILENAME=".epp.nightlybuild"
STATUSFILENAME="status.stub"
CVSPATH="org.eclipse.epp/releng/org.eclipse.epp.config"
CVSPROJECTPATH="org.eclipse.epp/packages"
RELEASE_NAME="-galileo-RC2"

###############################################################################

# only one build process allowed
if [ -e ${LOCKFILE} ]; then
    echo "${START_TIME} EPP build - lockfile ${LOCKFILE} exists" >/dev/stderr
    exit 1
fi
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
touch ${LOCKFILE}

# create download directory and files
DOWNLOAD_DIR=${DOWNLOAD_BASE_DIR}/${START_TIME}
mkdir -p ${DOWNLOAD_DIR}
MARKERFILE="${DOWNLOAD_DIR}/${MARKERFILENAME}"
touch ${MARKERFILE}
STATUSFILE="${DOWNLOAD_DIR}/${STATUSFILENAME}"
touch ${STATUSFILE}

# log to file
LOGFILE="${DOWNLOAD_DIR}/build.log"
exec 2>&1 | tee ${LOGFILE}

#Build the packages from the list of packages checked into CVS
PACKAGES=""
cvs -q -d :pserver:anonymous@dev.eclipse.org:/cvsroot/technology checkout -P ${CVSPROJECTPATH}
for file in  $(ls ${CVSPROJECTPATH} | grep -v feature | grep -v CVS);  
do
  PACKAGES="${PACKAGES} ${file##org.eclipse.}" 
done

# load external functions
. ${BASE_DIR}/${CVSPATH}/tools/functions.sh

# check-out configuration
echo "...checking out configuration to ${BASE_DIR}"
cvs -q -d :pserver:anonymous@dev.eclipse.org:/cvsroot/technology checkout -P ${CVSPATH}
pullAllConfigFiles ${BASE_DIR}/${CVSPATH}/packages_map.txt ${DOWNLOAD_DIR}

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

  for index in 0 1 2 3;
  do
    echo -n "...EPP building ${PACKAGE} ${OSes[$index]} ${WSes[$index]} ${ARCHes[$index]} "
    EXTENSION="${OSes[$index]}.${WSes[$index]}.${ARCHes[$index]}"
    PACKAGE_BUILD_DIR="${BUILD_DIR}/${PACKAGE}/${EXTENSION}"
    rm -rf ${PACKAGE_BUILD_DIR}
    mkdir -p ${PACKAGE_BUILD_DIR}
    ${ECLIPSE} -nosplash -consoleLog -application org.eclipse.equinox.p2.director \
      -metadatarepositories ${METADATAREPOSITORIES} -artifactrepositories ${ARTIFACTREPOSITORIES} \
      -installIU ${PACKAGE} \
      -destination ${PACKAGE_BUILD_DIR}/eclipse \
      -profile ${PACKAGE} \
      -flavor tooling \
      -profileproperties org.eclipse.update.install.features=true \
      -bundlepool ${PACKAGE_BUILD_DIR}/eclipse \
      -p2.os ${OSes[$index]} \
      -p2.ws ${WSes[$index]} \
      -p2.arch ${ARCHes[$index]} \
      -roaming \
      -vm ${JRE} \
      -vmargs -Declipse.p2.mirrors=false -Declipse.p2.data.area=${PACKAGE_BUILD_DIR}/eclipse/p2 \
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
cp -a ${DOWNLOAD_BASE_DIR}/${STATUSFILENAME} /home/data/httpd/download.eclipse.org/technology/epp/downloads/testing/status35.stub


###############################################################################

# remove lockfile
rm ${LOCKFILE}

## EOF