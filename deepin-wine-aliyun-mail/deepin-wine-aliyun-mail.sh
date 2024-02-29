#!/bin/sh
set -e
BOTTLENAME=@bottlename@
APPVER=@sparkver@
WINEPREFIX="${HOME}/.deepinwine/${BOTTLENAME}"
EXEC_PATH="c:/ProgramData/@providername@/@pathname@/@pathname@.exe"
EXEC_FILE="${WINEPREFIX}/drive_c/ProgramData/@providername@/@pathname@/@pathname@.exe"
START_SHELL_PATH="/opt/deepinwine/tools/run_v4.sh"
UPDATEAPP_INSTALLER="@pathname@"
UPDATEAPP_VER=@appver@
UPDATEAPP_INSTALLER_PATH="c:/ProgramData/@providername@/${UPDATEAPP_INSTALLER}/${UPDATEAPP_INSTALLER}-${UPDATEAPP_VER}.exe"
export MIME_TYPE=""
export DEB_PACKAGE_NAME=@appname@
export APPRUN_CMD=deepin-wine6-stable
DISABLE_ATTACH_FILE_DIALOG=""
EXPORT_ENVS=""
SPECIFY_SHELL_DIR=$(dirname ${START_SHELL_PATH})
export SPECIFY_SHELL_DIR
ARCHIVE_FILE_DIR="/opt/apps/${DEB_PACKAGE_NAME}/files"
export WINEDLLPATH="/opt/${APPRUN_CMD}/lib:/opt/${APPRUN_CMD}/lib64"
export LD_LIBRARY_PATH="/opt/apps/${DEB_PACKAGE_NAME}/files/lib32"
export WINEPREDLL="${ARCHIVE_FILE_DIR}/dlls"
msg() {
    ECHO_LEVEL=("\033[1;32m==> " "\033[1;31m==> ERROR: ")
    echo -e "${ECHO_LEVEL[$1]}\033[1;37m$2\033[0m"
}
OpenWinecfg() {
    msg 0 "Launching winecfg with ${APPRUN_CMD} in ${WINEPREFIX} ..."
    env WINEPREFIX="${WINEPREFIX}" ${APPRUN_CMD} winecfg
}
DeployApp() {
    # deploy bottle
    msg 0 "Deploying ${WINEPREFIX} ..."
    rm -rf "${WINEPREFIX}"
    # run installer
    msg 0 "Launching ${UPDATEAPP_INSTALLER_PATH} ..."
    env WINEDLLOVERRIDES="winemenubuilder.exe=d" ${START_SHELL_PATH} ${BOTTLENAME} ${APPVER} "${UPDATEAPP_INSTALLER_PATH}" "$@"
    touch "${WINEPREFIX}"/reinstalled
    msg 0 "Creating ${WINEPREFIX}/PACKAGE_VERSION ..."
    cat "/opt/apps/${DEB_PACKAGE_NAME}/files/files.md5sum" >"${WINEPREFIX}"/PACKAGE_VERSION
}
WakeApp() {
    env WINEPREDLL="${ARCHIVE_FILE_DIR}/dlls" \
        WINEDLLPATH=/opt/${APPRUN_CMD}/lib:/opt/${APPRUN_CMD}/lib64 \
        WINEPREFIX="${WINEPREFIX}" ${APPRUN_CMD} /opt/deepinwine/tools/sendkeys.exe w
}
Run() {
    if [ -z "${DISABLE_ATTACH_FILE_DIALOG}" ]; then
        export ATTACH_FILE_DIALOG=1
    fi
    if [ -n "${EXPORT_ENVS}" ]; then
        export "${EXPORT_ENVS}"
    fi
    if [ -n "${EXEC_PATH}" ]; then
        if [ ! -f "${WINEPREFIX}/reinstalled" ] || [ ! -f "${EXEC_FILE}" ]; then
            DeployApp "$@"
            exit 0
        fi
        if [ -z "${EXEC_PATH##*.lnk}" ]; then
            msg 0 "Launching  ${EXEC_PATH} lnk file ..."
            exec "${START_SHELL_PATH}" "${BOTTLENAME}" "${APPVER}" "C:/windows/command/start.exe" "/Unix" "${EXEC_PATH}" "$@" || exit $?
        else
            msg 0 "Launching  ${EXEC_PATH} ..."
            exec "${START_SHELL_PATH}" "${BOTTLENAME}" "${APPVER}" "${EXEC_PATH}" "$@" || exit $?
        fi
    else
        exec "${START_SHELL_PATH}" "${BOTTLENAME}" "${APPVER}" "uninstaller.exe" "$@" || exit $?
    fi
}
HelpApp() {
    echo " Extra Commands:"
    echo " winecfg          Open winecfg"
    echo " -w/--wake       Wake up background program"
    echo " -h/--help        Show program help info"
}
    
if [ -z "$1" ]; then
    Run "$@"
    exit 0
fi
case $1 in
"winecfg")
    OpenWinecfg
    ;;
"-w" | "--wake")
    WakeApp "$@"
    ;;
"-h" | "--help")
    HelpApp "$@"
    ;;
*)
    Run "$@"
    ;;
esac
exit 0