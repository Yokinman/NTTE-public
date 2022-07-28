#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Store Script References:
	scr.scythe_swap = script_ref_create(scythe_swap);
	
	 // Sprites:
	global.sprWep        = sprite_add_weapon("../sprites/weps/sprScythe.png",   5, 7);
	global.sprWepHUD     = sprite_add_weapon("../sprites/weps/sprScythe.png",  10, 7);
	global.sprShotbow    = sprite_add_weapon("../sprites/weps/sprShotbow.png",  6, 3);
	global.sprSlugbow    = sprite_add_weapon("../sprites/weps/sprSlugbow.png",  6, 5);
	global.sprSlugbowHUD = sprite_add_weapon("../sprites/weps/sprSlugbow.png", 11, 5);
	global.sprWepLocked	 = sprTemp;
	
	 // LWO:
	global.lwoWep = {
		"wep"      : mod_current,
		"ammo"     : 0,
		"amax"     : 55,
		"amin"     : 4,
		"anam"     : "BONES",
		"buff"     : false,
		"mode"     : scythe_basic,
		"cost"     : 0,
		"combo"    : 0,
		"autoswap" : false
	};
	
	 // Modes:
	scythe_mode = [];
	scythe_mode[scythe_basic] = {
		"name"     : "BONE SCYTHE",
		"text"     : "@rREASSEMBLED",
		"sprt"     : global.sprWep,
		"sprt_hud" : global.sprWepHUD,
		"swap"     : sndBloodGamble,
		"cost"     : 0,
		"load"     : 12, // 0.4 Seconds
		"auto"     : true,
		"melee"    : true
	};
	scythe_mode[scythe_shotbow] = {
		"name"     : "BONE SHOTBOW",
		"text"     : "@wMARROW @sFROM A HUNDRED @gMUTANTS",
		"sprt"     : global.sprShotbow,
		"sprt_hud" : global.sprShotbow,
		"swap"     : sndSwapMachinegun,
		"cost"     : 5,
		"load"     : 18, // 0.6 Seconds
		"auto"     : true,
		"melee"    : false
	};
	scythe_mode[scythe_slugbow] = {
		"name"     : "BONE SLUGBOW",
		"text"     : "@gRADIATION@s DETERIORATES @wBONES",
		"sprt"     : global.sprSlugbow,
		"sprt_hud" : global.sprSlugbowHUD,
		"swap"     : sndSwapMotorized,
		"cost"     : 5,
		"load"     : 15, // 0.5 Seconds
		"auto"     : false,
		"melee"    : false
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro scythe_mode    global.scythe_mode
#macro scythe_basic   0
#macro scythe_shotbow 1
#macro scythe_slugbow 2

#define scythe_get(_wep, _field)
	/*
		Returns a given field from the given LWO weapon
		Defaults to a basic scythe's value if the field isn't found
	*/
	
	return lq_defget(scythe_mode[lq_defget(_wep, "mode", scythe_basic)], _field, lq_defget(scythe_mode[scythe_basic], _field, 0));
	
#define scythe_swap // primary=true, ?mode
	/*
		Called from a Player to change their scythe's mode
		If not holding a scythe in the given slot, a scythe is set to that slot
		
		Args:
			primary - The weapon slot that the scythe is held in, primary (true) or secondary (false)
			mode    - The mode to set the scythe to, leave undefined to increment the mode by 1
	*/
	
	var	_primary = ((argument_count > 0) ? argument[0] : true),
		_mode    = ((argument_count > 1) ? argument[1] : undefined);
		
	with((instance_is(self, FireCont) && "creator" in self) ? creator : self){
		var _wep = wep_get(_primary, "wep", mod_current);
		
		 // Give Scythe:
		if(call(scr.wep_raw, _wep) != mod_current){
			_wep = mod_current;
			wep_set(_primary, "wep", _wep);
			
			 // Sound:
			sound_play_pitch(weapon_get_swap(_wep), 0.5);
			sound_play_pitchvol(sndCursedChest, 0.9, 2);
			sound_play_pitchvol(sndFishWarrantEnd, 1.2, 2);
		}
		
		 // Swap Scythe:
		else{
			 // LWO Setup:
			if(!is_object(_wep)){
				_wep = { "wep" : _wep };
				wep_set(_primary, "wep", _wep);
			}
			for(var i = lq_size(global.lwoWep) - 1; i >= 0; i--){
				var _key = lq_get_key(global.lwoWep, i);
				if(_key not in _wep){
					lq_set(_wep, _key, lq_get_value(global.lwoWep, i));
				}
			}
			
			 // Swap:
			_wep.mode     = max(0, (is_undefined(_mode) ? ++_wep.mode : _mode) % array_length(scythe_mode));
			_wep.cost     = scythe_get(_wep, "cost");
			_wep.autoswap = false;
			
			 // Sound:
			sound_play(weapon_get_swap(_wep));
			sound_play_hit(sndMutant14Turn, 0.1);
			call(scr.sound_play_at, x, y, sndFishWarrantEnd, 1 + random(0.2), 4);
		}
		wep_set(_primary, "clicked", false);
		
		 // Effects:
		if("swapmove" in self){
			swapmove = 1;
		}
		if(visible && !instance_exists(GenCont) && !instance_exists(LevCont)){
			wep_set(_primary, "wkick", -3);
			if("gunshine" in self){
				gunshine = 1;
			}
			
			 // !
			call(scr.pickup_text, weapon_get_name(_wep), "got");
			
			 // Bone Piece Effects:
			var	_num = 8 - array_length(instances_matching(obj.BoneFX, "creator", self)),
				_l   = 12,
				_d   = gunangle + wep_get(_primary, "wepangle", 0);
				
			if(_num > 0) repeat(_num){
				with(call(scr.fx, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), [_d, 1], "BoneFX")){
					creator = other;
				}
			}
			
			_l = 8;
			
			repeat(6){
				with(call(scr.fx, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), [_d + orandom(60), 1 + random(5)], Dust)){
					depth = -3;
				}
			}
		}
	}
	
#define ntte_end_step
	 // Swap Scythe Mode:
	if(instance_exists(Player)){
		for(var i = 0; i < maxp; i++){
			if(button_pressed(i, "pick")){
				with(instances_matching(instances_matching(Player, "index", i), "nearwep", noone)){
					if(call(scr.wep_raw, wep) == mod_current){
						 // Swap:
						scythe_swap();
						
						 // Silence:
						GameCont.ntte_scythe_tip_index = -1;
					}
				}
			}
		}
	}
	
#define weapon_name(_wep)   return (weapon_avail() ? scythe_get(_wep, "name") : "LOCKED");
#define weapon_text(_wep)   return scythe_get(_wep, "text");
#define weapon_swap(_wep)   return scythe_get(_wep, "swap");
#define weapon_sprt(_wep)   return (weapon_avail() ? scythe_get(_wep, "sprt") : global.sprWepLocked);
#define weapon_area         return (weapon_avail() ? 19 : -1); // 1-2 L1
#define weapon_type         return type_melee;
#define weapon_load(_wep)   return scythe_get(_wep, "load");
#define weapon_auto(_wep)   return scythe_get(_wep, "auto");
#define weapon_melee(_wep)  return scythe_get(_wep, "melee");
#define weapon_avail        return call(scr.unlock_get, "wep:" + mod_current);
#define weapon_unlock       return "A PACKAGE DEAL";
#define weapon_shrine       return [mut_long_arms, mut_shotgun_shoulders, mut_bolt_marrow];

#define weapon_sprt_hud(_wep)
	 // Custom Ammo HUD:
	call(scr.weapon_ammo_hud, _wep);
	
	 // HUD Sprite:
	return scythe_get(_wep, "sprt_hud");
	
#define weapon_ntte_eat
	 // Partial Refund:
	repeat(3){
		with(instance_create(x, y, WepPickup)){
			wep = "crabbone";
		}
	}
	
	 // Sound:
	sound_play_pitchvol(sndMutant14Dead, 1.4, 0.5);
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	if(call(scr.weapon_ammo_fire, _wep)){
		_wep.autoswap = false;
		
		 // Mode Specific:
		switch(_wep.mode){
			
			case scythe_basic:
				
				var	_skill = skill_get(mut_long_arms),
					_heavy = ((++_wep.combo % 3) == 0),
					_flip  = sign(wepangle),
					_dis   = lerp(10, 20, _skill),
					_dir   = gunangle + orandom(4 * accuracy);
					
				 // Slash:
				with(call(scr.projectile_create,
					x + hspeed + lengthdir_x(_dis, _dir),
					y + vspeed + lengthdir_y(_dis, _dir),
					"BoneSlash",
					_dir,
					lerp(2.5, 4.5, _skill)
				)){
					image_yscale *= _flip;
					rotspeed      = 3 * _flip;
					heavy         = _heavy;
				}
				
				 // Sounds:
				sound_play_pitchvol(sndBlackSword, 0.8 + random(0.3), 1);
				if(_heavy){
					sound_play_pitchvol(sndHammer,     1 - random(0.2),   0.6);
					sound_play_pitchvol(sndSwapHammer, 1.3 + random(0.2), 0.6);
				}
				
				 // Effects:
				motion_add(_dir + (30 * _flip), 3 + _heavy);
				weapon_post((_heavy ? -5 : 5), 6 + (10 * _heavy), 2);
				if(_heavy) sleep(12);
				
				break;
				
			case scythe_shotbow:
				
				var	_dir = gunangle + orandom(12 * accuracy),
					_off = 20 * accuracy;
					
				 // Bone Arrows:
				for(var i = -1; i <= 1; i++){
					call(scr.projectile_create, x, y, "BoneArrow", _dir + (i * _off), 16);
				}
				
				 // Sounds:
				sound_play_pitchvol(sndSuperCrossbow,      0.9 + random(0.3), 0.5);
				sound_play_pitchvol(sndBloodLauncherExplo, 1.2 + random(0.3), 0.5);
				
				 // Effects:
				weapon_post(6, 3, 7);
				sleep(4);
				
				break;
				
			case scythe_slugbow:
				
				var _dir = gunangle + orandom(4 * accuracy);
				
				 // Slug Bolt:
				with(call(scr.projectile_create, x, y, "BoneArrow", _dir, 20)){
					big = true;
				}
				
				 // Sounds:
				sound_play_pitchvol(sndHeavyCrossbow, 0.9 + random(0.3), 2/3);
				sound_play_pitchvol(sndBloodHammer,   1.1 + random(0.2), 2/3);
				
				 // Effects:
				motion_add(gunangle + 180, 3);
				weapon_post(12, 17, 15);
				sleep(40);
				
				break;
				
		}
	}
	
	 // No Ammo, Auto Swap:
	else if(!player_is_active(index) || button_pressed(index, "fire")){
		if(_wep.autoswap){
			scythe_swap(true, scythe_basic);
		}
		else _wep.autoswap = true;
	}
	
#define step(_primary)
	var _wep = call(scr.weapon_step_init, _primary);
	
	 // Back Muscle:
	with(_wep){
		var _muscle = skill_get(mut_back_muscle);
		if(buff != _muscle){
			var _amaxRaw = (amax / (1 + (0.8 * buff)));
			buff  = _muscle;
			amax  = (_amaxRaw * (1 + (0.8 * buff)));
			ammo += (amax - _amaxRaw);
		}
	}
	
	 // Big Ammo:
	if(instance_exists(WepPickup) && place_meeting(x, y, WepPickup)){
		var _inst = call(scr.instances_meeting_instance, self, instances_matching_le(instances_matching(WepPickup, "visible", true), "curse", wep_get(_primary, "curse", 0)));
		if(array_length(_inst)) with(_inst){
			if(place_meeting(x, y, other)){
				if(call(scr.wep_raw, wep) == "crabbone"){
					var _num = lq_defget(wep, "ammo", 1);
					_wep.ammo = min(_wep.ammo + (20 * _num), _wep.amax);
					
					 // Pickuped:
					with(other){
						if(!_primary && race != "steroids"){
							call(scr.pickup_text, loc("NTTE:Bone", "BONE"), "add", _num);
						}
					}
					
					 // Effects:
					with(instance_create(x, y, DiscDisappear)){
						image_angle = other.rotation;
					}
					sound_play_pitchvol(sndHPPickup,        4.0,               0.6);
					sound_play_pitchvol(sndPickupDisappear, 1.2,               0.6);
					sound_play_pitchvol(sndBloodGamble,     0.4 + random(0.2), 0.4);
					
					instance_destroy();
				}
			}
		}
	}
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  obj                                                                                     global.obj
#macro  scr                                                                                     global.scr
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    ((current_frame + global.epsilon) % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        if(((_primary ? '' : 'b') + _name) in self) variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);