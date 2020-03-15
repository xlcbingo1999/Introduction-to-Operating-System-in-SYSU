.section .bss
	.lcomm buffer,10
	.lcomm infilehandle,4
	.lcomm outfilehandle,4
	.lcomm size,4
.section .text
.globl _start
_start:
	#input file 1
	movl %esp,%ebp
	movl $5,%eax
	movl 8(%ebp),%ebx
	movl $00,%ecx
	movl $0444,%edx
	int $0x80
	test %eax,%eax
	js badfile
	movl %eax,infilehandle
	# output file 2
	movl $5,%eax
	movl 12(%ebp),%ebx
	movl $01101,%ecx
	movl $0644,%edx
	int $0x80
	test %eax,%eax
	js badfile
	movl %eax,outfilehandle

read_loop:
	movl $3,%eax
	movl infilehandle,%ebx
	movl $buffer,%ecx
	movl $10,%edx
	int $0x80
	test %eax,%eax
	jz done
	js done
	movl %eax,size

	pushl $buffer
	pushl size
	call convert
	addl $8,%esp

	movl $4,%eax
	movl outfilehandle,%ebx
	movl $buffer,%ecx
	movl size,%edx
	int $0x80
	test %eax,%eax
	js badfile
	jmp read_loop
done:
	movl $6,%eax
	movl infilehandle,%ebx
	int $0x80
badfile:
	movl %eax,%ebx
	movl $1,%eax
	int $0x80

.type convert,@function
convert:
	pushl %ebp
	movl %esp,%ebp
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
	movl %ebp,%esp
	popl %ebp
	ret
