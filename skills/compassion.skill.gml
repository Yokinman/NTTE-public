#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprSkillIcon = sprite_add("../sprites/skills/Compassion/sprSkillCompassionIcon.png", 1, 12, 16);
	global.sprSkillHUD  = sprite_add("../sprites/skills/Compassion/sprSkillCompassionHUD.png",  1,  8,  8);
	
	 // Reset:
	game_start();
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define game_start
	global.last = skill_get(mod_current);
	
#define skill_name    return "COMPASSION";
#define skill_text    return "EXTRA @wPET @sSLOT";
#define skill_tip     return "NEW BEST FRIEND";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;

#define skill_avail
	 // Only Appears w/ a Player at Max Pets:
	with(Player){
		var	_pet = variable_instance_get(self, "ntte_pet", []),
			_max = variable_instance_get(self, "ntte_pet_max", array_length(_pet)),
			_num = 0;
			
		if(_max > 0){
			with(_pet) _num += instance_exists(self);
			if(_num >= _max) return true;
		}
	}
	
	return false;
	
#define skill_take(_num)
	mod_variable_set("mod", "ntte", "pet_max", mod_variable_get("mod", "ntte", "pet_max") + (_num - global.last));
	with(instances_matching_ne(Player, "ntte_pet_max", null)){
		ntte_pet_max += (_num - global.last);
	}
	global.last = _num;
	
	 // Sound:
	if(_num > 0 && instance_exists(LevCont)){
		sound_play(sndMut);
		sound_play_pitch(sndMutLuckyShot, 1.2);
	}
	
#define skill_lose
	skill_take(0);
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));