

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
    fi
    ALL_PACKAGE_NAMES="${ALL_PACKAGE_NAMES} ${PACKAGE_NAME}"
  done
}

