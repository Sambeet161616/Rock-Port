EIGEN_VER=2.0.16
EIGEN_PKG=${BUILD_PREFIX}/pkgs/eigen-${EIGEN_VER}.tar.bz2
EIGEN_DIR=${BUILD_PREFIX}/eigen-eigen-${EIGEN_VER}
EIGEN_URL=http://bitbucket.org/eigen/eigen/get/${EIGEN_VER}.tar.bz2

if ! [ -d ${EIGEN_DIR} ]; then
   if ! [ -e ${EIGEN_PKG} ]; then
      echo; echo "${EIGEN_PKG} not found. Downloading..."; echo
      wget ${EIGEN_URL} -O ${EIGEN_PKG} || exit
   fi

   cd ${BUILD_PREFIX}
   echo; echo "Uncompressing ${EIGEN_PKG}"
   tar xfj ${EIGEN_PKG}
else
   echo; echo "Using existing installation ${EIGEN_DIR}"
fi

if [ -e ${EIGEN_DIR}/build/ ]; then
   rm -rf ${EIGEN_DIR}/build/
fi

mkdir ${EIGEN_DIR}/build/ && cd ${EIGEN_DIR}/build/ 

echo; echo "Compiling Eigen"
cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX/eigen -DCMAKE_MODULE_PATH=$INSTALL_PREFIX/eigen/cmake || { echo "Fail configuring Eigen"; exit 1; }

make && make install
