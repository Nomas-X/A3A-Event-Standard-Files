/*---------------------------------------------------------------------------
Title
	The code in this file is executed locally when player joins mission.
	For more info see https://community.bistudio.com/wiki/Event_Scripts#initPlayerLocal.sqf
	
	Parameters:
	0. OBJECT: the player's object
	1. BOOL: if the player Joins In Progress, the parameter returns true, otherwise false
---------------------------------------------------------------------------*/
params ["_player", "_jip"];

#include "initScripts\initScripts.sqf";
#include "initScripts\initDiary.sqf";
#include "initScripts\initDisclaimer.sqf";
#include "initScripts\initEquipment.sqf";

// Add "Import Plan" ace action to the units in the array
private _importPlanPlayerList = ["Z_1", "Z_2", "P_1"] call HR_fnc_ValidateObjects;
[player, _importPlanPlayerList, 0] call AET_fnc_importPlan;