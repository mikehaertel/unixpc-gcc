#include "storeArg.h"

#define nativeop concat(db,op,__)
#define gnuop concat(__,op,df3)

double nativeop (double b);
double gnuop (double a, double b) {
	store_double(a);
	return nativeop(b);
}
