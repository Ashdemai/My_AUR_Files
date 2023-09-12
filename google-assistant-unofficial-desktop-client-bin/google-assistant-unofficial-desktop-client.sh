#!/bin/bash
_ELECTRON=/usr/bin/electron10
_ASAR="/opt/google-assistant-unofficial-desktop-client/google-assistant-unofficial-desktop-client.asar"
if [[ $EUID -ne 0 ]] || [[ $ELECTRON_RUN_AS_NODE ]]; then
    exec ${_ELECTRON} ${_ASAR} "$@"
else
    exec ${_ELECTRON} ${_ASAR} --no-sandbox "$@"
fi