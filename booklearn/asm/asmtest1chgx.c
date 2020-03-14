
#include <stdio.h>

int main()
{
	int data1 = 10;
	int data2 = 10;
	int result;

	__asm__("imull %1, %2\n\t"
		"movl %2, %0"
		: "=r"(result)
		: "r"(data1), "r"(data2));

	printf("Ther result is %d\n",result);
	return 0;
}
