
#include <stdio.h>

int main()
{
	float angle = 90;
	float radian, cosine , sine;

	radian = angle / 180 * 3.14159;

	__asm__ ("fsincos"
		: "=t"(cosine),"=u"(sine)
		: "0"(radian));
	
	printf("cos: %f, sin: %f\n",cosine,sine);
	return 0;
}
