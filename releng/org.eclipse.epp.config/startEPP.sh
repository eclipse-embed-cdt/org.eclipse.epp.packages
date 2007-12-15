#!/bin/sh

# variables
START_TIME=`date -u +%Y%m%d%H%M%S`
WORKING_DIR=$HOME/epp.build
ECLIPSE_DIR=$WORKING_DIR/eclipse
VM=$HOME/ibm-java2-ppc-50/jre/bin/java
PACKAGE=org.eclipse.epp/releng/org.eclipse.epp.config

###############################################################################

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
cd $WORKSPACE
for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done

######### Java
echo "...creating Java package"
cd $ECLIPSE_DIR
WORKSPACE=$WORKING_DIR/workspaceJava
mkdir $WORKSPACE
./eclipse -data $WORKSPACE \
    -consoleLog \
    -vm $VM $WORKING_DIR/$PACKAGE/Eclipse_IDE_for_Java_Developers/EclipseJava_340.xml \
    2>&1 1>$TARGET_DIR/java.log
cd $WORKSPACE
for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done

######### JEE
echo "...creating JEE package"
cd $ECLIPSE_DIR
WORKSPACE=$WORKING_DIR/workspaceJEE
mkdir $WORKSPACE
./eclipse -data $WORKSPACE \
    -consoleLog \
    -vm $VM $WORKING_DIR/$PACKAGE/Eclipse_IDE_for_JEE_Developers/EclipseJavaEE_340.xml \
    2>&1 1>$TARGET_DIR/jee.log
cd $WORKSPACE
for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done

######### RCP
echo "...creating RCP package"
cd $ECLIPSE_DIR
WORKSPACE=$WORKING_DIR/workspaceRCP
mkdir $WORKSPACE
./eclipse -data $WORKSPACE \
    -consoleLog \
    -vm $VM $WORKING_DIR/$PACKAGE/Eclipse_for_RCP_Plugin_Developers/EclipseRCP_340.xml \
    2>&1 1>$TARGET_DIR/rcp.log
cd $WORKSPACE
for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done


# create checksum files
echo "...creating checksum files"
cd $TARGET_DIR
for II in *eclipse*; do md5sum $II >>packages.md5; done
for II in *eclipse*; do sha1sum $II >>packages.sha1; done




