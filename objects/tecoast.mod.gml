#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Gather Objects:
	for(var i = 1; true; i++){
		var _scrName = script_get_name(i);
		if(_scrName != undefined){
			call(scr.obj_add, script_ref_create(i));
		}
		else break;
	}
	
	 // Store Script References:
	with([Harpoon_rope, Harpoon_unrope, portal_pickups]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // Bind Events:
	script_bind(CustomDraw, draw_diver_laser, -5, true);
	global.portal_pickups_bind = script_bind(CustomStep, portal_pickups_step, 0, false);
	
	 // Harpoon Ropes:
	global.harpoon_rope_bind = [
		script_bind(CustomDraw, draw_harpoon_rope,  1, false),
		script_bind(CustomDraw, draw_harpoon_rope, -9, false)
	];
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
	
#define BloomingAssassin_create(_x, _y)
	with(instance_create(_x, _y, JungleAssassin)){
		 // Visual:
		spr_idle = spr.BloomingAssassinIdle;
		spr_walk = spr.BloomingAssassinWalk;
		spr_hurt = spr.BloomingAssassinHurt;
		spr_dead = spr.BloomingAssassinDead;
		
		return self;
	}
	
	
#define BloomingAssassinHide_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle    = spr.BloomingAssassinHide;
		spr_walk    = spr.BloomingAssassinHide;
		spr_hurt    = spr.BloomingAssassinHurt;
		spr_dead    = spr.BloomingAssassinDead;
		spr_shadow  = shd24;
		hitid       = [spr.BloomingAssassinIdle, "BLOOMING ASSASSIN"];
		image_speed = 0.4;
		depth       = 1;
		
		 // Sound:
		snd_hurt = sndJungleAssassinHurt;
		snd_dead = sndJungleAssassinDead;
		
		 // Vars:
		maxhealth = 12;
		raddrop   = 10;
		size      = 1;
		
		 // Alarms:
		alarm0 = 90 + random(90);
		alarm1 = random_range(1500, 3000);
		
		return self;
	}
	
#define BloomingAssassinHide_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	
	 // Stay Still:
	x = xstart;
	y = ystart;
	speed = 0;
	
	 // Player is making bushman uncomfortable:
	if(place_meeting(x, y, Player)){
		alarm0 = min(alarm0, 1);
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	if(image_index < 1){
		image_index += random(image_speed_raw * 0.05) - image_speed_raw;
		
		 // Tell Sound:
		if(image_index >= 1 && point_seen(x, y, -1)){
			sound_play(sndJungleAssassinPretend);
		}
	}
	
#define BloomingAssassinHide_alrm0
	alarm0 = 30 + random(60);
	
	 // Become Man:
	if(enemy_target(x, y)){
		var _targetDis = target_distance;
		if(_targetDis < 32 || (_targetDis < 128 && chance(1, 2))){
			alarm1 = min(alarm1, 1);
			
			 // Intimidating:
			motion_add(target_direction, 4);
			enemy_look(direction);
		}
	}
	
#define BloomingAssassinHide_alrm1
	 // Assassin Time:
	var _inst = call(scr.obj_create, x, y, "BloomingAssassin");
	with(["x", "y", "xstart", "ystart", "xprevious", "yprevious", "hspeed", "vspeed", "friction", "sprite_index", "image_index", "image_speed", "image_xscale", "image_yscale", "image_angle", "image_blend", "image_alpha", "spr_shadow", "spr_shadow_x", "spr_shadow_y", "hitid", "snd_hurt", "snd_dead", "maxhealth", "my_health", "raddrop", "size", "team", "right", "nexthurt", "canmelee", "meleedamage"]){
		variable_instance_set(_inst, self, variable_instance_get(other, self));
	}
	
	 // Effects:
	repeat(4){
		with(call(scr.fx, x, y, 1 + random(2), choose(Dust, Feather))){
			sprite_index = sprLeaf;
		}
	}
	
	instance_delete(self);
	
#define BloomingAssassinHide_hurt(_damage, _force, _direction)
	alarm1 = min(alarm1, 1);
	call(scr.enemy_hurt, _damage, _force / 2, _direction);
	
#define BloomingAssassinHide_death
	 // Bonus Rads:
	call(scr.rad_drop, x, y, raddrop, direction, speed);
	
	
#define BloomingBush_create(_x, _y)
	with(instance_create(_x, _y, Bush)){
		 // Visual:
		spr_idle = spr.BloomingBushIdle;
		spr_hurt = spr.BloomingBushHurt;
		spr_dead = spr.BloomingBushDead;
		
		return self;
	}
	
	
#define BloomingCactus_create(_x, _y)
	with(instance_create(_x, _y, Cactus)){
		 // Visual:
		var _s = irandom(array_length(spr.BloomingCactusIdle) - 1);
		spr_idle = spr.BloomingCactusIdle[_s];
		spr_hurt = spr.BloomingCactusHurt[_s];
		spr_dead = spr.BloomingCactusDead[_s];
		
		return self;
	}
	
	
#define BuriedCar_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle   = spr.BuriedCarIdle;
		spr_hurt   = spr.BuriedCarHurt;
		spr_dead   = mskNone;
		spr_shadow = mskNone;
		hitid      = [spr_idle, "BURIED CAR"];
		
		 // Sound:
		snd_hurt = sndHitMetal;
		
		 // Vars:
		maxhealth = 20;
		size      = 2;
		target    = call(scr.instance_nearest_bbox, x, y, Floor);
		
		return self;
	}
	
#define BuriedCar_step
	if(instance_exists(target)){
		with(target){
			other.x = bbox_center_x;
			other.y = bbox_center_y;
		}
	}
	else if(my_health > 0){
		my_health = 0;
	}
	
#define BuriedCar_death
	 // Explosion:
	repeat(2) call(scr.projectile_create, x + orandom(3), y + orandom(3), Explosion);
	repeat(2) call(scr.projectile_create, x + orandom(3), y + orandom(3), SmallExplosion);
	sound_play(sndExplosionCar);
	
	 // Break Floor:
	with(target){
		with(call(scr.instances_meeting_instance, self, Detail)){
			if(place_meeting(x, y, other)){
				instance_destroy();
			}
		}
		for(var _x = bbox_left; _x < bbox_right + 1; _x += 16){
			for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 16){
				instance_create(_x, _y, FloorExplo);
			}
		}
		instance_destroy();
	}
	
	
#define ClamShield_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.ClamShield;
		spr_shadow   = shd16;
		spr_shadow_x = 0;
		spr_shadow_y = 7;
		
		 // Vars:
		mask_index = mskOldGuardianDeflect;
		creator    = noone;
		damage     = 0;
		force      = 3;
		typ        = 0;
		wep        = "clam shield";
		
		 // Disable Events:
		on_anim = [];
		on_wall = [];
		
		return self;
	}
	
#define ClamShield_step
	var	_wep  = (("wep"  in creator) ? creator.wep  : wep),
		_bwep = (("bwep" in creator) ? creator.bwep : wep_none);
		
	if(instance_exists(creator) && creator.visible && (wep == _wep || wep == _bwep)){
		var	_shieldList = instances_matching(instances_matching(obj.ClamShield, "wep", wep), "creator", creator),
			_boltStick  = instances_matching(BoltStick, "target", self),
			_b          = ((wep == _bwep) ? "b" : "");
			
		 // Aim:
		if("gunangle" in creator){
			var	_shieldNum = array_length(_shieldList),
				_goalDir   = creator.gunangle + (180 * ((array_find_index(_shieldList, self) - ((_shieldNum - 1) / 2)) / _shieldNum)),
				_lastDir   = image_angle;
				
			if(wep == _bwep && call(scr.wep_raw, _wep) == call(scr.wep_raw, _bwep)){
				_goalDir += 180;
			//	if("bwepangle" in creator){
			//		_goalDir += creator.bwepangle;
			//	}
			}
		//	else if("wepangle" in creator){
		//		_goalDir += creator.wepangle;
		//	}
			
			image_angle = angle_lerp_ct(image_angle, _goalDir, (instance_is(creator, Player) ? 1/2 : 1/16));
			direction   = image_angle;
			
			 // Manually Rotate BoltSticks:
			with(_boltStick){
				image_angle += other.image_angle - _lastDir;
			}
		}
		
		 // Follow Creator:
		var	_l = 16 - variable_instance_get(creator, _b + "wkick", 0),
			_d = image_angle;
			
		if(_l >= 0){
			_l = max(_l, 12);
		}
		
		x         = creator.x + lengthdir_x(_l, _d);
		y         = creator.y + lengthdir_y(_l, _d);
		xprevious = x;
		yprevious = y;
		depth     = creator.depth - (y > creator.y);
		
		 // Bolts:
		with(_boltStick){
			var	_dis = 2 + (sprite_get_xoffset(sprite_index) - sprite_get_bbox_right(sprite_index)),
				_dir = image_angle;
				
			x = other.x + lengthdir_x(_dis, _dir);
			y = other.y + lengthdir_y(_dis, _dir);
		}
	}
	else instance_destroy();
	
#define ClamShield_draw
	var	_xsc   = image_xscale,
		_ysc   = image_yscale,
		_ang   = image_angle,
		_num   = image_number,
		_x     = x + lengthdir_x(-6, _ang),
		_y     = y + lengthdir_y(-6, _ang) + 5,
		_shn   = (("gunshine" in creator) ? creator.gunshine : 0),
		_off   = (_num / 7) * _xsc,
		_surfW = 2 * (_off + max(abs(sprite_height), abs(sprite_width) + ceil((_num - 1) * 2/3 * _xsc))),
		_surfH = _surfW;
		
	with(call(scr.surface_setup, `ClamShield${self}`, _surfW, _surfH, call(scr.option_get, "quality:main"))){
		x    = _x - (w / 2);
		y    = _y - (h / 2);
		free = true;
		
		 // Setup:
		if(
			reset
			|| abs(lq_get(self, "lastangle") - _ang) > 1
			|| lq_get(self, "lastshine") != _shn
		){
			reset     = false;
			lastangle = _ang;
			lastshine = _shn;
			
			 // Draw 3D Shield:
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(x, y, w, h, 0);
			
			with(other){
				 // Shield:
				for(var i = 0; i < _num; i++){
					var _disOff = _off * (1 - sqr((i - ((_num - 1) / 3)) / ((_num - 1) / 2)));
					draw_sprite_ext(
						sprite_index,
						i,
						_x + lengthdir_x(_disOff, _ang),
						_y + lengthdir_y(_disOff, _ang) - (i * _xsc * 2/3),
						_xsc * 1.5,
						_ysc,
						_ang,
						image_blend,
						1
					);
				}
				
				 // Shine:
				draw_set_color_write_enable(true, true, true, false);
				draw_sprite_ext(spr.Shine24, _shn, _x, _y, _xsc, _ysc, 0, image_blend, 1);
				draw_set_color_write_enable(true, true, true, true);
			}
			
			d3d_set_projection_ortho(view_xview_nonsync, view_yview_nonsync, game_width, game_height, 0);
			surface_reset_target();
		}
		
		 // Draw Shield:
		draw_set_alpha(other.image_alpha);
			
			 // Outline:
			draw_set_fog(true, c_black, 0, 0);
			for(var i = 0; i < 360; i += 90){
				call(scr.draw_surface_scale, surf, x + dcos(i), y + dsin(i), 1 / scale);
			}
			draw_set_fog(false, 0, 0, 0);
			
			 // Normal:
			call(scr.draw_surface_scale, surf, x, y, 1 / scale);
			
		draw_set_alpha(1);
	}
	
#define ClamShield_hit
	 // Push Enemies:
	if(!instance_is(other, prop)) with(other){
		motion_add(other.image_angle, other.force / max(size, 1));
	}
	
#define ClamShield_projectile
	if(instance_exists(self)){
		with(other){
			if(typ == 1 || typ == 2){
				if(speed > 0 && !instance_is(self, ToxicGas)){
					var	_deflectDir = other.image_angle,
						_typ        = (other.candeflect ? typ : 2);
						
					if(
						(instance_is(other.creator, Player) && team != other.team)
						||
						abs(angle_difference(direction + 180, _deflectDir)) < 90
					){
						var _b = ((other.wep == variable_instance_get(other.creator, "bwep")) ? "b" : "");
						
						 // Kick:
						if((_b + "wkick") in other.creator){
							var _kick = variable_instance_get(other.creator, _b + "wkick");
							if(abs(_kick) < 4){
								_kick += max(-8, (4 + (force / 2)) * ((_typ == 1) ? -1 : 1));
							}
							variable_instance_set(other.creator, _b + "wkick", _kick);
						}
						
						 // Knockback:
						if(force > 3){
							with(other.creator){
								speed = max(speed, friction_raw);
								motion_add(other.direction, other.force / ((_typ == 2) ? 3 : 6));
							}
						}
						
						 // Deflect:
						if(_typ == 1){
							speed      += friction * 3;
							direction   = _deflectDir - clamp(angle_difference(direction + 180, _deflectDir), -40, 40);
							image_angle = direction;
							if(instance_is(other.creator, Player)){
								deflected = true;
								team      = other.team;
							}
						}
						
						 // Effects:
						call(scr.sound_play_at, x, y, sndCrystalRicochet, 1 + random(0.2), 3);
						with(instance_create(x, y, Deflect)){
							image_angle = _deflectDir;
						}
						if(chance(1, 2) && chance(force, 12)){
							call(scr.fx, x, y, [image_angle + orandom(10), random_range(1, 3)], Bubble);
						}
						else{
							instance_create(x, y, Dust);
						}
						sleep(min(100, damage));
						
						 // Destroyables:
						if(_typ == 2){
							 // Bolts Stick:
							if(array_find_index([sprBolt, sprBoltGold, sprHeavyBolt, sprUltraBolt, sprSplinter, sprSeeker], sprite_index) >= 0){
								var _target = other;
								with(instance_create(x, y, BoltStick)){
									sprite_index = other.sprite_index;
									image_index  = image_number - 1;
									image_angle  = other.image_angle;
									target       = _target;
								}
							}
							
							 // Bye bro:
							instance_destroy();
						}
					}
				}
			}
		}
	}
	
#define ClamShield_grenade
	var _team = team;
	event_perform(ev_collision, projectile);
	team = _team;
	
	
#define ClamShieldSlash_create(_x, _y)
	with(instance_create(_x, _y, Slash)){
		 // Visual:
		sprite_index = spr.ClamShieldSlash;
		depth        = -3;
		
		 // Vars:
		mask_index = msk.ClamShieldSlash;
		friction   = 0.2;
		damage     = 10;
		force      = 16;
		
		return self;
	}
	
	
#define CoastBigDecal_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CoastDecal")){
		 // Visual:
		spr_idle = spr.ShellIdle;
		spr_hurt = spr.ShellHurt;
		spr_dead = spr.ShellDead;
		spr_bott = spr.ShellBott;
		spr_foam = spr.ShellFoam;
		depth = -2;
		
		 // Sound:
		snd_dead = sndHyperCrystalHurt;
		
		 // Vars:
		mask_index = mskScrapBoss;
		maxhealth *= 2;
		my_health *= 2;
		size       = 4;
		shell      = true;
		
		return self;
	}
	
	
#define CoastDecal_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		var _t = irandom(array_length(spr.RockIdle) - 1);
		spr_idle   = spr.RockIdle[_t];
		spr_hurt   = spr.RockHurt[_t];
		spr_dead   = spr.RockDead[_t];
		spr_bott   = spr.RockBott[_t];
		spr_foam   = spr.RockFoam[_t];
		spr_shadow = mskNone;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = sndWallBreakRock;
		
		 // Vars:
		mask_index = mskBandit;
		maxhealth  = 50;
		size       = 3;
		shell      = false;
		
		 // Offset:
		x += orandom(10);
		y += orandom(10);
		xstart = x;
		ystart = y;
		
		 // Doesn't Use Coast Wading System:
		canwade = false;
		
		return self;
	}
	
#define CoastDecal_step
	 // Space Out Decals:
	if(place_meeting(x, y, CustomProp)){
		with(call(scr.instances_meeting_instance, self, instances_matching_le(obj.CoastDecal, "size", size))){
			if(place_meeting(x, y, other)){
				var	_dir = point_direction(other.x, other.y, x, y),
					_dis = 8;
					
				do{
					x += lengthdir_x(_dis, _dir);
					y += lengthdir_y(_dis, _dir);
				}
				until(!place_meeting(x, y, other) && !position_meeting(x, y, Floor));
				
				xstart    = x;
				ystart    = y;
				xprevious = x;
				yprevious = y;
			}
		}
	}
	
#define CoastDecal_death
	 // Water Rock Debris:
	if(!shell){
		var _ang = random(360);
		for(var a = _ang; a < _ang + 360; a += 360 / 3){
			with(instance_create(x, y, MeleeHitWall)) image_angle = a + orandom(10);
		}
		repeat(choose(2, 3)){
			with(instance_create(x + orandom(2), y + orandom(2), Debris)){
				motion_set(other.direction + orandom(10), (speed + other.speed) / 2);
			}
		}
	}

	 // Special Corpse:
	with(call(scr.obj_create, x, y, "CoastDecalCorpse")){
		sprite_index = other.spr_dead;
		spr_bott     = other.spr_bott;
		spr_foam     = other.spr_foam;
		image_xscale = other.image_xscale;
		if(other.shell){
			depth -= 2;
			with(my_floor){
				mask_index = mskSalamander;
			}
		}
	}
	spr_dead = -1;


#define CoastDecalCorpse_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.RockDead[0];
		spr_bott     = spr.RockBott[0];
		spr_foam     = spr.RockFoam[0];
		depth        = 5;
		image_speed  = 0.4;
		image_index  = 0;
		
		 // Floor:
		var _off = 0;
		do{
			my_floor = instance_create(_off, 0, Floor);
			with(my_floor){
				x = other.x;
				y = other.y;
				instance_change(FloorExplo, false);
				mask_index = mskAlly;
				visible    = false;
				material   = 2;
			}
			_off += 32;
		}
		until instance_exists(my_floor);
		
		return self;
	}
	
#define CoastDecalCorpse_step
	 // Animate:
	if(image_speed != 0 && anim_end){
		image_speed = 0;
		image_index = image_number - 1;
	}


#define Creature_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle    = spr.CreatureIdle;
		spr_walk    = spr_idle;
		spr_hurt    = spr.CreatureHurt;
		spr_bott    = spr.CreatureBott;
		spr_foam    = spr.CreatureFoam;
		image_speed = 0.4;
		depth       = -3;
		
		 // Sounds:
		snd_hurt = sndOasisBossHurt;
		
		 // Vars:
		mask_index = spr_foam;
		friction   = 0.4;
		maxhealth  = 999999999;
		size       = 8;
		team       = 1;
		target     = noone;
		right      = choose(-1, 1);
		walk       = 0;
		walkspeed  = 1.2;
		maxspeed   = 2.6;
		canwade    = false;
		scared     = false;
		
		 // Alarms:
		alarm1 = 30;
		
		return self;
	}
	
#define Creature_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Run away when hurt:
	if(sprite_index == spr_hurt && !scared){
		scared = true;
		instance_create(x + (65 * right), y - 24, AssassinNotice);
	}

	 // Pushed away from floors:
	if(distance_to_object(Floor) < 64){
		with(call(scr.instance_nearest_bbox, x, y, Floor)){
			var _dir = point_direction(bbox_center_x, bbox_center_y, other.x, other.y);
			with(other){
				motion_add_ct(_dir, 3);
			}
		}
	}

	 // Push Player:
	if(place_meeting(x, y, Player)){
		with(call(scr.instances_meeting_instance, self, Player)){
			if(place_meeting(x, y, other)){
				motion_add_ct(point_direction(other.x, other.y, x, y), 3);
			}
		}
	}
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	
#define Creature_draw
	draw_self_enemy();
	
#define Creature_alrm1
	alarm1 = 30;
	
	 // Target Nearest Wading Player:
	if(instance_exists(Player)){
		var _disMax = infinity;
		with(Player){
			if(!collision_line(x, y, other.x, other.y, Floor, false, false)){
				var _dis = point_distance(x, y, other.x, other.y);
				if(_dis < _disMax){
					_disMax = _dis;
					other.target = self;
				}
			}
		}
	}
	
	 // Coolin:
	if(!scared){
		 // Investigate Bro:
		if(instance_exists(target)){
			var _targetDir = target_direction;
			if(target_distance > 128){
				enemy_walk(_targetDir, random_range(20, 30));
			}
			else if(chance(1, 4)){
				instance_create(x + (65 * right), y - 24, HealFX);
			}
			enemy_look(_targetDir);
		}
		
		 // Wander:
		else{
			enemy_walk(direction + random(20), random_range(20, 30));
			enemy_look(direction);
		}
	}
	
	 // RUUUN:
	else{
		if(instance_exists(target)){
			enemy_walk(target_direction + 180, alarm1);
		}
		else if(enemy_target(x, y)){
			enemy_walk(target_direction + 180, random_range(20, 30));
		}
		enemy_look(direction);
	}
	
	
#define Diver_create(_x, _y)
	/*
		The bandit of the aquatic route, fires a harpoon (bolt) at the player after a short delay
		
		Vars
			gonnafire - About to fire a harpoon, true/false
			reload    - Cooldown before firing again in frames
			laser     - The width of their laser sight
			palm      - Their palm tree fort's 'id', if residing in one
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle   = spr.DiverIdle;
		spr_walk   = spr.DiverWalk;
		spr_hurt   = spr.DiverHurt;
		spr_dead   = spr.DiverDead;
		spr_weap   = spr.HarpoonGun;
		spr_shadow = shd24;
		hitid      = [spr_idle, "DIVER"];
		depth      = -2;
		
		 // Sound:
		var _water = call(scr.area_get_underwater, GameCont.area);
		snd_hurt = (_water ? sndOasisHurt  : sndHitMetal);
		snd_dead = (_water ? sndOasisDeath : sndAssassinDie);
		
		 // Vars:
		mask_index = mskBandit;
		maxhealth  = 10;
		raddrop    = 4;
		size       = 1;
		walk       = 0;
		walkspeed  = 0.8;
		maxspeed   = 3;
		gunangle   = random(360);
		direction  = gunangle;
		gonnafire  = false;
		reload     = 0;
		laser      = 0;
		palm       = noone;
		
		 // Alarms:
		alarm1 = 90 + irandom(90);
		
		return self;
	}

#define Diver_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	
	 // Reloading Effects:
	if(reload > 0){
		reload -= current_time_scale;
		
		if(reload >= 6 && reload <= 12){
			wkick = lerp_ct(wkick, 6, 3/5);
		}
		
		else if(reload <= 0){
			alarm1 = max(alarm1, 30)
			wkick  = -2;
			sound_play_hit(sndCrossReload, 0.1);
			
			var	_l = 8,
				_d = gunangle;
				
			instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), WepSwap);
		}
	}
	
	 // Laser Sight:
	laser = lerp_ct(laser, gonnafire, 0.3);
	
#define Diver_draw
	var _back = (gunangle <= 180 || laser != 0);
	
	 // Gun Behind:
	if(_back) Diver_draw_wep();
	
	 // Self:
	draw_self_enemy();
	
	 // Tree:
	if(instance_exists(palm)){
		with(palm){
			draw_self();
		}
	}
	
	 // Gun Above:
	if(!_back) Diver_draw_wep();
	
#define Diver_alrm1
	alarm1 = 60 + irandom(30);
	
	 // Breath:
	if(call(scr.area_get_underwater, GameCont.area)){
		with(instance_create(x, y, Bubble)){
			speed /= 3;
		}
	}
	
	 // Shooty Harpoony:
	if(gonnafire){
		gonnafire = false;
		
		call(scr.projectile_create, x, y, "DiverHarpoon", gunangle, 14);
		sound_play(sndCrossbow);
		
		alarm1 = 20 + random(30);
		reload = 90 + random(30);
		wkick  = 8;
	}
	
	else{
		if(enemy_target(x, y) && target_visible){
			enemy_look(point_direction(x, y, target.x + target.hspeed, target.y + target.vspeed));
			
			var _targetDis = target_distance;
			
			if((_targetDis > 64 && _targetDis < 320) || instance_exists(palm)){
				 // Prepare to Shoot:
				if(reload <= 0 && chance(1, 2)){
					alarm1 = 12;
					gonnafire = true;
					sound_play_pitchvol(sndSniperTarget, 4, 0.8);
					sound_play_pitchvol(sndCrossReload, 0.5, 0.2);
					wkick = -4;
				}
				
				 // Reposition:
				else{
					alarm1 = 20 + random(30);
					if(chance(1, 2)){
						enemy_walk(
							gunangle + choose(-90, 90) + orandom(10),
							10
						);
					}
				}
			}
			
			 // Move Away From Target:
			else{
				alarm1 = 20 + irandom(30);
				enemy_walk(
					gunangle + 180 + orandom(30),
					random_range(15, 30)
				);
			}
			
			 // Go to Nearest Non-Pit Floor:
			if(array_length(instances_matching(Floor, "sprite_index", spr.FloorTrenchB))){
				with(call(scr.instance_nearest_bbox, x + (hspeed * 4), y + (vspeed * 4), instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB))){
					if(!place_meeting(x, y, other)){
						other.direction = point_direction(other.x, other.y, bbox_center_x, bbox_center_y) + orandom(20);
					}
				}
			}
		}
		
		 // Wander:
		else{
			enemy_walk(random(360), 30);
			enemy_look(direction);
		}
	}
	
#define Diver_death
	pickup_drop(20, 0);
	
#define Diver_draw_wep
	 // Bolt:
	if(reload < 6){
		var	_ox = 6 - (wkick + reload),
			_oy = -right,
			_x  = x + lengthdir_x(_ox, gunangle) + lengthdir_x(_oy, gunangle - 90),
			_y  = y + lengthdir_y(_ox, gunangle) + lengthdir_y(_oy, gunangle - 90);
			
		draw_sprite_ext(sprBolt, 1, _x, _y, 1, right, gunangle, image_blend, image_alpha);
	}
	
	 // Weapon:
	call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
	
#define DiverHarpoon_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprBolt;
		
		 // Vars:
		mask_index = mskBolt;
		creator    = noone;
		damage     = 4;
		force      = 8;
		typ        = 2;
		
		return self;
	}
	
#define DiverHarpoon_step
	 // Alarms:
	if(alarm0_run) exit;
	
#define DiverHarpoon_end_step
	 // Trail:
	var	_x1 = x,
		_y1 = y,
		_x2 = xprevious,
		_y2 = yprevious;
		
	with(instance_create(x, y, BoltTrail)){
		image_xscale = point_distance(_x1, _y1, _x2, _y2);
		image_angle = point_direction(_x1, _y1, _x2, _y2);
	}
	
#define DiverHarpoon_anim
	image_speed = 0;
	image_index = image_number - 1;
	
#define DiverHarpoon_alrm0
	instance_destroy();
	
#define DiverHarpoon_hit
	var _inst = other;
	if(speed > 0 && projectile_canhit(_inst)){
		projectile_hit_np(_inst, damage, force, 40);
		
		 // Stick in Player:
		if(instance_exists(self)){
			with(instance_create(x, y, BoltStick)){
				image_angle = other.image_angle;
				target      = _inst;
			}
			instance_destroy();
		}
	}
	
#define DiverHarpoon_wall
	 // Stick in Wall:
	if(speed > 0){
		speed = 0;
		sound_play_hit(sndBoltHitWall,.1);
		move_contact_solid(direction, 16);
		instance_create(x, y, Dust);
		alarm0 = 30;
		typ = 0;
	}


#define Gull_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle   = spr.GullIdle;
		spr_walk   = spr.GullWalk;
		spr_hurt   = spr.GullHurt;
		spr_dead   = spr.GullDead;
		spr_weap   = spr.GullSword;
		spr_shadow = shd24;
		hitid      = [spr_idle, "GULL"];
		depth      = -2;
		
		 // Sound:
		snd_hurt = sndRavenHit;
		snd_dead = sndAllyDead;
		
		 // Vars:
		mask_index = mskBandit;
		maxhealth  = 8;
		raddrop    = 3;
		size       = 1;
		walk       = 0;
		walkspeed  = 0.8;
		maxspeed   = 3.5;
		gunangle   = random(360);
		direction  = gunangle;
		wepangle   = 140 * choose(-1, 1);
		
		 // Alarms:
		alarm1 = 60 + irandom(60);
		alarm2 = -1;
		
		return self;
	}
	
#define Gull_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	
#define Gull_draw
	if(gunangle <= 180) call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);
	draw_self_enemy();
	if(gunangle >  180) call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);
	
#define Gull_alrm1
	alarm1 = 40 + irandom(30);
	
	if(enemy_target(x, y) && target_visible){
		enemy_look(target_direction);
		
		var _targetDis = target_distance;
		
		 // Target Nearby:
		if(_targetDis > 10 && _targetDis < 480){
			 // Attack:
			if(_targetDis < 60){
				alarm2 = 8;
				instance_create(x, y, AssassinNotice);
				sound_play_pitch(sndRavenScreech, 1.15 + random(0.1));
			}
			
			 // Move Toward Target:
			else{
				alarm1 = 40 + irandom(10);
				enemy_walk(
					gunangle + orandom(20),
					random_range(20, 35)
				);
			}
		}
		
		 // Move Toward Target:
		else{
			alarm1 = 30 + irandom(10);
			enemy_walk(
				gunangle + orandom(20),
				random_range(10, 30)
			);
		}
	}
	
	 // Wander:
	else{
		enemy_walk(random(360), 30);
		enemy_look(direction);
	}
	
#define Gull_alrm2
	 // Slash:
	if(instance_exists(target)){
		enemy_look(target_direction + orandom(10));
	}
	with(call(scr.projectile_create, x, y, EnemySlash, gunangle, 4)){
		damage = 2;
	}
	sound_play(sndChickenSword);
	motion_add(gunangle, 4);
	wepangle *= -1;
	wkick = -3;
	
#define Gull_death
	pickup_drop(16, 0);
	
	
#define Harpoon_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.Harpoon;
		image_speed  = 0;
		
		 // Vars:
		mask_index = mskBolt;
		creator    = noone;
		target     = noone;
		damage     = 8;
		force      = 8;
		typ        = 1;
		rope       = [];
		corpses    = [];
		pickup     = false;
		ammo_type  = type_bolt;
		setup      = true;
		
		 // Merged Weapons Support:
		temerge_on_hit = script_ref_create(Harpoon_temerge_hit);
		
		return self;
	}
	
#define Harpoon_setup
	setup = false;
	
	 // Facing:
	if(hspeed != 0){
		image_yscale *= sign(hspeed);
	}
	
#define Harpoon_step
	 // Skewered Corpses:
	with(corpses){
		if(instance_exists(self) && speed > 0){
			if(other.speed > 0){
				x          += (other.x - x) * 0.3 * current_time_scale;
				y          += (other.y - y) * 0.3 * current_time_scale;
				hspeed      = other.hspeed;
				vspeed      = other.vspeed;
				xprevious   = x + hspeed_raw;
				yprevious   = y + vspeed_raw;
				image_speed = 0.4;
				image_index = 1;
				depth       = other.depth - 1;
			}
			else{
				depth = 1;
				var _max = 5;
				if(speed > _max){
					speed = _max - random(1);
					direction += orandom(80);
				}
			}
		}
		else{
			if(instance_exists(self)) depth = 1;
			other.corpses = call(scr.array_delete_value, other.corpses, self);
		}
	}
	
	 // Movin:
	if(speed > 0){
		 // Rope Length:
		with(rope) if(!harpoon_stuck){
			if(instance_exists(link1) && instance_exists(link2)){
				length = point_distance(link1.x, link1.y, link2.x, link2.y);
			}
		}
		
		 // Bolt Marrow:
		if(skill_get(mut_bolt_marrow) > 0){
			var _target = call(scr.instance_nearest_array, x, y, instances_matching_ne(instances_matching_ne(hitme, "team", team, 0), "mask_index", mskNone, sprVoid));
			if(distance_to_object(_target) < (16 * skill_get(mut_bolt_marrow))){
				if(!place_meeting(x, y, _target)){
					if(!collision_line(x, y, _target.x, _target.y, Wall, false, false)){
						direction   = point_direction(x, y, _target.x, _target.y);
						image_angle = direction;
					}
				}
			}
		}
		
		 // Skewer Corpses:
		if(place_meeting(x, y, Corpse)){
			with(call(scr.instances_meeting_instance, self, instances_matching_ne(instances_matching_gt(Corpse, "speed", 1), "mask_index", -1))){
				if(place_meeting(x, y, other)){
					var _corpse = self;
					with(other){
						if(array_find_index(corpses, _corpse) < 0){
							if(sprite_get_width(_corpse.sprite_index) < 64 && sprite_get_height(_corpse.sprite_index) < 64){
								var _canTake = true;
								with(instances_matching_ne(obj.Harpoon, "id")){
									if(array_find_index(corpses, _corpse) >= 0){
										_canTake = false;
										break;
									}
								}
								
								if(_canTake){
									 // Skewer:
									array_push(corpses, _corpse);
									if(hspeed != 0){
										_corpse.image_xscale = -sign(hspeed);
									}
									speed = max(speed - (3 * (1 + _corpse.size)), 12);
									
									 // Effects:
									view_shake_at(x, y, 6);
									with(instance_create(_corpse.x, _corpse.y, ThrowHit)){
										motion_add(other.direction + orandom(30), 3);
										image_speed = random_range(0.8, 1);
										image_xscale = min(0.5 * (_corpse.size + 1), 1);
										image_yscale = image_xscale;
									}
									sound_play_pitchvol(sndChickenThrow,   0.4 + random(0.2), 3);
									sound_play_pitchvol(sndGrenadeShotgun, 0.6 + random(0.2), 0.3 + (0.2 * _corpse.size));
								}
							}
						}
					}
				}
			}
		}
		
		 // Stick in Chests:
		if(place_meeting(x, y, chestprop)){
			target = instance_nearest(x, y, chestprop);
			instance_destroy();
			exit;
		}
	}
	else if(pickup){
		instance_destroy();
		exit;
	}
	
	 // Can we have a typ variable for portalshocks or something:
	if(place_meeting(x + hspeed_raw, y + vspeed_raw, PortalShock)){
		pickup = true;
		instance_destroy();
	}
	
#define Harpoon_end_step
	if(setup) Harpoon_setup();
	
	 // Trail:
	if(speed > 0){
		var	_x1 = x,
			_y1 = y,
			_x2 = xprevious,
			_y2 = yprevious;
			
		with(instance_create(x, y, BoltTrail)){
			image_yscale = 0.6;
			image_xscale = point_distance(_x1, _y1, _x2, _y2);
			image_angle  = point_direction(_x1, _y1, _x2, _y2);
			creator      = other.creator;
		}
	}
	
#define Harpoon_hit
	if(speed > 0 && projectile_canhit(other)){
		projectile_hit(other, damage, force);
		
		 // Stick in enemies that don't die:
		if(instance_exists(other) && other.my_health > 0){
			target = other;
			instance_destroy();
		}
	}
	
#define Harpoon_wall
	if(speed > 0){
		move_contact_solid(direction, 16);
		instance_create(x, y, Dust);
		sound_play(sndBoltHitWall);
		speed = 0;
		typ   = 0;
		
		 // Deteriorate Rope if Both Harpoons Stuck:
		if(array_length(rope)){
			with(rope){
				if(
					harpoon_stuck
					&& array_find_index(obj.Harpoon, link1) >= 0
					&& array_find_index(obj.Harpoon, link2) >= 0
				){
					broken = -1;
				}
				harpoon_stuck = true;
			}
		}
		
		 // Not Roped:
		else{
			pickup = true;
			instance_destroy();
		}
	}
	
#define Harpoon_destroy
	 // Pickup:
	if(pickup){
		with(call(scr.obj_create, x, y, "HarpoonPickup")){
			motion_add(other.direction, other.speed / 2);
			image_yscale = other.image_yscale;
			image_angle  = other.image_angle;
			target       = other.target;
			ammo_type    = other.ammo_type;
		}
	}
	
	 // Stick in Object:
	else if(instance_exists(target)){
		var _harpoon = self;
		with(call(scr.obj_create, x, y, "HarpoonStick")){
			image_yscale = other.image_yscale;
			image_angle  = other.image_angle;
			target       = other.target;
			rope         = other.rope;
			
			 // Pull Speed:
			if("size" in target){
				pull_speed /= max(target.size, 0.5);
				if(
					(instance_is(target, prop) || target.team == 0)
					&& !instance_is(target, RadChest)
					&& !instance_is(target, Car)
					&& !instance_is(target, CarVenus)
					&& !instance_is(target, CarVenusFixed)
				){
					pull_speed = 0;
				}
			}
			
			 // Rope Stuff:
			with(rope){
				if(link1 == _harpoon) link1 = other;
				if(link2 == _harpoon) link2 = other;
				harpoon_stuck = true;
				
				 // Attached to Same Thing:
				var	_linkInst1 = (instance_is(link1, BoltStick) ? link1.target : link1),
					_linkInst2 = (instance_is(link2, BoltStick) ? link2.target : link2);
					
				if(_linkInst1 == _linkInst2){
					with([link1, link2]){
						pull_speed = 0;
					}
				}
				
				 // Deteriorate Rope if Doing Nothing:
				if(!array_length(instances_matching_gt([link1, link2], "pull_speed", 0))){
					broken = -1;
					if(instance_exists(link1) && instance_exists(link2)){
						length = point_distance(link1.x, link1.y, link2.x, link2.y);
					}
				}
			}
		}
	}
	
#define Harpoon_cleanup
	with(corpses) if(instance_exists(self)){
		depth = 1;
	}
	
#define Harpoon_rope(_link1, _link2)
	/*
		Links two instances together with a Harpoon rope, returns the rope LWO
	*/
	
	var _rope = {
		"link1"         : _link1,
		"link2"         : _link2,
		"length"        : 0,
		"harpoon_stuck" : false,
		"break_force"   : 0,
		"break_timer"   : 45 + random(15),
		"creator"       : noone,
		"broken"        : false
	}
	
	 // Add to List:
	if("ntte_harpoon_rope" not in GameCont){
		GameCont.ntte_harpoon_rope = [];
	}
	array_push(GameCont.ntte_harpoon_rope, _rope);
	
	 // Linked Harpoons:
	with([_link1, _link2]){
		if(array_find_index(obj.Harpoon, self) >= 0){
			array_push(rope, _rope);
			
			 // ??? Old code idk if important:
			if(!instance_exists(creator) && "creator" in self){
				_rope.creator = creator;
			}
		}
	}
	
	return _rope;
	
#define Harpoon_unrope(_rope)
	/*
		Destroys the given Harpoon rope connection
		Harpoon instances linked to the rope are turned into pickups
	*/
	
	with(_rope){
		broken = true;
		
		 // Remove From List:
		if("ntte_harpoon_rope" in GameCont){
			GameCont.ntte_harpoon_rope = call(scr.array_delete_value, GameCont.ntte_harpoon_rope, self);
		}
		
		 // Turn Harpoons Into Pickups:
		with([link1, link2]){
			if(instance_exists(self)){
				if(array_find_index(obj.Harpoon, self) >= 0){
					pickup = true;
				}
				else if(array_find_index(obj.HarpoonStick, self) >= 0){
					with(call(scr.obj_create, x, y, "HarpoonPickup")){
						image_yscale = other.image_yscale;
						image_angle  = other.image_angle;
						target       = other.target;
					}
					instance_destroy();
				}
			}
		}
	}
	
#define Harpoon_temerge_hit
	if(call(scr.projectile_can_temerge_hit, other) && other.my_health > damage){
		with(other){
			var	_maxDis = 96,
				_target = noone;
				
			 // Find Nearest Enemy in Line of Sight:
			with(instances_matching_ne(instances_matching_ne([hitme, chestprop], "team", other.team), "id", id)){
				var _dis = point_distance(x, y, other.x, other.y);
				if(_dis < _maxDis){
					if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
						_maxDis = _dis;
						_target = self;
					}
				}
			}
			
			 // Rope Enemies Together:
			if(_target != noone){
				if("ntte_harpoon_rope" in GameCont){
					with(GameCont.ntte_harpoon_rope){
						if((link1 == other && link2 == _target) || (link1 == _target && link2 == other)){
							_target = noone;
							break;
						}
					}
				}
				if(_target != noone){
					with(Harpoon_rope(self, _target)){
						length = _maxDis;
					}
				}
			}
		}
	}
	
	
#define HarpoonPickup_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = spr.Harpoon;
		image_index  = 1;
		spr_open     = spr.HarpoonOpen;
		spr_fade     = spr.HarpoonFade;
		
		 // Vars:
		mask_index = mskBigRad;
		friction   = 0.4;
		alarm0     = call(scr.pickup_alarm, 90 + random(30), 1/5);
		pull_spd   = 8;
		target     = noone;
		ammo_type  = type_bolt;
		
		 // Events:
		on_step = script_ref_create(HarpoonPickup_step);
		on_pull = script_ref_create(HarpoonPickup_pull);
		on_open = script_ref_create(HarpoonPickup_open);
		
		return self;
	}
	
#define HarpoonPickup_step
	 // Stuck in Target:
	if(instance_exists(target)){
		var	_odis = 16,
			_odir = image_angle;
			
		x = target.x + target.hspeed_raw - lengthdir_x(_odis, _odir);
		y = target.y + target.vspeed_raw - lengthdir_y(_odis, _odir);
		if("z" in target){
			y -= abs(target.z);
		}
		xprevious = x;
		yprevious = y;
		
		if(!target.visible){
			target = noone;
		}
	}
	
#define HarpoonPickup_pull
	if(instance_exists(target)){ // Stop Sticking
		if(place_meeting(x, y, Wall)){
			x         = target.x;
			y         = target.y;
			xprevious = x;
			yprevious = y;
		}
		target = noone;
	}
	return (speed <= 0);
	
#define HarpoonPickup_open
	var _type = ammo_type;
	
	with(instance_is(other, Player) ? other : Player){
		var _num = other.num * (1 + floor(typ_ammo[_type] / 10));
		
		 // Cool:
		if(_type == type_melee){
			if(reload > 0){
				reload -= 3;
			}
		}
		
		 // +1 Bolt Ammo:
		else{
			ammo[_type] = min(ammo[_type] + _num, typ_amax[_type]);
			
			 // Text:
			call(scr.pickup_text,
				typ_name[_type],
				((ammo[_type] < typ_amax[_type]) ? "add" : "max"),
				_num
			);
		}
	}
	
	
#define HarpoonStick_create(_x, _y)
	with(instance_create(_x, _y, BoltStick)){
		 // Visual:
		sprite_index = spr.Harpoon;
		image_index  = 0;
		
		 // Vars:
		pull_speed = 2;
		rope       = [];
		
		return self;
	}
	
	
#define NetNade_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.NetNade;
		image_speed  = 0.4;
		
		 // Vars:
		mask_index = mskBigRad;
		friction   = 0.4;
		creator    = noone;
		lasthit    = noone;
		damage     = 10;
		force      = 4;
		typ        = 1;
		
		 // Alarms:
		alarm0 = 60;
		alarm1 = 3;
		alarm2 = alarm0 - 15;
		
		 // Merged Weapons Support:
		temerge_on_fire    = script_ref_create(NetNade_temerge_fire);
		temerge_on_setup   = script_ref_create(NetNade_temerge_setup);
		temerge_on_hit     = script_ref_create(NetNade_temerge_hit);
		temerge_on_destroy = script_ref_create(NetNade_temerge_destroy);
		
		return self;
	}
	
#define NetNade_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Baseball:
	if(place_meeting(x, y, projectile)){
		var _inst = call(scr.instances_meeting_instance, self, [Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash]);
		if(array_length(_inst)) with(_inst){
			if(place_meeting(x, y, other)){
				event_perform(ev_collision, Grenade);
				if(!instance_exists(other)) exit;
			}
		}
	}
	
	 // Tryin a trail:
	if(speed > 0){
		with(instance_create(x, y, DiscTrail)){
			image_angle = other.direction;
			image_xscale = other.image_xscale * (other.speed / 16);
			image_yscale = other.image_yscale * 0.25;
			depth = -1;
		}
	}
	
#define NetNade_hit
	if(speed > 0 && projectile_canhit(other)){
		lasthit = other.id;
		projectile_hit(other, damage, force);
		instance_destroy();
	}
	
#define NetNade_wall
	instance_destroy();
	
#define NetNade_alrm0
	instance_destroy();
	
#define NetNade_alrm1
	friction = 0.8;
	
#define NetNade_alrm2
	sprite_index = spr.NetNadeBlink;
	
#define NetNade_destroy
	 // Effects:
	repeat(8) call(scr.fx, x, y, 1 + random(2), Dust);
	sound_play(sndUltraCrossbow);
	sound_play(sndFlakExplode);
	view_shake_at(x, y, 20);
	
	 // Break Walls:
	while(distance_to_object(Wall) < 32){
		with(instance_nearest(x - 8, y - 8, Wall)){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
	}
	
	 // Harpoon-Splosion:
	var	_num   = 10,
		_ang   = random(360),
		_dis   = 0,
		_spd   = 22,
		_link  = noone, // Latest Harpoon Created
		_first = noone; // First Harpoon Created
		
	for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
		_dis = ((_dis > 0) ? 0 : 8);
		
		var	_x   = x + lengthdir_x(_dis, _dir),
			_y   = y + lengthdir_y(_dis, _dir),
			_off = 0;
			
		 // Minor Homing on Nearest Enemy:
		with(call(scr.instance_nearest_array, 
			_x + lengthdir_x(3 * _spd, _dir),
			_y + lengthdir_y(3 * _spd, _dir),
			instances_matching_ne(instances_matching_ne(enemy, "team", team), "id", lasthit)
		)){
			_off = angle_difference(point_direction(other.x, other.y, x, y), _dir);
			if(abs(_off) >= (360 / _num) / 2){
				_off = 0;
			}
		}
		
		 // Harpoon:
		with(call(scr.projectile_create, _x, _y, "Harpoon", _dir + _off, _spd)){
			 // Explosion FX:
			with(instance_create(x, y, MeleeHitWall)){
				motion_add(other.direction, 1 + random(2));
				image_angle = direction + 180;
				image_speed = 0.6;
			}
			
			 // Link harpoons to each other:
			if(!instance_exists(_first)){
				_first = self;
			}
			if(instance_exists(other.lasthit)){
				Harpoon_rope(self, other.lasthit);
			}
			else{
				if(instance_exists(_link)){
					Harpoon_rope(self, _link);
				}
				_link = self;
			}
		}
	}
	if(instance_exists(_link)){
		Harpoon_rope(_first, _link);
	}
	
#define NetNade_temerge_fire(_at, _setupInfo)
	_setupInfo.ammo_type = weapon_get_type(_at.wep);
	
#define NetNade_temerge_setup(_instanceList, _setup)
	with(_instanceList){
		temerge_net_can_fire  = [true];
		temerge_net_ammo_type = _setup.ammo_type;
	}
	
#define NetNade_temerge_hit
	/*
		Net projectiles fire harpoons linked to enemies they collide with
	*/
	
	if(
		temerge_net_can_fire[0]
		&& projectile_canhit(other)
		&& other.my_health > 0
	){
		NetNade_temerge_destroy();
		temerge_net_can_fire[0] = false;
	}
	
#define NetNade_temerge_destroy
	/*
		Net projectiles release linked harpoons on destruction
	*/
	
	if(temerge_net_can_fire[0]){
		var _num = min(damage * 0.4 * ((force >= 3) ? 1 : 0.4), 120);
		
		_num = floor(_num) + chance(frac(_num), 1);
		
		if(_num > 0){
			var	_ang       = random(360),
				_spd       = 22,
				_hitTarget = ((self == other) ? noone : other);
				
			for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
				var _off = 0;
				
				if(instance_exists(_hitTarget)){
					 // Minor Homing on Nearest Enemy:
					with(call(scr.instance_nearest_array, 
						x + lengthdir_x(3 * _spd, _dir),
						y + lengthdir_y(3 * _spd, _dir),
						instances_matching_ne(instances_matching_ne(enemy, "team", team), "id", _hitTarget.id)
					)){
						if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
							_off = angle_difference(point_direction(other.x, other.y, x, y), _dir);
							if(abs(_off) >= (360 / _num) / 2){
								_off = 0;
							}
						}
					}
					
					 // Fire Harpoon:
					with(call(scr.projectile_create, x, y, "Harpoon", _dir + _off, _spd)){
						move_contact_solid(direction, 8);
						Harpoon_rope(self, _hitTarget);
						ammo_type = other.temerge_net_ammo_type;
						
						 // No Recursion:
						can_temerge = false;
					}
				}
				
				 // Effects:
				with(instance_create(x, y, MeleeHitWall)){
					motion_add(_dir + _off, random(2));
					image_angle  = direction + 180;
					image_speed  = 0.6;
					image_yscale = 2/3;
				}
			}
			
			 // Sound:
			if(instance_exists(_hitTarget)){
				sound_play_hit(((_num > 1) ? sndSuperSplinterGun : sndCrossbow), 0.2);
			}
			call(scr.sound_play_at, x, y, sndGrenadeRifle, 1.2 + orandom(0.1), (instance_exists(_hitTarget) ? 1 : 0.5));
			
			 // Effects:
			repeat(max(3, _num)){
				call(scr.fx, x, y, 1 + random(2), Dust);
			}
			view_shake_at(x, y, 2 * _num);
		}
	}
	
	
#define Palanking_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
		 // Visual:
		spr_bott        = spr.PalankingBott;
		spr_taun        = spr.PalankingTaunt;
		spr_call        = spr.PalankingCall;
		spr_idle        = spr.PalankingIdle;
		spr_walk        = spr.PalankingWalk;
		spr_hurt        = spr.PalankingHurt;
		spr_dead        = spr.PalankingDead;
		spr_burp        = spr.PalankingBurp;
		spr_fire        = spr.PalankingFire;
		spr_foam        = spr.PalankingFoam;
		spr_shadow_hold = shd64B; // Actually a good use for this shadow hell yeah
		spr_shadow      = mskNone;
		spr_shadow_y    = 24;
		hitid           = [spr_idle, "SEAL KING"];
		depth           = -3;
		
		 // Sound:
		snd_hurt = snd.PalankingHurt;
		snd_dead = snd.PalankingDead;
		snd_lowh = sndRocket;
		
		 // Vars:
		mask_index   = mskNone;
		mask_hold    = msk.Palanking;
		maxhealth    = call(scr.boss_hp, 300);
		raddrop      = 120;
		size         = 4;
		walk         = 0;
		walkspeed    = 0.8;
		maxspeed     = 2;
		ammo         = 0;
		canmelee     = 0;
		meleedamage  = 4;
		ground_smash = 0;
		gunangle     = random(360);
		direction    = gunangle;
		canwade      = false;
		active       = false;
		intro        = false;
		intro_pan    = 0;
		seal         = [];
		seal_x       = [];
		seal_y       = [];
		seal_max     = 4 + GameCont.loops;
		tauntdelay   = 40;
		phase        = -1;
		z            = 0;
		zspeed       = 0;
		zfriction    = 1;
		zgoal        = 0;
		corpse       = false;
		team         = 0;
		
		 // Alarms:
		alarm0 = -1;
		alarm1 = -1;
		alarm2 = -1;
		alarm3 = -1;
		
		 // For Sani's bosshudredux:
		bossname = "PALANKING";
		col      = c_red;
		
		return self;
	}

#define Palanking_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	if(alarm3_run) exit;
	
	 // Movement:
	if(z <= 0){
		walk = 0;
	}
	else if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Seals:
	var	_sealNum = array_length(instances_matching_ne(seal, "id")),
		_holdx   = seal_x,
		_holdy   = seal_y,
		_holding = [0, 0];
		
	for(var i = 0; i < array_length(seal); i++){
		if(instance_exists(seal[i])){
			var	_x = _holdx[i] + (1.5 * right),
				_y = _holdy[i];
				
			with(seal[i]){
				if("hold" in self && hold){
					walk = 0;
					if(sprite_index == spr_spwn || "hold_x" not in self){
						hold_x = _x;
						hold_y = _y;
					}
					else{
						_holding[_holdx[i] > 0]++;
						if(_sealNum > 1){
							if(hold_x != _x){
								hspeed = random(clamp(_x - hold_x, -maxspeed, maxspeed));
								hold_x += hspeed;
							}
							if(hold_y != _y){
								vspeed = random(clamp(_y - hold_y, -maxspeed, maxspeed));
								hold_y += vspeed;
							}
						}
					}
				}
				else{
					hold_x = x - other.x;
					hold_y = y - other.y;
					motion_add(point_direction(x, y, other.x + _x, other.y + _y) + orandom(10), walkspeed);
					if(distance_to_point(other.x + _x, other.y + _y) < 8 || distance_to_object(other) < 8){
						hold = true;
					}
				}
			}
		}
		else if(seal[i] != noone){
			seal[i] = noone;
			_sealNum--;
		}
	}
	
	 // Fight Time:
	if(active){
		 // Seals Run Over to Lift:
		if(_sealNum < seal_max){
			with(PalankingSeal){
				if(array_find_index(other.seal, self) < 0){
					seal_add(other, self);
					break;
				}
			}
		}
		
		 // Not Enough Seals Holding:
		if(_holding[0] + _holding[1] <= 1){
			if(zgoal != 0){
				zgoal = 0;
				zspeed = 6;
			}
		}
		else{
			 // Make Sure Seals on Both Sides:
			for(var i = 0; i < 2; i++){
				if(_holding[i] <= 0){
					for(var j = 0; j < array_length(seal); j++){
						if(seal[j] != noone && ((j + !i) % 2)){
							if(chance(1, 3)){
								var _s = seal[j];
								seal[j] = noone;
								
								var _o = (2 * !i) - 1;
								if(j + _o < 0){
									_o =  1;
								}
								if(j + _o >= array_length(seal)){
									_o = -1;
								}
								seal[j + _o] = _s;
							}
						}
					}
				}
			}
			
			 // Lifted Up:
			if(zgoal == 0){
				zgoal = 12;
			}
		}
		
		 // Constant Movement:
		if(instance_exists(Floor)){
			if(distance_to_object(Floor) > 0 && zspeed == 0){
				var	_f = instance_nearest(x - 16, y - 16, Floor),
					_d = point_direction(x, y, _f.x, _f.y);
					
				x += lengthdir_x(1, _d);
				y += lengthdir_y(1, _d);
			}
		}
	}
	
	 // Pre-Intro Stuff:
	else{
		my_health = maxhealth;
		x = xstart;
		y = ystart;
		
		 // Begin Intro:
		if(alarm0 < 0){
			if(instance_exists(Player)){
				if(instance_number(enemy) <= (array_length(instances_matching(enemy, "intro", false)) + array_length(instances_matching(PalankingSeal, "type", seal_none)) + instance_number(Van))){
					if(!instance_exists(becomenemy)){
						alarm0 = 30;
						phase++;
					}
				}
			}
		}
	}
	
	 // Pan Intro Camera:
	var _pan = false;
	if(intro_pan > 0){
		intro_pan -= current_time_scale;
		
		 // Just in Case:
		if(alarm0 > 0 && intro_pan < alarm0){
			intro_pan = alarm0;
		}
		if(instance_number(enemy) <= (array_length(instances_matching(enemy, "intro", false)) + array_length(PalankingSeal) + instance_number(Van))){
			_pan = true;
			
			 // Delay Popo:
			if(instance_exists(IDPDSpawn) || instance_exists(VanSpawn) || instance_exists(WantRevivePopoFreak)){
				if(instance_exists(Player) && current_frame_active){
					var _inst = instances_matching_gt([IDPDSpawn, VanSpawn, WantRevivePopoFreak], "alarm0", 0);
					if(array_length(_inst)) with(_inst){
						alarm0++;
					}
				}
			}
		}
		
		 // Attract Pickups:
		portal_pickups();
		
		 // Hold Off Seals:
		with(PalankingSeal){
			attack_delay = 15 + random(30);
		}
	}
	for(var i = 0; i < maxp; i++){
		if(player_is_active(i)){
			if(_pan){
				if("creator" not in view_object[i] || view_object[i].creator != self){
					view_object[i] = self;
				}
				view_pan_factor[i] = 10000;
			}
			else if(view_object[i] == self || ("creator" in view_object[i] && view_object[i].creator == self)){
				view_object[i]     = noone;
				view_pan_factor[i] = null;
			}
		}
	}
	
	 // Z-Axis:
	z += zspeed * current_time_scale;
	if(z <= zgoal){
		if(z < zgoal && zspeed == 0){
			if(zgoal <= 0) z = zgoal;
			else zspeed = (zgoal - z) / 2;
		}
		if(zspeed <= 0){
			 // Held in Air:
			if(zgoal > 0){
				z = zgoal + zspeed;
				zspeed *= 0.8;
			}
			
			 // Ground Landing:
			else if(zspeed < 0){
				 // Ground Smash:
				var _lastMask = mask_index;
				mask_index = mask_hold;
				if(zspeed < -5 && place_meeting(x, y, Floor)){
					alarm2 = 1;
					sound_play_hit_big(sndBigBanditMeleeHit, 0.3);
					
					 // Ouch:
					projectile_hit_raw(self, 40, 2);
				}
				mask_index = _lastMask;
				
				zspeed *= -0.2;
			}
			
			if(abs(zspeed) < zfriction){
				zspeed = 0;
				z = zgoal;
			}
		}
	}
	else zspeed -= zfriction * current_time_scale;
	
	 // Death Taunt:
	if(tauntdelay > 0 && !instance_exists(Player)){
		tauntdelay -= current_time_scale;
		if(tauntdelay <= 0){
			image_index  = 0;
			sprite_index = spr_taun;
			sound_play(snd.PalankingTaunt);
		}
	}
	
	 // Animate:
	if(sprite_index != spr_burp){
		if(sprite_index != spr_call && sprite_index != spr_taun && sprite_index != spr_fire){
			sprite_index = enemy_sprite;
		}
		else if(anim_end){
			sprite_index = spr_idle;
		}
	}
	else if(anim_end){
		image_index = 1;
	}
	
	 // Smack Smack:
	if(sprite_index == spr_call){
		var _img = floor(image_index);
		if(image_index < _img + image_speed_raw && (_img == 4 || _img == 7)){
			sound_play_pitchvol(sndHitRock, 0.8 + orandom(0.2), 0.6);
		}
	}
	
	 // Hitbox/Shadow:
	if(z <= 4){
		mask_index = mask_hold;
		if(spr_shadow != mskNone){
			spr_shadow_hold = spr_shadow;
			spr_shadow = mskNone;
		}
	}
	else{
		spr_shadow = spr_shadow_hold;
		if(mask_index != mskNone){
			mask_hold = mask_index;
			mask_index = mskNone
		}
		
		 // Plant Snare:
		mask_index = mask_hold;
		if(place_meeting(x, y, Tangle)){
			x -= (hspeed * 0.5);
			y -= (vspeed * 0.5);
		}
		mask_index = mskNone;
	}
	
#define Palanking_end_step
	var _inst = instances_matching_ne(instances_matching_ne(instances_matching(seal, "hold", true), "hold_x", null), "hold_y", null);
	if(array_length(_inst)){
		with(_inst){
			if(mask_index != mskNone){
				x         = other.x + hold_x;
				y         = other.y + hold_y;
				xprevious = x;
				yprevious = y;
				hspeed    = other.hspeed;
				vspeed    = other.vspeed;
				depth     = other.depth - (hold_y > 24 && hold);
			}
			else hold = false;
		}
	}

#define Palanking_draw
	var _hurt = (
		(nexthurt >= current_frame + 4 && active) ||
		(sprite_index == spr_hurt && image_index < 1)
	);
	
	 // Palanquin Bottom:
	if(z > 4 || place_meeting(x, y, Floor)){
		if(_hurt) draw_set_fog(true, image_blend, 0, 0);
		draw_sprite_ext(spr_bott, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
		if(_hurt) draw_set_fog(false, 0, 0, 0);
	}
	
	 // Self:
	_hurt &= (sprite_index != spr_hurt);
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
#define Palanking_alrm0
	if(intro_pan <= 0){
		alarm0 = 60;
		alarm1 = 20;
		
		 // Enable Cinematic:
		intro_pan = 10 + alarm0;
		
		 // "Safety":
		with(Player){
			instance_create(x, y, PortalShock);
		}
	}
	else{
		switch(phase){
			
			case 0: // Wave of Seals
				
				var	_delay  = 20,
					_groups = 5;
					
				for(var _d = 0; _d < 360; _d += (360 / _groups)){
					var	_x = 10016,
						_y = 10016;
						
					with(seal_wave(_x, _y, point_direction(_x, _y, x, y) + _d, _delay)){
						if(_d == 0){
							other.intro_pan += seal_delay + (6 * seal_num);
							for(var i = 0; i < maxp; i++){
								if(player_is_active(i)){
									view_object[i] = self;
								}
							}
						}
					}
					
					_delay += 15 + random(15);
				}
				
				break;
				
			case 1:
			case 2:
			case 3:
			case 4: // Seal Army Arrives
				
				 // Initial Seal Bros:
				if(phase == 1){
					var	_ang   = random(360),
						_odis  = 32,
						_odir  = point_direction(10016, 10016, x, y),
						_delay = 30;
						
					for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 3)){
						var _dis = 64 + random(16);
						
						seal_wave(
							x + lengthdir_x(_odis, _odir) + lengthdir_x(_dis, _dir),
							y + lengthdir_y(_odis, _odir) + lengthdir_y(_dis, _dir),
							_dir + 180,
							_delay
						);
						
						_delay += 10 + random(10);
					}
				}
				
				 // Seal Plop:
				//repeat(4) instance_create(other.x + x, other.y + y, Sweat);
				sound_play_pitch(choose(sndOasisHurt, sndOasisMelee, sndOasisShoot, sndOasisChest, sndOasisCrabAttack), 0.8 + random(0.4));
				
				 // Palanquin Holders:
				var _seal = call(scr.obj_create, x, y, "Seal");
				seal_add(self, _seal);
				with(_seal){
					hold    = true;
					creator = other;
					scared  = true;
				}
				
				 // Continue:
				phase++;
				alarm0 = ((phase < 4) ? 8 : 16);
				
				break;
				
			case 5: // Lift Palanking
				
				if(!active){
					active = true;
					team   = 1;
					zgoal  = 12;
					alarm0 = 30;
				}
				else{
					alarm1 = 60 + irandom(40);
					
					 // Boss Intro:
					if(!intro){
						intro = true;
						call(scr.boss_intro, "Palanking");
						sound_play(sndBigDogIntro);
					}
					
					 // Walk Towards Player:
					if(enemy_target(x, y)){
						enemy_look(target_direction);
						enemy_walk(gunangle, 90);
					}
				}
				
				break;
				
		}
		
		 // Pan:
		if(phase > 0){
			if(intro_pan <= 0){
				intro_pan = 10;
			}
			intro_pan += alarm0;
		}
	}
	
#define Palanking_alrm1
	if(intro){
		alarm1 = 40 + random(20);
		
		if(enemy_target(x, y) && target_visible){
			enemy_look(target_direction);
			enemy_walk(gunangle + orandom(30), 60);
			
			 // Kingly Slap:
			if(
				(target_distance < 80 && array_length(PalankingSeal) > 2)
				||
				("reload" in target && target.reload > 0 && chance(1, 3))
			){
				alarm1 = 60 + random(20);
				alarm3 = 6;
				
				image_index = 0;
				sprite_index = spr_fire;
				sound_play(snd.PalankingSwipe);
				instance_create(x, y - z, AssassinNotice);
			}
			
			 // Call for Seals:
			else if(
				array_length(PalankingSeal) <= seal_max * 4
				&& chance(1 + (z <= 0), 2)
				&& chance(1, array_length(PalankingSeal) / 2)
			){
				alarm1 = 30 + random(10);
				
				image_index  = 0;
				sprite_index = spr_call;
				sound_play(snd.PalankingCall);
				
				seal_wave(x, y, gunangle + orandom(30),       20 + random(20));
				seal_wave(x, y, gunangle + orandom(60) + 180, 20 + random(20));
			}
		}
	}
	
	 // Initial Call for Seals:
	else{
		alarm1 = -1;
		
		 // Call:
		if(sprite_index != spr_taun){
			image_index = 0;
			sprite_index = spr_call;
			sound_play(snd.PalankingCall);
		}
	}
	
#define Palanking_alrm2
	var	m = 2,
		_x = x,
		_y = y + 32;
		
	if(ground_smash++ < m){
		alarm2 = 5;
		
		 // Effects:
		view_shake_at(x, y, 40 / ground_smash);
		sound_play_pitch(sndOasisExplosion, 1.6 + random(0.4));
		sound_play_pitch(sndWallBreakBrick, 0.6 + random(0.2));
		
		var _dis = (ground_smash * 24);
		for(var _ang = 0; _ang < 360; _ang += (360 / 16)){
			 // Ground Smash Slash:
			with(call(scr.projectile_create,
				_x + lengthdir_x(_dis,         _ang),
				_y + lengthdir_y(_dis * (2/3), _ang) - 4,
				"PalankingSlashGround",
				_ang,
				1
			)){
				team = -1;
			}
			
			 // Effects:
			if(chance(1, 4)){
				var _off = 16;
				with(instance_create(_x + lengthdir_x(_dis + _off, _ang), _y + lengthdir_y((_dis + _off) * (2/3), _ang), MeleeHitWall)){
					motion_add(90 - (30 * dcos(_ang)), 1 + random(2));
					image_angle = direction + 180;
					image_speed = random_range(0.3, 0.6);
				}
			}
			repeat(irandom(2)){
				with(instance_create(_x + orandom(8) + lengthdir_x(_dis, _ang), _y - random(12) + lengthdir_y(_dis, _ang), Dust)){
					motion_add(_ang, random(5));
				}
			}
		}
		
		 // Lose sealboys:
		for(var i = 0; i < array_length(seal); i++){
			seal[i] = noone;
		}
	}
	else ground_smash = 0;
	
#define Palanking_alrm3
	 // Slappin:
	call(scr.projectile_create, x, y + 16 - z, "PalankingSlash", gunangle, 8);
	motion_add(gunangle, 4);
	
	 // Effects:
	sound_play(sndHammer);
	
#define Palanking_hurt(_damage, _force, _direction)
	nexthurt = current_frame + 6; // I-Frames
	
	if(active){
		my_health -= _damage;
		motion_add(_direction, _force)
		sound_play_hit(snd_hurt, 0.3);
		
		 // Hurt Sprite:
		if(sprite_index != spr_call && sprite_index != spr_burp && sprite_index != spr_fire){
			sprite_index = spr_hurt;
			image_index = 0;
		}
	}
	
	 // Laugh:
	else if(sprite_index == spr_idle && point_seen_ext(x, y, 16, 16, -1)){
		sound_play(snd.PalankingTaunt);
		sprite_index = spr_taun;
		image_index = 0;
		
		 // Sound:
		sound_play_hit(sndHitWall, 0.3);
	}
	
	 // Half HP:
	var _half = maxhealth / 2;
	if(my_health <= _half && my_health + _damage > _half){
		if(snd_lowh == sndRocket){
			sound_play_pitch(snd_lowh, 0.5);
		}
		else sound_play(snd_lowh);
		
		 // Extra FX:
		view_shake_at(x, y, 30);
		repeat(5){
			instance_create(x, y - z + 16, Debris);
		}
	}
	
	 // Effects:
	if(instance_exists(other) && instance_is(other, projectile)){
		with(instance_create(other.x, other.y, Dust)){
			coast_water = 1;
			if(y > other.y + 12){
				depth = other.depth - 1;
			}
		}
		if(chance(other.damage, 8)) with(other){
			sound_play_hit(sndHitRock, 0.3);
			with(instance_create(x, y, Debris)){
				motion_set(_direction + 180 + orandom(other.force * 4), 2 + random(other.force / 2));
			}
		}
	}
	
#define Palanking_death
	if(raddrop <= 0){
		raddrop = 40;
	}
	
	 // Epic Death:
	with(call(scr.obj_create, x, y, "PalankingDie")){
		spr_dead     = other.spr_dead;
		sprite_index = other.spr_hurt;
		image_xscale = other.image_xscale * other.right;
		mask_index   = other.mask_index;
		snd_dead     = other.snd_dead;
		raddrop      = other.raddrop;
		size         = other.size;
		z            = other.z;
		speed        = min(other.speed, other.maxspeed);
		direction    = other.direction;
	}
	sound_play_pitchvol(snd.PalankingSwipe, 1, 4);
	snd_dead = -1;
	raddrop  = 0;
	
	 // Boss Win Music:
	with(MusCont){
		alarm_set(1, 1);
	}
	
#macro PalankingSeal instances_matching_ne(call(scr.array_combine, obj.Seal, obj.SealHeavy), "id")

#define seal_wave(_xstart, _ystart, _dir, _delay)
	/*
		Spawns a group of seals in the nearby ocean
	*/
	
	with(call(scr.obj_create, _xstart, _ystart, "SealWave")){
		direction  = _dir;
		creator    = other;
		seal_num   = other.seal_max;
		seal_delay = _delay;
		
		if(other.intro_pan <= 0){
			seal_alert = true;
		}
		
		return self;
	}
	
	return noone;
	
#define seal_add(_palanking, _inst)
	with(_palanking){
		 // Generate Hold Positions:
		if(array_length(seal) != seal_max){
			seal = array_create(seal_max, noone);
			
			 // Manual Placement:
			if(seal_max <= 4){
				seal_x = [33.5, -33.5, 30.5, -30.5];
				seal_y = [16, 16, 28, 28];
			}
			
			 // Auto-Placement:
			else{
				seal_x = [];
				var o = 33.5;
				for(var i = 0; i < seal_max; i++){
					var a = ((floor(i / 2) + 1) * (180 / (ceil(seal_max / 2) + 1))) - 90;
					seal_x[i] = lengthdir_x(o, a)
					seal_y[i] = 16 + (lengthdir_y(o, a) / 2);
					o *= -1;
				}
			}
		}
		
		 // Add Seal:
		var p = max(array_find_index(seal, noone), 0);
		seal[p] = _inst;
	}
	
	
#define PalankingDie_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.PalankingHurt;
		spr_dead     = spr.PalankingDead;
		image_speed  = 0.4;
		image_alpha  = 0; // Cause customobjects draw themselves even if you have a custom draw event >:(
		depth        = -3;
		hitid        = [spr_dead, "PALANKING"];
		
		 // Vars:
		friction  = 0.4
		team      = -1;
		size      = 3;
		z         = 0;
		zspeed    = 9;
		zfriction = 1;
		raddrop   = 80;
		snd_dead  = snd.PalankingDead;
		
		return self;
	}
	
#define PalankingDie_step
	z += zspeed * current_time_scale;
	zspeed -= zfriction * current_time_scale;
	if(z <= 0) instance_destroy();
	
#define PalankingDie_draw
	var h = (image_index < 1);
	if(h) draw_set_fog(1, image_blend, 0, 0);
	draw_sprite_ext(spr.PalankingBott, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, 1);
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, 1);
	if(h) draw_set_fog(0, 0, 0, 0);
	
#define PalankingDie_destroy
	sound_play_pitchvol(sndWallBreakRock, 0.8, 0.8);
	sound_play_pitchvol(sndExplosionL, 0.5, 0.6);
	sound_play_hit(sndBigBanditMeleeHit, 0.3);
	sound_play(snd_dead);
	
	view_shake_at(x, y, 30);
	
	 // Palanquin Chunks & Debris:
	var	_spr = spr.PalankingChunk,
		_ang = random(360);
		
	for(var i = 0; i < sprite_get_number(_spr); i++){
		with(instance_create(x, y + 16, Debris)){
			motion_set(_ang + orandom(30), 2 + random(10));
			sprite_index = _spr;
			image_index = i;
			alarm0 += random(240);
		}
		repeat(irandom(2)) instance_create(x, y + 16, Debris);
		
		_ang += (360 / sprite_get_number(_spr));
	}
	
	 // Fricken DEAD:
	with(call(scr.corpse_drop, self, 0, 0)){
		depth = 0;
	}
	
	 // Pickups:
	repeat(3) pickup_drop(50, 0);
	call(scr.rad_drop, x, y + 16, raddrop, direction, speed);
	
	 // Smashin':
	var	_x   = x,
		_y   = y + 24,
		_dis = 24;
		
	for(var _ang = 0; _ang < 360; _ang += (360 / 16)){
		call(scr.projectile_create,
			_x + lengthdir_x(_dis,         _ang),
			_y + lengthdir_y(_dis * (2/3), _ang) - 4,
			"PalankingSlashGround",
			_ang,
			3 + random(1)
		);
		
		 // Effects:
		if(chance(1, 4)){
			var _off = 16;
			with(instance_create(_x + lengthdir_x(_dis + _off, _ang), _y + lengthdir_y((_dis + _off) * (2/3), _ang), MeleeHitWall)){
				motion_add(90 - (30 * dcos(_ang)), 1 + random(2));
				image_angle = direction + 180;
				image_speed = random_range(0.3, 0.6);
			}
		}
		repeat(irandom(2)){
			with(instance_create(_x + orandom(8) + lengthdir_x(_dis, _ang), _y - random(12) + lengthdir_y(_dis, _ang), Dust)){
				motion_add(_ang, random(5));
			}
		}
	}
	
	
#define PalankingSlash_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.PalankingSlash;
		image_speed  = 0.3;
		depth        = -4;
		
		 // Vars:
		mask_index = mskSlash;
		friction   = 0.5;
		damage     = 3;
		force      = 8;
		
		return self;
	}
	
#define PalankingSlash_step
	 // Launch Pickups:
	if(place_meeting(x, y, Pickup)){
		with(call(scr.instances_meeting_instance, self, instances_matching(Pickup, "mask_index", mskPickup))){
			if(place_meeting(x, y, other)){
				var _s = other;
				with(call(scr.obj_create, x, y, "PalankingToss")){
					direction  = angle_lerp(_s.direction, point_direction(_s.x, _s.y, x, y), 1/3);
					speed      = 4;
					zspeed    *= 2/3;
					creator    = other;
					depth      = other.depth;
					mask_index = other.mask_index;
					if("spr_shadow_y" in other){
						spr_shadow_y = other.spr_shadow_y;
					}
				}
				mask_index = mskNone;
			}
		}
	}
	
#define PalankingSlash_hit
	if(projectile_canhit_melee(other)){
		projectile_hit_push(other, damage, force);
		
		 // Mega Smak:
		if(
			instance_exists(other)
			&& other.my_health > 0
			&& !instance_is(other, prop)
			&& (instance_is(other, Player) || other.size <= 1)
		){
			var _inst = other;
			with(call(scr.obj_create, _inst.x, _inst.y, "PalankingToss")){
				direction    = angle_lerp(other.direction, point_direction(other.x, other.y, _inst.x, _inst.y), 1/3);
				speed        = 4;
				creator      = _inst;
				depth        = _inst.depth;
				mask_index   = _inst.mask_index;
				spr_shadow_y = _inst.spr_shadow_y;
			}
			with(other){
				if(instance_is(self, Player)){
					smoke = 6 + random(6);
				}
				mask_index = mskNone;
			}
			sound_play_pitchvol(sndHammerHeadEnd, 0.8, 0.5);
		}
	}
	
#define PalankingSlash_projectile
	if(instance_exists(self)){
		with(other){
			if(typ == 1 || typ == 2){
				 // Deflect (No Team Change):
				if(typ == 1 && other.candeflect){
					direction   = other.direction;
					image_angle = direction;
					
					 // Effects:
					with(instance_create(x, y, Deflect)){
						image_angle = other.image_angle;
					}
				}
				
				 // Destroy:
				else instance_destroy();
			}
		}
	}
	
	
#define PalankingSlashGround_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "PalankingSlash")){
		 // Visual:
		sprite_index = spr.GroundSlash;
		image_speed = 0.5;
		depth = 0;
		
		 // Vars:
		mask_index = -1;
		
		return self;
	}
	
	
#define PalankingStatue_create(_x, _y)
	/*
		A statue of the Big Seal himself, spawns on Frozen City's Seal Plaza event
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		var _phase = 0;
		
		 // Visual:
		spr_idle     = spr.PalankingStatueIdle[_phase];
		spr_hurt     = spr.PalankingStatueHurt[_phase];
		spr_dead     = spr.PalankingStatueDead;
		sprite_index = spr_idle;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndPillarBreak;
		
		 // Vars:
		mask_index = sprPortalClear;
		maxhealth  = 240;
		team       = 1;
		size       = 4;
		phase      = _phase;
		
		return self;
	}
	
#define PalankingStatue_step
	 // Change Phase:
	if(sprite_index == spr_hurt){
		var	_mPhase = 4,
			_cPhase = floor(_mPhase - ((my_health / maxhealth) * _mPhase));
			
		while(phase < _cPhase){
			phase++;
			
			 // Resprite:
			spr_idle     = spr.PalankingStatueIdle[phase];
			spr_hurt     = spr.PalankingStatueHurt[phase];
			sprite_index = spr_hurt;
			
			 // Chunks:
			repeat(3){
				PalankingStatue_chunk(x, y, random(360), random_range(2, 5), random_range(4, 5));
			}
			
			 // Sound:
			call(scr.sound_play_at, x, y, snd.PalankingHurt, 0.7 + random(0.2), 0.5);
		}
	}

#define PalankingStatue_death
	 // Boomba:
	team = 2;
	var _dis = 16;
	for(var _dir = 0; _dir < 360; _dir += 90){
		call(scr.projectile_create,
			x + lengthdir_x(_dis, _dir) + orandom(32),
			y + lengthdir_y(_dis, _dir) + orandom(32),
			"BubbleExplosion"
		);
		call(scr.projectile_create, x, y, "HyperBubble", _dir, 4);
	}
	
	 // Pickups:
	for(var i = 0; i < 3; i++){
		pickup_drop(100, 10, i);
	}
	
	 // Sound:
	call(scr.sound_play_at, x, y, snd.PalankingDead, 0.7 + random(0.2), 0.5);
	
	 // Effects:
	repeat(5){
		PalankingStatue_chunk(x, y, random(360), random_range(1, 3), random_range(6, 10));
	}
	for(var i = 0; i < maxp; i++){
		var	_x = view_xview[i] + (game_width  / 2),
			_y = view_yview[i] + (game_height / 2);
			
		call(scr.view_shift, 
			i,
			point_direction(_x, _y, x, y),
			point_distance(_x, _y, x, y) * 1.5
		);
	}
	sleep(100);
	
#define PalankingStatue_chunk(_x, _y, _dir, _spd, _zspd)
	with(call(scr.fx, _x, _y, [_dir, _spd], ScrapBossCorpse)){
		sprite_index = spr.PalankingStatueChunk;
		image_index  = irandom(image_number - 1);
		friction	 = 0.2;
		
		 // Z-ify:
		with(call(scr.obj_create, _x, _y, "BackpackPickup")){
			target    = other;
			zfriction = 0.6;
			zspeed    = _zspd;
			speed     = _spd;
			with(self){
				event_perform(ev_step, ev_step_end);
			}
		}
		
		return self;
	}
	
	
#define PalankingToss_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		direction = random(360);
		friction  = 0.1;
		creator   = noone;
		z         = 0;
		zspeed    = 8;
		zfriction = 0.5;
		explo     = 0;
		team      = -1;
		
		 // Saved Vars:
		depth        = -2;
		mask_index   = mskPlayer;
		spr_shadow_y = 0;
		
		return self;
	}
	
#define PalankingToss_end_step
	z += zspeed * current_time_scale;
	zspeed -= zfriction * current_time_scale;
	
	if(instance_exists(creator) && (z > 0 || zspeed > 0)){
		if(instance_is(creator, Player)){
			hspeed += (creator.hspeed / 10) * current_time_scale;
			vspeed += (creator.vspeed / 10) * current_time_scale;
		}
		
		speed = clamp(speed, 2, 6);
		
		with(creator){
			x = other.x;
			y = other.y - other.z;
			mask_index = mskNone;
			depth = -9;
			if(instance_is(self, enemy)){
				canfly = true;
			}
			
			 // Shadow:
			if("spr_shadow_y" in self){
				spr_shadow_y = other.spr_shadow_y + other.z;
			}
			
			 // Aerodynamic:
			var _ang = point_direction(0, 0, other.hspeed, -other.zspeed) - 90;
			if("angle" in self) angle = _ang;
			else image_angle = _ang;
			
			 // Trail:
			if(current_frame_active && instance_is(self, Player)){
				with(instance_create(x + orandom(4), y + orandom(4), Dust)){
					coast_water = false;
					depth = other.depth;
				}
			}
		}
	}
	else{
		script_ref_call(on_cleanup);
		on_cleanup = [];
		
		with(creator){
			 // Damage:
			if(instance_is(self, hitme) && (place_meeting(x, y, Floor) || GameCont.area != "coast")){
				with(other){
					projectile_hit(other, 1);
				}
			}
			
			 // On Walls:
			if(!place_meeting(x, y, Floor) || place_meeting(x, y, Wall)){
				if(!place_meeting(x, y, Floor)){
					with(call(scr.instance_nearest_bbox, x, y, Floor)){
						if(collision_line(other.x, other.y, bbox_center_x, bbox_center_y, Wall, false, false)){
							with(other){
								call(scr.top_create, x, y, self, 0, 0);
							}
						}
					}
				}
				instance_create(x, y, PortalClear);
			}
		}
		
		 // Explosion (Salamander Pet):
		if(explo > 0){
			with(instance_create(x, y, Explosion)){
				team = other.team;
				hitid = 55;
				
				 // Flame:
				for(var i = 0; i < 12 * other.explo; i++){
				    with(instance_create(x, y, Flame)){
				        motion_add(random(360), (i / 6) + random_range(1.5, 2.5));
				        hitid = other.hitid;
				        team  = other.team;
				        depth = other.depth - 1;
				    }
				}
			}
			
			 // Effects:
			sound_play_hit_big(sndFlameCannonEnd, 0.3);
			sound_play_hit(sndExplosion, 0.1);
			sleep(40);
		}
		
		 // Effects:
		repeat(5 + variable_instance_get(creator, "size", 0)){
			with(instance_create(x, y, Dust)){
				motion_add(random(360), 3);
				motion_add(other.direction, 1);
			}
		}
		
		instance_destroy();
	}
	
#define PalankingToss_cleanup
	 // Reset Vars:
	with(creator){
		mask_index = other.mask_index;
		depth = other.depth;
		if("spr_shadow_y" in self) spr_shadow_y = other.spr_shadow_y;
		if("angle" in self) angle = 0;
		else image_angle = 0;
		if(instance_is(self, enemy) && place_meeting(x, y, Floor)){
			canfly = false;
		}
	}
	
	
#define Palm_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle   = spr.PalmIdle;
		spr_hurt   = spr.PalmHurt;
		spr_dead   = spr.PalmDead;
		spr_shadow = -1;
		depth      = -7;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = sndHitPlant;
		
		 // Vars:
		mask_index = mskStreetLight;
		maxhealth  = 30;
		my_health  = maxhealth;
		size       = 2;
		target     = noone;
		
		 // Fortify:
		if(chance(1, 8)){
			 // Visual:
			spr_idle = spr.PalmFortIdle;
			spr_hurt = spr.PalmFortHurt;
			depth    = -4;
			
			 // Sound:
			snd_dead = sndGeneratorBreak;
			
			 // Bro:
			target = call(scr.obj_create, x, y, "Diver");
			with(target){
				depth      = other.depth - 1;
				mask_index = mskNone;
				canfly     = true;
				palm       = other;
				
				 // Become Tree:
				with(palm){
					team       = other.team;
					maxhealth += other.maxhealth;
					my_health += other.my_health;
				}
			}
			
			 // Clear Walls:
			instance_create(x, y - 24, PortalClear);
		}
		
		return self;
	}
	
#define Palm_step
	 // Hold Bro:
	if(instance_exists(target)){
		with(target){
			x         = other.x;
			y         = other.y - 46;
			xprevious = x;
			yprevious = y;
			speed     = 0;
			walk      = 0;
			if(sprite_index == spr_walk){
				sprite_index = spr_idle;
			}
		}
	}

#define Palm_death
	 // Fall to Death:
	with(target){
		mask_index = -1;
		my_health  = 0;
		vspeed     = 5;
		motion_add(other.direction, clamp(-other.my_health / 4, 0, 6));
	}
	
	 // Leaves:
	repeat(15){
		with(call(scr.fx, 
			[x,      15],
			[y - 30, 10],
			[270,     2],
			Feather
		)){
			sprite_index = sprLeaf;
			image_yscale = random_range(1, 3);
			motion_add(
				point_direction(other.x, other.y, x, y),
				1 + random(1)
			);
		}
	}


#define Pelican_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)) {
		 // Visual:
		spr_idle     = spr.PelicanIdle;
		spr_walk     = spr.PelicanWalk;
		spr_hurt     = spr.PelicanHurt;
		spr_dead     = spr.PelicanDead;
		spr_chrg     = spr.PelicanChrg;
		spr_weap     = spr.PelicanHammer;
		spr_shadow   = shd32;
		spr_shadow_y = 6;
		hitid        = [spr_idle, "PELICAN"];
		mask_index   = mskRhinoFreak;
		depth        = -2;
		
		 // Sound:
		snd_hurt = sndGatorHit;
		snd_dead = sndGatorDie;
		
		 // Vars:
		maxhealth   = 45;
		raddrop     = 20;
		size        = 2;
		walk        = 0;
		walkspeed   = 0.6;
		maxspeed    = 3;
		dash        = 0;
		dash_factor = 1.25;
		chrg_time   = 24; // 0.8 Seconds
		gunangle    = random(360);
		direction   = gunangle;
		wepangle    = choose(-140, 140);
		
		 // Alarms:
		alarm1 = 30 + irandom(60);
		
		return self;
	}
	
#define Pelican_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Dash:
	if(dash > 0){
		dash -= current_time_scale;
		motion_add_ct(direction, dash * dash_factor);
		if(sprite_index != spr_hurt){
			sprite_index = ((dash > 0) ? spr_chrg : spr_walk);
		}
		
		 // Dusty:
		if(current_frame_active){
			instance_create(x + orandom(3), y + random(6), Dust);
			with(instance_create(x + orandom(3), y + random(6), Dust)){
				motion_add(other.direction + orandom(45), (4 + random(1)) * other.dash_factor);
			}
		}
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	
#define Pelican_draw
	var	_charge = max(alarm2, 0),
		_angOff = sign(wepangle) * (60 * (_charge / chrg_time));
		
	if(gunangle >  180) draw_self_enemy();
	call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, wepangle - _angOff, wkick, 1, image_blend, image_alpha);
	if(gunangle <= 180) draw_self_enemy();
	
#define Pelican_alrm1
	alarm1 = 40 + random(20); // 1-2 Seconds
	
	 // Flash (About to attack):
	if(alarm2 >= 0){
		var	_dis = 18,
			_ang = gunangle + wepangle;
			
		with(instance_create(x + lengthdir_x(_dis, _ang), y + lengthdir_y(_dis, _ang), ThrowHit)){
			image_speed = 0.5;
			depth = -3;
		}
	}
	
	 // Aggroed:
	if(
		enemy_target(x, y)
		&& target_distance < 320
		&& target_visible
	){
		enemy_look(target_direction);
		
		 // Attack:
		if(((target_distance < 128 && chance(2, 3)) || chance(1, my_health)) && alarm2 < 0){
			alarm2 = chrg_time;
			alarm1 = alarm2 - 10;
			
			 // Move away a tiny bit:
			enemy_walk(
				gunangle + 180 + orandom(10),
				5
			);
			
			 // Warn:
			with(instance_create(x, y, AssassinNotice)){
				depth = -3;
			}
			sound_play_pitch(sndRavenHit, 0.5 + random(0.1));
		}
		
		 // Move Toward Target:
		else enemy_walk(
			gunangle + orandom(10),
			random_range(20, 30)
		);
	}
	
	 // Wander:
	else{
		alarm1 = 90 + random(30);
		enemy_walk(random(360), random_range(10, 15));
		enemy_look(direction);
	}
	
#define Pelican_alrm2
	alarm1 = 40 + random(20);
	
	 // Dash:
	dash = 12;
	motion_set(gunangle, maxspeed);
	
	 // Heavy Slash:
	with(call(scr.projectile_create, x, y, EnemySlash, gunangle, (dash - 2) * dash_factor)){
		sprite_index = sprHeavySlash;
		friction     = 0.4;
		damage       = 10;
	}
	
	 // Misc. Visual/Sound:
	wkick = -4;
	wepangle = -wepangle;
	view_shake_at(x, y, 20); // Mmm that's heavy
	sound_play(sndEnergyHammer);
	sound_play_pitch(sndHammer, 0.75);
	sound_play_pitch(sndRavenScreech, 0.5 + random(0.1));
	
#define Pelican_hurt(_damage, _force, _direction)
	if(dash > 0){
		_force = min(_force, speed - 1);
	}
	call(scr.enemy_hurt, _damage, _force, _direction);
	
#define Pelican_death
	var _minID = instance_max;
	
	 // Pickups:
	pickup_drop(60, 20, 0);
	pickup_drop(80, 0, 1);
	
	 // Hmm:
	with(instances_matching_gt(WepPickup, "id", _minID)){
		if(call(scr.wep_raw, wep) == wep_sledgehammer){
			wep = call(scr.wep_wrap, 
				wep,
				"weapon_sprt",
				script_ref_create(cool_hammer, other.spr_weap)
			);
			
			 // Sparkle:
			var	_len = 16,
				_dir = rotation;
				
			with(instance_create(x + lengthdir_x(_len, _dir), y + lengthdir_y(_len, _dir), ThrowHit)){
				image_speed = 0.35;
			}
		}
	}
	
#define cool_hammer(_sprHammer)
	return _sprHammer;
	
	
#define Seal_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_spwn     = spr.SealSpwn[0];
		spr_idle     = spr.SealIdle[0];
		spr_walk     = spr.SealWalk[0];
		spr_hurt     = spr.SealHurt[0];
		spr_dead     = spr.SealDead[0];
		spr_weap     = spr.SealWeap[0];
		spr_shadow   = shd24;
		hitid        = [spr_idle, "SEAL"];
		sprite_index = spr_spwn;
		depth        = -2;
		
		 // Sound:
		var _male = irandom(1);
		snd_hurt = (_male ? sndFireballerHurt : sndFreakHurt);
		snd_dead = (_male ? sndFireballerDead : sndFreakDead);
		
		 // Vars:
		mask_index   = mskBandit;
		maxhealth    = 10;
		raddrop      = 1;
		size         = 1;
		walk         = 0;
		walkspeed    = 0.8;
		maxspeed     = 3.5;
		type         = 0;
		hold         = false;
		hold_x       = 0;
		hold_y       = 0;
		creator      = noone;
		wepangle     = 0;
		gunangle     = random(360);
		direction    = gunangle;
		slide        = 0;
		scared       = false;
		shield       = false;
		shield_inst  = noone;
		toss         = noone;
		toss_speed   = 0;
		toss_time    = 0;
		toss_ammo    = 2;
		toss_spin    = 0;
		attack_delay = 0;
		skeal        = false;
		setup        = true;
		
		 // Alarms:
		alarm1 = 20 + random(20);
		alarm2 = -1;
		
		return self;
	}
	
#macro seal_none        0
#macro seal_hookpole    1
#macro seal_shield      2
#macro seal_blunderbuss 3
#macro seal_mercenary   4
#macro seal_deadeye     5
#macro seal_dasher      6

#define Seal_setup
	setup = false;
	
	var _lastSpwn = spr_spwn;
	
	 // Skeleton Seal:
	if(skeal){
		 // Visual:
		spr_idle       = spr.SkealIdle;
		spr_walk       = spr.SkealWalk;
		spr_hurt       = spr.SkealHurt;
		spr_dead       = spr.SkealDead;
		spr_spwn       = spr.SkealSpwn;
		spr_bubble     = -1;
		spr_bubble_pop = -1;
		spr_bubble_x   = 0;
		spr_bubble_y   = 0;
		
		 // Sound:
		snd_hurt = sndMutant14Hurt;
		snd_dead = sndGatorDie;
		
		 // Vars:
		maxhealth = ceil(maxhealth * 2);
		my_health = ceil(my_health * 2);
		raddrop  += 4;
		maxspeed -= 1;
	}
	
	 // Normal Seal:
	else{
		spr_idle = spr.SealIdle[type];
		spr_walk = spr.SealWalk[type];
		spr_hurt = spr.SealHurt[type];
		spr_dead = spr.SealDead[type];
		spr_spwn = spr.SealSpwn[type];
	}
	
	 // Visual:
	spr_weap = spr.SealWeap[type];
	hitid    = [spr_idle, "SEAL"];
	if(sprite_index == _lastSpwn){
		sprite_index = spr_spwn;
	}
	
	 // Shield:
	if(type == seal_shield){
		wepangle = choose(-120, 120);
	}
	
#define Seal_step
	if(setup) Seal_setup();
	
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Slide:
	if(slide > 0){
		slide -= current_time_scale;
		motion_add_ct(direction, min(slide, 2));
		
		 // Turn:
		var _turn = 5 * sin(current_frame / 10) * current_time_scale;
		if(type == seal_dasher) _turn /= 3;
		direction += _turn;
		gunangle  += _turn;
		
		 // Effects:
		if(chance_ct(1, (skeal ? 3 : 1))){
			with(instance_create(x + orandom(3), y + 6, (skeal ? Smoke : Dust))){
				direction = other.direction;
			}
		}
	}
	
	 // Attack Delay:
	if(attack_delay > 0){
		attack_delay -= current_time_scale;
	}
	
	 // Type Step:
	switch(type){
		
		case seal_hookpole:
			
			 // About to Stab:
			if(alarm2 > 0){
				wkick += 2 * current_time_scale;
			}
			
			 // Decrease wkick Faster:
			else if(wkick < 0){
				wkick -= (wkick / 20) * current_time_scale;
			}
			
			break;
			
		case seal_shield:
			
			 // Shield Mode:
			if(shield){
				if(!instance_exists(shield_inst)){
					shield_inst = call(scr.projectile_create, x, y, "ClamShield", gunangle);
					with(shield_inst){
						mask_index = sprWall0Out;
					}
				}
			}
			
			 // Sword Stabby Mode:
			else if(instance_exists(shield_inst)){
				with(shield_inst){
					instance_destroy();
				}
			}
			
			break;
			
		case seal_blunderbuss:
			
			 // Powder Smoke:
			if(alarm2 > 0 && current_frame_active){
				sound_play(asset_get_index(`sndFootPlaSand${1 + irandom(5)}`));
				with(instance_create(x, y, Smoke)){
					motion_set(other.gunangle + (other.right * 120) + orandom(20), 1 + random(1));
					image_xscale /= 2;
					image_yscale = image_xscale;
					growspeed -= 0.01;
					depth = other.depth - (other.gunangle > 180);
				}
			}
			
			break;
			
		case seal_deadeye:
			
			 // Tossing:
			if(instance_exists(toss)){
				 // Move Away from Walls:
				if(instance_exists(Wall)){
					with(call(scr.instance_nearest_bbox, x, y, Wall)){
						if(distance_to_point(other.x, other.y) < other.toss_speed + (max(other.toss.sprite_height, other.toss.sprite_width) / 2)){
							var _dir = point_direction(bbox_center_x, bbox_center_x, other.x, other.y);
							with(other){
								motion_add_ct(_dir, 1);
							}
						}
					}
				}
				
				with(toss){
					 // Build Speed:
					if(speed < other.toss_speed){
						speed += (1.5 * current_time_scale) + friction_raw;
						
						depth = other.depth;
						
						 // Ready:
						if(speed >= other.toss_speed){
							speed = other.toss_speed + 0.0001;
							
							 // Effects:
							other.wkick = 1;
							repeat(2){
								call(scr.fx, x, y, [direction + orandom(30), random_range(3, 5)], Dust);
							}
							sound_play_pitchvol(sndMeleeFlip, 1.4 + random(0.2), 0.8);
							sound_play_pitchvol(sndDiscgun, 1.6 + random(0.2), 0.4);
						}
					}
					
					 // Spin:
					else{
						depth = other.depth - 1;
						other.toss_spin += clamp((6 * speed) - other.toss_spin, -1, 1) * current_time_scale;
						direction += other.toss_spin * current_time_scale;
					}
					
					 // Holding:
					var _l = (speed + other.wkick) - (speed_raw - friction_raw);
					x = other.x + lengthdir_x(_l, direction);
					y = other.y + lengthdir_y(_l, direction);
					xprevious = x;
					yprevious = y;
					
					 // Toss:
					if(other.toss_time > 0) other.toss_time -= current_time_scale;
					else if(speed >= other.toss_speed){
						if(abs(angle_difference(direction + (90 * sign(other.toss_spin)), other.gunangle)) < abs(other.toss_spin * 0.5 * max(1, current_time_scale))){
							other.toss = noone;
							
							x = other.x + hspeed;
							y = other.y + vspeed;
							direction += 90 * sign(other.toss_spin);
							x -= hspeed_raw;
							y -= vspeed_raw;
							
							 // FX:
							with(other) motion_add(other.direction, 3);
							repeat(2){
								with(call(scr.fx, x, y, [direction + orandom(30), random_range(2, random(speed * 2/3))], Smoke)){
									image_xscale *= 2/3;
									image_yscale *= 2/3;
								}
							}
							call(scr.sound_play_at, x, y, sndDiscDie,   0.6 + random(0.1), 2);
							call(scr.sound_play_at, x, y, sndMeleeFlip, 0.8 + random(0.2), 3);
						}
					}
					
					 // Discin:
					if(instance_is(self, Disc)){
						dist = 0;
						alarm0 = max(alarm0, 9);
					}
					
					with(other){
						enemy_face(other.direction);
					}
				}
			}
			else{
				toss_speed = 0;
				toss_spin = 0;
				
				 // No More Discs:
				if(toss_ammo <= 0) type = seal_none;
			}
			
			break;
			
		case seal_dasher:
			
			if(slide <= 0 && gunangle > 180){
				gunangle = random(180);
			}
			
			break;
			
		default:
			
			if(walk > 0) direction += orandom(10);
			
			 // Less Post-Level Running Around:
			if(type == seal_none){
				if(scared && !array_length(instances_matching_ne(obj.Palanking, "id"))){
					if("wading" in self && wading > 0){
						if(!point_seen_ext(x, y, sprite_width, sprite_height, -1)){
							my_health = 0;
						}
					}
				}
			}
			
	}
	
	 // Animate:
	if(sprite_index != spr_spwn){
		if(sprite_index != spr_hurt || anim_end){
			if(speed <= 0){
				if(sprite_index != spr_idle) image_index += random(2);
				sprite_index = spr_idle;
			}
			else sprite_index = spr_walk;
		}
	}
	else{
		if(anim_end){
			sprite_index = spr_idle;
			wkick = 4;
			with(instance_create(x, y, (skeal ? Smoke : Dust))){
				depth = other.depth - 1;
			}
		}
		
		if(skeal) speed = 0;
		
		if(image_index < 2){
			if(skeal){
				if(current_frame_active) call(scr.fx, x, y, [90, 1], Smoke);
			}
			else{
				y -= image_index * current_time_scale;
			}
		}
	}
	
#define Seal_draw
	var _drawWep = (sprite_index != spr_spwn || image_index > (skeal ? 5 : 2));
	
	 // Sliding Visuals:
	if(slide > 0){
		var	_lastAng = image_angle,
			_lastY = y;
			
		image_angle = direction - 90;
		y += 2;
	}
	
	 // Back Weapon:
	if(type == seal_shield && _drawWep){
		 // Dagger:
		if(shield){
			draw_sprite_ext(spr_weap, 0, x + 2 - (8 * right), y - 16, 1, 1, 270 + (right * 25), image_blend, image_alpha);
		}
		
		 // Shield:
		else{
			draw_sprite_ext(spr.ClamShieldWep, 0, x - right, y, 1, right, image_angle + 90, c_white, image_alpha);
		}
	}
	
	 // Self Behind:
	var _back = (gunangle <= 180);
	if(!_back) draw_self_enemy();
	
	 // Weapon:
	if(_drawWep && !instance_exists(shield_inst)){
		call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, wepangle, wkick, ((wepangle == 0) ? right : sign(wepangle)), image_blend, image_alpha);
	}
	
	 // Self:
	if(_back) draw_self_enemy();
	
	 // Reset Vars:
	if(slide > 0){
		image_angle = _lastAng;
		y = _lastY;
	}
	
#define Seal_alrm1
	alarm1 = 30 + random(30);
	
	trident_dist = 0; // Reset
	
	if(enemy_target(x, y)){
		var	_aimLast   = gunangle,
			_canAttack = (attack_delay <= 0);
			
		enemy_look(target_direction);
		
		if(type == seal_none || target_visible){
			var _targetDis = target_distance;
			
			 // Seal Types:
			switch(type){
				
				case seal_hookpole:
					
					alarm1 = 10 + random(15);
					
					 // Too Close:
					if(_targetDis < 20){
						enemy_walk(
							gunangle + 180 + orandom(60),
							10
						);
					}
					
					else{
						if(chance(4, 5)){
							 // Attack:
							if(_canAttack && _targetDis < 70){
								alarm1       = 30;
								alarm2       = 10;
								trident_dist = _targetDis - 24;
							}
							
							 // Too Far:
							else{
								enemy_walk(gunangle + orandom(20), 10);
								if(chance(1, 10)){
									slide = 10;
								}
							}
						}
						
						 // Side Step:
						else{
							enemy_walk(gunangle + choose(-80, 80), 15);
							if(chance(1, 2)){
								slide = 5 + random(10);
							}
						}
					}
					
					break;
					
				case seal_shield:
					
					 // Shield Defendy Mode:
					if(shield){
						alarm1 = 15 + irandom(5);
						
						 // Dagger Time:
						if(wkick == 0 && _targetDis < 80){
							enemy_walk(
								gunangle + orandom(10),
								random_range(4, 8)
							);
							
							shield = false;
							alarm1 = 20;
							
							 // Swap FX:
							var _len = 8;
							instance_create(x + lengthdir_x(_len, gunangle), y + lengthdir_y(_len, gunangle), WepSwap);
							sound_play(sndSwapSword);
						}
						
						 // Reposition:
						else if(chance(2, 3)){
							enemy_walk(gunangle + orandom(50), random_range(6, 12));
							enemy_look(direction);
						}
					}
					
					 // Sword Stabby Mode:
					else{
						alarm1 = 20 + random(10);
						
						if(_targetDis < 120){
							enemy_walk(
								gunangle + (180 * chance(1, 3)) + orandom(20),
								random_range(5, 10)
							);
							
							 // Stabby:
							if(_canAttack && _targetDis < 80){
								with(call(scr.projectile_create, x, y, Shank, gunangle, 3)){
									damage = 2;
								}
								motion_add(gunangle, 2);
								wepangle *= -1;
								wkick = -4;
								
								 // Effects:
								instance_create(x, y, Dust);
								sound_play(sndMeleeFlip);
								sound_play(sndScrewdriver);
								sound_play_pitchvol(sndSwapGold, 1.25 + random(0.5), 0.4);
							}
							
							 // Slide Away:
							else{
								direction = gunangle + 180;
								slide = 10;
							}
						}
						
						 // Shield Time:
						else{
							shield = true;
							wkick = 2;
							
							 // Swap FX:
							var	_l = 8,
								_d = gunangle;
								
							instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), WepSwap);
							sound_play(sndSwapHammer);
						}
					}
					
					break;
					
				case seal_blunderbuss:
					
					 // Slide Away:
					if(_targetDis < 80){
						direction = gunangle + 180;
						slide = 15;
						alarm1 = slide + random(10);
					}
					
					 // Good Distance Away:
					else{
						 // Aim & Ignite Powder:
						if(_canAttack && _targetDis < 192 && chance(2, 3)){
							alarm1 = alarm1 + 90;
							alarm2 = 15;
							
							 // Effects:
							sound_play_pitchvol(sndEmpty, 2.5, 0.5);
							wkick = -2;
						}
						
						 // Reposition:
						else{
							enemy_walk(gunangle + orandom(90), 10);
							if(chance(1, 2)){
								slide = 15;
							}
						}
						
						 // Important:
						if(chance(1, 3)){
							with(instance_create(x, y, CaveSparkle)){
								depth = other.depth - 1;
							}
						}
					}
					
					break;
					
				case seal_mercenary:
					
					 // Slide Towards:
					if(_targetDis > 160){
						direction = gunangle + orandom(60);
						slide = 15;
						alarm1 = slide + random(20);
					}
					
					 // Within Range:
					else{
						enemy_walk(gunangle + orandom(90), 15);
						
						 // Pew Time:
						if(_canAttack){
							alarm2 = 8;
							alarm1 = alarm2 + 5 + random(20);
							
							 // Preparin:
							wkick = -4;
							call(scr.sound_play_at, x, y, sndShotReload, 1.5 + random(0.5), 1.2);
							with(instance_create(x, y, Shell)){
								sprite_index = sprShotShell;
								motion_add(other.gunangle + (90 * other.right), 2 + random(2));
							}
						}
					}
					
					break;
					
				case seal_deadeye:
					
					if(!instance_exists(toss)){
						 // Hobble Around:
						if(chance(1, 2)){
							enemy_walk(
								gunangle + choose(-80, 80) + orandom(20),
								random_range(4, 20)
							);
						}
						
						 // Toss Disc:
						else{
							toss_ammo--;
							toss_time  = 60;
							toss_speed = random_range(7, 9);
							toss       = call(scr.projectile_create, x, y, "SealDisc", random(360));
						}
					}
					
					if(instance_exists(toss)) alarm1 = 15;
					
					break;
					
				case seal_dasher:
					
					 // Move Away:
					if(_targetDis < 32 || chance(1, 4)){
						slide = 5 + random(5);
						direction = gunangle + 180 + orandom(40);
					}
					
					 // Combat Slide:
					else{
						slide = 20;
						alarm2 = 8;
						direction = random(360);
						call(scr.sound_play_at, x, y, sndSnowBotSlideStart, 1.3 + random(0.4), 1.5);
					}
					
					alarm1 = slide + 5 + random(15);
					
					break;
					
				default:
					
					 // Follow Big Seal:
					if(instance_exists(creator) && variable_instance_get(creator, "active", false)){
						enemy_look(point_direction(x, y, creator.x, creator.y));
						enemy_walk(gunangle, random_range(10, 20));
					}
					
					 // Normal:
					else{
						 // "Don't kill me!"
						if(scared){
							if(_targetDis < 120 || chance(2, array_length(instances_matching_ne(obj.Seal, "id")))){
								enemy_walk(
									gunangle + 180 + orandom(50),
									random_range(20, 30)
								);
								if(chance(1, 3)){
									slide = walk - 5;
								}
								alarm1 = walk;
							}
							else enemy_walk(
								random(360),
								random_range(5, 10)
							);
							enemy_look(direction);
						}
						
						 // Idle:
						else{
							enemy_walk(
								point_direction(x, y, xstart + orandom(24), ystart + orandom(24)),
								random_range(5, 10)
							);
							if(_targetDis > 120){
								enemy_look(direction);
							}
						}
					}
					
			}
			
			 // Sliding Time:
			if(alarm2 > 0 && slide > 0){
				enemy_face(gunangle - (direction - 90));
			}
		}
		
		 // Looking for Player:
		else{
			 // Move:
			enemy_walk(gunangle + orandom(60), random_range(5, 25));
			alarm1 = 5 + irandom(walk) + irandom(15);
			
			 // Aiming:
			enemy_look(direction);
			switch(type){
				case seal_shield:
					
					if(shield){
						enemy_look(angle_lerp(_aimLast, direction, 1/5));
					}
					
					break;
					
				case seal_dasher:
					
					gunangle = random(180);
					
					break;
			}
		}
	}
	
	 // Wander:
	else{
		enemy_walk(random(360), random_range(5, 25));
		enemy_look(direction);
		alarm1 += walk;
	}
	
	 // Slide FX:
	if(slide > 0){
		if(hold){
			slide = 0;
		}
		else{
			sound_play_hit(sndRoll, 0.4);
			sound_play_pitch(sndBouncerBounce, 0.4 + random(0.1));
			repeat(5) with(instance_create(x, y, Dust)){
				motion_add(random(360), 3);
			}
		}
	}
	
#define Seal_alrm2
	switch(type){
		
		case seal_hookpole:
			
			 // Hookpole Stabby:
			var	_dis = 24 + trident_dist,
				_dir = gunangle;
				
			with(call(scr.projectile_create, x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Shank, _dir + 180, 2)){
				image_angle  = _dir;
				image_xscale = 0.5;
				depth        = -3;
				damage       = 3;
				force        = 12;
			}
			
			 // Effects:
			sound_play(sndMeleeFlip);
			sound_play(sndJackHammer);
			sound_play(sndScrewdriver);
			repeat(5){
				call(scr.fx, x, y, [gunangle + orandom(30), random(skeal ? 2 : 5)], (skeal ? Smoke : Dust));
			}
			
			 // Forward Push:
			x += lengthdir_x(4, gunangle);
			y += lengthdir_y(4, gunangle);
			wkick = -trident_dist;
			
			 // Walk Backwards:
			enemy_walk(
				gunangle + 180 + orandom(20),
				random_range(6, 10)
			);
			
			break;
			
		case seal_blunderbuss:
			
			 // Blammo:
			repeat(6){
				call(scr.projectile_create, x, y, EnemyBullet1, gunangle + orandom(6), 6 + random(2));
			}
			
			 // Effects:
			for(var i = 0; i < 6; i++){
				with(instance_create(x, y, Dust)){
					motion_add(random(360), 3);
				}
				with(instance_create(x, y + 1, Dust)){
					motion_add(other.gunangle + orandom(6), 2 + i);
				}
			}
			sound_play_pitchvol(sndDoubleShotgun, 1.5, 1);
			motion_add(gunangle + 180, 4);
			wkick = 10;
			
			break;
			
		case seal_mercenary:
			
			if(chance(1, 3)){
				alarm2 = irandom_range(3, 5);
			}
			
			 // Pew:
			call(scr.projectile_create, x, y, EnemyBullet3, gunangle + orandom(4), 12 + random(2));
			
			 // Effects:
			call(scr.fx, x, y, [gunangle, 2], Smoke);
			sound_play_pitchvol(sndEnemyFire, 1, 1.5);
			sound_play_pitchvol(sndShotgun, 2 + random(0.4), 0.8);
			motion_add(gunangle + 180, 1);
			wkick += 5;
			
			 // Aim:
			if(enemy_target(x, y)){
				enemy_look(target_direction);
			}
			
			break;
			
		case seal_dasher:
			
			 // Aim:
			if(enemy_target(x, y) && target_visible){
				enemy_look(target_direction);
			}
			
			 // Shooty:
			call(scr.projectile_create, x, y, EnemyBullet1, gunangle, 6);
			
			 // Effects:
			wkick = 10;
			direction += choose(-30, 30);
			call(scr.sound_play_at, x, y, sndEnemyFire,  1.0 +  random(0.3), 2.5);
			call(scr.sound_play_at, x, y, sndTurretFire, 1.3 + orandom(0.2), 1.5);
			
			break;
			
	}
	
#define Seal_hurt(_damage, _force, _direction)
	call(scr.enemy_hurt, _damage, _force, _direction);
	
	switch(type){
		
		case seal_none:
			
			 // Alert:
			with(instances_matching(obj.Seal, "type", type)){
				if(!scared){
					if(instance_exists(target) && target_distance < 80){
						scared = true;
						instance_create(x, y, AssassinNotice);
					}
				}
			}
			
			break;
			
		case seal_shield:
			
			sound_play_hit(sndHitRock, 0.3);
			
			break;
			
		case seal_dasher:
			
			//sound_play_hit(sndSnowBotHurt, 0.3); i miss snowbot hunter bro
			
			break;
			
	}
	
#define Seal_death
	pickup_drop(50, 0);
	
	 // Tossin:
	if(instance_exists(toss) && (toss.speed < toss_speed || toss_spin < 20)){
		with(toss){
			sound_play_hit(sndDiscDie, 0.2);
			with(instance_create(x, y, DiscDisappear)){
				depth = other.depth;
			}
		}
		instance_delete(toss);
	}
	
	 // Skeal FX:
	if(skeal){
		sound_play_hit(sndBloodGamble, 0.1);
		for(var _d = direction; _d < direction + 360; _d += (360 / 3)){
			call(scr.fx, x, y, [_d, 3], Smoke);
		}
	}
	
	
#define SealAnchor_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.SealAnchor;
		image_speed  = 0;
		depth        = -2;
		
		 // Vars:
		mask_index = -1;
		damage     = 4;
		force      = 6;
		team       = 1;
		last_x     = [x, x];
		last_y     = [y, y];
		
		return self;
	}
	
#define SealAnchor_step
	if(instance_exists(creator)){
		x = creator.x + (hspeed * (1 - current_time_scale));
		y = creator.y + (vspeed * (1 - current_time_scale));
		with(creator){
			x += (other.hspeed / 20) * current_time_scale;
			y += (other.vspeed / 20) * current_time_scale;
		}
	}
	else{
		if(friction <= 0){
			sound_play_pitch(sndSwapSword, 2.4);
			friction = 0.6;
			speed /= 3;
			typ = 1;
		}
		
		 // Explode:
		if(speed < 1){
			instance_destroy();
		}
	}

#define SealAnchor_end_step
	 // Effects:
	var	_dis = [2, sprite_width - 2],
		_dir = direction;
		
	for(var i = 0; i < array_length(_dis); i++){
		var	_x = x + lengthdir_x(_dis[i], _dir),
			_y = y + lengthdir_y(_dis[i], _dir);
			
		with(instance_create(_x, _y, BoltTrail)){
			image_angle = point_direction(x, y, other.last_x[i], other.last_y[i]);
			image_xscale = point_distance(x, y, other.last_x[i], other.last_y[i]);
			image_yscale = 0.6;
		}
		
		last_x[i] = _x;
		last_y[i] = _y;
	}
	
#define SealAnchor_draw
	if(instance_exists(creator)){
		var	_oy  = 2,
			_x   = x + lengthdir_x(_oy, direction - 90),
			_y   = y + lengthdir_y(_oy, direction - 90),
			_spr = spr.SealChain,
			_dir = point_direction(_x, _y, creator.x, creator.y),
			_n   = ceil(point_distance(x, y, creator.x, creator.y)) / sprite_get_width(_spr),
			_l   = 0,
			_t   = 0,
			_w   = sprite_get_width(_spr),
			_h   = sprite_get_height(_spr);

		for(var i = 0; i < _n; i++){
			if(i >= _n - 1){
				_w = point_distance(_x, _y, creator.x, creator.y);
			}
			draw_sprite_general(_spr, 0, _l, _t, _w, _h, _x, _y, 1, 1, _dir, image_blend, image_blend, image_blend, image_blend, image_alpha);
			_x += lengthdir_x(_w, _dir);
			_y += lengthdir_y(_w, _dir);
		}
	}
	draw_self();

#define SealAnchor_hit
	if(projectile_canhit_np(other)){
		projectile_hit_np(other, damage, force, 40);
	}

#define SealAnchor_projectile
	if(instance_exists(self)){
		with(other){
			if(typ == 1 || typ == 2){
				 // Deflect (No Team Change):
				if(typ == 1 && other.candeflect){
					direction   = other.direction;
					image_angle = direction;
					
					 // Effects:
					with(instance_create(x, y, Deflect)){
						image_angle = other.image_angle;
					}
				}
				
				 // Destroy:
				else instance_destroy();
			}
		}
	}
	
#define SealAnchor_destroy
	 // Explodo:
	var	_dis = 8,
		_dir = image_angle;
		
	with(call(scr.projectile_create, x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "BubbleExplosion")){
		team = -1;
		
		 // Sounds:
		call(scr.sound_play_at, x, y, sndWallBreakBrick, 1.2 + random(0.1), 0.4);
		call(scr.sound_play_at, x, y, sndSwapHammer,     1.3,               0.3);
	}
	
	
#define SealDisc_create(_x, _y)
	with(instance_create(_x, _y, Disc)){
		 // Visual:
		sprite_index = spr.SealDisc;
		
		 // Vars:
		trail_color = make_color_rgb(252, 56, 0);
		
		return self;
	}
	
#define SealDisc_end_step
	 // Color Trail:
	if(team == -1){
		with(instances_matching(instances_matching(instances_matching(DiscTrail, "image_blend", c_white), "xstart", xprevious), "ystart", yprevious)){
			image_blend = ((other.team == 2) ? c_yellow : other.trail_color);
		}
	}
	
	
#define SealHeavy_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_spwn     = spr.SealHeavySpwn;
		spr_idle     = spr.SealHeavyIdle;
		spr_walk     = spr.SealHeavyWalk;
		spr_hurt     = spr.SealHeavyHurt;
		spr_dead     = spr.SealHeavyDead;
		spr_chrg     = spr.SealHeavyTell;
		spr_weap     = spr.SealAnchor;
		spr_shadow   = shd24;
		hitid        = [spr_idle, "HEAVY SEAL"];
		sprite_index = spr_spwn;
		depth        = -2;
		
		 // Sound:
		snd_hurt = sndJockHurt;
		snd_dead = sndJockDead;
		
		 // Vars:
		mask_index     = mskBandit;
		maxhealth      = 32;
		raddrop        = 12;
		size           = 2;
		walk           = 0;
		walkspeed      = 0.8;
		maxspeed       = 3;
		wepangle       = 0;
		gunangle       = random(360);
		direction      = gunangle;
		my_mine        = noone;
		my_mine_ang    = gunangle;
		my_mine_spin   = 0;
		target_x       = x;
		target_y       = y;
		anchor         = noone;
		anchor_swap    = false;
		anchor_spin    = 0;
		anchor_throw   = 0;
		anchor_retract = 0;
		
		 // Alarms:
		alarm1 = 40 + random(30);
		
		return self;
	}

#define SealHeavy_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	if(sprite_index == spr_spwn){
		if(anim_end){
			sprite_index = spr_idle;
		}
		if(image_index < 2){
			y -= image_index * current_time_scale;
		}
	}
	else sprite_index = enemy_sprite;
	
	 // Anchor Flail:
	if(anchor_spin != 0){
		enemy_look(gunangle + (anchor_spin * current_time_scale));
		speed = max(speed, 1.5);
		
		if(instance_exists(anchor)){
			sprite_index = spr_walk;
			with(anchor){
				direction = other.gunangle;
				image_angle = direction;
			}
			
			 // Throw Out Anchor:
			if(anchor_throw > 0){
				anchor.speed += anchor_throw * current_time_scale;
				anchor_throw -= current_time_scale;
			}
			
			 // Retract Anchor:
			if(anchor_retract){
				anchor.speed -= 0.5 * current_time_scale;
				if(anchor.speed <= 0){
					instance_delete(anchor);
					anchor = noone;
				}
			}
		}
		
		else{
			if(alarm1 < 20) sprite_index = spr_chrg;
			
			 // Stop Spinning:
			if(anchor_retract){
				anchor_spin *= 0.8;
				if(abs(anchor_spin) < 1){
					anchor_spin = 0;
					anchor_throw = 0;
					anchor_retract = false;
				}
			}
			
			 // Build Up Speed:
			else{
				anchor_spin += sign(anchor_spin) * 0.4 * current_time_scale;
				anchor_spin = clamp(anchor_spin, -20, 20);
			}
		}
		
		 // Effects:
		if(current_frame_active){
			with(instance_create(x, y, Dust)){
				motion_add(other.gunangle, 2);
			}
			
			 // Swoop Sounds:
			if(gunangle < abs(anchor_spin)){
				var _vol = 1.5;
				if(instance_exists(anchor)) _vol = 8;
				sound_play_pitchvol(sndMeleeFlip, 0.1 + random(0.1), _vol);
			}
		}
	}
	
	else{
		 // Unequip Anchor:
		if(anchor_swap){
			anchor_swap = false;
			sound_play(sndMeleeFlip);
			instance_create(x, y, WepSwap);
		}
		
		 // Spin Mine:
		if(instance_exists(my_mine)){
			 // Turn Gradually:
			if(my_mine_spin == 0){
				my_mine_ang = angle_lerp(my_mine_ang, gunangle, 1/5);
			}
			
			 // Spinny Momentum:
			else{
				my_mine_ang += my_mine_spin * current_time_scale;
				my_mine_ang = (((my_mine_ang % 360) + 360) % 360);
				enemy_face(my_mine_ang);
				
				my_mine_spin += 1.5 * sign(my_mine_spin) * current_time_scale;
				
				 // Animate:
				sprite_index = spr_chrg;
			}
			
			 // Holding:
			with(my_mine){
				var	_dis = 16,
					_dir = other.my_mine_ang;
					
				x = other.x + lengthdir_x(_dis, _dir);
				y = other.y + lengthdir_y(_dis, _dir);
				
				if(other.my_mine_spin != 0){
					image_angle += other.my_mine_spin / 3;
					
					 // Starting to Toss:
					if(other.alarm1 < 5){
						z = sqr(5 - other.alarm1);
						zspeed = 0;
					}
					
					 // FX:
					if(current_frame_active){
						instance_create(x, y, Dust);
					}
				}
			}
		}
		
		 // Pick Up Mines:
		else{
			my_mine = noone;
			if(place_meeting(x, y, CustomHitme)){
				with(call(scr.instances_meeting_instance, self, obj.SealMine)){
					if(
						place_meeting(x, y, other)
						&& !array_length(instances_matching(obj.SealHeavy, "my_mine", self))
					){
						with(other){
							alarm1      = 20;
							my_mine     = other;
							my_mine_ang = point_direction(x, y, other.x, other.y);
							enemy_face(my_mine_ang);
						}
						creator = other;
						hitid   = other.hitid;
						
						 // Effects:
						sound_play_pitchvol(sndSwapHammer, 0.6 + orandom(0.1), 0.8);
						for(var _dir = direction; _dir < direction + 360; _dir += (360 / 20)){
							call(scr.fx, x, y, [_dir, 4], Dust);
						}
						
						break;
					}
				}
			}
		}
	}
	
#define SealHeavy_draw
	var _drawWep = (sprite_index != spr_spwn || image_index > 2);

	 // Back Anchor:
	if(!anchor_swap && _drawWep){
		draw_sprite_ext(spr_weap, 0, x + right, y + 6, 1, 1, 90 + (right * 30), image_blend, image_alpha);
	}

	if(gunangle >  180) draw_self_enemy();

	if(anchor_swap && _drawWep && !instance_exists(anchor)){
		call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, 0, wkick, 1, image_blend, image_alpha);
	}

	if(gunangle <= 180) draw_self_enemy();

#define SealHeavy_alrm1
	alarm1 = 90 + random(30);
	
	 // Lob Mine:
	if(my_mine != noone && my_mine_spin != 0){
		sprite_index = spr_idle;
		with(my_mine){
			zspeed    = 10;
			direction = point_direction(x, y, other.target_x, other.target_y);
			speed     = (point_distance(x, y, other.target_x, other.target_y) * zfriction) / (zspeed * 2);
			x        -= hspeed_raw;
			y        -= vspeed_raw;
		}
		my_mine      = noone;
		my_mine_spin = 0;
		enemy_walk(gunangle, 5);
		
		 // Sound:
		sound_play_pitch(sndAssassinGetUp, 0.5 + orandom(0.2));
		sound_play_pitchvol(sndAssassinAttack, 0.8 + orandom(0.1), 0.8);
	}
	
	else{
		 // Spinning Anchor:
		if(anchor_spin != 0){
			 // Throw Out Anchor:
			if(!instance_exists(anchor)){
				alarm1       = 60;
				anchor       = call(scr.projectile_create, x, y, "SealAnchor", gunangle);
				anchor_throw = 8;
				anchor_spin  = max(20, abs(anchor_spin)) * sign(anchor_spin);
				if(enemy_target(x, y)){
					direction = target_direction;
				}
				
				 // Effects:
				sound_play_pitch(sndHammer, 0.8 + orandom(0.1));
				repeat(5) with(instance_create(x, y, Dust)){
					motion_add(other.gunangle, 4);
				}
			}
			
			 // Retract Anchor:
			else{
				alarm1 = 120 + random(30);
				anchor_retract = true;
			}
		}
		
		else if(enemy_target(x, y) && target_visible){
			enemy_look(target_direction);
			
			target_x = target.x;
			target_y = target.y;
			
			 // Not Holding Mine:
			if(my_mine == noone){
				 // Pick Up Mine:
				if(distance_to_object(Floor) > 24 && chance(3, 4)){
					alarm1      = 20;
					my_mine     = call(scr.obj_create, x, y, "SealMine");
					my_mine_ang = gunangle;
					with(my_mine){
						zspeed  = 5;
						creator = other;
						hitid   = other.hitid;
					}
				}
				
				 // On Land:
				else{
					var _targetDis = target_distance;
					
					 // Start Spinning Anchor:
					if((_targetDis < 180 && chance(3, 4)) || _targetDis < 100){
						alarm1 = 45;
						anchor_spin = choose(-1, 1) * 5;
						sound_play_pitch(sndRatMelee, 0.5 + orandom(0.1));
						
						 // Equip Anchor:
						anchor_swap = true;
						sound_play(sndSwapHammer);
						instance_create(x, y, WepSwap);
					}
					
					 // Walk Closer:
					else alarm1 = 30 + random(30);
					enemy_walk(
						gunangle + orandom(30),
						random_range(8, 24)
					);
				}
			}
			
			 // Holding Mine:
			else{
				if(instance_exists(my_mine)){
					alarm1 = 20;
					
					var _targetDis = target_distance;
					
					if(_targetDis < 144){
						 // Too Close:
						if(_targetDis < 48){
							enemy_walk(gunangle + 180, 20);
						}
						
						 // Start Toss:
						else{
							my_mine_ang  = gunangle;
							my_mine_spin = choose(-1, 1);
							
							sound_play_pitch(sndRatMelee, 0.5 + orandom(0.1));
							sound_play_pitch(sndSteroidsUpg, 0.75 + orandom(0.1));
							repeat(5) with(instance_create(target_x, target_y, Dust)){
								motion_add(random(360), 3);
							}
						}
					}
					
					 // Out of Range:
					else enemy_walk(
						gunangle + orandom(20),
						random_range(10, 20)
					);
				}
				else my_mine = noone;
			}
		}
		
		 // Passive Movement:
		else{
			enemy_walk(random(360), 5);
			enemy_look(direction);
		}
	}
	
#define SealHeavy_death
	pickup_drop(50, 0);
	
	
#define SealMine_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle    = spr.SealMine;
		spr_hurt    = spr.SealMineHurt;
		spr_dead    = sprScorchmark;
		spr_shadow  = shd24;
		hitid       = [spr_idle, "WATER MINE"];
		image_speed = 0.4;
		depth       = -3;
		
		 // Sound:
		snd_hurt = sndHitMetal;
		
		 // Vars:
		mask_index = mskNone;
		friction   = 0;
		maxhealth  = 10;
		creator    = noone;
		canfly     = true;
		size       = 2;
		team       = 0;
		z          = 0;
		zspeed     = 0;
		zfriction  = 1;
		right      = choose(-1, 1);
		
		motion_add(random(360), 3);
		
		return self;
	}
	
#define SealMine_step
	 // Animate:
	if(sprite_index != spr_hurt || anim_end){
		sprite_index = spr_idle;
	}

	 // Z-Axis:
	z += zspeed * current_time_scale;
	zspeed -= zfriction * current_time_scale;
	image_angle -= sign(hspeed) * (abs(vspeed / 2) + abs(hspeed));
	if(z <= 0){
		friction = 0.4;
		mask_index = mskWepPickup;
		depth = -3;
		
		 // Movement:
		if(speed > 0){
			var m = 4;
			if(speed > m) speed = m;
			
			 // Effects:
			if(chance_ct(1, 5)){
				instance_create(x, y + 8, Dust);
				if(place_meeting(x, y, Floor)){
					sound_play_pitchvol(asset_get_index(`sndFootPla${choose("Rock", "Sand", "Metal")}${irandom(5) + 1}`), 0.6, 0.6);
				}
			}
		}
		
		 // Impact:
		if(zspeed < -10){
			if(distance_to_object(Floor) < 20 || place_meeting(x, y, Player)){
				my_health = 0;
			}
			
			 // Splash FX:
			else{
				var _ang = orandom(20);
				for(var a = _ang; a < _ang + 360; a += (360 / 2)){
					with(call(scr.fx, x, y, [a, 4], "WaterStreak")){
						hspeed += other.hspeed / 2;
						vspeed += other.vspeed / 2;
					}
				}
				sound_play_pitch(sndOasisExplosionSmall, 2);
			}
		}
		
		 // On Land:
		if(place_meeting(x, y, Floor)) friction *= 1.5;
		
		 // Floating in Water:
		else image_angle += sin(current_frame / 20) * 0.5;
		
		zspeed = 0;
		z = 0;
	}
	
	 // In Air:
	else{
		friction = 0;
		mask_index = mskNone;
		depth = -9;
	}
	
	 // Push:
	if(place_meeting(x, y, hitme)){
		with(call(scr.instances_meeting_instance, self, (instance_exists(creator) ? instances_matching_ne(hitme, "id", creator.id) : hitme))){
			if(place_meeting(x, y, other)){
				with(other){
					motion_add(point_direction(other.x, other.y, x, y), other.size / 5);
				}
				if(!instance_is(self, prop)){
					motion_add(point_direction(other.x, other.y, x, y), other.size / 2);
				}
			}
		}
	}

	if(my_health <= 0) instance_destroy();

#define SealMine_draw
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	
#define SealMine_destroy
	 // Explode:
	with(call(scr.projectile_create, x, y, Explosion)){
		team = -1;
	}
	sound_play(sndExplosion);

	 // Shrapnel:
	for(var _dir = direction; _dir < direction + 360; _dir += (360 / 6)){
		with(call(scr.projectile_create, x, y, EnemyBullet3, _dir + orandom(20), 7 + random(4))){
			team = -1;
		}
	}
	sound_play_hit(sndFlakExplode, 0.2);
	
	
#define SealWave_create(_x, _y)
	/*
		A wave of seals spawned by Seal King
	*/
	
	with(instance_create(_x, _y, becomenemy)){
		 // Vars:
		mask_index = sprPortalClear;
		direction  = random(360);
		creator    = noone;
		seal_num   = 4;
		seal_delay = 30;
		seal_alert = false;
		floor_dis  = 16 + random(16);
		
		return self;
	}
	
#define SealWave_end_step
	 // Move to Ocean:
	if(floor_dis > 0){
		while(distance_to_object(Floor) < floor_dis || place_meeting(x, y, prop)){
			x += lengthdir_x(12, direction);
			y += lengthdir_y(12, direction);
		}
		floor_dis = 0;
		
		 // Disable Alert:
		if(point_seen(x, y, -1)){
			seal_alert--;
		}
	}
	
	 // Spawn Seals:
	if(seal_delay > 0){
		seal_delay -= current_time_scale;
	}
	else if(seal_num > 0){
		seal_num--;
		seal_delay = (
			(seal_num > 0)
			? max(4 - (GameCont.loops * 0.5), 2) * random_range(1, 2)
			: (("intro_pan" in creator) ? creator.intro_pan : 0)
		);
		
		 // Sound:
		sound_play_pitch(choose(sndOasisHurt, sndOasisMelee, sndOasisShoot, sndOasisChest, sndOasisCrabAttack), 0.8 + random(0.4));
		
		 // Seal:
		var	_len = 16 + random(24),
			_dir = (seal_num * 90) + orandom(40);
			
		with(call(scr.obj_create,
			x + lengthdir_x(_len, _dir),
			y + lengthdir_y(_len, _dir),
			(chance(1, 16) ? "SealHeavy" : "Seal"))
		){
			creator = other.creator;
			
			 // Rads:
			if("raddrop" in creator){
				if(creator.raddrop > 0){
					creator.raddrop -= min(raddrop, creator.raddrop);
				}
				raddrop = min(raddrop, creator.raddrop);
			}
			
			 // No Free Kills:
			if("active" not in creator || creator.active){
				kills = 0;
			}
			
			 // -- No fat allowed beyond this point -- //
			if(array_find_index(obj.Seal, self) >= 0){
				 // Randomize Type:
				type = call(scr.pool, [
					[seal_hookpole,    8],
					[seal_blunderbuss, 5],
					[seal_shield,      3],
					[seal_mercenary,   ((GameCont.loops > 0) ? 8 : 0)],
					[seal_dasher,      ((GameCont.loops > 0) ? 5 : 0)],
					[seal_deadeye,     ((GameCont.loops > 0) ? 3 : 0)]
				]);
				
				 // Launchin:
				if(GameCont.loops > 0 && chance(1, 2)){
					with(call(scr.obj_create, x, y, "PalankingToss")){
						with(call(scr.instance_nearest_bbox, x, y, Floor)){
							other.direction = point_direction(other.x, other.y, bbox_center_x, bbox_center_y) + orandom(30);
						}
						speed        = 4 + random(4);
						creator      = other;
						depth        = other.depth;
						mask_index   = other.mask_index;
						spr_shadow_y = other.spr_shadow_y;
						
						 // FX:
						sound_play_pitchvol(sndSlugger, 1.5, 0.6);
						call(scr.fx, x, y, [point_direction(x, y, x, z) + orandom(30), 2 + random(2)], "WaterStreak");
						repeat(4) instance_create(x, y, Dust);
					}
				}
			}
		}
		
		 // Alert:
		if(seal_alert){
			seal_alert = false;
			with(call(scr.alert_create, self, spr.SealAlert)){
				blink     = 15;
				flash     = 6;
				snd_flash = sndOasisHorn;
			}
		}
	}
	
	 // Done:
	else{
		 // Reset Camera:
		for(var i = 0; i < maxp; i++){
			if(view_object[i] == self){
				view_object[i]     = noone;
				view_pan_factor[i] = null;
			}
		}
		
		instance_destroy();
	}
	
	
#define TrafficCrab_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle   = spr.CrabIdle;
		spr_walk   = spr.CrabWalk;
		spr_hurt   = spr.CrabHurt;
		spr_dead   = spr.CrabDead;
		spr_fire   = spr.CrabFire;
		spr_hide   = spr.CrabHide;
		spr_shadow = shd48;
		hitid      = [spr_idle, "TRAFFIC CRAB"];
		mask_index = mskScorpion;
		depth      = -2;
		
		 // Sound:
		snd_hurt = sndSpiderHurt;
		snd_dead = sndPlantTBKill;
		snd_mele = sndGoldScorpionMelee;
		
		 // Vars:
		active      = chance(1, 8);
		maxhealth   = 20;
		raddrop     = 10;
		size        = 2;
		meleedamage = 4;
		walk        = 0;
		walkspeed   = 1;
		maxspeed    = 2.5;
		gunangle    = random(360);
		direction   = gunangle;
		sweep_spd   = 10;
		sweep_dir   = right;
		ammo        = 0;
		
		 // Alarms:
		alarm1 = 30 + random(90);
		
		return self;
	}

#define TrafficCrab_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Inactive:
	if(!active){
		x           = xstart;
		y           = ystart;
		speed       = 0;
		image_index = 0;
		
		 // Disable Melee:
		canmelee = false;
		alarm11  = 30;
	}
	
	 // Animate:
	if(ammo > 0){
		sprite_index = spr_fire;
		image_index = 0;
	}
	else if(sprite_index == spr_idle || anim_end){
		var _spr = (active ? enemy_sprite : spr_hide);
		if(sprite_index != _spr){
			sprite_index = _spr;
			image_index  = 0;
		}
	}
	
#define TrafficCrab_draw
	var _hurt = (sprite_index == spr_hide && nexthurt >= current_frame + 4);
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	draw_self_enemy();
	if(_hurt) draw_set_fog(false, 0, 0, 0);

#define TrafficCrab_alrm1
	alarm1 = 30 + random(30);
	
	enemy_target(x, y);

	if(active){
		 // Spray Venom:
		if(ammo > 0){
			alarm1 = 2;
			enemy_walk(direction, 1);
			
			sound_play(sndOasisCrabAttack);
			sound_play_pitchvol(sndFlyFire, 2 + random(1), 0.5);
			
			 // Venom:
			var	_x = x + (right * (4 + (sweep_dir * 10))),
				_y = y + 4;
				
			repeat(choose(2, 3)){
				call(scr.projectile_create, _x, _y, "VenomPellet", gunangle + orandom(10), 10 + random(2));
			}
			gunangle += (sweep_dir * sweep_spd);
			
			 // End:
			if(--ammo <= 0){
				alarm1 = 30 + random(20);
				sprite_index = spr_idle;
				
				 // Move Towards Player:
				enemy_walk((instance_exists(target) ? target_direction : random(360)), 15);
				
				 // Switch Claws:
				sweep_dir *= -1;
			}
		}
		
		 // Normal AI:
		else{
			alarm1 = 35 + random(15);
			
			if(instance_exists(target) && target_visible){
				enemy_look(target_direction);
				
				 // Attack:
				if(target_distance < 128){
					enemy_walk(gunangle + (sweep_dir * random(90)), 1);
					
					alarm1    = 1;
					ammo      = 10;
					gunangle -= sweep_dir * (sweep_spd * (ammo / 2));
					
					sound_play_pitch(sndScorpionFireStart, 0.8);
					sound_play_pitch(sndGoldScorpionFire, 1.5);
				}
				
				 // Move Towards Player:
				else enemy_walk(
					gunangle + (random_range(20, 40) * choose(-1, 1)),
					30
				);
			}
			
			 // Passive Movement:
			else{
				enemy_walk(random(360), 10);
				enemy_look(direction);
			}
		}
	}
	
	 // Awaken:
	else if((instance_exists(target) && target_distance < 80) || chance(1, instance_number(enemy))){
		active = true;
		if(place_meeting(x, y, hitme)){
			enemy_walk(random(360), 4);
		}
		
		 // Effects:
		sound_play_hit(sndPlantSnareTB, 0.2);
		sound_play_hit(sndScorpionFire, 0.2);
		instance_create(x + (6 * right), y, AssassinNotice);
	}
	
#define TrafficCrab_hurt(_damage, _force, _direction)
	my_health -= _damage;
	nexthurt = current_frame + 6;
	motion_add(_direction, _force);
	sound_play_hit(snd_hurt, 0.3);

	 // Hurt Sprite:
	if(sprite_index != spr_hide){
		sprite_index = spr_hurt;
		image_index = 0;
	}

	 // Awaken Bro:
	active = true;

#define TrafficCrab_death
	pickup_drop(10, 10, 0);

	 // Splat:
	var _ang = random(360);
	for(var a = _ang; a < _ang + 360; a += (360 / 3)){
		with(instance_create(x, y, MeleeHitWall)){
			motion_add(a, 1);
			image_angle = direction + 180;
			image_blend = make_color_rgb(174, 58, 45);//make_color_rgb(133, 249, 26);
		}
	}


#define Trident_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.Trident;
		image_speed  = 0.4;
		
		 // Vars:
		mask_index         = msk.Trident;
		damage             = 40;
		force              = 5;
		typ                = 1;
		curse              = false;
	//	curse_return       = false;
		curse_return_delay = false;
		rotspeed           = 0;
		target             = noone;
		marrow_target      = noone;
		hit_time           = 0;
		hit_list           = -1;
		wep                = "trident";
		
		 // Alarms:
		alarm0 = 15;
		
		return self;
	}
	
#define Trident_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Custom I-Frames:
	hit_time += current_time_scale;
	
	 // Cursed:
	if(curse > 0){
		 // Cursed Trident Returns:
		//curse_return = (instance_exists(creator) && (variable_instance_get(creator, "wep") == wep || variable_instance_get(creator, "bwep") == wep));
		
		 // FX:
		if(visible && current_frame_active){
			instance_create(x + orandom(4), y + orandom(4), Curse);
		}
	}
	
	 // Break Projectiles:
	with(instances_matching_ne(instances_matching(projectile, "typ", 1, 2), "team", team)){
		if(object_index != PopoNade && distance_to_object(other) <= 8){
			sleep(2);
			instance_destroy();
		}
	}
	
	 // Bolt Marrow:
	if(speed > 0){
		if(skill_get(mut_bolt_marrow) > 0){
			var _target = marrow_target;
			if(!instance_exists(_target) || collision_line(x, y, _target.x, _target.y, Wall, false, false)){
				var	_x      = x + hspeed,
					_y      = y + vspeed,
					_disMax = 160;
					
				with(instances_matching_ne(instances_matching_ne(call(scr.instances_in_rectangle, _x - _disMax, _y - _disMax, _x + _disMax, _y + _disMax, [enemy, Player, Sapling, Ally, SentryGun, CustomHitme]), "team", team, 0), "mask_index", mskNone, sprVoid)){
					var _dis = point_distance(x, y, _x, _y);
					if(_dis < _disMax){
						if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
							if(!ds_map_valid(other.hit_list) || !ds_map_exists(other.hit_list, self) || other.hit_list[? self] <= other.hit_time){
								if(!array_length(instances_matching(PopoShield, "creator", self))){
									_disMax = _dis;
									other.marrow_target = self;
								}
							}
						}
					}
				}
			}
			else{
				rotspeed += (angle_difference(point_direction(x, y, _target.x, _target.y), direction) / max(1, 60 / (point_distance(x, y, _target.x, _target.y) + 1))) * min(1, 0.1 * skill_get(mut_bolt_marrow)) * current_time_scale;
				//rotspeed = clamp(rotspeed, -90, 90);
			}
			
			var _f = min(1, abs(rotspeed) / 90);
			x -= hspeed_raw * _f;
			y -= vspeed_raw * _f;
		}
		
		 // Rotatin:
		if(rotspeed != 0){
			direction += rotspeed * current_time_scale;
			image_angle += rotspeed * current_time_scale;
			rotspeed -= rotspeed * 0.3 * current_time_scale;
		}
	}
	
	else{
		 // Trident Return:
		if(
			curse > 0
			&& instance_exists(creator)
			&& (
				("wep"  in creator && creator.wep  == wep) ||
				("bwep" in creator && creator.bwep == wep)
			)
		){
			if(curse_return_delay < 6){
				 // Movin:
				var	_l = max(5, point_distance(x, y, creator.x, creator.y) * 0.1 * current_time_scale) / (curse_return_delay + 1),
					_d = point_direction(x, y, creator.x, creator.y);
					
				x += lengthdir_x(_l, _d);
				y += lengthdir_y(_l, _d);
				
				 // Walled:
				if(!place_free(x, y)){
					xprevious = x;
					yprevious = y;
					if(visible){
						visible = false;
						sound_play_pitch(sndCursedReminder, 1 + orandom(0.3));
						repeat(4) with(instance_create(x + orandom(8), y + orandom(8), Smoke)){
							motion_add(_d + 180, random(1));
						}
					}
				}
				else if(place_meeting(x, y, Floor)){
					if(!visible){
						visible = true;
						sound_play_pitch(sndSwapCursed, 1 + orandom(0.3));
						repeat(4) with(instance_create(x + orandom(8), y + orandom(8), Smoke)){
							motion_add(_d, random(2));
						}
					}
				}
				
				 // Rotatin:
				if(point_distance(x, y, creator.x, creator.y) < 40){
					_d += 180;
				}
				image_angle = angle_lerp_ct(image_angle, _d, 0.05 / (curse_return_delay + 1));
			}
			if(curse_return_delay <= 8){
				image_angle += orandom(2 + curse_return_delay) * current_time_scale;
			}
			
			var _f = 0.5 * current_time_scale;
			curse_return_delay -= clamp(curse_return_delay, -_f, _f);
			
			 // Grab Weapon:
			if(place_meeting(x, y, creator) || (creator.mask_index == mskNone && place_meeting(x, y, Portal))){
				instance_destroy();
			}
		}
		
		 // Stopped:
		else instance_destroy();
	}
	
#define Trident_end_step
	 // Trail:
	if(visible){
		var	_x1 = x,
			_y1 = y,
			_x2 = xprevious,
			_y2 = yprevious;
			
		with(instance_create(_x1, _y1, BoltTrail)){
			image_xscale = point_distance(_x1, _y1, _x2, _y2);
			image_angle  = point_direction(_x1, _y1, _x2, _y2);
			if(other.curse > 0){
				image_blend = make_color_rgb(235, 0, 67);
			}
			creator = other.creator;
			
			/*
			if(skill_get(mut_bolt_marrow)){
				image_blend = make_color_rgb(235, 0, 67);
				with(instance_copy(false)){
					image_yscale *= 2;
					image_alpha *= 0.15;
				}
			}
			*/
		}
	}
	
#define Trident_draw
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * max(2/3, 1 - (0.025 * abs(rotspeed) * min(1, speed_raw / 8))), image_yscale, image_angle + rotspeed, image_blend, image_alpha);
	
#define Trident_anim
	if(instance_exists(self)){
		image_speed = 0;
		image_index = 0;
	}
	
#define Trident_alrm0
	friction = 0.5; // Stop movin
	
#define Trident_hit
	if(speed > 0){
		if(!ds_map_valid(hit_list)){
			hit_list = ds_map_create();
		}
		var _firstHit = !ds_map_exists(hit_list, other);
		if(_firstHit || hit_list[? other] <= hit_time){
			hit_list[? other] = hit_time + 3;
			
			 // Damage:
			projectile_hit(other, damage, force);
			
			if(instance_exists(self)){
				 // Untarget:
				if(marrow_target == other){
					marrow_target = noone;
				}
				
				 // Keep Movin:
				if(_firstHit && speed > 12){
					speed = 18;
				}
				
				 // Stick:
				if(instance_exists(other) && other.my_health > 0){
					if("race" not in creator || creator.race != "chicken" || skill_get(mut_throne_butt) <= 0){
						sound_play_pitch(sndAssassinAttack, 2);
						target = other;
						speed = 0;
						
						 // Curse Return:
						if(curse > 0){
							curse_return_delay = 8 + random(2);
							mask_index = mskFlakBullet;
						}
					}
				}
				
				 // Impact:
				else if(rotspeed < 5){
					x -= hspeed / 3;
					y -= vspeed / 3;
				}
				var _f = clamp((("size" in other) ? other.size : 1), 1, 5);
				view_shake_at(x, y, 12 * _f);
				sleep(16 * _f);
			}
		}
	}
	
#define Trident_wall
	if(speed > 0){
		var _canWall = true;
		if(speed > 12){
			if(skill_get(mut_bolt_marrow) > 0 && !instance_exists(marrow_target)){
				Trident_step();
			}
			if(
				marrow_target != creator
				&& instance_exists(marrow_target)
				&& point_distance(x, y, marrow_target.x, marrow_target.y) < 160
				&& !collision_line(x, y, marrow_target.x, marrow_target.y, Wall, false, false)
			){
				var _angTurn = abs(angle_difference(image_angle, point_direction(x, y, marrow_target.x, marrow_target.y)));
				if(_angTurn >= 10 && _angTurn <= 160){
					_canWall = false;
				}
			}
		}
		
		 // Stick in Wall:
		if(_canWall){
			speed = 0;
			move_contact_solid(direction, 16);
			
			 // Curse Return:
			if(curse > 0){
				curse_return_delay = 8 + random(2);
				mask_index = mskFlakBullet;
			}
			
			 // Effects:
			instance_create(x, y, Debris);
			sound_play(sndBoltHitWall);
			sound_play_pitchvol(sndExplosionS, 1.5, 0.7);
			sound_play_pitchvol(sndBoltHitWall,  1, 0.7);
		}
		
		 // Marrow Homin on Target:
		else if(instance_exists(marrow_target)){
			direction = angle_lerp_ct(direction, point_direction(x, y, marrow_target.x, marrow_target.y), 0.25);
			image_angle = direction;
			alarm0 = min(alarm0, 1);
		}
	}
	
#define Trident_destroy
	 // Hit FX:
	var	_l = 18,
		_d = direction,
		_x = x + lengthdir_x(_l, _d),
		_y = y + lengthdir_y(_l, _d);
		
	with(instance_create(_x, _y, BubblePop)){
		image_index = 1;
	}
	repeat(3) call(scr.fx, 
		_x,
		_y,
		[direction + orandom(30), choose(1, 2, 2)],
		Bubble
	);
	
#define Trident_cleanup // pls why do portals instance_delete everything
	var _wep = wep;
	
	 // Destroy I-Frame Map:
	if(ds_map_valid(hit_list)){
		ds_map_destroy(hit_list);
	}
	
	 // Reactivate Trident:
	if(is_object(_wep)){
		_wep.visible = true;
	}
	
	 // Return to Player:
	if(
		curse > 0
		&& instance_exists(creator)
		&& (
			("wep"  in creator && creator.wep  == wep) ||
			("bwep" in creator && creator.bwep == wep)
		)
	){
		with(creator){
			if(instance_is(self, Player)){
				var _b = ((bwep == _wep) ? "b" : "");
				if(is_object(_wep)){
					_wep.wepangle = angle_difference(other.image_angle, gunangle)
					if(chance(1, 8)) _wep.wepangle += 360 * sign(_wep.wepangle);
					variable_instance_set(self, _b + "wepangle", _wep.wepangle);
				}
			}
			
			 // Effects:
			if(instance_is(self, Player)){
				with(instance_create(x, y, WepSwap)){
					creator = other;
				}
			}
			sound_play(weapon_get_swap(_wep));
			sound_play(sndSwapCursed);
		}
	}
	
	 // Drop Weapon:
	else if(_wep != wep_none){
		 // Delete Existing:
		with(instances_matching([WepPickup, ThrownWep], "wep", _wep)){
			instance_destroy();
		}
		
		 // Walled:
		if(!visible && !place_meeting(x, y, Floor)){
			with(call(scr.instance_nearest_bbox, x, y, Floor)){
				other.x = bbox_center_x;
				other.y = bbox_center_y;
				repeat(4) instance_create(other.x, other.y, Smoke);
			}
		}
		
		 // WepPickup:
		var _stickTarget = target;
		with(call(scr.obj_create, x, y, (instance_exists(_stickTarget) ? "WepPickupStick" : WepPickup))){
			rotation = other.image_angle;
			curse    = other.curse;
			wep      = _wep;
			
			 // Stick:
			if(instance_exists(_stickTarget)){
				stick_target = _stickTarget;
				stick_damage = other.damage;
				with(stick_target){
					var	_len = 24,
						_dir = other.rotation;
						
					if(max(bbox_width, bbox_height) > _len + 8){
						other.rotation = angle_lerp(_dir, point_direction(other.x, other.y, x, y), 1/2);
					}
					else{
						other.x = x - lengthdir_x(_len, _dir);
						other.y = y - lengthdir_y(_len, _dir);
					}
				}
				stick_x = x - _stickTarget.x;
				stick_y = y - _stickTarget.y;
			}
			
			 // Determination:
			if(ultra_get("chicken", 2) && instance_is(other.creator, Player) && other.creator.race == "chicken"){
				creator = other.creator;
				alarm0 = 30;
			}
		}
	}
	
	
/// GENERAL
#define ntte_step
	 // Harpoon Connections:
	var _ropeDraw = [[], []];
	if("ntte_harpoon_rope" in GameCont && array_length(GameCont.ntte_harpoon_rope)){
		with(GameCont.ntte_harpoon_rope){
			var	_rope  = self,
				_link1 = _rope.link1,
				_link2 = _rope.link2;
				
			if(instance_exists(_link1) && instance_exists(_link2)){
				if(_rope.broken < 0) _rope.length = 0; // Deteriorate Rope
				
				var	_length  = _rope.length,
					_linkDis = point_distance(_link1.x, _link1.y, _link2.x, _link2.y) - _length,
					_linkDir = point_direction(_link1.x, _link1.y, _link2.x, _link2.y);
					
				 // Pull Link:
				if(_linkDis > 0){
					var	_pullLink = [_link1, _link2],
						_pullInst = [];
						
					for(var i = 0; i < array_length(_pullLink); i++){
						with(_pullLink[i]) if(!instance_is(self, projectile)){
							var _inst = noone;
							
							 // Rope Attached to Harpoon:
							if(instance_is(self, BoltStick)){
								if(pull_speed != 0 && !instance_is(target, becomenemy)){
									_inst = target;
								}
							}
							
							 // Rope Directly Attached:
							else if(_link1 != _link2){
								if(
									(!instance_is(self, prop) && "team" in self && team != 0)
									|| instance_is(self, RadChest)
									|| instance_is(self, Car)
									|| instance_is(self, CarVenus)
									|| instance_is(self, CarVenusFixed)
								){
									_inst = self;
								}
							}
							
							 // Add to Pull List:
							if(instance_exists(_inst)){
								array_push(_pullInst, {
									inst : _inst,
									pull : (instance_is(_inst, Player) ? 0.5 : (("pull_speed" in self) ? pull_speed : 2)),
									drag : min(_linkDis / 3, 10 / (("size" in _inst) ? (max(_inst.size, 0.5) * 2) : 2)),
									dir  : _linkDir + (i * 180)
								});
							}
						}
					}
					
					 // Pull:
					if(array_length(_pullInst)){
						with(_pullInst){
							var	_pull = pull,
								_drag = drag,
								_dir  = dir;
								
							with(inst){
								hspeed += lengthdir_x(_pull, _dir);
								vspeed += lengthdir_y(_pull, _dir);
								x      += lengthdir_x(_drag, _dir);
								y      += lengthdir_y(_drag, _dir);
							}
						}
					}
				}
				
				 // Draw Rope:
				with(other){
					array_push(_ropeDraw[instance_exists(collision_line(_link1.x, _link1.y, _link2.x, _link2.y, Wall, false, false))], _rope);
				}
				
				 // Rope Stretching:
				with(_rope){
					break_force = max(_linkDis, 0);
					
					 // Break:
					if(break_timer <= 0 || break_force > 1000){
						if(break_force > 100 || (broken < 0 && _length <= 1)){
							if(broken >= 0){
								sound_play_pitch(sndHammerHeadEnd, 2);
							}
							Harpoon_unrope(self);
						}
					}
					else break_timer -= current_time_scale;
				}
			}
			else Harpoon_unrope(_rope);
		}
	}
	var i = 0;
	with(global.harpoon_rope_bind){
		with(id){
			inst = _ropeDraw[i++];
			if(array_length(inst)){
				visible = true;
			}
		}
	}
	
#define ntte_draw_shadows
	 // Shield Shadows:
	if(array_length(obj.ClamShield)){
		with(instances_matching(obj.ClamShield, "visible", true)){
			var	_l = -8 - (1 * image_yscale),
				_d = image_angle,
				_x = x + lengthdir_x(_l, _d) + spr_shadow_x,
				_y = y + lengthdir_y(_l, _d) + spr_shadow_y;
				
			draw_sprite_ext(spr_shadow, 0, _x, _y, image_yscale, image_xscale, image_angle + 90, c_white, 1);
		}
	}
	
#define ntte_draw_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
			
			var _gray = (_type == "normal");
			
			 // Divers:
			if(array_length(obj.Diver)){
				var _r = 16 + (24 * _gray);
				with(instances_matching_ne(obj.Diver, "id")){
					draw_circle(x, y, _r + orandom(1), false);
				}
			}
			
			break;
			
	}
	
#define draw_diver_laser
	if(array_length(obj.Diver)){
		if(lag) trace_time();
		
		var _inst = instances_matching_ne(obj.Diver, "laser", 0);
		if(array_length(_inst)){
			draw_set_color(c_white);
			with(_inst){
				var _alpha = 0.8 * laser;
				draw_set_alpha(_alpha);
				
				 // Main:
				var	_x     = x,
					_y     = y - 1.5,
					_angle = gunangle,
					_width = (1 + random(0.5)) * laser,
					_laser = call(scr.draw_lasersight, _x, _y, _angle, 1000, _width);
					
				 // Bloom:
				draw_set_alpha(0.2 * _alpha);
				draw_set_blend_mode(bm_add);
				draw_line_width(
					_x - 1,
					_y - 1,
					_laser[0] + lengthdir_x(2, _angle) - 1,
					_laser[1] + lengthdir_y(2, _angle) - 1,
					_width * 2
				);
				draw_set_blend_mode(bm_normal);
			}
			draw_set_alpha(1);
		}
		
		if(lag) trace_time(script[2]);
	}
	
#define draw_harpoon_rope
	if("inst" in self && array_length(inst)){
		if(lag) trace_time();
		
		with(inst){
			if(instance_exists(link1) && instance_exists(link2)){
				var	_x1  = link1.x,
					_y1  = link1.y + (("z" in link1) ? -abs(link1.z) : 0),
					_x2  = link2.x,
					_y2  = link2.y + (("z" in link2) ? -abs(link2.z) : 0),
					_wid = clamp(length / point_distance(_x1, _y1, _x2, _y2), 0.1, 2),
					_col = merge_color(c_white, c_red, (0.25 + clamp(0.5 - (break_timer / 15), 0, 0.5)) * clamp(break_force / 100, 0, 1));
					
				if(break_timer > 0){
					_wid += (max(1, _wid) - _wid) * min(break_timer / 15, 1);
				}
				
				draw_set_color(_col);
				draw_line_width(_x1, _y1, _x2, _y2, _wid);
			}
		}
		
		if(lag) trace_time(script[2]);
	}
	
#define portal_pickups()
	/*
		Activates manual portal pickup attraction
	*/
	
	with(global.portal_pickups_bind.id){
		visible = true;
		return self;
	}
	
#define portal_pickups_step
	if(visible){
		visible = false;
		
		 // Attract Pickups:
		if(instance_exists(Pickup) && !instance_exists(Portal) && instance_exists(Player)){
			var _pluto = skill_get(mut_plutonium_hunger);
			
			 // Normal Pickups:
			if(instance_exists(AmmoPickup) || instance_exists(HPPickup) || instance_exists(RoguePickup)){
				var _attractDis = 30 + (40 * _pluto);
				with(instances_matching_ne([AmmoPickup, HPPickup, RoguePickup], "id")){
					var _p = instance_nearest(x, y, Player);
					if(instance_exists(_p) && point_distance(x, y, _p.x, _p.y) >= _attractDis){
						var	_dis = 6 * current_time_scale,
							_dir = point_direction(x, y, _p.x, _p.y),
							_x = x + lengthdir_x(_dis, _dir),
							_y = y + lengthdir_y(_dis, _dir);
							
						if(place_free(_x, y)) x = _x;
						if(place_free(x, _y)) y = _y;
					}
				}
			}
			
			 // Rads:
			if(instance_exists(Rad) || instance_exists(BigRad)){
				var	_attractDis      = 80 + (60 * _pluto),
					_attractDisProto = 170;
					
				with(instances_matching([Rad, BigRad], "speed", 0)){
					var _proto = instance_nearest(x, y, ProtoStatue);
					if(
						!instance_exists(_proto)
						|| distance_to_object(_proto) >= _attractDisProto
						|| collision_line(x, y, _proto.x, _proto.y, Wall, false, false)
					){
						if(distance_to_object(Player) >= _attractDis){
							var _p = instance_nearest(x, y, Player);
							if(instance_exists(_p)){
								var	_dis = 12 * current_time_scale,
									_dir = point_direction(x, y, _p.x, _p.y),
									_x   = x + lengthdir_x(_dis, _dir),
									_y   = y + lengthdir_y(_dis, _dir);
									
								if(place_free(_x, y)) x = _x;
								if(place_free(x, _y)) y = _y;
							}
						}
					}
				}
			}
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