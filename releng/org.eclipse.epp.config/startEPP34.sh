#!/bin/sh
#set -x
umask 0022

# variables
START_TIME=`date -u +%Y%m%d-%H%M`
WORKING_DIR="/shared/technology/epp/epp_build/34"
ECLIPSE_DIR="${WORKING_DIR}/eclipse"
DOWNLOAD_DIR="/shared/technology/epp/epp_build/34/download"
VM="/opt/ibm/java2-ppc-50/bin/java"
MARKERFILENAME=".epp.nightlybuild"
STATUSFILENAME="status34.stub"
TESTSTATUSFILENAME="status34test.stub"
LOCKFILE="/tmp/epp.build34.lock"
CVSPATH="org.eclipse.epp/releng/org.eclipse.epp.config"
DOWNLOADPACKAGES="cpp java jee rcp"
PLATFORMS="win32.win32.x86.zip linux.gtk.x86.tar.gz linux.gtk.x86_64.tar.gz macosx.carbon.ppc.tar.gz"
BASENAME="ganymede-M6"
BUILDSUCCESS=""

###############################################################################

. ${WORKING_DIR}/${CVSPATH}/tools/functions.sh

# only one build process allowed
if [ -e ${LOCKFILE} ]; then
    echo "${START_TIME} EPP build - lockfile ${LOCKFILE} exists" >/dev/stderr
    exit 1
fi
trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
touch ${LOCKFILE}

# create target directory
TARGET_DIR="${WORKING_DIR}/${START_TIME}"
mkdir ${TARGET_DIR}
touch ${TARGET_DIR}/${MARKERFILENAME}

# log to file
exec 1>${TARGET_DIR}/eppbuild.log 2>&1

# check-out configuration
echo "...checking out configuration to ${WORKING_DIR}"
cvs -q -d :pserver:anonymous@dev.eclipse.org:/cvsroot/technology checkout -P ${CVSPATH}
pullAllConfigFiles ${WORKING_DIR}/${CVSPATH}/packages_map.txt ${TARGET_DIR}

# build
echo "...starting build"

# create packages
for PACKAGENAME in ${ALL_PACKAGE_NAMES};
do
    PACKAGECONFIGURATION="${TARGET_DIR}/eclipse_"${PACKAGENAME}"_340.xml"
    echo "...creating package ${PACKAGENAME} with config ${PACKAGECONFIGURATION}"
    cd ${ECLIPSE_DIR}
    WORKSPACE=${WORKING_DIR}/workspace_${PACKAGENAME}
    rm -rf ${WORKSPACE}
    mkdir ${WORKSPACE}
    ${ECLIPSE_DIR}/eclipse \
            -data ${WORKSPACE} \
            -consoleLog \
            -vm ${VM} \
            ${PACKAGECONFIGURATION} \
            2>&1 1>${TARGET_DIR}/${PACKAGENAME}.log
    if [ $? = "0" ]; then
        echo -n "...successfully finished ${PACKAGENAME} package build"
        BUILDSUCCESS="${BUILDSUCCESS} ${PACKAGENAME}"
        cd ${WORKSPACE}
        for II in eclipse*; do 
            mv ${II} ${TARGET_DIR}/${START_TIME}\_$II
            md5sum ${TARGET_DIR}/${START_TIME}\_$II >${TARGET_DIR}/${START_TIME}\_$II.md5
            sha1sum ${TARGET_DIR}/${START_TIME}\_$II >>${TARGET_DIR}/${START_TIME}\_$II.sha1
        done
        echo " ...removing workspace"
        rm -rf ${WORKSPACE}
    else
        echo "...failed while building package ${PACKAGENAME}"
        echo "...workspace ${workspace} not removed"
    fi
done

# create index file
cat >>$TARGET_DIR/index.html <<Endofmessage
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="http://www.eclipse.org/eclipse.org-common/themes/Phoenix/css/visual.css" media="screen" />
<title>EPP Ganymede Build Status ${START_TIME}</title>
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr style="background-image: url(http://dash.eclipse.org/dash/commits/web-app/header_bg.gif);">
<td><a href="http://www.eclipse.org/"><img src="http://dash.eclipse.org/dash/commits/web-app/header_logo.gif" width="163" height="68" border="0" alt="Eclipse Logo" class="logo" /></a></td>
<td align="right" style="color: white; font-family: verdana,arial,helvetica; font-size: 1.25em; font-style: italic;"><b>EPP Ganymede Build Status&nbsp;</b></font> </td>
</tr>
</table>
<h1>EPP Ganymede Build Status ${START_TIME}</h1>
<table border="1">
<tr>
  <th><a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/eppbuild.log">Package</a></th>
  <th>Windows</th>
  <th>Linux 32 GTK</th>
  <th>Linux 64 GTK</th>
  <th>Mac OSX</th>
</tr>
Endofmessage
for NAME in ${ALL_PACKAGE_NAMES};
do
   if [[ "$BUILDSUCCESS" == *${NAME}* ]]
   then
cat >>$TARGET_DIR/index.html <<Endofmessage
<tr>
 <td><a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/${NAME}.log">${NAME}</a></td>
Endofmessage
   for PLATFORMEXTENSION in ${PLATFORMS};
   do
cat >>$TARGET_DIR/index.html <<Endofmessage
 <td style="background-color: rgb(204, 255, 204);">
   <a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/${START_TIME}_eclipse-${NAME}-${BASENAME}-${PLATFORMEXTENSION}">package</a> 
   [<a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/${START_TIME}_eclipse-${NAME}-${BASENAME}-${PLATFORMEXTENSION}.md5">md5</a>] 
   [<a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/${START_TIME}_eclipse-${NAME}-${BASENAME}-${PLATFORMEXTENSION}.sha1">sha1</a>]
 </td>
Endofmessage
   done
cat >>$TARGET_DIR/index.html <<Endofmessage
</tr>
Endofmessage
   else
cat >>$TARGET_DIR/index.html <<Endofmessage
<tr>
 <td><a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/${NAME}.log">${NAME}</a></td>
 <td align="center" style="background-color: rgb(255, 204, 204);"><b>Fail</b></td>
 <td align="center" style="background-color: rgb(255, 204, 204);"><b>Fail</b></td>
 <td align="center" style="background-color: rgb(255, 204, 204);"><b>Fail</b></td>
 <td align="center" style="background-color: rgb(255, 204, 204);"><b>Fail</b></td>
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
echo "<tr>" >>$TARGET_DIR/$STATUSFILENAME
echo "<td><a href=\"http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/index.html\">${START_TIME}</a></td>" >>$TARGET_DIR/$STATUSFILENAME
for PACKAGENAME in $DOWNLOADPACKAGES;
do
  if [[ "$BUILDSUCCESS" == *$PACKAGENAME* ]]
  then
cat >>$TARGET_DIR/$STATUSFILENAME <<Endofmessage
<td align="center" style="background-color: rgb(204, 255, 204);">
  <a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/index.html">Success</a><br>
  <font size="-2">
    <a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/${START_TIME}_eclipse-${PACKAGENAME}-${BASENAME}-win32.win32.x86.zip">win32</a> |
    <a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/index.html">other</a>
  </font>
</td>
Endofmessage
  else
cat >>$TARGET_DIR/$STATUSFILENAME <<Endofmessage
<td align="center" style="background-color: rgb(255, 204, 204);">
  <a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/$PACKAGENAME.log">Fail</a>
</td>
Endofmessage
  fi
done
echo "</tr>" >>$TARGET_DIR/$STATUSFILENAME

# create 2nd status file
echo "<tr>" >>$TARGET_DIR/$TESTSTATUSFILENAME
echo "<td><a href=\"http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/index.html\">${START_TIME}</a></td>" >>$TARGET_DIR/$TESTSTATUSFILENAME
for PACKAGENAME in ${ALL_PACKAGE_NAMES};
do
  if [[ "$BUILDSUCCESS" == *$PACKAGENAME* ]]
  then
cat >>$TARGET_DIR/$TESTSTATUSFILENAME <<Endofmessage
<td align="center" style="background-color: rgb(204, 255, 204);">
  <a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/index.html">Success</a><br>
  <font size="-2">
    <a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/${START_TIME}_eclipse-${PACKAGENAME}-${BASENAME}-win32.win32.x86.zip">win32</a> |
    <a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/index.html">other</a>
  </font>
</td>
Endofmessage
  else
cat >>$TARGET_DIR/$TESTSTATUSFILENAME <<Endofmessage
<td align="center" style="background-color: rgb(255, 204, 204);">
  <a href="http://build.eclipse.org/technology/epp/epp_build/34/download/${START_TIME}/$PACKAGENAME.log">Fail</a>
</td>
Endofmessage
  fi
done
echo "</tr>" >>$TARGET_DIR/$TESTSTATUSFILENAME


# move everything to download area
echo "...moving files to download directory ${DOWNLOAD_DIR}"
rsync -a --stats ${WORKING_DIR}/${START_TIME} ${DOWNLOAD_DIR}
if [ $? = "0" ]; then
  echo -n "...files successfully moved."
  rm -r ${WORKING_DIR}/${START_TIME}
  echo " Directory ${WORKING_DIR}/${START_TIME} removed."
else
  echo "...failed moving files. Not deleting source files."
fi

# remove 'some' (which?) files from the download server
echo "...remove oldest build from download directory ${DOWNLOAD_DIR}"
cd ${DOWNLOAD_DIR}
TOBEDELETED_TEMP=`find . -name ${MARKERFILENAME} | grep -v "\./${MARKERFILENAME}" | sort | head -n 1`
TOBEDELETED_DIR=`echo ${TOBEDELETED_TEMP} | cut -d "/" -f 2`
echo "...removing ${TOBEDELETED_DIR} from ${DOWNLOAD_DIR}"
rm -r ${TOBEDELETED_DIR}

# link results somehow in a single file
echo "...recreate ${DOWNLOAD_DIR}/${STATUSFILENAME}"
rm ${DOWNLOAD_DIR}/${STATUSFILENAME}
cd ${DOWNLOAD_DIR}
for FILE in `ls -r */${STATUSFILENAME}`
do
  echo "...adding $FILE"
  cat ${FILE} >>${DOWNLOAD_DIR}/${STATUSFILENAME}
done
cp -a ${DOWNLOAD_DIR}/${STATUSFILENAME} /home/data/httpd/download.eclipse.org/technology/epp/downloads/testing/
cp -a ${DOWNLOAD_DIR}/${STATUSFILENAME} /home/data/httpd/download.eclipse.org/technology/epp/downloads/testing/status.stub

# link results somehow in a 2nd single file
echo "...recreate ${DOWNLOAD_DIR}/${TESTSTATUSFILENAME}"
rm ${DOWNLOAD_DIR}/${TESTSTATUSFILENAME}
cd ${DOWNLOAD_DIR}
for FILE in `ls -r */${TESTSTATUSFILENAME}`
do
  echo "...adding $FILE"
  cat ${FILE} >>${DOWNLOAD_DIR}/${TESTSTATUSFILENAME}
done
cp -a ${DOWNLOAD_DIR}/${TESTSTATUSFILENAME} /home/data/httpd/download.eclipse.org/technology/epp/downloads/testing/

# remove lockfile
rm ${LOCKFILE}

## EOF
