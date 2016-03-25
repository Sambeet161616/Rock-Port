XERCES_C_VER=3.1.1
XERCES_C_PKG=${BUILD_PREFIX}/pkgs/xerces-c-${XERCES_C_VER}.tar.gz
XERCES_C_DIR=${BUILD_PREFIX}/xerces-c-${XERCES_C_VER}
XERCES_C_URL=http://apache.xl-mirror.nl//xerces/c/3/sources/xerces-c-${XERCES_C_VER}.tar.gz

if ! [ -d ${XERCES_C_DIR} ]; then
   if ! [ -e ${XERCES_C_PKG} ]; then
      echo; echo "${XERCES_C_PKG} not found. Downloading..."; echo
      wget ${XERCES_C_URL} -O ${XERCES_C_PKG} || exit
   fi

   cd ${BUILD_PREFIX}
   echo; echo "Uncompressing ${XERCES_C_PKG}"
   tar xfz ${XERCES_C_PKG}

   echo; echo "Applying patches"
   patch -p0 -i ${BUILD_PREFIX}/scripts/files/xerces-c-${XERCES_C_VER}.patch

   cd ${XERCES_C_DIR}
else
   echo; echo "Using existing installation ${XERCES_C_DIR}"
   cd ${XERCES_C_DIR}
   make clean
fi

echo; echo "Compiling Xerces-C"
LDFLAGS="-e start -B${RTEMS_INSTALL_DIR}/${TARGET}/${BSP}/lib/ -qrtems -specs bsp_specs" ./configure CC=${TARGET}-gcc CXX=${TARGET}-g++ --host=${TARGET} --disable-threads --prefix=$INSTALL_PREFIX/xerces || { echo "Fail configuring Xerces-C"; exit 1; }

make && make install
