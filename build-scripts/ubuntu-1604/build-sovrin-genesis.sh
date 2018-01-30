#!/bin/bash -xe

INPUT_PATH=$1
VERSION=$2
OUTPUT_PATH=${3:-.}

PACKAGE_NAME=sovrin-genesis

# copy the sources to a temporary folder
TMP_DIR=$(mktemp -d)
cp -r ${INPUT_PATH}/. ${TMP_DIR}

# prepare the sources
cd ${TMP_DIR}/build-scripts/ubuntu-1604
./prepare-package.sh ${TMP_DIR} ${VERSION}

fpm --input-type "dir" \
    --output-type "deb" \
    --architecture "amd64" \
    --verbose \
    --maintainer "Sovrin Foundation <repo@sovrin.org>" \
    --name ${PACKAGE_NAME} \
    --version "${VERSION}" \
    --package ${OUTPUT_PATH} \
    ${TMP_DIR}/sovrin/=/etc/sovrin/genesis/

rm -rf ${TMP_DIR}