#include <stdio.h>
#include <time.h>
#include <math.h>

#define N_REPERTI 1000
typedef enum {mTerracotta,mMarmo,mMetallo} tipomanufatto;
typedef struct{
float latitudine;
float longitudine;
float profondita;
float peso;
tipomanufatto t;} Reperto;


)
main (){
	
	Reperto totalereperti[N_REPERTI];
	int i;
	for (i=0;i<N_REPERTI;i++)
		printf ("\n%f" , totalereperti[i].peso);
	
	#define SOGLIA
	#define LATI
	#define LONI	
	for (i=0;i<N_REPERTI;i++)
		cond = if ((totalereperti[i].latitudine<LATI+SOGLIA)&&(totalereperti[i].latitudine>LATI-SOGLIA)&&(totalereperti[i].longitudine<LONI+SOGLIA)&&(totalereperti[i].longitudine>LONI-SOGLIA))
		
	float pMax, lati,loni,soglia;
	scanf ("%f",&pMax);
	scanf ("%f",&lati);
	scanf ("%f",&loni);
	scanf ("%f",&soglia);
	
	float pAtt=0,t=0;
	Reperto caricoVeicolo[N_REPERTI];
	for (i=0;i<N_REPERTI;i++){
		if (cond){
			if (totalereperti[i].peso<=pMax-pAtt){
			caricoVeicolo[t].peso=totalereperti[i].peso;
			t++;
			pAtt+=totalereperti[i].peso;}
		}
	}



printf ("\n\n");
system ("PAUSE");
return 0;
}

