clc
clear variables
close all

%% Section 1

A = randi([0, 1],100,100);
s = sum(A);

for j = 1:size(A,1)

    A(j,:) = A(j,:)./s;

end


%% Section 2

B = [
    0 0 0 1 0
    1 0 0 0 0
    0 1 0 0 0
    0 1 0 0 1
    1 1 1 1 0
    ];
s = sum(B);

for j = 1:size(B,1)

    B(j,:) = B(j,:)./s;

end


%% Section 3
% eigpower function


%% Section 4

TOLL = 1e-10;
nmax = 100;

NA = size(A, 1);
x0 = ones(NA, 1) / NA;
[eigvalue_maeigenvector_A, eigenvector_A, iter_A] = eigpower(A, TOLL, nmax, x0);


NB = size(B, 1);
x0 = ones(NB, 1) / NB;
[eigvalue_maeigenvector_B, eigenvector_B, iter_B] = eigpower(B, TOLL, nmax, x0);



