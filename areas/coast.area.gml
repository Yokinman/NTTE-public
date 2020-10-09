#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Bind Events:
	var _seaDepth = object_get_depth(Floor) + 10;
	global.sea_bind = ds_map_create();
	global.sea_bind[? "main"       ] = script_bind("SeaDraw",       CustomDraw, script_ref_create(draw_sea),                _seaDepth,                    false);
	global.sea_bind[? "top"        ] = script_bind("SeaDrawTop",    CustomDraw, script_ref_create(draw_sea_top),            -1,                           false);
	global.sea_bind[? "visible_max"] = script_bind("SeaInstVisMax", CustomDraw, script_ref_create(sea_inst_visible, false), _seaDepth,                    false);
	global.sea_bind[? "visible_min"] = script_bind("SeaInstVisMin", CustomDraw, script_ref_create(sea_inst_visible, true),  object_get_depth(SubTopCont), false);
	global.sea_inst = [];
	
	 // # of times that 'area_pop_enemies' must be called before it spawns another enemy, to reduce enemy spawns:
	global.pop_enemies_wait = 0;
	
	 // Ultra Bolt Fix:
	global.ultraboltfix_floors = [];
	
	 // Objects w/ Draw Events:
	global.draw_event_exists = [];
	with([Player, CrystalShield, Sapling, Ally, RogueStrike, DogMissile, PlayerSit, UberCont, BackCont, TopCont, KeyCont, GenCont, NothingSpiral, Credits, SubTopCont, BanditBoss, Drama, ScrapBossMissile, ScrapBoss, LilHunter, LilHunterFly, Nothing, NothingInactive, BecomeNothing, Carpet, NothingBeam, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, LastIntro, LastCutscene, Last, DramaCamera, BigFish, ProtoStatue, Campfire, LightBeam, TV, SentryGun, Disc, PlasmaBall, PlasmaBig, Lightning, IonBurst, Laser, PlasmaHuge, ConfettiBall, Nuke, Rocket, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, BigMaggotBurrow, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, GatorSmoke, Rat, FastRat, RatkingRage, MeleeBandit, SuperMimic, Sniper, Raven, RavenFly, Salamander, Spider, LaserCrystal, EnemyLightning, LightningCrystal, EnemyLaser, SnowTank, GoldSnowTank, SnowBot, CarThrow, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, CrownGuardianOld, CrownGuardian, Molefish, FireBaller, JockRocket, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoPlasmaBall, PopoRocket, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, PopoShield, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleBandit, EnemyHorror, RainDrop, SnowFlake, PopupText, Confetti, WepPickup, Menu, BackFromCharSelect, CharSelect, GoButton, Loadout, LoadoutCrown, LoadoutWep, LoadoutSkin, CampChar, MainMenu, PlayMenuButton, TutorialButton, MainMenuButton, StatMenu, StatButton, DailyArrow, WeeklyArrow, DailyScores, WeeklyScores, WeeklyProgress, DailyMenuButton, menubutton, BackMainMenu, UnlockAll, IntroLogo, MenuOLDOLD, OptionSelect, MusVolSlider, SfxVolSlider, AmbVolSlider, FullScreenToggle, FitScreenToggle, GamePadToggle, MouseCPToggle, CoopToggle, QToggle, ScaleUpDown, ShakeUpDown, AutoAimUpDown, BSkinLoadout, CrownLoadout, StatsSelect, CrownSelect, DailyToggle, UpdateSelect, CreditsSelect, LoadoutSelect, MenuOLD, Vlambeer, QuitSelect, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, SkillText, LevCont, mutbutton, PauseButton, GameOverButton, UnlockPopup, UnlockScreen, BUnlockScreen, UnlockButton, OptionMenuButton, VisualsMenuButton, AudioMenuButton, GameMenuButton, ControlMenuButton, CustomObject, CustomHitme, CustomProjectile, CustomSlash, CustomEnemy, CustomDraw, Dispose, asset_get_index("MultiMenu")]){
		global.draw_event_exists[self] = true;
	}
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro area_active variable_instance_get(GameCont, "ntte_active_" + mod_current, false) && (GameCont.area == mod_current || GameCont.lastarea == mod_current)
#macro area_visits variable_instance_get(GameCont, "ntte_visits_" + mod_current, 0)

#macro sea_depth global.sea_bind[? "main"].depth

#macro wading_color make_color_rgb(44, 37, 122)

#define area_subarea           return 3;
#define area_goal              return 100;
#define area_next              return ["oasis", 1];
#define area_music             return mus.Coast;
#define area_music_boss        return mus.SealKing;
#define area_ambient           return amb0b;
#define area_background_color  return make_color_rgb(27, 118, 184);
#define area_shadow_color      return c_black;
#define area_darkness          return false;
#define area_secret            return false;

#define area_name(_subarea, _loops)
	return "@1(sprInterfaceIcons)1-" + string((_subarea <= 0) ? "?" : _subarea);
	
#define area_text
	return choose(
		"COWABUNGA",
		"WAVES CRASH",
		"SANDY SANCTUARY",
		"THE WATER CALLS",
		"SO MUCH GREEN",
		"ENDLESS BLUE"
	);
	
#define area_mapdata(_lastX, _lastY, _lastArea, _lastSubarea, _subarea, _loops)
	return [
		18.15 + (9 * (_subarea - 1)),
		-9,
		(_subarea == 1)
	];
	
#define area_sprite(_spr)
	 // No Walls:
	if(instance_number(Wall) <= 1 || area_active){
		with([self, other]){
			if(instance_is(self, Wall)){
				instance_delete(self);
			}
			
			 // Rock Decals:
			else if(instance_is(self, TopSmall)){
				if(instance_exists(GenCont)){
					if(chance(1, 80) && !collision_rectangle(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, Floor, false, false)){
						obj_create(bbox_center_x, bbox_center_y, "CoastDecal");
					}
				}
				instance_delete(self);
			}
			
			 // Destroy Wall Decals:
			else if(instance_is(self, FloorExplo)){
				if(instance_exists(Bones) || instance_exists(TopPot)){
					with(instances_meeting(x, y, [Bones, TopPot])){
						if(place_meeting(x, y, other)){
							instance_delete(id);
						}
					}
				}
				instance_delete(self);
			}
		}
	}
	
	 // Sprites:
	switch(_spr){
		 // Floors:
		case sprFloor1      : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return spr.FloorCoast;
		case sprFloor1B     : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return spr.FloorCoastB;
		case sprFloor1Explo : return sprFloor1Explo;
		case sprDetail1     : return spr.DetailCoast;
		
		 // Walls:
		case sprWall1Bot    : return sprWall1Bot;
		case sprWall1Top    : return sprWall1Top;
		case sprWall1Out    : return sprWall1Out;
		case sprWall1Trans  : return sprWall1Trans;
		case sprDebris1     : return sprDebris1;
	}
	
#define area_setup
	goal             = area_goal();
	background_color = area_background_color();
	BackCont.shadcol = area_shadow_color();
	TopCont.darkness = area_darkness();
	
	 // Reset 'area_pop_enemies' Counter:
	global.pop_enemies_wait = 0;
	
	 // Remember:
	variable_instance_set(GameCont, "ntte_visits_" + mod_current, area_visits + 1);
	
#define area_setup_floor
	 // Footsteps:
	material = 1;
	
#define area_start
	 // Enable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, true);
	
	 // Active Sea Drawing:
	with(ds_map_values(global.sea_bind)){
		if(instance_exists(id)){
			id.visible = true;
		}
	}
	with(global.sea_bind[? "main"].id){
		flash = 0;
	}
	
	 // Subarea-Specific Spawns:
	switch(GameCont.subarea){
		
		case 1: // Shell
			
			with(instance_random(Floor)){
				with(obj_create(bbox_center_x, bbox_center_y, "CoastBigDecal")){
					 // Avoid Floors:
					direction = random(360);
					var l = random_range(16, 32);
					while(collision_rectangle(bbox_left + 20, bbox_top + 6, bbox_right - 20, bbox_bottom - 6, Floor, false, false)){
						x += lengthdir_x(l, direction);
						y += lengthdir_y(l, direction);
					}
					xstart = x;
					ystart = y;
					
					 // Friend:
					with(pet_spawn(x, y, "Parrot")){
						perched = other;
						can_take = false;
					}
				}
			}
			
			break;
			
		case 2: // Treasure
			
			if(variable_instance_get(GameCont, "sunkenchests", 0) <= GameCont.loops){
				with(instance_random(FloorNormal)){
					with(chest_create(bbox_center_x, bbox_center_y, "SunkenChest", true)){
						var	_dis = 160 + orandom(32),
							_dir = random(360);
							
						while(distance_to_object(Floor) < _dis){
							x += lengthdir_x(16, _dir);
							y += lengthdir_y(16, _dir);
						}
					}
				}
			}
			
			break;
			
		case 3: // Boss
			
			with(obj_create(10016, 10016, "Palanking")){
				var	_len = 10,
					_dir = random(360);
					
				while(distance_to_object(Floor) < 160){
					x += lengthdir_x(_len, _dir);
					y += lengthdir_y(_len, _dir);
				}
				scrRight(_dir + 180);
				xstart = x;
				ystart = y;
			}
			
			break
			
	}
	
	 // Anglers:
	with(RadChest) if(chance(1, 40)){
		obj_create(x, y, "Angler");
		instance_delete(id);
	}
	
	 // Reset Floor Surfaces:
	with(surface_setup("CoastFloor", null, null, null)){
		reset = true;
	}
	
	 // who's that bird?
	unlock_set("race:parrot", true);
	
#define area_finish
	 // Next Subarea:
	if(subarea < area_subarea()){
		subarea++;
	}
	
	 // Next Area:
	else{
		var _next = area_next();
		area    = _next[0];
		subarea = _next[1];
	}
	
#define area_transit
	 // Disable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, false);
	
	 // NTTE Update:
	mod_variable_set("mod", "ntte", "area_update", true);
	
	 // There Ain't No More Water:
	with(ds_map_values(global.sea_bind)){
		if(instance_exists(id)){
			id.visible = false;
		}
	}
	with(instances_matching_ne(instances_matching(GameObject, "persistent", true), "wading", null)){
		wading = 0;
	}
	
#define area_make_floor
	var	_x = x,
		_y = y,
		_outOfSpawn = (point_distance(_x, _y, 10000, 10000) > 48);
		
	/// Make Floors:
		 // Special - 4x4 to 6x6 Rounded Fills:
		if(chance(1, 5)){
			floor_fill(_x + 16, _y + 16, irandom_range(4, 6), irandom_range(4, 6), "round");
		}
		
		 // Normal - 2x1 Fills:
		else floor_fill(_x + 16, _y + 16, 2, 1, "");
		
	/// Turn:
		var _trn = 0;
		if(chance(3, 7)){
			_trn = choose(90, -90, 180);
		}
		direction += _trn;
		
	/// Chests & Branching:
		if(_trn == 180){
			 // Weapon Chests:
			if(_outOfSpawn){
				instance_create(_x + 16, _y + 16, WeaponChest);
			}
			
			 // Start New Island:
			if(chance(1, 2)){
				var d = direction + 180;
				_x += lengthdir_x(96, d);
				_y += lengthdir_y(96, d);
				
				with(instance_create(_x, _y, FloorMaker)){
					direction = d + choose(-90, 0, 90);
				}
				
				if(_outOfSpawn){
					instance_create(_x + 16, _y + 16, choose(AmmoChest, WeaponChest, RadChest));
				}
			}
		}
		
		 // Ammo Chests + End Branch:
		var n = instance_number(FloorMaker);
		if(!chance(22, 19 + n)){
			if(_outOfSpawn){
				instance_create(_x + 16, _y + 16, AmmoChest);
			}
			instance_destroy();
		}
		
	/// Crown Vault:
		if(GameCont.loops > 0){
			with(GenCont) if(instance_number(Floor) > goal){
				if(GameCont.subarea == 2 && GameCont.vaults < 3){
					with(instance_furthest(10000, 10000, Floor)){
						with(instance_nearest(
							(((x * 2) + 10000) / 3) + orandom(64),
							(((y * 2) + 10000) / 3) + orandom(64),
							Floor
						)){
							instance_create(x + 16, y + 16, ProtoStatue);
						}
					}
				}
			}
		}
		
#define area_pop_enemies
	var	_x = x + 16,
		_y = y + 16;
		
	if(global.pop_enemies_wait-- <= 0){
		global.pop_enemies_wait = 1;
		
		 // Loop Spawns:
		if(GameCont.loops > 0 && chance(1, 3)){
			 // Bushes:
			if(chance(1, 3)){
				with(instance_nearest(x, y, prop)){
					var	_ang = random(360),
						_num = irandom_range(1, 4);
						
					for(var a = _ang; a < _ang + 360; a += (360 / _num)){
						var o = 16 + random(16);
						obj_create(x + lengthdir_x(o, a), y + lengthdir_y(o, a), choose("BloomingAssassinHide", "BloomingAssassinHide", "BloomingBush"));
					}
				}
			}
			
			 // Birds:
			else repeat(irandom_range(1, 2)){
				instance_create(_x, _y, Raven);
			}
		}
		
		 // Normal Enemies:
		else{
			if(styleb) obj_create(_x + orandom(2), _y - irandom(16), "TrafficCrab");
			else{
				if(chance(GameCont.subarea, 18)){
					obj_create(_x, _y, choose("Pelican", "Pelican", "TrafficCrab"));
				}
				else{
					obj_create(_x, _y, choose("Diver", "Gull", "Gull", "Gull", "Gull"));
				}
			}
		}
		
		 // TMST:
		if(GameCont.loops > 0 && chance(1, 6)){
			var	_dir = random(360),
				_dis = 640 + random(1080);
				
			for(var i = 1; i <= 4; i++){
				with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Turtle)){
					snd_dead = asset_get_index(`sndTurtleDead${i}`);
				}
			}
		}
	}
	
	 // Seal Lands:
	else if(GameCont.subarea == 3){
		var _seals = instances_matching(CustomEnemy, "name", "Seal");
		if(random(2 * array_length(_seals)) < 1){
			if(styleb){
				obj_create(_x, _y, ((random(16) < 1) ? "SealHeavy" : "Seal"));
			}
			else{
				repeat(4) obj_create(_x, _y, "Seal");
			}
		}
	}
	
#define area_pop_props
	var	_x = x + 16,
		_y = y + 16,
		_spawnDis = point_distance(_x, _y, 10016, 10016);
		
	if(chance(1, 12)){
		if(_spawnDis > 48){
			var o = choose("BloomingCactus", "BloomingCactus", "BloomingCactus", "Palm");
			if(!styleb && chance(1, 8)) o = "BuriedCar";
			obj_create(_x, _y, o);
		}
	}
	
	 // Mine:
	else if(GameCont.subarea == 3 && chance(1, 40)){
		with(obj_create(_x + orandom(8), _y + orandom(8), "SealMine")){
			 // Move to sea:
			if(!other.styleb){
				var d = 24 + random(16);
				while(distance_to_object(Floor) < d){
					var o = 64;
					x += lengthdir_x(o, direction);
					y += lengthdir_y(o, direction);
				}
			}
		}
	}
	
#define area_pop_extras
	 // The new bandits
	with(instances_matching([WeaponChest, AmmoChest, RadChest], "", null)){
		obj_create(x, y, "Diver");
	}
	
	 // Underwater Details:
	with(Floor) if(chance(1, 3)){
		for(var a = 0; a < 360; a += 45){
			var	_x = bbox_center_x,
				_y = bbox_center_y;
				
			if(chance(1, 2) && !position_meeting(_x + lengthdir_x(sprite_get_width(mask_index), a), _y + lengthdir_y(sprite_get_height(mask_index), a), Floor)){
				var	l = random_range(32, 44),
					d = a + orandom(20);
					
				_x += lengthdir_x(l, d);
				_y += lengthdir_y(l, d);
				
				if(!position_meeting(_x, _y, Floor)){
					with(instance_create(_x, _y, Detail)){
						depth = sea_depth + 1;
					}
				}
			}
		}
	}
	
#define area_effect
	alarm0 = irandom_range(1, 60);
	
	for(var i = 0; i < maxp; i++){
		if(player_is_active(i)){
			 // Pick Random Player's Screen:
			do i = irandom(maxp - 1);
			until player_is_active(i);
			
			 // Wind:
			with(instance_random(instances_seen(Floor, 0, 0, i))){
				instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Wind);
			}
			
			break;
		}
	}
	
#define ntte_begin_step
	if(area_active){
		if(instance_exists(Player)){
			 // Destroy Projectiles Too Far Away:
			if(instance_exists(projectile)){
				var _inst = instances_matching_gt(projectile, "speed", 0);
				if(array_length(_inst)) with(_inst){
					if(distance_to_object(Player) > 1000 && distance_to_object(Floor) > 1000){
						instance_destroy();
					}
				}
			}
			
			 // Prevent Enemies Drowning:
			with(Player){
				alarm10 = max(alarm10, 90);
			}
		}
	}
	
#define ntte_step
	if(area_active){
		 // Push Stuff to Shore:
		if(instance_exists(Floor)){
			var _instPush = array_combine(
				array_combine(
					instances_matching(instances_matching_ge(hitme, "wading", 80), "visible", true),
					instances_matching_ge(Pickup, "wading", 80)
				),
				instances_matching_ge(chestprop, "wading", 192)
			);
			if(array_length(_instPush)) with(_instPush){
				if(distance_to_object(Portal) > 96){
					if(object_index != Player || !instance_exists(Portal) || array_length(instances_matching_lt(Portal, "endgame", 100)) > 0){
						if(!instance_is(self, hitme) || (team != 0 && !instance_is(self, prop))){
							var _player = instance_is(self, Player),
								_target = instance_nearest(x - 16, y - 16, Floor),
								_dir    = point_direction(x, y, _target.x, _target.y),
								_spd    = (_player ? (3 + ((wading - 80) / 16)) : 0.8);
								
							motion_add_ct(_dir, _spd);
							
							 // Extra Player Push:
							if(_player && wading > 120){
								if(array_length(instances_matching_ge(Portal, "endgame", 100)) <= 0){
									var _dis = ((wading - 120) / 10) * current_time_scale;
									x += lengthdir_x(_dis, _dir);
									y += lengthdir_y(_dis, _dir);
									
									 // FX:
									if(chance_ct(1, 2)){
										instance_create(x, y, Dust);
									}
								}
							}
						}
					}
				}
			}
		}
		
		 // Water Wading:
		var	_depthMax = global.sea_bind[? "visible_max"].depth,
			_depthMin = global.sea_bind[? "visible_min"].depth;
			
		global.sea_inst = array_combine(
			array_combine(
				[Debris, Corpse, ChestOpen, chestprop, WepPickup, Crown, Grenade, hitme],
				instances_matching(Pickup, "mask_index", mskPickup)
			),
			instances_matching(CustomSlash, "name", "ClamShield")
		);
		global.sea_inst = instances_matching_lt(global.sea_inst, "depth", _depthMax);
		global.sea_inst = instances_matching(   global.sea_inst, "visible", true);
		global.sea_inst = instances_matching_ne(global.sea_inst, "canwade", false);
		
		if(array_length(global.sea_inst)){
			 // Instance Setup:
			var _inst = instances_matching(global.sea_inst, "wading", null);
			if(array_length(_inst)) with(_inst){
				wading       = 0;
				wading_sink  = instance_is(self, Corpse);
				wading_clamp = ((object_index == Van) ? 40 : 0);
			}
			
			 // Find Dudes In/Out of Water:
			//var i = 0;
			with(global.sea_inst){
				 // In Water:
				var _dis = distance_to_object(Floor);
				if(_dis > 4 && depth > _depthMin){
					if(wading <= 0){
						 // Splash:
						repeat(irandom_range(4, 8)){
							instance_create(x, y, Sweat/*Bubble*/);
						}
						sound_play_hit_ext(choose(sndOasisChest, sndOasisMelee), 1.5 + random(0.5), 1);
					}
					wading = _dis;
					
					 // Hide Before & After Drawing:
					visible = false;
					
					 // Splashies:
					if(random(20) < min(speed_raw, 4)){
						with(instance_create(x, y, Dust)){
							motion_add(other.direction + orandom(10), 3);
						}
					}
				}
				
				 // Out of Water:
				else if(wading > 0){
					wading = 0;
					
					 // Sploosh:
					repeat(irandom_range(5, 9)){
						scrFX(x, y, [direction, speed], Sweat);
					}
					sound_play_hit_ext(choose(sndOasisChest, sndOasisMelee), 1 + random(0.25), 1);
				}
				
				//_inst[i++] = [id, y];
			}
			//array_sort_sub(_inst, 1, true);
			global.sea_inst = instances_matching_gt(global.sea_inst, "wading", 0);
		}
		
		 // Corpse Sinking (THE PEAK OF OPTIMIZATION):
		if(instance_exists(Corpse)){
			_inst = instances_matching_gt(Corpse, "wading", 30);
			if(array_length(_inst)){
				_inst = instances_matching(_inst, "speed", 0);
				if(array_length(_inst)){
					_inst = instances_matching(_inst, "image_speed", 0);
					if(array_length(_inst)){
						_inst = instances_matching_lt(_inst, "size", 3);
						if(array_length(_inst)){
							_inst = instances_matching_gt(_inst, "wading_sink", 0);
							if(array_length(_inst)) with(_inst){
								if(wading_sink++ >= 120){
									instance_destroy();
								}
							}
						}
					}
				}
			}
		}
		
		 // Wading Players:
		var _inst = instances_matching_gt(Player, "wading", 0);
		if(array_length(_inst)) with(_inst){
			 // Player Moves 20% Slower in Water:
			if(!skill_get(mut_extra_feet) && speed > 0){
				var f = ((race == "fish") ? 0 : -0.2);
				if(f != 0){
					x += hspeed_raw * f;
					y += vspeed_raw * f;
				}
			}
			
			 // Walk into Sea for Next Level:
			var n = instance_nearest(x, y, Portal);
			if(instance_exists(n) && n.endgame >= 100){
				if(wading > 120 || !instance_exists(Floor)){
					if(n.type == 1){
						n.x = x;
						n.y = y;
						n.xstart = x;
						n.ystart = y;
					}
					else{
						instance_create(x, y, Portal);
					}
				}
			}
		}
		
		 // Spinny Water Shells:
		if(instance_exists(Shell)){
			with(Shell) if(!position_meeting(x, y, Floor)){
				y += sin((x + y + current_frame) / 10) * 0.1 * current_time_scale;
			}
		}
		
		 // Explosion debris splash FX:
		if(instance_exists(Explosion)){
			with(Explosion) if(chance_ct(1, 5)){
				var	l = random_range(24, 48),
					d = random(360);
					
				with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), RainSplash)){
					if(place_meeting(x, y, Floor)) instance_destroy();
				}
			}
		}
		
		 // Spinny Underwater Portals:
		if(instance_exists(Portal)){
			 // Underwater Portal Setup:
			var _inst = instances_matching(Portal, "coast_portal", null);
			if(array_length(_inst)) with(_inst){
				coast_portal = (type == 1);
				alarm0 = -1;
				
				if(coast_portal){
					visible = false;
					sound_stop(sndPortalOpen);
					
					 // Flash Sea:
					with(global.sea_bind[? "main"].id){
						flash = 0;
					}
					
					 // Move to Sea:
					var	_moveDis = 8,
						_moveDir = 0;
						
					with(Floor){
						_moveDir += point_direction(bbox_center_x, bbox_center_y, other.x, other.y);
					}
					_moveDir /= instance_number(Floor);
					
					while(distance_to_object(Floor) < 120){
						x += lengthdir_x(_moveDis, _moveDir);
						y += lengthdir_y(_moveDis, _moveDir);
					}
					
					 // Move Spawned Stuff:
					with(instance_nearest(xstart, ystart, PortalShock)){
						x = other.x;
						y = other.y;
					}
					repeat(5) with(instance_nearest(xstart, ystart, PortalL)){
						x = other.x;
						y = other.y;
					}
					
					xstart = x;
					ystart = y;
					xprevious = x;
					yprevious = y;
				}
			}
			
			 // Spinnin!!!
			var _inst = instances_matching_lt(instances_matching(Portal, "visible", false), "endgame", 100);
			if(array_length(_inst)) with(_inst){
				if(!place_meeting(xstart, ystart, Floor)){
					var	r = 5 + image_index,
						c = current_frame;
						
					x = xstart + (cos(c) * r);
					y = ystart + (sin(c) * r);
					
					 // Effects:
					if(current_frame_active){
						instance_create(x, y, choose(Sweat, Sweat, Bubble));
					}
					
					 // Spawn Sound:
					if("coast_portal_sound" not in self){
						coast_portal_sound = true;
						sound_play(sndOasisPortal);
					}
				}
			}
		}
		
		 // Weird fix for ultra bolts destroying themselves when not touching a floor:
		global.ultraboltfix_floors = [];
		if(instance_exists(UltraBolt)){
			with(UltraBolt){
				if(!place_meeting(x, y, Floor)){
					with(instance_create(0, 0, Floor)){
						name = "UltraBoltCoastFix";
						mask_index = sprBoltTrail;
						x = other.x;
						y = other.y;
						xprevious = x;
						yprevious = y;
						visible = false;
						creator = other;
						array_push(global.ultraboltfix_floors, id);
					}
				}
			}
		}
	}
	
#define ntte_end_step
	if(area_active){
		 // Wall Stuff:
		if(instance_exists(Wall)){
			var _inst = instances_matching(Wall, "visible", false);
			if(array_length(_inst)) with(_inst){
				visible = true;
			}
		}
		if(instance_exists(TopSmall)){
			with(TopSmall){
				instance_destroy();
			}
		}
		
		 // Watery Dust:
		if(instance_exists(Dust)){
			var _inst = instances_matching(Dust, "coast_water", null);
			if(array_length(_inst)) with(_inst){
				coast_water = !position_meeting(x, y, Floor);
				if(coast_water){
					if(chance(1, 10 + instance_number(AcidStreak))){
						sound_play_hit(sndOasisCrabAttack, 0.1);
						with(scrFX(x, y, 2, "WaterStreak")){
							hspeed += other.hspeed / 2;
							vspeed += other.vspeed / 2;
						}
					}
					else{
						if(chance(1, 5) && point_seen(x, y, -1)){
							sound_play_hit(choose(sndOasisChest, sndOasisMelee), 0.2);
						}
						with(instance_create(x, y, Sweat)){
							hspeed = other.hspeed / 2;
							vspeed = other.vspeed / 2;
						}
					}
					instance_destroy();
				}
			}
		}
		
		 // Watery Explosion Sounds:
		if(instance_exists(Explosion)){
			var _inst = instances_matching(Explosion, "coast_water", null);
			if(array_length(_inst)) with(_inst){
				coast_water = !position_meeting(x, y, Floor);
				if(coast_water){
					sound_volume(sound_play_hit(sndOasisExplosion, 0.2), 5);
				}
			}
		}
		
		 // Watery Melting Scorch Marks:
		if(instance_exists(MeltSplat)){
			var _inst = instances_matching(MeltSplat, "coast_water", null);
			if(array_length(_inst)) with(_inst){
				coast_water = !position_meeting(x, y, Floor);
				if(coast_water){
					sound_volume(sound_play_hit(sndOasisExplosionSmall, 0.2), 5);
					repeat((sprite_index == sprMeltSplatBig) ? 16 : 8){
						if(chance(1, 6)) scrFX(x, y, 4, "WaterStreak");
						else instance_create(x, y, Sweat);
					}
					instance_destroy();
				}
			}
		}
		
		 // Ultra Bolt Fix Pt.2:
		if(array_length(global.ultraboltfix_floors)){
			with(instances_matching_ne(global.ultraboltfix_floors, "id", null)){
				instance_delete(id);
			}
		}
	}
	
#define draw_sea
	if(lag) trace_time();
	
	if("wave"     not in self) wave     = 0;
	if("wave_dis" not in self) wave_dis = 6;
	if("wave_ang" not in self) wave_ang = 0;
	if("flash"    not in self) flash    = 0;
	
	wave += current_time_scale;
	
	var	_wave           = wave,
		_vx             = view_xview_nonsync,
		_vy             = view_yview_nonsync,
		_vw             = game_width,
		_vh             = game_height,
		_surfScaleTop   = option_get("quality:main"),
		_surfScaleBot   = option_get("quality:minor"),
		_surfFloorExt   = 32,
		_surfFloorW     = (_vw + _surfFloorExt) * 2,
		_surfFloorH     = (_vh + _surfFloorExt) * 2,
		_surfFloor      = surface_setup("CoastFloor", _surfFloorW, _surfFloorH, _surfScaleBot),
		_surfTrans      = surface_setup("CoastTrans", _surfFloorW, _surfFloorH, _surfScaleBot),
		_surfWavesExt   = 8,
		_surfWavesW     = _vw + (_surfWavesExt * 2),
		_surfWavesH     = _vh + (_surfWavesExt * 2),
		_surfWaves      = surface_setup("CoastWaves",    _surfWavesW, _surfWavesH, _surfScaleBot),
		_surfWavesSub   = surface_setup("CoastWavesSub", _surfWavesW, _surfWavesH, _surfScaleBot),
		_surfSwimW      = _vw,
		_surfSwimH      = _vh,
		_surfSwimBot    = surface_setup("CoastSwimBot",    _surfSwimW, _surfSwimH, _surfScaleBot),
		_surfSwimTop    = surface_setup("CoastSwimTop",    _surfSwimW, _surfSwimH, _surfScaleTop),
		_surfSwimTopSub = surface_setup("CoastSwimTopSub", _surfSwimW, _surfSwimH, _surfScaleTop),
		_surfSwimScreen = surface_setup("CoastSwimScreen", _surfSwimW, _surfSwimH, _surfScaleBot);
		
	if(lag) trace_time(script[2] + " Setup");
	
	 // Draw Floors to Surface:
	with(_surfFloor){
		var	_surfX = pfloor(_vx, _vw) - _surfFloorExt,
			_surfY = pfloor(_vy, _vh) - _surfFloorExt,
			_surfScale = scale;
			
		if(
			reset
			|| x != _surfX
			|| y != _surfY
			|| (instance_number(Floor) != lq_defget(self, "floor_num", 0))
			|| (instance_exists(Floor) && lq_defget(self, "floor_min", 0) < Floor.id)
		){
			reset = false;
			
			 // Update Transition Tiles:
			_surfTrans.reset = true;
			
			 // Update Vars:
			x = _surfX;
			y = _surfY;
			floor_num = instance_number(Floor);
			floor_min = GameObject.id;
			
			 // Draw Floors:
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			
			var _inst = instance_rectangle_bbox(x, y, x + w, y + h, instances_matching(Floor, "visible", true));
			if(array_length(_inst)){
				var _spr = spr.FloorCoast;
				with(_inst){
					//var _spr = ((sprite_index == spr.FloorCoastB) ? spr.FloorCoast : sprite_index);
					draw_sprite_ext(_spr, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
				}
			}
			
			surface_reset_target();
		}
	}
	
	 // Underwater Transition Tiles:
	with(_surfTrans){
		x = _surfFloor.x;
		y = _surfFloor.y;
		
		 // Setup:
		if(reset){
			reset = false;
			
			var	_surfX = x,
				_surfY = y,
				_surfScale = scale;
			
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			
			 // Main Drawing:
			var _dis = 32;
			with(_surfFloor){
				var	_x = (x - _surfX),
					_y = (y - _surfY);
					
				draw_surface_scale(surf, _x * _surfScale, _y * _surfScale, _surfScale / scale);
				
				for(var _dir = 0; _dir < 360; _dir += 45){
					draw_surface_scale(
						surf,
						(_x + lengthdir_x(_dis, _dir)) * _surfScale,
						(_y + lengthdir_y(_dis, _dir)) * _surfScale,
						_surfScale / scale
					);
				}
			}
			
			 // Fill in Gaps (Cardinal Directions Only):
			var _inst = instance_rectangle_bbox(x - _dis, y - _dis, x + _dis + w, y + _dis + h, instances_matching(Floor, "visible", true));
			if(array_length(_inst)){
				var	_spr    = spr.FloorCoast,
					_sprNum = sprite_get_number(_spr);
					
				with(_inst){
					var	_x = x - _surfX,
						_y = y - _surfY;
						
					for(var _dir = 0; _dir < 360; _dir += 90){
						var	_ox = lengthdir_x(_dis, _dir),
							_oy = lengthdir_y(_dis, _dir);
							
						for(var _off = 1; _off <= 5; _off++){
							if(variable_instance_get(instance_place(x + (_ox * _off), y + (_oy * _off), Floor), "visible", false)){
								for(var i = 2; i <= _off; i++){
									var	_dx  = _x + (_ox * i),
										_dy  = _y + (_oy * i),
										_img = floor((_dx + _surfX + _dy + _surfY) / 32) % _sprNum;
										
									draw_sprite_ext(_spr, _img, _dx * _surfScale, _dy * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
								}
								break;
							}
						}
					}
				}
			}
			
			 // Details:
			if(instance_exists(Detail)){
				var _inst = instances_matching(instances_matching(Detail, "depth", sea_depth + 1), "visible", true);
				if(array_length(_inst)) with(_inst){
					draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
				}
			}
			
			surface_reset_target();
		}
		
		 // Draw:
		draw_surface_scale(surf, x, y, 1 / scale);
	}
	
	if(lag) trace_time(script[2] + " Floors");
	
	 // Submerged Rock Decals:
	if(instance_exists(CustomProp)){
		var _inst = instances_matching(instances_matching(CustomProp, "name", "CoastDecal", "CoastBigDecal"), "visible", true);
		if(array_length(_inst)) with(_inst){
			var	_hurt = (sprite_index == spr_hurt && image_index < 1);
			if(_hurt) draw_set_fog(true, image_blend, 0, 0);
			draw_sprite_ext(spr_bott, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
			if(_hurt) draw_set_fog(false, 0, 0, 0);
		}
	}
	if(instance_exists(CustomObject)){
		var _inst = instances_matching(instances_matching(CustomObject, "name", "CoastDecalCorpse"), "visible", true);
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(spr_bott, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		}
	}
	
	 // Palanking's Bottom:
	draw_set_fog(true, wading_color, 0, 0);
	if(instance_exists(CustomEnemy)){
		var _inst = instances_matching(instances_matching(CustomEnemy, "name", "Palanking"), "visible", true);
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(spr_bott, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
		}
	}
	if(instance_exists(CustomHitme)){
		var _inst = instances_matching(instances_matching(CustomHitme, "name", "Creature"), "visible", true);
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(spr_bott, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
		}
	}
	draw_set_fog(false, 0, 0, 0);
	
	if(lag) trace_time(script[2] + " Bottoms");
	
	/// Water Wading Objects:
		
		 // Surface Setup:
		with([_surfSwimBot, _surfSwimTop, _surfSwimTopSub, _surfSwimScreen]){
			x = _vx;
			y = _vy;
			
			 // Clear:
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			surface_reset_target();
		}
		
		if(array_length(global.sea_inst)){
			 // Copy Screen:
			draw_set_blend_mode_ext(bm_one, bm_zero);
			surface_screenshot(_surfSwimScreen.surf);
			draw_set_blend_mode(bm_normal);
			
			 // Drawing Water Wading Objects:
			var _inst = instances_matching_gt(instances_seen(global.sea_inst, 24, 24, -1), "wading", 0);
			if(array_length(_inst)){
				var _charmOutline = option_get("outline:charm");
				with(_inst){
					var	_sprH     = sprite_get_height(sprite_index),
						_sprY     = sprite_get_yoffset(sprite_index),
						_isPlayer = (object_index == Player);
						
					 // Clear Screen:
					draw_clear_alpha(0, 0);
					
					/// Z-Axis / Water Height:
						var	_z  = 2,
							_wh = (_sprH - sprite_get_bbox_bottom(sprite_index)) + ((wading - 16) * 0.2);
							
						 // Clamp Water Height:
						if(!_isPlayer || !instance_exists(Portal)){
							_wh = min(_wh, ((wading_clamp > 0) ? wading_clamp : _sprY - 2));
						}
						
						 // Bobbing:
						if(wading > _sprH || !instance_is(id, hitme)){
							var _bobMax = min(wading / _sprH, 2) / (1 + (wading_sink / 10));
							_z += _bobMax * sin((_wave + x + y) / 10);
						}
						
						 // Sinking:
						if(wading_sink != 0){
							_z += wading_sink / 5;
						}
						
					 // Store + Temporarily Set Player Vars:
					if(_isPlayer){
						var _save = {};
						
						 // Sucked Into Abyss:
						if(instance_exists(Portal)){
							_save.image_xscale = image_xscale;
							_save.image_yscale = image_yscale;
							_save.image_alpha  = image_alpha;
							with(instance_nearest(x, y, Portal)) if(endgame < 100){
								with(other){
									var _num = min(0.5 + (other.endgame / 60), 1);
									image_xscale *= _num;
									image_yscale *= _num;
									image_alpha  *= _num;
									_z += 48 * (1 - _num);
								}
							}
						}
						
						 // Manually Draw Laser Sights:
						if(canscope){
							_save.canscope = canscope;
							canscope = false;
						}
					}
					
					 // Call Draw Event:
					y += _z;
					if(global.draw_event_exists[object_index]){
						event_perform(ev_draw, 0);
					}
					else draw_self();
					y -= _z;
					
					 // Reset Player Vars:
					if(_isPlayer){
						for(var i = 0; i < lq_size(_save); i++){
							var k = lq_get_key(_save, i);
							variable_instance_set(id, k, lq_get(_save, k));
						}
					}
					
					 // Bottom Half:
					draw_set_alpha(1 - (wading_sink / 120));
					surface_screenshot(_surfSwimBot.surf);
					draw_set_alpha(1);
					
					 // Top Half:
					with(_surfSwimTopSub){
						 // Copy Screen:
						surface_set_target(surf);
						draw_clear_alpha(0, 0);
						surface_screenshot(surf);
						
						 // Top Half:
						var	_surfSwimTopX = _surfSwimTop.x,
							_surfSwimTopY = _surfSwimTop.y,
							_surfSwimTopScale = _surfSwimTop.scale;
							
						surface_set_target(_surfSwimTop.surf);
							
							var	_x = x - _surfSwimTopX,
								_y = y - _surfSwimTopY,
								_w = w * scale,
								_h = (((other.y - y) + (_sprH - _sprY)) - _wh) * scale;
								
							 // Manually Draw Laser Sights:
							if(_isPlayer){
								with(other) if(canscope && !instance_exists(PlayerSit)){
									draw_set_color(make_color_rgb(250, 54, 0));
									
									var _wep = ((race == "steroids") ? [wep, bwep] : [wep]);
									
									for(var i = 0; i < array_length(_wep); i++){
										if(weapon_get_laser_sight(_wep[i])){
											var	_sx = x,
												_sy = y + _z - (i * 4),
												_lx = _sx,
												_ly = _sy,
												_md = 1000, // Max Distance
												d = _md,    // Distance
												m = 0;      // Minor hitscan increment distance
												
											while(d > 0){ // A strange but fast hitscan system
												 // Major Hitscan Mode:
												if(m <= 0){
													_lx = _sx + lengthdir_x(d, gunangle);
													_ly = _sy + lengthdir_y(d, gunangle);
													d -= sqrt(_md);
													
													 // Enter minor hitscan mode once no walls on path:
													if(!collision_line(_sx, _sy, _lx, _ly, Wall, false, false)){
														m = 2;
														d = sqrt(_md);
													}
												}
												
												 // Minor Hitscan Mode:
												else{
													if(position_meeting(_lx, _ly, Wall)) break;
													_lx += lengthdir_x(m, gunangle);
													_ly += lengthdir_y(m, gunangle);
													d -= m;
												}
											}
											
											 // Draw Laser:
											_sx = (_sx - _surfSwimTopX) * _surfSwimTopScale;
											_sy = (_sy - _surfSwimTopY) * _surfSwimTopScale;
											_lx = (_lx - _surfSwimTopX) * _surfSwimTopScale;
											_ly = (_ly - _surfSwimTopY) * _surfSwimTopScale;
											
											var	_cdis = lerp(4, 48, abs(angle_difference(gunangle, 90)) / 180) * _surfSwimTopScale,
												_cx = _sx + lengthdir_x(_cdis, gunangle),
												_cy = _sy + lengthdir_y(_cdis, gunangle),
												_ox = lengthdir_x(right, gunangle - 90) * _surfSwimTopScale,
												_oy = lengthdir_y(right, gunangle - 90) * _surfSwimTopScale;
												
											draw_primitive_begin(pr_trianglestrip);
											draw_set_alpha(0);
											draw_vertex(_sx,       _sy      );
											draw_vertex(_sx + _ox, _sy + _oy);
											draw_set_alpha(1);
											draw_vertex(_cx,       _cy      );
											draw_vertex(_cx + _ox, _cy + _oy);
											draw_vertex(_lx,       _ly      );
											draw_vertex(_lx + _ox, _ly + _oy);
											draw_primitive_end();
											
											//draw_sprite_ext(sprLaserSight, -1, _sx, _sy, (point_distance(_sx, _sy, _lx, _ly) / 2) + 2, 1, gunangle, c_white, 1);
										}
									}
								}
							}
							
							 // Charmed Enemy Drawing:
							if("ntte_charm" in other && other.ntte_charm.charmed){
								var _charm = other.ntte_charm;
								
								 // Outlines:
								if(_charmOutline){
									var	_charmIndex = (player_is_active(_charm.index) ? _charm.index : player_find_local_nonsync()),
										_charmColor = (player_is_active(_charmIndex) ? player_get_color(_charmIndex) : c_white);
										
									draw_set_fog(true, _charmColor, 0, 0);
									for(var a = 0; a < 360; a += 90){
										draw_surface_part(surf, 0, 0, _w, _h, _x + dcos(a), _y - dsin(a));
									}
									draw_set_fog(false, 0, 0, 0);
								}
								
								 // Self:
								draw_surface_part(surf, 0, 0, _w, _h, _x, _y);
								
								 // Eyes:
								if(shader_setup("Charm", surface_get_texture(surf), [w, h])){
									draw_surface_part(surf, 0, 0, _w, _h, _x, _y);
									shader_reset();
								}
							}
							
							 // Self:
							else draw_surface_part(surf, 0, 0, _w, _h, _x, _y);
							
							 // Water Interference Line:
							draw_set_fog(true, c_white, 0, 0);
							draw_surface_part_ext(surf, 0, _h, _w, max(1, scale), _x, _y + _h, 1, 1, c_white, 0.8);
							draw_set_fog(false, 0, 0, 0);
							
						surface_reset_target();
					}
				}
			}
			
			 // Redraw Screen:
			with(_surfSwimScreen){
				draw_set_blend_mode_ext(bm_one, bm_zero);
				draw_surface_scale(surf, x, y, 1 / scale);
				draw_set_blend_mode(bm_normal);
			}
			
			 // Draw Bottom Halves:
			with(_surfSwimBot){
				draw_set_fog(true, wading_color, 0, 0);
				draw_surface_scale(surf, x, y, 1 / scale);
				draw_set_fog(false, 0, 0, 0);
			}
			
			if(lag) trace_time(script[2] + " Wading");
		}
		
	 // Draw Sea:
	draw_set_color(background_color);
	draw_set_alpha(0.6);
	draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, false);
	draw_set_alpha(1);
	
	 // Caustics:
	draw_set_alpha(0.4);
	draw_sprite_tiled(spr.CoastTrans, 0, sin(_wave * 0.02) * 4, sin(_wave * 0.05) * 2);
	draw_set_alpha(1);
	
	if(lag) trace_time(script[2] + " Sea");
	
	 // Foam:
	var	_waveInt     = 40,                                                            // How often waves occur in frames, affects wave speed
		_waveOutMax  = wave_dis,                                                      // Max travel distance
		_waveSpeed   = _waveOutMax + 0.1,                                             // Wave speed
		_waveAng     = wave_ang,                                                      // Angular Offset
		_iRad        = _waveSpeed * cos(((_wave % _waveInt) * (pi / _waveInt)) + pi), // Inner radius
		_oRad        = _iRad + min(_waveOutMax - _iRad, _iRad),                       // Outer radius
		_waveCanDraw = (_oRad > _iRad && _oRad > 0);                                  // Saves gpu time by not drawing when nothing is gonna show up
		
	if(_waveCanDraw){
		var	_surfX = _vx - _surfWavesExt,
			_surfY = _vy - _surfWavesExt;
			
		 // Draw Raw Foam:
		with(_surfWavesSub){
			x = _surfX;
			y = _surfY;
			
			var _surfScale = scale;
			
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			draw_set_fog(true, c_white, 0, 0);
				
				 // Floors:
				with(_surfFloor){
					draw_surface_scale(surf, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, _surfScale / scale);
				}
				
				// PalanKing:
				if(instance_exists(CustomEnemy)){
					var _inst = instances_matching_le(instances_matching(instances_matching(CustomEnemy, "name", "Palanking"), "visible", true), "z", 4);
					if(array_length(_inst)) with(_inst){
						if(!place_meeting(x, y, Floor)){
							draw_sprite_ext(spr_foam, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * right * _surfScale, image_yscale * _surfScale, 0, c_white, 1);
						}
					}
				}
				if(instance_exists(CustomHitme)){
					var _inst = instances_matching(instances_matching(CustomHitme, "name", "Creature"), "visible", true);
					if(array_length(_inst)) with(_inst){
						draw_sprite_ext(spr_foam, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * right * _surfScale, image_yscale * _surfScale, image_angle, c_white, 1);
					}
				}
				
				 // Rock Decals:
				if(instance_exists(CustomProp)){
					var _inst = instances_matching(instances_matching(CustomProp, "name", "CoastDecal", "CoastBigDecal"), "visible", true);
					if(array_length(_inst)) with(_inst){
						draw_sprite_ext(spr_foam, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, c_white, 1);
					}
				}
				if(instance_exists(CustomObject)){
					var _inst = instances_matching(instances_matching(CustomObject, "name", "CoastDecalCorpse"), "visible", true);
					if(array_length(_inst)) with(_inst){
						draw_sprite_ext(spr_foam, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, c_white, 1);
					}
				}
				
			draw_set_fog(false, 0, 0, 0);
			surface_reset_target();
		}
		
		 // Animate Foam (Part player sees):
		with(_surfWaves){
			x = _surfX;
			y = _surfY;
			
			var _surfScale = scale;
			
			 // Draw:
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
				
				with([_oRad, _iRad]){
					var _radius = self;
					with(_surfWavesSub){
						for(var _ang = _waveAng; _ang < _waveAng + 360; _ang += 45){
							draw_surface_scale(
								surf,
								(x - _surfX + lengthdir_x(_radius, _ang)) * _surfScale,
								(y - _surfY + lengthdir_y(_radius, _ang)) * _surfScale,
								_surfScale / scale
							);
						}
					}
					draw_set_blend_mode(bm_subtract);
				}
				draw_set_blend_mode(bm_normal);
				
			surface_reset_target();
			
			 // Finished Product, Bro:
			draw_surface_scale(surf, x, y, 1 / scale);
		}
	}
	else{
		wave_dis = round(5.5 + (0.5 * sin(_wave / 200)) + random(1));
		wave_ang = pround(random(45), 15);
	}
	
	if(lag) trace_time(script[2] + " Foam");
	
	 // Level Over, Flash Sea:
	if(instance_exists(Portal)){
		var	_flashInt = 300, // Flash every X frames
			_flashDur = 30,  // Flash lasts X frames
			_max = ((flash <= _flashDur) ? 0.3 : 0.15); // Max flash alpha
			
		draw_set_color(c_white);
		draw_set_alpha(_max * (1 - ((flash % _flashInt) / _flashDur)));
		draw_rectangle(_vx, _vy, _vx + _vw, _vy + _vh, 0);
		draw_set_alpha(1);
		
		if((flash % _flashInt) < current_time_scale){
			 // Sound:
			sound_play_pitchvol(sndOasisHorn, 0.5, 2);
			sound_play_pitchvol(sndOasisExplosion, 1 + random(1), ((flash <= 0) ? 1 : 0.4));
			
			 // Effects:
			for(var i = 0; i < maxp; i++){
				view_shake[i] += 8;
			}
			with(Floor) if(chance(1, 5)){
				for(var d = 0; d < 360; d += 45){
					var	_x = x + lengthdir_x(32, d),
						_y = y + lengthdir_y(32, d);
						
					if(!position_meeting(_x, _y, Floor)){
						repeat(irandom_range(3, 6)){
							if(chance(1, 6 + instance_number(AcidStreak))){
								sound_play_hit(sndOasisCrabAttack, 0.2);
								scrFX(_x + 16 + orandom(8), _y + 16 + orandom(8), [d + orandom(20), 4], "WaterStreak");
							}
							else instance_create(_x + random(32), _y + random(32), Sweat);
						}
					}
				}
			}
			with(Portal){
				repeat(3) scrFX(x, y, 3, Dust);
			}
		}
		
		flash += current_time_scale;
	}
	
	if(lag) trace_time(script[2] + " Flash");
	
#define draw_sea_top
	if(lag) trace_time();
	
	 // Top Halves of Swimming Objects:
	with(surface_setup("CoastSwimTop", null, null, null)){
		draw_surface_scale(surf, x, y, 1 / scale);
	}
	
	if(lag) trace_time(script[2]);
	
#define sea_inst_visible(_visible)
	if(array_length(global.sea_inst)){
		if(lag) trace_time();
		
		var _inst = instances_matching_ne(global.sea_inst, "visible", _visible);
		if(array_length(_inst)) with(_inst){
			visible = _visible;
		}
		
		if(lag) trace_time(script[2] + "(" + string(depth) + ")");
	}
	
	
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
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro  enemy_boss                                                                              (('boss' in self) ? boss : ('intro' in self)) || array_exists([Nothing, Nothing2, BigFish, OasisBoss], object_index)
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#macro  alarm0_run                                                                              alarm0 >= 0 && --alarm0 == 0 && (script_ref_call(on_alrm0) || !instance_exists(self))
#macro  alarm1_run                                                                              alarm1 >= 0 && --alarm1 == 0 && (script_ref_call(on_alrm1) || !instance_exists(self))
#macro  alarm2_run                                                                              alarm2 >= 0 && --alarm2 == 0 && (script_ref_call(on_alrm2) || !instance_exists(self))
#macro  alarm3_run                                                                              alarm3 >= 0 && --alarm3 == 0 && (script_ref_call(on_alrm3) || !instance_exists(self))
#macro  alarm4_run                                                                              alarm4 >= 0 && --alarm4 == 0 && (script_ref_call(on_alrm4) || !instance_exists(self))
#macro  alarm5_run                                                                              alarm5 >= 0 && --alarm5 == 0 && (script_ref_call(on_alrm5) || !instance_exists(self))
#macro  alarm6_run                                                                              alarm6 >= 0 && --alarm6 == 0 && (script_ref_call(on_alrm6) || !instance_exists(self))
#macro  alarm7_run                                                                              alarm7 >= 0 && --alarm7 == 0 && (script_ref_call(on_alrm7) || !instance_exists(self))
#macro  alarm8_run                                                                              alarm8 >= 0 && --alarm8 == 0 && (script_ref_call(on_alrm8) || !instance_exists(self))
#macro  alarm9_run                                                                              alarm9 >= 0 && --alarm9 == 0 && (script_ref_call(on_alrm9) || !instance_exists(self))
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define pround(_num, _precision)                                                        return  (_num == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_num == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_num == 0) ? _num :  ceil(_num / _precision) * _precision;
#define in_range(_num, _lower, _upper)                                                  return  (_num >= _lower && _num <= _upper);
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_add, _max)                                                                  if(walk > 0){ walk -= current_time_scale; motion_add_ct(direction, _add); } if(speed > _max) speed = _max;
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
#define script_bind(_name, _scriptObj, _scriptRef, _depth, _visible)                    return  mod_script_call_nc  ('mod', 'teassets', 'script_bind', _name, _scriptObj, _scriptRef, _depth, _visible);
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
#define instance_seen(_x, _y, _obj)                                                     return  mod_script_call_nc  ('mod', 'telib', 'instance_seen', _x, _y, _obj);
#define instance_near(_x, _y, _obj, _dis)                                               return  mod_script_call_nc  ('mod', 'telib', 'instance_near', _x, _y, _obj, _dis);
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
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc  ('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc  ('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_surface_scale(_surf, _x, _y, _scale)                                               mod_script_call_nc  ('mod', 'telib', 'draw_surface_scale', _surf, _x, _y, _scale);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc  ('mod', 'telib', 'array_exists', _array, _value);
#define array_count(_array, _value)                                                     return  mod_script_call_nc  ('mod', 'telib', 'array_count', _array, _value);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc  ('mod', 'telib', 'array_combine', _array1, _array2);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc  ('mod', 'telib', 'array_delete', _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc  ('mod', 'telib', 'array_delete_value', _array, _value);
#define array_flip(_array)                                                              return  mod_script_call_nc  ('mod', 'telib', 'array_flip', _array);
#define array_shuffle(_array)                                                           return  mod_script_call_nc  ('mod', 'telib', 'array_shuffle', _array);
#define data_clone(_value, _depth)                                                      return  mod_script_call_nc  ('mod', 'telib', 'data_clone', _value, _depth);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc  ('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define scrRight(_dir)                                                                          mod_script_call_self('mod', 'telib', 'scrRight', _dir);
#define scrWalk(_dir, _walk)                                                                    mod_script_call_self('mod', 'telib', 'scrWalk', _dir, _walk);
#define scrAim(_dir)                                                                            mod_script_call_self('mod', 'telib', 'scrAim', _dir);
#define enemy_hurt(_hitdmg, _hitvel, _hitdir)                                                   mod_script_call_self('mod', 'telib', 'enemy_hurt', _hitdmg, _hitvel, _hitdir);
#define enemy_target(_x, _y)                                                            return  mod_script_call_self('mod', 'telib', 'enemy_target', _x, _y);
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
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc  ('mod', 'telib', 'area_border', _y, _area, _color);
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
#define player_create(_x, _y, _index)                                                   return  mod_script_call_nc  ('mod', 'telib', 'player_create', _x, _y, _index);
#define player_swap()                                                                   return  mod_script_call_self('mod', 'telib', 'player_swap');
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc  ('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc  ('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call_self('mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define weapon_get_red(_wep)                                                            return  mod_script_call_self('mod', 'telib', 'weapon_get_red', _wep);
#define skill_get_icon(_skill)                                                          return  mod_script_call_self('mod', 'telib', 'skill_get_icon', _skill);
#define skill_get_avail(_skill)                                                         return  mod_script_call_self('mod', 'telib', 'skill_get_avail', _skill);
#define string_delete_nt(_string)                                                       return  mod_script_call_nc  ('mod', 'telib', 'string_delete_nt', _string);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc  ('mod', 'telib', 'path_create', _xstart, _ystart, _xtarget, _ytarget, _wall);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc  ('mod', 'telib', 'path_shrink', _path, _wall, _skipMax);
#define path_reaches(_path, _xtarget, _ytarget, _wall)                                  return  mod_script_call_nc  ('mod', 'telib', 'path_reaches', _path, _xtarget, _ytarget, _wall);
#define path_direction(_path, _x, _y, _wall)                                            return  mod_script_call_nc  ('mod', 'telib', 'path_direction', _path, _x, _y, _wall);
#define path_draw(_path)                                                                return  mod_script_call_self('mod', 'telib', 'path_draw', _path);
#define portal_poof()                                                                   return  mod_script_call_nc  ('mod', 'telib', 'portal_poof');
#define portal_pickups()                                                                return  mod_script_call_nc  ('mod', 'telib', 'portal_pickups');
#define pet_spawn(_x, _y, _name)                                                        return  mod_script_call_nc  ('mod', 'telib', 'pet_spawn', _x, _y, _name);
#define pet_get_icon(_modType, _modName, _name)                                         return  mod_script_call_self('mod', 'telib', 'pet_get_icon', _modType, _modName, _name);
#define team_get_sprite(_team, _sprite)                                                 return  mod_script_call_nc  ('mod', 'telib', 'team_get_sprite', _team, _sprite);
#define team_instance_sprite(_team, _inst)                                              return  mod_script_call_nc  ('mod', 'telib', 'team_instance_sprite', _team, _inst);
#define sprite_get_team(_sprite)                                                        return  mod_script_call_nc  ('mod', 'telib', 'sprite_get_team', _sprite);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call_self('mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_inst, _charm)                                                   return  mod_script_call_nc  ('mod', 'telib', 'charm_instance', _inst, _charm);
#define motion_step(_mult)                                                              return  mod_script_call_self('mod', 'telib', 'motion_step', _mult);
#define pool(_pool)                                                                     return  mod_script_call_nc  ('mod', 'telib', 'pool', _pool);