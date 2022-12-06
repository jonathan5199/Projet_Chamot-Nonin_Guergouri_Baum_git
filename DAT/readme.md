Si vous voulez générer vous même les fichier rééchantillonnés, il faut d'abord extraire les fichier .csv des archives .zip.
Les cvs. ont été stockés sous ce format car le push des commits vers github ne permettait pas le transfert de fichiers .csv si volumineux

Nous avons fait un enregistrement de la famille d'ambre sous trois jours.
Chaque participant (trois au total) a porté le bracelet pendant l'intégralité de sa journée de travail.
Le fichier .cwa issu de l'enregistrement de trois jours a été subdivisé en 3 .csv respectif à chaque participant, et en éliminant les périodes où le bracelet n'était pas porté.

les fichiers .mat sont des sauvegardes des fichiers après rééchantillonnage, et permettent un chargement plus rapide des variables dans matlab, à la place de charger les .csv à chaque fois.
