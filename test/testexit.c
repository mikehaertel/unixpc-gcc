#include <stdio.h>

extern int printf(const char *, ...);
extern void atexit(void (*)(void));

static void
hello()
{
	printf("hello, ");
}

static void
world()
{
	printf("world ");
}

static void
via_atexit()
{
	printf("(via atexit)\n");
}

int
main()
{
	atexit(via_atexit);
	atexit(world);
	atexit(hello);
	return 0;
}
