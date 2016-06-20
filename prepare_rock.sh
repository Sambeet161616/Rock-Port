ROCK_DIR=${BUILD_PREFIX}/rock
. ${BUILD_PREFIX}/Rock-Port_ana/env.sh

#if ! [ -d ${ROCK_DIR} ]; then
 #  echo; echo "Uncompressing ${BUILD_PREFIX}/pkgs/rock_base.tar.bz2"
  # if ! [ -e ${BUILD_PREFIX}/pkgs/rock_base.tar.bz2 ]; then
   #   exit
   #fi
   cd ${BUILD_PREFIX}
   #tar xfj ${BUILD_PREFIX}/pkgs/rock_base.tar.bz2
   #mv ${BUILD_PREFIX}/rock_base ${BUILD_PREFIX}/rock
   ${BUILD_PREFIX}/Rock-Port_Ana/files/fixPath.sh
#fi

cd ${ROCK_DIR}

# Build utilmm and typelib for host 
. ${ROCK_DIR}/env.sh
autoproj build tools/utilmm
autoproj build tools/typelib
rm -rf ${ROCK_DIR}/tools/utilmm/build
rm -rf ${ROCK_DIR}/tools/typelib/build

echo "Applying patches"
cd ${ROCK_DIR}
for i in `find ${BUILD_PREFIX}/Rock-Port_ana/files/rock/ -name *.patch`; do
	patch -p1 -i $i; 
done;

