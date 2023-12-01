#!/bin/bash
APPDIR="/usr/lib/my-yesplaymusic"
export PATH="${APPDIR}:${PATH}"
export ELECTRON_IS_DEV=0
#export LD_LIBRARY_PATH="${APPDIR}/swiftshader:${LD_LIBRARY_PATH}"
_ASAR="${APPDIR}/app.asar"
if [[ $EUID -ne 0 ]] || [[ $ELECTRON_RUN_AS_NODE ]]; then
    cd $APPDIR
    exec electron@electronversion@ ${_ASAR} "$@"
else
    cd $APPDIR
    exec electron@electronversion@ ${_ASAR} --no-sandbox "$@"
fi