#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprQuasarRifle.png", 8, 5);
	global.sprWepLocked = mskNone;
	
	 // LWO:
	global.lwoWep = {
		wep  : mod_current,
		beam : noone
	};
	
#define weapon_name         return (weapon_avail() ? "QUASAR RIFLE" : "LOCKED");
#define weapon_text         return "BLINDING LIGHT";
#define weapon_swap         return sndSwapEnergy;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area         return (weapon_avail() ? 16 : -1); // 7-3
#define weapon_type         return type_energy;
#define weapon_cost         return 10;
#define weapon_load         return 60; // 2 Seconds
#define weapon_auto         return true;
#define weapon_avail        return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack    return "trench";
#define weapon_ntte_quasar  return true;

#define weapon_fire(_wep)
	var	_fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // New Beam:
	if(!instance_exists(_wep.beam) || (_fire.spec && !_fire.roids)){
		 // Quasar Beam:
		with(projectile_create(x, y, "QuasarBeam", gunangle + orandom(6 * accuracy), 0)){
			image_yscale = 0.6;
			turn_factor  = 1/100;
			offset_dis   = 16;
			_wep.beam    = id;
		}
		
		 // Sound:
		var _brain = skill_get(mut_laser_brain);
		sound_play_pitch((_brain ? sndLaserUpg  : sndLaser),  0.4 + random(0.1));
		sound_play_pitch((_brain ? sndPlasmaUpg : sndPlasma), 1.2 + random(0.2));
		sound_play_pitchvol(sndExplosion, 1.5, 0.5);
		
		 // Effects:
		weapon_post(14, -16, 8);
		motion_add(gunangle + 180, 3);
	}
	
	 // Charge Beam:
	else with(_wep.beam){
		if(image_yscale < 1) scale_goal = 1;
		else{
			var	a = 0.25,
				m = 1 + (a * (1 + (0.4 * skill_get(mut_laser_brain))));
				
			if(scale_goal < m){
				scale_goal = min((floor(image_yscale / a) * a) + a, m);
				flash_frame = max(flash_frame, current_frame + 2);
			}
		}
		
		 // Knockback:
		if(image_yscale < scale_goal){
			with(other) motion_add(gunangle + 180, 2);
			flash_frame = max(flash_frame, current_frame + 3);
		}
	}
	
	 // Keep Setting:
	with(_wep.beam){
		shrink_delay = weapon_get_load(_wep) + 1;
		roids = _fire.roids;
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