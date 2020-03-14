# rep 指令 按块传输保证不会界越
.section .data
string1: .asciz "This is a test of the conversion program!\n"
len: .int 43
divisor: .int 4
.section .bss
	.lcomm buffer,43
.section .text
.globl _start
_start:
	nop
	leal string1,%esi
	leal buffer,%edi
	movl len,%ecx
	shrl $2,%ecx

	cld
	rep movsl
	movl len,%ecx
	andl $3,%ecx
	rep movsb

	movl $1,%eax
	movl $0,%ebx
	int $0x80
