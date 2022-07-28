#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep = sprHeavyARifle;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name  return "VENOM RIFLE";
#define weapon_text  return "A PIERCING STING";
#define weapon_swap  return sndSwapMachinegun;
#define weapon_sprt  return global.sprWep;
#define weapon_area  return 7; // 3-2
#define weapon_type  return type_bullet;
#define weapon_cost  return 2;
#define weapon_load  return 3; // 0.1 Seconds
#define weapon_auto  return true;

#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Pellets:
	var _dir = gunangle + orandom(4 * accuracy),
		_num = 3;
		
	for(var _ang = _dir; _ang < _dir + 360; _ang += (360 / _num)){
		var _l = 9 * lerp(accuracy, 1, 2/3),
			_d = _ang + orandom(2 * accuracy);
			
		with(call(scr.projectile_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "VenomPellet", _dir, 16)){
			sprite_index = spr_spwn;
			image_speed  = 1;
		}
	}
	
	 // Sounds:
	sound_play_gun(sndMachinegun, 0.3, 0.3);
	
	 // Effects:
	weapon_post(4, -2, 0);
	
	
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