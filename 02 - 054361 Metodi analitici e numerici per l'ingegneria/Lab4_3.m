clc
clear variables
close all

%% Section 1

F = @(x) [
    x(1)^2 + x(2)^2-1;
    sin(x(1)*pi/2) + x(2)^3
    ];


%% Section 2

JF = @(x) [
    2*x(1), 2*x(2);
    cos(x(1)*pi/2)*pi/2, 3*x(2)^2
    ];


%% Section 3

x0 = [0; 0.2];
TOLL = 1e-5;
nmax = 100;

[x_Res, R, iter] = newtonsys(F, JF, x0, TOLL, nmax);


%% Not mandatory

a = -3;
b = 3;

[x, y] = meshgrid(linspace(a, b));

z1 = x.^2 + y.^2 - 1;
z2 = sin(x.*pi/2) + y.^3;

surface(x, y, z1);
surface(x, y, z2);

view(3);
axis vis3d


C = contours(x, y, z1 - z2, [0 0]);
xLine = C(1, 2:end);
yLine = C(2, 2:end);

zLine = interp2(x, y, z1, xLine, yLine);

line(xLine, yLine, zLine, 'Color', 'r', 'LineWidth', 3);



