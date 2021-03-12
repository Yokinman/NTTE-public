#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Mod Lists:
	ntte_mods = mod_variable_get("mod", "teassets", "mods");
	
	 // Bind Events:
	global.wall_fake_bind = [
		script_bind(CustomDraw, script_ref_create(draw_wall_fake, "Bot"), 4,                                false),
		script_bind(CustomDraw, script_ref_create(draw_wall_fake, "Top"), object_get_depth(SubTopCont) + 1, false)
	];
	global.wall_fake_bind_reveal = [];
	with(global.wall_fake_bind){
		array_push(
			global.wall_fake_bind_reveal,
			script_bind(object, draw_wall_fake_reveal, depth - ((script[1] == "Bot") ? 2 : 1), visible)
		);
	}
	global.wall_shine_bind = script_bind(CustomDraw, draw_wall_shine, object_get_depth(SubTopCont), false);
	
	 // Surfaces:
	surfWallFakeMaskBot = surface_setup("RedWallFakeMaskBot", null, null, null);
	surfWallFakeMaskTop = surface_setup("RedWallFakeMaskTop", null, null, null);
	surfWallShineMask   = surface_setup("RedWallShineMask",   null, null, null);
	with(surfWallFakeMaskBot){
		wall_num  = 0;
		wall_min  = 0;
		wall_inst = [];
	}
	with(surfWallShineMask){
		wall_num  = 0;
		wall_min  = 0;
		wall_inst = [];
		tops_inst = [];
	}
	
	 // Objects w/ Draw Events:
	var _hasEvent = [Player, CrystalShield, Sapling, Ally, RogueStrike, DogMissile, PlayerSit, UberCont, BackCont, TopCont, KeyCont, GenCont, NothingSpiral, Credits, SubTopCont, BanditBoss, Drama, ScrapBossMissile, ScrapBoss, LilHunter, LilHunterFly, Nothing, NothingInactive, BecomeNothing, Carpet, NothingBeam, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, LastIntro, LastCutscene, Last, DramaCamera, BigFish, ProtoStatue, Campfire, LightBeam, TV, SentryGun, Disc, PlasmaBall, PlasmaBig, Lightning, IonBurst, Laser, PlasmaHuge, ConfettiBall, Nuke, Rocket, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, BigMaggotBurrow, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, GatorSmoke, Rat, FastRat, RatkingRage, MeleeBandit, SuperMimic, Sniper, Raven, RavenFly, Salamander, Spider, LaserCrystal, EnemyLightning, LightningCrystal, EnemyLaser, SnowTank, GoldSnowTank, SnowBot, CarThrow, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, CrownGuardianOld, CrownGuardian, Molefish, FireBaller, JockRocket, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoPlasmaBall, PopoRocket, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, PopoShield, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleBandit, EnemyHorror, RainDrop, SnowFlake, PopupText, Confetti, WepPickup, Menu, BackFromCharSelect, CharSelect, GoButton, Loadout, LoadoutCrown, LoadoutWep, LoadoutSkin, CampChar, MainMenu, PlayMenuButton, TutorialButton, MainMenuButton, StatMenu, StatButton, DailyArrow, WeeklyArrow, DailyScores, WeeklyScores, WeeklyProgress, DailyMenuButton, menubutton, BackMainMenu, UnlockAll, IntroLogo, MenuOLDOLD, OptionSelect, MusVolSlider, SfxVolSlider, AmbVolSlider, FullScreenToggle, FitScreenToggle, GamePadToggle, MouseCPToggle, CoopToggle, QToggle, ScaleUpDown, ShakeUpDown, AutoAimUpDown, BSkinLoadout, CrownLoadout, StatsSelect, CrownSelect, DailyToggle, UpdateSelect, CreditsSelect, LoadoutSelect, MenuOLD, Vlambeer, QuitSelect, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, SkillText, LevCont, mutbutton, PauseButton, GameOverButton, UnlockPopup, UnlockScreen, BUnlockScreen, UnlockButton, OptionMenuButton, VisualsMenuButton, AudioMenuButton, GameMenuButton, ControlMenuButton, CustomObject, CustomHitme, CustomProjectile, CustomSlash, CustomEnemy, CustomDraw, Dispose, asset_get_index("MultiMenu")];
	global.draw_event_exists = [];
	for(var i = 0; object_exists(i); i++){
		array_push(global.draw_event_exists, (array_find_index(_hasEvent, i) >= 0));
	}
	
	 // Client-Side Darkness:
	//clientDarknessCoeff = array_create(maxp, 0);
	//clientDarknessFloor = [];
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro ntte_mods global.mods

#macro surfWallFakeMaskBot global.surfWallFakeMaskBot
#macro surfWallFakeMaskTop global.surfWallFakeMaskTop
#macro surfWallShineMask   global.surfWallShineMask

//#macro clientDarknessCoeff global.clientDarknessCoeff
//#macro clientDarknessFloor global.clientDarknessFloor

#define BigCrystalProp_create(_x, _y)
	with(instance_create(_x, _y, CrystalProp)){
		 // Visual:
		spr_idle     = spr.BigCrystalPropIdle;
		spr_hurt     = spr.BigCrystalPropHurt;
		spr_dead     = spr.BigCrystalPropDead;
		spr_shadow   = -1;
		sprite_index = spr_idle;
		depth        = -1;
		
		 // Vars:
		maxhealth = 48;
		my_health = maxhealth;
		size      = 2;
		
		 // Enemies:
		instance_create(x, y, PortalClear);
		repeat(choose(2, 3)){
			obj_create(x, y, ((GameCont.area == area_cursed_caves) ? "InvCrystalBat" : "CrystalBat"));
		}
		
		return self;
	}
	
	
#define ChaosHeart_create(_x, _y)
	/*
		A special variant of crystal hearts unique to the red crown
		Generates random areas on death and cannot be used to access the warp zone
	*/
	
	with(obj_create(_x, _y, "CrystalHeart")){
		 // Visual:
		spr_idle     = spr.ChaosHeartIdle;
		spr_walk     = spr.ChaosHeartIdle;
		spr_hurt     = spr.ChaosHeartHurt;
		spr_dead     = spr.ChaosHeartDead;
		hitid        = [spr_idle, "CHAOS HEART"];
		sprite_index = spr_idle;
		
		 // Vars:
		white    = true;
		canmelee = true;
		area     = null;
		
		return self;
	}
	

#define CrystalBat_create(_x, _y)
	/*
		An enemy for the Crystal Caves, charges at the player in cardinal directions only
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.CrystalBatIdle;
		spr_walk     = spr.CrystalBatIdle;
		spr_hurt     = spr.CrystalBatHurt;
		spr_dead     = spr.CrystalBatDead;
		spr_chrg     = spr.CrystalBatTell;
		spr_fire     = spr.CrystalBatDash;
		spr_shadow   = shd24;
		spr_shadow_y = 4;
		hitid        = [spr_idle, "CRYSTAL BAT"];
		sprite_index = spr_idle;
		depth        = -2;
		
		 // Sounds:
		snd_hurt = sndSpiderHurt;
		snd_dead = sndSpiderDead;
		snd_mele = sndSpiderMelee;
		
		 // Vars:
		mask_index  = mskFreak;
		friction    = 0.6;
		maxhealth   = 18;
		raddrop     = 8;
		size        = 1;
		walk        = 0;
		walkspeed   = 1.2;
		maxspeed    = 2.4;
		canmelee    = false;
		meleedamage = 5;
		gunangle    = random(360);
		curse       = false;
		dash        = false;
		
		 // Alarms:
		alarm1 = 90;
		alarm2 = 90;
		
		return self;
	}
	
#define CrystalBat_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	if(alarm3_run) exit;
	
	 // Animate:
	if(anim_end && sprite_index != spr_chrg && sprite_index != spr_fire){
		sprite_index = enemy_sprite;
	}
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		
		var _add = walkspeed + (2 * dash);
		motion_add_ct(gunangle, _add);
		if(speed < _add){
			speed = _add;
		}
		
		 // Dashin':
		if(dash){
			image_angle = direction - 90;
			
			 // Contact Damage:
			if(alarm11 < 0){
				canmelee = true;
			}
			
			 // Effects:
			if(chance_ct(1, 3)){
				if(curse > 0){
					with(instance_create(x, y, Smoke)){
						if(position_meeting(x, y, Wall)){
							y -= 8;
							depth = -7;
						}
					}
				}
				else{
					instance_create(x, y, Dust);
				}
			}
		}
		
		 // Wall Collision:
		motion_step(1);
		if(place_meeting(x, y, Wall)){
			var _walled = true;
			
			 // Glitch Through Walls:
			if(curse > 0 && dash){
				_walled = false;
				with(instances_meeting(x, y, Wall)){
					if(place_meeting(x, y, other)){
						if(collision_rectangle(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, TopSmall, false, false)){
							_walled = true;
							break;
						}
					}
				}
				if(!_walled){
					xprevious = x;
					yprevious = y;
					canfly    = true;
				}
			}
			
			 // Hit Wall:
			if(_walled){
				x = xprevious;
				y = yprevious;
				move_contact_solid(direction, speed);
				
				 // Force End Dash:
				if(dash){
					walk = 0;
					
					 // Effects:
					instance_create(x, y, Smoke);
					audio_sound_set_track_position(sound_play_hit_ext(sndLaserCrystalHit, 1 + orandom(0.1), 1.0), 0.08);
					audio_sound_set_track_position(sound_play_hit_ext(sndBigDogWalk,      1 + orandom(0.1), 0.1), 0.12);
					sleep(24);
				}
				
				 // Wall Bouncin':
				if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
				if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
				enemy_look(pround(direction, 90));
				if(dash){
					enemy_face(direction + 180);
				}
			}
		}
		motion_step(-1);
		
		 // Dash End:
		if(walk <= 0 && dash){
			 // Walled, Try Again:
			if(curse > 0 && place_meeting(x, y, Wall) && place_meeting(xprevious, yprevious, Wall)){
				alarm3 = 1;
			}
			
			 // End:
			else{
				dash         = false;
				alarm1       = 45;
				alarm2       = 45;
				sprite_index = spr_hurt;
				image_index  = 2;
				image_angle  = 0;
				
				 // Disable Contact Damage:
				canmelee = false;
				alarm11  = -1;
				
				 // Unfly:
				if(curse > 0){
					canfly = false;
				}
			}
		}
	}
	speed = min(speed, maxspeed + (5 * dash));
	
	 // Curse Particles:
	if(curse > 0 && chance_ct(curse, 3)){
		instance_create(x + orandom(8), y + orandom(6), Curse);
	}
	
#define CrystalBat_draw
	var _hurt = (sprite_index != spr_hurt && nexthurt >= current_frame + 4);
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	draw_self_enemy();
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
#define CrystalBat_hurt(_damage, _force, _direction)
	my_health -= _damage;
	nexthurt = current_frame + 6;
	motion_add(_direction, _force);
	sound_play_hit(snd_hurt, 0.3);
	
	 // Hurt Sprite:
	if(sprite_index != spr_chrg && sprite_index != spr_fire){
		sprite_index = spr_hurt;
		image_index  = 0;
	}
	
#define CrystalBat_alrm1
	alarm1 = 40 + random(20);
	
	 // Wander:
	enemy_look(pround(random(360), 90));
	enemy_walk(gunangle, random_range(30, 60));
	
#define CrystalBat_alrm2
	alarm2 = 10;
	
	 // Prepare Dash:
	if(enemy_target(x, y)){
		if(curse > 0 || target_visible){
			if(target_distance < 160){
				if(place_meeting(x, target.y, target) || place_meeting(target.x, y, target)){
					alarm3 = 7;
					
					 // Sprite:
					sprite_index = spr_chrg;
					
					 // Motion:
					enemy_look(pround(target_direction, 90));
					motion_set(gunangle + 180 + orandom(30), maxspeed);
					move_contact_solid(direction, speed);
					
					 // Sounds:
					audio_sound_set_track_position(sound_play_hit_ext(sndLaserCrystalHit, random_range(0.9, 1.1), 1.0), 0.08);
					audio_sound_set_track_position(sound_play_hit_ext(sndLuckyShotProc,   random_range(0.9, 1.1), 1.0), 0.08);
					audio_sound_set_track_position(sound_play_hit_ext(sndMaggotBite,      random_range(1.0, 1.2), 0.8), 0.08);
					
					 // Reset:
					alarm1 = -1;
					alarm2 = -1;
					walk   = 0;
				}
			}
		}
	}
	
#define CrystalBat_alrm3
	 // Dash:
	dash = true;
	sprite_index = spr_fire;
	enemy_walk(gunangle, 60);
	
	 // Sounds:
	audio_sound_set_track_position(sound_play_hit_ext(sndLaserCrystalDeath, random_range(0.9, 1.1), 1),   0.4);
	audio_sound_set_track_position(sound_play_hit_ext(sndBigMaggotBite,     random_range(1.2, 1.4), 0.8), 0.08);
	
#define CrystalBat_death
	pickup_drop(25, 0);
	
	
#define CrystalBrain_create(_x, _y)
	/*
		Mastermind. Clones enemies.
		
		Vars:
			target_x/y           - Coordinates the brain will try to navigate to
			motion_obj           - Separate object for avoiding wall collision. Trades motion and position data with the brain
			clone_max            - Max clone count
			teleport             - Boolean. Indicates if the brain is currently teleporting
			teleport_x/y         - Position to draw at during teleportation
			teleport_dis_min/max - The distance from the player that the brain can teleport within
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle      = spr.CrystalBrainIdle;
		spr_walk      = spr.CrystalBrainIdle;
		spr_hurt      = spr.CrystalBrainHurt;
		spr_dead      = spr.CrystalBrainDead;
		spr_part	  = spr.CrystalBrainPart;
		spr_appear    = spr.CrystalBrainAppear;
		spr_disappear = spr.CrystalBrainDisappear;
		spr_effect    = spr.CrystalBrainEffect;
		spr_shadow    = shd32;
		spr_shadow_y  = 6;
		hitid         = [spr_idle, "CRYSTAL BRAIN"];
		sprite_index  = spr_hurt;
		depth         = -2;
		
		 // Sounds:
		snd_hurt = sndLightningCrystalHit;
		snd_dead = sndLightningCrystalCharge;
		
		 // Vars:
		mask_index       = mskBanditBoss;
		direction        = random(360);
		friction         = 0.1;
		maxhealth        = 80;
		raddrop          = 20;
		size             = 3;
		walk             = 0;
		walkspeed        = 0.3;
		maxspeed         = 1.2;
		minspeed         = 0.4;
		meleedamage      = 4;
		clone_max        = 3;
		teleport         = false;
		teleport_x       = x;
		teleport_y       = y;
		teleport_dis_min = 80;
		teleport_dis_max = 160;
		corpse           = false;
		
		 // Alarms:
		alarm1 = 90;
		
		return self;
	}
	
#define CrystalBrain_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed < minspeed){
		speed = minspeed;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	if(sprite_index == spr_disappear){
		if(anim_end){
			image_index -= image_speed_raw;
		}
	}
	else if(sprite_index != spr_appear || anim_end){
		sprite_index = enemy_sprite;
	}
	
	 // Teleporting:
	if(teleport){
		x      = 0;
		y      = 0;
		canfly = true;
		
		 // Effects:
		if(chance_ct(teleport, 4)){
			CrystalBrain_effect(teleport_x + orandom(32), teleport_y + orandom(32));
		}
	}
	
#define CrystalBrain_draw
	var	_x = (teleport ? teleport_x : x),
		_y = (teleport ? teleport_y : y);
		
	draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
	
	/* DEPRICATED - FUNKY DRAW EFFECT
	var _yoff = sin(wave / 20);
	draw_sprite_ext(sprite_index, image_index, x, y + (wall_yoff * wall_yoff_coeff) + _yoff, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
	
	if(button_check(0, "horn")) draw_self_enemy();
	else
	
	with(surface_setup("CrystalBrain", 64, 64, 1)){
		x = other.x - (w / 2);
		y = other.y - (h / 2);
		
		for(var i = 0; i <= 1; i++){
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			
			with(other){
				var	_c = ((i == 0) ? -1 : 1),
					_w = 48,
					_h = 48,
					_segHeight = 3,
					_segStartY = (wave mod _segHeight),
					_segNumber = (_h div _segHeight);
					
				for(var j = 0; j <= _segNumber; j++){
					draw_sprite_part(
						sprite_index, 
						image_index,
						0,
						j * _segHeight - _segStartY,
						_w,
						_segHeight,
						sin((wave + (j * 2)) / 10) * (2 * _c),
						j * _segHeight - _segStartY
					);
				}
				
				draw_set_blend_mode_ext(bm_inv_src_alpha, bm_subtract);
				draw_sprite_tiled(spr.CrystalBrainSurfMask, 0, 0, view_xview_nonsync + i);
				draw_set_blend_mode(bm_normal);
			}
			
			surface_reset_target();
			
			draw_surface(surf, x, y);
		}
	}
	*/
	
#define CrystalBrain_alrm1
	alarm1 = irandom_range(20, 40);
	
	if(!teleport){
		if(enemy_target(x, y)){
			var _targetDir  = target_direction,
				_targetSeen = target_visible,
				_canWarp    = true; // (my_health < maxhealth);
				
			if(_targetSeen || chance(1, 3)){
				 // Attempt Cloning:
				var _cloneNum = 0;
				with(instances_matching(instances_matching(CustomObject, "name", "CrystalClone"), "creator", self)){
					_cloneNum += variable_instance_get(target, "size", 1);
				}
				if(!chance(_cloneNum, clone_max)){
					with(obj_create(x, y, "CrystalClone")){
						creator = other;
						team    = other.team;
					}
					_canWarp = false;
				}
				
				 // Get Back, Bro:
				if(target_distance < 64){
					enemy_walk(
						_targetDir + 180 + orandom(30),
						random_range(10, 20)
					);
					alarm1 = walk + random(10);
				}
			}
			
			 // Warp Out:
			if(_canWarp && chance(1, 4)){
				alarm1     = 30;
				teleport   = true;
				teleport_x = x;
				teleport_y = y;
				
				 // Visual:
				sprite_index = spr_disappear;
				image_index  = 0;
				
				 // Effects:
				sound_play_hit_ext(sndTVOn,          1.4 + random(0.2), 0.4);
				sound_play_hit_ext(sndCrystalShield, 1.3 + random(0.2), 1);
				repeat(8){
					with(scrFX(teleport_x, teleport_y, random(2), CrystTrail)){
						sprite_index = spr.CrystalRedTrail;
					}
				}
			}
			
			 // Watch Your Back:
			else if(_targetSeen){
				enemy_look(_targetDir);
			}
		}
		
		 // Wander:
		else{
			alarm1 = random_range(30, 60);
			enemy_walk(
				random(360),
				random_range(20, 40)
			);
		}
	}
	
	 // Warp In:
	else if(enemy_target(x, y)){
		var _floor  = noone;
		
		 // Teleport Near Target:
		if(my_health < maxhealth || !instance_exists(enemy)){
			with(array_shuffle(FloorNormal)){
				var _x = bbox_center_x,
					_y = bbox_center_y;
					
				with(other){
					var _targetDis = point_distance(_x, _y, target.x, target.y);
					if(_targetDis >= teleport_dis_min && _targetDis <= teleport_dis_max){
						if(!place_meeting(_x, _y, Wall)){
							_floor = other;
						}
					}
				}
				if(instance_exists(_floor)){
					break;
				}
			}
		}
		
		 // Teleport Near Enemy:
		if(!instance_exists(_floor)){
			with(array_shuffle(enemy)){
				with(other){
					with(instance_nearest_bbox(other.x, other.y, FloorNormal)){
						var	_x = bbox_center_x,
							_y = bbox_center_y;
							
						with(other){
							if(point_distance(_x, _y, target.x, target.y) >= teleport_dis_min){
								if(!place_meeting(_x, _y, Wall)){
									_floor = other;
								}
							}
						}
					}
				}
				if(instance_exists(_floor)){
					break;
				}
			}
		}
		
		 // Rematerialize:
		if(instance_exists(_floor)){
			teleport = false;
			canfly   = false;
			
			 // Move:
			with(_floor){
				other.x = bbox_center_x;
				other.y = bbox_center_y;
			}
			
			 // Visual:
			sprite_index = spr_appear;
			image_index  = 0;
			
			 // Sound:
			sound_play_hit_ext(sndHyperCrystalSpawn, 2.1 + random(0.3), 0.8);
		}
	}
	
#define CrystalBrain_death
	 // Clear Space:
	with(instance_create(x, y, PortalClear)){
		image_xscale *= 0.8;
		image_yscale *= 0.8;
	}
	
	 // Epic Death:
	with(obj_create(x, y, "CrystalBrainDeath")){
		sprite_index = other.spr_hurt;
		spr_dead     = other.spr_dead;
		spr_part     = other.spr_part;
		spr_shadow   = other.spr_shadow;
		spr_shadow_x = other.spr_shadow_x;
		spr_shadow_y = other.spr_shadow_y;
		image_xscale = other.image_xscale * other.right;
		image_yscale = other.image_yscale;
		image_angle  = other.image_angle;
		image_blend  = other.image_blend;
		image_alpha  = other.image_alpha;
		depth        = other.depth;
		mask_index   = other.mask_index;
		snd_hurt     = other.snd_hurt;
		raddrop      = other.raddrop;
		size         = other.size;
		team         = other.team;
		direction    = other.direction;
		speed        = min(other.speed / 1.5, 8);
	}
	raddrop = 0;
	
	 // Effects:
	with(instance_create(x, y, PortalL)){
		depth = other.depth - 1;
	}
	repeat(8){
		scrFX(x, y, 3, Smoke);
	}
	
#define CrystalBrain_effect(_x, _y)
	if(sprite_exists(spr_effect)){
		with(obj_create(_x, _y, "CrystalBrainEffect")){
			sprite_index = other.spr_effect;
			depth        = other.depth - chance(2, 3);
			
			return self;
		}
	}
	
	return noone;
	
	
#define CrystalBrainDeath_create(_x, _y)
	/*
		The death sequence for the CrystalBrain enemy
		
		Vars:
			spr_part - Sprite of the fragments that the Crystal Brain smashes into
			throes   - The remaining number of throes before dying
			alarm0   - Time until the next death throe
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.CrystalBrainHurt;
		spr_dead     = spr.CrystalBrainDead;
		spr_part     = spr.CrystalBrainPart;
		spr_shadow   = shd32;
		spr_shadow_x = 0;
		spr_shadow_y = 6;
		image_speed  = 0.4;
		depth        = -2;
		
		 // Sound:
		snd_hurt = sndLightningCrystalHit;
		snd_dead = sndLightningCrystalDeath;
		
		 // Vars:
		mask_index = mskBanditBoss;
		friction   = 0.5;
		size       = 3;
		team       = 1;
		raddrop    = 20;
		throes     = irandom_range(2, 3);
		
		 // Alarms:
		alarm0 = 15;
		
		return self;
	}
	
#define CrystalBrainDeath_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Animate:
	if(sprite_index != -1 && anim_end){
		image_index = image_number - 1;
		image_speed = 0;
	}
	
	 // Shake:
	x += orandom(2 * current_time_scale);
	y += orandom(2 * current_time_scale);
	
	 // Wall Collision:
	motion_step(1);
	if(place_meeting(x, y, Wall)){
		x = xprevious;
		y = yprevious;
		move_bounce_solid(true);
	}
	motion_step(-1);
	
#define CrystalBrainDeath_alrm0
	alarm0 = 15;
	
	 // Fragment:
	if(sprite_index != -1){
		sprite_index = -1;
		sound_play_hit_ext(sndCrystalPropBreak, 1.4 + orandom(0.1), 4);
	}
	
	 // Effects:
	if(chance_ct(2, 5)){
		instance_create(x + orandom(12), y + orandom(12), Smoke);
	}
	
	 // Agony:
	if(throes > 0){
		throes--;
		
		 // Flash:
		image_index = 0;
		image_speed = 0.4;
		
		 // Jerk Around:
		speed     = random_range(3, 6);
		direction = point_direction(x, y, xstart, ystart) + orandom(30);
		move_contact_solid(direction, 4);
		
		 // Desperation Clone:
		with(obj_create(x, y, "CrystalClone")){
			creator = other;
			team    = other.team;
			time    = 150;
			clone   = instances_matching(instances_matching_lt(clone, "size", 3), "intro", null);
		}
		
		 // Chunk Off:
		repeat(2){
			with(scrFX(x, y, random_range(2, 5), Shell)){
				sprite_index = spr.CrystalBrainChunk;
				image_index  = irandom(image_number - 1);
				image_speed  = 0;
			}
		}
		
		 // FX:
		sound_play_hit(snd_hurt, 0.3);
		view_shake_at(x, y, 15);
	}
	
	 // Perish:
	else instance_destroy();
	
#define CrystalBrainDeath_draw
	 // Normal:
	draw_self();
	
	 // Fragments:
	if(sprite_index == -1){
		var	_flash    = (image_index < 1),
			_offset   = 10 / max(1, 1 + throes),
			_lastSeed = random_get_seed();
			
		random_set_seed(id + throes);
		random(1); // important
		
		if(_flash){
			draw_set_fog(true, image_blend, 0, 0);
		}
		
		for(var i = 0; i < sprite_get_number(spr_part); i++){
			draw_sprite_ext(
				spr_part,
				i,
				x + orandom(_offset),
				y + orandom(_offset),
				image_xscale,
				image_yscale,
				image_angle,
				image_blend,
				image_alpha
			);
		}
		
		if(_flash){
			draw_set_fog(false, 0, 0, 0);
		}
		
		random_set_seed(_lastSeed);
	}
	
#define CrystalBrainDeath_destroy
	 // Corpse:
	with(corpse_drop(direction, speed)){
		image_index = 3;
	}
	
	 // Pickups:
	pickup_drop(100, 0);
	pickup_drop(50,  0);
	rad_drop(x, y, raddrop, direction, speed);
	
	 // Sound:
	sound_play_hit_big(snd_dead, 0.2);
	
	 // Effects:
	view_shake_at(x, y, 30);
	repeat(5){
		with(scrFX(x, y, random_range(3, 7), Shell)){
			sprite_index = spr.CrystalBrainChunk;
			image_index  = irandom(image_number - 1);
			image_speed  = 0;
		}
	}
	
	
#define CrystalBrainEffect_create(_x, _y)
	/*
		The main "circuitry" particle used for Crystal Brains and their enemy clones
	*/
	
	with(instance_create(_x, _y, BulletHit)){
		 // Visual:
		sprite_index = spr.CrystalBrainEffect;
		image_yscale = choose(1, -1);
		image_angle  = pround(random(360), 90);
		depth        = choose(-2, -3);
		
		return self;
	}
	
	
#define CrystalClone_create(_x, _y)
	/*
		Clone handler object for enemies duplicated by Crystal Brains
		
		Vars:
			sprite_index - The clone's overlay sprite, set -1 for automatic
			spr_effect   - The clone's effect sprite, set -1 for automatic
			target       - The cloned instance
			clone        - Searches this object, instance, or list of instances, and clones the nearest one
			budge        - The cloned instance should be automatically offset from the original instance, true/false
			time         - Time in frames until the cloned instance is killed
			appear       - Timer, used for the clone's appearing visual
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = -1;
		spr_effect   = -1;
		image_speed  = 0.4;
		image_alpha  = 0;
		
		 // Vars:
		creator       = noone;
		target        = noone;
		clone         = instances_matching_ne(instances_matching_ne(instances_matching_ne(instances_matching_lt(instances_matching_ne(enemy, "team", 2), "size", 6), "name", "CrystalBrain", "CrystalHeart", "ChaosHeart"), "mask_index", mskNone), "intro", false);
		time          = 450;
		team          = -1;
		appear        = 1;
		appear_flip   = false;
		appear_health = false;
		budge         = true;
		
		return self;
	}
	
#define CrystalClone_step
	 // Determine Overlay Sprite:
	if(!sprite_exists(sprite_index)){
		switch(team){
			case 2  : sprite_index = spr.CrystalCloneOverlayAlly; break;
			case 3  : sprite_index = spr.CrystalCloneOverlayPopo; break;
			default : sprite_index = spr.CrystalCloneOverlay;
		}
	}
	if(!sprite_exists(spr_effect)){
		switch(team){
			case 2  : spr_effect = spr.CrystalBrainEffectAlly; break;
			case 3  : spr_effect = spr.CrystalBrainEffectPopo; break;
			default : spr_effect = spr.CrystalBrainEffect;
		}
	}
	
	 // Clone Nearest Enemy:
	if(target == noone){
		var	_disMax = 256,
			_target = noone,
			_clones = instances_matching(instances_matching(object_index, "name", name), "team", team);
			
		 // Find Nearest:
		with(instances_matching_ne(clone, "id", null)){
			var _dis = point_distance(x, y, other.x, other.y);
			if(_dis < _disMax){
				if(!array_length(instances_matching(_clones, "target", self))){
					_disMax = _dis;
					_target = self;
				}
			}
		}
		
		 // Cloning:
		if(instance_exists(_target)){
			with(_target){
				if(!instance_is(self, Player)){
					other.target = instance_clone();
				}
				
				 // Easter Egg:
				else{
					other.target = instance_create(x, y, Ally);
					with(other.target){
						 // Visual:
						spr_idle     = other.spr_idle;
						spr_walk     = other.spr_walk;
						spr_hurt     = other.spr_hurt;
						spr_dead     = other.spr_dead;
						spr_shadow   = other.spr_shadow;
						spr_shadow_x = other.spr_shadow_x;
						spr_shadow_y = other.spr_shadow_y;
						gunspr       = ((skill_get(mut_throne_butt) > 0) ? spr.CrystalCloneGunTB : spr.CrystalCloneGun);
						sprite_index = spr_idle;
						image_xscale = other.image_xscale;
						image_yscale = other.image_yscale;
						image_angle  = other.image_angle;
						image_blend  = other.image_blend;
						image_alpha  = other.image_alpha;
						
						 // Sounds:
						snd_hurt = other.snd_hurt;
						snd_dead = other.snd_dead;
						sound_stop(sndAllySpawn);
						sound_play(other.snd_wrld);
						
						 // Vars:
						mask_index = other.mask_index;
						maxhealth  = other.maxhealth;
						my_health  = maxhealth;
						
						 // No Bleed:
						alarm2 = -1;
					}
				}
			}
			
			with(target){
				 // Vars:
				if(instance_is(self, hitme)){
					raddrop = 0;
					
					 // Team:
					if(team != other.team){
						if(other.team == 2){
							var _charm = charm_instance(self, true);
							_charm.time = other.time + 1;
							_charm.kill = true;
							if("index" in other.creator){
								_charm.index = other.creator.index;
							}
						}
						team = other.team;
					}
					
					 // Enemy Vars:
					if(instance_is(self, enemy)){
						kills   = 0;
						wepseed = -1;
						
						 // Weaken:
						if(other.team != 2){
							my_health = ceil(my_health / 2);
							
							 // Delay Contact Damage:
							if(canmelee == true){
								canmelee = false;
								alarm11  = 30;
							}
						}
					}
				}
				
				 // Move Away:
				if(speed == 0){
					direction = random(360);
				}
				if(other.budge){
					if(!instance_budge(_target, -1)){
						var	_dis = 16,
							_dir = random(360);
							
						x += lengthdir_x(_dis, _dir);
						y += lengthdir_y(_dis, _dir);
						xprevious = x;
						yprevious = y;
						
						 // Obliterate Wall:
						wall_clear(x, y);
					}
				}
				else{
					x += dcos(direction);
					y -= dsin(direction);
				}
				xstart = x;
				ystart = y;
				
				 // Effects:
				with(other){
					CrystalClone_effect(x, y, other.x, other.y);
				}
				sound_play_hit_ext(sndHyperCrystalSearch, 1.3 + random(0.4), 0.4);
			}
		}
		
		 // Failed:
		else{
			instance_destroy();
			exit;
		}
	}
	
#define CrystalClone_end_step
	 // Follow Target:
	if(instance_exists(target)){
		x          = target.x;
		y          = target.y;
		mask_index = target.sprite_index;
		depth      = min(target.depth - 1, object_get_depth(SubTopCont));
		
		 // Appearing:
		if(appear > 0){
			appear -= (current_time_scale / 24);
			with(target){
				 // Hide:
				visible = (other.appear <= 0);
				
				 // Stay Still:
				if(instance_is(self, enemy)){
					speed  = 0;
					x      = xprevious;
					y      = yprevious;
					if("walk" in self){
						walk = min(1, walk);
					}
					if(sprite_index == spr_walk){
						sprite_index = spr_idle;
					}
				}
				
				 // Lock Health:
				if(other.appear_health > 0 && "my_health" in self){
					if(my_health < other.appear_health){
						my_health = other.appear_health;
					}
					other.appear_health = my_health;
				}
			}
		}
		
		 // Effects:
		else if(target.visible && chance_ct(1, 5)){
			CrystalBrain_effect(
				random_range(bbox_left, bbox_right + 1) + orandom(10),
				random_range(bbox_top, bbox_bottom + 1) + orandom(10)
			);
		}
		
		 // Death Timer:
		if(time >= 0){
			time -= min(time, current_time_scale);
			if(time <= 0){
				if(instance_is(target, hitme)){
					target.my_health = 0;
				}
				else if(!instance_is(target, becomenemy)){
					with(target){
						repeat(3){
							scrFX(x, y, 3, Smoke);
						}
						instance_destroy();
					}
				}
			}
		}
	}
	
	 // Goodbye:
	else if(target != noone){
		instance_destroy();
	}
	
#define CrystalClone_draw
	var _inst = (
		(appear > 0)
		? [self]
		: instances_matching_le(instances_matching(instances_matching(instances_matching(object_index, "name", name), "depth", depth), "sprite_index", sprite_index), "appear", 0)
	);
	
	if(_inst[0] == self){
		_inst = instances_seen(_inst, 24, 24, -1);
		
		if(array_length(_inst)){
			var	_vx = view_xview_nonsync,
				_vy = view_yview_nonsync,
				_gw = game_width,
				_gh = game_height;
				
			with(surface_setup("CrystalClone", _gw, _gh, game_scale_nonsync)){
				x = _vx;
				y = _vy;
				
				 // Copy & Clear Screen:
				draw_set_blend_mode_ext(bm_one, bm_zero);
				surface_screenshot(surf);
				draw_set_blend_mode(bm_normal);
				draw_clear_alpha(c_black, 0);
				
				 // Draw Clone Overlays:
				var _lastTimeScale = current_time_scale;
				current_time_scale = 1/1000000000000000;
				try{
					with(_inst){
						if(time > 60 || (time % 6) < 3){
							with(target){
								if(other.appear > 0){
									visible = true;
								}
								if(visible){
									 // Self:
									with(self){
										if(global.draw_event_exists[object_index]){
											event_perform(ev_draw, 0);
										}
										else draw_self();
									}
									
									 // Appearing Visual:
									if(other.appear > 0){
										var _appear = min(1, other.appear);
										if(other.appear_flip){
											_appear = 1 - _appear;
										}
										
										 // Set Hitbox to Sprite:
										var	_lastMask   = mask_index,
											_lastXScale = image_xscale;
											
										mask_index = sprite_index;
										if("right" in self){
											image_xscale *= right;
										}
										
										 // Cool Wavy Cut:
										var	_x1 = bbox_left,
											_y1 = bbox_top,
											_x2 = bbox_right  + 1,
											_y2 = bbox_bottom + 1,
											_h  = (_y2 - _y1) / 16,
											_y  = lerp(_y1 - (_h * 2), _y2, _appear),
											_ay = (other.appear_flip ? _y2 : _y1);
											
										draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
										draw_primitive_begin(pr_trianglestrip);
										
										draw_vertex(_x1, _ay);
										for(var _x = _x1; _x <= _x2; _x++){
											draw_vertex(_x, clamp(_y + (_h * sin((_x - _x1 + current_frame) / (2 * _h))) + (_h * cos((_x - _x1 - current_frame) / (4 * _h))), _y1, _y2));
											draw_vertex(_x, _ay);
										}
										
										draw_primitive_end();
										draw_set_blend_mode(bm_normal);
										
										 // Reset Hitbox:
										mask_index   = _lastMask;
										image_xscale = _lastXScale;
									}
								}
							}
						}
					}
					
					 // Epic Overlay:
					with(other){
						if(sprite_exists(sprite_index)){
							if(appear > 0){
								draw_set_blend_mode(bm_add);
							}
							draw_set_color_write_enable(true, true, true, false);
							draw_sprite_tiled(sprite_index, image_index, 0, 0);
							draw_set_color_write_enable(true, true, true, true);
							if(appear > 0){
								draw_set_blend_mode(bm_normal);
							}
						}
						if(appear <= 0){
							draw_set_blend_mode(bm_add);
						}
						surface_screenshot(other.surf);
					}
					
					 // Redraw Screen:
					draw_set_blend_mode_ext(bm_one, bm_zero);
					draw_surface_scale(surf, x, y, 1 / scale);
					draw_set_blend_mode(bm_normal);
				}
				catch(_error){
					trace(_error);
				}
				current_time_scale = _lastTimeScale;
			}
		}
	}
	
#define CrystalClone_destroy
	 // Death Effects:
	if(target != noone){
		var _num = round((bbox_width + bbox_height) / 32) + irandom(2);
		if(_num > 0) repeat(_num){
			instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Smoke);
			CrystalBrain_effect(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1));
		}
		sound_play_hit_ext(sndHyperCrystalRelease, 0.8 + random(0.3), 0.8);
	}
	
#define CrystalClone_effect(_x1, _y1, _x2, _y2)
	if(sprite_exists(spr_effect)){
		var	_inst   = [],
			_dir    = point_direction(_x1, _y1, _x2, _y2),
			_disMax = point_distance(_x1, _y1, _x2, _y2);
			
		for(var _dis = 0; _dis < _disMax; _dis += random_range(12, 24)){
			with(obj_create(
				_x1 + lengthdir_x(_dis, _dir) + orandom(8),
				_y1 + lengthdir_y(_dis, _dir) + orandom(8),
				"CrystalBrainEffect"
			)){
				sprite_index = other.spr_effect;
				image_speed  = lerp(0.8, 0.4, _dis / _disMax) + orandom(0.1);
				image_angle  = pround(_dir + orandom(45), 90);
				depth        = -9;
				direction    = point_direction(x, y, _x2, _y2);
				speed        = random_range(1, 1.5) * (1 - (_dis / _disMax));
				
				array_push(_inst, self);
			}
		}
		
		return _inst;
	}
	
	return noone;
	
	
#define CrystalHeart_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.CrystalHeartIdle;
		spr_walk     = spr.CrystalHeartIdle;
		spr_hurt     = spr.CrystalHeartHurt;
		spr_dead     = spr.CrystalHeartDead;
		spr_shadow   = shd24;
		spr_shadow_y = 4;
		hitid        = [spr_idle, "CRYSTAL HEART"];
		sprite_index = spr_idle;
		depth        = -3;
		
		 // Sounds:
		snd_hurt = sndHyperCrystalHurt;
		snd_dead = sndHyperCrystalDead;
		snd_mele = sndHyperCrystalSearch;
		
		 // Vars:
		mask_index  = mskLaserCrystal;
		friction    = 0.1;
		maxhealth   = 50;
		meleedamage = 4;
		canmelee    = false;
		size        = 3;
		walk        = 0;
		walkspeed   = 0.3;
		maxspeed    = 2;
		area        = "red";
		subarea     = 1;
		loops       = GameCont.loops;
		white       = false;
		tesseract	= false;
		
		 // Alarms:
		alarm1 = 30;
		
		return self;
	}
	
#define CrystalHeart_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	
	 // Effects:
	if(white){
		if(chance_ct(1, 20)){
			with(scrFX([x, 6], [y, 12], [90, random_range(0.2, 0.5)], LaserCharge)){
				sprite_index = sprSpiralStar;
				image_index  = choose(0, irandom(image_number - 1));
				depth        = other.depth - 1;
				alarm0       = random_range(15, 30);
			}
		}
		if(chance_ct(1, 25)){
			with(instance_create(x + orandom(6), y + orandom(12), BulletHit)){
				sprite_index = sprThrowHit;
				image_xscale = 0.2 + random(0.3);
				image_yscale = image_xscale;
				depth        = other.depth - 1;
			}
		}
	}
	else if(chance_ct(1, 10)){
		with(scrFX([x, 6], [y, 12], random(1), LaserCharge)){
			alarm0 = 10 + random(10);
		}
	}
	
	 // Manual Contact Damage:
	if(!is_undefined(area) && place_meeting(x, y, Player)){
		with(instances_meeting(x, y, instances_matching_ne(Player, "team", team))){
			if(place_meeting(x, y, other)){
				with(other) if(projectile_canhit_melee(other)){
					 // Death:
					projectile_hit_raw(other, 0, true);
					my_health = min(my_health, 0);
					GameCont.killenemies = true;
					
					 // Sound:
					if(sound_exists(snd_dead)){
						var _snd = sound_play_pitch(snd_dead, 1.3 + random(0.3));
						audio_sound_set_track_position(_snd, 0.4 + random(0.1));
						snd_dead = -1;
					}
					sound_play_hit(snd_mele, 0.1);
					
					 // Red:
					with(obj_create(x, y, "WarpPortal")){
						area    = other.area;
						subarea = other.subarea;
						loops   = other.loops;
						with(self){
							event_perform(ev_step, ev_step_normal);
						}
					}
				}
			}
		}
	}
	
#define CrystalHeart_alrm1
	alarm1 = random_range(30, 60);
	
	 // Wander:
	enemy_walk(
		random(360),
		random_range(10, 40)
	);
	
#define CrystalHeart_death
	 // Unfold:
	instance_create(x, y, PortalClear);
	var _chestTypes = [AmmoChest, WeaponChest, RadChest];
	for(var i = 0; i < array_length(_chestTypes); i++){
		with(projectile_create(
			x,
			y,
			"CrystalHeartBullet",
			direction + ((i / array_length(_chestTypes)) * 360) + orandom(4),
			4
		)){
			if(i == 0 && other.tesseract){
				area           = "red";
				subarea        = 3;
				area_goal      = irandom_range(5, 10);
				area_chest     = [_chestTypes[i], AmmoChest, AmmoChest, WeaponChest, WeaponChest, "Backpack"];
				area_chest_pos = "random";
			}
			else{
				area_chest = [_chestTypes[i]];
				area_chaos = other.white;
			}
		}
	}
	
	 // Effects:
	sleep(100);
	
	 // Wooo:
	unlock_set("crown:red", true);
	
	
#define CrystalHeartBullet_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.CrystalHeartBullet;
		spr_dead     = spr.CrystalHeartBulletHit;
		spr_ring     = spr.CrystalHeartBulletRing;
		spr_trail    = spr.CrystalHeartBulletTrail;
		image_speed  = 0.4;
		area_color   = c_white;
		
		 // Vars:
		mask_index     = mskFlakBullet;
		friction       = 0.4;
		maxspeed       = 12;
		damage         = 3;
		force          = 12;
		typ            = 0;
		area           = "red";
		subarea        = 0;
		loops          = GameCont.loops;
		area_seed      = random_get_seed() + random(0);
		area_goal      = irandom_range(8, 16);
		area_chest     = [];
		area_chest_pos = "furthest";
		area_chaos     = false;
		big            = false;
		setup          = true;
		
		 // Alarms:
		alarm0 = 12;
		
		return self;
	}
	
#define CrystalHeartBullet_setup
	setup = false;
	
	 // Determine Area:
	if(area_chaos){
		var _pick = [
			((area_get_secret(GameCont.area) || GameCont.subarea <= 0) ? GameCont.lastarea : GameCont.area),
			area
		];
		if(chance(1, 2)){
			_pick = [_pick[0]];
			
			while(loops > 0){
				loops = ceil(loops - 1);
				
				if(chance(1, 2)){
					switch(_pick[irandom(array_length(_pick) - 1)]){
						case area_desert     : _pick = [area_sewers, area_scrapyards]; break;
						case area_sewers     : _pick = [area_caves];                   break;
						case area_scrapyards : _pick = [area_sewers, area_city];       break;
						case area_caves      : _pick = [area_labs];                    break;
						case area_city       : _pick = [area_labs, area_palace];       break;
						case area_labs       : _pick = [area_sewers, area_caves];      break;
						case area_palace     : _pick = [area_scrapyards, area_labs];   break;
						case "coast"         : _pick = [area_scrapyards, area_jungle]; break;
						case "oasis"         : _pick = [area_sewers, area_labs];       break;
						case "trench"        : _pick = [area_sewers, area_caves];      break;
					}
				}
				else break;
			}
		}
		area = _pick[irandom(array_length(_pick) - 1)];
		
		 // Boss Time:
		if(loops > 0 && GameCont.subarea == 3){
			if(area == area_desert || area == area_scrapyards || area == area_city){
				subarea = 3;
			}
		}
	}
	
	 // Boss:
	if(!big){
		var _subMax = area_get_subarea(area);
		if(
			(area == "red")
			? (subarea == 3)
			: (subarea == _subMax && (_subMax > 1 || (loops > 0 && !area_get_secret(area))))
		){
			 // Vars:
			friction *= 4/3;
			maxspeed *= 2/3;
			damage   += floor(damage / 2);
			big       = true;
			
			 // Alarms:
			alarm0 += 4;
		}
	}
	if(big){
		 // Visual:
		sprite_index = ((area == "red") ? spr.CrystalHeartBulletBigRed : spr.CrystalHeartBulletBig);
		spr_ring     = spr.CrystalHeartBulletBigRing;
		spr_trail    = spr.CrystalHeartBulletBigTrail;
	}
	
	 // Colorize:
	switch(area){
		case area_hq:
			area_color = make_color_rgb(0, 255, 255);
			break;
			
		default:
			var _col = area_get_back_color(area);
			area_color =  make_color_hsv(
				color_get_hue(_col),
				color_get_saturation(_col),
				lerp(color_get_value(_col), 255, 0.5)
			);
	}
	
#define CrystalHeartBullet_step
	if(setup) CrystalHeartBullet_setup();
	
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Shielder Interaction:
	if(deflected && hitid == 58 && area != area_hq){
		area       = area_hq;
		subarea    = min(subarea, 2);
		area_chaos = false;
		array_push(area_chest, choose(IDPDChest, "BonusAmmoChest", "BonusHealthChest"));
		CrystalHeartBullet_setup();
	}
	
	 // Movement:
	if(friction_raw < 0 && speed_raw == 0){
		speed_raw -= friction_raw;
	}
	speed = min(speed, maxspeed);
	
	 // Effects:
	if((area == "red" || area == area_hq) && chance_ct(2, 3)){
		with(scrFX([x, 6], [y, 6], random(1), ((area == area_hq) ? IDPDPortalCharge : LaserCharge))){
			alarm0 = 5 + random(15);
		}
	}
	if(current_frame_active){
		with(instance_create(x, y, DiscTrail)){
			sprite_index = other.spr_trail;
			image_blend  = other.area_color;
			image_angle  = other.image_angle + orandom(120);
			image_xscale = other.image_xscale;
			image_yscale = other.image_yscale;
		}
	}
	
	 // Coast:
	if(!place_meeting(x, y, Floor)){
		instance_destroy();
	}
	
#define CrystalHeartBullet_draw
	draw_self();
	draw_sprite_ext(spr_ring, image_index, x, y, image_xscale, image_yscale, image_angle, area_color, image_alpha);
	
#define CrystalHeartBullet_alrm0
	 // Accelerate:
	friction = -maxspeed / 30;
	
	 // Deflectable:
	if(typ == 0) typ = 1;
	
#define CrystalHeartBullet_hit
	if(projectile_canhit_melee(other)){
		projectile_hit_push(other, damage, force);
		
		 // Slow:
		x -= hspeed_raw;
		y -= vspeed_raw;
		speed /= 2;
		
		 // Effects:
		sound_play_hit_ext(sndGammaGutsProc, 0.8 + random(0.4), 1.5);
		view_shake_at(x, y, 4);
		sleep(10);
	}
	
#define CrystalHeartBullet_wall
	 // Melt Through a Few Walls:
	if(min(image_xscale, image_yscale) > 0.85){
		image_xscale -= 0.05;
		image_yscale -= 0.05;
		
		 // Sound:
		var _snd = sound_play_hit_ext(sndGammaGutsProc, 0.8 + random(0.4), 1.5);
		
		 // Break:
		with(other){
			instance_create(x, y, FloorExplo);
			sound_stop(_snd + 1); // stops the wall break sound bro i didnt like how it sounded
			instance_destroy();
		}
	}
	
	 // Tunnel Time:
	else instance_destroy();
	
#define CrystalHeartBullet_destroy
	 // Sounds:
	sound_play_hit_ext(sndGammaGutsKill,      0.8 + random(0.3), 3.0);
	sound_play_hit_ext(sndNothing2Beam,       0.7 + random(0.2), 3.0);
	sound_play_hit_ext(sndHyperCrystalSearch, 0.6 + random(0.3), 1.5);
	
	 // Effects:
	with(instance_create(x, y, BulletHit)){
		sprite_index = other.spr_dead;
	}
	with(instance_create(x, y, ThrowHit)){
		image_blend = other.area_color;
		image_speed = 0.5;
		depth       = 0;
	}
	view_shake_max_at(x, y, 20);
	sleep(50);
	
	 // Tunnel Time:
	var	_scrt  = script_ref_create(CrystalHeartBullet_area_generate_setup, area_goal, direction, area_seed),
		_genID = area_generate(area, subarea, loops, x, y, false, false, _scrt);
		
	if(is_real(_genID)){
		 // Delete Chests:
		with(instances_matching_gt([RadChest, chestprop], "id", _genID)){
			instance_delete(self);
		}
		
		 // Delay Enemy Contact Damage:
		with(instances_matching_gt(enemy, "id", _genID)){
			if(canmelee){
				canmelee = false;
				alarm11  = 30;
			}
		}
		
		 // Spawn Chests:
		for(var i = 0; i < array_length(area_chest); i++){
			var	_chest    = area_chest[i],
				_chestX   = x,
				_chestY   = y,
				_chestPos = area_chest_pos,
				_disMin   = -1;
				
			 // Find Spawn Floor:
			with(array_shuffle(instances_matching_gt(FloorNormal, "id", _genID))){
				if(!place_meeting(x, y, Wall) && !place_meeting(x, y, prop) && !place_meeting(x, y, chestprop)){
					var _canChest = true;
					if(place_meeting(x, y, enemy)){
						with(instances_meeting(x, y, instances_matching_gt(enemy, "size", 1))){
							if(place_meeting(x, y, other)){
								_canChest = false;
								break;
							}
						}
					}
					if(_canChest){
						 // Random Floor:
						if(_chestPos == "random"){
							_chestX = bbox_center_x;
							_chestY = bbox_center_y;
							break;
						}
						
						 // Furthest Floor:
						else{
							var	_x   = bbox_center_x,
								_y   = bbox_center_y,
								_dis = point_distance(other.x, other.y, _x, _y);
								
							if(_dis > _disMin){
								_disMin = _dis;
								_chestX = _x;
								_chestY = _y;
							}
						}
					}
				}
			}
			
			 // New Chest Just Dropped:
			with(chest_create(_chestX, _chestY, _chest, true)){
				with(instances_meeting(x, y, CrystalProp)){
					instance_delete(self);
				}
			}
		}
		
		 // Deptherize:
		if(area == "red"){
			with(instances_matching_gt(Floor, "id", _genID)){
				depth = 8;
			}
		}
		
		 // TopSmalls:
		var	_tileOld = [],
			_tileNew = [];
			
		with(instances_matching_gt(TopSmall, "id", _genID)){
			array_push((chance(1, 5) ? _tileOld : _tileNew), self);
		}
		with(instances_matching_ne(_tileOld, "id", null)){
			var	_x   = bbox_center_x,
				_y   = bbox_center_y,
				_dis = 16;
				
			for(var _dir = 0; _dir < 360; _dir += 90){
				with(instances_at(_x + lengthdir_x(_dis, _dir), _y + lengthdir_y(_dis, _dir), _tileNew)){
					_tileNew = array_delete_value(_tileNew, self);
					array_push(_tileOld, self);
				}
			}
		}
		with(instances_matching_ne(_tileOld, "id", null)){
			with(self){
				event_perform(ev_create, 0);
			}
		}
		
		 // TopTinys:
		var _areaCurrent = GameCont.area;
		GameCont.area = area;
		with(instances_matching_ne(_tileNew, "id", null)){
			var	_ox = pfloor(random_range(bbox_left, bbox_right  + 1 + 8), 8),
				_oy = pfloor(random_range(bbox_top,  bbox_bottom + 1 + 8), 8);
				
			for(var _x = _ox - 8; _x < _ox + 8; _x += 8){
				for(var _y = _oy - 8; _y < _oy + 8; _y += 8){
					if(array_length(instances_at(_x, _y, _tileNew)) <= 0){
						if(chance(1, 1)){
							obj_create(_x, _y, "TopTiny");
						}
					}
				}
			}
		}
		GameCont.area = _areaCurrent;
		
		 // Extra TopSmalls:
		with(instances_matching_ne(_tileNew, "id", null)){
			if(instance_exists(self)){
				instance_create(x + choose(-16, 0), y + choose(-16, 0), Top);
			}
		}
		
		/*
		 // Clientside Darkness:
		var _darkAreas = [area_sewers, area_caves, area_labs, "pizza", "lair", "trench"];
		if(array_find_index(_darkAreas, area) >= 0 && array_find_index(_darkAreas, GameCont.area) < 0){
			with(instances_matching_gt(Floor, "id", _genID)){
				array_push(clientDarknessFloor, self);
			}
			with(TopCont){
				darkness = true;
			}
		}
		*/
		
		 // Reveal:
		with(instances_matching_gt([Floor, Wall, TopSmall], "id", _genID)){
			if(array_find_index(_tileOld, self) < 0){
				with(floor_reveal(bbox_left, bbox_top, bbox_right, bbox_bottom, 6)){
					time_max *= 1.3;
				}
			}
		}
		
		 // Red Crown Quality Assurance:
		if(subarea == 0 && instance_exists(PizzaEntrance)){
			with(instances_matching_gt(PizzaEntrance, "id", _genID)){
				instance_delete(self);
			}
		}
		if(loops <= 0 || GameCont.subarea != 3 || !instance_exists(enemy)){
			with(instances_matching_gt(WantBoss, "id", _genID)){
				instance_delete(self);
			}
		}
		switch(area){
			
			case area_labs: // TECHNOMANCER FIX
				
				if(loops > 0 && !array_length(instances_matching_gt(TechnoMancer, "id", _genID))){
					with(array_shuffle(instances_matching_gt(FloorNormal, "id", _genID))){
						if(point_distance(bbox_center_x, bbox_center_y, other.x, other.y) > 64){
							with(obj_create(bbox_center_x, bbox_center_y, TechnoMancer)){
								repeat(6){
									instance_create(x + orandom(60), y + orandom(60), PortalClear);
								}
							}
							break;
						}
					}
				}
				
				break;
				
			case area_hq: // WHERE THE HELL THOSE ENEMIES AT
				
				if(subarea != 3){
					var	_guardNum  = big,
						_portalNum = 2;
						
					with(array_shuffle(instances_matching_gt(FloorNormal, "id", _genID))){
						if(_guardNum > 0){
							_guardNum--;
							obj_create(bbox_center_x, bbox_center_y, "PopoSecurity");
						}
						else if(_portalNum > 0){
							_portalNum--;
							with(instance_create(bbox_center_x, bbox_center_y, IDPDSpawn)){
								x = xstart;
								y = ystart;
								move_contact_solid(random(360), 8);
							}
						}
						else break;
					}
				}
				
				break;
				
		}
		
		 // Goodbye:
		if(instance_exists(enemy)){
			portal_poof();
		}
		instance_create(x, y, PortalClear);
	}
	
#define CrystalHeartBullet_area_generate_setup(_goal, _direction, _seed)
	with(GenCont){
		goal     = _goal;
		safedist = 0;
	}
	with(FloorMaker){
		goal      = _goal;
		direction = pround(_direction, 90);
	}
	random_set_seed(_seed);
	
	
#define CrystalPropRed_create(_x, _y)
	with(instance_create(_x, _y, CrystalProp)){
		 // Visual:
		spr_idle = spr.CrystalPropRedIdle;
		spr_hurt = spr.CrystalPropRedHurt;
		spr_dead = spr.CrystalPropRedDead;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndCrystalPropBreak;
		
		 // Vars:
		maxhealth = 2;
		
		return self;
	}
	
	
#define CrystalPropWhite_create(_x, _y)
	with(instance_create(_x, _y, CrystalProp)){
		 // Visual:
		spr_idle = spr.CrystalPropWhiteIdle;
		spr_hurt = spr.CrystalPropWhiteHurt;
		spr_dead = spr.CrystalPropWhiteDead;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndCrystalPropBreak;
		
		 // Vars:
		maxhealth = 2;
		
		return self;
	}
	
#define CrystalPropWhite_step
	 // Sparkly:
	if(chance_ct(1, 20)){
		with(scrFX([x, 7], [(y + 3), 7], [90, random_range(0.2, 0.5)], LaserCharge)){
			sprite_index = sprSpiralStar;
			image_index = choose(0, irandom(image_number - 1));
			depth = other.depth - 1;
			alarm0 = random_range(15, 30);
		}
	}
	if(chance_ct(1, 25)){
		with(instance_create(x + orandom(7), (y + 3) + orandom(7), BulletHit)){
			sprite_index = sprThrowHit;
			image_xscale = 0.2 + random(0.3);
			image_yscale = image_xscale;
			depth = other.depth - 1;
		}
	}
	
	
#define EnergyBatSlash_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		var _skill = skill_get(mut_laser_brain);
		
		 // Visual:
		sprite_index = spr.EnergyBatSlash;
		image_speed  = 0.4 / ((_skill > 0) ? 1 + _skill : power(2, _skill)); // idk the base game does this
		
		 // Vars:
		mask_index = mskSlash;
		damage     = 18; 
		force      = 12;
		walled     = false;
		
		return self;
	}
	
#define EnergyBatSlash_hit
	if(projectile_canhit_melee(other)){
		projectile_hit(other, damage, force, direction);
		
		/*
		if(instance_exists(other) && other.my_health <= 0){
			projectile_create(other.x, other.y, ((other.size < 2) ? "PlasmaImpactSmall" : PlasmaImpact), 0, 0);
		}
		*/
	}
	
#define EnergyBatSlash_wall
	/*
	OLD CHUM
	⣿⣿⣿⣿⣿⠟⠉⠁⠄⠄⠄⠈⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⠏⠄⠄⠄⠄⠄⠄⠄⠄⠄⠸⢿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣏⠄⡠⡤⡤⡤⡤⡤⡤⡠⡤⡤⣸⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣗⢝⢮⢯⡺⣕⢡⡑⡕⡍⣘⢮⢿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⡧⣝⢮⡪⡪⡪⡎⡎⡮⡲⣱⣻⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⠟⠁⢸⡳⡽⣝⢝⢌⢣⢃⡯⣗⢿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⠟⠁⠄⠄⠄⠹⡽⣺⢽⢽⢵⣻⢮⢯⠟⠿⠿⢿⣿⣿⣿⣿⣿
	⡟⢀⠄⠄⠄⠄⠄⠙⠽⠽⡽⣽⣺⢽⠝⠄⠄⢰⢸⢝⠽⣙⢝⢿
	⡄⢸⢹⢸⢱⢘⠄⠄⠄⠄⠄⠈⠄⠄⠄⣀⠄⠄⣵⣧⣫⣶⣜⣾
	⣧⣬⣺⠸⡒⠬⡨⠄⠄⠄⠄⠄⠄⠄⣰⣿⣿⣿⣿⣿⣷⣽⣿⣿
	⣿⣿⣿⣷⠡⠑⠂⠄⠄⠄⠄⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣄⠠⢀⢀⢀⡀⡀⠠⢀⢲⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⢐⢀⠂⢄⠇⠠⠈⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣧⠄⠠⠈⢈⡄⠄⢁⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⡀⠠⠐⣼⠇⠄⡀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣯⠄⠄⡀⠈⠂⣀⠄⢀⠄⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿
	⣿⣿⣿⣿⣿⣶⣄⣀⠐⢀⣸⣷⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿
	*/
	
	 // Walled More Like Gnomed Haha:
	if(!walled){
		walled = true;
		
		 // Hit Wall FX:
		var	_x   = bbox_center_x + hspeed_raw,
			_y   = bbox_center_y + vspeed_raw,
			_col = ((image_yscale > 0) ? c_lime : c_white);
			
		with(
			instance_is(other, Wall)
			? instance_nearest_bbox(_x, _y, instances_meeting(_x, _y, Wall))
			: other
		){
			with(instance_create(bbox_center_x, bbox_center_y, MeleeHitWall)){
				image_angle = point_direction(_x, _y, x, y);
				image_blend = _col;
				sound_play_hit(sndMeleeWall, 0.3);
			}
		}
	}
	
#define EnergyBatSlash_projectile
	if(instance_exists(self)){
		with(other){
			if(typ == 1 || typ == 2){
				var	_x       = x,
					_y       = y,
					_depth   = depth,
					_damage  = damage,
					_target  = creator,
					_targetX = xstart,
					_targetY = ystart,
					_deflect = (typ == 1 && other.candeflect),
					_minID   = instance_max;
					
				if(_deflect) deflected = true;
				
				instance_destroy();
				
				with(other){
					var _cannon = false;
					
					 // Cannon?
					with(instances_matching_gt(projectile, "id", _minID)){
						_cannon = true;
						if(_deflect){
							instance_delete(self);
						}
						else break;
					}
					
					if(instance_exists(self)){
						 // Vlasma:
						if(_deflect){
							with(projectile_create(_x, _y, (_cannon ? "VlasmaCannon" : "VlasmaBullet"), direction, speed + 2)){
								target   = _target;
								target_x = _targetX;
								target_y = _targetY;
								
								 // Cannon:
								if(_cannon){
									cannon = _damage * 1.5;
								}
							}
						}
						
						 // Plasma Impact:
						with(projectile_create(_x, _y, (_cannon ? PlasmaImpact : "PlasmaImpactSmall"), 0, 0)){
							depth = _depth;
							
							 // Sounds:
							var _snd = [
								[sndPlasma,    sndPlasmaUpg], 
								[sndPlasmaBig, sndPlasmaBigUpg]
							];
							sound_play_hit_ext(
								_snd[_cannon][(instance_is(creator, Player) && skill_get(mut_laser_brain) > 0)],
								random_range(0.7, 1.3),
								0.6
							);
						}
						if(_cannon){
							sleep_max(10 * _damage);
						}
					}
				}
			}
		}
	}
	
	
#define EntanglerSlash_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.EntanglerSlash;
		image_speed  = 0.4;
		
		 // Vars:
		mask_index = mskSlash;
		friction   = 0.1;
		damage     = 8;
		force      = 12;
		setup      = true;
		walled     = false;
		hit_list   = {}; // when you do true entangler, dont use LWO
		cancharm   = false;
		red_ammo   = 0;
		
		return self;
	}
	
#define EntanglerSlash_setup
	setup = false;
	
	var _charm = false;
	with(instances_meeting(x, y, instances_matching_ne(enemy, "team", team))){
		if(place_meeting(x, y, other)){
			_charm = true;
			red_ammo = 0;
			
			 // maybe do charm stuff here instead idk
		}
	}
	
	if(_charm){
		 // Visual:
		// sprite_index = spr.EntanglerSlashCharm;
		
		 // Vars:
		cancharm = true;
	}
	
#define EntanglerSlash_step
	if(setup) EntanglerSlash_setup();
	
#define EntanglerSlash_wall
	if(!walled){
		walled = true;
		
		sound_play_hit(sndMeleeWall, 0.2);
	}

#define EntanglerSlash_hit
	if(team != other.team && lq_defget(hit_list, string(other), 0) <= current_frame){
		lq_set(hit_list, string(other), current_frame + 6);
		
		 // The Good Stuff:
		if(cancharm){
			 // iou charmed clones
		}
		
		projectile_hit(other, damage, force, direction);
	}
	
#define EntanglerSlash_cleanup
	 // Refund Unspent Ammo:
	with(creator) if("red_ammo" in self){
	//	red_ammo = min(red_ammo + other.red_ammo, red_amax);
	}
	
	
#define InvCrystalBat_create(_x, _y)
	/*
		Cursed version of the Crystal Bat
	*/
	
	with(obj_create(_x, _y, "CrystalBat")){
		 // Visual:
		spr_idle     = spr.InvCrystalBatIdle;
		spr_walk     = spr.InvCrystalBatIdle;
		spr_hurt     = spr.InvCrystalBatHurt;
		spr_dead     = spr.InvCrystalBatDead;
		spr_chrg     = spr.InvCrystalBatTell;
		spr_fire     = spr.InvCrystalBatDash;
		hitid        = [spr_idle, "@pC@qU@qR@qS@qE@qD @qC@qR@qY@qS@qT@qA@qL @qB@qA@qT"];
		sprite_index = spr_idle;
		
		 // Sounds:
		snd_hurt = choose(sndBanditHit, sndBigMaggotHit, sndScorpionHit, sndRatHit, sndGatorHit, sndRavenHit, sndSalamanderHurt, sndSniperHit);
		snd_dead = choose(sndBanditDie, sndBigMaggotDie, sndScorpionDie, sndRatDie, sndGatorDie, sndRavenDie, sndSalamanderDead);
		
		 // Vars:
		curse = true;
		
		return self;
	}
	
	
#define InvMortar_create(_x, _y)
	/*
		Cursed version of the Crystal Mortar, can randomly swap positions with another enemy when hurt
	*/
	
	with(obj_create(_x, _y, "Mortar")){
		 // Visual:
		spr_idle     = spr.InvMortarIdle;
		spr_walk     = spr.InvMortarWalk;
		spr_fire     = spr.InvMortarFire;
		spr_hurt     = spr.InvMortarHurt;
		spr_dead     = spr.InvMortarDead;
		hitid        = [spr_idle, "@p@qC@qU@qR@qS@qE@qD @qM@qO@qR@qT@qA@qR"];
		sprite_index = spr_idle;
		
		 // Sounds:
		snd_hurt = choose(sndBanditHit, sndBigMaggotHit, sndScorpionHit, sndRatHit, sndGatorHit, sndRavenHit, sndSalamanderHurt, sndSniperHit);
		snd_dead = choose(sndBanditDie, sndBigMaggotDie, sndScorpionDie, sndRatDie, sndGatorDie, sndRavenDie, sndSalamanderDead);
		  
		 // Vars:
		curse = true;  
		
		return self;
	}
	
	
#define MinerBandit_create(_x, _y)
	/*
		Bandit with light hat
		
		Vars
			light_angle   - Used for gradual light rotation
			light_visible - Used for flickering
	*/
	
	with(instance_create(_x, _y, Bandit)){
		 // Visual:
		spr_idle     = spr.MinerBanditIdle;
		spr_walk     = spr.MinerBanditWalk;
		spr_hurt     = spr.MinerBanditHurt;
		spr_dead     = spr.MinerBanditDead;
		hitid        = [spr_idle, "MINER BANDIT"];
		sprite_index = spr_idle;
		
		 // Vars:
		maxhealth     = 8; // protective headgear
		my_health     = maxhealth;
		light_angle   = gunangle;
		light_visible = true;
		
		 // Facing:
		enemy_face(gunangle);
		
		return self;
	}
	
#define MinerBandit_step
	 // Turn Light:
	light_angle = angle_lerp_ct(light_angle, gunangle, 1/4);
	
	 // Flicker:
	if(frame_active(3)){
		light_visible = !chance(1, 10);
		
		 // Broken:
		if(GameCont.area == area_cursed_caves){
			light_visible = !light_visible;
		}
	}
	
	
#define Mortar_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.MortarIdle;
		spr_walk     = spr.MortarWalk;
		spr_fire     = spr.MortarFire;
		spr_hurt     = spr.MortarHurt;
		spr_dead     = spr.MortarDead;
		spr_shadow   = shd48;
		spr_shadow_y = 4;
		hitid        = [spr_idle, "MORTAR"];
		depth        = -3;
		
		 // Sound:
		snd_hurt = sndLaserCrystalHit;
		snd_dead = sndLaserCrystalDeath;
		
		 // Vars:
		mask_index = mskDogGuardian;
		maxhealth  = 75;
		raddrop    = 30;
		size       = 3;
		walk       = 0;
		walkspeed  = 0.8;
		maxspeed   = 2;
		ammo       = 4;
		target_x   = x;
		target_y   = y;
		gunangle   = random(360);
		direction  = gunangle;
		curse      = false;
		
		 // Alarms:
		alarm1 = 100 + irandom(40);
		alarm2 = -1;
		
		return self;
	}
	
#define Mortar_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	if(sprite_index != spr_fire || anim_end){
		sprite_index = enemy_sprite;
	}
	
	 // Charging effect:
	if(sprite_index == spr_fire && chance_ct(1, 5)){
		var	_x = x + 6 * right,
			_y = y - 16,
			_l = irandom_range(16, 24),
			_d = random(360);
			
		with(instance_create(_x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), LaserCharge)){
			depth = other.depth - 1;
			motion_set(_d + 180, random_range(1,2));
			alarm0 = point_distance(x, y, _x, _y) / speed;
		}
	}
	
	 // Curse Particles:
	if(curse > 0 && chance_ct(curse, 3)){
		instance_create(x + orandom(8), y + orandom(8), Curse);
	}
	
#define Mortar_draw
	var _hurt = (sprite_index == spr_fire && nexthurt >= current_frame + 4);
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	draw_self_enemy();
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
#define Mortar_alrm1
	alarm1 = 80 + random(20);
	
	 // Near Target:
	if(enemy_target(x, y) && target_distance < 240){
		enemy_look(target_direction);
		
		 // Attack:
		if(chance(1, 3)){
			alarm2       = 26;
			target_x     = target.x;
			target_y     = target.y;
			sprite_index = spr_fire;
			sound_play(sndCrystalJuggernaut);
		}
		
		 // Move Towards Target:
		else{
			alarm1 = 40 + irandom(40);
			enemy_walk(
				gunangle + orandom(15),
				15 + random(30)
			);
		}
	}
	
	 // Passive Movement:
	else{
		alarm1 = 50 + irandom(30);
		enemy_walk(random(360), 10);
		enemy_look(direction);
	}

#define Mortar_alrm2
	enemy_target(x, y);

	 // Start:
	if(ammo <= 0){
		if(instance_exists(target)){
			target_x = target.x;
			target_y = target.y;
		}
		ammo = 4;
	}

	if(ammo > 0){
		var	_tx = target_x + orandom(16),
			_ty = target_y + orandom(16);
			
		enemy_look(point_direction(x, y, _tx, _ty));
		
		 // Sound:
		sound_play(sndCrystalTB);
		sound_play(sndPlasma);
		
		 // Shoot Mortar:
		with(projectile_create(x + (5 * right), y, "MortarPlasma", gunangle, 3)){
			z += 18;
			var d = point_distance(x, y, _tx, _ty) / speed;
			zspeed = (d * zfriction * 0.5) - (z / d);
			
			 // Cool particle line
			var	_x = x,
				_y = y,
				_z = z,
				_zspd = zspeed,
				_zfrc = zfriction,
				i = 0;
				
			while(_z > 0){
				with(instance_create(_x, _y - _z, BoltTrail)){
					image_angle  = point_direction(x, y, _x + other.hspeed, _y + other.vspeed - (_z + _zspd));
					image_xscale = point_distance(x, y, _x + other.hspeed, _y + other.vspeed - (_z + _zspd));
					image_yscale = random(1.5);
					image_blend  = make_color_rgb(235, 0, 67);
					depth        = -9;
					if(chance(1, 6)){
						with(instance_create(x + orandom(8), y + orandom(8), LaserCharge)){
							motion_add(point_direction(x, y, _x, _y - _z), 1);
							alarm0 = (point_distance(x, y, _x, _y - _z) / speed) + 1;
							depth  = -8;
						}
					}
				}
				
				_x += hspeed;
				_y += vspeed;
				_z += _zspd;
				_zspd -= _zfrc;
				i++;
			}
			var _ang = random(360);
			for(var _dir = _ang; _dir < _ang + 360; _dir += 120 + orandom(30)){
				var	_len = 16,
					_tx  = _x,
					_ty  = _y;
					
				with(instance_create(_x + lengthdir_x(_len, _dir), _y + lengthdir_y(_len, _dir), LaserCharge)){
					motion_add(point_direction(x, y, _tx, _ty), (point_distance(x, y, _tx, _ty) / i));
					alarm0 = i;
				}
				i *= 3/4;
			}
			with(instance_create(_x, _y, CaveSparkle)){
				image_speed *= random_range(0.5, 1);
			}
		}
		
		 // Aim After Target:
		if(instance_exists(target) && target_visible){
			var	_l = 32,
				_d = point_direction(target_x, target_y, target.x, target.y);
				
			target_x += lengthdir_x(_l, _d);
			target_y += lengthdir_y(_l, _d);
		}
		
		if(--ammo > 0) alarm2 = 4;
	}

#define Mortar_hurt(_damage, _force, _direction)
	my_health -= _damage;
	nexthurt = current_frame + 6;
	motion_add(_direction, _force);
	sound_play_hit(snd_hurt, 0.3);
	
	 // Hurt Sprite:
	if(sprite_index != spr_fire){
		sprite_index = spr_hurt;
		image_index = 0;
		
		 // Cursed Mortar Behavior:
		if(curse > 0 && my_health > 0 && chance(_damage / 25, 1)){
			var	_x       = x,
				_y       = y,
				_enemies = instances_matching_ne(enemy, "name", name);
				
			 // Swap places with another dude:
			if(array_length(_enemies) > 0){
				with(instance_random(_enemies)){
					other.x = x;
					other.y = y;
					x = _x;
					y = _y;
					
					 // Unstick from walls:
					if(!instance_budge(Wall, -1)){
						wall_clear(x, y);
					}
					
					 // Effects:
					nexthurt = current_frame + 6;
					sprite_index = spr_hurt;
					image_index = 0;
				}
				
				 // Unstick from walls:
				if(place_meeting(x, y, Floor)){
					if(!instance_budge(Wall, -1)){
						wall_clear(x, y);
					}
				}
				else{
					top_create(x, y, self, 0, 0);
				}
			}
		}
	}
	
#define Mortar_death
	 // Pickups:
	pickup_drop(30, 35, 0);
	pickup_drop(30, 0);
	
	
#define MortarPlasma_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.MortarPlasma;
		depth        = -12;
		
		 // Vars:
		mask_index = mskNone;
		damage     = 0;
		force      = 0;
		z          = 1;
		zspeed     = 0;
		zfriction  = 0.4; // 0.8
		
		return self;
	}
	
#define MortarPlasma_step
	z      += zspeed    * current_time_scale;
	zspeed -= zfriction * current_time_scale;
	
	 // Facing:
	if((direction >= 30 && direction <= 150) || (direction >= 210 && direction <= 330)){
		image_index = round((point_direction(0, 0, speed, zspeed) + 90) / (360 / image_number));
		image_angle = direction;
	}
	else{
		if(zspeed > 5) image_index = 0;
		else if(zspeed > 2) image_index = 1;
		else image_index = 2;
		image_angle = point_direction(0, 0, hspeed, -zspeed);
	}
	
	 // Trail:
	if(chance_ct(1, 2)){
		with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
			sprite_index = spr.EnemyPlasmaTrail;
			depth = other.depth;
		}
	}
	
	 // Hit:
	if(z <= 0 || (z <= 8 && position_meeting(x, y + 8, Wall))){
		instance_destroy();
	}
	
#define MortarPlasma_draw
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	
	 // Bloom:
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(sprite_index, image_index, x, y - z, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
	draw_set_blend_mode(bm_normal);
	
#define MortarPlasma_hit
	// nada
	
#define MortarPlasma_wall
	// nada
	
#define MortarPlasma_destroy
	 // Impact:
	with(projectile_create(x, y, PlasmaImpact, 0, 0)){
		sprite_index = spr.EnemyPlasmaImpact;
		damage = 2;
		
		 // Over Wall:
		if(position_meeting(x, y + 8, Wall) || !position_meeting(x, y + 8, Floor)){
			depth = -9;
		}
	}
	
	 // Effects:
	view_shake_at(x, y, 3);
	sound_play_hit_ext(sndPlasmaHit, 1 + orandom(0.1), 1.5);
	
	
#define NewCocoon_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = sprCocoon;
		spr_hurt = sprCocoonHurt;
		spr_dead = sprCocoonDead;
		spr_shadow = shd24;
		
		 // Sound:
		snd_dead = sndCocoonBreak;
		
		 // Vars:
		maxhealth = 6;
		size = 1;
		
		return self;
	}
	
#define NewCocoon_death
	 // Bits:
	var _ang = random(360);
	for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 5)){
		with(scrFX(x, y, [_dir, 1.5], Feather)){
			sprite_index = spr.PetSpiderWebBits;
			image_blend  = make_color_hsv(0, 0, 165);
			image_angle  = orandom(30);
			image_index  = irandom(image_number - 1);
			image_speed  = 0;
			rot         /= 2;
		}
	}
	
	 // O no:
	if(chance(1, 25)){
		with(obj_create(x, y, "SunkenSealSpawn")){
			alarm0 = 15;
		}
	}
	
	 // Hatch 1-3 Spiders:
	else if(chance(4, 5)){
		repeat(irandom_range(1, 3)){
			obj_create(x, y, "Spiderling");
		}
	}
	
	 // Normal:
	else{
		instance_change(Cocoon, false);
		instance_destroy();
	}
	
	
#define PlasmaImpactSmall_create(_x, _y)
	var	_lastShake = UberCont.opt_shake,
		_lastFreeze = UberCont.opt_freeze;
		
	UberCont.opt_shake *= 0.5;
	UberCont.opt_freeze = 0;
	
	var _inst = instance_create(_x, _y, PlasmaImpact);
	
	with(_inst){
		 // Visual:
		sprite_index = spr.PlasmaImpactSmall;
		
		 // Vars:
		mask_index = msk.PlasmaImpactSmall;
		damage     = 2;
		force      = 6;
	}
	
	UberCont.opt_shake = _lastShake;
	UberCont.opt_freeze = _lastFreeze;
	
	return _inst;
	
	
#define RedBullet_create(_x, _y)
	with(obj_create(_x, _y, "CustomShell")){
		 // Visuals:
		sprite_index = spr.RedBullet;
		spr_fade     = spr.RedBulletDisappear
		spr_dead     = spr_fade;
		
		 // Vars:
		mask_index   = mskFlakBullet;
		friction     = 1;
		damage       = 400;
		force        = 10;
		bonus_damage = 40;
		minspeed     = 8;
		wallbounce   = 7 * skill_get(mut_shotgun_shoulders);
		
		 // Events:
		on_hit = RedBullet_hit;
		
		return self;
	}
	
#define RedBullet_hit
	if(projectile_canhit(other)){
		projectile_hit_push(other, min(damage + (bonus_damage * bonus), max(other.my_health, 10)), force);
		
		 // Annihilation Time:
		if(instance_is(other, prop) || other.team == 0 || (instance_is(other, CustomEnemy) && "name" in other && other.name == "Tesseract")){
			obj_create(x, y, "RedExplosion");
		}
		else{
			mod_script_call("skill", "annihilation", "enemy_annihilate", other, 2);
			sleep(150);
		}
		
		 // Goodbye:
		with(instance_create(x, y, BulletHit)){
			sprite_index = other.spr_dead;
		}
		instance_destroy();
	}
	
	
#define RedExplosion_create(_x, _y)
	/*
		An explosion that deals massive pinpoint damage and destroys any enemy projectiles and explosions that it touches
	*/
	
	with(instance_create(_x, _y, MeatExplosion)){
		 // Visual:
		sprite_index = spr.RedExplosion;
		image_angle  = random(360);
		
		 // Vars:
		mask_index = mskPlasma;
		damage     = 200;
		force      = 2;
		team       = 2;
		target     = noone;
		
		 // Sounds:
		sound_stop(sndMeatExplo);
		audio_sound_set_track_position(sound_play_hit_ext(sndUltraEmpty,    1.1 + random(0.2), 2), 0.1)
		audio_sound_set_track_position(sound_play_hit_ext(sndExplosionS,    0.8 + random(0.4), 3), 0.03);
		audio_sound_set_track_position(sound_play_hit_ext(sndIDPDNadeExplo, 1.2 + random(0.4), 3), 0.4);
		
		return self;
	}
	
#define RedExplosion_end_step
	 // Follow Target:
	if(instance_exists(target)){
		x = target.x;
		y = target.y;
	}
	
	 // Clear Explosions:
	if(place_meeting(x, y, Explosion)){
		with(instances_meeting(x, y, Explosion)){
			if(place_meeting(x, y, other)){
				instance_destroy();
			}
		}
	}
	
	
#define RedShank_create(_x, _y)
	with(instance_create(_x, _y, Shank)){
		 // Visual:
		sprite_index = spr.RedShank;
		
		 // Vars:
		damage = 10;
		force  = 6;
		
		return self;
	}
	
	
#define RedSlash_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.RedSlash;
		image_speed  = 0.4;
		
		 // Vars:
		mask_index = mskSlash;
		friction   = 0.1;
		damage     = 10;
		force      = 12;
		walled     = false;
		clone      = false;
		
		return self;
	}
	
#define RedSlash_end_step
	 // Clone Chests:
	if(clone){
		var _inst = [];
		if(place_meeting(x, y, chestprop)){
			_inst = array_combine(_inst, instances_matching(chestprop, "", null));
		}
		if(place_meeting(x, y, Pickup)){
			_inst = array_combine(_inst, instances_matching(Pickup, "mask_index", mskPickup));
		}
		if(array_length(_inst)){
			with(instances_meeting(x, y, _inst)){
				if(place_meeting(x, y, other)){
					if(!instance_exists(CustomObject) || !array_length(instances_matching(instances_matching(CustomObject, "name", "CrystalClone"), "target", self))){
						var _clone = self;
						
						motion_add(random(180), 1);
						
						with(other){
							with(RedSlash_clone(_clone)){
								appear = 1/2;
								with(target){
									direction += 180;
								}
								with(obj_create(_clone.x, _clone.y, "CrystalClone")){
									clone       = _clone;
									target      = clone;
									creator     = other.creator;
									team        = other.team;
									appear      = other.appear;
									appear_flip = !other.appear_flip;
								}
							}
						}
					}
				}
			}
		}
	}
	
#define RedSlash_wall
	if(!walled){
		walled = true;
		
		 // Hit Wall FX:
		var	_x   = bbox_center_x + hspeed_raw,
			_y   = bbox_center_y + vspeed_raw,
			_col = area_get_back_color("red");
			
		with(
			instance_is(other, Wall)
			? instance_nearest_bbox(_x, _y, instances_meeting(_x, _y, Wall))
			: other
		){
			with(instance_create(bbox_center_x, bbox_center_y, MeleeHitWall)){
				image_angle = point_direction(_x, _y, x, y);
				image_blend = _col;
				sound_play_hit(sndMeleeWall, 0.3);
			}
		}
	}
	
#define RedSlash_projectile
	if(instance_exists(self)){
		with(other){
			if(typ == 1 || typ == 2){
				 // Deflect (No Team Change):
				if(typ == 1 && other.candeflect){
					deflected   = true;
					team        = other.team;
					direction   = other.direction;
					image_angle = direction;
					
					 // Effects:
					with(instance_create(x, y, Deflect)){
						image_angle = other.image_angle;
					}
					
					 // Clone:
					if(other.clone){
						var _clone = self;
						with(other){
							with(RedSlash_clone(_clone)){
								appear = 2/3;
								with(target){
									var _lastVSpeed = vspeed;
									direction  += random_range(10, 20) * choose(-1, 1);
									image_angle = direction;
									if(vspeed < _lastVSpeed){
										other.appear_flip = true;
									}
								}
								with(obj_create(_clone.x, _clone.y, "CrystalClone")){
									clone       = _clone;
									target      = clone;
									creator     = other.creator;
									team        = other.team;
									appear      = other.appear;
									appear_flip = !other.appear_flip;
								}
							}
						}
					}
				}
				
				 // Destroy:
				else instance_destroy();
			}
		}
	}
	
#define RedSlash_hit
	if(projectile_canhit_melee(other)){
		var _lastHealth = other.my_health;
		
		 // Damage:
		projectile_hit_push(other, damage, force);
		
		 // Clone:
		if(instance_exists(self) && clone && instance_is(other, enemy)){
			if(_lastHealth > 0 && other.my_health <= 0){
				with(RedSlash_clone(other)){
					with(target){
						my_health = _lastHealth;
					}
					appear        = 2/3;
					appear_health = _lastHealth;
				}
			}
		}
	}
	
#define RedSlash_clone(_inst)
	/*
		Clones the given instance for Entangler's mega slashes
	*/
	
	with(_inst){
		 // Effects:
		var _size = (
			("size" in self)
			? size
			: floor(bbox_width / 16)
		);
		with(instance_create(x, y, BulletHit)){
			sprite_index = spr.WaterStreak;
			image_xscale = (2 + _size) / 3;
			image_yscale = image_xscale / 3;
			image_angle  = (((other.direction % 180) - 90) / 4.5) + orandom(8);
			image_blend  = area_get_back_color("red");
			depth        = -4;
			with(instance_copy(false)){
				image_angle += 180;
			}
		}
		repeat(3){
			obj_create(x + orandom(6 * (_size + 1)), y + orandom(6 * (_size + 1)), "CrystalBrainEffect");
		}
		sleep(8 * (1 + _size));
		
		 // Sound:
		sound_play_hit_ext(sndSwapSword, 1.6 + random(0.2), 1);
		
		 // Clone the Bro:
		var _slash = other;
		with(obj_create(x, y, "CrystalClone")){
			clone   = other;
			creator = _slash.creator;
			team    = _slash.team;
			budge   = false;
			
			with(self){
				event_perform(ev_step, ev_step_normal);
			}
			
			return self;
		}
	}
	
	return noone;
	
	
#define RedSpider_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.RedSpiderIdle;
		spr_walk     = spr.RedSpiderWalk;
		spr_hurt     = spr.RedSpiderHurt;
		spr_dead     = spr.RedSpiderDead;
		sprite_index = spr_idle;
		spr_shadow   = shd24;
		hitid        = [spr_idle, "RED SPIDER"];
		depth        = -2;
		
		 // Sounds:
		snd_hurt = sndSpiderHurt;
		snd_dead = sndSpiderDead;
		snd_mele = sndSpiderMelee;
		
		 // Vars:
		mask_index  = mskSpider;
		maxhealth   = 14;
		raddrop     = 4;
		size        = 1;
		walk        = 0;
		walkspeed   = 0.6;
		maxspeed    = 4;
		canmelee    = true;
		meleedamage = 2;
		target_seen = false;
		
		 // Alarms:
		alarm1 = irandom_range(30, 60);
		
		return self;
	}
	
#define RedSpider_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	
#define RedSpider_alrm1
	alarm1 = irandom_range(10, 30);
	
	if(enemy_target(x, y)){
		 // Permanent Aggro:
		if(!target_seen && target_visible){
			target_seen = true;
		}
		
		 // Attack:
		if(chance(2, 3) && target_distance < 96){
			alarm1 = 45;
			walk   = 0;
			speed /= 2;
			
			var _dir = target_direction;
			
			enemy_look(_dir);
			
			for(var i = -1; i <= 1; i++){
				var	_l = 128,
					_d = (i * 90) + pround(_dir, 45) + orandom(2);
					
				with(projectile_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "VlasmaBullet", _d + 180, 1)){
					sprite_index = spr.EnemyVlasmaBullet;
					target       = other;
					target_x     = other.x;
					target_y     = other.y;
					my_sound     = sound_play_hit_ext(sndHyperCrystalSpawn, 0.9 + random(0.3), 0.8);
				}
			}
		}
		
		 // Towards Target:
		else if(target_seen){
			enemy_walk(target_direction + orandom(10), 15);
			enemy_look(direction);
		}
		
		 // Wander:
		else{
			enemy_walk(random(360), 10);
			enemy_look(direction);
		}
	}
	
	 // Wander:
	else{
		enemy_walk(random(360), random_range(5, 10));
		enemy_look(direction);
		alarm1 += walk;
	}
	
#define RedSpider_hurt(_damage, _force, _direction)
	enemy_hurt(_damage, _force, _direction);
	target_seen = true;
	
#define RedSpider_death
	pickup_drop(20, 0);
	
	 // Plasma:
	with(team_instance_sprite(1, projectile_create(x, y, PlasmaImpact, 0, 0))){
		mask_index = mskPopoPlasmaImpact;
		wall_clear(x, y);
	}
	sound_play_hit_big(sndPlasmaHit, 0.2);
	
	
#define Spiderling_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.SpiderlingIdle;
		spr_walk     = spr.SpiderlingWalk;
		spr_hurt     = spr.SpiderlingHurt;
		spr_dead     = spr.SpiderlingDead;
		spr_hatch    = spr.SpiderlingHatch;
		spr_shadow   = shd16;
		spr_shadow_y = 2;
		hitid        = [spr_idle, "SPIDERLING"];
		depth        = -2;
		
		 // Sound:
		snd_hurt = sndSpiderHurt;
		snd_dead = sndSpiderDead;
		
		 // Vars:
		mask_index = mskMaggot;
		maxhealth  = 4;
		raddrop    = 2;
		size       = 0;
		walk       = 0;
		walkspeed  = 0.8;
		maxspeed   = 3;
		nexthurt   = current_frame + 15;
		direction  = random(360);
		
		 // Cursed:
		curse = (GameCont.area == area_cursed_caves);
		if(curse > 0){
			spr_idle  = spr.InvSpiderlingIdle;
			spr_walk  = spr.InvSpiderlingWalk;
			spr_hurt  = spr.InvSpiderlingHurt;
			spr_dead  = spr.InvSpiderlingDead;
			spr_hatch = spr.InvSpiderlingHatch;
			snd_hurt  = choose(sndHitFlesh, sndBanditHit, sndFastRatHit);
			snd_dead  = choose(sndEnemyDie, sndBanditDie, sndFastRatDie);
		}
		
		 // Alarms:
		alarm0 = irandom_range(60, 150);
		alarm1 = irandom_range(20, 40);
		
		 // Hatch Delay:
		var _n = instance_nearest(x, y, Player);
		if(instance_exists(_n)){
			alarm0 += point_distance(x, y, _n.x, _n.y);
		}
		
		return self;
	}
	
#define Spiderling_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	
#define Spiderling_alrm0
	 // Shhh dont tell anybody
	var _obj = ((curse > 0) ? InvSpider : Spider);
	with(instance_create(x, y, _obj)){
		x       = other.x;
		y       = other.y;
		creator = other;
		right   = other.right;
		alarm1  = 10 + random(10);
		
		 // Out of Wall:
		instance_budge(Wall, -1);
	}

	 // Effects:
	for(var _dir = 0; _dir < 360; _dir += (360 / 6)){
		var _len = random(8);
		with(instance_create(x + lengthdir_x(_len, _dir), y + lengthdir_y(_len, _dir), Smoke)){
			motion_add(_dir + orandom(20), 1 + random(1.5));
			depth = -3;
			with(instance_create(x, y, Dust)){
				motion_add(other.direction + orandom(90), 2);
				depth = other.depth;
			}
		}
	}
	for(var _dir = direction; _dir < direction + 360; _dir += (360 / 3)){
		with(obj_create(x, y, "CatDoorDebris")){
			sprite_index = other.spr_hatch;
			image_index  = irandom(image_number - 1);
			direction    = _dir + orandom(30);
			speed       += 1 + random(4);
		}
	}
	sound_play_hit(sndHitRock,       0.3);
	sound_play_hit(sndBouncerBounce, 0.5);
	sound_play_pitchvol(sndCocoonBreak, 2 + random(1), 0.8);
	
	 // Gone:
	instance_delete(self);

#define Spiderling_alrm1
	alarm1 = 10 + irandom(10);
	
	 // Targeting:
	enemy_target(x, y);
	if(instance_exists(CrystalProp) || instance_exists(InvCrystal)){
		var _crystal = instance_nearest_array(x, y, [CrystalProp, InvCrystal]);
		if(!instance_exists(target) || point_distance(x, y, _crystal.x, _crystal.y) < target_distance){
			target = _crystal;
		}
	}
	
	 // Cursed:
	if(curse > 0) repeat(curse){
		instance_create(x, y, Curse);
	}
	
	 // Move Towards Target:
	if(
		instance_exists(target)
		&& target_distance < 96
		&& target_visible
	){
		enemy_walk(target_direction + orandom(20), 14);
		enemy_look(direction);
		if(instance_is(target, prop)){
			direction += orandom(60);
			alarm1 *= random_range(1, 2);
		}
	}
	
	 // Wander:
	else{
		enemy_walk(direction + orandom(20), 12);
		enemy_look(direction);
	}

#define Spiderling_death
	pickup_drop(15, 0);
	
	 // Dupe Time:
	var _chance = 2/3 * curse;
	if(chance(_chance, 1)){
		speed = min(1, speed);
		repeat(3 * max(1, _chance)){
			with(obj_create(x, y, "Spiderling")){
				sprite_index = spr_hurt;
				alarm0       = ceil(other.alarm0 / 2);
				curse        = other.curse / 2;
				kills        = other.kills;
				raddrop      = 0;
			}
		}
	}
	
	
#define Tesseract_create(_x, _y)
	/*
		Loop boss for the Warp Zone
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
		 // Visual:
		spr_idle     = spr.TesseractIdle;
		spr_walk     = spr.TesseractIdle;
		spr_hurt     = spr.TesseractHurt;
		spr_fire     = spr.TesseractFire;
		spr_tell	 = spr.TesseractTell;
		spr_shadow   = mskNone;
		spr_shadow_y = 12;
		hitid        = [spr.TesseractDeathCause, `@9(${spr.TesseractDeathCauseText}:-0.7)`];
		sprite_index = spr_tell;
		depth        = -3;
		
		 // Sound:
		snd_hurt = sndHyperCrystalHurt;
		snd_dead = sndHyperCrystalChargeExplo;
		snd_lowh = sndNothingRise;
		snd_mele = sndBasicUltra;
		
		 // Vars:
		mask_index  = msk.CaveHole;
		friction    = 0.2;
		maxhealth   = boss_hp(600);
		meleedamage = maxhealth;
		canmelee    = false;
		raddrop     = 65;
		size        = 6;
		walk        = 0;
		walkspeed   = 0.4;
		maxspeed    = 2;
		minspeed    = 0.2;
		corpse      = false;
		intro       = false;
		ammo        = 3;
		tauntdelay  = 30;
		direction   = random(360);
		
		 // Alarms:
		alarm1 = 200;
		alarm2 = 240;
		
		 // Layers:
		layers = array_create(array_length(spr.TesseractLayer));
		for(var i = 0; i < array_length(layers); i++){
			layers[i] = {
				"spr_idle"    : spr.TesseractLayer[i],
				"spr_dead"    : spr.TesseractDeathLayer[i],
				"rotation"    : 0,
				"rotspeed"    : 0,
				"rotfriction" : 0.2
			};
		}
		
		 // Arms:
		weapons     = [];
		weapons_max = 4 + GameCont.loops;
		if(weapons_max > 0){
			for(var _rot = 0; _rot < 360; _rot += (360 / weapons_max)){
				array_push(weapons, {
					"spr_idle"    : spr.TesseractWeapon,
					"rotation"    : _rot + pround(direction, 90),
					"rotspeed"    : 0,
					"rotfriction" : 0.1,
					"offset"      : 64 * 2/3,
					"kick"        : 16,
					"kick_goal"   : 0,
					"strike"      : noone
				});
			}
		}
		
		 // Music:
		with(MusCont){
			alarm_set(2, 1);
			alarm_set(3, -1);
		}
		
		 // For Sani's bosshudredux:
		bossname = hitid[1];
		col      = area_get_back_color("red");
		
		return self;
	}
	
#define Tesseract_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Animate:
	if((sprite_index != spr_tell && sprite_index != spr_fire) || anim_end){
		sprite_index = (
			(intro || sprite_index == spr_hurt)
			? enemy_sprite
			: spr_tell
		);
	}
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed < minspeed){
		speed = minspeed;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	/*
	 // Bounce Around:
	if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
		if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -0.1;
		if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -0.1;
	}
	*/
	
	 // Weapons:
	with(weapons){
		rotation += rotspeed * current_time_scale;
		rotspeed -= clamp(rotspeed, -rotfriction * current_time_scale, rotfriction * current_time_scale);
		kick     -= clamp(kick,                   -current_time_scale,               current_time_scale);
		
		 // Preparing Strike:
		if(instance_exists(strike) && strike.active){
			strike.xstart      = other.x + lengthdir_x(offset * other.image_xscale, rotation);
			strike.ystart      = other.y + lengthdir_y(offset * other.image_yscale, rotation);
			strike.image_angle = rotation;
			
			 // Strike Launched:
			if(strike.alarm1 > 0 && strike.alarm1 <= ceil(current_time_scale)){
				kick = kick_goal;
				with(other){
					sprite_index = spr_fire;
					image_index  = 0;
					with(layers){
						if(abs(rotspeed) < 6){
							rotspeed += 3 * ((rotspeed == 0) ? choose(-1, 1) : sign(rotspeed));
						}
					}
				}
			}
		}
	}
	
	 // Layers:
	with(layers){
		rotation += rotspeed * current_time_scale;
		rotspeed -= clamp(rotspeed, -rotfriction * current_time_scale, rotfriction * current_time_scale);
		
		 // Random Spins:
		if(chance_ct(1, 40)){
			rotspeed = orandom(6);
		}
	}
	
	 // Death Taunt:
	if(tauntdelay > 0 && !instance_exists(Player)){
		tauntdelay -= current_time_scale;
		if(tauntdelay <= 0){
			sound_play_pitch(sndLastGrowl,               0.3);
			sound_play_pitch(sndHyperCrystalChargeExplo, 0.3);
		}
	}
	
	 // Eject Arms:
	if(my_health / maxhealth <= max(0.1, array_length(weapons) - 1) / weapons_max){
		Tesseract_arm_break(array_length(weapons) - 1);
	}
	
#define Tesseract_draw
	var	_max  = array_length(layers),
		_hurt = (sprite_index == spr_hurt && image_index < 1);
		
	 // Flash:
	if(_hurt){
		draw_set_fog(true, image_blend, 0, 0);
	}
	
	 // Outline Layers:
	for(var i = 0; i < _max; i++){
		var _layer = layers[i];
		draw_sprite_ext(
			_layer.spr_idle,
			0,
			x,
			y,
			image_xscale,
			image_yscale,
			image_angle + _layer.rotation,
			image_blend,
			image_alpha
		);
	}
	
	 // Main Layers:
	for(var i = 0; i < _max; i++){
		var _layer = layers[i];
		
		 // Weapons:
		if(i == (_max - 1)){
			for(var j = 0; j < array_length(weapons); j++){
				var _wep = weapons[j],
					_len = _wep.offset - _wep.kick,
					_dir = _wep.rotation;
					
				draw_sprite_ext(
					_wep.spr_idle,
					image_index,
					x + lengthdir_x(_len * image_xscale, _dir),
					y + lengthdir_y(_len * image_yscale, _dir),
					image_xscale,
					image_yscale,
					_dir,
					image_blend,
					image_alpha
				);
			}
		}
		
		 // Layer:
		draw_sprite_ext(
			_layer.spr_idle,
			1,
			x,
			y,
			image_xscale,
			image_yscale,
			image_angle + _layer.rotation,
			image_blend,
			image_alpha
		);
	}
	
	 // Un-Flash:
	if(_hurt){
		draw_set_fog(false, 0, 0, 0);
	}
	
	 // Eye:
	draw_self();
	
#define Tesseract_alrm1
	alarm1 = 60 + random(30);
	 
	 // Just Schmovin' About:
	enemy_walk(
		direction + orandom(90),
		60 + random(60)
	);
	 
	 // Boss Intro:
	if(!intro){
		intro    = true;
		canmelee = true;
		with(boss_intro("Tesseract")){
			loops = GameCont.loops;
		}
		
		 // Sound:
		sound_play_pitch(sndBigDogHit,     0.2);
		sound_play_pitch(sndTVOn,          0.3);
		sound_play_pitch(sndRogueCanister, 0.5);
		sound_play_pitch(sndBallMamaLoop,  8.0);
		
		 // Clear Walls:
		wall_clear(x, y);
		with(weapons){
			with(instance_create(
				other.x + lengthdir_x(offset * other.image_xscale, rotation),
				other.y + lengthdir_y(offset * other.image_yscale, rotation),
				PortalClear
			)){
				motion_add(other.rotation, 3);
			}
		}
	}
	
	 // Where da hell is this guy:
	else if(enemy_target(x, y) && (!target_visible || target_distance > 192)){
		direction = target_direction + orandom(30);
		with(wall_clear(x, y)){
			motion_add(other.direction, 8);
		}
		alarm1 = 15 + random(30);
	}
	
	 // Move Toward Center of Area:
	else if(instance_exists(Floor)){
		var	_x1 = x,
			_y1 = y,
			_x2 = x,
			_y2 = y;
			
		 // Find Boundary of Visible Floors:
		with(Floor){
			if(!collision_line(other.x, other.y, bbox_center_x, bbox_center_y, Wall, false, false)){
				if(bbox_left   < _x1) _x1 = bbox_left;
				if(bbox_top    < _y1) _y1 = bbox_top;
				if(bbox_right  > _x2) _x2 = bbox_right;
				if(bbox_bottom > _y2) _y2 = bbox_bottom;
			}
		}
		
		 // Move:
		var	_tx = (_x1 + _x2) / 2,
			_ty = (_y1 + _y2) / 2;
			
		if(point_distance(x, y, _tx, _ty) > 64){
			direction = point_direction(x, y, _tx, _ty) + orandom(30);
		}
	}
	
#define Tesseract_alrm2
	alarm2 = 10 + random(40);
	
	enemy_target(x, y);
	
	if(ammo <= 0){
		 // Begin Orderly Attack:
		if(chance(array_length(weapons) - 1, weapons_max * 2)){
			ammo = min(array_length(weapons), irandom_range(2, 4));
			with(weapons){
				kick = -16;
			}
		}
		
		 // Begin Chaotic Attack:
		else if(array_length(weapons)){
			var _wep = weapons[0];
			if(!instance_exists(_wep.strike)){
				 // Effects:
				instance_create(
					x + lengthdir_x(_wep.offset, _wep.rotation),
					y + lengthdir_y(_wep.offset, _wep.rotation),
					Smoke
				);
				
				 // Aim:
				if(instance_exists(target)){
					var _lastRot = _wep.rotation;
					_wep.rotation = target_direction;
					_wep.rotspeed = 1.2 * sign(angle_difference(_wep.rotation, _lastRot));
				}
				
				 // Fire:
				_wep.strike = projectile_create(x, y, "TesseractStrike", _wep.rotation, 0);
				with(_wep.strike){
					alarm1 = min(20, other.alarm2 * array_length(other.weapons));
				}
				_wep.kick_goal = 15;
				_wep.kick	   = -5;
				
				 // Weapon Rotation:
				for(var i = 0; i < array_length(weapons) - 1; i++){
					weapons[i] = weapons[i + 1];
				}
				weapons[array_length(weapons) - 1] = _wep;
				
				 // Sounds:
				audio_sound_set_track_position(sound_play_hit_ext(sndPortalStrikeLoop, 1.3 + random(0.25), 10), 0.93);
				audio_sound_set_track_position(sound_play_hit_ext(sndSnowBotDead,      1.3 + random(0.20), 10), 0.55);
			}
		}
	}
	
	 // Orderly Attack:
	if(ammo > 0){
		ammo--;
		right = choose(-1, 1);
		
		var _max = array_length(weapons);
		
		if(_max > 0){
			var	_dir = weapons[0].rotation,
				_spd = random_range(2, 6) * right;
				
			 // Delay:
			alarm2 = max(45, 10 * abs(_spd));
			
			 // Fire:
			for(var i = 0; i < _max; i++){
				var _wep = weapons[i];
				_wep.rotation  = _dir + ((i / _max) * 360);
				_wep.rotspeed  = _spd;
				_wep.kick_goal = 10;
				_wep.strike    = projectile_create(x, y, "TesseractStrike", _wep.rotation, 0);
				with(_wep.strike){
					alarm1 = other.alarm2 - 15;
				}
			}
			
			 // Animate:
			sprite_index = spr_tell;
			image_index  = 0;
			
			 // Sounds:
			audio_sound_set_track_position(sound_play_hit_ext(sndPortalStrikeLoop, 0.85 + random(0.15), 10), 1.33);
			audio_sound_set_track_position(sound_play_hit_ext(sndSnowBotThrow,     0.60 + random(0.20),  8), 0.2);
			
			 // Cooldown:
			if(ammo <= 0){
				alarm2 = 24 * _max;
			}
		}
	}
	
#define Tesseract_hurt(_damage, _force, _direction)
	enemy_hurt(_damage, _force, _direction);
	
	 // Pitch Hurt Sound:
	if(snd_hurt == sndHyperCrystalHurt){
		sound_play_hit_ext(snd_hurt,           0.5 + random(0.3), 1);
		sound_play_hit_ext(sndNothingHurtHigh, 0.8 + random(0.2), 1);
		sound_play_hit(sndBigDogWalk, 0.3);
	}
	
#define Tesseract_death
	 // Boss Win Music:
	with(MusCont){
		alarm_set(1, 1);
	}
	
	 // Eject Arms:
	while(array_length(weapons)){
		Tesseract_arm_break(0);
	}
	
	 // Pitch Death Sound:
	if(snd_dead == sndHyperCrystalChargeExplo){
		sound_play_pitch(snd_dead, 0.2);
		snd_dead = -1;
	}
	
	 // Epic Death:
	with(obj_create(x, y, "TesseractDeath")){
		sprite_index = other.spr_hurt;
		spr_dead     = other.spr_dead;
		spr_shadow   = other.spr_shadow;
		spr_shadow_x = other.spr_shadow_x;
		spr_shadow_y = other.spr_shadow_y;
		hitid        = other.hitid;
		layers       = other.layers;
		image_xscale = other.image_xscale;
		image_yscale = other.image_yscale;
		image_angle  = other.image_angle;
		image_blend  = other.image_blend;
		image_alpha  = other.image_alpha;
		depth        = other.depth;
		mask_index   = other.mask_index;
		snd_hurt     = other.snd_hurt;
		raddrop      = other.raddrop;
		size         = other.size;
		team         = other.team;
		direction    = other.direction;
		speed        = min(other.speed / 2.5, 6);
	}
	raddrop = 0;
	
#define Tesseract_arm_break(_num)
	/*
		Breaks the given arm/weapon off of the Tesseract
	*/
	
	if(_num >= 0 && _num < array_length(weapons)){
		var _wep = weapons[_num];
		weapons = array_delete(weapons, _num);
		
		 // Angry:
		if(!intro){
			alarm1 = min(alarm1, 1);
			alarm2 = min(alarm2, 10);
		}
		ammo = min(ammo, 0);
		
		 // Half Arms:
		if(array_length(weapons) == floor(weapons_max / 2)){
			if(snd_lowh == sndNothingRise){
				sound_play_pitch(snd_lowh,                   0.7);
				sound_play_pitch(sndLastMeleeCharge,         0.25);
				sound_play_pitch(sndHyperCrystalChargeExplo, 1.5);
			}
			else sound_play(snd_lowh);
			view_shake_at(x, y, 40);
		}
		
		 // Exploding Arm:
		with(projectile_create(
			x + lengthdir_x((_wep.offset - _wep.kick) * image_xscale, _wep.rotation),
			y + lengthdir_y((_wep.offset - _wep.kick) * image_yscale, _wep.rotation),
			"TesseractArmDeath",
			_wep.rotation,
			5.5
		)){
			sprite_index = _wep.spr_idle;
			image_xscale = other.image_xscale;
			image_yscale = other.image_yscale;
			image_blend  = other.image_blend;
			image_alpha  = other.image_alpha;
			depth        = other.depth - 1;
			strike       = _wep.strike;
			
			 // Effects:
			repeat(8){
				with(scrFX(x, y, [direction + choose(-45, 45), 3], Smoke)){
					depth = other.depth;
					growspeed /= 3;
				}
			}
			view_shake_at(x, y, 20);
			
			 // Sound:
			sound_play_hit_ext(sndIDPDNadeExplo, 0.6, 3.5);
			sound_play_hit_ext(sndHeavyCrossbow, 0.6, 5);
			
			return self;
		}
	}
	
	return noone;
	
	
#define TesseractArmDeath_create(_x, _y)
	/*
		The Tesseract boss's arm exploding animation
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.TesseractWeapon;
		image_speed  = 0;
		depth        = -4;
		hitid        = -1;
		
		 // Vars:
		mask_index = mskExploder;
		friction   = 1/3;
		strike     = noone;
		force      = 8;
		damage     = 4;
		raddrop    = 16;
		
		return self;
	}
	
#define TesseractArmDeath_step
	 // Hold Strike:
	if(instance_exists(strike) && strike.active){
		strike.xstart      = x;
		strike.ystart      = y;
		strike.image_angle = image_angle;
	}
	
	 // Explode:
	if(speed < 1){
		instance_destroy();
	}
	
#define TesseractArmDeath_hit
	if(projectile_canhit_melee(other)){
		projectile_hit_push(other, damage, force);
	}
	
#define TesseractArmDeath_wall
	 // Break Walls:
	speed *= 0.95;
	with(other){
		instance_create(x, y, FloorExplo);
		instance_destroy();
	}
	
#define TesseractArmDeath_draw
	var _flash = (speed < 1 + friction || (friction != 0 && ((speed / friction) % 6) < 3));
	if(_flash){
		draw_set_fog(true, image_blend, 0, 0);
	}
	draw_self();
	if(_flash){
		draw_set_fog(false, 0, 0, 0);
	}
	
#define TesseractArmDeath_destroy
	 // Break Walls:
	instance_create(x, y, PortalClear);
	
	 // Explosion:
	with(projectile_create(x, y, "RedExplosion", direction, 0)){
		mask_index = mskPopoPlasmaImpact;
	}
	/*with(instance_create(x, y, MeltSplat)){
		sprite_index = sprMeltSplatBig;
		image_blend  = c_red;
	}*/
	
	 // Pickups:
	repeat(2){
		pickup_drop(60, 0);
	}
	rad_drop(x, y, raddrop, direction, speed);
	
	 // Chunks:
	for(var i = 0; i < 10; i++){
		with(scrFX(
			x + orandom(8),
			y + orandom(8),
			[direction + orandom(120), (i * 0.5) + random_range(1, 6)],
			"CatDoorDebris"
		)){
			sprite_index = spr.CrystalBrainChunk;
			image_index  = irandom(image_number - 1);
			flash        = 2;
			scrFX(x, y, random_range(4, 8), Smoke);
		}
	}
	
	 // Sound:
	sound_play_hit_ext(sndPlantPotBreak, 0.85 + orandom(0.15), 5);
	sound_play_hit_ext(sndExplosion,     1.0  + orandom(0.1),  5);
	sound_play_hit_ext(sndIDPDNadeExplo, 0.6  + orandom(0.1),  5);
	
	 // Activate Strike:
	with(strike){
		ammo   = min(ammo, 1);
		alarm1 = min(alarm1, time);
	}
	
	
#define TesseractDeath_create(_x, _y)
	/*
		The death sequence for the Tesseract boss
		
		Vars:
			throes - The remaining number of throes before dying
			alarm0 - Time until the next death throe
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.TesseractHurt;
		spr_shadow   = mskNone;
		spr_shadow_x = 0;
		spr_shadow_y = 12;
		hitid        = -1;
		image_speed  = 0.2;
		depth        = -3;
		
		 // Sound:
		snd_hurt = sndHyperCrystalHurt;
		snd_dead = sndHyperCrystalHalfHP;
		
		 // Vars:
		mask_index = msk.CaveHole;
		friction   = 0.2;
		size       = 6;
		team       = 1;
		raddrop    = 65;
		throes     = 3;
		
		 // Layers:
		layers = array_create(array_length(spr.TesseractLayer));
		for(var i = 0; i < array_length(layers); i++){
			layers[i] = {
				"spr_idle"    : spr.TesseractLayer[i],
				"spr_dead"    : spr.TesseractDeathLayer[i],
				"rotation"    : 0,
				"rotspeed"    : 0,
				"rotfriction" : 0.2
			};
		}
		
		 // Alarms:
		alarm0 = 1;
		
		return self;
	}
	
#define TesseractDeath_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Layers:
	var	_num = 0,
		_max = array_length(layers);
		
	with(layers){
		rotation += rotspeed * current_time_scale;
		rotspeed -= clamp(rotspeed, -rotfriction * current_time_scale, rotfriction * current_time_scale);
		
		 // Orbit Fragments:
		if(_num < _max - other.throes){
			var _spd = 2 + (1.5 * _num);
			if(abs(rotspeed) < _spd){
				rotspeed = _spd * ((rotspeed == 0) ? choose(-1, 1) : sign(rotspeed));
			}
		}
		_num++;
	}
	
	 // Animate:
	if(sprite_index != -1 && anim_end){
		image_index = image_number - 1;
		image_speed = 0;
	}
	
	 // Shake:
	x += orandom(2 * current_time_scale);
	y += orandom(2 * current_time_scale);
	
	 // Black Gas:
	if(chance_ct(1, 1 + (1.5 * throes))){
		with(scrFX(x, y, 3, Smoke)){
			image_blend = c_black;
		}
	}
	
	 // Wall Collision:
	motion_step(1);
	if(place_meeting(x, y, Wall)){
		x = xprevious;
		y = yprevious;
		move_bounce_solid(true);
	}
	motion_step(-1);
	
#define TesseractDeath_alrm0
	alarm0 = 30;
	
	 // Agony:
	if(throes > 0){
		throes--;
		
		 // Flash:
		image_index = 0;
		image_speed = 0.2;
		
		 // Jerk Around:
		speed     = 4;
		direction = point_direction(x, y, xstart, ystart) + orandom(30);
		move_contact_solid(direction, 4);
		
		 // Chunk Off:
		repeat(2){
			with(scrFX(x, y, random_range(2, 5), Shell)){
				sprite_index = spr.CrystalBrainChunk;
				image_index  = irandom(image_number - 1);
				image_speed  = 0;
			}
		}
		
		 // FX:
		if(snd_hurt == sndHyperCrystalHurt){
			sound_play_hit_ext(sndLaserCrystalHit, 0.5 + random(0.3),                8);
			sound_play_hit_ext(sndPlantPotBreak,   1.2 + random(0.6 / (1 + throes)), 8);
		}
		sound_play_hit_big(snd_hurt, 0.3);
		view_shake_at(x, y, 30);
	}
	
	 // Perish:
	else instance_destroy();
	
#define TesseractDeath_draw
	var	_max  = array_length(layers),
		_hurt = (image_index < 1);
		
	 // Flash:
	if(_hurt){
		draw_set_fog(true, image_blend, 0, 0);
	}
	
	 // Outline Layers:
	for(var i = clamp(_max - throes, 0, _max - 1); i < _max; i++){
		var _layer = layers[i];
		draw_sprite_ext(
			_layer.spr_idle,
			0,
			x,
			y,
			image_xscale,
			image_yscale,
			image_angle + _layer.rotation,
			image_blend,
			image_alpha
		);
	}
	
	 // Main Layers:
	for(var i = 0; i < _max; i++){
		var	_layer = layers[i],
			_ang   = image_angle + _layer.rotation;
			
		 // Normal:
		if(i >= (_max - throes)){
			draw_sprite_ext(
				_layer.spr_idle,
				1,
				x,
				y,
				image_xscale,
				image_yscale,
				_ang,
				image_blend,
				image_alpha
			);
		}
		
		 // Fragments:
		else{
			var	_spr    = _layer.spr_dead,
				_sprNum = sprite_get_number(_layer.spr_dead);
				
			for(var _img = 0; _img < _sprNum; _img++){
				var	_len = 16 + (4 * dsin(4 * ((360 * (_img / _sprNum)) + _ang))),
					_dir = _ang + ((_img / _sprNum) * 360);
					
				if(image_speed != 0 && i >= (_max - throes) - 1){
					_len *= clamp((image_index / image_number) * 1.5, 0, 1);
				}
				
				draw_sprite_ext(
					_spr,
					_img,
					x + (lengthdir_x(_len, _dir) * image_xscale),
					y + (lengthdir_y(_len, _dir) * image_yscale),
					image_xscale,
					image_yscale,
					_ang,
					image_blend,
					image_alpha
				);
			}
		}
	}
	
	 // Un-Flash:
	if(_hurt){
		draw_set_fog(false, 0, 0, 0);
	}
	
	 // Eye:
	draw_self();
	
#define TesseractDeath_destroy
	 // Corpse Chunks:
	for(var i = 0; i < max(1, array_length(layers) - 1); i++){
		var	_layer  = layers[i],
			_spr    = _layer.spr_dead,
			_sprNum = sprite_get_number(_spr),
			_ang    = image_angle + _layer.rotation;
			
		for(var _img = 0; _img < _sprNum; _img++){
			var	_len = 16,
				_dir = ((_img / _sprNum) * 360) + _ang;
				
			with(instance_create(x + lengthdir_x(_len, _dir), y + lengthdir_y(_len, _dir), ScrapBossCorpse)){
				sprite_index = _spr;
				image_index  = _img;
				image_xscale = other.image_xscale;
				image_yscale = other.image_yscale;
				image_angle  = _ang;
				mask_index   = -1;
				friction     = 0.5;
				size         = 3;
				motion_add(_dir, 4 + random(6) + (4 * skill_get(mut_impact_wrists)));
				speed = min(speed, 16);
			}
		}
	}
	
	 // Eye Explo:
	with(projectile_create(x, y, "RedExplosion", 0, 0)){
		mask_index  = mskPopoPlasmaImpact;
		image_angle = other.image_angle;
	}
	view_shake_at(x, y, 50);
	
	 // Spooky Gas:
	for(var _dir = 0; _dir < 360; _dir += (360 / 30)){
		var _len = random(20);
		with(scrFX(
			x + lengthdir_x(_len * image_xscale, _dir),
			y + lengthdir_y(_len * image_yscale, _dir),
			[_dir, random_range(3, 4)],
			Smoke
		)){
			image_xscale = other.image_xscale;
			image_yscale = other.image_yscale;
			image_blend  = c_black;
			depth        = other.depth;
		}
	}
	
	 // Pickups:
	repeat(3){
		pickup_drop(100, 0);
	}
	rad_drop(x, y, raddrop, direction, speed);
	var _gold = false;
	with(Player){
		if(
			weapon_get_gold(wep)  != 0   ||
			weapon_get_gold(bwep) != 0   ||
			wep_raw(wep)  == "tunneller" ||
			wep_raw(bwep) == "tunneller"
		){
			_gold = true;
			break;
		}
	}
	if(_gold){
		with(instance_create(x, y, WepPickup)){
			wep  = { wep: "tunneller", gold: true };
			ammo = true;
		}
	}
	
	 // Sound:
	sound_play_hit_ext(sndPlantPotBreak,     0.8 +  random(0.2), 6);
	sound_play_hit_ext(sndPortalOpen,        1.8 +  random(0.2), 4);
	sound_play_hit_ext(sndPortalStrikeFire,  2.5 + orandom(0.1), 4);
	sound_play_hit_ext(sndHyperCrystalTaunt, 3.0 + orandom(0.1), 4);
	sound_play_hit_big(snd_dead, 0.2);
	
	
#define TesseractStrike_create(_x, _y)
	/*
		The Tesseract boss's main attack, a warning vector followed by a line of Red Explosions
		
		Vars:
			xstart/ystart - The vector's starting point
			image_angle   - The vector's travel direction
			length        - The vector's travel distance
			active        - Still warning the player (true) or not (false)
			time          - Delay between activating explosions
			ammo          - How many explosions to activate between delays
			alarm1        - Alarm for activating explosions
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.TesseractStrike;
		image_xscale = 1/4;
		image_yscale = image_xscale;
		image_alpha  = -1;
		image_speed  = 0.4;
		depth        = -3;
		
		 // Vars:
		mask_index = mskSuperFlakBullet;
		active     = true;
		length     = 320;
		time       = 3;
		ammo       = 1;
		team       = -1;
		hitid      = -1;
		creator    = noone;
		
		 // Alarms:
		alarm1 = 35;
		
		return self;
	}
	
#define TesseractStrike_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Grow:
	image_xscale = lerp_ct(image_xscale, 1, 0.1);
	image_yscale = lerp_ct(image_yscale, 1, 0.1);
	
	 // Goodbye:
	if(active && creator != noone && !instance_exists(creator)){
		alarm1 = min(alarm1, 1);
	}
	
#define TesseractStrike_end_step
	 // Movement:
	xstart += hspeed_raw;
	ystart += vspeed_raw;
	
	 // Stay Still:
	if(active){
		x = xstart;
		y = ystart;
		
		 // Extend:
		var	_dis = length * image_xscale,
			_dir = image_angle;
			
		if(instance_exists(Wall)){
			var	_len = max(1, bbox_width),
				_ox  = lengthdir_x(_len, _dir),
				_oy  = lengthdir_y(_len, _dir);
				
			while(_dis > 0 && !place_meeting(x, y, Wall)){
				_dis -= _len;
				x += _ox;
				y += _oy;
			}
		}
		else{
			x += lengthdir_x(_dis, _dir);
			y += lengthdir_y(_dis, _dir);
		}
	}
	
#define TesseractStrike_draw
	image_alpha = abs(image_alpha);
	
	 // Arrowing:
	var	_x   = xstart,
		_y   = ystart,
		_len = max(abs(sprite_width * 2/3), game_scale_nonsync),
		_dis = point_distance(_x, _y, x, y),
		_dir = point_direction(_x, _y, x, y),
		_ox  = lengthdir_x(_len, _dir),
		_oy  = lengthdir_y(_len, _dir);
		
	while(_dis > 0){
		_dis -= _len;
		_x += _ox;
		_y += _oy;
		draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale, image_yscale, _dir, image_blend, image_alpha);
	}
	
	image_alpha *= -1;
	
#define TesseractStrike_alrm1
	alarm1 = time;
	
	var	_dis  = point_distance(xstart, ystart, x, y),
		_dir  = point_direction(xstart, ystart, x, y),
		_inst = [];
		
	 // Explosions:
	var	_len = 34 * image_xscale,
		_ox  = lengthdir_x(_len, _dir),
		_oy  = lengthdir_y(_len, _dir);
		
	if(ammo > 0){
		repeat(ammo){
			if(_dis > 0){
				_dis -= _len;
				if(_dis > 0 || (active && !array_length(_inst))){
					xstart += _ox;
					ystart += _oy;
					
					 // We Strikin':
					with(projectile_create(xstart, ystart, "RedExplosion", 0, 0)){
						mask_index = mskPopoPlasmaImpact;
						array_push(_inst, self);
					}
				}
			}
			else break;
		}
	}
	
	 // Effects:
	if(active){
		active = false;
		image_speed *= 2;
		sleep_max(15);
	}
	
	 // Goodbye:
	if(_dis <= 0){
		instance_destroy();
	}
	
	
//#define TesseractWarp_create(_x, _y)
//	with(instance_create(_x, _y, CustomObject)){
//		 // Visual:
//		sprite_index = spr.WarpOpen;
//		image_angle  = random(360);
//		image_speed  = 0.4;
//		depth		 = -4;
//		
//		 // Vars:
//		sprite_scale	      = 0.6;
//		sprite_scale_speed	  = 0.3;
//		sprite_scale_friction = 0.03;
//		radius				  = 5;
//		radius_speed		  = 3;
//		radius_friction 	  = 0.2;
//		angle_speed			  = 0;
//		angle_friction		  = 0.4;
//		
//		return self;
//	}
//	
//#define TesseractWarp_step
//	 // He do be growin' tho:
//	image_angle += angle_speed	  * current_time_scale;
//	angle_speed -= angle_friction * current_time_scale;
//
//	sprite_scale	   += sprite_scale_speed	* current_time_scale;
//	sprite_scale_speed -= sprite_scale_friction * current_time_scale;
//	
//	radius		 += radius_speed	* current_time_scale;
//	radius_speed -= radius_friction * current_time_scale;
//	
//	radius		 = max(radius,		 0);
//	sprite_scale = max(sprite_scale, 0);
//	
//	 // Effects:
//	if(current_frame_active){
//		var	_l = 64,
//			_d = random(360);
//			
//		with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), LaserCharge)){
//			alarm0 = random_range(15, 20);
//			motion_set(_d + 180, random_range(1, 2));
//			sprite_index = sprSpiralStar;
//			direction    = _d + 180;
//			speed        = _l / alarm0;
//		}
//	}
//	if(chance_ct(1, 5)){
//		var	_l = random_range(32, 128),
//			_d = random(360);
//			
//		with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), BulletHit)){
//			sprite_index = sprWepSwap;
//		}
//	}
//	
//	if(sprite_scale <= 0 && radius <= 0){
//		with(instance_create(x, y, BulletHit)){
//			sprite_index = sprThrowHit;
//		}
//		
//		 // Goodbye:
//		instance_destroy();
//	}
//	
//#define TesseractWarp_draw
//	image_alpha = abs(image_alpha);
//	draw_set_fog(true, image_blend, 0, 0);
//	
//	draw_sprite_ext(sprite_index, image_index, x, y, (image_xscale * sprite_scale), (image_yscale * sprite_scale), image_angle, image_blend, image_alpha);
//	draw_ellipse(x - (radius * image_xscale), y - (radius * image_yscale), x + (radius * image_xscale), y + (radius * image_yscale), false);
//	
//	draw_set_fog(false, c_white, 0, 0);
//	image_alpha *= -1;
	
	
#define TwinOrbital_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		sprite_index = spr.PetTwinsRed;
		spr_effect	 = spr.PetTwinsRedEffect;
		image_speed  = 0.4;
		depth        = -3;
		
		 // Vars:
		mask_index = mskFrogEgg;
		maxhealth  = 0;
		parent     = noone;
		white      = false;
		setup	   = true;
		twin	   = noone;
		
		return self;
	}
	
#define TwinOrbital_setup
	setup = false;
	
	if(white){
		sprite_index = spr.PetTwinsWhite;
		spr_effect	 = spr.PetTwinsWhiteEffect;
	}
	if(instance_exists(parent)){
		prompt = parent.prompt;
	}
	
#define TwinOrbital_step
	if(setup) TwinOrbital_setup();
	
	var _player = variable_instance_get(parent, "leader", noone),
		_team	= variable_instance_get(team,	"team",	  0);
	
	
#define VlasmaBullet_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.VlasmaBullet;
		image_speed  = 0.4;
		depth        = -9;
		
		 // Vars:
		mask_index = mskEnemyBullet1;
		damage     = 2;
		force      = 1;
		typ        = 1;
		maxspeed   = 8;
		addspeed   = 0.4;
		target     = noone;
		target_x   = x;
		target_y   = y;
		my_sound   = -1;
		cannon     = 0;
		wall_frame = 0;
		setup      = true;
		
		return self;
	}
	
#define VlasmaBullet_setup
	setup = false;
	
	 // Brain:
	if(instance_is(creator, Player)){
		var _skill = skill_get(mut_laser_brain);
		image_xscale *= power(1.2, _skill);
		image_yscale *= power(1.2, _skill);
		damage       *= power(2,   _skill);
	}
	
#define VlasmaBullet_step
	if(setup) VlasmaBullet_setup();
	
	 // Follow Target:
	if(instance_exists(target)){
		target_x = target.x;
		target_y = target.y;
		
		 // Gun Offset:
		if(target == creator && "gunangle" in creator){
			var	_l = (("spr_weap" in creator) ? (sprite_get_width(target.spr_weap) - sprite_get_xoffset(target.spr_weap)) : 16),
				_d = creator.gunangle;
				
			target_x += lengthdir_x(_l, _d);
			target_y += lengthdir_y(_l, _d);
		}
	}
	
	 // Movement:
	if(image_speed == 0){
		 // Acceleration:
		var	_euphoria = ((instance_exists(creator) ? instance_is(creator, enemy) : (team != 2)) ? power(0.8, skill_get(mut_euphoria)) : 1),
			_speedMax = maxspeed * _euphoria,
			_speedAdd = addspeed * _euphoria * current_time_scale;
			
		speed += clamp(_speedMax - speed, -_speedAdd, _speedAdd);
		
		 // Turn:
		var _turn = angle_difference(point_direction(x, y, target_x, target_y), direction);
		_turn *= clamp(speed / point_distance(x, y, target_x, target_y), 0.1, 1);
		_turn *= min(current_time_scale, 1);
		direction   += _turn;
		image_angle += _turn;
	}
	
	 // Particles:
	if(chance_ct(1, 4)){
		with(team_instance_sprite(
			sprite_get_team(sprite_index),
			scrFX([x, 4], [y, 4], [direction, 2 * (speed / maxspeed)], PlasmaTrail)
		)){
			depth = other.depth;
		}
	}
	
	 // Target Acquired, Sweet Prince:
	if(image_speed == 0){
		if(
			point_distance(x, y, target_x, target_y) <= 8 + speed_raw
			|| (instance_exists(target) && ("team" not in target || team != target.team) && place_meeting(x, y, target))
		){
			instance_destroy();
		}
	}
	
#define VlasmaBullet_draw
	draw_self();
	
	 // Bloom:
	var	_scale = 2,
		_alpha = 0.1;
		
	draw_set_blend_mode(bm_add);
	image_xscale *= _scale;
	image_yscale *= _scale;
	image_alpha  *= _alpha;
	draw_self();
	image_xscale /= _scale;
	image_yscale /= _scale;
	image_alpha  /= _alpha;
	draw_set_blend_mode(bm_normal);
	
#define VlasmaBullet_anim
	if(instance_exists(self)){
		image_index = image_number - 1;
		image_speed = 0;
	}
	
#define VlasmaBullet_hit
	if(image_speed == 0){
		if(
			instance_is(other, Player)
			? projectile_canhit_melee(other)
			: projectile_canhit(other)
		){
			projectile_hit(other, damage, force);
		}
	}
	
#define VlasmaBullet_wall
	 // Pass Through Walls:
	if(
		wall_frame != current_frame
		&& x == xprevious
		&& y == yprevious
	){
		wall_frame = current_frame;
		x += hspeed_raw;
		y += vspeed_raw;
		xprevious = x;
		yprevious = y;
	}
	
#define VlasmaBullet_destroy
	 // Sound:
	sound_stop(my_sound);
	sound_play_hit_ext(sndLaser,        1.1 + random(0.3), 1);
	sound_play_hit_ext(sndLightningHit, 0.9 + random(0.2), 1);
	
	 // Cannon:
	if(cannon > 0){
		var	_num = cannon,
			_ang = direction;
			
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			var _len = 96,
				_x = x + lengthdir_x(_len, _dir),
				_y = y + lengthdir_y(_len, _dir);
				
			with(team_instance_sprite(
				sprite_get_team(sprite_index),
				projectile_create(_x, _y, "VlasmaBullet", _dir + 180, 0)
			)){
				target   = other.target;
				target_x = other.target_x;
				target_y = other.target_y;
			}
		}
		
		 // Sound:
		sound_play_hit_ext(sndPlasmaHit, 0.6 + random(0.2), 4);
	}
	
	 // Explo:
	with(team_instance_sprite(
		sprite_get_team(sprite_index),
		projectile_create(x, y, ((cannon > 0) ? PlasmaImpact : "PlasmaImpactSmall"), 0, 0)
	)){
		depth = other.depth;
	}
	
	
#define VlasmaCannon_create(_x, _y)
	with(obj_create(_x, _y, "VlasmaBullet")){
		 // Visual:
		sprite_index = spr.VlasmaCannon;
		
		 // Vars:
		damage = 4;
		cannon = 6;
		
		return self;	
	}
	
	
#define WallFake_create(_x, _y)
	/*
		Illusory walls
		Drawing done through 'draw_wall_fake' and 'draw_wall_fake_reveal'
	*/
	
	with(instance_create(_x, _y, Wall)){
		 // Visual:
		sprite_index = spr.WallRedFake[irandom(array_length(spr.WallRedFake) - 1)];
		image_index  = 0;
		image_speed  = 0.4 + (0.1 * sin((x / 16) + (y / 16)));
		depth        = 3;
		visible      = true;
		
		 // Collision Helper:
		if(solid){
			solid = false;
			with(instance_create(x, y, CustomObject)){
				name         = "WallFakeHelper";
				creator      = other;
				solid        = true;
				visible      = false;
				sprite_index = other.sprite_index;
				image_xscale = other.image_xscale;
				image_yscale = other.image_yscale;
				image_angle  = other.image_angle;
				mask_index   = other.mask_index;
			}
		}
		
		return self;
	}
	
	
#define Warp_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_idle     = spr.Warp;
		spr_open     = spr.WarpOpen;
		spr_open_out = spr.WarpOpenOut;
		sprite_index = spr_idle;
		image_speed  = 0.4;
		image_angle  = random(360);
		image_alpha  = -1;
		depth        = -9;
		
		 // Vars:
		mask_index = -1;
		open       = false;
		setup      = true;
		area       = "red";
		subarea    = 1;
		loops      = GameCont.loops;
		seed       = GameCont.gameseed[(max(0, GameCont.atseed) + array_length(instances_matching_lt(instances_matching(CustomObject, "name", "Warp"), "id", id))) % array_length(GameCont.gameseed)];
		
		 // Prompt:
		prompt = prompt_create("");
		with(prompt){
			mask_index = mskReviveArea;
			yoff = 8;
		}
		
		 // Determine Area:
		var	_pick   = [],
			_secret = chance(1, 8);
			
		with(array_combine([area_desert, area_sewers, area_scrapyards, area_caves, area_city, area_labs, area_palace, choose(area_mansion, area_crib), area_cursed_caves, area_jungle], ntte_mods.area)){
			var _area = self;
			if(_area != "red"){
				 // Cursed:
				if(_area == area_caves){
					with(Player) if(curse > 0 || bcurse > 0){
						_area = area_cursed_caves;
						break;
					}
				}
				
				 // Add:
				array_push(_pick, _area);
			}
		}
		if(array_length(_pick)){
			area = _pick[irandom(array_length(_pick) - 1)];
			var _warpInst = instances_matching_ne(instances_matching(CustomObject, "name", "Warp"), "id", id);
			with(array_shuffle(_pick)){
				var _area = self;
				if(!area_get_secret(_area) ^ _secret){
					if(!array_length(instances_matching(_warpInst, "area", _area))){
						other.area = _area;
						break;
					}
				}
			}
			subarea = irandom_range(1, area_get_subarea(area));
		}
		
		 // Alarms:
		alarm0 = 30;
		
		return self;
	}
	
#define Warp_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Spin:
	image_angle += current_time_scale;
	
	 // Open / Close:
	var	_sparkle   = 1,
		_openScale = 3,
		_scale     = ((open || sprite_index == (open ? spr_open : spr_idle)) ? 1 : 1 / _openScale);
		
	image_xscale += (_scale - image_xscale) * 0.2 * current_time_scale;
	image_yscale += (_scale - image_yscale) * 0.2 * current_time_scale;
	
	if(max(abs(_scale - image_xscale), abs(_scale - image_yscale)) < 0.1){
		if(sprite_index == (open ? spr_idle : spr_open)){
			sprite_index = (open ? spr_open : spr_idle);
			
			 // Grow / Shrink:
			image_xscale *= (open ? 1 / _openScale : _openScale);
			image_yscale *= (open ? 1 / _openScale : _openScale);
		}
	}
	
	 // Break Walls:
	else{
		if(open && frame_active(2)){
			var _lastArea = GameCont.area;
			GameCont.area = area;
			
			y += 4;
			
			if(place_meeting(x, y, Wall)){
				with(instances_meeting(x, y, Wall)){
					if(place_meeting(x, y, other)){
						instance_create(x, y, FloorExplo);
						instance_destroy();
					}
				}
			}
			else with(instance_nearest_bbox(x + orandom(32), y + orandom(32), Wall)){
				instance_create(x, y, FloorExplo);
				instance_destroy();
			}
			sound_stop(sndWallBreak);
			
			y -= 4;
			
			GameCont.area = _lastArea;
		}
		_sparkle *= 2;
	}
	
	 // Effects:
	if(chance_ct(1, 15 / _sparkle)){
		with(instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), LaserCharge)){
			sprite_index = sprSpiralStar;
			image_index = choose(0, irandom(image_number - 1));
			alarm0 = random_range(15, 30);
			motion_set(90, random_range(0.2, 0.5));
		}
	}
	if(chance_ct(1, 20 / _sparkle)){
		with(instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), BulletHit)){
			sprite_index = sprThrowHit;
			image_xscale = 0.2 + random(0.3);
			image_yscale = image_xscale;
		}
	}
	
	 // No Portals:
	portal_poof();
	
	 // Warp:
	with(prompt){
		visible = other.open;
		if(text == ""){
			text = `WARP#${area_get_name(other.area, other.subarea, other.loops)}`;
		}
	}
	if(instance_exists(prompt) && player_is_active(prompt.pick)){
		instance_destroy();
	}
	
#define Warp_draw
	image_alpha = abs(image_alpha);
	
	 // Area Color:
	var _color = area_get_back_color(area);
	_color = make_color_hsv(
		color_get_hue(_color),
		color_get_saturation(_color),
		lerp(color_get_value(_color), 255, 1/3)
	);
	
	 // Self:
	if(sprite_index = spr_open){
		draw_sprite_ext(spr_open_out, current_frame * image_speed, x, y, image_xscale, image_yscale, image_angle, _color, image_alpha);
	}
	draw_self();
	
	 // Bloom:
	draw_set_blend_mode(bm_add);
	if(sprite_index = spr_open){
		draw_sprite_ext(spr_open_out, current_frame * image_speed, x, y, image_xscale * 1.4, image_yscale * 1.4, image_angle, _color, image_alpha * 0.075);
	}
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, _color, image_alpha * 0.075);
	draw_set_blend_mode(bm_normal);
	
	image_alpha *= -1;
	
#define Warp_alrm0
	alarm0 = 30;
	
	 // Warp Time:
	if(instance_number(enemy) - instance_number(Van) <= 0){
		var _seen = false;
		with(Player){
			if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
				_seen = true;
				break;
			}
		}
		if(_seen){
			open   = true;
			alarm0 = -1;
			var _snd = sound_play_hit_ext(sndHyperCrystalSearch, 0.5 + orandom(0.1), 4);
			if(sound_play_ambient(sndHyperCrystalAppear)){
				sound_pitch(_snd + 1, 0.6);
			}
		}
	}
	
#define Warp_destroy
	if(open){
		 // Close Warps:
		with(instances_matching(object_index, "name", name)){
			open = false;
			alarm0 = -1;
		}
		
		 // Going to a New Dimension:
		with(GameCont){
			var _lastSeed = {};
			with(["mutseed", "junseed", "patseed", "codseed"]){
				var _seed = variable_instance_get(other, self);
				lq_set(_lastSeed, self, (is_array(_seed) ? array_clone(_seed) : _seed));
			}
			game_set_seed(other.seed);
			for(var i = 0; i < lq_size(_lastSeed); i++){
				variable_instance_set(self, lq_get_key(_lastSeed, i), lq_get_value(_lastSeed, i));
			}
		}
		
		 // Warp:
		with(obj_create(x, y, "WarpPortal")){
			area    = other.area;
			subarea = other.subarea;
			loops   = other.loops
		}
	}
	
	 // Blip Out:
	else with(instance_create(x, y, BulletHit)){
		sprite_index = sprThrowHit;
		image_xscale = other.image_xscale;
		image_yscale = other.image_yscale;
		image_angle  = other.image_angle;
	}
	
	
#define WarpPortal_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = sprPortalClear;
		depth        = -9;
		
		 // Vars:
		mask_index   = sprPortalShock;
		image_xscale = 0.6;
		image_yscale = image_xscale;
		area         = "red";
		subarea      = 1;
		loops        = GameCont.loops;
		
		 // Portal:
		portal = instance_create(x, y, BigPortal);
		with(portal){
			x = other.x;
			y = other.y;
			sprite_index = sprBigPortal;
			image_alpha = 0;
		}
		instance_create(x, y, PortalShock);
		
		 // Sound:
		audio_sound_set_track_position(sound_play_pitchvol(sndLastNotifyDeath, 0.6 + random(0.1), 2), 0.4);
		sound_play_music(-1);
		sound_play_ambient(-1);
		
		 // Effects:
		repeat(30){
			var	_l = 32 + random(8),
				_d = random(360);
				
			with(scrFX(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), [_d, 4 + random(2)], Dust)){
				friction = 0.4;
				sprite_index = sprSmoke;
			}
		}
		view_shake_at(x, y, 50);
		sleep(100);
		
		return self;
	}
	
#define WarpPortal_step
	 // Shrink:
	if(!instance_exists(portal) || portal.endgame < 100){
		var _shrinkSpeed = 1/80 * current_time_scale;
		if(image_xscale > 0 && image_yscale > 0){
			image_xscale -= _shrinkSpeed;
			image_yscale -= _shrinkSpeed;
			
			 // Blip Out:
			if(image_xscale <= 0 || image_yscale <= 0){
				image_xscale = 0;
				image_yscale = 0;
				with(instance_create(x, y, BulletHit)){
					sprite_index = sprThrowHit;
				}
			}
		}
	}
	
	 // Destroy Walls:
	if(place_meeting(x, y, Wall)){
		var _lastArea = GameCont.area;
		GameCont.area = area;
		with(instances_meeting(x, y, Wall)){
			if(place_meeting(x, y, other)){
				instance_create(x, y, FloorExplo);
				instance_destroy();
			}
		}
		GameCont.area = _lastArea;
	}
	
	 // Grab Player:
	with(instances_matching(Player, "visible", true)){
		if(place_meeting(x, y, other) || position_meeting(x, y, other)){
			visible = false;
			direction = point_direction(x, y, other.x, other.y);
			
			 // Wacky Effect:
			with(instance_create(x, y, Dust)){
				speed        = max(3, other.speed);
				direction    = other.direction;
				sprite_index = other.spr_hurt;
				image_index  = 1;
				image_xscale = abs(other.image_xscale * other.right);
				image_yscale = abs(other.image_yscale);
				image_angle  = other.sprite_angle + other.angle + orandom(30);
				image_blend  = other.image_blend;
				image_alpha  = other.image_alpha;
				depth        = -10;
				growspeed   *= 2/3;
				
				 // Pink Flash:
				with(instance_create(x , y, ThrowHit)){
					motion_add(other.direction, 1);
					image_speed = 0.5;
					image_blend = make_color_rgb(255, 0, 80);
					depth       = other.depth - 1;
				}
			}
		}
	}
	
	 // Effects:
	if(current_frame_active){
		var	_l = 64,
			_d = random(360);
			
		with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), LaserCharge)){
			alarm0 = random_range(15, 20);
			motion_set(_d + 180, random_range(1, 2));
			sprite_index = sprSpiralStar;
			direction    = _d + 180;
			speed        = _l / alarm0;
		}
	}
	if(chance_ct(1, 5)){
		var	_l = random_range(32, 128),
			_d = random(360);
			
		with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), BulletHit)){
			sprite_index = sprWepSwap;
		}
	}
	
	 // Warpin Help:
	with(portal) if(anim_end){
		if(array_find_index(instance_is(self, BigPortal) ? [sprBigPortalDisappear] : [sprPortalDisappear, sprProtoPortalDisappear, sprPopoPortalDisappear], sprite_index) >= 0){
			area_set("red", 0, GameCont.loops);
			with(self){
				event_perform(ev_other, ev_animation_end);
			}
		}
	}
	
#define WarpPortal_draw
	var	_ext = random(3),
		_xsc = image_xscale + (_ext / sprite_get_width(sprite_index)),
		_ysc = image_yscale + (_ext / sprite_get_height(sprite_index));
		
	draw_sprite_ext(sprite_index, image_index, x, y, _xsc, _ysc, image_angle, image_blend, abs(image_alpha));
	
	 // CustomObject:
	image_alpha = -abs(image_alpha);
	
	
/// GENERAL
#define ntte_update(_newID)
	 // Spider Cocoons:
	if(instance_exists(Cocoon) && Cocoon.id > _newID){
		with(instances_matching_gt(Cocoon, "id", _newID)){
			obj_create(x, y, "NewCocoon");
			instance_delete(self);
		}
	}
	
	 // Scramble Cursed Caves Weapons:
	if(GameCont.area == area_cursed_caves){
		if(instance_exists(WepPickup) && WepPickup.id > _newID){
			with(instances_matching_gt(WepPickup, "id", _newID)){
				if(roll && wep_raw(wep) != "merge"){
					if(chance(1, 3) || !position_meeting(xstart, ystart, ChestOpen)){
						 // Curse:
						curse = max(1, curse);
						
						 // Scramble:
						var _part = wep_merge_decide(0, GameCont.hard + (2 * curse));
						if(array_length(_part) >= 2){
							wep = wep_merge(_part[0], _part[1]);
						}
					}
				}
			}
		}
	}
	
#define ntte_end_step
	 // Fake Walls:
	var _visible = false;
	with(surfWallFakeMaskBot){
		if(
			(instance_number(Wall) != wall_num) ||
			(instance_exists(Wall) && wall_min < Wall.id)
		){
			reset = true;
			surfWallFakeMaskTop.reset = true;
			
			 // Update Vars:
			wall_num  = instance_number(Wall);
			wall_min  = instance_max;
			wall_inst = instances_matching(Wall, "name", "WallFake");
			
			 // Update Fake Walls:
			with(instances_matching(CustomObject, "name", "WallFakeHelper")){
				if(!instance_exists(creator)){
					instance_destroy();
				}
			}
		}
		
		 // Walls Active:
		if(array_length(wall_inst)){
			 // Visual Fix:
			var _inst = instances_matching(wall_inst, "visible", false);
			if(array_length(_inst)) with(_inst){
				visible = true;
			}
			
			 // Fake Wall Collision:
			var _inst = instances_matching(CustomObject, "name", "WallFakeHelper");
			if(array_length(_inst)){
				var _instMeet = [];
				
				 // Gather Dudes in Fake Walls:
				with(hitme){
					if(place_meeting(x, y, CustomObject) && array_length(instances_meeting(x, y, _inst))){
						array_push(_instMeet, self);
					}
				}
				
				 // Disable Collision When Near Dude in a Fake Wall:
				if(array_length(_instMeet)){
					with(_inst){
						var _solid = true;
						if(distance_to_object(hitme) <= 32){
							with(_instMeet){
								if(distance_to_object(other) <= 32){
									_solid = false;
									break;
								}
							}
						}
						if(solid != _solid){
							solid = _solid;
							if(instance_exists(creator)){
								creator.mask_index = (solid ? mask_index : mskNone);
							}
							else instance_destroy();
						}
					}
				}
				
				 // Enable Collision:
				else{
					_inst = instances_matching_ne(_inst, "solid", true);
					if(array_length(_inst)) with(_inst){
						solid = true;
						if(instance_exists(creator)){
							creator.mask_index = (solid ? mask_index : mskNone);
						}
						else instance_destroy();
					}
				}
			}
			
			 // Player Reveal Circles:
			with(Player){
				var _grow = (array_find_index(_instMeet, self) >= 0);
				if("red_wall_fake" not in self){
					red_wall_fake = 0;
				}
				if(red_wall_fake > 0 || _grow){
					red_wall_fake = clamp(red_wall_fake + ((_grow ? 0.1 : -0.1) * current_time_scale), 0, 1);
					_visible = true;
				}
			}
		}
		
		 // Reset Player Circles:
		else if(instance_exists(Player)){
			var _inst = instances_matching_gt(Player, "red_wall_fake", 0);
			if(array_length(_inst)) with(_inst){
				red_wall_fake = 0;
			}
		}
	}
	with(global.wall_fake_bind){
		if(instance_exists(id)){
			id.visible = _visible;
		}
	}
	with(global.wall_fake_bind_reveal){
		if(instance_exists(id)){
			id.visible = _visible;
		}
	}
	
	 // Wall Shine:
	var _visible = false;
	with(surfWallShineMask){
		if(
			(instance_number(Wall) != wall_num) ||
			(instance_exists(Wall) && wall_min < Wall.id)
		){
			reset = true;
			
			 // Update Vars:
			wall_num  = instance_number(Wall);
			wall_min  = instance_max;
			wall_inst = instances_matching(Wall,     "topspr",       spr.WallRedTop, spr.WallRedTrans);
			tops_inst = instances_matching(TopSmall, "sprite_index", spr.WallRedTop, spr.WallRedTrans);
		}
		
		 // Time to Shine:
		if(array_length(wall_inst) || array_length(tops_inst)){
			_visible = true;
			
			 // Crystal Tunnel Particles:
			if(GameCont.area != "red" && chance_ct(1, 40)){
				mod_script_call_nc("area", "red", "area_effect");
			}
		}
	}
	with(global.wall_shine_bind.id){
		visible = _visible;
	}
	
	/*
	 // Client-Side Darkness:
	clientDarknessFloor = instances_matching_ne(clientDarknessFloor, "id", null);
	with(Player){
		if(array_length(clientDarknessFloor) > 0){
			var _num = clientDarknessCoeff[index],
				_spd = current_time_scale / 5,
				_inDark = false;
				
			with(instances_meeting(x, y, clientDarknessFloor)){
				_inDark = true;
				break;
			}
			
			if(_inDark){
				_num -= _spd;
			}
			else{
				_num += _spd;
			}
			
			clientDarknessCoeff[index] = clamp(_num, 0, 1);
		}
		else{
			clientDarknessCoeff[index] = 1;
		}
	}
	*/
	
#define ntte_draw_shadows
	 // Mortar Plasma:
	if(instance_exists(CustomProjectile)){
		var _inst = instances_matching(instances_matching(CustomProjectile, "name", "MortarPlasma"), "visible", true);
		if(array_length(_inst)) with(_inst){
			if(position_meeting(x, y, Floor)){
				var	_percent = clamp(96 / z, 0.1, 1),
					_w = ceil(18 * _percent),
					_h = ceil(6 * _percent),
					_x = x,
					_y = y;
					
				draw_ellipse(_x - (_w / 2), _y - (_h / 2), _x + (_w / 2), _y + (_h / 2), false);
			}
		}
	}
	
	 // Crystal Brain Death:
	if(instance_exists(CustomObject)){
		var _inst = instances_matching(instances_matching(CustomObject, "name", "CrystalBrainDeath"), "visible", true);
		if(array_length(_inst)) with(_inst){
			draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
		}
	}
	
	 // Tesseract:
	if(instance_exists(CustomObject) || instance_exists(CustomEnemy)){
		var _inst = array_combine(
			(instance_exists(CustomEnemy)  ? instances_matching(CustomEnemy,  "name", "Tesseract")      : []),
			(instance_exists(CustomObject) ? instances_matching(CustomObject, "name", "TesseractDeath") : [])
		);
		if(array_length(_inst)){
			_inst = instances_matching(instances_matching(_inst, "visible", true), "spr_shadow", mskNone);
			if(array_length(_inst)) with(_inst){
				var	_scale = 0.9,
					_offX  = spr_shadow_x,
					_offY  = spr_shadow_y;
					
				image_xscale *= _scale;
				image_yscale *= _scale;
				x += _offX;
				y += _offY;
				
				with(self) event_perform(ev_draw, 0);
				
				image_xscale /= _scale;
				image_yscale /= _scale;
				x -= _offX;
				y -= _offY;
			}
		}
	}
	
#define ntte_draw_bloom
	if(instance_exists(CustomObject)){
		 // Warp Portals:
		var _inst = instances_matching(CustomObject, "name", /*"TesseractStrike", "TesseractWarp",*/ "WarpPortal");
		if(array_length(_inst)) with(_inst){
			var	_scale = 2,
				_alpha = 0.1;
				
			image_xscale *= _scale;
			image_yscale *= _scale;
			image_alpha  *= _alpha;
			event_perform(ev_draw, 0);
			image_xscale /= _scale;
			image_yscale /= _scale;
			image_alpha  /= _alpha;
		}
		
		 // Tesseract Death:
		var _inst = instances_matching(CustomObject, "name", "TesseractDeath");
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(sprite_index, 0.4 * current_frame, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, (image_alpha * 0.2) / max(1, 1 + throes));
		}
	}
	
	 // Projectiles:
	if(instance_exists(projectile)){
		if(instance_exists(CustomProjectile)){
			 // Crystal Heart Projectiles:
			var _inst = instances_matching(CustomProjectile, "name", "CrystalHeartBullet");
			if(array_length(_inst)) with(_inst){
				var	_scale = 2,
					_alpha = 0.1;
					
				 // Copy pasting code is truly so epic:
				image_xscale *= _scale;
				image_yscale *= _scale;
				image_alpha  *= _alpha;
				event_perform(ev_draw, 0);
				image_xscale /= _scale;
				image_yscale /= _scale;
				image_alpha  /= _alpha;
			}
			
			 // Red Slashes:
			if(instance_exists(CustomSlash)){
				var _inst = instances_matching(CustomSlash, "name", "RedSlash");
				if(array_length(_inst)) with(_inst){
					draw_sprite_ext(sprite_index, image_index, x, y, 1.2 * image_xscale, 1.2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
				}
			}
		}
		
		 // Red Shanks:
		if(instance_exists(Shank)){
			var _inst = instances_matching(Shank, "name", "RedShank");
			if(array_length(_inst)) with(_inst){
				draw_sprite_ext(sprite_index, image_index, x, y, 1.2 * image_xscale, 1.2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
			}
		}
	}
	
#define ntte_draw_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
			
			var _gray = (_type == "normal");
			
			 // Enemies:
			if(instance_exists(enemy)){
				if(instance_exists(CustomEnemy)){
					 // Mortar:
					var _inst = instances_matching(CustomEnemy, "name", "Mortar", "InvMortar");
					if(array_length(_inst)) with(_inst){
						if(sprite_index == spr_fire){
							draw_circle(x + (6 * right), y - 16, abs(24 - alarm1 + orandom(4)) + (24 * _gray), false);
						}
					}
					
					 // Crystal Heart:
					var _inst = instances_matching(CustomEnemy, "name", "CrystalHeart", "ChaosHeart");
					if(array_length(_inst)){
						var	_ver = 15 + (30 * _gray),
							_rad = 24 + (48 * _gray),
							_coe = 2  + (1  * _gray);
							
						with(_inst){
							draw_crystal_heart_dark(_ver, _rad + random(2), _coe);
						}
					}
					
					 // Tesseract:
					var _inst = instances_matching(CustomEnemy, "name", "Tesseract");
					if(array_length(_inst)) with(_inst){
						draw_circle(x, y, 64 + (128 * _gray) + random(2), false);
					}
					
					/*
					 // Crystal Bat:
					var _inst = instances_matching(CustomEnemy, "name", "CrystalBat", "InvCrystalBat");
					if(array_length(_inst)) with(_inst){
						draw_circle(x, y, 16 + (20 * _gray) + random(2), false);
					}
					*/
				}
				
				 // Miner Bandit:
				if(instance_exists(Bandit)){
					var _inst = instances_matching(Bandit, "name", "MinerBandit");
					if(array_length(_inst)){
						var	_lightDis  = 60 + (60 * _gray),
							_lightAng  = 15 + (5  * _gray),
							_circleDis = 6  + (3  * _gray),
							_circleRad = 12 + (12 * _gray);
							
						with(_inst){
							 // Light Beam:
							if(light_visible == true){
								var _off = _lightAng + orandom(1),
									_x2  = x + lengthdir_x(_lightDis, light_angle + _off),
									_y2  = y + lengthdir_y(_lightDis, light_angle + _off),
									_x3  = x + lengthdir_x(_lightDis, light_angle - _off),
									_y3  = y + lengthdir_y(_lightDis, light_angle - _off);
									
								draw_triangle(x, y, _x2, _y2, _x3, _y3, false);
								draw_circle(
									x + lengthdir_x(_lightDis, light_angle), 
									y + lengthdir_y(_lightDis, light_angle), 
									point_distance(_x2, _y2, _x3, _y3) / 2, 
									false
								);
							}
							
							 // Helmet Glow:
							draw_circle(
								x + lengthdir_x(_circleDis, light_angle), 
								y + lengthdir_y(_circleDis, light_angle), 
								_circleRad + orandom(1), 
								false
							);
						}
					}
				}
			}
			
			 // Mortar Plasma:
			if(instance_exists(CustomProjectile)){
				var _inst = instances_matching(CustomProjectile, "name", "MortarPlasma");
				if(array_length(_inst)){
					var _r = 32 + (32 * _gray);
					with(_inst){
						draw_circle(x, y - z, _r + orandom(1), false);
					}
				}
			}
			
			 // Big Crystal Prop:
			if(instance_exists(CrystalProp)){
				var _inst = instances_matching(CrystalProp, "name", "BigCrystalProp");
				if(array_length(_inst)){
					var _r = 30 + (60 * _gray) + (1 + sin(current_frame / 80));
					with(_inst){
						draw_circle(x, y, _r, false);
					}
				}
			}
			
			/*
			 // Client-Side Darkness:
			if(_type == "end" && array_length(clientDarknessFloor) > 0){
				var _local = player_find_local_nonsync();
				if(_local >= 0 && _local < array_length(clientDarknessCoeff)){
					var	_alp = draw_get_alpha(),
						_vx  = view_xview_nonsync,
						_vy  = view_yview_nonsync;
						
					draw_set_alpha(clientDarknessCoeff[_local]);
					draw_rectangle(_vx, _vy, _vx + game_width, _vy + game_height, false);
					draw_set_alpha(_alp);
				}
			}
			*/
			
			break;
			
	}
	
#define draw_crystal_heart_dark(_vertices, _radius, _coefficient)
	draw_primitive_begin(pr_trianglefan);
	draw_vertex(x, y);
	
	for(var i = 0; i <= _vertices + 1; i++){
		var	_x = x + lengthdir_x(_radius, (360 / _vertices) * i),
			_y = y + lengthdir_y(_radius, (360 / _vertices) * i);
			
		_x += sin(_x * 0.1) * _coefficient;
		_y += sin(_y * 0.1) * _coefficient;
		draw_vertex(_x, _y);
	}
	
	draw_primitive_end();
	
#define draw_wall_shine
	if(lag) trace_time();
	
	var	_vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_gw = game_width,
		_gh = game_height,
		_surfScale = option_get("quality:minor");
		
	 // Wall Shine Mask:
	with(surface_setup("RedWallShineMask", _gw * 2, _gh * 2, _surfScale)){
		var	_surfX = pfloor(_vx, _gw),
			_surfY = pfloor(_vy, _gh);
			
		if(reset || x != _surfX || y != _surfY){
			reset = false;
			x = _surfX;
			y = _surfY;
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
				
				 // Background:
				if(background_color == area_get_back_color("red")){
					draw_clear(background_color);
					
					 // Cut Out Floors & Walls:
					draw_set_blend_mode_ext(bm_inv_src_alpha, bm_inv_src_alpha);
					with(instance_rectangle_bbox(x, y, x + w, y + h, Floor)){
						draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
					}
					with(instance_rectangle_bbox(x, y, x + w, y + h, Wall)){
						if(image_speed == 0){
							draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
						}
						else for(var i = 0; i < image_number; i++){
							draw_sprite_ext(sprite_index, i, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
						}
						draw_sprite_ext(topspr, topindex, (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, _surfScale, _surfScale, 0, image_blend, image_alpha);
					}
					with(instance_rectangle_bbox(x, y, x + w, y + h, TopSmall)){
						draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, image_alpha);
					}
					draw_set_blend_mode(bm_normal);
				}
				
				 // Red Crystal Wall Tops:
				wall_inst = instances_matching_ne(wall_inst, "id", null);
				tops_inst = instances_matching_ne(tops_inst, "id", null);
				with(wall_inst) draw_sprite_ext(topspr,       topindex,    (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, (solid ? image_alpha : (image_alpha * 0.9)));
				with(tops_inst) draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, image_alpha);
				
			surface_reset_target();
		}
	}
	
	 // Wall Shine:
	with(surface_setup("RedWallShine", _gw, _gh, _surfScale)){
		x = _vx;
		y = _vy;
		
		if("wave" not in self) wave = 0;
		wave += current_time_scale * random_range(1, 2);
		
		var	_surfX         = x,
			_surfY         = y,
			_shineAng      = 45,
			_shineSpeed    = 10,
			_shineWidth    = (30 + orandom(2)) * _surfScale,
			_shineInterval = 240, // 4-8 Seconds ('wave' adds 1~2)
			_shineDisMax   = sqrt(2 * sqr(max(_gw, _gh))),
			_shineDis      = (_shineSpeed * wave) % (_shineDisMax + (_shineInterval * _shineSpeed)),
			_shineX        = (_vx - _surfX       + lengthdir_x(_shineDis, _shineAng)) * _surfScale,
			_shineY        = (_vy - _surfY + _gh + lengthdir_y(_shineDis, _shineAng)) * _surfScale,
			_shineXOff     = lengthdir_x(_shineDisMax, _shineAng + 90) * _surfScale,
			_shineYOff     = lengthdir_y(_shineDisMax, _shineAng + 90) * _surfScale;
			
		if(_shineDis < _shineDisMax){
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
				
				 // Mask:
				draw_set_fog(true, c_black, 0, 0);
				with(surfWallShineMask){
					draw_surface_scale(
						surf,
						(x - _surfX) * _surfScale,
						(y - _surfY) * _surfScale,
						_surfScale / scale
					);
				}
				/*with(other){
					if(instance_exists(CustomEnemy)){
						var _inst = instances_matching(instances_matching(CustomEnemy, "name", "RedSpider"), "visible", true);
						if(array_length(_inst)) with(_inst){
							x -= _surfX;
							y -= _surfY;
							image_xscale *= _surfScale;
							image_yscale *= _surfScale;
							event_perform(ev_draw, 0);
							x += _surfX;
							y += _surfY;
							image_xscale /= _surfScale;
							image_yscale /= _surfScale;
						}
					}
					if(instance_exists(CrystalProp)){
						var _inst = instances_matching(instances_matching(CrystalProp, "name", "CrystalPropRed"), "visible", true);
						if(array_length(_inst)) with(_inst){
							draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
						}
					}
				}*/
				draw_set_fog(false, 0, 0, 0);
				
				 // Shine:
				draw_set_color(c_white);
				draw_set_color_write_enable(true, true, true, false);
				draw_line_width(_shineX + _shineXOff, _shineY + _shineYOff, _shineX - _shineXOff, _shineY - _shineYOff, _shineWidth);
				draw_set_color_write_enable(true, true, true, true);
				
			surface_reset_target();
			
			 // Ship 'em Out:
			draw_set_alpha(0.1);
			draw_set_blend_mode_ext(bm_src_alpha, bm_one);
			draw_surface_scale(surf, x, y, 1 / scale);
			draw_set_blend_mode(bm_normal);
			draw_set_alpha(1);
		}
	}
	
	if(lag) trace_time(script[2]);
	
#define draw_wall_fake(_type)
	if(lag) trace_time();
	
	var	_vx        = view_xview_nonsync,
		_vy        = view_yview_nonsync,
		_gw        = game_width,
		_gh        = game_height,
		_surfScale = option_get("quality:minor"),
		_surfMask  = surface_setup("RedWallFakeMask" + _type, _gw * 2, _gh * 2, _surfScale);
		
	 // Fake Wall Mask:
	with(_surfMask){
		var	_surfX = pfloor(_vx, _gw),
			_surfY = pfloor(_vy, _gh);
			
		if(reset || x != _surfX || y != _surfY){
			reset = false;
			x = _surfX;
			y = _surfY;
			
			surfWallFakeMaskBot.wall_inst = instances_matching_ne(surfWallFakeMaskBot.wall_inst, "id", null);
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			
			switch(_type){
				
				case "Bot":
					
					 // Fake Walls:
					with(surfWallFakeMaskBot.wall_inst){
						if(image_speed == 0){
							draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
						}
						else for(var i = 0; i < image_number; i++){
							draw_sprite_ext(sprite_index, i, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
						}
					}
					
					break;
					
				case "Top":
					
					 // Fake Walls:
					with(surfWallFakeMaskBot.wall_inst){
						draw_sprite_ext(topspr, topindex, (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, _surfScale, _surfScale, 0, image_blend, image_alpha);
						//draw_sprite_part_ext(outspr, outindex, l, r, w, h, (x - 4 + l - _surfX) * _surfScale, (y - 12 + r - _surfY) * _surfScale, _surfScale, _surfScale, image_blend, image_alpha);
					}
					
					 // Cut Out Normal Walls:
					draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
					with(instances_matching_ne(Wall, "name", "WallFake")){
						draw_sprite_ext(topspr, topindex, (x - _surfX) * _surfScale, (y - 8 - _surfY) * _surfScale, _surfScale, _surfScale, 0, image_blend, image_alpha);
						draw_sprite_part_ext(outspr, outindex, l, r, w, h, (x - 4 + l - _surfX) * _surfScale, (y - 12 + r - _surfY) * _surfScale, _surfScale, _surfScale, image_blend, image_alpha);
					}
					draw_set_blend_mode(bm_normal);
					
					break;
					
			}
			
			surface_reset_target();
		}
	}
	
	 // Fake Wall Reveal Circle:
	with(surface_setup("RedWallFake", _gw, _gh, _surfScale)){
		x = _vx;
		y = _vy;
		
		surface_set_target(surf);
		draw_clear_alpha(c_black, 0);
		
		 // Circles:
		var _inst = instances_matching_gt(Player, "red_wall_fake", 0);
		if(array_length(_inst)) with(_inst){
			draw_circle(
				(x - other.x) * other.scale,
				(y - other.y + ((_type == "Top") ? -4 : 4)) * other.scale,
				(32 + sin(current_frame / 10)) * lerp(0.2, red_wall_fake, red_wall_fake) * other.scale,
				false
			);
		}
		
		 // Cut Mask out of Circles:
		draw_set_blend_mode_ext(bm_zero, bm_src_alpha);
		with(_surfMask){
			draw_surface_scale(
				surf,
				(x - other.x) * other.scale,
				(y - other.y) * other.scale,
				other.scale / scale
			);
		}
		
		 // Stamp Screen Onto Mask:
		draw_set_blend_mode_ext(bm_one, bm_zero);
		draw_set_color_write_enable(true, true, true, false);
		surface_screenshot(surf);
		draw_set_color_write_enable(true, true, true, true);
		draw_set_blend_mode(bm_normal);
		
		surface_reset_target();
	}
	
	if(lag) trace_time(script[2] + " " + _type);
	
#define draw_wall_fake_reveal
	if(lag) trace_time();
	
	 // Draw Fake Wall Reveal Circle:
	with(surface_setup("RedWallFake", null, null, null)){
		 // Outline:
		draw_set_fog(true, make_color_rgb(192, 0, 55), 0, 0);
		draw_surface_scale(surf, x - 1, y, 1 / scale);
		draw_surface_scale(surf, x + 1, y, 1 / scale);
		draw_set_fog(true, make_color_rgb(145, 0, 43), 0, 0);
		draw_surface_scale(surf, x, y - 1, 1 / scale);
		draw_surface_scale(surf, x, y + 1, 1 / scale);
		draw_set_fog(false, 0, 0, 0);
		
		 // Normal:
		draw_surface_scale(surf, x, y, 1 / scale);
	}
	
	if(lag) trace_time(script[2]);
	
	
/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  area_campfire                                                                           0
#macro  area_desert                                                                             1
#macro  area_sewers                                                                             2
#macro  area_scrapyards                                                                         3
#macro  area_caves                                                                              4
#macro  area_city                                                                               5
#macro  area_labs                                                                               6
#macro  area_palace                                                                             7
#macro  area_vault                                                                              100
#macro  area_oasis                                                                              101
#macro  area_pizza_sewers                                                                       102
#macro  area_mansion                                                                            103
#macro  area_cursed_caves                                                                       104
#macro  area_jungle                                                                             105
#macro  area_hq                                                                                 106
#macro  area_crib                                                                               107
#macro  infinity                                                                                1/0
#macro  instance_max                                                                            instance_create(0, 0, DramaCamera)
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro  enemy_boss                                                                              ('boss' in self) ? boss : ('intro' in self || array_find_index([Nothing, Nothing2, BigFish, OasisBoss], object_index) >= 0)
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  target_visible                                                                          !collision_line(x, y, target.x, target.y, Wall, false, false)
#macro  target_direction                                                                        point_direction(x, y, target.x, target.y)
#macro  target_distance                                                                         point_distance(x, y, target.x, target.y)
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#macro  alarm0_run                                                                              alarm0 && !--alarm0 && !--alarm0 && (script_ref_call(on_alrm0) || !instance_exists(self))
#macro  alarm1_run                                                                              alarm1 && !--alarm1 && !--alarm1 && (script_ref_call(on_alrm1) || !instance_exists(self))
#macro  alarm2_run                                                                              alarm2 && !--alarm2 && !--alarm2 && (script_ref_call(on_alrm2) || !instance_exists(self))
#macro  alarm3_run                                                                              alarm3 && !--alarm3 && !--alarm3 && (script_ref_call(on_alrm3) || !instance_exists(self))
#macro  alarm4_run                                                                              alarm4 && !--alarm4 && !--alarm4 && (script_ref_call(on_alrm4) || !instance_exists(self))
#macro  alarm5_run                                                                              alarm5 && !--alarm5 && !--alarm5 && (script_ref_call(on_alrm5) || !instance_exists(self))
#macro  alarm6_run                                                                              alarm6 && !--alarm6 && !--alarm6 && (script_ref_call(on_alrm6) || !instance_exists(self))
#macro  alarm7_run                                                                              alarm7 && !--alarm7 && !--alarm7 && (script_ref_call(on_alrm7) || !instance_exists(self))
#macro  alarm8_run                                                                              alarm8 && !--alarm8 && !--alarm8 && (script_ref_call(on_alrm8) || !instance_exists(self))
#macro  alarm9_run                                                                              alarm9 && !--alarm9 && !--alarm9 && (script_ref_call(on_alrm9) || !instance_exists(self))
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < _numer * current_time_scale;
#define pround(_num, _precision)                                                        return  (_num == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_num == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_num == 0) ? _num :  ceil(_num / _precision) * _precision;
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define lerp_ct(_val1, _val2, _amount)                                                  return  lerp(_val2, _val1, power(1 - _amount, current_time_scale));
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define angle_lerp_ct(_ang1, _ang2, _num)                                               return  _ang2 + (angle_difference(_ang1, _ang2) * power(1 - _num, current_time_scale));
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_dir, _num)                                                                  direction = _dir; walk = _num; if(speed < friction_raw) speed = friction_raw;
#define enemy_face(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1;
#define enemy_look(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1; if('gunangle' in self) gunangle = _dir;
#define enemy_target(_x, _y)                                                                    target = (instance_exists(Player) ? instance_nearest(_x, _y, Player) : ((instance_exists(target) && target >= 0) ? target : noone)); return (target != noone);
#define save_get(_name, _default)                                                       return  mod_script_call_nc  ('mod', 'teassets', 'save_get', _name, _default);
#define save_set(_name, _value)                                                                 mod_script_call_nc  ('mod', 'teassets', 'save_set', _name, _value);
#define option_get(_name)                                                               return  mod_script_call_nc  ('mod', 'teassets', 'option_get', _name);
#define option_set(_name, _value)                                                               mod_script_call_nc  ('mod', 'teassets', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc  ('mod', 'teassets', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc  ('mod', 'teassets', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc  ('mod', 'teassets', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                       return  mod_script_call_nc  ('mod', 'teassets', 'unlock_set', _name, _value);
#define surface_setup(_name, _w, _h, _scale)                                            return  mod_script_call_nc  ('mod', 'teassets', 'surface_setup', _name, _w, _h, _scale);
#define shader_setup(_name, _texture, _args)                                            return  mod_script_call_nc  ('mod', 'teassets', 'shader_setup', _name, _texture, _args);
#define shader_add(_name, _vertex, _fragment)                                           return  mod_script_call_nc  ('mod', 'teassets', 'shader_add', _name, _vertex, _fragment);
#define script_bind(_scriptObj, _scriptRef, _depth, _visible)                           return  mod_script_call_nc  ('mod', 'teassets', 'script_bind', script_ref_create(script_bind), _scriptObj, (is_real(_scriptRef) ? script_ref_create(_scriptRef) : _scriptRef), _depth, _visible);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc  ('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define projectile_create(_x, _y, _obj, _dir, _spd)                                     return  mod_script_call_self('mod', 'telib', 'projectile_create', _x, _y, _obj, _dir, _spd);
#define chest_create(_x, _y, _obj, _levelStart)                                         return  mod_script_call_nc  ('mod', 'telib', 'chest_create', _x, _y, _obj, _levelStart);
#define prompt_create(_text)                                                            return  mod_script_call_self('mod', 'telib', 'prompt_create', _text);
#define alert_create(_inst, _sprite)                                                    return  mod_script_call_self('mod', 'telib', 'alert_create', _inst, _sprite);
#define door_create(_x, _y, _dir)                                                       return  mod_script_call_nc  ('mod', 'telib', 'door_create', _x, _y, _dir);
#define trace_error(_error)                                                                     mod_script_call_nc  ('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc  ('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc  ('mod', 'telib', 'sleep_max', _milliseconds);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call_self('mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc  ('mod', 'telib', 'instance_random', _obj);
#define instance_clone()                                                                return  mod_script_call_self('mod', 'telib', 'instance_clone');
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc  ('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_nearest_bbox(_x, _y, _inst)                                            return  mod_script_call_nc  ('mod', 'telib', 'instance_nearest_bbox', _x, _y, _inst);
#define instance_nearest_rectangle(_x1, _y1, _x2, _y2, _inst)                           return  mod_script_call_nc  ('mod', 'telib', 'instance_nearest_rectangle', _x1, _y1, _x2, _y2, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc  ('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc  ('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc  ('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen(_obj, _bx, _by, _index)                                          return  mod_script_call_nc  ('mod', 'telib', 'instances_seen', _obj, _bx, _by, _index);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc  ('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call_self('mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define instance_get_name(_inst)                                                        return  mod_script_call_nc  ('mod', 'telib', 'instance_get_name', _inst);
#define variable_instance_get_list(_inst)                                               return  mod_script_call_nc  ('mod', 'telib', 'variable_instance_get_list', _inst);
#define variable_instance_set_list(_inst, _list)                                                mod_script_call_nc  ('mod', 'telib', 'variable_instance_set_list', _inst, _list);
#define draw_weapon(_spr, _img, _x, _y, _ang, _angMelee, _kick, _flip, _blend, _alpha)          mod_script_call_nc  ('mod', 'telib', 'draw_weapon', _spr, _img, _x, _y, _ang, _angMelee, _kick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc  ('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_surface_scale(_surf, _x, _y, _scale)                                               mod_script_call_nc  ('mod', 'telib', 'draw_surface_scale', _surf, _x, _y, _scale);
#define array_count(_array, _value)                                                     return  mod_script_call_nc  ('mod', 'telib', 'array_count', _array, _value);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc  ('mod', 'telib', 'array_combine', _array1, _array2);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc  ('mod', 'telib', 'array_delete', _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc  ('mod', 'telib', 'array_delete_value', _array, _value);
#define array_flip(_array)                                                              return  mod_script_call_nc  ('mod', 'telib', 'array_flip', _array);
#define array_shuffle(_array)                                                           return  mod_script_call_nc  ('mod', 'telib', 'array_shuffle', _array);
#define data_clone(_value, _depth)                                                      return  mod_script_call_nc  ('mod', 'telib', 'data_clone', _value, _depth);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc  ('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define enemy_hurt(_damage, _force, _direction)                                                 mod_script_call_self('mod', 'telib', 'enemy_hurt', _damage, _force, _direction);
#define boss_hp(_hp)                                                                    return  mod_script_call_nc  ('mod', 'telib', 'boss_hp', _hp);
#define boss_intro(_name)                                                               return  mod_script_call_nc  ('mod', 'telib', 'boss_intro', _name);
#define corpse_drop(_dir, _spd)                                                         return  mod_script_call_self('mod', 'telib', 'corpse_drop', _dir, _spd);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc  ('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc  ('mod', 'telib', 'rad_path', _inst, _target);
#define area_set(_area, _subarea, _loops)                                               return  mod_script_call_nc  ('mod', 'telib', 'area_set', _area, _subarea, _loops);
#define area_get_name(_area, _subarea, _loops)                                          return  mod_script_call_nc  ('mod', 'telib', 'area_get_name', _area, _subarea, _loops);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call     ('mod', 'telib', 'area_get_sprite', _area, _spr);
#define area_get_subarea(_area)                                                         return  mod_script_call_nc  ('mod', 'telib', 'area_get_subarea', _area);
#define area_get_secret(_area)                                                          return  mod_script_call_nc  ('mod', 'telib', 'area_get_secret', _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc  ('mod', 'telib', 'area_get_underwater', _area);
#define area_get_back_color(_area)                                                      return  mod_script_call_nc  ('mod', 'telib', 'area_get_back_color', _area);
#define area_generate(_area, _sub, _loops, _x, _y, _setArea, _overlapFloor, _scrSetup)  return  mod_script_call_nc  ('mod', 'telib', 'area_generate', _area, _sub, _loops, _x, _y, _setArea, _overlapFloor, _scrSetup);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc  ('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc  ('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_set_align(_alignX, _alignY, _alignW, _alignH)                             return  mod_script_call_nc  ('mod', 'telib', 'floor_set_align', _alignX, _alignY, _alignW, _alignH);
#define floor_reset_style()                                                             return  mod_script_call_nc  ('mod', 'telib', 'floor_reset_style');
#define floor_reset_align()                                                             return  mod_script_call_nc  ('mod', 'telib', 'floor_reset_align');
#define floor_fill(_x, _y, _w, _h, _type)                                               return  mod_script_call_nc  ('mod', 'telib', 'floor_fill', _x, _y, _w, _h, _type);
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)                      return  mod_script_call_nc  ('mod', 'telib', 'floor_room_start', _spawnX, _spawnY, _spawnDis, _spawnFloor);
#define floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)         return  mod_script_call_nc  ('mod', 'telib', 'floor_room_create', _x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis);
#define floor_room(_spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis) return  mod_script_call_nc  ('mod', 'telib', 'floor_room', _spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis);
#define floor_reveal(_x1, _y1, _x2, _y2, _time)                                         return  mod_script_call_nc  ('mod', 'telib', 'floor_reveal', _x1, _y1, _x2, _y2, _time);
#define floor_tunnel(_x1, _y1, _x2, _y2)                                                return  mod_script_call_nc  ('mod', 'telib', 'floor_tunnel', _x1, _y1, _x2, _y2);
#define floor_bones(_num, _chance, _linked)                                             return  mod_script_call_self('mod', 'telib', 'floor_bones', _num, _chance, _linked);
#define floor_walls()                                                                   return  mod_script_call_self('mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call_self('mod', 'telib', 'wall_tops');
#define wall_clear(_x, _y)                                                              return  mod_script_call_self('mod', 'telib', 'wall_clear', _x, _y);
#define wall_delete(_x1, _y1, _x2, _y2)                                                         mod_script_call_nc  ('mod', 'telib', 'wall_delete', _x1, _y1, _x2, _y2);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call_self('mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call     ('mod', 'telib', 'race_get_sprite', _race, _sprite);
#define race_get_title(_race)                                                           return  mod_script_call_self('mod', 'telib', 'race_get_title', _race);
#define player_swap()                                                                   return  mod_script_call_self('mod', 'telib', 'player_swap');
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_wrap(_wep, _scrName, _scrRef)                                               return  mod_script_call_nc  ('mod', 'telib', 'wep_wrap', _wep, _scrName, _scrRef);
#define wep_skin(_wep, _race, _skin)                                                    return  mod_script_call_nc  ('mod', 'telib', 'wep_skin', _wep, _race, _skin);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc  ('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc  ('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call_self('mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define weapon_get(_name, _wep)                                                         return  mod_script_call     ('mod', 'telib', 'weapon_get', _name, _wep);
#define skill_get_icon(_skill)                                                          return  mod_script_call_self('mod', 'telib', 'skill_get_icon', _skill);
#define skill_get_avail(_skill)                                                         return  mod_script_call_self('mod', 'telib', 'skill_get_avail', _skill);
#define string_delete_nt(_string)                                                       return  mod_script_call_nc  ('mod', 'telib', 'string_delete_nt', _string);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc  ('mod', 'telib', 'path_create', _xstart, _ystart, _xtarget, _ytarget, _wall);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc  ('mod', 'telib', 'path_shrink', _path, _wall, _skipMax);
#define path_reaches(_path, _xtarget, _ytarget, _wall)                                  return  mod_script_call_nc  ('mod', 'telib', 'path_reaches', _path, _xtarget, _ytarget, _wall);
#define path_direction(_path, _x, _y, _wall)                                            return  mod_script_call_nc  ('mod', 'telib', 'path_direction', _path, _x, _y, _wall);
#define portal_poof()                                                                   return  mod_script_call_nc  ('mod', 'telib', 'portal_poof');
#define portal_pickups()                                                                return  mod_script_call_nc  ('mod', 'telib', 'portal_pickups');
#define pet_spawn(_x, _y, _name)                                                        return  mod_script_call_nc  ('mod', 'telib', 'pet_spawn', _x, _y, _name);
#define pet_get_name(_name, _modType, _modName, _skin)                                  return  mod_script_call_self('mod', 'telib', 'pet_get_name', _name, _modType, _modName, _skin);
#define pet_get_sprite(_name, _modType, _modName, _skin, _sprName)                      return  mod_script_call_self('mod', 'telib', 'pet_get_sprite', _name, _modType, _modName, _skin, _sprName);
#define pet_set_skin(_skin)                                                             return  mod_script_call_self('mod', 'telib', 'pet_set_skin', _skin);
#define team_get_sprite(_team, _sprite)                                                 return  mod_script_call_nc  ('mod', 'telib', 'team_get_sprite', _team, _sprite);
#define team_instance_sprite(_team, _inst)                                              return  mod_script_call_nc  ('mod', 'telib', 'team_instance_sprite', _team, _inst);
#define sprite_get_team(_sprite)                                                        return  mod_script_call_nc  ('mod', 'telib', 'sprite_get_team', _sprite);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call_self('mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_inst, _charm)                                                   return  mod_script_call_nc  ('mod', 'telib', 'charm_instance', _inst, _charm);
#define motion_step(_mult)                                                              return  mod_script_call_self('mod', 'telib', 'motion_step', _mult);
#define pool(_pool)                                                                     return  mod_script_call_nc  ('mod', 'telib', 'pool', _pool);