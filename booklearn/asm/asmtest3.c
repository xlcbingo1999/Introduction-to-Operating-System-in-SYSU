#include <stdio.h>

int main()
{
	int dividend = 20;
	int divisor = 5;
	int result;

	__asm__ ("divb %2\n\t"
		"movl %%eax, %0"
		: "=m"(result)
		: "a"(dividend),"m"(divisor));
	// dividend < 65536 divisor < 256
	printf("result: %d\n",result);
	return 0;
}
