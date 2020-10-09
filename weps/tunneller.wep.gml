#define init
	 // Sprites:
	global.sprWep       = sprite_add_weapon("../sprites/weps/sprTunneller.png",          8, 6);
	global.sprWepHUD    = sprite_add(       "../sprites/weps/sprTunnellerHUD.png",    1, 0, 3);
	global.sprWepHUDRed = sprite_add(       "../sprites/weps/sprTunnellerHUDRed.png", 1, 0, 3);
	global.sprWepLocked = mskNone;
	
#define weapon_name       return (weapon_avail() ? "TUNNELLER" : "LOCKED");
#define weapon_text       return choose(`@wUNLOCK @sTHE @(color:${area_get_back_color("red")})CONTINUUM`, "FULL CIRCLE", `YET ANOTHER @(color:${area_get_back_color("red")})RED KEY`);
#define weapon_sprt       return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_area       return (weapon_avail() ? 22 : -1); // L1 3-1
#define weapon_load       return 24; // 0.8 Seconds
#define weapon_auto       return true;
#define weapon_melee      return false;
#define weapon_avail      return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack  return "red";
#define weapon_shrine     return [mut_long_arms, mut_laser_brain];
#define weapon_red        return 1;

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
	return sndSwapSword;
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Red:
	var _cost = weapon_red();
	if("red_ammo" in self && red_ammo >= _cost){
		red_ammo -= _cost;
		
		var _skill = skill_get(mut_laser_brain);
		
		 // Chaos Ball:
		with(projectile_create(x, y, "CrystalHeartBullet", gunangle + orandom(4 * accuracy), 4)){
			damage = lerp(20, 30, _skill);
			image_xscale += 0.15 * _skill;
			image_yscale += 0.15 * _skill;
			
			 // Area:
			area_goal  = irandom_range(8, 12) + (4 * _skill);
			area_chaos = chance(1, 2); 
			area_chest = pool([
				[AmmoChest,          4],
				[WeaponChest,        4],
				["Backpack",         3],
				["BonusAmmoChest",   2],
				["BonusHealthChest", 2],
				["RedAmmoChest",     1]
			]);
			with(instance_create(x, y, ThrowHit)){
				image_blend = area_get_back_color(other.area);
			}
		}
		
		 // Sounds:
		var _pitch = random_range(0.8, 1.2);
		sound_play_pitch(sndHyperCrystalSearch,	((_skill > 0) ? 1.2 : 1.4) * _pitch);
		sound_play_pitch(sndUltraGrenade,		1.0 * _pitch);
		sound_play_pitch(sndGammaGutsKill,		1.4 * _pitch);
		sound_set_track_position(
			sound_play_pitch(((_skill > 0) ? sndDevastatorUpg : sndDevastator), 0.8 * _pitch),
			0.6
		);
		
		 // Effects:
		weapon_post(18, 24, 12);
		motion_add(gunangle + 180, 4);
		move_contact_solid(gunangle + 180, 4);
		if(_skill > 0 && _cost > 0){
			repeat(_cost){
				with(instance_create(x, y, LaserBrain)){
					creator = other;
				}
			}
		}
		sleep(20);
	}
	
	 // Normal:
	else if(fork()){
		repeat(3){
			var	_skill = skill_get(mut_long_arms),
				_dis   = 10 * _skill,
				_dir   = gunangle;
				
			 // Shank:
			projectile_create(
				x + lengthdir_x(_dis, _dir),
				y + lengthdir_y(_dis, _dir),
				"RedShank",
				_dir + orandom(10 * accuracy),
				lerp(3, 6, _skill)
			);
			
			 // Sounds:
			sound_play_gun(sndScrewdriver, 0.2, 0.6);
			sound_set_track_position(
				sound_play_pitchvol(sndHyperCrystalChargeExplo, 1 + random(0.5), 0.4),
				1.5
			);
			
			 // Effects:
			weapon_post(-3, 8, 2);
			motion_add(_dir, 3);
			
			 // Hold Your Metaphorical Horses:
			wait(4);
			if(!instance_exists(self)) break;
		}
		exit;
	}
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // Unextend While Empty:
	if("red_ammo" not in self || red_ammo < weapon_get_red(_wep)){
		var	_goal = 6,
			_kick = wep_get(_primary, "wkick", 0);
			
		if(_kick >= 0 && _kick < _goal){
			_kick = min(_goal, _kick + (2 * current_time_scale));
			wep_set(_primary, "wkick", _kick);
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
#define weapon_get_red(_wep)                                                            return  mod_script_call_self('mod', 'telib', 'weapon_get_red', _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);