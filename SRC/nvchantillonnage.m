%% Fonction de réduction de l'échantillonnage du data set
% date de création : 12/11/2022
% auteur: Chamot-Nonin Manon - Guergouri Ambre - Baum Jonathan

%% Commentaire : 
% Le rééchantillonnage par défaut se fait à 50 Hz, cela permet de réduire
% le nombre d'échantillons à afficher graphiquement. On évite de passer en
% dessous des 40 Hz pour respecter Shannon compte tenu du filtre passe
% bande de 0.5 à 20 Hz (2*20Hz = 40Hz min pour respecter Shanon

function [dataslim, Fe] = nvchantillonnage(data, Fs, varargin)

%% Entrées additionnelles
p = inputParser;
addOptional(p,'echant', 50, @isnumeric);%nouvel échantillonnage à 50Hz par défaut, réglable avec l'input 'echant' dans la fonciton
parse(p,varargin{:});
p = p.Results;

%% Fonction

ratio=Fs/p.echant;
Fe=p.echant;

dataslim(size(data,1)/ratio,4)=0; %préconstruire la matrice permet de gagner en temps de calcul car matlab n'a pas besoin de modifier la taille de dataslim à chaque tour de boucle for

for i=1:size(data,1)/ratio
    dataslim(i,:)=data(i*ratio-(ratio-1),:); %-(ratio-1) pour prendre la première valeur de l'intervalle de ratio
end

end

