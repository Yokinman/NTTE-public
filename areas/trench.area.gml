#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Bind Events:
	global.pit_bind = script_bind("PitDraw", CustomDraw, script_ref_create(draw_pit), object_get_depth(BackCont) + 1, false);
	
	 // Pit Surfaces:
	surfPit        = surface_setup("TrenchPit",        null, null, null);
	surfPitWallTop = surface_setup("TrenchPitWallTop", null, null, null);
	surfPitWallBot = surface_setup("TrenchPitWallBot", null, null, null);
	for(var i = 0; i < 2; i++){
		surfPitSpark[i] = surface_setup(`TrenchPitSpark${i}`, 60, 60, null);
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
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

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
					with(obj_create(x, y, "TopDecalWaterMine")){
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
	
#define area_setup_floor
	if(styleb){
		 // Fix Depth:
		depth = 9;
		
		 // Slippery pits:
		traction = 0.1;
	}
	
	 // Footsteps:
	material = (styleb ? 0 : 4);
	
	 // Check Pits:
	global.floor_num = 0;
	global.floor_min = 0;
	
#define area_start
	 // Enable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, true);
	
	 // Gold Anglers:
	with(instance_random(instances_matching(RadChest, "spr_idle", sprRadChestBig))){
		if(GameCont.norads >= 1){
			GameCont.norads = 0;
			
			 // Ensure Land:
			floor_set_style(0, null);
			with(FloorPit){
				if(instance_near(bbox_center_x, bbox_center_y, other, random_range(64, 96))){
					floor_set(x, y, true);
				}
			}
			floor_reset_style();
			
			 // Friends:
			/*var _num = irandom_range(1, 3) + GameCont.loops;
			with(array_shuffle(FloorPitless)){
				if(_num > 0){
					if(instance_near(bbox_center_x, bbox_center_y, other, 64)){
						if(
							!place_meeting(x, y, Wall)  &&
							!place_meeting(x, y, hitme) &&
							!place_meeting(x, y, chestprop)
						){
							_num--;
							obj_create(bbox_center_x, bbox_center_y, "Angler");
						}
					}
				}
				else break;
			}*/
			
			 // Man of the Hour:
			obj_create(x, y, "AnglerGold");
			instance_delete(id);
		}
	}
	
	/*
	 // Secret:
	if(chance(1, 40) && variable_instance_get(GameCont, "sunkenchests", 0) <= GameCont.loops){
		with(instance_random(WeaponChest)){
			chest_create(x, y, "SunkenChest", true);
			instance_create(x, y, PortalClear);
			instance_delete(id);
		}
	}
	*/
	
	 // Pit Boys:
	if(GameCont.subarea == 3){
		 // Small:
		with(instance_random(Floor)){
			with(pet_spawn(bbox_center_x, bbox_center_y, "Octo")){
				hiding = true;
			}
		}
		
		 // Big:
		var	_x = 10016,
			_y = 10016;
			
		if(false){
			var _spawnFloor = [];
			
			with(Floor) if(distance_to_object(Player) > 96){
				array_push(_spawnFloor, id);
			}
				
			with(instance_random(_spawnFloor)){
				_x = bbox_center_x;
				_y = bbox_center_y;
			}
		}
		
		obj_create(_x + orandom(8), _y + random(8), "PitSquid");
	}
	
	 // Fix Props:
	with(instances_matching_le(prop, "size", 2)){
		if(!instance_is(self, RadChest) && pit_get(x, y)){
			with(array_shuffle(FloorNormal)){
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
				unlock_set("skin:parrot:1", true);
				break;
			}
		}
	}
	
#define area_transit
	 // Disable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, false);
	
	 // Reset Pit:
	pit_clear(false);
	
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
				
			floor_fill(_x + 16, _y + 16, _w, _h, "");
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
		var n = instance_number(FloorMaker);
		if(!chance(22, 19 + n)){
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
			obj_create(_x, _y, (chance(1, 4) ? FireBaller : "CrystalBat"));
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
			obj_create(_x + orandom(4), _y + orandom(4), "Angler");
		}
		
		else{
			if(chance(1, 9)){
				 // Elite Jellies:
				var _eliteChance = 5 * (GameCont.loops + 1);
				if(chance(_eliteChance, 100)){
					with(obj_create(_x, _y, "JellyElite")){
						repeat(3) obj_create(x, y, "Eel");
					}
				}
				
				 // Jellies:
				else{
					obj_create(_x, _y, "Jelly");
					obj_create(_x, _y, "Eel");
				}
			}
			
			 // Random Eel Spawns:
			else if(chance(1, 6)){
				obj_create(_x, _y, "Eel");
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
				obj_create(_x, _y, "EelSkull");
			}
			else{
				obj_create(_x + orandom(8), _y + orandom(8), choose("Kelp", "Kelp", "Vent"));
			}
		}
	}
	
	 // Top Decals:
	if(chance(1, 80)){
		obj_create(x + 16, y + 16, "TopDecal");
	}
	
#define area_pop_extras
	 // The new bandits
	with(instances_matching([WeaponChest, AmmoChest, RadChest], "", null)){
		obj_create(x, y, "Diver");
	}
	with(Bandit){
		obj_create(x, y, "Diver");
		instance_delete(id);
	}
	
	 // Got too many eels, bro? No problem:
	with(instances_matching(CustomEnemy, "name", "Eel")){
		if(array_length(instances_matching(CustomEnemy, "name", "Eel")) > 8 + (4 * GameCont.loops)){
			obj_create(x, y, "WantEel");
			instance_delete(id);
		}
		else break;
	}
	
#define area_effect
	alarm0 = irandom_range(30, 50);
	
	 // Pet Bubbles:
	if(chance(1, 4) && instance_exists(CustomHitme)){
		var _inst = instances_matching(CustomHitme, "name", "Pet");
		if(array_length(_inst)) with(_inst){
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
			with(instance_random(instances_seen(Floor, 0, 0, i))){
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
		var _inst = instances_matching([WepPickup, chestprop, RadChest], "speed", 0);
		if(array_length(_inst)) with(_inst){
			if(pit_get(x, bbox_bottom)){
				var	_x = x + cos((current_frame + x + y) / 10) * 0.15,
					_y = y + sin((current_frame + x + y) / 10) * 0.15;
					
				if(!place_meeting(_x, y, Wall)) x = _x;
				if(!place_meeting(x, _y, Wall)) y = _y;
			}
		}
		
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
				if(speed <= 0){
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
				if(speed <= 0){
					trenchpit_check = true;
				}
				if(pit_get(x, bbox_bottom)){
					pit_sink(x, y, sprite_index, image_index, image_xscale, image_yscale, image_angle, direction, speed, orandom(1));
					instance_destroy();
				}
			}
		}
		
		 // Destroy PitSink Objects, Lag Helper:
		var	_max  = 80,
			_inst = instances_matching(CustomObject, "name", "PitSink");
			
		if(array_length(_inst) > _max){
			with(array_slice(_inst, _max, array_length(_inst) - _max)){
				instance_destroy();
			}
		}
	}
	
#define ntte_end_step
	 // Update Pit Grid:
	if(instance_exists(Floor) && !instance_exists(GenCont)){
		if(global.floor_num != instance_number(Floor) || global.floor_min < Floor.id){
			global.floor_num = instance_number(Floor);
			global.floor_min = GameObject.id;
			
			var	_pits  = FloorPit,
				_floor = FloorPitless;
				
			 // Pits:
			with(instances_matching_ne(_pits, "trenchpit_check", true)){
				trenchpit_check = true;
				for(var _x = bbox_left; _x < bbox_right + 1; _x += 16){
					for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 16){
						if(!position_meeting(_x + 8, _y + 8, Wall) && !array_length(instances_at(_x + 8, _y + 8, _floor))){
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
#define pit_sink(_x, _y, _spr, _img, _xsc, _ysc, _ang, _dir, _spd, _rot)
	with(instance_create(_x, _y, CustomObject)){
		name = "PitSink";
		
		 // Visual:
		sprite_index = _spr;
		image_index = _img;
		image_xscale = _xsc;
		image_yscale = _ysc;
		image_angle = _ang;
		image_speed = 0;
		visible = false;
		
		 // Vars:
		if(_dir == 0) direction = random(360);
		else direction = _dir;
		speed = max(_spd, 1);
		friction = 0.01;
		rotspeed = _rot;
		
		on_step = pit_sink_step;
		
		return id;
	}
	
#define pit_sink_step
	 // Blackness Consumes:
	image_blend = merge_color(image_blend, c_black, 0.05 * current_time_scale);
	
	 // Shrink into Abyss:
	var d = random_range(0.001, 0.01) * current_time_scale
	image_xscale -= sign(image_xscale) * d;
	image_yscale -= sign(image_yscale) * d;
	if(vspeed < 0) vspeed *= 0.9;
	y += 1/3 * current_time_scale;
	
	 // Spins:
	direction += rotspeed * current_time_scale;
	image_angle += rotspeed * current_time_scale;
	
	 // He gone:
	if(abs(image_xscale) < 2/3){
		instance_destroy();
	}
	
#define draw_pit
	if(lag) trace_time();
	
	var	_vx             = view_xview_nonsync,
		_vy             = view_yview_nonsync,
		_vw             = game_width,
		_vh             = game_height,
		_surfX          = pfloor(_vx, _vw),
		_surfY          = pfloor(_vy, _vh),
		_surfW          = _vw * 2,
		_surfH          = _vh * 2,
		_surfScaleMain  = option_get("quality:main"),
		_surfScaleMinor = option_get("quality:minor"),
		_surfPit        = surface_setup("TrenchPit",        _surfW, _surfH, _surfScaleMain),
		_surfPitWallTop = surface_setup("TrenchPitWallTop", _surfW, _surfH, _surfScaleMain),
		_surfPitWallBot = surface_setup("TrenchPitWallBot", _surfW, _surfH, _surfScaleMinor),
		_surfSpark      = surfPitSpark;
		
	for(var i = 0; i < array_length(_surfSpark); i++){
		surface_setup(_surfSpark[i].name, null, null, _surfScaleMinor);
	}
	
	 // Pit Walls:
	with([_surfPitWallTop, _surfPitWallBot]){
		if(reset || x != _surfX || y != _surfY){
			reset = false;
			x = _surfX;
			y = _surfY;
			
			var _surfScale = scale;
			
			 // Draw Pit Walls:
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			
			var _inst = [
				instances_matching_ne(FloorNormal,        "sprite_index", spr.FloorTrenchB), // Normal
				instances_matching_ne([Wall, FloorExplo], "sprite_index", spr.FloorTrenchB)  // Small
			];
			
			with(draw){
				for(var j = 0; j < array_length(self); j++){
					var _spr = self[j];
					if(array_length(_inst[j])){
						with(_inst[j]){
							draw_sprite_ext(_spr, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
						}
					}
				}
			}
			
			surface_reset_target();
		}
	}
	
	 // Pit:
	with(_surfPit){	
		var _surfScale = scale;
		
		surface_set_target(surf);
		
		 // Pit Mask:
		if(reset || x != _surfX || y != _surfY){
			reset = false;
			x = _surfX;
			y = _surfY;
			
			 // Clear:
			draw_clear_alpha(0, 0);
			draw_set_color(c_black);
			
			 // Draw Pit Floors:
			var _inst = instance_rectangle_bbox(x, y, x + w, y + h, instances_matching(FloorPit, "visible", true));
			if(array_length(_inst)) with(_inst){
				draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
			}
			
			 // Cut Out Non-Pit Floors:
			var _inst = instance_rectangle_bbox(x, y, x + w, y + h, instances_matching_le(instances_matching(FloorPitless, "visible", true), "depth", 8));
			if(array_length(_inst)){
				draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
				with(_inst){
					draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
				}
				draw_set_blend_mode(bm_normal);
			}
		}
		
		 // DRAW YOUR PIT SHIT HERE:
		draw_set_color_write_enable(true, true, true, false);
		draw_set_color(c_black/*BackCont.shadcol*/); // long live blue trench
		draw_rectangle(0, 0, w * scale, h * scale, false);
			
			 // Pit Spark:
			var _inst = instances_matching(instances_matching(CustomObject, "name", "PitSpark"), "tentacle_visible", true);
			if(array_length(_inst)) with(_inst){
				var	_sparkRadius = [[25, 20], [20, 10]],
					_sparkBright = (floor(image_index) % 2),
					_sparkNum    = (dark ? 1 : array_length(_surfSpark));
					
				for(var i = 0; i < _sparkNum; i++){
					with(_surfSpark[i]){
						x = other.x - (w / 2);
						y = other.y - (h / 2);
						
						var	_surfSparkScale = scale,
							_x = w * 0.5,
							_y = h * 0.5;
							
						surface_set_target(surf);
						draw_clear_alpha(0, 0);
						
						with(other){
							 // Draw mask:
							draw_set_color_write_enable(true, true, true, true);
							draw_circle(
								_x * _surfSparkScale,
								_y * _surfSparkScale,
								(_sparkRadius[i + dark][_sparkBright] + irandom(1)) * _surfSparkScale,
								false
							);
							draw_set_color_write_enable(true, true, true, false);
							
							 // Draw tentacle:
							var t = tentacle;
							draw_sprite_ext(
								spr.TentacleWheel, 
								i, 
								(_x + lengthdir_x(t.distance, t.move_dir)) * _surfSparkScale, 
								(_y + lengthdir_y(t.distance, t.move_dir)) * _surfSparkScale, 
								image_xscale * _surfSparkScale * t.scale * t.right, 
								image_yscale * _surfSparkScale * t.scale, 
								t.rotation, 
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
				
				for(var i = 0; i < _sparkNum; i++){
					with(_surfSpark[i]){
						draw_surface_scale(
							surf,
							(x - _surfX) * _surfScale,
							(y - _surfY) * _surfScale,
							_surfScale / scale
						);
					}
				}
			}
			
			 // Pit Squid:
			if(instance_exists(CustomEnemy)){
				 // Tentacle Outlines:
				var _inst = instances_seen_nonsync(instances_matching_le(instances_matching(instances_matching(CustomEnemy, "name", "PitSquidArm"), "visible", true), "nexthurt", current_frame), 32, 32);
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
								(x + _ox - _surfX) * _surfScale,
								(y + _oy - _surfY) * _surfScale,
								image_xscale * _surfScale * right,
								image_yscale * _surfScale,
								image_angle,
								image_blend,
								image_alpha * _alpha * 2
							);
						}
					}
					
					 // Outlines:
					draw_set_fog(true, make_color_rgb(235, 0, 67), 0, 0);
					with(_inst){
						for(var d = 0; d <= 180; d += 90){
							draw_sprite_ext(
								sprite_index,
								image_index,
								(x + dcos(d) - _surfX) * _surfScale,
								(y - dsin(d) - _surfY) * _surfScale,
								image_xscale * _surfScale * right,
								image_yscale * _surfScale,
								image_angle,
								image_blend,
								image_alpha * _alpha
							);
						}
					}
					
					draw_set_fog(false, c_white, 0, 0);
				}
				
				 // Pit Squid:
				with(instances_matching(CustomEnemy, "name", "PitSquid")){
					var	_xsc  = image_xscale * max(pit_height, 0) * _surfScale,
						_ysc  = image_yscale * max(pit_height, 0) * _surfScale,
						_ang  = image_angle,
						_col  = merge_color(c_black, image_blend, clamp(pit_height, 0, 1) * (intro ? 1 : 1/3)),
						_alp  = image_alpha,
						_hurt = (nexthurt > current_frame + 3);
						
					 // Eyes:
					with(eye){
						var	_x = (x - _surfX) * _surfScale,
							_y = (y - _surfY) * _surfScale,
							_l = dis * max(other.pit_height, 0) * _surfScale,
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
					
					/// Mouth:
						var	_x = (xpos - _surfX) * _surfScale,
							_y = (ypos - _surfY) * _surfScale;
							
						 // Bite:
						if(bite > 0 && bite <= 1){
							draw_sprite_ext(spr_bite, (1 - bite) * sprite_get_number(spr_bite), _x, _y, _xsc, _ysc, _ang, _col, _alp);
						}
						
						 // Spit:
						else if(spit > 0 && spit <= 1){
							draw_sprite_ext(spr_fire, (1 - spit) * sprite_get_number(spr_fire), _x, _y, _xsc, _ysc, _ang, _col, _alp);
						}
				}
			}
			
			 // Pit Squid Death:
			var _inst = instances_matching(CustomObject, "name", "PitSquidDeath");
			if(array_length(_inst)) with(_inst){
				var	_xsc = image_xscale * max(pit_height, 0) * _surfScale,
					_ysc = image_yscale * max(pit_height, 0) * _surfScale,
					_ang = image_angle,
					_col = merge_color(c_black, image_blend, clamp(pit_height, 0, 1)),
					_alp = image_alpha;
					
				with(eye){
					var	_x = (x - _surfX) * _surfScale,
						_y = (y - _surfY) * _surfScale,
						l = dis * max(other.pit_height, 0) * _surfScale,
						d = dir;
						
					with(other){
						if(explo){
							draw_set_fog(((current_frame % 6) < 2 || (!sink && pit_height < 1)), _col, 0, 0);
							draw_sprite_ext(spr.PitSquidCornea, image_index, _x,                                    _y,                                    _xsc,       _ysc, _ang, _col, _alp);
							draw_sprite_ext(spr.PitSquidPupil,  image_index, _x + lengthdir_x(l * image_xscale, d), _y + lengthdir_y(l * image_yscale, d), _xsc * 0.5, _ysc, _ang, _col, _alp);
							draw_set_fog(false, 0, 0, 0);
						}
						draw_sprite_ext(spr.PitSquidEyelid, (explo ? 0 : sprite_get_number(spr.PitSquidEyelid) - 1), _x, _y, _xsc, _ysc, _ang, _col, _alp);
					}
				}
			}
			
			 // Octo pet:
			if(instance_exists(CustomHitme)){
				var _inst = instances_matching(instances_matching(instances_matching(CustomHitme, "name", "Pet"), "pet", "Octo"), "hiding", true);
				if(array_length(_inst)) with(_inst){
					draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, visible);
				}
			}
			
			 // Pit Walls:
			with(_surfPitWallBot){
				draw_surface_scale(
					surf,
					(x - _surfX) * _surfScale,
					(y - _surfY) * _surfScale,
					_surfScale / scale
				);
			}
			
			 // WantEel:
			var _inst = instances_matching(instances_matching(CustomObject, "name", "WantEel"), "visible", true);
			if(array_length(_inst)) with(_inst){
				draw_sprite_ext(
					sprite_index,
					image_index,
					(x - _surfX) * _surfScale,
					((y - _surfY) + (12 * (1 - pit_height))) * _surfScale,
					image_xscale * pit_height * _surfScale,
					image_yscale * pit_height * _surfScale,
					image_angle,
					image_blend,
					image_alpha
				);
			}
			
			 // Make Proto Statues Cooler:
			if(instance_exists(ProtoStatue)){
				with(ProtoStatue){
					if(pit_get(x, bbox_bottom)){
						spr_shadow = -1;
						
						var _spr = ((sprite_index == spr_hurt) ? spr.PStatTrenchHurt : spr.PStatTrenchIdle);
						draw_sprite_ext(_spr,                  image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
						draw_sprite_ext(spr.PStatTrenchLights, anim,        (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
					}
				}
			}
			if(instance_exists(Corpse)){
				var _inst = instances_matching(Corpse, "sprite_index", sprPStatDead);
				if(array_length(_inst)) with(_inst){
					if(pit_get(x, bbox_bottom)){
						var	_spr = spr.PStatTrenchIdle,
							_img = image_index,
							_x   = (x - _surfX) * _surfScale,
							_y   = (y - _surfY) * _surfScale,
							_xsc = image_xscale * _surfScale,
							_ysc = image_yscale * _surfScale,
							_ang = image_angle,
							_col = image_blend,
							_alp = image_alpha;
							
						draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
						
						if(place_meeting(x, y, Portal)){
							_spr = spr.PStatTrenchLights;
							_img = 0;
							
							var	n = instance_nearest(x, y, Portal);
							switch(n.sprite_index){
								case sprPortalSpawn:
								case sprProtoPortal:
									_img = (sprite_get_number(_spr) - 1) - 2 + (2 * sin(current_frame / 16));
									break;
									
								case sprProtoPortalDisappear:
									_img = (sprite_get_number(_spr) - 1) * (1 - (n.image_index / n.image_number));
									break;
									
								default:
									_img = 0;
							}
							
							if(_img > 0){
								draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
							}
						}
					}
				}
			}
			
			 // Stuff that fell in pit:
			var _inst = instances_matching(CustomObject, "name", "PitSink");
			if(array_length(_inst)) with(_inst){
				draw_sprite_ext(sprite_index, image_index, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle, image_blend, image_alpha);
			}
			
			 // Pit Wall Tops:
			with(_surfPitWallTop){
				draw_surface_scale(
					surf,
					(x - _surfX) * _surfScale,
					(y - _surfY) * _surfScale,
					_surfScale / scale
				);
			}
			
		draw_set_color_write_enable(true, true, true, true);
		surface_reset_target();
		
		draw_surface_scale(surf, x, y, 1 / scale);
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
	
#define pit_clear(_bool)
	ds_grid_clear(global.pit_grid, _bool);
	
	 // Set Pit Drawing:
	with(global.pit_bind.id){
		visible = _bool;
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