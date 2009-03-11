#!/bin/sh
#set -x
umask 0022
ulimit -n 2048


HTTP_BASE="http://download.eclipse.org"
FILESYSTEM_BASE="file:///home/data/httpd/download.eclipse.org"

# change this if building on build.eclipse.org to FILESYSTEM_BASE
BASE_URL=${FILESYSTEM_BASE}

# Ganymede Repositories
REPO_ECLIPSE34="${BASE_URL}/eclipse/updates/3.4/"
REPO_GANYMEDE="${BASE_URL}/releases/ganymede/"
REPO_EPP_GANYMEDE="${BASE_URL}/technology/epp/packages/ganymede/"
REPO_EPP_UDC="${BASE_URL}/technology/epp/updates/1.0/"

# Galileo Repositories
REPO_ECLIPSE35="${BASE_URL}/eclipse/updates/3.5milestones"
#REPO_GALILEO="${BASE_URL}/releases/galileo/"
#REPO_GALILEO="http://build.eclipse.org/galileo/staging/"
REPO_GALILEO="file:///opt/users/hudsonbuild/downloads/galileo/"
REPO_EPP_GALILEO="${BASE_URL}/technology/epp/packages/galileo/milestones"

# Repositories (Galileo vs. Ganymede)
METADATAREPOSITORIES="${REPO_ECLIPSE35},${REPO_GALILEO},${REPO_EPP_UDC},${REPO_EPP_GALILEO}"
ARTIFACTREPOSITORIES="${REPO_ECLIPSE35},${REPO_GALILEO},${REPO_EPP_UDC}"
# METADATAREPOSITORIES="${REPO_ECLIPSE34},${REPO_GANYMEDE},${REPO_EPP_GANYMEDE}"
# ARTIFACTREPOSITORIES="${REPO_ECLIPSE34},${REPO_GANYMEDE}"

# Eclipse installation, Java, etc.
ECLIPSE="/shared/technology/epp/epp_build/35/eclipse/eclipse"
JRE="/opt/ibm/java2-ppc-50/bin/java"

PACKAGES="epp.package.cpp epp.package.java epp.package.jee epp.package.modeling epp.package.rcp epp.package.reporting epp.package.javame"
OSes=( win32 linux linux macosx )
WSes=( win32 gtk gtk carbon )
ARCHes=( x86 x86 x86_64 ppc )
FORMAT=( zip tar.gz tar.gz tar.gz )

BASE_DIR=/shared/technology/epp/epp_build/35
DOWNLOAD_BASE_DIR=${BASE_DIR}/download
BUILD_DIR=${BASE_DIR}/build

###############################################################################

# variables
START_TIME=`date -u +%Y%m%d-%H%M`
LOCKFILE="/tmp/epp.build35.lock"

###############################################################################

# only one build process allowed
if [ -e ${LOCKFILE} ]; then
    echo "${START_TIME} EPP build - lockfile ${LOCKFILE} exists" >/dev/stderr
    exit 1
fi
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
touch ${LOCKFILE}

# create download directory
DOWNLOAD_DIR=${DOWNLOAD_BASE_DIR}/${START_TIME}
mkdir ${DOWNLOAD_DIR}

# log to file
exec 1>${DOWNLOAD_DIR}/eppbuild.log 2>&1

# build the packages
for PACKAGE in ${PACKAGES};
do
  echo "Building package for IU ${PACKAGE}"
  mkdir -p ${BUILD_DIR}/${PACKAGE}
  for index in 0 1 2 3;
  do
    echo -n "...EPP building ${PACKAGE} ${OSes[$index]} ${WSes[$index]} ${ARCHes[$index]} "
    EXTENSION="${OSes[$index]}.${WSes[$index]}.${ARCHes[$index]}"
    PACKAGE_BUILD_DIR="${BUILD_DIR}/${PACKAGE}/${EXTENSION}"
    rm -rf ${PACKAGE_BUILD_DIR}
    mkdir ${PACKAGE_BUILD_DIR}
    ${ECLIPSE} -nosplash -consoleLog -application org.eclipse.equinox.p2.director.app.application \
      -metadataRepositories ${METADATAREPOSITORIES} -artifactRepositories ${ARTIFACTREPOSITORIES} \
      -installIU ${PACKAGE} \
      -destination ${PACKAGE_BUILD_DIR}/eclipse \
      -profile ${PACKAGE} \
      -profileProperties org.eclipse.update.install.features=true \
      -bundlepool ${PACKAGE_BUILD_DIR}/eclipse \
      -p2.os ${OSes[$index]} \
      -p2.ws ${WSes[$index]} \
      -p2.arch ${ARCHes[$index]} \
      -roaming \
      -vm ${JRE} \
      -vmargs -Declipse.p2.mirrors=false -Declipse.p2.data.area=${PACKAGE_BUILD_DIR}/eclipse/p2 \
         2>&1 >${DOWNLOAD_DIR}/${PACKAGE}_${EXTENSION}.log
    if [ $? = "0" ]; then
      echo "...successfully finished ${OSes[$index]} ${WSes[$index]} ${ARCHes[$index]} package build"
      cd ${PACKAGE_BUILD_DIR}
      if [ ${OSes[$index]} = "win32" ]; then
        zip -r -o -q ${DOWNLOAD_DIR}/${START_TIME}_eclipse-${PACKAGE}-${EXTENSION}.zip eclipse
      else
        tar zc --owner=100 --group=100 -f ${DOWNLOAD_DIR}/${START_TIME}_eclipse-${PACKAGE}-${EXTENSION}.tar.gz eclipse
      fi
      cd ..
      rm -r ${PACKAGE_BUILD_DIR}
    else
      echo "...failed while building package ${OSes[$index]} ${WSes[$index]} ${ARCHes[$index]}"
    fi
  done
done

###############################################################################

# remove lockfile
rm ${LOCKFILE}

## EOF