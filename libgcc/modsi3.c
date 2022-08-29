/*
 * modsi3.c - 32-bit 2s-complement signed integer remainder
 * Portable version of __modsi3() function needed by GCC.
 */

#include <signal.h>

#ifdef __unixpc__
extern int raise(int signo);
#endif

int
__modsi3(int nn, int dd)
{
	unsigned int n = nn, d = dd;
	if (d != 0) {
		int m = (int) n < 0, qshift = 0;
		if (m)
			n = -n;
		if ((int) d < 0)
			d = -d;
		while (n > d)
			d += d, ++qshift;
		for (;;) {
			if (n >= d)
				n -= d;
			if (qshift == 0)
				break;
			d >>= 1;
			--qshift;
		}
		return m ? -n : n;
	} else {
		return raise(SIGFPE);
	}
}
