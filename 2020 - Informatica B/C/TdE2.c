#include <stdio.h>
#define MAX 20
main ()
{
	char p1[MAX], p2[MAX], descr[2*MAX+1];
	int i = 0, j = 0;
	

	printf ("Inserisci la prima stringa:");
	scanf ("%s", p1);
	printf ("Inserisci la seconda stringa:");
	scanf ("%s", p2);
	
	while (p1[i]!='\0')
	{
		descr[i]=p1[i];
		i++;
	}
	
	descr[i++] = ',';
	
	while (p2[j]!='\0')
	{
		descr[i]=p2[j];
		i++;
		j++;
	}
	
	descr[i]='\0';
	
	printf ("\nLa stringa descrizione e': %s", descr);
	
	
printf ("\n\n");
system ("PAUSE");
return 0;
}

