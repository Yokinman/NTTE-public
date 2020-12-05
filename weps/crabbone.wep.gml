#define init
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprBone.png", 6, 6);
	
	 // LWO:
	global.lwoWep = {
		wep   : mod_current,
		ammo  : 1,
		combo : 0
	};
	
#define weapon_name  return "BONE";
#define weapon_text  return "BONE THE FISH"; // yokin no
#define weapon_swap  return sndBloodGamble;
#define weapon_sprt  return global.sprWep;
#define weapon_load  return ((wep_get(true, "curse", 0) > 0) ? 30 : 6); // 0.2 Seconds (Cursed ~ 1 Second)

#define weapon_area
	 // Drops naturally if a player is already carrying bones:
	with(Player){
		if(wep_raw(wep) == mod_current || wep_raw(bwep) == mod_current){
			return 4; // 1-3
		}
	}
	
	 // If not, it don't:
	return -1;
	
#define weapon_type(_wep)
	 // Return Other Weapon's Ammo Type:
	if(instance_is(self, AmmoPickup) && instance_is(other, Player)){
		with(other){
			return weapon_get_type((_wep == wep) ? bwep : wep);
		}
	}
	
	 // Normal:
	return type_melee;
	
#define weapon_sprt_hud(_wep)
	 // Custom Ammo Drawing:
	if(lq_defget(_wep, "ammo", 0) > 1){
		return weapon_ammo_hud(_wep);
	}
	
	 // Normal:
	return weapon_get_sprt(_wep);
	
#define weapon_ntte_eat(_wep)
	 // Fix Stacked Eating:
	if(is_object(_wep)){
		var _num = (lq_defget(_wep, "ammo", 0) - 1);
		if(_num > 0) repeat(_num){
			 // Regurgitate:
			if(ultra_get("robot", 2) > 0 && chance(3, 7)){
				sound_play_hit_big(sndRegurgitate, 0.2);
				repeat(ultra_get("robot", 2)){
					instance_create(x, y, choose(AmmoChest, choose(WeaponChest, WeaponChest, HealthChest)));
				}
			}
			
			 // Normal:
			else if(random(maxhealth) > my_health && crown_current != crwn_life){
				instance_create(x, y, HPPickup)
			}
			else{
				instance_create(x, y, AmmoPickup)
			}
			
			 // Throne Butt:
			if(skill_get(mut_throne_butt) > 0){
				repeat(skill_get(mut_throne_butt)){
					instance_create(x, y, AmmoPickup);
				}
			}
		}
	}
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Cursed:
	var _curse = 0;
	with(_fire.creator){
		_curse = max(_curse, wep_get(true, "curse", 0));
	}
	if(_curse > 0){
		 // Shrink Wepangle:
		if(abs(wepangle) == 120){
			wepangle = 100 * sign(wepangle);
		}
		
		 // Slash:
		var	_skill = skill_get(mut_long_arms),
			_heavy = ((++_wep.combo % 2) == 0),
			_flip  = sign(wepangle),
			_dis   = lerp(10, 20, _skill),
			_dir   = gunangle;
			
		with(projectile_create(
			x + hspeed + lengthdir_x(_dis, _dir),
			y + vspeed + lengthdir_y(_dis, _dir),
			"BoneSlash",
			_dir + orandom(5 * accuracy),
			lerp(2, 4, _skill)
		)){
			image_xscale *= 3/4;
			image_yscale *= 3/4 * _flip;
			rotspeed      = 2 * _flip;
			heavy         = _heavy;
		}
		
		 // Sounds:
		sound_play_gun(sndWrench, 0.3, 0.5);
		sound_play_hit(sndCursedReminder, 0.1);
		sound_play_pitchvol(sndBloodGamble, (_heavy ? 0.5 : 0.7) + random(0.2), (_heavy ? 0.7 : 0.5));
		if(_heavy){
			sound_play_pitch(sndHammer, 1 + random(0.2));
		}
		
		 // Effects:
		instance_create(x, y, Dust);
		weapon_post(-9 - (3 * _heavy), 12 + (8 * _heavy), 1);
		motion_add(_dir + (20 * _flip), 3 + _heavy);
		if(_heavy) sleep(10);
	}
	
	 // Fire:
	else if(weapon_ammo_fire(_wep)){
		 // Throw Bone:
		with(projectile_create(x, y, "Bone", gunangle, lerp(16, 20, skill_get(mut_long_arms)))){
			curse = _curse;
			
			 // Death to Free Bones:
			if(other.infammo != 0) broken = true;
		}
		
		 // Sound:
		sound_play(sndChickenThrow);
		sound_play_pitch(sndBloodGamble, 0.7 + random(0.2));
		
		 // Effects:
		weapon_post(-10, -4, 4);
		with(instance_create(x, y, MeleeHitWall)){
			motion_add(other.gunangle, 1);
			image_angle = direction + 180;
		}
	}
	
	 // Gone:
	if(_wep.ammo <= 0 && _fire.wepheld){
		with(_fire.creator){
			if(!_fire.primary){
				player_swap();
			}
			step(_fire.primary);
			if(!_fire.primary){
				player_swap();
			}
		}
	}
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // LWO Setup:
	if(!is_object(_wep)){
		_wep = lq_clone(global.lwoWep);
		wep_set(_primary, "wep", _wep);
	}
	
	 // Holdin Bone:
	if(_wep.ammo > 0){
		 // Extend Bone:
		var	_goal = -5,
			_kick = wep_get(_primary, "wkick", 0);
			
		if(_kick <= 0 && _kick > _goal){
			_kick = max(_goal, _kick - (2 * current_time_scale));
			wep_set(_primary, "wkick", _kick);
		}
		
		 // Pickup Bones:
		if(instance_exists(WepPickup) && place_meeting(x, y, WepPickup)){
			var _inst = instances_meeting(x, y, instances_matching_le(instances_matching(WepPickup, "visible", true), "curse", wep_get(_primary, "curse", 0)));
			if(array_length(_inst)) with(_inst){
				if(place_meeting(x, y, other)){
					if(wep_raw(wep) == mod_current){
						var _num = lq_defget(wep, "ammo", 1);
						_wep.ammo += _num;
						
						 // Pickuped:
						with(other){
							if(_primary || race == "steroids"){
								wep_set(_primary, "wkick", 0);
							}
							else{
								mod_script_call("mod", "tepickups", "pickup_text", "% BONE", _num);
							}
						}
						
						 // Epic Time:
						if(_wep.ammo > stat_get("bone")){
							stat_set("bone", _wep.ammo);
						}
						
						 // Effects:
						with(instance_create(x, y, DiscDisappear)){
							image_angle = other.rotation;
						}
						with(other){
							sound_play_pitch(sndHPPickup, 4);
							sound_play_pitch(sndPickupDisappear, 1.2);
							sound_play_pitchvol(sndBloodGamble, 0.4 + random(0.2), 0.9);
						}
						
						instance_destroy();
					}
				}
			}
		}
		
		 // Bro don't look here:
		if(_wep.ammo >= 10){
			 // E Indicator:
			if(!instance_exists(variable_instance_get(id, "prompt_scythe", noone))){
				prompt_scythe = obj_create(x, y, "Prompt");
				with(prompt_scythe){
					text    = "SCYTHE";
					creator = other;
					index   = other.index;
					depth   = 1000000;
					on_meet = script_ref_create(scythe_prompt_meet);
				}
			}
			prompt_scythe.yoff = sin(other.wave / 10);
			
			 // Bro 10 bones dont fit in a 3x3 square
			if(player_is_active(prompt_scythe.pick)){
				with(prompt_scythe){
					instance_destroy();
				}
				
				 // Give Scythe:
				mod_script_call("weapon", "scythe", "scythe_swap", _primary);
				
				 // Unlock:
				unlock_set("wep:scythe", true);
				
				 // Drop Spare Bones:
				_wep.ammo -= 10;
				if(_wep.ammo > 0) repeat(_wep.ammo){
					with(instance_create(x, y, WepPickup)){
						wep = mod_current;
					}
				}
			}
		}
		else if("prompt_scythe" in self && instance_exists(prompt_scythe)){
			with(prompt_scythe){
				instance_destroy();
			}
		}
	}
	
	 // No Bones Left:
	else{
		wep_set(_primary, "wep", wep_none);
		wep_set(_primary, "wkick", 0);
		
		 // Auto Swap to Secondary:
		if(_primary && instance_is(self, Player)){
			player_swap();
			swapmove  = true;
			drawempty = 30;
			
			 // Prevent Shooting Until Trigger Released:
			if(wep != wep_none && fork()){
				while(instance_exists(self) && canfire && button_check(index, "fire")){
					reload    = max(2 * reloadspeed * current_time_scale, reload);
					can_shoot = false;
					clicked   = false;
					wait 0;
				}
				exit;
			}
		}
	}
	
#define scythe_prompt_meet
	if(other.index == index && wep_raw(other.wep) == mod_current){
		return true;
	}
	return false;
	
	
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
#define unlock_set(_name, _value)                                                       return  mod_script_call_nc  ('mod', 'teassets', 'unlock_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc  ('mod', 'teassets', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc  ('mod', 'teassets', 'stat_set', _name, _value);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call_self('mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc  ('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define player_swap()                                                                   return  mod_script_call_self('mod', 'telib', 'player_swap');