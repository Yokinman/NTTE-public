#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Store Script References:
	scr.crime_alert = script_ref_create(crime_alert);
	
	 // Sprites:
	global.sprCrownIcon	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIcon.png",     1, 12, 16);
	global.sprCrownIdle	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIdle.png",    20,  8,  8);
	global.sprCrownWalk	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeWalk.png",     6,	 8,  8);
	global.sprCrownLoadout = sprite_add("../sprites/crowns/Crime/sprCrownCrimeLoadout.png",  2, 16, 16);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#define crown_name        return "CROWN OF CRIME";
#define crown_text        return "FIND @wSMUGGLED GOODS#@sA @rPRICE @sON YOUR HEAD";
#define crown_tip         return choose("THE @wFAMILY@s DOESN'T FORGIVE", "THE @rBAT'S@s EXPERIMENTS", "THE @rCAT'S@s RESOURCES");
#define crown_unlock      return "STOLEN FROM THIEVES";
#define crown_avail       return (call(scr.unlock_get, `crown:${mod_current}`) && GameCont.loops <= 0);
#define crown_menu_avail  return call(scr.unlock_get, `loadout:crown:${mod_current}`);
#define crown_loadout     return global.sprCrownLoadout;
#define crown_ntte_pack   return "crown";

#define crown_sound
	var _snd = sound_play_gun(sndBigWeaponChest, 0, 0.3);
	audio_sound_pitch(_snd, 0.2);
	audio_sound_gain(_snd,  1.5, 0);
	return sndCrownLove;
	
#define crown_menu_button
	sprite_index = crown_loadout();
	image_index  = !crown_menu_avail();
	dix          = -1;
	diy          = 0;
	
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
	 // Bounty Hunters:
	if(!instance_exists(GenCont) && !instance_exists(LevCont)){
		if("ntte_crime_enemy_delay" in GameCont && GameCont.ntte_crime_enemy_delay > 0){
			var _canTick = false;
			if(GameCont.ntte_crime_enemy_delay < 300){
				_canTick = true;
			}
			else with(Player){
				with(instance_nearest(x, y, enemy)){
					if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
						_canTick = true;
						break;
					}
				}
			}
			if(_canTick){
				GameCont.ntte_crime_enemy_delay -= current_time_scale;
			}
			
			 // Early Spawn:
			if(instance_number(enemy) < 8){
				GameCont.ntte_crime_enemy_delay = min(GameCont.ntte_crime_enemy_delay, 30);
			}
		}
		else if("ntte_crime_enemy_count" in GameCont && GameCont.ntte_crime_enemy_count > 0){
			GameCont.ntte_crime_enemy_count--;
			GameCont.ntte_crime_enemy_delay = random_range(120, 180);
			
			var	_isDark   = (array_length(instances_matching(TopCont, "darkness", true)) > 0),
				_spawnX   = 10016,
				_spawnY   = 10016,
				_spawnDis = (_isDark ? 8 : 160),
				_spawnDir = random(360);
				
			with(instance_nearest(_spawnX, _spawnY, (instance_exists(Crown) ? Crown : Player))){
				 // Determine Spawn Direction:
				with(instance_nearest(x, y, Player)){
					_spawnX = x;
					_spawnY = y;
					with(call(scr.instance_nearest_bbox,
						_spawnX + orandom(96),
						_spawnY + orandom(96),
						Wall
					)){
						_spawnDir = point_direction(
							_spawnX,
							_spawnY,
							(bbox_left + bbox_right  + 1) / 2,
							(bbox_top  + bbox_bottom + 1) / 2
						);
					}
				}
				
				 // Alert Effects:
				var	_l = 4,
					_d = _spawnDir;
					
				with(instance_create(x + lengthdir_x(_l, _d), y + 8 + lengthdir_y(_l, _d), AssassinNotice)){
					hspeed = other.hspeed;
					vspeed = other.vspeed;
					motion_add(_d, 2);
					friction = 0.2;
					depth = -9;
				}
				repeat(3) with(instance_create(x, y, Smoke)){
					image_xscale /= 2;
					image_yscale /= 2;
					hspeed += other.hspeed / 2;
					vspeed += other.vspeed / 2;
				}
				sound_play_pitch(sndIDPDNadeAlmost, 0.8);
			}
			
			 // Close Portal:
			call(scr.portal_poof);
			
			 // Spawn Enemy:
			var _pool = [
				[Gator,         5],
				["BabyGator",   2],
				[BuffGator,     3 * (GameCont.hard >= 4)],
				["BoneGator",   3 * (GameCont.hard >= 6)],
				["AlbinoGator", 2 * (GameCont.hard >= 8)]
			];
			for(var _spawnIndex = 0; _spawnIndex < 2; _spawnIndex++){
				with(call(scr.top_create,
					_spawnX,
					_spawnY,
					call(scr.pool, _pool),
					((_spawnIndex == 0) ? _spawnDir : random(360)),
					((_spawnIndex == 0) ? _spawnDis : (_isDark ? 0 : -1))
				)){
					jump_time = 1;
					idle_time = 0;
					
					_spawnX = x;
					_spawnY = y;
					
					with(target){
						 // Type-Specific:
						switch(object_index){
							
							case "BabyGator":
							
								 // Babies Stick Together:
								repeat(1 + irandom(1 + GameCont.loops)){
									with(call(scr.top_create, x, y, "BabyGator", random(360), -1)){
										jump_time = 1;
									}
								}
								
								break;
								
							case FastRat: // maybe?
							
								 // The Horde:
								repeat(3 + irandom(3 + GameCont.loops)){
									with(call(scr.top_create, x, y, FastRat, random(360), -1)){
										jump_time = 1;
									}
								}
								
								 // Large and in Charge:
								with(call(scr.top_create, x, y, RatkingRage, random(360), -1)){
									jump_time = 1;
								}
								
								break;
								
						}
						
						 // Poof:
						repeat(3){
							with(instance_create(x + orandom(8), y + orandom(8), Dust)){
								depth = other.depth - 1;
							}
						}
					}
					
					 // Insta-Fall:
					if(_isDark && place_meeting(x, y, Wall)){
						z = 0;
						with(target){
							motion_add(_spawnDir + 180, 3);
							call(scr.enemy_look, _spawnDir + 180 + orandom(30));
							if(alarm1 > 60){
								alarm1 *= 0.5;
							}
							
							 // Sound:
							var _soundInstance = sound_play_hit_big(snd_dead, 0);
							sound_pitch(_soundInstance,  0.6 + orandom(0.2));
							sound_volume(_soundInstance, 3);
						}
					}
				}
			}
			
			 // Break Through Walls:
			if(_isDark){
				with(instance_create(_spawnX, _spawnY, PortalClear)){
					image_xscale = 1/3;
					image_yscale = image_xscale;
					motion_add(_spawnDir + 180, 2.5);
				}
			}
		}
	}
	
#define crime_alert(_x, _y, _time, _blink)
	/*
		Displays the Crown of Crime's current bounty level near the given position
	*/
	
	var _target = noone;
	
	 // Target Nearby Crown:
	if(instance_exists(Crown)){
		var _disMax = 1/0;
		with(instances_matching(Crown, "visible", true)){
			var _dis = point_distance(x, y, _x, _y);
			if(_dis < _disMax){
				if(point_in_rectangle(x, y, _x - 160, _y - 128, _x + 160, _y + 128)){
					_disMax = _dis;
					_target = self;
				}
			}
		}
	}
	
	 // Target Player:
	if(!instance_exists(_target) && instance_exists(Player)){
		_target = instance_nearest(_x, _y, Player);
	}
	
	 // Create Alert:
	with(_target){
		if("ntte_crime_alert" not in self || !array_equals(ntte_crime_alert, instances_matching_ne(ntte_crime_alert, "id"))){
			if("ntte_crime_alert" in self){
				with(instances_matching_ne(ntte_crime_alert, "id")){
					instance_destroy();
				}
			}
			ntte_crime_alert = [
				call(scr.alert_create, self, spr.CrimeBountyAlert),
				call(scr.alert_create, self, spr.CrimeBountyFillAlert)
			];
			with(ntte_crime_alert){
				flash    = 6;
				target_y = other.ntte_crime_alert[0].target_y;
			}
		}
		for(var i = array_length(ntte_crime_alert) - 1; i >= 0; i--){
			with(ntte_crime_alert[i]){
				image_index = clamp(variable_instance_get(GameCont, `ntte_crime_${(i == 0) ? "active" : "bounty"}`, 0), 0, image_number - 1);
				image_speed = 0;
				visible     = true;
				depth       = ((i == 0) ? -7 : -9);
				alert       = {};
				alarm0      = _time;
				blink       = _blink;
				snd_flash   = sndAppear;
			}
		}
		return ntte_crime_alert;
	}
	
	return noone;
	
	
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