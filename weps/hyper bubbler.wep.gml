#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprHyperBubbler.png", 8, 4);
	global.sprWepLocked = mskNone;
	
#define weapon_name       return (weapon_avail() ? "HYPER BUBBLER" : "LOCKED");
#define weapon_text       return "POWER WASHER";
#define weapon_swap       return sndSwapExplosive;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 15 : -1); // 7-2
#define weapon_type       return type_explosive;
#define weapon_cost       return 3;
#define weapon_load       return 7; // 0.43 Seconds
#define weapon_avail      return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "oasis";

#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Hyper Bubble:
	var	_l = 20,
		_d = gunangle + orandom(3 * accuracy);
		
	projectile_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "HyperBubble", _d, 0);
	
	 // Sounds:
	sound_play_pitchvol(sndPlasmaRifle,  0.9 + random(0.3), 1.0);
	sound_play_pitchvol(sndHyperSlugger, 0.9 + random(0.3), 0.6);
	
	 // Effects:
	weapon_post(10, 20, 5);
	motion_add(_d + 180, 4);
	sleep(35);
	
	
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