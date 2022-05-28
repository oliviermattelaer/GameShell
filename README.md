GameShell: a "game" to teach the Unix shell
===========================================

![Illustration inspired by the game](Images/illustration-small.png)

Teaching first-year university students or high schoolers to use a Unix shell
is not always the easiest or most entertaining of tasks. GameShell was devised
as a tool to help students at the
[Université Savoie Mont Blanc](https://univ-smb.fr) to engage with a *real*
shell, in a way that encourages learning while also having fun. 

The original idea, due to Rodolphe Lepigre, was to run a standard bash session
with an appropriate configuration file that defined "missions" which would be
"checked" in order to progress through the game.

Here is the result...

![GameShell's first mission](Images/gsh-en.gif)


Feel free to send us your remarks, questions or suggestions by opening
[issues](https://github.com/phyver/GameShell/issues) or submitting
[pull requests](https://github.com/phyver/GameShell/pulls).
We are particularly interested in any new missions you might create!


Getting started
---------------

**Note:** GameShell is currently undergoing heavy development: the current
version has not been field tested by students. Do not hesitate to report any
problems you might encounter or suggestions you might have by
[opening an issue](https://github.com/phyver/GameShell/issues/new).

GameShell should work on any standard Linux system, and also on macOS and BSD
(but we have run fewer tests on the latter systems). On Debian or Ubuntu, the
only dependencies (besides `bash`) are the `gettext-base` and `awk` packages
(the latter is generally installed by default). Some missions have additional
dependencies: these missions will be skipped if the dependencies are not met.
On Debian or Ubuntu, run the following command to install all game and mission
dependencies.
```sh
$ sudo apt install gettext man-db procps psmisc nano tree bsdmainutils x11-apps wget
```
Check the [user manual](doc/user_manual.md) to see how to install the game
dependencies on other systems (macOS, BSD, ...).

Assuming all the dependencies are installed, you can try the latest version of
the game by running the following two commands in a terminal.
```sh
$ wget https://github.com/phyver/GameShell/releases/download/latest/gameshell.sh
$ bash gameshell.sh
```
The first command will download the latest version of the game in the form of
a self-extracting archive, and the second command will initialise and run the
game from the downloaded archive. Instructions on how to play are provided in
the game directly.

Note that when you quit the game (with `control-d` or the command `gsh exit`)
your progression will be saved in a new archive (called `GameShell-save.sh`).
Run this archive to resume the game where you left it.


If you prefer not running foreign shell scripts on your computer, you can
generate a Docker image with the following:
```sh
$ mkdir GameShell; cd GameShell
$ wget --quiet https://github.com/phyver/GameShell/releases/download/latest/Dockerfile
$ docker build -t gsh .
$ docker run -it gsh
```
The game will NOT be saved when you exit, and additional flags are required if
you want to run X programs from inside GameShell. Refer to [this
section](./doc/deps.md#running-GameShell-from-a-docker-container) of the user
manual.


Here is what the first mission looks like:
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

Press Enter to continue.


  ___________________________________________________________________
 /  __                                                           __  \
|  /  \   Welcome to GameShell!                                 /  \  |
|\ \   |                                                       |   / /|
| \___/|  Using and administering a computer running a         |\___/ |
|      |  Unix-like operating system (e.g., Linux, BSD or      |      |
|      |  macOS) requires using a command line interface       |      |
|      |  called "shell". In this game you will learn how      |      |
|      |  to use the shell by journeying through various       |      |
|      |  missions that will teach you to perform standard     |      |
|      |  tasks such as:                                       |      |
|      |    - creating directories,                            |      |
|      |    - creating, viewing and editing files,             |      |
|      |    - searching for files satisfying certain           |      |
|      |      criteria,                                        |      |
|      |    - running and interrupting programs,               |      |
|      |    - etc.                                             |      |
|      |                                                       |      |
|      |  During your adventure you will need to visit         |      |
|      |  locations, interact with people, and find various    |      |
|      |  objects. However, you have to keep in mind that      |      |
|      |  these are standard directories, programs, and        |      |
|      |  files (often with random contents). So, for          |      |
|      |  example:                                             |      |
|      |    - "build a hut" means creating a directory         |      |
|      |      called "Hut", and                                |      |
|      |    - "put a coin in your chest" means moving a file   |      |
|      |      called "coin" to a directory called "Chest".     |      |
|      |                                                       |      |
 \     |_______________________________________________________|     /
  \___/                                                         \___/


Press Enter to continue.



  |                                                   |
--+---------------------------------------------------+--
  | Run the command                                   |
  |     $ gsh goal                                    |
  | to discover your first mission.                   |
  |                                                   |
  | You can check the mission has been completed with |
  |     $ gsh check                                   |
  |                                                   |
  | The command                                       |
  |     $ gsh help                                    |
  | displays the list of available (gsh) commands.    |
--+---------------------------------------------------+--
  |                                                   |

[mission 1] $ gs goal

  ,------------------------------------------------------.
 (_\                                                      \
    |  Mission goal                                        |
    |  ============                                        |
    |                                                      |
    |  Go to the top of the main tower of the castle.      |
    |                                                      |
    |                                                      |
    |  Useful commands                                     |
    |  ===============                                     |
    |                                                      |
    |  cd LOCATION                                         |
    |    Move to the given location.                       |
    |    Remark: ``cd`` is an abbreviation for "change     |
    |    directory".                                       |
    |                                                      |
    |  pwd                                                 |
    |    Show the path to your current location.           |
    |    Remark: ``pwd`` is an abbreviation for "print     |
    |    working directory".                               |
    |                                                      |
    |  ls                                                  |
    |    Show a list of locations that are currently       |
    |    accessible.                                       |
    |    Remark: ``ls`` is an abbreviation of "list".      |
    |                                                      |
    |  gsh check                                           |
    |    Check if the mission objective has been achieved. |
    |                                                      |
    |  gsh reset                                           |
    |    Restart the mission from the beginning.           |
    |                                                      |
    |                                                      |
    |  Remarks                                             |
    |  -------                                             |
    |                                                      |
    |  UPPERCASE words appearing in commands are           |
    |  meta-variables: you need to replace them by         |
    |  appropriate (string) values.                        |
    |                                                      |
    |  Most filesystems treat uppercase and lowercase      |
    |  characters differently. Make sure you use the       |
    |  correct path.                                       |
   _|                                                      |
  (_/________________________________________________(*)___/
                                                      \\
                                                       ))
                                                       ^

[mission 1] $ ls
Castle	Forest	Garden	Mountain  Stall
[mission 1] $ cd Castle/
[mission 1] $ ls
Cellar	Great_hall  Main_building  Main_tower  Observatory
[mission 1] $ cd Main_tower/
[mission 1] $ ls
First_floor
[mission 1] $ cd First_floor/
[mission 1] $ ls
Second_floor
[mission 1] $ cd Second_floor/
[mission 1] $ ls
Top_of_the_tower
[mission 1] $ cd Top_of_the_tower/
[mission 1] $ ls
[mission 1] $ gsh check

Congratulations, mission 1 has been successfully completed!


  |                                    |
--+------------------------------------+--
  | Use the command                    |
  |     $ gsh help                     |
  | to get the list of "gsh" commands. |
--+------------------------------------+--
  |                                    |

[mission 2] $
````

Documentation
-------------

To find out more about GameShell, refer to the following documents:
- The [user manual](doc/user_manual.md) provides information on how to run the
  game on all supported platforms (Linux, macOS, BSD), explains how to run the
  game from the sources, tells you how to generate custom game archives (which
  is useful if you want to use GameShell for teaching a class), and more.
- The [developer manual](doc/dev_manual.md) provides information on how to
  create new missions, how to translate missions, and how to participate
  in the development of the game.


Who is developing GameShell?
----------------------------

### Developers

The game is currently being developed by:
* [Pierre Hyvernat](http://www.lama.univ-smb.fr/~hyvernat) (main developer,
  [pierre.hyvernat@univ-smb.fr](mailto:pierre.hyvernat@univ-smb.fr)),
* [Rodolphe Lepigre](https://lepigre.fr).

### Mission contributors

* Pierre Hyvernat
* Rodolphe Lepigre
* Christophe Raffalli
* Xavier Provencal
* Clovis Eberhart
* Sébastien Tavenas
* Tiemen Duvillard

### Special thanks

* All the students who found *many* bugs in the early versions.
* Joan Stark (a.k.a, jgs), who designed hundreds of ASCII-art pieces in the
  late 90s. Most of the ASCII-art encountered in GameShell are due to her.


Licence
-------

GameShell is released under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

Please link to this repository if you use GameShell.

GameShell is open source and free to use. One way you can acknowledge the work
it required is by sending an actual postcard to

```
  Pierre Hyvernat
  Laboratoire de Mathématiques, CNRS UMR 5127
  Université de Savoie
  73376 Le Bourget du Lac
  FRANCE
```

