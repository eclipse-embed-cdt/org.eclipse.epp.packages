#!/bin/sh
# Script with build.eclipse.org specific settings
#
export JAVA_HOME=/shared/common/ibm-java2-ppc-50
export ANT_HOME=/shared/common/apache-ant-1.7.1
$ANT_HOME/bin/ant
