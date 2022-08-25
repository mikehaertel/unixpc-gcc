	.globl _exit
_exit:
	movel #1, %d0
	trap #0
	jmp _exit
