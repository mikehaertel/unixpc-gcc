#define _concat(a,b,c) a ## b ## c
#define concat(a,b,c) _concat(a,b,c)

union dbl {
	struct i {
		long hi;
		long lo;
	} i;
	double d;
};

static inline void store_double(double a) {
	union dbl d;
	d.d = a;
	asm volatile("movel %0,%%d0\n"
	    "movel %1,%%d1\n"
	    : 
	    : "g"( d.i.hi ),"g"( d.i.lo )
	    );
}

static inline void store_float(float a) {
	asm volatile("movel %0,%%d0\n"
	    : 
	    : "g"( a)
	    );
}

static inline void store_int(int a) {
	asm volatile("movel %0,%%d0\n"
	    : 
	    : "g"( a)
	    );
}
