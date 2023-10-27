// FF
if (hasInterface) then {
	[player] call FFPP_fnc_punishment_FF_addEH;
};

// Gun safety script
{
	[ACE_player, _x, true] call ace_safemode_fnc_setWeaponSafety;
} forEach (weapons ACE_player);

[missionNamespace, "AET_disclaimerDone", {
	sleep 5;
	{
		[ACE_player, _x, false] call ace_safemode_fnc_setWeaponSafety;
	} forEach (weapons ACE_player);
}
] call BIS_fnc_addScriptedEventHandler;

// Dynamic groups system
["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups;

// Add "Import Plan" ace action to the units in the array
private _importPlanPlayerList = ["Z_1", "Z_2", "P_1"] call HR_fnc_ValidateObjects;
[player, _importPlanPlayerList, 0] call AET_fnc_importPlan;