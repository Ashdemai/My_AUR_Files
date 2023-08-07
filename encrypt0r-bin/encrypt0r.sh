#!/bin/bash
_ELECTRON=/usr/bin/electron18
_ASAR=/opt/encrypt0r/encrypt0r.asar
if [[ $EUID -ne 0 ]] || [[ $ELECTRON_RUN_AS_NODE ]]; then
    exec ${_ELECTRON} ${_ASAR} "$@"
else
    exec ${_ELECTRON} ${_ASAR} --no-sandbox "$@"
fi