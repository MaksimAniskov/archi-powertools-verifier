#!/bin/sh
export DISPLAY=:99
Xvfb $DISPLAY &
/opt/Archi/Archi -application com.archimatetool.commandline.app -consoleLog -nosplash $@
