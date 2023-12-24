#include <stdio.h>
int main() {
 float f;
 int i;

 f = 0.4000000;

 for (i = 1; i < 20; i++)
 {
 	f += 0.40000000;
	printf ("\n %f", f);
}

 printf("\n\nIl numero 0.4 * 20 ");
 if (f != 8.0) printf("non ");
 printf("e' uguale a %f\n\n", 8.0);

 return 0;
}
