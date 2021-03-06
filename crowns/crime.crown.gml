#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprCrownIcon	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIcon.png",     1, 12, 16);
	global.sprCrownIdle	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeIdle.png",    20,  8,  8);
	global.sprCrownWalk	   = sprite_add("../sprites/crowns/Crime/sprCrownCrimeWalk.png",     6,	 8,  8);
	global.sprCrownLoadout = sprite_add("../sprites/crowns/Crime/sprCrownCrimeLoadout.png",  2, 16, 16);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define crown_name        return "CROWN OF CRIME";
#define crown_text        return "FIND @wSMUGGLED GOODS#@sA @rPRICE @sON YOUR HEAD";
#define crown_tip         return choose("THE @wFAMILY@s DOESN'T FORGIVE", "THE @rBAT'S@s EXPERIMENTS", "THE @rCAT'S@s RESOURCES", "THE WASTELAND WEAPON TRADE");
#define crown_unlock      return "STOLEN FROM THIEVES";
#define crown_avail       return (unlock_get(`crown:${mod_current}`) && GameCont.loops <= 0);
#define crown_menu_avail  return unlock_get(`loadout:crown:${mod_current}`);
#define crown_loadout     return global.sprCrownLoadout;
#define crown_ntte_pack   return "crown";

#define crown_menu_button
	sprite_index = crown_loadout();
	image_index = !crown_menu_avail();
	dix = -1;
	diy = 0;
	
#define crown_button
	sprite_index = global.sprCrownIcon;
	
#define crown_object
	 // Visual:
	spr_idle = global.sprCrownIdle;
	spr_walk = global.sprCrownWalk;
	sprite_index = spr_idle;
	
	 // Vars:
	ntte_crown = mod_current;
	enemy_time = 0;
	enemies = 0;
	
	 // Sound:
	if(instance_is(other, CrownIcon)){
		sound_play_pitch(sndCrownLove, 1.1);
		sound_play_pitchvol(sndBigWeaponChest, 0.2, 1.5);
	}
	
#define step
	 // Bounty Hunters:
	if(!(GameCont.area == 7 && GameCont.subarea == 3)){
		with(instances_matching(Crown, "ntte_crown", "crime")){
			 // Watch where you're going bro:
			if(hspeed != 0 && sign(image_xscale) != sign(hspeed)){
				image_xscale = abs(image_xscale) * sign(hspeed);
			}
			
			 // Spawn Enemies:
			if(enemies > 0){
				enemy_time -= current_time_scale;
				
				if(enemy_time <= 0){
					var	_spawnX = x,
						_spawnY = y,
						_spawnDis = 240,
						_spawnDir = random(360);
						
					with(instance_furthest(_spawnX - 16, _spawnY - 16, Floor)){                                                                           
						_spawnDir = point_direction((bbox_left + bbox_right + 1) / 2, (bbox_top + bbox_bottom + 1) / 2, _spawnX, _spawnY);
					}
					
					 // Effects:
					var	l = 4,
						d = _spawnDir;
						
					with(instance_create(x + lengthdir_x(l, d), y + 8 + lengthdir_y(l, d), AssassinNotice)){
						hspeed = other.hspeed;
						vspeed = other.vspeed;
						motion_add(d, 2);
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
					
					 // Spawn:
					var _pool = [
						[Gator,         5],
						["BabyGator",   2],
						[BuffGator,     3 * (GameCont.hard >= 4)],
						["BoneGator",   3 * (GameCont.hard >= 6)],
						["AlbinoGator", 2 * (GameCont.hard >= 8)]
					];
					while(enemies > 0){
						enemies--;
						
						portal_poof();
						
						with(top_create(_spawnX, _spawnY, pool(_pool), _spawnDir, _spawnDis)){
							jump_time = 1;
							idle_time = 0;
							
							_spawnX = x;
							_spawnY = y;
							_spawnDir = random(360);
							_spawnDis = -1;
							
							with(target){
								 // Type-Specific:
								switch(object_index){
									case "BabyGator":
										 // Babies Stick Together:
										var n = 1 + irandom(1 + GameCont.loops);
										repeat(n) with(top_create(x, y, "BabyGator", random(360), -1)){
											jump_time = 1;
										}
										break;
										
									case FastRat: // maybe?
										 // The Horde:
										var n = 3 + irandom(3 + GameCont.loops);
										repeat(n) with(top_create(x, y, FastRat, random(360), -1)){
											jump_time = 1;
										}
										
										 // Large and in Charge:
										with(top_create(x, y, RatkingRage, random(360), -1)){
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
						}
					}
				}
			}
		}
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define portal_poof()                                                                   return  mod_script_call_nc('mod', 'telib', 'portal_poof');
#define pool(_pool)                                                                     return  mod_script_call_nc('mod', 'telib', 'pool', _pool);