#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprQuasarCannon.png", 20, 5);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name         return (weapon_avail() ? "QUASAR CANNON" : "LOCKED");
#define weapon_text         return "PULSATING";
#define weapon_swap         return sndSwapEnergy;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area         return (weapon_avail() ? 18 : -1); // 1-1 L1
#define weapon_type         return type_energy;
#define weapon_cost         return 16;
#define weapon_load         return 159; // 5.3 Seconds
#define weapon_avail        return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack    return "trench";
#define weapon_ntte_quasar  return true;

#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Quasar Ring:
	var _brain = skill_get(mut_laser_brain);
	with(call(scr.projectile_create, x, y, "QuasarRing", gunangle + orandom(8 * accuracy), 4)){
		image_yscale = 0;
		ring_size    = 0.6 * power(1.2, _brain);
	}
	
	 // Sound:
	sound_play_gun((_brain ? sndPlasmaBigUpg       : sndPlasmaBig), 0.4, -0.5);
	sound_play_gun((_brain ? sndLightningCannonUpg : sndLaser),     0.4, -0.5);
	sound_play_pitchvol(sndExplosion, 0.8, 1.5);
	
	 // Effects:
	weapon_post(20, -24, 8);
	motion_add(gunangle + 180, 5);
	
	
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