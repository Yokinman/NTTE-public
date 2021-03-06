#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprBubbleBat.png", 4, 3);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name       return (weapon_avail() ? "BUBBLE BAT" : "LOCKED");
#define weapon_text       return "REFRESHING";
#define weapon_swap       return sndSwapMotorized;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_type       return type_explosive;
#define weapon_cost       return 2;
#define weapon_load       return 18; // 0.6 Seconds
#define weapon_melee      return true;
#define weapon_avail      return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "oasis";

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
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Slash:
	var _skill = skill_get(mut_long_arms),
		_flip  = sign(wepangle),
		_dis   = 20 * _skill,
		_dir   = gunangle;
		
	with(projectile_create(
		x + lengthdir_x(_dis, _dir),
		y + lengthdir_y(_dis, _dir),
		"BubbleSlash",
		_dir,
		lerp(2, 5, _skill)
	)){
		image_yscale *= _flip;
	}
	
	 // Sounds:
	var _pitch = random_range(0.8, 1.2);
	sound_play_pitch(sndOasisCrabAttack,     1.6 * _pitch);
	sound_play_pitch(sndOasisExplosionSmall, 0.7 * _pitch);
	sound_play_pitch(sndToxicBoltGas,        2.0 * _pitch);
	sound_play_pitch(sndHammer,              1.2 * _pitch);
	
	 // Effects:
	_dir += 60 * sign(wepangle);
	weapon_post(-4, 10, 15);
	motion_add(_dir, 3);
	move_contact_solid(_dir, 3);
	instance_create(x, y, Dust);
	
	
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
#define weapon_get(_name, _wep)                                                         return  mod_script_call     ('mod', 'telib', 'weapon_get', _name, _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);