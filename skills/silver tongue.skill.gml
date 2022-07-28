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

#define skill_sound
	audio_sound_pitch(
		sound_play_gun(sndFishUltraA, 0, 0.3),
		1.2
	);
	return sndMut;
	
#define skill_take(_num)
	 // Sound:
	if(_num > 0 && instance_exists(LevCont)){
		sound_play_gun(skill_sound(), 0, 0.3);
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