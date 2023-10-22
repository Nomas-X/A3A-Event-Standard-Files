# AET-Event user guide
## Description.ext
Each line has a comment next to it explaining what every line does and how and if it should be changed.

The main parameter to change as a mission maker are:
* author
* OnLoadName
* loadScreen
* overviewPicture
* briefingName
* overviewText

If you making a mission with respawns you should look into those parameters:
* respawnDelay

If you are not using ACE in your mission, make sure to change the parameter `respawnTemplates` to `respawnTemplates[] = {"Spectator"}`

## initScripts folder
The only thing you need to modify most of the time here would be the `initDiary.inc` file. The file contains the in-game briefing that you will need to modify according to your in-game lore or mission.

If you are using someone's work like scripts, music, artwork etc. you must give credit in the credit section of `initDiary.inc`.

## Init files
### init.sqf
This file is executed locally on every machine at the start of the mission or when the player joins in progress.

In most cases you do not need to change anything in this file, unless you know what you are doing.
### initPlayerLocal.sqf
This file is executed locally on every player's machine at the start of the mission or when the player joins in progress, this also includes headless clients.

In most cases you do not need to change anything in this file, unless you know what you are doing.
### initServer.sqf
This file is executed locally on the server at the mission start. This is the file where you should execute global commands like disabling damage, disabling or enabling AI, creating vehicles etc. You MUST NOT do these things in objects' init field.
### onPlayerRespawn.sqf
This file is executed locally for players when the mission starts and when they respawn.

In most cases you do not need to change anything in this file, unless you know what you are doing.
## Other files
Currently the only function that you can modify is `fn_dressUp.sqf` which can be found in `Functions\Players\fn_dressUp.sqf`. This function is used for giving players specific facewear or face. By default the function is disabled, so you need to uncomment the contents of the file by yourself when you need to use it.