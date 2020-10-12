#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Rooms:
	var L = true;
	room_center = [10000, 10000];
	room_list = [];
	room_type = ds_map_create();
		
		 // SPECIAL Rooms:
		room_type[? "Start"] = {
			w       : 3,
			h       : 3,
			carpet  : 1,
			special : true
		};
		room_type[? "Boss"] = {
			w       : 12,
			h       : 12,
			special : true,
			layout  : [
				[0,0,0,L,L,L,L,L,L,0,0,0],
				[0,0,0,L,L,L,L,L,L,0,0,0],
				[0,0,L,L,L,L,L,L,L,L,0,0],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[L,L,L,L,L,L,L,L,L,L,L,L],
				[0,0,L,L,L,L,L,L,L,L,0,0],
				[0,0,0,L,L,L,L,L,L,0,0,0],
				[0,0,0,L,L,L,L,L,L,0,0,0]
			]
		};
		
		 // SMALL Rooms:
		room_type[? "SmallClutter"] = {
			w : 2,
			h : 2
		};
		room_type[? "MediumClutter"] = {
			w : 3,
			h : 3
		};
		room_type[? "SmallPillars"] = {
			w : 3,
			h : 3
		};
		room_type[? "SmallRing"] = {
			w : 2,
			h : 2
		};
		room_type[? "WideSmallRing"] = {
			w : 3,
			h : 2
		};
		room_type[? "TallSmallRing"] = {
			w : 2,
			h : 3
		};
		room_type[? "MediumRing"] = {
			w      : 3,
			h      : 3,
			layout : [
				[L,L,L],
				[L,0,L],
				[L,L,L]
			]
		};
		room_type[? "Table"] = {
			w : 3,
			h : 3
			// carpet : 2/5
		};
		room_type[? "Toilet"] = {
			w : 3,
			h : 2,
		};
		room_type[? "SmallTriangle"] = {
			h      : 3,
			w      : 3,
			layout : [
				[L,0,0],
				[L,L,0],
				[L,L,L]
			]
		};
		room_type[? "Vault"] = {
			w : 3,
			h : 3
		};
		
		 // LARGE Rooms:
		room_type[? "SmallAtrium"] = {
			w      : 6,
			h      : 6,
			layout : [
				[0,0,L,L,0,0],
				[0,0,L,L,0,0],
				[L,L,L,L,L,L],
				[L,L,L,L,L,L],
				[0,0,L,L,0,0],
				[0,0,L,L,0,0]
			]
		};
		room_type[? "Lounge"] = {
			w      : 5,
			h      : 4,
			layout : [
				[L,L,L,L,L],
				[L,L,L,L,L],
				[L,L,L,L,L],
				[L,0,0,0,L]
			]
		};
		room_type[? "Dining"] = {
			w      : 4,
			h      : 3,
			carpet : 1/3
		};
		room_type[? "Cafeteria"] = {
			w      : 4,
			h      : 6,
			layout : [
				[0,L,0,0],
				[L,L,L,L],
				[L,L,L,L],
				[L,L,L,L],
				[L,L,L,L],
				[L,L,L,L]
			]
		};
		room_type[? "Office"] = {
			w      : 6,
			h      : 4,
			layout : [
				[0,0,L,L,0,0],
				[L,L,L,L,L,L],
				[L,L,L,L,L,L],
				[L,L,L,L,L,L]
			]
		};
		room_type[? "Garage"] = {
			w : 4,
			h : 3
		};
		room_type[? "LargeRing"] = {
			w      : 6,
			h      : 6,
			layout : [
				[L,L,L,L,L,L],
				[L,L,L,L,L,L],
				[L,L,0,0,L,L],
				[L,L,0,0,L,L],
				[L,L,L,L,L,L],
				[L,L,L,L,L,L]
			]
		};
		
	 // Set Room Defaults:
	with(ds_map_values(room_type)){
		var _default = {
			w       : 1,
			h       : 1,
			carpet  : 0,
			special : false
		};
		for(var i = 0; i < lq_size(_default); i++){
			var _key = lq_get_key(_default, i);
			if(_key not in self){
				lq_set(self, _key, lq_get(_default, _key));
			}
		}
	}
	
	 // Carpet Surface:
	//surfCarpet = surface_setup("LairCarpet", 2000, 2000, null);
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro area_active variable_instance_get(GameCont, "ntte_active_" + mod_current, false) && (GameCont.area == mod_current || GameCont.lastarea == mod_current)
#macro area_visits variable_instance_get(GameCont, "ntte_visits_" + mod_current, 0)

#macro room_debug  false
#macro room_list   global.room_list
#macro room_type   global.room_type
#macro room_center global.room_center

//#macro surfCarpet global.surfCarpet

#define area_subarea           return 1;
#define area_goal              return 100;
#define area_next              return [area_scrapyards, 1];
#define area_music             return mus.Lair;
#define area_music_boss        return mus.BigShots;
#define area_ambient           return amb102;
#define area_background_color  return make_color_rgb(160, 157, 75);
#define area_shadow_color      return area_get_shadow_color(area_pizza_sewers);
#define area_fog               return sprFog102;
#define area_darkness          return true;
#define area_secret            return true;

#define area_name(_subarea, _loops)
	return "2-?";
	
#define area_text
	return choose(
		"DON'T PET THEM",
		"SO MANY FLEAS",
		"ITCHY",
		"VENTILATION",
		"THE AIR STINGS"
	);
	
#define area_mapdata(_lastX, _lastY, _lastArea, _lastSubarea, _subarea, _loops)
	return [((_lastArea == "red") ? 27 : _lastX), 9];
	
#define area_sprite(_spr)
	switch(_spr){
		 // Floors:
		case sprFloor1      : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return spr.FloorLair;
		case sprFloor1B     : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return spr.FloorLairB;
		case sprFloor1Explo : return spr.FloorLairExplo;
		case sprDetail1     : return spr.DetailLair;
		
		 // Walls:
		case sprWall1Bot    : return spr.WallLairBot;
		case sprWall1Top    : return spr.WallLairTop;
		case sprWall1Out    : return spr.WallLairOut;
		case sprWall1Trans  : return spr.WallLairTrans;
		case sprDebris1     : return spr.DebrisLair;
		
		 // Decals:
		case sprTopPot      : return spr.TopDecalLair;
		case sprBones       : return spr.WallDecalLair;
	}
	
#define area_setup
	goal             = area_goal();
	background_color = area_background_color();
	BackCont.shadcol = area_shadow_color();
	TopCont.darkness = area_darkness();
	TopCont.fog      = area_fog();
	
	 // No Safespawns:
	safespawn = 0;
	
	 // Rooms:
	room_list = [];
	if(room_debug) script_bind_draw(room_debug_draw, 0);
	
#define area_setup_floor
	 // Fix Depth:
	if(styleb) depth = 8;
	
	 // Footsteps:
	material = (styleb ? 3 : 2);
	
#define area_start
	 // Enable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, true);
	
	 // Delete SpawnWall:
	if(instance_exists(Wall)){
		with(Wall.id){
			if(place_meeting(x, y, Floor) && abs(point_distance(10016, 10016, x, y) - 48) < 12){
				instance_destroy();
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
		
		 // Silver Tongue:
		if("ntte_lairmut" not in self){
			skillpoints++;
			ntte_lairmut = true; // Change this system later if you add secret area mutations
		}
	}
	
#define area_transit
	 // Disable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, false);
	
	 // Debug:
	if(room_debug) GameCont.area = mod_current;
	
	 // Reset Carpet Surface:
	//surfCarpet.reset = true;
	
#define area_make_floor
	var	_x = 10016 - 16,
		_y = 10016 - 16;
		
	room_center = [_x, _y];
	
	 // Remove Starter Floor:
	if(instance_is(id + 1, Floor)){
		instance_delete(id + 1);
	}
	
	 // Spawn Rooms:
	if(array_length(room_list) < floor(4 * (goal / 100))){
		with(array_shuffle(ds_map_keys(room_type))){
			var _name = self;
			if(!room_type[? _name].special){
				room_create(irandom_range(-1, 1), irandom_range(-1, 1), _name);
				break;
			}
		}
	}
	
	 // Build Rooms:
	else{
		var _done = true;
		
		 // Push Rooms Apart:
		do{
			_done = true;
			with(room_list){
				var	_x1 = x - 1,
					_y1 = y - 1,
					_x2 = x + w + 1,
					_y2 = y + h + 1;
					
				with(room_list) if(self != other){
					if(rectangle_in_rectangle(x, y, x + w, y + h, _x1, _y1, _x2, _y2)){
						if(type != "Start"){
							var _dir = pround(point_direction(other.x + (other.w / 2), other.y + (other.h / 2), x + (w / 2), y + (h / 2)), 90);
							if(x + (w / 2) == other.x + (other.w / 2) && y + (h / 2) == other.y + (other.h / 2)){
								_dir = pround(random(360), 90);
							}
							else if(chance(1, 2)){
								_dir += choose(-90, -90, 90, 90, 180);
							}
							
							x += lengthdir_x(1, _dir);
							y += lengthdir_y(1, _dir);
							
							_done = false;
						}
					}
				}
				
				y = min(0 - floor(h / 2), y);
			}
		}
		until (_done || room_debug);
		
		 // Special Rooms:
		if(_done){
			var	_boss = false,
				_strt = false;
				
			with(room_list){
				if(type == "Boss") _boss = true;
				else if(type == "Start") _strt = true;
			}
			
			 // Starting Room:
			if(!_strt){
				var _maxY = 0;
				with(room_list) if(y > _maxY) _maxY = y + floor(h / 2);
				with(room_list) y -= _maxY;
				
				room_create(0, 0, "Start");
				
				_done = false;
			}
			
			 // Boss Room:
			else if(!_boss){
				var	_maxDis = -1,
					_furthest = noone;
					
				with(room_list){
					var _dis = point_distance(0, 0, x + (w / 2), y + (h / 2));
					if(_dis > _maxDis){
						_furthest = self;
						_maxDis = _dis;
					}
				}
				
				with(_furthest){
					room_create(x + sign(x), y + sign(y), "Boss");
				}
				
				_done = false;
			}
		}
		
		if(_done){
			 // Determine Hallway Connections:
			for(var i = 0; i <= 1; i++){
				with(room_list) if(!is_object(link)){
					var _minDis = 10000;
					with(room_list) if(self != other){
						var _dis = point_distance(x + (w / 2), y + (h / 2), other.x + (other.w / 2), other.y + (other.h / 2));
						if(_dis < _minDis && (!is_object(link) || i)){
							other.link = self;
							_minDis = _dis;
						}
					}
					with(link) if(link == other) link = noone;
				}
			}
			
			if(!room_debug || button_pressed(0, "east")){
				 // Make Rooms:
				styleb = false;
				with(room_list){
					for(var _fy = 0; _fy < array_length(layout); _fy++){
						var l = layout[_fy];
						for(var _fx = 0; _fx < array_length(l); _fx++){
							if(l[_fx]){
								array_push(floors, instance_create(_x + ((x + _fx) * 32), _y + ((y + _fy) * 32), Floor));
							}
						}
					}
				}
				
				 // Make Hallways:
				styleb = true;
				with(room_list) with(link){
					var	_fx    = x + floor(w / 2),
						_fy    = y + floor(h / 2),
						_tx    = other.x + floor(other.w / 2),
						_ty    = other.y + floor(other.h / 2),
						_dir   = pround(point_direction(_fx, _fy, _tx, _ty), 90),
						_tries = 100;
						
					while(_tries-- > 0){
						instance_create(_x + (_fx * 32), _y + (_fy * 32), Floor);
						
						 // Turn Corner:
						if(_fx == _tx || _fy == _ty) _dir = point_direction(_fx, _fy, _tx, _ty);
						
						 // End Hallway & Spawn Door:
						for(var _ang = _dir; _ang < _dir + 360; _ang += 90){
							var	_dx = _fx - other.x + lengthdir_x(1, _ang),
								_dy = _fy - other.y + lengthdir_y(1, _ang);
								
							if(point_in_rectangle(_dx, _dy, 0, 0, other.w - 1, other.h - 1)){
								if(other.layout[_dy, _dx]){
									door_create(_x + 16 + (_fx * 32), _y + 16 + (_fy * 32), _ang);
									_tries = 0;
									break;
								}
							}
						}
						
						_fx += lengthdir_x(1, _dir);
						_fy += lengthdir_y(1, _dir);
						if(_fx == _tx && _fy == _ty) break;
					}
				}
				
				 // End Level Gen:
				with(FloorMaker) instance_destroy();
			}
			
			else if(room_debug && button_pressed(0, "west")) room_list = [];
		}
	}
	
#define area_pop_props
	var	_x = x + 16,
		_y = y + 16;
		
	 // Top Decals:
	if(chance(1, 50)){
		obj_create(_x, _y, "TopDecal");
	}
	
#define area_pop_enemies
	var	_x = x + 16,
		_y = y + 16;
		
	 // Loop Spawns:
	if(GameCont.loops > 0 && chance(1, 4)){
		if(styleb) instance_create(_x, _y, BecomeTurret);
		else instance_create(_x, _y, choose(Molesarge, Jock));
	}
	
	 // Rat packs:
	if(!place_meeting(x, y, Wall) && chance(1, 20)){
		repeat(irandom_range(3, 7)) instance_create(_x, _y, Rat);
	}
	
	 // Spawn Cats Underground:
	else if(chance(1, 8)){
		with(obj_create(_x, _y, "Cat")){
			if(chance(1, 2)){
				active = false;
				cantravel = true;
				alarm1 = random_range(30, 900);
			}
		}
	}
	
#define area_pop_extras
	 // Populate Rooms:
	with(room_list){
		room_pop();
		
		// Cat Spawners:
		with(floors) if(instance_exists(self)){
			if(!place_meeting(x, y, Wall) && !place_meeting(x, y, prop)){
				if(
					chance(1, 16) ||
					(
						chance(1, 2) &&
						array_length(instance_rectangle(x - 96, y - 96, x + 96, y + 96, instances_matching(CustomObject, "name", "CatHole"))) <= 0
					)
				){
					obj_create(x + 16, y + 16, "CatHole");
				}
			}
		}
	}
	
	 // Emergency Enemy Reserves:
	var _floors = [];
	with(instances_matching(FloorNormal, "styleb", 0)){
		if(!place_meeting(x, y, Wall)){
			array_push(_floors, id);
		}
	}
	if(array_length(_floors) > 0){
		while(instance_number(enemy) < 24){
			with(instance_random(_floors)){
				create_enemies(bbox_center_x, bbox_center_y, 1);
			}
		}
	}
	
	 // Important Door Stuff:
	with(instances_matching(CustomHitme, "name", "CatDoor")){
		 // Remove Blocking Walls:
		var	_ang = image_angle - (90 * image_yscale);
		with(instances_at(
			x + lengthdir_x(8, _ang) + lengthdir_x(8, image_angle),
			y + lengthdir_y(8, _ang) + lengthdir_y(8, image_angle),
			Wall
		)){
			instance_destroy();
		}
		
		 // Make sure door isn't placed weirdly:
		with(instances_at(bbox_center_x, bbox_bottom - 5, Floor)){
			for(var i = 0; i <= 180; i += 180){
				var a = other.image_angle - 90 + i;
				if(position_meeting(x + lengthdir_x(32, a), y + lengthdir_y(32, a), Floor)){
					instance_delete(other);
					break;
				}
			}
			break;
		}
	}
	
	 // Fix stuck dudes:
	with(enemy) if(place_meeting(x, y, Wall)){
		instance_budge(Wall, -1);
	}
	
	 // Light up specific things:
	with(instances_matching([chestprop, RadChest], "", null)){
		obj_create(x, y - 32, "CatLight");
	}
	with(obj_create(10016, 10016 - 60, "CatLight")){
		w1 = 24;
		w2 = 60;
		h1 = 64;
		h2 = 16;
	}
	
#define area_effect
	alarm0 = irandom_range(1, 120);
	
	for(var i = 0; i < maxp; i++){
		if(player_is_active(i)){
			 // Pick Random Player's Screen:
			do i = irandom(maxp - 1);
			until player_is_active(i);
			
			 // Drip:
			with(instance_random(instances_seen(Floor, 0, 0, i))){
				instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1) - 8, Drip);
			}
			
			break;
		}
	}
	
#define ntte_begin_step
	 // Silver Tongue:
	if(instance_exists(SkillIcon) && "ntte_lairmut" in GameCont && GameCont.ntte_lairmut){
		GameCont.ntte_lairmut = false;
		
		var _skill = "silver tongue";
		if(mod_exists("skill", _skill) && skill_get(_skill) == 0){
			with(LevCont){
				 // Clear:
				with(instances_matching(SkillIcon, "creator", id)){
					if(skill_get_avail(skill)){
						other.maxselect--;
						with(instances_matching_gt(mutbutton, "num", num)){
							num--;
						}
						instance_destroy();
					}
				}
				
				 // Star of the Show:
				with(instance_create(0, 0, SkillIcon)){
					creator = other;
					num     = ++other.maxselect;
					alarm0	= num + 1;
					
					skill = _skill;
					name  = skill_get_name(_skill);
					text  = skill_get_text(_skill);
					mod_script_call("skill", _skill, "skill_button");
				}
			}
		}
	}
	
#define ntte_step
	 // Resprite turrets iam smash brother and i dont want to recode turrets:
	if(instance_exists(Turret)){
		var _inst = instances_matching(Turret, "ntte_lairturret", null);
		if(array_length(_inst)) with(_inst){
			ntte_lairturret = area_active;
			if(ntte_lairturret){
				spr_idle     = spr.LairTurretAppear;
				spr_walk     = spr.LairTurretIdle;
				spr_hurt     = spr.LairTurretHurt;
				spr_dead     = spr.LairTurretDead;
				spr_fire     = spr.LairTurretFire;
				hitid        = [spr_idle, "LAIR TURRET"];
				sprite_index = enemy_sprite;
			}
		}
		var _inst = instances_matching(Turret, "spr_idle", spr.LairTurretAppear);
		if(array_length(_inst)) with(_inst){
			if(anim_end || sprite_index != spr_idle){
				spr_idle = sprTurretAppear;
				with(self){
					event_perform(ev_other, ev_animation_end);
				}
				spr_idle = spr.LairTurretIdle;
				spr_walk = spr.LairTurretIdle;
				spr_hurt = spr.LairTurretHurt;
			}
		}
	}
	if(instance_exists(EnemyBullet1)){
		var _inst = instances_matching(EnemyBullet1, "ntte_lairturret", null);
		if(array_length(_inst)) with(_inst){
			ntte_lairturret = (
				object_index == EnemyBullet1
				&& is_array(hitid)
				&& array_length(hitid) > 1
				&& hitid[1] == "LAIR TURRET"
			);
			if(ntte_lairturret){
				with(projectile_create(x, y, EnemyBullet2, direction, speed)){
					 // Effects:
					with(instance_create(x, y, AcidStreak)){
						sprite_index = spr.AcidPuff;
						image_angle  = other.direction + orandom(30);
						depth        = other.depth - (image_angle >= 180);
						
						with(instance_create(x, y, AcidStreak)){
							motion_set(other.image_angle, 2 + random(2));
							image_angle = direction;
							depth       = other.depth;
						}
					}
					
					 // Sounds:
					sound_play_hit(sndFrogEggSpawn3, 0.4);
				}
				instance_delete(id);
			}
		}
	}
	
/// ROOMS
#define room_create(_x, _y, _type)
	with({}){
		x      = _x;
		y      = _y;
		type   = _type;
		link   = noone;
		floors = [];
		
		 // Grab Room Vars:
		if(ds_map_exists(room_type, type)){
			var _room = room_type[? type];
			for(var i = 0; i < lq_size(_room); i++){
				lq_set(self, lq_get_key(_room, i), lq_get_value(_room, i));
			}
		}
		
		 // Randomize Room:
		else{
			w       = irandom_range(3, 6);
			h       = irandom_range(3, 6);
			carpet  = 1/4;
			special = false;
		}
		
		 // Center:
		x -= floor(w / 2);
		y -= floor(h / 2);
		
		 // Carpet Chance:
		carpeted = chance(carpet, 1);
		
		 // Floor Layout:
		if("layout" not in self){
			layout = [];
			for(var _fy = 0; _fy < h; _fy++){
				for(var _fx = 0; _fx < w; _fx++){
					layout[_fy, _fx] = true;
				}
			}
		}
		
		 // Add:
		array_push(room_list, self);
		
		return self;
	}
	
#define create_enemies(_x, _y, _num)
	var _e = choose("Cat", "Bat");
	repeat(_num + round(random_range(1.5, 2) * GameCont.loops)){
		obj_create(_x, _y, _e);
	}
	
#define room_pop()
	var	_x = room_center[0] + (x * 32), // Left
		_y = room_center[1] + (y * 32), // Top
		_w = w * 32, // Width
		_h = h * 32, // Height
		_cx = _x + (_w / 2), // Center X
		_cy = _y + (_h / 2); // Center Y
		
	switch(type){
		
		/// IMPORTANT ROOMS
		case "Start":
			
			obj_create(_cx, _cy, "SewerRug");
			
			break;
			
		case "Boss":
			
			obj_create(_cx, _cy, "CatHoleBig");
			
			 // Corner Columns:
			instance_create(_x + 80,      _y + 80,      Wall);
			instance_create(_x + _w - 96, _y + 80,      Wall);
			instance_create(_x + 80,      _y + _h - 96, Wall);
			instance_create(_x + _w - 96, _y + _h - 96, Wall);
			
			 // Spawn backup chests
			var	_chest = [RadChest, "CatChest", "BatChest"],
				_dis = 176,
				_dir = pround(random(360), 90);
				
			for(var i = 0; i < array_length(_chest); i++){
				chest_create(
					_cx + lengthdir_x(_dis, _dir + (i * 90)),
					_cy + lengthdir_y(_dis, _dir + (i * 90)),
					_chest[i],
					true
				);
			}
			
			break;
			
		/// SMALL ROOMS
		case "SmallClutter":
			
			 // Props:
			repeat(irandom_range(2, 4)){
				obj_create(
					_cx + orandom(24),
					_cy + orandom(24),
					choose("ChairFront", "ChairSide", "Table", "Cabinet")
				);
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, irandom(3));
			
			break;
			
		case "MediumClutter":
			
			 // Props:
			repeat(irandom_range(2, 6)){
				obj_create(
					_cx + orandom(32),
					_cy + orandom(32),
					choose("ChairFront", "ChairSide", "Table", "Cabinet")
				);
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, irandom(5));
			
			break;
			
		case "SmallPillars":
			
			 // Walls:
			instance_create(_x + 16,      _y + 16,      Wall);
			instance_create(_x + _w - 32, _y + 16,      Wall);
			instance_create(_x + 16,      _y + _h - 32, Wall);
			instance_create(_x + _w - 32, _y + _h - 32, Wall);
			
			 // Enemies:
			create_enemies(_cx, _cy, 1);
			
			break;
			
		case "SmallRing":
		case "WideSmallRing":
		case "TallSmallRing":
		case "MediumRing":
			
			 // Center Walls:
			instance_create(_cx - 16, _cy - 16, Wall);
			instance_create(_cx - 16, _cy,      Wall);
			instance_create(_cx,      _cy - 16, Wall);
			instance_create(_cx,      _cy,      Wall);
			
			 // Enemies:
			switch(type){
				case "WideSmallRing":
					create_enemies(_cx + choose(-32, 32), _cy, 1);
					break;
					
				case "TallSmallRing":
					create_enemies(_cx, _cy + choose(-32, 32), 1);
					break;
			}
			
			break;
			
		case "Table":
			
			 // Props:
			with(obj_create(_cx, _cy, "NewTable")){
				if(chance(4, 5)){
					obj_create(x + orandom(2), y - 18 + orandom(2), "ChairFront");
				}
				obj_create(x, y - 32, "CatLight");
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, 1 + irandom(2));
			
			break;
			
		case "Toilet":
			
			 // Walls:
			for(var _oy = 0; _oy <= 1; _oy++){
				instance_create(_x + 32, _y + (_oy * 16), Wall);
			}
			instance_create(_x + _w - 16, _y + 48, Wall);
			
			 // Props:
			with(obj_create(_x + 16 + orandom(2), _y + 12, "ChairFront")){
				with(obj_create(x, y - 28, "CatLight")){
					w2 = 18;
					h2 = 6;
				}
			}
			
			 // Enemies:
			create_enemies(_x, _y, 1);
			
			break;
			
		case "SmallTriangle":
			
			 // Walls:
			for(_off = 0; _off < min(_w, _h); _off += 32){
				instance_create(_x + _off + 16, _y + _off, Wall);
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, 1 + irandom(1));
			
			break;
			
		case "Vault":
			
			 // Corner Walls:
			instance_create(_x,           _y,           Wall);
			instance_create(_x + _w - 16, _y,           Wall);
			instance_create(_x,           _y + _h - 16, Wall);
			instance_create(_x + _w - 16, _y + _h - 16, Wall);
			
			 // Valuables:
			var	_ang = random(360),
				_num = random_range(2, 4);
				
			for(var d = _ang; d < _ang + 360; d += (360 / _num)){
				var	l = random(24),
					_px = _cx + lengthdir_x(l, d),
					_py = _cy + lengthdir_y(l, d);
					
				if(chance(1, 4)){
					chest_create(_px, _py, "PizzaChest", true);
				}
				else obj_create(_px, _py, choose("PizzaStack", "PizzaStack", MoneyPile));
			}
			
			 // Center Floor:
			with(instances_at(_cx, _cy, floors)){
				sprite_index = sprFloor102B;
				material = 6;
			}
			
			break;
			
		/// LARGE ROOMS
		case "SmallAtrium":
			
			 // Walls:
			for(var _ox = -40; _ox <= 40; _ox += 80){
				for(var _oy = -40; _oy <= 40; _oy += 80){
					instance_create(_cx + _ox - 8,                    _cy + _oy - 8,                    Wall);
					instance_create(_cx + _ox - 8 - (16 * sign(_ox)), _cy + _oy - 8,                    Wall);
					instance_create(_cx + _ox - 8,                    _cy + _oy - 8 - (16 * sign(_oy)), Wall);
				}
			}
			
			 // Center Walls:
			instance_create(_cx - 16, _cy - 16, Wall);
			instance_create(_cx - 16, _cy,      Wall);
			instance_create(_cx,      _cy - 16, Wall);
			instance_create(_cx,      _cy,      Wall);
			
			 // Enemies & Lights:
			for(var d = 0; d <= 360; d += 90){
				var	_ox = _cx + lengthdir_x((_w / 2) - 24, d),
					_oy = _cy + lengthdir_y((_h / 2) - 24, d);
					
				create_enemies(_ox, _oy, 1 + irandom(1));
				
				 // Lights:
				with(obj_create(_ox, _oy - 44, "CatLight")){
					h1 = 48;
				}
			}
			
			break;
			
		case "Lounge":
			
			 // Walls:
			instance_create(_x + 32,      _y,           Wall);
			instance_create(_x + 32,      _y + _h - 48, Wall);
			instance_create(_x + _w - 48, _y,           Wall);
			instance_create(_x + _w - 48, _y + _h - 48, Wall);
			
			 // Props:
			with(obj_create(_cx + orandom(2), _y + 16 + orandom(2), "Couch")){
				obj_create(x + orandom(2), y + 20 + orandom(2), "NewTable");
			}
			
			 // Enemies:
			create_enemies(_cx, _y + 16, 2);
			
			break;
			
		case "Dining":
			
			 // Props:
			with(obj_create(_cx, _cy, "NewTable")){
				for(var _side = -1; _side <= 1; _side += 2){
					with(obj_create(x + (24 * _side), y + orandom(2), "ChairSide")){
						image_xscale = _side;
					}
					obj_create(x + (12 * _side), y - 18 + orandom(2), "ChairFront");
				}
				obj_create(x, y - 32, "CatLight");
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, 1 + irandom(1));
			
			break;
			
		case "Cafeteria":
			
			 // Walls:
			for(var _oy = 1; _oy <= 2; _oy++){
				instance_create(_x,           _y + (_oy * 16) + 32,      Wall);
				instance_create(_x + _w - 16, _y + (_oy * 16) + 32,      Wall);
				instance_create(_x,           _y - (_oy * 16) + _h - 16, Wall);
				instance_create(_x + _w - 16, _y - (_oy * 16) + _h - 16, Wall);
			}
			
			/// Props:
				
				 // Vending machine:
				with(instance_create(_x + 48, _y + 16, SodaMachine)){
					spr_idle = spr.SodaMachineIdle;
					spr_hurt = spr.SodaMachineHurt;
					spr_dead = spr.SodaMachineDead;
					sprite_index = spr_idle;
				}
				
				 // Tables & Chairs:
				for(var _oy = 80; _oy < _h - 32; _oy += 32){
					with(obj_create(_cx + orandom(2), _y + _oy + orandom(2), "NewTable")){
						 // Chairs:
						for(var _side = -1; _side <= 1; _side += 2){
							if(chance(2, 5)){
								with(obj_create(x + (20 * _side) + orandom(2), y + orandom(2), "ChairSide")){
									image_xscale = _side;
								}
							}
						}
						if(chance(2, 5)){
							obj_create(x + orandom(2), y - 14 + orandom(2), "ChairFront");
						}
						
						 // Lights:
						if(chance(2, 3)){
							obj_create(x, y - 32, "CatLight");
						}
					}
				}
				
			 // Enemies:
			create_enemies(_cx, _cy, 3 + irandom(1));
			
			break;
			
		case "Office":
			
			 // Walls:
			instance_create(_x + 16,      _y + 32,      Wall);
			instance_create(_x + _w - 32, _y + 32,      Wall);
			instance_create(_x + 16,      _y + _h - 16, Wall);
			instance_create(_x + _w - 32, _y + _h - 16, Wall);
			
			 // Props:
			with(obj_create(_cx + orandom(2), _y + 26 + orandom(2), "NewTable")){
				obj_create(
					x + orandom(4),
					y - 16 + orandom(2),
					choose("ChairFront", "ChairFront", "ChairSide")
				);
				
				 // Cabinets:
				for(var _side = -1; _side <= 1; _side += 2){
					obj_create(_cx + (_side * ((_w / 2) - 48)), _y + 42 + orandom(2), "Cabinet");
				}
				
				 // Light:
				obj_create(x, y - 30, "CatLight");
			}
			
			 // Enemies:
			create_enemies(_cx, _cy, 1 + irandom(1));
			
			break;
			
		case "Garage":
			
			 // Walls:
			instance_create(_cx - 16, _y,           Wall);
			instance_create(_cx,      _y,           Wall);
			instance_create(_cx - 16, _y + _h - 16, Wall);
			instance_create(_cx,      _y + _h - 16, Wall);
			
			/// Props:
				
				 // Cars:
				for(var _oy = 32; _oy < _h; _oy += 32){
					instance_create(_x + 32 + orandom(2), _y + _oy + orandom(2), Car);
				}
				
				 // Tires:
				repeat(2){
					instance_create(
						_cx + irandom_range(24, (_w / 2) - 10),
						_y  + irandom_range(16, _h - 24),
						(chance(1, 10) ? choose("ChairFront", "ChairSide") : Tires)
					);
				}
				
				 // Lights:
				for(var _side = -1; _side <= 1; _side += 2){
					obj_create(_cx + (((_w / 2) - 24) * _side), _cy - 32, "CatLight");
				}
				
			 // Enemies:
			create_enemies(_cx, _cy, 1);
			
			break;
			
		case "LargeRing":
			
			 // Walls:
			instance_create(_cx - 32, _cy - 32, Wall);
			instance_create(_cx - 32, _cy + 16, Wall);
			instance_create(_cx + 16, _cy - 32, Wall);
			instance_create(_cx + 16, _cy + 16, Wall);
			
			 // Enemies:
			create_enemies(_cx - 64, _cy - 64, 1);
			create_enemies(_cx + 64, _cy - 64, 1);
			create_enemies(_cx - 64, _cy + 64, 1);
			create_enemies(_cx + 64, _cy + 64, 1);
			
			break;
	}
	
#define draw_rugs
	if(!instance_exists(GenCont)){
		with(surface_setup("LairCarpet", null, null, 1)){
			x = room_center[0] - (w / 2);
			y = room_center[1] - (h / 2);
			
			 // Setup Carpets:
			if(reset){
				reset = false;
				
				surface_set_target(surf);
				draw_clear_alpha(0, 0);
				
				with(room_list) if(carpeted){
					var	_o = 32,
						_s = spr.Rug,
						_i = 8,
						_c = [
							choose(make_color_rgb(77, 49, 49), make_color_rgb(46, 56, 41)),
							choose(make_color_rgb(160, 75, 99), make_color_rgb(214, 134, 5))
						];
						
					for(var n = 0; n < array_length(_s); n++){
						draw_set_fog(true, _c[n], 0, 0);
						
						for(var xx = 0; xx < w; xx++){
							for (var yy = 0; yy < h; yy++){
								if(
									(yy > 0 && yy < h - 1) &&
									(xx > 0 && xx < w - 1)
								){
									_i = 8;
								}
								else{
									if(yy <= 0){
										if(xx <= 0) _i = 3;
										else{
											if(xx >= w - 1) _i = 1;
											else _i = 2;
										}
									}
									else if(yy >= h - 1){
										if(xx <= 0) _i = 5;
										else{
											if(xx >= w - 1) _i = 7;
											else _i = 6;
										}
									}
									else{
										if(xx <= 0) _i = 4;
										else{
											if(xx >= w - 1) _i = 0;
										}
									}
								}
								
								with(other){ // cant call draw_sprite in lightweight object, sad
									draw_sprite(_s[n], _i, room_center[0] + ((other.x + xx) * _o) - x, room_center[1] + ((other.y + yy) * _o) - y);
								}
							}
						}
					}
				}
				
				draw_set_fog(false, c_white, 0, 0);
				
				surface_reset_target();
			}
			
			 // Draw:
			draw_surface(surf, x, y);
		}
	}
	
#define room_debug_draw
	if(instance_exists(GenCont)){
		depth = GenCont.depth - 1;
		
		draw_set_projection(0);
		
		draw_set_color(c_black);
		draw_rectangle(0, 0, game_width, game_height, 0);
		
		var	_o = 4,
			_x = game_width / 2,
			_y = game_height / 2;
			
		 // Hallways:
		draw_set_color(c_dkgray);
		with(room_list){
			if(is_object(link)) with(link){
				var	_fx = x + floor(w / 2),
					_fy = y + floor(h / 2),
					_tx = other.x + floor(other.w / 2),
					_ty = other.y + floor(other.h / 2),
					_dir = pround(point_direction(_fx, _fy, _tx, _ty), 90),
					_tries = 100;
					
				while(_tries-- > 0){
					if(_fx == _tx || _fy == _ty){
						_dir = point_direction(_fx, _fy, _tx, _ty); // Turn Corner
					}
					
					draw_set_color(c_dkgray);
					draw_rectangle(_x + (_fx * _o), _y + (_fy * _o), _x + (_fx * _o) + _o - 1, _y + (_fy * _o) + _o - 1, 0);
					
					 // End Hallway & Spawn Door:
					for(var a = 0; a < 360; a += 90){
						var	_dx = _fx - other.x + lengthdir_x(1, a),
							_dy = _fy - other.y + lengthdir_y(1, a);
							
						if(point_in_rectangle(_dx, _dy, 0, 0, other.w - 1, other.h - 1)){
							if(other.layout[_dy, _dx]){
								draw_set_color(c_orange);
								draw_rectangle(_x + (_fx * _o), _y + (_fy * _o), _x + (_fx * _o) + _o - 1, _y + (_fy * _o) + _o - 1, 0);
								_tries = 0;
							}
						}
					}
					
					_fx += lengthdir_x(1, _dir);
					_fy += lengthdir_y(1, _dir);
					if(_fx == _tx && _fy == _ty) break;
				}
				/*var	_lx1 = _x + ((x + floor(w / 2)) * _o),
					_ly1 = _y + ((y + floor(h / 2)) * _o),
					_lx2 = _x + ((other.x + floor(other.w / 2)) * _o),
					_ly2 = _y + ((other.y + floor(other.h / 2)) * _o),
					_dir = pround(point_direction(_lx1, _ly1, _lx2, _ly2), 90),
					_mx = 0,
					_my = 0;
					
				if(_dir == 0 || _dir == 180){
					_mx = _lx1;
					_my = _ly2;
					if(_lx1 > _lx2) _lx1 += _o;
					//draw_set_color((_lx2 < _lx1) ? c_purple : c_blue);
				}
				else{
					_mx = _lx2;
					_my = _ly1;
					if(_ly1 > _ly2) _ly1 += _o;
					//draw_set_color((_ly2 < _ly1) ? c_orange : c_red);
				}
				
				for(var _fx = min(_lx1, _lx2); _fx < max(_lx1, _lx2); _fx += _o){
					draw_rectangle(_fx, _my, _fx + _o - 1, _my + _o - 1, 0);
				}
				for(var _fy = min(_ly1, _ly2); _fy < max(_ly1, _ly2); _fy += _o){
					draw_rectangle(_mx, _fy, _mx + _o - 1, _fy + _o - 1, 0);
				}*/
			}
		}
		
		 // Rooms:
		draw_set_color(c_white);
		with(room_list){
			draw_set_color(special ? c_purple : c_white);
			for(var _fy = 0; _fy < array_length(layout); _fy++){
				var l = layout[_fy];
				for(var _fx = 0; _fx < array_length(l); _fx++){
					if(l[_fx]){
						draw_rectangle(_x + ((x + _fx) * _o), _y + ((y + _fy) * _o), _x + ((x + _fx) * _o) + (_o - 1), _y + ((y + _fy) * _o) + (_o - 1), 0);
					}
				}
			}
		}
		
		 // Tip:
		draw_set_font(fntChat)
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text_nt(0, 0, "[A] Reset#[D] Generate Level");
		
		draw_reset_projection();
	}
	else instance_destroy();
	
	
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