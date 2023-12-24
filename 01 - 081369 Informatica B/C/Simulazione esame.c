#include <stdio.h>

typedef enum
{
	istruttore,
	studente
} type_ruolo;

typedef struct
{
	char nome[30];
	char codice_persona;
	type_ruolo ruolo;
} utente;

typedef struct
{
	char ID;
	utenti presenti[100];
	int n_presenti;
} classe_virtuale;

typedef struct
{
	char nome[30];
	utenti iscritti[100];
	int n_iscritti;
	utente istruttore[3];
	classe_virtuale classe;
} esami;

main()
{
	esami elencoEsami[100];

	int i, k;

	for (i = 0; i < elencoEsami[9].classe.n_presenti; i++)
	{
		k = 0;
		while (k < elencoEsami[9].n_iscritti && elencoEsami[9].classe.n_presenti[i].ID != elencoEsami[9].iscritti[k].ID)
			k++;
		if (k == elencoEsami[9].n_iscritti)
			printf("Esame: %s, Studente non iscritto: %s, %ld \n", elencoEsami[9].nome, elencoEsami[9].classe.presenti[i].nome, elencoEsami[9].classe.presenti[i].ID);
	}

	printf("\n\n");
	system("PAUSE");
	return 0;
}
