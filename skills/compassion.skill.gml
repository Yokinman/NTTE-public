#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprSkillIcon = sprite_add("../sprites/skills/Compassion/sprSkillCompassionIcon.png", 1, 12, 16);
	global.sprSkillHUD  = sprite_add("../sprites/skills/Compassion/sprSkillCompassionHUD.png",  1,  8,  8);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define skill_name    return "COMPASSION";
#define skill_text    return "EXTRA @wPET @sSLOT";
#define skill_tip     return "NEW BEST FRIEND";
#define skill_icon    return global.sprSkillHUD;
#define skill_button  sprite_index = global.sprSkillIcon;

#define skill_sound
	audio_sound_pitch(
		sound_play_gun(sndMutLuckyShot, 0, 0.3),
		1.2
	);
	return sndMut;
	
#define skill_avail
	 // Only Appears w/ a Player at Max Pets:
	with(Player){
		var	_pet = variable_instance_get(self, "ntte_pet", []),
			_max = variable_instance_get(self, "ntte_pet_max", array_length(_pet)),
			_num = 0;
			
		if(_max > 0){
			with(_pet) _num += instance_exists(self);
			if(_num >= _max){
				return true;
			}
		}
	}
	
	return (skill_get(mod_current) != 0);
	
#define skill_take(_num)
	var _last = variable_instance_get(GameCont, `skill_last_${mod_current}`, 0);
	variable_instance_set(GameCont, `skill_last_${mod_current}`, _num);
	
	 // Update Max Pets:
	GameCont.ntte_pet_max = variable_instance_get(GameCont, "ntte_pet_max", 1) + (_num - _last);
	with(instances_matching_ne(Player, "ntte_pet_max", null)){
		ntte_pet_max += (_num - _last);
	}
	
	 // Sound:
	if(_num > 0 && instance_exists(LevCont)){
		sound_play_gun(skill_sound(), 0, 0.3);
	}
	
#define skill_lose
	skill_take(0);
	
	
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