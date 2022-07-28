#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprNetGun.png", 3, 2);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name         return (weapon_avail() ? "NET LAUNCHER" : "LOCKED");
#define weapon_text         return "CATCH OF THE DAY";
#define weapon_swap         return sndSwapExplosive;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area         return (weapon_avail() ? 8 : -1); // 3-3
#define weapon_type         return type_bolt;
#define weapon_cost         return 10;
#define weapon_load         return 36; // 1.2 Seconds
#define weapon_laser_sight  return false;
#define weapon_avail        return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack    return "coast";

#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Net Nade:
	call(scr.projectile_create, x, y, "NetNade", gunangle + orandom(5 * accuracy), 16);
	
	 // Sounds:
	sound_play(sndGrenade);
	sound_play_pitch(sndFlakCannon, 1.75 + random(0.25));
	sound_play_pitch(sndNadeReload, 0.8);
	
	 // Effects:
	weapon_post(6, 8, -20);
	
	
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