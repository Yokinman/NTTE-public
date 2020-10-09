#define init
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprAnnihilator.png",          8, 3);
	global.sprWepHUD    = sprite_add(       "../sprites/weps/sprAnnihilatorHUD.png",    1, 0, 3);
	global.sprWepHUDRed = sprite_add(       "../sprites/weps/sprAnnihilatorHUDRed.png", 1, 0, 3);
	global.sprWepLocked = mskNone;
	
	 // LWO:
	global.lwoWep = {
		wep   : mod_current,
		melee : true
	};
	
#define weapon_name         return (weapon_avail() ? "ANNIHILATOR" : "LOCKED");
#define weapon_text         return `@wBEND @sTHE @(color:${area_get_back_color("red")})CONTINUUM`;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area         return (weapon_avail() ? 22 : -1); // L1 3-1
#define weapon_load         return 24; // 0.8 Seconds
#define weapon_melee(_wep)  return lq_defget(_wep, "melee", true);
#define weapon_avail        return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack    return "red";
#define weapon_shrine       return [mut_long_arms, mut_shotgun_shoulders];
#define weapon_red          return 2;

#define weapon_type
	 // Weapon Pickup Ammo Outline:
	if(instance_is(self, WepPickup) && instance_is(other, WepPickup)){
		if(image_index > 1 && ammo > 0){
			for(var i = 0; i < 360; i += 90){
				draw_sprite_ext(sprite_index, 1, x + dcos(i), y - dsin(i), 1, 1, rotation, image_blend, image_alpha);
			}
		}
	}
	
	 // Type:
	return type_melee;
	
#define weapon_sprt_hud(_wep)
	 // Normal Outline:
	if(instance_is(self, Player)){
		if(
			weapon_get_rads(_wep) > 0
			|| (wep  == _wep && curse  > 0)
			|| (bwep == _wep && bcurse > 0)
		){
			return global.sprWepHUD;
		}
	}
	
	 // Red Outline:
	return global.sprWepHUDRed;
	
#define weapon_swap
	sound_set_track_position(
		sound_play_pitchvol(sndHyperCrystalChargeExplo, 0.6, 0.5),
		1.55
	);
	return sndSwapHammer;
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Red:
	var _cost = weapon_get_red(_wep);
	if("red_ammo" in self && red_ammo >= _cost){
		red_ammo -= _cost;
		
		 // Annihilator:
		projectile_create(x, y, "RedBullet", gunangle, 16);
		
		 // Sounds:
		sound_play_pitchvol(sndEnergyScrewdriver, 0.7 + random(0.2), 2);
		sound_play_pitchvol(sndPlasmaReloadUpg,   1.2 + random(0.2), 0.8);
		
		 // Effects:
		weapon_post(10, 8, 6);
		motion_add(gunangle + 180, 3);
		sleep(40);
	}
	
	 // Normal:
	else{
		//wepangle *= -1;
		//repeat(3){
			var _skill = skill_get(mut_long_arms),
				_dis   = 20 * _skill,
				_dir   = gunangle/* + orandom(10 * accuracy)*/;
				
			 // Slash:
			projectile_create(
				x + lengthdir_x(_dis, _dir),
				y + lengthdir_y(_dis, _dir),
				"RedSlash",
				_dir,
				lerp(2, 5, _skill)
			);
			
			 // Sounds:
			sound_play_gun(sndWrench, 0.2, 0.6);
			sound_set_track_position(
				sound_play_pitchvol(sndHyperCrystalChargeExplo, 1 + random(0.5), 0.4),
				1.5
			);
			
			 // Effects:
			//wepangle *= -1;
			instance_create(x, y, Smoke);
			weapon_post(-4, 12, 1);
			motion_add(_dir, 6);
			sleep(10);
			
			 // Waiting:
		//	wait(6);
		//	if(!instance_exists(self)) break;		
		//}
	}
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // LWO Setup:
	if(!is_object(_wep)){
		_wep = lq_clone(global.lwoWep);
		wep_set(_primary, "wep", _wep);
	}
	
	 // Transition Between Shooty/Melee:
	var	_wepangle = wep_get(_primary, "wepangle", 0),
		_wkick    = wep_get(_primary, "wkick",    0);
		
	if("red_ammo" not in self || red_ammo < weapon_get_red(_wep)){
		if(!_wep.melee){
			_wep.melee   = true;
			_wepangle = choose(-1, 1);
			_wkick    = 4;
		}
		_wepangle = lerp(_wepangle, max(abs(_wepangle), 120) * sign(_wepangle), 0.4 * current_time_scale);
	}
	else if(_wep.melee){
		_wepangle -= _wepangle * 0.4 * current_time_scale;
		
		 // Done:
		if(abs(_wepangle) < 1){
			_wep.melee = false;
			_wkick = 2;
		}
	}
	wep_set(_primary, "wepangle", _wepangle);
	wep_set(_primary, "wkick",    _wkick);
	
	
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
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);