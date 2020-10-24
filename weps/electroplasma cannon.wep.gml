#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprElectroPlasmaCannon.png", 5, 6);
	global.sprWepLocked = mskNone;
	
#define weapon_name       return (weapon_avail() ? "ELECTROPLASMA CANNON" : "LOCKED");
#define weapon_text       return "BRAIN EXPANDING";
#define weapon_swap       return sndSwapEnergy;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 9 : -1); // 4-1
#define weapon_type       return type_energy;
#define weapon_cost       return 10;
#define weapon_load       return 50; // 1.66 Seconds
#define weapon_avail      return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "trench";

#define weapon_reloaded
	sound_play(sndLightningReload);
	sound_play_pitch(sndPlasmaReload, 1.5);
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Projectile:
	projectile_create(x, y, "ElectroPlasmaBig", gunangle + orandom(4 * accuracy), 6);
	
	 // Sounds:
	if(skill_get(mut_laser_brain) > 0){
		audio_sound_pitch(
			sound_play_gun(sndLightningShotgunUpg, 0, 0.6),
			0.6 + random(0.2)
		);
		sound_play_pitch(sndPlasmaRifleUpg, 0.5 + random(0.1));
	}
	else{
		audio_sound_pitch(
			sound_play_gun(sndLightningShotgun, 0, 0.3),
			0.6 + random(0.2)
		);
		sound_play_pitch(sndPlasmaRifle, 0.5 + random(0.1));
	}
	
	 // Effects:
	weapon_post(12, 30, 0);
	motion_add(gunangle + 180, 4);
	instance_create(x, y, Smoke);
	
	
	
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