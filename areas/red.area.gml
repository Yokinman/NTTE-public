#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // For Manual Map Drawing (Reset in ntte.mod):
	global.mapdata_warp_draw = undefined;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro area_active variable_instance_get(GameCont, "ntte_active_" + mod_current, false) && (GameCont.area == mod_current || GameCont.lastarea == mod_current)
#macro area_visits variable_instance_get(GameCont, "ntte_visits_" + mod_current, 0)

#define area_subarea           return 1;
#define area_goal              return 60;
#define area_next              return [mod_current, 1]; // CAN'T LEAVE
#define area_music             return mus.Red;
#define area_music_boss        return mus.Tesseract;
#define area_music_boss_intro  return mus.TesseractIntro;
#define area_ambient           return amb104;
#define area_background_color  return make_color_rgb(235, 0, 67);
#define area_shadow_color      return make_color_rgb(16, 0, 24);
#define area_darkness          return false;
#define area_secret            return true;

#define area_name(_subarea, _loops)
	return `@(color:${call(scr.area_get_back_color, mod_current)})@3(${spr.RedText}:-0.8)`;
	
#define area_text
	return choose(
		"BLINDING",
		"THE RED DOT",
		`WELCOME TO THE @(color:${area_background_color()})WARP ZONE`
	);
	
#define area_mapdata(_lastX, _lastY, _lastArea, _lastSubarea, _subarea, _loops)
	 // Compile Warp Zone Map Data:
	if(global.mapdata_warp_draw == undefined){
		global.mapdata_warp_draw = [];
		
		var _mapData = call(scr.mapdata_get, -1);
		
		for(var i = array_length(_mapData) - 2; i >= 1; i--){
			var _data = _mapData[i];
			if(_data.area == mod_current){
				array_push(global.mapdata_warp_draw, {
					"subarea" : _data.subarea,
					"loops"   : _data.loops,
					"last"    : _mapData[i - 1],
					"next"    : _mapData[i + 1]
				});
			}
		}
	}
	
	 // Post-Exit Warp Icons:
	with(global.mapdata_warp_draw){
		if(
			subarea      == _subarea     &&
			loops        == _loops       &&
			last.x       == _lastX       &&
			last.y       == _lastY       &&
			last.area    == _lastArea    &&
			last.subarea == _lastSubarea
		){
			if(next.area != mod_current){
				var	_x = view_xview_nonsync + (game_width  / 2),
					_y = view_yview_nonsync + (game_height / 2),
					_lx = last.x,
					_ly = last.y,
					_nx = next.x,
					_ny = next.y;
					
				 // Area Offset Fix:
				switch(next.area){
					case area_oasis        : _nx = 0;  break;
					case area_pizza_sewers : _nx = 27; break;
					case area_mansion      : _nx = 36; break;
					case area_cursed_caves : _nx = 54; break;
					case area_jungle       : _nx = 72; break;
				}
				
				 // Drawing Offset:
				if(instance_exists(TopCont) && !instance_exists(Player) && !instance_exists(GenCont) && !instance_exists(PauseButton) && !instance_exists(BackMainMenu)){
					_x -= 120;
					_y += 4 - min(2, TopCont.go_stage);
				}
				else{
					_x -= 70;
					_y += 7;
				}
				
				 // Manually Draw Map Warps:
				var	_spr = spr.RedDot,
					_img = (current_frame * 0.4), // + _loops * (sprite_get_number(spr.RedDot) / (GameCont.loops + 1)),
					_col = draw_get_color(),
					_alp = draw_get_alpha(),
					_ax1 = floor(_x + _lx),
					_ay1 = floor(_y + _ly - !last.showdot),
					_ax2 = floor(_x + _lx),
					_ay2 = floor(_y + max(0, _ly) + 9),
					_bx1 = floor(_x + _nx),
					_by1 = floor(_y + _ny),
					_bx2 = floor(_x + _nx),
					_by2 = floor(_y + min(0, _ny) - 9);
					
				with(UberCont){
					 // Exit Warp:
					draw_set_color(c_black);
					draw_line_width(_ax1 + 1, _ay1 + 1, _ax2 + 1, _ay2 + 1, 1);
					draw_set_color(_col);
					draw_line_width(_ax1, _ay1, _ax2, _ay2, 1);
					draw_sprite_ext(_spr, _img, _ax2, _ay2, 1, 1, 0, _col, _alp);
					
					 // Destination:
					draw_set_color(c_black);
					draw_line_width(_bx1 + 1, _by1 + 1, _bx2 + 1, _by2 + 1, 1);
					draw_set_color(_col);
					draw_line_width(_bx1, _by1, _bx2, _by2, 1);
					draw_sprite_ext(_spr, _img, _bx2, _by2, 1, 1, 0, _col, _alp);
				}
				
				return [_nx, _ny, false, false];
			}
		}
	}
	
	 // Still in Warp Zone:
	return [
		_lastX,
		max(0, _lastY) + 9,
		(_subarea == 1)
	];
	
#define area_sprite(_spr)
	switch(_spr){
		 // Floors:
		case sprFloor1      : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return spr.FloorRed;
		case sprFloor1B     : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return spr.FloorRedB;
		case sprFloor1Explo : return spr.FloorRedExplo;
		case sprDetail1     : return spr.DetailRed;
		
		 // Walls:
		case sprWall1Bot    : return spr.WallRedBot;
		case sprWall1Top    : return spr.WallRedTop;
		case sprWall1Out    : return spr.WallRedOut;
		case sprWall1Trans  : return spr.WallRedTrans;
		case sprDebris1     : return spr.DebrisRed;
		
		 // Decals:
		case sprBones       : return spr.WallDecalRed;
	}
	
#define area_setup
	goal             = area_goal();
	background_color = area_background_color();
	BackCont.shadcol = area_shadow_color();
	TopCont.darkness = area_darkness();
	
#define area_setup_spiral // Between Betweens
	 // Reset Time:
	time = 0;
	
	 // Did You Just See That?
	if(chance(1, 3)){
		with(call(scr.instance_random, Player)){
			with(instance_create(other.x, other.y, SpiralDebris)){
				sprite_index = other.spr_hurt;
				image_index  = 1;
				turnspeed   *= 2/3;
				
				 // Fast Forward:
				repeat(irandom_range(8, 12)){
					with(self){
						event_perform(ev_step, ev_step_normal);
					}
				}
			}
		}
	}
	
	 // Starfield:
	for(var i = sprite_get_number(spr.Starfield) - 1; i >= 0; i--){
		with(call(scr.obj_create, x, y, "SpiralStarfield")){
			image_index = i;
		}
	}
	
#define area_setup_floor
	 // Fix Depth:
	if(styleb) depth = 8;
	
	 // Footsteps:
	material = 2;
	
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
	variable_instance_set(GameCont, "ntte_visits_"      + mod_current, area_visits + 1); 
	variable_instance_set(GameCont, "ntte_visits_loop_" + mod_current, GameCont.loops);
	
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
	
	 // Skin Time:
	call(scr.unlock_set, "skin:red crystal", true);
	
	 // Warping:
	with(instances_matching_ne(obj.WarpPortal, "id")){
		if(!instance_exists(portal)){
			call(scr.area_set, area, subarea, loops);
			if(!call(scr.area_get_secret, area)){
				other.lastarea    = area;
				other.lastsubarea = subarea - 1;
			}
		}
	}
	
#define area_transit
	 // Disable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, false);
	
#define area_make_floor
	var	_x = x,
		_y = y,
		_outOfSpawn = (point_distance(_x, _y, 10000, 10000) > 48);
		
	 // Delete B-Floor (game sucks this game suk):
	if(styleb != 0){
		with(instances_matching(instances_matching(instances_matching(Floor, "xstart", xstart), "ystart", ystart), "styleb", styleb)){
			instance_destroy();
		}
		styleb = 0;
		instance_create(xstart, ystart, Floor);
	}
	
	/// Make Floors:
		 // Normal:
		instance_create(_x, _y, Floor);
		
		 // Special - Diamond:
		if(chance(1, 7)){
			call(scr.floor_fill, _x + 16, _y + 16, 3, 3, "round");
		}
		
	/// Chests:
		if(_trn == 180 && _outOfSpawn){
			instance_create(_x + 16, _y + 16, choose(WeaponChest, AmmoChest));
		}
		
	/// Don't Move:
		if(GenCont.safedist <= 0){
			if("direction_start" not in self){
				direction_start = direction;
			}
			
			var _ox = lengthdir_x(32, direction),
				_oy = lengthdir_y(32, direction);
				
			if(abs(angle_difference(direction_start, point_direction(xstart, ystart, x + _ox, y + _oy))) > 60){
				x -= _ox;
				y -= _oy;
				direction = pround(direction_start, 90);
			}
		}
		
	/// Turn:
		var _trn = 0;
		if(chance(3, 7)){
			_trn = choose(90, -90, 180);
		}
		direction += _trn;
		
#define area_pop_enemies
	if(GameCont.subarea != 3){
		var	_x = x + 16,
			_y = y + 16;
			
		 // Big:
		if(chance(1, 10)){
			call(scr.obj_create, _x, _y, "CrystalBrain");
		}
		
		 // Small:
		else{
			if(chance(1, 7)){
				instance_create(_x, _y, Bandit);
			}
			else{
				call(scr.obj_create, _x, _y, "RedSpider");
			}
		}
	}
	
#define area_pop_props
	 // Lone Walls:
	if(
		chance(1, 5)
		&& point_distance(x, y, 10000, 10000) > 16
		&& !place_meeting(x, y, NOWALLSHEREPLEASE)
		&& !place_meeting(x, y, hitme)
	){
		instance_create(x + choose(0, 16), y + choose(0, 16), Wall);
		instance_create(x, y, NOWALLSHEREPLEASE);
	}
	
	 // Props:
	else if(chance(1, 4)){
		call(scr.obj_create, x + 16, y + 16, "CrystalProp" + (styleb ? "White" : "Red"));
	}
	
	 // Warp Rooms:
	if(styleb == 0 && GameCont.subarea > 0 && GameCont.subarea != 3){
		if(chance(1, 12 * array_length(instances_matching_ne(obj.Warp, "id")))){
			var _w          = 2,
				_h          = 2,
				_type       = "",
				_dirOff     = 90,
				_floorDis   = random_range(48, 96),
				_spawnX     = 10016,
				_spawnY     = 10016,
				_spawnDis   = 64,
				_levelFloor = FloorNormal,
				_spawnFloor = instances_matching(_levelFloor, "styleb", 0);
				
			call(scr.floor_set_align, 32, 32);
			call(scr.floor_set_style, 1);
			
			with(call(scr.floor_room, _spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
				 // Hallway:
				with(call(scr.instance_random, floors)){
					var	_x = bbox_center_x,
						_y = bbox_center_y,
						_moveDis = 32;
						
					while(
						point_distance(_x, _y, other.xstart, other.ystart) > _moveDis / 2
						&&
						(!position_meeting(_x, _y, Floor) || !array_length(call(scr.instances_meeting_point, _x, _y, _levelFloor)))
					){
						 // Floor + Props:
						if(!position_meeting(_x, _y, Floor) || !array_length(call(scr.instances_meeting_point, _x, _y, FloorNormal))){
							with(call(scr.floor_set, _x - 16, _y - 16, true)){
								area_pop_props();
							}
						}
						
						 // Move:
						var _moveDir = pround(point_direction(_x, _y, other.xstart, other.ystart) + orandom(60), 90);
						_x += lengthdir_x(_moveDis, _moveDir);
						_y += lengthdir_y(_moveDis, _moveDir);
					}
				}
				
				 // Epify:
				for(var i = 0; i < array_length(floors); i++){
					with(floors[i]){
						sprite_index = spr.FloorRedRoom;
						image_index  = i;
					}
				}
				
				 // Portal:
				call(scr.obj_create, x, y - 4, "Warp");
			}
			
			call(scr.floor_reset_align);
			call(scr.floor_reset_style);
		}
	}
	
#define area_pop_extras
	 // Bone Decals:
	with(FloorNormal){
		if(chance(3, 4)){
			call(scr.floor_bones, self, 2, 1/8);
		}
	}
	
	 // Rooms:
	switch(GameCont.subarea){
		
		case 1: // Secrets Upon Secrets
			
			var	_w          = 3,
				_h          = 3,
				_type       = "",
				_dirOff     = 60,
				_floorDis   = random_range(80, 160),
				_dirStart   = 90,
				_spawnX     = 10016,
				_spawnY     = 10016,
				_spawnDis   = 64,
				_spawnFloor = [],
				_levelFloor = FloorNormal;
				
			call(scr.floor_set_align, 32, 32);
			call(scr.floor_set_style, 1);
			
			 // Spawn From Highest Floors:
			with(_levelFloor){
				if(!array_length(instances_matching_lt(instances_matching(_levelFloor, "x", x), "y", y))){
					array_push(_spawnFloor, self);
				}
			}
			
			 // Secret Room:
			with(call(scr.floor_room_start, _spawnX, _spawnY, _spawnDis, _spawnFloor)){
				with(call(scr.floor_room_create, x, y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
					var _minID = instance_max;
					
					 // Hallway:
					with(call(scr.instance_random, floors)){
						var	_x       = bbox_center_x,
							_y       = bbox_center_y,
							_moveDis = 32;
							
						while(
							point_distance(_x, _y, other.xstart, other.ystart) > _moveDis / 2
							&& (
								!position_meeting(_x, _y, Floor)
								|| !array_length(call(scr.instances_meeting_point, _x, _y, _levelFloor))
							)
						){
							 // Floor & Fake Walls:
							if(!position_meeting(_x, _y, Floor) || !array_length(call(scr.instances_meeting_point, _x, _y, FloorNormal))){
								with(call(scr.floor_set, _x - 16, _y - 16, true)){
									depth = 10;
									for(var _wx = bbox_left; _wx < bbox_right + 1; _wx += 16){
										for(var _wy = bbox_top; _wy < bbox_bottom + 1; _wy += 16){
											call(scr.obj_create, _wx, _wy, "WallFake");
										}
									}
								}
							}
							
							 // Move:
							var _moveDir = pround(point_direction(_x, _y, other.xstart, other.ystart) + orandom(60), 90);
							_x += lengthdir_x(_moveDis, _moveDir);
							_y += lengthdir_y(_moveDis, _moveDir);
						}
					}
					
					 // Secrets Upon Secrets Upon Secres:
					var _partIndex = 3;
					if(!call(scr.unlock_get, `quest:part:${_partIndex}`)){
						if("ntte_quest_spawned_part_index_list" not in GameCont){
							GameCont.ntte_quest_spawned_part_index_list = [];
						}
						if(array_find_index(GameCont.ntte_quest_spawned_part_index_list, _partIndex) < 0){
							array_push(GameCont.ntte_quest_spawned_part_index_list, _partIndex);
							
							with(call(scr.instance_random, floors)){
								with(call(scr.floor_room_create, bbox_center_x, bbox_center_y, 1, 3, "", 90, 0, 0)){
									 // Fake Walls:
									for(var _wx = x1; _wx < x2; _wx += 16){
										for(var _wy = y1; _wy < y2; _wy += 16){
											call(scr.obj_create, _wx, _wy, "WallFake");
										}
									}
									
									 // Missing Artifact:
									with(call(scr.chest_create, x, y1 + 16, "QuestChest", true)){
										wep = {
											"wep"        : "crabbone",
											"type_index" : _partIndex + 1
										};
									}
								}
							}
						}
					}
					
					 // Hidden:
					with(instances_matching_gt(Wall,     "id", _minID)) topindex = 0;
					with(instances_matching_gt(TopSmall, "id", _minID)) image_index = 0;
					
					 // Twins:
					call(scr.pet_create, x, y, "Twins");
				}
			}
			
			call(scr.floor_reset_align);
			call(scr.floor_reset_style);
			
			break;
			
		case 3: // Tesseract Room
			
			var	_x = 10016,
				_y = 10016;
				
			with(instance_furthest(_x - 16, _y - 16, Floor)){
				var	_w        = 4,
					_h        = 4,
					_type     = "",
					_dirStart = point_direction(_x, _y, bbox_center_x, bbox_center_y),
					_dirOff   = 30,
					_floorDis = -32;
					
				with(call(scr.floor_room_create, _x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
					call(scr.obj_create, x, y, "Tesseract");
				}
			}
			
			break;
			
	}
	
#define area_effect
	alarm0 = irandom_range(1, 40);
	
	for(var i = 0; i < maxp; i++){
		if(player_is_active(i)){
			 // Pick Random Player's Screen:
			do i = irandom(maxp - 1);
			until player_is_active(i);
			
			 // Sparkles:
			with(call(scr.instance_random, call(scr.instances_seen, instances_matching(Floor, "sprite_index", spr.FloorRed), 0, 0, i))){
				with(instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), LaserCharge)){
					alarm0    = irandom_range(40, 80);
					direction = random(360);
					speed     = random(0.2);
					depth     = -8;
				}
			}
			
			break;
		}
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