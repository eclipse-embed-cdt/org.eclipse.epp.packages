#!/bin/sh
#set -x
umask 0022
ulimit -n 2048

# change this if building on build.eclipse.org to "server"; "local" otherwise
BUILDLOCATION="server"

# Location of the build input
HTTP_BASE="http://download.eclipse.org"
FILESYSTEM_BASE="file:///home/data/httpd/download.eclipse.org"
if [ ${BUILDLOCATION} = "server" ]
then
  BASE_URL=${FILESYSTEM_BASE}
else
  BASE_URL=${HTTP_BASE}
fi

# Galileo Repositories
REPO_ECLIPSE35="${BASE_URL}/eclipse/updates/3.5milestones"
#REPO_GALILEO="${BASE_URL}/releases/galileo/"
if [ ${BUILDLOCATION} = "server" ]
then
  REPO_GALILEO="file:///opt/users/hudsonbuild/downloads/galileo/"
else
  REPO_GALILEO="http://build.eclipse.org/galileo/staging/"
fi
REPO_EPP_GALILEO="${BASE_URL}/technology/epp/packages/galileo/milestones"

ALL_REPOS="${BASE_URL}/birt/update-site/2.5-interim/,${BASE_URL}/datatools/downloads/drops/N_updates_1.7/site.xml,${BASE_URL}/dsdp/dd/updates/,${BASE_URL}/dsdp/mtj/updates/1.0/stable/,${BASE_URL}/dsdp/nab/updates/,${BASE_URL}/dsdp/tml/updates/0.3M6/,${BASE_URL}/dsdp/tm/updates/3.1interim/site-europa.xml,${BASE_URL}/dsdp/tm/updates/3.1milestones/site-europa.xml,${BASE_URL}/modeling/emft/updates/milestones/,${BASE_URL}/modeling/emf/updates/milestones/,${BASE_URL}/modeling/gmf/updates/milestones/,${BASE_URL}/modeling/m2m/updates/milestones/,${BASE_URL}/modeling/m2t/updates/milestones/,${BASE_URL}/modeling/mdt/updates/milestones/,${BASE_URL}/modeling/tmf/updates/milestones/,${BASE_URL}/rt/rap/1.2/update/,${BASE_URL}/rt/riena/1.1.0.M5/update/,${BASE_URL}/stp/updates/galileo/,${BASE_URL}/technology/actf/0.7/milestones/,${BASE_URL}/technology/dltk/updates-dev/1.0-stable/site.xml,${BASE_URL}/technology/epp/updates/1.0milestones/,${BASE_URL}/technology/jwt/stable-update-site/,${BASE_URL}/technology/jwt/update-site/,${BASE_URL}/technology/mat/0.7/update-site/,${BASE_URL}/technology/subversive/0.7/update-site/,${BASE_URL}/tools/buckminster/updates-ganymede/,${BASE_URL}/tools/cdt/releases/galileo/,${BASE_URL}/tools/cdt/updates/galileo/,${BASE_URL}/tools/gef/updates/milestones/,${BASE_URL}/tools/mylyn/update/galileo/,${BASE_URL}/tools/pdt/updates/milestones/,${BASE_URL}/tptp/updates/galileo/,${BASE_URL}/webtools/milestones/,http://www.eclipse.org/external/rt/ecf/3.0/3.5/updateSite/"

# Repositories (Galileo)
METADATAREPOSITORIES="${REPO_ECLIPSE35},${REPO_GALILEO},${REPO_EPP_GALILEO},${ALL_REPOS}"
ARTIFACTREPOSITORIES="${REPO_ECLIPSE35},${REPO_GALILEO},${ALL_REPOS}"

# Eclipse installation, Java, etc.
if [ ${BUILDLOCATION} = "server" ]
then
  ECLIPSE="/shared/technology/epp/epp_build/35/eclipse/eclipse"
  JRE="/opt/ibm/java2-ppc-50/bin/java"
else
  ECLIPSE="eclipse"
  JRE="java"
fi

PACKAGES="epp.package.javame epp.package.cpp epp.package.java epp.package.jee epp.package.modeling epp.package.rcp epp.package.reporting"
OSes=( win32 linux linux macosx )
WSes=( win32 gtk gtk carbon )
ARCHes=( x86 x86 x86_64 ppc )
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
RELEASE_NAME="-galileo-M6"

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
mkdir ${DOWNLOAD_DIR}
MARKERFILE="${DOWNLOAD_DIR}/${MARKERFILENAME}"
touch ${MARKERFILE}
STATUSFILE="${DOWNLOAD_DIR}/${STATUSFILENAME}"
touch ${STATUSFILE}

# log to file
LOGFILE="${DOWNLOAD_DIR}/build.log"
exec 1>${LOGFILE} 2>&1

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
  echo "<td>"  >>${STATUSFILE}
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

# start statusfile
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