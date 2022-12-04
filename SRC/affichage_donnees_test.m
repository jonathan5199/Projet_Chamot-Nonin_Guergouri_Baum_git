clc
close all
clearvars %-except data

%% Paramètres utilisateur

participant=1; %choix du dataset
reechantillonnage=1; %utilisation de la fonction pour rééchantillonner le dataset ? (1=ok 0=non)

%% chargement des données 

if participant==1
data=load("D:\OneDrive\Documents\Cours\M2\HAH913E - Activité physique\miniprojet mottet\Mesures Ambre\data_pere.csv");
elseif participant==2
data=load("D:\OneDrive\Documents\Cours\M2\HAH913E - Activité physique\miniprojet mottet\Mesures Ambre\data_frere.csv");
else
data=load("D:\OneDrive\Documents\Cours\M2\HAH913E - Activité physique\miniprojet mottet\Mesures Ambre\data_mere.csv");
end


Fs=100; %freq d'échantillonnage de l'accéléromètre en Hz
N=size(data,1);

%% rééchantillonnage

if reechantillonnage==1
    [data, Fe] = nvchantillonnage(data, Fs); %on peut modifier la Fe avec l'argument 'echant', x. Fe vaut 10Hz par défaut
    Fs=Fe; 
    clear Fe
    N=size(data,1);
end

N=size(data,1);
time=data(:,1); % y soustraire data(1,1) dans le cadre d'un fichier unix epoch
x=data(:,2);
y=data(:,3);
z=data(:,4);

clear reechantillonnage

%% ENMO
for i=1:size(time)
vector=[x(i) y(i) z(i)];
enmo(i)=norm(vector)-1; %euclidean norm minus one
end

clear vector i

%% Densité Spectrale de Puissance (PDS)

f = 0:(Fs/N):Fs/2; % échelle des fréquences en respectant le TH de Shannon (on met Fs sur deux parce que pas besoin de voir le repliement spectral)
datafft= fft(data(:,2:4));%fft de data
PSD= (abs(datafft(1:(N/2)+1)).^2)/(N*Fs);

%% Affichage

%Données brutes 

figure("WindowState",'maximized')
t=tiledlayout(4,1);

nexttile
plot(time,x)
title('accélération en x')
xlim([time(1,1) time(end,1)])
ylabel('accélération (g)')

nexttile
plot(time,y,'r')
title('accélération en y')
xlim([time(1,1) time(end,1)])
ylabel('accélération (g)')

nexttile
plot(time,z,'g')
title('accélération en z')
xlim([time(1,1) time(end,1)])
ylabel('accélération (g)')

%ENMO
nexttile
plot(time,enmo,'m')
title('enmo')
xlim([time(1,1) time(end,1)])
ylabel('accélération (g)')

xlabel(t,'temps (s)')

% PSD

figure
plot(f,PSD)
xlabel('Fréquence Hz')
ylabel(['g^2.Hz^–2'])
