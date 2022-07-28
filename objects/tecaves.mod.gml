#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Gather Objects:
	for(var i = 1; true; i++){
		var _scrName = script_get_name(i);
		if(_scrName != undefined){
			call(scr.obj_add, script_ref_create(i));
		}
		else break;
	}
	
	 // Bind Events:
	global.wall_fake_bind = [
		script_bind(CustomDraw, script_ref_create(draw_wall_fake, "Bot"), 4,                                false),
		script_bind(CustomDraw, script_ref_create(draw_wall_fake, "Top"), object_get_depth(SubTopCont) + 1, false)
	];
	global.wall_fake_bind_reveal = [];
	with(global.wall_fake_bind){
		array_push(
			global.wall_fake_bind_reveal,
			script_bind(object, draw_wall_fake_reveal, depth - ((script[3] == "Bot") ? 2 : 1), visible)
		);
	}
	global.wall_shine_bind = script_bind(CustomDraw, draw_wall_shine, object_get_depth(SubTopCont), false);
	
	 // Surfaces:
	surfWallFakeMaskBot = call(scr.surface_setup, "RedWallFakeMaskBot", null, null, null);
	surfWallFakeMaskTop = call(scr.surface_setup, "RedWallFakeMaskTop", null, null, null);
	surfWallShineMask   = call(scr.surface_setup, "RedWallShineMask",   null, null, null);
	with(surfWallFakeMaskBot){
		wall_num = 0;
		wall_min = 0;
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
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro surfWallFakeMaskBot global.surfWallFakeMaskBot
#macro surfWallFakeMaskTop global.surfWallFakeMaskTop
#macro surfWallShineMask   global.surfWallShineMask

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
		curse     = (GameCont.area == area_cursed_caves);
		
		 // Cursed:
		if(curse > 0){
			spr_idle = spr.InvBigCrystalPropIdle;
			spr_hurt = spr.InvBigCrystalPropHurt;
			spr_dead = spr.InvBigCrystalPropDead;
		}
		
		 // Enemies:
		instance_create(x, y, PortalClear);
		repeat(choose(2, 3)){
			call(scr.obj_create, x, y, ((curse > 0) ? "InvCrystalBat" : "CrystalBat"));
		}
		
		return self;
	}
	
	
#define ChaosHeart_create(_x, _y)
	/*
		A special variant of crystal hearts unique to the red crown
		Generates random areas on death and cannot be used to access the warp zone
	*/
	
	with(call(scr.obj_create, _x, _y, "CrystalHeart")){
		 // Visual:
		spr_idle     = spr.ChaosHeartIdle;
		spr_walk     = spr.ChaosHeartIdle;
		spr_hurt     = spr.ChaosHeartHurt;
		spr_dead     = spr.ChaosHeartDead;
		hitid        = [spr_idle, "CHAOS HEART"];
		sprite_index = spr_idle;
		
		 // Vars:
		meleedamage = 2;
		white       = true;
		area        = null;
		
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
		call(scr.motion_step, self, 1);
		if(place_meeting(x, y, Wall)){
			var _walled = true;
			
			 // Glitch Through Walls:
			if(curse > 0 && dash){
				_walled = false;
				with(call(scr.instances_meeting_instance, self, Wall)){
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
					audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndLaserCrystalHit, 1 + orandom(0.1), 1.0), 0.08);
					audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndBigDogWalk,      1 + orandom(0.1), 0.1), 0.12);
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
		call(scr.motion_step, self, -1);
		
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
					audio_sound_set_track_position(sound_play_hit(sndLaserCrystalHit, 0.2),                            0.08);
					audio_sound_set_track_position(sound_play_hit(sndLuckyShotProc,   0.2),                            0.08);
					audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndMaggotBite, 1 + random(0.2), 0.8), 0.08);
					
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
	audio_sound_set_track_position(sound_play_hit(sndLaserCrystalDeath, 0.2), 0.4);
	audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndBigMaggotBite, 1.2 + random(0.2), 0.8), 0.08);
	
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
	
	with(call(scr.surface_setup, "CrystalBrain", 64, 64, 1)){
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
				with(instances_matching(obj.CrystalClone, "creator", self)){
					_cloneNum += variable_instance_get(target, "size", 1);
				}
				if(!chance(_cloneNum, clone_max)){
					with(call(scr.obj_create, x, y, "CrystalClone")){
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
				call(scr.sound_play_at, x, y, sndTVOn,          1.4 + random(0.2), 0.4);
				call(scr.sound_play_at, x, y, sndCrystalShield, 1.3 + random(0.2));
				repeat(8){
					with(call(scr.fx, teleport_x, teleport_y, random(2), CrystTrail)){
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
		var _found = false;
		
		 // Teleport Near Enemy:
		with(call(scr.array_shuffle, instances_matching_ne(enemy, "id"))){
			with(other){
				with(call(scr.instance_nearest_bbox, other.x, other.y, FloorNormal)){
					var	_x = bbox_center_x,
						_y = bbox_center_y;
						
					with(other){
						if(point_distance(_x, _y, target.x, target.y) >= teleport_dis_min){
							if(!place_meeting(_x, _y, Wall)){
								_found = true;
								teleport_x = _x;
								teleport_y = _y;
							}
						}
					}
				}
			}
			if(_found){
				break;
			}
		}
		
		 // Teleport Near Target:
		if(my_health < maxhealth || !_found){
			_found = false;
			with(call(scr.array_shuffle, FloorNormal)){
				var _x = bbox_center_x,
					_y = bbox_center_y;
					
				with(other){
					var _targetDis = point_distance(_x, _y, target.x, target.y);
					if(_targetDis >= teleport_dis_min && _targetDis <= teleport_dis_max){
						if(!place_meeting(_x, _y, Wall)){
							_found = true;
							teleport_x = _x;
							teleport_y = _y;
						}
					}
				}
				if(_found){
					break;
				}
			}
		}
		
		 // Rematerialize:
		teleport     = false;
		canfly       = false;
		x            = teleport_x;
		y            = teleport_y;
		sprite_index = spr_appear;
		image_index  = 0;
		call(scr.sound_play_at, x, y, sndHyperCrystalSpawn, 2.1 + random(0.3), 0.8);
	}
	
#define CrystalBrain_death
	 // Clear Space:
	with(instance_create(x, y, PortalClear)){
		image_xscale *= 0.8;
		image_yscale *= 0.8;
	}
	
	 // Epic Death:
	with(call(scr.obj_create, x, y, "CrystalBrainDeath")){
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
		call(scr.fx, x, y, 3, Smoke);
	}
	
#define CrystalBrain_effect(_x, _y)
	if(sprite_exists(spr_effect)){
		with(call(scr.obj_create, _x, _y, "CrystalBrainEffect")){
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
	call(scr.motion_step, self, 1);
	if(place_meeting(x, y, Wall)){
		x = xprevious;
		y = yprevious;
		move_bounce_solid(true);
	}
	call(scr.motion_step, self, -1);
	
#define CrystalBrainDeath_alrm0
	alarm0 = 15;
	
	 // Fragment:
	if(sprite_index != -1){
		sprite_index = -1;
		call(scr.sound_play_at, x, y, sndCrystalPropBreak, 1.4 + orandom(0.1), 4);
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
		with(call(scr.obj_create, x, y, "CrystalClone")){
			creator = other;
			team    = other.team;
			time    = 150;
			clone   = instances_matching(instances_matching_lt(clone, "size", 3), "intro", null);
		}
		
		 // Chunk Off:
		repeat(2){
			with(call(scr.fx, x, y, random_range(2, 5), Shell)){
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
	with(call(scr.corpse_drop, self)){
		image_index = 3;
	}
	
	 // Pickups:
	pickup_drop(100, 0);
	pickup_drop(50,  0);
	call(scr.rad_drop, x, y, raddrop, direction, speed);
	
	 // Sound:
	sound_play_hit_big(snd_dead, 0.2);
	
	 // Effects:
	view_shake_at(x, y, 30);
	repeat(5){
		with(call(scr.fx, x, y, random_range(3, 7), Shell)){
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
		clone         = [];
		time          = 450;
		team          = -1;
		appear        = 1;
		appear_flip   = false;
		appear_health = false;
		budge         = true;
		
		 // Cloneables:
		with(instances_matching_ne(instances_matching_ne(instances_matching_lt(instances_matching_ne(enemy, "team", 2), "size", 5), "mask_index", mskNone), "intro", false)){
			if(array_find_index(obj.CrystalBrain, self) < 0){
				array_push(other.clone, self);
			}
		}
		
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
			_clones = instances_matching(obj.CrystalClone, "team", team);
			
		 // Find Nearest:
		with(instances_matching_ne(clone, "id")){
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
					other.target = call(scr.instance_clone, self);
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
					//	gunspr       = ((skill_get(mut_throne_butt) > 0) ? spr.CrystalCloneGunTB : spr.CrystalCloneGun);
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
						creator    = other;
						
						 // No Bleed:
						alarm2 = -1;
						
						 // Give Weapon:
						var _wep = (is_object(other.wep) ? lq_clone(other.wep) : other.wep);
						with(call(scr.obj_create, x, y, "FireWeapon")){
							creator       = other;
							wep           = _wep;
							search_object = AllyBullet;
						}
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
							var _charm = call(scr.charm_instance, self, true);
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
					if(!call(scr.instance_budge, self, _target)){
						var	_dis = 16,
							_dir = random(360);
							
						x += lengthdir_x(_dis, _dir);
						y += lengthdir_y(_dis, _dir);
						xprevious = x;
						yprevious = y;
						
						 // Obliterate Wall:
						call(scr.wall_clear, self);
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
				call(scr.sound_play_at, x, y, sndHyperCrystalSearch, 1.3 + random(0.4), 0.4);
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
							call(scr.fx, x, y, 3, Smoke);
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
		: instances_matching_le(instances_matching(instances_matching(obj.CrystalClone, "depth", depth), "sprite_index", sprite_index), "appear", 0)
	);
	
	if(_inst[0] == self){
		_inst = call(scr.instances_seen, _inst, 24, 24);
		
		if(array_length(_inst)){
			var	_vx = view_xview_nonsync,
				_vy = view_yview_nonsync,
				_gw = game_width,
				_gh = game_height;
				
			with(call(scr.surface_setup, "CrystalClone", _gw, _gh, game_scale_nonsync)){
				x = _vx;
				y = _vy;
				
				 // Copy & Clear Screen:
				draw_set_blend_mode_ext(bm_one, bm_zero);
				surface_screenshot(surf);
				draw_set_blend_mode(bm_normal);
				draw_clear_alpha(c_black, 0);
				
				 // Draw Clone Overlays:
				var _lastTimeScale = current_time_scale;
				current_time_scale = epsilon;
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
					call(scr.draw_surface_scale, surf, x, y, 1 / scale);
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
		call(scr.sound_play_at, x, y, sndHyperCrystalRelease, 0.8 + random(0.3), 0.8);
	}
	
#define CrystalClone_effect(_x1, _y1, _x2, _y2)
	if(sprite_exists(spr_effect)){
		var	_inst   = [],
			_dir    = point_direction(_x1, _y1, _x2, _y2),
			_disMax = point_distance(_x1, _y1, _x2, _y2);
			
		for(var _dis = 0; _dis < _disMax; _dis += random_range(12, 24)){
			with(call(scr.obj_create, 
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
		canmelee    = false;
		size        = 5;
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
			with(call(scr.fx, [x, 6], [y, 12], [90, random_range(0.2, 0.5)], LaserCharge)){
				sprite_index = sprSpiralStar;
				image_index  = choose(0, random(image_number));
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
	else if(chance_ct(1, 5)){
		with(instance_create(x, y, Dust)){
			move_contact_solid(random(360), random_range(16, 48));
			sprite_index = sprLaserCharge;
			image_index  = random(image_number);
			direction    = point_direction(x, y, other.x, other.y);
			speed        = random_range(1, 2);
			hspeed      += other.hspeed;
			vspeed      += other.vspeed;
			friction    /= 2;
		}
		/*with(call(scr.fx, [x, 6], [y, 12], random(1), LaserCharge)){
			alarm0 = 10 + random(10);
		}*/
	}
	
	 // Manual Contact Damage:
	if(canmelee == false && alarm11 < 0 && place_meeting(x, y, Player)){
		with(call(scr.instances_meeting_instance, self, instances_matching_ne(Player, "team", team))){
			if(place_meeting(x, y, other)){
				with(other){
					if(projectile_canhit_melee(other)){
						projectile_hit_raw(other, meleedamage, 1);
						sound_play_hit(snd_mele, 0.1);
						
						 // Death:
						my_health = min(my_health, 0);
						if(area != undefined){
							GameCont.killenemies = true;
							
							 // Red:
							with(call(scr.obj_create, x, y, "WarpPortal")){
								area    = other.area;
								subarea = other.subarea;
								loops   = other.loops;
								with(self){
									event_perform(ev_step, ev_step_normal);
								}
							}
							
							 // Sound:
							if(sound_exists(snd_dead)){
								var _snd = sound_play_pitch(snd_dead, 1.3 + random(0.3));
								audio_sound_set_track_position(_snd, 0.4 + random(0.1));
								snd_dead = -1;
							}
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
		with(call(scr.projectile_create,
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
				area_chest     = [_chestTypes[i], AmmoChest, AmmoChest, WeaponChest, WeaponChest, "RedChest"];
				area_chest_pos = "random";
			}
			else{
				area_chest = [_chestTypes[i]];
				area_chaos = other.white;
			}
		}
	}
	
	 // Effects:
	if(white){
		repeat(16){
			with(instance_create(x + orandom(4), y + orandom(4), Dust)){
				motion_add(point_direction(other.x, other.y, x, y), 5);
				sprite_index  = sprSpiralStar;
				image_index   = choose(0, random(image_number));
				image_xscale *= random_range(1, 5);
				image_yscale  = image_xscale;
				depth         = -7;
			}
		}
	}
	sleep(100);
	
	 // Wooo:
	call(scr.unlock_set, "crown:red", true);
	
	
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
		
		 // Merged Weapon Support:
		temerge_on_fire = script_ref_create(CrystalHeartBullet_temerge_fire);
		
		return self;
	}
	
#define CrystalHeartBullet_setup
	setup = false;
	
	 // Determine Area:
	if(area_chaos){
		var _pick = [
			((call(scr.area_get_secret, GameCont.area) || GameCont.subarea <= 0) ? GameCont.lastarea : GameCont.area),
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
		var _subMax = call(scr.area_get_subarea, area);
		if(
			(area == "red")
			? (subarea == 3)
			: (subarea == _subMax && (_subMax > 1 || (loops > 0 && !call(scr.area_get_secret, area))))
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
			var _col = call(scr.area_get_back_color, area);
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
		with(call(scr.fx, [x, 6], [y, 6], random(1), ((area == area_hq) ? IDPDPortalCharge : LaserCharge))){
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
	if(projectile_canhit_np(other) && (instance_is(other, Player) || current_frame_active)){
		 // Slow:
		if(projectile_canhit_melee(other)){
			x -= hspeed;
			y -= vspeed;
		}
		speed = min(
			speed,
			maxspeed / (instance_is(creator, Player) ? power(2, 1 + skill_get(mut_laser_brain)) : 2)
		);
		
		 // Damage:
		projectile_hit_np(other, damage, force, 10);
		
		 // Effects:
		call(scr.sound_play_at, x, y, sndGammaGutsProc, 0.8 + random(0.4), 1.5);
		view_shake_at(x, y, 4);
	}
	
#define CrystalHeartBullet_wall
	 // Melt Through a Few Walls:
	if(min(image_xscale, image_yscale) > 0.85){
		image_xscale -= 0.05;
		image_yscale -= 0.05;
		
		 // Sound:
		var _snd = call(scr.sound_play_at, x, y, sndGammaGutsProc, 0.8 + random(0.4), 1.5);
		
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
	call(scr.sound_play_at, x, y, sndGammaGutsKill,      0.8 + random(0.3), 3.0);
	call(scr.sound_play_at, x, y, sndNothing2Beam,       0.7 + random(0.2), 3.0);
	call(scr.sound_play_at, x, y, sndHyperCrystalSearch, 0.6 + random(0.3), 1.5);
	
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
		_genID = call(scr.area_generate, area, subarea, loops, x, y, false, false, _scrt);
		
	if(is_real(_genID)){
		 // Delete Chests:
		with(instances_matching_gt([RadChest, chestprop, Mimic, SuperMimic], "id", _genID)){
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
			with(call(scr.array_shuffle, instances_matching_gt(FloorNormal, "id", _genID))){
				if(!place_meeting(x, y, Wall) && !place_meeting(x, y, prop) && !place_meeting(x, y, chestprop)){
					var _canChest = true;
					if(place_meeting(x, y, enemy)){
						with(call(scr.instances_meeting_instance, self, instances_matching_gt(enemy, "size", 1))){
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
			with(call(scr.chest_create, _chestX, _chestY, _chest, true)){
				with(call(scr.instances_meeting_instance, self, CrystalProp)){
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
		with(instances_matching_ne(_tileOld, "id")){
			var	_x   = bbox_center_x,
				_y   = bbox_center_y,
				_dis = 16;
				
			for(var _dir = 0; _dir < 360; _dir += 90){
				with(call(scr.instances_meeting_point, _x + lengthdir_x(_dis, _dir), _y + lengthdir_y(_dis, _dir), _tileNew)){
					_tileNew = call(scr.array_delete_value, _tileNew, self);
					array_push(_tileOld, self);
				}
			}
		}
		with(instances_matching_ne(_tileOld, "id")){
			with(self){
				event_perform(ev_create, 0);
			}
		}
		
		 // TopTinys:
		var _currentArea = GameCont.area;
		GameCont.area = area;
		with(instances_matching_ne(_tileNew, "id")){
			var	_ox = pfloor(random_range(bbox_left, bbox_right  + 1 + 8), 8),
				_oy = pfloor(random_range(bbox_top,  bbox_bottom + 1 + 8), 8);
				
			for(var _x = _ox - 8; _x < _ox + 8; _x += 8){
				for(var _y = _oy - 8; _y < _oy + 8; _y += 8){
					if(!array_length(call(scr.instances_meeting_point, _x, _y, _tileNew))){
						call(scr.obj_create, _x, _y, "TopTiny");
					}
				}
			}
		}
		GameCont.area = _currentArea;
		
		 // Extra TopSmalls:
		with(instances_matching_ne(_tileNew, "id")){
			if(instance_exists(self)){
				instance_create(x + choose(-16, 0), y + choose(-16, 0), Top);
			}
		}
		
		 // Reveal:
		with(instances_matching_gt([Floor, Wall, TopSmall], "id", _genID)){
			if(array_find_index(_tileOld, self) < 0){
				with(call(scr.floor_reveal, bbox_left, bbox_top, bbox_right, bbox_bottom, 6)){
					time_max *= 1.3;
				}
			}
		}
		
		 // Red Crown Quality Assurance:
		var _currentArea = GameCont.area;
		GameCont.area = area;
		if(subarea == 0){
			if(instance_exists(PizzaEntrance)){
				with(instances_matching_gt(PizzaEntrance, "id", _genID)){
					instance_delete(self);
				}
			}
			if(instance_exists(CrownPickup)){
				with(instances_matching_gt(CrownPickup, "id", _genID)){
					var _crownGuardianNum = 2;
					with(call(scr.array_shuffle, instances_matching_gt(FloorNormal, "id", _genID))){
						if(point_distance(bbox_center_x, bbox_center_y, other.x, other.y) < 96 && place_free(x, y)){
							instance_create(bbox_center_x, bbox_center_y, CrownGuardian);
							if(--_crownGuardianNum <= 0){
								break;
							}
						}
					}
					instance_delete(self);
				}
			}
			if(instance_exists(CrownPed)){
				with(instances_matching_gt(CrownPed, "id", _genID)){
					instance_delete(self);
				}
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
					with(call(scr.array_shuffle, instances_matching_gt(FloorNormal, "id", _genID))){
						if(point_distance(bbox_center_x, bbox_center_y, other.x, other.y) > 64){
							with(call(scr.obj_create, bbox_center_x, bbox_center_y, TechnoMancer)){
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
						
					with(call(scr.array_shuffle, instances_matching_gt(FloorNormal, "id", _genID))){
						if(_guardNum > 0){
							_guardNum--;
							call(scr.obj_create, bbox_center_x, bbox_center_y, "PopoSecurity");
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
		GameCont.area = _currentArea;
		
		 // Goodbye:
		if(instance_exists(enemy)){
			call(scr.portal_poof);
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
	
#define CrystalHeartBullet_temerge_fire
	temerge_can_delete = false;
	
	
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
		with(call(scr.fx, [x, 7], [(y + 3), 7], [90, random_range(0.2, 0.5)], LaserCharge)){
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
		image_speed  = 0.4 / ((_skill > 0) ? (1 + _skill) : power(2, _skill)); // idk the base game does this
		
		 // Vars:
		mask_index = mskSlash;
		damage     = 18;
		force      = 12;
		walled     = false;
		
		return self;
	}
	
#define EnergyBatSlash_hit
	if(projectile_canhit_melee(other)){
		 // Death Plasma:
		//if(other.my_health <= 0){
		//	call(scr.projectile_create, other.x, other.y, ((other.size < 2) ? "PlasmaImpactSmall" : PlasmaImpact));
		//}
		
		 // Damage:
		projectile_hit(other, damage, force);
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
		
		x += hspeed_raw;
		y += vspeed_raw;
		
		 // Hit Wall FX:
		var	_x   = bbox_center_x,
			_y   = bbox_center_y,
			_col = ((image_yscale > 0) ? c_lime : c_white);
			
		with(
			instance_is(other, Wall)
			? call(scr.instance_nearest_bbox, _x, _y, call(scr.instances_meeting_instance, self, Wall))
			: other
		){
			with(instance_create(bbox_center_x, bbox_center_y, MeleeHitWall)){
				image_angle = point_direction(_x, _y, x, y);
				image_blend = _col;
				sound_play_hit(sndMeleeWall, 0.3);
			}
		}
		
		x -= hspeed_raw;
		y -= vspeed_raw;
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
							with(call(scr.projectile_create, _x, _y, (_cannon ? "VlasmaCannon" : "VlasmaBullet"), direction, speed + 2)){
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
						with(call(scr.projectile_create, _x, _y, (_cannon ? PlasmaImpact : "PlasmaImpactSmall"))){
							depth = _depth;
							
							 // Sounds:
							var _snd = [
								[sndPlasma,    sndPlasmaUpg], 
								[sndPlasmaBig, sndPlasmaBigUpg]
							];
							call(scr.sound_play_at,
								x,
								y,
								_snd[_cannon][(instance_is(creator, Player) && skill_get(mut_laser_brain) > 0)],
								random_range(0.7, 1.3),
								0.6
							);
						}
						if(_cannon){
							call(scr.sleep_max, 10 * _damage);
						}
					}
				}
			}
		}
	}
	
	
#define InvCrystalBat_create(_x, _y)
	/*
		Cursed version of the Crystal Bat
	*/
	
	with(call(scr.obj_create, _x, _y, "CrystalBat")){
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
	
	with(call(scr.obj_create, _x, _y, "Mortar")){
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
		with(call(scr.projectile_create, x + (5 * right), y, "MortarPlasma", gunangle, 3)){
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
		image_index  = 0;
		
		 // Cursed Mortar Behavior:
		if(curse > 0 && my_health > 0 && chance(_damage / 25, 1)){
			with(call(scr.instance_random, obj.Mortar)){
				var	_x = x,
					_y = y;
					
				 // Swap Places:
				x         = other.x;
				y         = other.y;
				xprevious = x;
				yprevious = y;
				with(other){
					x         = _x;
					y         = _y;
					xprevious = x;
					yprevious = y;
				}
				
				 // Effects:
				sprite_index = spr_hurt;
				image_index  = 0;
				nexthurt     = current_frame + 6;
				
				 // Unstick from walls:
				with([self, other]){
					if(place_meeting(x, y, Floor)){
						if(!call(scr.instance_budge, self, Wall)){
							call(scr.wall_clear, self);
						}
					}
					else{
						call(scr.top_create, x, y, self, 0, 0);
					}
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
	with(call(scr.projectile_create, x, y, PlasmaImpact)){
		sprite_index = spr.EnemyPlasmaImpact;
		damage = 2;
		
		 // Over Wall:
		if(position_meeting(x, y + 8, Wall) || !position_meeting(x, y + 8, Floor)){
			depth = -9;
		}
	}
	
	 // Effects:
	view_shake_at(x, y, 3);
	call(scr.sound_play_at, x, y, sndPlasmaHit, 1 + orandom(0.1), 1.5);
	
	
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
	with(call(scr.obj_create, _x, _y, "CustomShell")){
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
		
		 // Merged Weapons Support:
		var _info = {
			"annihilate_instance_list" : [],
			"can_annihilate"           : true
		};
		temerge_on_setup = script_ref_create(RedBullet_temerge_setup, _info);
		temerge_on_hit   = script_ref_create(RedBullet_temerge_hit,   _info);
		
		return self;
	}
	
#define RedBullet_hit
	if(projectile_canhit(other)){
		projectile_hit(other, min(damage + (bonus_damage * bonus), max(other.my_health, 10)), force);
		
		 // Annihilation Time:
		RedBullet_annihilate();
		
		 // Goodbye:
		with(instance_create(x, y, BulletHit)){
			sprite_index = other.spr_dead;
		}
		instance_destroy();
	}
	
#define RedBullet_annihilate
	 // Prop Annihilation:
	if(instance_is(other, prop) || other.team == 0 || array_find_index(obj.Tesseract, other) >= 0){
		call(scr.obj_create, x, y, "RedExplosion");
	}
	
	 // Enemy Annihilation:
	else{
		call(scr.enemy_annihilate, other, 2);
		sleep(150);
	}
	
#define RedBullet_temerge_setup(_info, _instanceList)
	 // Tint Red:
	if(_info.can_annihilate){
		var _color = call(scr.area_get_back_color, "red");
		with(_instanceList){
			image_blend = _color;
			array_push(_info.annihilate_instance_list, self);
		}
	}
	
#define RedBullet_temerge_hit(_info)
	 // Annihilate:
	if(_info.can_annihilate){
		if(projectile_canhit(other) && other.my_health > 0){
			_info.can_annihilate = false;
			RedBullet_annihilate();
			instance_destroy();
			
			 // Remove Tints:
			with(instances_matching_ne(_info.annihilate_instance_list, "id")){
				if(self != other){
					with(instance_create(x + hspeed_raw, y + vspeed_raw, BulletHit)){
						sprite_index = sprThrowHit;
						image_blend  = other.image_blend;
						depth        = other.depth + 1;
					}
				}
				image_blend = c_white;
			}
			
			 // Disable Event:
			return true;
		}
	}
	
	 // Disable Event:
	else return true;
	
	
#define RedExplosion_create(_x, _y)
	/*
		An explosion that deals massive pinpoint damage and destroys any enemy projectiles and explosions that it touches
	*/
	
	with(instance_create(_x, _y, MeatExplosion)){
		 // Visual:
		sprite_index = spr.RedExplosion;
		image_angle  = random(360);
		hitid        = [sprite_index, "ANNIHILATION"];
		
		 // Vars:
		mask_index = mskPlasma;
		damage     = 200;
		force      = 2;
		team       = 2;
		target     = noone;
		
		 // Sounds:
		sound_stop(sndMeatExplo);
		audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndUltraEmpty,    1.1 + random(0.2), 2), 0.1)
		audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndExplosionS,    0.8 + random(0.4), 3), 0.03);
		audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndIDPDNadeExplo, 1.2 + random(0.4), 3), 0.4);
		
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
		with(call(scr.instances_meeting_instance, self, Explosion)){
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
		if(instance_exists(chestprop) && place_meeting(x, y, chestprop)){
			_inst = call(scr.array_combine, _inst, instances_matching_ne(chestprop, "id"));
		}
		if(instance_exists(Pickup) && place_meeting(x, y, Pickup)){
			_inst = call(scr.array_combine, _inst, instances_matching(Pickup, "mask_index", mskPickup));
		}
		if(array_length(_inst)){
			with(call(scr.instances_meeting_instance, self, _inst)){
				if(place_meeting(x, y, other)){
					if(!array_length(instances_matching(obj.CrystalClone, "target", self))){
						var _clone = self;
						
						motion_add(random(180), 1);
						
						with(other){
							with(RedSlash_clone(_clone)){
								appear = 1/2;
								with(target){
									direction += 180;
								}
								with(call(scr.obj_create, _clone.x, _clone.y, "CrystalClone")){
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
		
		x += hspeed_raw;
		y += vspeed_raw;
		
		 // Hit Wall FX:
		var	_x   = bbox_center_x,
			_y   = bbox_center_y,
			_col = call(scr.area_get_back_color, "red");
			
		with(
			instance_is(other, Wall)
			? call(scr.instance_nearest_bbox, _x, _y, call(scr.instances_meeting_instance, self, Wall))
			: other
		){
			with(instance_create(bbox_center_x, bbox_center_y, MeleeHitWall)){
				image_angle = point_direction(_x, _y, x, y);
				image_blend = _col;
				sound_play_hit(sndMeleeWall, 0.3);
			}
		}
		
		x -= hspeed_raw;
		y -= vspeed_raw;
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
								with(call(scr.obj_create, _clone.x, _clone.y, "CrystalClone")){
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
		projectile_hit(other, damage, force);
		
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
			image_blend  = call(scr.area_get_back_color, "red");
			depth        = -4;
			with(instance_copy(false)){
				image_angle += 180;
			}
		}
		repeat(3){
			call(scr.obj_create, x + orandom(6 * (_size + 1)), y + orandom(6 * (_size + 1)), "CrystalBrainEffect");
		}
		sleep(8 * (1 + _size));
		
		 // Sound:
		call(scr.sound_play_at, x, y, sndSwapSword, 1.6 + random(0.2));
		
		 // Clone the Bro:
		var _slash = other;
		with(call(scr.obj_create, x, y, "CrystalClone")){
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
					
				with(call(scr.projectile_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "VlasmaBullet", _d + 180, 1)){
					sprite_index = spr.EnemyVlasmaBullet;
					target       = other;
					target_x     = other.x;
					target_y     = other.y;
					my_sound     = call(scr.sound_play_at, x, y, sndHyperCrystalSpawn, 0.9 + random(0.3), 0.8);
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
	call(scr.enemy_hurt, _damage, _force, _direction);
	target_seen = true;
	
#define RedSpider_death
	pickup_drop(20, 0);
	
	 // Plasma:
	with(call(scr.team_instance_sprite, 1, call(scr.projectile_create, x, y, PlasmaImpact))){
		mask_index = mskPopoPlasmaImpact;
		call(scr.wall_clear, self);
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
		call(scr.instance_budge, self, Wall);
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
		with(call(scr.obj_create, x, y, "CatDoorDebris")){
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
		var _crystal = call(scr.instance_nearest_array, x, y, [CrystalProp, InvCrystal]);
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
			with(call(scr.obj_create, x, y, "Spiderling")){
				sprite_index = spr_hurt;
				alarm0       = ceil(other.alarm0 / 2);
				curse        = other.curse / 2;
				kills        = other.kills;
				raddrop      = 0;
			}
		}
	}
	
	
#define SpiralStarfield_create(_x, _y)
	/*
		Warp Zone's loading screen background
	*/
	
	with(instance_create(_x, _y, SpiralDebris)){
		 // Visual:
		sprite_index = spr.Starfield;
		image_index  = 0;
		turnspeed    = 0;
		
		 // Bind Spiral Setup Script:
		if(lq_get(ntte, "bind_setup_SpiralStarfield_Spiral") == undefined){
			ntte.bind_setup_SpiralStarfield_Spiral = call(scr.ntte_bind_setup, script_ref_create(ntte_setup_SpiralStarfield_Spiral), Spiral);
			ntte_setup_SpiralStarfield_Spiral(Spiral);
		}
		
		return self;
	}
	
#define SpiralStarfield_step
	 // Spin & Scale:
	image_xscale = 0.8 + (0.4 * image_index) + (instance_exists(SpiralCont) ? arctan(SpiralCont.time / 100) : 0);
	image_yscale = image_xscale;
	rotspeed     = image_xscale;
	dist         = 0;
	grow         = 0;
	
	
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
		maxhealth   = call(scr.boss_hp, 600);
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
		col      = call(scr.area_get_back_color, "red");
		
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
		with(call(scr.boss_intro, "Tesseract")){
			loops = GameCont.loops;
		}
		
		 // Sound:
		sound_play_pitch(sndBigDogHit,     0.2);
		sound_play_pitch(sndTVOn,          0.3);
		sound_play_pitch(sndRogueCanister, 0.5);
		sound_play_pitch(sndBallMamaLoop,  8.0);
		
		 // Clear Walls:
		call(scr.wall_clear, self);
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
		with(call(scr.wall_clear, self)){
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
				_wep.strike = call(scr.projectile_create, x, y, "TesseractStrike", _wep.rotation);
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
				audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndPortalStrikeLoop, 1.3 + random(0.25), 10), 0.93);
				audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndSnowBotDead,      1.3 + random(0.20), 10), 0.55);
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
				_wep.strike    = call(scr.projectile_create, x, y, "TesseractStrike", _wep.rotation);
				with(_wep.strike){
					alarm1 = other.alarm2 - 15;
				}
			}
			
			 // Animate:
			sprite_index = spr_tell;
			image_index  = 0;
			
			 // Sounds:
			audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndPortalStrikeLoop, 0.85 + random(0.15), 10), 1.33);
			audio_sound_set_track_position(call(scr.sound_play_at, x, y, sndSnowBotThrow,     0.60 + random(0.20),  8), 0.2);
			
			 // Cooldown:
			if(ammo <= 0){
				alarm2 = 24 * _max;
			}
		}
	}
	
#define Tesseract_hurt(_damage, _force, _direction)
	call(scr.enemy_hurt, _damage, _force, _direction);
	
	 // Pitch Hurt Sound:
	if(snd_hurt == sndHyperCrystalHurt){
		call(scr.sound_play_at, x, y, snd_hurt,           0.5 + random(0.3));
		call(scr.sound_play_at, x, y, sndNothingHurtHigh, 0.8 + random(0.2));
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
	with(call(scr.obj_create, x, y, "TesseractDeath")){
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
		weapons = call(scr.array_delete, weapons, _num);
		
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
		with(call(scr.projectile_create,
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
				with(call(scr.fx, x, y, [direction + choose(-45, 45), 3], Smoke)){
					depth = other.depth;
					growspeed /= 3;
				}
			}
			view_shake_at(x, y, 20);
			
			 // Sound:
			call(scr.sound_play_at, x, y, sndIDPDNadeExplo, 0.6, 3.5);
			call(scr.sound_play_at, x, y, sndHeavyCrossbow, 0.6, 5);
			
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
		projectile_hit_np(other, damage, force, 40);
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
	with(call(scr.projectile_create, x, y, "RedExplosion", direction)){
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
	call(scr.rad_drop, x, y, raddrop, direction, speed);
	
	 // Chunks:
	for(var i = 0; i < 10; i++){
		with(call(scr.fx, 
			x + orandom(8),
			y + orandom(8),
			[direction + orandom(120), (i * 0.5) + random_range(1, 6)],
			"CatDoorDebris"
		)){
			sprite_index = spr.CrystalBrainChunk;
			image_index  = irandom(image_number - 1);
			flash        = 2;
			call(scr.fx, x, y, random_range(4, 8), Smoke);
		}
	}
	
	 // Sound:
	call(scr.sound_play_at, x, y, sndPlantPotBreak, 0.85 + orandom(0.15), 5);
	call(scr.sound_play_at, x, y, sndExplosion,     1.0  + orandom(0.1),  5);
	call(scr.sound_play_at, x, y, sndIDPDNadeExplo, 0.6  + orandom(0.1),  5);
	
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
		with(call(scr.fx, x, y, 3, Smoke)){
			image_blend = c_black;
		}
	}
	
	 // Wall Collision:
	call(scr.motion_step, self, 1);
	if(place_meeting(x, y, Wall)){
		x = xprevious;
		y = yprevious;
		move_bounce_solid(true);
	}
	call(scr.motion_step, self, -1);
	
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
			with(call(scr.fx, x, y, random_range(2, 5), Shell)){
				sprite_index = spr.CrystalBrainChunk;
				image_index  = irandom(image_number - 1);
				image_speed  = 0;
			}
		}
		
		 // FX:
		if(snd_hurt == sndHyperCrystalHurt){
			call(scr.sound_play_at, x, y, sndLaserCrystalHit, 0.5 + random(0.3),                8);
			call(scr.sound_play_at, x, y, sndPlantPotBreak,   1.2 + random(0.6 / (1 + throes)), 8);
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
	with(call(scr.projectile_create, x, y, "RedExplosion")){
		mask_index  = mskPopoPlasmaImpact;
		image_angle = other.image_angle;
	}
	view_shake_at(x, y, 50);
	
	 // Spooky Gas:
	for(var _dir = 0; _dir < 360; _dir += (360 / 30)){
		var _len = random(20);
		with(call(scr.fx, 
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
	call(scr.rad_drop, x, y, raddrop, direction, speed);
	var _gold = false;
	with(Player){
		if(
			weapon_get_gold(wep)  != 0             ||
			weapon_get_gold(bwep) != 0             ||
			call(scr.wep_raw, wep)  == "tunneller" ||
			call(scr.wep_raw, bwep) == "tunneller"
		){
			_gold = true;
			break;
		}
	}
	if(_gold){
		with(instance_create(x, y, WepPickup)){
			ammo = true;
			wep  = { wep: "tunneller", gold: true };
		}
	}
	
	 // Sound:
	call(scr.sound_play_at, x, y, sndPlantPotBreak,     0.8 +  random(0.2), 6);
	call(scr.sound_play_at, x, y, sndPortalOpen,        1.8 +  random(0.2), 4);
	call(scr.sound_play_at, x, y, sndPortalStrikeFire,  2.5 + orandom(0.1), 4);
	call(scr.sound_play_at, x, y, sndHyperCrystalTaunt, 3.0 + orandom(0.1), 4);
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
					with(call(scr.projectile_create, xstart, ystart, "RedExplosion")){
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
		call(scr.sleep_max, 15);
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
		with(call(scr.team_instance_sprite, 
			call(scr.sprite_get_team, sprite_index),
			call(scr.fx, [x, 4], [y, 4], [direction, 2 * (speed / maxspeed)], PlasmaTrail)
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
		if(projectile_canhit_np(other) && (instance_is(other, Player) || current_frame_active)){
			projectile_hit_np(other, damage, force, 40);
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
	sound_play_hit(sndLightningHit, 0.2);
	call(scr.sound_play_at, x, y, sndLaser, 1.1 + random(0.3));
	
	 // Cannon:
	if(cannon > 0){
		var	_num = cannon,
			_ang = direction;
			
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			var _len = 96,
				_x = x + lengthdir_x(_len, _dir),
				_y = y + lengthdir_y(_len, _dir);
				
			with(call(scr.team_instance_sprite, 
				call(scr.sprite_get_team, sprite_index),
				call(scr.projectile_create, _x, _y, "VlasmaBullet", _dir + 180)
			)){
				target   = other.target;
				target_x = other.target_x;
				target_y = other.target_y;
			}
		}
		
		 // Sound:
		call(scr.sound_play_at, x, y, sndPlasmaHit, 0.6 + random(0.2), 4);
	}
	
	 // Explo:
	with(call(scr.team_instance_sprite, 
		call(scr.sprite_get_team, sprite_index),
		call(scr.projectile_create, x, y, ((cannon > 0) ? PlasmaImpact : "PlasmaImpactSmall"))
	)){
		depth = other.depth;
	}
	
	
#define VlasmaCannon_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "VlasmaBullet")){
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
			with(call(scr.obj_create, x, y, "WallFakeHelper")){
				creator      = other;
				sprite_index = other.sprite_index;
				image_index  = other.image_index;
				image_speed  = other.image_speed;
				image_xscale = other.image_xscale;
				image_yscale = other.image_yscale;
				image_angle  = other.image_angle;
				mask_index   = other.mask_index;
			}
		}
		
		return self;
	}
	
	
#define WallFakeHelper_create(_x, _y)
	/*
		Collision helper object for fake walls
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		sprite_index = object_get_sprite(Wall);
		mask_index   = object_get_mask(Wall);
		visible      = false;
		solid        = true;
		creator      = noone;
		
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
		seed       = GameCont.gameseed[(max(0, GameCont.atseed) + array_length(instances_matching_lt(obj.Warp, "id", id))) % array_length(GameCont.gameseed)];
		prompt     = call(scr.prompt_create, self, "", mskReviveArea, 0, 8);
		
		 // Determine Area:
		var	_pick   = [],
			_secret = chance(1, 8);
			
		with(call(scr.array_combine, [area_desert, area_sewers, area_scrapyards, area_caves, area_city, area_labs, area_palace, choose(area_mansion, area_crib), area_cursed_caves, area_jungle], ntte.mods.area)){
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
			var _warpInst = instances_matching_ne(obj.Warp, "id", id);
			with(call(scr.array_shuffle, _pick)){
				var _area = self;
				if(!call(scr.area_get_secret, _area) ^ _secret){
					if(!array_length(instances_matching(_warpInst, "area", _area))){
						other.area = _area;
						break;
					}
				}
			}
			subarea = irandom_range(1, call(scr.area_get_subarea, area));
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
				with(call(scr.instances_meeting_instance, self, Wall)){
					if(place_meeting(x, y, other)){
						instance_create(x, y, FloorExplo);
						instance_destroy();
					}
				}
			}
			else with(call(scr.instance_nearest_bbox, x + orandom(32), y + orandom(32), Wall)){
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
	call(scr.portal_poof);
	
	 // Warp:
	with(prompt){
		visible = other.open;
		if(text == ""){
			text = `WARP#${call(scr.area_get_name, other.area, other.subarea, other.loops)}`;
		}
	}
	if(instance_exists(prompt) && player_is_active(prompt.pick)){
		instance_destroy();
	}
	
#define Warp_draw
	image_alpha = abs(image_alpha);
	
	 // Area Color:
	var _color = call(scr.area_get_back_color, area);
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
			var _snd = call(scr.sound_play_at, x, y, sndHyperCrystalSearch, 0.5 + orandom(0.1), 4);
			if(sound_play_ambient(sndHyperCrystalAppear)){
				sound_pitch(_snd + 1, 0.6);
			}
		}
	}
	
#define Warp_destroy
	if(open){
		 // Close Warps:
		with(instances_matching_ne(obj.Warp, "id")){
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
		with(call(scr.obj_create, x, y, "WarpPortal")){
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
				
			with(call(scr.fx, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), [_d, 4 + random(2)], Dust)){
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
		with(call(scr.instances_meeting_instance, self, Wall)){
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
			call(scr.area_set, "red", 0, GameCont.loops);
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
#define ntte_setup_WepPickup(_inst)
	 // Scramble Cursed Caves Weapons:
	if(GameCont.area == area_cursed_caves){
		with(_inst){
			if(roll && !call(scr.weapon_has_temerge, wep)){
				if(chance(1, 3) || !position_meeting(xstart, ystart, ChestOpen)){
					curse = max(1, curse);
					wep   = call(scr.temerge_decide_weapon, 0, max(1, GameCont.hard - 1) + (2 * curse));
				}
			}
		}
	}
	
#define ntte_setup_SpiralStarfield_Spiral(_inst)
	 // Starfield Spirals:
	if(array_length(instances_matching_ne(obj.SpiralStarfield, "id"))){
		with(instances_matching(_inst, "sprite_index", sprSpiral)){
			sprite_index = spr.SpiralStarfield;
			colors       = [make_color_rgb(30, 14, 29), make_color_rgb(16, 10, 25)];
			lanim        = -100;
			//grow        += 0.05;
		}
	}
	
	 // Unbind Script:
	else if(lq_get(ntte, "bind_setup_SpiralStarfield_Spiral") != undefined){
		call(scr.ntte_unbind, ntte.bind_setup_SpiralStarfield_Spiral);
		ntte.bind_setup_SpiralStarfield_Spiral = undefined;
	}
	
#define ntte_end_step
	 // Custom Cocoon Drops:
	if(instance_exists(Cocoon)){
		var _inst = instances_matching_le(Cocoon, "my_health", 0);
		if(array_length(_inst)){
			with(_inst){
				var _kill = false;
				
				 // Bits:
				var _ang = random(360);
				for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 5)){
					with(call(scr.fx, x, y, [_dir, 1.5], Feather)){
						sprite_index = spr.PetSpiderWebBits;
						image_blend  = make_color_hsv(0, 0, 165);
						image_angle  = orandom(30);
						image_index  = random(image_number);
						image_speed  = 0;
						rot         /= 2;
					}
				}
				
				 // O no:
				if(chance(1, 25)){
					with(call(scr.obj_create, x, y, "SunkenSealSpawn")){
						alarm0 = 15;
					}
					_kill = true;
				}
				
				 // Hatch 1-3 Spiders:
				else if(chance(4, 5)){
					repeat(irandom_range(1, 3)){
						call(scr.obj_create, x, y, "Spiderling");
					}
					_kill = true;
				}
				
				 // Override Death:
				if(_kill){
					var _minID = GameObject.id;
					instance_destroy();
					with(instances_matching_gt(GameObject, "id", _minID)){
						if(!instance_is(self, Corpse) && !instance_is(self, Rad) && !instance_is(self, BigRad)){
							instance_delete(self);
						}
					}
				}
			}
		}
	}
	
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
			wall_num = instance_number(Wall);
			wall_min = instance_max;
			
			 // Update Fake Walls:
			if(array_length(obj.WallFakeHelper)){
				with(instances_matching_ne(obj.WallFakeHelper, "id")){
					if(!instance_exists(creator)){
						instance_destroy();
					}
				}
			}
		}
		
		 // Walls Active:
		if(array_length(obj.WallFake)){
			var _instMeet = [];
			
			 // Visual Fix:
			var _inst = instances_matching(obj.WallFake, "visible", false);
			if(array_length(_inst)){
				with(_inst){
					visible = true;
				}
			}
			
			 // Fake Wall Collision:
			if(array_length(obj.WallFakeHelper)){
				var _instWall = instances_matching_ne(obj.WallFakeHelper, "id");
				
				 // Gather Dudes in Fake Walls:
				with(hitme){
					if(place_meeting(x, y, CustomObject) && array_length(call(scr.instances_meeting_instance, self, _instWall))){
						array_push(_instMeet, self);
					}
				}
				var _frogInst = instances_matching(Player, "race", "frog");
				if(array_length(_frogInst)){
					with(_frogInst){
						if(array_find_index(_instMeet, self) < 0){
							call(scr.motion_step, self, 1);
							if(place_meeting(x, y, CustomObject) && array_length(call(scr.instances_meeting_instance, self, _instWall))){
								array_push(_instMeet, self);
							}
							call(scr.motion_step, self, -1);
						}
					}
				}
				
				 // Disable Collision When Near Dude in a Fake Wall:
				if(array_length(_instMeet)){
					with(_instWall){
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
					var _inst = instances_matching_ne(_instWall, "solid", true);
					if(array_length(_inst)){
						with(_inst){
							solid = true;
							if(instance_exists(creator)){
								creator.mask_index = (solid ? mask_index : mskNone);
							}
							else instance_destroy();
						}
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
	
#define ntte_draw_shadows
	 // Mortar Plasma:
	if(array_length(obj.MortarPlasma)){
		with(instances_matching(obj.MortarPlasma, "visible", true)){
			if(position_meeting(x, y, Floor)){
				var	_percent = clamp(96 / z, 0.1, 1),
					_w = ceil(18 * _percent),
					_h = ceil( 6 * _percent),
					_x = x,
					_y = y;
					
				draw_ellipse(_x - (_w / 2), _y - (_h / 2), _x + (_w / 2), _y + (_h / 2), false);
			}
		}
	}
	
	 // Crystal Brain Death:
	if(array_length(obj.CrystalBrainDeath)){
		with(instances_matching(obj.CrystalBrainDeath, "visible", true)){
			draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
		}
	}
	if(array_length(obj.PortalGuardianDeath)){ // until telabs has other stuff to put in its ntte_draw_shadows event or tepalace exists
		with(instances_matching(obj.PortalGuardianDeath, "visible", true)){
			draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
		}
	}
	
	 // Tesseract:
	if(array_length(obj.Tesseract) || array_length(obj.TesseractDeath)){
		var _scale = 0.9;
		with(instances_matching(instances_matching(call(scr.array_combine, obj.Tesseract, obj.TesseractDeath), "visible", true), "spr_shadow", mskNone)){
			var	_offX = spr_shadow_x,
				_offY = spr_shadow_y;
				
			image_xscale *= _scale;
			image_yscale *= _scale;
			x            += _offX;
			y            += _offY;
			
			event_perform(ev_draw, 0);
			
			image_xscale /= _scale;
			image_yscale /= _scale;
			x            -= _offX;
			y            -= _offY;
		}
	}
	
#define ntte_draw_bloom
	 // Warp Portals:
	if(array_length(obj.WarpPortal)){
		var	_scale = 2,
			_alpha = 0.1;
			
		with(instances_matching_ne(obj.WarpPortal, "id")){
			image_xscale *= _scale;
			image_yscale *= _scale;
			image_alpha  *= _alpha;
			
			event_perform(ev_draw, 0);
			
			image_xscale /= _scale;
			image_yscale /= _scale;
			image_alpha  /= _alpha;
		}
	}
	
	 // Crystal Heart Orbs:
	if(array_length(obj.CrystalHeartBullet)){
		var	_scale = 2,
			_alpha = 0.1;
			
		with(instances_matching_ne(obj.CrystalHeartBullet, "id")){ // Copy pasting code is truly so epic
			image_xscale *= _scale;
			image_yscale *= _scale;
			image_alpha  *= _alpha;
			
			event_perform(ev_draw, 0);
			
			image_xscale /= _scale;
			image_yscale /= _scale;
			image_alpha  /= _alpha;
		}
	}
	
	 // Red Melee:
	if(array_length(obj.RedSlash)){
		with(instances_matching_ne(obj.RedSlash, "id")){
			draw_sprite_ext(sprite_index, image_index, x, y, 1.2 * image_xscale, 1.2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
		}
	}
	if(array_length(obj.RedShank)){
		with(instances_matching_ne(obj.RedShank, "id")){
			draw_sprite_ext(sprite_index, image_index, x, y, 1.2 * image_xscale, 1.2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
		}
	}
	
	 // Tesseract Death:
	if(array_length(obj.TesseractDeath)){
		with(instances_matching_ne(obj.TesseractDeath, "id")){
			draw_sprite_ext(sprite_index, 0.4 * current_frame, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, (image_alpha * 0.2) / max(1, 1 + throes));
		}
	}
	
#define ntte_draw_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
			
			var _gray = (_type == "normal");
			
			 // Miner Bandit:
			if(array_length(obj.MinerBandit)){
				var	_lightDis  = 60 + (60 * _gray),
					_lightAng  = 15 + (5  * _gray),
					_circleDis = 6  + (3  * _gray),
					_circleRad = 12 + (12 * _gray);
					
				with(instances_matching_ne(obj.MinerBandit, "id")){
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
			
			 // Big Crystal Prop:
			if(array_length(obj.BigCrystalProp)){
				var _r = 30 + (60 * _gray) + (1 + sin(current_frame / 80));
				with(instances_matching_ne(obj.BigCrystalProp, "id")){
					draw_circle(x, y, _r, false);
				}
			}
			
			/*
			 // Crystal Bat:
			if(array_length(obj.CrystalBat)){
				with(instances_matching_ne(obj.CrystalBat, "id")){
					draw_circle(x, y, 16 + (20 * _gray) + random(2), false);
				}
			}
			*/
			
			 // Crystal Mortar:
			if(array_length(obj.Mortar)){
				with(instances_matching_ne(obj.Mortar, "id")){
					if(sprite_index == spr_fire){
						draw_circle(x + (6 * right), y - 16, abs(24 - alarm1 + orandom(4)) + (24 * _gray), false);
					}
				}
			}
			
			 // Crystal Mortar Plasma:
			if(array_length(obj.MortarPlasma)){
				var _r = 32 + (32 * _gray);
				with(instances_matching_ne(obj.MortarPlasma, "id")){
					draw_circle(x, y - z, _r + orandom(1), false);
				}
			}
			
			 // Crystal Heart:
			if(array_length(obj.CrystalHeart)){
				var	_ver = 15 + (30 * _gray),
					_rad = 24 + (48 * _gray),
					_coe = 2  + (1  * _gray);
					
				with(instances_matching_ne(obj.CrystalHeart, "id")){
					draw_crystal_heart_dark(_ver, _rad + random(2), _coe);
				}
			}
			
			 // Tesseract:
			if(array_length(obj.Tesseract)){
				with(instances_matching_ne(obj.Tesseract, "id")){
					draw_circle(x, y, 64 + (128 * _gray) + random(2), false);
				}
			}
			
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
	
	var	_vx        = view_xview_nonsync,
		_vy        = view_yview_nonsync,
		_gw        = game_width,
		_gh        = game_height,
		_surfScale = call(scr.option_get, "quality:minor");
		
	 // Wall Shine Mask:
	with(call(scr.surface_setup, "RedWallShineMask", _gw * 2, _gh * 2, _surfScale)){
		var	_surfX = pfloor(_vx, _gw),
			_surfY = pfloor(_vy, _gh);
			
		if(reset || x != _surfX || y != _surfY){
			reset = false;
			x     = _surfX;
			y     = _surfY;
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
				
				 // Background:
				if(background_color == call(scr.area_get_back_color, "red")){
					draw_clear(background_color);
					
					 // Cut Out Floors & Walls:
					draw_set_blend_mode_ext(bm_inv_src_alpha, bm_inv_src_alpha);
					with(call(scr.instances_meeting_rectangle, x, y, x + w, y + h, Floor)){
						draw_self();
					}
					with(call(scr.instances_meeting_rectangle, x, y, x + w, y + h, Wall)){
						if(image_speed == 0){
							draw_self();
						}
						else{
							var _lastImg = image_index;
							for(image_index = 0; image_index < image_number; image_index++){
								draw_self();
							}
							image_index = _lastImg;
						}
						draw_sprite(topspr, topindex, x, y - 8);
					}
					with(call(scr.instances_meeting_rectangle, x, y, x + w, y + h, TopSmall)){
						draw_sprite(sprite_index, image_index, x, y - 8);
					}
					draw_set_blend_mode(bm_normal);
				}
				
				 // Red Crystal Wall Tops:
				wall_inst = instances_matching_ne(wall_inst, "id");
				tops_inst = instances_matching_ne(tops_inst, "id");
				with(instances_matching(wall_inst, "solid", true)){
					draw_sprite(topspr, topindex, x, y - 8);
				}
				with(instances_matching(wall_inst, "solid", false)){
					draw_sprite_ext(topspr, topindex, x, y - 8, 1, 1, 0, c_white, 0.9);
				}
				with(tops_inst){
					draw_sprite(sprite_index, image_index, x, y - 8);
				}
				
			d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
			surface_reset_target();
		}
	}
	
	 // Wall Shine:
	with(call(scr.surface_setup, "RedWallShine", _gw, _gh, _surfScale)){
		x = _vx;
		y = _vy;
		
		if("wave" not in self){
			wave = 0;
		}
		wave += current_time_scale * random_range(1, 2);
		
		var	_surfX         = x,
			_surfY         = y,
			_shineAng      = 45,
			_shineSpeed    = 10,
			_shineWidth    = 30 + orandom(2),
			_shineInterval = 240, // 4-8 Seconds ('wave' adds 1~2)
			_shineDisMax   = sqrt(2 * sqr(max(_gw, _gh))),
			_shineDis      = (_shineSpeed * wave) % (_shineDisMax + (_shineInterval * _shineSpeed)),
			_shineX        = _vx + lengthdir_x(_shineDis, _shineAng),
			_shineY        = _vy + lengthdir_y(_shineDis, _shineAng) + _gh,
			_shineXOff     = lengthdir_x(_shineDisMax, _shineAng + 90),
			_shineYOff     = lengthdir_y(_shineDisMax, _shineAng + 90);
			
		if(_shineDis < _shineDisMax){
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
				
				 // Mask:
				draw_set_fog(true, c_black, 0, 0);
				with(surfWallShineMask){
					call(scr.draw_surface_scale, surf, x, y, 1 / scale);
				}
				/*with(other){
					if(array_length(obj.RedSpider)){
						with(instances_matching(obj.RedSpider, "visible", true)){
							event_perform(ev_draw, 0);
							//draw_self_enemy();
						}
					}
					if(array_length(obj.CrystalPropRed)){
						with(instances_matching(obj.CrystalPropRed, "visible", true)){
							draw_self();
						}
					}
				}*/
				draw_set_fog(false, 0, 0, 0);
				
				 // Shine:
				draw_set_color(c_white);
				draw_set_color_write_enable(true, true, true, false);
				draw_line_width(_shineX + _shineXOff, _shineY + _shineYOff, _shineX - _shineXOff, _shineY - _shineYOff, _shineWidth);
				draw_set_color_write_enable(true, true, true, true);
				
			d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
			surface_reset_target();
			
			 // Ship 'em Out:
			draw_set_alpha(0.1);
			draw_set_blend_mode_ext(bm_src_alpha, bm_one);
			call(scr.draw_surface_scale, surf, x, y, 1 / scale);
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
		_surfScale = call(scr.option_get, "quality:minor"),
		_surfMask  = call(scr.surface_setup, "RedWallFakeMask" + _type, _gw * 2, _gh * 2, _surfScale);
		
	 // Fake Wall Mask:
	with(_surfMask){
		var	_surfX = pfloor(_vx, _gw),
			_surfY = pfloor(_vy, _gh);
			
		if(reset || x != _surfX || y != _surfY){
			reset = false;
			x = _surfX;
			y = _surfY;
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
			
			switch(_type){
				
				case "Bot":
					
					 // Fake Walls:
					with(instances_matching_ne(obj.WallFake, "id")){
						if(image_speed == 0){
							draw_self();
						}
						else{
							var _lastImg = image_index;
							for(image_index = 0; image_index < image_number; image_index++){
								draw_self();
							}
							image_index = _lastImg;
						}
					}
					
					break;
					
				case "Top":
					
					 // Fake Walls:
					with(instances_matching_ne(obj.WallFake, "id")){
						draw_sprite(topspr, topindex, x, y - 8);
						//draw_sprite_part(outspr, outindex, l, r, w, h, x + l - 4, y + r - 12);
					}
					
					 // Cut Out Normal Walls:
					draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
					with(instances_matching(Wall, "solid", true)){
						draw_sprite(topspr, topindex, x, y - 8);
						draw_sprite_part(outspr, outindex, l, r, w, h, x + l - 4, y + r - 12);
					}
					draw_set_blend_mode(bm_normal);
					
					break;
					
			}
			
			d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
			surface_reset_target();
		}
	}
	
	 // Fake Wall Reveal Circle:
	with(call(scr.surface_setup, "RedWallFake", _gw, _gh, _surfScale)){
		x = _vx;
		y = _vy;
		
		surface_set_target(surf);
		draw_clear_alpha(c_black, 0);
		d3d_set_projection_ortho(x, y, w, h, 0);
			
			 // Circles:
			var _inst = instances_matching_gt(Player, "red_wall_fake", 0);
			if(array_length(_inst)){
				with(_inst){
					draw_circle(
						x,
						y + ((_type == "Top") ? -4 : 4),
						(32 + sin(current_frame / 10)) * lerp(0.2, red_wall_fake, red_wall_fake),
						false
					);
				}
			}
			
			 // Cut Mask Out of Circles:
			draw_set_blend_mode_ext(bm_zero, bm_src_alpha);
			with(_surfMask){
				call(scr.draw_surface_scale, surf, x, y, 1 / scale);
			}
			
		d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
		surface_reset_target();
		
		 // Stamp Screen Onto Mask:
		draw_set_blend_mode_ext(bm_one, bm_zero);
		draw_set_color_write_enable(true, true, true, false);
		surface_screenshot(surf);
		draw_set_color_write_enable(true, true, true, true);
		draw_set_blend_mode(bm_normal);
	}
	
	if(lag) trace_time(script[2] + " " + _type);
	
#define draw_wall_fake_reveal
	if(lag) trace_time();
	
	 // Draw Fake Wall Reveal Circle:
	with(call(scr.surface_setup, "RedWallFake", null, null, null)){
		 // Outline:
		draw_set_fog(true, make_color_rgb(192, 0, 55), 0, 0);
		call(scr.draw_surface_scale, surf, x - 1, y, 1 / scale);
		call(scr.draw_surface_scale, surf, x + 1, y, 1 / scale);
		draw_set_fog(true, make_color_rgb(145, 0, 43), 0, 0);
		call(scr.draw_surface_scale, surf, x, y - 1, 1 / scale);
		call(scr.draw_surface_scale, surf, x, y + 1, 1 / scale);
		draw_set_fog(false, 0, 0, 0);
		
		 // Normal:
		call(scr.draw_surface_scale, surf, x, y, 1 / scale);
	}
	
	if(lag) trace_time(script[2]);
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  scr                                                                                     global.scr
#macro  obj                                                                                     global.obj
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  epsilon                                                                                 global.epsilon
#macro  mod_current_type                                                                        global.mod_type
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
#macro  current_frame_active                                                                    ((current_frame + epsilon) % 1) < current_time_scale
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number) || (image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed == 0) ? spr_idle : spr_walk) : sprite_index
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
#define pround(_num, _precision)                                                        return  (_precision == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_precision == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_precision == 0) ? _num :  ceil(_num / _precision) * _precision;
#define frame_active(_interval)                                                         return  ((current_frame + epsilon) % _interval) < current_time_scale;
#define lerp_ct(_val1, _val2, _amount)                                                  return  lerp(_val2, _val1, power(1 - _amount, current_time_scale));
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define angle_lerp_ct(_ang1, _ang2, _num)                                               return  _ang2 + (angle_difference(_ang1, _ang2) * power(1 - _num, current_time_scale));
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_dir, _num)                                                                  direction = _dir; walk = _num; if(speed < friction_raw) speed = friction_raw;
#define enemy_face(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1;
#define enemy_look(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1; if('gunangle' in self) gunangle = _dir;
#define enemy_target(_x, _y)                                                                    target = (instance_exists(Player) ? instance_nearest(_x, _y, Player) : ((instance_exists(target) && target >= 0) ? target : noone)); return (target != noone);
#define script_bind(_scriptObj, _scriptRef, _depth, _visible)                           return  call(scr.script_bind, script_ref_create(script_bind), _scriptObj, (is_real(_scriptRef) ? script_ref_create(_scriptRef) : _scriptRef), _depth, _visible);