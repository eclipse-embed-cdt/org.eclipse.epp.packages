#!/bin/sh

# variables
WORKING_DIR=$HOME/epp.build
ECLIPSE_DIR=$WORKING_DIR/eclipse
VM=$HOME/ibm-java2-ppc-50/jre/bin/java
PACKAGE=org.eclipse.epp/releng/org.eclipse.epp.config

###############################################################################

# remove old workspaces
cd  $WORKING_DIR
rm -r workspace*

# check-out configuration
cd $WORKING_DIR
cvs -d :pserver:anonymous@dev.eclipse.org:/cvsroot/technology co $PACKAGE

# build
cd $ECLIPSE_DIR
./eclipse -data $WORKING_DIR/workspaceJava  \
    -consoleLog \
    -vm $VM $WORKING_DIR/EclipseCDT_340.xml \
    2>&1 1>$WORKING_DIR/workspaceJava/log.txt