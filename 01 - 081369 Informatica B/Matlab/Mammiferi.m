clear;
mammifero.tipo = 'Elefante'; 
mammifero.alimentazione = 'Erbivoro'; 
% mammifero.peso  = {'A','5';'B','2';'C','3'};
mammifero.peso (1) = struct ('codice',3,'anno',1985);
mammifero.peso (2) = struct ('codice',4,'anno',1980);
mammifero.esemplari (1) = struct ('codice',3,'anno',1985,'cuccioli',3);
mammifero.esemplari (2) = struct ('codice',5,'anno',1989,'cuccioli',0);
mammifero.esemplari (3) = struct ('codice',8,'anno',1982,'cuccioli',0);

continua=input('Vuoi inserire altri esemplari? [s/n]', 's');

while (continua=='s')
    mammifero.esemplari (end+1).codice = input ('Inserisci codice:' );
    mammifero.esemplari (end+1).anno= input ('Inserisci anno:' );
    mammifero.esemplari (end+1).cuccioli= input ('Inserisci cuccioli:' );
    continua=input('Vuoi inserire altri esemplari? [s/n]','s');
end

[mammifero.esemplari.anno]<1990;
[mammifero.esemplari.cuccioli]==0;

selezione=([mammifero.esemplari.anno]<1990) & ([mammifero.esemplari.cuccioli]==0);

codice_sterili = [mammifero.esemplari(selezione).codice]