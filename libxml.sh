
source ${BUILD_PREFIX}/Rock-Port_ana/files/RTEMS_mod_ver


LIBXML_VER=2.7.8
LIBXML_PKG=${BUILD_PREFIX}/pkgs/libxml2-${LIBXML_VER}.tar.gz
LIBXML_DIR=${BUILD_PREFIX}/libxml2-${LIBXML_VER}
LIBXML_URL=ftp://xmlsoft.org/libxml2/libxml2-${LIBXML_VER}.tar.gz

if ! [ -d ${LIBXML_DIR} ]; then
   if ! [ -e ${LIBXML_PKG} ]; then
      echo; echo "${LIBXML_PKG} not found. Downloading..."; echo
      wget ${LIBXML_URL} -O ${LIBXML_PKG} || exit
   fi

   cd ${BUILD_PREFIX}
   echo; echo "Uncompressing ${LIBXML_PKG}"
   tar xfz ${LIBXML_PKG}

   echo; echo "Applying patches"
   patch -p0 -i ${BUILD_PREFIX}/Rock-Port_ana/files/libxml.patch

   cd ${LIBXML_DIR}
else
   echo; echo "Using existing installation ${LIBXML_DIR}"
   cd ${LIBXML_DIR}
   make clean
fi

echo; echo "Compiling libXml2"
./configure CFLAGS="-B${INSTALL_PREFIX}/rtems/${RTEMS_VER}${RC}/${TARGET}${RTEMS_VER}/${BSP}/lib/ -specs bsp_specs -qrtems  -D__BSD_VISIBLE -DHAVE_ERRNO_H   -DHAVE_SYS_TYPES_H  -DHAVE_SYS_STAT_H   -DHAVE_FCNTL_H   -DHAVE_UNISTD_H  -DHAVE_STDLIB_H  -DHAVE_ZLIB=NO "  CC=${INSTALL_PREFIX}/rtems/${RTEMS_VER}${RC}/bin/${TARGET}${RTEMS_VER}-gcc CXX=${INSTALL_PREFIX}/rtems/${RTEMS_VER}${RC}/bin/${TARGET}${RTEMS_VER}-g++  --host=${TARGET} --prefix=${INSTALL_PREFIX}/libxml 2>&1 | tee libxml-configure.out  || { echo "Fail configuring libxml"; }
make 2>&1 | tee libxml-maker.out && make install 
