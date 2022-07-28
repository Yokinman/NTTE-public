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
#define weapon_sprt_hud(_wep)  return call(scr.weapon_ammo_hud, _wep);
#define weapon_area            return (weapon_avail() ? 11 : -1); // 5-2
#define weapon_type            return type_melee;
#define weapon_load            return 20; // 0.66 Seconds
#define weapon_auto            return true;
#define weapon_melee           return false;
#define weapon_avail           return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
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
			if(_ammo < _cost && array_length(obj.BatDisc)){
				if(array_length(instances_matching(instances_matching(obj.BatDisc, "wep", _wep), "image_index", 1))){
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
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Fire:
	if(call(scr.weapon_ammo_fire, _wep)){
		 // Disc:
		with(call(scr.projectile_create, x, y, "BatDisc", gunangle + orandom(4 * accuracy))){
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
	var _wep = call(scr.weapon_step_init, _primary);
	
	 // Inherit:
	mod_script_call("weapon", "bat disc launcher", "step", _primary);
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  obj                                                                                     global.obj
#macro  scr                                                                                     global.scr
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    ((current_frame + global.epsilon) % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        if(((_primary ? '' : 'b') + _name) in self) variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);