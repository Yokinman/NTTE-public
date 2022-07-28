#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprCrownIcon    = sprite_add("../sprites/crowns/Red/sprCrownRedIcon.png",     1, 12, 16);
	global.sprCrownIdle    = sprite_add("../sprites/crowns/Red/sprCrownRedIdle.png",    10,  8,  8);
	global.sprCrownWalk    = sprite_add("../sprites/crowns/Red/sprCrownRedWalk.png",     6,  8,  8);
	global.sprCrownLoadout = sprite_add("../sprites/crowns/Red/sprCrownRedLoadout.png",  2, 16, 16);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define crown_name        return "RED CROWN";
#define crown_text        return "CHAOTIC @rCRYSTAL HEARTS#@sSMALLER @wAREAS";
#define crown_tip         return choose("FULL OF LIFE", "SO CRAMPED");
#define crown_unlock      return `EXPLORE THE @(color:${call(scr.area_get_back_color, "red")})OTHER SIDE`;
#define crown_avail       return (GameCont.loops > 0 && call(scr.unlock_get, `crown:${mod_current}`));
#define crown_menu_avail  return call(scr.unlock_get, `loadout:crown:${mod_current}`);
#define crown_loadout     return global.sprCrownLoadout;
#define crown_ntte_pack   return "crown";

#define crown_sound
	var _snd = sound_play_gun(sndLaserCrystalDeath, 0, 0.3);
	audio_sound_pitch(_snd, 0.35);
	audio_sound_gain(_snd,  2.00, 0);
	return sndCrownCurses;
	
#define crown_menu_button
	sprite_index = crown_loadout();
	image_index  = !crown_menu_avail();
	dix          = -1;
	diy          = 2;
	
#define crown_button
	sprite_index = global.sprCrownIcon;
	
#define crown_object
	 // Visual:
	spr_idle     = global.sprCrownIdle;
	spr_walk     = global.sprCrownWalk;
	sprite_index = spr_idle;
	
	 // Sound:
	if(instance_is(other, CrownIcon)){
		sound_play_gun(crown_sound(), 0, 0.3);
	}
	
#define ntte_setup_FloorMaker(_inst)
	 // Smaller Levels:
	if(crown_current == mod_current){
		with(_inst){
			goal = round(goal * 0.4);
			
			 // Fix:
			if(instance_number(Floor) > goal){
				with(GenCont){
					if(alarm0 < 0) alarm0 = 3;
					if(alarm2 < 0) alarm2 = 2;
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