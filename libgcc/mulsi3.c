/*
 * mulsi3.c - 32-bit 2s-complement signed/unsigned integer multiply
 * 68000-specific version of __mulsi3() function needed by GCC.
 */

unsigned int
__mulsi3(unsigned int x, unsigned int y)
{
	/* Here we are assuming a native 16x16 -> 32 multiply. */
	unsigned int t = (unsigned short) x * (unsigned short) y;
	t += (unsigned short) (x >> 16) * (unsigned short) y << 16;
	t += (unsigned short) x * (unsigned short) (y >> 16) << 16;
	return t;
}
