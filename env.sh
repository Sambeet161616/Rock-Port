export BUILD_PREFIX=/home/sambeet/NewRockPort/x86/Build/
export INSTALL_PREFIX=/home/sambeet/NewRockPort/x86/Install/

#LEON2 target
#export TARGET=sparc-rtems
#export BSP=leon2 
#export ARCH=sparc

#x86 target
export TARGET=i386-rtems
export BSP=pc486
export ARCH=x86

export RTEMS_INSTALL_DIR=${INSTALL_PREFIX}/rtems
export OMNIORB4_DIR=${INSTALL_PREFIX}/omniORB/
export XERCES_ROOT_DIR=${INSTALL_PREFIX}/xerces/
export EIGEN2_DIR=${INSTALL_PREFIX}/eigen/include/eigen2/

export PATH=$PATH:${RTEMS_INSTALL_DIR}/bin;

export IOR=010000002b00000049444c3a6f6d672e6f72672f436f734e616d696e672f4e616d696e67436f6e746578744578743a312e300000010000000000000070000000010102000d0000003139322e3136382e312e31390000f90a0b0000004e616d6553657276696365000300000000000000080000000100000000545441010000001c0000000100000001000100010000000100010509010100010000000901010003545441080000008c7da34e01003394
export HOST_IP="10.0.2.2"
