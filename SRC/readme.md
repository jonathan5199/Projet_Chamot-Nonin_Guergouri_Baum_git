!!! Avant d'exécuter le main !!!

Si vous souhaitez rééchantilloner les fichiers .csv, utilisez "data_shorter" qui permet de rééchantillonner les données par la fonction "nvchantillonnage".
Ce script permet aussi de sauvegarder dans le dossier DAT, les données extraites des .csv en variables matlab afin de réduire le temps de chargement des données à l'initialisation du main.

Fonction "nvchantillonnage" : 
Le rééchantillonnage par la fonction "nvchantillonnage" se fait par défaut à 50 Hz, cela permet de réduire
le nombre d'échantillons à afficher graphiquement. On évite de passer en
dessous des 40 Hz pour respecter Shannon compte tenu du filtre passe
bande à venir de 0.5 à 20 Hz (2*20Hz = 40Hz min pour respecter Shanon)
La Fe est tout de même réglable à la main avec l'input 'echant' à présicer dans l'appel de la fonction.

"Main" : 
Pour chaque participant
Lis et affiche les données brutes après rééchantillonnage s'il a  eu lieu.
Recentre les données + affichage résultat
Filtre les données recentrée + affichage résultat
Calcul de la ENMO à partir des données filtrées 
Moyenne des données ENMO selon des fenêtres temporelles de 60s EPOCH + Représentatino des aires d'intensité d'AP sur ce signal
Détermination de l'appartenance des échantillons à chaque intensité d'AP selon des coeff prédéfinis
Calcul de la proportion de temps passé à chaque intensité d'AP
Sauvegarde des figures au format .png dans le dossier "RES"