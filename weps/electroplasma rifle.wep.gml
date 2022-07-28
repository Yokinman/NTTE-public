#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprElectroPlasmaRifle.png", 1, 5);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name        return (weapon_avail() ? "ELECTROPLASMA RIFLE" : "LOCKED");
#define weapon_text        return "DEEP SEA WEAPONRY";
#define weapon_swap        return sndSwapEnergy;
#define weapon_sprt        return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area        return (weapon_avail() ? 7 : -1); // 3-2
#define weapon_type        return type_energy;
#define weapon_cost        return 5;
#define weapon_load        return 20; // 0.67 Seconds
#define weapon_burst       return 3;
#define weapon_burst_time  return 3; // 0.1 Seconds
#define weapon_auto        return true;
#define weapon_avail       return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack   return "trench";

#define weapon_reloaded
	sound_play(sndLightningReload);
	sound_play_pitch(sndPlasmaReload, 1.5);
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Electro Plasma:
	var	_last = variable_instance_get(_fire.creator, "electroplasma_last", noone),
		_side = variable_instance_get(_fire.creator, "electroplasma_side", 1);
		
	with(call(scr.projectile_create,
		x,
		y,
		"ElectroPlasma",
		gunangle + ((17 + orandom(7)) * accuracy * _side),
		random_range(4, 4.4)
	)){
		 // Tether Together:
		tether_inst = _last;
		_last       = self;
	}
	with(_fire.creator){
		electroplasma_last = _last;
		electroplasma_side = -_side;
	}
	
	 // Sounds:
	if(_fire.burst == 1){
		if(skill_get(mut_laser_brain) > 0){
			sound_play_gun(sndLightningPistolUpg, 0.4, 0.6);
		}
		else{
			sound_play_gun(sndLightningPistol, 0.3, 0.3);
		}
	}
	sound_play_pitch(sndEliteShielderFire, 0.9 + random(0.3));
	sound_play_pitch(sndGammaGutsProc,     1.0 + random(0.2));
	
	 // Effects:
	weapon_post(6, 3, 0);
	motion_add(gunangle + 180, 3);
	
	
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