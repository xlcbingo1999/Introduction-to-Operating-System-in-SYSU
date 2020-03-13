.section .data
newvalue: .byte 0x7f,0x00 #小尾数
.section .bss
	.lcomm control,2
.section .text
.globl _start
_start:
	nop
	fstcw control #获得设置存到control
	fldcw newvalue # 加载设置到控制寄存器
	fstcw control # 检查当前控制寄存器的值
	movl $1,%eax
	movl $0,%ebx
	int $0x80
