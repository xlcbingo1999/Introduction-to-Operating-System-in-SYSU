.section .data
#	values: .float 12.0,13.0,14.0,15.0
	values: .float 12,13,14,15
	beichu: .float 4.0
	result: .double 0.0
	outstring: .asciz "a is %d,result is %f\n"

.section .text
.globl _start
_start:
	movl $4,%edx

	leal values,%ebx
	flds 16(%ebx)
	flds 12(%ebx)
	flds 8(%ebx)
	flds 4(%ebx)
	leal beichu,%eax
	flds (%ebx)

	faddp
	faddp
	faddp
	fdivp %st(0), %st(1)
	
	fstl result

	leal result,%ebx
	pushl 4(%ebx)
	pushl (%ebx)
	pushl %edx
	pushl $outstring
	call printf
	pushl $0
	call exit
