% close all
clear
clc

set(0,'defaultaxesfontsize',16);
set(0, 'DefaultLineLineWidth', 1.5);

SAVEFIG=0;  % if 1, the script saves some figures of the results
TUKEY=1;    % if 1, the Tukey window is adopted
EXP=1;      % If 1, the exponential window is adopted)

%% Test data as from the presentation

fsamp=5120; % Sampling frequency in Hz
sens_hammer=2.4e-3; % V/N
sens_accelerometers=1.02e-2; %V/[m/s^2]

%% Get the list of files from the data folder
datapath='05 - FRF (impulse)\Data';
list_file=dir([datapath '\*.mat']);
N_files=length(list_file);

%% Open one file as an example

filename=list_file(1).name;
load([datapath '\' filename]);
N_channels=size(Dati,2);    % Number of channels
N_samples=size(Dati,1);     % Number of samples

T=N_samples/fsamp;          % Duration in seconds
Delta_t=1/fsamp;            % Time resolution
T_vec=0:Delta_t:T-Delta_t;  % Time vector

%% Convert into engineering units

Dati(:,1)=Dati(:,1)/sens_hammer;                        % In N
Dati(:,2:end)=Dati(:,2:end)/sens_accelerometers;        % In m/s^2

%% Develop a trigger strategy in post processing

figure
plot(T_vec,Dati(:,1),'LineWidth',2)
hold on
title('Input')
ylabel('Force [N]')
xlabel('Time [s]')
grid on

% [~,Threshold_level]=ginput(1);                  % I set the threshold by ginput
Threshold_level = 10;
T_triggered=10;                                 % Duration in s of the trimmed signal
T_pretrigger=0.01;                              % Duration in s of the pre-trigger

df=1/T_triggered;

N_triggered=T_triggered*fsamp;                  % Number of samples of the trimmed signal
N_pretrigger=ceil(T_pretrigger*fsamp);          % Number of samples representing the pre-delay

trig_start=find(Dati(:,1)>=Threshold_level);
trig_start=trig_start(1);                       % Starting index (without pre-trigger)

trig_start=trig_start-N_pretrigger;             % Starting index accounting for the pre-trigger


%% Evaluate H1 and H2

freq=0:df:fsamp/2; % I build the frequency vector for the plots
N_out=N_channels-1; % Number of nodes where I measure the output (in this case it's the total number of channels - 1


% These vectors will serve as buffer for the averaging in the freq domain.
% They have as many columns as many FRFs I will estimate
Sxx=zeros(N_triggered,N_out);
Sxy=zeros(N_triggered,N_out);
Syx=zeros(N_triggered,N_out);
Syy=zeros(N_triggered,N_out);

for ii=1:N_files % Iterate on the tests
    filename=list_file(ii).name;
    load([datapath '\' filename]);

    % Converting data into EU
    Dati(:,1)=Dati(:,1)/sens_hammer; % Converting the input in N
    Dati(:,2:end)=Dati(:,2:end)/sens_accelerometers; % Converting the output in m/s^2

    % I put the force vector into a vector x and the acceleration vectors in the matrix y
    x=Dati(:,1);
    y=Dati(:,2:end);


    %% I cut the signals according to the trigger
    trig_start=find(x>=Threshold_level);
    trig_start=trig_start(1);
    trig_start=trig_start-N_pretrigger;


    x=x(trig_start:trig_start+N_triggered-1);
    y=y(trig_start:trig_start+N_triggered-1,:);
    [~,pk_ind]=max(x); % I find the peak of the force signal

    %% I apply the Tukey window

    if TUKEY==1

        % I use the Tukey window on the force signal
        tk_win=zeros(N_triggered,1); % I initialize a zeros vector with the same size of the original force signal
        tk_win(1:2*pk_ind)=tukeywin(2*pk_ind,0.5); % I build a Tukey window centered on the peak of the force signal

        x=x.*tk_win; % I update x

    end
    %% I apply the exponential window

    if EXP==1
        exp_win=ones(N_triggered,1);
        N_exp=N_triggered-pk_ind+1;
        exp_win(pk_ind:end)=exp_win_fun(N_exp,N_exp,0.01); % SEE THE FUNCTION FOR THE EXPONENTIAL WINDOW AT THE END OF THE SCRIPT!!!
        exp_win_mat=zeros(size(y));
        exp_win_mat=exp_win_mat+exp_win;

        y=y.*exp_win_mat; % I update y

    end

    %% I calculate the spectra

    sp_x=fft(x)./N_triggered; % Spectrum of the input
    sp_y=fft(y)./N_triggered; % Spectrum of the output

    %% Sum of the jj-th power/cross-spectrum to the buffer
    Sxx=Sxx+sp_x.*conj(sp_x);
    Syy=Syy+sp_y.*conj(sp_y);
    Sxy=Sxy+sp_y.*conj(sp_x);
    Syx=Syx+sp_x.*conj(sp_y);

end

%% Estimating average power/cross-spectra
% I estimate Gxx, Gyy, Gxy, Gyy
Gxx=Sxx(1:end/2+1,:)./(N_files);
Gxx(2:end-1,:)=2*Gxx(2:end-1,:);

Gyy=Syy(1:end/2+1,:)./(N_files);
Gyy(2:end-1,:)=2*Gyy(2:end-1,:);

Gxy=Sxy(1:end/2+1,:)./(N_files);
Gxy(2:end-1,:)=2*Gxy(2:end-1,:);

Gyx=Syx(1:end/2+1,:)./(N_files);
Gyx(2:end-1,:)=2*Gyx(2:end-1,:);
%% Estimating FRF and coherence
H1=Gxy./Gxx;
H2=Gyy./Gyx;
coer=abs(Gxy).^2./(Gxx.*Gyy);
%% Plot of the results

for ii=1:N_out
    figure
    ax1= subplot(2,1,1);

    semilogy(freq,abs(H1(:,ii)))
    xlabel('Frequency [Hz]')
    ylabel('|H| [m/s^2/N]')
    axis tight
    grid on
    hold on
    semilogy(freq,abs(H2(:,ii)))
    yyaxis right
    plot(freq,coer(:,ii),'k')
    ylabel('\gamma')
    sg=sgtitle(['NodeIn=1 NodeOut=' num2str(ii)]);
    sg.FontSize=20;
    sg.FontWeight='bold';

    legend('H_1','H_2','\gamma')
    tit=title('Module of the FRF');
    tit.FontWeight='Normal';

    ax2=subplot(2,1,2);
    plot(freq,unwrap(angle(H1(:,ii)))./(2*pi)*360)
    hold on
    plot(freq,unwrap(angle(H2(:,ii)))./(2*pi)*360)
    xlabel('Frequency [Hz]')
    ylabel('\phi')
    axis tight
    legend('H_1','H_2')
    grid on
    tit=title('Phase of the FRF');
    tit.FontWeight='Normal';
    linkaxes([ax1,ax2],'x')
    xlim([0.5 2000])

    if SAVEFIG==1
        savefig(['FRF_N' num2str(ii) '_TK_' num2str(TUKEY) '_EXP_' num2str(EXP)])
    end

end

%%
%% Power spectrum of the input - Plot

figure
semilogy(freq,Gxx(:,1))
grid on
ylabel('|G_{xx}| [N^2]')
xlabel('Frequency [Hz]')
axis tight
title('G_{xx}')

if SAVEFIG==1
    savefig(['Gxx_TK_' num2str(TUKEY)])
end

%% Comparison of H1 for the 2 output nodes
figure
ax1=subplot(2,1,1);

semilogy(freq,abs(H1))
axis tight
grid on
axis tight
xlabel('Frequency [Hz]')
ylabel('|H_1| [m/s^2/N]')
nomi=1:1:N_channels;
legend('N1', 'N2')
grid on
ax2=subplot(2,1,2);
plot(freq,unwrap(angle(H1))./(2*pi)*360)
xlabel('Frequency [Hz]')
ylabel('\phi')
axis tight
linkaxes([ax1,ax2],'x')
legend('N1', 'N2')
grid on
sg=sgtitle('H_1');
sg.FontSize=20;
sg.FontWeight='bold';
xlim([0.5 2000])

%% I define here a custom function for my exponential window

function [exp_win]=exp_win_fun(N,n,P)
% N is the number of points of the exponential window
% n is the index at which I want to reach P; e.g., if n=N, I will reach P at the end of the exp window.

if P==0
    P=eps; % to avoid numerical issues for P=0
end

tau_e=-(n)/log(P); %% I calculate a tau_e such that I obtain P at n
exp_win=exp(-(1:N)/tau_e);
end