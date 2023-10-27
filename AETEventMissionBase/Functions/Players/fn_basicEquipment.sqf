/*
Author: Redwan S / Nomas

Description:
    This function is used to give a player the following basic equipment: Binoculars, Map, GPS, Radio, Compass, Watch, Radio Programmer, and basic medical and misc equipment in the uniform.

Arguments:
	0. <Array> Includes settings of the binoculars for everyone parameter 
		0.0. <String> Classname of the binoculars to be given to everyone
		0.1. <Boolean> Whether everyone should get binoculars

	1. <Array> Includes settings of the maps for everyone parameter
		1.0. <String> Classname of the map to be given to everyone
		1.1. <Boolean> Whether everyone should get maps

	2. <Array> Includes settings of the GPSs for everyone parameter
		2.0. <String> Classname of the GPS to be given to everyone
		2.1. <Boolean> Whether everyone should get GPSs

	3. <Array> Includes settings of the radios for everyone parameter
		3.0. <String> Classname of the radio to be given to everyone
		3.1. <Boolean> Whether everyone should get radios

	4. <Array> Includes settings of the hand watches for everyone parameter
		4.0. <String> Classname of the watch to be given to everyone
		4.1. <Boolean> Whether everyone should get watches
	
	5. <Boolean> Whether everyone should get radio programmers

	6. <Boolean> Whether everyone should get medical items and misc items in their uniform

	7. <Boolean> Whether everyone should get laser designator batteries

	8. <Array> Includes arrays of the classname of the items that should be added and how many of each, example: ["ACE_EarPlugs", 1]

	9. <Number> The value of which the uniform max load will be increased by

Return Value: <nil>

Example:
	private _binocularsForEveryone = ["Binocular", true];
	private _mapsForEveryone = ["ItemMap", true];
	private _GPSsForEveryone = ["ItemGPSs", false];
	private _radiosForEveryone = ["TFAR_anprc148jem", true];
	private _compassesForEveryone = ["ItemCompass", true];
	private _handWatchesForEveryone = ["ItemWatch", true];
	private _radioProgrammersForEveryone = true;
	private _medicalAndMiscForEveryone = true;
	private _laserDesignatorBatteryForEveryone = false;
	private _uniformMaxLoadIncrease = 75;

	private _uniformItems = [
		["ACE_EarPlugs", 1],
		["ACE_Flashlight_XL50", 1],
		["ACE_MapTools", 1],
		["acex_intelitems_notepad", 1],
		["ACE_CableTie", 2],
		["ACE_Canteen", 1],
		["ACE_SpraypaintBlack", 0],
		["ACE_SpraypaintBlue", 1],
		["ACE_SpraypaintGreen", 0],
		["ACE_SpraypaintRed", 0],
		["ACE_fieldDressing", 0],
		["ACE_elasticBandage", 10],
		["ACE_packingBandage", 10],
		["ACE_quikclot", 0],
		["ACE_epinephrine", 2],
		["ACE_morphine", 2],
		["ACE_bloodIV_250", 0],
		["ACE_bloodIV_500", 0],
		["ACE_bloodIV", 0],
		["ACE_personalAidKit", 0],
		["ACE_splint", 2],
		["ACE_tourniquet", 2]
	];

	[_binocularsForEveryone, _mapsForEveryone, _GPSsForEveryone, _radiosForEveryone, _compassesForEveryone, _handWatchesForEveryone, _radioProgrammersForEveryone, _medicalAndMiscForEveryone, _laserDesignatorBatteryForEveryone, _uniformItems, _uniformMaxLoadIncrease] call AET_fnc_basicEquipment;
*/
params ["_binocularsForEveryone", "_mapsForEveryone", "_GPSsForEveryone", "_radiosForEveryone", "_compassesForEveryone", "_handWatchesForEveryone", "_radioProgrammersForEveryone", "_medicalAndMiscForEveryone", "_laserDesignatorBatteryForEveryone", "_uniformItems", "_uniformMaxLoadIncrease"];

// Execution - Do not change anything below this line
// Maps and GPSs get added before the lobby map screen so players can see the map screen.
private _currentPlayerLoadout = getUnitLoadout player;

if (_mapsForEveryone select 1) then {
	private _currentPlayerMap = (_currentPlayerLoadout select 9) select 0;

	if (_currentPlayerMap == "") then {
		player linkItem (_mapsForEveryone select 0);
	};
};

if (_GPSsForEveryone select 1) then {
	private _currentPlayerGPS = (_currentPlayerLoadout select 9) select 1;

	if (_currentPlayerGPS == "") then {
		player linkItem (_GPSsForEveryone select 0);
	};
};

if (getClientState == "BRIEFING READ") then {
	private _programmerRequiredRadios = ["TFAR_anprc154", "TFAR_pnr1000a", "TFAR_rf7800str"];
	private _tfarCompatibleRadios = ["gm_radio_r126", "gm_radio_sem52a", "vn_o_item_radio_m252", "vn_b_item_radio_urc10", "TFAR_anprc148jem", "TFAR_anprc152", "TFAR_fadak"] + _programmerRequiredRadios;

	if ((uniform player) != "") then {
		private _playerUniform = uniformContainer player;
		private _uniformMaxLoad = (maxLoad _playerUniform) + _uniformMaxLoadIncrease;
		[_playerUniform, _uniformMaxLoad] remoteExec ["setMaxLoad", 2];

		[_playerUniform, _uniformMaxLoad, _uniformItems] spawn {
			params ["_playerUniform", "_uniformMaxLoad", "_uniformItems"];

			waitUntil {sleep 1; (maxLoad _playerUniform) == _uniformMaxLoad;};
			{ 
				for "_i" from 1 to (_x select 1) do {
					player addItemToUniform (_x select 0);
				};
			} forEach _uniformItems;
		};
	};

	if (_binocularsForEveryone select 1) then {
		private _currentPlayerBinoculars = binocular player;

		if (_currentPlayerBinoculars == "") then {
			player addWeaponGlobal (_binocularsForEveryone select 0);
		};
	};

	if (_radiosForEveryone select 1 || _radioProgrammersForEveryone) then {
		private _currentPlayerRadio = (_currentPlayerLoadout select 9) select 2;
		private _radioChecker = _tfarCompatibleRadios findif {_x in _currentPlayerRadio};

		if (_radioChecker == -1 && _radiosForEveryone select 1) then {
			_currentPlayerRadio = _radiosForEveryone select 0;

			player linkItem _currentPlayerRadio;
		};

		_radioChecker = _programmerRequiredRadios findif {_x in _currentPlayerRadio};

		if (_radioProgrammersForEveryone && _radioChecker > -1) then {
			player linkItem "TFAR_microdagr";
		} else {
			if (_handWatchesForEveryone select 1) then {
				private _currentPlayerHandWatch = (_currentPlayerLoadout select 9) select 4;

				if (_currentPlayerHandWatch == "") then {
					player linkItem (_handWatchesForEveryone select 0);
				};
			};
		};
	};

	if (_compassesForEveryone select 1) then {
		private _currentPlayerCompass = (_currentPlayerLoadout select 9) select 3;
		
		if (_currentPlayerCompass == "") then {
			player linkItem (_compassesForEveryone select 0);
		};
	};

	if (_laserDesignatorBatteryForEveryone) then {
		player addMagazineGlobal "Laserbatteries";
	};
};