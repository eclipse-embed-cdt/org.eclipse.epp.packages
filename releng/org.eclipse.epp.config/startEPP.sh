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
PACKAGES="cpp java jee rcp"
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
	PACKAGECONFIGURATION="$WORKING_DIR/$CVSPATH/eclipse_"$PACKAGENAME"_340.xml"
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
cat >>$TARGET_DIR/index.html <<Endofmessage
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="http://www.eclipse.org/eclipse.org-common/themes/Phoenix/css/visual.css" media="screen" />
<title>EPP Build Status $START_TIME</title>
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr style="background-image: url(http://dash.eclipse.org/dash/commits/web-app/header_bg.gif);">
<td><a href="http://www.eclipse.org/"><img src="http://dash.eclipse.org/dash/commits/web-app/header_logo.gif" width="163" height="68" border="0" alt="Eclipse Logo" class="logo" /></a></td>
<td align="right" style="color: white; font-family: verdana,arial,helvetica; font-size: 1.25em; font-style: italic;"><b>EPP Build Status&nbsp;</b></font> </td>
</tr>
</table>
<h1>EPP Build Status $START_TIME</h1>
<table border="1">
<tr>
  <th><a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/eppbuild.log">Package</a></th>
  <th>Windows</th>
  <th>Linux 32 GTK</th>
  <th>Linux 64 GTK</th>
  <th>Mac OSX</th>
</tr>
Endofmessage

for NAME in $PACKAGES;
do
   if [[ "$BUILDSUCCESS" == "*$PACKAGENAME*" ]]
   then
cat >>$TARGET_DIR/index.html <<Endofmessage
<tr>
 <td><a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$NAME.log">$NAME</a></td>
 <td style=\"background-color: rgb(204, 255, 204);\">
   <a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-win32.win32.x86.zip">package</a> 
   [<a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-win32.win32.x86.zip.md5">md5</a>] 
   [<a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-win32.win32.x86.zip.sha1">sha1</a>]
 </td>
 <td style=\"background-color: rgb(204, 255, 204);\">
   <a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-linux.gtk.x86.tar.gz">package</a> 
   [<a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-linux.gtk.x86.tar.gz.md5">md5</a>] 
   [<a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-linux.gtk.x86.tar.gz.sha1">sha1</a>]
 </td>
 <td style=\"background-color: rgb(204, 255, 204);\">
   <a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-linux.gtk.x86_64.tar.gz">package</a> 
   [<a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-linux.gtk.x86_64.tar.gz.md5">md5</a>] 
   [<a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-linux.gtk.x86_64.tar.gz.sha1">sha1</a>]
 </td>
 <td style=\"background-color: rgb(204, 255, 204);\">
   <a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-macosx.carbon.ppc.tar.gz">package</a> 
   [<a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-macosx.carbon.ppc.tar.gz.md5">md5</a>] 
   [<a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$START_TIME_eclipse-$NAME-ganymede-M4-macosx.carbon.ppc.tar.gz.sha1">sha1</a>]
 </td>
</tr>
Endofmessage
   else
cat >>$TARGET_DIR/index.html <<Endofmessage
<tr>
 <td><a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/$NAME.log">$NAME</a></td>
 <td style=\"background-color: rgb(255, 204, 204);\">Fail</td>
 <td style=\"background-color: rgb(255, 204, 204);\">Fail</td>
 <td style=\"background-color: rgb(255, 204, 204);\">Fail</td>
 <td style=\"background-color: rgb(255, 204, 204);\">Fail</td>
</tr>
Endofmessage
   fi
done
cat >>$TARGET_DIR/index.html <<Endofmessage
</table>
</body>
</html>
Endofmessage

# create status file
echo "<tr>"                                       >>$TARGET_DIR/$STATUSFILENAME
echo "<td><a href="http://download.eclipse.org/technology/epp/downloads/testing/$START_TIME/index.html">$START_TIME</a></td>" >>$TARGET_DIR/$STATUSFILENAME
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
      then echo "Success</a></td>"                >>$TARGET_DIR/$STATUSFILENAME
      else echo "Fail</a></td>"                   >>$TARGET_DIR/$STATUSFILENAME
    fi
done
echo "</tr>"                                      >>$TARGET_DIR/$STATUSFILENAME

# move everything to download area
echo "...moving files to download server"
mv $WORKING_DIR/$START_TIME $DOWNLOAD_DIR

# link results somehow in a single file
echo "...recreate $DOWNLOAD_DIR/$STATUSFILENAME"
rm $DOWNLOAD_DIR/$STATUSFILENAME
cd $DOWNLOAD_DIR
for FILE in */$STATUSFILENAME
do
  echo ...adding $FILE
  cat $FILE >>$DOWNLOAD_DIR/$STATUSFILENAME
done

# remove lockfile
rm $LOCKFILE

## EOF