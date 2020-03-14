.section .data
va1: .ascii "ABCdDDDDDXXXx"
va2: .ascii "ABCDDDDDDXXXx"
.section .text
.globl _start
_start:
	nop
	movl $1,%eax
	lea va1,%esi
	leal va2,%edi
	movl $13,%ecx
	cld
	repe cmpsb
	je equal
	movl %ecx,%ebx
	int $0x80
equal:
	movl $0,%ebx
	int $0x80

