.section .bss
	.lcomm status,2
.section .text
.globl _start
_start:
	nop
	# fstsw 用于读取状态寄存器（16bits）到双字内存位置
	fstsw %ax
	fstsw status

	movl $1,%eax
	movl $0,%ebx
	int $0x80
