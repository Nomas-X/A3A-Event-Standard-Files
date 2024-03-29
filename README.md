# AET Standardized Files Guide
## description.ext
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

## cba_settings.sqf
This file controls the mission side add-on options, also known as CBA settings.
Settings between the `// MISSION MAKERS ONLY TOUCH THIS //` comments are what you are expected to edit; other settings require permission from an Event Team Lead.

## AET_scripts folder
This folder contains the scripts and function calls that are required in every mission.
The only files you need to modify most of the time are `AET_diary.sqf` and `AET_equipment.sqf`.
### AET_diary.sqf
This file handles the in-game briefing entries, you are expected to:
1. Credit any scripts, music, artwork, material or content that requires crediting.
2. Ensure that the Situation, Mission, Execution, Addtional, and Signals sections match exactly what is in the warno.

### AET_equipment.sqf
This file handles ensuring that players always have their basic equipment, from radios and binoculars to medical and miscellaneous items.

You can configure the script to fit your mission, limiting radios or GPS, for example.

It is important that you read the comment at the top of the file to gain an understanding of how the function works.

### AET_desclaimer.sqf
This file handles the disclaimer at the start of the mission. It is highly advised not to change anything in this file, even if your mission does not need a disclaimer.

Should you want to add extra panels to the disclaimer, the file includes comments on what to add and do to achieve that.

### AET_onPlayerRespawn.sqf
This file includes comments that show how some functions are meant to be used. More details about functions can be found in the relevant section.

## Init files
### init.sqf
This file is executed locally on every machine at the start of the mission or when a player joins in progress.

You can set a friendly fire logger for an AI through this file as shown in the comment.

In most cases you do not need to change anything in this file, unless you know what you are doing.

### initPlayerLocal.sqf
This file is executed locally on every player's machine at the start of the mission or when the player joins in progress, this also includes headless clients.

In most cases you do not need to change anything in this file, unless you know what you are doing.

### initServer.sqf
This file is executed locally on the server at the mission start. This is the file where you should execute global commands like disabling damage, disabling or enabling AI, creating vehicles etc.

The file includes a guide in the comment on how to execute things on layer contents and how to disable and enable AI abilities by layer.

### onPlayerRespawn.sqf
This file is executed locally for players when the mission starts, when they spawn in, or when they respawn.

In most cases you do not need to change anything in this file, unless you know what you are doing.

## Useful Functions
### antiFlubber
Prevents smoke under-barrel launched grenades from bouncing when they hit the ground.

The function is active by default in `init.sqf`. To turn it off, simply comment out the function call.

### setFaces
Sets the player faces regardless of their profile settings.

It will change the face of any player in the player list to a random face of the faces in the faces list.

Execute in `AET_onPlayerRespawn.sqf` or `onPlayerRespawn.sqf`.

Example:
```sqf
private _listOfPlayers_1 = ["P_1", "P_2", "P_3"] call HR_fnc_ValidateObjects;

private _listOfFaces_1 = ["PersianHead_A3_04_a", "PersianHead_A3_04_l", "PersianHead_A3_04_sa"];

[player, _listOfPlayers_1, _listOfFaces_1] call AET_fnc_setFaces;
```

### startInVehicle
Starts a player inside a vehicle. It will teleport any player in the player list into the next available cargo seat of the chosen vehicle, and if the vehicle is full or is no longer alive then the player will instead be teleported to the designated marker.

This function is the only allowed method to start players inside a vehicle.

Execute in `AET_onPlayerRespawn.sqf` or `onPlayerRespawn.sqf`.

Example:
```sqf
private _listOfPlayers_2 = ["P_1", "P_2", "P_3"] call HR_fnc_ValidateObjects;

[player, _listOfPlayers_2, HELI_2, "LZ"] call AET_fnc_startInVehicle;
```

### diableLayerAI
Disables an AI feature for all units within a given layer.

Recommended to use over unit init fields in the editor.

Execute in `initServer.sqf`.

Example:
```sqf
["Ambush Layer", "PATH"] call AET_fnc_disableLayerAI;
```

### enableLayerAI
Enables an AI feature for all units within a given layer.

Recommended to use over unit init fields in the editor.

Execute in `initServer.sqf`.

Example:
```sqf
["Layer 1", "TARGET"] call AET_fnc_enableLayerAI;
```

### markTriggersInLayer
Takes all triggers in a Layer and places an area marker on it with its size and places a normal marker on the Trigger's center with the trigger's name.

Recommended to use by mission makers to allow Zeus to see triggers on the map.

Execute in `initServer.sqf`.

Example:
```sqf
private _listOfPlayers_3 = ["Z_1", "Z_2"] call HR_fnc_ValidateObjects;

if (player in _listOfPlayers_3) then {
	[["Triggers_Layer"], "AET_fnc_getLayer", [], "AET_fnc_markTriggersInLayer"] remoteExec ["AET_fnc_useRemoteReturn", 2];
};
```

### markTriggersInMission
Finds each trigger in the mission, places an area marker on it with its size and places a normal marker on the Trigger's center with the trigger's name.

Recommended to use by mission makers to allow Zeus to see triggers on the map or to help during Quality Assurance.

Execute in `initServer.sqf`.

Example:
```sqf
[] call AET_fnc_markTriggersInMission;
```