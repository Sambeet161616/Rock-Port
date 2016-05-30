EIGEN_VER=2.0.16
EIGEN_PKG=${BUILD_PREFIX}/pkgs/eigen-${EIGEN_VER}.tar.bz2
EIGEN_DIR=${BUILD_PREFIX}/eigen-${EIGEN_VER}
EIGEN_URL=http://bitbucket.org/eigen/eigen/get/${EIGEN_VER}.tar.bz2

if ! [ -d ${EIGEN_DIR} ]; then
   if ! [ -e ${EIGEN_PKG} ]; then
      echo; echo "${EIGEN_PKG} not found. Downloading..."; echo
      wget ${EIGEN_URL} -O ${EIGEN_PKG}
   fi
   
   cd ${BUILD_PREFIX}
   echo; echo "Uncompressing ${EIGEN_PKG}"
   NAME="$(tar xf pkgs/eigen-2.0.16.tar.bz2 && find -maxdepth 1 -type d -name '*eigen*'| head -n1)"
   NAMER="$(echo $NAME | cut -d "." -f 2 |cut -d "/" -f 2 )"
   mv $NAMER eigen-${EIGEN_VER}
else
   echo; echo "Using existing installation ${EIGEN_DIR}"
fi

if [ -e ${EIGEN_DIR}/build/ ]; then
   rm -rf ${EIGEN_DIR}/build/
fi

mkdir ${EIGEN_DIR}/build/ && cd ${EIGEN_DIR}/build/ 

echo; echo "Compiling Eigen"
cmake .. -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX/eigen -DCMAKE_MODULE_PATH=${EIGEN_DIR} || { echo "Fail configuring Eigen"; }

make && make install

echo "Eigen Prepared"
