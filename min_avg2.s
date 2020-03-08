

.section .data
output: 
	.asciz "The min is %d, the average is %f\n"
data_items:
	.long 12,4,6,7,80,34,54,46,3,23
values:
#	.float 12.0,4.0,6.0,7.0,8.0,34.0,103.0
	.float 12.0,4.0,6.0,7.0,8.0,34.0,54.0,46.0,3.0,23.0
count:
	.float 10.0
result:
	.double 0.0

.section .bss
	.lcomm buffer 256

.section .text
.globl _start
_start:
	movl $0,%edi
	movl data_items(,%edi,4) , %eax
	movl %eax,%edx
start_min_loop:
	cmpl $23,%eax
	je min_loop_exit
	incl %edi
	movl data_items(,%edi,4),%eax
	cmpl %edx,%eax
	jge start_min_loop

	movl %eax,%edx
#	movl %edx,16(%edx)
	jmp start_min_loop

min_loop_exit:
	leal values,%ebx
	flds 40(%ebx)
	flds 36(%ebx)
	flds 32(%ebx)
	flds 28(%ebx)
	flds 24(%ebx)
	flds 20(%ebx)
	flds 16(%ebx)
	flds 12(%ebx)
	flds 8(%ebx)
	flds 4(%ebx)
	leal count,%eax
	flds (%ebx)

	faddp
	faddp
	faddp
	faddp
	faddp
	faddp
	faddp
	faddp
	faddp
	fdivp %st(0), %st(1)
	
	fstl result
	leal result,%ebx

	pushl 4(%ebx)
	pushl %ebx
	pushl %edx
#	pushl 16(%edx)
	pushl $output
	call printf
	
	pushl $0
	call exit
