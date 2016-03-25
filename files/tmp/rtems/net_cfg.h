#ifndef _RTEMS_NETWORKCONFIG_H_
#define _RTEMS_NETWORKCONFIG_H_

/* #define USE_LIBBSDPORT */

#if defined(USE_LIBBSDPORT)
  #include <bsp/libbsdport_api.h>
  #define CONFIGURE_MAXIMUM_TIMERS 10
#endif
/*
 * For TFTP test application
 */
#if (defined (RTEMS_USE_BOOTP))
#define RTEMS_TFTP_TEST_HOST_NAME "BOOTP_HOST"
#define RTEMS_TFTP_TEST_FILE_NAME "BOOTP_FILE"
#else
#define RTEMS_TFTP_TEST_HOST_NAME "XXX.YYY.ZZZ.XYZ"
#define RTEMS_TFTP_TEST_FILE_NAME "tftptest"
#endif

/*
 * For NFS test application
 * 
 * NFS mount and a directory to ls once mounted
 */
#define RTEMS_NFS_SERVER      "192.168.1.210"
#define RTEMS_NFS_SERVER_PATH "/home"
#define RTEMS_NFS_LS_PATH     "/mnt/nfstest"



/*
 * This file can be copied to an application source dirctory
 * and modified to override the values shown below.
 *
 * The following CPP symbols may be passed from the Makefile:
 *
 *   symbol                   default       description
 *
 *   NETWORK_TASK_PRIORITY    150           can be read by app from public
 *                                          var 'gesysNetworkTaskPriority'
 *   FIXED_IP_ADDR            <undefined>   hardcoded IP address (e.g.,
 *                                          "192.168.0.10"); disables BOOTP;
 *                                          must also define FIXED_NETMASK
 *   FIXED_NETMASK            <undefined>   IP netmask string
 *                                          (e.g. "255.255.255.0")
 *   LO_IF_ONLY               <undefined>   If defined, do NOT configure
 *                                          any ethernet driver but only the
 *                                          loopback interface.
 *   MULTI_NETDRIVER          <undefined>   ugly hack; if defined try to probe
 *                                          a variety of PCI and ISA drivers
 *                                          (i386 ONLY) use is discouraged!
 *   NIC_NAME                 <undefined>   Ethernet driver name (e.g. "pcn1");
 *                                          must also define NIC_ATTACH
 *   NIC_ATTACH               <undefined>   Ethernet driver attach function
 *                                          (e.g., rtems_fxp_attach).
 *                                          If these are undefined then
 *                                            a) MULTI_NETDRIVER is used
 *                                               (if defined)
 *                                            b) RTEMS_BSP_NETWORK_DRIVER_NAME/
 *                                               RTEMS_BSP_NETWORK_DRIVER_ATTACH
 *                                               are tried
 *   MEMORY_CUSTOM            <undefined>   Allocate the defined amount of
 *                                          memory for mbufs and mbuf clusters,
 *                                          respectively. Define to a comma ','
 *                                          separated pair of two numerical
 *                                          values, e.g: 100*1024,200*1024
 *   MEMORY_SCARCE            <undefined>   Allocate few memory for mbufs
 *                                          (hint for how much memory the
 *                                          board has)
 *   MEMORY_HUGE              <undefined>   Allocate a lot of memory for mbufs
 *                                          (hint for how much memory the
 *                                          board has)
 *                                          If none of MEMORY_CUSTOM/
 *                                          MEMORY_SCARCE/MEMORY_HUGE are
 *                                          defined then a medium amount of
 *                                          memory is allocated for mbufs.
 */

#include <rtems/bspIo.h>
#include <bsp.h>
#include <rtems/rtems_bsdnet.h>
#include <rtems/pci.h>

#define MULTI_NETDRIVER

/* Assume we are on qemu unless forced to lab hardware */
#if !defined(ON_RTEMS_LAB_WINSYSTEMS)
#undef ON_QEMU
#define ON_QEMU
#endif

#define FIXED_IP_ADDR "10.0.2.3"
//#define FIXED_IP_ADDR "192.168.1.20"

#if defined(ON_RTEMS_LAB_WINSYSTEMS)
#define FIXED_IP_ADDR "192.168.1.249"
#endif

#define FIXED_NETMASK "255.0.0.0"
//#define FIXED_NETMASK "255.255.255.0"

#ifndef NETWORK_TASK_PRIORITY
#define NETWORK_TASK_PRIORITY   150  /* within EPICS' range */
#endif

/* make publicily available for startup scripts... */
const int gesysNetworkTaskPriority = NETWORK_TASK_PRIORITY;

#ifdef  FIXED_IP_ADDR
#define RTEMS_DO_BOOTP 0
#else
#define RTEMS_DO_BOOTP rtems_bsdnet_do_bootp
#define FIXED_IP_ADDR  0
#undef  FIXED_NETMASK
#define FIXED_NETMASK  0
#endif

#ifdef LO_IF_ONLY
#undef NIC_NAME
#elif !defined(NIC_NAME)

#ifdef MULTI_NETDRIVER

extern int rtems_3c509_driver_attach (struct rtems_bsdnet_ifconfig *, int);
extern int rtems_fxp_attach (struct rtems_bsdnet_ifconfig *, int);
extern int rtems_elnk_driver_attach (struct rtems_bsdnet_ifconfig *, int);
extern int rtems_dec21140_driver_attach (struct rtems_bsdnet_ifconfig *, int);

#if defined(__x86__)
/* these don't probe and will be used even if there's no device :-( */
extern int rtems_ne_driver_attach (struct rtems_bsdnet_ifconfig *, int);
extern int rtems_wd_driver_attach (struct rtems_bsdnet_ifconfig *, int);

static struct rtems_bsdnet_ifconfig isa_netdriver_config[] = {
  {
  	//"ne1", rtems_ne_driver_attach, 0, irno: 9 /* qemu cannot configure irq-no :-(; has it hardwired to 9 */
  	"ne1", rtems_ne_driver_attach, 0, 0,0,0,0,0,0,0,0, 9,0,0 /* qemu cannot configure irq-no :-(; has it hardwired to 9 */
  },
};
#endif

static const char *etc_hosts[] =
{
  "/etc/hosts",
  "127.0.0.1     localhost\n",

  /* IMPORTANT NOTE: *** CHANGE THIS TO MATCH YOUR ENVIRONMENT ****  */
  /*
   * replace this with the IP and HOSTANE of target used above.
   */
  "10.0.2.2  rtems\n",

  /* name of the host where the omniNames runs */
  "10.0.2.2   omniNames\n",
  0
};

static int pci_check(struct rtems_bsdnet_ifconfig *ocfg, int attaching)
{
struct rtems_bsdnet_ifconfig *cfg;
#if defined(__x86__)
int if_index_pre;
extern int if_index;
  if ( attaching ) {
  	cfg = isa_netdriver_config;
  }
  while ( cfg ) {
  	printk("Probing '%s'", cfg->name);
  	/* unfortunately, the return value is unreliable - some drivers report
  	 * success even if they fail.
  	 * Check if they chained an interface (ifnet) structure instead
  	 */
  	if_index_pre = if_index;
  	cfg->attach(cfg, attaching);
  	if ( if_index > if_index_pre ) {
  		/* assume success */
  		printk(" .. seemed to work\n");
  		ocfg->name   = cfg->name;
  		ocfg->attach = cfg->attach;
  		return 0;
  	}
  	printk(" .. failed\n");
  	cfg = cfg->next;
  }
#endif
  return -1;
}

#define  HOST_OMNINAMES_HOST_NAME     "omniNames_host"
#define  HOST_OMNINAMES_PORT_NUMBER   "6000"

#define NIC_NAME   "dummy"
#define NIC_ATTACH pci_check

#else

#if defined(RTEMS_BSP_NETWORK_DRIVER_NAME)  /* Use NIC provided by BSP */
# define NIC_NAME   RTEMS_BSP_NETWORK_DRIVER_NAME
# define NIC_ATTACH RTEMS_BSP_NETWORK_DRIVER_ATTACH
#endif

#endif /* ifdef MULTI_NETDRIVER */

#endif /* ifdef LO_IF_ONLY */

#ifdef NIC_NAME

//extern int NIC_ATTACH();


static struct rtems_bsdnet_ifconfig netdriver_config[1] = {{
  NIC_NAME,  /* name */
  (int (*)(struct rtems_bsdnet_ifconfig*,int))NIC_ATTACH,  /* attach function */
  0,  		/* link to next interface */
  FIXED_IP_ADDR,
  FIXED_NETMASK
}};
#else
#ifndef LO_IF_ONLY
#warning "NO KNOWN NETWORK DRIVER FOR THIS BSP -- YOU MAY HAVE TO EDIT rtems_netconfig.c"
#endif
#endif

extern void rtems_bsdnet_loopattach();
static struct rtems_bsdnet_ifconfig loopback_config = {
    "lo0",                          /* name */
    (int (*)(struct rtems_bsdnet_ifconfig *, int))rtems_bsdnet_loopattach, /* attach function */
#ifdef NIC_NAME
    netdriver_config,               /* link to next interface */
#else
    0,                              /* link to next interface */
#endif
    "127.0.0.1",                    /* IP address */
    "255.0.0.0",                    /* IP net mask */
};

struct rtems_bsdnet_config rtems_bsdnet_config = {
    &loopback_config,         /* Network interface */
#ifdef NIC_NAME
    RTEMS_DO_BOOTP,           /* Use BOOTP to get network configuration */
#else
    0,                        /* Use BOOTP to get network configuration */
#endif
    NETWORK_TASK_PRIORITY,    /* Network task priority */
#if   defined(MEMORY_CUSTOM)
    MEMORY_CUSTOM,
#elif defined(MEMORY_SCARCE)
    100*1024,                 /* MBUF space */
    200*1024,                 /* MBUF cluster space */
#elif defined(MEMORY_HUGE)
    2*1024*1024,              /* MBUF space */
    5*1024*1024,              /* MBUF cluster space */
#else
    180*1024,                 /* MBUF space */
    350*1024,                 /* MBUF cluster space */
#endif
#if (!defined (RTEMS_USE_BOOTP)) && defined(ON_RTEMS_LAB_WINSYSTEMS)
    "rtems",                /* Host name */
    "nodomain.com",         /* Domain name */
    "192.168.1.14",         /* Gateway */
    "192.168.1.1",          /* Log host */
    {"192.168.1.1"  },      /* Name server(s) */
    {"192.168.1.1"  },      /* NTP server(s) */
#else
    "10.0.2.2",               /* Host name */
    "nodomain.com",         /* Domain name */
    "10.0.2.2",             /* Gateway */
    NULL,                   /* Log host */
    { "localhost" },               /* Name server(s) */
    { NULL },               /* NTP server(s) */
#endif /* !RTEMS_USE_BOOTP */
    0,                      /* efficiency */
    0,                      /* udp TX buffer */
    0,                      /* udp RX buffer */
    0,                      /* tcp TX buffer */
    0,                      /* tcp RX buffer */
};
#endif /* _RTEMS_NETWORKCONFIG_H_ */
