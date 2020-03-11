# 小尾数变成大尾数
.section .text
.globl _start
_start:
	nop
	movl $0x12345678,%ebx
	bswap %ebx
	movl $1,%eax
	int $0x80
