#define init
	global.sprSkillHUD = sprite_add("../sprites/skills/Reroll/sprSkillRerollHUD.png", 1, 8, 8);
	game_start();
	
#define game_start
	global.skill = null;
	global.last = skill_get(mod_current);
	
#define skill_name   return "FLOWER'S BLESSING";
#define skill_text   return `@sREROLL @w${skill_get_name(global.skill)}`;
#define skill_tip    return "~";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;

#define skill_take(_num)
	if(is_undefined(global.skill)){
		global.skill = 0;
		for(var i = 0; true; i++){
			var s = skill_get_at(i);
			if(is_undefined(s)) break;
			if(s != mod_current) global.skill = s;
		}
	}
	
	 // Replace Skill:
	skill_set(mod_current, skill_get(global.skill));
	var _playerHealth = [];
	with(Player) array_push(_playerHealth, [id, my_health]);
	skill_set(global.skill, 0);
	with(_playerHealth) with(self[0]){
		if(my_health < other[1]) lasthit = [skill_icon(), skill_name()];
	}
	
	 // Give New Mutation:
	if(skill_get(mod_current) == _num){
		with(GameCont) skillpoints++;
	}
	
	global.last = skill_get(mod_current);
	
#define skill_lose
	if(!is_undefined(global.skill) && global.last != 0){
		skill_set(global.skill, global.last);
		with(GameCont) skillpoints--;
	}
	global.skill = null;
	global.last = 0;
	
#define step
	script_bind_end_step(end_step, 0);
	
#define end_step
	instance_destroy();
	
	 // Detect Rerolled Mutation:
	for(var i = 0; !is_undefined(skill_get_at(i)); i++){
		if(skill_get_at(i) == mod_current){
			var _skillNext = skill_get_at(i + 1);
			if(!is_undefined(_skillNext)){
				global.skill = null;
				skill_set(_skillNext, max(skill_get(_skillNext), skill_get(mod_current)));
				skill_set(mod_current, 0);
				mod_variable_set("mod", "ntte", "hud_reroll", _skillNext);
			}
			break;
		}
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));