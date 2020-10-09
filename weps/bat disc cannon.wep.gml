#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprBatDiscCannon.png", 13, 6);
	global.sprWepLocked = mskNone;
	
	 // LWO:
	global.lwoWep = {
		wep     : mod_current,
		ammo    : 14,
		amax    : 14,
		anam    : "SAWBLADES",
		cost    : 7,
		buff    : false,
		canload : true
	};
	
#define weapon_name            return (weapon_avail() ? "SAWBLADE CANNON" : "LOCKED");
#define weapon_text            return "THEY STAND NO CHANCE";
#define weapon_swap            return sndSwapShotgun;
#define weapon_sprt            return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_sprt_hud(_wep)  return weapon_ammo_hud(_wep);
#define weapon_area            return (weapon_avail() ? 11 : -1); // 5-2
#define weapon_type            return type_melee;
#define weapon_load            return 20; // 0.66 Seconds
#define weapon_auto            return true;
#define weapon_melee           return false;
#define weapon_avail           return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack       return "lair";
#define weapon_shrine          return mut_bolt_marrow;

#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Fire:
	if(weapon_ammo_fire(_wep)){
		 // Disc:
		with(projectile_create(x, y, "BatDisc", gunangle + orandom(4 * accuracy), 0)){
			ammo = ((other.infammo == 0) ? _wep.cost : 0);
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
		if(_wep.ammo <= 0 && variable_instance_get(self, "bonus_ammo", 0) <= 0){
			_wep.canload = false;
		}
	}
	else{
		 // Stop Reloading:
		if(_wep.ammo > 0){
			wep_set(_primary, "reload",    weapon_get_load(_wep));
			wep_set(_primary, "can_shoot", false);
		}
		
		 // Smokin'
		if(current_frame_active){
			repeat(choose(1, 2)){
				var	_x    = x,
					_y    = y,
					_dir  = gunangle,
					_disx = 12 - wkick,
					_disy = 2 + orandom(2);
					
				if(!_primary){
					if(race == "steroids"){
						_y -= 4;
						_disy -= 4;
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
		if(_wep.ammo >= _wep.amax){
			_wep.canload = true;
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