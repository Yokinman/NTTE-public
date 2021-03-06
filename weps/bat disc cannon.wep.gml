#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add(       "../sprites/weps/sprBatDiscCannon.png",       5, 13, 6);
	global.sprWepHoming = sprite_add_weapon("../sprites/weps/sprBatDiscCannonHoming.png",    13, 6);
	global.sprWepLocked = sprTemp;
	global.sprWepImage  = [];
	
	 // LWO:
	global.lwoWep = {
		"wep"     : mod_current,
		"ammo"    : 14,
		"amax"    : 14,
		"anam"    : "SAWBLADES",
		"cost"    : 7,
		"buff"    : false,
		"canload" : true
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name            return (weapon_avail() ? "SAWBLADE CANNON" : "LOCKED");
#define weapon_text            return "THEY STAND NO CHANCE";
#define weapon_swap            return sndSwapMotorized;
#define weapon_sprt_hud(_wep)  return weapon_ammo_hud(_wep);
#define weapon_area            return (weapon_avail() ? 11 : -1); // 5-2
#define weapon_type            return type_melee;
#define weapon_load            return 20; // 0.66 Seconds
#define weapon_auto            return true;
#define weapon_melee           return false;
#define weapon_avail           return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack       return "lair";
#define weapon_shrine          return mut_bolt_marrow;

#define weapon_sprt(_wep)
	if(weapon_avail()){
		 // Indicators:
		if(is_object(_wep) && array_length(global.sprWepImage)){
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
			return global.sprWepImage[ceil(clamp((floor(_ammo / _cost) * _cost) / _amax, 0, 1) * (array_length(global.sprWepImage) - 1))];
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
		with(projectile_create(x, y, "BatDisc", gunangle + orandom(4 * accuracy), 0)){
			ammo = _wep.cost;
			wep  = _wep;
			big  = true;
		}
		
		 // Sounds:
		sound_play_pitchvol(sndSuperDiscGun,    0.6 + random(0.4), 0.6);
		sound_play_pitchvol(sndNukeFire,        1.0 + random(0.6), 0.8);
		sound_play_pitchvol(sndEnergyHammerUpg, 0.8 + random(0.4), 0.6);
		
		 // Effects:
		weapon_post(12, 16, 12);
		motion_set(gunangle + 180, 4);
		repeat(irandom_range(4, 8)){
			with(instance_create(x, y, Smoke)){
				motion_set(other.gunangle + orandom(32), random(8));
			}
		}
	}
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
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
#define weapon_get(_name, _wep)                                                         return  mod_script_call     ('mod', 'telib', 'weapon_get', _name, _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);