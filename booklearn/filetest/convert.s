# lower -> upper
.section .text
.type convert,@function
convert:
	pushl %ebp
	movl %esp,%ebp
	pushl %esi
	pushl %edi
	movl 12(%ebp),%esi
	movl %esi,%edi
	movl 8(%ebp),%ecx
convert_loop:
	lodsb
	cmpb $'a',%al
	jl skip
	cmpb $'z',%al
	jg skip
	subb $0x20,%al
skip:
	stosb
	loop convert_loop
	pop %edi
	pop %esi
	movl %ebp,%esp
	popl %ebp
	ret
