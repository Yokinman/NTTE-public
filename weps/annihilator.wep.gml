#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprAnnihilator.png",       8, 3);
	global.sprWepHUD    = sprite_add_weapon("../sprites/weps/sprAnnihilatorHUD.png",    0, 3);
	global.sprWepHUDRed = sprite_add(       "../sprites/weps/sprAnnihilatorHUD.png", 1, 0, 3);
	global.sprWepLocked = sprTemp;
	
	 // LWO:
	global.lwoWep = {
		"wep"      : mod_current,
		"chrg"     : false,
		"chrg_num" : 0,
		"chrg_max" : 15
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name        return (weapon_avail() ? "ANNIHILATOR" : "LOCKED");
#define weapon_text        return `@wBEND @sTHE @(color:${call(scr.area_get_back_color, "red")})CONTINUUM`;
#define weapon_sprt        return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area        return (weapon_avail() ? 22 : -1); // L1 3-1
#define weapon_load        return 18; // 0.6 Seconds
#define weapon_auto(_wep)  return call(scr.weapon_get, "chrg", _wep);
#define weapon_avail       return call(scr.unlock_get, "pack:" + weapon_ntte_pack());
#define weapon_ntte_pack   return "red";
#define weapon_shrine      return [mut_long_arms, mut_shotgun_shoulders];
#define weapon_red         return 2;
#define weapon_chrg(_wep)  return (argument_count > 0 && "red_ammo" in self && red_ammo >= call(scr.weapon_get, "red", _wep));

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
	if(
		weapon_get_gold(_wep) != 0 ||
		weapon_get_rads(_wep) > 0  ||
		(instance_is(self, Player) && ((wep == _wep && curse > 0) || (bwep == _wep && bcurse > 0)))
	){
		return global.sprWepHUD;
	}
	
	 // Red Outline:
	return global.sprWepHUDRed;
	
#define weapon_swap
	sound_set_track_position(
		sound_play_pitchvol(sndHyperCrystalChargeExplo, 0.6, 0.5),
		1.55
	);
	return sndSwapHammer;
	
#define weapon_reloaded(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	if(lq_defget(_wep, "chrg", false)){
		wep_set(_primary, "wepflip", -wep_get(_primary, "wepflip", 1));
	}
	else if(weapon_is_melee(_wep)){
		sound_play(sndMeleeFlip);
	}
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	var _charge = (_wep.chrg_num / _wep.chrg_max);
	
	 // Reset Melee Offset:
	if(!_wep.chrg || (_wep.chrg_num <= current_time_scale && abs(wepangle) < 30)){
		wepangle = 120 * sign(wepangle);
	}
	
	 // Charging:
	if(_wep.chrg){
		 // Pullback:
		var _kick = 2 * _charge;
		if(wkick != _kick){
			weapon_post(_kick, 8 * _charge * current_time_scale, 0);
		}
		
		 // Reorient:
		var _lastAng = wepangle;
		wepangle *= power(1 - _charge, (4 / _wep.chrg_max) * current_time_scale);
		if(abs(wepangle) < 0.1){
			wepangle = 0.1 * sign(_lastAng);
		}
		
		 // Effects:
		if((current_frame % 5) < current_time_scale){
			var	_l = random_range(8, 32) - wkick,
				_d = gunangle + (wepangle * (1 - (wkick / 20)));
				
			call(scr.obj_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "CrystalBrainEffect");
		}
		if(_wep.chrg == 1){
			 // Sound:
			sound_set_track_position(
				sound_play_pitchvol(sndHyperCrystalChargeExplo, 0.4 + (0.2 * _charge), 0.5),
				1.55
			);
			sound_play_pitchvol(sndCrystalTB, 1 / (1 - (0.25 * _charge)), 1);
			
			 // Full:
			if(_charge >= 1){
				 // Sound:
				sound_play_pitch(sndCrystalTB,         0.5 + random(0.2));
				sound_play_pitch(sndCrystalJuggernaut, 2);
				
				 // Flash:
				var	_l = 24,
					_d = gunangle + wepangle;
					
				with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), PlasmaTrail)){
					sprite_index = sprThrowHit;
					image_speed  = 0.4;
					image_angle  = random(360);
					image_blend  = call(scr.area_get_back_color, "red");
					depth        = other.depth - 1;
					with(instance_create(x, y, PlasmaTrail)){
						sprite_index = other.sprite_index;
						image_speed  = 1;
						image_angle  = other.image_angle;
						depth        = other.depth - 1;
					}
				}
				view_shake_at(x, y, 10);
				sleep(5);
			}
		}
	}
	
	 // Fire:
	else{
		 // Red:
		var _cost = call(scr.weapon_get, "red", _wep);
		if(_charge >= 1 && "red_ammo" in _fire.creator && _fire.creator.red_ammo >= _cost){
			_fire.creator.red_ammo -= _cost;
			
			 // Annihilator:
			call(scr.projectile_create, x, y, "RedBullet", gunangle, 16);
			
			 // Sounds:
			sound_play_gun(sndShotgun,           0.2, 0.3);
			sound_play_gun(sndEnergyScrewdriver, 0.3, 0.3);
			sound_play_gun(sndPlasmaReloadUpg,   0.4, 0.3);
			sound_play_gun(sndUltraEmpty,        0.5, 0.3);
			
			 // Effects:
			weapon_post(10, 8, 6);
			motion_add(gunangle + 180, 3);
			sleep(40);
		}
		
		 // Normal:
		else{
			var _skill = skill_get(mut_long_arms),
				_dis   = 20 * _skill,
				_dir   = gunangle; // + orandom(10 * accuracy);
				
			 // Slash:
			call(scr.projectile_create,
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
			instance_create(x, y, Smoke);
			weapon_post(-4, 12, 1);
			motion_add(_dir, 6);
			sleep(5);
		}
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