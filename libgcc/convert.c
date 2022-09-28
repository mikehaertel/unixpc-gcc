#include "storeArg.h"

#define CONVERT concat(CONVERT_,op,)
#define CONVERT_extendsfdf2 fltodb__
#define CONVERT_truncdfsf2 dbtofl__
#define CONVERT_fixsfsi fltol__
#define CONVERT_fixdfsi dbtol__
#define CONVERT_floatsisf ltofl__
#define CONVERT_floatsidf ltodb__

#define FROMTYPE concat(FROMTYPE_,op,)
#define FROMTYPE_extendsfdf2 float
#define FROMTYPE_truncdfsf2 double
#define FROMTYPE_fixsfsi float
#define FROMTYPE_fixdfsi double
#define FROMTYPE_floatsisf int
#define FROMTYPE_floatsidf int

#define TOTYPE concat(TOTYPE_,op,)
#define TOTYPE_extendsfdf2 double
#define TOTYPE_truncdfsf2 float
#define TOTYPE_fixsfsi int
#define TOTYPE_fixdfsi int
#define TOTYPE_floatsisf float
#define TOTYPE_floatsidf double

TOTYPE CONVERT ();

TOTYPE concat(__,op,) (FROMTYPE in) {
	concat(store_,FROMTYPE,) (in);
	return CONVERT ();
}
