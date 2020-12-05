#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprBatTether.png", 4, 3);
	global.sprWepLocked = mskNone;
	
	 // LWO:
	global.lwoWep = {
		wep  : mod_current,
		ammo : 6,
		amax : 6,
		cost : 1,
		buff : false
	};
	
#define weapon_name            return (weapon_avail() ? "VAMPIRE" : "LOCKED");
#define weapon_text            return "HEMOELECTRICITY";
#define weapon_swap            return sndSwapEnergy;
#define weapon_sprt            return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_sprt_hud(_wep)  return weapon_ammo_hud(_wep);
#define weapon_area            return (weapon_avail() ? 11 : -1); // 5-2
#define weapon_type            return type_melee;
#define weapon_load            return 5; // 0.16 Seconds
#define weapon_auto(_wep)      return true;
#define weapon_melee           return false;
#define weapon_avail           return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack       return "lair";

#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Fire:
	if(weapon_ammo_fire(_wep)){
		 // Bat Coil:
		with(projectile_create(x, y, "TeslaCoil", gunangle, 0)){
			dist_max = 64;
			time     = 7 * (1 + skill_get(mut_laser_brain));
			bat      = true;
			primary  = _fire.primary;
			
			 // Steroids Offset:
			if(!primary){
				creator_offy -= 4;
			}
		}
		
		 // Refill:
		if(_wep.ammo <= 0 && instance_is(self, Player)){
			_wep.ammo = _wep.amax * (1 + skill_get(mut_back_muscle));
			
			 // Hurt:
			projectile_hit_raw(_fire.creator, 1, false);
			lasthit = [weapon_get_sprt(_wep), "PLAYING GOD"];
			
			 // Hurt FX:
			if(my_health > 0){
				var _addVol = (my_health <= maxhealth / 2) * 0.3;
				
				 // Sounds:
				sound_play_pitchvol(sndGammaGutsProc, 0.9 + random(0.3), 1.1 + _addVol);
				sound_play_pitchvol(sndHitFlesh,      0.8 + random(0.4), 0.9 + _addVol);
				
				 // Effects:
				instance_create(x, y, AllyDamage);
				view_shake_max_at(x, y, 12);
				sleep(24);
			}
			
			 // Death FX:
			else{
				sound_play(sndGammaGutsKill);
				sound_play_pitchvol(sndHyperCrystalSearch, 0.8, 0.8);
				view_shake_max_at(x, y, 24);
				sleep(48);
			}
		}
		
		 // Effects:
		if(array_length(instances_matching(instances_matching(instances_matching(instances_matching(CustomObject, "name", "TeslaCoil"), "bat", true), "creator", _fire.creator), "primary", _fire.primary)) <= 1){
			weapon_post(8, -10, 10);
			
			 // Sounds:
			if(skill_get(mut_laser_brain)){
				sound_play_pitchvol(sndBloodLauncherExplo, 0.7 + random(0.3), 0.8);
				sound_play_pitchvol(sndLightningShotgunUpg, 0.7 + random(0.4), 0.8)
			}
			else{
				sound_play_pitchvol(sndBloodLauncherExplo, 0.9 + random(0.4), 0.8);
				sound_play_pitchvol(sndLightningShotgun, 0.8 + random(0.4), 0.8)
			}
		}
		if(skill_get(mut_laser_brain)){
			with(instance_create(x, y, LaserBrain)){
				creator = _fire.creator; // Upgrade FX
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
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call_self('mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);