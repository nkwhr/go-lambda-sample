#!/bin/sh

DIR="archive"

[ -d ${DIR} ] || mkdir ${DIR}

for F in $(ls -1 "src/${NAME}" | grep -v vendor); do
    [ "$(file -b src/${NAME}/${F})" = "directory" ] || continue

    GOOS=linux GOARCH=amd64 go build -o "bin/${F}" "./src/${NAME}/${F}"
    if [ $? -ne 0 ]; then
        echo "failed to build binary. function: ${F}"
        continue
    fi

    echo "successfully built. function: ${F}"

    (cd bin && zip "../${DIR}/${F}.zip" ${F} >/dev/null)
    if [ $? -ne 0 ]; then
        echo "failed to zip binary. function: ${F}"
        continue
    fi

    echo "successfully zipped to ${DIR}/${F}.zip"
done
