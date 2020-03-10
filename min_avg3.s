.section .data
output: 
	.asciz "The average is %f, the min is %d\n"
outdebug:
	.asciz ":%d\n"
data_items:
	.long 12,4,6,7,80,34,54,46,3,23
count:
	.long 10
first_data:
	.long 12

.section .bss
	.lcomm buffer 20

.section .text
.globl _start
_start:
	movl $0,%edi
	movl data_items(,%edi,4),%ecx
	movl count,%edi
	decl %edi
	movl data_items(,%edi,4),%edx
	movl $0,%edi
	finit
	fildl first_data
loop:
	cmpl %edx,%ebx
	je loop_exit
	incl %edi
	movl data_items(,%edi,4),%ebx
	fiadd data_items(,%edi,4)
	cmpl %ebx,%ecx
	jle loop
	movl %ebx,%ecx
	jge loop
loop_exit:
	fidivl count
	pushl %ecx
	subl $8,%esp
	fstpl (%esp)
	pushl $output
	call printf
	addl $12,%esp
	pushl $0
	call exit
