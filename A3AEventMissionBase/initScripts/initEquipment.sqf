/*
Settings - Disable all uniform items if ACE is not loaded
Change to false if you'd like to turn a setting off
MicroDAGR uses the watch slot, so if you want to give the players a watch, just replace the class name

The following items [Binoculars, Radios, and MicroDAGR if a radio doesn't need it] will not be replaced by this script.
*/
private _binocularsForEveryone = ["Binocular", true];
private _mapsForEveryone = ["ItemMap", true];
private _radiosForEveryone = ["TFAR_anprc148jem", true];
private _compassesForEveryone = ["ItemCompass", true];
private _radioProgrammersForEveryone = true;
private _medicalAndMiscForEveryone = true;

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
// Maps gets executed before the lobby map screen so players can see the map screen.
if (_mapsForEveryone select 1) then {
	player linkItem (_mapsForEveryone select 0);
};

if (getClientState == "BRIEFING READ") then {
	private _programmerRequiredRadios = ["TFAR_anprc154", "TFAR_pnr1000a", "TFAR_rf7800str"];
	private _tfarCompatibleRadios = ["gm_radio_r126", "gm_radio_sem52a", "vn_o_item_radio_m252", "vn_b_item_radio_urc10", "TFAR_anprc148jem", "TFAR_anprc152", "TFAR_fadak"] + _programmerRequiredRadios;

	// Increasing Uniform Max Load | Increase the 50 to 75 if you are adding PAKs, IVS, or both
	private _playerUniform = uniformContainer player;
	private _uniformMaxLoad = (maxLoad _playerUniform) + 50;
	[_playerUniform, _uniformMaxLoad] remoteExec ["setMaxLoad", 2];

	private _currentPlayerLinkedItems = assignedItems player;

	if (_binocularsForEveryone select 1) then {
		private _binocularsChecker = binocular player;
		if (_binocularsChecker == "") then {
			player addWeaponGlobal (_binocularsForEveryone select 0);
		};
	};

	if (_radiosForEveryone select 1) then {
		if (_radiosForEveryone select 1) then {
			private _radioChecker = _currentPlayerLinkedItems arrayIntersect _tfarCompatibleRadios;
			if ((count _radioChecker) > 0) then {
				_radioChecker = _currentPlayerLinkedItems arrayIntersect _programmerRequiredRadios;
				if ((count _radioChecker) > 0 && _radioProgrammersForEveryone) then {
					player linkItem "TFAR_microdagr";
				};
			} else {
				player linkItem (_radiosForEveryone select 0);
			};
		};
	};

	if (_compassesForEveryone select 1) then {
		player linkItem (_compassesForEveryone select 0);
	};

	if ((uniform player) != "") then {
		{
			for "_i" from 1 to (_x select 1) do {
				player addItemToUniform (_x select 0);
			};
		} forEach _uniformItems;
	};
};