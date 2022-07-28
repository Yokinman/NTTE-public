#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprBubbleRifle.png", 2, 5);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name        return (weapon_avail() ? "BUBBLE RIFLE" : "LOCKED");
#define weapon_text        return "REFRESHING";
#define weapon_swap        return sndSwapExplosive;
#define weapon_sprt        return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area        return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_type        return type_explosive;
#define weapon_cost        return 2;
#define weapon_load        return 9; // 0.3 Seconds
#define weapon_burst       return 2;
#define weapon_burst_time  return 2; // 0.07 Seconds
#define weapon_avail       return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack   return "oasis";

#define weapon_reloaded
	var	_l = 14,
		_d = gunangle;
		
	with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), Bubble)){
		image_xscale = 0.75;
		image_yscale = image_xscale;
		image_angle  = random(360);
	}
	
	sound_play_pitchvol(sndOasisExplosionSmall, 1.3, 0.4);
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Bubble Bomb:
	with(call(scr.projectile_create, x, y, "BubbleBomb", gunangle + orandom(12 * accuracy), 9)){
		move_contact_solid(other.gunangle, 6);
	}
	
	 // Sounds:
	var _pitch = random_range(0.8, 1.2);
	sound_play_pitch(sndOasisCrabAttack,     1.6 * _pitch);
	sound_play_pitch(sndOasisExplosionSmall, 0.7 * _pitch);
	sound_play_pitch(sndToxicBoltGas,        0.8 * _pitch);
	sound_play_pitch(sndBouncerBounce,       1.2 * _pitch);
	
	 // Effects:
	weapon_post(5, -5, 10);
	
	var	_l = 14,
		_d = gunangle;
		
	with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), BubblePop)){
		image_index  = 1;
		image_xscale = 0.8;
		image_yscale = image_xscale;
		image_angle  = random(360);
		depth        = -1;
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