#!/bin/sh

# variables
START_TIME=`date -u +%Y%m%d%H%M%S`
WORKING_DIR=$HOME/epp.build
ECLIPSE_DIR=$WORKING_DIR/eclipse
VM=$HOME/ibm-java2-ppc-50/jre/bin/java
PACKAGE=org.eclipse.epp/releng/org.eclipse.epp.config

###############################################################################

# remove old workspaces
cd  $WORKING_DIR
rm -r workspace*

# create target directory
TARGET_DIR=$WORKING_DIR/$START_TIME
mkdir $TARGET_DIR

# check-out configuration
cd $WORKING_DIR
cvs -d :pserver:anonymous@dev.eclipse.org:/cvsroot/technology checkout -P $PACKAGE

# build
cd $ECLIPSE_DIR
WORKSPACE=$WORKING_DIR/workspaceCDT
mkdir $WORKSPACE
./eclipse -data $WORKSPACE \
    -consoleLog \
    -vm $VM $WORKING_DIR/EclipseCDT_340.xml \
    2>&1 1>$TARGET_DIR/cdt.log
cd $WORKSPACE
for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done

cd $ECLIPSE_DIR
WORKSPACE=$WORKING_DIR/workspaceJava
mkdir $WORKSPACE
./eclipse -data $WORKSPACE \
    -consoleLog \
    -vm $VM $WORKING_DIR/EclipseJava_340.xml \
    2>&1 1>$TARGET_DIR/java.log
cd $WORKSPACE
for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done

cd $ECLIPSE_DIR
WORKSPACE=$WORKING_DIR/workspaceRCP
mkdir $WORKSPACE
./eclipse -data $WORKSPACE \
    -consoleLog \
    -vm $VM $WORKING_DIR/EclipseRCP_340.xml \
    2>&1 1>$TARGET_DIR/rcp.log
cd $WORKSPACE
for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done


