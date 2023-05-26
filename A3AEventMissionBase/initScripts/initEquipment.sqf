/*
Settings - Disable all uniform items if ACE is not loaded
Change to false if you'd like to turn a setting off

The following items [Binoculars, Maps, GPSs, Compasses, Watches, Radios, and MicroDAGR if a radio doesn't need it] will not be replaced by this script
Radio programmers take priority over hand watches if _radioProgrammersForEveryone is set to true
Radio Programmers will only be added if the player has a radio that needs the programmer
If you are switching the binculars for a laser designator, make sure to enable the batteries setting
*/
private _binocularsForEveryone = ["Binocular", true];
private _mapsForEveryone = ["ItemMap", true];
private _gpsForEveryone = ["ItemGPS", false];
private _radiosForEveryone = ["TFAR_anprc148jem", true];
private _compassesForEveryone = ["ItemCompass", true];
private _handWatchesForEveryone = ["ItemWatch", true];
private _radioProgrammersForEveryone = true;
private _medicalAndMiscForEveryone = true;
private _laserDesignatorBatteryForEveryone = false;

// Uniform - The string is the item's classname, the number is the amount
private _uniformItems = [
	// Misc Equipment
	["ACE_EarPlugs", 1], // Earplugs
	["ACE_Flashlight_XL50", 1], // Map Flash Light
	["ACE_MapTools", 1], // Map Tools
	["acex_intelitems_notepad", 1], // Notepad
	["ACE_CableTie", 2], // Cable Tie
	["ACE_Canteen", 1], // Canteen
	// Medical
	["ACE_fieldDressing", 0], // Basic Bandages
	["ACE_elasticBandage", 10], // Elastic Bandages
	["ACE_packingBandage", 10], // Packing Bandages
	["ACE_quikclot", 0], // Quickclot Bandages
	["ACE_epinephrine", 2], // Epinephrine
	["ACE_morphine", 2], // Morphine
	["ACE_bloodIV_250", 0], // Blood IV 250ml
	["ACE_bloodIV_500", 0], // Blood IV 500ml
	["ACE_bloodIV", 0], // Blood IV 1000ml
	["ACE_personalAidKit", 0], // Personal Aid Kit
	["ACE_splint", 2], // Splint
	["ACE_tourniquet", 2] // Tourniquet
];

// Execution - Do not change anything below this line
// Maps and GPSs get added before the lobby map screen so players can see the map screen.
private _currentPlayerLoadout = getUnitLoadout player;

if (_mapsForEveryone select 1) then {
	private _currentPlayerMap = (_currentPlayerLoadout select 9) select 0;

	if (_currentPlayerMap == "") then {
		player linkItem (_mapsForEveryone select 0);
	};
};

if (_gpsForEveryone select 1) then {
	private _currentPlayerGPS = (_currentPlayerLoadout select 9) select 1;

	if (_currentPlayerGPS == "") then {
		player linkItem (_gpsForEveryone select 0);
	};
};

if (getClientState == "BRIEFING READ") then {
	private _programmerRequiredRadios = ["TFAR_anprc154", "TFAR_pnr1000a", "TFAR_rf7800str"];
	private _tfarCompatibleRadios = ["gm_radio_r126", "gm_radio_sem52a", "vn_o_item_radio_m252", "vn_b_item_radio_urc10", "TFAR_anprc148jem", "TFAR_anprc152", "TFAR_fadak"] + _programmerRequiredRadios;

	// Increasing Uniform Max Load | Increase the 50 to 75 if you are adding PAKs, IVS, or both
	private _playerUniform = uniformContainer player;
	private _uniformMaxLoad = (maxLoad _playerUniform) + 50;
	[_playerUniform, _uniformMaxLoad] remoteExec ["setMaxLoad", 2];

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

	if ((uniform player) != "") then {
		{
			for "_i" from 1 to (_x select 1) do {
				player addItemToUniform (_x select 0);
			};
		} forEach _uniformItems;
	};

	if (_laserDesignatorBatteryForEveryone) then {
		player addMagazineGlobal "Laserbatteries";
	};
};