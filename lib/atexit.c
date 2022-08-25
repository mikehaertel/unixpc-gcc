#include "exit.h"

void
atexit(void (*f)())
{
	if (_nexitfunc < NEXITFUNC)
		_exitfuncs[_nexitfunc++] = f;
}
