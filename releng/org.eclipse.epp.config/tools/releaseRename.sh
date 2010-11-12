#!/bin/bash

RELEASEDIRECTORY=/home/data/httpd/download.eclipse.org/technology/epp/downloads/release
TESTDIRECTORY=/shared/technology/epp/epp_build/indigo/download
RELEASETRAIN=indigo
CURRENTDIR=${PWD}


#############################################################################

if [ -z ${2} ]
then
  echo "ERROR: At least two parameters (test build id and target version) are necessary. Stopping."
  echo "       Example: \"sh releaseRename.sh 20080117-0620 M5\""
  exit 1
fi
TESTBUILDID=${1}
TARGETVERSION=${2}

echo "Running the releaseRename script with build ${TESTBUILDID} and version ${TARGETVERSION}"

SOURCEDIR=${TESTDIRECTORY}/${TESTBUILDID}
echo -n "Checking source directory: "
if [ ! -d ${SOURCEDIR} ]
then
  echo "failed"
  echo "ERROR: ${SOURCEDIR} does not exist. Stopping."
  exit 1
fi
echo "okay"

TARGETDIR=${RELEASEDIRECTORY}/${RELEASETRAIN}/${TARGETVERSION}
echo -n "Checking target directory: "
if [ -d ${TARGETDIR} ]
then
  echo "failed"
  echo "ERROR: ${TARGETDIR} does already exist. Stopping."
  exit 1
fi
echo "okay"

echo 1st: Create the release directory ${TARGETDIR}
mkdir ${TARGETDIR}

echo 2nd: Copy logfiles
cp -a ${SOURCEDIR}/*.log ${TARGETDIR}

echo 3rd: Copy config files
cp -a ${SOURCEDIR}/*.xml ${TARGETDIR}

echo 4th: Copy and rename packages
cd ${SOURCEDIR}
for II in *eclipse*; do
  if [[ ! ( "${II}" =~ ".sha1" || "${II}" =~ ".md5" || "${II}" =~ "^eclipse_" ) ]]
  then
    NEWNAME=`echo ${II} | \
             cut -d "_" -f 2- | \
             sed 's/linux\.gtk\.x86\_64/linux-gtk-x86\_64/' | \
             sed 's/linux\.gtk\.x86\./linux\-gtk\./' | \
             sed 's/win32\.win32\.x86\./win32\./' | \
             sed 's/win32\.win32\.x86\_64\./win32\-x86\_64\./' | \
             sed 's/macosx\.cocoa\.x86\_64/macosx\-cocoa-x86\_64/' | \
             sed 's/macosx\.cocoa\.x86/macosx\-cocoa/' | \
             sed 's/macosx\.carbon\.ppc/macosx\-carbon/'`
    echo Copying ${II} to ${TARGETDIR}/${NEWNAME}
    rsync -av --progress ${II} ${TARGETDIR}/${NEWNAME}
    if [ $? = "0" ]; then
      echo Successfully copied
    else
      echo Trying again...
      rsync -av --bwlimit=400 --progress ${II} ${TARGETDIR}/${NEWNAME}
    fi
  fi
done

echo 5th: Re-calculate checksum files
cd ${TARGETDIR}
for II in eclipse*.zip eclipse*.tar.gz; do 
  echo ... $II
  md5sum $II >$II.md5
  sha1sum $II >$II.sha1
done

# <a href="http://download.eclipse.org/technology/epp/downloads/release/ganyMEDE/mXXX/eclipse-reporting-ganymede-M5-win32.zip">
# http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/20080117-0620/eclipse-java-ganymede-M4-win32.zip

#echo 6th: Create new html and stub files
#cd ${SOURCEDIR}
#for II in index.html *.stub; do
#  cat ${II} | \
#  sed "s/build.eclipse.org/download.eclipse.org/g" | \
#  sed "s/technology\/epp\/epp\_build\/34\/download/technology\/epp\/downloads\/release\/${RELEASETRAIN}\/${TARGETVERSION}/g" | \
#  sed "s/\(http:\/\/\)download\.eclipse\.org\(\/technology.*\.zip\"\)/\1www.eclipse.org\/downloads\/download.php\?file\=\2/" | \
#  sed "s/\(http:\/\/\)download\.eclipse\.org\(\/technology.*\.tar\.gz\"\)/\1www.eclipse.org\/downloads\/download.php\?file\=\2/" | \
#  sed "s/${TESTBUILDID}\_//" | \
#  sed "s/${TESTBUILDID}\///" | \
#  sed "s/linux\.gtk\.x86\_64/linux-gtk-x86\_64/" | \
#  sed "s/linux\.gtk\.x86\./linux\-gtk\./" | \
#  sed "s/\.win32\.x86//" | \
#  sed "s/macosx\.carbon\.ppc/macosx\-carbon/" \
#  >${TARGETDIR}/${II}
#done

echo Moving to release done.
exit 0

