#include <bsp.h>

#ifdef __cplusplus
extern "C" {
#endif


void *POSIX_Init( void *argument );

#define CONFIGURE_APPLICATION_NEEDS_CONSOLE_DRIVER
#define CONFIGURE_APPLICATION_NEEDS_CLOCK_DRIVER
#define CONFIGURE_USE_IMFS_AS_BASE_FILESYSTEM
#ifndef CONFIGURE_NUMBER_OF_TERMIOS_PORTS
   #define CONFIGURE_NUMBER_OF_TERMIOS_PORTS             3
#endif

#define CONFIGURE_APPLICATION_NEEDS_CLOCK_DRIVER
#define CONFIGURE_APPLICATION_NEEDS_CONSOLE_DRIVER

#define CONFIGURE_POSIX_INIT_THREAD_TABLE

#define CONFIGURE_MAXIMUM_POSIX_MUTEXES \
rtems_resource_unlimited( 5 )

#define CONFIGURE_MAXIMUM_TASKS  \
rtems_resource_unlimited( 5 )

#define CONFIGURE_MAXIMUM_POSIX_THREADS \
rtems_resource_unlimited( 5 )

#define CONFIGURE_MAXIMUM_POSIX_CONDITION_VARIABLES \
rtems_resource_unlimited( 5 )

#define CONFIGURE_MAXIMUM_POSIX_BARRIERS \
rtems_resource_unlimited( 5 )

#define CONFIGURE_LIBIO_MAXIMUM_FILE_DESCRIPTORS \
20

#define CONFIGURE_MAXIMUM_POSIX_SEMAPHORES \
20

#define CONFIGURE_MP_MAXIMUM_GLOBAL_OBJECTS \
rtems_resource_unlimited( 5 )

#define CONFIGURE_MAXIMUM_POSIX_KEYS \
rtems_resource_unlimited( 7 )

#define CONFIGURE_INIT

#include <rtems/confdefs.h>

#ifdef __cplusplus
}
#endif
