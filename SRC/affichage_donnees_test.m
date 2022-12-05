%% Traitement des données issues des mesures d'accélérométrie
% date de création : 10/11/2022
% auteur: Chamot-Nonin Manon - Guergouri Ambre - Baum Jonathan

clc
close all
clear all

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

%% Mise à zéro des axes



%% Filtrage

filtered_data(size(data,1),3)=0;
[B,A] = butter(4, [0.5 20] ./ (Fs / 2)); %initialisation du filtre passe bande : 0.5 à 20 Hz --> bande passante typique de ce type de signal

for i=1:3
    filtered_data(:,i) = filter(B, A, data(:,i+1));
end

xfilt=filtered_data(:,1);
yfilt=filtered_data(:,2);
zfilt=filtered_data(:,3);
clear B A

% ENMO des données filtrées (ou signal vector magnitude SVM)

filtered_enmo(1:size(time))=0; %initialisation de la matrice enmo pour éviter son changement de taille à chaque itération
for i=1:size(time)
vector=[xfilt(i) yfilt(i) zfilt(i)];
filtered_enmo(i)=norm(vector)-1; %euclidean norm minus one
if filtered_enmo(i)<0
   filtered_enmo(i)=0; %valeurs négatives ramenées à 0 
end
end

clear vector i

%%  Affichage

%Données brutes 

figure("WindowState",'maximized')
t=tiledlayout(3,1);
sgtitle('Données brutes')

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

xlabel(t,'temps (s)')

%% Données filtrées 

figure("WindowState",'maximized')
t=tiledlayout(4,1);
sgtitle('Données filtrées')

nexttile
plot(time,xfilt)
title('accélération en x')
xlim([time(1,1) time(end,1)])
ylabel('accélération (g)')

nexttile
plot(time,yfilt,'r')
title('accélération en y')
xlim([time(1,1) time(end,1)])
ylabel('accélération (g)')

nexttile
plot(time,zfilt,'g')
title('accélération en z')
xlim([time(1,1) time(end,1)])
ylabel('accélération (g)')

%ENMO filtrée
nexttile
plot(time,filtered_enmo,'m')
title('enmo')
xlim([time(1,1) time(end,1)])
ylabel('accélération (g)')

xlabel(t,'temps (s)')


