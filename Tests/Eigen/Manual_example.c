#include <rtems.h> //
rtems_task user_application(rtems_task_argument argument);
rtems_task init_task(
rtems_task_argument ignored
)
{
rtems_id tid;
rtems_status_code status;
rtems_name name;
name = rtems_build_name( ’A’, ’P’, ’P’, ’1’ )
status = rtems_task_create(
name, 1, RTEMS_MINIMUM_STACK_SIZE,
RTEMS_NO_PREEMPT, RTEMS_FLOATING_POINT, &tid
);
if ( status != RTEMS_STATUS_SUCCESSFUL ) {
printf( "rtems_task_create failed with status of %d.\n", status );
exit( 1 );
}
status = rtems_task_start( tid, user_application, 0 );
if ( status != RTEMS_STATUS_SUCCESSFUL ) {
printf( "rtems_task_start failed with status of %d.\n", status );
exit( 1 );
}
status = rtems_task_delete( SELF );
/* should not return */
printf( "rtems_task_delete returned with status of %d.\n", status );
exit( 1 );
}
