#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Setup Objects:
	call(scr.obj_add, script_ref_create(BeetleChest_create));
	call(scr.obj_add, script_ref_create(BeetleChestOpen_create));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define race_name              return "BEETLE";
#define race_text              return "BEETLE CHEST#MERGE WEAPONS";
#define race_lock              return "OPEN THE CHEST";
#define race_unlock            return "FOR OPENING THE CHEST";
#define race_tb_text           return "PARTS OF @wMERGED WEAPONS @sCAN BE REPLACED#BY WEAPONS OF THE SAME @yAMMO TYPE";//"HOLDING MORE WEAPONS INCREASES AMMO";//"MERGING COSTS @gRADS#@sINSTEAD OF @rMAX HP";
#define race_portrait(_p, _b)  return race_sprite_raw("Portrait", _b);
#define race_mapicon(_p, _b)   return race_sprite_raw("Map",      _b);
#define race_avail             return call(scr.unlock_get, "race:" + mod_current);

#define race_ttip
	 // Ultra:
	if(GameCont.level >= 10 && chance(1, 5)){
		return choose(
			"REMEMBER THE GUNS LEFT BEHIND",
			"BOUND BY BLOOD",
			"THERE CAN ONLY BE GUN"
		);
	}
	
	 // Normal:
	return choose(
		"STICK TO YOUR GUNS",
		"LEAVE NO GUN BEHIND",
		"NEVER ENOUGH WEAPONS",
		"HEALTH CHESTS RESTORE LOST @rMAX HP",
		"BEETLE IS ALWAYS HOME",
		"BEETLE ALWAYS HAS COMPANY"
	);
	
#define race_sprite(_sprite)
	var _b = (("bskin" in self && is_real(bskin)) ? bskin : 0);
	
	switch(_sprite){
		case sprMutant1Idle      : return race_sprite_raw("Idle",         _b);
		case sprMutant1Walk      : return race_sprite_raw("Walk",         _b);
		case sprMutant1Hurt      : return race_sprite_raw("Hurt",         _b);
		case sprMutant1Dead      : return race_sprite_raw("Dead",         _b);
		case sprMutant1GoSit     : return race_sprite_raw("GoSit",        _b);
		case sprMutant1Sit       : return race_sprite_raw("Sit",          _b);
		case sprFishMenu         : return race_sprite_raw("Menu",         _b);
		case sprFishMenuSelected : return race_sprite_raw("MenuSelected", _b);
		case sprFishMenuSelect   : return race_sprite_raw("MenuSelect",   _b);
		case sprFishMenuDeselect : return race_sprite_raw("MenuDeselect", _b);
	}
	
	return -1;
	
#define race_sound(_snd)
	var _sndNone = sndFootPlaSand5; // playing a sound that doesn't exist using sound_play_pitch/sound_play_pitchvol modifies sndSwapPistol's pitch/volume
	
	switch(_snd){
		case sndMutant1Wrld : return snd.BeetleWrld;
		case sndMutant1Hurt : return snd.BeetleHurt;
		case sndMutant1Dead : return snd.BeetleDead;
		case sndMutant1LowA : return snd.BeetleLowA;
		case sndMutant1LowH : return snd.BeetleLowH;
		case sndMutant1Chst : return snd.BeetleChst;
		case sndMutant1Valt : return snd.BeetleChst;
		case sndMutant1Crwn : return snd.BeetleCrwn;
		case sndMutant1Spch : return snd.BeetleSpch;
		case sndMutant1IDPD : return snd.BeetleIDPD;
		case sndMutant1Cptn : return snd.BeetleSpch;
		case sndMutant1Thrn : return snd.BeetleLowH;
	}
	
	return -1;
	
#define race_sprite_raw(_sprite, _skin)
	var _skinSpriteMapList = lq_defget(spr.Race, mod_current, []);
	
	if(_skin >= 0 && _skin < array_length(_skinSpriteMapList)){
		return lq_defget(_skinSpriteMapList[_skin], _sprite, -1);
	}
	
	return -1;
	
	
/// Menu
#define race_menu_select
	return snd.BeetleSlct;
	
#define race_menu_confirm
	return snd.BeetleCnfm;
	
#define race_menu_button
	sprite_index = race_sprite_raw("Select", 0);
	image_index = !race_avail();
	
	
/// Skins
#define race_skins
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++){
		_playersActive += player_is_active(i);
	}
	
	 // Normal:
	if(_playersActive <= 1){
		return 2;
	}
	
	 // Co-op Bugginess:
	var _num = 0;
	while(_num == 0 || call(scr.unlock_get, `skin:${mod_current}:${_num}`)){
		_num++;
	}
	return _num;
	
#define race_skin_avail(_skin)
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++){
		_playersActive += player_is_active(i);
	}
	
	 // Normal:
	if(_playersActive <= 1){
		return (_skin == 0 || call(scr.unlock_get, `skin:${mod_current}:${_skin}`));
	}
	
	 // Co-op Bugginess:
	return true;
	
#define race_skin_name(_skin)
	if(race_skin_avail(_skin)){
		return chr(65 + _skin) + " SKIN";
	}
	else{
		return race_skin_lock(_skin);
	}
	
#define race_skin_lock(_skin)
	switch(_skin){
		case 0 : return "EDIT THE SAVE FILE LMAO";
		case 1 : return "HOLD 6 WEAPONS#IN ONE HAND";
	}
	
#define race_skin_unlock(_skin)
	switch(_skin){
		case 1 : return "FOR HOLDING 6 WEAPONS IN ONE HAND";
	}
	
#define race_skin_button(_skin)
	sprite_index = race_sprite_raw("Loadout", _skin);
	image_index  = !race_skin_avail(_skin);
	
	
/// Ultras
#macro ultA 1
#macro ultB 2

#define race_ultra_name(_ultra)
	switch(_ultra){
		case ultA : return "CRITICAL THORAX";
		case ultB : return "AUXILIARY MANDIBLES";
	}
	return "";
	
#define race_ultra_text(_ultra)
	switch(_ultra){
		case ultA : return "THE @yBEETLE CHEST @sOPENS WITH A @wBLAST#@sAND @wAPPEARS @sWHEN NEEDED";
		case ultB : return "@wMERGED WEAPON @sSTOCKS#ARE @rTRIGGER-HAPPY"; //"NEXT @wMERGED WEAPON @sHAS#HALF @yAMMO COST @sAND @wRELOAD";
	}
	return "";
	
#define race_ultra_button(_ultra)
	sprite_index = race_sprite_raw("UltraIcon", 0);
	image_index  = _ultra - 1; // why are ultras 1-based bro
	
#define race_ultra_icon(_ultra)
	return race_sprite_raw("UltraHUD" + chr(64 + _ultra), 0);
	
#define race_ultra_take(_ultra, _state)
	 // Ultra Sound:
	if(_state != 0 && instance_exists(EGSkillIcon)){
		switch(_ultra){
			case ultA : sound_play_gun(snd.BeetleUltraA, 0, 0.3); break;
			case ultB : sound_play_gun(snd.BeetleUltraB, 0, 0.3); break;
		}
	}
	
	 // Effect:
	switch(_ultra){
		case ultA:
			break;
			
		case ultB:
			// with(instances_matching(Player, "race", mod_current)){
			// 	beetle_menu_info.merging_upgrade_count++;
			// }
			break;
	}
	
	
#define race_ntte_guardian_step
	/*
		Popo Guardian pet shields when beetle is merging weapons
	*/
	
	if(beetle_menu_info.is_open && other.dash_charge == 0){
		with(other){
			var _shieldInstanceList = instances_matching(obj.PetGuardianShield, "creator", self);
			if(
				!array_length(_shieldInstanceList)
				&& !array_length(instances_matching(CrystalShieldDisappear, "creator", self))
			){
				with(call(scr.obj_create, x, y, "PetGuardianShield")){
					team    = other.team;
					creator = other;
					array_push(_shieldInstanceList, self);
				}
			}
			with(_shieldInstanceList){
				alarm0 = max(alarm0, 3);
				with(other){
					follow_delay = max(follow_delay, other.alarm0 + 10);
				}
			}
		}
	}
	
	
#define race_swep
	return "beetle pistol";
	
	
#define create
	 // Random lets you play locked characters: (Can remove once 9941+ gets stable build)
	if(!race_avail()){
		race = "fish";
		player_set_race(index, race);
		exit;
	}
	
	 // Sound:
	snd_wrld = race_sound(sndMutant1Wrld);
	snd_hurt = race_sound(sndMutant1Hurt);
	snd_dead = race_sound(sndMutant1Dead);
	snd_lowa = race_sound(sndMutant1LowA);
	snd_lowh = race_sound(sndMutant1LowH);
	snd_chst = race_sound(sndMutant1Chst);
	snd_valt = race_sound(sndMutant1Valt);
	snd_crwn = race_sound(sndMutant1Crwn);
	snd_spch = race_sound(sndMutant1Spch);
	snd_idpd = race_sound(sndMutant1IDPD);
	snd_cptn = race_sound(sndMutant1Cptn);
	snd_thrn = race_sound(sndMutant1Thrn);
	footkind = 4; // Metal
	
	 // Character-Specific Vars:
	if("beetle_last_usespec" not in self){
		beetle_last_usespec = 0;
	}
	if("beetle_menu_info" not in self){
		beetle_menu_info = {
			"is_open"                    : false,
			"scale"                      : 0,
			"last_wkick"                 : undefined,
			"last_bwkick"                : undefined,
			"last_canfire"               : undefined,
			"last_canscope"              : undefined,
			"revert_last_info_step_bind" : noone,
			"wep"                        : wep_none,
			"bwep"                       : wep_none,
			"curse"                      : 0,
			"bcurse"                     : 0,
			"selection_wep_info"         : beetle_menu_selection_wep_default_info,
			"selection_angle"            : 0,
			"selection_state"            : undefined,
			"selection_trail_last_x"     : x,
			"selection_trail_last_y"     : y,
			"selection_icon_scale"       : 0,
			"merging_wep_info"           : beetle_menu_merging_wep_default_info,
			"merging_scale"              : 0,
		//	"merging_upgrade_count"      : 0,
			"merging_part_num"           : 0
		};
	}
	// if("beetle_tb_info" not in self){
	// 	beetle_tb_info = {
	// 		"value"        : 0,
	// 		"wep_count"    : 0,
	// 		"wep"          : wep_none,
	// 		"bwep"         : wep_none,
	// 		"race"         : mod_current,
	// 		"muscle_value" : skill_get(mut_back_muscle)
	// 	};
	// }
	
	 // Re-Get Ultras When Revived:
	/*for(var i = 0; i < ultra_count(mod_current); i++){
		if(ultra_get(mod_current, i)){
			race_ultra_take(i, true);
		}
	}*/
	
#macro beetle_menu_merging_wep_default_info
	/*
		The default value of the beetle menu's merging weapon info
	*/
	
	{
		"index_list"    : [],
		"key_list"      : [],
		"type_key_list" : [],
		"health_cost"   : 0,
		"name"          : "",
		"type"          : type_melee,
		"cost"          : 0,
		"load"          : 0,
		"sprite"        : mskNone,
	}
	
#macro beetle_menu_selection_wep_default_info
	/*
		The default value of the beetle menu's selection weapon info
	*/
	
	{
		"list"          : [],
		"index"         : 0,
		"primary_count" : 0
	}
	
#define step
	if(lag) trace_time();
	
	var	_menu           = beetle_menu_info,
		_menuWasOpen    = _menu.is_open,
		_specIsPressed  = button_pressed(index, "spec"),
		_specIsReleased = button_released(index, "spec");
		
	 // Custom Active Support:
	if((usespec > 0) != (beetle_last_usespec > 0)){
		if(usespec > 0){
			_specIsPressed = true;
		}
		else{
			_specIsReleased = true;
		}
	}
	beetle_last_usespec = usespec;
	
	 // Open Weapon Merging Menu:
	if(_specIsPressed && !_menu.is_open && canspec && player_active){
		_menu.is_open         = !_menu.is_open;
		_menu.selection_angle = gunangle;
	}
	
	 // Weapon Merging Menu:
	if(_menu.is_open || _menu.scale != 0){
		 // Setup Variable Reverting Controller:
		if(!instance_exists(_menu.revert_last_info_step_bind)){
			with(script_bind_step(beetle_menu_revert_last_info_step, 0, _menu, self)){
				persistent = true;
				_menu.revert_last_info_step_bind = self;
			}
		}
		
		 // Setup Merged Weapon Parts:
		if(
			wep    != _menu.wep   ||
			bwep   != _menu.bwep  ||
			curse  != _menu.curse ||
			bcurse != _menu.bcurse
		){
			_menu.wep    = wep;
			_menu.bwep   = bwep;
			_menu.curse  = curse;
			_menu.bcurse = bcurse;
			
			 // Deselect Previous Weapon Parts:
			_menu.selection_wep_info = beetle_menu_selection_wep_default_info;
			_menu.merging_wep_info   = beetle_menu_merging_wep_default_info;
			
			 // Add Weapon Parts to List:
			for(var _wepIndex = 0; _wepIndex <= 1; _wepIndex++){
				var _wep = ((_wepIndex == 0) ? wep : bwep);
				while(true){
					if(call(scr.wep_raw, _wep) != wep_none){
						array_push(_menu.selection_wep_info.list, _wep);
						if(_wepIndex == 0){
							_menu.selection_wep_info.primary_count++;
						}
					}
					if(
						call(scr.weapon_has_temerge, _wep)
						&& ((_wepIndex == 0) ? (curse <= 0) : (bcurse <= 0))
					){
						_wep = call(scr.weapon_get_temerge_weapon, _wep);
					}
					else break;
				}
			}
		}
		
		 // Opened Menu:
		if(_menu.is_open){
			var	_menuSelectionWep         = _menu.selection_wep_info,
				_menuMergingWep           = _menu.merging_wep_info,
				_menuSelectionWepList     = _menuSelectionWep.list,
				_menuSelectionWepListSize = array_length(_menuSelectionWepList);
				
			 // Weapon Selection:
			if(_menuSelectionWepListSize > 0){
				_menuSelectionWep.index = round(_menuSelectionWepListSize * (1 + ((gunangle - _menu.selection_angle) / 360))) % _menuSelectionWepListSize;
				
				 // Toggle Current Weapon's Selection:
				if(button_check(index, "fire") && _menu.scale > 0.75){
					call(scr.motion_step, self, 1);
					
					var	_menuSelectionTrailX        = x + lengthdir_x(10, gunangle),
						_menuSelectionTrailY        = y + lengthdir_y(10, gunangle),
						_menuSelectionWepIsSelected = (array_find_index(_menuMergingWep.index_list, _menuSelectionWep.index) >= 0),
						_menuSelectedWep            = _menuSelectionWepList[_menuSelectionWep.index];
						
					call(scr.motion_step, self, -1);
					
					 // Store Selection State:
					if(_menu.selection_state == undefined){
						_menu.selection_state = !_menuSelectionWepIsSelected;
					}
					
					 // Selection Hand Trail:
					else with(instance_create(_menuSelectionTrailX, _menuSelectionTrailY, BoltTrail)){
						image_angle  = point_direction(x, y, _menu.selection_trail_last_x, _menu.selection_trail_last_y);
						image_xscale = point_distance(x, y, _menu.selection_trail_last_x, _menu.selection_trail_last_y);
						image_yscale = 1.5 + (0.5 * dsin((other.wave / 8) * 360));
						image_blend  = c_black;
						depth        = other.depth + 1;
					}
					_menu.selection_trail_last_x = _menuSelectionTrailX;
					_menu.selection_trail_last_y = _menuSelectionTrailY;
					
					 // Toggle Selection:
					if(_menu.selection_state != _menuSelectionWepIsSelected && _menuSelectedWep != wep_none){
						if(_menu.selection_state){
							array_push(_menuMergingWep.index_list, _menuSelectionWep.index);
						}
						else{
							_menuMergingWep.index_list = call(scr.array_delete_value, _menuMergingWep.index_list, _menuSelectionWep.index);
						}
						
						 // Effects:
						var _menuSelectionEffectScale = array_length(_menuMergingWep.index_list) / _menuSelectionWepListSize;
						with(call(scr.fx, _menuSelectionTrailX, _menuSelectionTrailY, [gunangle, 1], BulletHit)){
							image_xscale = lerp(1/3, 2/3, _menuSelectionEffectScale);
							image_yscale = image_xscale;
							image_blend  = c_black;
							depth        = other.depth + 1;
							hspeed      += other.hspeed * 2/3;
							vspeed      += other.vspeed * 2/3;
							friction     = 0.1;
						}
						
						 // Sound:
						if(_menu.selection_state){
							var	_menuSelectionWepSwap     = sndSwapPistol,
								_menuSelectedWepIsPrimary = (_menuSelectionWep.index < _menuSelectionWep.primary_count);
								
							 // Fetch Swap Sound:
							if(
								call(scr.weapon_has_temerge, _menuSelectedWep)
								&& (_menuSelectedWepIsPrimary ? (curse <= 0) : (bcurse <= 0))
							){
								call(scr.weapon_deactivate_temerge, _menuSelectedWep);
								_menuSelectionWepSwap = weapon_get_swap(_menuSelectedWep);
								call(scr.weapon_activate_temerge, _menuSelectedWep);
							}
							else{
								_menuSelectionWepSwap = weapon_get_swap(_menuSelectedWep);
							}
							
							 // Play Swap Sound(s):
							audio_sound_set_track_position(
								sound_play_pitchvol(_menuSelectionWepSwap, 1, 2/3),
								0.03
							);
							if(weapon_get_gold(_menuSelectedWep) != 0){
								sound_play_pitchvol(sndSwapGold, 1, 2/3);
							}
							if(_menuSelectedWepIsPrimary ? (curse > 0) : (bcurse > 0)){
								sound_play_pitchvol(sndSwapCursed, 1, 2/3);
							}
						}
						audio_sound_set_track_position(
							sound_play_pitchvol(
								(_menu.selection_state ? sndPlantFire : sndPlantPower),
								lerp(1.25, 2, _menuSelectionEffectScale),
								2
							),
							0.04
						);
						
						 // Reset Indicator Animation:
						_menu.selection_icon_scale = 0;
						
						 // Store Merged Weapon's Information:
						if(array_length(_menuMergingWep.index_list)){
							var	_menuMergedWep              = undefined,
								_menuMergingWepKeyList      = [],
								_menuMergingWepTypeKeyList  = [],
								_menuSelectionWepSpriteList = [];
								
							with(_menuMergingWep.index_list){
								var	_menuSelectionWepIndex = self,
									_menuSelectedWep       = call(scr.data_clone, _menuSelectionWepList[_menuSelectionWepIndex], infinity);
									
								 // Unmerge Weapon:
								if(
									call(scr.weapon_has_temerge, _menuSelectedWep)
									&& ((_menuSelectionWepIndex < _menuSelectionWep.primary_count) ? (other.curse <= 0) : (other.bcurse <= 0))
								){
									call(scr.weapon_delete_temerge, _menuSelectedWep);
								}
								
								 // Merge Weapon:
								_menuMergedWep = (
									(_menuMergedWep == undefined)
									? _menuSelectedWep
									: call(scr.weapon_add_temerge, _menuMergedWep, _menuSelectedWep)
								);
								
								 // Fetch Sprite:
								array_push(_menuSelectionWepSpriteList, weapon_get_sprt(_menuSelectedWep));
								if(_menuSelectionWepSpriteList[array_length(_menuSelectionWepSpriteList) - 1] == mskNone){
									_menuSelectionWepSpriteList[array_length(_menuSelectionWepSpriteList) - 1] = weapon_get_sprt(call(scr.wep_raw, _menuSelectedWep));
								}
								
								 // Fetch Type:
								array_push(_menuMergingWepTypeKeyList, string(weapon_get_type(_menuSelectedWep)));
								
								 // Fetch Raw Weapon:
								while(true){
									array_push(_menuMergingWepKeyList, string(call(scr.wep_raw, _menuSelectedWep)));
									if(call(scr.weapon_has_temerge, _menuSelectedWep)){
										_menuSelectedWep = call(scr.weapon_get_temerge_weapon, _menuSelectedWep);
									}
									else break;
								}
							}
							
							_menuMergingWep.key_list      = _menuMergingWepKeyList;
							_menuMergingWep.type_key_list = _menuMergingWepTypeKeyList;
							_menuMergingWep.health_cost   = 2 * (array_length(_menuMergingWepKeyList) - 1);
							_menuMergingWep.name          = weapon_get_name(_menuMergedWep);
							_menuMergingWep.type          = weapon_get_type(_menuMergedWep);
							_menuMergingWep.cost          = weapon_get_cost(_menuMergedWep);
							_menuMergingWep.load          = weapon_get_load(_menuMergedWep);
							_menuMergingWep.sprite        = call(scr.weapon_sprite_list_merge, _menuSelectionWepSpriteList);
						}
						else{
							_menuMergingWep        = beetle_menu_merging_wep_default_info;
							_menu.merging_wep_info = _menuMergingWep;
						}
					}
				}
				else _menu.selection_state = undefined;
			}
			
			 // Merged Weapon Crafting Zone Opening & Closing Animation:
			if(array_length(_menuMergingWep.index_list)){
				if(abs(1 - _menu.merging_scale) > 0.01){
					_menu.merging_scale = lerp_ct(_menu.merging_scale, 1, 1/3);
				}
				else{
					_menu.merging_scale = 1;
				}
			}
			else if(_menu.merging_scale != 0){
				if(_menu.merging_scale > 0.01){
					_menu.merging_scale *= power(2/3, current_time_scale);
				}
				else{
					_menu.merging_scale = 0;
				}
			}
			
			 // Close Menu & Confirm Selection:
			if((_specIsPressed && _menuWasOpen) || (_specIsReleased && (_menu.scale > 0.75 || !_menuSelectionWepListSize))){
				_menu.is_open = false;
				
				 // Merging Selected Weapons:
				if(array_length(_menuMergingWep.index_list)){
					var	_menuMergingHPCost       = _menuMergingWep.health_cost, // * ((skill_get(mut_throne_butt) > 0) ? 60 : 1),
						_menuMergingWepPartList  = [],
						_menuMergingWepWasMerged = true,
						_menuMergingWepCanMerge  = (
							/*(skill_get(mut_throne_butt) > 0)
							? (GameCont.rad >= _menuMergingHPCost) // (my_health > _menuMergingHPCost)
							: */(maxhealth > _menuMergingHPCost)
						);
						
					 // Compile List of Selected Weapons:
					with(_menuMergingWep.index_list){
						array_push(_menuMergingWepPartList, _menuSelectionWepList[self]);
					}
					
					 // Remember Crafted Weapon:
					var _menuMergingWepKeyTreeNameList = ["key", "type_key"];
					for(var _menuMergingWepKeyTreeIndex = array_length(_menuMergingWepKeyTreeNameList) - 1; _menuMergingWepKeyTreeIndex >= 0; _menuMergingWepKeyTreeIndex--){
						var	_menuMergingWepKeyTreeName    = _menuMergingWepKeyTreeNameList[_menuMergingWepKeyTreeIndex],
							_menuMergingWepKeyTreeVarName = `beetle_menu_merging_wep_${_menuMergingWepKeyTreeName}_tree`,
							_menuMergingWepKeyTree        = variable_instance_get(GameCont, _menuMergingWepKeyTreeVarName),
							_menuMergingWepKeyList        = lq_get(_menuMergingWep, `${_menuMergingWepKeyTreeName}_list`);
							
						if(_menuMergingWepKeyTree == undefined){
							_menuMergingWepKeyTree = {};
							variable_instance_set(GameCont, _menuMergingWepKeyTreeVarName, _menuMergingWepKeyTree);
						}
						
						with(call(scr.array_combine, _menuMergingWepKeyList, ["?"])){
							if(self not in _menuMergingWepKeyTree || (self == "?" && !lq_defget(_menuMergingWepKeyTree, self, false))){
								if((skill_get(mut_throne_butt) <= 0) ^^ _menuMergingWepKeyTreeIndex){
									_menuMergingWepWasMerged = false;
								}
								if(_menuMergingWepCanMerge){
									lq_set(_menuMergingWepKeyTree, self, ((self == "?") ? true : {}));
								}
								else break;
							}
							_menuMergingWepKeyTree = lq_get(_menuMergingWepKeyTree, self);
						}
					}
					if(_menuMergingWepWasMerged){
						_menuMergingHPCost      = 0;
						_menuMergingWepCanMerge = true;
					}
					
					 // Merge Weapons:
					if(_menuMergingWepCanMerge){
						var	_wep                  = wep,
							_curse                = curse,
							_bWep                 = bwep,
							_bCurse               = bcurse,
							_menuSelectionWepPrimaryCount = _menuSelectionWep.primary_count,
							_mergeHasPrimaryWep   = false,
							_mergeHasSecondaryWep = false;
							
						 // Check Selected Weapon Slot Status:
						for(var _menuSelectionWepIndex = 0; _menuSelectionWepIndex < _menuSelectionWepListSize; _menuSelectionWepIndex++){
							if(array_find_index(_menuMergingWep.index_list, _menuSelectionWepIndex) >= 0){
								if(_menuSelectionWepIndex < _menuSelectionWepPrimaryCount){
									_mergeHasPrimaryWep    = true;
									_menuSelectionWepIndex = _menuSelectionWepPrimaryCount - 1;
								}
								else{
									_mergeHasSecondaryWep = true;
									break;
								}
							}
						}
						
						 // Clear Secondary Weapon:
						if(_mergeHasSecondaryWep && _mergeHasPrimaryWep){
							if(bwep != wep_none){
								curse  = max(curse, bcurse);
								bwep   = wep_none;
								bcurse = 0;
							}
							_menuSelectionWep.primary_count = _menuSelectionWepListSize;
						}
						
						 // Weapon Parts in Affected Slots:
						for(var _menuSelectionWepIndex = 0; _menuSelectionWepIndex <_menuSelectionWepListSize; _menuSelectionWepIndex++){
							var _menuSelectionWepIsPrimary = (_menuSelectionWepIndex < _menuSelectionWepPrimaryCount);
							if(_menuSelectionWepIsPrimary ? _mergeHasPrimaryWep : _mergeHasSecondaryWep){
								var _menuSelectedWep = _menuSelectionWepList[_menuSelectionWepIndex];
								
								 // Delete Existing Weapon Merges:
								if(
									call(scr.weapon_has_temerge, _menuSelectedWep) != false
									&& (_menuSelectionWepIsPrimary ? (curse <= 0) : (bcurse <= 0))
								){
									call(scr.weapon_delete_temerge, _menuSelectedWep);
								}
								
								 // Unselected Weapon Parts:
								if(_menuSelectedWep != wep_none && array_find_index(_menuMergingWep.index_list, _menuSelectionWepIndex) < 0){
									_menuSelectionWepList[_menuSelectionWepIndex] = wep_none;
									
									 // Put in Secondary Slot:
									if(bwep == wep_none){
										bwep   = _menuSelectedWep;
										bcurse = (_menuSelectionWepIsPrimary ? _curse : _bCurse);
									}
									
									 // Drop on Ground:
									else with(instance_create(x, y, WepPickup)){
										wep   = _menuSelectedWep;
										curse = (_menuSelectionWepIsPrimary ? _curse : _bCurse);
										
										 // Effects:
										image_index = 1;
										call(scr.fx, x, y, 3, Dust);
									}
								}
							}
						}
						
						 // Swap to Secondary Weapon:
						if(_mergeHasSecondaryWep && !_mergeHasPrimaryWep){
							call(scr.player_swap, self);
							clicked = false;
							
							 // HUD Visual Swap:
							var _menuSelectionWepSecondaryCount = _menuSelectionWepListSize - _menuSelectionWepPrimaryCount;
							_menuSelectionWepList = call(scr.array_combine,
								array_slice(_menuSelectionWepList, _menuSelectionWepPrimaryCount, _menuSelectionWepSecondaryCount),
								array_slice(_menuSelectionWepList, 0, _menuSelectionWepPrimaryCount)
							);
							_menu.selection_angle          += 360 * (_menuSelectionWepPrimaryCount / _menuSelectionWepListSize);
							_menuSelectionWep.list          = _menuSelectionWepList;
							_menuSelectionWep.primary_count = _menuSelectionWepSecondaryCount;
						}
						
						 // Merge Selected Weapons:
						wep = wep_none;
						with(_menuMergingWepPartList){
							other.wep = (
								(other.wep == wep_none)
								? self
								: call(scr.weapon_add_temerge, other.wep, self)
							);
						}
						//beetle_tb_info.wep = wep_none;
						
						//  // Ultra B:
						// if(_menu.merging_upgrade_count > 0){
						// 	_menu.merging_upgrade_count--;
						// 	wep = call(scr.wep_wrap, wep, "weapon_cost", script_ref_create(beetle_weapon_upgrade_cost));
						// 	wep = call(scr.wep_wrap, wep, "weapon_load", script_ref_create(beetle_weapon_upgrade_load));
						// 	wep = call(scr.wep_wrap, wep, "weapon_name", script_ref_create(beetle_weapon_upgrade_name));
						// 	wep = call(scr.wep_wrap, wep, "step",        script_ref_create(beetle_weapon_upgrade_step));
						// }
						
						 // B-Skin Unlock:
						if(array_length(_menuMergingWepPartList) >= 6){
							call(scr.unlock_set, `skin:${mod_current}:1`, true);
						}
						
						 // Take Health:
						if(_menuMergingHPCost != 0){
							var _text = "";
							
							// if(skill_get(mut_throne_butt) > 0){
							// 	_text = "RADS";
							// 	GameCont.rad -= _menuMergingHPCost;
							// 	//projectile_hit_raw(self, _menuMergingHPCost, 2);
							// }
							// else{
								_text = "MAX HP"
								chickendeaths += _menuMergingHPCost;
								maxhealth     -= _menuMergingHPCost;
								lsthealth      = min(lsthealth, maxhealth);
								projectile_hit_raw(self, max(0, my_health - maxhealth), 2);
							// }
							
							 // Stat:
							var _statPath = "race:beetle:spec";
							call(scr.stat_set, _statPath, call(scr.stat_get, _statPath) + _menuMergingHPCost);
							
							 // Effects:
							with(call(scr.pickup_text, _text + " ", "add", -_menuMergingHPCost)){
								y    -= 58;
								speed = 0;
							}
							with(call(scr.fx, x, y, 3, BloodStreak)){
								sprite_index = spr.SquidBloodStreak;
							}
						}
						
						 // Weapon Part Debris:
						if(array_length(_menuMergingWepPartList) > 1){
							_menu.merging_part_num = array_length(_menuMergingWepPartList);
						}
						
						 // Sound:
						sound_play_pitchvol(
							sndPlantTBKill,
							lerp(0.75, 0.25, _menuMergingHPCost / (
								/*(skill_get(mut_throne_butt) > 0)
								? (600 + GameCont.radmaxextra)
								: */(maxhealth + chickendeaths)
							)),
							2.5
						);
						
						 // Weapon Name:
						call(scr.pickup_text, weapon_get_name(wep), "got");
						
						 // Reset Menu:
						_menu.wep              = wep;
						_menu.bwep             = bwep;
						_menu.curse            = curse;
						_menu.bcurse           = bcurse;
						_menu.merging_wep_info = beetle_menu_merging_wep_default_info;
						
						 // Easy Fix for Curse Repetitive Merging Cheese:
						if(_mergeHasPrimaryWep && _mergeHasSecondaryWep && (curse > 0 || bcurse > 0)){
							_menu.wep  = wep_none;
							_menu.bwep = wep_none;
						}
					}
				}
			}
			
			 // Animation:
			if(_menu.scale == 0 && (wep != wep_none || bwep != wep_none)){
				if(call(scr.weapon_has_temerge, wep)){
					gunshine = 1;
					sound_play_pitchvol(sndWeaponPickup, 1 + orandom(0.1), 2/3);
				}
				sound_play_pitchvol(sndPlantSnareTB, 2 + orandom(0.1), 4/3);
			}
			if(abs(1 - _menu.scale) > 0.01){
				_menu.scale = lerp_ct(_menu.scale, 1, 0.15);
			}
			else{
				_menu.scale = 1;
			}
			if(_menu.scale > 5/6 || array_length(_menuMergingWep.key_list)){
				if(abs(1 - _menu.selection_icon_scale) > 0.01){
					_menu.selection_icon_scale = lerp_ct(_menu.selection_icon_scale, 1, 0.2);
				}
				else{
					_menu.selection_icon_scale = 1;
				}
			}
			
			 // Disable Firing & Laser Sight:
			if(canfire ){ _menu.last_canfire  = canfire;  canfire  = false; }
			if(canscope){ _menu.last_canscope = canscope; canscope = false; }
		}
		
		 // Closing Menu:
		else{
			 // Animation:
			if(_menu.scale > 0.05){
				_menu.scale                *= power(0.8, current_time_scale);
				_menu.selection_icon_scale *= power(0.2, current_time_scale);
			}
			
			 // Closed:
			else{
				 // Clear Menu:
				with(_menu){
					scale                = 0;
					wep                  = wep_none;
					bwep                 = wep_none;
					selection_wep_info   = beetle_menu_selection_wep_default_info;
					selection_state      = undefined;
					selection_icon_scale = 0;
					merging_wep_info     = beetle_menu_merging_wep_default_info;
					merging_scale        = 0;
				}
				
				 // Effects:
				if(wep != wep_none){
					 // Sound:
					sound_play_hit(weapon_get_swap(wep), 0.1);
					if(weapon_get_gold(wep) != 0){
						sound_play_hit(sndSwapGold, 0.1);
					}
					if(curse > 0){
						sound_play_hit(sndSwapCursed, 0.1);
					}
					
					 // Flash:
					if(call(scr.weapon_has_temerge, wep)){
						gunshine = 2;
					}
					with(instance_create(x, y, WepSwap)){
						creator = other;
					}
					
					 // Replaced Weapon Part Debris:
					if(_menu.merging_part_num > 0){
						var	_offsetLen = 8,
							_offsetDir = gunangle + wepangle,
							_x         = x + lengthdir_x(_offsetLen, _offsetDir),
							_y         = y + lengthdir_y(_offsetLen, _offsetDir),
							_ang       = random(360);
							
						for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _menu.merging_part_num)){
							with(call(scr.fx, _x, _y, [_dir + orandom(70), 3], Shell)){
								sprite_index = spr.BackpackDebris;
								image_index  = irandom(image_number - 1);
								image_speed  = 0;
								image_xscale = choose(-1, 1);
								image_blend  = c_silver;
							}
						}
						
						_menu.merging_part_num = 0;
					}
				}
			}
		}
		
		 // Hide Weapons While Menu is Open:
		if(_menu.scale != 0){
			if(_menu.last_bwkick == undefined || abs(bwkick) < 320){
				_menu.last_bwkick = bwkick;
			}
			if(_menu.last_wkick == undefined || abs(wkick) < 320){
				_menu.last_wkick = wkick;
			}
			else{
				_menu.last_wkick -= clamp(_menu.last_wkick, -current_time_scale, current_time_scale);
			}
			bwkick = 10000;
			wkick  = 10000;
		}
	}
	
	 // Chest Retrieval Ultra:
	if(
		ultra_get(mod_current, ultA) > 0
		&& button_pressed(index, "fire")
		&& canfire
		&& player_active
	){
		if(
			wep == wep_none
			|| (
				infammo == 0
				&& (
					ammo[weapon_get_type(wep)] < weapon_get_cost(wep)
					|| GameCont.rad < weapon_get_rads(wep)
				)
			)
		){
			with(call(scr.instance_nearest_array, x, y, instances_matching_ne(obj.BeetleChest, "id"))){
				if(point_distance(x, y, other.x, other.y) > 64){
					 // Disappear Effects:
					for(var _dir = 0; _dir < 360; _dir += (360 / 6)){
						call(scr.fx, x, y, [_dir, 3], Dust);
					}
					
					 // Move to Player:
					x         = other.x;
					y         = other.y;
					xprevious = x;
					yprevious = y;
					call(scr.instance_budge, self, Wall);
					
					 // Appear Effects:
					for(var _dir = 0; _dir < 360; _dir += (360 / 6)){
						call(scr.fx, x, y, [_dir, 3], Dust);
					}
					
					 // Sound:
					sound_play_pitchvol(sndChickenReturn, 1.2 + orandom(0.1), 1.5);
				}
			}
		}
	}
	
	if(lag) trace_time(mod_current + "_step");
	
#define beetle_weapon_upgrade_cost(_wep, _cost)
	/*
		
	*/
	
	return _cost - ceil(_cost * 0.5);
	
#define beetle_weapon_upgrade_load(_wep, _load)
	/*
		
	*/
	
	return _load * 0.5;
	
#define beetle_weapon_upgrade_name(_wep, _name)
	return "SUPAH " + _name;
	
#define beetle_weapon_upgrade_step(_isPrimary)
	if(_isPrimary || race == "steroids"){
		with(instance_create(x, y, WepSwap)){
			creator = other;
			sprite_index = sprCaveSparkle;
		}
	}
	
#define beetle_menu_revert_last_info_step(_beetleMenu, _beetleMenuInstance)
	/*
		Reverts the given beetle menu's stored variables when closed (player weapon kick, ability to fire, and ability to use a laser sight)
	*/
	
	if(instance_exists(_beetleMenuInstance)){
		with(_beetleMenuInstance){
			if(race != mod_current || beetle_menu_info != _beetleMenu){
				_beetleMenu.is_open = false;
				_beetleMenu.scale   = 0;
			}
			if(!_beetleMenu.is_open){
				 // Revert Ability to Fire:
				if(_beetleMenu.last_canfire != undefined){
					canfire                  = _beetleMenu.last_canfire;
					_beetleMenu.last_canfire = undefined;
				}
				
				 // Revert Weapon Kick & Ability to Use a Laser Sight:
				if(_beetleMenu.scale == 0){
					if(_beetleMenu.last_wkick    != undefined){ wkick    = _beetleMenu.last_wkick;    _beetleMenu.last_wkick    = undefined; }
					if(_beetleMenu.last_bwkick   != undefined){ bwkick   = _beetleMenu.last_bwkick;   _beetleMenu.last_bwkick   = undefined; }
					if(_beetleMenu.last_canscope != undefined){ canscope = _beetleMenu.last_canscope; _beetleMenu.last_canscope = undefined; }
					with(other){
						instance_destroy();
					}
				}
			}
		}
	}
	else instance_destroy();
	
// #define ntte_end_step
// 	/*
// 		Beetle's Throne Butt increases their max ammo based on the number of weapons they're holding
// 	*/
//	
// 	if(!instance_exists(GenCont) && !instance_exists(LevCont)){
// 		var _beetleInst = instances_matching(instances_matching_ne(Player, "beetle_tb_info", null), "visible", true);
//		
// 		if(array_length(_beetleInst)){
// 			with(_beetleInst){
// 				var	_beetleTB        = beetle_tb_info,
// 					_TBAmmoAddMult   = 0.05,
// 					_canUpdateTB     = false,
// 					_canMakeAmmoText = false;
//					
// 				 // Check for Updated Values:
// 				if(race == mod_current){
// 					if(_beetleTB.value != skill_get(mut_throne_butt)){
// 						_beetleTB.value  = skill_get(mut_throne_butt);
// 						_canUpdateTB     = true;
// 						_canMakeAmmoText = true;
// 					}
// 					if(_beetleTB.wep != wep || _beetleTB.bwep != bwep){
// 						_beetleTB.wep  = wep;
// 						_beetleTB.bwep = bwep;
// 						_canUpdateTB   = true;
// 					}
// 				}
//				
// 				 // Fix Character-Changing Resetting Pickup Ammo:
// 				if(_beetleTB.race != race){
// 					_beetleTB.race = race;
// 					if(_beetleTB.wep_count > 0){
// 						repeat(ceil(_beetleTB.wep_count)){
// 							for(var _ammoIndex = array_length(ammo) - 1; _ammoIndex >= 1; _ammoIndex--){
// 								var _typAmmoAdd = typ_ammo[_ammoIndex] * _TBAmmoAddMult;
// 								typ_ammo[_ammoIndex] += ceil(abs(_typAmmoAdd)) * sign(_typAmmoAdd);
// 							}
// 						}
// 					}
// 				}
//				
// 				 // Fix Back Muscle Overriding Max Ammo:
// 				if(_beetleTB.muscle_value != skill_get(mut_back_muscle)){
// 					_beetleTB.muscle_value = skill_get(mut_back_muscle);
// 					if(_beetleTB.wep_count > 0){
// 						repeat(ceil(_beetleTB.wep_count)){
// 							for(var _ammoIndex = array_length(ammo) - 1; _ammoIndex >= 1; _ammoIndex--){
// 								var _maxAmmoAdd = typ_amax[_ammoIndex] * _TBAmmoAddMult;
// 								typ_amax[_ammoIndex] += ceil(abs(_maxAmmoAdd)) * sign(_maxAmmoAdd);
// 							}
// 						}
// 					}
// 				}
//				
// 				 // Update TB:
// 				if(_canUpdateTB){
// 					var _lastWepCount = _beetleTB.wep_count;
//					
// 					 // Count Up Weapons:
// 					_beetleTB.wep_count = 0;
// 					if(_beetleTB.value != 0){
// 						for(var _wepIndex = 0; _wepIndex < 2; _wepIndex++){
// 							var _wep = ((_wepIndex == 0) ? _beetleTB.wep : _beetleTB.bwep);
// 							while(true){
// 								if(call(scr.wep_raw, _wep) != wep_none){
// 									_beetleTB.wep_count += _beetleTB.value;
// 								}
// 								if(call(scr.weapon_has_temerge, _wep)){
// 									_wep = call(scr.weapon_get_temerge_weapon, _wep)
// 								}
// 								else break;
// 							}
// 						}
// 						_beetleTB.wep_count -= min(_beetleTB.wep_count, 2 * _beetleTB.value);
// 					}
//					
// 					 // Adjust Ammo:
// 					if(_beetleTB.wep_count != _lastWepCount){
// 						var _ammoAddMult = (
// 							(_beetleTB.wep_count > _lastWepCount)
// 							? _TBAmmoAddMult
// 							: ((1 / (1 + _TBAmmoAddMult)) - 1)
// 						);
// 						repeat(ceil(abs(_beetleTB.wep_count - _lastWepCount))){
// 							for(var _ammoIndex = array_length(ammo) - 1; _ammoIndex >= 1; _ammoIndex--){
// 								var	_ammoAdd    = ammo[_ammoIndex]     * _ammoAddMult,
// 									_maxAmmoAdd = typ_amax[_ammoIndex] * _ammoAddMult,
// 									_typAmmoAdd = typ_ammo[_ammoIndex] * _ammoAddMult;
//									
// 								ammo[_ammoIndex]     += ceil(abs(_ammoAdd))    * sign(_ammoAdd);
// 								typ_amax[_ammoIndex] += ceil(abs(_maxAmmoAdd)) * sign(_maxAmmoAdd);
// 								typ_ammo[_ammoIndex] += ceil(abs(_typAmmoAdd)) * sign(_typAmmoAdd);
// 							}
// 						}
// 						_canMakeAmmoText = true;
// 					}
// 				}
//				
// 				 // % Indicator:
// 				if(_canMakeAmmoText){
// 					var	_ammoMult    = 1 + (_TBAmmoAddMult * ceil(_beetleTB.wep_count)),
// 						_ammoTagList = ["@s", "@w", "@y", "@q@y"],
// 						_ammoTag     = _ammoTagList[clamp(ceil(((_ammoMult - 1) / 0.1) - epsilon), 0, array_length(_ammoTagList) - 1)];
//						
// 					call(scr.pickup_text, `${_ammoTag}${round(100 * _ammoMult)}% AMMO`);
// 					sound_play_pitchvol(sndLuckyShotProc, _ammoMult, 2);
// 				}
// 			}
// 		}
// 	}
	
#define ntte_draw
	/*
		Beetle weapon merging menu HUD
	*/
	
	if(instance_exists(Player)){
		var _inst = instances_matching(instances_matching(Player, "race", mod_current), "visible", true);
		if(array_length(_inst)){
			with(_inst){
				var	_menu      = beetle_menu_info,
					_menuScale = _menu.scale;
					
				if(_menuScale != 0){
					var	_menuX                    = pround(x, 1 / game_scale_nonsync),
						_menuY                    = pround(y, 1 / game_scale_nonsync),
						_menuSelectionWep         = _menu.selection_wep_info,
						_menuSelectionWepList     = _menuSelectionWep.list,
						_menuSelectionWepListSize = array_length(_menuSelectionWepList),
						_menuMergingWep           = _menu.merging_wep_info,
						_menuMergingWepSize       = array_length(_menuMergingWep.index_list),
						_handLen2                 = 4 * _menuScale,
						_handDir                  = gunangle,
						_handX1                   = x + lengthdir_x(lerp(5, 10, _menuScale),           _handDir),
						_handY1                   = y + lengthdir_y(lerp(2, 10, power(_menuScale, 2)), _handDir) + (3 * (1 - _menuScale)),
						_handX2                   = _handX1 + lengthdir_x(_handLen2, _handDir),
						_handY2                   = _handY1 + lengthdir_y(_handLen2, _handDir) + dsin((wave / 60) * 360),
						_handRadius               = lerp(1, 2, _menuScale),
						_hasThroneButt            = (skill_get(mut_throne_butt) > 0);
						
					 // Beetle's Hand:
					draw_set_color(c_black);
					draw_circle(_handX1 - 1, _handY1 - 1, _handRadius, false);
					if(_menu.selection_state == undefined){
						draw_triangle(
							(_handX1 - 1) + lengthdir_x(_handRadius, _handDir - 90),
							(_handY1 - 1) + lengthdir_y(_handRadius, _handDir - 90),
							(_handX1 - 1) - lengthdir_x(_handRadius, _handDir - 90),
							(_handY1 - 1) - lengthdir_y(_handRadius, _handDir - 90),
							(_handX2 - 1),
							(_handY2 - 1),
							false
						);
					}
					
					 // Radial Weapon Selection:
					for(var _menuSelectionWepIndex = 0; _menuSelectionWepIndex < _menuSelectionWepListSize; _menuSelectionWepIndex++){
						var	_wep        = _menuSelectionWepList[_menuSelectionWepIndex],
							_wepSpr     = -1,
							_wepKeyList = [],
							_isPrimary  = (_menuSelectionWepIndex < _menuSelectionWep.primary_count),
							_circleList = [];
							
						 // Fetch Weapon Sprite & Keys:
						if(
							call(scr.weapon_has_temerge, _wep)
							&& (_isPrimary ? (curse <= 0) : (bcurse <= 0))
						){
							call(scr.weapon_deactivate_temerge, _wep);
							
							 // Weapon Sprite:
							_wepSpr = weapon_get_sprt(_wep);
							
							 // Weapon Key:
							array_push(_wepKeyList, string(
								_hasThroneButt
								? weapon_get_type(_wep)
								: call(scr.wep_raw, _wep)
							));
							
							call(scr.weapon_activate_temerge, _wep);
						}
						else{
							 // Weapon Sprite:
							_wepSpr = weapon_get_sprt(_wep);
							
							 // Weapon Keys (Including Cursed):
							var _searchWep = _wep;
							while(call(scr.weapon_has_temerge, _searchWep)){
								call(scr.weapon_deactivate_temerge, _searchWep);
								array_push(_wepKeyList, string(
									_hasThroneButt
									? weapon_get_type(_searchWep)
									: call(scr.wep_raw, _searchWep)
								));
								call(scr.weapon_activate_temerge, _searchWep);
								_searchWep = call(scr.weapon_get_temerge_weapon, _searchWep);
							}
							array_push(_wepKeyList, string(
								_hasThroneButt
								? weapon_get_type(_searchWep)
								: call(scr.wep_raw, _searchWep)
							));
						}
						if(_wepSpr == mskNone){
							_wepSpr = weapon_get_sprt(call(scr.wep_raw, _wep));
						}
						
						 // Setup Drawing Values:
						var	_isMelee      = weapon_is_melee(_isPrimary ? wep : bwep),
							_wepImg       = gunshine,
							_wepFlip      = (_isMelee ? (_isPrimary ? wepflip : bwepflip) : right),
							_wepKick      = 0,
							_wepAng       = ((_wepFlip < 0) ? 180 : 0),
							_wepMeleeAng  = 0,
							_wepCol       = ((array_find_index(_menuMergingWep.index_list, _menuSelectionWepIndex) < 0) ? c_white : c_black),
							_wepAlp       = 1,
							_wepOffsetX   = sprite_get_xoffset(_wepSpr) - floor(lerp(sprite_get_bbox_left(_wepSpr), sprite_get_bbox_right(_wepSpr)  + 1, 0.5)),
							_wepOffsetY   = sprite_get_yoffset(_wepSpr) - floor(lerp(sprite_get_bbox_top(_wepSpr),  sprite_get_bbox_bottom(_wepSpr) + 1, 0.5)),
							_wepOffsetLen = 28,
							_wepOffsetDir = _menu.selection_angle + (360 * (_menuSelectionWepIndex / _menuSelectionWepListSize));
							
						if(_wepFlip < 0){
							_wepOffsetX += sprite_get_width(_wepSpr) - (2 * sprite_get_xoffset(_wepSpr));
						}
						
						 // Draw Separator Line:
						if(_menuSelectionWepListSize > 1){
							var	_lineLen1 = lerp(56, 20, power(_menuScale, 1.5)) + (2 * dcos((wave / 60) * 360)),
								_lineLen2 = _lineLen1 + (16 * power(_menuScale, 2));
								
							if(round(_lineLen2 - _lineLen1) > 0){
								var	_lineDir = _wepOffsetDir + (360 * (0.5 / _menuSelectionWepListSize) * _menuScale),
									_lineX1  = _menuX + lengthdir_x(_lineLen1, _lineDir),
									_lineY1  = _menuY + lengthdir_y(_lineLen1, _lineDir),
									_lineX2  = _menuX + lengthdir_x(_lineLen2, _lineDir),
									_lineY2  = _menuY + lengthdir_y(_lineLen2, _lineDir),
									_lineW   = 2 * lerp(3, _menuScale, abs(power(_menuScale, 1.5) - 0.5) / 0.5);
									
								draw_set_color(c_black);
								draw_line_width(_lineX1,     _lineY1 - 1, _lineX2,     _lineY2 - 1, _lineW);
								draw_line_width(_lineX1 - 1, _lineY1,     _lineX2 - 1, _lineY2,     _lineW);
								draw_line_width(_lineX1,     _lineY1,     _lineX2,     _lineY2,     _lineW);
								draw_set_color(c_white);
								draw_line_width(_lineX1 - 1, _lineY1 - 1, _lineX2 - 1, _lineY2 - 1, _lineW);
							}
						}
						
						 // Path to Free Merge Indicators:
						var	_menuMergingWepKeyTree        = undefined,
							_menuMergingWepKeyTreeName    = (_hasThroneButt ? "type_key" : "key"),
							_menuMergingWepKeyTreeVarName = `beetle_menu_merging_wep_${_menuMergingWepKeyTreeName}_tree`,
							_menuMergingWepKeyList        = lq_get(_menuMergingWep, `${_menuMergingWepKeyTreeName}_list`);
							
						if(
							array_find_index(_menuMergingWep.index_list, _menuSelectionWepIndex) < 0
							&& _menuMergingWepKeyTreeVarName in GameCont
						){
							_menuMergingWepKeyTree = variable_instance_get(GameCont, _menuMergingWepKeyTreeVarName);
							
							 // Check if Weapon Was Merged Before:
							with(call(scr.array_combine, _menuMergingWepKeyList, _wepKeyList)){
								if(self not in _menuMergingWepKeyTree){
									_menuMergingWepKeyTree = undefined;
									break;
								}
								_menuMergingWepKeyTree = lq_get(_menuMergingWepKeyTree, self);
							}
							
							 // Weapon Was Merged:
							if(_menuMergingWepKeyTree != undefined){
								var	_circleAngle            = _wepOffsetDir - (360 * (0.5 / _menuSelectionWepListSize) * (1 - _menuScale)),
									_circleRadius           = (3 + (0.25 * dcos((wave / 60) * 360))) * _menuScale,
									_circleScale            = lerp(1.5, _menu.selection_icon_scale, abs(_menu.selection_icon_scale - 0.5) / 0.5),
									_circleCenterX          = _menuX + lengthdir_x(_wepOffsetLen - (_circleRadius * 2), _circleAngle),
									_circleCenterY          = _menuY + lengthdir_y(_wepOffsetLen - (_circleRadius * 2), _circleAngle),
									_selectableWepIndexList = [],
									_selectableWepCount     = 0,
									_selectableWepInfoList  = [{ "index": -1, "tree": _menuMergingWepKeyTree }],
									_selectableWepInfoCount = 1;
									
								 // Compile List of Selectable Weapon Indices:
								for(var _index = 0; _index < _menuSelectionWepListSize; _index++){
									if(
										_index != _menuSelectionWepIndex
										&& array_find_index(_menuMergingWep.index_list, _index) < 0
									){
										array_push(_selectableWepIndexList, _index);
										_selectableWepCount++;
									}
								}
								
								 // Search for Past Merged Combinations:
								while(_selectableWepInfoCount){
									var _selectableWepInfo = _selectableWepInfoList[_selectableWepInfoCount - 1];
									_selectableWepInfo.index++;
									if(_selectableWepInfo.index < _selectableWepCount){
										var	_selectableWepIndex   = _selectableWepIndexList[_selectableWepInfo.index],
											_selectableWep        = _menuSelectionWepList[_selectableWepIndex],
											_selectableWepKeyTree = _selectableWepInfo.tree;
											
										 // Cursed Weapon:
										if((_selectableWepIndex < _menuSelectionWep.primary_count) ? (curse > 0) : (bcurse > 0)){
											while(call(scr.weapon_has_temerge, _selectableWep)){
												call(scr.weapon_deactivate_temerge, _selectableWep);
												_selectableWepKeyTree = lq_get(_selectableWepKeyTree, string(
													_hasThroneButt
													? weapon_get_type(_selectableWep)
													: call(scr.wep_raw, _selectableWep)
												));
												call(scr.weapon_activate_temerge, _selectableWep);
												if(_selectableWepKeyTree == undefined){
													break;
												}
												_selectableWep = call(scr.weapon_get_temerge_weapon, _selectableWep);
											}
											if(_selectableWepKeyTree != undefined){
												_selectableWepKeyTree = lq_get(_selectableWepKeyTree, string(
													_hasThroneButt
													? weapon_get_type(_selectableWep)
													: call(scr.wep_raw, _selectableWep)
												));
											}
											else continue;
										}
										
										 // Normal Weapon:
										else{
											var _selectWepHasMerge = call(scr.weapon_has_temerge, _selectableWep);
											if(_selectWepHasMerge){
												call(scr.weapon_deactivate_temerge, _selectableWep);
											}
											_selectableWepKeyTree = lq_get(_selectableWepKeyTree, string(
												_hasThroneButt
												? weapon_get_type(_selectableWep)
												: call(scr.wep_raw, _selectableWep)
											));
											if(_selectWepHasMerge){
												call(scr.weapon_activate_temerge, _selectableWep);
											}
										}
										
										 // Found Previously Merged Combination:
										if(_selectableWepKeyTree != undefined){
											var _selectableWepInfoIsUnique = true;
											with(_selectableWepInfoList){
												if(self != _selectableWepInfo && index == _selectableWepInfo.index){
													_selectableWepInfoIsUnique = false;
													break;
												}
											}
											if(_selectableWepInfoIsUnique){
												if(lq_defget(_selectableWepKeyTree, "?", false)){
													 // Add Indicator:
													var _circleRot = 360 * ((_selectableWepIndexList[_selectableWepInfoList[0].index] - _menuSelectionWepIndex) / _menuSelectionWepListSize);
													array_push(_circleList, [
														_circleCenterX + lengthdir_x(_circleRadius * 2, _circleAngle + _circleRot),
														_circleCenterY + lengthdir_y(_circleRadius * 2, _circleAngle + _circleRot)
													]);
													
													 // Return to First Layer:
													_selectableWepInfoCount = 1;
													_selectableWepInfoList  = array_slice(_selectableWepInfoList, 0, _selectableWepInfoCount);
												}
												
												 // Keep Searching:
												else{
													array_push(_selectableWepInfoList, {
														"index" : -1,
														"tree"  : _selectableWepKeyTree
													});
													_selectableWepInfoCount++;
												}
											}
										}
									}
									
									 // Up a Layer:
									else{
										_selectableWepInfoCount--;
										_selectableWepInfoList = array_slice(_selectableWepInfoList, 0, _selectableWepInfoCount);
									}
								}
								
								 // Scale Circle:
								_circleRadius *= _circleScale * ((_menuSelectionWepIndex == _menuSelectionWep.index) ? 1 : 0.8);
							}
						}
						
						 // Menu Opening Animation:
						if(_menuScale < 1){
							var	_startKick      = (_isPrimary ? _menu.last_wkick : 0),
								_startAng       = (_isPrimary ? gunangle         : (90 + (15 * right))),
								_startMeleeAng  = (_isPrimary ? wepangle         : 0),
								_startCol       = (_isPrimary ? image_blend      : c_black),
								_startAlp       = (_isPrimary ? image_alpha      : -0.5),
								_startOffsetX   = (_isPrimary ? 0                : -(2 * right)),
								_startOffsetY   = (_isPrimary ? swapmove         : -swapmove),
								_startOffsetDir = (_isPrimary ? _wepAng          : (90 + (90 * right))),
								_startOffsetLen = 0;
								
							_wepKick      = lerp       (_startKick,      _wepKick,      _menuScale);
							_wepAng       = angle_lerp (_startAng,       _wepAng,       _menuScale);
							_wepMeleeAng  = angle_lerp (_startMeleeAng,  _wepMeleeAng,  _menuScale);
							_wepCol       = merge_color(_startCol,       _wepCol,       _menuScale);
							_wepAlp       = lerp       (_startAlp,       _wepAlp,       _menuScale);
							_wepOffsetX   = lerp       (_startOffsetX,   _wepOffsetX,   _menuScale);
							_wepOffsetY   = lerp       (_startOffsetY,   _wepOffsetY,   _menuScale);
							_wepOffsetDir = angle_lerp (_startOffsetDir, _wepOffsetDir, _menuScale);
							_wepOffsetLen = lerp       (_startOffsetLen, _wepOffsetLen, _menuScale);
						}
						
						var	_wepX = _menuX + lengthdir_x(_wepOffsetLen, _wepOffsetDir),
							_wepY = _menuY + lengthdir_y(_wepOffsetLen, _wepOffsetDir);
							
						 // Draw Selection Highlight Outline:
						if(_menuSelectionWepIndex == _menuSelectionWep.index){
							draw_set_fog(true, ((_isPrimary ? (curse > 0) : (bcurse > 0)) ? make_color_rgb(136, 36, 174) : c_white), 0, 0);
							
							var _outlineAlpha = max(0, lerp(-1, 1, _menuScale));
							
							for(var _dir = 0; _dir < 360; _dir += 90){
								call(scr.draw_weapon,
									_wepSpr,
									_wepImg,
									_wepX + _wepOffsetX + dcos(_dir),
									_wepY + _wepOffsetY - dsin(_dir),
									_wepAng,
									_wepMeleeAng,
									_wepKick,
									_wepFlip,
									_wepCol,
									_wepAlp * _outlineAlpha
								);
							}
							
							draw_set_fog(false, 0, 0, 0);
						}
						
						 // Draw Weapon Sprite:
						call(scr.draw_weapon,
							_wepSpr,
							_wepImg,
							_wepX + _wepOffsetX,
							_wepY + _wepOffsetY,
							_wepAng,
							_wepMeleeAng,
							_wepKick,
							_wepFlip,
							_wepCol,
							_wepAlp
						);
						
						 // Draw Crafting History Indicators:
						for(var _circleIndex = array_length(_circleList) - 1; _circleIndex >= 0; _circleIndex--){
							var	_circle  = _circleList[_circleIndex],
								_circleX = _circle[0],
								_circleY = _circle[1];
								
							draw_set_color(c_black);
							draw_circle(_circleX,     _circleY - 1, _circleRadius, false);
							draw_circle(_circleX - 1, _circleY,     _circleRadius, false);
							draw_circle(_circleX,     _circleY,     _circleRadius, false);
							draw_set_color(c_white);
							draw_circle(_circleX - 1, _circleY - 1, _circleRadius, false);
						}
						
						 // Free Merge Indicator:
						if(
							array_length(_menuMergingWepKeyList)
							&& _menuMergingWepKeyTree != undefined
							&& lq_defget(_menuMergingWepKeyTree, "?", false)
						){
							var _circleColor = (
								(bskin == 0)
								? make_color_rgb(24, 165, 132)
								: (
									(bskin == 1)
									? make_color_rgb(252, 56, 0)
									: player_get_color(index)
								)
							);
							_circleRadius *= 2/3;
							draw_set_color(c_black);
							draw_circle(_circleCenterX,     _circleCenterY - 1, _circleRadius, false);
							draw_circle(_circleCenterX - 1, _circleCenterY,     _circleRadius, false);
							draw_circle(_circleCenterX,     _circleCenterY,     _circleRadius, false);
							draw_set_color(make_color_hsv(
								color_get_hue(_circleColor),
								color_get_saturation(_circleColor),
								255
							));
							draw_circle(_circleCenterX - 1, _circleCenterY - 1, _circleRadius, false);
						}
						
						//  // Draw Selected Weapon Button Prompt:
						// if(_menuSelectionWepIndex == _menuSelectionWep.index && _menuScale > 0.75){
						// 	draw_set_font(fntSmall);
						// 	draw_set_halign(fa_center);
						// 	draw_set_valign(fa_middle);
						// 	for(var _buttonOffsetY = 0; _buttonOffsetY <= (button_check(index, "fire") ? 0 : 1); _buttonOffsetY++){
						// 		draw_text_nt(
						// 			_wepX + lengthdir_x(-10, _wepOffsetDir),
						// 			_wepY + lengthdir_y(-10, _wepOffsetDir) - _buttonOffsetY,
						// 			"@(sprKeySmall:fire)"
						// 		);
						// 	}
						// }
					}
					
					 // Weapon Merging:
					var	_menuMergingX1 = _menuX - (lerp(24, 32, _menuScale) * _menu.merging_scale),
						_menuMergingX2 = _menuX + (_menuX - _menuMergingX1),
						_menuMergingY1 = _menuY - (52 + ((4 + (8 * (_menuMergingWepSize ? -1 : 1) * (1 - power(_menu.merging_scale, 1/2)))))),
						_menuMergingY2 = _menuMergingY1 + (16 * _menuScale);
						
					draw_set_color(c_black);
					draw_set_alpha(2/3);
					draw_roundrect(_menuMergingX1 - 1, _menuMergingY1 - 1, _menuMergingX2 - 1, _menuMergingY2 - 1, false);
					draw_set_alpha(1);
					
					if(_menuMergingWepSize > 0){
						var	_menuMergingWepX      = pround(lerp(_menuMergingX1, _menuMergingX2, 0.5), 1 / game_scale_nonsync),
							_menuMergingWepY      = pround(lerp(_menuMergingY1, _menuMergingY2, 0.5), 1 / game_scale_nonsync),
							_menuMergingWepXScale = power(_menu.merging_scale, 1/3) * lerp(2, 1, _menuScale),
							_menuMergingWepYScale = _menuScale * lerp(2, 1, power(_menu.merging_scale, 1/5)),
							_menuMergingHPCost    = _menuMergingWep.health_cost; // * (_hasThroneButt ? 60 : 1);
							
						 // Remember Past Merges:
						if(_menuMergingHPCost != 0 && _menuMergingWepKeyTreeVarName in GameCont){
							var _menuMergingWepKeyTree = variable_instance_get(GameCont, _menuMergingWepKeyTreeVarName);
							with(_menuMergingWepKeyList){
								if(self not in _menuMergingWepKeyTree){
									_menuMergingWepKeyTree = undefined;
									break;
								}
								_menuMergingWepKeyTree = lq_get(_menuMergingWepKeyTree, self);
							}
							if(_menuMergingWepKeyTree != undefined && lq_defget(_menuMergingWepKeyTree, "?", false)){
								_menuMergingHPCost = 0;
							}
						}
						
						 // Draw Merging Weapon Sprite:
						draw_sprite_ext(
							_menuMergingWep.sprite,
							0,
							_menuMergingWepX + ((sprite_get_xoffset(_menuMergingWep.sprite) - floor(lerp(sprite_get_bbox_left(_menuMergingWep.sprite), sprite_get_bbox_right(_menuMergingWep.sprite)  + 1, 0.5))) * _menuMergingWepXScale),
							_menuMergingWepY + ((sprite_get_yoffset(_menuMergingWep.sprite) - floor(lerp(sprite_get_bbox_top(_menuMergingWep.sprite),  sprite_get_bbox_bottom(_menuMergingWep.sprite) + 1, 0.5))) * _menuMergingWepYScale),
							_menuMergingWepXScale,
							_menuMergingWepYScale,
							0,
							merge_color(c_black, c_white, clamp(_menuMergingWepYScale, 0, 1)),
							1
						);
						
						 // HP Cost Text:
						if(_menuMergingHPCost != 0){
							var	_menuMergingHPCostX        = lerp(_menuMergingX1, _menuMergingX2, 0.5),
								_menuMergingHPCostY        = _menuMergingY1 - 2,
								_menuMergingHPCostText     = ((_menuMergingHPCost > 0) ? "-" : "+"),
								_menuMergingHPCostIsActive = (
									/*_hasThroneButt
									? (GameCont.rad >= _menuMergingHPCost)
									: */(maxhealth > _menuMergingHPCost) // && !_menuMergingWepWasMerged
								);
								
							draw_set_font(fntM);
							draw_set_halign(fa_center);
							draw_set_valign(fa_bottom);
							
							 // Amount Text:
							if(!_menuMergingHPCostIsActive){
								_menuMergingHPCostText += "@d";
							}
							_menuMergingHPCostText += `${abs(_menuMergingHPCost)} `;
							
							 // Name Text:
							if(_menuMergingHPCostIsActive){
								_menuMergingHPCostText += "@q" + (/*_hasThroneButt ? "@g" : */"@r");
							}
							_menuMergingHPCostText += (
								/*_hasThroneButt
								? "RADS"
								: */"MAX HP"
							)
							_menuMergingHPCostText += (_menuMergingHPCostIsActive ? "@w!" : ".");
							
							 // Draw Text:
							draw_text_nt(_menuMergingHPCostX, _menuMergingHPCostY, _menuMergingHPCostText);
						}
						
						 // Draw Merging Weapon Name:
						draw_set_font(fntSmall);
						draw_set_halign(fa_center);
						draw_set_valign(fa_bottom);
						draw_text_nt(
							lerp(_menuMergingX1, _menuMergingX2, 0.5),
							_menuMergingY1 - (2 + (10 * (_menuMergingHPCost != 0))),
							_menuMergingWep.name
						);
						
						 // Draw Merging Weapon Stats:
						var	_menuMergingWepCost = _menuMergingWep.cost,
							_menuMergingWepLoad = _menuMergingWep.load;
							
						draw_set_valign(fa_middle);
						
						if(_menuMergingWepCost != 0){
							draw_set_halign(fa_right);
							
							var _menuMergingWepCostText = string(_menuMergingWepCost);
							
							 // Remove Leading Zero:
							if(string_char_at(_menuMergingWepCostText, 1) == "0"){
								_menuMergingWepCostText = string_delete(_menuMergingWepCostText, 1, 1);
							}
							
							 // Draw Text:
							var	_menuMergingWepCostTextX = _menuMergingX1 - 2,
								_menuMergingWepCostTextY = _menuMergingWepY;
								
							draw_text_nt(
								_menuMergingWepCostTextX,
								_menuMergingWepCostTextY,
								`@1(${spr.WhiteAmmoTypeIcon}:${_menuMergingWep.type}) ${/*(_menu.merging_upgrade_count > 0) ? "@d" : */((_menuMergingWepCost > typ_amax[_menuMergingWep.type]) ? "@r" : "")}${_menuMergingWepCostText}`
							);
							
							// if(_menu.merging_upgrade_count > 0){
							// 	var	_menuMergingWepCostTextW = -(string_width(_menuMergingWepCostText) + 1),
							// 		_menuMergingWepCostTextH = string_height(_menuMergingWepCostText);
							//		
							// 	 // Cross Out Text:
							// 	draw_set_color(c_black);
							// 	draw_line_width(_menuMergingWepCostTextX,     _menuMergingWepCostTextY - 1, _menuMergingWepCostTextX + _menuMergingWepCostTextW,     _menuMergingWepCostTextY - 1, 1);
							// 	draw_line_width(_menuMergingWepCostTextX - 1, _menuMergingWepCostTextY,     _menuMergingWepCostTextX + _menuMergingWepCostTextW - 1, _menuMergingWepCostTextY,     1);
							// 	draw_line_width(_menuMergingWepCostTextX,     _menuMergingWepCostTextY,     _menuMergingWepCostTextX + _menuMergingWepCostTextW,     _menuMergingWepCostTextY,     1);
							// 	draw_set_color(make_color_rgb(252, 56, 0));
							// 	draw_line_width(_menuMergingWepCostTextX - 1, _menuMergingWepCostTextY - 1, _menuMergingWepCostTextX + _menuMergingWepCostTextW - 1, _menuMergingWepCostTextY - 1, 1);
							//	
							// 	 // Draw Halved Text:
							// 	_menuMergingWepCost     = _menuMergingWep.cost - ceil(_menuMergingWep.cost * 0.5);
							// 	_menuMergingWepCostText = string(_menuMergingWepCost);
							// 	if(string_char_at(_menuMergingWepCostText, 1) == "0"){
							// 		_menuMergingWepCostText = string_delete(_menuMergingWepCostText, 1, 1);
							// 	}
							// 	draw_text_nt(
							// 		_menuMergingWepCostTextX,
							// 		_menuMergingWepCostTextY + _menuMergingWepCostTextH + 1,
							// 		((_menuMergingWepCost > typ_amax[_menuMergingWep.type]) ? "@r" : "") + _menuMergingWepCostText
							// 	);
							// }
						}
						if(_menuMergingWepLoad > 0){
							draw_set_halign(fa_left);
							
							_menuMergingWepLoad = pround(_menuMergingWepLoad / 30, 0.01);
							
							var _menuMergingWepLoadText = string_format(
								_menuMergingWepLoad,
								0,
								(
									(_menuMergingWepLoad > 0 && _menuMergingWepLoad < 0.1)
									? 2
									: ((frac(pround(_menuMergingWepLoad, 0.1)) == 0) ? 0 : 1)
								)
							);
							
							 // Remove Leading Zero:
							if(string_char_at(_menuMergingWepLoadText, 1) == "0"){
								_menuMergingWepLoadText = string_delete(_menuMergingWepLoadText, 1, 1);
							}
							
							 // Draw Text:
							var	_menuMergingWepLoadTextX = _menuMergingX2 + 2,
								_menuMergingWepLoadTextY = _menuMergingWepY;
								
							draw_text_nt(
								_menuMergingWepLoadTextX,
								_menuMergingWepLoadTextY,
								`${/*(_menu.merging_upgrade_count > 0) ? "@d" : */""}${_menuMergingWepLoadText} @1(${spr.WhiteReloadIcon})`
							);
							
							// if(_menu.merging_upgrade_count > 0){
							// 	var	_menuMergingWepLoadTextW = string_width(_menuMergingWepLoadText),
							// 		_menuMergingWepLoadTextH = string_height(_menuMergingWepLoadText);
							//		
							// 	 // Cross Out Text:
							// 	draw_set_color(c_black);
							// 	draw_line_width(_menuMergingWepLoadTextX - 1, _menuMergingWepLoadTextY - 1, _menuMergingWepLoadTextX + _menuMergingWepLoadTextW,     _menuMergingWepLoadTextY - 1, 1);
							// 	draw_line_width(_menuMergingWepLoadTextX - 2, _menuMergingWepLoadTextY,     _menuMergingWepLoadTextX + _menuMergingWepLoadTextW - 1, _menuMergingWepLoadTextY,     1);
							// 	draw_line_width(_menuMergingWepLoadTextX - 1, _menuMergingWepLoadTextY,     _menuMergingWepLoadTextX + _menuMergingWepLoadTextW,     _menuMergingWepLoadTextY,     1);
							// 	draw_set_color(make_color_rgb(252, 56, 0));
							// 	draw_line_width(_menuMergingWepLoadTextX - 2, _menuMergingWepLoadTextY - 1, _menuMergingWepLoadTextX + _menuMergingWepLoadTextW - 1, _menuMergingWepLoadTextY - 1, 1);
							//	
							// 	 // Draw Halved Text:
							// 	_menuMergingWepLoad     = pround((_menuMergingWep.load * 0.5) / 30, 0.01);
							// 	_menuMergingWepLoadText = string_format(
							// 		_menuMergingWepLoad,
							// 		0,
							// 		(
							// 			(_menuMergingWepLoad > 0 && _menuMergingWepLoad < 0.1)
							// 			? 2
							// 			: ((frac(pround(_menuMergingWepLoad, 0.1)) == 0) ? 0 : 1)
							// 		)
							// 	);
							// 	if(string_char_at(_menuMergingWepLoadText, 1) == "0"){
							// 		_menuMergingWepLoadText = string_delete(_menuMergingWepLoadText, 1, 1);
							// 	}
							// 	draw_text_nt(
							// 		_menuMergingWepLoadTextX,
							// 		_menuMergingWepLoadTextY + _menuMergingWepLoadTextH + 1,
							// 		_menuMergingWepLoadText
							// 	);
							// }
						}
					}
				}
			}
		}
	}
	
	
/// OBJECTS
#define BeetleChest_create(_x, _y)
	/*
		A chest used for weapon storage between levels, similar to the proto chest
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.QuestChest;
		spr_dead	 = spr.QuestChestOpen;
		spr_shadow   = shd32;
		
		 // Sounds:
		snd_open = sndChest;
		
		 // Vars:
		ammo = false;
		
		 // Events:
		on_open = script_ref_create(BeetleChest_open);
		
		return self;
	}
	
#define BeetleChest_step
	/*
		Beetle chests sparkle when their contained weapon has ammo
	*/
	
	if(chance_ct(1, 30)){
		var _canSparkle = true;
		if("player_beetle_chest_info_list" in GameCont){
			_canSparkle = false;
			for(var _playerIndex = 0; _playerIndex < maxp; _playerIndex++){
				if(player_is_active(_playerIndex)){
					var	_beetleChest    = GameCont.player_beetle_chest_info_list[_playerIndex],
						_beetleChestWep = _beetleChest.wep;
						
					if(_beetleChest.has_ammo && (_beetleChestWep == wep_none || weapon_get_type(_beetleChestWep) != type_melee)){
						_canSparkle = true;
						break;
					}
				}
			}
		}
		if(_canSparkle){
			with(call(scr.obj_create,
				random_range(bbox_left, bbox_right  + 1),
				random_range(bbox_top,  bbox_bottom + 1),
				"VaultFlowerSparkle"
			)){
				sprite_index = spr.QuestSparkle;
				depth		 = other.depth - 1;
			}
		}
	}
	
#define BeetleChest_draw
	/*
		Beetle chests have a visual effect when Beetle's ultra A is active and they have an ammo supply
	*/
	
	if(ultra_get(mod_current, ultA) > 0 && "player_beetle_chest_info_list" in GameCont){
		for(var _playerIndex = 0; _playerIndex < maxp; _playerIndex++){
			if(player_is_active(_playerIndex) && GameCont.player_beetle_chest_info_list[_playerIndex].has_blast){
				draw_sprite(sprGunWarrant, current_frame * 0.4, x, y);
				break;
			}
		}
	}
	
#define BeetleChest_open
	/*
		Beetle chests drop their stored weapon and become closable
	*/
	
	var	_target    = other,
		_chestOpen = call(scr.obj_create, x, y, "BeetleChestOpen");
		
	 // Become Openable:
	with(_chestOpen){
		sprite_index = other.spr_dead;
		spr_shadow   = other.spr_shadow;
		spr_shadow_x = other.spr_shadow_x;
		spr_shadow_y = other.spr_shadow_y;
		image_xscale = other.image_xscale;
		image_yscale = other.image_yscale;
		image_angle  = other.image_angle;
		image_blend  = other.image_blend;
		image_alpha  = other.image_alpha;
		mask_index   = ((other.mask_index < 0) ? other.sprite_index : other.mask_index);
		if(instance_is(_target, Player)){
			index = _target.index;
		}
	}
	spr_dead = -1;
	
	 // Drop Weapon:
	if(instance_is(_target, Player) && "player_beetle_chest_info_list" in GameCont){
		var	_beetleChest    = GameCont.player_beetle_chest_info_list[_target.index],
			_beetleChestWep = _beetleChest.wep;
			
		if(_beetleChestWep != wep_none){
			with(call(scr.obj_create, x, y, "WepPickupGrounded")){
				target = instance_create(x, y, WepPickup);
				with(target){
					ammo = _beetleChest.has_ammo;
					wep  = _beetleChestWep;
					
					 // Ultra Ammo Supply:
					if(ammo > 0 && ultra_get(mod_current, ultA) > 0){
						with(_target){
							call(scr.motion_step, self, 1);
							repeat(2){
								event_perform(ev_collision, WepPickup);
								if(instance_exists(other)){
									other.ammo = _beetleChest.has_ammo;
								}
								else break;
							}
							call(scr.motion_step, self, -1);
						}
					}
				}
			}
			_beetleChest.wep = wep_none;
		}
		
		 // Ultra Blast:
		if(_beetleChest.has_blast && ultra_get(mod_current, ultA) > 0){
			_beetleChest.has_blast = false;
			
			 // Clear Walls:
			instance_create(x, y, PortalClear);
			
			 // Fire Shots:
			for(var _fireRotation = 360 / 3; _fireRotation <= 360; _fireRotation += 360 / 3){
				call(scr.player_fire_at,
					{ "x": x, "y": y },
					{ "rotation": _fireRotation },
					undefined,
					call(scr.data_clone, _beetleChestWep, infinity),
					undefined,
					_target,
					true
				);
				
				 // Weapon Part Effects:
				with(_chestOpen){
					repeat(3){
						with(call(scr.fx, x, y, [_target.gunangle + _fireRotation, 3], "BoneFX")){
							sprite_index = spr.BackpackDebris;
							image_index  = random(image_number);
							creator      = other;
						}
					}
				}
			}
			
			 // Character Sound:
			sound_play(_target.snd_chst);
		}
		
		 // Ammo Supply Sound:
		if(_beetleChest.has_ammo){
			_beetleChest.has_ammo = false;
			snd_open = (
				(ultra_get(mod_current, ultA) > 0)
				? sndBigWeaponChest
				: sndWeaponChest
			);
		}
	}
	
	
#define BeetleChestOpen_create(_x, _y)
	/*
		An opened beetle chest, which can close back up to store its weapon
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.QuestChestOpen;
		spr_shadow   = shd32;
		spr_shadow_x = 0;
		spr_shadow_y = -1;
		depth        = 1;
		
		 // Vars:
		index  = -1;
		target = noone;
		prompt = call(scr.prompt_create, self, loc("NTTE:PetMimic:Prompt", "DROP"));
		with(prompt){
			visible = false;
		}
		
		return self;
	}
	
#define BeetleChestOpen_step
	/*
		Beetle chests close when they aren't being held open
	*/
	
	var	_isEmpty = (
			player_is_active(index)
			&& ("player_beetle_chest_info_list" not in GameCont || GameCont.player_beetle_chest_info_list[index].wep == wep_none)
			&& (!place_meeting(x, y, WepPickup) || !array_length(call(scr.instances_meeting_instance, self, instances_matching_le(instances_matching(WepPickup, "visible", true), "curse", 0))))
		),
		_isOpen = (
			(_isEmpty && array_length(instances_matching(Player, "visible", true)) == 1)
			|| place_meeting(x, y, Player)
			|| place_meeting(x, y, PortalShock)
		);
		
	if(_isOpen){
		 // Player Dropping Weapon:
		if(instance_exists(prompt)){
			prompt.visible = _isEmpty;
			if(_isEmpty){
				with(player_find(prompt.pick)){
					if(canpick && wep != wep_none){
						if(curse <= 0){
							with(instance_create(other.x, other.y, WepPickup)){
								wep = other.wep;
								
								 // Sound:
								sound_play_hit(
									((wep == wep_guitar) ? sndGuitarPickup : sndWeaponPickup),
									0.1
								);
							}
							wep   = wep_none;
							curse = 0;
							call(scr.player_swap, self);
							clicked = false;
						}
						else sound_play_hit(sndCursedReminder, 0.05);
					}
				}
			}
		}
	}
	
	 // Close:
	else instance_destroy();
	
#define BeetleChestOpen_destroy
	/*
		Open beetle chests become closed beetle chests when destroyed
	*/
	
	with(call(scr.obj_create, x, y, "BeetleChest")){
		spr_shadow   = other.spr_shadow;
		spr_shadow_x = other.spr_shadow_x;
		spr_shadow_y = other.spr_shadow_y;
		image_xscale = other.image_xscale;
		image_yscale = other.image_yscale;
		image_angle  = other.image_angle;
		image_blend  = other.image_blend;
		image_alpha  = other.image_alpha;
		
		 // Effects:
		for(var _dir = 202.5; _dir < 360; _dir += 45){
			with(call(scr.fx, x, y, [_dir, 3], Dust)){
				depth = other.depth - 1;
			}
		}
		sound_play_pitchvol(sndMimicMelee, 1 + orandom(0.1), 2/3);
	}
	
#define BeetleChestOpen_cleanup
	/*
		Open beetle chests store the nearest available weapon pickup when they stop existing
	*/
	
	if(player_is_active(index)){
		if("player_beetle_chest_info_list" not in GameCont){
			GameCont.player_beetle_chest_info_list = [];
			repeat(maxp){
				array_push(GameCont.player_beetle_chest_info_list, {
					"wep"       : wep_none,
					"has_ammo"  : true,
					"has_blast" : true
				});
			}
		}
		var _beetleChest = GameCont.player_beetle_chest_info_list[index];
		if(_beetleChest.wep == wep_none){
			with(call(scr.instance_nearest_array, x, y, instances_matching_le(instances_matching(WepPickup, "visible", true), "curse", 0))){
				if(place_meeting(x, y, other) || !collision_line(x, y, other.x, other.y, Wall, false, false)){
					_beetleChest.wep      = wep;
					_beetleChest.has_ammo = ammo;
					
					 // Effects:
					for(var _dir = 22.5; _dir < 180; _dir += 45){
						with(call(scr.fx, x, y, [_dir, 3], Dust)){
							depth = 0;
						}
					}
					
					instance_destroy();
				}
			}
		}
	}
	
	
/// GENERAL
#define ntte_draw_shadows
	 // Open Beetle Chest:
	if(array_length(obj.BeetleChestOpen)){
		with(instances_matching(obj.BeetleChestOpen, "visible", true)){
			draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
		}
	}
	
	
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