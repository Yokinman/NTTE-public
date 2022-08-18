#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Setup Objects:
	call(scr.obj_add, script_ref_create(HyperSlashTrail_create));
	
	 // Store Script References:
	with([
		weapon_set_temerge, weapon_deactivate_temerge, weapon_activate_temerge, weapon_add_temerge, weapon_delete_temerge, weapon_has_temerge, weapon_has_temerge_weapon, weapon_is_temerge_part, weapon_get_temerge_weapon, weapon_set_temerge_weapon, weapon_add_temerge_weapon, temerge_decide_weapon, temerge_weapon_event_set_script,
		projectile_add_temerge_event, projectile_add_temerge_effect, projectile_has_temerge_effect, projectile_add_temerge_scale, projectile_add_temerge_bloom, projectile_add_temerge_damage, projectile_add_temerge_force, projectile_can_temerge_hit, projectile_temerge_wall_bounce, projectile_temerge_destroy,
		temerge_effect_add_event, temerge_effect_call_event
	]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // Object Event Variable Names:
	global.object_event_index_list_map = mod_variable_get("mod", "teassets", "object_event_index_list_map");
	global.event_varname_list          = mod_variable_get("mod", "teassets", "event_varname_list");
	
	 // Volume-Muffled Sounds:
	global.sound_muffle_map = ds_map_create();
	
	 // 'draw_text_nt' Color Tags:
	global.nt_tag_color_map = ds_map_create();
	global.nt_tag_color_map[? "w"] = c_white;
	global.nt_tag_color_map[? "s"] = make_color_rgb(125, 131, 141);
	global.nt_tag_color_map[? "d"] = make_color_rgb( 59,  62,  67);
	global.nt_tag_color_map[? "r"] = make_color_rgb(252,  56,   0);
	global.nt_tag_color_map[? "y"] = make_color_rgb(250, 171,   0);
	global.nt_tag_color_map[? "g"] = make_color_rgb( 68, 198,  22);
	global.nt_tag_color_map[? "b"] = make_color_rgb( 22,  97, 223);
	global.nt_tag_color_map[? "p"] = make_color_rgb( 86,  34, 110);
	with(ds_map_keys(global.nt_tag_color_map)){
		global.nt_tag_color_map[? string_upper(self)] = global.nt_tag_color_map[? self];
	}
	
	 // Merged Weapon Event Scripts:
	global.weapon_event_script_map = ds_map_create();
	with([
		"weapon_name",
		"weapon_text",
		"weapon_swap",
		"weapon_sprt",
		"weapon_sprt_hud",
		"weapon_loadout",
		"weapon_area",
		"weapon_gold",
		"weapon_type",
		"weapon_cost",
		"weapon_rads",
		"weapon_load",
		"weapon_auto",
		"weapon_melee",
		"weapon_laser_sight",
		"weapon_red",
		"weapon_reloaded",
		"weapon_step",
		"player_fire",
		"weapon_fire",
		"projectile_setup"
	]){
		var	_eventName   = self,
			_scriptIndex = script_get_index("temerge_" + _eventName);
			
		if(_scriptIndex >= 0){
			switch(_eventName){
				case "weapon_fire":
				case "player_fire":
					temerge_weapon_event_set_script(_eventName, script_ref_create(_scriptIndex, false));
					break;
					
				default:
					temerge_weapon_event_set_script(_eventName, script_ref_create(_scriptIndex));
			}
		}
	}
	
	 // Merged Effect Events:
	global.temerge_effect_event_script_list_table = ds_map_create();
	temerge_effect_add_event("hit_event",  "post_step", script_ref_create(temerge_collision_event_effect_post_step, "hit"));
	temerge_effect_add_event("wall_event", "post_step", script_ref_create(temerge_collision_event_effect_post_step, "wall"));
	for(var _scriptIndex = 1; true; _scriptIndex++){
		var _scriptName = script_get_name(_scriptIndex);
		if(_scriptName != undefined){
			var	_scriptNameSplit       = string_split(_scriptName, "_"),
				_scriptNameSplitLength = array_length(_scriptNameSplit);
				
			if(_scriptNameSplit[0] == "temerge"){
				var _scriptNameSplitEffectIndex = array_find_last_index_ext(_scriptNameSplit, "effect", _scriptNameSplitLength - 1);
				if(_scriptNameSplitEffectIndex > 1){
					temerge_effect_add_event(
						array_join(array_slice(_scriptNameSplit, 1, _scriptNameSplitEffectIndex - 1), "_"),
						array_join(array_slice(_scriptNameSplit, _scriptNameSplitEffectIndex + 1, _scriptNameSplitLength - (_scriptNameSplitEffectIndex + 1)), "_"),
						script_ref_create(_scriptIndex)
					);
				}
			}
		}
		else break;
	}
	
	 // Merged Projectile Default Events:
	global.object_temerge_event_table = ds_map_create();
	for(var _objectIndex = 0; object_exists(_objectIndex); _objectIndex++){
		if(object_is_ancestor(_objectIndex, projectile)){
			var	_mergeEventMap       = {},
				_objectHasMergeEvent = false;
				
			with(["fire", "setup", "hit", "wall", "destroy"]){
				var _mergeEventName = self;
				lq_set(_mergeEventMap, _mergeEventName, undefined);
				for(
					var _mergeEventObjectIndex = _objectIndex;
					object_is_ancestor(_mergeEventObjectIndex, projectile);
					_mergeEventObjectIndex = object_get_parent(_mergeEventObjectIndex)
				){
					var _mergeEventScriptIndex = script_get_index(`${object_get_name(_mergeEventObjectIndex)}_temerge_${_mergeEventName}`);
					if(_mergeEventScriptIndex >= 0){
						lq_set(_mergeEventMap, _mergeEventName, script_ref_create(_mergeEventScriptIndex));
						_objectHasMergeEvent = true;
						break;
					}
				}
			}
			
			if(_objectHasMergeEvent){
				global.object_temerge_event_table[? _objectIndex] = _mergeEventMap;
			}
		}
	}
	
	 // Hyper Slash Trail Sprites:
	global.hyper_slash_trail_sprite_map = ds_map_create();
	global.hyper_slash_trail_mask_map   = ds_map_create();
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
	 // Unmuffle Sounds:
	with(ds_map_keys(global.sound_muffle_map)){
		audio_sound_gain(self, global.sound_muffle_map[? self].sound_gain, 0);
	}
	ds_map_destroy(global.sound_muffle_map);
	
#macro _wepXhas_merge             ((is_object(_wep) && "temerge" in _wep && _wep.temerge != undefined) ? (_wepXmerge_is_active ? true : -1) : false)
#macro _wepXmerge                 _wep.temerge
#macro _wepXmerge_is_active       _wepXmerge.is_active
#macro _wepXmerge_is_part         _wepXmerge.is_part
#macro _wepXmerge_raw_wep         _wepXmerge.wep
#macro _wepXmerge_wep             _wepXmerge_raw_wep[@ 0]
#macro _wepXmerge_wep_fire_frame  _wepXmerge.wep_fire_frame
#macro _wepXmerge_wep_fire_reload _wepXmerge.wep_fire_reload
#macro _wepXmerge_fire_frame      _wepXmerge.fire_frame
#macro _wepXmerge_fire_at         _wepXmerge.fire_at_vars
#macro _wepXmerge_last_type       _wepXmerge.last_type
#macro _wepXmerge_last_cost       _wepXmerge.last_cost
#macro _wepXmerge_last_rads       _wepXmerge.last_rads
#macro _wepXmerge_last_stock_cost _wepXmerge.last_stock_cost

#define weapon_set_temerge(_wep, _mergeWep)
	/*
		Sets the given weapon's merge to one with the given weapon
		Returns the weapon, inside a lightweight object if it wasn't already
	*/
	
	if(!is_object(_wep) || "temerge" not in _wep){
		 // Wrapper Script Setup:
		with(ds_map_keys(global.weapon_event_script_map)){
			_wep = call(scr.wep_wrap, _wep, self, global.weapon_event_script_map[? self]);
		}
		
		 // LWO Setup (Just in Case):
		if(!is_object(_wep)){
			_wep = { "wep" : _wep };
		}
	}
	
	 // Variable Setup:
	_wepXmerge                 = {};
	_wepXmerge_is_active       = true;
	_wepXmerge_is_part         = true;
	_wepXmerge_raw_wep         = [wep_none];
	_wepXmerge_wep_fire_frame  = 0;
	_wepXmerge_wep_fire_reload = undefined;
	_wepXmerge_fire_frame      = 0;
	_wepXmerge_fire_at         = undefined;
	_wepXmerge_last_type       = 0;
	_wepXmerge_last_cost       = 0;
	_wepXmerge_last_rads       = 0;
	_wepXmerge_last_stock_cost = 0;
	
	 // Set Weapon:
	weapon_set_temerge_weapon(_wep, _mergeWep);
	
	return _wep;
	
#define weapon_add_temerge(_wep, _mergeWep)
	/*
		Sets the given weapon's merge to one with the given weapon, or adds it to the front of the given weapon's active merge if it has one
		Returns the weapon, inside a lightweight object if it wasn't already
	*/
	
	if(_wepXhas_merge){
		weapon_add_temerge_weapon(_wep, _mergeWep);
	}
	else{
		_wep = weapon_set_temerge(_wep, _mergeWep);
	}
	
	return _wep;
	
#define weapon_has_temerge(_wep)
	/*
		Returns whether the given weapon has an active merge, or -1 if it has an inactive merge
	*/
	
	return _wepXhas_merge;
	
#define weapon_has_temerge_weapon(_wep, _mergeWep)
	/*
		Returns whether the given weapon has an active merge, or -1 if it has an inactive merge, that contains the given weapon
	*/
	
	var _mergeWepIsLWO = is_object(_mergeWep);
	
	while(_wepXhas_merge != false){
		var _wepMergeWep = _wepXmerge_wep;
		if(_mergeWep == (_mergeWepIsLWO ? _wepMergeWep : call(scr.wep_raw, _wepMergeWep))){
			return (_wepXmerge_is_active ? true : -1);
		}
		_wep = _wepMergeWep;
	}
	
	return false;
	
#define weapon_delete_temerge(_wep)
	/*
		Deletes the given weapon's merge
	*/
	
	_wepXmerge = undefined;
	
#define weapon_activate_temerge(_wep)
	/*
		Activates the given weapon's merge
	*/
	
	_wepXmerge_is_active = true;
	
#define weapon_deactivate_temerge(_wep)
	/*
		Deactivates the given weapon's merge
	*/
	
	_wepXmerge_is_active = false;
	
#define weapon_get_temerge_weapon(_wep)
	/*
		Returns the given weapon's merge weapon
	*/
	
	return _wepXmerge_wep;
	
#define weapon_set_temerge_weapon(_wep, _mergeWep)
	/*
		Sets the given weapon's merge weapon with the given weapon
	*/
	
	_wepXmerge_wep     = _mergeWep;
	_wepXmerge_is_part = (call(scr.wep_raw, _wep) == wep_none || weapon_has_temerge_weapon(_wep, wep_none));
	
#define weapon_add_temerge_weapon(_wep, _mergeWep)
	/*
		Adds to the front of given weapon's active merge with the given weapon
	*/
	
	var _wepMergeWep = _wepXmerge_wep;
	
	if(weapon_has_temerge(_wepMergeWep)){
		weapon_add_temerge_weapon(_wepMergeWep, _mergeWep);
		_wepXmerge_is_part = (call(scr.wep_raw, _wep) == wep_none || weapon_has_temerge_weapon(_wep, wep_none));
	}
	else{
		weapon_set_temerge_weapon(_wep, weapon_set_temerge(_wepMergeWep, _mergeWep));
	}
	
#define weapon_is_temerge_part(_wep)
	/*
		Returns whether the given weapon is an empty slot or if its merge has an empty slot (wep_none)
	*/
	
	return _wepXmerge_is_part;
	
#define temerge_decide_weapon // minArea=0, maxArea=GameCont.hard, isGold=false, avoidedWepList=[]
	/*
		Sets the given weapon's merge to one with a randomly decided weapon, or adds it to the front of the given weapon's merge if it has one
		Returns the weapon, inside a lightweight object if it wasn't already
		
		Args:
			minArea/maxArea - The weapon spawn difficulty range, defaults to 0 and GameCont.hard
			isGold          - Is only able to decide from golden weapons? Defaults to false
			                  Use -1 to completely exclude golden weapons
			avoidedWepList  - Optional, an array of weapons to exclude
			
		Ex:
			temerge_decide_weapon()
			temerge_decide_weapon(0, GameCont.hard + 1)
			temerge_decide_weapon(3, GameCont.hard, false, [wep, bwep])
	*/
	
	var	_minArea        = ((argument_count > 0) ? argument[0] : 0),
		_maxArea        = ((argument_count > 1) ? argument[1] : GameCont.hard),
		_isGold         = ((argument_count > 2) ? argument[2] : false),
		_avoidedWepList = ((argument_count > 3) ? argument[3] : []),
		_decidedWep     = call(scr.weapon_decide, _minArea, _maxArea, _isGold, _avoidedWepList);
		
	return weapon_add_temerge(
		_decidedWep,
		call(scr.weapon_decide,
			_minArea,
			_maxArea,
			_isGold,
			call(scr.array_combine, _avoidedWepList, [_decidedWep])
		)
	);
	
#define temerge_weapon_event_set_script(_eventName, _scriptRef)
	/*
		Sets the given merged weapon event to the given script reference
	*/
	
	global.weapon_event_script_map[? ((_eventName == "weapon_step") ? "step" : _eventName)] = _scriptRef;
	
#define temerge_weapon_name(_wep, _stockName)
	/*
		Merged weapons insert their front weapon's name before the last word(s) of their stock weapon's name
		Words in the stock weapon's name are grouped with words in the front weapon's name for less repetition
		Redundant name suffixes are removed or replaced, like "GUN", "PISTOL", and "LAUNCHER"
		Weapon parts are suffixed with "STOCK" or "FRONT" depending on their type
	*/
	
	var _mergeCanGenerateNameByNonSync = true;
	
	 // HUD Optimization:
	if(
		instance_is(self, Player)
		&& (instance_is(other, TopCont) || instance_is(other, UberCont))
		&& (wep == _wep || bwep == _wep)
	){	
		var	_x = view_xview_nonsync + 24 + (44 * (wep != _wep)),
			_y = view_yview_nonsync + 16;
			
		 // Co-op Offset:
		for(var _playerIndex = 0, _playerCount = 0; _playerIndex < maxp; _playerIndex++){
			if(player_is_active(_playerIndex) && ++_playerCount > 1){
				_x -= 19;
				switch(call(scr.player_get_hud_index, index)){
					case 1 : _x += 227;            break;
					case 2 :            _y += 193; break;
					case 3 : _x += 227; _y += 193; break;
				}
				break;
			}
		}
		
		 // Check if Hovering:
		_mergeCanGenerateNameByNonSync = (
			   mouse_y_nonsync <= _y + 13
			&& mouse_x_nonsync <= _x + 31 + (44 * (wep == _wep && bwep == _wep))
			&& mouse_y_nonsync >= _y
			&& mouse_x_nonsync >= _x
		//	&& call(scr.player_get_show_hud_local_nonsync, index)
		);
	}
	
	 // Generate Merged Name:
	if(_mergeCanGenerateNameByNonSync && _wepXhas_merge){
		var _frontName = weapon_get_name(_wepXmerge_wep);
		if(_stockName != "" || _frontName != ""){
			var	_stockNameWordList     = [],
				_stockNameWordTextList = [],
				_frontNameWordList     = [],
				_frontNameWordTextList = [],
				_mergeNameWordList     = ((_frontName == "") ? _stockNameWordList     : _frontNameWordList),
				_mergeNameWordTextList = ((_frontName == "") ? _stockNameWordTextList : _frontNameWordTextList);
				
			 // Deconstruct Names Into Words:
			with([
				[_stockName, _stockNameWordList, _stockNameWordTextList],
				[_frontName, _frontNameWordList, _frontNameWordTextList]
			]){
				var _name = self[0];
				if(_name != ""){
					var	_nameWordList          = self[1],
						_nameWordTextList      = self[2],
						_nameTextColor         = c_white,
						_nameTextShake         = 0,
						_nameTagSplitNameIndex = 0;
						
					array_push(_nameWordList, {
						"space" : " ",
						"color" : _nameTextColor,
						"shake" : _nameTextShake,
						"text"  : ""
					});
					
					with(call(scr.string_split_nt, _name)){
						var	_tagString = self[0],
							_lineList  = string_split(self[1], "#"),
							_lineCount = array_length(_lineList);
							
						 // Parse Tag:
						if(_nameTagSplitNameIndex++ > 0){
							if(ds_map_exists(global.nt_tag_color_map, _tagString)){
								_nameTextColor = global.nt_tag_color_map[? _tagString];
							}
							else if(_tagString == "q" || _tagString == "Q"){
								_nameTextShake++;
							}
							else{
								var _tagExtStringStartPos = string_pos("(", _tagString);
								
								 // Custom Colors:
								if(_tagExtStringStartPos > 0 && string_split(string_delete(_tagString, 1, _tagExtStringStartPos), ":")[0] == "color"){
									_tagExtStringStartPos += 7;
									_nameTextColor = real(string_copy(_tagString, _tagExtStringStartPos, string_pos(")", _tagString) - _tagExtStringStartPos));
								}
								
								 // Insert Non-Style Tags Back Into Words:
								else{
									_nameWordList[array_length(_nameWordList) - 1].text += "@" + _tagString;
									_tagString = "";
								}
							}
						}
						
						 // Parse Lines:
						for(var _lineIndex = 0; _lineIndex < _lineCount; _lineIndex++){
							var	_lineWordList  = string_split(_lineList[_lineIndex], " "),
								_lineWordCount = array_length(_lineWordList);
								
							 // Continue Last Word:
							if(_lineIndex == 0){
								var	_lineFirstWord = _lineWordList[0],
									_nameLastWord  = _nameWordList[array_length(_nameWordList) - 1];
									
								 // Update Style for Empty Words:
								if(_nameLastWord.text == ""){
									_nameLastWord.color = _nameTextColor;
									_nameLastWord.shake = _nameTextShake;
								}
								
								 // Active Words:
								else if(_lineFirstWord != ""){
									 // Store Latest Style:
									_nameLastWord.final_color = _nameTextColor;
									_nameLastWord.final_shake = _nameTextShake;
									
									 // Insert Raw Tags:
									if(_tagString != ""){
										_nameLastWord.text += "@" + _tagString;
									}
								}
								
								 // Add Text:
								_nameLastWord.text += _lineFirstWord;
							}
							
							 // Add New Words:
							for(var _lineWordIndex = ((_lineIndex == 0) ? 1 : 0); _lineWordIndex < _lineWordCount; _lineWordIndex++){
								array_push(_nameWordList, {
									"space" : ((_lineWordIndex > 0) ? " " : "#"),
									"color" : _nameTextColor,
									"shake" : _nameTextShake,
									"text"  : _lineWordList[_lineWordIndex]
								});
							}
						}
					}
					
					 // Compile Text Comparison List:
					with(_nameWordList){
						var	_text       = text,
							_textLength = string_length(_text);
							
						while(string_char_at(_text, _textLength) == "!"){
							_textLength--;
						}
						
						array_push(_nameWordTextList, string_upper(string_copy(_text, 1, _textLength)));
					}
				}
			}
			
			 // Combine Names (SUPER PLASMA CANNON + AUTO SHOTGUN = SUPER PLASMA AUTO SHOTGUN CANNON):
			if(_frontName != "" && _stockName != ""){
				var	_stockNamePrefixCount    = array_length(_stockNameWordList) - 1,
					_stockNamePrefixList     = array_slice(_stockNameWordList,     0, _stockNamePrefixCount),
					_stockNamePrefixTextList = array_slice(_stockNameWordTextList, 0, _stockNamePrefixCount),
					_stockNameSuffix         = _stockNameWordList[_stockNamePrefixCount],
					_stockNameSuffixText     = _stockNameWordTextList[_stockNamePrefixCount];
					
				 // Group Prefixes (*PLASMA* CANNON RIFLE > PLASMA PLASMA CANNON RIFLE):
				for(var _stockNamePrefixIndex = _stockNamePrefixCount - 1; _stockNamePrefixIndex >= 0; _stockNamePrefixIndex--){
					var _mergeNameWordIndex = array_find_index(_mergeNameWordTextList, _stockNamePrefixTextList[_stockNamePrefixIndex]);
					if(_mergeNameWordIndex >= 0){
						if(_mergeNameWordList[_mergeNameWordIndex].text != "GOLDEN"){
							temerge_weapon_name_word_add_style(_mergeNameWordList[_mergeNameWordIndex], _stockNamePrefixList[_stockNamePrefixIndex]);
						}
						_stockNamePrefixList     = call(scr.array_delete, _stockNamePrefixList,     _stockNamePrefixIndex);
						_stockNamePrefixTextList = call(scr.array_delete, _stockNamePrefixTextList, _stockNamePrefixIndex);
						_stockNamePrefixCount--;
					}
				}
				
				 // Prepend Prefixes:
				if(_stockNamePrefixCount > 0){
					_mergeNameWordList     = call(scr.array_combine, _stockNamePrefixList,     _mergeNameWordList);
					_mergeNameWordTextList = call(scr.array_combine, _stockNamePrefixTextList, _mergeNameWordTextList);
				}
				
				 // Remove Redundant Suffixes:
				switch(_stockNameSuffixText){
					
					case "GUN":
					case "PISTOL":
					case "LAUNCHER":
					case "REVOLVER":
					case "BLASTER":
					
						 // SMART MACHINEGUN > SMART MACHINEGUN GUN:
						if(array_length(_stockNamePrefixList)){
							_stockNameSuffixText = "";
						}
						
						break;
						
					case "RIFLE":
					
						 // ASSAULT SHOTGUN > ASSAULT SHOTGUN RIFLE:
						if(array_find_index(_mergeNameWordTextList, "ASSAULT") >= 0){
							_stockNameSuffixText = "";
						}
						
						break;
						
					case "CANNON":
					
						 // FLAK MACHINEGUN > FLAK MACHINEGUN CANNON
						if(array_find_index(_mergeNameWordTextList, "FLAK") >= 0){
							_stockNameSuffixText = "";
						}
						
						break;
						
				}
				
				 // Append / Replace Suffix:
				if(_stockNameSuffixText != ""){
					var	_mergeNameSuffixIndex = array_length(_mergeNameWordTextList) - 1,
						_mergeNameSuffixText  = _mergeNameWordTextList[_mergeNameSuffixIndex];
						
					if(array_find_index(["STOCK", "FRONT", "PARTS"], _mergeNameSuffixText) >= 0){
						_mergeNameSuffixText = _mergeNameWordTextList[--_mergeNameSuffixIndex];
					}
					
					switch(_mergeNameSuffixText){
						
						case "GUN":
						case "PISTOL":
						case "LAUNCHER":
						
							 // Replace Redundant Suffixes (PLASMA DISC RIFLE > PLASMA DISC GUN RIFLE):
							_mergeNameWordList[_mergeNameSuffixIndex]     = _stockNameSuffix;
							_mergeNameWordTextList[_mergeNameSuffixIndex] = _stockNameSuffixText;
							
							break;
							
						default:
						
							 // Group Suffixes (HEAVY *MACHINEGUN* > HEAVY MACHINEGUN MACHINEGUN):
							var _mergeNameWordIndex = array_find_last_index(_mergeNameWordTextList, _stockNameSuffixText);
							if(_mergeNameWordIndex >= 0){
								temerge_weapon_name_word_add_style(_mergeNameWordList[_mergeNameWordIndex], _stockNameSuffix);
							}
							
							 // Append Suffix:
							else{
								_mergeNameSuffixIndex++;
								array_insert(_mergeNameWordList,     _mergeNameSuffixIndex, _stockNameSuffix);
								array_insert(_mergeNameWordTextList, _mergeNameSuffixIndex, _stockNameSuffixText);
							}
							
					}
				}
			}
			
			 // Append Part Type:
			if(_wepXmerge_is_part){
				var	_stockIsEmpty = (call(scr.wep_raw, _wep)           == wep_none),
					_frontIsEmpty = (call(scr.wep_raw, _wepXmerge_wep) == wep_none);
					
				if(_stockIsEmpty ^^ _frontIsEmpty){
					var	_mergeNameSuffixIndex = array_length(_mergeNameWordTextList) - 1,
						_mergeNameSuffixText  = _mergeNameWordTextList[_mergeNameSuffixIndex];
						
					if(_mergeNameSuffixText != "PARTS"){
						var _mergeNamePartWord = {
							"space" : " ",
							"color" : c_white,
							"shake" : 0,
							"text"  : ""
						};
						if(_mergeNameSuffixText == (_stockIsEmpty ? "STOCK" : "FRONT")){
							_mergeNamePartWord.text = "PARTS";
						}
						else{
							_mergeNameSuffixIndex++;
							_mergeNamePartWord.text = (_stockIsEmpty ? "FRONT" : "STOCK");
						}
						_mergeNameWordList[_mergeNameSuffixIndex]     = _mergeNamePartWord;
						_mergeNameWordTextList[_mergeNameSuffixIndex] = _mergeNamePartWord.text;
					}
				}
			}
			
			 // Reconstruct Name:
			var	_mergeName              = "",
				_mergeNameLastWordColor = c_white,
				_mergeNameLastWordShake = 0;
				
			_mergeNameWordList[0].space = "";
			
			with(_mergeNameWordList){
				 // Leading Spacer:
				_mergeName += space;
				
				 // Color:
				if(color != _mergeNameLastWordColor){
					var	_tagColorList  = ds_map_values(global.nt_tag_color_map),
						_tagColorIndex = array_find_index(_tagColorList, color);
						
					if(_tagColorIndex >= 0){
						_mergeName += `@${ds_map_keys(global.nt_tag_color_map)[_tagColorIndex]}`;
					}
					else{
						_mergeName += `@(color:${color})`;
					}
				}
				_mergeNameLastWordColor = (("final_color" in self) ? final_color : color);
				
				 // Shake:
				if(shake != _mergeNameLastWordShake){
					_mergeName += string_repeat("@q", shake - _mergeNameLastWordShake);
				}
				_mergeNameLastWordShake = (("final_shake" in self) ? final_shake : shake);
				
				 // Add Text:
				_mergeName += text;
			}
			
			return _mergeName;
		}
	}
	
	return _stockName;
	
#define temerge_weapon_name_word_add_style(_word, _withWord)
	/*
		Adds to the given merged weapon name word's style with the given merged weapon name word
	*/
	
	var	_wordColor      = _word.color,
		_wordColorList  = [global.nt_tag_color_map[? "r"], global.nt_tag_color_map[? "y"], global.nt_tag_color_map[? "g"], global.nt_tag_color_map[? "b"]],
		_wordColorIndex = array_find_index(_wordColorList, _wordColor);
		
	 // Shift Color Hue:
	if(
		(
			_wordColorIndex >= 0
			|| color_get_saturation(_wordColor) < 255
			|| color_get_value(_wordColor) < 242
		)
		&& _wordColorIndex + 1 < array_length(_wordColorList)
	){
		_word.color = _wordColorList[_wordColorIndex + 1];
		
		 // !!!:
		if(_wordColorIndex >= 0){
			_word.text += "!";
		}
	}
	else{
		var _hue = color_get_hue(_wordColor) + 39;
		if(_hue >= 255){
			_hue %= 255;
			_word.shake++;
		}
		_word.color = make_color_hsv(_hue, 255, 242);
	}
	
	 // Combine Shake:
	_word.shake += _withWord.shake;
	
#define temerge_weapon_text(_wep, _stockText)
	/*
		Merged weapons combine the first half of their front weapon's loading tip with the second half of their stock weapon's loading tip
		Weapon names and certain projectile names are swapped with more fitting references
	*/
	
	if(_wepXhas_merge){
		var _frontText = weapon_get_text(_wepXmerge_wep);
		
		if(
			(is_string(_stockText) && _stockText != "") &&
			(is_string(_frontText) && _frontText != "")
		){
			var _mergeText = string_lower(_stockText);
			_frontText = string_lower(_frontText);
			
			 // Fetch Stock Weapon Values:
			_wepXmerge_is_active = false;
			
			var	_stockName = weapon_get_name(_wep),
				_stockType = weapon_get_type(_wep);
				
			_wepXmerge_is_active = true;
			
			 // Swap Weapon Names:
			var _mergeName = string_lower(weapon_get_name(_wep));
			_frontText = string_replace(_frontText, string_lower(weapon_get_name(_wepXmerge_wep)), _mergeName);
			_mergeText = string_replace(_mergeText, string_lower(_stockName),                      _mergeName);
			
			 // Swap Projectile Names:
			if(_stockType >= 0 && _stockType < 6){
				var _frontType = weapon_get_type(_wepXmerge_wep);
				if(_stockType != _frontType && _frontType >= 0 && _frontType < 6){
					var	_typeTextLists = [
							["swing"],
							["bullet"],
							["shell"],
							["bolt"],
							["explosive", "grenade", "nade"],
							["plasma"]
						],
						_frontTypeText = _typeTextLists[_frontType][0];
						
					with(_typeTextLists[_stockType]){
						_mergeText = string_replace_all(_mergeText, self, _frontTypeText);
					}
				}
			}
			
			 // Combine Loading Tips:
			var	_frontTextWordList  = string_split(_frontText, " "),
				_mergeTextWordList  = string_split(_mergeText,      " "),
				_mergeTextWordCount = array_length(_mergeTextWordList);
				
			_mergeText  = array_join(array_slice(_frontTextWordList, 0, max(1, floor(array_length(_frontTextWordList) / 2))), " ") + " ";
			_mergeText += array_join(array_slice(_mergeTextWordList, floor(_mergeTextWordCount / 2), ceil(_mergeTextWordCount / 2)), " ");
			
			return _mergeText;
		}
		
		return _frontText;
	}
	
	return _stockText;
	
#define temerge_weapon_sprt(_wep, _stockSprite)
	/*
		Merged weapons combine vertical slices from the sprites of their weapon parts
	*/
	
	if(_wepXhas_merge){
		if(sprite_get_name(_stockSprite) == "sprMerge" && _stockSprite == weapon_get_sprt_hud(_wep)){
			_wepXmerge_is_active = false;
			_stockSprite = weapon_get_sprt_hud(_wep);
			_wepXmerge_is_active = true;
		}
		return call(scr.weapon_sprite_list_merge, [_stockSprite, weapon_get_sprt(_wepXmerge_wep)]);
	}
	
	return _stockSprite;
	
#define temerge_weapon_sprt_hud(_wep, _stockHUDSprite)
	/*
		Merged weapons combine vertical slices from the HUD sprites of their weapon parts
	*/
	
	if(_wepXhas_merge){
		if(sprite_get_name(_stockHUDSprite) == "sprMerge" && _stockHUDSprite == weapon_get_sprt(_wep)){
			_wepXmerge_is_active = false;
			_stockHUDSprite = weapon_get_sprt(_wep);
			_wepXmerge_is_active = true;
		}
		return call(scr.weapon_sprite_list_merge, [_stockHUDSprite, weapon_get_sprt_hud(_wepXmerge_wep)]);
	}
	
	return _stockHUDSprite;
	
#define temerge_weapon_loadout(_wep, _stockLoadoutSprite)
	/*
		Merged weapons combine curved slices from the loadout sprites of their weapon parts
	*/
	
	if(_stockLoadoutSprite != 0 && _wepXhas_merge){
		var _frontLoadoutSprite = call(scr.weapon_get, "loadout", _wepXmerge_wep);
		return (
			(_frontLoadoutSprite == 0)
			? 0
			: call(scr.weapon_loadout_sprite_list_merge, [_stockLoadoutSprite, _frontLoadoutSprite])
		);
	}
	
	return _stockLoadoutSprite;
	
#define temerge_weapon_swap(_wep, _stockSwapSound)
	/*
		Merged weapons use their front weapon's swap sound and play the swap sounds of their stock weapon(s) manually
	*/
	
	if(_wepXhas_merge){
		sound_play_pitchvol(_stockSwapSound, 1, 0.5);
		return weapon_get_swap(_wepXmerge_wep);
	}
	
	return _stockSwapSound;
	
#define temerge_weapon_area(_wep, _stockArea)
	/*
		Merged weapons use the highest spawn difficulty of their weapon parts
	*/
	
	if(_wepXhas_merge){
		var _frontArea = weapon_get_area(_wepXmerge_wep);
		if(_frontArea > _stockArea){
			return _frontArea;
		}
	}
	
	return _stockArea;
	
#define temerge_weapon_gold(_wep, _stockGold)
	/*
		Merged weapons are gold if all of their weapon parts are gold
	*/
	
	if(_stockGold != 0 && _wepXhas_merge){
		var _frontGold = weapon_get_gold(_wepXmerge_wep);
		if(_frontGold == 0 || _frontGold < _stockGold){
			return _frontGold;
		}
	}
	
	return _stockGold;
	
#define temerge_weapon_type(_wep, _stockType)
	/*
		Merged weapons use their front weapon's ammo type
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return type_melee;
		}
		
		var _mergeType = weapon_get_type(_wepXmerge_wep);
		
		_wepXmerge_last_type = _mergeType;
		
		return _mergeType;
	}
	
	return _stockType;
	
#macro temerge_weapon_cost_scale_factor
	/*
		How much the cost of a merged weapon exponentially scales between shots
	*/
	
	0.795
	
#define temerge_weapon_cost(_wep, _stockCost)
	/*
		Merged weapons use their front weapon's ammo cost:
		1. Multiplied by the reduced ammo cost of their stock weapon(s)
		2. Clamped at max capacity for fun (Back Muscle)
	*/
	
	if(_wepXhas_merge){
		_wepXmerge_last_stock_cost = _stockCost;
		
		if(_wepXmerge_is_part){
			return 0;
		}
		
		var	_frontCost = weapon_get_cost(_wepXmerge_wep),
			_mergeCost = _frontCost;
			
		if(_stockCost != 0 && _frontCost != 0){
			 // Integrate Stock Ammo Cost:
			_mergeCost += round(_mergeCost * (power(abs(_stockCost), temerge_weapon_cost_scale_factor) - 1));
			
			 // Clamp at Max Ammo:
			if(_mergeCost > 99){
				switch(weapon_get_type(_wep)){
					case type_bullet:
						if(
							_mergeCost > 555
							&& _stockCost <= 555
							&& _frontCost <= 555
						){
							_mergeCost = 555;
						}
						break;
						
					default:
						if(
							_stockCost <= 99 &&
							_frontCost <= 99
						){
							_mergeCost = 99;
						}
				}
			}
		}
		
		_wepXmerge_last_cost = _mergeCost;
		
		return _mergeCost;
	}
	
	return _stockCost;
	
#define temerge_weapon_rads(_wep, _stockRads)
	/*
		Merged weapons use their front weapon's rad cost:
		1. Multiplied by the reduced ammo cost of their stock weapon(s)
		2. Added to half of the rad cost of their stock weapon(s) multiplied by how much ammo their front weapon(s) cost
		3. Clamped at max capacity for fun (Meltdown)
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return 0;
		}
		
		var	_frontRads = weapon_get_rads(_wepXmerge_wep),
			_mergeRads = _frontRads;
			
		if(_stockRads != 0 || _frontRads != 0){
			 // Integrate Stock Ammo Cost:
			if(_mergeRads != 0){
				_wepXmerge_is_active = false;
				
				var _stockCost = abs(weapon_get_cost(_wep));
				if(_stockCost != 0 && _stockCost != 1){
					_mergeRads += round(_mergeRads * (power(_stockCost, temerge_weapon_cost_scale_factor) - 1));
				}
				
				_wepXmerge_is_active = true;
			}
			
			 // Integrate Stock Rad Cost:
			if(_stockRads != 0){
				var	_addRads   = _stockRads / 2,
					_frontCost = weapon_get_cost(_wepXmerge_wep),
					_frontType = weapon_get_type(_wepXmerge_wep);
					
				if(_frontCost != 0){
					_addRads *= abs(_frontCost);
				}
				
				_wepXmerge_is_active = false;
				
				var _stockType = weapon_get_type(_wep);
				if(_stockType != _frontType){
					if(_stockType == type_bullet){
						_addRads *= 3;
					}
					else if(_frontType == type_bullet){
						_addRads /= 3;
					}
				}
				
				_wepXmerge_is_active = true;
				
				_mergeRads += round(_addRads);
			}
			
			 // Clamp at Max Rads:
			if(
				_mergeRads > 1200
				&& _stockRads <= 1200
				&& _frontRads <= 1200
			){
				_mergeRads = 1200;
			}
		}
		
		_wepXmerge_last_rads = _mergeRads;
		
		return _mergeRads;
	}
	
	return _stockRads;
	
#define temerge_weapon_load(_wep, _stockLoad)
	/*
		Merged weapons use their front weapon's reload:
		1. (If they aren't melee, or if their front weapon is melee) Multiplied by a reduced factor of the reload of their stock weapon(s)
		2. (If they cost no ammo) Increased by any surplus (>1) ammo cost from their stock weapon(s)
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return 1;
		}
		
		var	_frontLoad = weapon_get_load(_wepXmerge_wep),
			_mergeLoad = _frontLoad * lerp(1, _stockLoad / 8, 0.8);
			
		 // Less Reload Increase:
		if(_mergeLoad > _frontLoad && (!weapon_is_melee(_wep) || weapon_is_melee(_wepXmerge_wep))){
			_mergeLoad = lerp(_mergeLoad, _frontLoad, 2/3);
		}
		
		 // Integrate Stock Ammo Cost (Ammoless Weapons):
		if(weapon_get_cost(_wep) == 0){
			_wepXmerge_is_active = false;
			_mergeLoad += 2 * max(0, abs(weapon_get_cost(_wep)) - 1);
			_wepXmerge_is_active = true;
		}
		
		return _mergeLoad;
	}
	
	return _stockLoad;
	
#define temerge_weapon_auto(_wep, _stockIsAuto)
	/*
		Merged weapons are automatic if their stock weapon is automatic,
		or if they reload quickly and their front weapon is automatic
	*/
	
	if(_stockIsAuto >= 0 && _wepXhas_merge){
		if(_wepXmerge_is_part){
			return -1;
		}
		
		var _frontIsAuto = weapon_get_auto(_wepXmerge_wep);
		
		if(
			_frontIsAuto
			? (((_wepXmerge_wep_fire_reload == undefined) ? weapon_get_load(_wep) : _wepXmerge_wep_fire_reload) <= 8)
			: (_frontIsAuto < 0)
		){
			return _frontIsAuto;
		}
	}
	
	return _stockIsAuto;
	
#define temerge_weapon_melee(_wep, _stockIsMelee)
	/*
		Merged weapons are melee if any of their weapon parts are melee
	*/
	
	if(!_stockIsMelee && _wepXhas_merge){
		return weapon_is_melee(_wepXmerge_wep);
	}
	
	return _stockIsMelee;
	
#define temerge_weapon_laser_sight(_wep, _stockLaserSight)
	/*
		Merged weapons use the laser sight of their stock weapon(s) (the first one that has a laser sight)
	*/
	
	if(_wepXhas_merge){
		if(_wepXmerge_is_part){
			return false;
		}
		
		if(_stockLaserSight == 0){
			_wep = _wepXmerge_wep;
			if(_wepXhas_merge){
				return weapon_get_laser_sight(_wep);
			}
		}
	}
	
	return _stockLaserSight;
	
#define temerge_weapon_red(_wep, _stockRed)
	/*
		Merged weapons alternate between using the red ammo costs of their front, first red-using, and latest-fired weapon parts
	*/
	
	if(
		_wepXhas_merge
		&& (
			(current_frame > _wepXmerge_fire_frame)
			? (((current_frame - _wepXmerge_fire_frame) % 60) < 30 && !_wepXmerge_is_part)
			: (_wepXmerge_wep_fire_frame >= _wepXmerge_fire_frame)
		)
	){
		return call(scr.weapon_get, "red", _wepXmerge_wep);
	}
	
	return _stockRed;
	
#define temerge_weapon_reloaded(_isPrimary)
	/*
		Merged weapons call all of their weapon part's reloaded events
	*/
	
	var _wep = (_isPrimary ? wep : bwep);
	
	if(_wepXhas_merge && !_wepXmerge_is_part && _wepXmerge_wep_fire_frame >= _wepXmerge_fire_frame){
		var	_mergeWep     = _wepXmerge_wep,
			_mergeBaseWep = _mergeWep;
			
		 // Find Base Front Weapon:
		while(is_object(_mergeBaseWep) && "wep" in _mergeBaseWep){
			_mergeBaseWep = _mergeBaseWep.wep;
		}
		
		 // Call Front Weapon's Reloaded Event:
		if(is_string(_mergeBaseWep) && mod_script_exists("weapon", _mergeBaseWep, "weapon_reloaded")){
			temerge_weapon_wrap_event(_wep, self, script_ref_create_ext("weapon", _mergeBaseWep, "weapon_reloaded", _isPrimary), true, "", undefined);
		}
		else{
			if(_isPrimary){
				wep = _mergeWep;
				
				call(scr.player_weapon_reloaded, _isPrimary);
				
				if(wep != _mergeWep){
					_wepXmerge_wep = wep;
				}
				wep = _wep;
			}
			else{
				bwep = _mergeWep;
				
				call(scr.player_weapon_reloaded, _isPrimary);
				
				if(bwep != _mergeWep){
					_wepXmerge_wep = bwep;
				}
				bwep = _wep;
			}
		}
	}
	
#define temerge_weapon_step(_isPrimary)
	/*
		Merged weapons call all of their weapon part's step events
	*/
	
	var _wep = (_isPrimary ? wep : bwep);
	
	if(_wepXhas_merge){
		if(!_wepXmerge_is_part){
			var	_mergeWep     = _wepXmerge_wep,
				_mergeBaseWep = _mergeWep;
				
			 // Find Base Front Weapon:
			while(is_object(_mergeBaseWep) && "wep" in _mergeBaseWep){
				_mergeBaseWep = _mergeBaseWep.wep;
			}
			
			 // Call Front Weapon's Step Event:
			if(is_string(_mergeBaseWep) && mod_script_exists("weapon", _mergeBaseWep, "step")){
				temerge_weapon_wrap_event(_wep, self, script_ref_create_ext("weapon", _mergeBaseWep, "step", _isPrimary), true, "", undefined);
			}
			else{
				if(_isPrimary){
					wep = _mergeWep;
					
					call(scr.player_weapon_step, _isPrimary);
					
					if(wep != _mergeWep){
						_wepXmerge_wep = wep;
					}
					wep = _wep;
				}
				else{
					bwep = _mergeWep;
					
					call(scr.player_weapon_step, _isPrimary);
					
					if(bwep != _mergeWep){
						_wepXmerge_wep = bwep;
					}
					bwep = _wep;
				}
			}
		}
		
		 // Update Part State:
		if(frame_active(30) && _wepXhas_merge){
			if(_wepXmerge_is_part){
				if(call(scr.wep_raw, _wep) != wep_none && !weapon_has_temerge_weapon(_wep, wep_none)){
					do{
						_wepXmerge_is_part = false;
						_wep = _wepXmerge_wep;
					}
					until(!_wepXhas_merge);
				}
			}
			else if(call(scr.wep_raw, _wepXmerge_wep) == wep_none || (weapon_has_temerge(_wepXmerge_wep) && weapon_is_temerge_part(_wepXmerge_wep))){
				_wepXmerge_is_part = true;
			}
		}
	}
	
#define temerge_weapon_wrap_event(_wep, _creator, _scriptCallRef, _canWrapEvents, _wrapEventVarName, _wrapEventRef)
	/*
		Used to override a Player instance's weapons during the events of custom instances created during certain weapon events
	*/
	
	 // Just in Case:
	if(!argument_count) exit;
	
	 // Set Event Reference:
	if(_wrapEventVarName in self){
		variable_instance_set(self, _wrapEventVarName, _scriptCallRef);
	}
	
	 // Set Weapon, Call Script, & Capture Instances:
	if(instance_exists(_creator) && _wepXhas_merge){
		var	_minInstanceID  = (_canWrapEvents ? instance_max : undefined),
			_mergeWep       = _wepXmerge_wep,
			_creatorHasWep  = (_creator.wep  == _wep),
			_creatorHasBWep = (_creator.bwep == _wep);
			
		 // Set Player Weapon:
		if(_creatorHasWep ) _creator.wep  = _mergeWep;
		if(_creatorHasBWep) _creator.bwep = _mergeWep;
		
		 // Call Script Reference:
		if(fork()){
			script_ref_call(_scriptCallRef);
			exit;
		}
		
		 // Revert Player Weapon:
		if(instance_exists(_creator)){
			if(_creatorHasBWep){ if(_creator.bwep != _mergeWep){ _wepXmerge_wep = _creator.bwep; } _creator.bwep = _wep; }
			if(_creatorHasWep ){ if(_creator.wep  != _mergeWep){ _wepXmerge_wep = _creator.wep;  } _creator.wep  = _wep; }
		}
		
		 // Wrap Events of New Instances:
		if(_canWrapEvents){
			for(var _instanceID = instance_max - 1; _instanceID >= _minInstanceID; _instanceID--){
				if("object_index" in _instanceID){
					var _instObject = _instanceID.object_index;
					if(ds_map_exists(global.object_event_index_list_map, _instObject)){
						with(global.object_event_index_list_map[? _instObject]){
							var	_eventVarName = global.event_varname_list[self],
								_instEventRef = variable_instance_get(_instanceID, _eventVarName);
								
							if(array_length(_instEventRef) >= 3){
								var _instEventWrapRef = script_ref_create(
									temerge_weapon_wrap_event,
									_wep,
									_creator,
									_instEventRef,
									(instance_is(_instObject, CustomObject) || instance_is(_instObject, CustomScript)), // Causes slight inconsistencies, but significantly reduces lag
									_eventVarName
								);
								array_push(_instEventWrapRef, _instEventWrapRef);
								variable_instance_set(_instanceID, _eventVarName, _instEventWrapRef);
							}
						}
					}
				}
			}
		}
	}
	
	 // Call Script Reference:
	else if(fork()){
		script_ref_call(_scriptCallRef);
		exit;
	}
	
	 // Revert Event Reference:
	if(_wrapEventVarName in self){
		var _scriptRef = variable_instance_get(self, _wrapEventVarName);
		if(_scriptRef != _scriptCallRef){
			if(array_length(_scriptRef) >= 3){
				_wrapEventRef[@ array_find_index(_wrapEventRef, _scriptCallRef)] = _scriptRef;
			}
			else _wrapEventRef = _scriptRef;
		}
		variable_instance_set(self, _wrapEventVarName, _wrapEventRef);
	}
	
#define temerge_player_fire(_wepIsFront, _wep, _at)
	/*
		Merged weapon pre-firing event
	*/
	
	var	_wepType           = type_melee,
		_wepCost           = 0,
		_wepRads           = 0,
		_wepHasMerge       = false,
		_wepMergeStockCost = 0,
		_wepMergeFrontCost = 0;
		
	 // Front Weapon Setup:
	if(_wepIsFront){
		_wepHasMerge = true;
		
		 // Fetch Ammo & Rad Info:
		_wepType           = weapon_get_type(_wep);
		_wepCost           = weapon_get_cost(_wep);
		_wepRads           = weapon_get_rads(_wep);
		_wepMergeStockCost = _wepCost;
	}
	
	 // Stock Weapon Setup:
	else if(_wepXhas_merge){
		_wepHasMerge = true;
		
		 // Don't Fire:
		if(_wepXmerge_is_part){
			_at.wep = wep_none;
			exit;
		}
		
		 // Fetch Stored Ammo & Rad Info:
		if(infammo != 0){
			weapon_get_type(_wep);
			weapon_get_cost(_wep);
			weapon_get_rads(_wep);
		}
		_wepType           = _wepXmerge_last_type;
		_wepCost           = _wepXmerge_last_cost;
		_wepRads           = _wepXmerge_last_rads;
		_wepMergeStockCost = _wepXmerge_last_stock_cost;
		var _lastWep = _wep;
		_wep = _wepXmerge_wep;
		_wepMergeFrontCost = (_wepXhas_merge ? _wepXmerge_last_cost : weapon_get_cost(_wep));
		_wep = _lastWep;
		
		 // Store Firing Frame:
		_wepXmerge_fire_frame = current_frame;
		
		 // Apply Firing Variables:
		var _fireAt = _wepXmerge_fire_at;
		if(_fireAt != undefined){
			_at.x                  = _fireAt.x;
			_at.y                  = _fireAt.y;
			_at.position_distance  = _fireAt.position_distance;
			_at.position_direction = _fireAt.position_direction;
			_at.position_rotation  = _fireAt.position_rotation;
			_at.direction          = _fireAt.direction;
			_at.direction_rotation = _fireAt.direction_rotation;
			_at.accuracy           = _fireAt.accuracy;
			_at.wep                = _fireAt.wep;
			_at.team               = _fireAt.team;
			_at.creator            = _fireAt.creator;
		}
	}
	
	 // Store Values:
	if(_wepHasMerge){
		var	_atTeam    = ((_at.team == undefined) ? team : _at.team),
			_atCreator = _at.creator,
			_merge     = call(scr.projectile_tag_get_value, _atTeam, _atCreator, "temerge_vars");
			
		 // Setup Variable Container:
		if(_merge == undefined){
			_merge = {};
			call(scr.projectile_tag_set_value, _atTeam, _atCreator, "temerge_vars", _merge);
		}
		
		 // Store Initial Firing Values:
		var _fire = {
			"last_vars"                  : undefined,
			"main_vars"                  : undefined,
			"has_shot"                   : false,
			"shot_count"                 : 0,
			"shot_replace_count"         : 0,
			"shot_replace_min"           : max(1, _wepMergeStockCost),
			"shot_replace_base"          : power(1.5, 1 + max(0, (_wepMergeFrontCost - 1) / 9)),
			"shot_replace_cost_interval" : ((_wepMergeStockCost == 0) ? 1 : abs(_wepMergeStockCost)),
			"shot_is_delayed"            : false,
			"frame"                      : current_frame,
			"x"                          : x,
			"y"                          : y,
			"hspeed"                     : hspeed,
			"vspeed"                     : vspeed,
			"wepangle"                   : wepangle,
			"wkick"                      : wkick,
			"reload"                     : reload,
			"infammo"                    : infammo,
			"ammo"                       : (instance_is(_atCreator, Player) ? array_clone(_atCreator.ammo) : undefined),
			"ammo_type"                  : _wepType,
			"ammo_cost"                  : _wepCost,
			"rads"                       : GameCont.rad,
			"rads_cost"                  : _wepRads,
			"shake"                      : [],
			"opt_shake"                  : UberCont.opt_shake,
			"opt_freeze"                 : UberCont.opt_freeze,
			"min_instance_id"            : instance_max,
			"min_sound_id"               : sound_play_pitchvol(0, 0, 0)
		};
		sound_stop(_fire.min_sound_id);
		for(var i = 0; i < maxp; i++){
			array_push(_fire.shake, view_shake[i]);
		}
		_merge.fire_vars = _fire;
		if("last_fire_vars" in _merge){
			var	_lastFire = _merge.last_fire_vars,
				_mainFire = _lastFire.main_vars;
				
			_fire.last_vars = _lastFire;
			_fire.main_vars = _mainFire;
			
			 // Update Initial Values:
			if(_fire.frame > _mainFire.frame){
				_mainFire.frame      = _fire.frame;
				_mainFire.x          = _fire.x;
				_mainFire.y          = _fire.y;
				_mainFire.hspeed     = _fire.hspeed;
				_mainFire.vspeed     = _fire.vspeed;
				_mainFire.wepangle   = _fire.wepangle;
				_mainFire.wkick      = _fire.wkick;
				_mainFire.reload     = _fire.reload;
				_mainFire.ammo       = _fire.ammo;
				_mainFire.rads       = _fire.rads;
				_mainFire.shake      = _fire.shake;
				_mainFire.opt_shake  = _fire.opt_shake;
				_mainFire.opt_freeze = _fire.opt_freeze;
			}
			
			 // Restore Initial Values:
			else{
				x        = _mainFire.x;
				y        = _mainFire.y;
				hspeed   = _mainFire.hspeed;
				vspeed   = _mainFire.vspeed;
				wepangle = abs(wepangle) * sign(_mainFire.wepangle);
				for(var i = 0; i < maxp; i++){
					view_shake[i] = _mainFire.shake[i];
				}
			}
		}
		else{
			_fire.main_vars = _fire;
			
			 // Return Ammo Cost:
			if(infammo == 0){
				if(instance_is(self, Player)){
					ammo[_wepType] += _wepCost;
					_fire.ammo = array_clone(ammo);
				}
				GameCont.rad += _wepRads;
				_fire.rads = GameCont.rad;
			}
		}
		
		 // Temporary Weapon Kick:
		wkick = 0;
		
		 // Reduce Screen Shifting & Disable Freeze Frames:
		if(!_wepIsFront){
			UberCont.opt_shake  = 0;
			UberCont.opt_freeze = 0;
		}
	}
	
#define temerge_weapon_fire(_wepIsFront, _wep)
	/*
		Merged weapon post-firing event
	*/
	
	if(_wepIsFront || _wepXhas_merge){
		var	_team    = team,
			_creator = (("creator" in self && instance_is(self, FireCont)) ? creator : self),
			_merge   = call(scr.projectile_tag_get_value, _team, _creator, "temerge_vars");
			
		if(_merge != undefined && "fire_vars" in _merge){
			var _fire = _merge.fire_vars;
			
			 // Store Latest Asset Instances:
			_fire.max_instance_id = instance_max;
			_fire.max_sound_id    = sound_play_pitchvol(0, 0, 0);
			sound_stop(_fire.max_sound_id);
			
			 // Check if a Teamed Object Was Shot:
			if(instance_exists(projectile) && projectile.id > _fire.min_instance_id){
				_fire.has_shot = true;
			}
			else{
				var _maxInstanceID = _fire.max_instance_id;
				for(var _instanceID = _fire.min_instance_id; _instanceID < _maxInstanceID; _instanceID++){
					if("team" in _instanceID){
						_fire.has_shot        = true;
						_fire.shot_is_delayed = true;
						break;
					}
				}
			}
			
			 // Has Shot Teamed Objects:
			if(_fire.has_shot){
				if(_fire.main_vars != undefined){
					var _mainFire = _fire.main_vars;
					
					 // Only Flip Melee Angle After Gaps in Firing:
					if(sign(wepangle) != sign(_mainFire.wepangle)){
						if("wepangle_side_frame" not in _mainFire || (current_frame - _mainFire.wepangle_side_frame) > 1){
							_mainFire.wepangle_side = sign(wepangle);
						}
						_mainFire.wepangle_side_frame = current_frame;
					}
					if("wepangle_side" in _mainFire){
						wepangle = abs(wepangle) * sign(_mainFire.wepangle_side);
					}
					
					 // Combine Weapon Kick:
					if(wkick == 0){
						wkick = _fire.wkick;
					}
					else if(_fire != _mainFire){
						wkick = max(abs(wkick), abs(_fire.wkick)) * ((wkick < 0 || _fire.wkick < 0) ? -1 : 1);
					}
					
					 // Combine Motion:
					x      += _fire.x      - _mainFire.x;
					y      += _fire.y      - _mainFire.y;
					hspeed += _fire.hspeed - _mainFire.hspeed;
					vspeed += _fire.vspeed - _mainFire.vspeed;
					
					 // Combine Screenshake:
					var	_fireShake     = _fire.shake,
						_mainFireShake = _mainFire.shake;
						
					for(var i = 0; i < maxp; i++){
						view_shake[i] += _fireShake[i] - _mainFireShake[i];
					}
				}
			}
			
			 // Hasn't Shot Teamed Objects:
			else{
				 // Undo Asset Instances Created by Stock Weapon:
				for(var _lastFire = _fire.last_vars; _lastFire != undefined; _lastFire = _lastFire.last_vars){
					 // Muffle Firing Sounds:
					var _maxSoundID = _lastFire.max_sound_id;
					for(var _soundID = _lastFire.min_sound_id; _soundID < _maxSoundID; _soundID++){
						if(audio_is_playing(_soundID)){
							var _soundIndex = asset_get_index(audio_get_name(_soundID));
							if(audio_exists(_soundIndex)){
								if(ds_map_exists(global.sound_muffle_map, _soundIndex)){
									var _muffle = global.sound_muffle_map[? _soundIndex];
									_muffle.sound_id = _soundID;
									if(_muffle.frame < current_frame){
										_muffle.frame = current_frame;
										audio_sound_gain(
											_soundIndex,
											lerp(audio_sound_get_gain(_soundIndex), _muffle.sound_gain * 0.1, 0.2),
											0
										);
									}
								}
								else global.sound_muffle_map[? _soundIndex] = {
									"sound_id"   : _soundID,
									"sound_gain" : audio_sound_get_gain(_soundIndex),
									"frame"      : current_frame
								};
							}
						}
					}
					
					 // Delete Instances:
					var _maxInstanceID = _lastFire.max_instance_id;
					for(var _instanceID = _lastFire.min_instance_id; _instanceID < _maxInstanceID; _instanceID++){
						instance_delete(_instanceID);
					}
				}
				
				 // Revert Values Set by Stock Weapon:
				if(_fire.main_vars != undefined){
					var _mainFire = _fire.main_vars;
					
					 // Revert Melee Angle:
					wepangle = abs(wepangle) * sign(_mainFire.wepangle);
					
					 // Revert Weapon Kick:
					if(wkick == 0){
						wkick = _mainFire.wkick;
					}
				}
			}
			
			 // Revert Ammo Cost:
			if(!_wepIsFront){
				if(instance_is(_creator, Player)){
					var _fireAmmo = _fire.ammo;
					if(_fireAmmo != undefined){
						array_copy(_creator.ammo, 0, _fireAmmo, 0, array_length(_fireAmmo));
					}
				}
				GameCont.rad = _fire.rads;
			}
			
			 // Fix & Store Reload:
			if(reload <= 0 && _fire.reload > 0){
				reload = max(reload, (("reloadspeed" in self) ? reloadspeed : 1) * current_time_scale);
			}
			
			 // Revert Options:
			UberCont.opt_shake  = _fire.opt_shake;
			UberCont.opt_freeze = _fire.opt_freeze;
		}
	}
	
#define temerge_projectile_setup(_instanceList, _wep, _isMain, _mainX, _mainY, _mainDirection, _mainAccuracy, _mainTeam, _mainCreator)
	/*
		Merged weapons replace the projectiles fired by their stock weapon(s) with shots from their front weapon(s) and apply effects to the final projectiles
	*/
	
	if(array_length(_instanceList)){
		var _lastMerge = call(scr.projectile_tag_get_value, _mainTeam, _mainCreator, "temerge_vars");
		
		 // Replace Projectiles:
		if(_isMain && _wepXhas_merge){
			var	_mainWep         = _wep,
				_originX         = _mainX,
				_originY         = _mainY,
				_originDirection = _mainDirection,
				_playerSpeedMap  = ds_map_create();
				
			 // Setup Variable Container:
			if(_lastMerge == undefined){
				_lastMerge = {};
				call(scr.projectile_tag_set_value, _mainTeam, _mainCreator, "temerge_vars", _lastMerge);
			}
			
			 // Find Shot's Original Position & Direction:
			if(instance_exists(_mainCreator)){
				_originX = _mainCreator.x;
				_originY = _mainCreator.y;
				if("gunangle" in _mainCreator){
					_originDirection = _mainCreator.gunangle;
				}
			}
			
			 // Sort Projectiles by Relative Distance:
			var	_sortInstanceList = [],
				_sortNum          = 0,
				_lastInstanceDis  = 0;
				
			with(_instanceList){
				var _dis = point_distance(_originX, _originY, xstart, ystart);
				if(abs(_dis - _lastInstanceDis) > 8){
					_lastInstanceDis = _dis;
					_sortNum++;
				}
				array_push(_sortInstanceList, [self, _sortNum + random(1)]);
			}
			array_sort_sub(_sortInstanceList, 1, true);
			for(var i = array_length(_sortInstanceList) - 1; i >= 0; i--){
				_sortInstanceList[i] = _sortInstanceList[i][0];
			}
			
			 // Replace Projectiles w/ Firing:
			if("fire_vars" in _lastMerge){
				var	_lastMergeFire           = _lastMerge.fire_vars,
					_mainMergeFire           = _lastMerge.fire_vars.main_vars,
					_rawWep                  = undefined,
					_wepSprite               = undefined,
					_wepMergeStockSprite     = undefined,
					_wepMergeFrontFireReload = weapon_get_load(_wep),
					_instWasIndependent      = false,
					_ultraDirectionOffset    = choose(-90, 90);
					
				with(_sortInstanceList){
					if(instance_exists(self)){
						 // Don't Replace Weapon Projectiles:
						if("wep" in self){
							if(_rawWep == undefined){
								_rawWep = call(scr.wep_raw, _wep);
							}
							if(wep == _wep || wep == _rawWep || call(scr.wep_raw, wep) == _rawWep){
								if(_wepSprite == undefined){
									_wepSprite = weapon_get_sprt(wep);
								}
								if(sprite_index == _wepSprite){
									continue;
								}
								else{
									if(_wepMergeStockSprite == undefined){
										_wepXmerge_is_active = false;
										_wepMergeStockSprite = weapon_get_sprt(_wep);
										_wepXmerge_is_active = true;
									}
									if(sprite_index == _wepMergeStockSprite){
										sprite_index = _wepSprite;
										if(is_array(hitid) && array_length(hitid) > 1 && hitid[1] == _wepSprite){
											hitid[1] = sprite_index;
										}
										continue;
									}
								}
							}
						}
						
						 // Replace Projectile:
						if(_lastMergeFire.has_shot){
							if(_lastMergeFire.shot_replace_count < _lastMergeFire.shot_replace_min + floor(logn(_lastMergeFire.shot_replace_base, 1 + _lastMergeFire.shot_count))){
								_lastMergeFire.shot_replace_count++;
								
								var	_merge = {
										"last_fire_vars" : _lastMergeFire,
										"on_fire"        : (("temerge_on_fire"      in self) ? temerge_on_fire      : undefined),
										"on_setup"       : (("temerge_on_setup"     in self) ? temerge_on_setup     : undefined),
										"on_hit"         : (("temerge_on_hit"       in self) ? temerge_on_hit       : undefined),
										"on_wall"        : (("temerge_on_wall"      in self) ? temerge_on_wall      : undefined),
										"on_destroy"     : (("temerge_on_destroy"   in self) ? temerge_on_destroy   : undefined),
										"speed_factor"   : (("temerge_speed_factor" in self) ? temerge_speed_factor : undefined),
										"object"         : (("temerge_object"       in self) ? temerge_object       : undefined),
										"setup_vars"     : {}
									},
									_fireAt = {
										"x"                  : undefined,
										"y"                  : undefined,
										"position_distance"  : point_distance(_originX, _originY, xstart, ystart),
										"position_direction" : undefined,
										"position_rotation"  : angle_difference(point_direction(_originX, _originY, xstart, ystart), _originDirection),
										"direction"          : undefined,
										"direction_rotation" : angle_difference(((direction == 0 && speed == 0) ? ((image_angle == 0) ? _originDirection : image_angle) : direction), _originDirection),
										"speed_factor"       : ((_merge.speed_factor == undefined) ? (0.5 + max(0, abs(speed / 32) * (1 - (friction / 2)))) : _merge.speed_factor),
										"accuracy"           : _mainAccuracy,
										"wep"                : _wepXmerge_wep,
										"team"               : team,
										"creator"            : creator
									};
									
								 // Is Independent From the Creator:
								if(_instWasIndependent || round(_fireAt.position_distance) > 16){
									_instWasIndependent = true;
									_fireAt.x           = _originX;
									_fireAt.y           = _originY;
									_fireAt.direction   = _originDirection;
								}
								
								 // Setup Default Events:
								var _mergeObject = ((_merge.object == undefined) ? object_index : _merge.object);
								if(ds_map_exists(global.object_temerge_event_table, _mergeObject)){
									var _mergeObjectEventMap = global.object_temerge_event_table[? _mergeObject];
									switch(_merge.on_fire   ){ case undefined: _merge.on_fire    = _mergeObjectEventMap.fire;    }
									switch(_merge.on_setup  ){ case undefined: _merge.on_setup   = _mergeObjectEventMap.setup;   }
									switch(_merge.on_hit    ){ case undefined: _merge.on_hit     = _mergeObjectEventMap.hit;     }
									switch(_merge.on_wall   ){ case undefined: _merge.on_wall    = _mergeObjectEventMap.wall;    }
									switch(_merge.on_destroy){ case undefined: _merge.on_destroy = _mergeObjectEventMap.destroy; }
								}
								
								 // Call Merged Projectile Fire Event:
								if(_merge.on_fire != undefined){
									call(scr.pass, self, _merge.on_fire, _fireAt, _merge.setup_vars);
								}
								
								 // Weapon Firing:
								var	_canCost = (("temerge_can_cost" in self) ? temerge_can_cost : true),
									_canFire = (("temerge_can_fire" in self) ? temerge_can_fire : true);
									
								if(_canCost || _canFire){
									var	_fireCreator         = _fireAt.creator,
										_fireCreatorIsPlayer = instance_is(_fireCreator, Player);
										
									 // Set Firing Weapon:
									if(_fireAt.wep == _wepXmerge_wep){
										_fireAt.wep = _wepXmerge_raw_wep;
									}
									_wep = (
										is_array(_fireAt.wep)
										? _fireAt.wep[0]
										: _fireAt.wep
									);
									
									 // Take Ammo & Rads:
									if(
										_canCost
										&& (!_wepXhas_merge || !_canFire)
										&& _fireCreatorIsPlayer
										&& _mainMergeFire.infammo == 0
									){
										for(var _mergeFire = _lastMergeFire; _mergeFire != undefined; _mergeFire = _mergeFire.last_vars){
											if(_mergeFire.shot_is_delayed && _mergeFire.shot_replace_count == 1){
												break;
											}
											if(((_mergeFire.shot_replace_count - 1) % _mergeFire.shot_replace_cost_interval) >= 1){
												_canCost = false;
												break;
											}
										}
										if(_canCost){
											var	_ammoType  = _mainMergeFire.ammo_type,
												_ammoCost  = _mainMergeFire.ammo_cost,
												_radsCost  = _mainMergeFire.rads_cost,
												_costIndex = _lastMergeFire.shot_replace_count;
												
											 // Decay Cost:
											if(_costIndex != 0){
												var _costAddMult = -(1 - (power(_costIndex, temerge_weapon_cost_scale_factor) - power(_costIndex - 1, temerge_weapon_cost_scale_factor)));
												_ammoCost += round(_ammoCost * _costAddMult);
												_radsCost += round(_radsCost * _costAddMult);
											}
											
											 // Take Ammo & Rads:
											if(
												_fireCreator.ammo[_ammoType] >= _ammoCost &&
												GameCont.rad                 >= _radsCost
											){
												_fireCreator.ammo[_ammoType] -= _ammoCost;
												GameCont.rad                 -= _radsCost;
											}
											
											 // Not Enough Ammo & Rads to Fire:
											else{
												_canFire = false;
												for(var _mergeFire = _lastMergeFire; _mergeFire != undefined; _mergeFire = _mergeFire.last_vars){
													_mergeFire.has_shot = false;
												}
											}
										}
									}
									
									 // Fire Weapon:
									if(_canFire){
										var	_lastFireContReload   = 0,
											_lastFireContCanShoot = true;
											
										if(!_fireCreatorIsPlayer && instance_exists(FireCont)){
											_lastFireContReload   = FireCont.reload;
											_lastFireContCanShoot = FireCont.can_shoot;
										}
										
										with(
											_fireCreatorIsPlayer
											? _fireCreator
											: player_fire_ext(
												(("gunangle" in _fireCreator) ? _fireCreator.gunangle : _originDirection),
												wep_none,
												(("x"        in _fireCreator) ? _fireCreator.x        : _originX),
												(("y"        in _fireCreator) ? _fireCreator.y        : _originY),
												(("team"     in _fireCreator) ? _fireCreator.team     : _mainTeam),
												_fireCreator,
												(("accuracy" in _fireCreator) ? _fireCreator.accuracy : _mainAccuracy)
											)
										){
											 // Store Firing Frame:
											var _lastWep = _wep;
											_wep = _mainWep;
											_wepXmerge_wep_fire_frame = current_frame;
											_wep = _lastWep;
											
											 // Store Player Speed:
											if(_fireCreatorIsPlayer){
												if(!ds_map_exists(_playerSpeedMap, self)){
													_playerSpeedMap[? self] = speed;
												}
											}
											
											 // Restore FireCont Vars:
											else{
												reload    = _lastFireContReload;
												can_shoot = _lastFireContCanShoot;
											}
											
											 // Store Variable Container:
											_merge.speed_factor = _fireAt.speed_factor;
											call(scr.projectile_tag_set_value,
												((_fireAt.team == undefined) ? team : _fireAt.team),
												_fireCreator,
												"temerge_vars",
												_merge
											);
											
											 // Fire:
											if(_wepXhas_merge){
												var _lastMergeFireAt = _wepXmerge_fire_at;
												_wepXmerge_fire_at = _fireAt;
												call(scr.pass, self, scr.weapon_get, "fire", _wep);
												_wepXmerge_fire_at = _lastMergeFireAt;
											}
											else{
												temerge_player_fire(true, _wep, _fireAt);
												call(scr.pass, self, scr.player_fire_at,
													{
														"x"         : _fireAt.x,
														"y"         : _fireAt.y,
														"distance"  : _fireAt.position_distance,
														"direction" : _fireAt.position_direction,
														"rotation"  : _fireAt.position_rotation
													},
													{
														"direction" : _fireAt.direction,
														"rotation"  : _fireAt.direction_rotation
													},
													_fireAt.accuracy,
													_fireAt.wep,
													_fireAt.team,
													_fireCreator,
													true
												);
												if(instance_exists(self)){
													var _lastTeam = team;
													team = _fireAt.team;
													temerge_weapon_fire(true, _wep);
													team = _lastTeam;
												}
											}
											
											 // Store Minimum Firing Reload Time:
											if(reload < _wepMergeFrontFireReload){
												_wepMergeFrontFireReload = reload;
											}
											
											 // Transfer Variables:
											if(instance_is(self, FireCont)){
												call(scr.FireCont_end, self);
											}
											
											 // Stop Firing if Nothing Was Shot:
											if("fire_vars" in _merge && !_merge.fire_vars.has_shot){
												for(var _mergeFire = _lastMergeFire; _mergeFire != undefined; _mergeFire = _mergeFire.last_vars){
													_mergeFire.has_shot = false;
												}
											}
										}
									}
									
									 // Revert Firing Weapon:
									_wep = _mainWep;
								}
							}
							
							 // Increment Shot Count:
							_lastMergeFire.shot_count++;
						}
						
						 // Delete Projectile:
						if(instance_exists(self) && ("temerge_can_delete" not in self || temerge_can_delete)){
							var _canUltra = false;
							
							 // Beetle Ultra B:
							if(ultra_get("beetle", 2)){
								_wepXmerge_is_active = false;
								
								var	_wepCost = weapon_get_cost(_wep),
									_wepType = weapon_get_type(_wep);
									
								if(chance(
									((_lastMergeFire.ammo_cost == 0) ? 1 : _lastMergeFire.ammo_cost) * ((_lastMergeFire.ammo_type == type_bullet) ? (1/3) : 1),
									((_wepCost == 0) ? 1 : _wepCost) * ((_wepType == type_bullet) ? (1/3) : 1)
								)){
									_canUltra = true;
								}
								
								_wepXmerge_is_active = true;
							}
							if(_canUltra){
								 // Disable Merged Projectile Effects:
								team              = round(team);
								temerge_can_setup = false;
								
								 // Prevent Modded Weapon Insanity:
								creator = noone;
								
								 // Offset Direction:
								if(object_index == Laser || object_index == EnemyLaser){
									x            = xstart;
									y            = ystart;
									image_xscale = 1;
									image_angle += _ultraDirectionOffset;
									direction   += _ultraDirectionOffset;
									with(self){
										event_perform(ev_alarm, 0);
									}
								}
								else if(speed != 0){
									if(direction == image_angle){
										image_angle += _ultraDirectionOffset;
									}
									direction += _ultraDirectionOffset;
								}
								with(instance_create(x, y, Dust)){
									motion_add(other.direction, 3);
								}
								_ultraDirectionOffset *= -1;
							}
							
							 // Really Delete Projectile:
							else{
								switch(object_index){
									case LightningBall:
									case FlameBall:
									case BloodBall:
										var _snd = variable_instance_get(self, "snd");
										if(instance_number(object_index) <= 1 || _snd != asset_get_index(audio_get_name(_snd))){
											sound_stop(_snd);
										}
										break;
								}
								instance_delete(self);
							}
						}
					}
				}
				
				 // Store Reload Time:
				_wepXmerge_wep_fire_reload = _wepMergeFrontFireReload;
			}
			
			 // Clamp Player Speed + Manual Push (For Stacking):
			with(instances_matching_ne(ds_map_keys(_playerSpeedMap), "id")){
				var _maxSpeed = max(_playerSpeedMap[? self], maxspeed);
				if(speed > _maxSpeed){
					var	_dirX =  dcos(direction),
						_dirY = -dsin(direction);
						
					for(var _dis = (speed - _maxSpeed) / 8; _dis > 0; _dis--){
						var	_len  = min(1, _dis),
							_lenX = _len * _dirX,
							_lenY = _len * _dirY;
							
						if(place_free(x + _lenX, y + _lenY)){
							x += _lenX;
							y += _lenY;
						}
						else break;
					}
					
					speed = _maxSpeed;
				}
			}
			ds_map_destroy(_playerSpeedMap);
		}
		
		 // Apply Merged Projectile Effects:
		else if(_lastMerge != undefined && "on_setup" in _lastMerge){
			 // Ignore Instances That Already Have the Effects:
			with(_instanceList){
				if("temerge_vars_list" not in self){
					temerge_vars_list = [];
				}
				if(array_find_index(temerge_vars_list, _lastMerge) < 0 && ("temerge_can_setup" not in self || temerge_can_setup)){
					array_push(temerge_vars_list, _lastMerge);
				}
				else _instanceList = instances_matching_ne(_instanceList, "id", id);
			}
			
			 // Setup Speed Multiplier:
			var _speedFactor = _lastMerge.speed_factor;
			if(_speedFactor != 1){
				with(_instanceList){
					 // Manual Fixes:
					if(speed != 0){
						switch(object_index){
							
							case PlasmaBall:
							case PlasmaBig:
							case PlasmaHuge:
							
								projectile_add_temerge_effect(self, "fixed_plasma_speed_factor");
								
								break;
								
							case Seeker:
							
								projectile_add_temerge_effect(self, "fixed_seeker_speed_factor");
								
								break;
								
							case Rocket:
							case Nuke:
							
								if(_speedFactor > 1){
									if(active || alarm1 > 0){
										active = false;
										alarm1 = max(alarm1, 0) + 1;
										speed  = max(speed, ((object_index == Nuke) ? 5 : 12));
									}
								}
								else{
									projectile_add_temerge_effect(self, "fixed_rocket_speed_factor");
								}
								
								break;
								
						}
					}
					if("temerge_fixed_speed_factor" not in self){
						temerge_fixed_speed_factor = 1;
					}
					temerge_fixed_speed_factor *= _speedFactor;
					
					 // Clamp Speed:
					image_angle -= direction;
					var _maxSpeed = 16 + bbox_width;
					image_angle += direction;
					if(speed < _maxSpeed){
						speed = min(speed * _speedFactor, _maxSpeed);
					}
				}
			}
			
			 // Gun Gun Special:
			var _gunInstanceList = instances_matching(_instanceList, "object_index", ThrownWep);
			if(array_length(_gunInstanceList)){
				var _rawWep = call(scr.wep_raw, _wep);
				if(_rawWep == wep_gun_gun || weapon_has_temerge_weapon(_wep, wep_gun_gun)){
					with(_gunInstanceList){
						wep          = weapon_set_temerge(_rawWep, wep);
						sprite_index = weapon_get_sprt(wep);
					}
				}
			}
			
			 // Call Setup Event:
			if(_lastMerge.on_setup != undefined){
				script_ref_call(_lastMerge.on_setup, _instanceList, _lastMerge.setup_vars);
			}
			
			 // Setup Events:
			with(["hit", "wall", "destroy"]){
				var	_eventName = self,
					_eventRef  = lq_get(_lastMerge, `on_${_eventName}`);
					
				if(_eventRef != undefined){
					projectile_add_temerge_event(_instanceList, _eventName, _eventRef);
				}
			}
		}
	}
	
	
/// MERGED EFFECTS
#define temerge_effect_add_event(_effectName, _effectEventName, _scriptRef)
	/*
		Adds the given script to the given merged effect's event
	*/
	
	var _effectEventScriptListTable = global.temerge_effect_event_script_list_table;
	
	 // Setup Event Script List Map:
	var _effectEventScriptListMap = ds_map_find_value(_effectEventScriptListTable, _effectName);
	if(_effectEventScriptListMap == undefined){
		_effectEventScriptListMap = ds_map_create();
		_effectEventScriptListTable[? _effectName] = _effectEventScriptListMap;
	}
	
	 // Setup Event Script List:
	var _effectEventScriptList = ds_map_find_value(_effectEventScriptListMap, _effectEventName);
	if(_effectEventScriptList == undefined){
		_effectEventScriptList = [];
		_effectEventScriptListMap[? _effectEventName] = _effectEventScriptList;
	}
	
	 // Add to Event Script List:
	array_push(_effectEventScriptList, _scriptRef);
	
#define temerge_effect_call_event(_effectName, _effectEventName, _effectEventArgList)
	/*
		Runs the given event of the given merged effect for its instances
	*/
	
	if("temerge_effect_vars_map" in GameCont){
		var _effectVars = lq_get(GameCont.temerge_effect_vars_map, _effectName);
		if(_effectVars != undefined){
			var _effectInstanceList = _effectVars.instance_list;
			if(array_length(_effectInstanceList)){
				 // Prune Instance List:
				_effectInstanceList = instances_matching_ne(_effectInstanceList, "id");
				
				 // Untag Instance Teams:
				var _effectTagInstanceList = instances_matching(_effectInstanceList, "temerge_event_last_team", undefined);
				with(_effectTagInstanceList){
					temerge_event_last_team = team;
					team = round(team);
				}
				
				 // Call Event Scripts:
				with(global.temerge_effect_event_script_list_table[? _effectName][? _effectEventName]){
					 // Clear Instance List:
					_effectVars.instance_list = [];
					
					 // Call Script:
					var _newEffectInstanceList = (
						(_effectEventArgList == undefined)
						? script_ref_call(self, _effectInstanceList)
						: script_ref_call(call(scr.array_combine, self, [_effectInstanceList], _effectEventArgList))
					);
					if(_newEffectInstanceList != 0){
						_effectInstanceList = _newEffectInstanceList;
					}
					
					 // Store Instances:
					if(array_length(_effectVars.instance_list)){
						_effectInstanceList = call(scr.array_combine, _effectInstanceList, _effectVars.instance_list);
					}
					_effectInstanceList = instances_matching_ne(_effectInstanceList, "id");
					_effectVars.instance_list = _effectInstanceList;
				}
				
				 // Retag Instance Teams:
				with(instances_matching_ne(_effectTagInstanceList, "temerge_event_last_team", undefined)){
					if(team == temerge_event_last_team){
						team = temerge_event_last_team;
					}
					temerge_event_last_team = undefined;
				}
				
				 // Update Draw Event Depth:
				if(_effectEventName == "draw" && lq_get(_effectVars.event_instance_map, _effectEventName) == self){
					var _effectDepthInstanceList = instances_matching_lt(_effectInstanceList, "depth", depth + 1);
					if(array_length(_effectDepthInstanceList)){
						with(_effectDepthInstanceList){
							other.depth = min(other.depth, depth - 1);
						}
					}
				}
				
				 // Destroy Event:
				if("destroy_event_vars_list" in _effectVars){
					if(!array_equals(_effectVars.destroy_event_instance_list, _effectInstanceList)){
						_effectVars.destroy_event_instance_list = _effectInstanceList;
						with(_effectVars.destroy_event_vars_list){
							if(!instance_exists(id)){
								 // Remove From List:
								_effectVars.destroy_event_vars_list = call(scr.array_delete_value, _effectVars.destroy_event_vars_list, self);
								
								 // Dummy Object:
								with(instance_create(x, y, object_index)){
									 // Set Stored Variables:
									call(scr.variable_instance_set_list, self, other);
									xprevious = x;
									yprevious = y;
									direction = other.direction;
									speed     = other.speed;
									
									 // Move Ahead:
									if(!place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
										x += hspeed_raw;
										y += vspeed_raw;
									}
									
									 // Offset Lasers:
									switch(object_index){
										case Laser:
										case EnemyLaser:
											x -= lengthdir_x(12, direction);
											y -= lengthdir_y(12, direction);
									}
									
									 // Call Event Scripts:
									if(!place_meeting(x, y, PortalShock)){
										with(temerge_destroy_event_ref_list){
											call(scr.pass, other, self);
											if(!instance_exists(other)){
												break;
											}
										}
									}
									
									 // Delete:
									switch(object_index){
										case LightningBall:
										case FlameBall:
										case BloodBall:
											var _snd = variable_instance_get(self, "snd");
											if(instance_number(object_index) <= 1 || _snd != asset_get_index(audio_get_name(_snd))){
												sound_stop(_snd);
											}
											break;
									}
									instance_delete(self);
								}
							}
						}
					}
				}
			}
			
			 // Unbind Script:
			else if(lq_get(_effectVars.event_instance_map, _effectEventName) == self){
				lq_set(_effectVars.event_instance_map, _effectEventName, noone);
				instance_destroy();
			}
		}
	}
	
#define temerge_effect_object_setup(_effectName, _setupObject, _setupInstanceList)
	/*
		Collects merged projectiles that were created by 'instance_copy()'
	*/
	
	if("temerge_effect_vars_map" in GameCont){
		var _effectVars = lq_get(GameCont.temerge_effect_vars_map, _effectName);
		if(_effectVars != undefined){
			var _effectInstanceList = _effectVars.instance_list;
			if(array_length(_effectInstanceList)){
				var _effectInstanceVarName = `temerge_${_effectName}_instance`;
				
				 // Collect Instances:
				with(instances_matching_ne(_setupInstanceList, _effectInstanceVarName, null)){
					if(array_find_index(_effectInstanceList, self) < 0){
						if(array_find_index(_effectInstanceList, variable_instance_get(self, _effectInstanceVarName)) >= 0){
							array_push(_effectInstanceList, self);
							
							 // Update Instance Capturing Identifier:
							variable_instance_set(self, _effectInstanceVarName, self);
							
							 // Store Destroy Event Variables:
							if("destroy_event_vars_list" in _effectVars){
								temerge_destroy_event_vars = call(scr.variable_instance_get_list, self);
								array_push(_effectVars.destroy_event_vars_list,     temerge_destroy_event_vars);
								array_push(_effectVars.destroy_event_instance_list, self);
							}
						}
					}
				}
				
				 // Don't Unbind Script:
				exit;
			}
		}
	}
	
	 // Unbind Script:
	var	_effectObjectSetupBindVarName = `bind_setup_temerge_${_effectName}_${object_get_name(_setupObject)}`,
		_effectObjectSetupBind        = lq_get(ntte, _effectObjectSetupBindVarName);
		
	if(_effectObjectSetupBind != undefined){
		call(scr.ntte_unbind, _effectObjectSetupBind);
		lq_set(ntte, _effectObjectSetupBindVarName, undefined);
	}
	
	
#define temerge_collision_event_effect_post_step(_collisionType, _instanceList)
	/*
		Predicts collisions and runs custom collision events for merged projectiles
	*/
	
	var	_collisionDis    = 16,
		_collisionObject = -1;
		
	 // Collision Object:
	switch(_collisionType){
		case "hit"  : _collisionObject = hitme; break;
		case "wall" : _collisionObject = Wall;  break;
	}
	
	 // Instance Collision:
	var _collisionInstanceList = instances_matching_ne(_instanceList, "mask_index", mskNone);
	if(array_length(_collisionInstanceList)){
		with(_collisionInstanceList){
			if(instance_exists(self) && distance_to_object(_collisionObject) <= _collisionDis + max(0, abs(speed_raw) - friction_raw) + abs(gravity_raw)){
				var _isFixingSolid = false;
				
				 // Fix Projectiles Without Wall Collision Events:
				if(_collisionObject == Wall && array_find_index([Laser, EnemyLaser, Lightning, EnemyLightning, HyperGrenade], object_index) >= 0){
					_isFixingSolid = true;
					
					var	_lastXPrevious = xprevious,
						_lastYPrevious = yprevious;
						
					xprevious = x;
					yprevious = y;
					
					 // Object-Specific:
					switch(object_index){
						
						case Laser:
						case EnemyLaser:
						
							xprevious -= lengthdir_x(2, image_angle);
							yprevious -= lengthdir_y(2, image_angle);
							
							break;
						
						case HyperGrenade:
						
							if(alarm0 == 0){
								xprevious -= lengthdir_x(4, direction);
								yprevious -= lengthdir_y(4, direction);
							}
							
							break;
							
					}
				}
				
				 // Apply Motion:
				call(scr.motion_step, self, 1);
				
				 // Search for Nearby Collision Objects:
				if(distance_to_object(_collisionObject) <= _collisionDis){
					var _meetInstanceList = call(scr.instances_meeting_rectangle,
						bbox_left   - _collisionDis,
						bbox_top    - _collisionDis,
						bbox_right  + _collisionDis,
						bbox_bottom + _collisionDis,
						(
							(_collisionObject == hitme)
							? instances_matching_ne(_collisionObject, "team", team)
							: _collisionObject
						)
					);
					if(array_length(_meetInstanceList)){
						with(_meetInstanceList){
							 // Apply Motion:
							call(scr.motion_step, self, 1);
							
							 // Collision:
							if(place_meeting(x, y, other)){
								with(other){
									var	_isSolid             = (other.solid || solid),
										_context             = [self, other],
										_eventRefListVarName = `temerge_${_collisionType}_event_ref_list`,
										_eventRefList        = variable_instance_get(self, _eventRefListVarName),
										_minInstanceID       = instance_max;
										
									 // Solid Collision:
									if(_isSolid){
										x       = xprevious;
										y       = yprevious;
										other.x = other.xprevious;
										other.y = other.yprevious;
									}
									
									 // Call Event Scripts:
									with(_eventRefList){
										if(call(scr.pass, _context, self)){
											 // Remove Script From Event:
											_eventRefList = call(scr.array_delete_value, _eventRefList, self);
											if(instance_exists(other)){
												variable_instance_set(other, _eventRefListVarName, _eventRefList);
											}
											else break;
										}
										else if(!instance_exists(other)){
											break;
										}
										
										 // Stopped Colliding:
										if(instance_exists(_context[1])){
											var _isMeeting = true;
											with(other){
												_isMeeting = (
													_isSolid
													? place_meeting(x + hspeed_raw, y + vspeed_raw, _context[1])
													: place_meeting(x,              y,              _context[1])
												);
											}
											if(!_isMeeting){
												break;
											}
										}
										else break;
									}
									
									 // Solid Collision:
									if(_isSolid){
										if(instance_exists(self)){
											x += hspeed_raw;
											y += vspeed_raw;
										}
										if(instance_exists(other)){
											other.x += other.hspeed_raw;
											other.y += other.vspeed_raw;
										}
									}
									
									 // Colliding Instances Created During Event:
									var _maxInstanceID = instance_max;
									for(var _instanceID = _minInstanceID; _instanceID < _maxInstanceID && instance_exists(self); _instanceID++){
										if(instance_is(_instanceID, _collisionObject) && place_meeting(x, y, _instanceID)){
											_isSolid    = (solid || _instanceID.solid);
											_context[1] = _instanceID;
											
											 // Solid Collision:
											if(_isSolid){
												x             = xprevious;
												y             = yprevious;
												_instanceID.x = _instanceID.xprevious;
												_instanceID.y = _instanceID.yprevious;
											}
											
											 // Call Event Scripts:
											with(_eventRefList){
												if(call(scr.pass, _context, self)){
													 // Remove Script From Event:
													_eventRefList = call(scr.array_delete_value, _eventRefList, self);
													if(instance_exists(other)){
														variable_instance_set(other, _eventRefListVarName, _eventRefList);
													}
													else break;
												}
												else if(!instance_exists(other)){
													break;
												}
												
												 // Stopped Colliding:
												if(instance_exists(_context[1])){
													var _isMeeting = true;
													with(other){
														_isMeeting = (
															_isSolid
															? place_meeting(x + hspeed_raw, y + vspeed_raw, _context[1])
															: place_meeting(x,              y,              _context[1])
														);
													}
													if(!_isMeeting){
														break;
													}
												}
												else break;
											}
											
											 // Solid Collision:
											if(_isSolid){
												if(instance_exists(self)){
													x += hspeed_raw;
													y += vspeed_raw;
												}
												if(instance_exists(_instanceID)){
													_instanceID.x += _instanceID.hspeed_raw;
													_instanceID.y += _instanceID.vspeed_raw;
												}
											}
											
											 // Keep Searching:
											_maxInstanceID = instance_max;
										}
									}
									
									 // Remove From Event Instance List:
									if(!instance_exists(self)){
										_instanceList = instances_matching_ne(_instanceList, "id");
									}
									else if(!array_length(_eventRefList)){
										_instanceList = instances_matching_ne(_instanceList, "id", id);
									}
								}
								if(!instance_exists(self)){
									continue;
								}
							}
							
							 // Revert Motion:
							call(scr.motion_step, self, -1);
						}
						if(!instance_exists(self)){
							continue;
						}
					}
				}
				
				 // Revert Motion:
				call(scr.motion_step, self, -1);
				
				 // Revert Wall Collision Fix:
				if(_isFixingSolid){
					xprevious = _lastXPrevious;
					yprevious = _lastYPrevious;
				}
			}
		}
	}
	
	return _instanceList;
	
	
#define temerge_destroy_event_effect_post_step(_instanceList)
	/*
		Updates the stored destroy event variables for merged projectiles
	*/
	
	with(_instanceList){
		var _destroyVars = temerge_destroy_event_vars;
		_destroyVars.mask_index   = mask_index;
		_destroyVars.sprite_index = sprite_index;
		_destroyVars.image_index  = image_index;
		_destroyVars.image_xscale = image_xscale;
		_destroyVars.image_yscale = image_yscale;
		_destroyVars.image_angle  = image_angle;
		_destroyVars.image_blend  = image_blend;
		_destroyVars.image_alpha  = image_alpha;
		_destroyVars.x            = x;
		_destroyVars.y            = y;
		_destroyVars.speed        = speed;
		_destroyVars.direction    = direction;
		_destroyVars.friction     = friction;
		_destroyVars.damage       = damage;
		_destroyVars.force        = force;
		_destroyVars.team         = team;
		_destroyVars.creator      = creator;
	}
	
	
#define temerge_fixed_plasma_speed_factor_effect_begin_step(_instanceList)
	/*
		Fixes the speed multiplier for plasma merged projectiles
	*/
	
	with(instances_matching(_instanceList, "image_speed", 0)){
		_instanceList = instances_matching_ne(_instanceList, "id", id);
		speed *= temerge_fixed_speed_factor;
	}
	
	return _instanceList;
	
#define temerge_fixed_seeker_speed_factor_effect_step(_instanceList)
	/*
		Fixes the speed multiplier for seeker merged projectiles
	*/
	
	with(_instanceList){
		speed *= temerge_fixed_speed_factor;
	}
	
#define temerge_fixed_rocket_speed_factor_effect_step(_instanceList)
	/*
		Fixes the speed multiplier for rocket merged projectiles
	*/
	
	with(_instanceList){
		var _maxSpeed = ((object_index == Nuke) ? 5 : 12) * temerge_fixed_speed_factor;
		if(speed > _maxSpeed){
			speed = _maxSpeed;
		}
	}
	
#define temerge_fixed_scale_effect_draw(_instanceList)
	/*
		Draws visual scale fixes for merged projectiles
	*/
	
	with(instances_matching(_instanceList, "visible", true)){
		draw_self();
	}
	
#define temerge_fixed_lightning_yscale_effect_draw(_instanceList)
	/*
		Draws visual scale fixes for lightning merged projectiles
	*/
	
	with(instances_matching(_instanceList, "visible", true)){
		var _yScale = temerge_fixed_lightning_yscale / 2;
		image_yscale *= _yScale;
		draw_self();
		image_yscale /= _yScale;
	}
	
	
#define temerge_trail_effect_setup(_instanceList)
	/*
		Merged projectile trail visual effect
	*/
	
	with(instances_matching(_instanceList, "temerge_trail_color", null)){
		temerge_trail_color     = c_white;
		temerge_trail_delay     = 2;
		temerge_trail_is_sprite = !(
			   instance_is(self, Grenade)
			|| instance_is(self, HyperGrenade)
			|| instance_is(self, Rocket)
			|| instance_is(self, Nuke)
			|| instance_is(self, Bolt)
			|| instance_is(self, HeavyBolt)
			|| instance_is(self, UltraBolt)
			|| instance_is(self, Seeker)
			|| instance_is(self, Disc)
		);
		
		 // Default Trail Color:
		switch(object_index){
			
			case BloodGrenade:
			
				temerge_trail_color = make_color_rgb(174, 58, 45);
				
				break;
				
			case ToxicGrenade:
			case UltraGrenade:
			
				temerge_trail_color = make_color_rgb(190, 253, 8);
				
				break;
				
			case ConfettiBall:
			
				temerge_trail_color = mycol;
				
				break;
				
		}
	}
	
#define temerge_trail_effect_end_step(_instanceList)
	/*
		Merged trail projectiles leave behind a particle streak
	*/
	
	var _trailInstanceList = instances_matching_gt(_instanceList, "speed", 0);
	
	if(array_length(_trailInstanceList)){
		var _areaIsUnderwater = call(scr.area_get_underwater, GameCont.area);
		
		with(_trailInstanceList){
			if(temerge_trail_delay > 0){
				temerge_trail_delay -= current_time_scale;
			}
			else{
				with(instance_create(xprevious, yprevious, BoltTrail)){
					image_xscale = point_distance(x, y, other.x, other.y);
					image_angle  = point_direction(x, y, other.x, other.y);
					creator      = other.creator;
					if(other.temerge_trail_is_sprite){
						sprite_index  = other.sprite_index;
						image_index   = other.image_index;
						image_speed   = 0;
						image_xscale /= 1 + (other.sprite_width / 2);
						image_yscale  = other.image_yscale / 2;
						image_blend   = other.image_blend;
					}
					else{
						image_blend = other.temerge_trail_color;
					}
				}
				
				 // Bubbles:
				if(_areaIsUnderwater && chance_ct(1, 4)){
					instance_create(x, y, Bubble);
				}
			}
		}
	}
	
	
#define temerge_flame_effect_setup(_instanceList)
	/*
		Merged projectile flame-releasing effect
	*/
	
	with(_instanceList){
		if("temerge_flame" not in self){
			temerge_flame = { "amount": 0 };
			projectile_add_temerge_event(self, "destroy", script_ref_create(temerge_flame_projectile_destroy));
		}
		temerge_flame.amount++;
	}
	
#define temerge_flame_effect_step(_instanceList)
	/*
		Flame projectiles release their flame early if they slow down enough
	*/
	
	var _releaseInstanceList = instances_matching_gt(instances_matching_lt(_instanceList, "speed", 5), "friction", 0);
	
	if(array_length(_releaseInstanceList)){
		with(_releaseInstanceList){
			_instanceList = instances_matching_ne(_instanceList, "id", id);
			temerge_flame_projectile_destroy();
			temerge_flame.amount = 0;
		}
	}
	
	return _instanceList;
	
#define temerge_flame_projectile_destroy
	/*
		Flame projectiles release their flame on destruction
	*/
	
	if(temerge_flame.amount > 0){
		repeat(temerge_flame.amount){
			call(scr.projectile_create,
				x,
				y,
				Flame,
				((speed == 0) ? random(360) : direction),
				max(1.5, speed / 2)
			);
		}
	}
	
	
#define temerge_flame_trail_effect_setup // instanceList, flameTrailAmount=1
	/*
		Merged projectile flame trail effect
	*/
	
	var	_instanceList     = argument[0],
		_flameTrailAmount = ((argument_count > 1) ? argument[1] : 1);
		
	with(_instanceList){
		if("temerge_flame_trail_amount" not in self){
			temerge_flame_trail_amount = 0;
			temerge_flame_trail_angle  = random(360);
			projectile_add_temerge_event(_instanceList, "hit", script_ref_create(temerge_flame_trail_projectile_hit));
		}
		temerge_flame_trail_amount += _flameTrailAmount;
	}
	
#define temerge_flame_trail_effect_step(_instanceList)
	/*
		Merged flame trail projectiles leave behind a trail of flames
	*/
	
	var	_lastSprite = -1,
		_lastYScale = 1,
		_flameScale = 1;
		
	with(_instanceList){
		if((current_frame % damage) >= 1){
			 // Store Sprite Information:
			if(sprite_index != _lastSprite || image_yscale != _lastYScale){
				_lastSprite = sprite_index;
				_flameScale = (((sprite_get_bbox_bottom(sprite_index) + 1) - sprite_get_bbox_top(sprite_index)) * image_yscale) / 16;
				if(_flameScale >= 0.375 && _flameScale < 1){
					_flameScale = 1;
				}
			}
			
			 // Spew Flame(s):
			for(var _length = 0; _length <= speed_raw; _length += 8 * _flameScale){
				with(instance_create(
					x + lengthdir_x(_length, direction),
					y + lengthdir_y(_length, direction),
					Flame
				)){
					 // Motion:
					motion_add(
						other.temerge_flame_trail_angle,
						other.temerge_flame_trail_amount + random(1)
					);
					
					 // Dissipate Faster:
					image_index = max(0, (image_number - 1) - (1 + other.damage));
					
					 // Resize:
					image_xscale *= _flameScale;
					image_yscale *= _flameScale;
					
					 // Setup:
					projectile_init(other.team, other);
					
					 // Extra Flames:
					if(other.temerge_flame_trail_amount > 1){
						var _directionOffset = 0;
						repeat(other.temerge_flame_trail_amount - 1){
							_directionOffset += 360 / other.temerge_flame_trail_amount;
							with(instance_copy(false)){
								direction += _directionOffset;
							}
						}
					}
				}
			}
			
			 // Rotate Trail:
			temerge_flame_trail_angle += 36 / temerge_flame_trail_amount;
		}
	}
	
#define temerge_flame_trail_projectile_hit
	/*
		Merged flame trail projectiles create flames on impact with a hittable
	*/
	
	if(projectile_can_temerge_hit(other) && current_frame_active){
		repeat(5 * temerge_flame_trail_amount){
			call(scr.projectile_create,
				x,
				y,
				Flame,
				random(360),
				random_range(2, 3) * temerge_flame_trail_amount
			);
		}
	}
	
	
#define temerge_toxic_effect_setup(_instanceList)
	/*
		Merged projectile toxic gas-releasing effect
	*/
	
	projectile_add_temerge_event(_instanceList, "destroy", script_ref_create(temerge_toxic_projectile_destroy));
	
#define temerge_toxic_projectile_destroy
	/*
		Toxic projectiles release toxic gas on destruction
	*/
	
	var _num = min(damage * 2/3, 640);
	
	_num = floor(_num) + chance(frac(_num), 1);
	
	if(_num > 0){
		repeat(_num){
			instance_create(x, y, ToxicGas);
		}
		
		 // Sound:
		call(scr.sound_play_at,
			x,
			y,
			sndToxicBoltGas,
			max(0.6, 1.2 - (0.0125 * _num)) + orandom(0.1),
			0.2 + (0.05 * _num),
			320
		);
		
		 // Effects:
		repeat(ceil(_num / 3)){
			call(scr.fx, x, y, random(sqrt(_num) / 2), Smoke);
		}
	}
	
	
#define temerge_slug_effect_setup(_instanceList, _size)
	/*
		Merged projectile slug impact effect
	*/
	
	with(_instanceList){
		if("temerge_slug_size" not in self){
			temerge_slug_size = 0;
			projectile_add_temerge_event(self, "hit", script_ref_create(temerge_slug_projectile_hit));
		}
		temerge_slug_size += _size;
	}
	
	 // Add Bloom:
	projectile_add_temerge_bloom(_instanceList, _size / 3);
	
#define temerge_slug_hit(_instance, _hitInstance, _hitX, _hitY, _hitDamage)
	/*
		Applies merged slug projectile impact damage & effects to the given hittable instance
		
		Args:
			instance    - The projectile instance
			hitInstance - The hitme instance
			hitX, hitY  - The position that the hitme instance is being hit from
			hitDamage   - The damage that is applied to the hitme instance
			hitMult     - The multiplier for the damage and effects
	*/
	
	with(_hitInstance){
		var	_x   = bbox_center_x,
			_y   = bbox_center_y,
			_dir = (
				(_x == _hitX && _y == _hitY)
				? random(360)
				: point_direction(_x, _y, _hitX, _hitY)
			);
			
		 // Hit Effect:
		with(instance_create(
			_x + lengthdir_x(min(abs(_hitX - _x), (bbox_width  / 2) + 1), _dir),
			_y + lengthdir_y(min(abs(_hitY - _y), (bbox_height / 2) + 1), _dir),
			BulletHit
		)){
			var _scale = 0.75 + (max(0, _hitDamage) / 80);
			sprite_index = ((_scale < 1.5) ? sprSlugHit : sprHeavySlugHit);
			image_xscale = ((_scale < 1.5) ? _scale     : (_scale / 1.5));
			image_yscale = image_xscale;
			depth        = -6;
			friction     = 0.6;
			motion_add(_dir + 180 + orandom(30), 4);
		}
		
		 // Hit Damage:
		if(instance_exists(_instance)){
			with(_instance){
				projectile_hit(other, _hitDamage);
			}
		}
		else projectile_hit_raw(self, _hitDamage, 1);
	}
	
#define temerge_slug_projectile_hit
	/*
		Merged slug projectiles deal extra impact damage to the first thing they hit
	*/
	
	if(temerge_slug_size != 0){
		if(projectile_can_temerge_hit(other)){
			var _damage = ceil(((damage == 0) ? 1 : damage) * (power(1.5, temerge_slug_size) - 1));
			
			if("temerge_slug_nexthurt" not in other || other.temerge_slug_nexthurt <= current_frame){
				var _lastNextHurt = other.nexthurt;
				
				 // Deal Impact Damage:
				temerge_slug_hit(self, other, x, y, _damage);
				
				with(other){
					 // Manual I-Frames:
					temerge_slug_nexthurt = nexthurt;
					nexthurt = _lastNextHurt;
					
					 // Piercing Fix:
					if(my_health <= 0){
						script_bind_end_step(temerge_slug_projectile_hit_health_end_step, 0, self, my_health);
						my_health = 1;
					}
				}
				
				 // Disable Slug Effect:
				if(instance_exists(self)){
					projectile_add_temerge_bloom(self, -temerge_slug_size / 3);
					temerge_slug_size = 0;
				}
				
				 // Disable Event:
				return true;
			}
			
			 // Check Post-Collision:
			else script_bind_end_step(temerge_slug_projectile_hit_end_step, 0, self, other, x, y, _damage);
		}
	}
	
	 // Disable Event:
	else return true;
	
#define temerge_slug_projectile_hit_end_step(_instance, _hitInstance, _hitX, _hitY, _hitDamage)
	if(!instance_exists(_instance)){
		temerge_slug_hit(_instance, instances_matching_ne(_hitInstance, "id"), _hitX, _hitY, _hitDamage);
	}
	instance_destroy();
	
#define temerge_slug_projectile_hit_health_end_step(_slugInstance, _lastHealth)
	with(instances_matching_le(_slugInstance, "my_health", 1)){
		my_health = _lastHealth + (my_health - 1);
	}
	instance_destroy();
	
	
#define temerge_hyper_effect_setup // instanceList, hyperSpeed=1
	/*
		Merged projectile hyper travel effect
	*/
	
	var	_instanceList = argument[0],
		_hyperSpeed   = ((argument_count > 1) ? argument[1] : 1);
		
	with(_instanceList){
		 // Hyper Melee:
		if(speed < 8 && array_find_index([Slash, EnemySlash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash, Shank, EnergyShank], object_index) >= 0){
			if(array_find_index(obj.HyperSlashTrail, self) < 0){
				var	_maskIndex   = ((mask_index < 0) ? sprite_index : mask_index),
					_bboxCenterX = bbox_center_x,
					_bboxCenterY = bbox_center_y;
					
				with(creator){
					if(mask_index != mskNone && !place_meeting(_bboxCenterX, _bboxCenterY, Wall) && !collision_line(x, y, _bboxCenterX, _bboxCenterY, Wall, false, false)){
						var	_lastX    = x,
							_lastY    = y,
							_moveDis  = max(64, 2 * ((sprite_get_bbox_right(_maskIndex) + 1) - sprite_get_bbox_left(_maskIndex))) * _hyperSpeed,
							_moveLen  = 8,
							_moveDir  = ((other.direction == 0 && other.speed == 0) ? ((other.image_angle == 0 && "gunangle" in self) ? gunangle : other.image_angle) : other.direction),
							_moveX    = lengthdir_x(_moveLen, _moveDir),
							_moveY    = lengthdir_y(_moveLen, _moveDir);
							
						x = _bboxCenterX;
						y = _bboxCenterY;
						
						 // Creator Wall Hitscan:
						while(_moveDis > 0 && place_free(x + (3 * _moveX), y + (3 * _moveY))){
							_moveDis -= _moveLen;
							x        += _moveX;
							y        += _moveY;
						}
						
						 // Slash:
						with(other){
							var	_trailX = x,
								_trailY = y;
								
							 // Move Slash:
							x        += other.x - _bboxCenterX;
							y        += other.y - _bboxCenterY;
							xprevious = x;
							yprevious = y;
							
							 // Create Trail:
							with(call(scr.obj_create, _trailX, _trailY, "HyperSlashTrail")){
								target = other;
								
								 // One-Sided Trail:
								if("wepangle" in other.creator){
									sprite_side = -sign(other.creator.wepangle * other.image_yscale);
								}
								
								 // Fix for Position Changing in End Step:
								if(instance_is(other, CustomSlash) && other.on_end_step != undefined){
									on_end_step = on_step;
								}
								
								 // Instant Setup:
								event_perform(ev_step, ev_step_normal);
							}
						}
						
						 // Keep Creator Here:
						var _hyperDistance = point_distance(x, y, _bboxCenterX, _bboxCenterY);
						if(
							"temerge_hyper_frame" not in self
							|| temerge_hyper_frame < current_frame
							|| ("temerge_hyper_distance" in self && _hyperDistance > temerge_hyper_distance)
						){
							temerge_hyper_frame    = current_frame;
							temerge_hyper_distance = _hyperDistance;
							
							 // Stay Put:
							xprevious = x;
							yprevious = y;
							
							 // Shift Screen:
							call(scr.view_shift, index, _moveDir, _hyperDistance / 2);
						}
						
						 // Move Creator Back:
						else{
							x = _lastX;
							y = _lastY;
						}
					}
				}
			}
			
			 // Remove From List:
			_instanceList = instances_matching_ne(_instanceList, "id", id);
		}
		
		 // Hyper Projectiles:
		else{
			if("temerge_hyper_speed" not in self){
				temerge_hyper_speed    = 0;
				temerge_hyper_minspeed = max(1, min(friction * 10, speed - (4 * friction)));
			}
			temerge_hyper_speed += _hyperSpeed;
		}
	}
	
	return _instanceList;
	
#define temerge_hyper_effect_begin_step(_instanceList)
	/*
		Merged hyper projectiles travel instantly until they hit a wall or enemy
	*/
	
	var _hyperInstanceList = instances_matching_ge(_instanceList, "speed", 1);
	
	if(array_length(_hyperInstanceList)){
		var _projectileCollisionObjectList = [
			Slash,
			EnemySlash,
			GuitarSlash,
			BloodSlash,
			EnergySlash,
			EnergyHammerSlash,
			LightningSlash,
			CustomSlash,
			Shank,
			EnergyShank,
			HorrorBullet,
			GuardianDeflect
		];
		
		with(_hyperInstanceList){
			if(speed >= temerge_hyper_minspeed){
				var	_stepNum  = 0,
					_stepMax  = 15 * temerge_hyper_speed,
					_isMelee  = (array_find_index(_projectileCollisionObjectList, object_index) >= 0),
					_lastTeam = team;
					
				team = temerge_event_last_team;
				
				with(self){
					while(_stepNum < _stepMax && speed >= temerge_hyper_minspeed){
						 // Alarms:
						if(((current_frame + _stepNum + epsilon) % 1) < current_time_scale){
							var _notExisting = false;
							for(var _alarmIndex = 0; _alarmIndex < 12; _alarmIndex++){
								var _alarmNum = alarm_get(_alarmIndex);
								if(_alarmNum >= 0){
									//if(event_exists(object_index, ev_alarm, _alarmIndex)){
										alarm_set(_alarmIndex, --_alarmNum);
										if(_alarmNum == 0){
											event_perform(ev_alarm, _alarmIndex);
											if(!instance_exists(self)){
												_notExisting = true;
												break;
											}
										}
									//}
								}
							}
							if(_notExisting){
								break;
							}
						}
						
						 // Step:
						event_perform(ev_step, ev_step_normal);
						if(!instance_exists(self)){
							break;
						}
						
						 // Movement:
						if(friction_raw != 0 && speed_raw != 0){
							speed_raw -= min(abs(speed_raw), friction_raw) * sign(speed_raw);
						}
						if(gravity_raw != 0){
							hspeed_raw += lengthdir_x(gravity_raw, gravity_direction);
							vspeed_raw += lengthdir_y(gravity_raw, gravity_direction);
						}
						if(speed_raw != 0){
							x += hspeed_raw;
							y += vspeed_raw;
						}
						
						 // Smoke Trail:
						if(chance_ct(1, 10)){
		        			instance_create(x, y, Smoke);
						}
						
						 // Potential Collision:
						if(place_meeting(x, y, Wall) || place_meeting(x, y, PortalShock)){
							x = xprevious;
							y = yprevious;
							break;
						}
						
						 // Potential Hit:
						if(place_meeting(x, y, hitme)){
							if(array_length(instances_matching_gt(call(scr.instances_meeting_instance, self, instances_matching_ne(hitme, "team", team)), "my_health", 0))){
								x = xprevious;
								y = yprevious;
								break;
							}
						}
						
						 // Potential Deflection:
						if(typ != 0){
							var _collisionObjectList = [];
							if(place_meeting(x, y, projectile   )) _collisionObjectList = call(scr.array_combine, _collisionObjectList, _projectileCollisionObjectList);
							if(place_meeting(x, y, CrystalShield)) array_push(_collisionObjectList, CrystalShield);
							if(place_meeting(x, y, PopoShield   )) array_push(_collisionObjectList, PopoShield);
							if(place_meeting(x, y, MeatExplosion)) array_push(_collisionObjectList, MeatExplosion);
							if(place_meeting(x, y, PopoExplosion)) array_push(_collisionObjectList, PopoExplosion);
							if(array_length(_collisionObjectList)){
								if(array_length(call(scr.instances_meeting_instance, self, instances_matching_ne(_collisionObjectList, "team", team)))){
									x = xprevious;
									y = yprevious;
									break;
								}
							}
						}
						if(_isMelee && place_meeting(x, y, projectile)){
							if(array_length(call(scr.instances_meeting_instance, self, instances_matching_ne(instances_matching_ne(projectile, "team", team), "typ", 0)))){
								x = xprevious;
								y = yprevious;
								break;
							}
						}
						
						 // End Step:
						event_perform(ev_step, ev_step_end);
						if(!instance_exists(self)){
							break;
						}
						
						 // Store Last Position:
						xprevious = x;
						yprevious = y;
						
						 // Animate:
						image_index += image_speed_raw;
						if(image_index < 0 || image_index >= image_number){
							image_index -= image_number * sign(image_index);
							event_perform(ev_other, ev_animation_end);
							if(!instance_exists(self)){
								break;
							}
						}
						
						 // Begin Step:
						event_perform(ev_step, ev_step_begin);
						if(!instance_exists(self)){
							break;
						}
						
						_stepNum += current_time_scale;
					}
				}
				
				if(instance_exists(self)){
					 // Revert Team:
					if(team == temerge_event_last_team){
						team = _lastTeam;
					}
					
					 // Remove From List:
					if(speed - friction_raw < temerge_hyper_minspeed){
						_instanceList = instances_matching_ne(_instanceList, "id", id);
					}
				}
			}
		}
		
		return _instanceList;
	}
	
	
#define temerge_piercing_effect_setup(_instanceList, _piercingAmount)
	/*
		Merged projectile enemy piercing effect
	*/
	
	with(_instanceList){
		if("temerge_piercing_amount" not in self){
			temerge_piercing_amount = 0;
			projectile_add_temerge_event(self, "hit", script_ref_create(temerge_piercing_projectile_hit));
		}
		temerge_piercing_amount = max(temerge_piercing_amount, _piercingAmount);
	}
	
#define temerge_piercing_projectile_hit
	/*
		Merged piercing projectiles can survive hitting weaker enemies 
	*/
	
	if(projectile_can_temerge_hit(other)){
		var _piercingHealth = ceil(damage * temerge_piercing_amount);
		if(other.my_health <= _piercingHealth){
			 // Manual Damage:
			projectile_hit(other, max(damage, _piercingHealth), force);
			
			 // Temporarily Disable Enemy Hitbox:
			with(other){
				if(mask_index != mskNone){
					script_bind_end_step(temerge_piercing_projectile_hit_mask_end_step, 0, self, mask_index);
					mask_index = mskNone;
				}
			}
		}
	}
	
#define temerge_piercing_projectile_hit_mask_end_step(_instance, _mask)
	/*
		Restores the hitbox of the given pierced enemy
	*/
	
	with(instances_matching(_instance, "mask_index", mskNone)){
		mask_index = _mask;
	}
	
	instance_destroy();
	
	
#define temerge_wall_piercing_effect_setup(_instanceList, _piercingAmount)
	/*
		Merged projectile wall piercing effect
	*/
	
	with(_instanceList){
		if("temerge_wall_piercing_count" not in self){
			temerge_wall_piercing_count = 0;
			projectile_add_temerge_event(self, "wall", script_ref_create(temerge_wall_piercing_projectile_wall));
		}
		temerge_wall_piercing_count += _piercingAmount;
	}
	
#define temerge_wall_piercing_projectile_wall
	/*
		Merged wall piercing projectiles break walls on impact
	*/
	
	if(temerge_wall_piercing_count > 0){
		with(other){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
		
		 // Slow Down (Less Weird):
		if(speed > 16){
			speed = 16;
		}
		
		 // Disable Event:
		if(--temerge_wall_piercing_count <= 0){
			return true;
		}
	}
	
	 // Disable Event:
	else return true;
	
	
#define temerge_seeking_effect_setup(_instanceList)
	/*
		Merged projectile enemy seeking effect
	*/
	
	with(_instanceList){
		if("temerge_seeking_strength" not in self){
			temerge_seeking_strength = 0;
		}
		temerge_seeking_strength++;
	}
	
#define temerge_seeking_effect_step(_instanceList)
	/*
		Merged seeker projectiles turn towards the nearest enemy
	*/
	
	var _seekingInstanceList = instances_matching_ne(instances_matching_ne([enemy, Player, Ally, Sapling, SentryGun, CustomHitme], "team", 0), "mask_index", mskNone);
	
	if(array_length(_seekingInstanceList)){
		with(instances_matching_ne(_instanceList, "speed", 0)){
			var	_turn   = orandom(speed_raw / 4),
				_target = call(scr.instance_nearest_array,
					x + (6 * hspeed),
					y + (6 * vspeed),
					instances_matching_ne(_seekingInstanceList, "team", team)
				);
				
			 // Turn Towards Target:
			if(instance_exists(_target) && !collision_line(x, y, _target.x, _target.y, Wall, false, false)){
				var	_addTurn = angle_difference(point_direction(x, y, _target.x, _target.y), direction),
					_maxTurn = 3 * (abs(_addTurn) / (abs(_addTurn) + 30)) * temerge_seeking_strength * current_time_scale;
					
				 // Nearby Seeking:
				if(distance_to_object(_target) < 6 * speed){
					_maxTurn *= 2;
					
					 // Disable Nuke Homing:
					if(instance_is(self, Nuke)){
						index = -1;
					}
				}
				
				_turn += clamp(_addTurn, -_maxTurn, _maxTurn);
			}
			
			 // Turning:
			direction   += _turn;
			image_angle += _turn;
		}
		
		 // Lasers:
		var _laserInstanceList = instances_matching(instances_matching(_instanceList, "object_index", Laser, EnemyLaser), "speed", 0);
		if(array_length(_laserInstanceList)){
			with(_laserInstanceList){
				var _target = call(scr.instance_nearest_array, x, y, instances_matching_ne(_seekingInstanceList, "team", team));
				if(instance_exists(_target) && !collision_line(xstart, ystart, _target.x, _target.y, Wall, false, false)){
					var	_len = min(4 * temerge_seeking_strength * current_time_scale, point_distance(x, y, _target.x, _target.y)),
						_dir = point_direction(x, y, _target.x, _target.y);
						
					x           += lengthdir_x(_len, _dir);
					y           += lengthdir_y(_len, _dir);
					image_angle  = point_direction(xstart, ystart, x, y);
					image_xscale = point_distance(xstart, ystart, x, y) / 2;
				}
			}
		}
	}
	
	
#define temerge_explosion_effect_setup // instanceList, ?explosionInfo, explosionCount=1
	/*
		Merged projectile destruction explosion effect
	*/
	
	var	_instanceList   = argument[0],
		_explosionInfo  = ((argument_count > 1) ? lq_clone(argument[1]) : {}),
		_explosionCount = ((argument_count > 2) ? lq_clone(argument[2]) : 1);
		
	 // Default Values:
	with(["is_small", "is_heavy", "is_blood", "is_bubble", "is_toxic", "is_cluster"]){
		if(self not in _explosionInfo){
			lq_set(_explosionInfo, self, false);
		}
	}
	if("is_active" not in _explosionInfo){
		_explosionInfo.is_active = true;
	}
	
	 // Add Explosion:
	with(_instanceList){
		if("temerge_explosion_list" not in self){
			temerge_explosion_list = [];
			projectile_add_temerge_event(self, "destroy", script_ref_create(temerge_explosion_projectile_destroy));
		}
		repeat(_explosionCount){
			array_push(temerge_explosion_list, _explosionInfo);
		}
	}
	
	 // Toxic Explosions:
	if(_explosionInfo.is_toxic){
		projectile_add_temerge_effect(_instanceList, "toxic");
	}
	
#define temerge_explosion_projectile_destroy
	/*
		Merged explosion projectiles create explosions on destruction
	*/
	
	if((object_index != Lightning && object_index != EnemyLightning) || (ammo % 4) < 1){
		var	_explosionList  = temerge_explosion_list,
			_explosionCount = array_length(_explosionList),
			_explosionAngle = random(360);
			
		for(var _explosionIndex = 0; _explosionIndex < _explosionCount; _explosionIndex++){
			var _explosion = _explosionList[_explosionIndex];
			if(_explosion.is_active){
				var	_explosionIsSmall   = (_explosion.is_small || damage < 10),
					_explosionIsHeavy   = _explosion.is_heavy,
					_explosionIsBlood   = _explosion.is_blood,
					_explosionIsBubble  = _explosion.is_bubble,
					_explosionIsCluster = _explosion.is_cluster,
					_explosionOffsetLen = min(16, 8 * (_explosionCount - 1)),
					_explosionOffsetDir = _explosionAngle + (360 * (_explosionIndex / _explosionCount)),
					_explosionX         = x + lengthdir_x(_explosionOffsetLen, _explosionOffsetDir),
					_explosionY         = y + lengthdir_y(_explosionOffsetLen, _explosionOffsetDir),
					_explosionSubCount  = ((_explosionIsBlood && !_explosionIsSmall) ? 3 : 1),
					_explosionSubAngle  = random(360);
					
				 // Sound:
				if(_explosionIsCluster){
					sound_play_hit(sndClusterOpen, 0.2);
				}
				else if(_explosionIsBlood){
					sound_play_hit_big(sndMeatExplo,          0.2);
					sound_play_hit_big(sndBloodLauncherExplo, 0.2);
				}
				else if(!_explosionIsBubble){
					sound_play_hit_big(
						(
							(_explosionCount > 1)
							? (_explosionIsSmall ? sndExplosion  : sndExplosionL)
							: (_explosionIsSmall ? sndExplosionS : sndExplosion)
						),
						0.2
					);
				}
				
				 // Create Explosion:
				for(var _explosionSubOffsetDir = _explosionSubAngle; _explosionSubOffsetDir < _explosionSubAngle + 360; _explosionSubOffsetDir += (360 / _explosionSubCount)){
					if(_explosionIsCluster){
						var _clusterNum = min(ceil(damage / 3), 640) + (crown_current == crwn_death);
						if(_clusterNum > 0){
							var _clusterMotionLerpAmount = min(abs(speed) / 16, 1) / sqrt(_clusterNum);
							repeat(_clusterNum){
								call(scr.projectile_create,
									x + orandom(2),
									y + orandom(2),
									MiniNade,
									angle_lerp(random(360), direction, _clusterMotionLerpAmount),
									lerp(random_range(3, 8), speed / 2, _clusterMotionLerpAmount)
								);
								
								 // Smoke:
								call(scr.fx, x, y, random_range(2, 5), Smoke);
							}
						}
					}
					else{
						var _explosionSubOffsetLen = ((_explosionSubCount > 1) ? 24 : random(1));
						with(call(scr.projectile_create,
							_explosionX + lengthdir_x(_explosionSubOffsetLen, _explosionSubOffsetDir),
							_explosionY + lengthdir_y(_explosionSubOffsetLen, _explosionSubOffsetDir),
							(
								_explosionIsBubble
								? (_explosionIsSmall ? "BubbleExplosionSmall" : "BubbleExplosion")
								: (
									_explosionIsBlood
									? MeatExplosion
									: (
										_explosionIsSmall
										? (_explosionIsHeavy ? "SmallGreenExplosion" : SmallExplosion)
										: (_explosionIsHeavy ? GreenExplosion        : Explosion)
									)
								)
							),
							direction,
							speed / 4
						)){
							friction    = 0.5;
							image_angle = 0;
							
							 // Damage:
							damage  = other.damage;
							damage *= (_explosionIsHeavy ? (4/5) : (1/3));
							if(_explosionIsBlood){
								damage *= 0.8;
							}
							if(_explosionIsBubble){
								damage *= 0.6;
							}
							damage = round(damage);
							
							 // Streak Blood:
							if(_explosionIsBlood){
								with(instance_create(_explosionX, _explosionY, BloodStreak)){
									image_angle = _explosionSubOffsetDir;
								}
							}
							
							else{
								 // Hostile to Player:
								if(!_explosionIsBubble){
									team = -1;
									if(hitid == -1){
										switch(object_index){
											case Explosion      : hitid = 55; break;
											case SmallExplosion : hitid = 56; break;
											case GreenExplosion : hitid = 99; break;
										}
									}
								}
								
								 // Crown of Death:
								if(crown_current == crwn_death && _explosionIsSmall && !_explosion.is_small){
									with(instance_copy(false)){
										x += orandom(2);
										y += orandom(2);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	
#define temerge_grenade_effect_setup // instanceList, maxRange, ?explosionInfo
	/*
		Merged projectile timed explosion effect
	*/
	
	var	_instanceList  = argument[0],
		_maxRange      = argument[1],
		_explosionInfo = ((argument_count > 2) ? argument[2] : undefined);
		
	if("temerge_grenade_frame" not in GameCont){
		GameCont.temerge_grenade_frame = 0;
	}
	
	with(_instanceList){
		if("temerge_grenade_frame" not in self){
			temerge_grenade_frame = GameCont.temerge_grenade_frame;
			
			 // Hyper Grenade Events:
			if(instance_is(self, HyperGrenade)){
				projectile_add_temerge_event(self, "hit",  script_ref_create(temerge_grenade_HyperGrenade_hit));
				projectile_add_temerge_event(self, "wall", script_ref_create(temerge_grenade_HyperGrenade_wall));
			}
		}
		
		 // Explosion Delay:
		temerge_grenade_frame = max(temerge_grenade_frame, GameCont.temerge_grenade_frame + (_maxRange / max(6, speed)));
		if(instance_is(self, Grenade) && alarm0 > 0){
			temerge_grenade_frame += alarm0 / 4;
			alarm0 = -1;
		}
	}
	
	 // Add Explosion:
	if(_explosionInfo != undefined){
		projectile_add_temerge_effect(_instanceList, "explosion", [_explosionInfo]);
	}
	
#define temerge_grenade_effect_step(_instanceList)
	/*
		Merged grenade projectiles destroy themselves after a length of time
	*/
	
	GameCont.temerge_grenade_frame += current_time_scale;
	
	var _explodeInstanceList = instances_matching_le(_instanceList, "temerge_grenade_frame", GameCont.temerge_grenade_frame);
	
	if(array_length(_explodeInstanceList)){
		projectile_temerge_destroy(_explodeInstanceList);
	}
	
#define temerge_grenade_effect_end_step(_instanceList)
	/*
		Merged grenade projectiles explode if they touch explosions when they're about to explode (for balance purposes)
	*/
	
	if(instance_exists(Explosion)){
		var _blinkInstanceList = instances_matching_le(_instanceList, "temerge_grenade_frame", GameCont.temerge_grenade_frame + 10);
		if(array_length(_blinkInstanceList)){
			with(_blinkInstanceList){
				if(place_meeting(x, y, Explosion)){
					projectile_temerge_destroy(self);
				}
			}
		}
	}
	
#define temerge_grenade_effect_draw(_instanceList)
	/*
		Merged grenade projectiles visually flash when they're about to explode
	*/
	
	var _blinkInstanceList = instances_matching(instances_matching_le(_instanceList, "temerge_grenade_frame", GameCont.temerge_grenade_frame + 10), "visible", true);
	
	if(array_length(_blinkInstanceList)){
		draw_set_fog(true, ((((GameCont.temerge_grenade_frame * 0.4) % 2) < 1) ? c_white : c_black), 0, 0);
		
		with(_blinkInstanceList){
			draw_self();
		}
		
		draw_set_fog(false, 0, 0, 0);
	}
	
#define temerge_grenade_HyperGrenade_hit
	/*
		Merged sticky grenade hyper grenades don't detonate instantly
	*/
	
	alarm1 = max(alarm1, temerge_grenade_frame - GameCont.temerge_grenade_frame);
	
#define temerge_grenade_HyperGrenade_wall
	/*
		Merged grenade hyper grenades bounce off walls like normal grenades
	*/
	
	if("temerge_explosion_list" in self){
		var _canBounce = false;
		with(temerge_explosion_list){
			if(!is_small && !is_blood){
				_canBounce = true;
				break;
			}
		}
		if(_canBounce){
			 // Delay Explosion:
			alarm1 = max(alarm1, temerge_grenade_frame - GameCont.temerge_grenade_frame);
			
			 // Bounce:
			if(speed != 0 && "temerge_sticky_target" not in self){
				friction = 0.4;
				move_bounce_solid(true);
				sound_play_hit(sndGrenadeHitWall, 0.2);
				instance_create(x, y, Dust);
			}
		}
	}
	
	
#define temerge_sticky_effect_setup(_instanceList)
	/*
		Merged projectile sticky effect
	*/
	
	with(instances_matching(_instanceList, "temerge_sticky_target", null)){
		temerge_sticky_target     = noone;
		temerge_sticky_xoffset    = 0;
		temerge_sticky_yoffset    = 0;
		temerge_sticky_mask_index = mskNone;
		
		 // Projectile Events:
		projectile_add_temerge_event(self, "hit",  script_ref_create(temerge_sticky_projectile_stick));
		projectile_add_temerge_event(self, "wall", script_ref_create(temerge_sticky_projectile_stick));
	}
	
#define temerge_sticky_effect_post_step(_instanceList)
	/*
		Merged sticky projectiles follow what they're stuck to around
	*/
	
	var _stickyInstanceList = instances_matching_ne(_instanceList, "temerge_sticky_target", noone);
	
	if(array_length(_stickyInstanceList)){
		with(_stickyInstanceList){
			if(instance_exists(temerge_sticky_target)){
				 // Follow Target:
				x = lerp_ct(x, temerge_sticky_target.x + temerge_sticky_xoffset, 0.5);
				y = lerp_ct(y, temerge_sticky_target.y + temerge_sticky_yoffset, 0.5);
				call(scr.motion_step, self, -1);
				
				 // Thrust:
				if(speed != 0){
					switch(object_index){
						
						case Rocket:
						case Nuke:
						
							if(active && instance_is(temerge_sticky_target, hitme)){
								with(temerge_sticky_target){
									motion_add_ct(other.direction, other.speed / (3 * (max(0, size) + 1)));
								}
							}
							
							break;
							
					}
				}
				
				 // Disable Hitbox:
				if(mask_index != mskNone && object_index != UltraBolt){
					temerge_sticky_mask_index = mask_index;
					mask_index                = mskNone;
				}
			}
			else{
				temerge_sticky_target = noone;
				
				 // Restore Hitbox:
				if(temerge_sticky_mask_index != mskNone){
					mask_index                = temerge_sticky_mask_index;
					temerge_sticky_mask_index = mskNone;
				}
			}
		}
	}
	
#define temerge_sticky_projectile_stick
	/*
		Merged sticky projectiles stick to hittables and walls instead of their normal interaction
	*/
	
	if(!instance_exists(temerge_sticky_target) && visible){
		temerge_sticky_target  = other;
		temerge_sticky_xoffset = x - other.x;
		temerge_sticky_yoffset = y - other.y;
		
		 // Offset Stick Position:
		if(speed != 0){
			repeat(3){
				temerge_sticky_xoffset += hspeed_raw / 3;
				temerge_sticky_yoffset += vspeed_raw / 3;
				if(place_meeting(
					other.x + temerge_sticky_xoffset,
					other.y + temerge_sticky_yoffset,
					other
				)){
					break;
				}
			}
			x = other.x + temerge_sticky_xoffset + hspeed_raw;
			y = other.y + temerge_sticky_yoffset + vspeed_raw;
		}
		if(instance_is(other, hitme)){
			var _offsetScale = 1 - (1 / (1 + max(0, other.size)));
			temerge_sticky_xoffset *= _offsetScale;
			temerge_sticky_yoffset *= _offsetScale;
		}
		
		 // Reduce Speed:
		if(speed > friction * 10){
			speed = max(friction * 10, speed * 0.6);
		}
		
		 // Appear Above or Below:
		depth = other.depth + choose(-1, 1);
		
		 // Sound:
		sound_play_hit(sndGrenadeStickWall, 0.1);
		
		 // Object-Specific:
		switch(object_index){
			
			case Rocket:
			case Nuke:
			
				 // Stop Thrusting:
				if(instance_is(other, Wall) || instance_is(other, prop)){
					active = false;
					alarm1 = -1;
				}
				
				break;
				
			case UltraBolt:
			
				 // Stop Damaging:
				canhurt = false;
				
				break;
				
			case Laser:
			case EnemyLaser:
			
				 // Stop Growing:
				alarm0 = -1;
				
				break;
				
		}
		
		 // Follow Target:
		temerge_sticky_effect_post_step(self);
	}
	
	
#define temerge_pulling_effect_setup(_instanceList)
	/*
		Merged projectile enemy pulling effect
	*/
	
	with(instances_matching(_instanceList, "temerge_pulling_can_play_sound", null)){
		temerge_pulling_can_play_sound = true;
	}
	
#define temerge_pulling_effect_step(_instanceList)
	/*
		Merged pulling projectiles attract nearby enemies towards them
	*/
	
	var _pullingInstanceList = instances_matching_ne([enemy, Player, Ally, Sapling, SentryGun, CustomHitme], "team", 0);
	
	if(array_length(_pullingInstanceList)){
		var _pullingRadius = 96;
		with(_instanceList){
			var	_pullingStrength           = power(2, 1 - (speed / 16)) * lerp(damage / 20, 1, 1/15),
				_pullingRadiusInstanceList = call(scr.instances_in_rectangle, x - _pullingRadius, y - _pullingRadius, x + _pullingRadius, y + _pullingRadius, _pullingInstanceList);
				
			if(array_length(_pullingRadiusInstanceList)){
				with(_pullingRadiusInstanceList){
					if(point_distance(x, y, other.x, other.y) < _pullingRadius){
						var	_pullingDis = _pullingStrength * (instance_is(self, Player) ? 0.5 : 1),
							_pullingDir = point_direction(x, y, other.x, other.y),
							_pullingX   = x + lengthdir_x(_pullingDis, _pullingDir),
							_pullingY   = y + lengthdir_y(_pullingDis, _pullingDir);
							
						if(place_free(_pullingX, y)) x = _pullingX;
						if(place_free(x, _pullingY)) y = _pullingY;
					}
				}
			}
			
			 // Sound:
			if(temerge_pulling_can_play_sound && speed < 4){
				temerge_pulling_can_play_sound = false;
				sound_play_hit(sndUltraGrenadeSuck, 0.2);
			}
			
			 // Effects:
			if(chance_ct(_pullingStrength, 4)){
				var	_len = random(_pullingRadius / 2),
					_dir = random(360);
					
				with(instance_create(x + lengthdir_x(_len, _dir), y + lengthdir_y(_len, _dir), EatRad)){
					motion_add(_dir + 180, random(4));
					hspeed      += other.hspeed / 2;
					vspeed      += other.vspeed / 2;
					image_speed *= random_range(0.5, 1);
					depth        = -8;
					if(chance(1, 4)){
						sprite_index = sprEatBigRad;
					}
				}
			}
		}
	}
	
	
#define temerge_rocket_effect_setup // instanceList, maxSpeedFactor=2, addSpeed=1, hitExplosionCount=1
	/*
		Merged projectile thruster & impact explosion effect
	*/
	
	var	_instanceList      = argument[0],
		_maxSpeedFactor    = ((argument_count > 1) ? argument[1] : 2),
		_addSpeed          = ((argument_count > 2) ? argument[2] : 1),
		_hitExplosionCount = ((argument_count > 3) ? argument[3] : 1);
		
	if("temerge_rocket_frame" not in GameCont){
		GameCont.temerge_rocket_frame = 0;
	}
	
	with(_instanceList){
		if("temerge_rocket_frame" not in self){
			temerge_rocket_frame               = GameCont.temerge_rocket_frame + (5 * (1 - ((friction * 10) / speed)));
			temerge_rocket_is_active           = false;
			temerge_rocket_sound               = -1;
			temerge_rocket_max_speed           = speed;
			temerge_rocket_max_speed_factor    = 1;
			temerge_rocket_add_speed           = 0;
			temerge_rocket_hit_explosion_count = 0;
			temerge_rocket_flame_sprite        = ((damage > 20) ? sprNukeFlame : sprRocketFlame);
			temerge_rocket_flame_xscale        = 0;
			temerge_rocket_flame_yscale        = 0;
			temerge_rocket_flame_offset_length = 0;
			
			 // Projectile Events:
			projectile_add_temerge_event(self, "hit",  script_ref_create(temerge_rocket_projectile_hit));
			projectile_add_temerge_event(self, "wall", script_ref_create(temerge_rocket_projectile_wall));
		}
		temerge_rocket_max_speed_factor    *= _maxSpeedFactor
		temerge_rocket_add_speed           += _addSpeed;
		temerge_rocket_hit_explosion_count += _hitExplosionCount;
		
		 // Max Acceleration Speed:
		image_angle -= direction;
		var _maxSpeed = 16 + bbox_width;
		image_angle += direction;
		if(temerge_rocket_max_speed < _maxSpeed){
			temerge_rocket_max_speed = min(temerge_rocket_max_speed * temerge_rocket_max_speed_factor, _maxSpeed);
		}
	}
	
#define temerge_rocket_effect_step(_instanceList)
	/*
		Merged rocket projectiles accelerate over time and leave behind a smoke trail
	*/
	
	GameCont.temerge_rocket_frame += current_time_scale;
	
	 // Activate Rocket Thrusters:
	var _activateInstanceList = instances_matching_le(instances_matching(_instanceList, "temerge_rocket_is_active", false), "temerge_rocket_frame", GameCont.temerge_rocket_frame);
	if(array_length(_activateInstanceList)){
		with(_activateInstanceList){
			temerge_rocket_is_active = true;
			
			 // Effects:
			view_shake_at(x, y, 2);
			temerge_rocket_sound = sound_play_hit(sndRocketFly, 0.2);
			projectile_add_temerge_event(self, "destroy", script_ref_create(temerge_rocket_sound_projectile_destroy));
		}
	}
	
	 // Rocket Thrusting:
	var _activeInstanceList = instances_matching(_instanceList, "temerge_rocket_is_active", true);
	if(array_length(_activeInstanceList)){
		var	_spriteIndex             = -1,
			_spriteOffsetLength      = 0,
			_flameSpriteIndex        = -1,
			_flameSpriteOffsetLength = 0;
			
		with(_activeInstanceList){
			 // Store Thruster Flame Information:
			if(_spriteIndex != sprite_index){
				_spriteIndex        = sprite_index;
				_spriteOffsetLength = sprite_get_bbox_left(_spriteIndex) - sprite_get_xoffset(_spriteIndex);
			}
			if(_flameSpriteIndex != temerge_rocket_flame_sprite){
				_flameSpriteIndex        = temerge_rocket_flame_sprite;
				_flameSpriteOffsetLength = sprite_get_xoffset(_flameSpriteIndex) - sprite_get_bbox_right(_flameSpriteIndex);
			}
			temerge_rocket_flame_xscale        = min(speed / 12, 2) * image_xscale;
			temerge_rocket_flame_yscale        = min(speed / 6,  1) * image_yscale;
			temerge_rocket_flame_offset_length = ((_spriteOffsetLength * image_xscale) + (_flameSpriteOffsetLength * temerge_rocket_flame_xscale)) / 2;
			
			 // Smoke:
			if(speed != 0 && chance_ct(10 + damage, 100)){
				with(instance_create(
					x + lengthdir_x(temerge_rocket_flame_offset_length, direction) - hspeed_raw,
					y + lengthdir_y(temerge_rocket_flame_offset_length, direction) - vspeed_raw,
					Smoke
				)){
					depth = other.depth + choose(-1, -2);
				}
			}
			
			 // Accelerate:
			if(speed < temerge_rocket_max_speed){
				speed = min(speed + (temerge_rocket_add_speed * current_time_scale), temerge_rocket_max_speed);
			}
			
			 // Update Max Acceleration Speed:
			else if(speed > temerge_rocket_max_speed){
				image_angle -= direction;
				var _maxSpeed = 16 + bbox_width;
				image_angle += direction;
				if(temerge_rocket_max_speed < _maxSpeed){
					temerge_rocket_max_speed = min(temerge_rocket_max_speed * temerge_rocket_max_speed_factor, _maxSpeed);
				}
			}
		}
	}
	
#define temerge_rocket_effect_draw(_instanceList)
	/*
		Merged rocket projectiles have a visual thruster flame
	*/
	
	var _flameInstanceList = instances_matching(instances_matching(_instanceList, "temerge_rocket_is_active", true), "visible", true);
	
	if(array_length(_flameInstanceList)){
		var _flameImageIndex = 0.4 * GameCont.temerge_rocket_frame;
		
		for(var _bloom = 0; _bloom <= (instance_exists(SubTopCont) ? 1 : 0); _bloom++){
			var	_flameScaleFactor = 1,
				_flameAlphaFactor = 1;
				
			if(_bloom == 1){
				_flameScaleFactor = 2;
				_flameAlphaFactor = 0.1;
				draw_set_blend_mode(bm_add);
			}
			
			with(_flameInstanceList){
				draw_sprite_ext(
					temerge_rocket_flame_sprite,
					_flameImageIndex + id,
					x + lengthdir_x(temerge_rocket_flame_offset_length, direction),
					y + lengthdir_y(temerge_rocket_flame_offset_length, direction),
					temerge_rocket_flame_xscale * _flameScaleFactor,
					temerge_rocket_flame_yscale * _flameScaleFactor,
					direction,
					image_blend,
					image_alpha * _flameAlphaFactor
				);
			}
			
			if(_bloom == 1){
				draw_set_blend_mode(bm_normal);
			}
		}
	}
	
#define temerge_rocket_projectile_hit
	/*
		Merged rocket projectiles stop thrusting and activate their explosive payload on impact with a hittable
	*/
	
	if(projectile_can_temerge_hit(other)){
		 // Activate Explosion:
		if(temerge_rocket_hit_explosion_count > 0){
			temerge_rocket_hit_explosion_count--;
			projectile_add_temerge_effect(self, "explosion");
			temerge_explosion_projectile_destroy();
			with(temerge_explosion_list){
				is_active = false;
			}
		}
		
		 // Stop Thrusting:
		if(temerge_rocket_hit_explosion_count <= 0){
			temerge_rocket_projectile_wall();
		}
	}
	
#define temerge_rocket_projectile_wall
	/*
		Merged rocket projectiles stop thrusting on impact with a wall
	*/
	
	 // Kill Thruster:
	if(temerge_rocket_is_active){
		 // Stop Sound:
		audio_stop_sound(temerge_rocket_sound);
		
		 // Particle:
		if(visible){
			var _len = temerge_rocket_flame_offset_length - (10 * temerge_rocket_flame_xscale);
			with(instance_create(
				x + lengthdir_x(_len, direction),
				y + lengthdir_y(_len, direction),
				BulletHit
			)){
				sprite_index = ((other.temerge_rocket_flame_sprite == sprNukeFlame) ? sprHeavyBulletHit : sprBulletHit);
				image_xscale = other.temerge_rocket_flame_yscale;
				image_yscale = other.temerge_rocket_flame_yscale;
			}
		}
	}
	
	 // Stop Thrusting:
	temerge_rocket_is_active = -1;
	
#define temerge_rocket_sound_projectile_destroy
	/*
		Merged rocket projectiles stop their thrusting sound on destruction
	*/
	
	audio_stop_sound(temerge_rocket_sound);
	
	
#define temerge_guiding_effect_setup(_instanceList, _playerIndex)
	/*
		Merged projectile mouse guiding effect
	*/
	
	with(_instanceList){
		temerge_guiding_index = _playerIndex;
	}
	
#define temerge_guiding_effect_step(_instanceList)
	/*
		Merged guiding projectiles turn towards their creator's mouse
	*/
	
	for(var _playerIndex = 0; _playerIndex < maxp; _playerIndex++){
		if(player_is_active(_playerIndex)){
			var _guidingInstanceList = instances_matching_ne(instances_matching(instances_matching(_instanceList, "temerge_guiding_index", _playerIndex), "temerge_rocket_is_active", true, null), "speed", 0);
			if(array_length(_guidingInstanceList)){
				var	_playerMouseX = mouse_x[_playerIndex],
					_playerMouseY = mouse_y[_playerIndex];
					
				with(_guidingInstanceList){
					var	_turn           = angle_difference(point_direction(x, y, _playerMouseX, _playerMouseY), direction),
						_turnFactor     = abs(dsin(_turn)) / 12,
						_turnMoveFactor = -power(_turnFactor * 4, 24 / speed);
						
					_turn       *= _turnFactor * current_time_scale;
					direction   += _turn;
					image_angle += _turn;
					x           += hspeed_raw * _turnMoveFactor;
					y           += vspeed_raw * _turnMoveFactor;
				}
			}
		}
	}
	
	
#define temerge_laser_effect_setup(_instanceList, _maxDistance)
	/*
		Merged projectile laser beam hitscan effect
	*/
	
	var	_instanceIndex     = 0,
		_instanceCount     = array_length(_instanceList),
		_instanceTeam      = undefined,
		_enemyInstanceList = [];
		
	with(_instanceList){
		var	_moveDistance    = 0,
			_moveMaxDistance = _maxDistance * (1 - (_instanceIndex / _instanceCount)),
			_moveAddDistance = max(4, speed),
			_moveAddXFactor  =  dcos(direction),
			_moveAddYFactor  = -dsin(direction),
			_moveStartX      = x,
			_moveStartY      = y,
			_meetingEnemy    = false;
			
		 // Store Enemy List:
		if(_instanceTeam != team){
			_instanceTeam      = team;
			_enemyInstanceList = instances_matching_ne(hitme, "team", _instanceTeam);
		}
		
		 // Move Ahead to the First Enemy or Wall:
		while(_moveDistance < _moveMaxDistance){
			_moveDistance = min(_moveDistance + _moveAddDistance, _moveMaxDistance);
			x             = _moveStartX + (_moveAddXFactor * _moveDistance);
			y             = _moveStartY + (_moveAddYFactor * _moveDistance);
			
			 // Enemy Collision:
			if(array_length(_enemyInstanceList) && place_meeting(x, y, hitme)){
				var _metEnemyInstanceList = call(scr.instances_meeting_instance, self, _enemyInstanceList);
				if(array_length(_metEnemyInstanceList)){
					with(_metEnemyInstanceList){
						if(place_meeting(x, y, other)){
							_meetingEnemy = true;
							break;
						}
					}
					if(_meetingEnemy){
						_moveDistance -= _moveAddDistance;
						break;
					}
				}
			}
			
			 // Wall Collision:
			if(place_meeting(x, y, Wall)){
				_moveDistance -= _moveAddDistance;
				break;
			}
			
			 // Particles:
			if(chance(1, 12 * _instanceCount)){
				with(call(scr.fx,
					x,
					y,
					[direction, _moveAddDistance * lerp(0.5, 0.2, _moveDistance / _moveMaxDistance)],
					Dust
				)){
					sprite_index = spr.AllyLaserCharge;
					image_index  = random(image_number);
					image_xscale = 1;
					image_yscale = image_xscale;
				}
			}
		}
		if(!_meetingEnemy){
			_moveDistance -= random(_maxDistance / max(2, _instanceCount));
		}
		
		 // Set Position:
		x = _moveStartX;
		y = _moveStartY;
		if(_moveDistance > 0){
			x        += _moveAddXFactor * _moveDistance;
			y        += _moveAddYFactor * _moveDistance;
			xprevious = x;
			yprevious = y;
		}
		
		 // Particle:
		if(chance(3, _instanceCount)){
			with(call(scr.fx, [x, 12], [y, 12], 1, PlasmaTrail)){
				motion_add(other.direction, 1);
			}
		}
		
		_instanceIndex++;
	}
	
	
#define temerge_plasma_effect_setup // instanceList, extraAmount=0
	/*
		Merged projectile plasma destruction explosion effect
	*/
	
	var	_instanceList = argument[0],
		_extraAmount  = ((argument_count > 1) ? argument[1] : 0);
		
	with(_instanceList){
		if("temerge_plasma" not in self){
			temerge_plasma = { "extra_amount": 0 };
			projectile_add_temerge_event(self, "destroy", script_ref_create(temerge_plasma_projectile_destroy));
		}
		else{
			temerge_plasma.extra_amount++;
		}
		temerge_plasma.extra_amount += _extraAmount;
	}
	
#define temerge_plasma_effect_step(_instanceList)
	/*
		Merged plasma projectiles have a visual plasma trail
	*/
	
	var _trailInstanceList = instances_matching_gt(_instanceList, "speed", 0);
	
	if(array_length(_trailInstanceList)){
		with(_trailInstanceList){
			if(chance(speed_raw * power(damage, 1/2), 128)){
				instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), PlasmaTrail);
			}
		}
	}
	
#define temerge_plasma_projectile_destroy
	/*
		Merged plasma projectiles create plasma explosions on destruction
	*/
	
	if((object_index != Lightning && object_index != EnemyLightning) || (ammo % 4) < 1){
		var	_explosionX        = x,
			_explosionY        = y,
			_explosionMoveAng  = random(360),
			_explosionMoveTurn = 20 * choose(-1, 1),
			_explosionCount    = abs(damage / 15) + temerge_plasma.extra_amount;
			
		if(_explosionCount > 1){
			 // Get Out of Walls:
			if(position_meeting(_explosionX, _explosionY, Wall)){
				with(call(scr.instance_nearest_bbox, x, y, Floor)){
					_explosionMoveAng  = point_direction(other.x, other.y, bbox_center_x, bbox_center_y);
					_explosionMoveTurn = 0;
				}
			}
			
			 // Move Towards Nearest Enemy:
			else with(call(scr.instance_nearest_array, x, y, instances_matching_ne(hitme, "team", team, 0))){
				if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
					_explosionMoveAng   = point_direction(other.x, other.y, x, y);
					_explosionMoveTurn *= 0.5;
				}
			}
		}
		
		 // Plasma Explosion:
		for(var _explosionIndex = 0; _explosionIndex < _explosionCount; _explosionIndex++){
			with(instance_create(_explosionX, _explosionY, CustomObject)){
				scale   = lerp(0.5, 1, min(_explosionCount - _explosionIndex, 1));
				time    = sqrt(_explosionIndex) * 3;
				team    = other.team;
				creator = other.creator;
				on_step = script_ref_create(temerge_plasma_delayed_explosion_step);
				with(self){
					event_perform(ev_step, ev_step_normal);
				}
			}
			
			 // Offset Explosion Position:
			for(var _explosionMoveIndex = 0; _explosionMoveIndex < 2; _explosionMoveIndex++){
				var	_explosionMoveLen = lerp(8, 16, min(_explosionCount - (_explosionIndex + _explosionMoveIndex), 1)),
					_explosionMoveX   = lengthdir_x(_explosionMoveLen, _explosionMoveAng),
					_explosionMoveY   = lengthdir_y(_explosionMoveLen, _explosionMoveAng);
					
				 // Bounce Off Walls:
				if(!position_meeting(_explosionX + _explosionMoveX, _explosionY + _explosionMoveY, Floor)){
					if(position_meeting(_explosionX, _explosionY, Floor)){
						if(!position_meeting(_explosionX + _explosionMoveX, _explosionY, Floor)){
							_explosionMoveX *= -1;
						}
						else if(!position_meeting(_explosionX, _explosionY + _explosionMoveY, Floor)){
							_explosionMoveY *= -1;
						}
						else{
							_explosionMoveX *= -1;
							_explosionMoveY *= -1;
						}
					}
				}
				_explosionMoveAng = point_direction(0, 0, _explosionMoveX, _explosionMoveY);
				
				 // Move Ahead:
				_explosionX       += _explosionMoveX;
				_explosionY       += _explosionMoveY;
				_explosionMoveAng += _explosionMoveTurn + orandom(60);
			}
			_explosionMoveTurn += orandom(30);
		}
		
		 // Break Walls:
		if(_explosionCount > 2){
			instance_create(x, y, PortalClear);
		}
		
		 // Sound:
		sound_play_hit_big(
			(
				(_explosionCount > 2)
				? (projectile_has_temerge_effect(self, "plasma_trail") ? sndDevastatorExplo : sndPlasmaBigExplode)
				: sndPlasmaHit
			),
			0.3
		);
	}
	
#define temerge_plasma_delayed_explosion_step
	/*
		Creates a plasma explosion after an amount of time
	*/
	
	if(time > 0){
		time -= current_time_scale;
	}
	else{
		with(call(scr.projectile_create, x, y, PlasmaImpact)){
			image_xscale = other.scale;
			image_yscale = other.scale;
		}
		instance_destroy();
	}
	
	
#define temerge_plasma_trail_effect_setup(_instanceList)
	/*
		Merged projectile plasma explosion trail effect
	*/
	
	with(_instanceList){
		if("temerge_plasma_trail_scale" not in self){
			temerge_plasma_trail_scale  = 1/28;
			temerge_plasma_trail_amount = 0;
			projectile_add_temerge_event(self, "hit", script_ref_create(temerge_plasma_trail_projectile_hit));
		}
		else{
			temerge_plasma_trail_scale *= 2;
		}
		temerge_plasma_trail_amount++;
	}
	
#define temerge_plasma_trail_effect_step(_instanceList)
	/*
		Merged plasma trail projectiles create plasma explosions as they travel
	*/
	
	with(_instanceList){
		var _explosionAmount = abs(damage) * temerge_plasma_trail_scale;
		if(chance_ct(_explosionAmount, 1)){
			var	_explosionScale     = lerp(0.5, 1, min(abs(_explosionAmount), 1)),
				_explosionOffsetLen = random(16),
				_explosionOffsetDir = random(360);
				
			with(instance_create(
				x + lengthdir_x(_explosionOffsetLen, _explosionOffsetDir),
				y + lengthdir_y(_explosionOffsetLen, _explosionOffsetDir),
				CustomObject
			)){
				scale   = _explosionScale;
				time    = 0;
				team    = other.team;
				creator = other.creator;
				on_step = script_ref_create(temerge_plasma_delayed_explosion_step);
				
				 // Extra Offset:
				if(_explosionAmount > 1 && _explosionOffsetLen > 0){
					mask_index = mskPlasma;
					move_contact_solid(_explosionOffsetDir, _explosionOffsetLen * (_explosionAmount - 1));
				}
				
				 // Extra Delayed Explosions:
				for(var _explosionIndex = 1; _explosionIndex < other.temerge_plasma_trail_amount; _explosionIndex++){
					with(instance_copy(false)){
						x    += orandom(2);
						y    += orandom(2);
						time += 15 * (_explosionIndex + random(1));
						with(self){
							event_perform(ev_step, ev_step_normal);
						}
					}
				}
				
				 // Call Step Event:
				with(self){
					event_perform(ev_step, ev_step_normal);
				}
			}
		}
	}
	
#define temerge_plasma_trail_projectile_hit
	/*
		Merged plasma trail projectiles create plasma explosions on impact with a hittable
	*/
	
	if(projectile_can_temerge_hit(other) && current_frame_active){
		var _explosionScale = lerp(0.5, 1, min(abs(damage) * temerge_plasma_trail_scale, 1));
		for(var _explosionIndex = 0; _explosionIndex < temerge_plasma_trail_amount; _explosionIndex++){
			with(instance_create(
				random_range(other.bbox_left, other.bbox_right  + 1),
				random_range(other.bbox_top,  other.bbox_bottom + 1),
				CustomObject
			)){
				scale   = _explosionScale;
				time    = 15 * _explosionIndex;
				team    = other.team;
				creator = other.creator;
				on_step = script_ref_create(temerge_plasma_delayed_explosion_step);
				with(self){
					event_perform(ev_step, ev_step_normal);
				}
			}
		}
	}
	
	
#define temerge_lightning_trail_effect_setup(_instanceList)
	/*
		Merged projectile lightning trail effect
	*/
	
	with(_instanceList){
		if(!projectile_has_temerge_effect(self, "lightning_trail")){
			projectile_add_temerge_event(self, "hit", script_ref_create(temerge_lightning_trail_projectile_hit));
		}
	}
	
#define temerge_lightning_trail_effect_step(_instanceList)
	/*
		Merged lightning trail projectiles leave behind a trail of lightning rails
	*/
	
	with(_instanceList){
		if(chance_ct(1, 4)){
			with(call(scr.projectile_create, x, y, Lightning, random(360))){
				ammo = min(irandom(other.damage), 27);
				event_perform(ev_alarm, 0);
				
				 // Spawn Effect:
				visible = false;
				with(instance_create(x, y, LightningSpawn)){
					image_angle = other.image_angle;
				}
			}
		}
	}
	
#define temerge_lightning_trail_projectile_hit
	/*
		Merged lightning trail projectiles create lightning rails on impact with a hittable
	*/
	
	if(projectile_can_temerge_hit(other) && current_frame_active){
		with(call(scr.projectile_create, x, y, Lightning, point_direction(x, y, other.x, other.y) + orandom(45))){
			ammo = min(3 + irandom(other.damage), 27);
			event_perform(ev_alarm, 0);
			
			 // Spawn Effect:
			visible = false;
			with(instance_create(x, y, LightningSpawn)){
				image_angle = other.image_angle;
			}
		}
	}
	
	
#define temerge_blood_trail_effect_setup(_instanceList)
	/*
		Merged projectile blood explosion trail effect
	*/
	
	with(_instanceList){
		if(!projectile_has_temerge_effect(self, "blood_trail")){
			projectile_add_temerge_event(self, "hit", script_ref_create(temerge_blood_trail_projectile_hit));
		}
	}
	
#define temerge_blood_trail_effect_step(_instanceList)
	/*
		Merged blood trail projectiles leave behind a trail of blood explosions
	*/
	
	with(_instanceList){
		if(chance_ct(damage + (force >= 3), 270)){
			call(scr.projectile_create, x + orandom(5), y + orandom(5), MeatExplosion);
		}
	}
	
#define temerge_blood_trail_projectile_hit
	/*
		Merged blood trail projectiles create blood explosions on impact with a hittable
	*/
	
	if(projectile_canhit_melee(other) && current_frame_active){
		call(scr.projectile_create, x + orandom(5), y + orandom(5), MeatExplosion);
	}
	
	
/// MERGED PROJECTILES
#define projectile_add_temerge_event(_instanceList, _eventName, _eventRef)
	/*
		Adds the given merged event to the given projectile instance(s)
	*/
	
	var	_eventRefVarName     = `on_${_eventName}`,
		_eventRefListVarName = `temerge_${_eventName}_event_ref_list`;
		
	with(_instanceList){
		var _eventRefList = variable_instance_get(self, _eventRefListVarName);
		
		 // Setup Event Script Reference List:
		if(_eventRefList == undefined || !array_length(_eventRefList)){
			_eventRefList = [];
			variable_instance_set(self, _eventRefListVarName, _eventRefList);
			
			 // Custom Object (Wrap Existing Event):
			if(
				ds_map_exists(global.object_event_index_list_map, object_index)
				&& array_find_index(global.object_event_index_list_map[? object_index], array_find_index(global.event_varname_list, _eventRefVarName)) >= 0
			){
				var _lastEventRef = variable_instance_get(self, _eventRefVarName);
				if(_lastEventRef == undefined){
					var _defaultScriptIndex = script_get_index(`CustomProjectile_${_eventName}`);
					_lastEventRef = ((_defaultScriptIndex < 0) ? [] : script_ref_create(_defaultScriptIndex));
				}
				variable_instance_set(self, _eventRefVarName, script_ref_create(temerge_event_wrap_event, _eventName, _lastEventRef));
			}
			
			 // Non-Custom Object:
			else projectile_add_temerge_effect(self, _eventName + "_event");
		}
		
		 // Update Destroy Event Variables:
		else if(_eventName == "destroy" && "temerge_destroy_event_vars" in self){
			var _destroyEventVars = call(scr.variable_instance_get_list, self);
			for(var _destroyEventVarIndex = lq_size(_destroyEventVars) - 1; _destroyEventVarIndex >= 0; _destroyEventVarIndex--){
				lq_set(temerge_destroy_event_vars, lq_get_key(_destroyEventVars, _destroyEventVarIndex), lq_get_value(_destroyEventVars, _destroyEventVarIndex));
			}
		}
		
		 // Store Event Script Reference:
		array_push(_eventRefList, _eventRef);
	}
	
#define temerge_event_wrap_event(_eventName, _eventRef)
	/*
		Used as a wrapper script for merged projectile events
	*/
	
	var	_isSolid             = false,
		_isMeeting           = false,
		_context             = [self, other],
		_eventRefVarName     = `on_${_eventName}`,
		_eventRefListVarName = `temerge_${_eventName}_event_ref_list`,
		_eventRefList        = variable_instance_get(self, _eventRefListVarName),
		_lastEventRef        = variable_instance_get(self, _eventRefVarName);
		
	 // Set Event Reference:
	variable_instance_set(self, _eventRefVarName, _eventRef);
	
	 // Event-Specific:
	switch(_eventName){
		
		case "hit":
		case "wall":
		
			 // Check if Colliding:
			_isSolid   = (solid || other.solid);
			_isMeeting = (
				_isSolid
				? place_meeting(x + hspeed_raw, y + vspeed_raw, other)
				: place_meeting(x,              y,              other)
			);
			
			break;
			
	}
	
	 // Untag Team:
	if("temerge_event_last_team" not in self || temerge_event_last_team == undefined){
		temerge_event_last_team = team;
		team = round(team);
	}
	
	 // Call Custom Scripts:
	with(_eventRefList){
		if(call(scr.pass, _context, self)){
			 // Remove Script From Event:
			_eventRefList = call(scr.array_delete_value, _eventRefList, self);
			if(instance_exists(other)){
				variable_instance_set(other, _eventRefListVarName, _eventRefList);
			}
			else exit;
		}
		else if(!instance_exists(other)){
			exit;
		}
		
		 // Stopped Colliding:
		if(_isMeeting){
			if(instance_exists(_context[1])){
				with(other){
					_isMeeting = (
						_isSolid
						? place_meeting(x + hspeed_raw, y + vspeed_raw, _context[1])
						: place_meeting(x,              y,              _context[1])
					);
				}
				if(!_isMeeting){
					_isMeeting = -1;
					break;
				}
			}
			else{
				_isMeeting = -1;
				break;
			}
		}
	}
	
	 // Retag Team:
	if(team == temerge_event_last_team){
		team = temerge_event_last_team;
	}
	temerge_event_last_team = undefined;
	
	 // Call Normal Script:
	if(_isMeeting != -1 && array_length(_eventRef) >= 3){
		call(scr.pass, _context, _eventRef);
		if(!instance_exists(self)){
			exit;
		}
	}
	
	 // Revert Event Reference:
	if(array_length(_eventRefList)){
		var _scriptRef = variable_instance_get(self, _eventRefVarName);
		if(_scriptRef != _eventRef){
			if(array_length(_scriptRef) >= 3){
				_lastEventRef[@ array_find_index(_lastEventRef, _eventRef)] = _scriptRef;
			}
			else _lastEventRef = _scriptRef;
		}
		variable_instance_set(self, _eventRefVarName, _lastEventRef);
	}
	
#define projectile_add_temerge_effect // instance, effectName, ?effectSetupArgList
	/*
		Adds the given merge effect to the given projectile
		Future duplicates of the instance created by 'instance_copy' also get the effect
	*/
	
	var	_instance           = argument[0],
		_effectName         = argument[1],
		_effectSetupArgList = ((argument_count > 2) ? argument[2] : undefined);
		
	if("temerge_effect_vars_map" not in GameCont){
		GameCont.temerge_effect_vars_map = {};
	}
	
	var _effectVars = lq_get(GameCont.temerge_effect_vars_map, _effectName);
	
	 // Setup Effect Variables:
	if(_effectVars == undefined){
		_effectVars = {
			"instance_list"      : [],
			"event_instance_map" : {}
		};
		lq_set(GameCont.temerge_effect_vars_map, _effectName, _effectVars);
	}
	
	 // Activate Effect Events:
	if(ds_map_exists(global.temerge_effect_event_script_list_table, _effectName)){
		var _effectEventInstanceMap = _effectVars.event_instance_map;
		with(ds_map_keys(global.temerge_effect_event_script_list_table[? _effectName])){
			var _effectEventName = self;
			switch(_effectEventName){
				
				case "setup":
				
					 // Call Setup Event:
					var _effectLastInstanceList = _effectVars.instance_list;
					_effectVars.instance_list = (is_array(_instance) ? _instance : [_instance]);
					temerge_effect_call_event(_effectName, _effectEventName, _effectSetupArgList);
					_instance = _effectVars.instance_list;
					_effectVars.instance_list = _effectLastInstanceList;
					
					break;
					
				default:
				
					 // Create Event Instance:
					var _effectEventInstance = lq_defget(_effectEventInstanceMap, _effectEventName, noone);
					if(!instance_exists(_effectEventInstance)){
						var _effectEventObject = CustomScript;
						switch(_effectEventName){
							case "step"       : _effectEventObject = CustomObject;    break;
							case "post_step"  : _effectEventObject = CustomStep;      break;
							case "begin_step" : _effectEventObject = CustomBeginStep; break;
							case "end_step"   : _effectEventObject = CustomEndStep;   break;
							case "draw"       : _effectEventObject = CustomDraw;      break;
						}
						with(instance_create(0, 0, _effectEventObject)){
							lq_set(_effectEventInstanceMap, _effectEventName, self);
							
							 // Set Event's Script:
							var _scriptRef = script_ref_create(temerge_effect_call_event, _effectName, _effectEventName, undefined);
							switch(_effectEventObject){
								case CustomObject : on_step = _scriptRef; break;
								default           : script  = _scriptRef;
							}
							
							 // Event-Specific:
							switch(_effectEventObject){
								
								case CustomStep:
								case CustomObject:
								
									 // Run Step Events on Frame of Creation:
									if("temerge_effect_call_step_instance_list" not in GameCont){
										GameCont.temerge_effect_call_step_instance_list = [];
									}
									array_push(GameCont.temerge_effect_call_step_instance_list, self);
									GameCont.temerge_effect_call_step_frame = current_frame;
									
									break;
									
								case CustomDraw:
								
									 // Set Draw Event's Initial Depth:
									var _effectEventInstanceDepth = infinity;
									with(_instance){
										if(depth - 1 < _effectEventInstanceDepth){
											_effectEventInstanceDepth = depth - 1;
										}
									}
									depth = _effectEventInstanceDepth;
									
									break;
									
							}
						}
					}
					
			}
		}
	}
	
	 // Prune Instance List:
	_effectVars.instance_list = instances_matching_ne(_effectVars.instance_list, "id");
	
	 // Add Instance to Effect:
	with(_instance){
		 // Bind 'instance_copy' Instance Capturing Script:
		var _effectObjectSetupBindVarName = `bind_setup_temerge_${_effectName}_${object_get_name(object_index)}`;
		if(lq_get(ntte, _effectObjectSetupBindVarName) == undefined){
			lq_set(ntte, _effectObjectSetupBindVarName, call(scr.ntte_bind_setup, script_ref_create(temerge_effect_object_setup, _effectName, object_index), object_index));
		}
		
		 // Add to Instance List:
		if(array_find_index(_effectVars.instance_list, self) < 0){
			array_push(_effectVars.instance_list, self);
			
			 // Instance Capturing Identifier:
			var _effectInstanceVarName = `temerge_${_effectName}_instance`;
			if(_effectInstanceVarName not in self){
				variable_instance_set(self, _effectInstanceVarName, self);
			}
			
			 // Destroy Event:
			if(_effectName == "destroy_event" && "temerge_destroy_event_vars" not in self){
				 // Setup Variables List:
				if("destroy_event_vars_list" not in _effectVars){
					_effectVars.destroy_event_vars_list     = [];
					_effectVars.destroy_event_instance_list = [];
				}
				
				 // Store Variables:
				temerge_destroy_event_vars = call(scr.variable_instance_get_list, self);
				array_push(_effectVars.destroy_event_vars_list,     temerge_destroy_event_vars);
				array_push(_effectVars.destroy_event_instance_list, self);
			}
		}
	}
	
#define projectile_has_temerge_effect(_instance, _effectName)
	/*
		Returns whether the given instance has the given merge effect
	*/
	
	if("temerge_effect_vars_map" in GameCont){
		var _effectVars = lq_get(GameCont.temerge_effect_vars_map, _effectName);
		if(_effectVars != undefined && array_find_index(_effectVars.instance_list, _instance) >= 0){
			return true;
		}
	}
	
	return false;
	
#define projectile_add_temerge_scale // instanceList, addXScale, addYScale=addXScale
	/*
		Adds to the given merged projectile's scale, with manual visual fixes for certain projectiles
		
		Args:
			addXScale - The number to add to the instance's image_xscale
			addYScale - The number to add to the instance's image_yscale, defaults to addXScale
	*/
	
	var	_instanceList = argument[0],
		_addXScale    = argument[1],
		_addYScale    = ((argument_count > 2) ? argument[2] : _addXScale);
		
	with(_instanceList){
		image_xscale += _addXScale * ((image_xscale < 0) ? -1 : 1);
		image_yscale += _addYScale * ((image_yscale < 0) ? -1 : 1);
		
		 // Manual Visual Fixes:
		switch(object_index){
			
			case Rocket:
			case Nuke:
			case ConfettiBall:
			
				projectile_add_temerge_effect(self, "fixed_scale");
				
				break;
				
			case Lightning:
			case EnemyLightning:
			
				temerge_fixed_lightning_yscale = image_yscale;
				projectile_add_temerge_effect(self, "fixed_lightning_yscale");
				
				break;
				
		}
	}
	
#define projectile_add_temerge_bloom(_instanceList, _bloomAmount)
	/*
		Adds to the given merged projectile's bloom
	*/
	
	with(_instanceList){
		image_alpha += _bloomAmount * sign(image_alpha);
	}
	
#define projectile_add_temerge_damage(_instanceList, _damageFactor)
	/*
		Adds to the given merged projectile's damage
	*/
	
	with(_instanceList){
		damage += round(damage * _damageFactor);
	}
	
#define projectile_add_temerge_force(_instanceList, _forceAmount)
	/*
		Adds to the given merged projectile's push force
	*/
	
	with(_instanceList){
		force += _forceAmount * sign(force);
	}
	
#define projectile_can_temerge_hit(_hitInstance)
	/*
		Returns whether the current merged projectile instance can vaguely hit the given hittable instance
	*/
	
	return (
		projectile_canhit(_hitInstance)
		&& _hitInstance.my_health > 0
		&& ("canhurt" not in self || canhurt) // Bolts
	);
	
#define projectile_temerge_wall_bounce()
	/*
		Called from a merged projectile in its wall collision event to make it bounce
	*/
	
	switch(object_index){
		
		case Laser:
		case EnemyLaser:
		
			 // Laser Bounce:
			with(instance_copy(false)){
				 // Restore Starting Values:
				xstart       = x;
				ystart       = y;
				image_xscale = 1;
				
				 // Bounce Direction:
				var	_addX = lengthdir_x(2, image_angle),
					_addY = lengthdir_y(2, image_angle);
					
				if(place_meeting(x + _addX, y, Wall)){
					_addX *= -1;
				}
				else if(place_meeting(x, y + _addY, Wall)){
					_addY *= -1;
				}
				else{
					_addX *= -1;
					_addY *= -1;
				}
				image_angle = point_direction(0, 0, _addX, _addY);
				direction   = image_angle;
				
				 // Rerun Hitscan:
				event_perform(ev_alarm, 0);
			}
			
			break;
			
		default:
		
			 // Normal Bounce:
			if(speed != 0){
				var _lastDirection = direction;
				move_bounce_solid(true);
				if(image_angle == _lastDirection){
					image_angle = direction;
				}
				
				 // Fun:
				if(instance_is(self, HyperGrenade)){
					alarm0 = 1;
					alarm1 = -1;
				}
			}
			
	}
	
#define projectile_temerge_destroy(_instance)
	/*
		Used as a replacement for 'instance_destroy' in merged projectile events,
		so projectiles created by destroying merged projectiles are also merged
	*/
	
	with(_instance){
		 // Retag Team:
		if(team == temerge_event_last_team){
			team = temerge_event_last_team;
		}
		temerge_event_last_team = undefined;
		
		 // Destroy Instance:
		instance_destroy();
	}
	
	
#define HeavyBullet_temerge_setup(_instanceList)
	 // Heavy:
	projectile_add_temerge_scale(_instanceList, 0.1);
	
	 // Hits Like a Fist:
	projectile_add_temerge_damage(_instanceList, 2/3);
	projectile_add_temerge_force(_instanceList, 2);
	
	
#define UltraBullet_temerge_setup(_instanceList)
	 // Big & Bright:
	projectile_add_temerge_scale(_instanceList, 0.2);
	projectile_add_temerge_bloom(_instanceList, 0.2);
	
	 // Hits Like a Brick:
	projectile_add_temerge_damage(_instanceList, 1.5);
	projectile_add_temerge_force(_instanceList, 4);
	
	
#define BouncerBullet_temerge_wall
	 // Bounce:
	projectile_temerge_wall_bounce();
	
	 // Effects:
	instance_create(x, y, Dust);
	sound_play_hit(sndBouncerBounce, 0.2);
	
	 // Disable Event:
	return true;
	
	
#define FlameShell_temerge_setup(_instanceList)
	 // Releases a Flame:
	projectile_add_temerge_effect(_instanceList, "flame");
	
	
#define UltraShell_temerge_setup(_instanceList)
	 // Long & Bright:
	with(_instanceList){
		if((sprite_get_bbox_bottom(sprite_index) + 1) - sprite_get_bbox_top(sprite_index) <= (sprite_get_bbox_right(sprite_index) + 1) - sprite_get_bbox_left(sprite_index)){
			projectile_add_temerge_scale(self, 0.1, 0);
		}
		else{
			projectile_add_temerge_scale(self, 0, 0.1);
		}
	}
	projectile_add_temerge_bloom(_instanceList, 0.2);
	
	 // Floaty:
	with(instances_matching_gt(_instanceList, "friction", 0)){
		friction *= 2/3;
	}
	
	 // Hits Like a Dart:
	projectile_add_temerge_damage(_instanceList, 1);
	projectile_add_temerge_force(_instanceList, 2);
	
	
#define Slug_temerge_setup(_instanceList)
	 // Fat:
	projectile_add_temerge_scale(_instanceList, 0.25);
	
	 // Hits Like a Big Fist:
	projectile_add_temerge_effect(_instanceList, "slug", [1]);
	projectile_add_temerge_force(_instanceList, 4);
	
	
#define HeavySlug_temerge_setup(_instanceList)
	 // Obese:
	projectile_add_temerge_scale(_instanceList, 0.4);
	
	 // Hits Like a Truck:
	projectile_add_temerge_effect(_instanceList, "slug", [2]);
	projectile_add_temerge_force(_instanceList, 8);
	
	
#define HyperSlug_temerge_setup(_instanceList)
	 // Hyper:
	projectile_add_temerge_effect(_instanceList, "hyper");
	
	 // Slug:
	Slug_temerge_setup(_instanceList);
	
	
#define FlakBullet_temerge_destroy
	var _num = min(abs(damage / 2) + (force >= 3), 640);
	
	 // Nerf Lightning:
	switch(object_index){
		case Lightning:
		case EnemyLightning:
			_num -= ammo;
	}
	
	 // Explode Into Shrapnel:
	_num = floor(_num) + chance(frac(_num), 1);
	if(_num > 0){
		repeat(_num){
			call(scr.projectile_create, x, y, Bullet2, random(360), random_range(8, 16));
		}
		
		 // Sound:
		call(scr.sound_play_at,
			x,
			y,
			sndFlakExplode,
			max(0.6, 1.2 - (0.0125 * _num)) + orandom(0.1),
			0.2 + (0.05 * _num),
			320
		);
		
		 // Effects:
		repeat(ceil(_num / 3)){
			call(scr.fx, x, y, random(3), Smoke);
		}
		with(instance_create(x, y, BulletHit)){
			sprite_index = sprFlakHit;
		}
		view_shake_at(x, y, _num / 2);
		sleep(_num / 1.5);
	}
	
	
#define SuperFlakBullet_temerge_setup(_instanceList)
	 // Big:
	projectile_add_temerge_scale(_instanceList, 0.2);
	
#define SuperFlakBullet_temerge_destroy
	var _num = min(power(max(0, abs(damage) - 1.95), 0.45) + (0.25 * (force >= 3)), 40);
	
	 // Nerf Lightning:
	switch(object_index){
		case Lightning:
		case EnemyLightning:
			_num -= ammo * 1.5;
	}
	
	 // Explode Into Flak Shrapnel:
	_num = floor(_num) + chance(frac(_num), 1);
	if(_num > 0){
		var _ang = random(360);
		if(position_meeting(x + lengthdir_x(16, _ang), y + lengthdir_y(16, _ang), Wall)){
			_ang += 180;
		}
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			call(scr.projectile_create, x, y, FlakBullet, _dir, 12);
		}
		
		 // Sound:
		call(scr.sound_play_at,
			x,
			y,
			sndSuperFlakExplode,
			max(0.6, 1.2 - (0.04 * _num)) + orandom(0.1),
			0.2 + (0.16 * _num),
			320
		);
		
		 // Effects:
		repeat(floor(_num * 2.5)){
			call(scr.fx, x, y, random(3), Smoke);
		}
		with(instance_create(x, y, BulletHit)){
			sprite_index = sprSuperFlakHit;
		}
		view_shake_at(x, y, _num * 2.5);
		sleep(_num * 4);
	}
	
	 // Normal Shrapnel:
	else{
		var _addDamage = 2 * (force >= 3);
		damage += _addDamage;
		FlakBullet_temerge_destroy();
		damage -= _addDamage;
	}
	
	
#define Bolt_temerge_fire(_at)
	 // Accurate:
	_at.accuracy *= 0.5;
	
#define Bolt_temerge_setup(_instanceList)
	 // Pierces Weaker Enemies:
	projectile_add_temerge_effect(_instanceList, "piercing", [0.5]);
	
	 // Has a Cool Trail:
	projectile_add_temerge_effect(_instanceList, "trail");
	
	
#define HeavyBolt_temerge_fire(_at)
	 // Bolt:
	Bolt_temerge_fire(_at);
	
#define HeavyBolt_temerge_setup(_instanceList)
	 // Fat:
	projectile_add_temerge_scale(_instanceList, 0.25);
	
	 // Hits Like a Log:
	projectile_add_temerge_damage(_instanceList, 1);
	projectile_add_temerge_force(_instanceList, 2);
	
	 // Bolt:
	Bolt_temerge_setup(_instanceList);
	
	
#define ToxicBolt_temerge_fire(_at)
	 // Bolt:
	Bolt_temerge_fire(_at);
	
#define ToxicBolt_temerge_setup(_instanceList)
	 // Toxic:
	projectile_add_temerge_effect(_instanceList, "toxic");
	with(_instanceList){
		image_blend = merge_color(image_blend, make_color_rgb(131, 253, 8), 0.5);
	}
	
	 // Bolt:
	Bolt_temerge_setup(_instanceList);
	
	
#define UltraBolt_temerge_fire(_at)
	 // Bolt:
	Bolt_temerge_fire(_at);
	
#define UltraBolt_temerge_setup(_instanceList)
	 // Brighter:
	projectile_add_temerge_bloom(_instanceList, 0.2);
	
	 // Pierces Walls:
	with(_instanceList){
		projectile_add_temerge_effect(self, "wall_piercing", [damage / 6]);
	}
	
	 // Bolt:
	Bolt_temerge_setup(_instanceList);
	
	
#define Splinter_temerge_setup(_instanceList)
	 // Small:
	projectile_add_temerge_scale(_instanceList, -0.05);
	
	
#define Seeker_temerge_setup(_instanceList)
	 // Small:
	projectile_add_temerge_scale(_instanceList, -0.05);
	
	 // Has a Cool Trail:
	projectile_add_temerge_effect(_instanceList, "trail");
	
	 // Seeks Enemies:
	projectile_add_temerge_effect(_instanceList, "seeking");
	
	
#define Disc_temerge_setup(_instanceList)
	with(_instanceList){
		 // Setup Variables:
		if("temerge_disc_wall_bounce_frame" not in self){
			temerge_disc_wall_bounce_frame = current_frame;
			temerge_disc_friction          = 0;
			temerge_disc_is_ally           = true;
		}
		
		 // Bounces:
		temerge_disc_wall_bounce_frame = max(current_frame, temerge_disc_wall_bounce_frame) + 30;
		
		 // No Friction:
		if(friction != 0){
			temerge_disc_friction = friction;
			if(speed > friction * 10){
				speed = max(friction * 10, speed - (3 * friction));
			}
			friction = 0;
		}
	}
	
#define Disc_temerge_wall
	 // Become Hostile:
	if(
		temerge_disc_is_ally
		&& (
			!instance_exists(creator)
			|| distance_to_object(creator) > 16
			|| point_distance(xstart, ystart, creator.x, creator.y) > 16
		)
	){
		temerge_disc_is_ally = false;
		team = -1;
		
		 // Resprite:
		var _hitName = call(scr.instance_get_name, self);
		call(scr.team_instance_sprite, 1, self);
		if(hitid == -1){
			hitid = [((sprite_index == sprEnemyLaser) ? sprEnemyLaserStart : sprite_index), _hitName];
		}
	}
	
	 // Bounce:
	if(temerge_disc_wall_bounce_frame > current_frame){
		var _isLaser = (object_index == Laser || object_index == EnemyLaser);
		
		 // Hitscan Projectiles Bounce Once:
		if(_isLaser || instance_is(self, HyperGrenade)){
			temerge_disc_wall_bounce_frame -= 30;
		}
		
		 // Bounce:
		projectile_temerge_wall_bounce();
		
		 // Lasers Bounce Once:
		if(_isLaser){
			temerge_disc_wall_bounce_frame = current_frame;
		}
		
		 // Effects:
		sound_play_hit(sndDiscBounce, 0.2);
		with(instance_create(x, y, DiscBounce)){
			image_angle = other.image_angle;
		}
	}
	
	 // Done:
	else{
		 // Restore Friction:
		if(temerge_disc_friction != 0){
			if(friction == 0){
				friction = temerge_disc_friction;
			}
			temerge_disc_friction = 0;
		}
		
		 // Effects:
		sound_play_hit(sndDiscDie, 0.2);
		instance_create(x, y, DiscDisappear);
		
		 // Disable Event:
		return false;
	}
	
	
#define Grenade_temerge_fire(_at, _setupInfo)
	var	_moveSpeed    = speed,
		_moveFriction = friction,
		_moveSteps    = floor(_moveSpeed / _moveFriction),
		_moveDistance = 0,
		_explodeSteps = alarm0,
		_airSteps     = alarm1;
		
	 // Determine Travel Distance:
	if(_explodeSteps > 0 && _explodeSteps < _moveSteps){
		_moveSteps = _explodeSteps;
	}
	if(_airSteps > 0 && _airSteps < _moveSteps && !instance_is(self, BloodBall)){
		_moveDistance += _airSteps * (_moveSpeed - (_moveFriction * ((_airSteps + 1) / 2)));
		_moveSpeed    -= _moveFriction * _airSteps;
		_moveFriction  = (instance_is(self, BloodGrenade) ? 0.5 : 0.4);
		_moveSteps     = floor(_moveSpeed / _moveFriction);
		if(_explodeSteps > 0 && _explodeSteps < _moveSteps){
			_moveSteps = _explodeSteps;
		}
	}
	_moveDistance += _moveSteps * (_moveSpeed - (_moveFriction * ((floor(_moveSpeed / _moveFriction) + 1) / 2)));
	
	 // Store Explosion Info:
	_setupInfo.max_range   = _moveDistance;
	_setupInfo.is_sticky   = sticky;
	_setupInfo.is_ultra    = instance_is(self, UltraGrenade);
	_setupInfo.is_cannon   = instance_is(self, BloodBall);
	_setupInfo.is_confetti = instance_is(self, ConfettiBall);
	_setupInfo.explosion   = {
		"is_small"   : instance_is(self, MiniNade),
		"is_heavy"   : (_setupInfo.is_ultra || instance_is(self, HeavyNade)),
		"is_blood"   : (instance_is(self, BloodGrenade) || instance_is(self, BloodBall)),
		"is_toxic"   : instance_is(self, ToxicGrenade),
		"is_cluster" : instance_is(self, ClusterNade)
	};
	
#define Grenade_temerge_setup(_instanceList, _info)
	if(!_info.is_confetti){
		var _explosion = _info.explosion;
		
		 // Explosion on a Timer:
		projectile_add_temerge_effect(_instanceList, "grenade", [_info.max_range, _explosion]);
		
		 // Small:
		if(_explosion.is_small){
			projectile_add_temerge_scale(_instanceList, -0.05);
		}
		
		 // Big:
		if(_explosion.is_heavy){
			projectile_add_temerge_scale(_instanceList, 0.1);
		}
		
		 // Bloody:
		if(_explosion.is_blood){
			with(_instanceList){
				if(!place_meeting(x, y, BloodStreak) || chance(1, 3)){
					var _streakAngleOffset = 15 * ceil(((((sprite_get_bbox_bottom(sprite_index) + 1) - sprite_get_bbox_top(sprite_index)) * image_yscale) / 16) - 1);
					for(var _streakAngleSide = -1; _streakAngleSide <= 1; _streakAngleSide++){
						var _streakAngle = ((direction == 0 && speed == 0) ? ((image_angle == 0) ? random(360) : image_angle) : direction);
						with(instance_create(xstart + hspeed, ystart + vspeed, BloodStreak)){
							image_angle = _streakAngle + (_streakAngleOffset * _streakAngleSide);
						}
						if(_streakAngleOffset == 0){
							break;
						}
					}
				}
			}
		}
		
		 // Cannon:
		if(_info.is_cannon){
			 // Big:
			projectile_add_temerge_scale(_instanceList, 0.1);
			projectile_add_temerge_damage(_instanceList, 0.5);
			
			 // Has Less Friction:
			with(_instanceList){
				friction /= 2;
			}
			
			 // Spews Blood Explosions:
			if(_explosion.is_blood){
				projectile_add_temerge_effect(_instanceList, "blood_trail");
			}
		}
		
		 // Sticky:
		if(_info.is_sticky){
			projectile_add_temerge_effect(_instanceList, "sticky");
			
			 // Bigger Explosion:
			if(!_explosion.is_toxic){
				projectile_add_temerge_effect(_instanceList, "explosion", [_explosion, 2]);
			}
			
			 // Longer Delay:
			with(_instanceList){
				projectile_add_temerge_effect(self, "grenade", [_info.max_range + (20 * speed)]);
				
				 // Green:
				image_blend = merge_color(image_blend, make_color_rgb(131, 253, 8), 0.5);
			}
		}
		
		 // Ultra:
		if(_info.is_ultra){
			projectile_add_temerge_effect(_instanceList, "pulling");
			
			 // Brighter:
			projectile_add_temerge_bloom(_instanceList, 0.2);
			
			 // Longer Delay:
			with(_instanceList){
				projectile_add_temerge_effect(self, "grenade", [_info.max_range + (10 * speed)]);
			}
		}
	}
	
	
#define HyperGrenade_temerge_fire(_at)
	 // No Speed Multiplier:
	if(alarm0 > 0){
		_at.speed_factor = 1;
	}
	
#define HyperGrenade_temerge_setup(_instanceList)
	 // Hyper:
	projectile_add_temerge_effect(_instanceList, "hyper");
	
	 // Grenade:
	projectile_add_temerge_effect(_instanceList, "grenade", [160, {}]);
	
	
#define Flare_temerge_setup(_instanceList)
	 // Spews Flames:
	projectile_add_temerge_effect(_instanceList, "flame_trail");
	
	
#define FlameBall_temerge_setup(_instanceList)
	 // Big:
	projectile_add_temerge_scale(_instanceList, 0.1);
	projectile_add_temerge_damage(_instanceList, 0.5);
	
	 // Has Less Friction:
	with(_instanceList){
		friction /= 3;
	}
	
	 // Spews Flames:
	projectile_add_temerge_effect(_instanceList, "flame_trail", [2]);
	
	
#define Rocket_temerge_setup(_instanceList)
	 // Delivers a Payload:
	projectile_add_temerge_effect(_instanceList, "rocket");
	
	
#define Nuke_temerge_fire(_at, _setupInfo)
	 // Store Creator's Player Index:
	_setupInfo.player_index = (
		("index" in _at.creator)
		? _at.creator.index
		: -1
	);
	
#define Nuke_temerge_setup(_instanceList, _info)
	 // Delivers a Big Payload:
	projectile_add_temerge_effect(_instanceList, "rocket", [1.5, 0.5]);
	projectile_add_temerge_effect(_instanceList, "explosion");
	
	 // Guided by the Mouse:
	projectile_add_temerge_effect(_instanceList, "guiding", [_info.player_index]);
	
	
#define Laser_temerge_fire(_at, _setupInfo)
	 // Narrow:
	_at.accuracy *= 0.2;
	
	 // Store Distance to First Wall in Path:
	var	_dis        = 320,
		_disXFactor =  dcos(image_angle),
		_disYFactor = -dsin(image_angle),
		_startX     = xstart,
		_startY     = ystart,
		_endX       = _startX + (_dis * _disXFactor),
		_endY       = _startY + (_dis * _disYFactor),
		_isWalled   = collision_line(_startX, _startY, _endX, _endY, Wall, false, false);
		
	if(_isWalled){
		while(_dis >= 1){
			_dis /= 2;
			if(_isWalled){
				_endX -= _dis * _disXFactor;
				_endY -= _dis * _disYFactor;
			}
			else{
				_endX += _dis * _disXFactor;
				_endY += _dis * _disYFactor;
			}
			_isWalled = collision_line(_startX, _startY, _endX, _endY, Wall, false, false);
		}
	}
	
	_setupInfo.max_distance = point_distance(_startX, _startY, _endX, _endY);
	
#define Laser_temerge_setup(_instanceList, _info)
	 // Beamular:
	projectile_add_temerge_effect(
		call(scr.array_shuffle, instances_matching_ne(_instanceList, "speed", 0)),
		"laser",
		[_info.max_distance]
	);
	
	
#define Lightning_temerge_setup(_instanceList)
	 // Zappy:
	var _instanceCount = array_length(_instanceList);
	with(_instanceList){
		if(chance(2, _instanceCount)){
			with(call(scr.fx, x, y, 0.5, PlasmaTrail)){
				sprite_index = sprLightning;
				image_xscale = random(3);
				image_yscale = random(1);
				image_angle  = other.direction + orandom(30);
				motion_add(other.direction, 0.5);
			}
		}
	}
	
	
#define LightningBall_temerge_setup(_instanceList)
	 // Big:
	projectile_add_temerge_scale(_instanceList, 0.1);
	projectile_add_temerge_damage(_instanceList, 0.5);
	
	 // Has Less Friction:
	with(_instanceList){
		friction /= 3;
	}
	
	 // Spews Lightning:
	projectile_add_temerge_effect(_instanceList, "lightning_trail");
	
	
#define PlasmaBall_temerge_setup(_instanceList)
	 // Has Less Friction:
	with(_instanceList){
		friction /= 3;
	}
	
	 // Explodes Into Plasma:
	projectile_add_temerge_effect(_instanceList, "plasma");
	
	
#define PlasmaBig_temerge_setup(_instanceList)
	 // Big:
	projectile_add_temerge_scale(_instanceList, 0.2);
	projectile_add_temerge_bloom(_instanceList, 1/3);
	projectile_add_temerge_damage(_instanceList, 2.5);
	projectile_add_temerge_force(_instanceList, 4);
	
	 // Plasma:
	PlasmaBall_temerge_setup(_instanceList);
	
	
#define PlasmaHuge_temerge_setup(_instanceList)
	 // Huge:
	projectile_add_temerge_scale(_instanceList, 0.4);
	projectile_add_temerge_bloom(_instanceList, 2/3);
	projectile_add_temerge_damage(_instanceList, 5.5);
	projectile_add_temerge_force(_instanceList, 4);
	
	 // Plasma:
	PlasmaBall_temerge_setup(_instanceList);
	
#define PlasmaHuge_temerge_destroy
	 // Break Walls:
	instance_create(x, y, PortalClear);
	
	 // Release Plasma Balls:
	var	_ballCount = ceil(damage / 13);
	if(_ballCount > 0){
		var _ballAngle = random(360);
		for(var _ballDirection = _ballAngle; _ballDirection < _ballAngle + 360; _ballDirection += (360 / _ballCount)){
			call(scr.projectile_create, x, y, PlasmaBall, _ballDirection, 2);
		}
	}
	
	
#define Devastator_temerge_fire(_at)
	 // Apply Laser Brain Effect:
	if(alarm0 > 0 && _at.speed_factor > 0.5){
		_at.speed_factor = lerp(0.5, _at.speed_factor, 0.4);
	}
	
#define Devastator_temerge_setup(_instanceList)
	with(_instanceList){
		 // Stack Effect - Pierces Enemies:
		if(projectile_has_temerge_effect(self, "plasma_trail")){
			projectile_add_temerge_effect(self, "piercing", [2]);
		}
		
		 // Has Less Friction:
		friction /= 3;
	}
	
	 // Spews Plasma:
	projectile_add_temerge_effect(_instanceList, "plasma_trail");
	projectile_add_temerge_effect(_instanceList, "plasma", [1]);
	
	
#define Slash_temerge_fire(_at)
	temerge_can_delete = false;
	projectile_add_temerge_scale(self, -0.25);
	
#define EnergySlash_temerge_fire(_at)
	Slash_temerge_fire(_at);
	
#define EnergyHammerSlash_temerge_fire(_at)
	Slash_temerge_fire(_at);
	
#define LightningSlash_temerge_fire(_at)
	Slash_temerge_fire(_at);
	
#define BloodSlash_temerge_fire(_at)
	Slash_temerge_fire(_at);
	
#define GuitarSlash_temerge_fire(_at)
	Slash_temerge_fire(_at);
	
#define CustomSlash_temerge_fire(_at)
	Slash_temerge_fire(_at);
	
	
#define Shank_temerge_fire(_at)
	temerge_can_delete = false;
	projectile_add_temerge_scale(self, -0.1);
	
#define EnergyShank_temerge_fire(_at)
	Shank_temerge_fire(_at);
	
	
#define ThrownWep_temerge_fire(_at)
	 // Merge Weapon:
	wep                = weapon_add_temerge(wep, _at.wep);
	sprite_index       = weapon_get_sprt(wep);
	temerge_can_delete = false;
	
	
#define ConfettiBall_temerge_hit
	 // Celebrate Death:
	if(
		projectile_can_temerge_hit(other)
		&& other.my_health <= damage
		&& ("temerge_confetti_can_hit" not in other || other.temerge_confetti_can_hit)
	){
		other.temerge_confetti_can_hit = false;
		repeat(30){
			call(scr.fx, x, y, random(14), Confetti);
		}
		sound_play_hit_big(asset_get_index(`sndConfetti${irandom_range(1, 7)}`), 0.2);
	}
	
	
/// OBJECTS
#define HyperSlashTrail_create(_x, _y)
	/*
		A stretched slash trail that follows a slash or shank around and passes collision to its events
	*/
	
	with(instance_create(_x, _y, CustomSlash)){
		 // Vars:
		target      = other;
		sprite_side = 0;
		
		 // Events:
		on_hit        = script_ref_create(HyperSlashTrail_collision, hitme);
		on_wall       = script_ref_create(HyperSlashTrail_collision, Wall);
		on_projectile = script_ref_create(HyperSlashTrail_collision, projectile);
		on_grenade    = script_ref_create(HyperSlashTrail_collision, Grenade);
		
		return self;
	}
	
#define HyperSlashTrail_begin_step
	 // Shrink Towards Target:
	if(image_index > image_speed || image_speed <= 0){
		if(instance_exists(target)){
			var	_targetX     = target.x,
				_targetY     = target.y,
				_targetAngle = target.image_angle;
				
			 // Try to Shrink Along Target's Axis:
			if(_targetAngle != 0){
				var	_dir = _targetAngle + 180,
					_len = 0.5 * (lengthdir_x(xstart - _targetX, _dir) + lengthdir_y(ystart - _targetY, _dir));
					
				_targetX += lengthdir_x(_len, _dir);
				_targetY += lengthdir_y(_len, _dir);
			}
			
			 // Effects:
			if(chance_ct(1, 2)){
				call(scr.fx, [_targetX, 4], [_targetY, 4], [_targetAngle + orandom(15), 4], Dust);
			}
			
			 // Shrink:
			xstart = lerp_ct(xstart, _targetX, 2/3);
			ystart = lerp_ct(ystart, _targetY, 2/3);
			
			 // Shrunk:
			if(point_distance(xstart, ystart, target.x, target.y) < 1){
				instance_destroy();
			}
		}
	}
	
#define HyperSlashTrail_step
	if(instance_exists(target)){
		var	_target         = target,
			_spriteIndex    = _target.sprite_index,
			_spriteCutWidth = 0,
			_maskIndex      = _target.mask_index;
			
		 // Uses Sprite as Mask:
		if(_maskIndex < 0){
			_maskIndex = _spriteIndex;
		}
		
		 // Follow Target:
		x                 = _target.x;
		y                 = _target.y;
		hspeed            = _target.hspeed;
		vspeed            = _target.vspeed;
		friction          = _target.friction;
		gravity           = _target.gravity;
		gravity_direction = _target.gravity_direction;
		image_index       = _target.image_index;
		image_speed       = _target.image_speed;
		image_xscale      = _target.image_xscale;
		image_yscale      = _target.image_yscale;
		image_angle       = point_direction(xstart, ystart, x, y);
		image_blend       = _target.image_blend;
		image_alpha       = _target.image_alpha;
		visible           = _target.visible;
		depth             = _target.depth - 1;
		deflected         = _target.deflected;
		damage            = _target.damage;
		force             = _target.force;
		hitid             = _target.hitid;
		typ               = _target.typ;
		team              = _target.team;
		creator           = _target.creator;
		
		 // Sprite Setup:
		if(sprite_exists(_spriteIndex)){
			var _spriteKey = `${_spriteIndex}:${sprite_side}`;
			if(ds_map_exists(global.hyper_slash_trail_sprite_map, _spriteKey)){
				sprite_index = global.hyper_slash_trail_sprite_map[? _spriteKey];
			}
			else{
				_spriteCutWidth = ceil(lerp(sprite_get_bbox_left(_spriteIndex), sprite_get_bbox_right(_spriteIndex) + 1, 0.5));
				
				var	_spriteImageNumber = sprite_get_number(_spriteIndex),
					_spriteBBoxTop     = sprite_get_bbox_top(_spriteIndex),
					_spriteBBoxHeight  = (sprite_get_bbox_bottom(_spriteIndex) + 1) - _spriteBBoxTop,
					_spriteBBoxCenterY = _spriteBBoxTop + (_spriteBBoxHeight / 2),
					_spriteCutY        = ((sprite_side < 0) ? floor(_spriteBBoxCenterY) : 0),
					_spriteCutHeight   = ((sprite_side > 0) ?  ceil(_spriteBBoxCenterY) : sprite_get_height(_spriteIndex)) - _spriteCutY,
					_spriteSurface     = surface_create(max(1, _spriteCutWidth * _spriteImageNumber), _spriteCutHeight);
					
				 // Draw Sprite:
				surface_set_target(_spriteSurface);
				draw_clear_alpha(c_black, 0);
				for(var _spriteImage = 0; _spriteImage < _spriteImageNumber; _spriteImage++){
					draw_sprite_part(
						_spriteIndex,
						_spriteImage,
						0,
						_spriteCutY,
						_spriteCutWidth,
						_spriteCutHeight,
						_spriteCutWidth * _spriteImage,
						0
					);
				}
				surface_reset_target();
				
				 // Add Sprite:
				surface_save(_spriteSurface, "sprHyperSlashTrail.png");
				surface_destroy(_spriteSurface);
				sprite_index = sprite_add(
					"sprHyperSlashTrail.png",
					_spriteImageNumber,
					_spriteCutWidth,
					sprite_get_yoffset(_spriteIndex) - _spriteCutY
				);
				global.hyper_slash_trail_sprite_map[? _spriteKey] = sprite_index;
			}
		}
		
		 // Mask Setup:
		if(sprite_exists(_maskIndex)){
			if(ds_map_exists(global.hyper_slash_trail_mask_map, _maskIndex)){
				mask_index = global.hyper_slash_trail_mask_map[? _maskIndex];
			}
			else{
				var	_maskHeight        = sprite_get_height(_maskIndex),
					_maskImageNumber   = sprite_get_number(_maskIndex),
					_maskSpriteXOffset = sprite_get_xoffset(_maskIndex) - sprite_get_xoffset(_spriteIndex),
					_maskCutX          = sprite_get_bbox_left(_spriteIndex) + _maskSpriteXOffset,
					_maskCutWidth      = (_spriteCutWidth + _maskSpriteXOffset) - _maskCutX,
					_maskSurface       = surface_create(max(1, _maskCutWidth * _maskImageNumber), _maskHeight);
					
				 // Draw Mask:
				surface_set_target(_maskSurface);
				draw_clear_alpha(c_black, 0);
				for(var _maskImage = 0; _maskImage < _maskImageNumber; _maskImage++){
					draw_sprite_part(
						_maskIndex,
						_maskImage,
						max(0, _maskCutX),
						0,
						max(0, _maskCutWidth + min(0, _maskCutX)),
						_maskHeight,
						_maskCutWidth * _maskImage,
						0
					);
				}
				surface_reset_target();
				
				 // Add Mask:
				surface_save(_maskSurface, "mskHyperSlashTrail.png");
				surface_destroy(_maskSurface);
				mask_index = sprite_add(
					"mskHyperSlashTrail.png",
					_maskImageNumber,
					_maskCutWidth,
					sprite_get_yoffset(_maskIndex)
				);
				global.hyper_slash_trail_mask_map[? _maskIndex] = mask_index;
			}
		}
		
		 // Stretch Backwards:
		var	_offsetLen   = (sprite_get_xoffset(sprite_index) - sprite_get_xoffset(_spriteIndex)) * image_xscale,
			_offsetDir   = _target.image_angle,
			_spriteWidth = sprite_get_width(sprite_index);
			
		image_xscale += (point_distance(x, y, xstart, ystart) * (1 + (sprite_get_bbox_left(sprite_index) / _spriteWidth))) / _spriteWidth;
		x            += lengthdir_x(_offsetLen, _offsetDir);
		y            += lengthdir_y(_offsetLen, _offsetDir);
		xprevious     = x;
		yprevious     = y;
	}
	else instance_destroy();
	
#define HyperSlashTrail_collision(_collisionObject)
	if(instance_exists(self) && instance_exists(target)){
		var	_dir = image_angle,
			_len = clamp(lengthdir_x(other.x - xstart, _dir) + lengthdir_y(other.y - ystart, _dir), 0, point_distance(xstart, ystart, target.x, target.y)),
			_x   = xstart + lengthdir_x(_len, _dir),
			_y   = ystart + lengthdir_y(_len, _dir);
			
		with(other){
			with(other.target){
				var	_lastX         = x,
					_lastY         = y,
					_lastXPrevious = x,
					_lastYPrevious = y;
					
				xprevious += _x - x;
				yprevious += _y - y;
				x          = _x;
				y          = _y;
				
				event_perform(ev_collision, _collisionObject);
				
				if(instance_exists(self)){
					x         = _lastX;
					y         = _lastY;
					xprevious = _lastXPrevious;
					yprevious = _lastYPrevious;
				}
			}
		}
		
		 // Update:
		if(instance_exists(self)){
			HyperSlashTrail_step();
		}
	}
	
	
/// GENERAL
#define ntte_setup_WepPickup(_inst)
	/*
		Adds subtext to merged weapon pickup prompts
	*/
	
	if("temerge_weapon_prompt_subtext_string_map" not in GameCont){
		GameCont.temerge_weapon_prompt_subtext_string_map = {
			"key_list" : [/* wep */],
			"list"     : [/* prompt subtext string */]
		};
	}
	
	var _wepPromptSubtextStringMap = GameCont.temerge_weapon_prompt_subtext_string_map;
	
	with(_inst){
		var _wep = wep;
		if(_wepXhas_merge){
			var _wepIndex = array_find_index(_wepPromptSubtextStringMap.key_list, _wep);
			
			 // Setup Subtext:
			if(_wepIndex < 0){
				var _wepNameList = [];
				
				 // Compile List of Weapon Names:
				do{
					_wepXmerge_is_active = false;
					var _wepName = weapon_get_name(_wep);
					if(_wepName != ""){
						array_push(_wepNameList, _wepName);
					}
					_wepXmerge_is_active = true;
					_wep = _wepXmerge_wep;
				}
				until(!_wepXhas_merge);
				var _wepName = weapon_get_name(_wep);
				if(_wepName != ""){
					array_push(_wepNameList, _wepName);
				}
				
				 // Compile & Store Subtext:
				if(array_length(_wepNameList)){
					_wep      = wep;
					_wepIndex = array_length(_wepPromptSubtextStringMap.key_list);
					
					var _wepPromptSubtext = (
						_wepXmerge_is_part
						? (
							(array_length(_wepNameList) == 1)
							? "WEAPON PART"
							: `WEAPON PARTS / @s${array_join(_wepNameList, " @s+ ")}`
						)
						: array_join(_wepNameList, " + ")
					);
					
					array_push(_wepPromptSubtextStringMap.key_list, _wep);
					array_push(_wepPromptSubtextStringMap.list,     `#@(${call(scr.prompt_subtext_get_sprite, _wepPromptSubtext)})`);
				}
				
				 // No Subtext:
				else continue;
				
				 // Bind PopupText Fix Script:
				if(is_undefined(lq_get(ntte, "bind_setup_temerge_PopupText"))){
					ntte.bind_setup_temerge_PopupText = call(scr.ntte_bind_setup, script_ref_create(ntte_setup_temerge_PopupText), PopupText);
				}
			}
			
			 // Add Subtext:
			name += _wepPromptSubtextStringMap.list[_wepIndex];
		}
	}
	
#define ntte_setup_temerge_PopupText(_inst)
	/*
		Deletes merged weapon prompt subtext from new PopupText instances
	*/
	
	if("temerge_weapon_prompt_subtext_string_map" in GameCont && array_length(GameCont.temerge_weapon_prompt_subtext_string_map.key_list)){
		var _wepPromptSubtextStringMap = GameCont.temerge_weapon_prompt_subtext_string_map;
		
		 // Delete Subtext String From PopupText:
		with(_inst){
			with(_wepPromptSubtextStringMap.list){
				other.text = string_replace(other.text, self, "");
			}
		}
		
		 // Remove Weapon From List:
		with(_wepPromptSubtextStringMap.key_list){
			var _wep = self;
			if(!array_length(instances_matching(WepPickup, "wep", _wep))){
				var _wepIndex = array_find_index(_wepPromptSubtextStringMap.key_list, _wep);
				_wepPromptSubtextStringMap.key_list = call(scr.array_delete, _wepPromptSubtextStringMap.key_list, _wepIndex);
				_wepPromptSubtextStringMap.list     = call(scr.array_delete, _wepPromptSubtextStringMap.list,     _wepIndex);
			}
		}
	}
	
	 // Unbind Script:
	else if(!is_undefined(lq_get(ntte, "bind_setup_temerge_PopupText"))){
		call(scr.ntte_unbind, ntte.bind_setup_temerge_PopupText);
		ntte.bind_setup_temerge_PopupText = undefined;
	}
	
#define ntte_step
	 // Unmuffle Muffled Sounds:
	with(ds_map_keys(global.sound_muffle_map)){
		var	_sound  = self,
			_muffle = global.sound_muffle_map[? _sound];
			
		if(audio_is_playing(_sound)){
			if(!audio_is_playing(_muffle.sound_id)){
				var	_muffleSoundGain = _muffle.sound_gain,
					_soundGain       = lerp(audio_sound_get_gain(_sound), _muffleSoundGain, 0.1);
					
				if(abs(1 - (_soundGain / _muffleSoundGain)) > 0.1){
					audio_sound_gain(_sound, _soundGain, 0);
				}
				else{
					audio_sound_gain(_sound, _muffleSoundGain, 0);
					ds_map_delete(global.sound_muffle_map, _sound);
				}
			}
		}
		else{
			audio_sound_gain(_sound, _muffle.sound_gain, 0);
			ds_map_delete(global.sound_muffle_map, _sound);
		}
	}
	
	 // Reset Projectile Effect Variables Between Levels:
	if(instance_exists(GenCont) || instance_exists(LevCont)){
		if("temerge_effect_vars_map" in GameCont && lq_size(GameCont.temerge_effect_vars_map)){
			GameCont.temerge_effect_vars_map = {};
		}
	}
	
	 // Run Newly Created Effect Step Events:
	if("temerge_effect_call_step_frame" in GameCont && GameCont.temerge_effect_call_step_frame == current_frame){
		with(instances_matching(GameCont.temerge_effect_call_step_instance_list, "object_index", CustomObject)) event_perform(ev_step, ev_step_normal);
		with(instances_matching(GameCont.temerge_effect_call_step_instance_list, "object_index", CustomStep  )) event_perform(ev_step, ev_step_normal);
		GameCont.temerge_effect_call_step_instance_list = [];
	}
	
#define CustomProjectile_hit
	/*
		Default CustomProjectile hitme collision
	*/
	
	if(projectile_canhit(other)){
		projectile_hit(other, damage, force);
		instance_destroy();
	}
	
#define CustomProjectile_wall
	/*
		Default CustomProjectile wall collision
	*/
	
	instance_destroy();
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  scr                                                                                     global.scr
#macro  obj                                                                                     global.obj
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  epsilon                                                                                 global.epsilon
#macro  mod_current_type                                                                        global.mod_type
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  area_campfire                                                                           0
#macro  area_desert                                                                             1
#macro  area_sewers                                                                             2
#macro  area_scrapyards                                                                         3
#macro  area_caves                                                                              4
#macro  area_city                                                                               5
#macro  area_labs                                                                               6
#macro  area_palace                                                                             7
#macro  area_vault                                                                              100
#macro  area_oasis                                                                              101
#macro  area_pizza_sewers                                                                       102
#macro  area_mansion                                                                            103
#macro  area_cursed_caves                                                                       104
#macro  area_jungle                                                                             105
#macro  area_hq                                                                                 106
#macro  area_crib                                                                               107
#macro  infinity                                                                                1/0
#macro  instance_max                                                                            instance_create(0, 0, DramaCamera)
#macro  current_frame_active                                                                    ((current_frame + epsilon) % 1) < current_time_scale
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number) || (image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed == 0) ? spr_idle : spr_walk) : sprite_index
#macro  enemy_boss                                                                              ('boss' in self) ? boss : ('intro' in self || array_find_index([Nothing, Nothing2, BigFish, OasisBoss], object_index) >= 0)
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  target_visible                                                                          !collision_line(x, y, target.x, target.y, Wall, false, false)
#macro  target_direction                                                                        point_direction(x, y, target.x, target.y)
#macro  target_distance                                                                         point_distance(x, y, target.x, target.y)
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#macro  alarm0_run                                                                              alarm0 && !--alarm0 && !--alarm0 && (script_ref_call(on_alrm0) || !instance_exists(self))
#macro  alarm1_run                                                                              alarm1 && !--alarm1 && !--alarm1 && (script_ref_call(on_alrm1) || !instance_exists(self))
#macro  alarm2_run                                                                              alarm2 && !--alarm2 && !--alarm2 && (script_ref_call(on_alrm2) || !instance_exists(self))
#macro  alarm3_run                                                                              alarm3 && !--alarm3 && !--alarm3 && (script_ref_call(on_alrm3) || !instance_exists(self))
#macro  alarm4_run                                                                              alarm4 && !--alarm4 && !--alarm4 && (script_ref_call(on_alrm4) || !instance_exists(self))
#macro  alarm5_run                                                                              alarm5 && !--alarm5 && !--alarm5 && (script_ref_call(on_alrm5) || !instance_exists(self))
#macro  alarm6_run                                                                              alarm6 && !--alarm6 && !--alarm6 && (script_ref_call(on_alrm6) || !instance_exists(self))
#macro  alarm7_run                                                                              alarm7 && !--alarm7 && !--alarm7 && (script_ref_call(on_alrm7) || !instance_exists(self))
#macro  alarm8_run                                                                              alarm8 && !--alarm8 && !--alarm8 && (script_ref_call(on_alrm8) || !instance_exists(self))
#macro  alarm9_run                                                                              alarm9 && !--alarm9 && !--alarm9 && (script_ref_call(on_alrm9) || !instance_exists(self))
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < _numer * current_time_scale;
#define pround(_num, _precision)                                                        return  (_precision == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_precision == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_precision == 0) ? _num :  ceil(_num / _precision) * _precision;
#define frame_active(_interval)                                                         return  ((current_frame + epsilon) % _interval) < current_time_scale;
#define lerp_ct(_val1, _val2, _amount)                                                  return  lerp(_val2, _val1, power(1 - _amount, current_time_scale));
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define angle_lerp_ct(_ang1, _ang2, _num)                                               return  _ang2 + (angle_difference(_ang1, _ang2) * power(1 - _num, current_time_scale));
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_dir, _num)                                                                  direction = _dir; walk = _num; if(speed < friction_raw) speed = friction_raw;
#define enemy_face(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1;
#define enemy_look(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1; if('gunangle' in self) gunangle = _dir;
#define enemy_target(_x, _y)                                                                    target = (instance_exists(Player) ? instance_nearest(_x, _y, Player) : ((instance_exists(target) && target >= 0) ? target : noone)); return (target != noone);
#define script_bind(_scriptObj, _scriptRef, _depth, _visible)                           return  call(scr.script_bind, script_ref_create(script_bind), _scriptObj, (is_real(_scriptRef) ? script_ref_create(_scriptRef) : _scriptRef), _depth, _visible);