BOOST_VER=1_44_0
BOOST_PKG=${BUILD_PREFIX}/pkgs/boost_${BOOST_VER}.tar.bz2
BOOST_DIR=${BUILD_PREFIX}/boost_${BOOST_VER}
BOOST_URL=http://sourceforge.net/projects/boost/files/boost/${BOOST_VER//_/.}/boost_${BOOST_VER}.tar.bz2/download

if ! [ -d ${BOOST_DIR} ]; then
   if ! [ -e ${BOOST_PKG} ]; then
      echo "${BOOST_PKG} not found. Downloading..."; echo
      wget ${BOOST_URL} -O ${BOOST_PKG} || exit
   fi

   cd ${BUILD_PREFIX}
   echo "Uncompressing ${BOOST_PKG}"
   tar xfj ${BOOST_PKG}

   echo "Building BJam"
   cd ${BOOST_DIR}/tools/jam/src/
   ./build.sh
   cp bin.linu*/* .
   PATH=${BOOST_DIR}/tools/jam/src:$PATH
   
   echo "Applying patches"
   cd ${BUILD_PREFIX}
   patch -p0 -i ${BUILD_PREFIX}/scripts/files/boost_${BOOST_VER}.patch
else
   echo "Using existing installation ${BOOST_DIR}"
   PATH=${BOOST_DIR}/tools/jam/src:$PATH
fi

echo "Compiling Boost"
cd ${BOOST_DIR}
bjam -d2 install --toolset=gcc '-sBUILD=release static multi/single' link=static runtime-link=static threading=multi --prefix=${INSTALL_PREFIX}/boost/ --layout=system stage --with-filesystem --with-serialization --with-thread --with-regex --with-graph --with-test
