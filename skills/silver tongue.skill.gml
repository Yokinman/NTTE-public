#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprSkillIcon = sprite_add("../sprites/skills/Silver Tongue/sprSkillSilverTongueIcon.png", 1, 12, 16);
	global.sprSkillHUD  = sprite_add("../sprites/skills/Silver Tongue/sprSkillSilverTongueHUD.png",  1,  8,  8);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define skill_name    return "SILVER TONGUE";
#define skill_text    return `FIND @wSMUGGLED GOODS#@(color:${make_color_rgb(175, 143, 106)})THE FAMILY CONCEDES`;
#define skill_tip     return "DIPLOMACY";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;
#define skill_avail   return (skill_get(mod_current) != 0);

#define skill_take(_num)
	 // Sound:
	if(_num > 0 && instance_exists(LevCont)){
		sound_play(sndMut);
		sound_play_pitch(sndFishUltraA, 1.2);
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));