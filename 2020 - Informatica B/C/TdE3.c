#include <stdio.h>
#define N 100

main ()
{
	int nRighe, nCol, m[N][N], i, j, t;
	
printf ("Inserisci nRighe: ");
scanf ("%d" , &nRighe);

while (nRighe<0 || nRighe>N || nRighe%2==1)
{
	printf ("Reinserisci nRighe: ");
	scanf ("%d" , &nRighe);
}

printf ("Inserisci nCol: ");
scanf ("%d" , &nCol);

while (nCol<0 || nCol>N || nCol%2==1)
{
	printf ("Reinserisci nCol: ");
	scanf ("%d" , &nCol);
}

for (i=0; i<nRighe; i++)
{
	for (j=0; j<nCol; j++)
	{
		printf ("Inserisci l'elemento di riga %d e colonna %d: ", i, j);	
		scanf ("%d", &m[i][j]);
	}
}

for (i=0; i<nRighe; i=i+2)
{
	for (j=0; j<nCol; j=j+2)
	{
		if ((m[i][j]+m[i+1][j]+m[i][j+1]+m[i+1][j+1])/4>10)
			t++;
	}
}

printf ("Il valore della matrice e': %d", t);

printf ("\n\n");
system ("PAUSE");
return 0;
}

