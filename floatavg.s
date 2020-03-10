.code32
.section .data
#	values: .float 1.2,2.3,4.5,6.5,9.5,12.0,13.0,14.0,15.0
#	values: .float 12,13,14,15
	values: .float 1.2,2.3
	beichu: .float 4.0
#	result: .double 0.0
	outstring: .asciz "result is %f\n"

.section .text
.globl _start
_start:
	movl $4,%edx

	leal values,%ebx
	flds 8(%ebx)
	flds 4(%ebx)
	faddp
	flds beichu
	fdivrp
	
	subl $8,%esp
	fstpl %esp
	pushl $outstring
	call printf
	addl $12,%esp
	pushl $0
	call exit
