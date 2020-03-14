
#include <stdio.h>

int main()
{
	int a = 20;
	int b = 50;
	int result;



	__asm__ ("cmp %1,%2\n\t"
		"jge 0f\n\t"
		"movl %1,%0\n\t"
		"jmp 1f\n"
		"0:\n\t"
		"movl %2,%0\n"
		"1:"
		: "=r"(result)
		: "r"(a),"r"(b));
	printf("result: %d\n",result);
	return 0;
}
