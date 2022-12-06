%% Traitement des données issues des mesures d'accélérométrie
% date de création : 10/11/2022
% auteur: Chamot-Nonin Manon - Guergouri Ambre - Baum Jonathan

for particip_number=1:3 %choix du dataset
clc
close all
clearvars -except particip_number

%% Paramètres utilisateur
participant=["pere" "frere" "mere"]; %vecteur contenant la composante variable des noms des fichiers (à compléter par d'éventuels noms de fichiers supplémentaires)


%% chargement des données

load(['..\DAT\shorten_data_' char(participant(particip_number)) '.mat']) ;
N=size(data,1);

time=data(:,1); % y soustraire data(1,1) dans le cadre d'un fichier unix epoch
x=data(:,2);
y=data(:,3);
z=data(:,4);

%% Centrage des données
data_c(N,3)=0;

for i=1:3
    data_c(:,i)=data(:,i+1)-mean(data(:,i+1)); % retirer au signal sa moyenne permet de recentrer le signal et réduit son potentiel décallage du vrai 0
end

%% Filtrage des données centrées

filtered_data(N,3)=0;
[B,A] = butter(4, [0.5 20] ./ (Fs / 2)); %initialisation du filtre passe bande : 0.5 à 20 Hz --> bande passante typique de ce genre de signal

for i=1:3
    filtered_data(:,i) = filter(B, A, data_c(:,i));
end

xfilt=filtered_data(:,1);
yfilt=filtered_data(:,2);
zfilt=filtered_data(:,3);
clear B A

%% ENMO des données filtrées (ou signal vector magnitude SVM)

filtered_enmo(1:N)=0; %initialisation de la matrice enmo pour éviter son changement de taille à chaque itération
for i=1:N
    vector=[xfilt(i) yfilt(i) zfilt(i)];
    filtered_enmo(i)=norm(vector)-1; %euclidean norm minus one
    if filtered_enmo(i)<0
        filtered_enmo(i)=0; %valeurs négatives ramenées à 0
    end
end

clear vector i

%% moyennes epoch

window=1:60*Fs:N; % donne l'index de time de chaque début de plage de 60 sec
moyepoch(1:size(window,2)-1)=0;

for i = 1:size(window,2)-1
    moyepoch(1,i)=mean(filtered_enmo(window(i):window(i)+(60*Fs)-1));
end

%% cut-points

cuts=[0.030 0.090 0.250];
points(size(moyepoch,2)+1,1:4)=0;

for i=1:size(moyepoch,2)
    if moyepoch(1,i)<cuts(1)
        points(i,1)=1;
        points(end,1)=points(end,1)+1;
    elseif moyepoch(1,i)<cuts(2)
        points(i,2)=1;
        points(end,2)=points(end,2)+1;
    elseif moyepoch(1,i)<cuts(3)
        points(i,3)=1;
        points(end,3)=points(end,3)+1;
    else
        points(i,4)=1;
        points(end,4)=points(end,4)+1;
    end
end

%% Proportions de mouvement par intensité d'activité

percentact(1,:)= ["SED" "LA" "MA" "HA"];
for i = 1:4
   percentact(2,i)=round((points(end,i)/size(moyepoch,2))*100,2);
end

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

%% Données centrées

figure("WindowState",'maximized')
t=tiledlayout(3,1);
sgtitle('Données centrées')

nexttile
plot(time,data_c(:,1))
title('accélération en x')
xlim([time(1,1) time(end,1)])
ylabel('accélération (g)')

nexttile
plot(time,data_c(:,2),'r')
title('accélération en y')
xlim([time(1,1) time(end,1)])
ylabel('accélération (g)')

nexttile
plot(time,data_c(:,3),'g')
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

%% Moyenne EPOCH

figure("WindowState",'maximized')
plot(time(window(1:end-1))+30*Fs,moyepoch)
title('Signal moyenné selon fenêtres EPOCH de 60 secondes')
xlim([time(1,1) time(end,1)])
ylabel('accélération moyenne (g)')
xlabel('temps (s)')

% v(:,1)=time(Fs*60*find(points(:,2)==1)+30);
% v(:,2)=moyepoch(find(points(:,2)==1));
% hold on
% plot(v(:,1),v(:,2),'*')
% % plot(time(window(1:end-1))+30*Fs, moyepoch(find(points(:,3)==1)) ,'*','g')
% % plot(time(window(1:end-1))+30*Fs, moyepoch(find(points(:,4)==1)) ,'*','r')
% hold off

Color_window={'white','#EDB120','#D95319','#FF0000'};
patchingcuts=[0 0.030 0.090 0.250 0.4];
hold on
for i=1:4
zone=[0 patchingcuts(i); time(end,1) patchingcuts(i); time(end,1) patchingcuts(i+1); 0 patchingcuts(i+1)]; %x puis y
f=[1 2 3 4];
patch('Faces',f,'Vertices',zone,'FaceColor',Color_window{i},'FaceAlpha',.3)
end
hold off

for i=1:4
   pro(i)= strcat(percentact(1,i)," --> " , percentact(2,i), '%') ;
end

text(0.1e4,0.3,["Proportion temps/niveau d'activité :" pro(1) pro(2) pro(3) pro(4)])

%% sauvegarde figures

filename=["Donnees_brutes" "Donnees_centrees" "Donnees_filtrees" "epoch"];
for r=1:4
 saveas(figure(r),strcat('..\RES\', participant(particip_number), '\' ,filename(r) ,'.png'))
end
end