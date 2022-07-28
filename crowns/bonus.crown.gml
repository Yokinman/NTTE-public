#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprCrownIcon	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusIcon.png",     1, 12, 16);
	global.sprCrownIdle	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusIdle.png",    15,  8,  8);
	global.sprCrownWalk	   = sprite_add("../sprites/crowns/Bonus/sprCrownBonusWalk.png",     6,  8,  8);
	global.sprCrownLoadout = sprite_add("../sprites/crowns/Bonus/sprCrownBonusLoadout.png",  2, 16, 16);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define crown_name        return "CROWN OF BONUS";
#define crown_text        return "@bBONUS AMMO PICKUPS#@sREPLACE @wAMMO @sAND @wHP DROPS";
#define crown_tip         return "ALL EXTRA";
#define crown_avail       return (GameCont.loops > 0);
#define crown_menu_avail  return call(scr.unlock_get, `loadout:crown:${mod_current}`);
#define crown_loadout     return global.sprCrownLoadout;
#define crown_ntte_pack   return "crown";

#define crown_sound
	var _snd = sound_play_gun(sndRogueCanister, 0, 0.3);
	audio_sound_pitch(_snd, 0.7);
	audio_sound_gain(_snd,  1.4, 0);
	return sndCrownProtection;
	
#define crown_menu_button
	sprite_index = crown_loadout();
	image_index  = !crown_menu_avail();
	dix          = -1;
	diy          = 1;
	
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
	
#define step
	 // Bind Pickup Replacement Script:
	if(is_undefined(lq_get(ntte, "bind_setup_bonus"))){
		ntte.bind_setup_bonus = call(scr.ntte_bind_setup, script_ref_create(ntte_setup_bonus), [AmmoPickup, HPPickup, AmmoChest, HealthChest, Mimic, SuperMimic]);
	}
	
#define ntte_setup_bonus(_inst)
	 // Crown of Bonus:
	if(crown_current == mod_current){
		if(!instance_exists(GenCont)){
			with(instances_matching(_inst, "bonus_pickup_check", null)){
				bonus_pickup_check = true;
				
				if(!position_meeting(xstart, ystart, ChestOpen)){
					var _num = 0;
					
					with(instances_matching_gt(Player, "bonus_ammo", 0)){
						_num += bonus_ammo;
					}
					
					if(
						chance(60, _num)
						|| place_meeting(x, y, Player)
						|| place_meeting(x, y, Portal)
					){
						if(instance_is(self, Pickup)){
							call(scr.obj_create, x, y, "BonusAmmoPickup");
						}
						else{
							call(scr.chest_create, x, y, `BonusAmmo${instance_is(self, enemy) ? "Mimic" : "Chest"}`);
						}
					}
					
					instance_delete(self);
				}
			}
		}
	}
	
	 // Unbind Script:
	else if(!is_undefined(lq_get(ntte, "bind_setup_bonus"))){
		call(scr.ntte_unbind, ntte.bind_setup_bonus);
		ntte.bind_setup_bonus = undefined;
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