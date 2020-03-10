

.section .rodata
prompt:
   	.asciz "enter an integer: "
output:
   	.asciz "The avg is %d.\n"
format:
   	.asciz "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d"

.section .data
num1:
   	.int 0
num2:
   	.int 0
num3:
   	.int 0
num4:
	.int 0
num5:
	.int 0
num6:
	.int 0
num7:
	.int 0
num8:
	.int 0
num9:
	.int 0
num10:
	.int 0

.section .text
.globl _start
_start:
   	pushl $prompt
   	call  printf
   	addl  $4, %esp
	
	pushl $num10
	pushl $num9
	pushl $num8
	pushl $num7
	pushl $num6
	pushl $num5
	pushl $num4
	pushl $num3
   	pushl $num2
  	pushl $num1
   	pushl $format
   	call  scanf
   	addl  $48, %esp

   	movl num1,%eax
	movl num2,%ebx
	addl %ebx,%eax
	movl num3,%ebx
	addl %ebx,%eax
	movl num4,%ebx
	addl %ebx,%eax
	movl num5,%ebx
	addl %ebx,%eax
	movl num6,%ebx
	addl %ebx,%eax
	movl num7,%ebx
	addl %ebx,%eax
	movl num8,%ebx
	addl %ebx,%eax
	movl num9,%ebx
	addl %ebx,%eax
	movl num10,%ebx
	addl %ebx,%eax
	movl $10,%ecx
	div %ecx
	pushl %eax
   	pushl $output
   	call  printf
   	addl  $8, %esp

   	pushl $0
   	call  exit
