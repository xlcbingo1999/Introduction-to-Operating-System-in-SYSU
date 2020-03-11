.section .data
values: .long 10,15,20,30

.section .text
.globl _start
_start:
	nop
	movl values,%eax
	movl $values,%edi
	movl $100,4(%edi)
	movl $1,%edi
	movl values(,%edi,4),%ebx
	movl $1,%eax
	int $0x80
