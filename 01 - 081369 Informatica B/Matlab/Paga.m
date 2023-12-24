operaio(1) = struct('paga',5,'ore_lavoro', 40,'pezzi_prodotti',1000);
operaio(2) = struct('paga',6,'ore_lavoro', 41,'pezzi_prodotti',1001);
operaio(3) = struct('paga',7,'ore_lavoro', 43,'pezzi_prodotti',1003);
operaio(4) = struct('paga',8,'ore_lavoro', 46,'pezzi_prodotti',1004);
operaio(5) = struct('paga',9,'ore_lavoro', 48,'pezzi_prodotti',1005);
%vettore con tutte le paghe
paghe=[operaio.paga];
%vettore con tutte le ore lavorate
ore=[operaio.ore_lavoro];

guadagni = paghe.*ore;

salario_totale = sum(guadagni);

pezzi_prodotti= sum([operaio.pezzi_prodotti]);

costo_medio=pezzi_prodotti/salario_totale

ore_totale=sum([operaio.ore_lavoro]);
ore_medie=ore_totale/pezzi_prodotti;

efficienza_operaio=[operaio.pezzi_prodotti]./[guadagni]
%la funziona ritorna piu valori, 1°max, 2°indice del max
[val,idx]=max(efficienza_operaio)