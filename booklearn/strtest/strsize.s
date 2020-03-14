.section .data
str1: .asciz "Testing, one, two\n"
.section .text
.globl _start
_start:
	nop
	leal str1,%edi
	movl $0xffff,%ecx
	movb $0,%al
	cld
	repne scasb # compare %al with %edi
	jne notfound
	subw $0xffff,%cx
	neg %cx
	dec %cx
	movl $1,%eax
	movl %ecx,%ebx
	int $0x80
notfound:
	movl $1,%eax
	movl $0,%ebx
	int $0x80
	
