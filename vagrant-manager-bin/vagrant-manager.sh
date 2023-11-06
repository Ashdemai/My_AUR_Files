#!/bin/bash
_ELECTRON=/usr/bin/electron5
APPDIR="/usr/lib/vagrant-manager"
export PATH="${APPDIR}:${PATH}"
export LD_LIBRARY_PATH="${APPDIR}/swiftshader:${APPDIR}/usr/lib:${LD_LIBRARY_PATH}"
_ASAR="${APPDIR}/app.asar"
if [[ $EUID -ne 0 ]] || [[ $ELECTRON_RUN_AS_NODE ]]; then
    exec ${_ELECTRON} ${_ASAR} "$@"
else
    exec ${_ELECTRON} ${_ASAR} --no-sandbox "$@"
fi