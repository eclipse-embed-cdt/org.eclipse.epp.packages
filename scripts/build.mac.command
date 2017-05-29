#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Safety settings (see https://gist.github.com/ilg-ul/383869cbb01f61a51c4d).

if [[ ! -z ${DEBUG} ]]
then
  set ${DEBUG} # Activate the expand mode if DEBUG is -x.
else
  DEBUG=""
fi

set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if variable not set.

# Remove the initial space and instead use '\n'.
IFS=$'\n\t'

# -----------------------------------------------------------------------------

# This script runs on Mac OS X and is intended to
# build the EPP packages.

build_script=$0
if [[ "${build_script}" != /* ]]
then
  # Make relative path absolute.
  build_script=$(pwd)/$0
fi

scripts_folder=$(dirname ${build_script})
project_root_folder=$(dirname ${scripts_folder})

# echo ${project_root_folder}

cd ${project_root_folder}

# Add maven path to environment.
export PATH=${HOME}/opt/apache-maven-3.3.9/bin:${PATH}

bash scripts/build.sh

