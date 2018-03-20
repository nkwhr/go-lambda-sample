#!/bin/sh

_DEPLOY_DIR="deploy"
_FUNC_DIR="./src/${NAME}/functions"

[ -d ${_DEPLOY_DIR} ] || mkdir ${_DEPLOY_DIR}

for F in $(ls -1 "${_FUNC_DIR}"); do
    GOOS=linux GOARCH=amd64 go build -o "bin/${F}" "${_FUNC_DIR}/${F}"
    if [ $? -ne 0 ]; then
        echo "failed to build binary. function: ${F}"
        continue
    fi

    echo "successfully built function: ${F}"

    (cd bin && zip "../${_DEPLOY_DIR}/${F}.zip" ${F} >/dev/null)
    if [ $? -ne 0 ]; then
        echo "failed to zip binary. function: ${F}"
        continue
    fi

    echo "successfully zipped to ${_DEPLOY_DIR}/${F}.zip"
done
