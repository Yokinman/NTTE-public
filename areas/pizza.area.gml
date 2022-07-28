#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro area_active variable_instance_get(GameCont, "ntte_active_" + mod_current, false) && (GameCont.area == mod_current || GameCont.lastarea == mod_current)
#macro area_visits variable_instance_get(GameCont, "ntte_visits_" + mod_current, 0)

#define area_subarea           return 1;
#define area_next              return [area_scrapyards, 1];
#define area_music             return mus102;
#define area_ambient           return amb102;
#define area_background_color  return area_get_background_color(area_pizza_sewers);
#define area_shadow_color      return area_get_shadow_color(area_pizza_sewers);
#define area_fog               return sprFog102;
#define area_darkness          return true;
#define area_secret            return true;

#define area_name(_subarea, _loops)
	return "2-@2(sprSlice:0)";
	
#define area_text
	return choose(
		choose(
			"IT SMELLS NICE HERE",
			"HUNGER...",
			"WHAT THE CHEESE" // thxsprite's childhood catchphrase // he's talking about it in a voice call right now bro // he got mad i didn't put '!?' at the end, don't let him win
		),
		mod_script_call("area", "lair", "area_text")
	);
	
#define area_mapdata(_lastX, _lastY, _lastArea, _lastSubarea, _subarea, _loops)
	return [((_lastArea == "red") ? 27 : _lastX), 9];
	
#define area_sprite(_spr)
	switch(_spr){
		 // Floors:
		case sprFloor1      : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return sprFloor102;
		case sprFloor1B     : with([self, other]) if(instance_is(self, Floor)){ area_setup_floor(); break; } return sprFloor102B;
		case sprFloor1Explo : return sprFloor102Explo;
		case sprDetail1     : return sprDetail102;
		
		 // Walls:
		case sprWall1Bot    : return sprWall102Bot;
		case sprWall1Top    : return sprWall102Top;
		case sprWall1Out    : return sprWall102Out;
		case sprWall1Trans  : return sprWall102Trans;
		case sprDebris1     : return sprDebris102;
		
		 // Decals:
		case sprTopPot      : return sprTopDecalPizzaSewers;
		case sprBones       : return sprPizzaSewerDecal;
	}
	
#define area_setup
	background_color = area_background_color();
	BackCont.shadcol = area_shadow_color();
	TopCont.darkness = area_darkness();
	TopCont.fog      = area_fog();
	
	 // Turtle Den Gen:
	var _den = {
		cols : 0,
		rows : 0,
		cols_max : 8,
		rows_max : 6
	};
	turtle_den = _den;
	goal       = (_den.cols_max * _den.rows_max) + 2;
	safespawn  = false;
	
	 // Manually Unlock Eyes:
	try{
		with(GameCont){
			 // Save Vars & Seed:
			var	_vars       = [],
				_crownAlarm = [],
				_seed       = random_get_seed();
				
			with(variable_instance_get_names(self)){
				array_push(_vars, [self, variable_instance_get(other, self)]);
			}
			with(_crownAlarm){
				array_push(_crownAlarm, [self, alarm0]);
			}
			
			 // Set Area to Pizza Sewers & Call room_start:
			area    = area_pizza_sewers;
			subarea = 1;
			loops   = 0;
			with(self){
				event_perform(ev_other, ev_room_start);
			}
			
			 // Restore Vars & Seed:
			with(_vars){
				if(!call(scr.variable_is_readonly, other, self[0])){
					variable_instance_set(other, self[0], self[1]);
				}
			}
			with(_crownAlarm){
				with(self[0]) alarm0 = other[1];
			}
			random_set_seed(_seed);
		}
	}
	catch(_error){
		call(scr.trace_error, _error);
	}
	
#define area_setup_spiral
	 // Void:
	type = 4;
	
	 // Reset:
	with(Spiral){
		instance_destroy();
	}
	repeat(30){
		with(self) event_perform(ev_step, ev_step_normal);
		with(Spiral) event_perform(ev_step, ev_step_normal);
		with(SpiralStar) event_perform(ev_step, ev_step_normal);
	}
	
	 // Pizza:
	with(SpiralStar){
		if(chance(1, 30)){
			sprite_index  = sprSlice;
			image_index   = 0;
			image_xscale *= 2/3;
			image_yscale *= 2/3;
			image_angle   = random(360);
			
			 // Fast Forward:
			repeat(irandom(10)){
				with(self){
					event_perform(ev_step, ev_step_normal);
				}
			}
		}
	}
	
	 // Manhole Cover:
	with(instance_create(x, y, SpiralDebris)){
		sprite_index = spr.Manhole;
		image_index  = 5;
		turnspeed   *= 2/3;
		
		 // Fast Forward:
		repeat(irandom_range(8, 12)){
			with(self){
				event_perform(ev_step, ev_step_normal);
			}
		}
	}
	
#define area_setup_floor
	 // Fix Depth:
	if(styleb) depth = 8;
	
	 // Footsteps:
	material = (styleb ? 6 : 2);
	
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
	
	 // So much pizza:
	with(Floor){
		if(place_meeting(x, y, PizzaBox) || place_meeting(x, y, HealthChest) || place_meeting(x, y, HPPickup)){
			styleb       = true;
			sprite_index = call(scr.area_get_sprite, mod_current, sprFloor1B);
		}
	}
	with(HPPickup){
		alarm0 *= 2;
	}
	
	 // Open Manhole:
	call(scr.obj_create, 10016, 10016, "PizzaManholeCover");
	
	 // Door:
	with(call(scr.instance_nearest_bbox, 10016, 10016, Floor)){
		call(scr.door_create, x + 16, y - 16, 90);
	}
	
	 // Turt Squad:
	with(TV){
		x += random(32);
		xstart = x;
		
		 // Viewing Carpet:
		with(call(scr.obj_create, x, y + 16, "SewerRug")){
			var _steps = 12;
			while(!collision_circle(x, y, 24, Wall, false, false) && _steps-- > 0){
				y += 4;
			}
			
			 // Squad:
			var	_color = [1, 2, 4],
				_dir = random(360);
				
			for(var i = 0; i < array_length(_color); i++){
				with(call(scr.obj_create, x, y, "TurtleCool")){
					move_contact_solid(_dir + orandom(10), 20 + random(4));
					snd_dead = asset_get_index(`sndTurtleDead${_color[i]}`);
					enemy_look(_dir + 180);
				}
				_dir += (360 / array_length(_color));
			}
		}
		
		 // The man himself:
		with(call(scr.obj_create, x + orandom(4), y + orandom(4), "TurtleCool")){
			move_contact_solid(random(180), random_range(12, 64));
			
			 // Visual:
			spr_idle = sprRatIdle;
			spr_walk = sprRatWalk;
			spr_hurt = sprRatHurt;
			spr_dead = sprRatDead;
			sprite_index = spr_idle;
			
			 // Sound:
			snd_hurt = sndRatHit;
			snd_dead = sndRatDie;
			
			 // Vars:
			become = Rat;
			right = 1;
		}
		
		 // Hungry Boy:
		with(call(scr.instance_random, [PizzaBox, HealthChest, HPPickup])){
			with(call(scr.obj_create, x + orandom(4), y + orandom(4), "TurtleCool")){
				snd_dead = sndTurtleDead3;
				right    = 1;
			}
		}
	}
	
	 // Light up specific things:
	with(instances_matching_ne([chestprop, RadChest], "id")){
		call(scr.obj_create, x, y - 28, "CatLight");
	}
	
	 // Cooler Pizza Box:
	with(PizzaBox){
		call(scr.obj_create, x, y, "PizzaStack");
		instance_delete(self);
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
	var	_den = GenCont.turtle_den,
		_scale = (goal / ((_den.cols_max * _den.rows_max) + 2));
		
	 // Generating:
	if(_den.cols <= 0){
		x = xstart - 48;
		instance_create(xstart, ystart - 32, Floor);
	}
	if(_den.rows <= 0){
		y = ystart - 64;
	}
	direction = 90;
	styleb = false;
	instance_create(x, y, Floor);
	
	 // Next:
	_den.rows++;
	if(_den.rows >= _den.rows_max * _scale){
		x += 32;
		_den.rows = 0;
		_den.cols++;
		if(_den.cols >= _den.cols_max * _scale){
			instance_destroy();
		}
	}
	
#define area_pop_props
	var	_x    = x + 16,
		_y    = y + 16,
		_west = !position_meeting(x - 16, y, Floor),
		_east = !position_meeting(x + 48, y, Floor),
		_nort = !position_meeting(x, y - 16, Floor),
		_sout = !position_meeting(x, y + 48, Floor);
		
	 // Gimme pizza:
	if(!_nort && !_sout && !_west && _east){
		repeat(irandom_range(1, 4)){
			call(scr.obj_create, _x + orandom(4), _y + orandom(4), choose("Pizza", PizzaBox, "PizzaChest"));
		}
	}
	
	 // Top Decals:
	if(chance(1, 30)){
		call(scr.obj_create, _x, _y, "TopDecal");
	}
	
#define area_pop_extras
	var	_x1 = null,
		_y1 = null,
		_x2 = null,
		_y2 = null;
		
	with(instances_matching_lt(Floor, "y", spawn_y - 32)){
		if(_x1 == null || bbox_left       < _x1) _x1 = bbox_left;
		if(_y1 == null || bbox_top        < _y1) _y1 = bbox_top;
		if(_x2 == null || bbox_right + 1  > _x2) _x2 = bbox_right + 1;
		if(_y2 == null || bbox_bottom + 1 > _y2) _y2 = bbox_bottom + 1;
	}
	
	 // Sewage Hole:
	with(instance_nearest(lerp(_x1, _x2, 0.8), _y1, Floor)){
		call(scr.obj_create, x, y, "PizzaDrain");
	}
	
	 // Toons Viewer:
	with(instance_nearest(lerp(_x1, _x2, 0.5) - 16, lerp(_y1, _y2, 0.3), Floor)){
		call(scr.obj_create, x, y - 16, "PizzaTV");
	}
	
	 // Corner Walls:
	with(Floor){
		     if(!place_meeting(x - 32, y, Floor) && !place_meeting(x, y - 32, Floor)) instance_create(x,      y,      Wall);
		else if(!place_meeting(x + 32, y, Floor) && !place_meeting(x, y - 32, Floor)) instance_create(x + 16, y,      Wall);
		else if(!place_meeting(x - 32, y, Floor) && !place_meeting(x, y + 32, Floor)) instance_create(x,      y + 16, Wall);
		else if(!place_meeting(x + 32, y, Floor) && !place_meeting(x, y + 32, Floor)) instance_create(x + 16, y + 16, Wall);
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
				with(instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1) - 8, Drip)){
					sprite_index = sprCheeseDrip;
				}
			}
			
			break;
		}
	}
	
#define ntte_setup_HPPickup(_inst)
	 // Yummy HP:
	if(area_active){
		with(instances_matching(_inst, "sprite_index", sprHP)){
			sprite_index = sprSlice;
			num          = ceil(num / 2);
		}
	}
	
#define ntte_setup_HealthChest(_inst)
	 // Yummy HP:
	if(area_active){
		with(instances_matching(_inst, "sprite_index", sprHealthChest)){
			sprite_index = choose(sprPizzaChest1, sprPizzaChest2);
			spr_dead     = sprPizzaChestOpen;
			num          = ceil(num / 2);
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