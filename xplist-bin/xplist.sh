#!/bin/sh
set -e
_APPDIR="/opt/@appname@"
_RUNAPP="${_APPDIR}/@runname@"
export PATH="${_APPDIR}:${PATH}"
export LD_LIBRARY_PATH="${_APPDIR}/swiftshader:${_APPDIR}/lib:${LD_LIBRARY_PATH}"
export QT_PLUGIN_PATH="${_APPDIR}/plugins:${QT_PLUGIN_PATH}"
cd "${_APPDIR}"
exec "${_RUNAPP}" "$@"
exit