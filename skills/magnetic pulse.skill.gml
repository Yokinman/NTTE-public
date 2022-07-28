#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprSkillHUD = sprite_add("../sprites/skills/Magnetic Pulse/sprMagneticPulseHUD.png", 1, 8, 8);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define skill_name   return "MAGNETIC PULSE";
#define skill_text   return "CHANCE @bI.D.P.D. @sDIE @wON ENTRY";
#define skill_tip    return "SHORT CIRCUIT";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;
#define skill_rat    return true;

#define skill_sound
	audio_sound_pitch(
		sound_play_gun(sndShielderDeadF, 0, 0.3),
		0.75
	);
	return sndMutGammaGuts;
	
#define skill_take(_num)
	 // Sound:
	if(_num > 0 && instance_exists(LevCont)){
		sound_play_gun(skill_sound(), 0, 0.3);
	}
	
	 // Bind Popo Killing Script:
	if(is_undefined(lq_get(ntte, "ntte_setup_magnetic_pulse_enemy"))){
		ntte.bind_setup_magnetic_pulse_enemy = call(scr.ntte_bind_setup, script_ref_create(ntte_setup_magnetic_pulse_enemy), enemy);
	}
	
#define ntte_setup_magnetic_pulse_enemy(_inst)
	 // 50% of IDPD Have Heart Attacks:
	if(skill_get(mod_current) != 0){
		with(instances_matching_lt(_inst, "size", 4)){
			if(team == 3 || instance_is(self, PopoFreak)){
				if(!chance(1, power(2, abs(skill_get(mod_current))))){
					if(skill_get(mod_current) > 0){
						my_health = min(my_health, 0);
					}
					else{
						my_health *= 2;
						maxhealth *= 2;
					}
				}
			}
		}
	}
	
	 // Unbind Script:
	else if(!is_undefined(lq_get(ntte, "bind_setup_magnetic_pulse_enemy"))){
		call(scr.ntte_unbind, ntte.bind_setup_magnetic_pulse_enemy);
		ntte.bind_setup_magnetic_pulse_enemy = undefined;
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