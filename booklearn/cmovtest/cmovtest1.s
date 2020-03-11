.section .data
output: .asciz "The max is %d\n"
values: .long 105,235,64

.section .text
.globl _start
_start:
	nop
	movl values,%ebx
	movl $1,%edi
loop:
	movl values(,%edi,4) ,%eax
	cmp %ebx,%eax
	cmovb %eax, %ebx # if eax >= ebx change
	inc %edi
	cmp $3,%edi
	jne loop
	pushl %ebx
	pushl $output
	call printf
	add $8,%esp
	pushl $0
	call exit 
