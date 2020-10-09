#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprHarpoonLauncher.png", 3, 4);
	global.sprWepLocked = mskNone;
	
#define weapon_name       return (weapon_avail() ? "HARPOON LAUNCHER" : "LOCKED");
#define weapon_text       return "REEL IT IN";
#define weapon_swap       return sndSwapBow;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 4 : -1); // 1-3
#define weapon_type       return type_bolt;
#define weapon_cost       return 1;
#define weapon_load       return 5; // 0.17 Seconds
#define weapon_avail      return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "coast";

#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Linked Harpoons:
	with(projectile_create(x, y, "Harpoon", gunangle + orandom(3 * accuracy), 22)){
		if(instance_exists(creator)){
			var _rope = variable_instance_get(creator, "harpoon_rope", noone);
			
			if(!instance_exists(lq_defget(_rope, "link1", noone)) || lq_defget(_rope, "broken", true)){
				_rope = Harpoon_rope(id, creator);
			}
			else{
				array_push(rope, _rope);
				_rope.break_timer = 60;
				_rope.link2 = id;
				_rope = noone;
			}
			
			variable_instance_set(creator, "harpoon_rope", _rope);
		}
	}
	
	 // Sounds:
	sound_play(sndCrossbow);
	sound_play_pitch(sndNadeReload, 0.8);
	
	 // Effects:
	weapon_post(6, 8, -20);
	
	
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
#define Harpoon_rope(_link1, _link2)                                                    return  mod_script_call_nc  ('mod', 'tecoast', 'Harpoon_rope', _link1, _link2);