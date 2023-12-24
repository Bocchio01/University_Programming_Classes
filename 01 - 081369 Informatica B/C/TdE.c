#include <stdio.h>
#include <time.h>
#include <math.h>

typedef struct
{
 int id; //id numerico univoco del pilota
 //char nome[100]; //nome e cognome
 int nvoli; //numero voli nel mese
 int voli[100]; //id dei voli effettuati dal pilota nel mese
 int tempo_volo; //tempo di volo in minuti nel mese, da calcolare
} dati_pilota;
typedef struct
{
 int id; //id numerico univoco
 //char from[4]; // sigla aeroporto partenza
 //char dest[4]; // sigla aeroporto destinazione
 int durata; //durata del volo in minuti
} dati_volo;


dati_pilota p[50]; // dati dei piloti per Ottobre 2017
dati_volo v[215]; // dati dei voli per Ottobre 2017


main (){

int i,j,k;
	for (i=0; i<50; i++)
	{
	 p[i].tempo_volo = 0;
	 	for (j=0; j<p[i].nvoli; j++)
	 		for (k=0; k<215; k++)
	 			if (p[i].voli[j] == v[k].id)
	 				p[i].tempo_volo += v[k].durata;
	}

int ar[50];
	j=0;
	for (i=0; i<50; i++)
	{
		if (p[i].tempo_volo>3000)
			{
				ar[j]=p[i].id;
				j++;
			}
	}



printf ("\n\n");
system ("PAUSE");
return 0;
}

