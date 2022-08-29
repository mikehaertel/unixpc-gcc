/*
 * umodsi3.c - 32-bit 2s-complement unsigned integer remainder
 * Portable version of __umodsi3() function needed by GCC.
 */

#include <signal.h>

#ifdef __unixpc__
extern int raise(int signo);
#endif

unsigned
__umodsi3(unsigned int n, unsigned int d)
{
	if (d != 0) {
		int qshift = 0;
		while ((int) d > 0 && n > d)
			d += d, ++qshift;
		for (;;) {
			if (n >= d)
				n -= d;
			if (qshift == 0)
				break;
			d >>= 1;
			--qshift;
		}
		return n;
	} else {
		return raise(SIGFPE);
	}
}
