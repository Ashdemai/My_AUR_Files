#!/bin/bash
_ELECTRON=/usr/bin/electron25
APPDIR=/usr/lib/fairshare
export PATH="${APPDIR}:${PATH}"
export LD_LIBRARY_PATH="${APPDIR}/lib:${LD_LIBRARY_PATH}"
_ASAR="${APPDIR}/app.asar"
cd $APPDIR && ./api 7632
if [[ $EUID -ne 0 ]] || [[ $ELECTRON_RUN_AS_NODE ]]; then
    exec ${_ELECTRON} ${_ASAR} "$@"
else
    exec ${_ELECTRON} ${_ASAR} --no-sandbox "$@"
fi