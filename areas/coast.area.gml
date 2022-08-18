#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Bind Events:
	var _seaDepth = object_get_depth(Floor) + 10;
	global.sea_bind = ds_map_create();
	global.sea_bind[? "main"       ] = script_bind(CustomDraw, draw_sea,                                   _seaDepth,                        false);
	global.sea_bind[? "top"        ] = script_bind(CustomDraw, draw_sea_top,                               -1,                               false);
	global.sea_bind[? "visible_max"] = script_bind(CustomDraw, script_ref_create(sea_inst_visible, false), _seaDepth,                        false);
	global.sea_bind[? "visible_min"] = script_bind(CustomDraw, script_ref_create(sea_inst_visible, true),  object_get_depth(SubTopCont) + 1, false);
	
	 // Objects w/ Draw Events:
	var _hasEvent = [Player, CrystalShield, Sapling, Ally, RogueStrike, DogMissile, PlayerSit, UberCont, BackCont, TopCont, KeyCont, GenCont, NothingSpiral, Credits, SubTopCont, BanditBoss, Drama, ScrapBossMissile, ScrapBoss, LilHunter, LilHunterFly, Nothing, NothingInactive, BecomeNothing, Carpet, NothingBeam, Nothing2, FrogQueen, HyperCrystal, TechnoMancer, LastIntro, LastCutscene, Last, DramaCamera, BigFish, ProtoStatue, Campfire, LightBeam, TV, SentryGun, Disc, PlasmaBall, PlasmaBig, Lightning, IonBurst, Laser, PlasmaHuge, ConfettiBall, Nuke, Rocket, RadMaggot, GoldScorpion, MaggotSpawn, BigMaggot, Maggot, Scorpion, Bandit, BigMaggotBurrow, Mimic, SuperFrog, Exploder, Gator, BuffGator, Ratking, GatorSmoke, Rat, FastRat, RatkingRage, MeleeBandit, SuperMimic, Sniper, Raven, RavenFly, Salamander, Spider, LaserCrystal, EnemyLightning, LightningCrystal, EnemyLaser, SnowTank, GoldSnowTank, SnowBot, CarThrow, Wolf, SnowBotCar, RhinoFreak, Freak, Turret, ExploFreak, Necromancer, ExploGuardian, DogGuardian, GhostGuardian, Guardian, CrownGuardianOld, CrownGuardian, Molefish, FireBaller, JockRocket, SuperFireBaller, Jock, Molesarge, Turtle, Van, PopoPlasmaBall, PopoRocket, PopoFreak, Grunt, EliteGrunt, Shielder, EliteShielder, Inspector, EliteInspector, PopoShield, Crab, OasisBoss, BoneFish, InvLaserCrystal, InvSpider, JungleAssassin, FiredMaggot, JungleFly, JungleBandit, EnemyHorror, RainDrop, SnowFlake, PopupText, Confetti, WepPickup, Menu, BackFromCharSelect, CharSelect, GoButton, Loadout, LoadoutCrown, LoadoutWep, LoadoutSkin, CampChar, MainMenu, PlayMenuButton, TutorialButton, MainMenuButton, StatMenu, StatButton, DailyArrow, WeeklyArrow, DailyScores, WeeklyScores, WeeklyProgress, DailyMenuButton, menubutton, BackMainMenu, UnlockAll, IntroLogo, MenuOLDOLD, OptionSelect, MusVolSlider, SfxVolSlider, AmbVolSlider, FullScreenToggle, FitScreenToggle, GamePadToggle, MouseCPToggle, CoopToggle, QToggle, ScaleUpDown, ShakeUpDown, AutoAimUpDown, BSkinLoadout, CrownLoadout, StatsSelect, CrownSelect, DailyToggle, UpdateSelect, CreditsSelect, LoadoutSelect, MenuOLD, Vlambeer, QuitSelect, CrownIcon, SkillIcon, EGSkillIcon, CoopSkillIcon, SkillText, LevCont, mutbutton, PauseButton, GameOverButton, UnlockPopup, UnlockScreen, BUnlockScreen, UnlockButton, OptionMenuButton, VisualsMenuButton, AudioMenuButton, GameMenuButton, ControlMenuButton, CustomObject, CustomHitme, CustomProjectile, CustomSlash, CustomEnemy, CustomDraw, Dispose, asset_get_index("MultiMenu")];
	global.draw_event_exists = [];
	for(var i = 0; object_exists(i); i++){
		array_push(global.draw_event_exists, (array_find_index(_hasEvent, i) >= 0));
	}
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro area_active variable_instance_get(GameCont, "ntte_active_" + mod_current, false) && (GameCont.area == mod_current || GameCont.lastarea == mod_current)
#macro area_visits variable_instance_get(GameCont, "ntte_visits_" + mod_current, 0)

#macro sea_depth global.sea_bind[? "main"].depth

#macro wading_color make_color_rgb(44, 37, 122)

#define area_subarea           return 3;
#define area_goal              return 100;
#define area_next              return ["oasis", 1];
#define area_music             return ((GameCont.proto == true) ? mus.CoastB : mus.Coast);
#define area_music_boss        return mus.SealKing;
#define area_ambient           return amb0b;
#define area_background_color  return make_color_rgb(27, 118, 184);
#define area_shadow_color      return c_black;
#define area_darkness          return false;
#define area_secret            return false;

#define area_name(_subarea, _loops)
	return `@1(${spr.RouteIcon}:0)1-` + string((_subarea <= 0) ? "?" : _subarea);
	
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
	GameCont.ntte_pop_enemies_wait = 0;
	
#define area_setup_floor
	 // Footsteps:
	material = 1;
	
#define area_start
	 // Enable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, true);
	
	 // No Walls:
	if(GameCont.subarea > 0){
		 // Active Sea Drawing:
		with(ds_map_values(global.sea_bind)){
			if(instance_exists(id)){
				id.visible = true;
			}
		}
		with(global.sea_bind[? "main"].id){
			flash = 0;
		}
		
		 // Bind Object Setup Scripts:
		if(lq_get(ntte, "bind_setup_coast_list") == undefined){
			var _objList = [hitme, projectile, Corpse, ChestOpen, chestprop, Pickup, Crown, Debris];
			ntte.bind_setup_coast_list = [
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_coast_wading),    _objList),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_coast_unwall),    [Wall, TopSmall, FloorExplo]),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_coast_Dust),      Dust),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_coast_Explosion), Explosion),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_coast_MeltSplat), MeltSplat),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_coast_Portal),    Portal)
			];
			with(_objList){
				ntte_setup_coast_wading(self);
			}
		}
		
		 // No Walls:
		with(instances_matching(Wall, "area", mod_current)){
			instance_delete(self);
		}
		
		 // Spawn Rock Props:
		with(TopSmall){
			if(chance(1, 80)){
				call(scr.obj_create, bbox_center_x, bbox_center_y, "CoastDecal");
			}
			instance_delete(self);
		}
		
		 // who's that bird?
		call(scr.unlock_set, "race:parrot", true);
	}
	
	 // Subarea-Specific Spawns:
	switch(GameCont.subarea){
		
		case 1: // Shell
			
			with(call(scr.instance_random, Floor)){
				with(call(scr.obj_create, bbox_center_x, bbox_center_y, "CoastBigDecal")){
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
					with(call(scr.pet_create, x, y, "Parrot")){
						perched = other;
						can_take = false;
					}
				}
			}
			
			break;
			
		case 2: // Treasure
			
			if(variable_instance_get(GameCont, "sunkenchests", 0) <= GameCont.loops){
				with(call(scr.instance_random, FloorNormal)){
					with(call(scr.chest_create, bbox_center_x, bbox_center_y, "SunkenChest", true)){
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
			
			with(call(scr.obj_create, 10016, 10016, "Palanking")){
				var	_len = 10,
					_dir = random(360);
					
				while(distance_to_object(Floor) < 160){
					x += lengthdir_x(_len, _dir);
					y += lengthdir_y(_len, _dir);
				}
				enemy_look(_dir + 180);
				xstart = x;
				ystart = y;
			}
			
			break
			
	}
	
	 // Anglers:
	with(RadChest) if(chance(1, 40)){
		call(scr.obj_create, x, y, "Angler");
		instance_delete(self);
	}
	
	 // Reset Floor Surfaces:
	with(call(scr.surface_setup, "CoastFloor", null, null, null)){
		reset = true;
	}
	
#define area_finish
	 // Remember:
	variable_instance_set(GameCont, "ntte_visits_" + mod_current, area_visits + 1);
	
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
	
	 // NT:TE Area Update:
	GameCont.ntte_area_update = true;
	
	 // There Ain't No More Water:
	with(instances_matching_gt(instances_matching(GameObject, "persistent", true), "wading", 0)){
		wading      = 0;
		wading_sink = 0;
	}
	
#define area_make_floor
	var	_x = x,
		_y = y,
		_outOfSpawn = (point_distance(_x, _y, 10000, 10000) > 48);
		
	/// Make Floors:
		 // Special - 4x4 to 6x6 Rounded Fills:
		if(chance(1, 5)){
			call(scr.floor_fill, _x + 16, _y + 16, irandom_range(4, 6), irandom_range(4, 6), "round");
		}
		
		 // Normal - 2x1 Fills:
		else call(scr.floor_fill, _x + 16, _y + 16, 2, 1);
		
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
			if(chance(1, 2) && GameCont.subarea > 0){
				var _dir = direction + 180;
				_x += lengthdir_x(96, _dir);
				_y += lengthdir_y(96, _dir);
				
				with(instance_create(_x, _y, FloorMaker)){
					direction = _dir + choose(-90, 0, 90);
				}
				
				if(_outOfSpawn){
					instance_create(_x + 16, _y + 16, choose(AmmoChest, WeaponChest, RadChest));
				}
			}
		}
		
		 // Ammo Chests + End Branch:
		var _num = instance_number(FloorMaker);
		if(!chance(22, 19 + _num)){
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
		
	if("ntte_pop_enemies_wait" not in GameCont){
		GameCont.ntte_pop_enemies_wait = 0;
	}
	
	if(GameCont.ntte_pop_enemies_wait-- <= 0){
		GameCont.ntte_pop_enemies_wait = 1;
		
		 // Loop Spawns:
		if(GameCont.loops > 0 && chance(1, 3)){
			 // Bushes:
			if(chance(1, 3)){
				with(instance_nearest(x, y, prop)){
					var	_ang = random(360),
						_num = irandom_range(1, 4);
						
					for(var a = _ang; a < _ang + 360; a += (360 / _num)){
						var o = 16 + random(16);
						call(scr.obj_create, x + lengthdir_x(o, a), y + lengthdir_y(o, a), choose("BloomingAssassinHide", "BloomingAssassinHide", "BloomingBush"));
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
			if(styleb){
				call(scr.obj_create, _x + orandom(2), _y - irandom(16), "TrafficCrab");
			}
			else{
				if(chance(max(1, GameCont.subarea), 18)){
					call(scr.obj_create, _x, _y, choose("Pelican", "Pelican", "TrafficCrab"));
				}
				else{
					call(scr.obj_create, _x, _y, choose("Diver", "Gull", "Gull", "Gull", "Gull"));
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
		var _sealNum = array_length(instances_matching_ne(obj.Seal, "id"));
		if(random(2 * _sealNum) < 1){
			if(styleb){
				call(scr.obj_create, _x, _y, ((random(16) < 1) ? "SealHeavy" : "Seal"));
			}
			else repeat(4){
				call(scr.obj_create, _x, _y, "Seal");
			}
		}
	}
	
#define area_pop_props
	var	_x = x + 16,
		_y = y + 16,
		_spawnDis = point_distance(_x, _y, 10016, 10016);
		
	if(chance(1, 12)){
		if(_spawnDis > 48){
			call(scr.obj_create, _x, _y,
				(styleb == 0 && chance(1, 8))
				? "BuriedCar"
				: choose("BloomingCactus", "BloomingCactus", "BloomingCactus", "Palm")
			);
		}
	}
	
	 // Mine:
	else if(GameCont.subarea == 3 && chance(1, 40)){
		with(call(scr.obj_create, _x + orandom(8), _y + orandom(8), "SealMine")){
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
	with(instances_matching_ne([WeaponChest, AmmoChest, RadChest], "id")){
		call(scr.obj_create, x, y, "Diver");
	}
	
	 // Underwater Details:
	with(Floor) if(chance(1, 3)){
		for(var _ang = 0; _ang < 360; _ang += 45){
			var	_x = bbox_center_x,
				_y = bbox_center_y;
				
			if(chance(1, 2) && !position_meeting(_x + lengthdir_x(sprite_get_width(mask_index), _ang), _y + lengthdir_y(sprite_get_height(mask_index), _ang), Floor)){
				var	_l = random_range(32, 44),
					_d = _ang + orandom(20);
					
				_x += lengthdir_x(_l, _d);
				_y += lengthdir_y(_l, _d);
				
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
			with(call(scr.instance_random, call(scr.instances_seen, Floor, 0, 0, i))){
				instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Wind);
			}
			
			break;
		}
	}
	
#define ntte_setup_coast_wading(_inst)
	 // Setup Wading Variables:
	with(_inst){
		if("wading"      not in self) wading      = 0;
		if("wading_wave" not in self) wading_wave = 0;
		if("wading_sink" not in self) wading_sink = 0;
		if("canwade"     not in self) canwade     = true;
	}
	
#define ntte_setup_coast_unwall(_inst)
	 // No Coast Walls:
	with(instances_matching(_inst, "area", mod_current, null)){
		if(visible || object_index != FloorExplo){
			instance_delete(self);
		}
	}
	
	 // Unhide Walls:
	var _instFix = instances_matching(Wall, "visible", false);
	if(array_length(_instFix)){
		with(_instFix){
			visible = true;
		}
	}
	
#define ntte_setup_coast_Dust(_inst)
	 // Watery Dust:
	with(_inst){
		if(!position_meeting(x, y, Floor)){
			if(chance(1, 10 + instance_number(AcidStreak))){
				sound_play_hit(sndOasisCrabAttack, 0.1);
				with(call(scr.fx, x, y, 2, "WaterStreak")){
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
	
#define ntte_setup_coast_Explosion(_inst)
	 // Watery Explosion Sounds:
	with(_inst){
		if(!position_meeting(x, y, Floor)){
			sound_volume(sound_play_hit(sndOasisExplosion, 0.2), 5);
		}
	}
	
#define ntte_setup_coast_MeltSplat(_inst)
	 // Watery Melting Scorch Marks:
	with(_inst){
		if(!position_meeting(x, y, Floor)){
			sound_volume(sound_play_hit(sndOasisExplosionSmall, 0.2), 5);
			repeat((sprite_index == sprMeltSplatBig) ? 16 : 8){
				if(chance(1, 6)) call(scr.fx, x, y, 4, "WaterStreak");
				else instance_create(x, y, Sweat);
			}
			instance_destroy();
		}
	}
	
#define ntte_setup_coast_Portal(_inst)
	 // Underwater Portal Setup:
	with(_inst){
		if(type == 1 && endgame == 100 && image_alpha == 1){
			visible = false;
			sound_stop(sndPortalOpen);
			
			 // Flash Sea:
			with(global.sea_bind[? "main"].id){
				flash = 0;
			}
			
			 // Move to Floor:
			if(alarm0 > 0){
				with(self){
					event_perform(ev_alarm, 0);
				}
			}
			
			 // Move to Sea:
			if(instance_exists(Floor)){
				var	_floorX = 0,
					_floorY = 0;
					
				 // Find Level's Center Position:
				with(Floor){
					_floorX += bbox_center_x;
					_floorY += bbox_center_y;
				}
				_floorX /= instance_number(Floor);
				_floorY /= instance_number(Floor);
				
				 // Move Away from Floors:
				var	_moveDis = 8,
					_moveDir = point_direction(_floorX, _floorY, x, y);
					
				while(distance_to_object(Floor) < 120){
					x += lengthdir_x(_moveDis, _moveDir);
					y += lengthdir_y(_moveDis, _moveDir);
				}
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
			
			xstart    = x;
			ystart    = y;
			xprevious = x;
			yprevious = y;
		}
		alarm0 = -1;
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
		
		 // Weird fix for ultra bolts destroying themselves when not touching a floor:
		if(instance_exists(UltraBolt)){
			if("ntte_coast_ultrabolt_floors" not in GameCont){
				GameCont.ntte_coast_ultrabolt_floors = [];
			}
			with(UltraBolt){
				if(!place_meeting(x, y, Floor)){
					with(instance_create(0, 0, Floor)){
						name       = "UltraBoltCoastFix";
						mask_index = sprBoltTrail;
						x          = other.x;
						y          = other.y;
						xprevious  = x;
						yprevious  = y;
						visible    = false;
						creator    = other;
						array_push(GameCont.ntte_coast_ultrabolt_floors, self);
					}
				}
			}
		}
	}
	
	 // Disable Sea:
	else{
		with(ds_map_values(global.sea_bind)){
			if(instance_exists(id)){
				id.visible = false;
			}
		}
		if(lq_get(ntte, "bind_setup_coast_list") != undefined){
			with(ntte.bind_setup_coast_list){
				call(scr.ntte_unbind, self);
			}
			ntte.bind_setup_coast_list = undefined;
		}
	}
	
#define ntte_step
	 // Ultra Bolt Fix Pt.2:
	if("ntte_coast_ultrabolt_floors" in GameCont && array_length(GameCont.ntte_coast_ultrabolt_floors)){
		with(instances_matching_ne(GameCont.ntte_coast_ultrabolt_floors, "id")){
			instance_delete(self);
		}
		GameCont.ntte_coast_ultrabolt_floors = [];
	}
	
	if(area_active){
		 // Push Stuff to Shore:
		if(instance_exists(Floor)){
			var _instPush = call(scr.array_combine,
				instances_matching(instances_matching_ge(hitme, "wading", 80), "visible", true),
				instances_matching_ge(Pickup, "wading", 80),
				instances_matching_ge(chestprop, "wading", 192)
			);
			if(array_length(_instPush)){
				var _noPortal = !instance_exists(Portal);
				with(_instPush){
					if(_noPortal || (distance_to_object(Portal) > 96 && (object_index != Player || array_length(instances_matching_lt(Portal, "endgame", 100))))){
						if(!instance_is(self, hitme) || (team != 0 && !instance_is(self, prop))){
							var _player = (object_index == Player),
								_target = instance_nearest(x - 16, y - 16, Floor),
								_dir    = point_direction(x, y, _target.x, _target.y),
								_spd    = (_player ? (3 + ((wading - 80) / 16)) : (friction * 3));
								
							motion_add_ct(_dir, _spd);
							
							 // Extra Player Push:
							if(_player && wading > 120){
								if(!array_length(instances_matching_ge(Portal, "endgame", 100))){
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
			_depthMin = global.sea_bind[? "visible_min"].depth,
			_seaInst  = call(scr.array_combine,
				[Debris, Corpse, ChestOpen, chestprop, WepPickup, Crown, Grenade, hitme],
				instances_matching(Pickup, "mask_index", mskPickup),
				obj.ClamShield
			);
			
		_seaInst = instances_matching_le(_seaInst, "depth", _depthMax);
		_seaInst = instances_matching(_seaInst, "visible", true);
		_seaInst = instances_matching(_seaInst, "canwade", true);
		
		if(array_length(_seaInst)){
			var	_z    = -2,
				_wave = current_frame;
				
			//var i = 0;
			
			with(_seaInst){
				 // In Water:
				var _dis = distance_to_object(Floor);
				if(_dis > 4 && depth >= _depthMin){
					if(wading <= 0){
						 // Offset:
						y -= _z;
						if(distance_to_object(Floor) <= 4){
							y += _z;
						}
						
						 // Splash:
						repeat(irandom_range(4, 8)){
							instance_create(x, y, Sweat/*Bubble*/);
						}
						call(scr.sound_play_at, x, y, choose(sndOasisChest, sndOasisMelee), 1.5 + random(0.5));
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
					
					 // Sinking:
					if(wading_sink){
						wading_sink += 0.3 * current_time_scale;
						if(wading > 30){
							y += 0.3 * current_time_scale;
						}
						
						 // Death:
						if(wading_sink >= abs(sprite_height) && !persistent){
							instance_destroy();
							continue;
						}
					}
					
					 // Floating:
					else if(wading > sprite_height){
						wading_wave += 0.1 * (current_time_scale + speed_raw);
						
						var _bob = min(wading / sprite_height, 2) * (cos(wading_wave) / 10) * current_time_scale;
						
						 // Bobbing:
						if(speed == 0){
							y += _bob;
						}
						
						 // Swimming:
						else if(instance_is(self, hitme)){
							if((object_index != Player) || !skill_get(mut_extra_feet)){
								var	_len = _bob * (1 + (1.5 * speed)),
									_dir = direction - 90;
									
								x += lengthdir_x(_len, _dir);
								y += lengthdir_y(_len, _dir);
							}
						}
						
						 // Skipping:
						else y += _bob * (1 + (1.5 * speed));
					}
					else if(wading_wave){
						wading_wave = 0;
					}
					
					//_inst[i++] = [self, y];
				}
				
				 // Out of Water:
				else if(wading > 0){
					wading      = 0;
					wading_sink = 0;
					
					 // Offset:
					y += _z;
					if(distance_to_object(Floor) > 4){
						y -= _z;
					}
					
					 // Sploosh:
					repeat(irandom_range(5, 9)){
						call(scr.fx, x, y, [direction, speed], Sweat);
					}
					call(scr.sound_play_at, x, y, choose(sndOasisChest, sndOasisMelee), 1 + random(0.25));
					
					 // Footprints:
					if(instance_is(self, Player)){
						mod_script_call("mod", "ntte", "footprint_give", 20, background_color, 0.5);
					}
				}
			}
			
			//array_sort_sub(_inst, 1, true);
			_seaInst = instances_matching_gt(_seaInst, "wading", 0);
		}
		
		GameCont.ntte_sea_inst = _seaInst;
		
		 // Corpse Sinking (THE PEAK OF OPTIMIZATION):
		if(instance_exists(Corpse)){
			var _inst = instances_matching_gt(Corpse, "wading", 30);
			if(array_length(_inst)){
				_inst = instances_matching(_inst, "wading_sink", 0);
				if(array_length(_inst)){
					_inst = instances_matching_lt(instances_matching(instances_matching(_inst, "speed", 0), "image_speed", 0), "size", 3);
					if(array_length(_inst)) with(_inst){
						wading_sink = 1;
					}
				}
			}
		}
		
		 // Wading Players:
		var _inst = instances_matching_gt(Player, "wading", 0);
		if(array_length(_inst)) with(_inst){
			 // Move Slower in Water:
			if(roll == 0 && !skill_get(mut_extra_feet)){
				friction = 1;
			}
			
			 // Walk into Sea for Next Level:
			if(instance_exists(Portal)){
				var _nearest = instance_nearest(x, y, Portal);
				if(instance_exists(_nearest)){
					if(_nearest.endgame >= 100){
						if(wading > 120 || !instance_exists(Floor)){
							if(_nearest.type == 1){
								_nearest.x      = x;
								_nearest.y      = y;
								_nearest.xstart = x;
								_nearest.ystart = y;
							}
							else{
								instance_create(x, y, Portal);
							}
						}
					}
					else if(wading_sink >= 0){
						wading_sink += 0.6 * current_time_scale;
					}
				}
			}
		}
		
		 // Spinny Water Shells:
		if(instance_exists(Shell)){
			with(Shell){
				if(!position_meeting(x, y, Floor)){
					y += sin((x + y + current_frame) / 10) * 0.1 * current_time_scale;
				}
			}
		}
		
		 // Explosion debris splash FX:
		if(instance_exists(Explosion)){
			with(Explosion){
				if(chance_ct(1, 5)){
					var	_l = random_range(24, 48),
						_d = random(360);
						
					with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), RainSplash)){
						if(place_meeting(x, y, Floor)){
							instance_destroy();
						}
					}
				}
			}
		}
		
		 // Spinny Underwater Portals:
		if(instance_exists(Portal)){
			var _inst = instances_matching_lt(instances_matching(Portal, "visible", false), "endgame", 100);
			if(array_length(_inst)) with(_inst){
				if(!place_meeting(xstart, ystart, Floor)){
					var	_r = 5 + image_index,
						_c = current_frame;
						
					x = xstart + (cos(_c) * _r);
					y = ystart + (sin(_c) * _r);
					
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
		_gw             = game_width,
		_gh             = game_height,
		_surfScaleTop   = call(scr.option_get, "quality:main"),
		_surfScaleBot   = call(scr.option_get, "quality:minor"),
		_surfFloorExt   = 32,
		_surfFloorW     = (_gw + _surfFloorExt) * 2,
		_surfFloorH     = (_gh + _surfFloorExt) * 2,
		_surfFloor      = call(scr.surface_setup, "CoastFloor", _surfFloorW, _surfFloorH, _surfScaleBot),
		_surfTrans      = call(scr.surface_setup, "CoastTrans", _surfFloorW, _surfFloorH, _surfScaleBot),
		_surfWavesExt   = 8,
		_surfWavesW     = _gw + (_surfWavesExt * 2),
		_surfWavesH     = _gh + (_surfWavesExt * 2),
		_surfWaves      = call(scr.surface_setup, "CoastWaves",    _surfWavesW, _surfWavesH, _surfScaleBot),
		_surfWavesSub   = call(scr.surface_setup, "CoastWavesSub", _surfWavesW, _surfWavesH, _surfScaleBot),
		_surfSwimW      = _gw,
		_surfSwimH      = _gh,
		_surfSwimBot    = call(scr.surface_setup, "CoastSwimBot",    _surfSwimW, _surfSwimH, _surfScaleBot),
		_surfSwimTop    = call(scr.surface_setup, "CoastSwimTop",    _surfSwimW, _surfSwimH, _surfScaleTop),
		_surfSwimTopSub = call(scr.surface_setup, "CoastSwimTopSub", _surfSwimW, _surfSwimH, _surfScaleTop),
		_surfSwimScreen = call(scr.surface_setup, "CoastSwimScreen", _surfSwimW, _surfSwimH, _surfScaleBot);
		
	if(lag) trace_time(script[2] + " Setup");
	
	 // Draw Floors to Surface:
	with(_surfFloor){
		var	_surfX = pfloor(_vx, _gw) - _surfFloorExt,
			_surfY = pfloor(_vy, _gh) - _surfFloorExt;
			
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
			x         = _surfX;
			y         = _surfY;
			floor_num = instance_number(Floor);
			floor_min = instance_max;
			
			 // Draw Floors:
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
			
			var _inst = call(scr.instances_meeting_rectangle, x, y, x + w, y + h, instances_matching(Floor, "visible", true));
			if(array_length(_inst)){
				var _spr = spr.FloorCoast;
				with(instances_matching(_inst, "sprite_index", _spr)){
					draw_self();
				}
				with(instances_matching_ne(_inst, "sprite_index", _spr)){
					var _lastSpr = sprite_index;
					if(mask_index == mskFloor){
						sprite_index = _spr;
					}
					draw_self();
					sprite_index = _lastSpr;
				}
			}
			
			d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
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
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
			
			var _dis = 32;
			
			 // Main Drawing:
			with(_surfFloor){
				call(scr.draw_surface_scale, surf, x, y, 1 / scale);
				for(var _dir = 0; _dir < 360; _dir += 45){
					call(scr.draw_surface_scale, 
						surf,
						x + lengthdir_x(_dis, _dir),
						y + lengthdir_y(_dis, _dir),
						1 / scale
					);
				}
			}
			
			 // Fill in Gaps (Cardinal Directions Only):
			var _inst = call(scr.instances_meeting_rectangle, x - _dis, y - _dis, x + _dis + w, y + _dis + h, instances_matching(Floor, "visible", true));
			if(array_length(_inst)){
				var	_spr           = spr.FloorCoast,
					_floorHide     = instances_matching(Floor, "visible", false),
					_floorHideMask = [];
					
				 // Disable Hitbox of Invisible Floors:
				with(_floorHide){
					array_push(_floorHideMask, mask_index);
					mask_index = mskNone;
				}
				
				 // Fill Gaps:
				for(var _dir = 0; _dir < 360; _dir += 90){
					var	_ox = lengthdir_x(_dis, _dir),
						_oy = lengthdir_y(_dis, _dir);
						
					with(_inst){
						for(var _off = 1; _off <= 5; _off++){
							if(place_meeting(x + (_ox * _off), y + (_oy * _off), Floor)){
								while(_off >= 2){
									var	_x = x + (_ox * _off),
										_y = y + (_oy * _off);
										
									draw_sprite(_spr, (_x + _y) / 32, _x, _y);
									
									_off--;
								}
								break;
							}
						}
					}
				}
				
				 // Restore Hitbox of Invisible Floors:
				var i = 0;
				with(_floorHide){
					mask_index = _floorHideMask[i++];
				}
			}
			
			 // Details:
			if(instance_exists(Detail)){
				var _inst = instances_matching(instances_matching(Detail, "depth", sea_depth + 1), "visible", true);
				if(array_length(_inst)){
					with(_inst){
						draw_self();
					}
				}
			}
			
			d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
			surface_reset_target();
		}
		
		 // Draw:
		call(scr.draw_surface_scale, surf, x, y, 1 / scale);
	}
	
	if(lag) trace_time(script[2] + " Floors");
	
	 // Submerged Rock Decals:
	if(array_length(obj.CoastDecal)){
		with(instances_matching(obj.CoastDecal, "visible", true)){
			var	_hurt = (sprite_index == spr_hurt && image_index < 1);
			if(_hurt) draw_set_fog(true, image_blend, 0, 0);
			draw_sprite_ext(spr_bott, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
			if(_hurt) draw_set_fog(false, 0, 0, 0);
		}
	}
	if(array_length(obj.CoastDecalCorpse)){
		with(instances_matching(obj.CoastDecalCorpse, "visible", true)){
			draw_sprite_ext(spr_bott, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
		}
	}
	
	 // Palanking's Bottom:
	draw_set_fog(true, wading_color, 0, 0);
	if(array_length(obj.Palanking)){
		with(instances_matching(obj.Palanking, "visible", true)){
			draw_sprite_ext(spr_bott, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
		}
	}
	if(array_length(obj.Creature)){
		with(instances_matching(obj.Creature, "visible", true)){
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
			draw_clear_alpha(c_black, 0);
			surface_reset_target();
		}
		
		if("ntte_sea_inst" in GameCont && array_length(GameCont.ntte_sea_inst)){
			 // Copy Screen:
			draw_set_blend_mode_ext(bm_one, bm_zero);
			surface_screenshot(_surfSwimScreen.surf);
			draw_set_blend_mode(bm_normal);
			
			 // Drawing Water Wading Objects:
			var _inst = instances_matching_gt(call(scr.instances_seen, GameCont.ntte_sea_inst, 24, 24), "wading", 0);
			if(array_length(_inst)){
				var	_surfSwimBotSurf     = _surfSwimBot.surf,
					_surfSwimTopSurf     = _surfSwimTop.surf,
					_surfSwimTopX        = _surfSwimTop.x,
					_surfSwimTopY        = _surfSwimTop.y,
					_surfSwimTopSubSurf  = _surfSwimTopSub.surf,
					_surfSwimTopSubScale = _surfSwimTopSub.scale,
					_surfSwimTopSubX     = _surfSwimTopSub.x,
					_surfSwimTopSubY     = _surfSwimTopSub.y,
					_surfSwimTopSubW     = _surfSwimTopSub.w * _surfSwimTopSubScale,
					_surfSwimTopSubH     = _surfSwimTopSub.h * _surfSwimTopSubScale,
					_sprGradient         = spr.WaterGradient;
					
				with(_inst){
					 // Clear Screen:
					draw_clear_alpha(c_black, 0);
					
					 // Call Draw Event:
					if(global.draw_event_exists[object_index]){
						event_perform(ev_draw, 0);
					}
					else draw_self();
					
					 // Sprite Bounding Box:
					var _lastMask = mask_index;
					mask_index = sprite_index;
					
					/// Water Height:
						
						var	_wh    = 2 + ((wading - 16) * 0.2),
							_whMax = min(6, round(bbox_bottom - y) - 2);
							
						 // Clamp Water Height:
						if(_wh > _whMax){
							if(object_index != Player || !instance_exists(Portal)){
								_wh = _whMax;
							}
						}
						
						 // Bobbing:
						if(wading_wave > 0 && (speed == 0 || !instance_is(self, hitme))){
							_wh += min(wading / sprite_height, 2) * sin(wading_wave);
						}
						
					 // Grab Bottom Half:
					if(wading_sink){
						_wh += wading_sink;
						draw_set_alpha(1 - (wading_sink / abs(sprite_height)));
						surface_screenshot(_surfSwimBotSurf);
						draw_set_alpha(1);
					}
					else surface_screenshot(_surfSwimBotSurf);
					
					/// Grab Top Half:
						
						var	_cutX = (x                 - _surfSwimTopSubX) * _surfSwimTopSubScale,
							_cutY = (bbox_bottom - _wh - _surfSwimTopSubY) * _surfSwimTopSubScale;
							
						 // Copy Screen:
						draw_set_blend_mode_ext(bm_one, bm_zero);
						surface_screenshot(_surfSwimTopSubSurf);
						
						 // Cut Off Bottom Half:
						surface_set_target(_surfSwimTopSubSurf);
						draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
							
							 // Gradient (Laser Sights - Awesome):
							draw_sprite_ext(
								_sprGradient,
								0,
								_cutX,
								_cutY,
								((bbox_width  + 40) / 128) * _surfSwimTopSubScale,
								((bbox_height + 40) / 128) * _surfSwimTopSubScale,
								0,
								c_white,
								1
							);
							
							 // Sinking:
							if(wading_sink && _wh > bbox_height / 1.5){
								draw_set_alpha(wading_sink / abs(sprite_height));
								draw_rectangle(0, 0, _surfSwimTopSubW, _surfSwimTopSubH, false);
								draw_set_alpha(1);
							}
							
						draw_set_blend_mode(bm_normal);
						
						 // Top Halfing:
						var	_x = _surfSwimTopSubX - _surfSwimTopX,
							_y = _surfSwimTopSubY - _surfSwimTopY;
							
						surface_set_target(_surfSwimTopSurf);
							
							 // Water Interference Line:
							draw_set_fog(true, c_white, 0, 0);
							draw_surface_part_ext(_surfSwimTopSubSurf, 0, _cutY - 1, _surfSwimTopSubW, 1, _x, _y + _cutY, 1, max(1, _surfSwimTopSubScale), c_white, 0.4);
							draw_set_fog(false, 0, 0, 0);
							
							 // Top Half:
							draw_surface(_surfSwimTopSubSurf, _x, _y);
							
						surface_reset_target();
						
					 // Revert Hitbox:
					mask_index = _lastMask;
				}
			}
			
			 // Unblend Color/Alpha:
			draw_set_blend_mode_ext(bm_one, bm_zero);
			with([_surfSwimBot, _surfSwimTop]){
				if(call(scr.shader_setup, "Unblend", surface_get_texture(surf), [2])){
					call(scr.draw_surface_scale, surf, x, y, 1 / scale);
					shader_reset();
					surface_screenshot(surf);
				}
				
				 // Partial Unblend:
				else{
					call(scr.draw_surface_scale, surf, x, y, 1 / scale);
					draw_set_blend_mode_ext(bm_inv_src_alpha, bm_one);
					surface_screenshot(surf);
					draw_set_color_write_enable(false, false, false, true);
					repeat(3) surface_screenshot(surf);
					draw_set_color_write_enable(true, true, true, true);
					draw_set_blend_mode_ext(bm_one, bm_zero);
				}
			}
			
			 // Redraw Screen:
			with(_surfSwimScreen){
				call(scr.draw_surface_scale, surf, x, y, 1 / scale);
			}
			draw_set_blend_mode(bm_normal);
			
			 // Draw Bottom Halves:
			with(_surfSwimBot){
				draw_set_fog(true, wading_color, 0, 0);
				call(scr.draw_surface_scale, surf, x, y, 1 / scale);
				draw_set_fog(false, 0, 0, 0);
			}
			
			if(lag) trace_time(script[2] + " Wading");
		}
		
	 // Draw Sea:
	draw_set_color(background_color);
	draw_set_alpha(0.6);
	draw_rectangle(_vx, _vy, _vx + _gw, _vy + _gh, false);
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
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			draw_set_fog(true, c_white, 0, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
				
				 // Floors:
				with(_surfFloor){
					call(scr.draw_surface_scale, surf, x, y, 1 / scale);
				}
				
				// PalanKing:
				if(array_length(obj.Palanking)){
					with(instances_matching_le(instances_matching(obj.Palanking, "visible", true), "z", 4)){
						if(!place_meeting(x, y, Floor)){
							draw_sprite_ext(spr_foam, image_index, x, y, image_xscale * right, image_yscale, 0, c_white, 1);
						}
					}
				}
				if(array_length(obj.Creature)){
					with(instances_matching(obj.Creature, "visible", true)){
						draw_sprite_ext(spr_foam, image_index, x, y, image_xscale * right, image_yscale, image_angle, c_white, 1);
					}
				}
				
				 // Rock Decals:
				if(array_length(obj.CoastDecal)){
					with(instances_matching(obj.CoastDecal, "visible", true)){
						draw_sprite_ext(spr_foam, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
					}
				}
				if(array_length(obj.CoastDecalCorpse)){
					with(instances_matching(obj.CoastDecalCorpse, "visible", true)){
						draw_sprite_ext(spr_foam, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
					}
				}
				
			d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
			draw_set_fog(false, 0, 0, 0);
			surface_reset_target();
		}
		
		 // Animate Foam (Part player sees):
		with(_surfWaves){
			x = _surfX;
			y = _surfY;
			
			 // Draw:
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
				
				with([_oRad, _iRad]){
					var _radius = self;
					with(_surfWavesSub){
						for(var _ang = _waveAng; _ang < _waveAng + 360; _ang += 45){
							call(scr.draw_surface_scale, 
								surf,
								x + lengthdir_x(_radius, _ang),
								y + lengthdir_y(_radius, _ang),
								1 / scale
							);
						}
					}
					draw_set_blend_mode(bm_subtract);
				}
				draw_set_blend_mode(bm_normal);
				
			d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
			surface_reset_target();
			
			 // Finished Product, Bro:
			call(scr.draw_surface_scale, surf, x, y, 1 / scale);
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
		draw_rectangle(_vx, _vy, _vx + _gw, _vy + _gh, 0);
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
								call(scr.fx, _x + 16 + orandom(8), _y + 16 + orandom(8), [d + orandom(20), 4], "WaterStreak");
							}
							else instance_create(_x + random(32), _y + random(32), Sweat);
						}
					}
				}
			}
			with(Portal){
				repeat(3) call(scr.fx, x, y, 3, Dust);
			}
		}
		
		flash += current_time_scale;
	}
	
	if(lag) trace_time(script[2] + " Flash");
	
#define draw_sea_top
	if(lag) trace_time();
	
	 // Top Halves of Swimming Objects:
	with(call(scr.surface_setup, "CoastSwimTop", null, null, null)){
		call(scr.draw_surface_scale, surf, x, y, 1 / scale);
	}
	
	if(lag) trace_time(script[2]);
	
#define sea_inst_visible(_visible)
	if("ntte_sea_inst" in GameCont && array_length(GameCont.ntte_sea_inst)){
		if(lag) trace_time();
		
		var _inst = instances_matching_ne(GameCont.ntte_sea_inst, "visible", _visible);
		if(array_length(_inst)) with(_inst){
			visible = _visible;
		}
		
		if(lag) trace_time(script[2] + "(" + string(depth) + ")");
	}
	
	
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