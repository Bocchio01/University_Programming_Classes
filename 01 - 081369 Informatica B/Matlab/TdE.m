clc;
clear;


% function [D] = distmat (mat1, mat2)
%     for ii=1:max(length(mat1), length(mat2))
%         D(ii, :) = [sqrt((mat2(ii,1)-mat1(:,1)).^2 +(mat2(ii,2)-mat1(:,2)).^2) ]
%     end
% end


load('fattoriniERichieste.mat');
J = distmat(C, M);
K = distmat(F, M);
r = input('Dimmi un numero di richiesta: ');

ind_fattorini = find (K(:,r)<J(r,r));
if isempty(ind_fattorini)
    disp('Non è possibile soddisfare la richiesta');
else
    fprintf ('Per la richiesta %d, il fattorino più vicino é il numero: %d', r, min(ind_fattorini));
end

function [D] = distmat (mat1, mat2)
    for ii=1:length(mat1)
        D(ii,:) = [sqrt((mat1(ii,1)-mat2(:,1)).^2+(mat1(ii,2)-mat2(:,2)).^2)];
    end
end