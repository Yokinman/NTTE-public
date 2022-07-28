#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprBubbleMinigun.png", 3, 3);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name        return (weapon_avail() ? "BUBBLE MINIGUN" : "LOCKED");
#define weapon_text        return "SOAP EVERYWHERE";
#define weapon_swap        return sndSwapMotorized;
#define weapon_sprt        return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area        return (weapon_avail() ? 10 : -1); // 5-1
#define weapon_type        return type_explosive;
#define weapon_cost        return 3;
#define weapon_load        return 3; // 0.1 Seconds
#define weapon_burst       return 3;
#define weapon_auto        return true;
#define weapon_avail       return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack   return "oasis";

#define weapon_reloaded
	var	_l = 19,
		_d = gunangle;
		
	with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), BubblePop)){
		image_index = (other.wkick > 0);
		image_angle = random(360);
		depth       = -1;
	}
	
	sound_play_pitchvol(sndOasisExplosionSmall, 1.1, 0.4);
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Bubble Bomb:
	with(call(scr.projectile_create, x, y, "BubbleBomb", gunangle + orandom(6 * accuracy), 10 + random(2))){
		move_contact_solid(other.gunangle, 6);
	}
	
	 // Sounds:
	var _pitch = random_range(0.8, 1.2);
	sound_play_pitch(sndOasisCrabAttack,     0.7 * _pitch);
	sound_play_pitch(sndSuperSplinterGun,    1.4 * _pitch);
	sound_play_pitch(sndOasisExplosionSmall, 0.7 * _pitch);
	
	 // Effects:
	weapon_post(5, -5, 10);
	motion_add(gunangle + 180, 0.5);
	
	
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