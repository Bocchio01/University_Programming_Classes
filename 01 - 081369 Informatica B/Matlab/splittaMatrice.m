function [titoliOver, titoliUnder] = splittaMatrice (titoliTot, andamentoTot, soglia)
titoliOver = titoliTot(andamentoTot>=soglia, 1:end);
titoliUnder = titoliTot (andamentoTot <soglia, :);
end

load ('log.mat')
[titoliOver, titloiUnder] = splittaMatrice (titoli, andamento, 0);
x=1:500;

figure
ylabel('Valore titolo');
xlabel('Tempo');
title('Titolo positivi');
if titoliOver
    [r c] = size(titoliOver);
    hold on
    for k=1:r
        plot (x,titoliOver(k,:);
    end
    hold off
end

figure
ylabel('Valore titolo');
xlabel('Tempo');
title('Titolo negativi');
if titoliUnder
    [r c] = size(titoliUnder);
    hold on
    for k=1:r
        plot (x,titoliUnder(k,:);
    end
    hold off
end

