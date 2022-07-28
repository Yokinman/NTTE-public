#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprHarpoonLauncher.png", 3, 4);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name       return (weapon_avail() ? "HARPOON LAUNCHER" : "LOCKED");
#define weapon_text       return "REEL IT IN";
#define weapon_swap       return sndSwapBow;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 4 : -1); // 1-3
#define weapon_type       return type_bolt;
#define weapon_cost       return 1;
#define weapon_load       return 5; // 0.17 Seconds
#define weapon_avail      return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "coast";

#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Linked Harpoons:
	with(call(scr.projectile_create, x, y, "Harpoon", gunangle + orandom(3 * accuracy), 22)){
		if(instance_exists(creator)){
			var _rope = variable_instance_get(creator, "harpoon_rope", noone);
			
			if(!instance_exists(lq_defget(_rope, "link1", noone)) || lq_defget(_rope, "broken", true)){
				_rope = call(scr.Harpoon_rope, self, creator);
			}
			else{
				array_push(rope, _rope);
				_rope.break_timer = 60;
				_rope.link2       = self;
				_rope             = noone;
			}
			
			variable_instance_set(creator, "harpoon_rope", _rope);
		}
	}
	
	 // Sounds:
	sound_play_gun(sndCrossbow, 0.2, 0.3);
	audio_sound_pitch(sound_play_gun(sndNadeReload, 0, 0.3), 0.8);
	
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