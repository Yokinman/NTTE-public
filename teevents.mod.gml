#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Store Script References:
	with([teevent_add, teevent_get_active, teevent_set_active, floor_set, floor_fill, floor_delete, floor_room, floor_room_create, floor_room_start, floor_set_style, floor_reset_style, floor_set_align, floor_reset_align]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // Add Objects:
	call(scr.obj_add, script_ref_create(NTTEEvent_create));
	
	 // floor_set():
	floor_reset_style();
	floor_reset_align();
	
	/*
		0) Determine if X should be an event:
			Would X use the event tip system?
			If a mutation made events more likely, should X be more likely?
			If a crown made events spawn in any area, should X spawn anywhere?
			
		1) Add an event using 'teevent_add(_event)'
		
		2) Define scripts:
			Event_text    : Returns the event's loading tip, leave undefined or return a blank string for no loading tip
			Event_area    : Returns the event's spawn area, leave undefined if it can spawn on any area
			Event_hard    : Returns the event's minimum difficulty, leave undefined to default to 2 (Desert-2)
			Event_chance  : Returns the event's spawn chance from 0 to 1, leave undefined if it always spawns
			Event_setup   : The event's pre-generation code, called from its controller object to define variables and/or adjust level gen before floors are made
			Event_create  : The event's generation code, called from its controller object during ntte.mod's level_start script
			Event_step    : The event's step code, called from its controller object
			Event_cleanup : The event's cleanup code, called from its controller object when it's destroyed (usually when the level ends)
	*/
	
	 // Event Tip Color:
	event_tip = `@(color:${make_color_rgb(175, 143, 106)})`;
	
	 // Event Execution Order:
	event_list = [];
	teevent_add("BlockedRoom");
	teevent_add("GatorAmbush");
	teevent_add("MaggotPark");
	teevent_add("ScorpionCity");
	teevent_add("BanditCamp");
	teevent_add("GatorDen");
	teevent_add("SewerPool");
	teevent_add("RavenArena");
	teevent_add("FirePit");
	teevent_add("SealPlaza");
	//teevent_add("YetiHideout");
	teevent_add("MutantVats");
	//teevent_add("ButtonGame");
	teevent_add("PopoAmbush");
	teevent_add("PalaceShrine");
	teevent_add("SeaCreature");
	teevent_add("EelGrave");
	teevent_add("BuriedVault");
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro event_tip  global.event_tip
#macro event_list global.event_list

#macro BuriedVault_spawn variable_instance_get(GenCont, "safespawn", 1) > 0 && GameCont.area != "coast"
#macro BuriedVault_found variable_instance_get(GameCont, "buried_vaults", 0)

#macro ScorpionCity_pet instances_matching_gt(instances_matching(obj.Pet, "pet", "Scorpion"), "scorpion_city", 0)

#define BuriedVault_text    return ((GameCont.area == area_vault || BuriedVault_found > 0) ? "" : choose(`SECRETS IN THE ${event_tip}WALLS`, `${event_tip}ARCHAEOLOGY`, `ANCIENT ${event_tip}STRUCTURES`));
#define BuriedVault_hard    return 5; // 3-1+
#define BuriedVault_chance  return ((GameCont.area == area_vault) ? 1/2 : (BuriedVault_spawn ? (1 / (12 + (2 * BuriedVault_found))) : 0));

#define BuriedVault_create
	if(instance_number(enemy) > instance_number(EnemyHorror) || GameCont.area == area_vault){
		with(call(scr.instance_random, Wall)){
			call(scr.obj_create, x, y, ((GameCont.level >= 10 && chance(1, 3) && false) ? "BuriedShrine" : "BuriedVault"));
		}
	}
	
#define BanditCamp_text    return ((GameCont.loops > 0) ? "" : `${event_tip}BANDITS`);
#define BanditCamp_area    return area_desert;
#define BanditCamp_hard    return 3; // 1-3+
#define BanditCamp_chance  return ((GameCont.subarea == 3) ? 1/10 : 1/20);

#define BanditCamp_create
	var	_w          = 5,
		_h          = 4,
		_type       = "",
		_dirOff     = 30,
		_floorDis   = -32,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 128,
		_spawnFloor = FloorNormal;
		
	floor_set_align(32, 32);
	
	with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
		 // Dying Campfire:
		with(instance_create(x, y, Effect)){
			sprite_index = spr.BanditCampfire;
			image_xscale = choose(-1, 1);
			depth = 8;
			with(instance_create(x, y - 2, GroundFlame)) alarm0 *= 4;
		}
		
		 // Main Tents:
		var	_ang   = random(360),
			_chest = [];
			
		with(instances_matching_ne([chestprop, RadChest], "object_index", RadMaggotChest)){
			if(place_meeting(x, y, Floor) && !place_meeting(x, y, Wall) && !position_meeting(x, y, PortalClear)){
				array_push(_chest, self);
			}
		}
		
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 3)){
			var	_l = 40,
				_d = _dir + orandom(10);
				
			with(call(scr.obj_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "BanditTent")){
				 // Grab Nearest Chest:
				target = call(scr.instance_nearest_array, x, y, _chest);
				_chest = call(scr.array_delete_value, _chest, target);
				with(self){
					event_perform(ev_step, ev_step_begin);
				}
			}
		}
		
		 // Bro:
		call(scr.obj_create, x, y, "BanditHiker");
		
		 // Reduce Nearby Non-Bandits:
		var	_park = teevent_get_active("MaggotPark"),
			_city = teevent_get_active("ScorpionCity");
			
		with(instances_matching_ne([MaggotSpawn, BigMaggot], "id")){
			if(chance(1, point_distance(x, y, other.x, other.y) / (_park ? 64 : 160))){
				instance_delete(self);
			}
		}
		with(instances_matching_ne([Scorpion, GoldScorpion], "id")){
			if(chance(1, point_distance(x, y, other.x, other.y) / (_city ? 32 : 160))){
				instance_delete(self);
			}
		}
		
		 // Random Tent Spawns:
		with(call(scr.array_shuffle, instances_matching(FloorNormal, "styleb", false))){
			if(chance(1, point_distance(x, y, other.x, other.y) / 24)){
				if(!place_meeting(x, y, Wall) && !place_meeting(x, y, hitme)){
					var	_fx = bbox_center_x,
						_fy = bbox_center_y,
						_fw = bbox_width,
						_fh = bbox_height;
						
					if(point_distance(_fx, _fy, _spawnX, _spawnY) > 64){
						var	_sideStart = choose(-1, 1),
							_spawn = true;
							
						 // Wall Tent:
						for(var _side = _sideStart; abs(_side) <= 1; _side += 2 * -_sideStart){
							if(_spawn && !place_meeting(x + (_fw * _side), y, Floor)){
								_spawn = false;
								with(call(scr.obj_create, _fx + (((_fw / 2) - irandom_range(3, 5)) * _side), _fy - random(2), "BanditTent")){
									spr_idle = spr.BanditTentWallIdle;
									spr_hurt = spr.BanditTentWallHurt;
									spr_dead = spr.BanditTentWallDead;
									image_xscale = -_side;
								}
							}
						}
						
						 // Can't Spawn Wall Tent, Spawn Normal:
						if(_spawn){
							if(!collision_rectangle(_fx - 32, _fy - 32, _fx + 32, _fy + 32, Wall, false, false)){
								if(!collision_rectangle(bbox_left - 4, bbox_top - 4, bbox_right + 4, bbox_bottom + 4, hitme, false, false)){
									_spawn = false;
									call(scr.obj_create, _fx + orandom(8), _fy + orandom(8), (chance(1, 3) ? Barrel : "BanditTent"));
								}
							}
						}
					}
				}
			}
		}
		
		 // Riders:
		with(teevent_get_active("ScorpionCity")){
			var	_rideList = call(scr.array_shuffle, instances_matching_ne([Scorpion, GoldScorpion], "id")),
				_rideNum  = 0;
				
			with(instances_matching_ne(obj.BanditCamper, "id")){
				if(_rideNum >= array_length(_rideList)){
					break;
				}
				if(chance(1, 2)){
					rider_target = _rideList[_rideNum++];
				}
			}
		}
	}
	
	floor_reset_align();
	
	
#define BlockedRoom_area    return area_desert;
#define BlockedRoom_hard    return 1; // 1-1+
#define BlockedRoom_chance  return 1/3;

#define BlockedRoom_setup
	type = call(scr.pool, {
		"Chest"    : 2,
		"Scorpion" : 1,
		"Maggot"   : 1,
		"Skull"    : 1,
		"Dummy"    : ((GameCont.subarea < 3 && variable_instance_get(GameCont, "ntte_bigbandit_spawn", 0) <= 0) ? 1 : 0)
	});
	dummy_spawn = 1;
	dummy_music = false;
	
#define BlockedRoom_create
	var	_minID      = instance_max,
		_w          = 2,
		_h          = 2,
		_type       = "",
		_dirOff     = 0,
		_floorDis   = 32,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 32,
		_spawnFloor = FloorNormal;
		
	floor_set_align(32, 32);
	
	 // Type Setup:
	switch(type){
		case "Chest":
		case "Dummy":
			var _size = 6;
			_w = 1 + irandom(_size - 1);
			_h = 1 + irandom(_size - _w);
			if(type == "Chest"){
				_w = irandom_range(1, _w);
				_h = irandom_range(1, _h);
			}
			break;
			
		case "Maggot":
			_w = irandom_range(2, 3);
			_h = _w;
			floor_set_style(1);
			break;
			
		case "Scorpion":
			if(chance(1, 4)){
				_w = 1;
				_h = _w;
			}
			else{
				_w = irandom_range(2, 3);
				_h = irandom_range(2, 3);
			}
			break;
			
		case "Skull":
			_w = irandom_range(2, 3) + chance(1, 3);
			_h = irandom_range(2, 3);
			break;
	}
	
	 // Generate:
	with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
		var	_cx = x,
			_cy = y;
			
		 // Decals:
		with(call(scr.instance_random, floors)){
			call(scr.obj_create, bbox_center_x, bbox_center_y, "TopDecal");
		}
		
		 // Barrel Wall Entrance:
		var	_ow = (_w * 32) / 2,
			_oh = (_h * 32) / 2,
			_ang = pround(point_direction(xstart, ystart, x, y), 90);
			
		for(var _dir = _ang; _dir < _ang + 360; _dir += 90){
			var	_x    = x + lengthdir_x(_ow + _floorDis + 1, _dir),
				_y    = y + lengthdir_y(_oh + _floorDis + 1, _dir),
				_ox   = abs(lengthdir_x(_ow + 1, _dir - 90)),
				_oy   = abs(lengthdir_y(_oh + 1, _dir - 90)),
				_inst = call(scr.instances_meeting_rectangle, _x - _ox, _y - _oy, _x + _ox, _y + _oy, Floor);
				
			if(array_length(_inst) > 0){
				var	_doorSide = ((_dir % 180) == 0),
					_doorDis  = (_doorSide ? _h        : _w       ) * 32,
					_doorW    = (_doorSide ? _floorDis : _doorDis ) / 32,
					_doorH    = (_doorSide ? _doorDis  : _floorDis) / 32,
					_doorX    = x + lengthdir_x(_ow + _floorDis - 8, _dir),
					_doorY    = y + lengthdir_y(_oh + _floorDis - 8, _dir);
					
				_cx += lengthdir_x((_floorDis / 2) - 8, _dir);
				_cy += lengthdir_y((_floorDis / 2) - 8, _dir);
				
				 // Connect to Level:
				floor_fill(
					_x - lengthdir_x((_floorDis / 2) + 1, _dir),
					_y - lengthdir_y((_floorDis / 2) + 1, _dir),
					_doorW,
					_doorH
				);
				
				 // Barrel:
				var _barrel = noone;
				with(call(scr.instance_nearest_bbox, x + orandom(1), y + orandom(1), _inst)){
					with(call(scr.instances_meeting_instance, self, Wall)){
						with(instances_matching_gt(Debris, "id", instance_create(x, y, FloorExplo))){
							instance_delete(self);
						}
						instance_destroy();
					}
					_barrel = instance_create(bbox_center_x, bbox_center_y, Barrel);
				}
				with(_barrel){
					size = 2;
					move_contact_solid(point_direction(x, y, _doorX, _doorY) + orandom(60), 8);
					xprevious = x;
					yprevious = y;
				}
				
				 // Generate Wall:
				var _wall = [];
				for(var _dis = 8; _dis < _doorDis; _dis += 16){
					with(instance_create(
						_doorX + lengthdir_x(_dis - (_doorDis / 2), _dir - 90) - 8,
						_doorY + lengthdir_y(_dis - (_doorDis / 2), _dir - 90) - 8,
						Wall
					)){
						if(!position_meeting(bbox_center_x + lengthdir_x(16, _dir), bbox_center_y + lengthdir_y(16, _dir), Wall)){
							array_push(_wall, self);
						}
					}
				}
				
				 // Spriterize Walls:
				if(array_length(_wall) > 0){
					var	_wallMax = array_length(_wall),
						_wallNum = (
							instance_exists(_barrel)
							? array_find_index(_wall, call(scr.instance_nearest_bbox, _barrel.x, _barrel.y, _wall))
							: irandom(_wallMax - 1)
						),
						_break = false;
						
					for(var i = 0; i < _wallMax; i++){
						with(_wall[(_wallNum + i) % _wallMax]){
							var	_wx = bbox_center_x,
								_wy = bbox_center_y;
								
							with(call(scr.instance_nearest_bbox, _wx + orandom(1), _wy + orandom(1), call(scr.instances_meeting_rectangle, bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, instances_matching_ne(_wall, "id", id)))){
								_wx = (_wx + bbox_center_x) / 2;
								_wy = (_wy + bbox_center_y) / 2;
								
								with([self, other]){
									sprite_index = spr.Wall1BotRubble
									topspr       = spr.Wall1TopRubble;
									outspr       = spr.Wall1OutRubble;
									image_index  = round(point_direction(bbox_center_x, bbox_center_y, _wx, _wy) / 90);
									topindex     = image_index;
									outindex     = image_index;
								}
								
								_break = true;
							}
						}
						if(_break) break;
					}
				}
				
				 // Move Away Barrel Bros:
				with(_barrel){
					with(call(scr.instances_meeting_instance, self, [chestprop, hitme])){
						if(place_meeting(x, y, other)){
							if(call(scr.instance_budge, self, other)){
								xstart = x;
								ystart = y;
							}
						}
					}
				}
				
				 // No More Entrances:
				if(chance(1, 3)){
					break;
				}
			}
		}
		
		 // Secrets Within:
		switch(other.type){
			
			case "Chest":
				
				 // Offset:
				if(x != _cx ^^ y != _cy){
					if(_w > _h) _cx = x + ((_w - _h) * 16 * sign(x - _cx));
					if(_h > _w) _cy = y + ((_h - _w) * 16 * sign(y - _cy));
				}
				
				 // Grab Nearest Chest:
				var _chest = [];
				with(instances_matching_ne([chestprop, RadChest, Mimic, SuperMimic], "object_index", RadMaggotChest)){
					if(place_meeting(x, y, Floor) && !position_meeting(x, y, PortalClear)){
						array_push(_chest, self);
					}
				}
				with(call(scr.instance_nearest_rectangle, x1, y1, x2, y2, _chest)){
					instance_create(x, y, Cactus);
					with(call(scr.instances_meeting_instance, self, Bandit)){
						if(place_meeting(x, y, other)){
							x         = _cx;
							y         = _cy;
							xprevious = x;
							yprevious = y;
						}
					}
					x         = _cx;
					y         = _cy;
					xprevious = x;
					yprevious = y;
				}
				
				break;
				
			case "Maggot":
				
				 // Centerpiece:
				var	_obj = choose(BonePile, MaggotSpawn, RadMaggotChest, AmmoChest, WeaponChest),
					_num = 1;
					
				if(
					(_obj == chestprop || object_is_ancestor(_obj, chestprop)) ||
					(_obj == RadChest  || object_is_ancestor(_obj, RadChest))
				){
					_num += skill_get(mut_open_mind);
				}
				
				if(_num > 0) repeat(_num){
					call(scr.chest_create, _cx + orandom(4), _cy + orandom(4), _obj, true);
				}
				
				 // Maggots:
				repeat(irandom_range(3, 5)){
					instance_create(x + orandom(1), y + orandom(1), BigMaggot);
				}
				repeat(irandom_range(6, 8)){
					instance_create(x + orandom(1), y + orandom(1), Maggot);
				}
				
				 // Flies:
				with(floors){
					with(call(scr.obj_create, random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), "FlySpin")){
						if(chance(1, 2)){
							target = instance_nearest(x, y, Maggot);
							target_x = orandom(8);
							target_y = -random(4);
						}
					}
				}
				
				break;
				
			case "Scorpion":
				
				 // Baby:
				call(scr.obj_create, _cx, _cy, "BabyScorpionGold");
				
				 // Parents:
				if(_w > 1 || _h > 1){
					 // Mommy:
					instance_create(_cx, _cy, GoldScorpion);
					
					 // Daddy:
					if(chance((_w - 2) + (_h - 2), 2)){
						instance_create(_cx, _cy, Scorpion);
					}
					
					 // Victim:
					call(scr.obj_create, _cx + orandom(_w * 8), _cy + orandom(_h * 8), "Backpacker");
				}
				
				 // More Details:
				call(scr.obj_create, _cx, _cy, "TopDecal");
				with(floors){
					instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Detail);
				}
				
				break;
				
			case "Skull":
				
				var _canSkull = true;
				
				 // Move Shark Skull:
				with(instances_matching_ne(obj.CoastBossBecome, "id")){
					if(_canSkull){
						_canSkull = false;
						
						xstart = _cx + orandom(4);
						ystart = _cy + orandom(4);
						
						 // Free Bone:
						part = min(part + 1, sprite_get_number(spr_idle) - 2);
						
						 // Details:
						with(instances_matching_gt(Detail, "id", _minID)){
							instance_destroy();
						}
						var _lastArea = GameCont.area;
						GameCont.area = "coast";
						repeat(1 + irandom(max(_w, _h))){
							instance_create(
								random_range(other.x1 + 4, other.x2 - 4),
								random_range(other.y1 + 4, other.y2 - 8),
								Detail
							);
						}
						GameCont.area = _lastArea;
					}
				}
				
				 // Cow Skull:
				if(_canSkull){
					_canSkull = false;
					
					call(scr.obj_create, _cx, _cy, "CowSkull");
					
					 // Extra:
					var _canTent = true;
					with(call(scr.array_shuffle, floors)){
						var	_fx   = bbox_center_x,
							_fy   = bbox_center_y,
							_fw   = bbox_width,
							_fh   = bbox_height,
							_side = sign(_fx - other.x);
							
						if(_side == 0) _side = choose(-1, 1);
						
						 // Camper:
						if(_canTent && !place_meeting(x + (_fw * _side), y, Floor)){
							_canTent = false;
							
							with(call(scr.obj_create, _fx + (((_fw / 2) - irandom_range(3, 5)) * _side), _fy - random(2), "BanditTent")){
								spr_idle = spr.BanditTentWallIdle;
								spr_hurt = spr.BanditTentWallHurt;
								spr_dead = spr.BanditTentWallDead;
								image_xscale = -_side;
							}
							
							 // Old Friend:
							if(chance(1, 3)){
								with(call(scr.obj_create, _cx + orandom(8), _cy + orandom(8), "BanditHiker")){
									can_path = false;
								}
							}
						}
						
						 // Cacti:
						else if(chance(1, 4) && !place_meeting(x, y, hitme)){
							instance_create(_fx, _fy, Cactus);
						}
					}
				}
				
				break;
				
			case "Dummy":
				
				with(instance_create(_cx, _cy, TutorialTarget)){
					maxhealth = 8;
					my_health = maxhealth;
					team      = 1;
					
					 // Decals:
					repeat(4) with(call(scr.obj_create, x, y, "TopDecal")){
						if(place_meeting(x, y, TopPot)){
							instance_destroy();
						}
					}
					
					 // Spectators:
					var	_wall = instances_matching_ne(instances_matching_gt([Wall, TopSmall], "id", _minID), "sprite_index", spr.Wall1BotRubble),
						_ang = random(360);
						
					for(
						var _dir = _ang;
						_dir < _ang + 360;
						_dir += random_range(30, 45) * ((max(_w, _h) <= 1) ? 2 : 1)
					){
						var _dis = random(28);
						with(call(scr.instance_nearest_bbox, x + lengthdir_x((_w * 16) + _dis, _dir), y + lengthdir_y((_h * 16) + _dis, _dir), _wall)){
							call(scr.obj_create, bbox_center_x, bbox_center_y, "WallEnemy");
						}
					}
				}
				
				break;
				
		}
		
		other.x = _cx;
		other.y = _cy;
	}
	
	floor_reset_align();
	floor_reset_style();
	
#define BlockedRoom_step
	switch(type){
		
		case "Dummy":
		
			 // Bandit Ambush:
			if(instance_exists(WantBoss)){
				if(dummy_spawn > 0){
					if(!position_meeting(x, y, TutorialTarget)){
						dummy_spawn--;
						dummy_music = true;
						
						 // B-Theme Next Level:
						GameCont.proto = true;
						
						 // Move Player to Spawnable Position:
						var	_wall      = [],
							_playerPos = [];
							
						with(Wall){
							if(
								(!place_free(x - 16, y) && !place_free(x + 16, y)) ||
								(!place_free(x, y + 16) && !place_free(x, y - 16))
							){
								if(array_length(call(scr.instances_meeting_rectangle, bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, TopSmall))){
									array_push(_wall, self);
								}
							}
						}
						with(call(scr.instance_nearest_bbox, x + orandom(16), y + orandom(16), _wall)){
							var _dis = 112;
							for(var _dir = 0; _dir < 360; _dir += 4){
								var	_fx = x + lengthdir_x(_dis, _dir),
									_fy = y + lengthdir_y(_dis, _dir);
									
								if(!collision_line(x, y, _fx, _fy, Wall, true, true)){
									with(Player){
										array_push(_playerPos, [self, x, y]);
										x = _fx;
										y = _fy;
									}
									break;
								}
							}
						}
						
						 // Call Big Bandit:
						var _minID = instance_max;
						with(WantBoss) with(self){
							var	_lastSub   = GameCont.subarea,
								_lastAlarm = alarm_get(0);
								
							event_perform(ev_alarm, 0);
							
							GameCont.subarea = _lastSub;
							if(instance_exists(self)){
								alarm_set(0, _lastAlarm);
							}
						}
						
						 // Return Players:
						with(_playerPos){
							with(self[0]){
								x = other[1];
								y = other[2];
							}
						}
						
						 // Fix Big Bandit:
						with(instances_matching_gt(BanditBoss, "id", _minID)){
							var _target = instance_nearest(x, y, Player);
							if(instance_exists(_target)){
								enemy_look(point_direction(x, y, _target.x, _target.y));
							}
							
							 // Awesomesauce:
							hitid = [sprTargetIdle, "BANDIT AMBUSH"];
							
							 // Less:
							GameCont.ntte_bigbandit_spawn = variable_instance_get(GameCont, "ntte_bigbandit_spawn", 0) + 1;
						}
					}
				}
				
				 // Boss Win Music Fix:
				else if(dummy_music && GameCont.subarea != 3 && !instance_exists(BanditBoss)){
					dummy_music = false;
					with(MusCont){
						alarm_set(1, 1);
					}
				}
			}
			
			 // Nevermind...
			else if(instance_exists(Portal) && position_meeting(x, y, TutorialTarget)){
				with(call(scr.instances_meeting_point, x, y, TutorialTarget)){
					if(position_meeting(other.x, other.y, self)){
						my_health = 0;
					}
				}
			}
			
			break;
			
	}
	
#define MaggotPark_text    return `THE SOUND OF ${event_tip}FLIES`;
#define MaggotPark_area    return area_desert;
#define MaggotPark_chance  return 1/50;

#define MaggotPark_create
	var	_x          = spawn_x,
		_y          = spawn_y,
		_num        = 3,
		_ang        = random(360),
		_nestNum    = _num,
		_nestDir    = _ang,
		_nestDis    = 16 + (4 * _nestNum),
		_w          = ceil(((2 * (_nestDis + 32)) + 32) / 32),
		_h          = _w,
		_type       = "round",
		_dirOff     = 0,
		_floorDis   = -32,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 160,
		_spawnFloor = FloorNormal;
		
	 // Find Spawn Location:
	with(floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)){
		_x = x;
		_y = y;
	}
	with(instance_furthest(_spawnX, _spawnY, RadChest)){
		with(call(scr.instance_nearest_bbox, _x, _y, _spawnFloor)){
			var	_fx = bbox_center_x,
				_fy = bbox_center_y;
				
			if(point_distance(_fx, _fy, _spawnX, _spawnY) >= _spawnDis){
				_x = _fx;
				_y = _fy;
			}
		}
		instance_delete(self);
	}
	
	 // Generate Area:
	var _minID = instance_max;
	
	floor_set_align(32, 32);
	floor_set_style(1);
	
	with(floor_room_create(_x, _y, _w, _h, _type, point_direction(_spawnX, _spawnY, _x, _y), _dirOff, _floorDis)){
		 // Tendril Floors:
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			var	_fx  = x + lengthdir_x((_w * 16) - 32, _dir),
				_fy  = y + lengthdir_y((_h * 16) - 32, _dir),
				_off = 0;
				
			for(var _size = 3; _size > 0; _size--){
				var	_dis    = _size * 16,
					_dirOff = pround(_dir + _off, 90);
					
				_fx += lengthdir_x(_dis, _dirOff);
				_fy += lengthdir_y(_dis, _dirOff);
				
				floor_fill(_fx, _fy, _size);
				
				_fx += lengthdir_x(_dis, _dirOff);
				_fy += lengthdir_y(_dis, _dirOff);
				
				_off += orandom(60);
			}
		}
		
		 // Chest:
		with(instance_nearest(x, y, WeaponChest)){
			 // Delete Old Chest:
			instance_create(x, y, Cactus);
			with(instances_matching(instances_matching(PortalClear, "x", x), "y", y)){
				instance_delete(self);
			}
			instance_delete(self);
			
			 // Upgrade:
			with(call(scr.chest_create, other.x, other.y, BigWeaponChest, true)){
				depth = -1;
			}
		}
		
		 // Nests:
		for(var _d = _nestDir; _d < _nestDir + 360; _d += (360 / _nestNum)){
			var _l = _nestDis + random(4 * _nestNum);
			call(scr.obj_create, round(x + lengthdir_x(_l, _d)), round(y + lengthdir_y(_l, _d)), "BigMaggotSpawn");
		}
		
		 // Tendril Floors Setup:
		var	_nestTinyNum = irandom_range(5, 6),
			_burrowNum = irandom_range(3, 4),
			_propNum = irandom_range(1, 3);
			
		with(call(scr.array_shuffle, instances_matching_gt(FloorNormal, "id", _minID))){
			var	_fx = bbox_center_x,
				_fy = bbox_center_y,
				_cx = other.x,
				_cy = other.y;
				
			if(!place_meeting(x, y, hitme)){
				 // Enemies:
				if(_nestTinyNum > 0){
					_nestTinyNum--;
					with(instance_create(_fx, _fy, MaggotSpawn)){
						x = xstart;
						y = ystart;
						move_contact_solid(point_direction(_cx, _cy, x, y) + orandom(120), random(16));
						with(instance_create(x, y, Maggot)){
							with(call(scr.obj_create, x, y, "FlySpin")){
								target   = other;
								target_x = orandom(8);
								target_y = -random(4);
							}
						}
					}
				}
				else if(_burrowNum > 0){
					_burrowNum--;
					call(scr.obj_create, _fx, _fy, "WantBigMaggot");
					
					 // Dead Thing:
					if(chance(1, 3)){
						instance_create(_fx + orandom(4), _fy + orandom(4), BonePile);
					}
					else with(instance_create(_fx + orandom(4), _fy + orandom(4), Corpse)){
						sprite_index = sprMSpawnDead;
						image_xscale = choose(-1, 1);
						size = 2;
					}
					
					 // Fly:
					call(scr.obj_create, random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), "FlySpin");
				}
				
				 // Cacti:
				else if(_propNum > 0){
					_propNum--;
					with(instance_create(_fx, _fy, Cactus)){
						call(scr.obj_create, x + orandom(8), y + orandom(8), "FlySpin");
					}
				}
			}
			
			 // Cactus Fix:
			else with(call(scr.instances_in_rectangle, bbox_left, bbox_top, bbox_right + 1, bbox_bottom + 1, Cactus)){
				with(self){
					event_perform(ev_create, 0);
				}
			}
		}
		
		 // Sound:
		sound_volume(sound_loop(sndMaggotSpawnIdle), 0.4);
	}
	
	floor_reset_align();
	floor_reset_style();
	
	
#define ScorpionCity_text    return choose(`THE AIR ${event_tip}STINGS`, `${event_tip}WHERE ARE WE GOING`);
#define ScorpionCity_area    return area_desert;
#define ScorpionCity_chance  return array_length(ScorpionCity_pet);

#define ScorpionCity_setup
	 // Smaller Level:
	with(instances_matching_gt([GenCont, FloorMaker], "goal", 0)){
		goal = ceil(goal * 0.85);
	}
	
#define ScorpionCity_create
	 // Alert:
	with(ScorpionCity_pet){
		scorpion_city--;
		with(call(scr.alert_create, self, spr_icon)){
			snd_flash = sndScorpionMelee;
		}
	}
	
	 // No Scorpion Pets:
	/*with(instances_matching_ne(obj.ScorpionRock, "id")){
		friendly = -1;
	}*/
	
	 // Delete Lone Walls:
	with(Wall) if(place_meeting(x, y, Floor)){
		var _delete = true;
		for(var _dir = 0; _dir < 360; _dir += 90){
			if(place_meeting(x + lengthdir_x(16, _dir), y + lengthdir_y(16, _dir), Wall)){
				_delete = false;
				break;
			}
		}
		if(_delete){
			with(instance_create(x, y, FloorExplo)){
				depth = 10;
				with(instances_matching_gt(Debris, "id", id)){
					instance_delete(self);
				}
			}
			instance_destroy();
		}
	}
	
	 // More Scorpions:
	with(instances_matching_lt(enemy, "size", 4)){
		if(!array_length(instances_matching(call(scr.instances_meeting_point, x, y, Floor), "styleb", true))){
			if(!instance_is(self, Bandit) || chance(1, 2)){
				var	_scorp = [[Scorpion, "BabyScorpion"], [GoldScorpion, "BabyScorpionGold"]],
					_gold  = chance(size, 5),
					_baby  = (size <= 1);
					
				call(scr.obj_create, x, y, _scorp[_gold, _baby]);
				instance_delete(self);
			}
		}
	}
	with(instances_matching_ne(obj.BigMaggotSpawn, "id")){
		scorp_drop++;
	}
	
	 // Scorpion Nests:
	var	_minID      = instance_max,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnFloor = FloorNormal;
		
	repeat(3){
		var	_w        = irandom_range(3, 5),
			_h        = _w,
			_type     = ((min(_w, _h) > 3) ? "round" : ""),
			_dirOff   = 90,
			_floorDis = 0,
			_spawnDis = 64 + (max(_w, _h) * 16);
			
		floor_set_align(32, 32);
		floor_set_style(1);
		
		with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
			 // Cool-Ass Rocky Floors:
			with(instances_matching(floors, "area", area_desert)){
				sprite_index = spr.FloorScorpion;
				image_index  = irandom(image_number - 1);
				depth        = 8;
				material     = 2;
				traction     = 0.45;
				styleb       = false;
				
				 // Add Thickness:
				with(instance_create(
					x + orandom(1), 
					y - irandom_range(2, 3), 
					SnowFloor
				)){
					sprite_index = spr.SnowFloorScorpion;
					image_index  = other.image_index;
					image_speed  = other.image_speed;
					image_angle += orandom(1);
				}
				
				 // More Details:
				instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Detail);
			}
			
			 // Family:
			repeat(max(1, ((_w + _h) / 2) - 2)){
				instance_create(x, y, (chance(1, 5) ? GoldScorpion : Scorpion));
			}
			
			 // Props:
			var	_boneNum = round(((_w * _h) / 16) + orandom(1)),
				_ang     = random(360);
				
			for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _boneNum)){
				var	_d   = _dir + orandom(30),
					_obj = choose(BonePile, BonePile, "CowSkull"); // choose("Backpacker", LightBeam, WepPickup);
					
				with(call(scr.obj_create, round(x + lengthdir_x((_w * 16) - 24, _d)), round(y + lengthdir_y((_h * 16) - 24, _d)), _obj)){
					if(_obj == WepPickup){
						wep = "crabbone";
					}
				}
			}
		}
		
		floor_reset_align();
		floor_reset_style();
	}
	
	 // Nest Corner Walls:
	with(instances_matching_gt(Floor, "id", _minID)){
		var	_x1    = bbox_left,
			_y1    = bbox_top,
			_x2    = bbox_right + 1,
			_y2    = bbox_bottom + 1,
			_cx    = bbox_center_x,
			_cy    = bbox_center_y,
			_w     = _x2 - _x1,
			_h     = _y2 - _y1,
			_break = false;
			
		for(var	_x = _x1; _x < _x2; _x += _w - 16){
			for(var	_y = _y1; _y < _y2; _y += _h - 16){
				var	_sideX = sign((_x + 8) - _cx),
					_sideY = sign((_y + 8) - _cy);
					
				if(!place_meeting(_x1 + (_w * _sideX), _y1, Floor) && !place_meeting(_x1, _y1 + (_h * _sideY), Floor)){
					instance_create(_x, _y, Wall);
					
					 // Corner Decals:
					with(call(scr.obj_create, _x + 8 - (8 * _sideX), _y, "WallDecal")){
						image_xscale = -_sideX;
					}
					
					_break = true;
					break;
				}
			}
			if(_break) break;
		}
	}
	
	 // The Alpha:
	with(instance_furthest(_spawnX, _spawnY, Scorpion)){
		call(scr.obj_create, x, y, "SilverScorpion");
		instance_delete(self);
	}
	
	 // Oh No:
	if(GameCont.loops > 0) repeat(GameCont.loops){
		with(call(scr.instance_random, [Scorpion, GoldScorpion])){
			call(scr.obj_create, x, y, "SilverScorpion");
			instance_delete(self);
		}
	}
	
	
#define SewerPool_text    return choose("", choose(`${event_tip}RADIOACTIVE SEWAGE @sSMELLS#WORSE THAN YOU THINK`, `${event_tip}ACID RAIN @sRUNOFF`));
#define SewerPool_area    return area_sewers;
#define SewerPool_chance  return 1/5;

#define SewerPool_create
	var	_w          = 2,
		_h          = 4,
		_type       = "",
		_dirStart   = 90,
		_dirOff     = 0,
		_floorDis   = -32,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 96,
		_spawnFloor = [];
		
	floor_set_align(32, 32);
	
	 // Get Potential Spawn Floors:
	var _floorNormal = FloorNormal;
	with(instances_matching(_floorNormal, "styleb", 0)){
		 // Not Above Spawn:
		if(abs(_spawnX - bbox_center_x) > _w * 32){
			 // No Floors Above Current Floor:
			if(array_length(instances_matching_ge(instances_matching_le(instances_matching_lt(_floorNormal, "bbox_top", bbox_top), "bbox_left", bbox_right), "bbox_right", bbox_left)) <= 0){
				 // Not Above Another Event:
				var _notEvent = true;
				/*with(teevent_get_active(all)){
					if(array_find_index(floors, other) >= 0){
						_notEvent = false;
						break;
					}
				}*/
				if(_notEvent){
					array_push(_spawnFloor, self);
				}
			}
		}
	}
	
	 // Generate Room:
	with(floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)){
		with(floor_room_create(x, y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
			 // The Bath:
			with(call(scr.obj_create, x, y, "SludgePool")){
				sprite_index = msk.SewerPool;
				spr_floor    = spr.SewerPool;
				call(scr.obj_create, x + 16, y - 64, "SewerDrain");
			}
			
			 // Just Bros Bathing Together:
			if(point_distance(x, y, _spawnX, _spawnY) >= 128){
				repeat(2 + irandom(1)){
					with(call(scr.obj_create, x - irandom(16), y + orandom(24), "Cat")){
						right = choose(-1, 1);
						sit   = true;
					}
				}
			}
		}
	}
	
	floor_reset_align();
	
	
#define GatorAmbush_text    return choose(`${event_tip}THE WASTELAND WEAPON TRADE`, `THESE PIPES RUN ${event_tip}EVERYWHERE`);
#define GatorAmbush_chance  return ("ntte_crime_bounty" in GameCont && GameCont.ntte_crime_bounty >= 3 && variable_instance_get(GenCont, "safespawn", 1) > 0);

#define GatorAmbush_setup
	 // Smaller Level:
	with(instances_matching_gt([GenCont, FloorMaker], "goal", 0)){
		goal = ceil(goal * 0.9);
	}
	
#define GatorAmbush_create
	var	_w          = 6,
		_h          = 6,
		_type       = "round",
		_dirOff     = 0,
		_floorDis   = -64,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 128,
		_spawnFloor = FloorNormal;
		
	call(scr.floor_set_align, 32, 32);
	//call(scr.floor_set_style, 0, area_sewers);
	
	with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
		 // Temporary decoration
		//call(scr.obj_create, x, y, "SewerRug");
		// with(call(scr.obj_create, x, y, FloorMiddle)){
		// 	mask_index   = -1;
		// 	sprite_index = spr.BigManhole;
		// 	image_speed  = 0;
		// 	depth        = 8;
		// }
		
		 // Cool Floors:
	//	with(floors){
	//		sprite_index = spr.FloorSewerDirt; // spr.FloorSewerLightDirt
	//		material     = 1;
	//		depth        = 9;
	//	}
		// with(call(scr.obj_create, x, y, "SludgePool")){
		// 	sprite_index = msk.SewerPoolBig;
		// 	spr_floor    = spr.SewerPoolBig;
		// 	with(self){
		// 		event_perform(ev_step, ev_step_normal);
		// 	}
		// }
		
		 // Crates:
		var _chestList = [];
		with(instances_matching_ne([chestprop, RadChest, Mimic, SuperMimic], "object_index", RadMaggotChest)){
			if(place_meeting(x, y, Floor)){
				array_push(_chestList, self);
			}
		}
		with(call(scr.array_shuffle, [
			[x1 + 16 + 32, y1 + 16     ],
			[x1 + 16,      y1 + 16 + 32],
			[x2 - 16 - 32, y1 + 16     ],
			[x2 - 16,      y1 + 16 + 32],
			[x1 + 16 + 32, y2 - 16     ],
			[x1 + 16,      y2 - 16 - 32],
			[x2 - 16 - 32, y2 - 16     ],
			[x2 - 16,      y2 - 16 - 32]
		])){
			var	_crateX = self[0],
				_crateY = self[1];
				
			// with(other){
				with(UberCont){
					if(
						!collision_rectangle(_crateX - 16, _crateY - 16, _crateX + 15, _crateY + 15, hitme, false, false) &&
						!collision_rectangle(_crateX - 16, _crateY - 16, _crateX + 15, _crateY + 15, Wall,  false, false)
					){
						if(array_length(_chestList)){
							var _adjacentFloorNum = 0;
							for(var _d = 0; _d < 360; _d += 90){
								var	_x = _crateX + lengthdir_x(32, _d),
									_y = _crateY + lengthdir_y(32, _d);
									
								if(collision_rectangle(_x - 16, _y - 16, _x + 15, _y + 15, Floor, false, false)){
									_adjacentFloorNum++;
								}
							}
							if(_adjacentFloorNum <= 2){
								with(call(scr.obj_create, _crateX, _crateY, "WallCrate")){
									crate_loot = call(scr.instance_nearest_array, x, y, _chestList)
									with(crate_loot){
										instance_create(x, y, Pipe);
										x         = other.x;
										y         = other.y - 4;
										xprevious = x;
										yprevious = y;
									}
									_chestList = call(scr.array_delete_value, _chestList, crate_loot);
								}
							}
						}
						
						//  // :
						// else if(chance(1, 1)){
						// 	// if(_crateX > other.x) _crateX -= 16;
						// 	// if(_crateY > other.y) _crateY -= 16;
						// 	// var _lastArea = GameCont.area;
						// 	// //GameCont.area = area_sewers;
						// 	// instance_create(_crateX, _crateY, Wall);
						// 	// GameCont.area = _lastArea;
						// 	//instance_create(_crateX + orandom(4), _crateY + orandom(4), choose(Pipe, MoneyPile));
						// }
					}
				}
			// }
		}
		
		 // Pipes:
		var	_lenX         = (_w / 2) * 32,
			_lenY         = (_h / 2) * 32,
			_spawnDirList = [],
			_bigPipeNum   = irandom_range(2, 2),
			_pipeNum      = irandom_range(2, 4);
			
		for(var _dir = 0; _dir < 360; _dir += 90){
			array_push(_spawnDirList, _dir);
		}
		with(call(scr.array_shuffle, _spawnDirList)){
			var _dir = self;
			if(_bigPipeNum-- > 0){
				call(scr.obj_create,
					other.x + lengthdir_x(_lenX, _dir),
					other.y + lengthdir_y(_lenY, _dir),
					"BigPipe"
				);
				with(floor_fill(
					other.x + lengthdir_x(_lenX / 2, _dir),
					other.y + lengthdir_y(_lenY / 2, _dir),
					max(2, abs(lengthdir_x(_w / 2, _dir))),
					max(2, abs(lengthdir_y(_h / 2, _dir)))
				)){
					sprite_index = spr.FloorSewerGrate;
					material     = 3;
					styleb       = 1;
					depth        = choose(8, 9);
				}
			}
			else with(call(scr.obj_create, 
				other.x + lengthdir_x(_lenX - random_range(16, 40), self),
				other.y + lengthdir_y(_lenY - random_range(16, 40), self),
				(array_length(call(scr.instances_in_rectangle, other.x1, other.y1, other.x2, other.y2, Barrel)) ? Pipe : Barrel)
			)){
				 // Cool Floors:
				with(call(scr.instances_meeting_instance, self, Floor)){
					sprite_index = (
						(color_get_value(background_color) < 170 || array_length(instances_matching(TopCont, "darkness", true)))
						? spr.FloorSewerDirt
						: spr.FloorSewerLightDirt
					);
					depth    = 9;
					material = 1;
					traction = 0.45;
				}
			}
		}
		// with(call(scr.array_shuffle, _spawnDirList)){
		// 	if(_pipeNum-- > 0){
		// 		var	_ol = random(1),
		// 			_od = self + 180 + orandom(60),
		// 			_ox = lengthdir_x((((_w / 2) * 32) - 64) * _ol, _od),
		// 			_oy = lengthdir_y((((_h / 2) * 32) - 64) * _ol, _od);
					
		// 		with(instance_create(
		// 			other.x + lengthdir_x(_lenX, self) + lengthdir_x(24, _od),
		// 			other.y + lengthdir_y(_lenY, self) + lengthdir_y(24, _od) - 8,
		// 			Pipe
		// 		)){
		// 			move_contact_solid(point_direction(0, 0, _ox, _oy), point_distance(0, 0, _ox, _oy));
		// 			xstart    = x;
		// 			ystart    = y;
		// 			xprevious = x;
		// 			yprevious = y;
		// 			if(place_meeting(x, y, prop)){
		// 				instance_delete(self);
		// 			}
		// 		}
		// 	}
		// 	else break;
		// }
		
		//  // Enemies:
		// var	_smallNum = 2,
		// 	_bigNum   = 2;
			
		// repeat(_smallNum){
		// 	if(chance(1, 3)){
		// 		repeat(2){
		// 			call(scr.obj_create, x, y, "BabyGator");
		// 		}
		// 	}
		// 	else{
		// 		call(scr.obj_create, x, y, Gator);
		// 	}
		// }
		// repeat(_bigNum){
		// 	call(scr.obj_create, x, y, call(scr.pool, [
		// 		[BuffGator,     3],
		// 		["BoneGator",   3 * (GameCont.hard >= 6)],
		// 		["AlbinoGator", 2 * (GameCont.hard >= 8)]
		// 	]));
		// }
	}
	
	floor_reset_align();
	//floor_reset_style();
	
	 // Sound:
	sound_play_pitchvol(sndSkillPick, 0.75, 1.2);
	sound_play_pitch(sndIDPDNadeLoad, 1.15);
	
#define GatorDen_text    return `${event_tip}DISTANT CHATTER`;
#define GatorDen_area    return area_sewers;
#define GatorDen_chance  return (call(scr.unlock_get, "crown:crime") ? 1/10 : 0);

#define GatorDen_setup
	inst = [];
	
#define GatorDen_create
	var _inst = inst;
	
	with(call(scr.array_shuffle, FloorNormal)){
		if(!place_meeting(x, y, Wall)){
			var	_fx     = bbox_center_x,
				_fy     = bbox_center_y,
				_w      = 5 * 32,
				_h      = 4 * 32,
				_ang    = 90 * irandom(3),
				_border = 32,
				_end    = false;
				
			for(var _dir = _ang; _dir < _ang + 360; _dir += 90){
				if(!place_meeting(x + lengthdir_x(32, _dir), y + lengthdir_y(32, _dir), Floor)){
					for(var _dis = _border + choose(32, 64, 96); _dis >= _border; _dis -= 32){
						var	_hallXOff = lengthdir_x(_dis - _border, _dir + 180),
							_hallYOff = lengthdir_y(_dis - _border, _dir + 180),
							_cx = _fx + lengthdir_x(16 + _dis + (_w / 2), _dir),
							_cy = _fy + lengthdir_y(16 + _dis + (_h / 2), _dir);
							
						if(!collision_rectangle(
							_cx - (_w / 2) - _border + min(0, _hallXOff),
							_cy - (_h / 2) - _border + min(0, _hallYOff),
							_cx + (_w / 2) + _border + max(0, _hallXOff) - 1,
							_cy + (_h / 2) + _border + max(0, _hallYOff) - 1,
							Floor,
							false,
							false
						)){
							 // Floors:
							floor_fill(_cx, _cy, _w / 32, _h / 32);
							
							 // Entrance:
							floor_set_style(1, "lair");
							for(var _l = _border; _l <= _dis; _l += 32){
								with(floor_set(_fx - 16 + lengthdir_x(_l, _dir), _fy - 16 + lengthdir_y(_l, _dir), true)){
									 // Doors:
									if(_l > _dis - 32){
										call(scr.door_create, x + 16, y + 16, _dir);
									}
									if(_l <= _border){
										call(scr.door_create, x + 16, y + 16, _dir + 180);
									}
									
									 // Pipes:
									else call(scr.floor_bones, self, 1, 1/10, true);
								}
							}
							floor_reset_style();
							
							 // Table:
							other.x = _cx + lengthdir_x(12, _dir + 180);
							other.y = _cy + lengthdir_y(12, _dir + 180);
							with(instance_create(other.x, other.y, Table)){
								spr_idle   = sprTable1;
								spr_hurt   = sprTable1Hurt;
								spr_dead   = sprTable1Dead;
								spr_shadow = shd32;
								maxhealth  = 5;
								my_health  = maxhealth;
								
								 // Furnishment:
								call(scr.obj_create, x, y, "SewerRug");
								
								 // Light:
								with(call(scr.obj_create, x, y - 30, "CatLight")){
									image_xscale *= 1.1;
								}
								
								 // Table Variance:
								if(chance(1, 3)){
									spr_idle = sprTable2;
									spr_hurt = sprTable2Hurt;
									spr_dead = sprTable2Dead;
								}
								else if(chance(1, 2)){
									with(instance_create(x, y - 10, Corpse)){
										sprite_index = sprBanditDead;
										image_xscale = choose(-1, 1);
										mask_index = mskBandit;
										size = 1;
										other.depth = depth;
									}
								}
								else with(instance_create(x, y - 9, MoneyPile)){
									x = xstart;
									y = ystart;
									depth = other.depth - 1;
								}
								
								 // The Boys:
								array_push(_inst, self);
								for(var _side = -1; _side <= 1; _side += 2){
									var	_off = 20,
										_num = 2,
										_l   = 28,
										_d   = (180 * (_side < 0)) - _off;
										
									repeat(_num){
										var _obj = choose(
											Gator, Gator, GatorSmoke, GatorSmoke,
											"BabyGator", "BabyGator", "BabyGator",
											BuffGator, BuffGator,
											"BoneGator",
											"AlbinoGator"
										);
										
										with(call(scr.obj_create, x + orandom(2) + lengthdir_x(_l, _d), y - random(4) + lengthdir_y(_l, _d), _obj)){
											x = xstart;
											y = ystart;
											image_index = irandom(image_number - 1);
											
											 // Aim:
											enemy_look(_d + 180);
											if(chance(2, 3)){
												gunangle = 90 + (random_range(30, 50) * right);
											}
											
											 // Specifics:
											switch(_obj){
												case GatorSmoke:
													image_speed = 0;
													break;
													
												case "BabyGator":
													if(chance(1, 2)){
														with(instance_copy(false)){
															var _o = orandom(30);
															x += lengthdir_x(16, _d + _o);
															y += lengthdir_y(16, _d + _o);
															right *= choose(-1, 1);
															gunangle = 90 + (angle_difference(90, gunangle) * right) + orandom(20);
															array_push(_inst, self);
														}
													}
													break;
											}
											
											array_push(_inst, self);
										}
										
										_d += (_off * 2) / (_num - 1);
									}
								}
							}
							
							 // Corner Prop:
							var	_x = choose(_cx - (_w / 2) + 16, _cx + (_w / 2) - 16),
								_y = choose(_cy - (_h / 2) + 16, _cy + (_h / 2) - 16),
								_obj = MoneyPile;
								
							if(abs(angle_difference(_dir + 180, point_direction(_cx, _cy, _x, _y))) < 90){
								_obj = Table;
							}
							
							with(instance_create(_x, _y, _obj)){
								switch(_obj){
									case Table:
										spr_idle = sprFallenChair;
										spr_hurt = sprFallenChairHurt;
										spr_dead = sprFallenChairDead;
										break;
								}
							}
							
							 // Loot:
							var _num = 3 + skill_get(mut_open_mind);
							if(_num > 0){
								for(var _side = ((_num > 1) ? -1 : 0); _side <= 1; _side += 2 / (_num - 1)){
									var	_ox = ((abs(_side) < 1) ? -24 : -32),
										_oy = -32,
										_x = _cx + lengthdir_x((_w / 2) + _ox, _dir) + (lengthdir_x((_w / 2) + _oy, _dir - 90) * _side) + orandom(2),
										_y = _cy + lengthdir_y((_h / 2) + _ox, _dir) + (lengthdir_y((_h / 2) + _oy, _dir - 90) * _side) + orandom(2),
										_obj = choose(choose(WeaponChest, AmmoChest), AmmoChestMystery, MoneyPile);
										
									if(abs(_side) < 1){
										_obj = choose("CatChest", "BatChest", "RatChest");
									}
									
									with(call(scr.chest_create, _x, _y, _obj, true)){
										x = xstart;
										y = ystart;
									}
									
									 // Light:
									with(call(scr.obj_create, _x, _y - 28, "CatLight")){
										sprite_index = spr.CatLightThin;
										image_xscale *= 1.2;
									}
								}
							}
							
							_end = true;
							break;
						}
					}
					
					if(_end) break;
				}
			}
			
			if(_end) break;
		}
	}
	
#define GatorDen_step
	if(array_length(inst)){
		with(inst){
			 // Deactivate:
			if(
				instance_exists(self)
				&& sprite_index != spr_hurt
				&& distance_to_object(Player) > 80
			){
				alarm1 = -1;
				if(instance_is(self, GatorSmoke)){
					timer = 0;
				}
			}
			
			 // Reactivate:
			else{
				with(other){
					var _alert = false;
					
					with(inst){
						 // Stop Smoking:
						if(instance_is(self, GatorSmoke)){
							var	_x = x,
								_y = y;
								
							with(instance_create(_x, _y, Shell)) sprite_index = sprCigarette;
							instance_change(Gator, true);
							x = _x;
							y = _y;
						}
						
						 // Reactivate:
						if(instance_is(self, enemy)){
							if(alarm1 < 0){
								alarm1 = 25 + random(10);
							}
							
							 // Alerted:
							if(enemy_target(x, y) && target_visible && my_health > 0){
								_alert = true;
								
								var _ready = (sign(right) == sign(dcos(gunangle)));
								enemy_look(target_direction + orandom(20));
								
								 // Move:
								if(_ready){
									alarm1 /= 2;
									enemy_walk(gunangle + 180 + orandom(30), random(15));
								}
								
								 // Reload:
								else{
									wkick = -4;
									instance_create(x + lengthdir_x(4, gunangle), y + lengthdir_y(4, gunangle), WepSwap);
									if(variable_instance_get(self, "spr_weap") != spr.AlbinoGatorWeap){
										with(call(scr.fx, x, y, [gunangle + (90 * right), 2 + random(2)], Shell)){
											sprite_index = sprShotShell;
										}
									}
								}
							}
						}
					}
					
					 // Alert:
					if(_alert){
						with(call(scr.alert_create, noone, spr.GatorAlert)){
							x         = other.x
							y         = other.y - 16;
							vspeed    = -2;
							snd_flash = sndBuffGatorHit;
						}
					}
					
					 // ?
					else with(inst){
						if(instance_is(self, enemy) && my_health > 0){
							with(call(scr.alert_create, self, -1)){
								alert.spr = spr.AlertIndicatorMystery;
								alert.col = c_yellow;
								target_y -= 2;
								alarm0    = irandom_range(50, 70);
								blink     = irandom_range(6, 15);
							}
						}
					}
					
					inst = [];
				}
				break;
			}
		}
	}
	
	
#define RavenArena_text    return `ENTER ${event_tip}THE RING`;
#define RavenArena_area    return area_scrapyards;
#define RavenArena_chance  return 1/40;


#define RavenArena_setup
	inst_top  = [];
	inst_idle = [];
	
#define RavenArena_create
	var	_w          = 6 + ceil(GameCont.loops / 2.5),
		_h          = _w,
		_type       = "round",
		_dirOff     = 60,
		_floorDis   = ((GameCont.subarea == 3) ? -16 : 0),
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 32,
		_spawnFloor = FloorNormal,
		_instTop    = inst_top,
		_instIdle   = inst_idle,
		_wepDis     = random(12),
		_wepDir     = random(360);
		
	floor_set_align(32, 32);
	
	with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
		 // Decals:
		repeat(3){
			call(scr.obj_create, x, y, "TopDecal");
		}
		
		 // Round Off Corners:
		for(var _x = x1; _x < x2; _x += 16){
			for(var _y = y1; _y < y2; _y += 16){
				var	_cx = _x + 8,
					_cy = _y + 8;
					
				if(
					(_cx < x1 + 64 || _cx > x2 - 64) &&
					(_cy < y1 + 64 || _cy > y2 - 64)
				){
					var	_sideX = ((_x <= x1 || _x >= x2 - 16) ? sign(_cx - x) : 0),
						_sideY = ((_y <= y1 || _y >= y2 - 16) ? sign(_cy - y) : 0);
						
					if(_sideX != 0 || _sideY != 0){
						with(other){
							if(position_meeting(_cx + (16 * _sideX), _cy + (16 * _sideY), Wall)){
								var	_cornerX = ((_cx < x) ? other.x1 : other.x2 - 32),
									_cornerY = ((_cy < y) ? other.y1 : other.y2 - 32);
									
								if(!collision_rectangle(_cornerX, _cornerY, _cornerX + 31, _cornerY + 31, Floor, false, false)){
									instance_create(_x, _y, Wall);
								}
							}
						}
					}
				}
			}
		}
		
		 // Front Row Seating:
		with(Wall){
			if(place_meeting(x, y, Floor) && !collision_line(other.x, other.y, bbox_center_x, bbox_center_y, Wall, false, true)){
				if(chance(1, 4)){
					with(call(scr.top_create, bbox_center_x + orandom(2), y - 8 + orandom(2), "TopRaven", 0, 0)){
						array_push(_instTop, self);
					}
				}
			}
		}
		
		 // Back Row Seating:
		var	_ang = random(360),
			_num = 3 + ceil(GameCont.loops / 4);
			
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			with(call(scr.top_create, x, y, ((GameCont.loops > 0 && chance(1, 2)) ? MeleeFake : Tires), _dir + orandom(40), 16)){
				with(target){
					 // Perched Raven:
					with(call(scr.top_create, x, y + 1, "TopRaven", 0, 0)){
						z += max(0, ((sprite_get_bbox_bottom(other.spr_idle) + 1) - sprite_get_bbox_top(other.spr_idle)) - 5);
						array_push(_instTop, self);
					}
					
					 // Ravens:
					var	_num = 3 + ceil(GameCont.loops / 2),
						_l   = 24;
						
					for(var _d = _dir; _d < _dir + 360; _d += (360 / _num)){
						with(call(scr.top_create, x + lengthdir_x(_l, _d), y + lengthdir_x(_l, _d), "TopRaven", _d + orandom(40), -1)){
							array_push(_instTop, self);
						}
					}
				}
			}
		}
		
		 // Fire Pit:
		if(teevent_get_active("FirePit")){
			call(scr.obj_create, x, y, "TrapSpin");
			_wepDis += 32;
		}
		
		 // Enemies:
		else{
			 // Big Dog:
			if(instance_exists(BecomeScrapBoss)){
				with(instance_nearest(x, y, BecomeScrapBoss)){
					x = other.x;
					y = other.y;
				}
				_wepDis += 48;
			}
			
			 // Generic Enemies:
			if(!instance_exists(BecomeScrapBoss) || GameCont.loops > 0){
				var	_obj = [choose(Raven, Salamander, Exploder), choose(Sniper, MeleeFake)],
					_ang = random(360),
					_num = 4 * (1 + GameCont.loops);
					
				if(GameCont.loops > 0){
					array_push(_obj, choose("Pelican", BuffGator));
				}
				
				for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
					var _objNum = array_length(_instIdle);
					if(_objNum >= array_length(_obj)){
						_objNum = irandom(array_length(_obj) - 1);
					}
					with(call(scr.obj_create, x, y, _obj[_objNum])){
						array_push(_instIdle, self);
						move_contact_solid(_dir + orandom(20), random_range(16, 64));
						
						 // Loop Groups:
						if(chance(GameCont.loops, 60)){
							repeat(3 + GameCont.loops){
								array_push(_instIdle, instance_copy(false));
							}
						}
					}
				}
			}
		}
		
		 // Weapon:
		with(call(scr.obj_create, x + lengthdir_x(_wepDis, _wepDir), y + lengthdir_y(_wepDis, _wepDir), "WepPickupGrounded")){
			target = instance_create(x, y, WepPickup);
			with(target){
				var _noWep = [];
				with(Player){
					array_push(_noWep, wep);
					array_push(_noWep, bwep);
				}
				wep  = call(scr.weapon_decide, 2, 1 + GameCont.hard, false, _noWep);
				ammo = true;
				roll = true;
			}
		}
	}
	
	floor_reset_align();
	
	with(inst_top){
		jump_time = -1;
	}
	
#define RavenArena_step
	 // Hold Enemies:
	if(array_length(inst_idle)){
		with(inst_idle){
			if(instance_exists(self) && sprite_index != spr_hurt){
				if("walk" in self){
					if(walk > 0){
						walk -= 4 * current_time_scale;
					}
				}
				else{
					direction = angle_lerp_ct(direction, point_direction(x, y, other.x, other.y), 0.04);
				}
			}
			else other.inst_idle = call(scr.array_delete_value, other.inst_idle, self);
		}
	}
	
	 // Activate Ravens:
	if(array_length(inst_top)){
		var _player = instance_nearest(x, y, Player);
		if(instance_exists(_player) && point_distance(x, y, _player.x, _player.y) < 96){
			var _time = 60;
			with(instances_matching_lt(inst_top, "jump_time", 0)){
				jump_time = _time * (128 / point_distance(x, y, other.x, other.y));
				_time += random_range(15 + (2400 / _time), 60);
			}
			inst_idle = [];
			inst_top  = [];
		}
	}
	
	
#define FirePit_text    return `${event_tip}RAIN DROPS @sTURN TO ${event_tip}STEAM`;
#define FirePit_area    return area_scrapyards;
#define FirePit_chance  return ((GameCont.subarea != 3) ? 1/12 : 0);

#define FirePit_setup
	 // Bind Steam Spawning Script:
	bind_setup_steam = call(scr.ntte_bind_setup, script_ref_create(FirePit_setup_steam), RainSplash);
	
#define FirePit_create
	var	_spawnX = spawn_x,
		_spawnY = spawn_y;
		
	 // More Traps:
	var _num = floor(array_length(FloorNormal) / 30);
	with(call(scr.array_shuffle, instances_matching_ne(Wall, "id"))){
		if(_num > 0){
			if(place_meeting(x, y, Floor) && point_distance(bbox_center_x, bbox_center_y, _spawnX, _spawnY) > 64/* && chance(3, 5)*/){
				if(!array_length(call(scr.instances_in_rectangle, bbox_left, bbox_top, bbox_right, bbox_bottom, Trap))){
					var _spawn = true;
					with(teevent_get_active("RavenArena")){
						var _wall = other;
						with(instances_matching_ne(floors, "id")){
							if(place_meeting(x, y, _wall)){
								_spawn = false;
								break;
							}
						}
					}
					if(_spawn){
						_num--;
						instance_create(x, y, Trap);
					}
				}
			}
		}
		else break;
	}
	/*with(Trap){
		alarm0 = 150;
		with(instance_copy(false)){
			side = !side;
		}
	}*/
	
	 // Spinny Trap Room:
	if(!teevent_get_active("RavenArena")){
		var _cx  = 0,
			_cy  = 0,
			_num = 0;
			
		with(FloorNormal){
			_cx += bbox_center_x;
			_cy += bbox_center_y;
			_num++;
		}
		if(_num > 0){
			_cx /= _num;
			_cy /= _num;
			floor_set_align(32, 32);
			with(floor_room_create(_cx, _cy, 4, 4, "", point_direction(x, y, _cx, _cy), 30, -32)){
				call(scr.obj_create, x, y, "TrapSpin");
			}
			floor_reset_align();
		}
	}
	
	 // Baby Scorches:
	with(FloorNormal) if(chance(1, 4)){
		with(instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Scorchmark)){
			sprite_index = spr.FirePitScorch;
			image_index  = irandom(image_number - 1);
			image_speed  = 0;
			image_angle  = random(360);
		}
	}
	
/*#define FirePit_step
	 // Arcing Traps:
	if(instance_exists(TrapFire){
		var _inst = instances_matching(TrapFire, "firepitevent_check", null);
		if(array_length(_inst)) with(_inst){
			firepitevent_check = (instance_exists(creator) ? instance_is(creator, Trap) : 57);
			
			if(firepitevent_check){
				with(instance_exists(creator) ? creator : instance_nearest(xstart, ystart, Trap)){
					other.direction += 5 * dsin(360 * (fire / 45));
				}
			}
		}
	}
	*/
	
#define FirePit_cleanup
	 // Unbind Script:
	call(scr.ntte_unbind, bind_setup_steam);
	
#define FirePit_setup_steam(_inst)
	 // Rain Turns to Steam:
	with(_inst){
		with(instance_create(x, y, Breath)){
			image_yscale = choose(-1, 1);
			image_angle  = random(90);
			if(!place_meeting(x, y + 8, Floor)){
				depth = -8;
			}
		}
	}
	
	
#define SealPlaza_text    return `${event_tip}DISTANT RELATIVES`;
#define SealPlaza_area    return area_city;
#define SealPlaza_chance  return (call(scr.unlock_get, "pack:coast") ? 1/18 : 0);

#define SealPlaza_setup
	 // Smaller Level:
	with(instances_matching_gt([GenCont, FloorMaker], "goal", 0)){
		goal = ceil(goal * 0.8);
	}
	
#define SealPlaza_create
	var	_minID      = instance_max,
		_w          = 3,
		_h          = 3,
		_type       = "",
		_dirOff     = 0,
		_floorDis   = -32,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 160,
		_spawnFloor = FloorNormal;
		
	floor_set_align(32, 32);
	
	with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
		 // Royal Presence:
		var _img = 0;
		with(floor_fill(x, y, _w + 2, _h + 2)){
			sprite_index = spr.FloorSealRoomBig;
			image_index  = _img++;
		}
		call(scr.obj_create, x, y - 6, "PalankingStatue");
		
		 // Main Igloos:
		//var _floorRoad = [];
		for(var _dir = 0; _dir < 360; _dir += 90){
			var	_iglooW = 3,
				_iglooH = 3,
				_pathX1 = x + lengthdir_x(16 * (_w + 2), _dir),
				_pathY1 = y + lengthdir_y(16 * (_h + 2), _dir),
				_pathX2 = _pathX1,
				_pathY2 = _pathY1;
				
			 // Avoid Spawn:
			var	_dis = point_distance(x, y, _spawnX, _spawnY),
				_x1  = x - lengthdir_x(ceil(_iglooW / 2) * 32, _dir - 90),
				_y1  = y - lengthdir_y(ceil(_iglooH / 2) * 32, _dir - 90),
				_x2  = x + lengthdir_x(ceil(_iglooW / 2) * 32, _dir - 90) + lengthdir_x(_dis, _dir),
				_y2  = y + lengthdir_y(ceil(_iglooH / 2) * 32, _dir - 90) + lengthdir_y(_dis, _dir);
				
			if(point_in_rectangle(_spawnX, _spawnY, min(_x1, _x2), min(_y1, _y2), max(_x1, _x2), max(_y1, _y2))){
				_pathX2 = x + lengthdir_x(max(0, _dis - 64), _dir);
				_pathY2 = y + lengthdir_y(max(0, _dis - 64), _dir);
			}
			
			 // Igloo Room:
			else with(floor_room_create(x, y, _iglooW, _iglooH, "", _dir, 0, 0)){
				var _img = 0;
				with(floors){
					sprite_index = spr.FloorSealRoom;
					image_index  = _img++;
				}
				with(call(scr.obj_create, x, y - 2, "Igloo")){
					chest = true;
				}
				_pathX2 = x - lengthdir_x(_iglooW * 16, _dir);
				_pathY2 = y - lengthdir_y(_iglooH * 16, _dir);
			}
			
			 // Path:
			var _pathDis = point_distance(_pathX1, _pathY1, _pathX2, _pathY2);
			for(var _dis = 16; _dis < _pathDis; _dis += 32){
				with(floor_set(
					_pathX1 + lengthdir_x(_dis, _dir) - 16,
					_pathY1 + lengthdir_y(_dis, _dir) - 16,
					true
				)){
					sprite_index = spr.FloorSeal;
					//array_push(_floorRoad, self);
					
					 // Props:
					if(chance(1, 5)){
						if(!place_meeting(x, y, prop) && !place_meeting(x, y, chestprop)){
							with(instance_create(bbox_center_x, bbox_center_y, choose(Hydrant, StreetLight, Car))){
								x = xstart;
								y = ystart;
								if(instance_is(self, StreetLight)){
									move_contact_solid(90, 8);
								}
							}
						}
					}
					
					 // Push Props Off Path:
					with(call(scr.instances_in_rectangle, bbox_left, bbox_top, bbox_right + 1, bbox_bottom + 1, instances_matching_lt(prop, "size", 3))){
						if(_dir == 90 || _dir == 270 || !instance_is(self, Car)){
							var	_try = true,
								_off = choose(-90, 90);
								
							for(var i = -1; i <= 1; i += 2){
								var	_x = x,
									_y = y;
									
								move_contact_solid(_dir + (_off * i), 32);
								
								if(
									!point_in_rectangle(x, y, other.bbox_left, other.bbox_top, other.bbox_right + 1, other.bbox_bottom + 1)
									&& !place_meeting(x, y, prop)
									&& !place_meeting(x, y, chestprop)
								){
									_try = false;
									break;
								}
								
								x = _x;
								y = _y;
							}
							if(_try){
								move_contact_solid(_dir, 32);
							}
						}
					}
				}
			}
		}
		
		 // Other Igloos:
		with(instances_matching_ne(obj.Igloo, "id")){
			 // Face Statue:
			if(x != other.x){
				image_xscale = sign(other.x - x);
			}
			
			/*
			 // Connect to Main Road:
			if((x < other.x1 || x > other.x2) && (y < other.y1 || y > other.y2)){
				with(call(scr.instance_nearest_bbox, x, y, _floorRoad)){
					if((other.x >= bbox_left && other.x < bbox_right + 1) || (other.y >= bbox_top && other.y < bbox_bottom + 1)){
						with(floor_fill(
							(other.x + bbox_center_x) / 2,
							(other.y + bbox_center_y) / 2,
							max(1, floor(abs(other.x - bbox_center_x) / 32) - 1),
							max(1, floor(abs(other.y - bbox_center_y) / 32) - 1)
						)){
							sprite_index = spr.FloorSeal;
						}
					}
				}
			}
			*/
		}
		
		 // The Neighbors:
		repeat(3){
			instance_create(x, y, Bandit);
		}
	}
	
	floor_reset_align();
	
	 // Floor Setup:
	var	_floorSeal = [spr.FloorSeal,     spr.FloorSealRoom,     spr.FloorSealRoomBig],
		_floorSnow = [spr.SnowFloorSeal, spr.SnowFloorSealRoom, spr.SnowFloorSealRoomBig];
		
	with(instances_matching_gt(Floor, "id", _minID)){
		var i = array_find_index(_floorSeal, sprite_index);
		
		 // Road Tiles:
		if(i >= 0){
			depth    = 8;
			traction = 0.45;
			material = ((i == 0 || array_find_index([0, sqrt(image_number) - 1, image_number - 1, image_number - sqrt(image_number)], image_index) >= 0) ? 2 : 1);
			with(instance_create(x, y - 1, SnowFloor)){
				sprite_index = _floorSnow[i];
				image_index  = other.image_index;
				image_speed  = other.image_speed;
			}
		}
		
		 // Corner Walls:
		if(!place_meeting(x - 32, y, Floor) && !place_meeting(x, y - 32, Floor)/* && !place_meeting(x, y, hitme)*/) instance_create(x,      y,      Wall);
		if(!place_meeting(x + 32, y, Floor) && !place_meeting(x, y - 32, Floor)/* && !place_meeting(x, y, hitme)*/) instance_create(x + 16, y,      Wall);
		if(!place_meeting(x - 32, y, Floor) && !place_meeting(x, y + 32, Floor)/* && !place_meeting(x, y, hitme)*/) instance_create(x,      y + 16, Wall);
		if(!place_meeting(x + 32, y, Floor) && !place_meeting(x, y + 32, Floor)/* && !place_meeting(x, y, hitme)*/) instance_create(x + 16, y + 16, Wall);
	}
	
	
#define YetiHideout_text   return `SMELLS LIKE ${event_tip}WET FUR`;
#define YetiHideout_area   return area_city;
#define YetiHideout_chance return 1/100;

#define YetiHideout_create
	with(call(scr.obj_create, x, y, "BuriedVault")){
		floor_vars      = { sprite_index : spr.FloorSeal     };
		floor_room_vars = { sprite_index : spr.FloorSealRoom };
		obj_prop        = "";
		obj_loot        = "";
		area            = area_city;
	}
	
	
#define MutantVats_text    return `${event_tip}SPECIMENS`;
#define MutantVats_area    return area_labs;
#define MutantVats_chance  return (mod_exists("mod", "tegeneral") ? (("ntte_pet_history" in GameCont && array_length(GameCont.ntte_pet_history)) / 3) : 0);

#define MutantVats_create
	var	_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 128,
		_spawnFloor = FloorNormal,
		_w          = 6,
		_h          = 5,
		_type       = "",
		_dirOff     = 0,
		_floorDis   = 0;
		
	floor_set_align(32, 32);
	
	with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
		var _vatList = [];
		
		/*
		 // Corner Vats:
		array_push(_vatList, call(scr.obj_create, x - 64, y - 44, "MutantVat"));
		array_push(_vatList, call(scr.obj_create, x - 56, y + 36, "MutantVat"));
		array_push(_vatList, call(scr.obj_create, x + 64, y - 44, "MutantVat"));
		array_push(_vatList, call(scr.obj_create, x + 56, y + 36, "MutantVat"));
		
		 // Central Vat:
		_vatList = call(scr.array_combine, [call(scr.obj_create, x, y - 16, "MutantVat")], call(scr.array_shuffle, _vatList));
		*/
		
		 // Vats:
		array_push(_vatList, call(scr.obj_create, x - 64, y - 24, "MutantVat"));
		array_push(_vatList, call(scr.obj_create, x + 64, y - 24, "MutantVat"));
		_vatList = call(scr.array_combine, [call(scr.obj_create, x, y - 40, "MutantVat")], call(scr.array_shuffle, _vatList));
		
		 // Props:
		with(_vatList){
			var	_l = 32,
				_d = point_direction(x, y, other.x, other.y + random_range(64, 128));
				
			with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), Terminal)){
				depth = other.depth - 1;
				with(instance_create(x + lengthdir_x(16, _d), y + lengthdir_y(24, _d), Necromancer)){
					alarm1 = 600 + random(150);
					enemy_look(_d + 180);
				}
			}
		}
		
		 // Petify:
		if("ntte_pet_history" in GameCont){
			var _numVats = array_length(_vatList);
			for(var i = min(_numVats, array_length(GameCont.ntte_pet_history)) - 1; i >= 0; i--){
				if(chance(1 - (i / _numVats), 1)){
					with(_vatList[i]){
						type     = "Pet";
						pet_data = GameCont.ntte_pet_history[i];
						spr_dude = call(scr.pet_get_sprite, pet_data[0], pet_data[1], pet_data[2], lq_defget(pet_data[3], "bskin", 0), "idle");
					}
					
					 // Remove From Pool:
					GameCont.ntte_pet_history = call(scr.array_delete, GameCont.ntte_pet_history, i);
				}
			}
		}
		
		 // Ring:
		floor_set_style(1);
		floor_fill(x, y, _w, _h, "ring");
	}
	
	floor_reset_align();
	floor_reset_style();
	
	
#define ButtonGame_text    return `NEVER TOUCH THE ${event_tip}RED BUTTON`;
#define ButtonGame_area    return area_labs;
#define ButtonGame_chance  return 1/4;

#define ButtonGame_create
	var	_w          = 4,
		_h          = 4,
		_type       = "",
		_dirOff     = 0,
		_floorDis   = -32,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 32,
		_spawnFloor = FloorNormal;
		
	floor_set_align(32, 32);
	
	with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
		 // The Button:
		call(scr.obj_create, x, y, "Button");
		
		 // Ring:
		floor_set_style(1);
		floor_fill(x, y, _w, _h, "ring");
	}
	
	floor_reset_align();
	floor_reset_style();

	/*
	var _w          = 5,
		_h          = 5,
		_type       = "",
		_dirOff     = 0,
		_floorDis   = -32,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 32,
		_spawnFloor = FloorNormal;
		
	floor_set_align(32, 32);
	
	with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
		 // The Button:
		call(scr.obj_create, x, y, "Button");
		
		 // Ring:
		floor_set_style(1);
		
		var _floors = floor_fill(x, y, _w, _h, "ring");
		repeat(5){
			with(call(scr.instance_random, _floors)){
				var o = (chance(1, 4) ? "ButtonChest" : "ButtonPickup")
				call(scr.obj_create, bbox_center_x + orandom(2), bbox_center_y + orandom(2), o);
			}
		}
	}
	
	floor_reset_align();
	floor_reset_style();
	*/
	
	
#define PalaceShrine_text    return choose(`${event_tip}RAD MANIPULATION @sIS @wKINDA TRICKY`, `${event_tip}FINAL PROVISIONS`);
#define PalaceShrine_area    return area_palace;
#define PalaceShrine_chance  return ((GameCont.subarea == 2 && array_length(PalaceShrine_skills()) > 0) ? (1 / (1 + max(0, GameCont.wepmuts))) : 0);

#define PalaceShrine_create
	/*
		This is WIP and I know u will look here so I will explain my plans. It's also 2am and I dunno if I'll remember what I wanted tomorrow
		
		To be composed of three room types:
		 1. Main Room:
			- Pretty empty, meant to be like an atrium of sorts
			- Custom single floors resembling the big vault tiles but in palace colors
		 2. Altar Rooms:
			- Each contains an altar
			- Custom 2x2 or 3x3 floor patterns
		 3. Decor Rooms:
			- Small rooms with decorative props
			- Custom single floors
			
		Rooms don't necessarily have to be connected so long as they spawn close enough but it would be nice u know.
		we epic
	*/
	
	var	_minID      = instance_max,
		_skillArray = call(scr.array_shuffle, PalaceShrine_skills()),
		_skillCount = min(array_length(_skillArray), 2 + irandom(2)),
		_w          = choose(3, 4),
		_h          = choose(3, 4),
		_type       = "",
		_dirOff     = 0,
		_dirStart   = random(360),
		_floorDis   = 0,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 128,
		_spawnFloor = FloorNormal;
		
	floor_set_align(32, 32);
	
	with(floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)){
		
		 // Main Decorative Room:
		with(floor_room_create(x, y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
			
			 // Altar Rooms:
			for(var i = 0; i < _skillCount; i++){
				var	_roomSize = choose(2, 3),
					_roomDir = _dirStart + orandom(45);
					
				with(floor_room_create(x, y, _roomSize, _roomSize, _type, _roomDir, _dirOff, _floorDis)){
					with(call(scr.obj_create, x, y - 10, "PalaceAltar")){
						skill = _skillArray[i];
					}
					
					 // Beautify Rooms:	 
					for(var j = 0; j < array_length(floors); j++){
						with(floors[j]){
							sprite_index = ((_roomSize == 3) ? spr.FloorPalaceShrineRoomLarge : spr.FloorPalaceShrineRoomSmall);
							image_index	= j;
							depth = 8;
						}
					}
				}
			}
			
			 // Small Decorative Side Rooms:
			repeat(2 + irandom(2)){
				var _decorRoomSize = choose(1, 1, 1, 2);
				with(floor_room_create(x, y, _decorRoomSize, _decorRoomSize, "", 0, 360, _floorDis)){
					if(chance(2, 3)){
						instance_create(x, y, Pillar);
					}
				}
			}
			
			 // Decals:
			repeat(3) call(scr.obj_create, x, y, "TopDecal");
		}
		
		 // Fancify:
		with(instances_matching_ne(instances_matching_gt(FloorNormal, "id", _minID), "sprite_index", spr.FloorPalaceShrineRoomSmall, spr.FloorPalaceShrineRoomLarge)){
			sprite_index = spr.FloorPalaceShrine;
			image_index = irandom(image_number - 1);
			depth = 8;
		}
	}
	
	floor_reset_align();
	
#define PalaceShrine_skills
	/*
		Compiles a list of weapon mutations based on the player's weapon loadout and mutation selection
	*/
	
	var	_list = [],
		_pool = [];
		
	 // Normal:
	with(instances_matching_ne([Player, Revive], "id")){
		with([wep, bwep]){
			var	_wep = self,
				_raw = call(scr.wep_raw, _wep);
				
			with(other) with(self){
				switch(_raw){
					
					case wep_none:
						
						array_push(_list, mut_last_wish);
						
						break;
						
					case wep_incinerator:
						
						array_push(_list, mut_shotgun_shoulders);
						
						break;
						
					case wep_jackhammer:
						
						array_push(_list, mut_long_arms);
						
						break;
						
					case wep_lightning_hammer:
						
						array_push(_list, mut_long_arms);
						array_push(_list, mut_laser_brain);
						
						break;
						
					default:
						
						 // Custom:
						var _shrine = call(scr.weapon_get, "shrine", _wep);
						if(_shrine != mut_none){
							_list = call(scr.array_combine, 
								_list,
								(is_array(_shrine) ? _shrine : [_shrine])
							);
						}
						
						 // Normal:
						else{
							var	_type  = weapon_get_type(_wep),
								_split = string_split(string_upper(call(scr.string_delete_nt, weapon_get_name(_wep))), " ");
								
							 // Type-Specific:
							switch(_type){
								case type_melee     : array_push(_list, mut_long_arms);         break;
								case type_bullet    : array_push(_list, mut_recycle_gland);     break;
								case type_shell     : array_push(_list, mut_shotgun_shoulders); break;
								case type_bolt      : array_push(_list, mut_bolt_marrow);       break;
								case type_explosive : array_push(_list, mut_boiling_veins);     break;
								case type_energy    : array_push(_list, mut_laser_brain);       break;
							}
							
							 // Melee:
							if(weapon_is_melee(_wep)){
								array_push(_list, mut_long_arms);
							}
							
							 // Ultra:
							if(weapon_get_rads(_wep) > 0){
								array_push(_list, "lead ribs");
							}
							
							 // Toxic:
							if(array_find_index(_split, "TOXIC") >= 0){
								array_push(_list, "toad breath");
							}
							
							 // Blood:
							if(array_find_index(_split, "BLOOD") >= 0){
								array_push(_list, mut_bloodlust);
							}
							
							 // Pop:
							if(array_find_index(_split, "POP") >= 0 && _type == type_bullet){
								array_push(_list, mut_shotgun_shoulders);
							}
						}
						
				}
			}
		}
	}
	
	 // Modded:
	with(call(scr.array_shuffle, mod_get_names("skill"))){
		var	_skill = self,
			_found = false;
			
		with(other){
			if(
				mod_script_exists("skill", _skill, "skill_wepspec")
				&& mod_script_call_self("skill", _skill, "skill_wepspec")
			){
				if(call(scr.skill_get_avail, _skill)){
					array_push(_list, _skill);
					_found = true;
				}
			}
		}
		
		if(_found){
			break;
		}
	}
	
	 // Compile Skill Pool:
	with(_list){
		var _skill = self;
		with(other){
			if(!is_string(_skill) || mod_exists("skill", _skill)){
				if(
					skill_get(_skill) == 0
					&& skill_get_active(_skill)
					&& array_find_index(_pool, _skill) < 0
				){
					array_push(_pool, _skill);
				}
			}
		}
	}
	
	return _pool;
	
	
#define PopoAmbush_text    return choose(`${event_tip}THE ${(player_count_race(char_venuz) > 0) ? "POPO" : "I.D.P.D."} @sIS @wWAITING FOR YOU`, `${event_tip}AMBUSHED`);
#define PopoAmbush_area    return area_palace;
#define PopoAmbush_chance  return ((GameCont.subarea == 1) ? (clamp((GameCont.popolevel - 5) / 10, 0, 1) / (1 + GameCont.loops)) : 0);

#define PopoAmbush_create
	 // Ambush:
	if(GameCont.loops > 0) repeat(GameCont.loops){
		instance_create(x, y, IDPDSpawn);
	}
	with(call(scr.obj_create, spawn_x, spawn_y, "BigIDPDSpawn")){
		with(call(scr.alert_create, self, (freak ? spr.PopoFreakAlert : spr.PopoEliteAlert))){
			image_speed = 0.1;
			alert       = { spr:spr.AlertIndicatorPopo, x:-5, y:5 };
			target_x    = -3;
			target_y    = -24;
			alarm0      = other.alarm0;
		}
	}
	
	/*
	 // Fewer Guardians:
	with(instances_matching_ne([DogGuardian, ExploGuardian], "id")){
		instance_delete(self);
	}
	with(Guardian){
		if(chance(1, 4)){
			instance_delete(self);
		}
	}
	*/
	
	 // Replace Chest:
	with(AmmoChest){
		call(scr.chest_create, x, y, IDPDChest, true);
		instance_delete(self);
	}
	
	
#define SeaCreature_text    return "SOMETHING IN THE DISTANCE";
#define SeaCreature_area    return "coast";
#define SeaCreature_chance  return ((player_get_alias(0) == "blaac") ? (GameCont.subarea == 2) : ((GameCont.subarea != 3) ? 1/25 : 0));

#define SeaCreature_create
	var	_l = 400,
		_d = random(360);
		
	 // Find Spawn Vector:
	with(Floor){
		var _dis = point_distance(other.spawn_x, other.spawn_y, bbox_center_x, bbox_center_y);
		if(_l < _dis){
			_l = _dis;
			_d = point_direction(other.spawn_x, other.spawn_y, bbox_center_x, bbox_center_y) + 180;
		}
	}
	_l *= 1.75;
	
	 // Loch Ness:
	call(scr.obj_create, spawn_x + lengthdir_x(_l, _d), spawn_y + lengthdir_y(_l, _d), "Creature");
	
	 // Friend:
	with(call(scr.array_shuffle, FloorNormal)){
		if(point_distance(bbox_center_x, bbox_center_y, other.spawn_x, other.spawn_y) > 200){
			instance_create(bbox_center_x, bbox_center_y, Gator);
			break;
		}
	}
	
	
#define EelGrave_text    return `EELS ${event_tip}NEVER @sFORGET`;
#define EelGrave_area    return "trench";
#define EelGrave_chance  return (call(scr.unlock_get, "pack:trench") ? 1/10 : 0);

#define EelGrave_create
	var	_w          = 6,
		_h          = 6,
		_type       = "round",
		_dirOff     = 0,
		_floorDis   = -32,
		_spawnX     = spawn_x,
		_spawnY     = spawn_y,
		_spawnDis   = 80,
		_spawnFloor = FloorNormal;
		
	floor_set_align(32, 32);
	floor_set_style(1, "trench");
	
	with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
		 // Center Island:
		floor_reset_style();
		floor_fill(x, y, _w - 2, _h - 2, _type);
		
		 // Skulls:
		var	_ang = random(360),
			_num = irandom_range(2, 3);
			
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			var	_l = random_range(16, 28),
				_d = _dir + orandom(30 / _num);
				
			call(scr.obj_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "EelSkull");
		}
		
		 // Want Eels, Bro?:
		repeat(15 * (1 + GameCont.loops)){
			with(call(scr.obj_create, x, y, "WantEel")){
				elite = 150;
			}
		}
		
		 // Walls:
		instance_create(x - 48, y - 48, Wall);
		instance_create(x + 32, y - 48, Wall);
		instance_create(x + 32, y + 32, Wall);
		instance_create(x - 48, y + 32, Wall);
	}
	
	floor_reset_align();
	floor_reset_style();
	
	
/// LEVEL MODIFYING
#define floor_set_style // style, ?area
	/*
		Sets the style of the next floor(s) created by 'floor_set'-related scripts
	*/
	
	global.floor_style = argument[0];
	
	if(argument_count > 1){
		global.floor_area = argument[1];
	}
	
#define floor_reset_style()
	floor_set_style(undefined, undefined);
	
#define floor_set_align // alignW, alignH, ?alignX, ?alignY
	/*
		Sets the grid alignment of the next floor(s) created by 'floor_set'-related scripts
	*/
	
	global.floor_align_w = argument[0];
	global.floor_align_h = argument[1];
	
	if(argument_count > 2){
		global.floor_align_x = argument[2];
		if(argument_count > 3){
			global.floor_align_y = argument[3];
		}
	}
	
#define floor_reset_align()
	floor_set_align(undefined, undefined, undefined, undefined);
	
#define floor_align(_x, _y, _w, _h, _type)
	/*
		Returns the given rectangle's position aligned to the floor grid
		Has a bias towards nearby floors to help prevent the rectangle from being disconnected from the level
	*/
	
	var	_gridWAuto = (global.floor_align_w == undefined),
		_gridHAuto = (global.floor_align_h == undefined),
		_gridXAuto = (global.floor_align_x == undefined),
		_gridYAuto = (global.floor_align_y == undefined),
		_gridW     = (_gridWAuto ? 16    : global.floor_align_w),
		_gridH     = (_gridHAuto ? 16    : global.floor_align_h),
		_gridX     = (_gridXAuto ? 10000 : global.floor_align_x),
		_gridY     = (_gridYAuto ? 10000 : global.floor_align_y),
		_gridXBias = 0,
		_gridYBias = 0;
		
	if(_gridWAuto || _gridHAuto || _gridXAuto || _gridYAuto){
		if(!instance_exists(FloorMaker)){
			 // Align to Nearest Floor:
			if(_gridXAuto || _gridYAuto){
				with(call(scr.instance_nearest_rectangle_bbox, _x, _y, _x + _w, _y + _h, Floor)){
					if(_gridXAuto){
						_gridX     = x;
						_gridXBias = bbox_center_x - (_x + (_w / 2));
					}
					if(_gridYAuto){
						_gridY     = y;
						_gridYBias = bbox_center_y - (_y + (_h / 2));
					}
				}
			}
			
			 // Align to Largest Colliding Floor:
			var	_fx    = _gridX + floor_align_round(_x - _gridX, _gridW, _gridXBias),
				_fy    = _gridY + floor_align_round(_y - _gridY, _gridH, _gridYBias),
				_fwMax = _gridW,
				_fhMax = _gridH;
				
			with(call(scr.instances_meeting_rectangle, _fx, _fy, _fx + _w - 1, _fy + _h - 1, Floor)){
				var	_fw = bbox_width,
					_fh = bbox_height;
					
				if(_fw >= _fwMax){
					_fwMax = _fw;
					if(_gridWAuto){
						_gridW = _fwMax;
					}
					if(_gridXAuto){
						_gridX     = x;
						_gridXBias = bbox_center_x - (_x + (_w / 2));
					}
				}
				if(_fh >= _fhMax){
					_fhMax = _fh;
					if(_gridHAuto){
						_gridH = _fhMax;
					}
					if(_gridYAuto){
						_gridY     = y;
						_gridYBias = bbox_center_y - (_y + (_h / 2));
					}
				}
			}
			
			 // No Unnecessary Bias:
			if(_gridXBias != 0 || _gridYBias != 0){
				_fx = _gridX + floor_align_round(_x - _gridX, _gridW, 0);
				_fy = _gridY + floor_align_round(_y - _gridY, _gridH, 0);
				with(UberCont){
					if(
						(_type == "round")
						? (
							collision_rectangle(_fx + 32, _fy,     _fx + _w - 32 - 1, _fy + _h - 1,      Floor, false, false) ||
							collision_rectangle(_fx,      _fy + 32, _fx + _w - 1,     _fy + _h - 32 - 1, Floor, false, false)
						)
						: collision_rectangle(_fx, _fy, _fx + _w - 1, _fy + _h - 1, Floor, false, false)
					){
						_gridXBias = 0;
						_gridYBias = 0;
					}
				}
			}
		}
		
		 // FloorMaker:
		else with(instance_nearest(_x + max(0, (_w / 2) - 16), _y + max(0, (_h / 2) - 16), FloorMaker)){
			if(_gridXAuto) _gridX = x;
			if(_gridYAuto) _gridY = y;
			if(_gridWAuto) _gridW = min(_w, 32);
			if(_gridHAuto) _gridH = min(_h, 32);
		}
	}
	
	 // Align:
	return [
		_gridX + floor_align_round(_x - _gridX, _gridW, _gridXBias),
		_gridY + floor_align_round(_y - _gridY, _gridH, _gridYBias)
	];
	
#define floor_align_round(_num, _precision, _bias)
	var _value = _num;
	if(_precision != 0){
		_value /= _precision;
		
		if(_bias < 0){
			_value = floor(_value);
		}
		else if(_bias > 0 || frac(_value) == 0.5){ // No sig-fig rounding
			_value = ceil(_value);
		}
		else{
			_value = round(_value);
		}
		
		_value *= _precision;
	}
	return _value;
	
#define floor_set(_x, _y, _state) // imagine if floors and walls just used a ds_grid bro....
	var _inst = noone;
	
	 // Create Floor:
	if(_state){
		var	_obj = ((_state >= 2) ? FloorExplo : Floor),
			_msk = object_get_mask(_obj),
			_w   = ((sprite_get_bbox_right (_msk) + 1) - sprite_get_bbox_left(_msk)),
			_h   = ((sprite_get_bbox_bottom(_msk) + 1) - sprite_get_bbox_top (_msk));
			
		 // Align to Adjacent Floors:
		var _gridPos = floor_align(_x, _y, _w, _h, "");
		_x = _gridPos[0];
		_y = _gridPos[1];
		
		 // Clear Floors:
		if(!instance_exists(FloorMaker)){
			if(_obj == FloorExplo){
				with(instances_matching(instances_matching(_obj, "x", _x), "y", _y)){
					instance_delete(self);
				}
			}
			else{
				floor_delete(_x, _y, _x + _w - 1, _y + _h - 1);
			}
		}
		
		 // Floorify:
		var	_floorMaker = noone,
			_lastArea   = GameCont.area;
			
		if(global.floor_style != undefined){
			GameCont.area = area_campfire;
			with(instance_create(_x, _y, FloorMaker)){
				with(instances_matching_gt(Floor, "id", id)){
					instance_delete(self);
				}
				styleb = global.floor_style;
				_floorMaker = self;
			}
			GameCont.area = _lastArea;
		}
		if(global.floor_area != undefined){
			GameCont.area = global.floor_area;
		}
		_inst = instance_create(_x, _y, _obj);
		with(_floorMaker){
			instance_destroy();
		}
		if(!instance_exists(FloorMaker)){
			with(_inst){
				 // Clear Area:
				call(scr.wall_delete, bbox_left, bbox_top, bbox_right, bbox_bottom);
				
				 // Details:
				if(_obj != FloorExplo && chance(1, 6)){
					instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Detail);
				}
			}
		}
		GameCont.area = _lastArea;
		
		 // Wallerize:
		if(instance_exists(Wall)){
			with(_inst){
				call(scr.floor_walls, self);
				call(scr.wall_update, bbox_left - 16, bbox_top - 16, bbox_right + 16, bbox_bottom + 16);
			}
		}
	}
	
	 // Destroy Floor:
	else with(call(scr.instances_meeting_point, _x, _y, Floor)){
		var	_x1 = bbox_left   - 16,
			_y1 = bbox_top    - 16,
			_x2 = bbox_right  + 16,
			_y2 = bbox_bottom + 16;
			
		with(call(scr.instances_meeting_instance, self, SnowFloor)){
			if(point_in_rectangle(bbox_center_x, bbox_center_y, other.bbox_left, other.bbox_top, other.bbox_right + 1, other.bbox_bottom + 1)){
				instance_destroy();
			}
		}
		
		instance_destroy();
		
		if(instance_exists(Wall)){
			with(other){
				 // Un-Wall:
				call(scr.wall_delete, _x1, _y1, _x2, _y2);
				
				 // Re-Wall:
				for(var _fx = _x1; _fx < _x2 + 1; _fx += 16){
					for(var _fy = _y1; _fy < _y2 + 1; _fy += 16){
						if(!position_meeting(_fx, _fy, Floor)){
							if(collision_rectangle(_fx - 16, _fy - 16, _fx + 31, _fy + 31, Floor, false, false)){
								instance_create(_fx, _fy, Wall);
							}
						}
					}
				}
				call(scr.wall_update, _x1 - 16, _y1 - 16, _x2 + 16, _y2 + 16);
			}
		}
	}
	
	return _inst;
	
#define floor_fill // x, y, w, h=w, ?type
	/*
		Creates a rectangular area of floors around the given position
		
		Args:
			x/y  - The rectangular area's center position
			w    - The number of floors to fill horizontally
			h    - The number of floors to fill vertically, defaults to the width
			type - Shape modifier for the area, leave undefined for no change
			       Can be "round" for no corners, or "ring" for no inner floors
			
		Ex:
			floor_fill(x, y, 3)
				###
				###
				###
				
			floor_fill(x, y, 5, 4, "round")
				 ###
				#####
				#####
				 ###
				 
			floor_fill(x, y, 4, 4, "ring")
				####
				#  #
				#  #
				####
	*/
	
	var	_x    = argument[0],
		_y    = argument[1],
		_w    = argument[2],
		_h    = ((argument_count > 3) ? argument[3] : _w),
		_type = ((argument_count > 4) ? argument[4] : ""),
		_ow   = 32,
		_oh   = 32;
		
	_w *= _ow;
	_h *= _oh;
	
	 // Center & Align:
	_x -= (_w / 2);
	_y -= (_h / 2);
	var _gridPos = floor_align(_x, _y, _w, _h, _type);
	_x = _gridPos[0];
	_y = _gridPos[1];
	
	 // Floors:
	var	_aw   = global.floor_align_w,
		_ah   = global.floor_align_h,
		_ax   = global.floor_align_x,
		_ay   = global.floor_align_y,
		_inst = [];
		
	floor_set_align(_ow, _oh, _x, _y);
	
	for(var _oy = 0; _oy < _h; _oy += _oh){
		for(var _ox = 0; _ox < _w; _ox += _ow){
			var _make = true;
			
			 // Type-Specific:
			switch(_type){
				case "round": // No Corner Floors
					_make = ((_ox != 0 && _ox != _w - _ow) || (_oy != 0 && _oy != _h - _oh));
					break;
					
				case "ring": // No Inner Floors
					_make = (_ox == 0 || _oy == 0 || _ox == _w - _ow || _oy == _h - _oh);
					break;
			}
			
			if(_make){
				array_push(_inst, floor_set(_x + _ox, _y + _oy, true));
			}
		}
	}
	
	floor_set_align(_aw, _ah, _ax, _ay);
	
	return _inst;
	
#define floor_delete(_x1, _y1, _x2, _y2)
	/*
		Deletes all Floors and Floor-related objects within the given rectangular area
	*/
	
	with(call(scr.instances_meeting_rectangle, _x1, _y1, _x2, _y2, Floor)){
		for(var	_x = bbox_left; _x < bbox_right + 1; _x += 16){
			for(var	_y = bbox_top; _y < bbox_bottom + 1; _y += 16){
				if(
					!rectangle_in_rectangle(_x, _y, _x + 15, _y + 15, _x1, _y1, _x2, _y2)
					&& !collision_rectangle(_x, _y, _x + 15, _y + 15, Floor, false, true)
				){
					var	_shake = UberCont.opt_shake,
						_sleep = UberCont.opt_freeze,
						_sound = sound_play_pitchvol(0, 0, 0);
						
					UberCont.opt_shake  = 0;
					UberCont.opt_freeze = 0;
					
					with(instances_matching_gt(GameObject, "id", instance_create(_x, _y, FloorExplo))){
						instance_delete(self);
					}
					
					UberCont.opt_shake  = _shake;
					UberCont.opt_freeze = _sleep;
					
					for(var i = _sound; audio_is_playing(i); i++){
						sound_stop(i);
					}
				}
			}
		}
		with(call(scr.instances_in_rectangle, bbox_left, bbox_top, bbox_right + 1, bbox_bottom + 1, Detail)){
			instance_destroy();
		}
		with(call(scr.instances_meeting_instance, self, SnowFloor)){
			if(point_in_rectangle(bbox_center_x, bbox_center_y, other.bbox_left, other.bbox_top, other.bbox_right + 1, other.bbox_bottom + 1)){
				instance_destroy();
			}
		}
		instance_destroy();
	}
	
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)
	/*
		Returns a safe starting x/y and direction to use with 'floor_room_create()'
		Searches through the given Floor tiles for one that is far enough away from the spawn and can be reached from the spawn (no Walls in between)
		
		Args:
			spawnX/spawnY - The spawn point
			spawnDis      - Minimum distance that the starting x/y must be from the spawn point
			spawnFloor    - Potential starting floors to search
			
		Ex:
			with(floor_room_start(10016, 10016, 128, FloorNormal)){
				floor_room_create(x, y, 2, 2, "", direction, [60, 90], 96);
			}
	*/
	
	with(call(scr.array_shuffle, instances_matching_ne(_spawnFloor, "id"))){
		var	_x = bbox_center_x,
			_y = bbox_center_y;
			
		if(point_distance(_spawnX, _spawnY, _x, _y) >= _spawnDis){
			var _spawnReached = false;
			
			 // Make Sure it Reaches the Spawn Point:
			if(
				position_meeting(_spawnX, _spawnY, Floor)
				&& !position_meeting(_spawnX, _spawnY, Wall)
				&& !position_meeting(_spawnX, _spawnY, InvisiWall)
			){
				var _pathWall = [Wall, InvisiWall];
				for(var _fx = bbox_left; _fx < bbox_right + 1; _fx += 16){
					for(var _fy = bbox_top; _fy < bbox_bottom + 1; _fy += 16){
						if(call(scr.path_reaches, call(scr.path_create, _fx + 8, _fy + 8, _spawnX, _spawnY, _pathWall), _spawnX, _spawnY, _pathWall)){
							_spawnReached = true;
							break;
						}
					}
					if(_spawnReached){
						break;
					}
				}
			}
			else _spawnReached = true; // Impossible to reach the spawn
			
			 // Success bro!
			if(_spawnReached){
				return {
					"x"         : _x,
					"y"         : _y,
					"direction" : point_direction(_spawnX, _spawnY, _x, _y),
					"id"        : id
				};
			}
		}
	}
	
	return noone;
	
#define floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)
	/*
		Moves toward a given direction until an open space is found, then creates a room based on the width, height, and type
		Rooms will always connect to the level as long as floorDis <= 0 (and the starting x/y is over a floor)
		Rooms will not overlap existing Floors as long as floorDis >= 0 (they can still overlap FloorExplo)
		
		Args:
			x/y      - The point to begin the search for an open space to create the room
			w/h      - Width/height of the room to create
			type     - The type of room to create (see 'floor_fill' script)
			dirStart - The direction to search towards for an open space
			dirOff   - Random directional offset to use while searching towards dirStart
			floorDis - How far from the level to create the room
			           Use 0 to spawn adjacent to the level, >0 to create an isolated room, <0 to overlap the level
			
		Ex:
			floor_room_create(10016, 10016, 5, 3, "round", random(360), 0, 0)
	*/
	
	 // Find Space:
	var	_move       = true,
		_floorAvoid = FloorNormal,
		_dis        = 16,
		_dir        = 0,
		_ow         = (_w * 32) / 2,
		_oh         = (_h * 32) / 2,
		_sx         = _x,
		_sy         = _y;
		
	if(!is_array(_dirOff)){
		_dirOff = [_dirOff];
	}
	while(array_length(_dirOff) < 2){
		array_push(_dirOff, 0);
	}
	
	while(_move){
		var	_x1   = _x - _ow,
			_y1   = _y - _oh,
			_x2   = _x + _ow,
			_y2   = _y + _oh,
			_inst = call(scr.instances_meeting_rectangle, _x1 - _floorDis, _y1 - _floorDis, _x2 + _floorDis - 1, _y2 + _floorDis - 1, _floorAvoid);
			
		 // No Corner Floors:
		if(_type == "round" && _floorDis <= 0){
			with(_inst){
				if((bbox_right < _x1 + 32 || bbox_left >= _x2 - 32) && (bbox_bottom < _y1 + 32 || bbox_top >= _y2 - 32)){
					_inst = call(scr.array_delete_value, _inst, self);
				}
			}
		}
		
		 // Floors in Range:
		_move = false;
		if(array_length(_inst)){
			if(_floorDis <= 0){
				_move = true;
			}
			
			 // Floor Distance Check:
			else with(_inst){
				var	_fx = clamp(_x, bbox_left, bbox_right + 1),
					_fy = clamp(_y, bbox_top, bbox_bottom + 1),
					_fDis = (
						(_type == "round")
						? min(
							point_distance(_fx, _fy, clamp(_fx, _x1 + 32, _x2 - 32), clamp(_fy, _y1,      _y2     )),
							point_distance(_fx, _fy, clamp(_fx, _x1,      _x2     ), clamp(_fy, _y1 + 32, _y2 - 32))
						)
						: point_distance(_fx, _fy, clamp(_fx, _x1, _x2), clamp(_fy, _y1, _y2))
					);
					
				if(_fDis < _floorDis){
					_move = true;
					break;
				}
			}
			
			 // Keep Searching:
			if(_move){
				_dir = pround(_dirStart + (random_range(_dirOff[0], _dirOff[1]) * choose(-1, 1)), 90);
				_x += lengthdir_x(_dis, _dir);
				_y += lengthdir_y(_dis, _dir);
			}
		}
	}
	
	 // Create Room:
	var	_floorNumLast = array_length(FloorNormal),
		_floors       = floor_fill(_x, _y, _w, _h, _type),
		_floorNum     = array_length(FloorNormal),
		_x1           = _x,
		_y1           = _y,
		_x2           = _x,
		_y2           = _y;
		
	if(array_length(_floors)){
		with(_floors[0]){
			_x1 = bbox_left;
			_y1 = bbox_top;
			_x2 = bbox_right  + 1;
			_y2 = bbox_bottom + 1;
		}
		with(_floors){
			var	_fx1 = bbox_left,
				_fy1 = bbox_top,
				_fx2 = bbox_right,
				_fy2 = bbox_bottom;
				
			 // Determine Room's Dimensions:
			_x1 = min(_x1, _fx1);
			_y1 = min(_y1, _fy1);
			_x2 = max(_x2, _fx2 + 1);
			_y2 = max(_y2, _fy2 + 1);
			
			 // Fix Potential Wall Softlock:
			if(_floorDis <= 0 && _floorNum == _floorNumLast + array_length(_floors)){
				with(call(scr.array_combine,
					call(scr.instances_meeting_rectangle, _fx1 - 1, _fy1,     _fx2 + 1, _fy2,     Wall),
					call(scr.instances_meeting_rectangle, _fx1,     _fy1 - 1, _fx2,     _fy2 + 1, Wall)
				)){
					if(instance_exists(self) && place_meeting(x, y, Floor)){
						with(call(scr.instances_meeting_instance, self, [Bones, TopPot])){
							if(place_meeting(x, y, other)){
								instance_delete(self);
							}
						}
						instance_delete(self);
					}
				}
			}
		}
	}
	
	 // Done:
	return {
		"floors" : _floors,
		"x"      : (_x1 + _x2) / 2,
		"y"      : (_y1 + _y2) / 2,
		"x1"     : _x1,
		"y1"     : _y1,
		"x2"     : _x2,
		"y2"     : _y2,
		"xstart" : _sx,
		"ystart" : _sy
	};
	
#define floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)
	/*
		Automatically creates a room a safe distance from the spawn point
		Rooms will always connect to the level as long as floorDis <= 0
		Rooms will not overlap existing Floors as long as floorDis >= 0 (they can still overlap FloorExplo)
		
		Args:
			spawnX/spawnY - The spawn point
			spawnDis      - Minimum distance from the spawn point to begin searching for an open space
			spawnFloor    - Potential starting floors to begin searching for an open space from
			w/h           - Width/height of the room to create
			type          - The type of room to create (see 'floor_fill' script)
			dirOff        - Random directional offset to use while moving away from the spawn point to find an open space
			floorDis      - How far from the level to create the room
			                Use 0 to spawn adjacent to the level, >0 to create an isolated room, <0 to overlap the level
			
		Ex:
			floor_room(10016, 10016, 96, FloorNormal, 4, 4, "round", 60, -32)
	*/
	
	with(floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)){
		return floor_room_create(x, y, _w, _h, _type, direction, _dirOff, _floorDis);
	}
	
	return noone;
	
	
/// EVENT MANAGEMENT
#define teevent_add(_event)
	/*
		Adds a given event script reference to the list of events
		If the given event is a string then a script reference is automatically generated for teevents.mod
		
		Ex:
			teevent_add(script_ref_create_ext("mod", "teevents", "MaggotPark"));
			teevent_add("MaggotPark");
	*/
	
	var _scrt = (
		is_array(_event)
		? _event
		: script_ref_create_ext(mod_current_type, mod_current, _event)
	);
	
	array_push(event_list, _scrt);
	
	return _scrt;
	
#define teevent_set_active(_name, _active)
	/*
		Activates or deactivates a given event and returns its controller object
		Use the 'all' keyword to activate every event and return all of their controller objects as an array, wtf
	*/
	
	 // Activate:
	if(_active){
		 // All:
		if(_name == all){
			with(event_list){
				teevent_set_active(self[2], _active);
			}
		}
		
		 // Normal:
		else if(!teevent_get_active(_name)){
			with(call(scr.obj_create, 0, 0, "NTTEEvent")){
				mod_type = mod_current_type;
				mod_name = mod_current;
				event    = _name;
				tip      = mod_script_call(mod_type, mod_name, event + "_text");
				
				with(GenCont){
					 // Spawn Point:
					other.spawn_x = spawn_x;
					other.spawn_y = spawn_y;
					
					 // Tip:
					if(is_string(other.tip) && other.tip != ""){
						if("tip_ntte_event" not in self){
							tip_ntte_event = other.tip;
							tip            = tip_ntte_event;
						}
					}
				}
				
				 // Setup:
				mod_script_call(mod_type, mod_name, event + "_setup");
			}
		}
	}
	
	 // Deactivate:
	else with(teevent_get_active(_name)){
		instance_destroy();
	}
	
	return teevent_get_active(_name);
	
#define teevent_get_active(_name)
	/*
		Returns a given event's controller object
		Use the 'all' keyword to return an array of every active event's controller object
	*/
	
	 // All:
	if(_name == all){
		var _inst = instances_matching_ne(obj.NTTEEvent, "id");
		array_sort(_inst, true);
		return _inst;
	}
	
	 // Normal:
	with(instances_matching(obj.NTTEEvent, "event", _name)){
		return self;
	}
	
	return noone;
	
#define NTTEEvent_create(_x, _y)
	/*
		The raw object used for NTTE's events
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		mod_type = "";
		mod_name = "";
		event    = "";
		tip      = "";
		floors   = [];
		spawn_x  = 10016;
		spawn_y  = 10016;
		
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