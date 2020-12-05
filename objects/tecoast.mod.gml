#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Palanking Camera Pan (During Pause Screen):
	global.palanking_pan = [0, 0];
	
	 // Harpoon Ropes:
	global.harpoon_rope_bind = [
		script_bind("HarpoonRopeDraw",    CustomDraw, script_ref_create(draw_harpoon_rope),  0, false),
		script_bind("HarpoonRopeDrawTop", CustomDraw, script_ref_create(draw_harpoon_rope), -9, false)
	];
	global.harpoon_rope = [];
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#define BloomingAssassin_create(_x, _y)
	with(instance_create(_x, _y, JungleAssassin)){
		 // Visual:
		spr_idle = spr.BloomingAssassinIdle;
		spr_walk = spr.BloomingAssassinWalk;
		spr_hurt = spr.BloomingAssassinHurt;
		spr_dead = spr.BloomingAssassinDead;
		
		return id;
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
		
		return id;
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
	
	enemy_target(x, y);
	
	 // Become Man:
	if(instance_near(x, y, target, 32) || (chance(1, 2) && instance_near(x, y, target, 128))){
		alarm1 = min(alarm1, 1);
		
		 // Intimidating:
		motion_add(point_direction(x, y, target.x, target.y), 4);
		scrRight(direction);
	}
	
#define BloomingAssassinHide_alrm1
	 // Assassin Time:
	var _inst = obj_create(x, y, "BloomingAssassin");
	with(["x", "y", "xstart", "ystart", "xprevious", "yprevious", "hspeed", "vspeed", "friction", "sprite_index", "image_index", "image_speed", "image_xscale", "image_yscale", "image_angle", "image_blend", "image_alpha", "spr_shadow", "spr_shadow_x", "spr_shadow_y", "hitid", "snd_hurt", "snd_dead", "maxhealth", "my_health", "raddrop", "size", "team", "right", "nexthurt", "canmelee", "meleedamage"]){
		variable_instance_set(_inst, self, variable_instance_get(other, self));
	}
	
	 // Effects:
	repeat(4){
		with(scrFX(x, y, 1 + random(2), choose(Dust, Feather))){
			sprite_index = sprLeaf;
		}
	}
	
	instance_delete(id);
	
#define BloomingAssassinHide_hurt(_hitdmg, _hitvel, _hitdir)
	alarm1 = min(alarm1, 1);
	enemy_hurt(_hitdmg, _hitvel / 2, _hitdir);
	
#define BloomingAssassinHide_death
	 // Bonus Rads:
	rad_drop(x, y, raddrop, direction, speed);
	
	
#define BloomingBush_create(_x, _y)
	with(instance_create(_x, _y, Bush)){
		 // Visual:
		spr_idle = spr.BloomingBushIdle;
		spr_hurt = spr.BloomingBushHurt;
		spr_dead = spr.BloomingBushDead;
		
		return id;
	}
	
	
#define BloomingCactus_create(_x, _y)
	with(instance_create(_x, _y, Cactus)){
		 // Visual:
		var s = irandom(array_length(spr.BloomingCactusIdle) - 1);
		spr_idle = spr.BloomingCactusIdle[s];
		spr_hurt = spr.BloomingCactusHurt[s];
		spr_dead = spr.BloomingCactusDead[s];
		
		return id;
	}
	
	
#define BuriedCar_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.BuriedCarIdle;
		spr_hurt = spr.BuriedCarHurt;
		spr_dead = mskNone;
		spr_shadow = mskNone;
		
		 // Sound:
		snd_hurt = sndHitMetal;
		
		 // Vars:
		size = 2;
		maxhealth = 20;
		my_floor = instance_nearest_bbox(x, y, Floor);
		
		return id;
	}
	
#define BuriedCar_step
	if(instance_exists(my_floor)){
		x = my_floor.x + 16;
		y = my_floor.y + 16;
	}
	else instance_destroy();
	
#define BuriedCar_death
	 // Explosion:
	repeat(2) instance_create(x + orandom(3), y + orandom(3), Explosion);
	repeat(2) instance_create(x + orandom(3), y + orandom(3), SmallExplosion);
	sound_play(sndExplosionCar);
	
	 // Break Floor:
	with(my_floor){
		repeat(4){
			instance_create(bbox_center_x + orandom(8), bbox_center_y + orandom(8), Debris);
		}
		with(instances_meeting(x, y, Detail)){
			if(place_meeting(x, y, other)){
				instance_destroy();
			}
		}
		instance_destroy();
	}
	
	
#define ClamShield_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.ClamShield;
		spr_shadow = shd16;
		spr_shadow_x = 0;
		spr_shadow_y = 7;
		
		 // Vars:
		mask_index = mskOldGuardianDeflect;
		creator = noone;
		damage = 0;
		force = 3;
		typ = 0;
		wep = "clam shield";
		
		 // Scripts:
		on_anim = [];
		on_wall = [];
		
		return id;
	}
	
#define ClamShield_step
	var	_wep  = variable_instance_get(creator, "wep", wep),
		_bwep = variable_instance_get(creator, "bwep", wep_none);
		
	if(instance_exists(creator) && creator.visible && (wep == _wep || _bwep == wep)){
		var	_shieldList = instances_matching(instances_matching(instances_matching(object_index, "name", name), "wep", wep), "creator", creator),
			_boltStick = instances_matching(BoltStick, "target", self),
			_b = ((wep == _bwep) ? "b" : "");
			
		 // Aim:
		if("gunangle" in creator){
			var	_shieldNum = array_length(_shieldList),
				_goalDir = creator.gunangle + (180 * ((array_find_index(_shieldList, id) - ((_shieldNum - 1) / 2)) / _shieldNum)),
				_lastDir = image_angle;
				
			if(wep == _bwep && wep_raw(_wep) == wep_raw(_bwep)){
				_goalDir += 180;
			}
			
			image_angle = angle_lerp(image_angle, _goalDir, (instance_is(creator, Player) ? 1/2 : 1/16) * current_time_scale);
			direction = image_angle;
			
			 // Manually Rotate BoltSticks:
			with(_boltStick){
				image_angle += other.image_angle - _lastDir;
			}
		}
		
		 // Follow Creator:
		var	l = 16 - min(4, variable_instance_get(creator, _b + "wkick", 0)),
			d = image_angle;
			
		x = creator.x + lengthdir_x(l, d);
		y = creator.y + lengthdir_y(l, d);
		xprevious = x;
		yprevious = y;
		depth = creator.depth - (y > creator.y);
		
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
	var	_xsc = image_xscale,
		_ysc = image_yscale,
		_ang = image_angle,
		_num = image_number,
		_shn = variable_instance_get(creator, "gunshine", 0),
		_off = (_num / 7) * _xsc,
		_surfScale = option_get("quality:main"),
		_surfW = 2 * (_off + max(
			abs(sprite_height),
			abs(sprite_width) + ceil((_num - 1) * 2/3 * _xsc)
		)),
		_surfH = _surfW;
		
	with(surface_setup(name + string(id), _surfW, _surfH, _surfScale)){
		var _dis = -6;
		x = other.x + lengthdir_x(_dis, _ang) - (w / 2);
		y = other.y + lengthdir_y(_dis, _ang) - (h / 2) + 5;
		free = true;
		
		 // Setup:
		if(
			reset
			|| abs(lq_get(self, "lastangle") - _ang) > 1
			|| lq_get(self, "lastshine") != _shn
		){
			reset = false;
			lastangle = _ang;
			lastshine = _shn;
			
			 // Draw 3D Shield:
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			
			with(other){
				 // Shield:
				for(var i = 0; i < _num; i++){
					var	_disOff = _off * (1 - sqr((i - ((_num - 1) / 3)) / ((_num - 1) / 2))),
						_x = (_surfW / 2) + lengthdir_x(_disOff, _ang),
						_y = (_surfH / 2) + lengthdir_y(_disOff, _ang) - (i * 2/3 * _xsc);
						
					draw_sprite_ext(sprite_index, i, _x * _surfScale, _y * _surfScale, _xsc * _surfScale * 1.5, _ysc * _surfScale, _ang, image_blend, 1);
				}
				
				 // Shine:
				draw_set_color_write_enable(true, true, true, false);
				draw_sprite_ext(spr.Shine24, _shn, (_surfW / 2) * _surfScale, (_surfH / 2) * _surfScale, _xsc * _surfScale, _ysc * _surfScale, 0, image_blend, 1);
				draw_set_color_write_enable(true, true, true, true);
			}
			
			surface_reset_target();
		}
		
		/// Draw Shield:
			draw_set_alpha(other.image_alpha);
			
			 // Outline:
			draw_set_fog(true, c_black, 0, 0);
			for(var i = 0; i < 360; i += 90){
				draw_surface_scale(surf, x + dcos(i), y + dsin(i), 1 / scale);
			}
			draw_set_fog(false, 0, 0, 0);
			
			 // Normal:
			draw_surface_scale(surf, x, y, 1 / scale);
			
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
							speed += friction * 3;
							direction = _deflectDir - clamp(angle_difference(direction + 180, _deflectDir), -40, 40);
							image_angle = direction;
							if(instance_is(other.creator, Player)){
								deflected = true;
								team = other.team;
							}
						}
						
						 // Effects:
						sound_play_hit_ext(sndCrystalRicochet, 1 + random(0.2), 3);
						with(instance_create(x, y, Deflect)){
							image_angle = _deflectDir;
						}
						if(chance(1, 2) && chance(force, 12)){
							scrFX(x, y, [image_angle + orandom(10), random_range(1, 3)], Bubble);
						}
						else{
							instance_create(x, y, Dust);
						}
						sleep(min(100, damage));
						
						 // Destroyables:
						if(_typ == 2){
							 // Bolts Stick:
							if(array_exists([sprBolt, sprBoltGold, sprHeavyBolt, sprUltraBolt, sprSplinter, sprSeeker], sprite_index)){
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
		
		return id;
	}
	
	
#define CoastBigDecal_create(_x, _y)
	with(obj_create(_x, _y, "CoastDecal")){
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
		size = 4;
		shell = true;
		
		return id;
	}
	
	
#define CoastDecal_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		var t = irandom(array_length(spr.RockIdle) - 1);
		spr_idle = spr.RockIdle[t];
		spr_hurt = spr.RockHurt[t];
		spr_dead = spr.RockDead[t];
		spr_bott = spr.RockBott[t];
		spr_foam = spr.RockFoam[t];
		spr_shadow = mskNone;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = sndWallBreakRock;
		
		 // Vars:
		mask_index = mskBandit;
		maxhealth = 50;
		size = 3;
		shell = false;
		
		 // Offset:
		x += orandom(10);
		y += orandom(10);
		xstart = x;
		ystart = y;
		
		 // Doesn't Use Coast Wading System:
		canwade = false;
		
		return id;
	}
	
#define CoastDecal_step
	 // Space Out Decals:
	if(place_meeting(x, y, CustomProp)){
		with(instances_meeting(x, y, instances_matching_le(instances_matching(CustomProp, "name", "CoastDecal", "CoastBigDecal"), "size", size))){
			var	_dir = point_direction(other.x, other.y, x, y),
				_dis = 8;
				
			do{
				x += lengthdir_x(_dis, _dir);
				y += lengthdir_y(_dis, _dir);
			}
			until (!place_meeting(x, y, other) && !position_meeting(x, y, Floor));
			
			xstart = x;
			ystart = y;
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
	with(obj_create(x, y, "CoastDecalCorpse")){
		sprite_index = other.spr_dead;
		spr_bott     = other.spr_bott;
		spr_foam     = other.spr_foam;
		image_xscale = other.image_xscale;
		if(other.shell){
			depth -= 2;
			with(my_floor) mask_index = mskSalamander;
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
			my_floor = instance_create(x + _off, y, Floor);
			with(my_floor){
				x = other.x;
				y = other.y;
				instance_change(FloorExplo, false);
				mask_index = mskAlly;
				visible = false;
				material = 2;
			}
			_off += 100;
		}
		until instance_exists(my_floor);
		
		return id;
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
		right      = choose(-1, 1);
		walk       = 0;
		walkspeed  = 1.2;
		maxspeed   = 2.6;
		canwade    = false;
		scared     = false;
		
		 // Alarms:
		alarm1 = 30;
		
		return id;
	}

#define Creature_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Run away when hurt:
	if nexthurt > current_frame && !scared{
		scared = true;
		instance_create(x+right*65,y-24,AssassinNotice);
	}

	 // Pushed away from floors:
	if(instance_near(x, y, Floor, 128)){
		with(instance_nearest_bbox(x, y, Floor)){
			var _dir = point_direction(bbox_center_x, bbox_center_y, other.x, other.y);
			with(other) motion_add_ct(_dir, 3);
		}
	}

	 // Push Player:
	if(place_meeting(x, y, Player)){
		with(Player) if(place_meeting(x, y, other)){
			motion_add_ct(point_direction(other.x, other.y, x, y), 3);
		}
	}
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Animate:
	sprite_index = enemy_sprite;

#define Creature_draw
	draw_self_enemy();

#define Creature_alrm1
	alarm1 = 30;
	if instance_exists(Player){
		 // finds the nearest wading player
		var	_p = noone,
			_bigdist = 10000;
		with(Player) if(!collision_line(x, y, other.x, other.y, Floor, false, false)){
			var _distance = point_distance(x,y,other.x,other.y);
			if _distance < _bigdist{
				_p = self;
				_bigdist = _distance;
			}
		}
		if !scared{
			if instance_exists(_p){
				 // investigate wading player
				if(!instance_near(x, y, _p, 128)){
					scrWalk(point_direction(x, y, _p.x, _p.y), [20, 30]);
				}
				else if(chance(1, 4)){
					instance_create(x + (65 * right), y - 24, HealFX);
				}
				scrRight(point_direction(x, y, _p.x, _p.y));
			}
			else{
				 // wander
				scrWalk(direction + random(20), [20, 30]);
			}
		}
		else{
			if instance_exists(_p)
				scrWalk(point_direction(_p.x, _p.y, x, y), 999999999);
			else{
				_p = instance_nearest(x,y,Player);
				scrWalk(point_direction(_p.x, _p.y, x, y), [20, 30]);
			}
		}
	}
	
	
#define Diver_create(_x, _y)
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
		var _water = area_get_underwater(GameCont.area);
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
		laser_draw = noone;
		
		 // Alarms:
		alarm1 = 90 + irandom(90);
		
		return id;
	}

#define Diver_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Animate:
	sprite_index = enemy_sprite;
	
	 // Reloading Effects:
	if(reload > 0){
		reload -= current_time_scale;
		
		if(in_range(reload, 6, 12)){
			wkick += ((6 - wkick) * 3/5) * current_time_scale;
		}
		
		else if(reload <= 0){
			alarm1 = max(alarm1, 30)
			wkick = -2;
			sound_play_hit(sndCrossReload, 0.1);
			
			var	l = 8,
				d = gunangle;
				
			instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), WepSwap);
		}
	}
	
	 // Laser Sight:
	laser += (gonnafire - laser) * 0.3 * current_time_scale;
	if(laser > 0 && variable_instance_get(self, "wading", 0) > 0){
		if(!instance_exists(laser_draw)){
			laser_draw = script_bind_draw(Diver_draw_laser, depth - 1, id);
		}
	}
	else if(instance_exists(laser_draw)){
		with(laser_draw) instance_destroy();
	}
	
#define Diver_draw
	var _back = (gunangle <= 180 || instance_exists(laser_draw));
	
	 // Gun Behind:
	if(_back) Diver_draw_wep();
	
	 // Self:
	draw_self_enemy();
	
	 // Tree:
	with(instances_matching(instances_matching(CustomProp, "name", "Palm"), "creator", id)){
		draw_self();
	}
	
	 // Laser Sight:
	if(instance_exists(laser_draw)){
		laser_draw.x = x;
		laser_draw.y = y;
	}
	else Diver_draw_laser(id);
	
	 // Gun Above:
	if(!_back) Diver_draw_wep();
	
#define Diver_alrm1
	alarm1 = 60 + irandom(30);
	
	 // Breath:
	if(area_get_underwater(GameCont.area)){
		with(instance_create(x, y, Bubble)){
			speed /= 3;
		}
	}
	
	 // Shooty Harpoony:
	if(gonnafire){
		gonnafire = false;
		
		projectile_create(x, y, "DiverHarpoon", gunangle, 14);
		sound_play(sndCrossbow);
		
		alarm1 = 20 + random(30);
		reload = 90 + random(30);
		wkick = 8;
	}
	
	else{
		if(enemy_target(x, y) && instance_seen(x, y, target)){
			scrAim(point_direction(x, y, target.x + target.hspeed, target.y + target.vspeed));
			
			if(instance_near(x, y, target, [64, 320]) || array_length(instances_matching(instances_matching(CustomProp, "name", "Palm"), "creator", id)) > 0){
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
						scrWalk(gunangle + choose(-90, 90) + orandom(10), 10);
					}
				}
			}
			
			 // Move Away From Target:
			else{
				alarm1 = 20 + irandom(30);
				scrWalk(gunangle + 180 + orandom(30), [15, 30]);
			}
			
			 // Go to Nearest Non-Pit Floor:
			if(array_length(instances_matching(Floor, "sprite_index", spr.FloorTrenchB)) > 0){
				var f = instance_nearest_bbox(x + (hspeed * 4), y + (vspeed * 4), instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB));
				if(!place_meeting(x, y, f) && instance_exists(f)){
					direction = point_direction(x, y, f.x, f.y) + orandom(20);
				}
			}
		}
		
		 // Wander:
		else{
			scrWalk(random(360), 30);
			scrAim(direction);
		}
	}
	
#define Diver_death
	pickup_drop(20, 0);
	
#define Diver_cleanup
	with(laser_draw) instance_destroy();
	
#define Diver_draw_wep
	 // Bolt:
	if(reload < 6){
		var	_ox = 6 - (wkick + reload),
			_oy = -right,
			_x = x + lengthdir_x(_ox, gunangle) + lengthdir_x(_oy, gunangle - 90),
			_y = y + lengthdir_y(_ox, gunangle) + lengthdir_y(_oy, gunangle - 90);
			
		draw_sprite_ext(sprBolt, 1, _x, _y, 1, right, gunangle, image_blend, image_alpha);
	}
	
	 // Weapon:
	draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
	
#define Diver_draw_laser(_inst)
	with(_inst){
		draw_set_color(c_white);
		draw_set_alpha(0.8 * laser);
		
		 // Main:
		var	_x = other.x - 1,
			_y = other.y - 3,
			_angle = gunangle,
			_width = (1 + random(0.5)) * laser,
			_laser = draw_lasersight(_x, _y, _angle, 1000 * laser, _width);
			
		 // Bloom:
		draw_set_alpha(draw_get_alpha() * 0.2);
		draw_set_blend_mode(bm_add);
		draw_line_width(
			_x,
			_y,
			_laser[0] + lengthdir_x(2, _angle),
			_laser[1] + lengthdir_y(2, _angle),
			_width * 2
		);
		
		draw_set_blend_mode(bm_normal);
		draw_set_alpha(1);
	}
	
	
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
		
		return id;
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
	if(speed > 0 && projectile_canhit(_inst) && variable_instance_get(other, "creator") != creator){
		projectile_hit(_inst, damage, force, direction);
		
		 // Stick in Player:
		with(instance_create(x, y, BoltStick)){
			image_angle = other.image_angle;
			target = _inst;
		}
		instance_destroy();
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
		
		return id;
	}
	
#define Gull_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Animate:
	sprite_index = enemy_sprite;
	
#define Gull_draw
	if(gunangle <= 180) draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);
	draw_self_enemy();
	if(gunangle >  180) draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, 1, image_blend, image_alpha);
	
#define Gull_alrm1
	alarm1 = 40 + irandom(30);
	
	if(enemy_target(x, y) && instance_seen(x, y, target)){
		scrAim(point_direction(x, y, target.x, target.y));
		
		 // Target Nearby:
		if(instance_near(x, y, target, [10, 480])){
			 // Attack:
			if(instance_near(x, y, target, 60)){
				alarm2 = 8;
				instance_create(x, y, AssassinNotice);
				sound_play_pitch(sndRavenScreech, 1.15 + random(0.1));
			}
			
			 // Move Toward Target:
			else{
				alarm1 = 40 + irandom(10);
				scrWalk(gunangle + orandom(20), [20, 35]);
			}
		}
		
		 // Move Toward Target:
		else{
			alarm1 = 30 + irandom(10);
			scrWalk(gunangle + orandom(20), [10, 30]);
		}
	}
	
	 // Wander:
	else{
		scrWalk(random(360), 30);
		scrAim(direction);
	}
	
#define Gull_alrm2
	 // Slash:
	scrAim(point_direction(x, y, target.x, target.y) + orandom(10));
	with(projectile_create(x, y, EnemySlash, gunangle, 4)){
		damage = 2;
	}
	sound_play(sndChickenSword);
	motion_add(gunangle, 4);
	wepangle *= -1;
	wkick = -3;
	
	
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
		setup      = true;
		
		return id;
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
			other.corpses = array_delete_value(other.corpses, self);
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
			var n = instance_nearest_array(x, y, instances_matching_ne(instances_matching_ne(hitme, "team", team, 0), "mask_index", mskNone, sprVoid));
			if(distance_to_object(n) < (16 * skill_get(mut_bolt_marrow))){
				if(!place_meeting(x, y, n)){
					if(instance_seen(x, y, n)){
						direction = point_direction(x, y, n.x, n.y);
						image_angle = direction;
					}
				}
			}
		}
		
		 // Skewer Corpses:
		if(place_meeting(x, y, Corpse)){
			with(instances_meeting(x, y, instances_matching_ne(instances_matching_gt(Corpse, "speed", 1), "mask_index", -1))){
				if(place_meeting(x, y, other)){
					var c = id;
					with(other){
						if(array_find_index(corpses, c) < 0){
							if(sprite_get_width(c.sprite_index) < 64 && sprite_get_height(c.sprite_index) < 64){
								var _canTake = true;
								with(instances_matching(object_index, "name", name)){
									if(array_find_index(corpses, c) >= 0){
										_canTake = false;
										break;
									}
								}
								
								if(_canTake){
									 // Skewer:
									array_push(corpses, c);
									if(hspeed != 0){
										c.image_xscale = -sign(hspeed);
									}
									speed = max(speed - (3 * (1 + c.size)), 12);
									
									 // Effects:
									view_shake_at(x, y, 6);
									with(instance_create(c.x, c.y, ThrowHit)){
										motion_add(other.direction + orandom(30), 3);
										image_speed = random_range(0.8, 1);
										image_xscale = min(0.5 * (c.size + 1), 1);
										image_yscale = image_xscale;
									}
									sound_play_pitchvol(sndChickenThrow,   0.4 + random(0.2), 3);
									sound_play_pitchvol(sndGrenadeShotgun, 0.6 + random(0.2), 0.3 + (0.2 * c.size));
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
		projectile_hit_push(other, damage, force);
		
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
		typ = 0;
		
		 // Deteriorate Rope if Both Harpoons Stuck:
		if(array_length(rope) > 0){
			with(rope){
				if(harpoon_stuck && array_length(instances_matching_ne([link1, link2], "object_index", CustomProjectile)) <= 0){
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
		with(obj_create(x, y, "HarpoonPickup")){
			motion_add(other.direction, other.speed / 2);
			image_yscale = other.image_yscale;
			image_angle  = other.image_angle;
			target       = other.target;
		}
	}
	
	 // Stick in Object:
	else if(instance_exists(target)){
		var _harpoon = id;
		with(obj_create(x, y, "HarpoonStick")){
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
				if(array_length(instances_matching_gt([link1, link2], "pull_speed", 0)) <= 0){
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
	var _rope = {
		link1         : _link1,
		link2         : _link2,
		length        : 0,
		harpoon_stuck : false,
		break_force   : 0,
		break_timer   : 45 + random(15),
		creator       : noone,
		broken        : false
	}
	
	array_push(global.harpoon_rope, _rope);
	
	with([_link1, _link2]){
		if("rope" in self){
			array_push(rope, _rope);
			if(!instance_exists(creator) && "creator" in self){
				_rope.creator = creator;
			}
		}
	}
	
	return _rope;
	
#define Harpoon_unrope(_rope)
	with(_rope){
		broken = true;
		global.harpoon_rope = array_delete_value(global.harpoon_rope, self);
		
		 // Turn Harpoons Into Pickups:
		with([link1, link2]) if("name" in self){
			if(object_index == CustomProjectile && name == "Harpoon"){
				pickup = true;
			}
			else if(object_index == BoltStick && name == "HarpoonStick"){
				with(obj_create(x, y, "HarpoonPickup")){
					image_yscale = other.image_yscale;
					image_angle  = other.image_angle;
					target       = other.target;
				}
				instance_destroy();
			}
		}
	}
	
	
#define HarpoonStick_create(_x, _y)
	with(instance_create(_x, _y, BoltStick)){
		 // Visual:
		sprite_index = spr.Harpoon;
		image_index = 0;
		
		 // Vars:
		pull_speed = 2;
		rope = [];
		
		return id;
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
		
		return id;
	}
	
#define NetNade_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Baseball:
	if(place_meeting(x, y, projectile)){
		var _inst = instances_meeting(x, y, [Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash]);
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
		lasthit = other;
		projectile_hit_push(other, damage, force);
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
	repeat(8) scrFX(x, y, 1 + random(2), Dust);
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
		
		var	_x = x + lengthdir_x(_dis, _dir),
			_y = y + lengthdir_y(_dis, _dir),
			_off = 0;
			
		 // Minor Homing on Nearest Enemy:
		with(instance_nearest_array(
			_x + lengthdir_x(3 * _spd, _dir),
			_y + lengthdir_y(3 * _spd, _dir),
			instances_matching_ne(enemy, "team", team)
		)){
			_off = angle_difference(point_direction(other.x, other.y, x, y), _dir);
			if(abs(_off) >= (360 / _num) / 2){
				_off = 0;
			}
		}
		
		 // Harpoon:
		with(projectile_create(_x, _y, "Harpoon", _dir + _off, _spd)){
			 // Explosion FX:
			with(instance_create(x, y, MeleeHitWall)){
				motion_add(other.direction, 1 + random(2));
				image_angle = direction + 180;
				image_speed = 0.6;
			}
			
			 // Link harpoons to each other:
			if(!instance_exists(_first)){
				_first = id;
			}
			if(instance_exists(other.lasthit)){
				Harpoon_rope(id, other.lasthit);
			}
			else{
				if(instance_exists(_link)) Harpoon_rope(id, _link);
				_link = id;
			}
		}
	}
	if(instance_exists(_link)){
		Harpoon_rope(_first, _link);
	}
	
	
#define Palanking_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
		 // For Sani's bosshudredux:
		bossname = "PALANKING";
		col = c_red;
		
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
		maxhealth    = boss_hp(260);
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
		intro_pan_x  = x;
		intro_pan_y  = y;
		seal         = [];
		seal_x       = [];
		seal_y       = [];
		seal_max     = 4 + GameCont.loops;
		seal_spawn   = [];
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
		
		return id;
	}

#define Palanking_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	if(alarm3_run) exit;
	
	 // Movement:
	if(z <= 0) walk = 0;
	enemy_walk(walkspeed, maxspeed);
	
	 // Seals:
	var	_sealNum = (seal_max - array_count(seal, noone)),
		_holdx = seal_x,
		_holdy = seal_y,
		_holding = [0, 0];
		
	for(var i = 0; i < array_length(seal); i++){
		if(instance_exists(seal[i])){
			var	_x = _holdx[i] + (1.5 * right),
				_y = _holdy[i];
				
			with(seal[i]){
				if(hold){
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
			with(instances_matching(CustomEnemy, "name", "Seal")){
				if(!array_exists(other.seal, id)){
					seal_add(other, id);
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
			for(var i = 0; i < 2; i++) if(_holding[i] <= 0){
				for(var j = 0; j < array_length(seal); j++){
					if(seal[j] != noone && ((j + !i) % 2)){
						if(chance(1, 3)){
							var s = seal[j];
							seal[j] = noone;
							
							var o = (2 * !i) - 1;
							if(j + o < 0) o = 1;
							if(j + o >= array_length(seal)) o = -1;
							seal[j + o] = s;
						}
					}
				}
			}
			
			 // Lifted Up:
			if(zgoal == 0) zgoal = 12;
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
				if(instance_number(enemy) - (instance_number(Van) + array_length(instances_matching(Seal, "type", 0))) <= 1){
					if(array_length(seal_spawn) <= 0){
						alarm0 = 30;
						phase++;
					}
				}
			}
		}
		
		if(instance_exists(Player) && intro_pan > 15){
			 // Freeze Things:
			if(current_frame_active){
				with(instances_matching([WantRevivePopoFreak, VanSpawn, IDPDSpawn], "", null)){
					for(var i = 0; i <= 1; i++){
						var _alarm = alarm_get(i);
						if(_alarm > 0){
							alarm_set(i, _alarm + 1);
						}
					}
				}
				with(Seal){
					var _alarm = alarm_get(1);
					if(_alarm > 0){
						alarm_set(1, _alarm + 1);
					}
				}
			}
			
			 // Just in case:
			with(instances_matching_ne(enemy, "name", "Palanking", "Seal", "SealHeavy")){
				my_health = 0;
			}
			
			 // Attract Pickups:
			portal_pickups();
		}
	}
	
	 // Pan Intro Camera:
	if(intro_pan > 0){
		intro_pan -= min(1, current_time_scale);
		
		 // Pan:
		global.palanking_pan = [
			point_direction(x, y, intro_pan_x, intro_pan_y),
			point_distance(x, y, intro_pan_x, intro_pan_y) / 1.5
		];
		
		 // Still Camera:
		for(var i = 0; i < maxp; i++){
			view_object[i] = id;
			view_pan_factor[i] = 10000;
			if(intro_pan <= 0){
				view_pan_factor[i] = null;
			}
		}
		
		 // Hold Off Seals:
		with(Seal){
			attack_delay = 15 + random(30);
		}
	}
	else{
		global.palanking_pan = [0, 0];
		for(var i = 0; i < maxp; i++){
			if(view_object[i] == id){
				view_object[i] = noone;
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
				if(zspeed < -5){
					alarm2 = 1;
					sound_play_hit_big(sndBigBanditMeleeHit, 0.3);
				}
				
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
	
	 // Spawn Seals:
	with(seal_spawn){
		if(num > 0){
			if(delay > 0) delay -= current_time_scale;
			else{
				num--;
				delay = max(4 - (GameCont.loops * 0.5), 2) * random_range(1, 2);
				
				sound_play_pitch(choose(sndOasisHurt, sndOasisMelee, sndOasisShoot, sndOasisChest, sndOasisCrabAttack), 0.8 + random(0.4));
				
				 // Seal:
				var	_dis = 16 + random(24),
					_dir = (num * 90) + orandom(40),
					_x = x + lengthdir_x(_dis, _dir),
					_y = y + lengthdir_y(_dis, _dir),
					o = obj_create(_x, _y, (chance(1, 16) ? "SealHeavy" : "Seal"));
					
				 // Seal Vars:
				o.creator = other;
				with(o){
					 // Rads:
					creator.raddrop -= raddrop;
					raddrop = clamp(raddrop + creator.raddrop, 0, raddrop);
					
					 // Randomize Type:
					if(name == "Seal"){
						var _pick = [];
						for(var i = 0; i < array_length(seal_chance); i++){
							if(seal_chance[i] > 0) repeat(seal_chance[i]){
								array_push(_pick, i);
							}
						}
						type = _pick[irandom(array_length(_pick) - 1)];
						
						 // Launchin:
						if(GameCont.loops > 0 && chance(1, 2)){
							with(obj_create(x, y, "PalankingToss")){
								with(instance_nearest_bbox(x, y, Floor)){
									other.direction = point_direction(other.x, other.y, bbox_center_x, bbox_center_y) + orandom(30);
								}
								speed        = 4 + random(4);
								creator      = other;
								depth        = other.depth;
								mask_index   = other.mask_index;
								spr_shadow_y = other.spr_shadow_y;
								
								 // FX:
								sound_play_pitchvol(sndSlugger, 1.5, 0.6);
								scrFX(x, y, [point_direction(x, y, x, z) + orandom(30), 2 + random(2)], "WaterStreak");
								repeat(4) instance_create(x, y, Dust);
							}
						}
					}
					
					 // Important Stuff:
					if(creator.active) kills = 0;
					array_push(mod_variable_get("area", "coast", "sea_inst"), id);
				}
				
				 // Alert:
				if(alert){
					alert = false;
					with(other){
						var _other = other;
						with(alert_create(noone, spr.SealAlert)){
							x = _other.x;
							y = _other.y - 16;
							flash = 6;
							blink = 15;
							snd_flash = sndOasisHorn;
						}
					}
				}
			}
		}
		else with(other){
			seal_spawn = array_delete_value(seal_spawn, other);
		}
	}
	
#define Palanking_end_step
	with(instances_matching_ne(instances_matching_ne(instances_matching(seal, "hold", true), "hold_x", null), "hold_y", null)){
		if(mask_index != mskNone){
			x = other.x + hold_x;
			y = other.y + hold_y;
			xprevious = x;
			yprevious = y;
			hspeed = other.hspeed;
			vspeed = other.vspeed;
			depth = other.depth - (hold_y > 24 && hold);
		}
		else hold = false;
	}

#define Palanking_draw
	var h = ((nexthurt > current_frame + 3 && active) || (sprite_index == spr_hurt && image_index < 1));
	
	 // Palanquin Bottom:
	if(z > 4 || place_meeting(x, y, Floor)){
		if(h) draw_set_fog(true, image_blend, 0, 0);
		draw_sprite_ext(spr_bott, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
		if(h) draw_set_fog(false, 0, 0, 0);
	}
	
	 // Self:
	h = (h && sprite_index != spr_hurt);
	if(h) draw_set_fog(true, image_blend, 0, 0);
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
	if(h) draw_set_fog(false, 0, 0, 0);
	
#define Palanking_alrm0
	if(intro_pan <= 0){
		alarm0 = 60;
		alarm1 = 20;
		
		 // Enable Cinematic:
		intro_pan   = 10 + alarm0;
		intro_pan_x = x;
		intro_pan_y = y;
		
		 // "Safety":
		with(Player){
			instance_create(x, y, PortalShock);
		}
	}
	else{
		switch(phase){
			
			case 0: // Wave of Seals
				
				var	_delay = 20,
					_groups = 5;
					
				for(var d = 0; d < 360; d += (360 / _groups)){
					var	_x = 10016,
						_y = 10016,
						s = seal_wave(_x, _y, point_direction(_x, _y, x, y) + d, _delay);
						
					if(d == 0){
						intro_pan_x = s.x;
						intro_pan_y = s.y;
						intro_pan += _delay + (6 * s.num);
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
						
						seal_wave(x + lengthdir_x(_odis, _odir) + lengthdir_x(_dis, _dir), y + lengthdir_y(_odis, _odir) + lengthdir_y(_dis, _dir), _dir + 180, _delay);
						
						_delay += 10 + random(10);
					}
				}
				
				 // Seal Plop:
				//repeat(4) instance_create(other.x + x, other.y + y, Sweat);
				sound_play_pitch(choose(sndOasisHurt, sndOasisMelee, sndOasisShoot, sndOasisChest, sndOasisCrabAttack), 0.8 + random(0.4));
				
				 // Palanquin Holders:
				var _seal = obj_create(x, y, "Seal");
				seal_add(id, _seal);
				with(_seal){
					hold = true;
					creator = other;
					scared = true;
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
						boss_intro("Palanking");
						sound_play(sndBigDogIntro);
					}
					
					 // Walk Towards Player:
					if(enemy_target(x, y)){
						scrAim(point_direction(x, y, target.x, target.y));
						scrWalk(gunangle, 90);
					}
				}
				
				break;
				
		}
		
		 // Pan:
		if(phase > 0){
			if(intro_pan <= 0){
				intro_pan_x = x;
				intro_pan_y = y;
				intro_pan   = 10;
			}
			intro_pan += alarm0;
		}
	}
	
#define Palanking_alrm1
	if(intro){
		alarm1 = 40 + random(20);
		
		if(enemy_target(x, y) && instance_seen(x, y, target)){
			scrAim(point_direction(x, y, target.x, target.y));
			scrWalk(gunangle + orandom(30), 60);
			
			 // Kingly Slap:
			if(
				(instance_near(x, y, target, 80) && array_length(Seal) > 2)
				||
				(variable_instance_get(target, "reload", 0) > 0 && chance(1, 3))
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
				chance(1 + (z <= 0), 2)				&&
				chance(1, array_length(Seal) / 2)	&&
				array_length(Seal) <= seal_max * 4
			){
				alarm1 = 30 + random(10);
				
				image_index = 0;
				sprite_index = spr_call;
				sound_play(snd.PalankingCall);
				
				seal_wave(x, y, gunangle + orandom(30),       20 + random(20));
				seal_wave(x, y, gunangle + 180 + orandom(60), 20 + random(20));
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
		for(var a = 0; a < 360; a += (360 / 16)){
			 // Ground Smash Slash:
			with(projectile_create(_x + lengthdir_x(_dis, a), _y - 4 + lengthdir_y(_dis * 0.66, a), "PalankingSlashGround", a, 1)){
				team = -1;
			}
			
			 // Effects:
			if(chance(1, 4)){
				var o = 16;
				with(instance_create(_x + lengthdir_x(_dis + o, a), _y + lengthdir_y((_dis + o) * 0.66, a), MeleeHitWall)){
					motion_add(90 - (30 * dcos(a)), 1 + random(2));
					image_angle = direction + 180;
					image_speed = random_range(0.3, 0.6);
				}
			}
			repeat(irandom(2)){
				with(instance_create(_x + orandom(8) + lengthdir_x(_dis, a), _y - random(12) + lengthdir_y(_dis, a), Dust)){
					motion_add(a, random(5));
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
	projectile_create(x, y + 16 - z, "PalankingSlash", gunangle, 8);
	motion_add(gunangle, 4);
	
	 // Effects:
	sound_play(sndHammer);
	
#define Palanking_hurt(_hitdmg, _hitvel, _hitdir)
	nexthurt = current_frame + 6;	// I-Frames
	if(active){
		my_health -= _hitdmg;			// Damage
		motion_add(_hitdir, _hitvel);	// Knockback
		sound_play_hit(snd_hurt, 0.3);	// Sound
		
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
	var h = (maxhealth / 2);
	if(in_range(my_health, h - _hitdmg + 1, h)){
		if(snd_lowh == sndRocket) sound_play_pitch(snd_lowh, 0.5);
		else sound_play(snd_lowh);
		
		 // Extra FX:
		view_shake_at(x, y, 30);
		repeat(5) instance_create(x, y - z + 16, Debris);
	}
	
	 // Effects:
	if(instance_exists(other) && instance_is(other, projectile)){
		with(instance_create(other.x, other.y, Dust)){
			coast_water = 1;
			if(y > other.y + 12) depth = other.depth - 1;
		}
		if(chance(other.damage, 8)) with(other){
			sound_play_hit(sndHitRock, 0.3);
			with(instance_create(x, y, Debris)){
				motion_set(_hitdir + 180 + orandom(other.force * 4), 2 + random(other.force / 2));
			}
		}
	}
	
#define Palanking_death
	if(raddrop <= 0){
		raddrop = 40;
	}
	
	 // Epic Death:
	with(obj_create(x, y, "PalankingDie")){
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
	raddrop = 0;
	
	 // Boss Win Music:
	with(MusCont) alarm_set(1, 1);
	
#macro Seal instances_matching(CustomEnemy, "name", "Seal", "SealHeavy")

#define seal_wave(_xstart, _ystart, _dir, _delay)
	var s = {
		x     : _xstart,
		y     : _ystart,
		num   : seal_max,
		delay : _delay,
		alert : (intro_pan <= 0),
	};
	array_push(seal_spawn, s);
	
	 // Find Spawn Location:
	var _dis = 40 + random(16);
	if(instance_exists(Floor)){
		with(instance_create(s.x, s.y, GameObject)){
			while(distance_to_object(Floor) < _dis + 8 || distance_to_object(prop) < 32){
				x += lengthdir_x(12, _dir);
				y += lengthdir_y(12, _dir);
			}
			s.x = x;
			s.y = y;
			if(s.alert && point_seen(x, y, -1)){
				s.alert = false;
			}
			instance_destroy();
		}
	}
	
	return s;
	
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
		
		return id;
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
	with(corpse_drop(0, 0)){
		depth = 0;
	}
	
	 // Pickups:
	repeat(3) pickup_drop(50, 0);
	rad_drop(x, y + 16, raddrop, direction, speed);
	
	 // Smashin':
	var	_x = x,
		_y = y + 24,
		_dis = 24;
		
	for(var a = 0; a < 360; a += (360 / 16)){
		projectile_create(
			_x + lengthdir_x(_dis, a),
			_y - 4 + lengthdir_y(_dis * 0.66, a),
			"PalankingSlashGround",
			a,
			3 + random(1)
		);
		
		 // Effects:
		if(chance(1, 4)){
			var o = 16;
			with(instance_create(_x + lengthdir_x(_dis + o, a), _y + lengthdir_y((_dis + o) * 0.66, a), MeleeHitWall)){
				motion_add(90 - (30 * dcos(a)), 1 + random(2));
				image_angle = direction + 180;
				image_speed = random_range(0.3, 0.6);
			}
		}
		repeat(irandom(2)){
			with(instance_create(_x + orandom(8) + lengthdir_x(_dis, a), _y - random(12) + lengthdir_y(_dis, a), Dust)){
				motion_add(a, random(5));
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
		
		return id;
	}
	
#define PalankingSlash_step
	 // Launch Pickups:
	if(place_meeting(x, y, Pickup)){
		with(instances_meeting(x, y, instances_matching(Pickup, "mask_index", mskPickup))){
			if(place_meeting(x, y, other)){
				var s = other;
				with(obj_create(x, y, "PalankingToss")){
					direction  = angle_lerp(s.direction, point_direction(s.x, s.y, x, y), 1/3);
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
		if(instance_is(other, Player) || other.size <= 1){
			var p = other;
			with(obj_create(p.x, p.y, "PalankingToss")){
				direction    = angle_lerp(other.direction, point_direction(other.x, other.y, p.x, p.y), 1/3);
				speed        = 4;
				creator      = p;
				depth        = p.depth;
				mask_index   = p.mask_index;
				spr_shadow_y = p.spr_shadow_y;
			}
			with(other){
				if(instance_is(self, Player)) smoke = 6 + random(6);
				mask_index = mskNone;
			}
		}
		
		sound_play_pitchvol(sndHammerHeadEnd, 0.8, 0.5);
	}
	
#define PalankingSlash_projectile
	if(instance_exists(self)){
		with(other){
			if(typ == 1 || typ == 2){
				 // Deflect (No Team Change):
				if(typ == 1 && other.candeflect){
					direction = other.direction;
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
	with(obj_create(_x, _y, "PalankingSlash")){
		 // Visual:
		sprite_index = spr.GroundSlash;
		image_speed = 0.5;
		depth = 0;
		
		 // Vars:
		mask_index = -1;
		
		return id;
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
		
		return id;
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
		with(creator){
			 // Reset Vars:
			mask_index = other.mask_index;
			depth = other.depth;
			if("spr_shadow_y" in self) spr_shadow_y = other.spr_shadow_y;
			if("angle" in self) angle = 0;
			else image_angle = 0;
			
			 // Damage:
			if(instance_is(self, hitme) && (place_meeting(x, y, Floor) || GameCont.area != "coast")){
				projectile_hit(id, 1);
			}
			
			 // On Walls:
			if(!place_meeting(x, y, Floor) || place_meeting(x, y, Wall)){
				if(!place_meeting(x, y, Floor)){
					with(instance_nearest_bbox(x, y, Floor)){
						if(!instance_seen(bbox_center_x, bbox_center_y, other)){
							with(other){
								top_create(x, y, self, 0, 0);
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
				        team = other.team;
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
	
	
#define Palm_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.PalmIdle;
		spr_hurt = spr.PalmHurt;
		spr_dead = spr.PalmDead;
		spr_shadow = -1;
		depth = -3;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = sndHitPlant;
		
		 // Vars:
		mask_index = mskStreetLight;
		maxhealth = 30;
		size = 2;
		creator = noone;
		creator_mask = mskNone;
		
		 // Fortify:
		if(chance(1, 8)){
			creator = obj_create(x, y, "Diver");
			with(creator) depth = -3;
			
			spr_idle = spr.PalmFortIdle;
			spr_hurt = spr.PalmFortHurt;
			snd_dead = sndGeneratorBreak;
			maxhealth = 40;
		}
		
		return id;
	}
	
#define Palm_step
	 // Hold Bro:
	with(creator){
		x            = other.x;
		y            = other.y - 44;
		walk         = 0;
		speed        = 0;
		sprite_index = spr_idle;
		
		 // Disable Hitbox:
		if(mask_index != mskNone){
			other.creator_mask = mask_index;
			mask_index = mskNone;
		}
	}

#define Palm_death
	with(creator){
		y += 8;
		vspeed += 10;
		mask_index = other.creator_mask;
	}

	 // Leaves:
	repeat(15) with(instance_create(x + orandom(15), y - 30 + orandom(10), Feather)){
		sprite_index = sprLeaf;
		image_yscale = random_range(1, 3);
		motion_add(point_direction(other.x, other.y, x, y), 1 + random(1));
		vspeed += 2;
	}


#define Pelican_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)) {
		 // Visual:
		spr_idle     = spr.PelicanIdle;
		spr_walk     = spr.PelicanWalk;
		spr_hurt     = spr.PelicanHurt;
		spr_dead     = spr.PelicanDead;
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
		
		return id;
	}
	
#define Pelican_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Dash:
	if(dash > 0){
		dash -= current_time_scale;
		motion_add_ct(direction, dash * dash_factor);
		
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
	draw_weapon(spr_weap, x, y, gunangle, wepangle - _angOff, wkick, 1, image_blend, image_alpha);
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
		&& instance_seen(x, y, target)
		&& instance_near(x, y, target, 320)
	){
		scrAim(point_direction(x, y, target.x, target.y));
		
		 // Attack:
		if(((instance_near(x, y, target, 128) && chance(2, 3)) || chance(1, my_health)) && alarm2 < 0){
			alarm2 = chrg_time;
			alarm1 = alarm2 - 10;
			
			 // Move away a tiny bit:
			scrWalk(gunangle + 180 + orandom(10), 5);
			
			 // Warn:
			with(instance_create(x, y, AssassinNotice)){
				depth = -3;
			}
			sound_play_pitch(sndRavenHit, 0.5 + random(0.1));
		}
		
		 // Move Toward Target:
		else scrWalk(gunangle + orandom(10), [20, 30]);
	}
	
	 // Wander:
	else{
		alarm1 = 90 + random(30);
		scrWalk(random(360), [10, 15]);
		scrAim(direction);
	}
	
#define Pelican_alrm2
	alarm1 = 40 + random(20);
	
	 // Dash:
	dash = 12;
	motion_set(gunangle, maxspeed);
	
	 // Heavy Slash:
	with(projectile_create(x, y, EnemySlash, gunangle, (dash - 2) * dash_factor)){
		sprite_index = sprHeavySlash;
		friction     = 0.4;
		damage       = 10;
	}
	
	 // Misc. Visual/Sound:
	wkick = -10;
	wepangle = -wepangle;
	view_shake_at(x, y, 20); // Mmm that's heavy
	sound_play(sndEnergyHammer);
	sound_play_pitch(sndHammer, 0.75);
	sound_play_pitch(sndRavenScreech, 0.5 + random(0.1));
	
#define Pelican_hurt(_hitdmg, _hitvel, _hitdir)
	if(dash > 0) _hitvel = min(_hitvel, speed - 1);
	enemy_hurt(_hitdmg, _hitvel, _hitdir);
	
#define Pelican_death
	var _minID = GameObject.id;
	
	 // Pickups:
	pickup_drop(80, 0);
	pickup_drop(60, 5, 0);
	
	 // Hmm:
	with(instances_matching(instances_matching_gt(WepPickup, "id", _minID), "wep", wep_sledgehammer)){
		sprite_index = other.spr_weap;
		
		var	_dis = 16,
			_dir = rotation;
			
		with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), ThrowHit)){
			image_speed = 0.35;
		}
	}
	
	
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
		
		return id;
	}
	
#macro seal_none        0
#macro seal_hookpole    1
#macro seal_shield      2
#macro seal_blunderbuss 3
#macro seal_mercenary   4
#macro seal_deadeye     5
#macro seal_dasher      6
#macro seal_chance_loop (GameCont.loops > 0)
#macro seal_chance      [0, 8, 3, 5, 8*seal_chance_loop, 3*seal_chance_loop, 5*seal_chance_loop]

#define Seal_setup
	setup = false;
	
	var _lastSpwn = spr_spwn;
	
	 // Skeleton Seal:
	if(skeal){
		spr_idle = spr.SkealIdle;
		spr_walk = spr.SkealWalk;
		spr_hurt = spr.SkealHurt;
		spr_dead = spr.SkealDead;
		spr_spwn = spr.SkealSpwn;
		
		 // Sound:
		snd_hurt = sndMutant14Hurt;
		snd_dead = sndGatorDie;
		
		 // Vars:
		maxhealth = ceil(maxhealth * 2);
		my_health = ceil(my_health * 2);
		raddrop += 4;
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
	
	spr_weap = spr.SealWeap[type];
	hitid = [spr_idle, name];
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
	enemy_walk(walkspeed, maxspeed);
	
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
			if(alarm2 > 0) wkick += 2 * current_time_scale;
			
			 // Decrease wkick Faster:
			else if(wkick < 0){
				wkick -= (wkick / 20) * current_time_scale;
			}
			
			break;
			
		case seal_shield:
			
			 // Shield Mode:
			if(shield){
				if(!instance_exists(shield_inst)){
					shield_inst = projectile_create(x, y, "ClamShield", gunangle, 0);
					with(shield_inst){
						mask_index = sprWall0Out;
					}
				}
				/*
				 // Turn:
				var	m = random(10/3) * current_time_scale,
					t = clamp(angle_difference(gunangle, shield_ang) / 8, -m, m);
					
				shield_ang = (shield_ang + t + 360) % 360;
				
				 // Draw Shield:
				if(t != 0 && point_seen_ext(x, y, 16, 16, -1)){
					shield_draw = true;
				}
				
				 // Reflect Projectiles:
				var	o = 6,
					r = 12,
					_x = x + lengthdir_x(o, shield_ang),
					_y = y + lengthdir_y(o, shield_ang),
					b = r + 32;
					
				if(collision_circle(_x, _y, b, projectile, false, false)){
					with(instances_matching_ne(instances_matching_ne(instances_matching_gt(instances_matching_ne(instances_matching_ne(instance_rectangle(_x - b, _y - b, _x + b, _y + b, projectile), "team", team), "typ", 0), "speed", 0), "object_index", ToxicGas), "mask_index", mskNone, sprVoid)){
						if(abs(angle_difference(direction + 180, other.shield_ang)) < 80){
							if(point_in_circle(x + hspeed_raw, y + vspeed_raw, _x, _y, r + (speed_raw / 2))){
								other.wkick = 8 + orandom(1);
								speed += friction * 3;
								
								 // Knockback:
								if(force > 3){
									with(other) motion_add(shield_ang + 180, min(other.damage / 3, 3));
								}
								
								 // Reflect:
								var _reflectLine = other.shield_ang;
								direction = _reflectLine - clamp(angle_difference(direction + 180, _reflectLine), -40, 40);
								image_angle = direction;
								
								 // Effects:
								sound_play(sndShielderDeflect);
								with(instance_create(x, y, Deflect)) image_angle = _reflectLine;
								instance_create(x, y, Dust);
								
								 // Destroyables:
								if(typ == 2) instance_destroy();
							}
						}
					}
				}
				*/
			}
			
			 // Sword Stabby Mode:
			else if(instance_exists(shield_inst)){
				with(shield_inst) instance_destroy();
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
				var n = instance_nearest_bbox(x, y, Wall);
				if(instance_exists(n)){
					with(n) if(distance_to_point(other.x, other.y) < other.toss_speed + (max(other.toss.sprite_height, other.toss.sprite_width) / 2)){
						var _dir = point_direction(bbox_center_x, bbox_center_x, other.x, other.y);
						with(other) motion_add_ct(_dir, 1);
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
								scrFX(x, y, [direction + orandom(30), random_range(3, 5)], Dust);
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
					var l = (speed + other.wkick) - (speed_raw - friction_raw);
					x = other.x + lengthdir_x(l, direction);
					y = other.y + lengthdir_y(l, direction);
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
								with(scrFX(x, y, [direction + orandom(30), random_range(2, random(speed * 2/3))], Smoke)){
									image_xscale *= 2/3;
									image_yscale *= 2/3;
								}
							}
							sound_play_hit_ext(sndDiscDie, 0.6 + random(0.1), 2);
							sound_play_hit_ext(sndMeleeFlip, 0.8 + random(0.2), 3);
						}
					}
					
					 // Discin:
					if(instance_is(self, Disc)){
						dist = 0;
						alarm0 = max(alarm0, 9);
					}
					
					with(other) scrRight(other.direction);
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
				if(scared && array_length(instances_matching(CustomEnemy, "name", "Palanking")) <= 0){
					if(variable_instance_get(self, "wading", 0) > 0){
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
				if(current_frame_active) scrFX(x, y, [90, 1], Smoke);
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
		draw_weapon(spr_weap, x, y, gunangle, wepangle, wkick, ((wepangle == 0) ? right : sign(wepangle)), image_blend, image_alpha);
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
		var	_aimLast = gunangle,
			_canAttack = (attack_delay <= 0);
			
		scrAim(point_direction(x, y, target.x, target.y));
		
		if(instance_seen(x, y, target) || type == seal_none){
			 // Seal Types:
			switch(type){
				case seal_hookpole:
					
					alarm1 = 10 + random(15);
					
					 // Too Close:
					if(instance_near(x, y, target, 20)){
						scrWalk(gunangle + 180 + orandom(60), 10);
					}
					
					else{
						if(chance(4, 5)){
							 // Attack:
							if(_canAttack && instance_near(x, y, target, 70)){
								alarm1 = 30;
								alarm2 = 10;
								trident_dist = point_distance(x, y, target.x, target.y) - 24;
							}
							
							 // Too Far:
							else{
								scrWalk(gunangle + orandom(20), 10);
								if(chance(1, 10)) slide = 10;
							}
						}
						
						 // Side Step:
						else{
							scrWalk(gunangle + choose(-80, 80), 15);
							if(chance(1, 2)) slide = 5 + random(10);
						}
					}
					
					break;
					
				case seal_shield:
					
					 // Shield Defendy Mode:
					if(shield){
						alarm1 = 15 + irandom(5);
						
						 // Dagger Time:
						if(wkick == 0 && instance_near(x, y, target, 80)){
							scrWalk(gunangle + orandom(10), [4, 8]);
							
							shield = false;
							alarm1 = 20;
							
							 // Swap FX:
							var o = 8;
							instance_create(x + lengthdir_x(o, gunangle), y + lengthdir_y(o, gunangle), WepSwap);
							sound_play(sndSwapSword);
						}
						
						 // Reposition:
						else if(chance(2, 3)){
							scrWalk(gunangle + orandom(50), [6, 12]);
							scrAim(direction);
						}
					}
					
					 // Sword Stabby Mode:
					else{
						alarm1 = 20 + random(10);
						
						if(instance_near(x, y, target, 120)){
							scrWalk(gunangle + (180 * chance(1, 3)) + orandom(20), [5, 10]);
							
							 // Stabby:
							if(_canAttack && instance_near(x, y, target, 80)){
								with(projectile_create(x, y, Shank, gunangle, 3)){
									damage = 2;
								}
								motion_add(gunangle, 2);
								wepangle *= -1;
								wkick = -5;
								
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
							var	l = 8,
								d = gunangle;
								
							instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), WepSwap);
							sound_play(sndSwapHammer);
						}
					}
					
					break;
					
				case seal_blunderbuss:
					
					 // Slide Away:
					if(instance_near(x, y, target, 80)){
						direction = gunangle + 180;
						slide = 15;
						alarm1 = slide + random(10);
					}
					
					 // Good Distance Away:
					else{
						 // Aim & Ignite Powder:
						if(_canAttack && instance_near(x, y, target, 192) && chance(2, 3)){
							alarm1 = alarm1 + 90;
							alarm2 = 15;
							
							 // Effects:
							sound_play_pitchvol(sndEmpty, 2.5, 0.5);
							wkick = -2;
						}
						
						 // Reposition:
						else{
							scrWalk(gunangle + orandom(90), 10);
							if(chance(1, 2)) slide = 15;
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
					if(!instance_near(x, y, target, 160)){
						direction = gunangle + orandom(60);
						slide = 15;
						alarm1 = slide + random(20);
					}
					
					 // Within Range:
					else{
						scrWalk(gunangle + orandom(90), 15);
						
						 // Pew Time:
						if(_canAttack){
							alarm2 = 8;
							alarm1 = alarm2 + 5 + random(20);
							
							 // Preparin:
							wkick = -4;
							sound_play_hit_ext(sndShotReload, 1.5 + random(0.5), 1.2);
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
							scrWalk(gunangle + choose(-80, 80) + orandom(20), [4, 20]);
						}
						
						 // Toss Disc:
						else{
							toss_ammo--;
							toss_time = 60;
							toss_speed = random_range(7, 9);
							toss = projectile_create(x, y, "SealDisc", random(360), 0);
						}
					}
					
					if(instance_exists(toss)) alarm1 = 15;
					
					break;
					
				case seal_dasher:
					
					 // Move Away:
					if(instance_near(x, y, target, 32) || chance(1, 4)){
						slide = 5 + random(5);
						direction = gunangle + 180 + orandom(40);
					}
					
					 // Combat Slide:
					else{
						slide = 20;
						alarm2 = 8;
						direction = random(360);
						sound_play_hit_ext(sndSnowBotSlideStart, 1.3 + random(0.4), 1.5);
					}
					
					alarm1 = slide + 5 + random(15);
					
					break;
					
				default:
					
					 // Follow Big Seal:
					if(instance_exists(creator) && variable_instance_get(creator, "active", false)){
						scrAim(point_direction(x, y, creator.x, creator.y));
						scrWalk(gunangle, [10, 20]);
					}
					
					 // Normal:
					else{
						 // "Don't kill me!"
						if(scared){
							if(instance_near(x, y, target, 120) || chance(2, array_length(instances_matching(object_index, "name", name)))){
								scrWalk(gunangle + 180 + orandom(50), [20, 30]);
								if(chance(1, 3)) slide = walk - 5;
								alarm1 = walk;
							}
							else{
								scrWalk(random(360), [5, 10]);
							}
							scrAim(direction);
						}
						
						 // Idle:
						else{
							scrWalk(point_direction(x, y, xstart + orandom(24), ystart + orandom(24)), [5, 10]);
							if(!instance_near(x, y, target, 120)){
								scrAim(direction);
							}
						}
					}
			}
			
			 // Sliding Time:
			if(alarm2 > 0 && slide > 0){
				scrRight(gunangle - (direction - 90));
			}
		}
		
		 // Looking for Player:
		else{
			scrWalk(gunangle + orandom(60), [5, 25]);
			alarm1 = 5 + irandom(walk) + irandom(15);
			
			 // Aiming:
			scrAim(direction);
			switch(type){
				case seal_shield:
					
					if(shield){
						scrAim(angle_lerp(_aimLast, direction, 1/5));
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
		scrWalk(random(360), [5, 25]);
		scrAim(direction);
		alarm1 += walk;
	}
	
	 // Slide FX:
	if(slide > 0){
		if(hold) slide = 0;
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
				
			with(projectile_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Shank, _dir + 180, 2)){
				damage = 3;
				image_angle = _dir;
				image_xscale = 0.5;
				depth = -3;
				force = 12;
			}
			
			 // Effects:
			sound_play(sndMeleeFlip);
			sound_play(sndJackHammer);
			sound_play(sndScrewdriver);
			repeat(5){
				scrFX(x, y, [gunangle + orandom(30), random(skeal ? 2 : 5)], (skeal ? Smoke : Dust));
			}
			
			 // Forward Push:
			x += lengthdir_x(4, gunangle);
			y += lengthdir_y(4, gunangle);
			wkick = -trident_dist;
			
			 // Walk Backwards:
			scrWalk(gunangle + 180 + orandom(20), [6, 10]);
			
			break;
			
		case seal_blunderbuss:
			
			 // Blammo:
			repeat(6){
				projectile_create(x, y, EnemyBullet1, gunangle + orandom(6), 6 + random(2));
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
			
			if(chance(1, 3)) alarm2 = irandom_range(3, 5);
			
			 // Pew:
			projectile_create(x, y, EnemyBullet3, gunangle + orandom(4), 12 + random(2));
			
			 // Effects:
			scrFX(x, y, [gunangle, 2], Smoke);
			sound_play_pitchvol(sndEnemyFire, 1, 1.5);
			sound_play_pitchvol(sndShotgun, 2 + random(0.4), 0.8);
			motion_add(gunangle + 180, 1);
			wkick += 5;
			
			 // Aim:
			if(enemy_target(x, y)){
				scrAim(point_direction(x, y, target.x, target.y));
			}
			
			break;
			
		case seal_dasher:
			
			 // Aim:
			if(enemy_target(x, y) && instance_seen(x, y, target)){
				scrAim(point_direction(x, y, target.x, target.y));
			}
			
			 // Shooty:
			projectile_create(x, y, EnemyBullet1, gunangle, 6);
			
			 // Effects:
			wkick = 10;
			direction += choose(-30, 30);
			sound_play_hit_ext(sndEnemyFire, 1 + random(0.3), 2.5);
			sound_play_hit_ext(sndTurretFire, 1.3 + orandom(0.2), 1.5);
			
			break;
	}
	
#define Seal_hurt(_hitdmg, _hitvel, _hitdir)
	enemy_hurt(_hitdmg, _hitvel, _hitdir);
	
	switch(type){
		case seal_none:
			
			 // Alert:
			with(instances_matching(object_index, "name", name)){
				if(!scared && type == other.type){
					if(instance_near(x, y, other, 80)){
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
		for(var d = direction; d < direction + 360; d += (360 / 3)){
			scrFX(x, y, [d, 3], Smoke);
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
		
		return id;
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
		var	_oy = 2,
			_x = x + lengthdir_x(_oy, direction - 90),
			_y = y + lengthdir_y(_oy, direction - 90),
			_spr = spr.SealChain,
			_dir = point_direction(_x, _y, creator.x, creator.y),
			n = ceil(point_distance(x, y, creator.x, creator.y)) / sprite_get_width(_spr),
			l = 0,
			t = 0,
			w = sprite_get_width(_spr),
			h = sprite_get_height(_spr);

		for(var i = 0; i < n; i++){
			if(i >= n - 1){
				w = point_distance(_x, _y, creator.x, creator.y);
			}
			draw_sprite_general(_spr, 0, l, t, w, h, _x, _y, 1, 1, _dir, image_blend, image_blend, image_blend, image_blend, image_alpha);
			_x += lengthdir_x(w, _dir);
			_y += lengthdir_y(w, _dir);
		}
	}
	draw_self();

#define SealAnchor_hit
	if(projectile_canhit_melee(other)){
		projectile_hit_push(other, damage, force);
	}

#define SealAnchor_projectile
	if(instance_exists(self)){
		with(other){
			if(typ == 1 || typ == 2){
				 // Deflect (No Team Change):
				if(typ == 1 && other.candeflect){
					direction = other.direction;
					image_angle = direction;
					
					 // Effects:
					with(instance_create(x, y, Deflect)){
						image_angle = other.image_angle;
					}
				}
				
				 // Destroy:
				else if(typ == 2){
					instance_destroy();
				}
			}
		}
	}
	
#define SealAnchor_destroy
	 // Explodo:
	var	_dis = 8,
		_dir = image_angle;
		
	with(projectile_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "BubbleExplosion", 0, 0)){
		team = -1;
		
		 // Sounds:
		sound_play_hit_ext(sndWallBreakBrick, 1.2 + random(0.1), 0.4);
		sound_play_hit_ext(sndSwapHammer,     1.3,               0.3);
	}
	
	
#define SealDisc_create(_x, _y)
	with(instance_create(_x, _y, Disc)){
		 // Visual:
		sprite_index = spr.SealDisc;
		
		 // Vars:
		trail_color = make_color_rgb(252, 56, 0);
		
		return id;
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
		
		return id;
	}

#define SealHeavy_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
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
		scrAim(gunangle + (anchor_spin * current_time_scale));
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
					with(anchor) instance_destroy();
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
				my_mine_ang = ((my_mine_ang + 360) % 360);
				scrRight(my_mine_ang);
				
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
				with(instances_meeting(x, y, instances_matching(CustomHitme, "name", "SealMine"))){
					if(
						place_meeting(x, y, other) &&
						array_length(instances_matching(instances_matching(other.object_index, "name", other.name), "my_mine", id)) <= 0
					){
						with(other){
							alarm1      = 20;
							my_mine     = other;
							my_mine_ang = point_direction(x, y, other.x, other.y);
							
							scrRight(my_mine_ang);
						}
						creator = other;
						hitid   = other.hitid;
						
						 // Effects:
						sound_play_pitchvol(sndSwapHammer, 0.6 + orandom(0.1), 0.8);
						for(var _dir = direction; _dir < direction + 360; _dir += (360 / 20)){
							scrFX(x, y, [_dir, 4], Dust);
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
		draw_weapon(spr_weap, x, y, gunangle, 0, wkick, 1, image_blend, image_alpha);
	}

	if(gunangle <= 180) draw_self_enemy();

#define SealHeavy_alrm1
	alarm1 = 90 + random(30);
	
	enemy_target(x, y);
	
	 // Lob Mine:
	if(my_mine != noone && my_mine_spin != 0){
		sprite_index = spr_idle;
		with(my_mine){
			zspeed = 10;
			direction = point_direction(x, y, other.target_x, other.target_y);
			speed = (point_distance(x, y, other.target_x, other.target_y) * zfriction) / (zspeed * 2);
			x -= hspeed_raw;
			y -= vspeed_raw;
		}
		my_mine = noone;
		my_mine_spin = 0;
		
		scrWalk(gunangle, 5);
		
		 // Effects:
		sound_play_pitch(sndAssassinGetUp, 0.5 + orandom(0.2));
		sound_play_pitchvol(sndAssassinAttack, 0.8 + orandom(0.1), 0.8);
	}
	
	else{
		 // Spinning Anchor:
		if(anchor_spin != 0){
			 // Throw Out Anchor:
			if(!instance_exists(anchor)){
				alarm1 = 60;
				anchor = projectile_create(x, y, "SealAnchor", gunangle, 0);
				anchor_throw = 8;
				anchor_spin = max(20, abs(anchor_spin)) * sign(anchor_spin);
				if(instance_exists(target)){
					direction = point_direction(x, y, target.x, target.y);
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
		
		else if(instance_seen(x, y, target)){
			scrAim(point_direction(x, y, target.x, target.y));
			
			target_x = target.x;
			target_y = target.y;
			
			 // Not Holding Mine:
			if(my_mine == noone){
				 // Pick Up Mine:
				if(distance_to_object(Floor) > 24 && chance(3, 4)){
					alarm1 = 20;
					my_mine = obj_create(x, y, "SealMine");
					my_mine_ang = gunangle;
					with(my_mine){
						zspeed = 5;
						creator = other;
						hitid = other.hitid;
					}
				}
				
				 // On Land:
				else{
					 // Start Spinning Anchor:
					if((instance_near(x, y, target, 180) && chance(3, 4)) || instance_near(x, y, target, 100)){
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
					scrWalk(gunangle + orandom(30), [8, 24]);
				}
			}
			
			 // Holding Mine:
			else{
				if(instance_exists(my_mine)){
					alarm1 = 20;
					
					if(instance_near(x, y, target, 144)){
						 // Too Close:
						if(instance_near(x, y, target, 48)){
							scrWalk(gunangle + 180, 20);
						}
						
						 // Start Toss:
						else{
							my_mine_ang = gunangle;
							my_mine_spin = choose(-1, 1);
							
							sound_play_pitch(sndRatMelee, 0.5 + orandom(0.1));
							sound_play_pitch(sndSteroidsUpg, 0.75 + orandom(0.1));
							repeat(5) with(instance_create(target_x, target_y, Dust)){
								motion_add(random(360), 3);
							}
						}
					}
					
					 // Out of Range:
					else scrWalk(gunangle + orandom(20), [10, 20]);
				}
				else my_mine = noone;
			}
		}
		
		 // Passive Movement:
		else{
			scrWalk(random(360), 5);
			scrAim(direction);
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

		return id;
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
					with(scrFX(x, y, [a, 4], "WaterStreak")){
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
		with(instances_matching_ne(hitme, "id", creator)) if(place_meeting(x, y, other)){
			with(other){
				motion_add(point_direction(other.x, other.y, x, y), other.size / 5);
			}
			if(!instance_is(self, prop)){
				motion_add(point_direction(other.x, other.y, x, y), other.size / 2);
			}
		}
	}

	if(my_health <= 0) instance_destroy();

#define SealMine_draw
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

#define SealMine_destroy
	 // Explode:
	with(instance_create(x, y, Explosion)) hitid = other.hitid;
	sound_play(sndExplosion);

	 // Shrapnel:
	for(var a = direction; a < direction + 360; a += (360 / 6)){
		with(projectile_create(x, y, EnemyBullet3, a + orandom(20), 7 + random(4))){
			team = -1;
		}
	}
	sound_play_hit(sndFlakExplode, 0.2);

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
		
		return id;
	}

#define TrafficCrab_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Inactive:
	if(!active){
		x = xstart;
		y = ystart;
		speed = 0;
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
	var _hurt = (sprite_index == spr_hide && nexthurt > current_frame + 3);
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
			scrWalk(direction, 1);
			
			sound_play(sndOasisCrabAttack);
			sound_play_pitchvol(sndFlyFire, 2 + random(1), 0.5);
			
			 // Venom:
			var	_x = x + (right * (4 + (sweep_dir * 10))),
				_y = y + 4;
				
			repeat(choose(2, 3)){
				projectile_create(_x, _y, "VenomPellet", gunangle + orandom(10), 10 + random(2));
			}
			gunangle += (sweep_dir * sweep_spd);
			
			 // End:
			if(--ammo <= 0){
				alarm1 = 30 + random(20);
				sprite_index = spr_idle;
				
				 // Move Towards Player:
				scrWalk((instance_exists(target) ? point_direction(x, y, target.x, target.y) : random(360)), 15);
				
				 // Switch Claws:
				sweep_dir *= -1;
			}
		}
		
		 // Normal AI:
		else{
			alarm1 = 35 + random(15);
			
			if(instance_seen(x, y, target)){
				scrAim(point_direction(x, y, target.x, target.y));
				
				 // Attack:
				if(instance_near(x, y, target, 128)){
					scrWalk(gunangle + (sweep_dir * random(90)), 1);
					
					alarm1 = 1;
					ammo = 10;
					gunangle -= sweep_dir * (sweep_spd * (ammo / 2));
					
					sound_play_pitch(sndScorpionFireStart, 0.8);
					sound_play_pitch(sndGoldScorpionFire, 1.5);
				}
				
				 // Move Towards Player:
				else scrWalk(gunangle + (random_range(20, 40) * choose(-1, 1)), 30);
			}
			
			 // Passive Movement:
			else{
				scrWalk(random(360), 10);
				scrAim(direction);
			}
		}
	}
	
	 // Awaken:
	else if(instance_near(x, y, target, 80) || chance(1, instance_number(enemy))){
		active = true;
		if(place_meeting(x, y, hitme)){
			scrWalk(random(360), 4);
		}
		
		 // Effects:
		sound_play_hit(sndPlantSnareTB, 0.2);
		sound_play_hit(sndScorpionFire, 0.2);
		instance_create(x + (6 * right), y, AssassinNotice);
	}
	
#define TrafficCrab_hurt(_hitdmg, _hitvel, _hitdir)
	my_health -= _hitdmg;          // Damage
	motion_add(_hitdir, _hitvel);  // Knockback
	nexthurt = current_frame + 6;  // I-Frames
	sound_play_hit(snd_hurt, 0.3); // Sound

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
		image_speed = 0.4;
		
		 // Vars:
		mask_index         = msk.Trident;
		damage             = 40;
		force              = 5;
		typ                = 1;
		curse              = false;
		curse_return       = false;
		curse_return_delay = false;
		rotspeed           = 0;
		target             = noone;
		marrow_target      = noone;
		hit_time           = 0;
		hit_list           = {};
		wep                = "trident";
		
		 // Alarms:
		alarm0 = 15;
		
		return id;
	}
	
#define Trident_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Custom I-Frames:
	hit_time += current_time_scale;
	
	 // Cursed:
	if(curse){
		 // Cursed Trident Returns:
		curse_return = (instance_exists(creator) && (variable_instance_get(creator, "wep") == wep || variable_instance_get(creator, "bwep") == wep));
		
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
			var n = marrow_target;
			if(!instance_seen(x, y, n)){
				var	_x = x + hspeed,
					_y = y + vspeed,
					_disMax = 160;
					
				with(instances_matching_ne(instances_matching_ne(instance_rectangle(_x - _disMax, _y - _disMax, _x + _disMax, _y + _disMax, [enemy, Player, Sapling, Ally, SentryGun, CustomHitme]), "team", team, 0), "mask_index", mskNone, sprVoid)){
					var _dis = point_distance(x, y, _x, _y);
					if(_dis < _disMax){
						if(instance_seen(x, y, other)){
							if(lq_defget(other.hit_list, string(self), 0) <= other.hit_time){
								if(array_length(instances_matching(PopoShield, "creator", id)) <= 0){
									_disMax = _dis;
									other.marrow_target = id;
								}
							}
						}
					}
				}
			}
			else{
				rotspeed += (angle_difference(point_direction(x, y, n.x, n.y), direction) / max(1, 60 / (point_distance(x, y, n.x, n.y) + 1))) * min(1, 0.1 * skill_get(mut_bolt_marrow)) * current_time_scale;
				//rotspeed = clamp(rotspeed, -90, 90);
			}
			
			var f = min(1, abs(rotspeed) / 90);
			x -= hspeed_raw * f;
			y -= vspeed_raw * f;
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
		if(curse_return){
			if(curse_return_delay < 6){
				 // Movin:
				var	l = max(5, point_distance(x, y, creator.x, creator.y) * 0.1 * current_time_scale) / (curse_return_delay + 1),
					d = point_direction(x, y, creator.x, creator.y);
					
				x += lengthdir_x(l, d);
				y += lengthdir_y(l, d);
				
				 // Walled:
				if(!place_free(x, y)){
					xprevious = x;
					yprevious = y;
					if(visible){
						visible = false;
						sound_play_pitch(sndCursedReminder, 1 + orandom(0.3));
						repeat(4) with(instance_create(x + orandom(8), y + orandom(8), Smoke)){
							motion_add(d + 180, random(1));
						}
					}
				}
				else if(place_meeting(x, y, Floor)){
					if(!visible){
						visible = true;
						sound_play_pitch(sndSwapCursed, 1 + orandom(0.3));
						repeat(4) with(instance_create(x + orandom(8), y + orandom(8), Smoke)){
							motion_add(d, random(2));
						}
					}
				}
				
				 // Rotatin:
				if(instance_near(x, y, creator, 40)){
					d += 180;
				}
				image_angle = angle_lerp(image_angle, d, (0.05 * current_time_scale) / (curse_return_delay + 1));
			}
			if(curse_return_delay <= 8){
				image_angle += orandom(2 + curse_return_delay) * current_time_scale;
			}
			
			var f = 0.5 * current_time_scale;
			curse_return_delay -= clamp(curse_return_delay, -f, f);
			
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
			image_angle = point_direction(_x1, _y1, _x2, _y2);
			if(other.curse) image_blend = make_color_rgb(235, 0, 67);
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
	if(speed > 0 && lq_defget(hit_list, string(other), 0) <= hit_time){
		projectile_hit_push(other, damage, force);
		
		if(marrow_target == other) marrow_target = noone;
		
		 // Keep Movin:
		if(!lq_exists(hit_list, string(other)) && speed > 12){
			speed = 18;
		}
		
		 // Stick:
		if(other.my_health > 0){
			//replacing this interaction for now cause of stabby trident interaction// if(!skill_get(mut_long_arms)){
			if(!instance_exists(creator) || !skill_get(mut_throne_butt) || creator.race != "chicken"){
				sound_play_pitch(sndAssassinAttack, 2);
				target = other;
				speed = 0;
				
				 // Curse Return:
				if(curse){
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
		var f = clamp(other.size, 1, 5);
		view_shake_at(x, y, 12 * f);
		sleep(16 * f);
		
		 // Set Custom IFrames:
		lq_set(hit_list, string(other), hit_time + 3);
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
				&& instance_seen(x, y, marrow_target)
				&& instance_near(x, y, marrow_target, 160)
			){
				if(in_range(abs(angle_difference(image_angle, point_direction(x, y, marrow_target.x, marrow_target.y))), 10, 160)){
					_canWall = false;
				}
			}
		}
		
		 // Stick in Wall:
		if(_canWall){
			speed = 0;
			move_contact_solid(direction, 16);
			
			 // Curse Return:
			if(curse){
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
			direction = angle_lerp(direction, point_direction(x, y, marrow_target.x, marrow_target.y), 0.25 * current_time_scale);
			image_angle = direction;
			alarm0 = min(alarm0, 1);
		}
	}
	
#define Trident_destroy
	 // Hit FX:
	var	l = 18,
		d = direction,
		_x = x + lengthdir_x(l, d),
		_y = y + lengthdir_y(l, d);
		
	with(instance_create(_x, _y, BubblePop)){
		image_index = 1;
	}
	repeat(3) scrFX(
		_x,
		_y,
		[direction + orandom(30), choose(1, 2, 2)],
		Bubble
	);
	
#define Trident_cleanup // pls why do portals instance_delete everything
	var w = wep;
	if(is_object(w)) w.visible = true;
	
	 // Return to Player:
	if(curse_return) with(creator){
		if(instance_is(self, Player)){
			var _b = ((bwep == w) ? "b" : "");
			if(is_object(w)){
				w.wepangle = angle_difference(other.image_angle, gunangle)
				if(chance(1, 8)) w.wepangle += 360 * sign(w.wepangle);
				variable_instance_set(self, _b + "wepangle", w.wepangle);
			}
		}
		
		 // Effects:
		if(instance_is(self, Player)){
			with(instance_create(x, y, WepSwap)) creator = other;
		}
		sound_play(weapon_get_swap(w));
		sound_play(sndSwapCursed);
	}
	
	 // Drop Weapon:
	else if(w != wep_none){
		 // Delete Existing:
		with(instances_matching([WepPickup, ThrownWep], "wep", w)){
			instance_destroy();
		}
		
		 // Walled:
		if(!visible && !place_meeting(x, y, Floor)){
			with(instance_nearest_bbox(x, y, Floor)){
				other.x = bbox_center_x;
				other.y = bbox_center_y;
				repeat(4) instance_create(other.x, other.y, Smoke);
			}
		}
		
		 // WepPickup:
		var _stickTarget = target;
		with(obj_create(x, y, (instance_exists(_stickTarget) ? "WepPickupStick" : WepPickup))){
			wep      = w;
			curse    = other.curse;
			rotation = other.image_angle;
			
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
			if(instance_exists(other.creator) && ultra_get(char_chicken, 2) && variable_instance_get(other.creator, "race") == "chicken"){
				creator = other.creator;
				alarm0 = 30;
			}
		}
	}
	
	
/// GENERAL
#define ntte_step
	 // Harpoon Connections:
	var _ropeDraw = [[], []];
	if(array_length(global.harpoon_rope)){
		with(global.harpoon_rope){
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
									_inst = id;
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
						if(break_force > 100 || (_rope.broken < 0 && _length <= 1)){
							if(_rope.broken >= 0){
								sound_play_pitch(sndHammerHeadEnd, 2);
							}
							Harpoon_unrope(_rope);
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
				depth++;
				depth--;
			}
		}
	}
	
#define ntte_shadows
	 // Shield Shadows:
	if(instance_exists(CustomSlash)){
		var _inst = instances_matching(instances_matching(CustomSlash, "name", "ClamShield"), "visible", true)
		if(array_length(_inst)) with(_inst){
			var	_l = -8 - (1 * image_yscale),
				_d = image_angle,
				_x = x + lengthdir_x(_l, _d) + spr_shadow_x,
				_y = y + lengthdir_y(_l, _d) + spr_shadow_y;
				
			draw_sprite_ext(spr_shadow, 0, _x, _y, image_yscale, image_xscale, image_angle + 90, c_white, 1);
		}
	}
	
#define ntte_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
			
			var _gray = (_type == "normal");
			
			 // Divers:
			if(instance_exists(CustomEnemy)){
				var _inst = instances_matching(CustomEnemy, "name", "Diver");
				if(array_length(_inst)){
					var _r = 16 + (24 * _gray);
					with(_inst){
						draw_circle(x, y, _r + orandom(1), false);
					}
				}
			}
			
			break;
			
	}
	
#define draw_gui_end
	 // Palanking camera pan here so that pausing doesn't jank things:
	var	_dir = global.palanking_pan[0],
		_dis = global.palanking_pan[1];
		
	if(_dis > 0){
		view_shift(-1, _dir, _dis);
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