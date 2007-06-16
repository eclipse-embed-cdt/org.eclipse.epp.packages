#!/bin/sh

JAVA=/opt/java/current/bin/java
PACKAGING_ROOT=$HOME/packaging
ECLIPSE_PATH=$PACKAGING_ROOT/eclipse
ROOT_FILES=$PACKAGING_ROOT/roots
# not working...
# SCRIPT_DIRECTORY="$(dirname $BASH_SOURCE[-1])"
SCRIPT_DIRECTORY=$PWD
TARGETS="linux.gtk.x86  macosx.carbon.x86  win32.win32.x86"

#################################################
# building with Eclipse 3.2.1 as base platform  #
#################################################

cd $ECLIPSE_PATH
$JAVA -Xms64m -Xmx512m -jar startup.jar -consoleLog   \
      -data $SCRIPT_DIRECTORY/target $SCRIPT_DIRECTORY/EclipseJava_33RC3.xml

# tar.gz error in build script
if [ ! -e $SCRIPT_DIRECTORY/target/temp/linux.gtk.x86/eclipse/eclipse ]
then
  echo "unpacking linux archive"
  cd $SCRIPT_DIRECTORY/target/temp/linux.gtk.x86/
  tar zxf $ROOT_FILES/eclipse-RCP-3.3-linux-gtk.tar.gz
fi
if [ ! -e $SCRIPT_DIRECTORY/target/temp/macosx.carbon.x86/eclipse/eclipse ]
then
  echo "unpacking macosx archive"
  cd $SCRIPT_DIRECTORY/target/temp/macosx.carbon.x86/
  tar zxf $ROOT_FILES/eclipse-RCP-3.3-macosx-carbon.tar.gz
fi

# plugin_customization.ini
echo "Copying plugin_customization.ini"
cp -a $SCRIPT_DIRECTORY/plugin_customization.ini \
      $SCRIPT_DIRECTORY/target/extension_site/eclipse/plugins/org.eclipse.platform_3.3.0.*/

# eclipse.ini
for TARGET in $TARGETS;
do
  echo "Copying eclipse.ini for target $TARGET"
  cp -a $SCRIPT_DIRECTORY/eclipse.ini $SCRIPT_DIRECTORY/target/temp/$TARGET/eclipse/
done



#################################################
# building with Eclipse 3.3 M6 as base platform #
#################################################

# cd /home/mknauer/packaging/eclipse.3.3RC1
#/opt/java/jdk1.5.0_07.modified/bin/java -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=y -jar plugins/org.eclipse.equinox.launcher_1.0.0.v20070319.jar -consolelog -debug /home/mknauer/packaging/debug.options -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33RC1.xml 
#/opt/java/jdk1.5.0_07.modified/bin/java -jar plugins/org.eclipse.equinox.launcher_1.0.0.v20070523.jar -consolelog -debug /home/mknauer/packaging/debug.options -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33RC1.xml 
