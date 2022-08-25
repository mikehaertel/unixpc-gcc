#include "exit.h"

void (*_exitfuncs[33])();
unsigned int _nexitfunc;

void
exit(int status)
{
	while (_nexitfunc)
		(*_exitfuncs[--_nexitfunc])();
	_cleanup();
	_exit(status);
}
