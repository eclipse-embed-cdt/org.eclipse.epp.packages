#!/bin/bash

if [[ "$#" -ne 3 ]]; then
    echo "Illegal number of parameters"
    exit 1
fi

TARGET_DIR="${1}"
SOURCE_DIR="${2}"
BASENAME="${3}"

if [[ ! -d "${TARGET_DIR}" ]]; then
    echo "Creating target directory ${TARGET_DIR}"
    mkdir -p ${TARGET_DIR}
fi
echo "Starting archive creation in target directory ${TARGET_DIR}"

if [[ ! -d "${SOURCE_DIR}" ]]; then
    echo "Source directory ${SOURCE_DIR} does not exist"
    exit 1
fi
echo "Using packages from source directory ${SOURCE_DIR}"

# definition of OS, WS, ARCH, FORMAT combinations - DO NOT FORGET to adjust the for loop
OSes=(   win32  win32   linux   linux   macosx  macosx  )
WSes=(   win32  win32   gtk     gtk     cocoa   cocoa   )
ARCHes=( x86    x86_64  x86     x86_64  x86     x86_64  )
FORMAT=( zip    zip     tar.gz  tar.gz  tar.gz  tar.gz  )

for index in 0 1 2 3 4 5;
do
    EXTENSION="${OSes[$index]}.${WSes[$index]}.${ARCHes[$index]}"
    echo -n "Building archive ${BASENAME} for ${EXTENSION} : "
    PACKAGE_DIR="${SOURCE_DIR}/${OSes[$index]}/${WSes[$index]}/${ARCHes[$index]}"
    cd "${PACKAGE_DIR}"
    if [[ ${OSes[$index]} = "win32" ]]; then
        PACKAGEFILE="${BASENAME}-${EXTENSION}.zip"
        zip -r -o -q ${TARGET_DIR}/${PACKAGEFILE} eclipse || exit 1
    else
        PACKAGEFILE="${BASENAME}-${EXTENSION}.tar.gz"
        tar zc --owner=100 --group=100 -f ${TARGET_DIR}/${PACKAGEFILE} eclipse || exit 1
    fi
    echo "${PACKAGEFILE}"
done

echo "Package archive creation in target directory ${TARGET_DIR} finished successfully"
exit 0

