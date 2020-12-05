#define init
	 // Sprites:
	global.sprWep       = sprTemp;
	global.sprWepAmmo   = [];
	global.sprWepHoming = sprite_add_weapon("../sprites/weps/sprPizzaCutterHoming.png", 2, 7);
	global.sprWepHUD    = sprite_add_weapon("../sprites/weps/sprPizzaCutterHoming.png", 9, 7);
	global.sprWepLocked = mskNone;
	
	 // Manually Split Sprite:
	if(fork()){
		var _path = "../sprites/weps/sprPizzaCutter.png";
		
		file_load(_path);
		
		while(!file_loaded(_path)){
			wait 0;
		}
		
		if(file_exists(_path)){
			var	_spr  = sprite_add(_path, 3, 2, 7),
				_sprX = sprite_get_xoffset(_spr),
				_sprY = sprite_get_yoffset(_spr),
				_surf = surface_create(sprite_get_width(_spr), sprite_get_height(_spr));
				
			surface_set_target(_surf);
			
			 // Load Each Frame as a Weapon Sprite:
			for(var i = 0; i < sprite_get_number(_spr); i++){
				draw_clear_alpha(0, 0);
				draw_sprite(_spr, i, _sprX, _sprY);
				surface_save(_surf, "sprWep.png");
				array_push(global.sprWepAmmo, sprite_add_weapon("sprWep.png", _sprX, _sprY));
			}
			global.sprWep = global.sprWepAmmo[array_length(global.sprWepAmmo) - 1];
			
			 // Done:
			surface_reset_target();
			surface_destroy(_surf);
			sprite_delete(_spr);
		}
		
		file_unload(_path);
		
		exit;
	}
	
	 // LWO:
	global.lwoWep = {
		"wep"      : mod_current,
		"ammo"     : 1,
		"amax"     : 1,
		"anam"     : "SAWBLADES",
		"cost"     : 1,
		"buff"     : false,
		"canload"  : true,
		"chrg"     : false,
		"chrg_num" : 0,
		"chrg_max" : 9
	};
	
#define weapon_name        return (weapon_avail() ? "PIZZA CUTTER" : "LOCKED");
#define weapon_text        return "FOR THE CIVILIZED TURTLE";
#define weapon_swap        return sndSwapHammer;
#define weapon_area        return (weapon_avail() ? 7 : -1); // 3-2
#define weapon_type        return type_melee;
#define weapon_load        return 24; // 0.8 Seconds
#define weapon_auto(_wep)  return lq_defget(_wep, "canload", false);
#define weapon_melee       return true;
#define weapon_avail       return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack   return "lair";
#define weapon_shrine      return [mut_long_arms, mut_bolt_marrow];
#define weapon_chrg(_wep)  return (argument_count <= 0 || lq_defget(_wep, "canload", true));

#define weapon_sprt(_wep)
	if(weapon_avail()){
		 // Indicators:
		if(is_object(_wep) && array_length(global.sprWepAmmo) > 0){
			var	_ammo = (lq_defget(_wep, "canload", false) ? lq_defget(_wep, "ammo", 0) : 0),
				_amax = lq_defget(_wep, "amax", 1),
				_cost = lq_defget(_wep, "cost", 1);
				
			 // Homing:
			if(_ammo < _cost && instance_exists(CustomObject)){
				if(array_length(instances_matching(instances_matching(instances_matching(CustomProjectile, "name", "BatDisc"), "wep", _wep), "image_index", 1))){
					return global.sprWepHoming;
				}
			}
			
			 // Ammo:
			return global.sprWepAmmo[ceil(clamp((floor(_ammo / _cost) * _cost) / _amax, 0, 1) * (array_length(global.sprWepAmmo) - 1))];
		}
		
		 // Normal:
		return global.sprWep;
	}
	
	 // Locked:
	return global.sprWepLocked;
	
#define weapon_sprt_hud(_wep)  
	weapon_ammo_hud(_wep);
	return global.sprWepHUD;
	
#define weapon_reloaded(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	if(lq_defget(_wep, "chrg", false)){
		wep_set(_primary, "wepflip", -wep_get(_primary, "wepflip", 1));
	}
	else{
		sound_play(sndMeleeFlip);
	}
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	var _num = (_wep.chrg_num / _wep.chrg_max);
	
	 // Charging:
	if(_wep.chrg){
		 // Pullback:
		var _kick = -3 * _num;
		if(wkick != _kick){
			weapon_post(_kick, 8 * _num * current_time_scale, 0);
		}
		
		 // Effects:
		if(_wep.chrg == 1){
			sound_play_pitch(sndMeleeFlip, 1 / (1 - (0.25 * _num)));
			sound_play_pitchvol(sndSwapBow, 0.3 + (2 * _num), 0.3);
			
			 // Full:
			if(_num >= 1){
				var	_l = 16,
					_d = gunangle;
					
				instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), ThrowHit);
				instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), ImpactWrists);
				sound_play_pitch(sndCrystalRicochet, 3);
				sound_play_pitch(sndSewerDrip,       3);
				sleep(5);
			}
		}
		
		 // Fully Charged - Blink:
		else if((current_frame % 12) < current_time_scale){
			with(_fire.creator) if(instance_is(self, Player)){
				gunshine = 2;
			}
		}
	}
	
	 // Charged Disc Slash:
	else if(_num > 0){
		var _skill = skill_get(mut_long_arms),
			_len   = (20 * _skill),
			_dir   = gunangle + orandom(8 * accuracy);
			
		with(projectile_create(
			x + lengthdir_x(_len, _dir),
			y + lengthdir_y(_len, _dir),
			Slash,
			_dir,
			3 + (2 * _skill)
		)){
			sprite_index = sprHeavySlash;
			damage       = 20;
		}
		
		 // Sounds:
		var _pitch = random_range(0.8, 1.2);
		sound_play_pitchvol(sndDiscHit, 1.7 * _pitch, 1.0);
		sound_play_pitchvol(sndHammer,  0.8 * _pitch, 1.4);
		sound_play_pitchvol(sndShovel,  1.5 * _pitch, 0.3);
		
		 // Effects:
		weapon_post(-4, -5, 8);
		motion_add(_dir, 3.5);
		sleep(15);
		
		 // Fully Charged - Launch Disc:
		if(_num >= 1){
			if(weapon_ammo_fire(_wep)){
				with(projectile_create(x, y, "BatDisc", gunangle + orandom(4 * accuracy), 0)){
					ammo = _wep.cost;
					wep  = _wep;
				}
			}
			weapon_post(8, 40, 5);
		}
	}
	
	 // Disc-less Slash:
	else{
		var _skill = skill_get(mut_long_arms),
			_len   = 20 * _skill,
			_dir   = gunangle + orandom(8 * accuracy);
			
		with(projectile_create(
			x + lengthdir_x(_len, _dir),
			y + lengthdir_y(_len, _dir),
			Slash,
			_dir,
			3 + (2 * _skill)
		)){
			damage = 8;
			force  = 6;
		}
		
		 // Sounds:
		var _pitch = random_range(0.8, 1.2);
		sound_play_pitchvol(sndDiscBounce, 1.2 * _pitch, 0.7);
		sound_play_pitchvol(sndHammer,     1.4 * _pitch, 1.4);
		sound_play_pitchvol(sndWrench,     0.8 * _pitch, 0.3);
		
		 // Effects:
		weapon_post(-4, -5, 8);
		motion_add(_dir, 3.5);
	}
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // LWO Setup:
	if(!is_object(_wep)){
		_wep = lq_clone(global.lwoWep);
		wep_set(_primary, "wep", _wep);
	}
	
	 // Inherit:
	mod_script_call("weapon", "bat disc launcher", "step", _primary);
	
	
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
#define player_swap()                                                                   return  mod_script_call_self('mod', 'telib', 'player_swap');