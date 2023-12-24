clear;
clc;
close all;

bandiera = zeros(200,501,3);

bandiera(:, 1:167, 1) = 1;
bandiera(:, 168:334, :) = 1;
bandiera(:, 335:500, 2) = 1;

imagesc(bandiera);