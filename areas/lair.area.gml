#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Store Script References:
	scr.door_create = script_ref_create(door_create);
	
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
	//surfCarpet = call(scr.surface_setup, "LairCarpet", 2000, 2000, null);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
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
#define area_music_boss_intro  return mus.BigShotsIntro;
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
		with(call(scr.array_shuffle, ds_map_keys(room_type))){
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
									call(scr.door_create, _x + 16 + (_fx * 32), _y + 16 + (_fy * 32), _ang);
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
		call(scr.obj_create, _x, _y, "TopDecal");
	}
	
#define area_pop_enemies
	var	_x = x + 16,
		_y = y + 16;
		
	 // Loop Spawns:
	if(GameCont.loops > 0 && chance(1, 4)){
		instance_create(_x, _y,
			styleb
			? BecomeTurret
			: choose(Molesarge, Jock)
		);
	}
	
	 // Rat packs:
	if(!place_meeting(x, y, Wall) && chance(1, 20)){
		repeat(irandom_range(3, 7)) instance_create(_x, _y, Rat);
	}
	
	 // Spawn Cats Underground:
	else if(chance(1, 8)){
		with(call(scr.obj_create, _x, _y, "Cat")){
			if(chance(1, 2)){
				active    = false;
				cantravel = true;
				alarm1    = random_range(30, 900);
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
					chance(1, 16)
					|| (
						chance(1, 2)
						&& !array_length(call(scr.instances_in_rectangle, x - 96, y - 96, x + 96, y + 96, obj.CatHole))
					)
				){
					call(scr.obj_create, x + 16, y + 16, "CatHole");
				}
			}
		}
	}
	
	 // Emergency Enemy Reserves:
	var _floors = [];
	with(instances_matching(FloorNormal, "styleb", 0)){
		if(!place_meeting(x, y, Wall)){
			array_push(_floors, self);
		}
	}
	if(array_length(_floors) > 0){
		while(instance_number(enemy) < 24){
			with(call(scr.instance_random, _floors)){
				create_enemies(bbox_center_x, bbox_center_y, 1);
			}
		}
	}
	
	 // Important Door Stuff:
	with(instances_matching_ne(obj.CatDoor, "id")){
		 // Remove Blocking Walls:
		var	_ang = image_angle - (90 * image_yscale);
		with(call(scr.instances_meeting_point,
			x + lengthdir_x(8, _ang) + lengthdir_x(8, image_angle),
			y + lengthdir_y(8, _ang) + lengthdir_y(8, image_angle),
			Wall
		)){
			instance_destroy();
		}
		
		 // Make sure door isn't placed weirdly:
		with(call(scr.instances_meeting_point, bbox_center_x, bbox_bottom - 5, Floor)){
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
	call(scr.instance_budge, enemy, Wall);
	
	 // Light up specific things:
	with(instances_matching_ne([chestprop, RadChest], "id")){
		call(scr.obj_create, x, y - 28, "CatLight");
	}
	with(call(scr.obj_create, 10016, 10016 - 48, "CatLight")){
		sprite_index = spr.CatLightBig;
	}
	
#define area_effect
	alarm0 = irandom_range(1, 120);
	
	for(var i = 0; i < maxp; i++){
		if(player_is_active(i)){
			 // Pick Random Player's Screen:
			do i = irandom(maxp - 1);
			until player_is_active(i);
			
			 // Drip:
			with(call(scr.instance_random, call(scr.instances_seen, Floor, 0, 0, i))){
				instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1) - 8, Drip);
			}
			
			break;
		}
	}
	
#define ntte_setup_Turret(_inst)
	 // Resprite turrets iam smash brother and i dont want to recode turrets:
	with(_inst){
		if("lair_turret" not in self){
			lair_turret = area_active;
		}
		if(lair_turret){
			spr_idle     = spr.LairTurretAppear;
			spr_walk     = spr.LairTurretIdle;
			spr_hurt     = spr.LairTurretHurt;
			spr_dead     = spr.LairTurretDead;
			spr_fire     = spr.LairTurretFire;
			hitid        = [spr_idle, "LAIR TURRET"];
			sprite_index = enemy_sprite;
			
			 // Bind Projectile Replacing Script:
			if(lq_get(ntte, "bind_setup_LairTurret_EnemyBullet1") == undefined){
				ntte.bind_setup_LairTurret_EnemyBullet1 = call(scr.ntte_bind_setup, script_ref_create(ntte_setup_LairTurret_EnemyBullet1), EnemyBullet1);
			}
		}
	}
	
#define ntte_setup_LairTurret_EnemyBullet1(_inst)
	 // Lair Turret Bullets:
	_inst = instances_matching(_inst, "object_index", EnemyBullet1);
	if(array_length(_inst)){
		with(_inst){
			if(
				is_array(hitid)
				&& array_length(hitid) > 1
				&& hitid[1] == "LAIR TURRET"
			){
				with(call(scr.pass, self, scr.projectile_create, x, y, EnemyBullet2, direction, speed)){
					 // Effects:
					with(instance_create(x, y, AcidStreak)){
						sprite_index = spr.AcidPuff;
						image_angle  = other.direction + orandom(30);
						depth        = other.depth - (image_angle >= 180);
						
						with(call(scr.fx, x, y, [image_angle, 2 + random(2)], AcidStreak)){
							depth = other.depth;
						}
					}
					
					 // Sounds:
					sound_play_hit(sndFrogEggSpawn3, 0.4);
				}
				instance_delete(self);
			}
		}
	}
	
	 // Unbind Script:
	if(!array_length(instances_matching(Turret, "lair_turret", true))){
		if(lq_get(ntte, "bind_setup_LairTurret_EnemyBullet1") != undefined){
			call(scr.ntte_unbind, ntte.bind_setup_LairTurret_EnemyBullet1);
			ntte.bind_setup_LairTurret_EnemyBullet1 = undefined;
		}
	}
	
#define ntte_begin_step
	 // Silver Tongue:
	if(
		"ntte_lairmut" in GameCont
		&& GameCont.ntte_lairmut
		&& instance_exists(LevCont)
		&& GameCont.skillpoints > 0
		&& GameCont.crownpoints <= 0
	){
		GameCont.ntte_lairmut = false;
		
		var _skill = "silver tongue";
		
		if(mod_exists("skill", _skill) && skill_get(_skill) == 0){
			with(LevCont){
				 // Clear:
				var _inst = instances_matching(mutbutton, "creator", self);
				if(array_length(_inst)){
					with(_inst){
						if(instance_is(self, SkillIcon) && call(scr.skill_get_avail, skill)){
							other.maxselect--;
							var _num = num;
							with(instances_matching(_inst, "num", _num)){
								instance_destroy();
							}
							with(instances_matching_gt(_inst, "num", _num)){
								num--;
								if(alarm0 > 0){
									alarm0--;
									if(alarm0 <= 0){
										with(self){
											event_perform(ev_alarm, 0);
										}
									}
								}
							}
						}
					}
				}
				
				 // Star of the Show:
				maxselect++;
				with(instance_create(0, 0, SkillIcon)){
					creator = other;
					num     = other.maxselect;
					alarm0	= num + 1;
					skill   = _skill;
					name    = skill_get_name(_skill);
					text    = skill_get_text(_skill);
					mod_script_call("skill", _skill, "skill_button");
				}
			}
		}
	}
	
#define ntte_step
	 // Dissipate Cat Gas Faster:
	if(array_length(obj.CatToxicGas)){
		var _inst = instances_matching_lt(obj.CatToxicGas, "speed", 0.1);
		if(array_length(_inst)){
			with(_inst){
				growspeed -= random(0.002 * current_time_scale);
			}
		}
	}
	
	 // Resprited Turret (Fix Appear Animation):
	if(instance_exists(Turret)){
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
		call(scr.obj_create, _x, _y, _e);
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
			
			call(scr.obj_create, _cx, _cy, "SewerRug");
			
			break;
			
		case "Boss":
			
			call(scr.obj_create, _cx, _cy, "CatHoleBig");
			
			 // Corner Columns:
			instance_create(_x + 80,      _y + 80,      Wall);
			instance_create(_x + _w - 96, _y + 80,      Wall);
			instance_create(_x + 80,      _y + _h - 96, Wall);
			instance_create(_x + _w - 96, _y + _h - 96, Wall);
			
			 // Spawn backup chests
			var	_chest = ["CatChest", "BatChest", ((GameCont.loops > 0) ? "RatChest" : RadChest)],
				_dis   = 176,
				_dir   = pround(random(360), 90);
				
			for(var i = 0; i < array_length(_chest); i++){
				call(scr.chest_create, 
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
				call(scr.obj_create, 
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
				call(scr.obj_create, 
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
			with(call(scr.obj_create, _cx, _cy, "NewTable")){
				if(chance(4, 5)){
					call(scr.obj_create, x + orandom(2), y - 18 + orandom(2), "ChairFront");
				}
				call(scr.obj_create, x, y - 32, "CatLight");
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
			with(call(scr.obj_create, _x + 16 + orandom(2), _y + 12, "ChairFront")){
				with(call(scr.obj_create, x, y - 28, "CatLight")){
					sprite_index = spr.CatLightThin;
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
					call(scr.chest_create, _px, _py, "PizzaChest", true);
				}
				else call(scr.obj_create, _px, _py, choose("PizzaStack", "PizzaStack", MoneyPile));
			}
			
			 // Center Floor:
			with(call(scr.instances_meeting_point, _cx, _cy, floors)){
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
				with(call(scr.obj_create, _ox, _oy - 48, "CatLight")){
					image_yscale *= 1.5;
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
			with(call(scr.obj_create, _cx + orandom(2), _y + 16 + orandom(2), "Couch")){
				call(scr.obj_create, x + orandom(2), y + 20 + orandom(2), "NewTable");
			}
			
			 // Enemies:
			create_enemies(_cx, _y + 16, 2);
			
			break;
			
		case "Dining":
			
			 // Props:
			with(call(scr.obj_create, _cx, _cy, "NewTable")){
				for(var _side = -1; _side <= 1; _side += 2){
					with(call(scr.obj_create, x + (24 * _side), y + orandom(2), "ChairSide")){
						image_xscale = _side;
					}
					call(scr.obj_create, x + (12 * _side), y - 18 + orandom(2), "ChairFront");
				}
				call(scr.obj_create, x, y - 32, "CatLight");
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
					with(call(scr.obj_create, _cx + orandom(2), _y + _oy + orandom(2), "NewTable")){
						 // Chairs:
						for(var _side = -1; _side <= 1; _side += 2){
							if(chance(2, 5)){
								with(call(scr.obj_create, x + (20 * _side) + orandom(2), y + orandom(2), "ChairSide")){
									image_xscale = _side;
								}
							}
						}
						if(chance(2, 5)){
							call(scr.obj_create, x + orandom(2), y - 14 + orandom(2), "ChairFront");
						}
						
						 // Lights:
						if(chance(2, 3)){
							call(scr.obj_create, x, y - 32, "CatLight");
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
			with(call(scr.obj_create, _cx + orandom(2), _y + 26 + orandom(2), "NewTable")){
				call(scr.obj_create, 
					x + orandom(4),
					y - 16 + orandom(2),
					choose("ChairFront", "ChairFront", "ChairSide")
				);
				
				 // Cabinets:
				for(var _side = -1; _side <= 1; _side += 2){
					call(scr.obj_create, _cx + (_side * ((_w / 2) - 48)), _y + 42 + orandom(2), "Cabinet");
				}
				
				 // Light:
				call(scr.obj_create, x, y - 30, "CatLight");
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
					call(scr.obj_create, 
						_cx + irandom_range(24, (_w / 2) - 10),
						_y  + irandom_range(16, _h - 24),
						(chance(1, 10) ? choose("ChairFront", "ChairSide") : Tires)
					);
				}
				
				 // Lights:
				for(var _side = -1; _side <= 1; _side += 2){
					call(scr.obj_create, _cx + (((_w / 2) - 24) * _side), _cy - 32, "CatLight");
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
	
#define door_create(_x, _y, _dir)
	/*
		Creates a double CatDoor for a normal Floor
		Returns an array containing both doors
		
		Ex:
			with(FloorNormal){
				door_create(bbox_center_x, bbox_center_y, 90);
			}
	*/
	
	var	_dx      = _x + lengthdir_x(16 - 2, _dir),
		_dy      = _y + lengthdir_y(16 - 2, _dir) + 1,
		_partner = noone,
		_inst    = [];
		
	for(var i = -1; i <= 1; i += 2){
		var _side = i;
		if(_dir < 90 || _dir > 270){
			_side *= -1; // Depth fix, create bottom door first
		}
		with(call(scr.obj_create,
			_dx + lengthdir_x(16 * _side, _dir - 90),
			_dy + lengthdir_y(16 * _side, _dir - 90),
			"CatDoor"
		)){
			image_angle  = _dir;
			image_yscale = -_side;
			
			 // Link Doors:
			partner = _partner;
			with(partner){
				partner = other;
			}
			_partner = self;
			
			 // Ensure LoS Wall Creation:
			with(self){
				event_perform(ev_step, ev_step_normal);
			}
			
			array_push(_inst, self);
		}
	}
	
	return _inst;
	
#define draw_rugs
	if(!instance_exists(GenCont)){
		with(call(scr.surface_setup, "LairCarpet", null, null, 1)){
			x = room_center[0] - (w / 2);
			y = room_center[1] - (h / 2);
			
			 // Setup Carpets:
			if(reset){
				reset = false;
				
				surface_set_target(surf);
				draw_clear_alpha(c_black, 0);
				d3d_set_projection_ortho(x, y, w, h, 0);
				
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
								
								with(UberCont){ // cant call draw_sprite in lightweight object, sad
									draw_sprite(_s[n], _i, room_center[0] + ((other.x + xx) * _o), room_center[1] + ((other.y + yy) * _o));
								}
							}
						}
					}
				}
				
				draw_set_fog(false, c_white, 0, 0);
				
				d3d_set_projection_ortho(view_xview_nonsync, view_yview_nonsync, game_width, game_height, 0);
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