#
# initial stack image of new process on Unix PC (from high to low addresses)
#	lowest address just beyond user-accessible memory = 0x300000
#		possible \0 bytes
#		last env string \0
#		...
#		first env string \0
#		last arg string \0
#		...
#		first arg string \0
#		>=4 \0 bytes (null pointer)
#		4-byte pointer to last env string
#		...
#		4-byte pointer to first env string
#		4 \0 bytes (null pointer)
#		4-byte pointer to last arg string
#		...
#		4-byte pointer to first arg string
#		4-byte count of args
#	sp points here (4-byte aligned)
#
	.globl _start
_start:
	movel %sp@+, %d0	;# int argc = *sp++
	movel %sp, %a0		;# char *argv = sp
	movel %d0, %d1		;# temp = argc
	lsll #2, %d1		;# temp *= sizeof (char *)
	leal %a0@(4,%d1), %a1	;# char *envp = argv + argc + 1
	movel %a1, environ	;# environ = envp
	movel %a1, %sp@-	;# push envp
	movel %a0, %sp@-	;# push argv
	movel %d0, %sp@-	;# push argc
	jbsr main		;# call main(argc, argv, envp)
	movel %d0, %sp@		;# arg for "just in case" manual exit syscall
	movel %d0, %sp@-	;# arg for normal C library exit()
	jbsr exit		;# exit(main(...)) (not supposed to return...)
1:	moveql #1, %d0		;# just in case it did: set up manual exit
	trap #0			;# system call [also not supposed to return!]
	jmp 1b			;# keep trying forever
	.comm environ, 4
	.comm errno, 4
