clc
close all
clearvars %-except data

%% Paramètres utilisateur

reechantillonnage=1; %activation de la fonction pour rééchantillonner le dataset ? (1=ok 0=non)
participant=["pere" "frere" "mere"]; %vecteur contenant les nom spécifiques des fichiers (à compléter par d'éventuels noms de fichiers supplémentaires)

for i=1:3 %pour chaque participant
%% chargement des données 

data=load(strcat('..\DAT\data_' ,participant(i) ,'.csv'));
Fs=100; %freq d'échantillonnage de l'accéléromètre en Hz


%% rééchantillonnage

if reechantillonnage==1
    [data, Fe] = nvchantillonnage(data, Fs); %on peut modifier la Fe avec l'argument 'echant', x. Fe vaut 10Hz par défaut
    Fs=Fe; %changement de Fs d'origine par la nouvelle Fe
    clear Fe
end


filename=['..\DAT\shorten_data_',char(participant(i)),'.mat'];
save(filename,'data','Fs')
clear data Fs filename

end