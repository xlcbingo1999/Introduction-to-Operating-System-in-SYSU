.section .text
.globl _start
_start:
	movl $1,%eax
	movl $4,%ebx
	subl $3,%ebx
	jp overhere #1'number is even? 1: 0
	int $0x80
overhere:
	movl $100,%ebx
	int $0x80
