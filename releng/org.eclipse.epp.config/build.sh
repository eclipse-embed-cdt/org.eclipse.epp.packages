#!/bin/sh

DIRECTORY=$PWD

cd $DIRECTORY/Eclipse_for_RCP_Plugin_Developers
sh ./build.sh
cd $DIRECTORY/Eclipse_for_RCP_Plugin_Developers
sh ./build.sh

cd $DIRECTORY/Eclipse_IDE_for_C_C++_Developers
sh ./build.sh
cd $DIRECTORY/Eclipse_IDE_for_C_C++_Developers
sh ./build.sh

cd $DIRECTORY/Eclipse_IDE_for_Java_Developers
sh ./build.sh
cd $DIRECTORY/Eclipse_IDE_for_Java_Developers
sh ./build.sh

cd $DIRECTORY/Eclipse_IDE_for_JEE_Developers
sh ./build.sh
cd $DIRECTORY/Eclipse_IDE_for_JEE_Developers
sh ./build.sh

mkdir $DIRECTORY/result
find $DIRECTORY -name "epp-*" -maxdepth 3 -type f -exec mv {} $DIRECTORY/result/ \;
cd $DIRECTORY/result

mv epp-cpp-europa-linux.gtk.x86.tar.gz       epp-cpp-europa-linux-gtk.tar.gz
mv epp-cpp-europa-macosx.carbon.x86.tar.gz   epp-cpp-europa-macosx-carbon.tar.gz
mv epp-cpp-europa-win32.win32.x86.zip        epp-cpp-europa-win32.zip

mv epp-rcp-europa-linux.gtk.x86.tar.gz       epp-rcp-europa-linux-gtk.tar.gz
mv epp-rcp-europa-macosx.carbon.x86.tar.gz   epp-rcp-europa-macosx-carbon.tar.gz
mv epp-rcp-europa-win32.win32.x86.zip        epp-rcp-europa-win32..zip

mv epp-java-europa-linux.gtk.x86.tar.gz      epp-java-europa-linux-gtk.tar.gz
mv epp-java-europa-macosx.carbon.x86.tar.gz  epp-java-europa-macosx-carbon.tar.gz
mv epp-java-europa-win32.win32.x86.zip       epp-java-europa-win32.zip

mv epp-jee-europa-linux.gtk.x86.tar.gz       epp-jee-europa-linux-gtk.tar.gz
mv epp-jee-europa-macosx.carbon.x86.tar.gz   epp-jee-europa-macosx-carbon.tar.gz
mv epp-jee-europa-win32.win32.x86.zip        epp-jee-europa-win32..zip

for FILE in *[zp]; do md5sum -b $FILE >$FILE.md5; done
for FILE in *[zp]; do sha1sum -b $FILE >$FILE.sha1; done



#################################################
# building with Eclipse 3.2.1 as base platform  #
#################################################
cd /home/mknauer/packaging/eclipse

# RCP
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33RC1.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33RC2.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33RC3.xml

# CDT
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseCDT_33RC1.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseCDT_33RC2.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseCDT_33RC3.xml

# Java
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJava_33RC1.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJava_33RC2.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJava_33RC3.xml

# Java EE
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJavaEE_33RC1.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -XX:MaxPermSize=128m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJavaEE_33RC2.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -Xms64m -Xmx512m -XX:MaxPermSize=128m -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJavaEE_33RC3.xml


#################################################
# building with Eclipse 3.3 M6 as base platform #
#################################################
#cd /home/mknauer/packaging/eclipse.3.3M6
cd /home/mknauer/packaging/eclipse.3.3RC1

# RCP
#/opt/java/jdk1.5.0_07.modified/bin/java -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=y -jar plugins/org.eclipse.equinox.launcher_1.0.0.v20070319.jar -consolelog -debug /home/mknauer/packaging/debug.options -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33RC1.xml 
#/opt/java/jdk1.5.0_07.modified/bin/java -jar plugins/org.eclipse.equinox.launcher_1.0.0.v20070523.jar -consolelog -debug /home/mknauer/packaging/debug.options -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33RC1.xml 

# CDT
#/opt/java/jdk1.5.0_07.modified/bin/java -jar plugins/org.eclipse.equinox.launcher_1.0.0.v20070319.jar -consolelog -debug /home/mknauer/packaging/debug.options -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseCDT_33M7.xml

# Java
#/opt/java/jdk1.5.0_07.modified/bin/java -jar plugins/org.eclipse.equinox.launcher_1.0.0.v20070319.jar -consolelog -debug /home/mknauer/packaging/debug.options -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJava_33M7.xml

# Java EE
#/opt/java/jdk1.5.0_07.modified/bin/java -jar plugins/org.eclipse.equinox.launcher_1.0.0.v20070319.jar -consolelog -debug /home/mknauer/packaging/debug.options -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJavaEE_33M7.xml
