
.section .data
value1: .float 12.0
value2: .float 4.0
value3: .float 6.0
value4: .float 7.0
value5: .float 80.0
value6: .float 34.0
value7: .float 54.0
value8: .float 46.0
value9: .float 3.0
value10: .float 23.0
count: .int 10
output: .asciz "The min is,the avg is %f\n"

.section .text
.globl _start
_start:
nop
	finit
	flds value1
	flds value2
	faddp
	flds value3
	faddp
	flds value4
	faddp
	flds value5
	faddp
	flds value6
	faddp
	flds value7
	faddp
	flds value8
	faddp
	flds value9
	faddp
	flds value10
	faddp
	fidiv count
	subl $8,%esp
	fstpl (%esp)
	pushl $output
	call printf
	add $12,%esp
	pushl $0
	call exit
