
.section .rodata
prompt:
   .asciz "enter an integer: "
output:
   .asciz "your input is %d and %d.\n"
format:
   .asciz "%d,%d"

.section .data
num1:
   .int 0
num2:
   .int 0

.section .text
.globl _start
_start:
   pushl $prompt
   call  printf
   addl  $4, %esp

   pushl $num2
   pushl $num1
   pushl $format
   call  scanf
   addl  $12, %esp

   pushl num2
   pushl num1
   pushl $output
   call  printf
   addl  $12, %esp

   pushl $0
   call  exit
