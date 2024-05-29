clear 
close all
clc
%% load the input file and assemble structure
[file_i,xy,nnod,sizee,idb,ndof,incid,l,gamma,m,EA,EJ,posiz,nbeam,pr]=loadstructure;

%% Assemble mass and stiffness matrices
[M,K] = assem(incid,l,m,EA,EJ,gamma,idb);
M_FF=M(1:ndof,1:ndof);
K_FF=K(1:ndof,1:ndof);

%% Compute the natural frequencies and vibration modes
% calcolo gli autovettori e gli autovalori, che corrispondono alle natural frequencies e i vibration mode
[modes, omega2] = eig(M_FF\K_FF); 
omega = sqrt(diag(omega2));

% Sort frequencies in ascending order
[omega,i_omega] = sort(omega);
freq0 = omega/2/pi;

% Sort mode shapes in ascending order
modes = modes(:,i_omega);

%% Undeformed structure plot
dis_stru(posiz,l,gamma,xy,pr,idb,ndof); 

%% 2-Mode Shapes Plot
scale_factor=1.5;
% scegli la mode che vuoi plottare

for k=1:3
mode=modes(:,k); 
figure
diseg2(mode,scale_factor,incid,l,gamma,posiz,idb,xy)
title(['Mode shape ' num2str(k) ' \omega_0=' num2str(omega(k)) ' [rad/s]'])
legend('Undeformed shape','Deformed shape')
xlabel('Length [m]')
ylabel('Height [m]')
end

%% Compute the Damping Matrix
alpha=0.1;
beta=2.0e-4;
C = alpha*M + beta*K; %damping matrix 

%% 3.FRF tra forza esterna applicata e spostamenti nei nodi

% costruisco il vettore delle forze applicate 
F0 = zeros(ndof,1);
F0(idb(9,2)) = 1; % specifico che la forza esterza è applicata nel punto A,cioè nodo 9 sulla coordinata verticale

om = (0:0.01:8)*2*pi;
for ii=1:length(om)
 A = -om(ii)^2*M_FF+ 1i*om(ii)*C(1:ndof,1:ndof)+ K_FF;
 X(:,ii) = A\F0; % è la matrice che contiene le FRF
end 

figure
subplot(2,1,1)
semilogy(0:0.01:8,abs(X(idb(9,2),:)),'LineWidth',1.5) % idb(9,2) corrisponde al vertical displacemnet (y) del nodo 9, cioe del punto A
title('FRF: Vertical Force in A-Vertical Displacement A')
xlabel('f [Hz]')
ylabel('|FRF|')
grid on
subplot(2,1,2)
plot(0:0.01:8,angle(X(idb(9,2),:)),'LineWidth',1.5)
xlabel('f [Hz]')
ylabel('Phase [rad]')
grid on

figure
subplot(2,1,1)
semilogy(0:0.01:8,abs(X(idb(14,1),:)),'LineWidth',1.5) % idb(14,1) corrisponde al horizontal displacement (x) del nodo 14, cioe del punto B
title('FRF: Vertical Force in A-Horizontal Displacement B')
xlabel('f [Hz]')
ylabel('|FRF|')
grid on
subplot(2,1,2)
plot(0:0.01:8,angle(X(idb(14,1),:)),'LineWidth',1.5)
xlabel('f [Hz]')
ylabel('Phase [rad]')
grid on

%% 4. Modal superposition approach 

% Modal matrices
ii = 1:2; % we consider only the first two modes
Phi = modes(:,ii);
Mmod = Phi'*M(1:ndof,1:ndof)*Phi;
Kmod = Phi'*K(1:ndof,1:ndof)*Phi;
Cmod = Phi'*C(1:ndof,1:ndof)*Phi;
Fmod = Phi'*F0;
% first 2 mode shapes, FRF in modal superposition approach
for ii = 1:length(om)
 xx_mod(:,ii) = (-om(ii)^2*Mmod+1i*om(ii)*Cmod+Kmod)\Fmod;
end
xx_m = Phi * xx_mod;

% plotto e faccio il confronto tra i due metodi
figure
subplot(2,1,1)
semilogy(0:0.01:8,abs(X(idb(14,1),:)),'LineWidth',1.5) % sto plottando la FRF calcolata col FEM approach
hold on 
semilogy(0:0.01:8,abs(xx_m(idb(14,1),:)),'LineWidth',1.5)
grid on
title('FEM vs Modal superposition approach (Force in A-Displacement in B)')
legend('FEM','Modal')
xlabel('f [Hz]')
ylabel('|X/F|')

subplot(2,1,2)
plot(0:0.01:8,angle(X(idb(14,1),:)),'LineWidth',1.5)
hold on
plot(0:0.01:8,angle(X(idb(9,2),:)),'LineWidth',1.5)
grid on
legend('FEM','Modal')
xlabel('f [Hz]')
ylabel('Phase [rad]')
% commenti . . . 

%% 5-FRF tra forza esterna e reazioni vincolari
M_CF=M(ndof+1:end,1:ndof); % Matrixes saw by the costraints to the free dof
C_CF=C(ndof+1:end,1:ndof);
K_CF=K(ndof+1:end,1:ndof);
F0 = zeros(ndof,1);
F0(idb(1,2)) = 1; % input force applied in point C, cioe nel nodo 1 in vertical direction
om = (0:0.01:8)*2*pi;
for ii=1:length(om)
 X(:,ii)=inv(-om(ii)^2*M_FF+sqrt(-1)*om(ii)*C(1:ndof,1:ndof)+K_FF)*F0;
 rr(:,ii)= (-om(ii)^2*M_CF+sqrt(-1)*om(ii)*C_CF+K_CF)*X(:,ii);
end

ndof_RV1 = idb(15,2)-ndof; % il nodo 15 corrisponde al punto 02
FRF_RV1 = rr(ndof_RV1,:);

figure
subplot(2,1,1)
semilogy(0:0.01:8,abs(FRF_RV1),'LineWidth',1.5)
title('FRF: Vertical Force in C-Axial Force in O_2')
xlabel('f [Hz]')
ylabel('|FRF|')
grid on
subplot(2,1,2)
plot(0:0.01:8,angle(FRF_RV1),'LineWidth',1.5)
xlabel('f [Hz]')
ylabel('Phase [rad]')
grid on

%% 6.Static response of the structure due to the weight of the entire structure
%% A-Lagrange Approach
FGa = zeros(3*nnod,1);

for ii = 1:30 % cicle over elements involved: in this case all elements
p0 = -m(ii)*9.8; %[N/m]
gammaii = gamma(ii);
%p0G = [p0*sin(gammaii) p0*cos(gammaii)]'; 
p0G=[0 p0]';
Lk = l(ii);
p0L = [cos(gammaii) sin(gammaii);
-sin(gammaii) cos(gammaii)]*p0G;
FkL = [Lk/2; 0 ; 0 ; Lk/2; 0 ; 0 ]*p0L(1) + ...
[0 ; Lk/2; Lk^2/12; 0 ; Lk/2; -Lk^2/12]*p0L(2);
FkG = [cos(gammaii) -sin(gammaii) 0 0 0 0;
        sin(gammaii) cos(gammaii) 0 0 0 0;
        0 0 1 0 0 0;
        0 0 0 cos(gammaii) -sin(gammaii) 0;
        0 0 0 sin(gammaii) cos(gammaii) 0;
        0 0 0 0 0 1]*FkL;
Ek = zeros(6,3*nnod);
for jj = 1:6
Ek(jj,incid(ii,jj)) = 1;
end
FGa = FGa + Ek'*FkG;
end

F0a = FGa(1:ndof);

% Displacement with method A

Xa=K_FF\F0a;

% Max deflection
X_free_a=[Xa(1:33,1);0;0;Xa(34:40,1);0;0;Xa(41:end)];
X_Ha=X_free_a(1:3:end)+xy(1:end,1);
X_Va=X_free_a(2:3:end)+xy(1:end,2);
XX_a=[X_Ha,X_Va];
deflect_xa=X_free_a(1:3:end);
deflect_ya=X_free_a(2:3:end);
max_def_a=[max(abs(deflect_xa)),max(abs(deflect_ya))];

%% B-Acceleration Approach
x_dotdot=zeros(ndof,1);
x_dotdot(idb(:,2))=-9.81;

Fnodal=zeros(3*nbeam,1);
Fnodal=M*x_dotdot;
Fnodal = Fnodal(1:ndof,1);

%Displacement with method B
Xb=K_FF\Fnodal;

% Max deflection
X_free_b=[Xb(1:33,1);0;0;Xb(34:40,1);0;0;Xb(41:end)];
X_Hb=X_free_b(1:3:end)+xy(1:end,1);
X_Vb=X_free_b(2:3:end)+xy(1:end,2);
XX_b=[X_Hb,X_Vb];
deflect_xb=X_free_b(1:3:end);
deflect_yb=X_free_b(2:3:end);
max_def_b=[max(abs(deflect_xb)),max(abs(deflect_yb))];

%% Comparison plots
figure
subplot(2,1,1)
diseg2(Xa,10,incid,l,gamma,posiz,idb,xy)
title('Deformed shape due to self weight (Lagrange Approach)')
legend('Undeformed shape','Deformed shape')
xlabel('Length [m]')
ylabel('Height [m]')

subplot(2,1,2)
diseg2(Xb,10,incid,l,gamma,posiz,idb,xy)
title('Deformed shape due to self weight (Nodal acceleration)')
legend('Undeformed shape','Deformed shape')
xlabel('Length [m]')
ylabel('Height [m]')

%% 7- Vertical displacement time history of point A
% Calculate the vertical displacement time history of point A, taking into account a 
% moving load traveling between points D and A.

% Velocity profile
L_D_A=0:0.12:24; % [m]
t_D_A=0:0.1:20; % [s]
v_max=1; %[m/s]
v=zeros(1,100);
v(1)=0;

a=v_max/6;
for ii=2:61
    v(ii)=a*t_D_A(ii);
end
for ii=62:141
    v(ii)=v_max;
end
for ii=142:201
    v(ii)=v_max-a*(t_D_A(ii)-t_D_A(141));
end
figure
plot(L_D_A,v)
%%
Load=1;
mode_D_A=modes(19:27,:);

%% funzioni
%% loadstructure

function [file_i,xy,nnod,sizee,idb,ndof,incidenze,l,gamma,m,EA,EJ,posiz,nbeam,pr]=loadstructure

% Loads *.inp file
disp(' ');
file_i=input(' Name of the input file *.inp (without extension) for the structure to be analyzed = ','s') ;
disp(' ')
% Check input file
if exist([file_i '.inp'])~=2
    disp(['File ',file_i,'.inp does not exist' ])
    file_i=[];
    return
end
nprova=file_i;

% File opening
eval(['fid_i=fopen(''',file_i,'.inp'',''r'');']);

% Reading card NODES
findcard(fid_i,'*NODES')
% line=scom(fid_i)
% finewhile=findstr(line,'*ENDNODES')
finewhile=1;
iconta=0;
while finewhile ==1
    line=scom(fid_i);
    finewhile=isempty(findstr(line,'*ENDNODES'));
    if finewhile == 1
        tmp=sscanf(line,'%i %i %i %i %f %f')';
        iconta=iconta+1;
        if iconta ~=tmp(1)
        disp('Errore: nodi non numerati in ordine progressivo')
        break  
        end
        ivinc(iconta,:)=tmp(2:4);
        xy(iconta,:)=tmp(5:6);
    end
end
nnod=iconta;
disp(['Number structure nodes ',int2str(nnod)])
sizee=sqrt((max(xy(:,1))-min(xy(:,1)))^2+(max(xy(:,2))-min(xy(:,2)))^2);
% End of reading card NODES

% Building IDB matrix
idof=0;
for i=1:nnod
    for j=1:3
        if ivinc(i,j) == 0
            idof=idof+1;
            idb(i,j)=idof;
        end
    end
end
ndof=idof;
disp(['Number of structure d.o.f. ',int2str(ndof)])
for i=1:nnod
    for j=1:3
        if ivinc(i,j) == 1
            idof=idof+1;
            idb(i,j)=idof;
        end
    end
end


% reading card PROPERTIES
findcard(fid_i,'*PROPERTIES')
finewhile=1;
iconta=0;
while finewhile ==1
    line=scom(fid_i);
    finewhile=isempty(findstr(line,'*ENDPROPERTIES'));
    if finewhile == 1
        tmp=sscanf(line,'%i %f %f %f')';
        iconta=iconta+1;
        properties(iconta,:) = tmp(2:4);
    end
end
disp(['Number of properties ',int2str(iconta)])

% reading card BEAMS
findcard(fid_i,'*BEAMS')
finewhile=1;
iconta=0;
while finewhile ==1
    line=scom(fid_i);
    finewhile=isempty(findstr(line,'*ENDBEAMS'));
    if finewhile == 1
        tmp=sscanf(line,'%i %i %i %i')';
        iconta=iconta+1;
        incid(iconta,:)=tmp(2:3);
        pr(1,iconta) = tmp(4);
        m(1,iconta)  = properties(tmp(4),1);
        EA(1,iconta) = properties(tmp(4),2);
        EJ(1,iconta) = properties(tmp(4),3);
        l(1,iconta)=sqrt((xy(incid(iconta,2),1)-xy(incid(iconta,1),1))^2+(xy(incid(iconta,2),2)-xy(incid(iconta,1),2))^2);
        gamma(1,iconta)=atan2(xy(incid(iconta,2),2)-xy(incid(iconta,1),2),xy(incid(iconta,2),1)-xy(incid(iconta,1),1));
        incidenze(iconta,:)=[idb(incid(iconta,1),:) idb(incid(iconta,2),:)];
        posiz(iconta,:)=xy(incid(iconta,1),:);
    end
end
nbeam=iconta;
disp(['Number of beam FE ',int2str(nbeam)])

fclose(fid_i);
end

%% dis_stru

function dis_stru(posiz,l,gamma,xy,pr,idb,ndof)
% Plotting the undeformed structure

xmax = max(xy(:,1));
xmin = min(xy(:,1));
ymax = max(xy(:,2));
ymin = min(xy(:,2));

dx = (xmax - xmin)/200;
dy = (ymax - ymin)/200;
d = sqrt(dx^2 + dy^2);

npr     = max(pr);
red     = cos(((0:npr/(npr-1):npr)-npr/2)*pi/2/npr).^2;
green   = cos((0:npr/(npr-1):npr)*pi/2/npr).^2;
blue    = cos(((0:npr/(npr-1):npr)-npr)*pi/2/npr).^2;
colori = [red' green' blue'];

figure();
hold on;
% Step 2: elements
for ii=1:length(posiz)
    xin=posiz(ii,1);
    yin=posiz(ii,2);
    xfi=posiz(ii,1)+l(ii)*cos(gamma(ii));
    yfi=posiz(ii,2)+l(ii)*sin(gamma(ii));
    colore = colori(pr(ii),:);
    plot([xin xfi],[yin yfi],'linewidth',5,'color',colore);
end
grid on; box on;

% Step 1: nodal positions
% plot(xy(:,1),xy(:,2),'r.','markersize',20);

triangolo_h = [ 0 0; -sqrt(3)/2 .5; -sqrt(3)/2 -.5; 0 0]*d*2;
triangolo_v = [ 0 0; .5 -sqrt(3)/2; -.5 -sqrt(3)/2; 0 0]*d*2;
triangolo_r = [0 0; .5 -sqrt(3)/2; -.5 -sqrt(3)/2; 0 0]*d*2 * [sqrt(2)/2 -sqrt(2/2); -sqrt(2)/2 -sqrt(2)/2];


hold on
for ii = 1:size(xy,1)
    rectangle('Position',[xy(ii,1)-d/2 xy(ii,2)-d/2 d d],'curvature',1,'facecolor',[1 0 0],'linewidth',0.1);
    text(xy(ii,1) + d, xy(ii,2) + d,num2str(ii));
    if (idb(ii,1) > ndof)
        fill(xy(ii,1) + triangolo_h(:,1),xy(ii,2) + triangolo_h(:,2),'k');
    end
    if (idb(ii,2) > ndof)
        fill(xy(ii,1) + triangolo_v(:,1),xy(ii,2) + triangolo_v(:,2),'k');
    end
    if (idb(ii,3) > ndof)
        fill(xy(ii,1) + triangolo_r(:,1),xy(ii,2) + triangolo_r(:,2),'k');
    end
end


axis equal
xlim([min(xy(:,1))-10*d max(xy(:,1))+10*d]);
ylim([min(xy(:,2))-10*d max(xy(:,2))+10*d]);


title('Undeformed Structure')
end

%% Assem 

function [M,K] = assem(incidenze,l,m,EA,EJ,gamma,idb)

% Checking consistency input data
[n_el,nc]=size(incidenze);
if nc ~= 6
    disp('Error: number of columns of incidence matrix different from 6')
    return
end
if length(l) ~= n_el
    sprintf('Error: number of elements in l differenc from n')
    return
end
if length(m) ~= n_el    
    sprintf('Error: number of elements in m differenc from number of elements')
    return
end
if length(EA) ~= n_el
    sprintf('Error: number of elements in EA differenc number of elements')
    return
end
if length(EJ) ~= n_el
    sprintf('Error: number of elements in EJ differenc number of elements')
    return
end
if length(gamma) ~= n_el
    sprintf('Error: number of elements in alpha differenc number of elements')
    return
end

if min(min(incidenze)) ~= 1    
    sprintf('Error: dof sequence does not start from 1')
    return
end

n_dof=max(max(idb));

% Assembling matrices M and K
M=zeros(n_dof,n_dof);
K=zeros(n_dof,n_dof);
for k=1:n_el
    [mG,kG] = el_tra(l(k),m(k),EA(k),EJ(k),gamma(k));
    for iri=1:6
        for ico=1:6
            i1=incidenze(k,iri);
            i2=incidenze(k,ico);
            M(i1,i2)=M(i1,i2)+mG(iri,ico);
            K(i1,i2)=K(i1,i2)+kG(iri,ico);
        end
    end
end

end

%% diseg2
function diseg2(mode,scale_factor,incidenze,l,gamma,posiz,idb,xy)

% Checking consistency input data
[n_el,nc]=size(incidenze);

if length(posiz) ~= n_el
    sprintf('Error: number of nodes in posit matrix differs from number of elements')
    return
end

n_gdl=length(mode);


hold on
% looping on the finite elements
for k=1:n_el
% building the nodal displacements vector of each element in the global
% reference frame
    for iri=1:6
        if incidenze(k,iri) <= n_gdl
        xkG(iri,1)=mode(incidenze(k,iri));
        else
        xkG(iri,1)=0.;
        end
    end
% Applying scale factor
    xkG=scale_factor*xkG;
% Global to Local reference frame rotation
    lambda = [ cos(gamma(k)) sin(gamma(k)) 0. 
              -sin(gamma(k)) cos(gamma(k)) 0.
	                0.      0.     1. ] ;
    Lambda = [ lambda     zeros(3)
              zeros(3)   lambda      ] ;
    xkL=Lambda*xkG;

% Computing the axial (u) and transversal (w) displacements by means of
% shape functions
    csi=l(k)*[0:0.05:1];
    fu=zeros(6,length(csi));
    fu(1,:)=1-csi/l(k);
    fu(4,:)=csi/l(k);
    u=(fu'*xkL)';
    fw=zeros(6,length(csi));
    fw(2,:)=2*(csi/l(k)).^3-3*(csi/l(k)).^2+1;
    fw(3,:)=l(k)*((csi/l(k)).^3-2*(csi/l(k)).^2+csi/l(k));
    fw(5,:)=-2*(csi/l(k)).^3+3*(csi/l(k)).^2;
    fw(6,:)=l(k)*((csi/l(k)).^3-(csi/l(k)).^2);
    w=(fw'*xkL)';
% Local to global transformation of the element's deformation
    xyG=lambda(1:2,1:2)'*[u+csi;w];
    undef=lambda(1:2,1:2)'*[csi;zeros(1,length(csi))];
 % Plotting deformed and undeformed element's shape
    plot(undef(1,:)+posiz(k,1),undef(2,:)+posiz(k,2),'b--')
    plot(xyG(1,:)+posiz(k,1),xyG(2,:)+posiz(k,2),'b')
end

% Looping the nodes
n_nodi=size(idb,1);
xkG=[];
for k=1:n_nodi
    for ixy=1:2
        if idb(k,ixy) <= n_gdl
        xkG(k,ixy)=mode(idb(k,ixy));
        else
        xkG(k,ixy)=0.;
        end
    end
end
xkG=scale_factor*xkG;
xyG=xkG+xy;
plot(xy(:,1),xy(:,2),'b.')
plot(xyG(:,1),xyG(:,2),'bo')

grid on
box on
axis equal
end