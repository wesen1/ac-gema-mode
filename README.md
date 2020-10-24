ac-gema-mode
============

Gema mode for AssaultCube


Description
-----------

A gema mode for AssaultCube written in CubeScript. The mode can be used online and offline.

### Features

* Easy to use
* Customizable
* Shows map statistics and score messages on gema maps
* Saves your best score times per weapon per map
* Allows you to race against a target time


### Differences to playing on a gema server

* The item respawn rate is lower (especially health/armor/grenade packs do not work the same way)
* No flag reset
* `/gonext` not usable (if playing offline)


### Tips for playing on non gema servers ###

You should try to find a server that allows you to:

* vote a map with a time limit of 60 minutes (`/ctf <map name> 60`)
* disable autoteam (`/autoteam 0`)


Screenshots
-----------

### Main menu and score message
![Main menu and score message](readme/screenshots/main-menu.jpg?raw=true "Main menu and score message")

### Weapon records
![Weapon records](readme/screenshots/weapon-records.jpg?raw=true "Weapon records")

### Map Statistics
![Map Statistics on loading a gema map](readme/screenshots/map-statistics.jpg?raw=true "Map Statistics on loading a gema map")


Installation
------------

Copy the ac-gema-mode.cfg file and the ac-gema-mode folder to your AssaultCube scripts folder. Then restart the game.


Usage
-----

Ingame press "T" and type `/showGemaModeMenu`.

In order to avoid having to type that command each time you want to open the menu you can also bind it to a key, e.g. if you want to bind it to the key "L" type `bind l showGemaModeMenu`. Then you can open the menu by just pressing "L".
