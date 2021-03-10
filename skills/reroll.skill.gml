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
					if(skill_get_avail(_skill)){
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
	if(skill_get(mod_current) != 0){
		for(var i = 0; !is_undefined(skill_get_at(i)); i++){
			if(skill_get_at(i) == mod_current){
				var _skillNext = skill_get_at(i + 1);
				if(!is_undefined(_skillNext)){
					GameCont.ntte_reroll     = undefined;
					GameCont.ntte_reroll_hud = _skillNext;
					skill_set(_skillNext, skill_get(_skillNext) * skill_get(mod_current));
					skill_set(mod_current, 0);
				}
				break;
			}
		}
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define skill_get_avail(_skill)                                                         return  mod_script_call_self('mod', 'telib', 'skill_get_avail', _skill);