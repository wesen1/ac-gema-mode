# ac-gema-mode
Gema mode for AssaultCube


# Description
A gema mode for AssaultCube written in CubeScript. The mode can be used online and offline.

Differences to playing on a gema server are:

* The item respawn rate is lower (especially health/armor/grenade packs do not work the same way)
* No flag reset
* /gonext not usable (if playing offline)


# Installation

Copy the ac-gema-mode.cfg file and the ac-gema-mode folder to your AssaultCube scripts folder. Then restart the game.


# Usage
Ingame press t and type ````/showmenu $menuGemaModeTitle````.

In order to avoid having to type that command each time you want to open the menu you can also bind it to a key, e.g. if you want to bind it to the key "L" type ````bind l [showmenu $menuGemaModeTitle]````. Then you can open the menu by just pressing "L".

