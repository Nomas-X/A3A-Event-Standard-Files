params ["_unit", "_importPlanList"];

if (_unit in _importPlanList) then {
	_statement = {
		[
			[true,""],
			"Import PLANOPS plan",
			{
				if _confirmed then {
					[_text] spawn {
						params ["_text"];
						[format["Plan import attempt by: %1 | ID64: %2 | Import text: %3", name player, getPlayerUID player, _text]] remoteExec ["diag_log", 2, false];
						_plan = _text regexFind ["private _data = \[.*\]; \n \n_/"];

						if (count _plan >= 1) then {
							_plan = (((_plan select 0) select 0) select 0) regexFind ["\[.*\]/"];
							private _errorHandler = -1;
							player setVariable ["A3A_importPlan_parseFlag", false, false];
							private _errorHandler = addMissionEventHandler ["ScriptError", {
								params ["_errorText", "_sourceFile", "_lineNumber", "_errorPos", "_content", "_stackTraceOutput"];
								if (_errorText == "parseSimpleArray format error") then {
									player setVariable ["A3A_importPlan_parseFlag", true, false];
									systemchat "Invalid input, a parsing error has occursed!";
									removeMissionEventHandler ["ScriptError", _errorHandler];
								};
							}];

							waitUntil {sleep 0.1; _errorHandler != -1};
							_plan = parseSimpleArray (((_plan select 0) select 0) select 0);

							if (!(player getVariable "A3A_importPlan_parseFlag")) then {
								_plan params ['_icons', '_poly', '_metis'];
								if (!isNil 'gtd_map_allMarkers') then {
									{
										deleteMarker _x;
									} forEach gtd_map_allMarkers;
								};

								if (!isNil 'gtd_map_allMetisMarkers') then {
									{
										[_x] call mts_markers_fnc_deleteMarker
									} forEach gtd_map_allMetisMarkers;
								};

								gtd_map_allMarkers = [];
								gtd_map_allMetisMarkers = [];

								{
									_x params ['_id', '_points', '_color'];
									_points params ['_x', '_y'];
									private _marker = createMarker [ format ['_USER_DEFINED #%1/planops%2/0', clientOwner, _id], [_x, _y], 0];
									_marker setMarkerShape 'polyline';
									_marker setMarkerPolyline _points;
									_marker setMarkerColor _color; 
									gtd_map_allMarkers pushBack _marker;
								} forEach _poly;

								{
									_x params ['_id', '_x', '_y', '_icon', '_color', '_text', '_rotate',['_scale',1]];
									private _marker = createMarker [ format ['_USER_DEFINED #%1/planops%2/0', clientOwner, _id], [_x, _y], 0];
									_marker setMarkerShape 'ICON';
									_marker setMarkerDir _rotate;
									_marker setMarkerColor _color; 
									_marker setMarkerText _text;
									_marker setMarkerType _icon;
									_marker setMarkerSize [_scale,_scale];
									gtd_map_allMarkers pushBack _marker;
								} forEach _icons;

								{
									_x params ['_id', '_x', '_y', '_sideid', '_dashed', '_icon', '_mod1', '_mod2', '_size', '_designation',['_scale',1]];
									private _marker = [[_x,_y], 0, true, [[_sideid, _dashed], [_icon, _mod1, _mod2], [_size, false, false], [], _designation], _scale * 1.3] call mts_markers_fnc_createMarker;
									gtd_map_allMetisMarkers pushBack _marker;
								} forEach _metis;

								publicVariable 'gtd_map_allMarkers';
								publicVariable 'gtd_map_allMetisMarkers';
							};
						};
					};
				} else {
					systemchat "Plan import cancelled";
				};
			},
			"Import",
			"Cancel"
		] call CAU_UserInputMenus_fnc_text;
	};
	_action = ["Import Plan", "Import Plan", "\A3\ui_f\data\map\markers\military\marker_CA.paa", _statement, {true}] call ace_interact_menu_fnc_createAction;	
	[_unit, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
};