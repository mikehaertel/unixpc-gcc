extern int kill(int, int);
extern int getpid(void);

int
raise(int sig)
{
	return kill(getpid(), sig);
}
