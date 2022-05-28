# GameShell : un "jeu" pour apprendre le shell Unix
=================================================

![Illustration inspired by the game](art/illustration-small.png)

Enseigner l'utilisation d'un shell Unix à des étudiants de première année à
l'université ou à des lycéens n'est pas toujours simple, ni très amusant.
GameShell a été conçu comme un outil pour aider les étudiants de [l'Université
Savoie Mont Blanc](https://univ-smb.fr) à découvrir un *vrai* shell, avec une
approche qui favorise l'apprentissage tout en s'amusant.

L'idée initiale, due à Rodolphe Lepigre, était de lancer une session bash avec
un fichier de configuration qui définissait des "missions", qui seraient
"validées" pour avancer dans le jeu.

Voilà le résultat...

![la première mission de GameShell](Images/gsh-fr.gif)

N'hésitez pas à nous envoyer vos remarques, questions ou suggestions en
ouvrant des ["issues"](https://github.com/phyver/GameShell/issues) ou en
soumettant des ["pull requests"](https://github.com/phyver/GameShell/pulls).
Nous sommes particulièrement intéressés pas toute nouvelle mission que vous
pourriez créer !


Comment jouer ?
---------------

**Note:** GameShell est en phase de développement : la version courante n'a
pas été intensivement testée par des étudiants. N'hésitez pas à rapporter tout
problème que vous pourriez rencontrer et toute suggestion d'amélioration en
ouvrant une ["issue"](https://github.com/phyver/GameShell/issues/new).

GameShell devrait fonctionner sur n'importe quel système Linux standard, et
aussi sur macOS et BSD (mais ces systèmes ont été moins testés). Sur Debian ou
Ubuntu, les seules dépendances (autres que `bash`) sont les paquets `awk` et
`gettext-base` (le premier étant généralement installé par défaut). Certaines
missions ont des dépendances additionnelles : elles seront annulées si leurs
dépendances ne sont pas satisfaites. Sur Debian ou Ubuntu, lancez la commande
suivante pour installer toutes les dépendances pour le jeu et les missions.
```sh
$ sudo apt install gettext-base man-db psmisc nano tree bsdmainutils x11-apps
```
Consultez le [manuel utilisateur](doc/user_manual.md) (en anglais) pour voir
comment installer les dépendances sur d'autres systèmes (macOS, BSD, ...).

En supposant que toutes les dépendances sont installées, vous pouvez essayer
la dernière version du jeu en lançant les deux commandes suivantes dans un
terminal.
```sh
$ wget https://github.com/phyver/GameShell/releases/download/latest/gameshell.sh
$ bash gameshell.sh
```
La première commande téléchargera la dernière version du jeu sous la forme
d'une archive auto-extractible, et la seconde commande initialisera et lancera
le jeu à partir de cette archive. Les instructions pour jouer sont données
directement dans le jeu.

Quand vous quitterez le jeu (avec `control-d` ou la commande `gsh exit`) votre
progression sera sauvegardée dans une nouvelle archive (nommée
`GameShell-save.sh`). Elle peut être lancée pour reprendre le jeu où vous vous
étiez arrêté.


Si vous préférez ne pas exécuter des scripts étrangers sur votre machine,
vous pouvez générer une image Docker avec :
```sh
$ mkdir GameShell; cd GameShell
$ wget --quiet https://github.com/phyver/GameShell/releases/download/latest/Dockerfile
$ docker build -t gsh .
$ docker run -it gsh
```
Votre progression ne sera PAS sauvée lorsque vous quittez le jeu, et des
options supplémentaires sont nécessaires si vous souhaitez lancer des
programmes X depuis GameShell. Référez vous à [cette
section](./doc/deps.md#running-GameShell-from-a-docker-container) du manuel
d'utilisateur.


Voila à quoi ressemble la première mission :
````
$ bash ./gameshell.sh

  ____                      ____  _          _ _
 / ___| __ _ _ __ ___   ___/ ___|| |__   ___| | |
| |  _ / _` | '_ ` _ \ / _ \___ \| '_ \ / _ \ | |
| |_| | (_| | | | | | |  __/___) | | | |  __/ | |
 \____|\__,_|_| |_| |_|\___|____/|_| |_|\___|_|_|

                             _
                           _/ \
          _               /    \
         / \_   __       /\/\  /\
        /    \ /  \     /    \/  \
       /\/\  /\    `--./.'-    `-.\
      /    \/  ' ^ _    _  _
    /\ ____..      YY  Y     _   |~  _
   /._/  _ \_        Y  Y   [_]--'--[_]
  / / .'/#\_ `-.    Y  YY   |'|""`""|'|
    .-_/#@##\  `\"" ' Y     | | /^\ | |
   " "'"''"'"'''" '         |_|_|I|_|_|

Appuyez sur Entrée pour continuer.



  ,-------------------------------------------------------.
 (_\                                                       \
    |  Bienvenue dans GameShell !                           |
    |                                                       |
    |  Utiliser et gérer un ordinateur avec un système      |
    |  d'exploitation de type Unix (comme Linux, BSD ou     |
    |  macOS) demande l'utilisation d'une interface en      |
    |  ligne de commande appelée "shell". Dans ce jeu vous  |
    |  allez apprendre à utiliser le shell au travers de    |
    |  diverses missions impliquant des tâches habituelles  |
    |  comme :                                              |
    |    - créer des répertoires,                           |
    |    - créer, éditer ou visualiser des fichiers,        |
    |    - chercher les fichiers satisfaisant certains      |
    |      critères,                                        |
    |    - lancer ou arrêter des programmes,                |
    |    - etc.                                             |
    |                                                       |
    |  Durant votre aventure il vous sera demandé de        |
    |  vous rendre dans des lieux, d'interagir avec des     |
    |  personnages, et de trouver des objets. Cependant,    |
    |  gardez à l'esprit que tous ces éléments du jeu       |
    |  font référence à des concepts standards : des        |
    |  répertoires, des programmes, et des fichiers (avec   |
    |  un contenu qui peut être aléatoire). Ainsi, par      |
    |  exemple :                                            |
    |    - "construire une hutte" signifie créer un         |
    |      dossier "Hutte",                                 |
    |    - "mettre la pièce dans le coffre" signifie        |
    |      déplacer un fichier "piece" dans un répertoire   |
    |      "Coffre".                                        |
   _|                                                       |
  (_/_________________________________________________(*)___/
                                                       \\
                                                        ))
                                                        ^


Appuyez sur Entrée pour continuer.


  |                                                     |
--+-----------------------------------------------------+--
  | Utilisez la commande                                |
  |   $ gsh goal                                        |
  | pour découvrir votre première mission.              |
  |                                                     |
  | Vous pouvez vérifier si l'objectif est atteint avec |
  |   $ gsh check                                       |
  |                                                     |
  | La commande                                         |
  |   $ gsh help                                        |
  | affiche la liste des commandes (gsh) disponibles.   |
--+-----------------------------------------------------+--
  |                                                     |

[mission 1] $ gsh goal

     _______________________________________________________
()==(                                                      (@==()
     '______________________________________________________'|
       |                                                     |
       | Objectif                                            |
       | ========                                            |
       |                                                     |
       | Allez tout en haut du donjon.                       |
       |                                                     |
       |                                                     |
       | Commandes utiles                                    |
       | ================                                    |
       |                                                     |
       | cd LIEU                                             |
       |   Se déplace vers le lieu donné.                    |
       |   Note : ``cd`` est une abréviation pour "change    |
       |   directory".                                       |
       |                                                     |
       | ls                                                  |
       |   Liste les lieux accessibles depuis la position    |
       |   actuelle.                                         |
       |   Note : ``ls`` est une abréviation pour "liste".   |
       |                                                     |
       | pwd                                                 |
       |   Affiche la position actuelle.                     |
       |   Note : ``pwd`` est une abréviation pour "print    |
       |   working directory".                               |
       |                                                     |
       | gsh check                                           |
       |   Vérifie si l'objectif de la mission a été         |
       |   atteint.                                          |
       |                                                     |
       | gsh reset                                           |
       |   Ré-initialise la mission au début.                |
       |                                                     |
       |                                                     |
       | Remarque                                            |
       | --------                                            |
       |                                                     |
       | Les termes apparaissant en MAJUSCULES dans les      |
       | commandes sont des méta-variables : vous devez les  |
       | remplacer par des valeurs (chaines de caractères)   |
       | appropriées.                                        |
       |                                                     |
       | La plupart des systèmes de fichiers différencient   |
       | les caractères majuscules et minuscules. Faites     |
       | attention à utiliser le bon chemin.                 |
     __)_____________________________________________________|
()==(                                                       (@==()
     '------------------------------------------------------'


[mission 1] $ ls
Chateau  Echoppe  Foret  Jardin  Montagne
[mission 1] $ cd Chateau
[mission 1] $ ls
Batiment_principal  Cave  Donjon  Grande_salle	Observatoire
[mission 1] $ cd Donjon/
[mission 1] $ ls
Premier_etage
[mission 1] $ cd Premier_etage/
[mission 1] $ ls
Deuxieme_etage
[mission 1] $ cd Deuxieme_etage/
[mission 1] $ ls
Haut_du_donjon
[mission 1] $ cd Haut_du_donjon/
[mission 1] $ gsh check

Bravo, vous avez réussi la mission 1 !


  |                                            |
--+--------------------------------------------+--
  | Tapez la commande                          |
  |     $ gsh help                             |
  | pour obtenir la liste des commandes "gsh". |
--+--------------------------------------------+--
  |                                            |

[mission 2] $
````

Documentation
-------------

Pour en savoir plus sur GameShell les documents suivants sont disponibles (en
langue anglaise uniquement):
- Le [manuel utilisateur](doc/user_manual.md) explique, entre autres, comment
  lancer le jeu sur toutes les plateformes supportées (Linux, macOS, BSD),
  comment lancer le jeu à partir des sources, et comment générer une archive
  de jeu personnalisée (ce qui est utile pour utiliser le jeu dans le cadre
  d'un cours).
- Le [manuel développeur](doc/dev_manual.md) explique, entre autres, comment
  créer une nouvelle mission, comment traduire le jeu et les missions, et
  comment participer au développement du jeu.


Qui développe GameShell?
------------------------

### Développeurs

Le jeu est développé par:
* [Pierre Hyvernat](http://www.lama.univ-smb.fr/~hyvernat) (développeur
  principal, [pierre.hyvernat@univ-smb.fr](mailto:pierre.hyvernat@univ-smb.fr)),
* [Rodolphe Lepigre](https://lepigre.fr).

### Contributeurs missions

* Pierre Hyvernat
* Rodolphe Lepigre
* Christophe Raffalli
* Xavier Provencal
* Clovis Eberhart
* Sébastien Tavenas
* Tiemen Duvillard

### Remerciements

* Tous les étudiants qui ont testé les toutes premières versions du jeu.
* Joan Stark (alias jgs) qui a créé des centaines d'ASCII-art à la fin des
  années 90. La majorité des ASCII-art que vous rencontrerez dans GameShell
  lui sont dus.


Licence
-------

GameShell est distribué sous la licence [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

Merci de pointer vers ce dépôt si vous l'utilisez.

GameShell est open source et son utilisation est gratuite. Une manière de
reconnaitre le travail que cela à nécessité est d'envoyer un carte postale à

```
  Pierre Hyvernat
  Laboratoire de Mathématiques, CNRS UMR 5127
  Université de Savoie
  73376 Le Bourget du Lac
  FRANCE
```

