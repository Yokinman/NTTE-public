#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprTeslaCoil.png", 5, 2);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name       return (weapon_avail() ? "TESLA COIL" : "LOCKED");
#define weapon_text       return "LIMITED POWER";
#define weapon_swap       return sndSwapEnergy;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 11 : -1); // 5-2
#define weapon_type       return type_energy;
#define weapon_cost       return 2;
#define weapon_load       return 8; // 0.27 Seconds
#define weapon_auto       return true;
#define weapon_avail      return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "trench";

#define weapon_reloaded
	sound_play_pitchvol(sndLightningReload, 0.5 + random(0.5), 0.8);
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Tesla Coil Ball:
	var	_xdis = 0,
		_ydis = 0;
		
	with(call(scr.projectile_create, x, y, "TeslaCoil", gunangle)){
		primary = _fire.primary;
		if(!primary){
			creator_offy -= 4;
		}
		_xdis = creator_offx;
		_ydis = creator_offy;
	}
	
	 // Effects:
	if(array_length(instances_matching(instances_matching(obj.TeslaCoil, "creator", _fire.creator), "primary", _fire.primary)) == 1){
		weapon_post(8, -10, 10);
		
		 // Ball Appear FX:
		_ydis *= variable_instance_get(_fire.creator, "right", 1);
		with(instance_create(
			x + lengthdir_x(_xdis, gunangle) + lengthdir_x(_ydis, gunangle - 90),
			y + lengthdir_y(_xdis, gunangle) + lengthdir_y(_ydis, gunangle - 90) - (_fire.primary ? 0 : 4),
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