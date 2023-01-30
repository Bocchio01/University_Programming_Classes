#include <stdio.h>
#include <time.h>
#include <math.h>
#define N 10
typedef enum {vero,falso} bool;
main (){
	int a[N],i,t;
	bool controllo=vero;

printf ("Inserisci l'array:");
	for (i=0;i<N;i++)
		scanf ("%d",&a[i]);

while (controllo==vero){
	controllo=falso;
	for (i=0;i<N-1;i++){
		if(a[i]>a[i+1]){
			t=a[i+1];
			a[i+1]=a[i];
			a[i]=t;
			controllo=vero;
		}
	}
}

for (i=0;i<N;i++)
	printf ("%d ", a[i]);

printf ("\n\n");
system ("PAUSE");
return 0;}

