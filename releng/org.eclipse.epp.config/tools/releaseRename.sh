#!/bin/bash

# These steps have to be executed on build.eclipse.org in the final download directory
# of the EPP packages, e.g. for 2020-03 RC1 this is located in 
# /home/data/httpd/download.eclipse.org/technology/epp/downloads/release/2020-03/RC1

# 2020-03
PACKAGES="committers cpp dsl java javascript jee modeling parallel php rcp rust scout testing"
PLATFORMS="linux.gtk.x86_64.tar.gz macosx.cocoa.x86_64.dmg win32.win32.x86_64.zip"
TIMESTAMP="20200227-1435"
RELEASE="2020-03-RC1"
BASEURL="https://ci.eclipse.org/packaging/job/simrel.epp-tycho-build/896/artifact/org.eclipse.epp.packages/archive"
GITBRANCH="master"

GITURL="git://git.eclipse.org/gitroot/epp/org.eclipse.epp.packages.git"

# ----------------------------------------------------------------------------------------------
# pull the XML configuration files that describe each package; these files are used by the
# script that generates the package websites at eclipse.org/downloads

GITURL="/gitroot/epp/org.eclipse.epp.packages.git"
GITPROJECTPATH="packages"

echo "...loading external functions"
git archive --format=tar --remote=${GITURL} ${GITBRANCH} releng/org.eclipse.epp.config/tools/functions.sh | tar xf - --to-stdout >functions.sh
. functions.sh

# check-out configuration
PACKAGES_MAP_FILE=packages_map.txt
echo "...checking out configuration map to ${PACKAGES_MAP_FILE}"
git archive --format=tar --remote=${GITURL} ${GITBRANCH} releng/org.eclipse.epp.config/packages_map.txt | tar xf - --to-stdout >${PACKAGES_MAP_FILE}
pullAllConfigFiles ${PACKAGES_MAP_FILE} .

# ----------------------------------------------------------------------------------------------
# download the packages from the Jenkins build server

for PACKAGE in $PACKAGES; do
  for PLATFORM in $PLATFORMS; do
    NAME="${TIMESTAMP}_eclipse-${PACKAGE}-${RELEASE}-${PLATFORM}"
    echo ${NAME}
    wget ${BASEURL}/${NAME}
  done;
done

# ----------------------------------------------------------------------------------------------
# rename the packages, i.e. strip the build date, update the package file name, and add the
# incubation name if required.

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
    echo .. Renaming ${II} to ${NEWNAME}
    mv -i ${II} ${NEWNAME}
  fi
done

INCUBATION=`ls *.xml | grep -v feature | xargs grep "product name=\"eclipse.*incubation" | sed 's/^.*\(eclipse-.*\)-incubation.*/\1/'`
echo Found ${INCUBATION} in incubation
for II in ${INCUBATION}; do
  echo ".. Renaming ${II} incubating packages"
  for INCUBATIONPACKAGE in `ls *${II}* | grep -v "\.md5$" | grep -v "\.sha1$" | grep -v "incubation"`; do
    INCUBATIONPACKAGE_FILE=`echo ${INCUBATIONPACKAGE} | sed 's:\(.*\)\('${II}'\)\(.*\):\1\2-incubation\3:'`
    echo -n ".... Moving ${INCUBATIONPACKAGE} to ${INCUBATIONPACKAGE_FILE}"
    mv -i ${INCUBATIONPACKAGE} ${INCUBATIONPACKAGE_FILE}
    echo " done."
  done
done

# ----------------------------------------------------------------------------------------------
# compute the checksum files for each package

for II in eclipse*.zip eclipse*.tar.gz eclipse*.dmg; do 
  echo .. $II
  md5sum $II >$II.md5
  sha1sum $II >$II.sha1
  sha512sum -b $II >$II.sha512
done
