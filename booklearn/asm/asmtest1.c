#include <stdio.h>

int main()
{
	int data1 = 10;
	int data2 = 10;
	int result;

	__asm__("imull %%edx, %%ecx\n\t"
		"movl %%ecx, %%eax"
		: "=a"(result)
		: "d"(data1), "c"(data2));

	printf("Ther result is %d\n",result);
	return 0;
}
