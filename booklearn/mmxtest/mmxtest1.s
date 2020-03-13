#MMX data
.section .data
value1: .int 1,-1
value2: .byte 0x10,0x05,0xff,0x32,0x47,0xe4,0x00,0x01
.section .text
.globl _start
_start:
	nop
	movq value1,%mm0
	movq value2,%mm1
	movl $1,%eax
	movl $0,%ebx
	int $0x80
