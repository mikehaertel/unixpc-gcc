/*
 * Test program to show that the C startup is passing command line arguments
 * and initializing environ correctly.
 */

#include <stdio.h>

/* remedial declarations for ancient C library */
extern int printf(const char *, ...);
extern void exit(int);
extern char **environ;

int
main(int argc, char **argv, char **envp)
{
	int i;
	printf("main: argc=%d argv=0x%08X envp=0x%08X environ=%08X\n",
	       argc, (unsigned) argv, (unsigned) envp, (unsigned) environ);
	for (i = 0; i < argc; ++i)
		printf("argv[%d] = 0x%08X = \"%s\"\n",
		       i, (unsigned) argv[i], argv[i]);
	for (i = 0; envp[i]; ++i)
		printf("envp[%d] = 0x%08X = \"%s\"\n",
		       i, (unsigned) envp[i], envp[i]);
	exit(0);
}
