#!/usr/bin/env bash

source ${BUILD_PREFIX}/Rock-Port_ana/files/RTEMS_mod_ver

if ! [ -e ${BUILD_PREFIX}/rtems/ ]; then
   echo; echo "Creating ${BUILD_PREFIX}/rtems/"; echo
   mkdir ${BUILD_PREFIX}/rtems/
fi

RSB_PKG=${BUILD_PREFIX}/pkgs/rtems-source-builder-${RTEMS_VER}${RC}.tar.xz
RSB_URL=https://ftp.rtems.org/pub/rtems/releases/${RTEMS_VER}/${RTEMS_VER}${RC}/rtems-source-builder-${RTEMS_VER}${RC}.tar.xz
RSB_DIR=${BUILD_PREFIX}/rtems/rtems-source-builder-${RTEMS_VER}${RC}

RTEMS_PKG=${BUILD_PREFIX}/pkgs/rtems-${RTEMS_VER}${RC}.tar.xz
RTEMS_URL=http://ftp.rtems.org/pub/rtems/releases/${RTEMS_VER}/${RTEMS_VER}${RC}/rtems-${RTEMS_VER}${RC}.tar.xz
RTEMS_DIR=${BUILD_PREFIX}/rtems/rtems-${RTEMS_VER}${RC}

if ! [ -e ${RSB_PKG} ]; then
   echo; echo "${RSB_PKG} not found. Downloading..."; echo
   wget ${RSB_URL} -O ${RSB_PKG} || exit
fi

if ! [ -e ${RTEMS_PKG} ]; then
   echo; echo "${RTEMS_PKG} not found. Downloading..."; echo
   wget ${RTEMS_URL} -O ${RTEMS_PKG} || exit
fi

cd ${BUILD_PREFIX}/rtems/

if ! [ -d ${RSB_DIR} ]; then
   echo; echo "Uncompressing ${RSB_PKG}"
   tar xf ${RSB_PKG}
fi

if ! [ -d ${RTEMS_DIR} ]; then
   echo; echo "Uncompressing ${RTEMS_PKG}"
   tar xf ${RTEMS_PKG}
   echo;
fi

if ! [ -e ${BUILD_PREFIX}/rtems/Makefile ]; then
   cp ${BUILD_PREFIX}/Rock-Port_ana/files/mod/Makefile_rtems ${BUILD_PREFIX}/rtems/Makefile
fi

make all

echo "RTEMS Prepared"

