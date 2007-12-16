#!/bin/sh
set -x

# variables
START_TIME=`date -u +%Y%m%d-%H%M`
LOCKFILE=/tmp/epp.build.lock
WORKING_DIR=$HOME/epp.build
ECLIPSE_DIR=$WORKING_DIR/eclipse
VM=$HOME/ibm-java2-ppc-50/jre/bin/java
PACKAGE=org.eclipse.epp/releng/org.eclipse.epp.config

###############################################################################

# only one build process allowed
if [ -e $LOCKFILE ]; then
    echo "EPP build - lockfile $LOCKFILE exists" >/dev/stderr
    exit 1
fi
trap "rm -f $LOCKFILE; exit" INT TERM EXIT
touch $LOCKFILE

# remove old workspaces
echo "...removing old workspaces"
cd  $WORKING_DIR
rm -r workspace*

# create target directory
TARGET_DIR=$WORKING_DIR/$START_TIME
echo "...creating target directory $TARGET_DIR"
mkdir $TARGET_DIR

# check-out configuration
echo "...checking out configuration to $WORKING_DIR"
cd $WORKING_DIR
cvs -d :pserver:anonymous@dev.eclipse.org:/cvsroot/technology checkout -P $PACKAGE

# build
echo "...starting build"

######### CDT
echo "...creating CDT package"
cd $ECLIPSE_DIR
WORKSPACE=$WORKING_DIR/workspaceCDT
mkdir $WORKSPACE
./eclipse -data $WORKSPACE \
    -consoleLog \
    -vm $VM $WORKING_DIR/$PACKAGE/Eclipse_IDE_for_C_C++_Developers/EclipseCDT_340.xml \
    2>&1 1>$TARGET_DIR/cdt.log
if [ $? eq 0 ]; then
	echo "CDT build successful"
	CDTBUILD=true
    cd $WORKSPACE
    for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done
fi

######### Java
echo "...creating Java package"
cd $ECLIPSE_DIR
WORKSPACE=$WORKING_DIR/workspaceJava
mkdir $WORKSPACE
./eclipse -data $WORKSPACE \
    -consoleLog \
    -vm $VM $WORKING_DIR/$PACKAGE/Eclipse_IDE_for_Java_Developers/EclipseJava_340.xml \
    2>&1 1>$TARGET_DIR/java.log
if [ $? eq 0 ]; then
    echo "Java build successful"
    JAVABUILD=true
    cd $WORKSPACE
    for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done
fi

######### JEE
echo "...creating JEE package"
cd $ECLIPSE_DIR
WORKSPACE=$WORKING_DIR/workspaceJEE
mkdir $WORKSPACE
./eclipse -data $WORKSPACE \
    -consoleLog \
    -vm $VM $WORKING_DIR/$PACKAGE/Eclipse_IDE_for_JEE_Developers/EclipseJavaEE_340.xml \
    2>&1 1>$TARGET_DIR/jee.log
if [ $? eq 0 ]; then
    echo "JEE build successful"
    JEEBUILD=true
    cd $WORKSPACE
    for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done
fi

######### RCP
echo "...creating RCP package"
cd $ECLIPSE_DIR
WORKSPACE=$WORKING_DIR/workspaceRCP
mkdir $WORKSPACE
./eclipse -data $WORKSPACE \
    -consoleLog \
    -vm $VM $WORKING_DIR/$PACKAGE/Eclipse_for_RCP_Plugin_Developers/EclipseRCP_340.xml \
    2>&1 1>$TARGET_DIR/rcp.log
if [ $? eq 0 ]; then
    echo "RCP build successful"
    RCPBUILD=true
    cd $WORKSPACE
    for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done
fi

# create checksum files
echo "...creating checksum files"
cd $TARGET_DIR
for II in *eclipse*; do md5sum $II >>packages.md5; done
for II in *eclipse*; do sha1sum $II >>packages.sha1; done

# create index file


# move everything to download area and link it somehow


# remove lockfile
rm $LOCKFILE

## EOF