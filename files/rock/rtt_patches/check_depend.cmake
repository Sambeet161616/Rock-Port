--- ../config/check_depend.cmake	2016-06-20 03:35:37.951414806 +0530
+++ ../patchstudy/check_depend_study.cmake	2016-06-20 03:42:38.375397125 +0530
@@ -54,6 +54,12 @@
 
 # Look for boost We look up all components in one place because this macro does
 # not support multiple invocations in some CMake versions.
+
+if(OROCOS_TARGET STREQUAL "rtems")
+   set(Boost_USE_STATIC_LIBS   ON)
+   set(Boost_USE_MULTITHREADED ON)
+endif()
+
 find_package(Boost 1.38 COMPONENTS filesystem system unit_test_framework thread serialization)
 
 # Look for boost
@@ -169,6 +175,32 @@
   set(OROPKG_OS_XENOMAI FALSE CACHE INTERNAL "" FORCE)
 endif()
 
+# Setup flags for rtems 
+if(OROCOS_TARGET STREQUAL "rtems")
+  set(OROPKG_OS_RTEMS TRUE CACHE INTERNAL "This variable is exported to the rtt-config.h file to expose our target choice to the code." FORCE)
+  set(OS_HAS_TLSF FALSE)
+
+  find_package(RTEMS REQUIRED)
+
+  if(RTEMS_FOUND)
+
+    set(RTEMS_SUPPORT TRUE CACHE INTERNAL "" FORCE)
+
+    list(APPEND OROCOS-RTT_INCLUDE_DIRS ${RTEMS_INCLUDE_DIRS} )
+    list(APPEND OROCOS-RTT_LIBRARIES ${RTEMS_LIBRARIES} ${PTHREAD_LIBRARIES} ) 
+    list(APPEND OROCOS-RTT_DEFINITIONS "OROCOS_TARGET=${OROCOS_TARGET}") 
+    
+
+    message( "Turning BUILD_STATIC ON for rtems.")
+    set( FORCE_BUILD_STATIC ON CACHE INTERNAL "Forces to build Orocos RTT as a static library (forced to ON by Rtems)" FORCE)
+    set( BUILD_STATIC ON CACHE BOOL "Build Orocos RTT as a static library (forced to ON by Rtems)" FORCE)
+  endif()
+else()
+  set(OROPKG_OS_RTEMS FALSE CACHE INTERNAL "" FORCE)
+endif()
+
+
+
 # Setup flags for GNU/Linux
 if(OROCOS_TARGET STREQUAL "gnulinux")
   set(OROPKG_OS_GNULINUX TRUE CACHE INTERNAL "This variable is exported to the rtt-config.h file to expose our target choice to the code." FORCE)
