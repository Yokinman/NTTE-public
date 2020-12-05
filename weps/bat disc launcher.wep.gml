#define init
	 // Sprites:
	global.sprWep       = sprTemp;
	global.sprWepAmmo   = [];
	global.sprWepHoming = sprite_add_weapon("../sprites/weps/sprBatDiscLauncherHoming.png", 6, 5);
	global.sprWepLocked = mskNone;
	
	 // Manually Split Sprite:
	if(fork()){
		var _path = "../sprites/weps/sprBatDiscLauncher.png";
		
		file_load(_path);
		
		while(!file_loaded(_path)){
			wait 0;
		}
		
		if(file_exists(_path)){
			var	_spr  = sprite_add(_path, 4, 6, 5),
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
		"wep"     : mod_current,
		"ammo"    : 3,
		"amax"    : 3,
		"anam"    : "SAWBLADES",
		"cost"    : 1,
		"buff"    : false,
		"canload" : true
	};
	
#define weapon_name            return (weapon_avail() ? "SAWBLADE GUN" : "LOCKED");
#define weapon_text            return "LIKE DISCS BUT @ySMARTER";
#define weapon_swap            return sndSwapShotgun;
#define weapon_sprt_hud(_wep)  return weapon_ammo_hud(_wep);
#define weapon_area            return (weapon_avail() ? 5 : -1); // 2-1
#define weapon_type            return type_melee;
#define weapon_load            return 8; // 0.27 Seconds
#define weapon_auto            return true;
#define weapon_melee           return false;
#define weapon_avail           return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack       return "lair";
#define weapon_shrine          return mut_bolt_marrow;

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

#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Fire:
	if(weapon_ammo_fire(_wep)){
		 // Disc:
		with(projectile_create(x, y, "BatDisc", gunangle + orandom(12 * accuracy), 0)){
			ammo = _wep.cost;
			wep  = _wep;
		}
		
		 // Sounds:
		sound_play_pitchvol(sndSuperDiscGun, 0.8 + random(0.4), 0.6);
		sound_play_pitchvol(sndRocket,       1.0 + random(0.6), 0.8);
		
		 // Effects:
		weapon_post(8, 8, 8);
		motion_set(gunangle + 180, 2);
		repeat(irandom_range(3, 6)){
			with(instance_create(x, y, Smoke)){
				motion_set(other.gunangle + orandom(24), random(6));
			}
		}
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
			var _amaxRaw = (amax / (1 + buff));
			buff = _muscle;
			amax = (_amaxRaw * (1 + buff));
			ammo += (amax - _amaxRaw);
		}
	}
	
	 // Encourage Less Hold-Down-LMouse Play:
	if(_wep.canload){
		if(_wep.ammo <= 0){
			_wep.canload = false;
		}
	}
	if(!_wep.canload){
		if(weapon_is_melee(_wep) ? (_wep.ammo <= 0) : (_wep.ammo < _wep.amax)){
			 // Stop Reloading:
			if(_wep.ammo > 0){
				wep_set(_primary, "reload",    weapon_get_load(_wep));
				wep_set(_primary, "can_shoot", false);
			}
			
			 // Smokin'
			if(current_frame_active){
				var	_x    = x,
					_y    = y,
					_spr  = weapon_get_sprt(_wep),
					_dir  = gunangle + wep_get(_primary, "wepangle", 0),
					_disx = (sprite_get_bbox_right(_spr) - sprite_get_xoffset(_spr)) * 0.75,
					_disy = 2;
					
				if(_primary){
					_disx -= wkick;
				}
				else{
					if(race == "steroids"){
						_disx -= bwkick;
						_disy -= 4;
						_y    -= 4;
					}
					else{
						_dir = 90 + (20 * right);
					}
				}
				
				with(instance_create(
					_x + lengthdir_x(_disx, _dir) + lengthdir_x(_disy, _dir - (90 * right)),
					_y + lengthdir_y(_disx, _dir) + lengthdir_y(_disy, _dir - (90 * right)),
					Smoke
				)){
					hspeed += other.hspeed / 2;
					vspeed += other.vspeed / 2;
					motion_add(_dir, 2);
					image_xscale /= 1.5;
					image_yscale /= 1.5;
					growspeed = -0.015;
					gravity = -0.1;
				}
			}
		}
		
		 // Ammo Returned:
		else _wep.canload = true;
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