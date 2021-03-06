#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprBubbleCannon.png", 5, 7);
	global.sprWepLocked = sprTemp;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name       return (weapon_avail() ? "BUBBLE CANNON" : "LOCKED");
#define weapon_text       return "KING OF THE BUBBLES";
#define weapon_swap       return sndSwapExplosive;
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 11 : -1); // 5-2
#define weapon_type       return type_explosive;
#define weapon_cost       return 4;
#define weapon_load       return 30; // 1 Second
#define weapon_avail      return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "oasis";

#define weapon_reloaded
	var	_l = 22,
		_d = gunangle;
		
	repeat(5) with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), Bubble)){
		image_xscale = 0.75;
		image_yscale = image_xscale;
		image_angle  = random(360);
	}
	
	sound_play_pitchvol(sndOasisExplosionSmall, 1.3, 0.4);
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Bubble Bomb:
	with(projectile_create(x, y, "BubbleBomb", gunangle + orandom(6 * accuracy), 9)){
		move_contact_solid(other.gunangle, 7);
		big = true;
	}
	
	 // Sounds:
	var _pitch = random_range(0.8, 1.2);
	sound_play_pitch(sndOasisCrabAttack,     1.4 * _pitch);
	sound_play_pitch(sndOasisExplosionSmall, 0.5 * _pitch);
	sound_play_pitch(sndToxicBoltGas,        0.7 * _pitch);
	sound_play_pitch(sndToxicBarrelGas,      0.8 * _pitch);
	sound_play_pitch(sndOasisPortal,         0.6 * _pitch);
	sound_play_pitch(sndPlasmaMinigunUpg,    0.4 * _pitch);
	
	 // Effects:
	weapon_post(10, -12, 32);
	motion_add(gunangle + 180, 4);
	
	 // Particles:
	var	_dis = 12,
		_dir = gunangle;
		
	with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), BubblePop)){
		image_index = 1;
		image_speed = 0.25;
		image_angle = random(360);
		image_xscale = 1.2;
		image_yscale = image_xscale;
		depth = -1;
	}
	for(var a = -1; a <= 1; a++){
		with(obj_create(x, y, "WaterStreak")){
			motion_set(_dir + (((a * 24) + orandom(8)) * other.accuracy), 2 + random(4));
			y += vspeed;
			image_angle = other.gunangle;
			image_speed += orandom(0.2);
		}
	}
	
	
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