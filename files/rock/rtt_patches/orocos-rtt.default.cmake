--- ../orocos-rtt.default.cmake	2016-06-10 02:55:36.604061313 +0530
+++ ../patchstudy/orocos-rtt.default_study.cmake	2016-06-20 04:24:43.535290931 +0530
@@ -51,10 +51,10 @@
 # set(FORCE_BUILD_STATIC ON)
 
 #
-# Set the target operating system. One of [lxrt gnulinux xenomai macosx win32]
+# Set the target operating system. One of [lxrt gnulinux xenomai macosx rtems win32]
 # You may leave this as-is or force a certain target by removing the if... logic.
 #
-set(DOC_STRING "The Operating System target. One of [gnulinux lxrt macosx win32 xenomai]")
+set(DOC_STRING "The Operating System target. One of [gnulinux lxrt macosx rtems win32 xenomai ]")
 set(OROCOS_TARGET_ENV $ENV{OROCOS_TARGET}) # MUST use helper variable, otherwise not picked up !!!
 if( OROCOS_TARGET_ENV )
   set(OROCOS_TARGET ${OROCOS_TARGET_ENV} CACHE STRING "${DOC_STRING}" FORCE)
