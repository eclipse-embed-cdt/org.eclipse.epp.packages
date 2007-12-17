#!/bin/sh
#set -x

# variables
START_TIME=`date -u +%Y%m%d-%H%M`
LOCKFILE=/tmp/epp.build.lock
STATUSFILENAME=status.stub
WORKING_DIR=$HOME/epp.build
ECLIPSE_DIR=$WORKING_DIR/eclipse
DOWNLOAD_DIR=/home/data/httpd/download.eclipse.org/technology/epp/downloads/testing
VM=$HOME/ibm-java2-ppc-50/jre/bin/java
CVSPATH=org.eclipse.epp/releng/org.eclipse.epp.config
PACKAGES="cdt java jee rcp"
BUILDSUCCESS=""

###############################################################################

# only one build process allowed
if [ -e $LOCKFILE ]; then
    echo "EPP build - lockfile $LOCKFILE exists" >/dev/stderr
    exit 1
fi
trap "rm -f $LOCKFILE; exit" INT TERM EXIT
touch $LOCKFILE

# create target directory
TARGET_DIR=$WORKING_DIR/$START_TIME
echo "...creating target directory $TARGET_DIR"
mkdir $TARGET_DIR

# log to file
exec 1>$TARGET_DIR/eppbuild.log 2>&1

# check-out configuration
echo "...checking out configuration to $WORKING_DIR"
cd $WORKING_DIR
cvs -d :pserver:anonymous@dev.eclipse.org:/cvsroot/technology checkout -P $CVSPATH

# build
echo "...starting build"

# create packages
for PACKAGENAME in $PACKAGES;
do
	PACKAGECONFIGURATION="$WORKING_DIR/$CVSPATH/eclipse\_$PACKAGENAME\_340.xml"
    echo "...creating package $PACKAGENAME with config $PACKAGECONFIGURATION"
    cd $ECLIPSE_DIR
    WORKSPACE=$WORKING_DIR/workspace_$PACKAGENAME
    rm -r $WORKSPACE
    mkdir $WORKSPACE
    $ECLIPSE_DIR/eclipse \
            -data $WORKSPACE \
            -consoleLog \
            -vm $VM \
            $PACKAGECONFIGURATION \
            2>&1 1>$TARGET_DIR/$PACKAGENAME.log
    if [ $? = "0" ]; then
        echo "...successful finished $PACKAGENAME build"
	    BUILDSUCCESS="$BUILDSUCCESS $PACKAGENAME"
        cd $WORKSPACE
        for II in eclipse*; do mv $II $TARGET_DIR/$START_TIME\_$II; done
    else
        echo "...failed while building $PACKAGENAME"
    fi
done

# create checksum files
echo "...creating checksum files"
cd $TARGET_DIR
for II in *eclipse*; do 
	md5sum $II >>$II.md5
	sha1sum $II >>$II.sha1;
done

# create index file




# create status file
echo "<td><a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/index.html">$START_TIME</a></td>" >$TARGET_DIR/$STATUSFILENAME
for PACKAGENAME in $PACKAGES;
do
	if [[ "$BUILDSUCCESS" == "*$PACKAGENAME*" ]]
	then
		SUCCESS="true"
	else
	    SUCCESS="false"
    fi
    echo -n "<td style=\"background-color: rgb("  >>$TARGET_DIR/$STATUSFILENAME
    if [[ "$SUCCESS" == "true" ]]; 
      then echo -n "204, 255, 204"                >>$TARGET_DIR/$STATUSFILENAME
      else echo -n "255, 204, 204"                >>$TARGET_DIR/$STATUSFILENAME
    fi
    echo -n ");\"><a href=\"http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$PACKAGENAME.log\">" >>$TARGET_DIR/$STATUSFILENAME
    if [[ "$SUCCESS" == "true" ]]; 
      then echo -n "Success</a></td>"                >>$TARGET_DIR/$STATUSFILENAME
      else echo -n "Fail</a></td>"                >>$TARGET_DIR/$STATUSFILENAME
    fi
done

# move everything to download area
echo "...moving files to download server"
mv $WORKING_DIR/$START_TIME $DOWNLOAD_DIR

# link results somehow in a single file
echo "...recreate status.stub"
rm $DOWNLOAD_DIR/$STATUSFILENAME
find $DOWNLOAD_DIR -name $STATUSFILENAME -exec cat {} >>$DOWNLOAD_DIR/$STATUSFILENAME \;

# remove lockfile
rm $LOCKFILE

## EOF