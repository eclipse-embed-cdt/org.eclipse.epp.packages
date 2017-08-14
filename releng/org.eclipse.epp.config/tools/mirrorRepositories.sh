#!/bin/bash

# directory that points to an Eclipse SDK or similar
ECLIPSE_DIR="/opt/eclipse/64/eclipse.rcp.kepler.m7"
#ECLIPSE_DIR="/shared/technology/epp/epp_build/photon/eclipse"

ECLIPSE="${ECLIPSE_DIR}/eclipse"

if [ $# -gt "0" ]
then
  echo "Using list of given URLs."
  until [ -z "$1" ]  # Until all parameters used up . . .
    do
      REPO_URL=${1}
      echo "Using URL ${REPO_URL}"
      shift
      ${ECLIPSE} -noSplash -application org.eclipse.equinox.p2.artifact.repository.mirrorApplication -source ${REPO_URL} -destination file:.
      ${ECLIPSE} -noSplash -application org.eclipse.equinox.p2.metadata.repository.mirrorApplication -source ${REPO_URL} -destination file:.
    done
else
  echo "Searching for local repositories."
  for II in `ls -tr */content.jar`;
    do
      REPO_URL=${II%/content.jar}
      echo "Using URL ${REPO_URL}"
      ${ECLIPSE} -noSplash -application org.eclipse.equinox.p2.artifact.repository.mirrorApplication -source ${REPO_URL} -destination file:.
      ${ECLIPSE} -noSplash -application org.eclipse.equinox.p2.metadata.repository.mirrorApplication -source ${REPO_URL} -destination file:.
    done
fi  

