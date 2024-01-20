% clc;
% clear;

% Initial Values
v=0;
u=0;
Px=0;
Py=0;
dPx=0.5;
dPy=0.5;

% Mecahnical and Geometrical Properties
EA=5E7;
L=2500;
K=1.5;

% External Load Increments
for j=1:5
    Rx=100.;
    Ry=100.;
    
    F=(EA/L^2)*(v^2/2.-L*u);
    
    Kt11=EA/L;
    Kt12=-EA*v/L^2;
    Kt21=-EA*v/L^2;
    Kt22=(EA/L^3)*v^2+F/L+K;
    det=Kt11*Kt22-Kt12*Kt21;
    
    % Euler Displacement Predictor
    du=(Kt22*dPx-Kt12*dPy)/det;
    dv=(-Kt21*dPx+Kt11*dPy)/det;
    
    u=u+du;
    v=v+dv;
    
    %Updating External Force Increment
    Px=Px+dPx;
    Py=Py+dPy;
    
    %for i=1:5
    i = 0;
    while ((abs(Rx)+abs(Ry))>0.00001)
        i=i+1;
    
        % Internal Forces;
        F=(EA/L^2)*(v^2/2.-L*u);
        Fix=-F;
        Fiy=F*v/L+K*v;
    
        % Residual Functions
        Rx=Fix-Px;
        Ry=Fiy-Py;
    
        Kt11=EA/L;
        Kt12=-EA*v/L^2;
        Kt21=-EA*v/L^2;
        Kt22=(EA/L^3)*v^2+F/L+K;
        det=Kt11*Kt22-Kt12*Kt21;
    
        % N-R Displacement Corrector
        du=-(Kt22*Rx-Kt12*Ry)/det;
        dv=-(-Kt21*Rx+Kt11*Ry)/det;
    
        u=u+du;
        v=v+dv;
    end

end

u
v
    
