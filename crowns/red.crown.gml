#define init
	 // Sprites:
	global.sprCrownIcon    = sprite_add("../sprites/crowns/Red/sprCrownRedIcon.png",     1, 12, 16);
	global.sprCrownIdle    = sprite_add("../sprites/crowns/Red/sprCrownRedIdle.png",    10,  8,  8);
	global.sprCrownWalk    = sprite_add("../sprites/crowns/Red/sprCrownRedWalk.png",     6,  8,  8);
	global.sprCrownLoadout = sprite_add("../sprites/crowns/Red/sprCrownRedLoadout.png",  2, 16, 16);
	
#define crown_name        return "RED CROWN";
#define crown_text        return "CHAOTIC @rCRYSTAL HEARTS#@sSMALLER @wAREAS";
#define crown_tip         return choose("FULL OF LIFE", "SO CRAMPED");
#define crown_unlock      return `EXPLORE THE @(color:${area_get_back_color("red")})OTHER SIDE`;
#define crown_avail       return (GameCont.loops > 0 && unlock_get(`crown:${mod_current}`));
#define crown_menu_avail  return unlock_get(`loadout:crown:${mod_current}`);
#define crown_loadout     return global.sprCrownLoadout;
#define crown_ntte_pack   return "crown";

#define crown_menu_button
	sprite_index = crown_loadout();
	image_index = !crown_menu_avail();
	dix = -1;
	diy = 2;
	
#define crown_button
	sprite_index = global.sprCrownIcon;
	
#define crown_object
	 // Visual:
	spr_idle = global.sprCrownIdle;
	spr_walk = global.sprCrownWalk;
	sprite_index = spr_idle;
	
	 // Sound:
	if(instance_is(other, CrownIcon)){
		sound_play_pitch(sndCrownCurses, 1.1);
		sound_play_pitchvol(sndLaserCrystalDeath, 0.35, 2);
	}
	
#define step
	 // Smaller Levels:
	if(instance_exists(FloorMaker)){
		with(instances_matching(FloorMaker, "crownredsmallerlevels", null)){
			crownredsmallerlevels = true;
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
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'telib', 'unlock_get', _unlock);
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);