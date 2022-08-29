/*
 * udivsi3.c - 32-bit 2s-complement unsigned integer division
 * Portable version of __udivsi3() function needed by GCC.
 */

#include <signal.h>

#ifdef __unixpc__
extern int raise(int signo);
#endif

unsigned int
__udivsi3(unsigned int n, unsigned int d)
{
	if (d != 0) {
		int q = 0, qshift = 0;
		while ((int) d > 0 && n > d)
			d += d, ++qshift;
		for (;;) {
			if (n >= d)
				n -= d, q++;
			if (qshift == 0)
				break;
			d >>= 1;
			q <<= 1;
			--qshift;
		}
		return q;
	} else {
		return raise(SIGFPE);
	}
}
