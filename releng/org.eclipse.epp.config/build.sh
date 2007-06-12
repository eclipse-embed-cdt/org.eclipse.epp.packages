#!/bin/sh

#################################################
# building with Eclipse 3.2.1 as base platform  #
#################################################
cd /home/mknauer/packaging/eclipse

# RCP
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33M7.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33RC1.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33RC2.xml
/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseRCP_33RC3.xml

# CDT
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseCDT_33M7.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseCDT_33RC1.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseCDT_33RC2.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseCDT_33RC3.xml

# Java
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJava_33M7.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJava_33RC1.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJava_33RC2.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJava_33RC3.xml

# Java EE
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJavaEE_33M7.xml
#/opt/java/jdk1.5.0_07.modified/bin/java -jar startup.jar -consolelog -data /home/mknauer/packaging/target /home/mknauer/packaging/EclipseJavaEE_33RC1.xml
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
