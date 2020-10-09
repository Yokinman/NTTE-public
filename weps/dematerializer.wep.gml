#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprDematerializer.png", 4, 5);
	global.sprWepLocked = mskNone;
	
#define weapon_name       return (weapon_avail() ? "DEMATERIALIZER" : "LOCKED");
#define weapon_text       return "ITS A GUN";
#define weapon_swap       return sndSwapEnergy;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 7 : -1); // 3-2
#define weapon_type       return type_energy;
#define weapon_cost       return 0;
#define weapon_load       return 18; // 0.67 Seconds
#define weapon_auto       return true;
#define weapon_avail      return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "trench";

#define weapon_reloaded
	sound_play(sndLightningReload);
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	var	_last     = variable_instance_get(_fire.creator, "electroplasma_last", noone),
		_side     = variable_instance_get(_fire.creator, "electroplasma_side", 1),
		_dir      = gunangle + orandom(3 * accuracy),
		_needProj = true;
		
	 // Retain Projectile if youre holding fire:
	with(instances_matching(CustomProjectile, "name", "ElectroPlasma")){
		_needProj = false;
		lifetime = weapon_get_load(_wep) + 1;
	}
	
	 // Create new hyper Projectile if none exists:
	if(_needProj){
		with(projectile_create(x, y, "ElectroPlasma", _dir, 0)){
			move_contact_solid(_dir, 480);
			hyper        = "true";
			tether_range = 1200;
			wave         = 0;
			
			// Tether Together:
			tether_inst = creator;
			_last = id;
			
			// Unique Weapon Mechanic:
			lifetime = weapon_get_load(_wep) + 1;
		}
	}
	with(_fire.creator){
		electroplasma_last = _last;
		electroplasma_side = -_side;
	}
	
	 // Sounds:
	var _brain = (skill_get(mut_laser_brain) > 0);
	if(_brain) sound_play_gun(sndLightningPistolUpg, 0.4, 0.6);
	else       sound_play_gun(sndLightningPistol,    0.3, 0.3);
	sound_play_pitch(sndEliteShielderFire, 0.9 + random(0.3));
	sound_play_pitch(sndGammaGutsProc,     1.0 + random(0.2));
	
	 // Effects:
	weapon_post(6, 3, 0);
	motion_add(gunangle + 180, 0.5);
	
#define step
	with(instances_matching(CustomProjectile, "name", "ElectroPlasma")){
		if("lifetime" in self){
			if(lifetime > 0){
				x = creator.x;
				y = creator.y;
				move_contact_solid(creator.gunangle, 480);
				direction = creator.gunangle;
				image_angle = direction;
				wave = 0;
				lifetime -= current_time_scale;
				if(instance_exists(creator)){
					with(creator) weapon_post(6, 3, 0);
				}
			}
			else instance_destroy();
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