#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprTeslaCoil.png", 5, 2);
	global.sprWepLocked = mskNone;
	
#define weapon_name       return (weapon_avail() ? "TESLA COIL" : "LOCKED");
#define weapon_text       return "LIMITED POWER";
#define weapon_swap       return sndSwapEnergy;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 11 : -1); // 5-2
#define weapon_type       return type_energy;
#define weapon_cost       return 2;
#define weapon_load       return 8; // 0.27 Seconds
#define weapon_auto       return true;
#define weapon_avail      return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "trench";

#define weapon_reloaded
	sound_play_pitchvol(sndLightningReload, 0.5 + random(0.5), 0.8);
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Tesla Coil Ball:
	var	_xdis = 0,
		_ydis = 0;
		
	with(projectile_create(x, y, "TeslaCoil", gunangle, 0)){
		roids = _fire.roids;
		if(roids) creator_offy -= 4;
		_xdis = creator_offx;
		_ydis = creator_offy;
	}
	
	 // Effects:
	if(array_length(instances_matching(instances_matching(instances_matching(CustomObject, "name", "TeslaCoil"), "creator", _fire.creator), "roids", _fire.roids)) <= 1){
		weapon_post(8, -10, 10);
		
		 // Ball Appear FX:
		_ydis *= variable_instance_get(_fire.creator, "right", 1);
		with(instance_create(
			x + lengthdir_x(_xdis, gunangle) + lengthdir_x(_ydis, gunangle - 90),
			y + lengthdir_y(_xdis, gunangle) + lengthdir_y(_ydis, gunangle - 90) - (4 * _fire.roids),
			LightningHit
		)){
			motion_add(other.gunangle, 0.5);
		}
		
		 // Sounds:
		if(skill_get(mut_laser_brain) > 0){
			sound_play_pitchvol(sndGuitarHit7,      2.4 + random(0.4), 0.6);
			sound_play_pitchvol(sndLaserUpg,        0.8 + random(0.2), 0.6);
			sound_play_pitchvol(sndDevastatorExplo, 1.4 + random(0.4), 0.6);
		}
		else{
			sound_play_pitchvol(sndGuitarHit6,      1.6 + random(0.4), 0.4);
			sound_play_pitchvol(sndLaser,           1.4 + random(0.4), 1.0);
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