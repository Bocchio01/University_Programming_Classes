% Tommaso Bocchietti 957259 - Docente: Elisabetta Di Nitto
% Data: 02/01/2021
% Crea una matrice tridimensionale raffigurante la bandiera del Canada
% Utilizza le funzioni: Crea_Matrice.m
%                       Disegna_Profilo.m
%                       Riempi_Profilo.m
%                       Livelli_Colore.m
% 
%     Riceve in input la matrice 'dati_profilo' con le coordinate (in
%     pixel) dei vertici del contorno dell'immagine.
%     Crea quindi una matrice 500*1000.
%     Lavorando per approsimazione matematica, analizza le coordinate e
%     "colora" (modifica il valore) dei campi che in un ideale piano
%     cartesiano vengono toccate dalle linee che collegano le cooridinate.
%     "Colora" quindi le regioni di spazio (intese come campi della matrice)
%     delimitate da tali linee, e infine assegna la matrice al corretto 
%     livello RGB.
%     Stampa quindi a video la matrice tridimensionale prodotta.

clc;
clear;

scelte_utente = 'N';

% Scommentare la prossima riga per poter personalizzare la propria bandiera
scelte_utente = input('Vuoi personalizzare la tua bandiera? (S/N): ','s');

if (scelte_utente=='S' || scelte_utente=='s')
    altezza_bandiera = input('\nDimmi le dimensioni della tua bandiera canadese\nAltezza: ');
    larghezza_bandiera = input('Larghezza: ');
    
    colore_principale = ["Nero"; "Bianco"; "Rosso"; "Verde"; "Blu"; "Giallo"; "Magenta"; "Ciano"];
    fprintf('\nScegli il colore della foglia:');
    for ii=1:length(colore_principale)
        fprintf ('\n%d: %s;', ii, colore_principale(ii));
    end
    colore_principale = colore_principale(input('\nInserisci il numero del colore: '));
    
    intensita_profilo = input('\nInserisci la tonalità del colore di contorno (da 0 a 255): ')/255;
    intensita_campitura = input('Inserisci la tonalità del colore interno (da 0 a 255): ')/255;
    bandiera_negativa = input('Vuoi la bandiera in versione negativa? (Si -> 1, No -> 0): ');
    step_visivi = input('\nVuoi visualizzare la creazione della bandiera step_by_step? (Si -> 1, No -> 0): ');

else
    altezza_bandiera = 500;
    larghezza_bandiera = 1000;
    colore_principale = "Rosso";
    intensita_profilo = 255/255;
    intensita_campitura = 255/255;
    bandiera_negativa = 0;
    step_visivi = 0;
end

% Coordinate della metà sinistra della bandiera Canadese
dati_profilo = [467	500;
467	493;
368	497;
362	491;
361	489;
361	485;
374	396;
347	405;
343	405;
336	401;
260	308;
246	331;
239	331;
180	314;
191	365;
191	372;
189	375;
163	385;
213	434;
215	438;
213	442;
207	444;
202	444;
103	425;
117	455;
117	460;
114	465;
50	500;
0	0;      
500	1;
1	1;
1	250;
500	250;
500	1];

% Nel caso si volesse caricare i dati del profilo da disegnare da un file
% testo, scommentare la prossima riga e scrivere al posto di '###' il nome
% completo del file di testo.

% dati_profilo = load('###');
plotter_profilo = Disegna_Profilo(dati_profilo, altezza_bandiera, larghezza_bandiera, intensita_profilo, step_visivi);

plotter_campito = Riempi_Profilo(plotter_profilo, intensita_campitura, intensita_profilo, step_visivi);

bandiera = Livelli_Colore(plotter_campito, colore_principale, bandiera_negativa);

figure
imshow(bandiera)