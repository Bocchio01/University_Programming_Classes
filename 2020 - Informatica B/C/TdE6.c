#include <stdio.h>

#define MAXESAMI 30

typedef char stringa[15];

typedef struct {
 char codiceCorso[10];
 stringa nomeCorso;
 int voto;
} esame;

typedef struct{
 char matricola[8];
 stringa cognome;
 stringa nome;
stringa corsoDiLaurea;
int numEsamiSuperati;
esame ElencoEsamiSuperati[MAXESAMI];
} studente;

main ()
{
	int i, j;
	float sommaVoti, mediaVoti;
	studente InsiemeStudenti[1000];

	printf ("Studenti con una media > 25:");
	for(i=0;i<1000;i++)
	{
		sommaVoti = 0;
		for(j=0;j<InsiemeStudenti[i].numEsamiSuperati;j++)
			sommaVoti += InsiemeStudenti[i].ElencoEsamiSuperati[j].voto;
		mediaVoti = (sommaVoti / InsiemeStudenti[i].numEsamiSuperati);
		
		if (mediaVoti>25)
			printf ("\n-\tMatricola: %s\n%tNome: %s\n%tCognome: %s\n%tMedia voti: %f\n", InsiemeStudenti[i].matricola, InsiemeStudenti[i].nome, InsiemeStudenti[i].cognome, mediaVoti);
	}


printf ("\n\n");
system ("PAUSE");
return 0;
}

