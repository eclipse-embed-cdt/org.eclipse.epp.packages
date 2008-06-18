

function incubationLinkFix {
  if [ -z $3 ]
  then
    echo "No (not enough) parameters passed to function incubationLinkFix()."
    return 0
  fi
  FILEPATH=$1
  PACKAGENAME=$2
  VERSION=$3

  echo "Fixing ${FILEPATH} for package ${PACKAGENAME} (${VERSION})"
  
  sed 's/${VERSION}_${PACKAGENAME}/${VERSION}_${PACKAGENAME}-incubation/g' \
      ${FILEPATH} >${FILEPATH}.temp
  mv ${FILEPATH}.temp ${FILEPATH}
  
}
