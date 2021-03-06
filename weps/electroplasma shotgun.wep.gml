#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprElectroPlasmaShotgun.png", 2, 6);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name       return (weapon_avail() ? "ELECTROPLASMA SHOTGUN" : "LOCKED");
#define weapon_text       return "WHERE'S THE PEANUT BUTTER";
#define weapon_swap       return sndSwapEnergy;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 8 : -1); // 3-3
#define weapon_type       return type_energy;
#define weapon_cost       return 8;
#define weapon_load       return 27; // 0.9 Seconds
#define weapon_avail      return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "trench";

#define weapon_reloaded
	sound_play(sndLightningReload);
	sound_play_pitch(sndPlasmaReload, 1.5);
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Spread Fire:
	var _last = variable_instance_get(_fire.creator, "electroplasma_last", noone);
	for(var i = -2; i <= 2; i++){
		with(projectile_create(
			x,
			y,
			"ElectroPlasma",
			gunangle + ((20 + orandom(6)) * accuracy * i),
			random_range(4, 4.8)
		)){
			 // Tether Together:
			tether_inst = _last;
			_last = id;
		}
	}
	with(_fire.creator){
		electroplasma_last = _last;
	}
	
	 // Sounds:
	var _brain = (skill_get(mut_laser_brain) > 0);
	if(_brain) sound_play_gun(sndLightningShotgunUpg, 0.4, 0.6);
	else       sound_play_gun(sndLightningShotgun,    0.3, 0.3);
	sound_play_pitch(sndPlasmaBig, 1.1 + random(0.3));
	
	 // Effects:
	weapon_post(8, 6, 0);
	motion_add(gunangle, -4);
	
	
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