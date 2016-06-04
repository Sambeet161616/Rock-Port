
source ${BUILD_PREFIX}/Rock-Port_ana/files/RTEMS_mod_ver

XERCES_C_VER=3.1.1
XERCES_C_PKG=${BUILD_PREFIX}/pkgs/xerces-c-${XERCES_C_VER}.tar.gz
XERCES_C_DIR=${BUILD_PREFIX}/xerces-c-${XERCES_C_VER}
XERCES_C_URL=http://archive.apache.org/dist/xerces/c/3/sources/xerces-c-${XERCES_C_VER}.tar.gz

if ! [ -d ${XERCES_C_DIR} ]; then
   if ! [ -e ${XERCES_C_PKG} ]; then
      echo; echo "${XERCES_C_PKG} not found. Downloading..."; echo
      wget ${XERCES_C_URL} -O ${XERCES_C_PKG}
   fi

   cd ${BUILD_PREFIX}
   echo; echo "Uncompressing ${XERCES_C_PKG}"
   tar xfz ${XERCES_C_PKG}

   echo; echo "Applying patches"
   patch -p0 -i ${BUILD_PREFIX}/Rock-Port_ana/files/xerces-c-${XERCES_C_VER}.patch

   cd ${XERCES_C_DIR}
else
   echo; echo "Using existing installation ${XERCES_C_DIR}"
   cd ${XERCES_C_DIR}
   make clean
fi

echo; echo "Compiling Xerces-C"
LDFLAGS="-e start -B${INSTALL_PREFIX}/rtems/${RTEMS_VER}${RC}/${TARGET}${RTEMS_VER}/${BSP}/lib/ -qrtems -specs bsp_specs" ./configure CC=${INSTALL_PREFIX}/rtems/${RTEMS_VER}${RC}/bin/${TARGET}${RTEMS_VER}-gcc CXX=${INSTALL_PREFIX}/rtems/${RTEMS_VER}${RC}/bin/${TARGET}${RTEMS_VER}-g++ --host=${TARGET} --disable-threads --prefix=$INSTALL_PREFIX/xerces || { echo "Fail configuring Xerces-C"; }

make && make install
