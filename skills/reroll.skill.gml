#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprSkillHUD = sprite_add("../sprites/skills/Reroll/sprSkillRerollHUD.png", 1, 8, 8);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define skill_name   return "FLOWER'S BLESSING";
#define skill_text   return `@sREROLL @w${skill_get_name(variable_instance_get(GameCont, "ntte_reroll"))}`;
#define skill_tip    return "~";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;

#define skill_take(_num)
	var _last = variable_instance_get(GameCont, `skill_last_${mod_current}`, 0);
	variable_instance_set(GameCont, `skill_last_${mod_current}`, _num);
	
	 // Reroll Mutation:
	if(_num != 0){
		if(_last == 0){
			GameCont.ntte_reroll_hud = undefined;
			
			 // Find a Mutation to Reroll:
			if("ntte_reroll" not in GameCont || is_undefined(GameCont.ntte_reroll)){
				for(var i = 0; true; i++){
					var _skill = skill_get_at(i);
					if(is_undefined(_skill)){
						break;
					}
					if(call(scr.skill_get_avail, _skill)){
						GameCont.ntte_reroll = _skill;
					}
				}
			}
			
			 // Reroll Mutation:
			if("ntte_reroll" in GameCont && !is_undefined(GameCont.ntte_reroll)){
				skill_set(mod_current, skill_get(mod_current) * skill_get(GameCont.ntte_reroll));
				
				 // Remove Mutation:
				var _playerHealth = [];
				with(Player){
					array_push(_playerHealth, [self, my_health]);
				}
				skill_set(GameCont.ntte_reroll, 0);
				with(_playerHealth){
					with(self[0]){
						if(my_health < other[1]){
							lasthit = [skill_icon(), skill_name()];
						}
					}
				}
				
				 // Give New Mutation:
				GameCont.skillpoints++;
			}
		}
	}
	
	 // Reroll Canceled:
	else if("ntte_reroll" in GameCont && !is_undefined(GameCont.ntte_reroll)){
		if(_last != 0){
			skill_set(GameCont.ntte_reroll, _last);
			GameCont.skillpoints--;
		}
		GameCont.ntte_reroll = undefined;
	}
	
#define skill_lose
	skill_take(0);
	
#define ntte_end_step
	 // Detect Rerolled Mutation:
	if("ntte_reroll_hud" not in GameCont || is_undefined(GameCont.ntte_reroll_hud)){
		if(instance_exists(SkillText)){
			if(skill_get(mod_current) != 0){
				for(var i = 0; true; i++){
					var _skill = skill_get_at(i);
					if(is_undefined(_skill)){
						break;
					}
					if(_skill == mod_current){
						for(var j = i + 1; true; j++){
							var _skillNext = skill_get_at(j);
							if(is_undefined(_skillNext)){
								break;
							}
							GameCont.ntte_reroll_hud = _skillNext;
						}
						
						 // Found:
						if("ntte_reroll_hud" in GameCont && !is_undefined(GameCont.ntte_reroll_hud)){
							var _mult = skill_get(mod_current);
							GameCont.ntte_reroll = undefined;
							skill_set(mod_current, 0);
							skill_set(GameCont.ntte_reroll_hud, skill_get(GameCont.ntte_reroll_hud) * _mult);
						}
						
						break;
					}
				}
			}
		}
	}
	else if(skill_get(GameCont.ntte_reroll_hud) == 0){
		GameCont.ntte_reroll_hud = undefined;
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