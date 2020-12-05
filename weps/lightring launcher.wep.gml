#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprLightningRingLauncher.png", 6, 3);
	global.sprWepLocked = mskNone;
	
#define weapon_name       return (weapon_avail() ? "LIGHTRING LAUNCHER" : "LOCKED");
#define weapon_text       return "JELLY TECHNOLOGY";
#define weapon_swap       return sndSwapEnergy;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_type       return type_energy;
#define weapon_cost       return 3;
#define weapon_load       return 37; // 1.23 Seconds
#define weapon_auto       return true;
#define weapon_avail      return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "trench"

#define weapon_reloaded
	sound_play(sndLightningReload);
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Lightning Disc:
	with(projectile_create(x, y, "LightningDisc", gunangle, 10)){
		primary = _fire.primary;
	}
	
	 // Sounds:
	sound_play_pitchvol(sndLightningCannonUpg, 0.5, 0.4);
	
	
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