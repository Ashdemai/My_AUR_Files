#!/bin/bash
_ELECTRON=/usr/bin/electron9
_ASAR="/opt/youku/resources/app.asar"
if [[ $EUID -ne 0 ]] || [[ $ELECTRON_RUN_AS_NODE ]]; then
    exec "${_ELECTRON}" "${_ASAR}" "$@"
else
    exec "${_ELECTRON}" "${_ASAR}" --no-sandbox "$@"
fi