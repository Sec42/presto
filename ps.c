#if 0
static char copyright[] =
"@(#) Copyright (c) 1990, 1993, 1994\n\
	The Regents of the University of California.  All rights reserved.\n";

static char sccsid[] = "@(#)ps.c	8.4 (Berkeley) 4/2/94";
#endif /* not lint */

#include <sys/param.h>
#include <sys/user.h>
#include <sys/resource.h>
#include <sys/proc.h>
#include <sys/stat.h>
#include <sys/sysctl.h>

#include <ctype.h>
#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <kvm.h>
#include <paths.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

pid_t target_pid = -1;
uid_t target_euid = 0;
uid_t target_ruid = 0;
char * target_kmem = "/dev/kmem";
int target_debug = 0;

static void usage()
{

	(void)fprintf(stderr,
	    "usage:\t%s\n",
	    "presto [-p pid] [-u uid] [-e euid] [-M /dev/kmem]");
	exit(1);
}

kvm_t *kd;

int
main(argc, argv)
	int argc;
	char *argv[];
{
	struct kinfo_proc *kp;
	int all, nentries;
	int ch;
	char errbuf[256];

	target_pid=getppid();

	while ((ch = getopt(argc, argv,
	    "hdM:p:e:u:")) != EOF)
		switch((char)ch) {
		case 'M':
			target_kmem = optarg;
			break;
		case 'd':
			target_debug++;
			break;
		case 'u':
			target_ruid = atol(optarg);
		case 'e':
			target_euid = atol(optarg);
			break;
		case 'p':
			target_pid = atol(optarg);
			break;
		case '?':
		default:
			usage();
		}
	argc -= optind;
	argv += optind;

	if(target_debug)printf("target:\n\tpid=%ld\n\tkmem=%s\n\truid=%ld\n\teuid=%ld\n",target_pid,target_kmem,target_ruid,target_euid);

	all=1;
	kd = kvm_openfiles(NULL, NULL, NULL, O_RDONLY, errbuf);
	if (kd == 0)
		errx(1, "%s", errbuf);

	if ((kp = kvm_getprocs(kd, KERN_PROC_ALL, 0, &nentries)) == 0)
		errx(1, "%s", kvm_geterr(kd));

	exit(0);
}

