
.section .data
output: 
	.asciz "The count of number is %d,the average is %d, the min is %d\n"
data_items:
	.long 12,4,6,7,80,34,54,46,3,23

.section .bss
	.lcomm buffer 48

.section .text
.globl _start
_start:
	movl $0,%edi
	movl data_items(,%edi,4) , %eax
	movl $0,%ebx

start_avg_loop:
	addl %eax,%ebx
	incl %edi
	cmpl $23,%eax
	je avg_loop_exit
	movl data_items(,%edi,4),%eax
	jmp start_avg_loop

avg_loop_exit:
	movl %ebx,%eax
	movl $0,%edx
	divl %edi
	movl %ebx,%edx
	movl %eax,%ebx
	movl $0,%edi
	movl data_items(,%edi,4),%eax
	movl %eax,%ecx

start_min_loop:
	cmpl $23,%eax
	je min_loop_exit
	incl %edi
	movl data_items(,%edi,4),%eax
	cmpl %ecx,%eax
	jge start_min_loop

	movl %eax,%ecx
	jmp start_min_loop

min_loop_exit:
	pushl %ecx
	pushl %ebx
	pushl %edx
	pushl $output
	call printf
	
	pushl $0
	call exit
