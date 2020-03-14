# lower to upper case
.section .data
string1: .asciz "This is a TEST\n"
len: .int 15
.section .text
.globl _start
_start:
	nop
	leal string1,%esi
	movl %esi,%edi
	movl len,%ecx
	cld
loop:
	lodsb
	cmpb $'a',%al
	jl skip
	cmpb $'z',%al
	jg skip
	subb $0x20,%al
skip:
	stosb
	loop loop
end:
	pushl $string1
	call printf
	addl $4,%esp
	pushl $0
	call exit
