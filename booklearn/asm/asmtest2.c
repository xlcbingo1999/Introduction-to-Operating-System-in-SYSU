
// 注意volatile不可以省略
#include <stdio.h>

int main()
{
	char input[30] = {"This is a test message.\n"};
	char output[30];
	int length = 25;

	__asm__ __volatile__("cld\n\t"
			"rep movsb"
			:
			: "S"(input),"D"(output),"c"(length));
	printf("%s",output);
	return 0;
}
