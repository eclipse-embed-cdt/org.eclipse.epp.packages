#!/bin/bash

set -u # run with unset flag error so that missing parameters cause build failure
set -e # error out on any failed commands
set -x # echo all commands used for debugging purposes

# The commented out parameters come from Jenkinsfile
# RELEASE_NAME=
# RELEASE_MILESTONE=
# RELEASE_DIR=
# BUILD_NUMBER=
PACKAGES="committers cpp dsl java javascript jee modeling parallel php rcp rust scout testing"
PLATFORMS="linux.gtk.x86_64.tar.gz macosx.cocoa.x86_64.dmg win32.win32.x86_64.zip"
ARCHIVE_URL="https://ci.eclipse.org/packaging/job/simrel.epp-tycho-build/${BUILD_NUMBER}/artifact/org.eclipse.epp.packages/archive/*zip*/archive.zip"
EPP_DOWNLOADS=/home/data/httpd/download.eclipse.org/technology/epp
DOWNLOADS=${EPP_DOWNLOADS}/downloads/release/${RELEASE_NAME}/
REPO=${EPP_DOWNLOADS}/packages/${RELEASE_NAME}/

mkdir downloads
mkdir p2
pushd downloads

# ----------------------------------------------------------------------------------------------
# pull the XML configuration files that describe each package; these files are used by the
# script that generates the package websites at eclipse.org/downloads

cp ../releng/org.eclipse.epp.config/tools/functions.sh ../releng/org.eclipse.epp.config/packages_map.txt .

# ----------------------------------------------------------------------------------------------
# download the packages from the Jenkins build server
# rename the packages, i.e. strip the build date, update the package file name, and add the
# incubation name if required.

echo "wget running quietly - have a look at the workspace to track progress"
wget --quiet $ARCHIVE_URL
unzip archive.zip
pushd archive
for PACKAGE in $PACKAGES; do
  for PLATFORM in $PLATFORMS; do
    NAME=$(echo *_eclipse-${PACKAGE}-${RELEASE_NAME}-${RELEASE_MILESTONE}-${PLATFORM})
    NEWNAME=`echo ${NAME} | \
             cut -d "_" -f 2- | \
             sed 's/linux\.gtk\.x86\_64/linux-gtk-x86\_64/' | \
             sed 's/win32\.win32\.x86\_64\./win32\-x86\_64\./' | \
             sed 's/macosx\.cocoa\.x86\_64/macosx\-cocoa-x86\_64/' | \
             sed 's/macosx-cocoa-x86_64.dmg/macosx-cocoa-x86_64.dmg-tonotarize/'`
    # Move and rename file
    mv ${NAME} ../${NEWNAME}
  done;
done
mv repository ../../p2
popd
# archive will be empty now, unless we are only publishing some packages
rm -rvf archive.zip archive

# check-out configuration
. functions.sh
pullAllConfigFiles packages_map.txt .

# Rename incubation packages
INCUBATION=`ls *.xml | grep -v feature | xargs grep "product name=\"eclipse.*incubation" | sed 's/^.*\(eclipse-.*\)-incubation.*/\1/'`
echo Found ${INCUBATION} in incubation
for II in ${INCUBATION}; do
  echo ".. Renaming ${II} incubating packages"
  for INCUBATIONPACKAGE in `ls *${II}* | grep -v "incubation"`; do
    INCUBATIONPACKAGE_FILE=`echo ${INCUBATIONPACKAGE} | sed 's:\(.*\)\('${II}'\)\(.*\):\1\2-incubation\3:'`
    echo -n ".... Moving ${INCUBATIONPACKAGE} to ${INCUBATIONPACKAGE_FILE}"
    mv -i ${INCUBATIONPACKAGE} ${INCUBATIONPACKAGE_FILE}
    echo " done."
  done
done

# ----------------------------------------------------------------------------------------------
# compute the checksum files for each package

for II in eclipse*.zip eclipse*.tar.gz eclipse*.dmg-tonotarize; do
  echo .. $II
  md5sum $II >$II.md5
  sha1sum $II >$II.sha1
  sha512sum -b $II >$II.sha512
done

popd # leave downloads


# ----------------------------------------------------------------------------------------------
# Prepare compositeArtifacts.jar/compositeContent.jar
pushd p2
if [ "$RELEASE_MILESTONE" != "M1" ]; then
    # For non M1 build we need to add to the existing p2 content,
    # for M1 we start from scratch
    cp -rp ${REPO}/* .
fi
mv repository ${RELEASE_DIR}
cat > addmilestone.xml <<EOM
<?xml version="1.0" encoding="UTF-8"?>
<project name="p2 composite repository">
  <target name="default">
    <p2.composite.repository>
      <repository compressed="true" location="." name="${RELEASE_NAME}" />
      <add>
        <repository location="${RELEASE_DIR}" />
      </add>
    </p2.composite.repository>
  </target>
</project>
EOM

# Use the eclipse we have to build p2 with
tar xf ../downloads/eclipse-committers-*-linux-gtk-x86_64.tar.gz
./eclipse/eclipse \
    -application org.eclipse.ant.core.antRunner \
    -buildfile addmilestone.xml \
    default
rm -rf eclipse

cat > p2.index <<EOM
version=1
metadata.repository.factory.order=compositeContent.xml,\!
artifact.repository.factory.order=compositeArtifacts.xml,\!
EOM

popd # leave p2

# ----------------------------------------------------------------------------------------------
# Make the new https://download.eclipse.org/technology/epp/downloads/release/release.xml file
# The release.xml file is used by Eclipse Webmaster to populate eclipse.org/downloads
cat > release.xml <<EOM
<packages>
<past>2019-03/R</past>
<past>2019-06/R</past>
<past>2019-09/R</past>
<past>2019-12/R</past>
<past>2020-03/R</past>
<past>2020-06/R</past>
<present>2020-09/R</present>
</packages>
EOM

# Add this line above on M1
# <future>2020-12/M1</future>


# ----------------------------------------------------------------------------------------------
# Copy everything to download.eclipse.org

ECHO=echo
if [ "$DRY_RUN" == "false" ]; then
    ECHO=""
else
    echo Dry run of build:
fi

${ECHO} mkdir -p ${DOWNLOADS}/${RELEASE_DIR}
${ECHO} mkdir -p ${REPO}
${ECHO} cp -r downloads/* ${DOWNLOADS}/${RELEASE_DIR}
${ECHO} cp -r p2/p2.index ${REPO}
${ECHO} cp -r p2/${RELEASE_DIR} ${REPO}
${ECHO} cp p2/compositeArtifacts.jar ${REPO}/compositeArtifacts${RELEASE_DIR}.jar
${ECHO} cp p2/compositeContent.jar ${REPO}/compositeContent${RELEASE_DIR}.jar
${ECHO} cp release.xml ${EPP_DOWNLOADS}/downloads/release/release.xml
