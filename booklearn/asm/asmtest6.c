#include <stdio.h>

#define GREATER(a,b,result) ({ \
	__asm__ ("cmp %1,%2\n\t" \
		"jge 0f\n\t" \
		"movl %1,%0\n\t" \
		"jmp 1f\n" \
		"0:\n\t" \
		"movl %2,%0\n" \
		"1:" \
		: "=r"(result) \
		: "r"(a),"r"(b));})
int main()
{
	int data1 = 10;
	int data2 = 20;
	int result;

	GREATER(data1,data2,result);
	printf("result: %d\n",result);
	return 0;
}
