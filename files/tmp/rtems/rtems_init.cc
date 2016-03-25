#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <stdlib.h>

/* omniORB includes */
#include <omnithread.h>
#include <omniORB4/CORBA.h>
#include <omniORB4/omniORB.h>


//#define  CONFIGURE_INIT
extern "C" {
#include "rtemscfg.h"
#include "net_cfg.h"
}

#define HOST_OMNINAMES_PORT_NUMBER 1235 

// Enable the following define if you want to 
// debug this application using the remote GDB.
// Basically, it stalls the GDB stubs along with
// application.
// NOTE: This is PC386 specific, and should not be
//       enabled for other BSPs.
// #define USE_REMOTE_GDB__
#ifdef USE_REMOTE_GDB__
#include <uart.h>

#define BREAKPOINT() asm("   int $3");
extern int BSPConsolePort;

 /* Init GDB glue  */
void init_remote_gdb( void )
{
  if(BSPConsolePort != BSP_UART_COM2)
    {
      /*
       * If com2 is not used as console use it for
       * debugging
       */

      i386_stub_glue_init(BSP_UART_COM2);
      printf( "Remote GDB using COM2...\n" );

    }
  else
    {
      /* Otherwise use com1 */
      i386_stub_glue_init(BSP_UART_COM1);
      printf( "Remote GDB using COM1...\n" );
    }

  printf( "Remote GDB: setting traps...\n" );
  /* Init GDB stub itself */
  set_debug_traps();

  printf( "Remote GDB: waiting remote connection....\n" );

  /*
   * Init GDB break in capability,
   * has to be called after
   * set_debug_traps
   */
  i386_stub_glue_init_breakin();

  /* Put breakpoint in */
  /* BREAKPOINT();     */
}
#endif  // USE_REMOTE_GDB__


//
// Table of directories to make. Please list here
// and file that you intend to use.
// 

static const char *directories[] =
{
  "/etc",
  0
};

/*
 * /etc/host.conf controls the resovler.
 */

static const char *etc_host_conf[] =
{
  "/etc/host.conf",
  "hosts,bind\n",
  0
};
static const char *etc_omniORB_conf[] =
{
  "/etc/omniORB.cfg",
  "traceExceptions = 0\n",
  "traceInvocations = 0\n",
  "traceInvocationReturns = 0\n",
  "traceThreadId = 0\n",
  "traceTime = 0\n",
  "dumpConfiguration = 0\n",
  "maxGIOPVersion = 1.2\n",
  "giopMaxMsgSize = 2097152  strictIIOP = 1\n",
  "lcdMode = 0\n",
  "tcAliasExpand = 0\n",
  "useTypeCodeIndirections = 1\n",
  "acceptMisalignedTcIndirections = 0\n",
  "scanGranularity = 5\n",
  "nativeCharCodeSet = ISO-8859-1\n",
  "nativeWCharCodeSet = UTF-16\n",
  "abortOnInternalError = 0\n",
  "validateUTF8 = 0\n",
  "clientCallTimeOutPeriod = 0\n",
  "clientConnectTimeOutPeriod = 0\n",
  "supportPerThreadTimeOut = 0\n",
  "resetTimeOutOnRetries = 0\n",
  "outConScanPeriod = 120\n",
  "maxGIOPConnectionPerServer = 5\n",
  "oneCallPerConnection = 1\n",
  "maxInterleavedCallsPerConnection = 5\n",
  "offerBiDirectionalGIOP = 0\n",
  "diiThrowsSysExceptions = 0\n",
  "verifyObjectExistsAndType = 1\n",
  "giopTargetAddressMode = 0\n",
  "immediateAddressSwitch = 0\n",
  "bootstrapAgentPort = 900\n",
  "serverCallTimeOutPeriod = 0\n",
  "inConScanPeriod = 180\n",
  "threadPerConnectionPolicy = 1\n",
  "maxServerThreadPerConnection = 100\n",
  "maxServerThreadPoolSize = 100\n",
  "threadPerConnectionUpperLimit = 10000\n",
  "threadPerConnectionLowerLimit = 9000\n",
  "threadPoolWatchConnection = 1\n",
  "connectionWatchPeriod = 50000\n",
  "connectionWatchImmediate = 0\n",
  "acceptBiDirectionalGIOP = 0\n",
  "unixTransportDirectory = /tmp/omni-%u\n",
  "unixTransportPermission = 0777\n",
  "supportCurrent = 1\n",
  "copyValuesInLocalCalls = 1\n",
  "objectTableSize = 0\n",
  "poaHoldRequestTimeout = 0\n",
  "poaUniquePersistentSystemIds = 1\n",
  "idleThreadTimeout = 10\n",
  "supportBootstrapAgent = 0\n",
  "InitRef = NameService=IOR:010000002b00000049444c3a6f6d672e6f72672f436f734e616d696e672f4e616d696e67436f6e746578744578743a312e300000010000000000000070000000010102000d0000003139322e3136382e312e31320000d3040b0000004e616d6553657276696365000300000000000000080000000100000000545441010000001c0000000100000001000100010000000100010509010100010000000901010003545441080000007d1c7f4e01002731\n",
  0
};


/*
 * Create enough files to support the networking stack.
 */
 
static int
make_dirs (const char **dir_table)
{
  /*
   * Create the directory.
   */

  while (*dir_table)
  {
    if (mkdir (*dir_table, 0755) < 0)
    {
      printf ("root fs, cannot make `%s' : %s\n", *dir_table, strerror (errno));
      return -1;
    }
//    printf( "mkdir: %s\n",  *dir_table );
    dir_table++;
  }
  return 0;
}


/*
 * Create enough files to support the networking stack.
 */

static int open_and_write_file (const char **file_table)
{
  int    len;
  FILE   *fp;

  if( ( fp= fopen( *file_table  ,"wt" ) ) == NULL )
  {
      fprintf(stderr, "unable to open output file %s\n", *file_table );
      return 0;
  }
  file_table++;
  while( *file_table )
  {
    len = fwrite( *file_table , 1, strlen( *file_table ), fp );
    if( len <= 0 )
	 {
      printf ("root fs, cannot write `%s' : %s\n", *file_table, strerror (errno));
      return 0;
    }
    file_table++;
  }
  fclose( fp );
  return 1;
}

/*
 * Create a root file system.
 */

int
rtems_create_root_fs (void *bcfg)
{
  /*
   * Create the directories.
   */

  if (make_dirs (directories) < 0)
    return -1;

   /*
   * Create a `/etc/omniORB.conf' file.
   */

  if( open_and_write_file (etc_omniORB_conf) < 0)
    return -1;

  /*
   * Create a `/etc/hosts' file.
   */

//  if( open_and_write_file (etc_hosts) < 0)
//    return -1;

  /*
   * Create a `/etc/host.conf' file.
   */

  if( open_and_write_file (etc_host_conf) < 0)
    return -1;

  return 0;
}



/* this is the command line options to be passed to the ORB */

// IMPORTANT: ** CHANGE THIS FOR YOUR TARGET **
// The command line paramters here to be passed to the ORB is
// specific of the setup that use to test. "rps1" is the name
// of the machine where the naming service is running, and 
// 6000 is the port number that I use to start omniNames.
//
char *cc_argv[] = 
{
	"cc_main",              /* always the name of the program */
   "-ORBtraceLevel",       /* trace level */
	"1"
};
//"-ORBInitRef NameService=corbaname::10.0.2.2",
//"-ORBtraceLevel",       /* trace level */
//	"20"
int cc_argc = sizeof( cc_argv ) / sizeof( cc_argv[ 0 ]  );


//
// this is the user's entry point. It should match the "main()"
// function in a regular C/C+prgram.
//
extern int cc_main(int argc, char **argv);


CORBA::Boolean rtems_transient_handler
( 
   void *cookie, 
   CORBA::ULong retries, 
   const CORBA::TRANSIENT & ex 
)
{
   printf( "Trasient Handler called: %ld\n", retries );
   return 1;
}


CORBA::Boolean rtems_COMM_FAILURE_handler
( 
   void *cookie, 
   CORBA::ULong retries, 
   const CORBA::COMM_FAILURE & ex 
)
{
   printf( "COMM_FAILURE HANDLER called: %ld\n", retries );
   return 1;
}


CORBA::Boolean rtems_SystemException_handler
( 
   void *cookie, 
   CORBA::ULong retries, 
   const CORBA::SystemException & ex 
)
{
   printf( "SystemException HANDLER called: %ld\n", retries );
   return 1;
}


static void installHandlers()
{
  printf( "Installing RTEMS exception handlers\n" );
  omniORB::installTransientExceptionHandler( 0, rtems_transient_handler );  
  omniORB::installCommFailureExceptionHandler( 0, rtems_COMM_FAILURE_handler );  
  omniORB::installSystemExceptionHandler( 0, rtems_SystemException_handler );  
}

/////////////////////////////////////////////////////////////////////////////
// DESCRIPTION: Init task for any omniORB/RTEMS application.
/////////////////////////////////////////////////////////////////////////////
void *POSIX_Init( void *argument )
{
//int main( int, char **, char **){

#ifdef USE_REMOTE_GDB__
  init_remote_gdb();
  BREAKPOINT();
#endif

  setenv("OMNIORB_USEHOSTNAME_VAR","10.0.2.2",0);
  //
  // This call does some preliminary initalization of the file
  // system, creating all necessary files used by the network
  // TCP/IP stack, such as /etc/hosts, etc.
  //
  rtems_create_root_fs( 0 );

  // RTEMS calls the global Ctor/Dtor in a context that is not
  // a posix thread. Calls to functions such as pthread_self()
  // returns NULL. So, for RTEMS let's make the thread 
  // initialization here. This is Ok as long as the cc_main()
  // routine stays running for the life time of the application.
  omni_thread::init_t omni_thread_init;

  printf( "\n\n*** CORBA omniORB2 - Echo test programs ***\n" );
  /* Make all network initialization */
  rtems_bsdnet_initialize_network();
  rtems_bsdnet_show_inet_routes ();
  printf( "Netowrk Initialization is complete.\n\n" );

  pthread_attr_t attr;
  size_t st = 0;
  pthread_attr_init(&attr);
  pthread_attr_getstacksize( &attr, &st );

  st = _Thread_Executing->Start.Initial_stack.size;

  printf( "Init Task Stack Size is: %d\n", st );

  // Uncomment the following lines if you want disable the 
  // connection management of omniORB. - See documentation
  // omniORB::idleConnectionScanPeriod( omniORB::idleIncoming, 0 );
  // omniORB::idleConnectionScanPeriod( omniORB::idleOutgoing, 0 );

  // install the exception handlers for the omniORB run-time.
  // Check documentation to see how they could be activated
  // and which cases you should use them.

  // installHandlers();

  // Call omniORB example
  cc_main( cc_argc, cc_argv );
  printf( "*** Done ***\n\n\n" );
  pthread_exit( NULL );
  return NULL; /* just so the compiler thinks we returned something */
}

