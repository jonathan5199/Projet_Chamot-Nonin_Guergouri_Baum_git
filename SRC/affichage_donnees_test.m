%% Traitement des données issues des mesures d'accélérométrie
% date de création : 10/11/2022
% auteur: Chamot-Nonin Manon - Guergouri Ambre - Baum Jonathan

clc
close all
clearvars %-except data

%% Paramètres utilisateur
participant=["pere" "frere" "mere"]; %vecteur contenant la composante variable des noms des fichiers (à compléter par d'éventuels noms de fichiers supplémentaires)
particip_number=1; %choix du dataset

%% chargement des données 

load(['..\DAT\shorten_data_' char(participant(particip_number)) '.mat']) ; 

N=size(data,1);
time=data(:,1); % y soustraire data(1,1) dans le cadre d'un fichier unix epoch
x=data(:,2);
y=data(:,3);
z=data(:,4);

%% ENMO
enmo(1:size(time))=0; %initialisation de la matrice enmo pour éviter son changement de taille à chaque itération
for i=1:size(time)
vector=[x(i) y(i) z(i)];
enmo(i)=norm(vector)-1; %euclidean norm minus one
end

clear vector i

%% Densité Spectrale de Puissance (PDS)
data_c(size(time),3)=0;
for i=1:3
data_c(:,i)=data(:,i+1)-mean(data(:,i+1));
end

f = 0:(Fs/N):Fs/2; % échelle des fréquences en respectant le TH de Shannon (on met Fs sur deux parce que pas besoin de voir le repliement spectral)
datafft= fft(data_c(:,1:3));%fft des données centrées
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
ylabel('g^2.Hz^–2')
