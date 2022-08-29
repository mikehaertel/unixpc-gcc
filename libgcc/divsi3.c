/*
 * divsi3.c - 32-bit 2s-complement signed integer division
 * Portable version of __divsi3() function needed by GCC.
 */

#include <signal.h>

#ifdef __unixpc__
extern int raise(int signo);
#endif

int
__divsi3(int nn, int dd)
{
	unsigned int n = nn, d = dd;
	if (d != 0) {
		int q = 0, qinc = 1, qshift = 0;
		if ((int) n < 0)
			n = -n, qinc = -qinc;
		if ((int) d < 0)
			d = -d, qinc = -qinc;
		while (n > d)
			d += d, ++qshift;
		for (;;) {
			if (n >= d)
				n -= d, q += qinc;
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
