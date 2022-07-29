#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep = spr.Bone;
	
	 // Type Stats:
	global.wep_info_list = [
		{ "name": "DROP",                   "text": "",                          "sprt": mskNone,              "swap": sndSwapCursed,  "shrine": mut_none,                         "quest_part_index": -1 },
		{ "name": loc("NTTE:Bone", "BONE"), "text": "BONE THE FISH"/*yokin no*/, "sprt": global.sprWep,        "swap": sndBloodGamble, "shrine": mut_long_arms,                    "quest_part_index": -1 },
		{ "name": "ANCIENT ARTIFACT",       "text": "SECRETS LIE WITHIN",        "sprt": spr.QuestArtifact[0], "swap": sndSwapHammer,  "shrine": [mut_long_arms, mut_laser_brain], "quest_part_index": 0 },
		{ "name": "GUARDED ARTIFACT",       "text": "UNCONVENTIONAL WEAPONRY",   "sprt": spr.QuestArtifact[1], "swap": sndSwapHammer,  "shrine": [mut_long_arms, mut_laser_brain], "quest_part_index": 1 },
		{ "name": "STOLEN ARTIFACT",        "text": "BRING IT BACK",             "sprt": spr.QuestArtifact[2], "swap": sndSwapHammer,  "shrine": [mut_long_arms, mut_laser_brain], "quest_part_index": 2 },
		{ "name": "MISSING ARTIFACT",       "text": "HARDLY FOUND, EASILY LOST", "sprt": spr.QuestArtifact[3], "swap": sndSwapHammer,  "shrine": [mut_long_arms, mut_laser_brain], "quest_part_index": 3 }
	];
	
	 // LWO:
	global.lwoWep = {
		"wep"        : mod_current,
		"ammo"       : 1,
		"ammo_wep"   : wep_none,
		"type_index" : 0,
		"combo"      : 0
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#macro _wepXinfo
	/*
		Bone stats
	*/
	
	global.wep_info_list[
		(lq_defget(_wep, "ammo", 1) > 0)
		? (lq_defget(_wep, "type_index", 0) + 1)
		: 0
	]
	
#define weapon_name(_wep)    return _wepXinfo.name;
#define weapon_text(_wep)    return _wepXinfo.text;
#define weapon_sprt(_wep)    return _wepXinfo.sprt;
#define weapon_swap(_wep)    return _wepXinfo.swap;
#define weapon_shrine(_wep)  return _wepXinfo.shrine;
#define weapon_load          return ((wep_get(true, "curse", 0) > 0) ? 30 : 6); // 0.2 Seconds (Cursed ~ 1 Second)

#define weapon_area
	 // Drops naturally if a player is already carrying bones:
	with(Player){
		if(
			call(scr.wep_raw, wep)  == mod_current ||
			call(scr.wep_raw, bwep) == mod_current
		){
			var _wep = wep;
			if(!_wepXinfo.quest_part_index < 0){
				return 4; // 1-3
			}
		}
	}
	
	 // If not, it don't:
	return -1;
	
#define weapon_type(_wep)
	 // Return Other Weapon's Ammo Type:
	if(instance_is(self, AmmoPickup) && instance_is(other, Player) && other.wep == _wep){
		with(other){
			return weapon_get_type(bwep);
		}
	}
	
	 // Normal:
	return type_melee;
	
#define weapon_sprt_hud(_wep)
	 // Custom Ammo Drawing:
	if(lq_defget(_wep, "ammo", 0) > 1){
		return call(scr.weapon_ammo_hud, _wep);
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
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	var _wepIsPart = (_wepXinfo.quest_part_index >= 0);
	
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
			_heavy = ((++_wep.combo % 2) == 0 && !_wepIsPart),
			_flip  = sign(wepangle),
			_dis   = lerp(10, 20, _skill) + (_wepIsPart ? -16 : 0),
			_dir   = gunangle;
			
		with(call(scr.projectile_create,
			x + hspeed + lengthdir_x(_dis, _dir),
			y + vspeed + lengthdir_y(_dis, _dir),
			(_wepIsPart ? EnergySlash : "BoneSlash"),
			_dir + orandom(5 * accuracy),
			lerp(2, 4, _skill)
		)){
			image_xscale *= 3/4;
			image_yscale *= 3/4 * _flip;
			if(_wepIsPart){
				damage = 25;
				force  = 10;
				switch(_wepXinfo.quest_part_index){
					case 0: sprite_index = spr.EnergyBatSlash;       break;
					case 1: sprite_index = spr.PurpleEnergyBatSlash; break;
					case 2: sprite_index = spr.PopoEnergyBatSlash;   break;
					case 3: sprite_index = spr.EnemyEnergyBatSlash;  break;
				}
			}
			else{
				rotspeed = 2 * _flip;
			}
			if(_heavy){
				heavy = _heavy;
			}
		}
		
		 // Sounds:
		if(_wepIsPart){
			if(skill_get(mut_laser_brain) > 0){
				sound_play_gun(sndEnergySwordUpg, 0.3, 0.3);
				sound_play_pitchvol(sndBlackSword, random_range(0.5, 0.7), 2/3);
			}
			else{
				sound_play_gun(sndEnergySword, 0.3, 0.3);
				sound_play_pitchvol(sndBlackSword, random_range(0.5, 0.7), 2/3);
			}
		}
		else{
			sound_play_gun(sndWrench, 0.3, 0.5);
			sound_play_hit(sndCursedReminder, 0.1);
			sound_play_pitchvol(sndBloodGamble, (_heavy ? 0.5 : 0.7) + random(0.2), (_heavy ? 0.7 : 0.5));
			if(_heavy){
				sound_play_pitch(sndHammer, 1 + random(0.2));
			}
		}
		
		 // Effects:
		instance_create(x, y, Dust);
		weapon_post(-9 - (3 * _heavy), 12 + (8 * _heavy), 1);
		motion_add(_dir + (20 * _flip), 3 + _heavy);
		if(_heavy) sleep(10);
	}
	
	 // Fire:
	else{
		var _lastInfAmmo = infammo;
		if(_wepIsPart){
			infammo = 0;
		}
		if(call(scr.weapon_ammo_fire, _wep)){
			 // Effects:
			weapon_post(-10, -4, 4);
			with(instance_create(x, y, MeleeHitWall)){
				motion_add(other.gunangle, 1);
				image_angle = direction + 180;
			}
			
			 // Sound:
			sound_play(sndChickenThrow);
			if(_wepIsPart){
				sound_play_pitch(sndPlasmaReload, 2 + orandom(0.1));
			}
			else{
				sound_play_pitch(sndBloodGamble, 0.7 + random(0.2));
			}
			
			 // Throw Bone:
			if(_fire.wepheld){
				if("ammo_wep" in _wep && infammo == 0){
					wep   = _wep.ammo_wep;
					wkick = 0;
					
					 // Auto Swap to Secondary:
					if(wep == wep_none && _fire.primary){
						call(scr.player_swap, self);
						clicked   = false;
						swapmove  = true;
						drawempty = 30;
						
						 // Prevent Shooting Until Trigger Released:
						if(wep != wep_none && !_fire.spec && fork()){
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
			}
			else{
				_wep = lq_clone(_wep)
			}
			with(call(scr.projectile_create, x, y, "Bone", gunangle, lerp(16, 20, skill_get(mut_long_arms)))){
				wep          = _wep;
				wep.ammo     = 1;
				wep.ammo_wep = wep_none;
				curse        = _curse;
				sprite_index = weapon_get_sprt(wep);
				
				 // Death to Free Bones:
				if(other.infammo != 0){
					broken = true;
				}
			}
		}
		if(_wepIsPart){
			infammo = _lastInfAmmo;
		}
	}
	
#define step(_primary)
	var _wep = call(scr.weapon_step_init, _primary);
	
	 // Holdin Bone:
	if(_wep.ammo > 0){
		var _wepQuestPartIndex = _wepXinfo.quest_part_index;
		
		 // Extend Bone:
		var	_goal = -5,
			_kick = wep_get(_primary, "wkick", 0);
			
		if(_kick <= 0 && _kick > _goal){
			_kick = max(_goal, _kick - (2 * current_time_scale));
			wep_set(_primary, "wkick", _kick);
		}
		
		 // Pickup Bones:
		if(instance_exists(WepPickup) && place_meeting(x, y, WepPickup)){
			var _inst = call(scr.instances_meeting_instance, self, instances_matching_le(instances_matching(WepPickup, "visible", true), "curse", wep_get(_primary, "curse", 0)));
			if(array_length(_inst)) with(_inst){
				if(place_meeting(x, y, other)){
					if(call(scr.wep_raw, wep) == mod_current){
						var	_newWep               = wep,
							_newWepAmmo           = lq_defget(_newWep, "ammo", 1),
							_newWepQuestPartIndex = global.wep_info_list[(_newWepAmmo > 0) ? (lq_defget(_newWep, "type_index", 0) + 1) : 0].quest_part_index;
							
						if(
							(_wepQuestPartIndex >= 0) == (_newWepQuestPartIndex >= 0)
							&& ((_newWepQuestPartIndex < 0) || instance_exists(enemy) || !array_length(call(scr.instances_meeting_instance, self, obj.QuestFloorCont)))
						){
							if(!is_object(_newWep)){
								_newWep = { "wep" : _newWep };
							}
							_newWep.ammo     = _newWepAmmo + lq_defget(_wep, "ammo", 1);
							_newWep.ammo_wep = _wep;
							_wep             = _newWep;
							if(_primary){
								other.wep = _wep;
							}
							else{
								other.bwep = _wep;
							}
							
							 // Pickuped:
							with(other){
								var _isHeld = (_primary || race == "steroids");
								if(_isHeld){
									wep_set(_primary, "wkick", 0);
									if(_newWepQuestPartIndex >= 0){
										gunshine = max(gunshine, 2);
									}
								}
								if(!_isHeld || _newWepQuestPartIndex >= 0){
									call(scr.pickup_text, weapon_get_name(_newWep), "got", _newWepAmmo);
								}
							}
							
							 // Epic Time:
							if(_newWepQuestPartIndex < 0 && _wep.ammo > call(scr.stat_get, "bone")){
								call(scr.stat_set, "bone", _wep.ammo);
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
		}
		
		 // Sparkly:
		if(_wepQuestPartIndex >= 0){
			if(_primary && chance_ct(1, 20)){
				var	_len = random_range(4, 12) - _kick,
					_dir = gunangle + ((_primary ? wepangle : bwepangle) * (1 - (_kick / 20)));
					
				with(call(scr.obj_create,
					x + lengthdir_x(_len, _dir) + orandom(4),
					y + lengthdir_y(_len, _dir) + orandom(4),
					"VaultFlowerSparkle"
				)){
					sprite_index = spr.QuestSparkle;
					depth		 = other.depth + (_primary ? -1 : 1);
					switch(_wepQuestPartIndex){
						case 0 : sprite_index = spr.AllyLaserCharge;    break;
						case 1 : sprite_index = spr.ElectroPlasmaTrail; break;
						case 2 : sprite_index = sprIDPDPortalCharge;    break;
						case 3 : sprite_index = sprLaserCharge;         break;
					}
				}
			}
		}
		
		 // Bro don't look here:
		else if(_wep.ammo >= 10){
			 // E Indicator:
			if(!instance_exists(variable_instance_get(self, "prompt_scythe", noone))){
				prompt_scythe = call(scr.prompt_create, self, loc("NTTE:Bone:Prompt", "SCYTHE"));
				with(prompt_scythe){
					depth   = 1000000;
					index   = other.index;
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
				call(scr.scythe_swap, _primary);
				
				 // Unlock:
				call(scr.unlock_set, "wep:scythe", true);
				
				 // Drop Spare Bones:
				repeat(10){
					if(is_object(_wep) && "ammo_wep" in _wep){
						_wep = _wep.ammo_wep;
					}
					else break;
				}
				if(_wep != wep_none){
					with(instance_create(x, y, WepPickup)){
						wep = _wep;
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
		_wep = lq_defget(_wep, "ammo_wep", wep_none);
		wep_set(_primary, "wep",   _wep);
		wep_set(_primary, "wkick", 0);
		
		 // Auto Swap to Secondary:
		if(_wep == wep_none && _primary && instance_is(self, Player)){
			call(scr.player_swap, self);
			clicked   = false;
			swapmove  = true;
			drawempty = 30;
		}
	}
	
#define scythe_prompt_meet
	return (other.index == index && call(scr.wep_raw, other.wep) == mod_current);
	
	
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