#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	
	 // Sprites:
	global.sprWep            = spr.Trident;
	global.sprWepGold        = spr.GoldTrident;
	global.sprWepLoadout     = spr.TridentLoadout;
	global.sprWepGoldLoadout = spr.GoldTridentLoadout;
	global.sprWepLocked      = mskNone;
	
	 // LWO:
	global.lwoWep = {
		wep      : mod_current,
		gold     : false,
		chrg     : false,
		chrg_num : 0,
		chrg_max : 7,
		chrg_obj : noone,
		stab_dis : 14,
		wepangle : 0,
		primary  : true,
		visible  : true,
		last     : 0
	};
	
#macro spr global.spr

#define weapon_name(_wep)   return (weapon_avail(_wep) ? ((weapon_gold(_wep) != 0) ? "GOLDEN " : "") + "TRIDENT" : "LOCKED");
#define weapon_text(_wep)   return ((weapon_get_gold(_wep) != 0) ? "SHINE THROUGH THE SKY" : "SCEPTER OF THE @bSEA");
#define weapon_swap(_wep)   return (lq_defget(_wep, "visible", true) ? sndSwapSword : sndSwapCursed);
#define weapon_sprt(_wep)   return (lq_defget(_wep, "visible", true) ? (weapon_avail() ? ((weapon_get_gold(_wep) != 0) ? global.sprWepGold : global.sprWep) : global.sprWepLocked) : mskNone);
#define weapon_loadout      return ((argument_count > 0 && weapon_get_gold(argument0) != 0) ? global.sprWepGoldLoadout : global.sprWepLoadout);
#define weapon_area(_wep)   return ((argument_count > 0 && weapon_avail(_wep) && weapon_get_gold(_wep) == 0) ? 7 : -1); // 3-2
#define weapon_gold(_wep)   return (lq_defget(_wep, "gold", false) ? -1 : 0);
#define weapon_type(_wep)   return type_melee;
#define weapon_auto(_wep)   return true;
#define weapon_melee(_wep)  return false;
#define weapon_avail        return (unlock_get("pack:" + weapon_ntte_pack()) || unlock_get("wep:" + mod_current));
#define weapon_ntte_pack    return "coast";
#define weapon_shrine       return [mut_long_arms, mut_bolt_marrow];
#define weapon_chrg         return true; // Defpack 4

#define weapon_load(_wep)
	 // Stab Reload:
	if(is_object(_wep) && instance_is(self, Player)){
		if((wep == _wep && reload > 0 && !can_shoot) || (bwep == _wep && breload > 0 && !bcan_shoot)){
			return _wep.stab_dis;
		}
	}
	
	 // Normal:
	return current_time_scale;
	
#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Charge Trident:
	if(_wep.visible){
		_wep.chrg = true;
		_wep.primary = !(_fire.spec && _fire.roids);
		
		 // Charging:
		if(_wep.chrg_num < _wep.chrg_max){
			_wep.chrg_num += current_time_scale;
			
			 // Charging FX:
			sound_play_pitch(sndOasisMelee, 1 / (1 - ((_wep.chrg_num / _wep.chrg_max) * 0.25)));
			
			 // Full Charge:
			if(_wep.chrg_num >= _wep.chrg_max){
				_wep.chrg_num = _wep.chrg_max;
				
				 // FX:
				var	_l = 16,
					_d = gunangle;
					
				instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), ThrowHit);
				instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), ImpactWrists);
				sound_play_pitch(sndCrystalRicochet, 3);
				sound_play_pitch(sndSewerDrip,       3);
				sleep(5);
			}
		}
		
		 // Fully Charged - Blink:
		else if(frame_active(12)){
			with(_fire.creator) if(instance_is(self, Player)){
				gunshine = 2;
			}
		}
		
		 // Pullback:
		if(_wep.last < current_frame){
			_wep.last = current_frame;
			var _num = (_wep.chrg_num / _wep.chrg_max);
			weapon_post(9 * _num, 8 * _num * current_time_scale, 0);
		}
		
		 // Pop Pop, Blood Gamble:
		if(_fire.spec && !_fire.roids){
			_wep.chrg_num = _wep.chrg_max;
		}
		
		 // Charge Controller:
		if(!instance_exists(_wep.chrg_obj)){
			_wep.chrg_obj = script_bind_step(trident_chrg, 0, _wep);
		}
		with(_wep.chrg_obj){
			x         = other.x;
			y         = other.y;
			direction = other.gunangle;
			team      = other.team;
			creator   = _fire.creator;
		}
	}
	
#define trident_chrg(_wep)
	if(!_wep.chrg){
		with(creator){
			if(_wep.chrg_num > 0){
				if(wep_get(_wep.primary, "wep", _wep) == _wep){
					 // Throw Trident:
					if(_wep.chrg_num >= _wep.chrg_max){
						var _curse = wep_get(_wep.primary, "curse", false);
						
						 // Trident:
						with(other){
							with(projectile_create(x, y, "Trident", direction, 18 * (1 + (0.3 * _wep.gold)))){
								sprite_index = weapon_get_sprt(_wep);
								curse        = _curse;
								wep          = _wep;
							}
						}
						if(instance_is(self, Player) || instance_is(self, FireCont)){
							weapon_post(wkick, 50, 5);
						}
						wep_set(_wep.primary, "wkick", -4);
						
						 // Lose Trident:
						if(wep_get(_wep.primary, "wep", null) == _wep){
							if(_curse <= 0){
								wep_set(_wep.primary, "wep",   wep_none);
								wep_set(_wep.primary, "wkick", 0);
								
								 // Swap to Secondary:
								if(instance_is(self, Player) && _wep.primary){
									player_swap();
								}
							}
							else _wep.visible = false;
						}
					}
					
					 // Stab Trident:
					else{
						var	_dis = _wep.stab_dis,
							_dir = other.direction;
							
						 // Reload:
						wep_set(_wep.primary, "reload",    _dis);
						wep_set(_wep.primary, "can_shoot", false);
						
						 // Long Arms:
						_dis += 8 * skill_get(mut_long_arms);
						
						 // Stabby:
						if(instance_is(self, Player)){
							weapon_post(wkick, -20, 8);
						}
						wep_set(_wep.primary, "wkick", -_dis);
						
						 // Stab:
						with(other){
							var _off = 220 / _dis;
							for(var _ang = -_off; _ang <= _off; _ang += _off){
								for(var i = _dis + (8 * ((_ang == 0) ? 1 : 2/3)); i > 0; i -= 16){
									with(projectile_create(
										other.x + other.hspeed + lengthdir_x(i, _dir + _ang),
										other.y + other.vspeed + lengthdir_y(i, _dir + _ang) - (_wep.primary ? 0 : 4),
										Shank,
										_dir + (_ang / 3),
										(1 + skill_get(mut_long_arms)) * ((_ang == 0) ? 1 : 0.5)
									)){
										image_xscale = 0.5 + (0.1 * (_ang == 0));
										image_yscale = 0.9;
										canfix       = false;
										damage       = 20;
										
										 // Depth:
										if(instance_exists(creator)){
											depth = creator.depth - (1 + (0.1 * (_ang != 0)));
										}
										
										 // Secret Shanks:
										if(i < _dis){
											visible = false;
										}
										
										 // Hit Wall:
										else if(place_meeting(x + hspeed, y + vspeed, Wall)){
											sound_play(sndMeleeWall);
											instance_create(x + orandom(4), y + orandom(4), Debris);
											with(instance_nearest(x + hspeed - 8, y + vspeed - 8, Wall)){
												with(instance_create(((bbox_left + bbox_right + 1) / 2) + orandom(4), ((bbox_top + bbox_bottom + 1) / 2) + orandom(4), MeleeHitWall)){
													image_angle = _dir;
												}
											}
										}
									}
								}
							}
						}
					}
					
					 // Sounds:
					var _pitch = random_range(0.8, 1.2);
					sound_play_pitchvol(sndAssassinAttack,      1.3 * _pitch, 1.6);
					sound_play_pitchvol(sndOasisExplosionSmall, 0.7 * _pitch, 0.7);
					sound_play_pitchvol(sndOasisDeath,          1.2 * _pitch, 0.8);
					sound_play_pitchvol(sndOasisMelee,          1   * _pitch, 1);
					if(_wep.gold){
						sound_play_pitchvol(sndSwapGold,        0.8 * _pitch, 0.7);
					}
					
					 // bubbol:
					var _dis = 24;
					with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Bubble)){
						direction = _dir + orandom(30);
						speed = choose(1, 2, 2, 3, 3);
					}
					sleep(15);
				}
			}
			_wep.chrg_num = 0;
		}
		instance_destroy();
	}
	_wep.chrg = false;
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // LWO Setup:
	if(!is_object(_wep)){
		_wep = lq_clone(global.lwoWep);
		wep_set(_primary, "wep", _wep);
	}
	
	 // Cursed Trident Grab Reorient:
	if(_wep.wepangle != 0){
		script_bind_end_step(end_step, 0, _primary, _wep, self);
	}
	
#define end_step(_primary, _wep, _inst)
	instance_destroy();
	
	 // Wepangle Transition:
	if(is_object(_wep) && "wepangle" in _wep){
		with(_inst){
			if(_wep == wep_get(_primary, "wep", null)){
				wep_set(_primary, "wepangle", _wep.wepangle);
				
				_wep.wepangle -= clamp(_wep.wepangle * 0.4, -40, 40) * current_time_scale;
				
				if(abs(_wep.wepangle) < 1){
					_wep.wepangle = 0;
				}
			}
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
#define frame_active(_interval)                                                         return  mod_script_call_nc  ('mod', 'telib', 'frame_active', _interval);
#define player_swap()                                                                   return  mod_script_call_self('mod', 'telib', 'player_swap');