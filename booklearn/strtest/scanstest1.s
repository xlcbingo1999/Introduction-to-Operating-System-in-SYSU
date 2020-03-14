
.section .data
str1: .asciz "Testing, one, two\n"
len1: .int 18
str2: .ascii "z"
.section .text
.globl _start
_start:
	nop
	leal str1,%edi
	leal str2,%esi
	movl len1,%ecx
	lodsb
	cld
	repne scasb # compare %al with %edi
	jne notfound
	subw len1,%cx
	neg %cx
	movl $1,%eax
	movl %ecx,%ebx
	int $0x80
notfound:
	movl $1,%eax
	movl $0,%ebx
	int $0x80
	
