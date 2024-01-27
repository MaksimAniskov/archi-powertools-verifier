#!/bin/sh
export DISPLAY=:99
Xvfb $DISPLAY &

/opt/Archi/Archi -application com.archimatetool.commandline.app -consoleLog -nosplash \
    --modelrepository.cloneModel "${GIT_URL}" \
    --modelrepository.userName "${GIT_USER}" \
    --modelrepository.passFile "/usr/var/passwords/${GIT_PASSWORD_FILE}" \
    --modelrepository.loadModel /tmp/archi-model-clone \
    --saveModel /usr/var/intermediate_files/model.archimate

rm -f /usr/var/intermediate_files/model2.archimate
if [ "$GIT_URL2" ]
then
    /opt/Archi/Archi -application com.archimatetool.commandline.app -consoleLog -nosplash \
        --modelrepository.cloneModel "${GIT_URL2}" \
        --modelrepository.userName "${GIT_USER2}" \
        --modelrepository.passFile "/usr/var/passwords/${GIT_PASSWORD_FILE2}" \
        --modelrepository.loadModel /tmp/archi-model-clone \
        --saveModel /usr/var/intermediate_files/model2.archimate
fi
