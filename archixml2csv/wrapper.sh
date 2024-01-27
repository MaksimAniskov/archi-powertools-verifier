#!/bin/sh

set -e

cp "${MODELS_FOLDER}/${ARCHI_FILE-model.archimate}" /tmp/archimate.model
(cd /tmp && unzip -o archimate.model model.xml && mv model.xml archimate.model || true)
python /usr/src/archixml2csv.py /tmp/archimate.model

rm -fr model2
if [ "$ARCHI_FILE2" ] && [ -f "${MODELS_FOLDER}/${ARCHI_FILE2}" ]
then
    cp "${MODELS_FOLDER}/${ARCHI_FILE2}" /tmp/archimate2.model
    (cd /tmp && unzip -o archimate2.model model2.xml && mv model2.xml archimate2.model || true)
    mkdir -p model2
    cd model2
    python /usr/src/archixml2csv.py /tmp/archimate2.model
fi
