

function cvsCheckout {
  if [ -z $4 ]
  then
    echo "No parameters passed to function cvsCheckout()."
    return 0
  fi
  REPSTRING=$1
  FILEPATH=$2
  VERSION=$3
  FILENAME=$4

  echo "Checking out ${FILEPATH} to ${FILENAME}"
  cvs -q -d ${REPSTRING} checkout -r ${VERSION} -p ${FILEPATH} >${FILENAME}
}


function gitCheckout {
  if [ -z $4 ]
  then
    echo "No parameters passed to function gitCheckout()."
    return 0
  fi
  GITURL=$1
  GITPATH=$2
  GITBRANCH=$3
  FILENAME=$4

  echo "Checking out ${GITPATH} to ${FILENAME}"
  git archive --format=tar \
    --remote=${GITURL} ${GITBRANCH} ${GITPATH} | tar xf - --to-stdout >${FILENAME}
}

function pullAllConfigFiles {
  if [ -z $2 ]
  then
    echo "No parameters passed to function pullAllConfigFiles()."
    return 0
  fi
  
  if [ ! -d $2 ]
  then
    echo "Directory $2 does not exist."
    return 0
  fi
  
  # read relevant (non comment, non empty) lines from package definition map file
  ALL_PACKAGES=`grep -v '^#' $1 | grep -v '^\s*$'`


  # name, [CVS,GIT], repository string, path to file, version [HEAD], EPP local filename
  # cpp,CVS,:pserver:anonymous@dev.eclipse.org:/cvsroot/technology,org.eclipse.epp/packages/org.eclipse.epp.package.cpp.feature/eclipse_cpp_juno.xml,HEAD,cpp.xml
  # cpp,CVS,:pserver:anonymous@dev.eclipse.org:/cvsroot/technology,org.eclipse.epp/packages/org.eclipse.epp.package.cpp.feature/feature.xml,HEAD,cpp.feature.xml
  ALL_PACKAGE_NAMES=""
  for II in ${ALL_PACKAGES};
  do
    PACKAGE_NAME=`echo ${II} | cut -d "," -f 1`
    REPTYPE=`echo ${II}      | cut -d "," -f 2`
    REPSTRING=`echo ${II}    | cut -d "," -f 3`
    FILEPATH=`echo ${II}     | cut -d "," -f 4`
    VERSION=`echo ${II}      | cut -d "," -f 5`
    FILENAME=`echo ${II}     | cut -d "," -f 6`

    if [ "${REPTYPE}" = "CVS" ]; then
      cvsCheckout ${REPSTRING} ${FILEPATH} ${VERSION} ${2}/${FILENAME}
    elif [ "${REPTYPE}" = "GIT" ]; then
      gitCheckout ${REPSTRING} ${FILEPATH} ${VERSION} ${2}/${FILENAME}
    fi
    ALL_PACKAGE_NAMES="${ALL_PACKAGE_NAMES} ${PACKAGE_NAME}"
  done
}

