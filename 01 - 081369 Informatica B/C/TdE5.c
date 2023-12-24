#include <stdio.h>

#define MAX_TRASPORTI 100
#define NUM_DIPENDENTI 10

typedef char stringa[100];

typedef enum{falso, vero} boolean;

typedef struct {
 stringa destinazione;
 boolean trasportoSpeciale; /* Un trasporto è speciale se si movimentano prodotti
 velenosi o molto pesanti o di grandi dimensioni */
 float numeroKm; /* Indica il numero di Km che è necessario percorrere per portare il
 carico a destinazione e tornare indietro alla sede dell’azienda */
} Trasporto;

typedef struct{
 stringa nome;
 stringa cognome;
 int kmPerLitro; /*indica quanti km in media percorre con un litro di carburante*/
 int numTrasportiEffettuati;
 Trasporto listaTrasporti[MAX_TRASPORTI];
} Camionista;

main ()
{
	int totkm, i, j;
	Camionista dipendentiNormali[NUM_DIPENDENTI];
	Camionista dipendenti[NUM_DIPENDENTI];
	float litriConsumati[NUM_DIPENDENTI];

	for (i=0;i<NUM_DIPENDENTI;i++)
	{
		totkm=0;
		for(j=0;j<dipendenti[i].numTrasportiEffettuati;j++)
			totkm += dipendenti[i].listaTrasporti[j].numeroKm;
		litriConsumati[i] = totkm/dipendenti[i].kmPerLitro;
	}
	
	j=0;
	for (i=0;i<NUM_DIPENDENTI;i++)
	{
		int flag=1;
		for(j=0;j<dipendenti[i].numTrasportiEffettuati;j++)
		{
			if (dipendenti[i].listaTrasporti[j].trasportoSpeciale==falso)
				{
					dipendentiNormali[j]=dipendenti[i];
					j++;
				}
		}
	}
	
	printf ("\n%d Dipendenti non hanno mai fatto trasporti speciali:\n", j);
	for (i=0; i<j;i++)
	{
		printf ("%s %s", dipendentiNormali[j].nome, dipendentiNormali[j].cognome);
	}


printf ("\n\n");
system ("PAUSE");
return 0;
}

