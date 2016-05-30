OMNIORB_VER=4.1.4
OMNIORB_PKG=${BUILD_PREFIX}/pkgs/omniORB-${OMNIORB_VER}.tar.gz
OMNIORB_DIR=${BUILD_PREFIX}/omniORB-${OMNIORB_VER}
OMNIORB_URL=http://sourceforge.net/projects/omniorb/files/omniORB/omniORB-${OMNIORB_VER}/omniORB-${OMNIORB_VER}.tar.gz/download

if ! [ -d ${OMNIORB_DIR} ]; then
   if ! [ -e ${OMNIORB_PKG} ]; then
      echo; echo "${OMNIORB_PKG} not found. Downloading..."; echo
      wget ${OMNIORB_URL} -O ${OMNIORB_PKG} || exit
   fi

   cd ${BUILD_PREFIX}
   echo; echo "Uncompressing ${OMNIORB_PKG}"
   tar xfz ${OMNIORB_PKG}

   echo; echo "Applying patches"
   patch -p0 -i ${BUILD_PREFIX}/Rock-Port_ana/files/omniORB-${OMNIORB_VER}.patch

   cd ${OMNIORB_DIR}
else
   echo; echo "Using existing installation ${OMNIORB_DIR}"
   cd ${OMNIORB_DIR}
   make clean
fi

echo; echo "Compiling omniORB tools"
./configure CPPFLAGS="-D__rtems__" --prefix=${INSTALL_PREFIX}/omniORB || { echo "Fail configuring omniORB tools"; exit 1; }

make -C src/tool/omniidl/ && make -C src/lib/omniORB/omniidl_be && make -C src/tool/omkdepend || { echo "Fail compiling omniORB tools"; exit 1; }

make -C src/tool/omniidl/ install && make -C src/lib/omniORB/omniidl_be install && make -C src/tool/omkdepend/ install || { echo "Fail installing omniORB tools"; exit 1; }

echo; echo "Compiling omniORB"
./configure CC=${TARGET}-gcc CXX=${TARGET}-g++ --host=${TARGET} --prefix=${INSTALL_PREFIX}/omniORB  || { echo "Fail configuring omniORB"; exit 1; }
make && make install
