#!/usr/bin/env bash

source ${BUILD_PREFIX}/Rock-Port_ana/files/rtems_ver

BINUTILS_PKG=${BUILD_PREFIX}/pkgs/binutils-${BINUTILS_VER}.tar.bz2
BINUTILS_URL=http://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VER}.tar.bz2
BINUTILS_DIR=${BUILD_PREFIX}/rtems/binutils-${BINUTILS_VER}

GCC_PKG=${BUILD_PREFIX}/pkgs/gcc-${GCC_VER}.tar.bz2
GCC_URL=http://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.bz2
GCC_DIR=${BUILD_PREFIX}/rtems/gcc-${GCC_VER}

NEWLIB_PKG=${BUILD_PREFIX}/pkgs/newlib-${NEWLIB_VER}.tar.gz
NEWLIB_URL=ftp://sourceware.org/pub/newlib/newlib-${NEWLIB_VER}.tar.gz
NEWLIB_DIR=${BUILD_PREFIX}/rtems/newlib-${NEWLIB_VER}

RTEMS_PKG=${BUILD_PREFIX}/pkgs/rtems-${RTEMS_VER}.0-rc1.tar.gz
RTEMS_URL=http://www.rtems.org/ftp/pub/rtems/${RTEMS_VER}/rtems-${RTEMS_VER}.0-rc1.tar.gz
RTEMS_DIR=${BUILD_PREFIX}/rtems/rtems-${RTEMS_VER}


GDB_PKG=${BUILD_PREFIX}/pkgs/gdb-${GDB_VER}.tar.bz2
GDB_URL=http://ftp.gnu.org/gnu/gdb/gdb-${GDB_VER}.tar.bz2
GDB_DIR=${BUILD_PREFIX}/rtems/gdb-${GDB_VER}


if ! [ -e ${BINUTILS_PKG} ]; then
   echo; echo "${BINUTILS_PKG} not found. Downloading..."; echo
   wget ${BINUTILS_URL} -O ${BINUTILS_PKG} || exit
fi

if ! [ -e ${GCC_PKG} ]; then
   echo; echo "${GCC_PKG} not found. Downloading..."; echo
   wget ${GCC_URL} -O ${GCC_PKG} || exit
fi

if ! [ -e ${GDB_PKG} ]; then
   echo; echo "${GDB_PKG} not found. Downloading..."; echo
   wget ${GDB_URL} -O ${GDB_PKG} || exit
fi

if ! [ -e ${NEWLIB_PKG} ]; then
   echo; echo "${NEWLIB_PKG} not found. Downloading..."; echo
   wget ${NEWLIB_URL} -O ${NEWLIB_PKG} || exit
fi

if ! [ -e ${RTEMS_PKG} ]; then
   echo; echo "${RTEMS_PKG} not found. Downloading..."; echo
   wget ${RTEMS_URL} -O ${RTEMS_PKG} || exit
fi

if ! [ -e ${BUILD_PREFIX}/rtems/ ]; then
   echo; echo "Creating ${BUILD_PREFIX}/rtems/"; echo
   mkdir ${BUILD_PREFIX}/rtems/
fi

cd ${BUILD_PREFIX}/rtems/

if ! [ -d ${BINUTILS_DIR} ]; then
   echo; echo "Uncompressing ${BINUTILS_PKG}"
   tar xfj ${BINUTILS_PKG}
fi

if ! [ -d ${GCC_DIR} ]; then
   echo; echo "Uncompressing ${GCC_PKG}"
   tar xfj ${GCC_PKG}
fi

if ! [ -d ${GDB_DIR} ]; then
   echo; echo "Uncompressing ${GDB_PKG}"
   tar xfj ${GDB_PKG}
fi

if ! [ -d ${NEWLIB_DIR} ]; then
   echo; echo "Uncompressing ${NEWLIB_PKG}"
   tar xfz ${NEWLIB_PKG}
   echo;cd ${BUILD_PREFIX}/rtems/
fi

if ! [ -d ${RTEMS_DIR} ]; then
   echo; echo "Uncompressing ${RTEMS_PKG}"
   tar xfz ${RTEMS_PKG}
   echo;
fi

if ! [ -e ${BUILD_PREFIX}/rtems/Makefile ]; then
   cp ${BUILD_PREFIX}/Rock-Port_ana/files/Makefile_RTEMS ${BUILD_PREFIX}/rtems/Makefile
fi

if ! [ -e ${GCC_DIR}/newlib ]; then
   ln -s ${NEWLIB_DIR}/newlib ${GCC_DIR}/newlib
fi

cd ${BUILD_PREFIX}/rtems/
make build-binutils && make build-gcc && make build-gdb && make build-rtems && make clean
