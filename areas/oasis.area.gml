#define init
    mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro area_active variable_instance_get(GameCont, "ntte_active_" + mod_current, false) && (GameCont.area == mod_current || GameCont.lastarea == mod_current)
#macro area_visits variable_instance_get(GameCont, "ntte_visits_" + mod_current, 0)

#define area_subarea           return 1;
#define area_goal              return 130;
#define area_next              return [area_scrapyards, 3];
#define area_music             return mus101;
#define area_ambient           return amb101;
#define area_background_color  return area_get_background_color(area_oasis);
#define area_shadow_color      return area_get_shadow_color(area_oasis);
#define area_darkness          return false;
#define area_secret            return false;
#define area_underwater        return true;

#define area_name(_subarea, _loops)
	return `@1(${spr.RouteIcon}:0)2-` + string(_subarea);
	
#define area_text
	return choose(
		"DON'T MOVE",
		"IT'S BEAUTIFUL DOWN HERE",
		"HOLD YOUR BREATH",
		"FISH",
		"RIPPLING SKY",
		"IT'S SO QUIET",
		"THERE'S SOMETHING IN THE WATER"
	);
	
#define area_mapdata(_lastX, _lastY, _lastArea, _lastSubarea, _subarea, _loops)
	return [
		44,
		-9,
		(_subarea == 1)
	];
	
#define area_sprite(_spr)
	switch(_spr){
		 // Floors:
		case sprFloor1      : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return sprFloor101;
		case sprFloor1B     : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return sprFloor101B;
		case sprFloor1Explo : return sprFloor101Explo;
		case sprDetail1     : return sprDetail101;
		
		 // Walls:
		case sprWall1Bot    : return sprWall101Bot;
		case sprWall1Top    : return sprWall101Top;
		case sprWall1Out    : return sprWall101Out;
		case sprWall1Trans  : return sprWall101Trans;
		case sprDebris1     : return sprDebris101;
		
		 // Decals:
		case sprBones       : return sprCoral;
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
	material = (styleb ? 4 : 1);
	
#define area_start
	 // Enable Area:
	variable_instance_set(GameCont, "ntte_active_" + mod_current, true);
	
	 // Anglers:
	with(RadChest) if(chance(1, 40)){
		call(scr.obj_create, x, y, "Angler");
		instance_delete(self);
	}
	
	 // Bab Skull:
	if(GameCont.subarea == 1 && instance_exists(Floor) && instance_exists(Player)){
		with(call(scr.array_shuffle, FloorNormal)){
			if(point_distance(bbox_center_x, bbox_center_y, 10016, 10016) > 48){
				if(!place_meeting(x, y, prop) && !place_meeting(x, y, chestprop) && !place_meeting(x, y, Wall)){
					call(scr.obj_create, bbox_center_x, bbox_center_y, "OasisPetBecome");
					break;
				}
			}
		}
	}
	
	 // Cool Crack:
	with(call(scr.instance_nearest_bbox, 10016, 10016, FloorNormal)){
		with(call(scr.obj_create, bbox_center_x, bbox_center_y, "Manhole")){
			sprite_index = spr.Crack;
			visible      = false;
			contact      = true;
			area         = "trench";
			subarea      = 0;
		}
	}
	
	 // Secret Chest Room:
	if(variable_instance_get(GameCont, "sunkenchests", 0) <= GameCont.loops){
		with(call(scr.instance_random, Floor)){
			var	_x        = bbox_center_x,
				_y        = bbox_center_y,
				_w        = 3,
				_h        = 3,
				_type     = "round",
				_dirStart = random(360),
				_dirOff   = [30, 60],
				_floorDis = 64;
				
			with(call(scr.floor_room_create, _x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
				with(call(scr.chest_create, x, y, "SunkenChest", true)){
					skeal = true;
					instance_create(x, y - 8, LightBeam);
				}
				
				 // Softlock Prevention:
				with(call(scr.obj_create, x1, y1, "SunkenRoom")){
					image_xscale = _w;
					image_yscale = _h;
					floors = other.floors;
				}
				
				 // Details:
				with(floors){
					instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), Detail);
					call(scr.floor_bones, self, 2, 1/4);
				}
			}
		}
	}
	
	 // Top Props:
	with(instances_matching_ne([TopSmall, Wall], "id")){
		if(chance(1, 300)){
			call(scr.top_create, 
				random_range(bbox_left, bbox_right + 1),
				random_range(bbox_top, bbox_bottom + 1),
				call(scr.pool, [
					[OasisBarrel, 1],
					[Anchor,      1/4]
				]),
				-1,
				-1
			);
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
	
#define area_make_floor
	var	_x = x,
		_y = y,
		_outOfSpawn = (point_distance(_x, _y, 10000, 10000) > 48);
		
	/// Make Floors:
		 // Normal:
		instance_create(_x, _y, Floor);
		
		 // Special - Diamond:
		if(chance(1, 3)){
			call(scr.floor_fill, _x + 16, _y + 16, 3, 3, "round");
		}
		
	/// Turn:
		var _trn = 0;
		if(chance(1, 4)){
			_trn = choose(90, 90, -90, -90, 180);
		}
		direction += _trn;
		
	/// Chests & Branching:
		 // Turn Arounds (Weapon Chests):
		if(_trn == 180 && _outOfSpawn){
			instance_create(_x + 16, _y + 16, WeaponChest);
		}
		
		 // Dead Ends (Ammo Chests):
		if(!chance(20, 19 + instance_number(FloorMaker))){
			if(_outOfSpawn){
				instance_create(_x + 16, _y + 16, AmmoChest);
			}
			instance_destroy();
		}
		
		 // Branch:
		if(chance(1, 5)){
			instance_create(_x, _y, FloorMaker);
		}
		
#define area_pop_enemies
	var	_x = x + 16,
		_y = y + 16;
		
	if(chance(1, 2)){
		var _top = chance(1, 2);
		
		 // Shoals:
		if(chance(1, 2)){
			if(!styleb && chance(3, 4)){
				if(GameCont.loops > 0 && chance(1, 2)){
					repeat(irandom_range(1, 4)){
						call(scr.obj_create, _x, _y, Freak);
					}
				}
				repeat(irandom_range(1, 4)){
					call(scr.obj_create, _x, _y, BoneFish);
				}
			}
			else repeat(irandom_range(1, 4)){
				call(scr.obj_create, _x, _y, "Puffer");
			}
		}
		
		else{
			if(GameCont.loops > 0 && chance(1, 3)){
				instance_create(_x, _y, choose(Necromancer, Ratking));
			}
			else{
				if(chance(1, 5)) call(scr.obj_create, _x, _y, "Diver");
				else{
					if(!styleb){
						if(chance(1, 2)) instance_create(_x, _y, Crab);
					}
					else{
						call(scr.obj_create, _x, _y, "HammerShark");
					}
				}
			}
		}
	}
	
#define area_pop_props
	 // Lone Walls:
	if(
		chance(1, 14)
		&& point_distance(x, y, 10000, 10000) > 96
		&& !place_meeting(x, y, NOWALLSHEREPLEASE)
		&& !place_meeting(x, y, hitme)
	){
		instance_create(x + choose(0, 16), y + choose(0, 16), Wall);
		instance_create(x, y, NOWALLSHEREPLEASE);
	}
	
	 // Props:
	else if(chance(1, 10)){
		var	_x = x + 16,
			_y = y + 16,
			_spawnDis = point_distance(_x, _y, 10016, 10016);
			
		 // Special:
		if(chance(1, 40) && !place_meeting(x - 32, y, Wall) && !place_meeting(x + 32, y, Wall)){
			instance_create(_x, _y, Anchor);
		}
		
		 // Basic:
		else if(_spawnDis > 96){
			instance_create(_x, _y, choose(LightBeam, LightBeam, WaterPlant, WaterPlant, WaterMine, WaterMine, OasisBarrel));
		}
	}
	
#define area_pop_extras
	 // Bone Decals:
	call(scr.floor_bones, FloorNormal, 2, 1/9);
	
	 // The new bandits
	with(instances_matching_ne([WeaponChest, AmmoChest, RadChest], "id")){
		call(scr.obj_create, x, y, "Diver");
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