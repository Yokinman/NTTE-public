#define init
	 // Sprites:
	global.sprWep        = sprite_add_weapon("../sprites/weps/sprScythe.png",   5, 7);
	global.sprWepHUD     = sprite_add_weapon("../sprites/weps/sprScythe.png",  10, 7);
	global.sprShotbow    = sprite_add_weapon("../sprites/weps/sprShotbow.png",  6, 3);
	global.sprSlugbow    = sprite_add_weapon("../sprites/weps/sprSlugbow.png",  6, 5);
	global.sprSlugbowHUD = sprite_add_weapon("../sprites/weps/sprSlugbow.png", 11, 5);
	global.sprWepLocked	 = mskNone;
	
	 // LWO:
	global.lwoWep = {
		"wep"   : mod_current,
		"ammo"  : 0,
		"amax"  : 55,
		"amin"  : 4,
		"anam"  : "BONES",
		"buff"  : false,
		"mode"  : scythe_basic,
		"cost"  : 0,
		"combo" : 0
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
		"melee"    : true
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
	
#define scythe_swap(_primary)
	/*
		Called from a Player to cycle to their scythe's next mode
		If not holding a scythe in the given slot, a scythe is set to that slot
	*/
	
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // Give Scythe:
	if(wep_raw(_wep) != mod_current){
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
			_wep = lq_clone(global.lwoWep);
			wep_set(_primary, "wep", _wep);
		}
		
		 // Swap:
		_wep.mode = max(0, ++_wep.mode % array_length(scythe_mode));
		_wep.cost = scythe_get(_wep, "cost");
		
		 // Sound:
		sound_play(weapon_get_swap(_wep));
		sound_play_hit(sndMutant14Turn, 0.1);
		sound_play_hit_ext(sndFishWarrantEnd, 1 + random(0.2), 4);
	}
	if(_primary){
		clicked = false;
	}
	
	 // Effects:
	swapmove = 1;
	if(visible && !instance_exists(GenCont) && !instance_exists(LevCont)){
		wep_set(_primary, "wkick", -3);
		gunshine = 1;
		
		 // !
		with(instance_create(x, y, PopupText)){
			text = weapon_get_name(_wep) + "!";
			target = other.index;
		}
		
		 // Bone Piece Effects:
		var	_num = 8 - array_length(instances_matching(instances_matching(Shell, "name", "BoneFX"), "creator", id)),
			_l   = 12,
			_d   = gunangle + wep_get(_primary, "wepangle", 0);
			
		if(_num > 0) repeat(_num){
			with(scrFX(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), [_d, 1], "BoneFX")){
				creator = other;
			}
		}
		
		_l = 8;
		
		repeat(6){
			with(scrFX(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), [_d + orandom(60), 1 + random(5)], Dust)){
				depth = -3;
			}
		}
	}
	
#define scythe_swap_step
	for(var i = 0; i < maxp; i++){
		if(button_pressed(i, "pick")){
			with(instances_matching(Player, "index", i)){
				if(wep_raw(wep) == mod_current && nearwep == noone){
					 // Swap:
					scythe_swap(true);
					
					 // Silence:
					mod_variable_set("mod", "ntte", "scythe_tip_index", -1);
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
#define weapon_avail        return unlock_get("wep:" + mod_current);
#define weapon_unlock       return "A PACKAGE DEAL";
#define weapon_shrine       return [mut_long_arms, mut_shotgun_shoulders, mut_bolt_marrow];

#define weapon_sprt_hud(_wep)
	 // Custom Ammo HUD:
	weapon_ammo_hud(_wep);
	
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
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Mode Specific:
	switch(_wep.mode){
		
		case scythe_basic:
			
			var	_skill = skill_get(mut_long_arms),
				_heavy = ((++_wep.combo % 3) == 0),
				_flip  = sign(wepangle),
				_dis   = lerp(10, 20, _skill),
				_dir   = gunangle + orandom(4 * accuracy);
				
			 // Slash:
			with(projectile_create(
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
			
			if(weapon_ammo_fire(_wep)){
				var	_dir = gunangle + orandom(12 * accuracy),
					_off = 20 * accuracy;
					
				 // Bone Arrows:
				for(var i = -1; i <= 1; i++){
					projectile_create(x, y, "BoneArrow", _dir + (i * _off), 16);
				}
				
				 // Sounds:
				sound_play_pitchvol(sndSuperCrossbow,      0.9 + random(0.3), 0.5);
				sound_play_pitchvol(sndBloodLauncherExplo, 1.2 + random(0.3), 0.5);
				
				 // Effects:
				weapon_post(6, 3, 7);
				sleep(4);
			}
			
			break;
			
		case scythe_slugbow:
			
			if(weapon_ammo_fire(_wep)){
				var _dir = gunangle + orandom(4 * accuracy);
				
				 // Slug Bolt:
				with(projectile_create(x, y, "BoneArrow", _dir, 20)){
					big = true;
				}
				
				 // Sounds:
				sound_play_pitchvol(sndHeavyCrossbow, 0.9 + random(0.3), 2/3);
				sound_play_pitchvol(sndBloodHammer,   1.1 + random(0.2), 2/3);
				
				 // Effects:
				motion_add((gunangle + 180), 3);
				weapon_post(12, 17, 15);
				sleep(40);
			}
			
			break;
			
	}
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // LWO Setup:
	if(!is_object(_wep)){
		_wep = lq_clone(global.lwoWep);
		wep_set(_primary, "wep", _wep);
	}
	
	 // Back Muscle:
	with(_wep){
		var _muscle = skill_get(mut_back_muscle);
		if(buff != _muscle){
			var _amaxRaw = (amax / (1 + (0.8 * buff)));
			buff = _muscle;
			amax = (_amaxRaw * (1 + (0.8 * buff)));
			ammo += (amax - _amaxRaw);
		}
	}
	
	 // Big Ammo:
	if(instance_exists(WepPickup) && place_meeting(x, y, WepPickup)){
		var _inst = instances_meeting(x, y, instances_matching_le(instances_matching(WepPickup, "visible", true), "curse", wep_get(_primary, "curse", 0)));
		if(array_length(_inst)) with(_inst){
			if(place_meeting(x, y, other)){
				if(wep_raw(wep) == "crabbone"){
					var _num = lq_defget(wep, "ammo", 1);
					_wep.ammo = min(_wep.ammo + (20 * _num), _wep.amax);
					
					 // Pickuped:
					with(other){
						if(!_primary && race != "steroids"){
							mod_script_call("mod", "tepickups", "pickup_text", "% BONE", _num);
						}
					}
					
					 // Effects:
					with(instance_create(x, y, DiscDisappear)){
						image_angle = other.rotation;
					}
					sound_play_pitchvol(sndHPPickup, 4, 0.6);
					sound_play_pitchvol(sndPickupDisappear, 1.2, 0.6);
					sound_play_pitchvol(sndBloodGamble, 0.4 + random(0.2), 0.4);
					
					instance_destroy();
				}
			}
		}
	}
	
	 // Bind End Step:
	if(array_length(instances_matching(CustomScript, "name", "scythe_swap_step")) <= 0){
		with(script_bind_end_step(scythe_swap_step, 0)){
			name = script[2];
			persistent = true;
		}
	}
	
	
/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define projectile_create(_x, _y, _obj, _dir, _spd)                                     return  mod_script_call_self('mod', 'telib', 'projectile_create', _x, _y, _obj, _dir, _spd);
#define weapon_fire_init(_wep)                                                          return  mod_script_call     ('mod', 'telib', 'weapon_fire_init', _wep);
#define weapon_ammo_fire(_wep)                                                          return  mod_script_call     ('mod', 'telib', 'weapon_ammo_fire', _wep);
#define weapon_ammo_hud(_wep)                                                           return  mod_script_call     ('mod', 'telib', 'weapon_ammo_hud', _wep);
#define weapon_get_red(_wep)                                                            return  mod_script_call_self('mod', 'telib', 'weapon_get_red', _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call_self('mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc  ('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define sound_play_hit_ext(_snd, _pit, _vol)											return  mod_script_call_self('mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);