#define NEXITFUNC 33 /* POSIX specified 32 + 1 extra for GCC __do_global_dtors */

extern void atexit(void (*)());
extern void exit(int);
extern void (*_exitfuncs[])();
extern unsigned int _nexitfunc;
extern void _cleanup();
extern void _exit(int);
