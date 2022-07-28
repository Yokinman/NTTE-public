#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Store Script References:
	with([pit_get, pit_set, pit_reset, pit_sink]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // Bind Events:
	global.pit_bind = script_bind(CustomDraw, draw_pit, object_get_depth(BackCont) + 1, false);
	
	 // Pit Surfaces:
	surfPit        = call(scr.surface_setup, "TrenchPit",        null, null, null);
	surfPitWallTop = call(scr.surface_setup, "TrenchPitWallTop", null, null, null);
	surfPitWallBot = call(scr.surface_setup, "TrenchPitWallBot", null, null, null);
	for(var i = 0; i < 2; i++){
		surfPitSpark[i] = call(scr.surface_setup, `TrenchPitSpark${i}`, 60, 60, null);
	}
	with(surfPitWallTop) draw = [[spr.PitTop, spr.PitSmallTop]];
	with(surfPitWallBot) draw = [[spr.PitBot, spr.PitSmallBot], [spr.Pit, spr.PitSmall]];
	
	 // Pit Grid:
	global.pit_grid = ds_grid_create(20000/16, 20000/16);
	mod_variable_set("mod", "tetrench", "pit_grid", global.pit_grid);
	with(instances_matching_ne(Floor, "trenchpit_check", null)){
		trenchpit_check = null;
	}
	global.floor_num = 0;
	global.floor_min = 0;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro area_active variable_instance_get(GameCont, "ntte_active_" + mod_current, false) && (GameCont.area == mod_current || GameCont.lastarea == mod_current)
#macro area_visits variable_instance_get(GameCont, "ntte_visits_" + mod_current, 0)

#macro pit_depth global.pit_bind.depth

#macro surfPit        global.surfPit
#macro surfPitWallTop global.surfPitWallTop
#macro surfPitWallBot global.surfPitWallBot
#macro surfPitSpark   global.surfPitSpark

#macro FloorPit     instances_matching   (Floor, "sprite_index", spr.FloorTrenchB)
#macro FloorPitless instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB)

#define area_subarea           return 3;
#define area_goal              return 150;
#define area_next              return [area_city, 1];
#define area_music             return ((GameCont.proto == true) ? mus.TrenchB : mus.Trench);
#define area_music_boss        return mus.PitSquid;
#define area_ambient           return amb101;
#define area_background_color  return make_color_rgb(100, 114, 127);
#define area_shadow_color      return c_black;
#define area_darkness          return true;
#define area_secret            return false;
#define area_underwater        return true;

#define area_name(_subarea, _loops)
	return `@1(${spr.RouteIcon}:0)3-` + string(_subarea);
	
#define area_text
	return choose(
		"IT'S SO DARK",
		"SHADOWS CRAWL",
		"IT'S ELECTRIC",
		"GLOWING",
		"BLUB",
		"SWIM OVER PITS",
		"UNTOUCHED"
	);
	
#define area_mapdata(_lastX, _lastY, _lastArea, _lastSubarea, _subarea, _loops)
	return [
		44 + (9.9 * (_subarea - 1)),
		9,
		(_subarea == 1)
	];
	
#define area_sprite(_spr)
	switch(_spr){
		 // Floors:
		case sprFloor1      : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return spr.FloorTrench;
		case sprFloor1B     : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return spr.FloorTrenchB;
		case sprFloor1Explo : return spr.FloorTrenchExplo;
		case sprDetail1     : return spr.DetailTrench;
		
		 // Walls:
		case sprWall1Bot    : return spr.WallTrenchBot;
		case sprWall1Top    : return spr.WallTrenchTop;
		case sprWall1Out    : return spr.WallTrenchOut;
		case sprWall1Trans  : return spr.WallTrenchTrans;
		case sprDebris1     : return spr.DebrisTrench;
		
		 // Decals:
		case sprTopPot:
			
			 // Water Mine:
			with([self, other]) if(instance_is(self, TopPot)){
				if(chance(1, 6) && distance_to_object(Player) > 128){
					with(call(scr.obj_create, x, y, "TopDecalWaterMine")){
						creator = other;
					}
					return spr.TopDecalTrenchMine;
				}
				break;
			}
			
			return spr.TopDecalTrench;
	}
	
#define area_setup
	goal             = area_goal();
	background_color = area_background_color();
	BackCont.shadcol = area_shadow_color();
	TopCont.darkness = area_darkness();
	
	 // Tunnel Spawn:
	safespawn += 2;
	
#define area_setup_spiral
	 // Surprise Cameo:
	if(chance(1, 6)){
		with(instance_create(x, y, SpiralDebris)){
			sprite_index = spr.KingCrabIdle;
			grow         = 0.1;
			dist        *= 0.8;
		}
	}
	
#define area_setup_floor
	if(styleb){
		 // Fix Depth:
		depth = 9;
		
		 // Slippery pits:
		traction = 0.1;
	}
	
	 // Footsteps:
	material = (styleb ? 0 : 4);
	
#define area_start
	 // Enable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, true);
	
	 // Gold Anglers:
	with(call(scr.instance_random, instances_matching(RadChest, "spr_idle", sprRadChestBig))){
		if(GameCont.norads >= 1){
			GameCont.norads = 0;
			
			 // Ensure Land:
			call(scr.floor_set_style, 0);
			with(FloorPit){
				if(point_distance(bbox_center_x, bbox_center_y, other.x, other.y) < random_range(64, 96)){
					call(scr.floor_set, x, y, true);
				}
			}
			call(scr.floor_reset_style);
			
			 // Friends:
			/*var _num = irandom_range(1, 3) + GameCont.loops;
			with(call(scr.array_shuffle, FloorPitless)){
				if(_num > 0){
					if(point_distance(bbox_center_x, bbox_center_y, other.x, other.y) < 64){
						if(
							!place_meeting(x, y, Wall)  &&
							!place_meeting(x, y, hitme) &&
							!place_meeting(x, y, chestprop)
						){
							_num--;
							call(scr.obj_create, bbox_center_x, bbox_center_y, "Angler");
						}
					}
				}
				else break;
			}*/
			
			 // Man of the Hour:
			call(scr.obj_create, x, y, "AnglerGold");
			instance_delete(self);
		}
	}
	
	/*
	 // Secret:
	if(chance(1, 40) && variable_instance_get(GameCont, "sunkenchests", 0) <= GameCont.loops){
		with(call(scr.instance_random, WeaponChest)){
			call(scr.chest_create, x, y, "SunkenChest", true);
			instance_create(x, y, PortalClear);
			instance_delete(self);
		}
	}
	*/
	
	 // Pit Boys:
	if(GameCont.subarea == 3){
		 // Small:
		with(call(scr.instance_random, Floor)){
			with(call(scr.pet_create, bbox_center_x, bbox_center_y, "Octo")){
				hiding = true;
			}
		}
		
		 // Big:
		var	_x = 10016,
			_y = 10016;
			
		if(false){
			var _spawnFloor = [];
			
			with(Floor) if(distance_to_object(Player) > 96){
				array_push(_spawnFloor, self);
			}
				
			with(call(scr.instance_random, _spawnFloor)){
				_x = bbox_center_x;
				_y = bbox_center_y;
			}
		}
		
		call(scr.obj_create, _x + orandom(8), _y + random(8), "PitSquid");
	}
	
	 // Fix Props:
	with(instances_matching_le(prop, "size", 2)){
		if(!instance_is(self, RadChest) && pit_get(x, y)){
			with(call(scr.array_shuffle, FloorNormal)){
				var	_x = bbox_center_x,
					_y = bbox_center_y;
					
				if(distance_to_object(Player) > 48 && !place_meeting(x, y, Wall) && !pit_get(_x, _y)){
					other.x = _x;
					other.y = _y;
					break;
				}
			}
		}
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
		
		/* fun fact trench used to exit at 4-1 woah
		 // Cursed Caves:
		with(Player) if(curse > 0 || bcurse > 0){
			other.area = area_cursed_caves;
		}
		*/
		
		 // who's that bird? \\
		for(var i = 0; i < maxp; i++){
			if(player_get_race(i) == "parrot"){
				call(scr.unlock_set, "skin:parrot:1", true);
				break;
			}
		}
	}
	
#define area_transit
	 // Disable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, false);
	
	 // Reset Pit:
	pit_reset(false);
	
#define area_make_floor
	var	_x = x,
		_y = y,
		_outOfSpawn = (point_distance(_x, _y, 10000, 10000) > 48);
		
	 // Making Pits:
	styleb = false;
	if(_outOfSpawn){
		var _floorNum = array_length(FloorPitless);
		if(_floorNum >= (1 - (GameCont.subarea * 0.25)) * GenCont.goal){
			styleb = true;
		}
	}
	
	/// Make Floors:
		 // Special - Area Fill
		if(chance(1, 7) && _outOfSpawn){
			var	_w = irandom_range(3, 5),
				_h = 8 - _w;
				
			call(scr.floor_fill, _x + 16, _y + 16, _w, _h);
		}
		
		 // Normal:
		instance_create(_x, _y, Floor);
		
	/// Turn:
		var _trn = 0;
		if(chance(3, 7)){
			_trn = choose(90, -90, 180);
		}
		direction += _trn;
		
	/// Chests & Branching:
		 // Weapon Chests:
		if(_outOfSpawn && _trn == 180){
			instance_create(_x + 16, _y + 16, WeaponChest);
		}
		
		 // Ammo Chests + End Branch:
		if(!chance(22, 19 + instance_number(FloorMaker))){
			if(_outOfSpawn){
				instance_create(_x + 16, _y + 16, AmmoChest);
			}
			instance_destroy();
		}
		
		 // Branch:
		else if(chance(1, 5)){
			instance_create(_x, _y, FloorMaker);
		}
		
	/// Crown Vault:
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
		
#define area_pop_enemies
	var	_x = x + 16,
		_y = y + 16;
		
	 // Loop Spawns:
	if(GameCont.loops > 0 && chance(1, (styleb ? 16 : 6))){
		if(styleb){
			instance_create(_x, _y, LightningCrystal);
		}
		else{
			call(scr.obj_create, _x, _y, (chance(1, 4) ? FireBaller : "CrystalBat"));
		}
		/*
		if(chance(1, 5)){
			instance_create(_x, _y, FireBaller);
		}
		else{
			instance_create(_x, _y, choose(LaserCrystal, Salamander));
		}
		*/
	}
	
	 // Normal:
	else{
		 // Anglers:
		if(!styleb && chance(1, 15)){
			call(scr.obj_create, _x + orandom(4), _y + orandom(4), "Angler");
		}
		
		else{
			if(chance(1, 9)){
				 // Elite Jellies:
				var _eliteChance = 5 * (GameCont.loops + 1);
				if(chance(_eliteChance, 100)){
					with(call(scr.obj_create, _x, _y, "JellyElite")){
						repeat(3) call(scr.obj_create, x, y, "Eel");
					}
				}
				
				 // Jellies:
				else{
					call(scr.obj_create, _x, _y, "Jelly");
					call(scr.obj_create, _x, _y, "Eel");
				}
			}
			
			 // Random Eel Spawns:
			else if(chance(1, 6)){
				call(scr.obj_create, _x, _y, "Eel");
			}
		}
	}
	
#define area_pop_props
	 // Lone Walls:
	if(
		chance(1, (styleb ? 3 : 12)) // higher chance of cover over pits
		&& point_distance(x, y, 10000, 10000) > 96
		&& !place_meeting(x, y, NOWALLSHEREPLEASE)
		&& !place_meeting(x, y, hitme)
	){
		instance_create(x + choose(0, 16), y + choose(0, 16), Wall);
		instance_create(x, y, NOWALLSHEREPLEASE);
	}
	
	 // Prop Spawns:
	else if(chance(1, 16) && !styleb){
		var	_x = x + 16,
			_y = y + 16,
			_spawnDis = point_distance(_x, _y, 10016, 10016);
			
		if(_spawnDis > 48){
			if(chance(1, 10)){
				call(scr.obj_create, _x, _y, "EelSkull");
			}
			else{
				call(scr.obj_create, _x + orandom(8), _y + orandom(8), choose("Kelp", "Kelp", "Vent"));
			}
		}
	}
	
	 // Top Decals:
	if(chance(1, 80)){
		call(scr.obj_create, x + 16, y + 16, "TopDecal");
	}
	
#define area_pop_extras
	 // The new bandits
	with(instances_matching_ne([WeaponChest, AmmoChest, RadChest], "id")){
		call(scr.obj_create, x, y, "Diver");
	}
	with(Bandit){
		call(scr.obj_create, x, y, "Diver");
		instance_delete(self);
	}
	
	 // Got too many eels, bro? No problem:
	with(instances_matching_ne(obj.Eel, "id")){
		if(array_length(instances_matching_ne(obj.Eel, "id")) > 8 + (4 * GameCont.loops)){
			call(scr.obj_create, x, y, "WantEel");
			instance_delete(self);
		}
		else break;
	}
	
#define area_effect
	alarm0 = irandom_range(30, 50);
	
	 // Pet Bubbles:
	if(chance(1, 4) && array_length(obj.Pet)){
		with(instances_matching_ne(obj.Pet, "id")){
			instance_create(x, y, Bubble);
		}
	}
	
	 // Player Bubbles:
	if(chance(1, 4) && instance_exists(Player)){
		with(Player){
			instance_create(x, y, Bubble);
		}
	}
	
	 // Floor Bubbles:
	else for(var i = 0; i < maxp; i++){
		if(player_is_active(i)){
			 // Pick Random Player's Screen:
			do i = irandom(maxp - 1);
			until player_is_active(i);
			
			 // Bubble:
			with(call(scr.instance_random, call(scr.instances_seen, Floor, 0, 0, i))){
				instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Bubble);
			}
			
			break;
		}
	}
	
#define ntte_step
	if(instance_exists(global.pit_bind.id) && global.pit_bind.id.visible){
		 // Player Above Pits:
		if(instance_exists(Player)){
			with(Player){
				var _pit = pit_get(x, bbox_bottom);
				
				 // Do a spin:
				if(_pit && speed < maxspeed - friction){
					var	_x = x + cos(wave / 10) * 0.25 * right,
						_y = y + sin(wave / 10) * 0.25 * right;
						
					if(!place_meeting(_x, y, Wall)) x = _x;
					if(!place_meeting(x, _y, Wall)) y = _y;
				}
				
				 // Pit Transition FX:
				if(speed > 0 && _pit != pit_get(x - hspeed_raw, bbox_bottom - vspeed_raw)){
					repeat(3) with(instance_create(x, y, Smoke)){
						motion_add(other.direction, other.speed / (_pit ? 2 : 3));
						if(!_pit) sprite_index = sprDust;
					}
					sound_play_pitchvol(
						asset_get_index("sndFootPlaRock" + choose("1", "3", "4", "5", "6")),
						0.5 + orandom(0.1),
						(_pit ? 0.8 : 0.5)
					);
				}
			}
		}
		
		 // Floaty Effects Above Pits:
		//if(instance_exists(WepPickup) || instance_exists(chestprop) || instance_exists(RadChest)){ // probably always true
			var _inst = instances_matching([WepPickup, chestprop, RadChest], "speed", 0);
			if(array_length(_inst)) with(_inst){
				if(pit_get(x, bbox_bottom)){
					var	_x = x + cos((current_frame + x + y) / 10) * 0.15,
						_y = y + sin((current_frame + x + y) / 10) * 0.15;
						
					if(!place_meeting(_x, y, Wall)) x = _x;
					if(!place_meeting(x, _y, Wall)) y = _y;
				}
			}
		//}
		
		 // No Props Above Pits:
		if(instance_exists(prop)){
			var _inst = instances_matching_le(instances_matching_gt(prop, "my_health", 0), "size", 2);
			if(array_length(_inst)) with(_inst){
				if(pit_get(x, y)){
					if(
						!instance_is(self, RadChest)      &&
						!instance_is(self, Car)           &&
						!instance_is(self, CarVenus)      &&
						!instance_is(self, CarVenusFixed) &&
						!instance_is(self, CarThrow)
					){
						my_health = 0;
					}
				}
			}
		}
		
		 // Stuff Falling Into Pits:
		if(instance_exists(Corpse)){
			var _inst = instances_matching_ne(instances_matching(instances_matching(Corpse, "trenchpit_check", null), "image_speed", 0), "sprite_index", mskNone, sprPStatDead);
			if(array_length(_inst)) with(_inst){
				if(speed == 0){
					trenchpit_check = true;
				}
				if(pit_get(x, y)){
					pit_sink(x, y, sprite_index, image_index, image_xscale, image_yscale, image_angle, direction, speed, orandom(0.6))
					
					 // Safety Corpse:
					if(!instance_exists(enemy) && !instance_exists(Portal)){
						with(instance_create(x, y, Corpse)){
							sprite_index = mskNone;
						}
					}
					
					instance_destroy();
				}
			}
		}
		if(instance_exists(ChestOpen) || instance_exists(Debris) || instance_exists(Shell) || instance_exists(Feather)){
			var _inst = instances_matching_le(instances_matching([ChestOpen, Debris, Shell, Feather], "trenchpit_check", null), "speed", 1);
			if(array_length(_inst)) with(_inst){
				if(speed == 0){
					trenchpit_check = true;
				}
				if(pit_get(x, bbox_bottom)){
					pit_sink(x, y, sprite_index, image_index, image_xscale, image_yscale, image_angle, direction, speed, orandom(1));
					instance_destroy();
				}
			}
		}
		
		 // Destroy PitSink Objects, Lag Helper:
		var _max = 80;
		if(array_length(obj.PitSink) > _max){
			var _inst = instances_matching_ne(obj.PitSink, "id");
			if(array_length(_inst) > _max){
				with(array_slice(_inst, _max, array_length(_inst) - _max)){
					instance_destroy();
				}
			}
		}
	}
	
#define ntte_end_step
	 // Open Pits:
	if(instance_exists(PortalClear)){
		var _inst = instances_matching_gt(PortalClear, "pit_clear", 0);
		if(array_length(_inst)) with(_inst){
			image_xscale *= pit_clear;
			image_yscale *= pit_clear;
			
			var _instFloor = call(scr.instances_meeting_instance, self, FloorPitless);
			if(array_length(_instFloor)) with(_instFloor){
				if(instance_exists(self) && place_meeting(x, y, other)){
					 // Sound:
					sound_play_pitchvol(sndWallBreak, 0.6 + random(0.4), 1.5);
					
					 // Debris:
					if("pit_smash" in other && other.pit_smash){
						for(var _x = bbox_left; _x < bbox_right + 1; _x += 16){
							for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 16){
								var	_dir = point_direction(other.x, other.y, _x + 8, _y + 8),
									_spd = 8 - (point_distance(other.x, other.y - 16, _x + 8, _y + 8) / 16);
									
								if(chance(2, 3)){
									with(call(scr.obj_create, _x + random_range(4, 12), _y + random_range(4, 12), "TrenchFloorChunk")){
										zspeed    = _spd;
										direction = _dir;
										
										 // Normal Debris:
										if(other.sprite_index != spr.FloorTrench || chance(1, 2)){
											sprite_index = call(scr.area_get_sprite, GameCont.area, sprDebris1);
											zspeed      /= 2;
											zfriction   /= 2;
											debris       = true;
										}
									}
								}
							}
						}
					}
					else repeat(ceil((bbox_width + bbox_height) / 32)){
						instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Debris);
					}
					
					 // Pity:
					call(scr.floor_set_align, null, null, x, y);
					call(scr.floor_set_style, 1, mod_current);
					if(instance_is(self, FloorExplo)){
						with(call(scr.floor_set, x, y, 2)){
							styleb       = true;
							sprite_index = area_sprite(sprFloor1B);
						}
					}
					else call(scr.floor_set, x, y, true);
					call(scr.floor_reset_align);
					call(scr.floor_reset_style);
				}
			}
			
			image_xscale /= pit_clear;
			image_yscale /= pit_clear;
		}
	}
	
	 // Update Pit Grid:
	if(instance_exists(Floor) && !instance_exists(GenCont)){
		if(global.floor_num != instance_number(Floor) || global.floor_min < Floor.id){
			global.floor_num = instance_number(Floor);
			global.floor_min = instance_max;
			
			var	_pits  = FloorPit,
				_floor = FloorPitless;
				
			 // Pits:
			with(instances_matching_ne(_pits, "trenchpit_check", true)){
				trenchpit_check = true;
				for(var _x = bbox_left; _x < bbox_right + 1; _x += 16){
					for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 16){
						if(!position_meeting(_x + 8, _y + 8, Wall) && !array_length(call(scr.instances_meeting_point, _x + 8, _y + 8, _floor))){
							pit_set(_x, _y, true);
						}
					}
				}
			}
			
			 // Non-Pits:
			with(instances_matching_ne(_floor, "trenchpit_check", false)){
				trenchpit_check = false;
				for(var _x = bbox_left; _x < bbox_right + 1; _x += 16){
					for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 16){
						pit_set(_x, _y, false);
					}
				}
			}
		}
	}
	
	
/// PITS
#define draw_pit
	if(lag) trace_time();
	
	var	_vx             = view_xview_nonsync,
		_vy             = view_yview_nonsync,
		_gw             = game_width,
		_gh             = game_height,
		_surfX          = pfloor(_vx, _gw),
		_surfY          = pfloor(_vy, _gh),
		_surfW          = _gw * 2,
		_surfH          = _gh * 2,
		_surfScaleMain  = call(scr.option_get, "quality:main"),
		_surfScaleMinor = call(scr.option_get, "quality:minor"),
		_surfPit        = call(scr.surface_setup, "TrenchPit",        _surfW, _surfH, _surfScaleMain),
		_surfPitWallTop = call(scr.surface_setup, "TrenchPitWallTop", _surfW, _surfH, _surfScaleMain),
		_surfPitWallBot = call(scr.surface_setup, "TrenchPitWallBot", _surfW, _surfH, _surfScaleMinor);
		
	 // Pit Walls:
	with([_surfPitWallTop, _surfPitWallBot]){
		if(reset || x != _surfX || y != _surfY){
			reset = false;
			x     = _surfX;
			y     = _surfY;
			
			 // Draw Pit Walls:
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
				
				var _inst = [
					instances_matching_ne(FloorNormal,        "sprite_index", spr.FloorTrenchB), // Normal
					instances_matching_ne([Wall, FloorExplo], "sprite_index", spr.FloorTrenchB)  // Small
				];
				
				with(draw){
					for(var j = 0; j < array_length(self); j++){
						if(array_length(_inst[j])){
							var _spr = self[j];
							with(_inst[j]){
								draw_sprite(_spr, image_index, x, y);
							}
						}
					}
				}
				
			d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
			surface_reset_target();
		}
	}
	
	 // Pit:
	with(_surfPit){
		 // Pit Mask:
		if(reset || x != _surfX || y != _surfY){
			reset = false;
			x     = _surfX;
			y     = _surfY;
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
				
				 // Draw Pit Floors:
				var _inst = call(scr.instances_meeting_rectangle, x, y, x + w, y + h, instances_matching(FloorPit, "visible", true));
				if(array_length(_inst)){
					with(_inst){
						draw_self();
					}
				}
				
				 // Cut Out Non-Pit Floors:
				var _inst = call(scr.instances_meeting_rectangle, x, y, x + w, y + h, instances_matching_le(instances_matching(FloorPitless, "visible", true), "depth", 8));
				if(array_length(_inst)){
					draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
					with(_inst){
						draw_self();
					}
					draw_set_blend_mode(bm_normal);
				}
				
			d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
			surface_reset_target();
		}
		
		 // DRAW YOUR PIT SHIT HERE:
		surface_set_target(surf);
		d3d_set_projection_ortho(x, y, w, h, 0);
		draw_set_color_write_enable(true, true, true, false);
			
			 // Flatten Pit Mask:
			draw_set_color(c_black /*BackCont.shadcol*/); // long live blue trench
			draw_rectangle(x, y, x + w, y + h, false);
			
			 // Pit Spark:
			if(array_length(obj.PitSpark)){
				var _inst = instances_matching(obj.PitSpark, "tentacle_visible", true);
				if(array_length(_inst)){
					var	_surfSpark   = surfPitSpark,
						_sparkRadius = [[25, 20], [20, 10]];
						
					for(var i = 0; i < array_length(_surfSpark); i++){
						call(scr.surface_setup, _surfSpark[i].name, null, null, _surfScaleMinor);
					}
					
					with(_inst){
						var	_sparkBright = (floor(image_index) % 2),
							_sparkNum    = (dark ? 1 : array_length(_surfSpark));
							
						d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
						
						for(var i = 0; i < _sparkNum; i++){
							with(_surfSpark[i]){
								x = other.x - (w / 2);
								y = other.y - (h / 2);
								
								surface_set_target(surf);
								draw_clear_alpha(c_black, 0);
								d3d_set_projection_ortho(x, y, w, h, 0);
								
								with(other){
									 // Draw mask:
									draw_set_color_write_enable(true, true, true, true);
									draw_circle(x, y, _sparkRadius[i + dark][_sparkBright] + irandom(1), false);
									draw_set_color_write_enable(true, true, true, false);
									
									 // Draw tentacle:
									var _t = tentacle;
									draw_sprite_ext(
										spr.TentacleWheel, 
										i, 
										x + lengthdir_x(_t.distance, _t.move_dir), 
										y + lengthdir_y(_t.distance, _t.move_dir), 
										image_xscale * _t.scale * _t.right, 
										image_yscale * _t.scale, 
										_t.rotation, 
										merge_color(c_black, image_blend,
											visible
											? (image_index / image_number)
											: ((alarm0 > 3) ? 1 : (((current_frame + x + y) / 2) % 2))
										),
										image_alpha
									);
								}
							}
						}
						
						surface_set_target(other.surf);
						d3d_set_projection_ortho(other.x, other.y, other.w, other.h, 0);
						
						for(var i = 0; i < _sparkNum; i++){
							with(_surfSpark[i]){
								call(scr.draw_surface_scale, surf, x, y, 1 / scale);
							}
						}
					}
				}
			}
			
			 // Pit Squid Tentacle Outlines:
			if(array_length(obj.PitSquidArm)){
				var _inst = call(scr.instances_seen_nonsync, instances_matching_le(instances_matching(obj.PitSquidArm, "visible", true), "nexthurt", current_frame), 32, 32);
				if(array_length(_inst)){
					var _alpha = 0.3 + (0.25 * sin(current_frame / 10));
					
					 // Anti-Aliasing:
					draw_set_fog(true, make_color_rgb(24, 21, 33), 0, 0);
					var _oy = -1;
					with(_inst){
						for(var _ox = -1; _ox <= 1; _ox += 2){
							draw_sprite_ext(
								sprite_index,
								image_index,
								x + _ox,
								y + _oy,
								image_xscale * right,
								image_yscale,
								image_angle,
								image_blend,
								image_alpha * _alpha * 2
							);
						}
					}
					
					 // Outlines:
					draw_set_fog(true, make_color_rgb(235, 0, 67), 0, 0);
					with(_inst){
						for(var _dir = 0; _dir <= 180; _dir += 90){
							draw_sprite_ext(
								sprite_index,
								image_index,
								x + dcos(_dir),
								y - dsin(_dir),
								image_xscale * right,
								image_yscale,
								image_angle,
								image_blend,
								image_alpha * _alpha
							);
						}
					}
					
					draw_set_fog(false, c_white, 0, 0);
				}
			}
			
			 // Pit Squid:
			if(array_length(obj.PitSquid)){
				with(instances_matching_ne(obj.PitSquid, "id")){
					var	_xsc  = image_xscale * max(pit_height, 0),
						_ysc  = image_yscale * max(pit_height, 0),
						_ang  = image_angle,
						_col  = merge_color(c_black, image_blend, clamp(pit_height, 0, 1) * (intro ? 1 : 1/3)),
						_alp  = image_alpha,
						_hurt = (nexthurt > current_frame + 3);
						
					 // Eyes:
					with(eye){
						var	_x = x,
							_y = y,
							_l = dis * max(other.pit_height, 0),
							_d = dir;
							
						with(other){
							 // Cornea + Pupil:
							if(_hurt) draw_set_fog(true, _col, 0, 0);
							if(other.blink_img < sprite_get_number(spr.PitSquidEyelid) - 1){
								draw_sprite_ext(spr.PitSquidCornea, image_index, _x,                                      _y,                                      _xsc, _ysc, _ang, _col, _alp);
								draw_sprite_ext(spr.PitSquidPupil,  image_index, _x + lengthdir_x(_l * image_xscale, _d), _y + lengthdir_y(_l * image_yscale, _d), _xsc, _ysc, _ang, _col, _alp);
							}
							if(_hurt) draw_set_fog(false, 0, 0, 0);
							
							 // Eyelid:
							draw_sprite_ext(spr.PitSquidEyelid, other.blink_img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
						}
					}
					
					 // Mouth Bite:
					if(bite > 0 && bite <= 1){
						draw_sprite_ext(spr_bite, (1 - bite) * sprite_get_number(spr_bite), xpos, ypos, _xsc, _ysc, _ang, _col, _alp);
					}
					
					 // Mouth Spit:
					else if(spit > 0 && spit <= 1){
						draw_sprite_ext(spr_fire, (1 - spit) * sprite_get_number(spr_fire), xpos, ypos, _xsc, _ysc, _ang, _col, _alp);
					}
				}
			}
			
			 // Pit Squid Death:
			if(array_length(obj.PitSquidDeath)){
				with(instances_matching_ne(obj.PitSquidDeath, "id")){
					var	_xsc = image_xscale * max(pit_height, 0),
						_ysc = image_yscale * max(pit_height, 0),
						_ang = image_angle,
						_col = merge_color(c_black, image_blend, clamp(pit_height, 0, 1)),
						_alp = image_alpha;
						
					with(eye){
						var	_x = x,
							_y = y,
							_l = dis * max(other.pit_height, 0),
							_d = dir;
							
						with(other){
							if(explo){
								draw_set_fog(((current_frame % 6) < 2 || (!sink && pit_height < 1)), _col, 0, 0);
								draw_sprite_ext(spr.PitSquidCornea, image_index, _x,                                      _y,                                      _xsc,       _ysc, _ang, _col, _alp);
								draw_sprite_ext(spr.PitSquidPupil,  image_index, _x + lengthdir_x(_l * image_xscale, _d), _y + lengthdir_y(_l * image_yscale, _d), _xsc * 0.5, _ysc, _ang, _col, _alp);
								draw_set_fog(false, 0, 0, 0);
							}
							draw_sprite_ext(spr.PitSquidEyelid, (explo ? 0 : sprite_get_number(spr.PitSquidEyelid) - 1), _x, _y, _xsc, _ysc, _ang, _col, _alp);
						}
					}
				}
			}
			
			 // Octo pet:
			if(array_length(obj.Pet)){
				var _inst = instances_matching(instances_matching(instances_matching(obj.Pet, "pet", "Octo"), "hiding", true), "visible", true);
				if(array_length(_inst)){
					with(_inst){
						draw_self_enemy();
					}
				}
			}
			
			 // Pit Walls:
			with(_surfPitWallBot){
				call(scr.draw_surface_scale, surf, x, y, 1 / scale);
			}
			
			 // WantEel:
			if(array_length(obj.WantEel)){
				var _inst = instances_matching(obj.WantEel, "visible", true);
				if(array_length(_inst)){
					with(_inst){
						draw_sprite_ext(
							sprite_index,
							image_index,
							x,
							y + (12 * (1 - pit_height)),
							image_xscale * pit_height,
							image_yscale * pit_height,
							image_angle,
							image_blend,
							image_alpha
						);
					}
				}
			}
			
			 // Make Proto Statues Cooler:
			if(instance_exists(ProtoStatue)){
				with(ProtoStatue){
					if(pit_get(x, bbox_bottom)){
						spr_shadow = -1;
						draw_sprite(((sprite_index == spr_hurt) ? spr.PStatTrenchHurt : spr.PStatTrenchIdle), image_index, x, y);
						draw_sprite(spr.PStatTrenchLights, anim, x, y);
					}
				}
			}
			if(instance_exists(Corpse)){
				var _inst = instances_matching(Corpse, "sprite_index", sprPStatDead);
				if(array_length(_inst)){
					with(_inst){
						if(pit_get(x, bbox_bottom)){
							draw_sprite_ext(spr.PStatTrenchIdle, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
							
							 // Portal Open:
							if(place_meeting(x, y, Portal)){
								var	_spr    = spr.PStatTrenchLights,
									_img    = 0,
									_portal = instance_nearest(x, y, Portal);
									
								if(instance_exists(_portal)){
									switch(_portal.sprite_index){
										case sprPortalSpawn:
										case sprProtoPortal:
											_img = (sprite_get_number(_spr) - 1) - 2 + (2 * sin(current_frame / 16));
											break;
											
										case sprProtoPortalDisappear:
											_img = (sprite_get_number(_spr) - 1) * (1 - (_portal.image_index / _portal.image_number));
											break;
											
										default:
											_img = 0;
									}
								}
								
								if(_img > 0){
									draw_sprite_ext(_spr, _img, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
								}
							}
						}
					}
				}
			}
			
			 // Stuff that fell in pit:
			if(array_length(obj.PitSink)){
				with(instances_matching_ne(obj.PitSink, "id")){
					draw_self();
				}
			}
			
			 // Pit Wall Tops:
			with(_surfPitWallTop){
				call(scr.draw_surface_scale, surf, x, y, 1 / scale);
			}
			
		draw_set_color_write_enable(true, true, true, true);
		d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
		surface_reset_target();
		
		call(scr.draw_surface_scale, surf, x, y, 1 / scale);
	}
	
	if(lag) trace_time(script[2]);
	
#define pit_get(_x, _y)
	_x /= 16;
	_y /= 16;
	
	if(_x >= 0 && _y >= 0 && _x < ds_grid_width(global.pit_grid) && _y < ds_grid_height(global.pit_grid)){
		return global.pit_grid[# _x, _y];
	}
	
	return false;
	
#define pit_set(_x, _y, _bool)
	_x /= 16;
	_y /= 16;
	
	if(_x >= 0 && _y >= 0 && _x < ds_grid_width(global.pit_grid) && _y < ds_grid_height(global.pit_grid)){
		global.pit_grid[# _x, _y] = _bool;
		
		 // Reset Pit Sink Checks:
		with(instances_matching_ne([Corpse, ChestOpen, Debris, Shell, Feather], "trenchpit_check", null)){
			trenchpit_check = null;
		}
	}
	
	 // Reset Pit Surfaces:
	with([surfPit, surfPitWallTop, surfPitWallBot]){
		reset = true;
	}
	
	 // Activate Pit Drawing:
	if(_bool){
		with(global.pit_bind.id){
			visible = true;
		}
	}
	
#define pit_reset(_bool)
	ds_grid_clear(global.pit_grid, _bool);
	
	 // Set Pit Drawing:
	with(global.pit_bind.id){
		visible = _bool;
	}
	
#define pit_sink(_x, _y, _spr, _img, _xsc, _ysc, _ang, _dir, _spd, _rot)
	with(call(scr.obj_create, _x, _y, "PitSink")){
		 // Visual:
		sprite_index = _spr;
		image_index  = _img;
		image_xscale = _xsc;
		image_yscale = _ysc;
		image_angle  = _ang;
		
		 // Vars:
		if(_spd != 0){
			direction = _dir;
		}
		speed     = max(_spd, speed);
		rotspeed  = _rot;
		
		return self;
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