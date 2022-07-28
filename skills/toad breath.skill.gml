#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprSkillHUD = sprite_add("../sprites/skills/Toad Breath/sprToadBreathHUD.png", 1, 8, 8);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro player_active visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)

#define skill_name     return "TOAD BREATH";
#define skill_text     return "@gTOXIC GAS @sIS @wBREATHABLE";
#define skill_tip      return "CORROSION";
#define skill_icon     return global.sprSkillHUD;
#define skill_wepspec  return true;
#define skill_avail    return false;
#define skill_rat      return true;

#define skill_sound
	sound_play_gun(sndFrogGasRelease, 0.1, 0.3);
	return sndMutEuphoria;
	
#define skill_take(_num)
	if(_num != 0){
		 // Fart:
		with(Player){
			if(player_active){
				with(instance_create(x, y, ToxicDelay)){
					team    = other.team;
					creator = other;
					alarm0  = 1;
				}
				sound_play_hit(sndFrogGasRelease, 0.1);
			}
		}
		
		 // Sound:
		if(_num > 0 && instance_exists(LevCont)){
			sound_play_gun(skill_sound(), 0, 0.3);
		}
	}
	
#define ntte_step
	 // Friendly Gas:
	if(skill_get(mod_current) > 0){
		if(instance_exists(Player)){
			if(instance_exists(ToxicGas)){
				with(instances_matching(ToxicGas, "team", 0, -1)){
					with(instance_nearest(x, y, Player)){
						other.team = team;
					}
				}
			}
			
			 // Cool Breath FX:
			var _inst = instances_matching_ne(instances_matching(Player, "speed", 0), "race", "robot");
			if(array_length(_inst)){
				with(_inst){
					if(
						(wave % 30) < current_time_scale
						&& player_active
						&& chance(1, 2)
					){
						with(instance_create(x, y - (4 * (race == "plant")), Breath)){
							image_xscale = other.right;
							image_blend  = make_color_rgb(108, 195, 4);
							image_alpha  = 1;
						}
					}
				}
			}
		}
	}
	
#define ntte_end_step
	 // Push Toxic Gas:
	var _num = skill_get(mod_current);
	if(_num != 0){
		if(instance_exists(ToxicGas) && instance_exists(Player)){
			var _inst = instances_matching_ne(Player, "speed", 0);
			if(array_length(_inst)){
				with(_inst){
					if(place_meeting(x, y, ToxicGas)){
						with(call(scr.instances_meeting_instance, self, ToxicGas)){
							if(place_meeting(x, y, other)){
								 // Suck:
								var _lerp = min(1, abs(_num) / 50);
								x = call(scr.lerp_ct, x, other.x, _lerp);
								y = call(scr.lerp_ct, y, other.y, _lerp);
								
								 // Blow:
								var _speedMax = max(other.speed * _num, speed);
								motion_add_ct(
									call(scr.angle_lerp,
										other.direction,
										point_direction(other.x, other.y, x, y),
										clamp((point_distance(x, y, other.x, other.y) - 8) / 16, 0, 1)
									),
									(other.speed / 4) * abs(_num)
								);
								if(speed > _speedMax){
									speed = _speedMax;
								}
							}
						}
					}
				}
			}
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
#macro  current_frame_active                                                                    ((current_frame + global.epsilon) % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);