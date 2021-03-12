#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // For Manual Map Drawing:
	global.mapdata_warp_draw = [];
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro area_active variable_instance_get(GameCont, "ntte_active_" + mod_current, false) && (GameCont.area == mod_current || GameCont.lastarea == mod_current)
#macro area_visits variable_instance_get(GameCont, "ntte_visits_" + mod_current, 0)

#define area_subarea           return 1;
#define area_goal              return 60;
#define area_next              return [mod_current, 1]; // CAN'T LEAVE
#define area_music             return mus.Red;
#define area_music_boss        return mus.Tesseract;
#define area_ambient           return amb104;
#define area_background_color  return make_color_rgb(235, 0, 67);
#define area_shadow_color      return make_color_rgb(16, 0, 24);
#define area_darkness          return false;
#define area_secret            return true;

#define area_name(_subarea, _loops)
	return `@(color:${area_get_back_color(mod_current)})@3(${spr.RedText}:-0.8)`;
	
#define area_text
	return choose(
		"BLINDING",
		"THE RED DOT",
		`WELCOME TO THE @(color:${area_background_color()})WARP ZONE`
	);
	
#define area_mapdata(_lastX, _lastY, _lastArea, _lastSubarea, _subarea, _loops)
	 // Post Exit:
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
	unlock_set("skin:red crystal", true);
	
	 // Warping:
	with(instances_matching(CustomObject, "name", "WarpPortal")){
		if(!instance_exists(portal)){
			area_set(area, subarea, loops);
			if(!area_get_secret(area)){
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
			floor_fill(_x + 16, _y + 16, 3, 3, "round");
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
			obj_create(_x, _y, "CrystalBrain");
		}
		
		 // Small:
		else{
			if(chance(1, 7)){
				instance_create(_x, _y, Bandit);
			}
			else{
				obj_create(_x, _y, "RedSpider");
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
		obj_create(x + 16, y + 16, "CrystalProp" + (styleb ? "White" : "Red"));
	}
	
	 // Warp Rooms:
	if(styleb == 0 && GameCont.subarea > 0 && GameCont.subarea != 3){
		if(chance(1, 12 * array_length(instances_matching(CustomObject, "name", "Warp")))){
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
				
			floor_set_align(null, null, 32, 32);
			floor_set_style(1, null);
			
			with(floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)){
				 // Hallway:
				with(instance_random(floors)){
					var	_x = bbox_center_x,
						_y = bbox_center_y,
						_moveDis = 32;
						
					while(
						point_distance(_x, _y, other.xstart, other.ystart) > _moveDis / 2
						&&
						(!position_meeting(_x, _y, Floor) || !array_length(instances_at(_x, _y, _levelFloor)))
					){
						 // Floor + Props:
						if(!position_meeting(_x, _y, Floor) || !array_length(instances_at(_x, _y, FloorNormal))){
							with(floor_set(_x - 16, _y - 16, true)){
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
				obj_create(x, y - 4, "Warp");
			}
			
			floor_reset_align();
			floor_reset_style();
		}
	}
	
#define area_pop_extras
	 // Bone Decals:
	with(FloorNormal){
		if(chance(3, 4)){
			floor_bones(2, 1/8, false);
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
				
			floor_set_align(null, null, 32, 32);
			floor_set_style(1, null);
			
			 // Spawn From Highest Floors:
			with(_levelFloor){
				if(!array_length(instances_matching_lt(instances_matching(_levelFloor, "x", x), "y", y))){
					array_push(_spawnFloor, self);
				}
			}
			
			 // Secret Room:
			with(floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)){
				with(floor_room_create(x, y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
					var _minID = instance_max;
					
					 // Hallway:
					with(instance_random(floors)){
						var	_x       = bbox_center_x,
							_y       = bbox_center_y,
							_moveDis = 32;
							
						while(
							point_distance(_x, _y, other.xstart, other.ystart) > _moveDis / 2
							&&
							(!position_meeting(_x, _y, Floor) || !array_length(instances_at(_x, _y, _levelFloor)))
						){
							 // Floor & Fake Walls:
							if(!position_meeting(_x, _y, Floor) || !array_length(instances_at(_x, _y, FloorNormal))){
								with(floor_set(_x - 16, _y - 16, true)){
									depth = 10;
									for(var _wx = bbox_left; _wx < bbox_right + 1; _wx += 16){
										for(var _wy = bbox_top; _wy < bbox_bottom + 1; _wy += 16){
											obj_create(_wx, _wy, "WallFake");
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
					with(instance_random(floors)){
						with(floor_room_create(bbox_center_x, bbox_center_y, 1, 2, "", 90, 0, 0)){
							 // Fake Walls:
							for(var _wx = x1; _wx < x2; _wx += 16){
								for(var _wy = y1; _wy < y2; _wy += 16){
									obj_create(_wx, _wy, "WallFake");
								}
							}
							
							 // Chest:
							chest_create(x, y1 + 16, "Backpack", true);
						}
					}
					
					 // Hidden:
					with(instances_matching_gt(Wall,     "id", _minID)) topindex = 0;
					with(instances_matching_gt(TopSmall, "id", _minID)) image_index = 0;
					
					 // Twins:
					pet_spawn(x, y, "Twins");
				}
			}
			
			floor_reset_align();
			floor_reset_style();
			
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
					
				with(floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
					obj_create(x, y, "Tesseract");
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
			with(instance_random(instances_seen(instances_matching(Floor, "sprite_index", spr.FloorRed), 0, 0, i))){
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
	
#define ntte_end_step
	 // Compile Area Map Visits:
	if(area_visits > 0){
		global.mapdata_warp_draw = [];
		
		var _mapdata = mod_script_call("mod", "ntte", "mapdata_get", -1);
		
		for(var i = array_length(_mapdata) - 2; i >= 1; i--){
			var _data = _mapdata[i];
			if(_data.area == mod_current){
				array_push(global.mapdata_warp_draw, {
					"subarea" : _data.subarea,
					"loops"   : _data.loops,
					"last"    : _mapdata[i - 1],
					"next"    : _mapdata[i + 1]
				});
			}
		}
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