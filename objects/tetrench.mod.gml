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
	with([lightning_connect, lightning_disappear]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // Bind Events:
	script_bind(CustomDraw, draw_anglertrail, -3, true);
	
	 // Pit Grid:
	global.pit_grid = mod_variable_get("area", "trench", "pit_grid");
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro FloorPit     instances_matching(Floor, "sprite_index", spr.FloorTrenchB)
#macro FloorPitless instances_matching_ne(Floor, "sprite_index", spr.FloorTrenchB)

#define Angler_create(_x, _y)
	/*
		It's just a rad canister bro
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		 // Offset:
		x         = _x - (right * 6);
		y         = _y - 8;
		xstart    = x;
		ystart    = y;
		xprevious = x;
		yprevious = y;
		
		 // Visual:
		spr_idle     = spr.AnglerIdle;
		spr_walk     = spr.AnglerWalk;
		spr_hurt     = spr.AnglerHurt;
		spr_dead     = spr.AnglerDead;
		spr_appear   = spr.AnglerAppear;
	//	spr_shadow   = shd64;
	//	spr_shadow_y = 6;
		hitid        = [spr_idle, "ANGLER"];
		sprite_index = spr_appear;
		image_speed  = 0.4;
		depth        = -2;
		
		 // Sound:
		var _water = call(scr.area_get_underwater, GameCont.area);
		snd_hurt = sndFireballerHurt;
		snd_dead = (_water ? sndOasisDeath : choose(sndFrogEggDead, sndFrogEggOpen2));
		
		 // Vars:
		mask_index  = -1;
		maxhealth   = 45;
		raddrop     = 25;
	//	rad_max     = raddrop;
		meleedamage = 4;
		size        = 3;
		walk        = 0;
		walkspeed   = 0.6;
		maxspeed    = 3;
		hiding      = true;
		ammo        = 0;
		gold        = false;
		
		 // Alarms:
		alarm1 = 30 + irandom(30);
	//	alarm2 = -1;
		
		 // Hide:
		scrAnglerHide();
		
		return self;
	}
	
#define Angler_step
	 // Alarms:
	if(alarm1_run) exit;
	//if(alarm2_run) exit;
	
	 // Movement:
	var _max = maxspeed;
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
		
		 // Charging:
		if(ammo >= 0){
			_max += 8;
		}
	}
	if(speed > _max){
		speed = _max;
	}
	
	 // Animate:
	if(hiding){
		sprite_index = spr_appear;
		if(image_index > 0){
			image_index -= min(image_index, image_speed_raw * 2);
		}
	}
	else{
		if(sprite_index != spr_appear || anim_end){
			if(sprite_index == spr_appear) sprite_index = spr_idle;
			sprite_index = enemy_sprite;
		}
		
		 // Charging Up:
		if(ammo >= 0){
			speed *= power(0.85, current_time_scale);
			//call(scr.wall_clear, self, x + hspeed, y + vspeed);
		}
	}
	
#define Angler_draw
	var _hurt = (sprite_index == spr_appear && nexthurt >= current_frame + 4);
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	draw_self_enemy();
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
#define Angler_alrm1
	alarm1 = 6 + irandom(6);
	
	enemy_target(x, y);
	
	 // Hiding:
	if(hiding){
		if(
			instance_exists(target)
			&& target_distance < ((gold && my_health < maxhealth) ? 96 : 48)
			&& target_visible
		){
			scrAnglerAppear(); // Unhide
		}
	}
	
	else{
		 // Charging:
		if(ammo > 0){
			ammo--;
			alarm1 = (gold ? 6 : 8);
			
			 // Charge:
			enemy_walk(((instance_exists(target) && target_visible) ? target_direction : direction) + orandom(40), 5);
			enemy_look(direction);
			speed = maxspeed + 10;
			
			 // Effects:
			sound_play_pitchvol(sndRoll, 1.4 + random(0.4), 1.2);
			sound_play_pitchvol(sndBigBanditMeleeStart, 1.2 + random(0.2), 0.5);
			repeat(4){
				call(scr.fx, [x, 16], [y, 16], [direction + 180, random(4)], Dust);
			}
			sprite_index = spr_hurt; // Temporary?
			image_index  = 1;
			
			 // Gold:
			if(gold){
				call(scr.wall_clear, self, x + hspeed, y + vspeed);
				/*with(call(scr.projectile_create, x, y, "BatScreech")){
					sprite_index = spr.AnglerGoldScreech;
					image_xscale = 0.5;
					image_yscale = 0.5;
					image_index  = 1;
				}*/
			}
		}
		else if(ammo == 0){
			ammo   = -1;
			alarm1 = 15;
			
			 // Back up:
			enemy_walk(direction + 180, 8);
			enemy_look(direction);
		}
		
		 // Normal AI:
		else{
			alarm1 = 20 + irandom(20);
			
			 // Move Toward Player:
			if(
				instance_exists(target)
				&& target_distance < 96 * (1 + gold)
				&& (gold || target_visible)
			){
				enemy_walk(target_direction + orandom(20), random_range(25, 50));
				enemy_look(direction);
				if(chance(1, 2)){
					ammo = irandom_range(1, 3) + (2 * gold);
					if(gold){
						alarm1 = ceil(alarm1 * 0.4);
						direction += 180;
						
						 // Screech:
						with(call(scr.projectile_create, x, y, "BatScreech")){
							sprite_index = spr.AnglerGoldScreech;
						}
						
						 // Sounds:
						audio_sound_gain(
							call(scr.sound_play_at, x, y, sndLilHunterLaunch, 0.5 + orandom(0.1), 1.6),
							0,
							750
						);
						audio_sound_set_track_position(
							call(scr.sound_play_at, x, y, sndNothing2DeadStart, 1, 1.3),
							1
						);
						
						 // Call the bros:
						with(instances_matching_lt(obj.Angler, "gold", gold)){
							if(hiding && point_distance(x, y, other.x, other.y) < 128){
								scrAnglerAppear();
							}
						}
					}
				}
			}
			
			 // Wander:
			else{
				enemy_walk(direction + orandom(30), random_range(20, 50));
				enemy_look(direction);
				
				 // Go to Nearest Non-Pit Floor:
				with(call(scr.instance_nearest_bbox, x + (hspeed * 4), y + (vspeed * 4), FloorPitless)){
					other.direction = point_direction(other.x, other.y, bbox_center_x, bbox_center_y);
				}
				
				 // Hide:
				if(instance_exists(target) && target_distance > 160 && !call(scr.pit_get, x, y)){
					scrAnglerHide();
				}
			}
		}
	}
	
//#define Angler_alrm2
//	alarm2 = 2 + random(4);
//	
//	 // Call Rads to Heal:
//	if(!hiding && my_health <= maxhealth){
//		if(instance_exists(Rad) || instance_exists(BigRad)){
//			var _inst = instances_matching([Rad, BigRad], "goldanglerradattract_check", null);
//			
//			if(array_length(_inst)){
//				with(call(scr.instance_nearest_array, x, y, _inst)){
//					goldanglerradattract_check = true;
//					call(scr.rad_path, self, other);
//				}
//			}
//		}
//	}
//	
//	 // Heal Up:
//	if(raddrop > rad_max){
//		repeat(min(irandom_range(1, 3), (raddrop - rad_max))){
//			raddrop--;
//			my_health++;
//			instance_create(x + orandom(16), y + orandom(12), HorrorTB);
//		}
//	}
	
#define Angler_hurt(_damage, _force, _direction)
	my_health -= _damage;           // Damage
	nexthurt = current_frame + 6;   // I-Frames
	motion_add(_direction, _force); // Knockback
	
	 // Sounds:
	if(gold && snd_hurt == sndFreakPopoHurt){
		call(scr.sound_play_at, x, y, sndEnergyHammerUpg, 0.8 + random(0.2), 0.7);
		call(scr.sound_play_at, x, y, sndSwapGold,        0.9 + random(0.2), 0.4);
		call(scr.sound_play_at, x, y, snd_hurt,           0.7 + random(0.2));
	}
	else sound_play_hit(snd_hurt, 0.3);
	
	 // Appear:
	if(my_health > 0 && hiding){
		scrAnglerAppear();
	}
	
	 // Hurt Sprite:
	else if(sprite_index != spr_appear){
		sprite_index = spr_hurt;
		image_index = 0;
	}
	
	 // Emergency:
	if(my_health < maxhealth * 2/3 && chance(2, 3) && ammo < 0){
		walk   = 0;
		ammo   = 1 + gold;
		alarm1 = 4;
		
		if(gold){
			 // Screech:
			with(call(scr.projectile_create, x, y, "BatScreech")){
				sprite_index = spr.AnglerGoldScreech;
			}
			
			 // Sounds:
			audio_sound_gain(
				call(scr.sound_play_at, x, y, sndLilHunterLaunch, 0.5 + orandom(0.1), 1.6),
				0,
				750
			);
			audio_sound_set_track_position(
				call(scr.sound_play_at, x, y, sndNothing2DeadStart, 1, 1.3),
				1
			);
		}
	}
	
#define Angler_death
	pickup_drop(80, 0);
	pickup_drop(60, 5, 0);
	
	/// Light Broke:
		var	_x = x + (20 * right),
			_y = y - 10;
			
		if(hiding){
			_x = x;
			_y = y;
		}
		
		 // it is very broke
		with(call(scr.corpse_drop, self, direction + orandom(10), speed + random(2))){
			x            = _x;
			y            = _y;
			sprite_index = (other.gold ? sprRadChestBigDead : sprRadChestCorpse);
			mask_index   = -1;
			size         = 2;
		}
		
		 // yea...
		with(instance_create(_x, _y, PortalClear)){
			image_xscale = 0.4;
			image_yscale = 0.4;
		}
		
		 // most important part
		if(raddrop > 0){
			while(raddrop > 25){
				raddrop -= 10;
				with(instance_create(_x, _y, BigRad)){
					motion_add(random(360), random(4));
					motion_add(other.direction, min(other.speed / 3, 3));
				}
			}
			repeat(raddrop){
				with(instance_create(_x, _y, Rad)){
					motion_add(random(360), random(5));
					motion_add(other.direction, min(other.speed / 3, 3));
				}
			}
			raddrop = 0;
		}
		
		 // Effects:
		sound_play(sndEXPChest);
		repeat(4){
			call(scr.fx, _x, _y, random(3), Smoke);
		}
		with(instance_create(_x, _y, ExploderExplo)){
			motion_add(other.direction, 1);
		}
		
	 // Gold:
	if(gold){
		 // Sounds:
		call(scr.sound_play_at, x, y, sndEnergyHammerUpg, 0.9, 0.9);
		audio_sound_gain(
			call(scr.sound_play_at, x, y, sndLilHunterDeath, 0.5, 1.1),
			0,
			2500
		);
		audio_sound_set_track_position(
			call(scr.sound_play_at, x, y, sndNothing2DeadStart, 1, 0.5),
			1
		);
		
		 // Angler Fish Skin Unlock:
		if(player_count_race(char_fish) > 0){
			call(scr.unlock_set, "skin:angler fish", true);
		}
	}
	
#define scrAnglerAppear()
	hiding = false;
	
	 // Anglers rise up
	mask_index   = mskFrogQueen;
	spr_shadow   = shd64B;
	spr_shadow_x = 0;
	spr_shadow_y = 3;
	call(scr.wall_clear, self);
	
	 // Time 2 Charge
	alarm1 = 15 + orandom(2);
	ammo   = 3 + (2 * gold);
	
	 // Effects:
	sound_play_pitch(sndBigBanditMeleeStart, 0.8 + random(0.2));
	view_shake_at(x, y, 10);
	repeat(5){
		call(scr.obj_create, x + orandom(24), y + orandom(24), "FakeDust");
	}
	
	 // Call the bros:
	with(instances_matching_lt(obj.Angler, "gold", gold)){
		if(
			hiding
			&& chance(1 + other.gold, 2)
			&& point_distance(x, y, other.x, other.y) < 64 * (1 + other.gold)
		){
			scrAnglerAppear();
		}
	}
	
	 // Screech:
	if(gold){
		with(call(scr.pass, self, scr.projectile_create, x, y, "BatScreech")){
			sprite_index = spr.AnglerGoldScreech;
		}
		
		 // Sounds:	
		call(scr.sound_play_at, x, y, sndEnergyHammerUpg, 0.9, 0.9);
		audio_sound_gain(
			call(scr.sound_play_at, x, y, sndLilHunterLaunch, 0.5, 1.1),
			0,
			750
		);
		audio_sound_set_track_position(
			call(scr.sound_play_at, x, y, sndNothing2DeadStart, 1, 0.75),
			1
		);
	}
	
#define scrAnglerHide()
	hiding = true;
	
	 // Anglers rise down
	sprite_index = spr_appear;
	image_index  = image_number - 1 + image_speed;
	mask_index   = msk.AnglerHidden[right < 0];
	spr_shadow   = shd24;
	spr_shadow_x = 6 * right;
	spr_shadow_y = 9;
	walk         = 0;
	
	 // Effects:
	sound_play_pitchvol(sndJockFire, 1.6 + random(0.5), 0.2);
	view_shake_at(x, y, 10);
	repeat(5){
		call(scr.fx, [x, 24], [y, 24], 2, "FakeDust");
	}
	
	
#define AnglerGold_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "Angler")){
		 // Visual:
		spr_idle     = spr.AnglerGoldIdle;
		spr_walk     = spr.AnglerGoldWalk;
		spr_hurt     = spr.AnglerGoldHurt;
		spr_dead     = spr.AnglerGoldDead;
		spr_appear   = spr.AnglerGoldAppear;
		hitid        = [spr_idle, "GOLDEN ANGLER"];
		sprite_index = spr_appear;
		
		// Sounds:
		snd_hurt = sndFreakPopoHurt;
		
		 // Vars:
		maxhealth   = round(maxhealth * 1.6);
		my_health   = round(my_health * 1.6);
		maxspeed    = 5;
	//	meleedamage = 6;
		raddrop     = 45;
	//	rad_max     = raddrop;
		gold        = true;
		
		return self;
	}
	
	
#define Eel_create(_x, _y)
	/*
		Rat-style enemy, lightning arcs between it and the nearest Jelly
		Different colors represent the pickup they drop (health/ammo/rad chunk)
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		 // Type:
		type = irandom(2);
		switch(crown_current){
			case crwn_guns : if(type == 0) type = 1; break;
			case crwn_life : if(type == 1) type = 0; break;
		}
		
		 // Visual:
		spr_idle    = spr.EelIdle[type];
		spr_walk    = spr_idle;
		spr_hurt    = spr.EelHurt[type];
		spr_dead    = spr.EelDead[type];
		spr_tell    = spr.EelTell[type];
		hitid       = [spr_idle, "EEL"];
		spr_shadow  = shd24;
		image_index = irandom(image_number - 1);
		depth       = -2;
		
		 // Sound:
		var _water = call(scr.area_get_underwater, GameCont.area);
		snd_hurt = (_water ? sndOasisHurt  : sndHitFlesh);
		snd_dead = (_water ? sndOasisDeath : sndFastRatDie);
		snd_mele = (_water ? sndOasisMelee : sndMaggotBite);
		
		 // Vars:
		mask_index  = mskRat;
		maxhealth   = 10;
		raddrop     = 2;
		meleedamage = 2;
		size        = 1;
		walk        = 0;
		walkspeed   = 1.2;
		maxspeed    = 3.4;
		direction   = random(360);
		arc_inst    = noone;
		arcing      = 0;
		elite       = 0;
		wave        = random(180);
		
		 // Alarms:
		alarm1 = 15 + random(45);
		
		return self;
	}
	
#define Eel_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Arcing:
	if(arc_inst != noone){
		var	_ax = x,
			_ay = y;
			
		if(instance_exists(arc_inst)){
			_ax = arc_inst.x;
			_ay = arc_inst.y;
		}
		else arcing = -1;
		
		if(
			arcing >= 0
			&& point_distance(x, y, _ax, _ay) < arc_inst.arc_dis
			&& !collision_line(x, y, _ax, _ay, Wall, false, false)
		){
			 // Start Arcing:
			if(arcing < 1){
				arcing += 0.15 * current_time_scale;
				
				if(current_frame_active){
					var	_dis = random(point_distance(x, y, _ax, _ay)),
						_dir = point_direction(x, y, _ax, _ay);
						
					with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), choose(PortalL, PortalL, LaserCharge))){
						motion_add(random(360), 1);
						alarm0 = 8;
					}
				}
				
				 // Arced:
				if(arcing >= 1){
					sound_play_pitch(sndLightningHit, 2);
					
					 // Color:
					if(arc_inst.type <= 2){
						type     = max(arc_inst.type, 0);
						spr_idle = spr.EelIdle[type];
						spr_walk = spr_idle;
						spr_hurt = spr.EelHurt[type];
						spr_dead = spr.EelDead[type];
						spr_tell = spr.EelTell[type];
						hitid    = [spr_idle, "EEL"];
					}
				}
			}
			
			 // Arcing:
			else{
				wave += current_time_scale;
				if(arc_inst.type > 2){
					elite = 30;
				}
				with(arc_inst){
					lightning_connect(other.x, other.y, x, y, 16 * sin((other.wave / 180) * 2 * pi), true, self);
				}
			}
		}
		
		 // Stop Arcing:
		else{
			with(arc_inst){
				arc_num--;
				repeat(2){
					var	_dis = random(point_distance(x, y, other.x, other.y)),
						_dir = point_direction(x, y, other.x, other.y);
						
					with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), PortalL)){
						motion_add(random(360), 1);
					}
				}
			}
			arc_inst = noone;
			arcing   = 0;
		}
	}
	else arcing = 0;

	 // Eelite:
	if(elite > 0){
		elite -= current_time_scale;
		
		 // Zappin ?
		if(
			alarm11 > 0
			&& ((alarm11 + 1) % 15) < 1
			&& current_frame_active
		){
			var _dir = random(360);
			if(instance_exists(Player)){
				with(instance_nearest(x, y, Player)){
					_dir = point_direction(other.x, other.y, x, y) + orandom(40);
				}
			}
			with(call(scr.projectile_create, x, y, EnemyLightning, _dir)){
				ammo = 2 + random(2);
				with(self){
					event_perform(ev_alarm, 0);
				}
			}
			walk = 0;
		}
		
		 // Effects:
		if(chance_ct(1, 30)){
			instance_create(x, y, PortalL);
		}
		if(elite <= 0){
			instance_create(x, y, PortalL);
			sprite_index = spr_hurt;
			image_index  = 0;
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
	if(sprite_index != spr_chrg || anim_end){
		sprite_index = enemy_sprite;
	}
	
#define Eel_draw
	var _spr = sprite_index;
	if(elite > 0){
		     if(_spr == spr_idle) _spr = spr.EeliteIdle;
		else if(_spr == spr_walk) _spr = spr.EeliteWalk;
		else if(_spr == spr_hurt) _spr = spr.EeliteHurt;
	}
	draw_sprite_ext(_spr, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);

#define Eel_alrm1
	alarm1 = 30 + random(10);
	
	enemy_target(x, y);
	
	 // Search for New Jelly:
	if(instance_exists(target) && target_distance < 160){
		if(arc_inst == noone){
			var _disMax = infinity;
			with(instances_matching_ne(obj.Jelly, "id")){
				if(arc_num < arc_max){
					var _dis = point_distance(x, y, other.x, other.y);
					if(_dis < arc_dis && _dis < _disMax){
						if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
							_disMax = _dis;
							other.arc_inst = self;
						}
					}
				}
			}
			with(arc_inst) arc_num++;
		}
	}
	else arcing = -1;
	
	 // When you walking:
	if(instance_exists(target) && target_visible){
		enemy_walk(
			target_direction + orandom(20),
			random_range(23, 30)
		);
	}
	else enemy_walk(
		direction + orandom(30),
		random_range(17, 30)
	);
	enemy_look(direction);
	
	 // Stay Near Papa:
	if(instance_exists(arc_inst)){
		if(arcing < 1 || point_distance(x, y, arc_inst.x, arc_inst.y) > arc_inst.arc_dis - 16){
			direction = point_direction(x, y, arc_inst.x, arc_inst.y) + orandom(10);
		}
	}
	
#define Eel_death
	if(elite){
		spr_dead = spr.EeliteDead;
		
		 // Death Lightning:
		with(call(scr.projectile_create, x, y, "LightningDisc", direction + 180 + orandom(15), 6)){
			is_enemy  = true;
			maxspeed *= 0.5;
			radius   *= 4/3;
			charge   *= 0.5;
		}
		repeat(2){
			with(call(scr.projectile_create, x, y, EnemyLightning, random(360), 0.5)){
				alarm0       = 2 + random(4);
				ammo         = 1 + random(2);
				image_speed *= random_range(0.75, 1);
				
				with(instance_create(x, y, LightningHit)){
					motion_add(other.direction, random(2));
				}
			}
		}
		sound_play_pitchvol(sndLightningCrystalDeath, 1.5 + random(0.5), 1);
	}
	
	 // Type-Pickups:
	else switch(type){
		
		case 0: // Blue
			
			if(chance(2 * pickup_chance_multiplier, 3)){
				if(chance(ultra_get("fish", 1), 5)){
					instance_create(x, y, FishA);
					instance_create(x + orandom(2), y + orandom(2), AmmoChest);
				}
				else instance_create(x + orandom(2), y + orandom(2), AmmoPickup);
				
				 // FX:
				with(instance_create(x, y, FXChestOpen)){
					motion_add(other.direction, random(1));
				}
			}
			
			break;
			
		case 1: // Purple
			
			if(chance(2 * pickup_chance_multiplier, 3)){
				if(chance(ultra_get("fish", 1), 5)){
					instance_create(x, y, FishA);
					instance_create(x + orandom(2), y + orandom(2), HealthChest);
				}
				else instance_create(x + orandom(2), y + orandom(2), HPPickup);
				
				 // FX:
				repeat(2) with(instance_create(x + orandom(4), y + orandom(4), AllyDamage)){
					motion_add(other.direction + orandom(30), random(1));
				}
			}
			
			break;
			
		case 2: // Green
			
			with(instance_create(x, y, BigRad)){
				motion_add(other.direction, other.speed);
				motion_add(random(360), 3);
				speed *= power(0.9, speed);
			}
			
			 // FX:
			repeat(2) with(instance_create(x + orandom(4), y + orandom(4), EatRad)){
				sprite_index = sprEatBigRadPlut;
				motion_add(other.direction + orandom(30), 1);
			}
			
			break;
			
	}
	
	
#define EelSkull_create(_x, _y)
	/*
		Epic prop, drops bone
	*/
	
	with(instance_create(_x, _y, BigSkull)){
		 // Visual:
		spr_idle = spr.EelSkullIdle;
		spr_hurt = spr.EelSkullHurt;
		spr_dead = spr.EelSkullDead;
		
		 // Sound:
		snd_hurt = sndOasisHurt;
		snd_dead = sndOasisDeath;
		
		return self;
	}
	
	
#define ElectroPlasma_create(_x, _y)
	/*
		A PlasmaBall-style projectile that arcs lightning to another instance, usually other ElectroPlasma
		
		Vars:
			tether            - 0 to 1, untethered to fully tethered
			tether_x/tether_y - The point to tether lightning with
			tether_inst       - The instance to tether lightning with, forces tether_x/tether_y to its position
			tether_range      - Cannot tether lightning to tether_x/tether_y outside of this distance
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visuals:
		sprite_index = spr.ElectroPlasma;
		image_speed  = 0.4;
		image_index  = 1 - image_speed_raw;
		depth        = -3;
		ntte_bloom   = 0.1;
		
		 // Vars:
		mask_index   = mskEnemyBullet1;
		damage       = 3;
		force        = 3;
		typ          = 2;
		wave         = current_frame + choose(0, 150) + random(30);
		tether       = 0;
		tether_x     = x;
		tether_y     = y;
		tether_inst  = noone;
		tether_range = 80;
		big          = false;
		setup        = true;
		
		 // Alarms:
		alarm0 = -1;
		alarm1 = -1;
		
		 // Merged Weapon Support:
		temerge_on_fire  = script_ref_create(ElectroPlasma_temerge_fire);
		temerge_on_setup = script_ref_create(ElectroPlasma_temerge_setup);
		
		return self;
	}
	
#define ElectroPlasma_setup
	setup = false;
	
	 // Not Tethered:
	if(tether == 0 && tether_inst == noone){
		tether = -1;
	}
	
	 // Laser Brain:
	if(instance_is(creator, Player)){
		var _brain = skill_get(mut_laser_brain);
		image_xscale += 0.15 * _brain;
		image_yscale += 0.15 * _brain;
		tether_range += 40 * _brain;
	}
	
#define ElectroPlasma_anim
	if(instance_exists(self)){
		image_index = 1;
	}
	
#define ElectroPlasma_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	
	 // Setup:
	if(setup) ElectroPlasma_setup();
	
	 // Tether:
	if(tether >= 0){
		if(instance_exists(tether_inst)){
			tether_x = tether_inst.x + tether_inst.hspeed_raw;
			tether_y = tether_inst.y + tether_inst.vspeed_raw;
		}
		
		var	_x1 = x + hspeed_raw,
			_y1 = y + vspeed_raw,
			_x2 = tether_x,
			_y2 = tether_y;
			
		if(
			(tether_inst == noone || instance_exists(tether_inst))
			&& point_distance(_x1, _y1, _x2, _y2) < tether_range
			&& !collision_line(_x1, _y1, _x2, _y2, Wall, false, false)
		){
			 // Initialize Tether:
			if(tether < 1){
				tether += 0.2 * current_time_scale;
				
				if(current_frame_active){
					var	_dis = random(point_distance(_x1, _y1, _x2, _y2)),
						_dir = point_direction(_x1, _y1, _x2, _y2);
						
					with(instance_create(_x1 + lengthdir_x(_dis, _dir), _y1 + lengthdir_y(_dis, _dir), choose(PortalL, LaserCharge))){
						if(object_index == LaserCharge){
							sprite_index = spr.ElectroPlasmaTether;
							image_angle  = random(360);
							alarm0       = 4 + random(4);
						}
						motion_add(random(360), 1);
					}
				}
				
				 // Tethered:
				if(tether >= 1){
					sound_play_pitch(sndLightningHit, 2);
					
					 // Laser Brain FX:
					if(skill_get(mut_laser_brain) > 0){
						with(instance_create(_x1, _y1, LaserBrain)){
							image_angle = _dir + orandom(10);
							creator     = other.creator;
						}
						with(instance_create(_x2, _y2, LaserBrain)){
							image_angle = _dir + orandom(10) + 180;
							creator     = other.creator;
						}
					}
				}
			}
			
			 // Tethering:
			else{
				var	_d1 = direction,
					_d2 = direction;
					
				if(instance_exists(tether_inst)){
					_d2 = tether_inst.direction;
				}
				
				with(lightning_connect(
					_x1,
					_y1,
					_x2,
					_y2,
					(point_distance(_x1, _y1, _x2, _y2) / 4) * sin((wave / 300) * 2 * pi),
					false,
					self
				)){
					damage       = floor(damage * (other.damage / 3));
					sprite_index = spr.ElectroPlasmaTether;
					depth        = -3;
					
					 // Effects:
					if(chance_ct(1, 16)){
						with(instance_create(x, y, PlasmaTrail)){
							sprite_index = spr.ElectroPlasmaTrail;
							motion_set(angle_lerp(_d1, _d2, random(1)), 1);
						}
					}
				}
			}
		}
		
		 // Untether FX:
		else ElectroPlasma_untether();
	}
	
	 // Trail:
	if(chance_ct(1, 8)){
		with(instance_create(
			random_range(bbox_left, bbox_right), 
			random_range(bbox_top, bbox_bottom), 
			PlasmaTrail
		)){
			sprite_index = spr.ElectroPlasmaTrail;
		}
	}
	
	 // Increment Wave:
	wave += current_time_scale;
	
	 // Goodbye:
	if(image_xscale <= 0.8 || image_yscale <= 0.8 || speed <= friction){
		instance_destroy();
	}
	
#define ElectroPlasma_alrm0
	alarm0 = random_range(5, 10);
	
	 // Zap Nearby:
	with(call(scr.projectile_create, x, y, "TeslaCoil")){
		direction    = random(360);
		damage       = other.damage;
		purple       = true;
		creator      = other;
		creator_offx = 0;
		creator_offy = 0;
		dist_max     = 64;
	}
	
#define ElectroPlasma_alrm1
	friction = 0.3;
	call(scr.sound_play_at, x, y, sndLightningHit, 0.3 + random(0.2), 1.5);
	
#define ElectroPlasma_hit
	if(setup) ElectroPlasma_setup();
	
	if(projectile_canhit_np(other)){
		projectile_hit_push(other, damage, force);
		
		 // Effects:
		call(scr.sleep_max, 10);
		view_shake_max_at(x, y, 2);
		
		 // Slow:
		x -= hspeed * 0.8;
		y -= vspeed * 0.8;
		
		 // Shrink:
		var _shrink = 0.05;
		image_xscale -= _shrink;
		image_yscale -= _shrink;
	}
	
#define ElectroPlasma_wall
	 // Shrink:
	var _shrink = 0.03;
	image_xscale -= _shrink;
	image_yscale -= _shrink;
	
	 // Break Walls:
	if(big){
		with(other){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
	}
	
#define ElectroPlasma_destroy
	 // Cannon:
	if(big > 0){
		var	_num  = 5 * big,
			_inst = [];
			
		 // Balls:
		for(var i = 0; i < _num; i++){
			var _ang = direction + (360 * (i / _num));
			for(var j = -1; j <= 1; j++){
				var	_dir = _ang + (j * 15) + orandom(2),
					_spd = ((j == 0) ? 5 : 4) + random(0.4);
					
				array_push(
					_inst,
					call(scr.projectile_create, x, y, "ElectroPlasma", _dir, _spd)
				);
			}
		}
		
		 // Link Balls:
		var _link = 0;
		with(_inst){
			_link++;
			if(instance_exists(self)){
				tether_inst = _inst[_link % array_length(_inst)];
			}
		}
		
		 // Explo Impact:
		var _num = 3 * big,
			_l   = 16;
			
		for(var i = 0; i < _num; i++){
			var _d = direction + (360 * (i / _num));
			call(scr.projectile_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "ElectroPlasmaImpact", _d);
		}
		
		 // Effects:
		sleep(60);
		view_shake_at(x, y, 24);
		with(instance_create(x, y, PortalClear)){
			image_xscale = 5/3;
			image_yscale = image_xscale;
		}
		
		 // Sounds:
		var	_brain = (skill_get(mut_laser_brain) > 0),
			_snd   = sound_play_hit_big((_brain ? sndPlasmaBigExplodeUpg : sndPlasmaBigExplode), 0);
			
		audio_sound_pitch(_snd, 0.8);
		audio_sound_gain(_snd, 0.8 * audio_sound_get_gain(_snd), 0);
		sound_play_hit((_brain ? sndLightningCannonUpg  : sndLightningCannon), 0.1);
		call(scr.sound_play_at, x, y, sndLightningCannonEnd, 1.4 + orandom(0.1), 1.5);
	}
	
	 // Normal:
	else call(scr.projectile_create, x, y, "ElectroPlasmaImpact", direction);
	
	 // Untether FX:
	ElectroPlasma_untether();
	
#define ElectroPlasma_untether
	if(tether > 0){
		tether = 0;
		sound_play_pitchvol(sndLightningReload, 0.7 + random(0.2), 0.5);
		
		var	_x1 = x + hspeed_raw,
			_y1 = y + vspeed_raw,
			_x2 = tether_x,
			_y2 = tether_y;
			
		with(lightning_disappear(lightning_connect(
			_x1,
			_y1,
			_x2,
			_y2,
			(point_distance(_x1, _y1, _x2, _y2) / 4) * sin((wave / 300) * 2 * pi),
			(team != 2 && !instance_is(creator, Player)),
			self
		))){
			sprite_index = spr.ElectroPlasmaTether;
			depth        = -3;
		}
	}
	
#define ElectroPlasma_temerge_fire(_at, _setupInfo)
	_setupInfo.is_big = big;
	
#define ElectroPlasma_temerge_setup(_instanceList, _setupInfo)
	with(_instanceList){
		var _lastInstance = (
			("temerge_electroplasma_last" in creator)
			? creator.temerge_electroplasma_last
			: noone
		);
		if(
			(instance_exists(_lastInstance) && point_distance(x, y, _lastInstance.x, _lastInstance.y) < 64)
			|| _setupInfo.is_big
		){
			with(call(scr.projectile_create, x, y, "TeslaCoil", random(360))){
				damage       = other.damage;
				purple       = true;
				creator      = other;
				creator_offx = 0;
				creator_offy = 0;
				dist_max     = 64;
				time        *= 2;
				if(instance_exists(_lastInstance) && point_distance(x, y, _lastInstance.x, _lastInstance.y) < 64){
					alarm0 = -1;
					target = _lastInstance;
				}
			}
		}
		creator.temerge_electroplasma_last = self;
	}
	
	
#define ElectroPlasmaBig_create(_x, _y)
	/*
		The "cannon" variant of ElectroPlasma
	*/
	
	with(call(scr.obj_create, _x, _y, "ElectroPlasma")){
		 // Visual:
		sprite_index = spr.ElectroPlasmaBig;
		image_speed  = 0.475;
		image_index  = 1 - image_speed_raw;
		
		 // Vars:
		mask_index = mskPlasma;
		damage     = 6;
		force      = 2;
		typ        = 1;
		big        = true;
		
		 // Alarms:
		alarm0 = 5;
		alarm1 = 20;
		
		return self;
	}
	
	
#define ElectroPlasmaImpact_create(_x, _y)
	/*
		ElectroPlasma's plasma explosion
	*/
	
	with(instance_create(_x, _y, PlasmaImpact)){
		 // Visual:
		sprite_index = spr.ElectroPlasmaImpact;
		
		 // Vars:
		mask_index = mskBullet1;
		damage     = 2;
		
		 // Effects:
		repeat(1 + irandom(1)){
			with(instance_create(x + orandom(6), y + orandom(6), PortalL)){
				depth = -6;
			}
		}
		
		 // Sounds:
		sound_play_hit(sndPlasmaHit,     0.4);
		sound_play_hit(sndGammaGutsProc, 0.4);
		
		return self;
	}
	
	
#define Jelly_create(_x, _y)
	/*
		A standard Trench enemy that floats around and fires lightning rings at the Player
		Lightning arcs between it and the nearest Eel, changing the Eel's color to the Jelly's color
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		 // Type:
		type = irandom(2);
		switch(crown_current){
			case crwn_guns : if(type == 0) type = 1; break;
			case crwn_life : if(type == 1) type = 0; break;
		}
		
		 // Visual:
		spr_idle     = spr.JellyIdle[type];
		spr_walk     = spr_idle;
		spr_hurt     = spr.JellyHurt[type];
		spr_dead     = spr.JellyDead[type];
		spr_fire     = spr.JellyFire;
		spr_shadow   = shd24;
		spr_shadow_y = 6;
		hitid        = [spr_idle, "JELLY"];
		depth        = -2;
		
		 // Sound:
		var _water = call(scr.area_get_underwater, GameCont.area);
		snd_hurt = (_water ? sndOasisHurt  : sndHitFlesh);
		snd_dead = (_water ? sndOasisDeath : sndBigMaggotDie);
		snd_mele = sndOasisMelee;
		
		 // Vars:
		mask_index  = mskLaserCrystal;
		maxhealth   = 42; // (type == 3 ? 72 : 52);
		raddrop     = 16; // (type == 3 ? 38 : 16);
		size        = 2;
		walk        = 0;
		walkspeed   = 1;
		maxspeed    = 3.4;
		meleedamage = 4;
		direction   = random(360);
		arc_num     = 0;
		arc_max     = 3;
		arc_dis     = 112;
		
		 // Alarms:
		alarm1 = 40 + irandom(20);
		
		return self;
	}
	
#define Jelly_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;

	 // Movement:
	var _max = min(maxspeed, max(1, 0.07 * walk));
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > _max){
		speed = _max;
	}

	 // Bouncy Boy:
	if(speed > 0){
		if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)) {
			if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
			if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
			enemy_look(direction);
		}
	}
	
	 // Animate:
	if(sprite_index != spr_fire){
		sprite_index = enemy_sprite;
	}

#define Jelly_alrm1
	alarm1 = 40 + random(20);
	
	 // Always movin':
	enemy_walk(direction, alarm1);
	
	if(enemy_target(x, y) && target_visible){
		var _targetDir = target_direction;
		
		 // Steer towards target:
		motion_add(_targetDir, 0.4);
		
		 // Attack:
		if(chance(1, 3)){
			var _targetDis = target_distance;
			if(_targetDis > 32 && _targetDis < 256){
				alarm1 += 30;
				
				 // Shoot Lightning Disc:
				var _inst = [];
				if(type <= 2){
					array_push(_inst, call(scr.projectile_create, x, y, "LightningDisc", _targetDir, 8));
				}
				else for(var _dir = _targetDir; _dir < _targetDir + 360; _dir += (360 / 3)){
					with(call(scr.projectile_create, x, y, "LightningDisc", _dir, 8)){
						shrink /= 2; // Last twice as long
						array_push(_inst, self);
					}
				}
				with(_inst){
					is_enemy    = true;
					maxspeed   *= 4/5;
					radius     *= 4/3;
					charge_spd *= 0.7;
				}
				
				 // Effects:
				sound_play_hit(sndLightningHit, 0.25);
				sound_play_pitch(sndLightningCrystalCharge, 0.8);
				sprite_index = spr_fire;
				alarm2 = 30;
			}
		}
	}
	
	enemy_look(direction);
	
#define Jelly_alrm2
	sprite_index = spr_walk;
	
#define Jelly_death
	if(type <= 2){
		pickup_drop(50, 2, 0);
	}
	else{
		pickup_drop(100, 10, 0);
	}
	
	
#define JellyElite_create(_x, _y)
	/*
		The elite Jelly
		Has a farther Eel arcing range, makes elite Eels, and shoots 3 lightning rings
	*/
	
	with(call(scr.obj_create, _x, _y, "Jelly")){
		 // Visual:
		type = 3;
		spr_idle = spr.JellyIdle[type];
		spr_walk = spr_idle;
		spr_hurt = spr.JellyHurt[type];
		spr_dead = spr.JellyDead[type];
		spr_fire = spr.JellyEliteFire;
		
		 // Sound:
		var _water = call(scr.area_get_underwater, GameCont.area);
		snd_hurt = sndLightningCrystalHit;
		snd_dead = (_water ? sndOasisDeath : sndLightningCrystalDeath);
		
		 // Vars:
		raddrop *= 2;
		arc_max = 5;
		arc_dis = 144;
		
		return self;
	}
	
	
#define Kelp_create(_x, _y)
	/*
		Kelp prop
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle    = spr.KelpIdle;
		spr_hurt    = spr.KelpHurt;
		spr_dead    = spr.KelpDead;
		image_speed = random_range(0.2, 0.3);
		depth       = -2;
		
		 // Sounds:
		snd_hurt = sndOasisHurt;
		snd_dead = sndOasisDeath;
		
		 // Vars:
		maxhealth = 2;
		size      = 1;
		
		return self;
	}
	
	
#define LightningDisc_create(_x, _y)
	/*
		Lightning ring projectiles that bounces around, slowly shrink, and zap enemies they come into contact with
		
		Vars:
			ammo           - How many segments the lightning ring has (3 == triangle)
			radius         - The radius of the lightning ring (wtf ??)
			rotation       - The ring's visual rotation for drawing
			rotspeed       - Added to 'rotation', makes it spin
			charge         - The value that image_xscale/image_yscale should grow towards
			charge_spd     - Multiplier of how fast image_xscale/image_yscale should grow towards 'charge'
			shrink         - How fast the ring should shrink after charging up
			maxspeed       - The speed to clamp down to after charging up
			is_enemy       - True/false, created by an enemy, determines laser brain and minor homing effects
			stretch        - The width of the ring (How fat the ring looks)
			super          - Describes the minimum size of the ring before splitting into more rings, -1 == no splitting
			creator_follow - True/false, should follow its creator while charging up
			primary        - Shot by a player's primary weapon (true) or secondary weapon (false)
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprLightning;
		image_speed  = 0.4;
		depth        = -3;
		
		 // Vars:
		mask_index     = mskWepPickup;
		image_xscale   = 0;
		image_yscale   = 0;
		rotspeed       = random_range(10, 20) * choose(-1, 1);
		rotation       = 0;
		radius         = 12;
		charge         = 1;
		charge_spd     = 2;
		ammo           = 10;
		typ            = 0;
		shrink         = 1/160;
		maxspeed       = 2.5;
		stretch        = 1;
		super          = -1;
		is_enemy       = false;
		creator_follow = true;
		primary        = true;
		setup          = true;
		
		 // Merged Weapons Support:
		temerge_on_fire  = script_ref_create(LightningDisc_temerge_fire);
		temerge_on_setup = script_ref_create(LightningDisc_temerge_setup);
		temerge_on_hit   = script_ref_create(LightningDisc_temerge_hit);
		
		return self;
	}
	
#define LightningDisc_setup
	setup = false;
	
	 // Enemy:
	if(is_enemy){
		if(sprite_index == sprLightning){
			sprite_index = sprEnemyLightning;
		}
	}
	
	 // Laser Brain:
	else{
		var _skill = skill_get(mut_laser_brain);
		charge      *= power(1.2,  _skill);
		stretch     *= power(1.2,  _skill);
		image_speed *= power(0.75, _skill);
	}

#define LightningDisc_step
	rotation += rotspeed * current_time_scale;
	
	 // Setup:
	if(setup) LightningDisc_setup();
	
	 // Charge Up:
	if(image_xscale < charge){
		var _spd = charge_spd;
		/*if(instance_is(creator, Player)) with(creator){
			_spd *= reloadspeed;
			_spd *= 1 + ((1 - (my_health / maxhealth)) * skill_get(mut_stress));
		}*/
		
		image_xscale += (charge / 20) * _spd * current_time_scale;
		image_yscale = image_xscale;
		
		if(creator_follow){
			if(instance_exists(creator)){
				x = creator.x;
				y = creator.y + (primary ? 0 : -4);
				
				if("gunangle" in creator){
					direction = creator.gunangle;
					x += hspeed;
					y += vspeed;
					
					 // Attempt to Unstick from Wall:
					if(place_meeting(x, y, Wall)){
						if(charge < 2.5){
							call(scr.instance_budge, self, Wall, 32);
						}
						
						 // Big boy:
						else with(call(scr.instances_meeting_instance, self, Wall)){
							if(place_meeting(x, y, other)){
								instance_create(x, y, FloorExplo);
								instance_destroy();
							}
						}
					}
				}
				
				 // Chargin'
				var _kick = (primary ? "" : "b") + "wkick";
				if(_kick in creator){
					variable_instance_set(creator, _kick, 5 * (image_xscale / charge));
				}
			}
		}
		
		 // Stay Still:
		xprevious = x;
		yprevious = y;
		x -= hspeed_raw;
		y -= vspeed_raw;
		
		 // Effects:
		sound_play_pitch(sndLightningHit, (image_xscale / charge));
		if(!is_enemy){
			sound_play_pitch(sndPlasmaReload, (image_xscale / charge) * 3);
			view_shake_max_at(x, y, 6 * image_xscale);
		}
	}
	else{
		if(charge > 0){
			 // Just in case:
			if(place_meeting(x, y, Wall)){
				with(Wall) if(place_meeting(x, y, other)){
					instance_create(x, y, FloorExplo);
					instance_destroy();
				}
			}
			
			 // Creator Stuff:
			with(creator){
				var	_kick = (other.primary ? "" : "b") + "wkick";
				if(_kick in self){
					variable_instance_set(self, _kick, -4);
				}
				
				 // Player Papa:
				if(instance_is(self, Player)){
					weapon_post(wkick, 16 * other.charge, 8 * other.charge);
					other.direction += orandom(6 * accuracy);
				}
			}
			
			 // Effects:
			sound_play_pitch(sndLightningCannonEnd, (3 + random(1)) / charge);
			with(instance_create(x, y, GunWarrantEmpty)) image_angle = other.direction;
			if(!is_enemy && skill_get(mut_laser_brain)){
				sound_play_pitch(sndLightningPistolUpg, 0.8);
			}
			
			charge = 0;
		}
		
		 // Random Zapp:
		if(!is_enemy){
			if(chance_ct(1, 30)){
				with(call(scr.instance_nearest_array, x, y, instances_matching_ne(hitme, "team", team, 0))){
					if(!place_meeting(x, y, other) && distance_to_object(other) < 32){
						with(other) LightningDisc_hit();
					}
				}
			}
		}
	}
	
	 // Slow:
	var _maxSpd = maxspeed;
	if(charge <= 0 && speed > _maxSpd) speed -= current_time_scale;
	
	 // Particles:
	if(current_frame_active){
		if(chance(image_xscale, 30) || (charge <= 0 && speed > _maxSpd && chance(image_xscale, 3))){
			var	_d = random(360),
				_r = random(radius),
				_x = x + lengthdir_x(_r * image_xscale, _d),
				_y = y + lengthdir_y(_r * image_yscale, _d);
				
			with(instance_create(_x, _y, PortalL)){
				motion_add(random(360), 1);
				if(other.charge <= 0){
					hspeed += other.hspeed;
					vspeed += other.vspeed;
				}
			}
		}
		
		 // Super Ring Split FX:
		if(super >= 0 && charge <= 0 && image_xscale < super + 1){
			if(chance(1, 12 * (image_xscale - super))){
				 // Particles:
				var _ang = random(360);
				repeat(irandom(2)){
					with(instance_create(x + lengthdir_x((image_xscale * 17) + hspeed, _ang), y + lengthdir_y((image_yscale * 17) + vspeed, _ang), LightningSpawn)){
						image_angle = _ang;
						image_index = 1;
						with(instance_create(x, y, PortalL)) image_angle  = _ang;
					}
				}
				view_shake_at(x, y, 3);
				
				 // Sound:
				var	_pitchMod = 1 / (4 * ((image_xscale - super) + .12));
					_vol = 0.1 / ((image_xscale - super) + 0.2);
					
				sound_play_pitchvol(sndGammaGutsKill, random_range(1.8, 2.5) * _pitchMod, min(_vol, 0.7));
				sound_play_pitchvol(sndLightningHit,  random_range(0.8, 1.2) * _pitchMod, min(_vol, 0.7) * 2);
				
				// Displacement:
				speed -= speed_raw * 0.02;
				x += orandom(3) * _pitchMod * current_time_scale;
				y += orandom(3) * _pitchMod * current_time_scale;
			}
		}
	}
	
	 // Shrink:
	if(charge <= 0){
		var s = shrink * current_time_scale;
		image_xscale -= s;
		image_yscale -= s;
		
		 // Super lightring split:
		if(super >= 0 && (image_xscale <= super || image_yscale <= super)){
			instance_destroy();
			exit;
		}
		
		 // Normal poof:
		if(image_xscale <= 0 || image_yscale <= 0){
			sound_play_hit(sndLightningHit, 0.5);
			instance_create(x, y, LightningHit);
			instance_destroy();
		}
	}
	
#define LightningDisc_hit
	if(projectile_canhit_melee(other)){
		 // Slow:
		if(image_xscale >= charge){
			x -= hspeed;
			y -= vspeed;
			direction = point_direction(x, y, other.x, other.y) + orandom(10);
		}
		
		 // Electricity Field:
		var	_tx = other.x,
			_ty = other.y,
			_d  = random(360),
			_r  = radius,
			_x  = x + lengthdir_x(_r * image_xscale, _d),
			_y  = y + lengthdir_y(_r * image_yscale, _d);
			
		with(call(scr.projectile_create, _x, _y, (is_enemy ? EnemyLightning : Lightning), point_direction(_x, _y, _tx, _ty) + orandom(12))){
			ammo = min(28, ceil(other.image_xscale + random(other.image_xscale * 2)));
			with(self){
				event_perform(ev_alarm, 0);
			}
		}
		
		 // Effects:
		with(other) instance_create(x, y, Smoke);
		sound_play(sndLightningHit);
	}
	
#define LightningDisc_wall
	var	_hprev = hspeed,
		_vprev = vspeed;
		
	if(image_xscale >= charge && (image_xscale < 2.5 || image_yscale < 2.5)){
		 // Bounce:
		if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
		if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
		
		with(other){
			 // Bounce Effect:
			var	_x = x + 8,
				_y = y + 8,
				_dis = 8,
				_dir = point_direction(_x, _y, other.x, other.y);
				
			instance_create(_x + lengthdir_x(_dis, _dir), _y + lengthdir_y(_dis, _dir), PortalL);
			sound_play_hit(sndLightningHit, 0.2);
		}
	}
	
	 // Too powerful to b contained:
	if(image_xscale > 1.2 || image_yscale > 1.2){
		with(other){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
		with(Wall) if(place_meeting(x - _hprev, y - _vprev, other)){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
	}
	
#define LightningDisc_destroy
	if(super >= 0){
		 // Effects:
		sleep(80);
		sound_play_pitchvol(sndLightningPistolUpg, 0.7,               0.4);
		sound_play_pitchvol(sndLightningPistol,    0.7,               0.6);
		sound_play_pitchvol(sndGammaGutsKill,      0.5 + random(0.2), 0.7);
		
		 // Disc Split:
		var _ang = random(360);
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 5)){
			with(call(scr.projectile_create, x, y, "LightningDisc", _dir, 10)){
				charge = other.image_xscale / 1.2;
				creator_follow = false;
				
				 // Insta-Charge:
				image_xscale = charge * 0.9;
				image_yscale = charge * 0.9;
			}
			
			 // Clear Walls:
			var _len = 24;
			instance_create(x + lengthdir_x(_len, _dir), y + lengthdir_y(_len, _dir), PortalClear);
		}
	}
	
#define LightningDisc_draw
	scrDrawLightningDisc(sprite_index, image_index, x, y, ammo, radius, stretch, image_xscale, image_yscale, image_angle + rotation, image_blend, image_alpha);
	
#define scrDrawLightningDisc(_spr, _img, _x, _y, _num, _radius, _stretch, _xscale, _yscale, _angle, _blend, _alpha)
	var	_off = (360 / _num),
		_ysc = _stretch * (0.5 + random(1));
		
	for(var _d = _angle; _d < _angle + 360; _d += _off){
		var	_ro  = random(2),
			_rx  = (_radius * _xscale) + _ro,
			_ry  = (_radius * _yscale) + _ro,
			_x1  = _x + lengthdir_x(_rx, _d),
			_y1  = _y + lengthdir_y(_ry, _d),
			_x2  = _x + lengthdir_x(_rx, _d + _off),
			_y2  = _y + lengthdir_y(_ry, _d + _off),
			_xsc = point_distance(_x1, _y1, _x2, _y2) / 2,
			_ang = point_direction(_x1, _y1, _x2, _y2);
			
		draw_sprite_ext(_spr, _img, _x1, _y1, _xsc, _ysc, _ang, _blend, _alpha);
	}
	
#define LightningDisc_temerge_fire(_at, _setupInfo)
	_setupInfo.super = super;
	
#define LightningDisc_temerge_setup(_instanceList, _setupInfo)
	if(_setupInfo.super >= 0){
		with(_instanceList){
			if("temerge_lightning_disc" not in self){
				temerge_lightning_disc = { "super_count": 0 };
				call(scr.projectile_add_temerge_event, self, "destroy", script_ref_create(LightningDisc_temerge_destroy));
			}
			temerge_lightning_disc.super_count++;
		}
	}
	
#define LightningDisc_temerge_hit
	if(call(scr.projectile_can_temerge_hit, other)){
		var	_dir     = random(360),
			_xOffset =  dcos(_dir),
			_yOffset = -dsin(_dir);
			
		_xOffset = clamp(((_xOffset < 0) ? bbox_left : (bbox_right  + 1)) - x, -32, 32) * abs(_xOffset);
		_yOffset = clamp(((_yOffset < 0) ? bbox_top  : (bbox_bottom + 1)) - y, -32, 32) * abs(_yOffset);
		
		with(call(scr.projectile_create,
			x + _xOffset,
			y + _yOffset,
			Lightning,
			point_direction(x + _xOffset, y + _yOffset, other.x, other.y) + orandom(12)
		)){
			ammo = min(28, irandom_range(floor(other.damage * 0.5), ceil(other.damage)));
			with(self){
				event_perform(ev_alarm, 0);
			}
		}
	}
	
#define LightningDisc_temerge_destroy
	if(temerge_lightning_disc.super_count > 0){
		repeat(temerge_lightning_disc.super_count){
			with(call(scr.projectile_create, x, y, "LightningDisc", direction, 10)){
				charge = lerp(other.damage / 10, 1, 0.5);
				creator_follow = false;
				
				 // Insta-Charge:
				image_xscale = charge * 0.9;
				image_yscale = charge * 0.9;
			}
		}
	}
	
	
//#define LightningTether_create(_x, _y)
//	/*
//		...
//	*/
//	
//	with(instance_create(_x, _y, CustomObject)){
//		 // Visual:
//		spr_lightning = -1;
//		
//		 // Vars:
//		link         = array_create(2, noone);
//		active       = false;
//		broken       = false;
//		distance_max = 96;
//		delay_max    = 6;
//		delay        = delay_max;
//		arc_min      = 4;
//		arc_max      = 16;
//		arc_speed    = 1/150;
//		is_enemy     = false;
//		creator      = noone;
//		wave         = 0;
//		
//		 // :
//		for(var i = 0; i < array_length(link); i++){
//			link[i] = {
//				"x"        : x,
//				"y"        : y,
//				"distance" : 0,
//				"target"   : noone
//			};
//		}
//		
//		return self;
//	}
//	
//#define LightningTether_step
//	var	_linkMax  = array_length(link),
//		_overWall = false,
//		_active   = true;
//		
//	 // Connection Management:
//	if(!broken){
//		with(link){
//			if(target != noone){
//				 // Follow Target:
//				if(instance_exists(target)){
//					var	_spd     = target.speed_raw,
//						_dir     = target.direction,
//						_gravSpd = target.gravity_raw,
//						_gravDir = target.gravity_direction;
//						
//					_spd -= min(abs(_spd), target.friction_raw) * sign(_spd);
//					
//					x = target.x + lengthdir_x(_spd, _dir) + lengthdir_x(_gravSpd, _gravDir);
//					y = target.y + lengthdir_y(_spd, _dir) + lengthdir_y(_gravSpd, _gravDir);
//					
//					 // Appears Over Walls:
//					if(target.depth < -6){
//						_overWall = true;
//					}
//				}
//				
//				 // Target Destroyed:
//				else{
//					other.broken = true;
//					other.delay  = other.delay_max;
//					break;
//				}
//			}
//		}
//		
//		 // Check Connection Validity:
//		if(!broken){
//			for(var i = 0; i < _linkMax - 1; i++){
//				var	_link = link[i],
//					_next = link[i + 1];
//					
//				 // Determine Tether Distance:
//				if(instance_exists(_link.target)){
//					with(_link.target){
//						_link.distance = (
//							instance_exists(_next.target)
//							? distance_to_object(_next.target)
//							: distance_to_point(_next.x, _next.y)
//						);
//					}
//				}
//				else _link.distance = point_distance(_link.x, _link.y, _next.x, _next.y);
//				
//				 // Stop Tethering if Too Far or Interrupted by Walls:
//				if(_link.distance > distance_max || (!_overWall && collision_line(_link.x, _link.y, _next.x, _next.y, Wall, false, false))){
//					_active = false;
//					break;
//				}
//			}
//		}
//	}
//	
//	 // Activate Lightning Tether:
//	if(delay > 0){
//		delay -= current_time_scale;
//		
//		if(_active && !active){
//			 // Tethering...
//			if(current_frame_active){
//				for(var i = 0; i < _linkMax - 1; i++){
//					var	_link = link[i],
//						_next = link[i + 1],
//						_num  = random(1);
//						
//					with(instance_create(
//						lerp(_link.x, _next.x, _num),
//						lerp(_link.y, _next.y, _num),
//						choose(PortalL, LaserCharge)
//					)){
//						if(object_index == LaserCharge){
//							sprite_index = (sprite_exists(other.spr_lightning) ? other.spr_lightning : (other.is_enemy ? sprEnemyLightning : sprLightning));
//							image_xscale = random_range(0.5, 2);
//							image_yscale = random_range(0.5, 2);
//							image_angle  = random(360);
//							alarm0       = 4 + random(4);
//						}
//						motion_add(random(360), 1);
//					}
//				}
//			}
//			
//			 // Tethered:
//			if(delay <= 0){
//				active = true;
//				
//				 // Sound:
//				with(link[array_length(link) - 1]){
//					call(scr.sound_play_at, x, y, sndLightningHit, 2);
//				}
//				
//				 // Laser Brain FX:
//				if(!is_enemy && skill_get(mut_laser_brain) > 0){
//					for(var i = 0; i < _linkMax; i++){
//						var _next = link[(i + 1) % array_length(link)];
//						with(link[i]){
//							with(instance_create(x, y, LaserBrain)){
//								image_angle = point_direction(x, y, _next.x, _next.y) + orandom(10);
//								creator     = other.target;
//							}
//						}
//					}
//				}
//			}
//		}
//	}
//	
//	 // Lightning Tethering:
//	if(active){
//		for(var i = 0; i < _linkMax - 1; i++){
//			var	_link = link[i],
//				_next = link[i + 1],
//				_arc  = lerp(arc_max, arc_min, _link.distance / distance_max) * sin(wave * arc_speed * 2 * pi),
//				_inst = lightning_connect(_link.x, _link.y, _next.x, _next.y, _arc, is_enemy, creator);
//				
//			 // Appear Over Walls:
//			if(_overWall){
//				with(_inst){
//					var _lastMask = mask_index;
//					mask_index = -1;
//					depth = (
//						(place_meeting(x, y + 8, Wall) || !place_meeting(x, y + 8, Floor))
//						? -8
//						: -1
//					);
//					mask_index = _lastMask;
//				}
//			}
//			
//			 // Untether:
//			if(!_active || (broken && delay <= 0)){
//				active = false;
//				
//				 // Sound:
//				sound_play_pitchvol(sndLightningReload, 0.7 + random(0.2), 0.5);
//				
//				 // Disappearing Visual:
//				with(_inst){
//					with(instance_create(x, y, object_index)){
//						other.image_speed = image_speed;
//						instance_delete(self);
//					}
//					with(instance_create(x, y, BoltTrail)){
//						sprite_index = other.sprite_index;
//						image_index  = other.image_index;
//						image_speed  = other.image_speed;
//						image_xscale = other.image_xscale;
//						image_yscale = other.image_yscale * power(0.4 / other.image_speed, 4/3);
//						image_angle  = other.image_angle;
//						image_blend  = other.image_blend;
//						image_alpha  = other.image_alpha;
//						depth        = other.depth;
//						
//						 // Dissipate Enemy Lightning Faster:
//						if(instance_is(other, EnemyLightning)){
//							image_yscale -= random(0.4);
//						}
//					}
//					
//					 // Hide / Destroy Lightning:
//					if(instance_is(self, EnemyLightning)){
//						instance_delete(self);
//					}
//					else{
//						image_index = 0;
//						image_alpha = 0;
//					}
//				}
//			}
//		}
//	}
//	
//	 // Animation:
//	wave += current_time_scale;
//	
//	 // Connection Permanently Broken:
//	if(broken && delay <= 0){
//		instance_destroy();
//	}
	
	
#define PitSink_create(_x, _y)
	/*
		Used for the visual of objects falling into Trench's pits
		Use the 'pit_sink' script in trench.area to make one of these
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		image_speed = 0;
		visible     = false;
		
		 // Vars:
		friction  = 0.01;
		speed     = 1;
		direction = random(360);
		rotspeed  = 0;
		
		return self;
	}
	
#define PitSink_step
	 // Blackness Consumes:
	image_blend = merge_color(c_black, image_blend, power(0.95, current_time_scale));
	
	 // Shrink into Abyss:
	var _d = random_range(0.001, 0.01) * current_time_scale;
	image_xscale -= sign(image_xscale) * _d;
	image_yscale -= sign(image_yscale) * _d;
	if(vspeed < 0){
		vspeed *= 0.9;
	}
	y += 1/3 * current_time_scale;
	
	 // Spins:
	direction   += rotspeed * current_time_scale;
	image_angle += rotspeed * current_time_scale;
	
	 // He gone:
	if(abs(image_xscale) < 2/3){
		instance_destroy();
	}
	
	
#define PitSpark_create(_x, _y)
	/*
		Cool pit tentacle effect used by PitSquid
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.PitSpark[irandom(array_length(spr.PitSpark) - 1)];
		image_angle  = random(360);
		image_speed  = 0.4;
		depth        = 5;
		
		 // Vars:
		mask_index       = mskReviveArea;
		dark             = irandom(1);
		tentacle         = {};
		tentacle_visible = true;
		with(tentacle){
			scale    = 1 + (0.1 * GameCont.loops);//random_range(1, 1.2);
			right    = choose(-1, 1);
			rotation = random(360);
			move_dir = random(360);
			move_spd = random(1.6);
			distance = irandom_range(28, 12) * scale;
		};
		
		 // Alarms:
		alarm0 = 15 + random(5);
		
		return self;
	}
	
#define PitSpark_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Movement:
	if(tentacle_visible) with(tentacle){
		rotation += right * current_time_scale * 7;
		distance += move_spd * current_time_scale;
	}
	
	 // Goodbye:
	if(anim_end) visible = false;
	
#define PitSpark_alrm0
	instance_destroy();
	
	
#define PitSquid_create(_x, _y)
	/*
		Trench boss bro, resides in the pits
		
		Vars:
			xpos/ypos          - Custom x/y position so nothing interacts with PitSquid, like bolt marrow
			meleedamage        - Bite damage
			bite               - Delay before biting, set to 1 for a basic bite or above 1 for a delayed bite. Based on # of frames in spr_bite.
			spit               - Delay before spitting, set to 1 for a basic spit or above 1 for a delayed spit. Based on # of frames in spr_spit.
			ammo               - How many electroplasma to spit
			electroplasma_side - Used to determine which directional side to spit ElectroPlasma, -1/1
			electroplasma_last - The most recently spat ElectroPlasma, used to tether the next ElectroPlasma to it
			sink               - Sink into the pits, true/false
			pit_height         - Height in the pits, 0 to 1 (1 == at the top, 0 == smaller than a pixel)
			intro              - Boss intro played, true/false
			rise_delay         - How long to wait before rising out of the pits, used for initial intro pit smash
			tauntdelay         - Delay before taunting after all Players are dead
			eye                - List of eye LWOs (see 'Eye Vars')
			eye_dir            - PitSquid's eye rotation offset
			eye_dir_speed      - Added to 'eye_dir' to spin PitSquid
			eye_dis            - PitSquid's eye offset
			eye_laser          - How many frames to shoot eye lasers
			eye_laser_delay    - Delay before shooting eye lasers, usually set same time as 'eye_laser'
			alarm1             - Used for PitSquid's general AI
			alarm2             - Used for PitSquid's attacks
			alarm3             - Used for spawning PitSpark effects
			
		Eye Vars:
			x/y       - Eye's center position, set for reference like with drawing and stuff
			dis/dir   - Distance/direction offset of the pupil from the eye's center position
			blink     - Close the eye, true/false
			blink_img - Frame index of the eyelid, based on spr.PitSquidEyelid
			my_laser  - The QuasarBeam instance when firing eye lasers
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
		 // Visual:
		spr_bite       = spr.PitSquidMawBite;
		spr_fire       = spr.PitSquidMawSpit;
		spr_bubble     = -1;
		spr_bubble_pop = -1;
		spr_bubble_x   = 0;
		spr_bubble_y   = 0;
		hitid          = [spr_fire, "PIT SQUID"];
		
		 // Sounds:
		snd_hurt = sndBigDogHit;
		snd_dead = sndNothing2Hurt;
		snd_lowh = sndNothing2HalfHP;
		
		 // Vars:
		xpos               = x;
		ypos               = y;
		x                  = 0;
		y                  = 0;
		friction           = 0.01;
		mask_index         = mskNone;
		mask               = sprPortalClear;
		meleedamage        = 8;
		maxhealth          = call(scr.boss_hp, 340);
		tauntdelay         = 60;
		intro              = false;
		raddrop            = 50;
		size               = 5;
		canfly             = true;
		target             = noone;
		bite               = 0;
		sink               = false;
		pit_height         = 1;
		spit               = 0;
		ammo               = 0;
		gunangle           = random(360);
		electroplasma_side = choose(-1, 1);
		electroplasma_last = noone;
		rise_delay         = 0;
		
		 // Eyes:
		eye             = [];
		eye_dir         = random(360);
		eye_dir_speed   = 0;
		eye_dis         = 0;
		eye_laser       = 0;
		eye_laser_delay = 0;
		repeat(3){
			array_push(eye, {
				x         : 0,
				y         : 0,
				dis       : 5,
				dir       : random(360),
				blink     : true,
				blink_img : 0,
				my_laser  : noone
			});
		}
		
		 // Loop:
		var _grow = 0.1 * GameCont.loops;
		image_xscale += _grow;
		image_yscale += _grow;
		
		 // Alarms:
		alarm1 = 90;
		alarm2 = 90;
		alarm3 = random_range(1, 30);
		
		 // Clear Pits:
		mask_index = mask;
		with(call(scr.wall_clear, self, xpos, ypos - 16)){
			pit_clear     = 0.75;
			image_xscale *= 1.2 * (1 / pit_clear);
			image_yscale *= 1.2 * (1 / pit_clear);
		}
		mask_index = mskNone;
		
		 // For Sani's bosshudredux:
		bossname = hitid[1];
		col      = c_red;
		
		return self;
	}
	
#define PitSquid_step
	xprevious = xpos;
	yprevious = ypos;
	x         = xpos;
	y         = ypos;
	
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	if(alarm3_run) exit;
	
	 // Pit Z Movement:
	if(sink || rise_delay > 0){
		rise_delay -= current_time_scale;
		
		 // Quickly Sink:
		var _heightGoal = (instance_exists(Player) ? 0.5 : 0);
		if(pit_height > _heightGoal){
			pit_height += ((_heightGoal - pit_height) / (instance_exists(Player) ? 4 : 8)) * current_time_scale;
			if(abs(_heightGoal - pit_height) < 0.05){
				pit_height = _heightGoal;
			}
			
			 // Close Eyes:
			with(eye){
				blink = true;
			}
		}
		
		/*
		 // Start Rising:
		if(pit_height <= 0.5){
			sink = false;
			pit_height = -random_range(0.2, 0.5);
		}
		*/
		
		 // Intro Dim Music:
		if(
			!intro
			&& "ntte_music_index" in GameCont
			&& audio_is_playing(GameCont.ntte_music_index)
		){
			var _vol = audio_sound_get_gain(GameCont.ntte_music_index);
			if(_vol > 0.3){
				sound_volume(GameCont.ntte_music_index, _vol - (0.01 * current_time_scale));
			}
		}
	}
	else{
		 // Slow Initial Rise:
		if(pit_height < 0.5){
			pit_height += abs(sin(current_frame / 30)) * 0.02 * current_time_scale;
			
			 // Prepare Bite:
			if(bite <= 0 && pit_height > 0.3){
				bite = 0.6;
			}
		}
		
		 // Quickly Rise:
		else if(pit_height < 1){
			if(bite <= 0) bite = 1;
			else if(((1 - bite) * sprite_get_number(spr_bite)) >= 6){
				pit_height += 0.1 * current_time_scale;
				
				 // Reached Top of Pit:
				if(pit_height >= 1){
					pit_height = 1;
					alarm1 = 10 + random(10);
					alarm2 = 30 + random(10);
					speed /= 3;
					
					 // Smash Floors:
					mask_index = mask;
					with(call(scr.wall_clear, self, x, y - 16)){
						pit_clear     = 0.75;
						pit_smash     = true;
						image_xscale *= 1.2 * (1 / pit_clear);
						image_yscale *= 1.2 * (1 / pit_clear);
						
						 // Big Intro Clear:
						if(!other.intro){
							image_xscale *= 1.5;
							image_yscale *= 1.5;
						}
					}
					mask_index = mskNone;
					with(eye) blink = true;
					view_shake_at(x, y, 30);
					sound_play(sndOasisExplosion);
					
					 // Boss Intro:
					if(!intro){
						intro = true;
						call(scr.boss_intro, "PitSquid");
						sound_play(sndBigDogIntro);
						sound_play_pitchvol(sndNothing2Taunt, 0.7, 0.8);
						view_shake_at(x, y, 30);
					}
				}
			}
		}
	}
	
	 // Sinking/Rising FX:
	if(pit_height > 0.5 && pit_height < 1 && current_frame_active){
		instance_create(x + orandom(32), y + orandom(32), Smoke);
		view_shake_at(x, y, 4);
	}
	
	 // Movement:
	if(eye_laser > 0){
		speed = 0;
	}
	else if(speed > 0){
		eye_dir_speed += (speed / 10) * current_time_scale;
		direction     += sin(current_frame / 20) * current_time_scale;
		
		 // Effects:
		if(current_frame_active){
			view_shake_max_at(x, y, min(speed * 4, 3));
		}
		if(chance_ct(speed, 10 / pit_height)){
			instance_create(x + orandom(40), y + orandom(40), Bubble);
		}
	}
	
	 // Eye Lasering:
	if(eye_laser_delay > 0){
		eye_laser_delay -= current_time_scale;
		if(eye_laser > 0){
			if(bite <= 0 && eye_laser_delay < 30){
				bite = 1.2;
			}
			var _s = sound_play_pitchvol(sndNothing2Appear, 0.7, 1.5);
			audio_sound_set_track_position(_s, audio_sound_length_nonsync(_s) * clamp(eye_laser_delay / 40, 0, 0.8));
		}
	}
	if(eye_laser > 0){
		if(eye_laser_delay <= 0){
			eye_laser -= current_time_scale;
		}
		
		 // Spinny:
		if(eye_laser > 30){
			eye_dir_speed += (0.1 - (0.03 * (image_xscale - 1))) * current_time_scale;
		}
		else with(eye){
			blink = true;
		}
		
		 // Away From Walls:
		var _n = instance_nearest(x - 8, y - 8, Wall);
		if(instance_exists(_n)){
			motion_add_ct(point_direction(_n.x + 8, _n.y + 8, x, y), 0.5);
		}
		
		 // End:
		if(eye_laser <= 0 || !instance_exists(Player) || pit_height < 1){
			eye_laser = 0;
			eye_laser_delay = random_range(30, 150);
		}
	}
	
	 // Eyes:
	var	_target     = noone,
		_targetDis  = infinity,
		_eyeDisGoal = 0;
		
	with(Player){
		var _dis = point_distance(x, y, other.x, other.y);
		if(_dis < _targetDis){
			if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
				_targetDis = _dis;
				_target    = self;
			}
		}
	}
	
	eye_dir       += eye_dir_speed * right * current_time_scale;
	eye_dir_speed *= power(0.9, current_time_scale);
	
	for(var i = 0; i < array_length(eye); i++){
		var	_dis = (24 + eye_dis) * max(pit_height, 0),
			_dir = image_angle + eye_dir + ((360 / array_length(eye)) * i),
			_x   = x + hspeed_raw + lengthdir_x(_dis * image_xscale, _dir),
			_y   = y + vspeed_raw + lengthdir_y(_dis * image_yscale, _dir);
			
		with(eye[i]){
			x = _x;
			y = _y;
			
			 // Look at Player:
			if(other.eye_laser <= 0 && !instance_exists(my_laser)){
				var _seen = false;
				if(instance_exists(_target)){
					_seen = true;
					dir = angle_lerp_ct(dir, point_direction(x, y, _target.x, _target.y),           0.3);
					dis = lerp_ct(dis, clamp(point_distance(x, y, _target.x, _target.y) / 6, 0, 5), 0.3);
				}
				else dir += sin((current_frame) / 20) * 1.5;
			}
			
			 // Blinking:
			if(blink || (other.eye_laser > 0 && other.eye_laser_delay > 0)){
				var n = sprite_get_number(spr.PitSquidEyelid) - 1;
				blink_img += other.image_speed * (instance_exists(my_laser) ? 0.5 : 1) * current_time_scale;
				
				 // Gonna Laser:
				if(other.eye_laser > 0){
					var _dir = point_direction(other.x, other.y, x, y);
					if(chance_ct(10, other.eye_laser_delay)){
						if(chance(1, 7)){
							with(call(scr.obj_create, x + orandom(12), y, "PitSquidL")){
								if(chance(1, 2)){
									sprite_index = asset_get_index(`sprPortalL${irandom_range(1, 5)}`);
								}
							}
						}
						else{
							with(instance_create(x + orandom(16), y, PlasmaTrail)){
								sprite_index = spr.QuasarBeamTrail;
								hspeed += orandom(1.5);
								vspeed += orandom(0.8);
							}
						}
					}
				}
				
				 // End Blink:
				if(blink_img >= n){
					blink_img = n;
					if((instance_exists(Player) || other.pit_height >= 1) && (other.intro || other.pit_height < 1)){
						if(chance(1, 4)){
							blink = false;
						}
					}
				}
			}
			
			else{
				blink_img = max(blink_img - other.image_speed, 0);
				
				 // Eye Lasers:
				if(other.eye_laser > 0){
					dis *= power(0.1, current_time_scale);
					
					if(!instance_exists(my_laser)){
						my_laser = call(scr.pass, other, scr.projectile_create, x, y, "QuasarBeam", _dir);
						with(my_laser){
							damage         = 6;
							bend_fric      = 0.2;
							scale_goal     = 0.8 * creator.image_xscale;
							follow_creator = false;
							mask_index     = mskSuperFlakBullet;
							image_xscale   = scale_goal / 2;
							image_yscale   = scale_goal / 2;
							depth          = -3;
						}
					}
					with(my_laser){
						shrink_delay = 4;
					}
				}
				
				 // Blink:
				if(blink_img <= 0){
					if(chance_ct(1, (_seen ? 150 : 100))){
						blink = true;
					}
				}
			}
			
			 // Lasering:
			if(instance_exists(my_laser)){
				_eyeDisGoal = -4;
				with(my_laser){
					hold_x = other.x;
					hold_y = other.y;
					line_dir_goal = _dir;
				}
			}
			
			 // Effects:
			/* hmhmmm for now i feel like theres too many particles to focus on i will just comment this out for now sorry
			if(other.pit_height >= 1 && chance_ct(!blink, 150)){
				with(call(scr.obj_create, x + orandom(20), y + orandom(20), "PitSquidL")){
					motion_add(point_direction(other.x, other.y, x, y), 1);
				}
			}*/
		}
	}
	
	 // Spit:
	if(spit > 0){
		_eyeDisGoal = 8;
		
		var	_spr = spr_fire,
			_img = ((1 - spit) * sprite_get_number(_spr));
			
		if(_img < 6 || ammo <= 0){
			spit -= (image_speed_raw / sprite_get_number(_spr));
			
			 // Effects:
			if(chance_ct(1, 5)){
				instance_create(x + orandom(4), y + orandom(4), Bubble);
			}
		}
	}
	
	 // Bite:
	if(bite > 0){
		_eyeDisGoal = 8;
		
		var	_spr = spr_bite,
			_img = (1 - bite) * sprite_get_number(_spr);
			
		 // Finish chomp at top of pit:
		if(
			_img <  6 ||
			_img >= 8 ||
			(pit_height > 0.5 && (eye_laser <= 0 || eye_laser_delay <= 0))
		){
			bite -= (image_speed_raw / sprite_get_number(_spr));
		}
		
		 // Bite Time:
		if(_img >= 8 && _img < 9){
			if(pit_height > 0.5){
				mask_index = mask;
				with(call(scr.instances_meeting_instance, self, instances_matching_ne(hitme, "team", team))){
					with(other) if(place_meeting(x, y, other)){
						if(projectile_canhit_melee(other)){
							projectile_hit(other, meleedamage);
							if("lasthit" in other){
								other.lasthit = [spr_bite, "PIT SQUID"];
							}
						}
					}
				}
				mask_index = mskNone;
			}
			
			 // Chomp FX:
			if(_img - image_speed_raw < 8){
				sound_play_pitchvol(snd_mele, 0.8 + orandom(0.1), 0.8);
				sound_play_pitchvol(sndOasisChest, 0.8 + orandom(0.1), 1);
				repeat(3) instance_create(x, y, Bubble);
			}
		}
	}
	
	eye_dis += ((_eyeDisGoal - eye_dis) / 5) * current_time_scale;
	
	 // Death Taunt:
	if(tauntdelay > 0 && !instance_exists(Player)){
		tauntdelay -= current_time_scale;
		if(tauntdelay <= 0 && intro){
			if(!sink){
				sink = true;
				eye_dir_speed -= 8;
				sound_play_pitchvol(sndNothing2Hurt,      0.6, 0.4);
				sound_play_pitchvol(sndNothingHurtHigh,   0.3, 0.5);
			}
			sound_play_pitchvol(sndNothingGenerators, 0.4, 0.4);
		}
	}
	
	xpos = x;
	ypos = y;
	x    = 0;
	y    = 0;
	
#define PitSquid_end_step
	xpos += hspeed_raw;
	ypos += vspeed_raw;
	
	 // Pit Collision:
	if(pit_height > 0.5){
		mask_index = mask;
		if(pitless_meeting(xpos, ypos - 16) && !pitless_meeting(xprevious, yprevious - 16)){
			xpos = xprevious;
			ypos = yprevious;
			
			 // Bounce:
			if(pitless_meeting(xpos + hspeed_raw, ypos - 16             )) hspeed_raw *= -1;
			if(pitless_meeting(xpos,              ypos - 16 + vspeed_raw)) vspeed_raw *= -1;
			speed *= 0.8;
		}
		mask_index = mskNone;
	}
	
#define PitSquid_alrm1
	alarm1 = 20 + irandom(30);
	
	if(enemy_target(x, y)){
		if(intro || pit_height < 1 || (instance_number(enemy) - instance_number(Van)) <= array_length(instances_matching_ne(obj.PitSquid, "id"))){
			if(intro || pit_height < 1){
				var	_targetDir = target_direction,
					_targetDis = target_distance;
					
				if(_targetDis >= 96 || pit_height < 1 || chance(1, 2)){
					if(chance(pit_height, 2) || !intro){
						motion_add(_targetDir, 1);
						sound_play_pitchvol(sndRoll, 0.2 + random(0.2), 2)
						sound_play_pitchvol(sndFishRollUpg, 0.4, 0.2);
					}
					
					 // In Pit:
					if(sink){
						alarm1 = 20 + random(10);
						
						direction = _targetDir;
						speed = max(speed, 2.4);
						if(!intro) speed = min(speed, 3);
						
						 // Rise:
						if(
							_targetDis < (intro ? 40 : 120) * image_xscale ||
							(
								intro &&
								(
									(_targetDis < (160 * image_xscale) && !call(scr.pit_get, x, y)) ||
									(_targetDis < (128 * image_xscale) && (chance(1, 2) || !chance(my_health, maxhealth)))
								)
							)
						){
							sink = false;
							if(!intro){
								speed /= 2;
								rise_delay = 84;
								sound_play_pitchvol(mus.PitSquidIntro, 1, audio_sound_get_gain(mus.Trench));
							}
						}
					}
				}
				
				if(pit_height >= 1){
					 // Check LOS to Player:
					var _targetSeen = (_targetDis < 240 && target_visible);
					if(_targetSeen && (chance(2, 3) || _targetDis > 128) && eye_laser <= 0){
						var _pits = FloorPit;
						with(_pits){
							x -= 10000;
						}
						if(collision_line(x, y, target.x, target.y, Floor, false, false)){
							_targetSeen = false;
						}
						with(_pits){
							x += 10000;
						}
					}
					
					 // Sink into pit:
					if(!_targetSeen && eye_laser_delay <= 0){
						sink = true;
						alarm1 = 20;
					}
					
					 // Spawn Tentacles:
					else{
						var	_ang = random(360),
							_num = irandom_range(2, 3 + floor(5 * (image_xscale - 1)));
							
						for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
							var _armNum = array_length(instances_matching(obj.PitSquidArm, "creator", self));
							if(
								_armNum < 2 + (10 * (image_xscale - 1))
								|| chance(1, 5 + (5 * _armNum))
							){
								with(call(scr.obj_create, x + dcos(_dir), y - dsin(_dir) - 8, "PitSquidArm")){
									creator = other;
									hitid   = other.hitid;
									if(chance(1, 2)){
										PitSquidArm_alrm2();
										alarm2 = 1;
									}
									else{
										alarm2 = irandom_range(60, 150);
									}
								}
							}
						}
					}
				}
			}
			else sink = true;
		}
	}
	
#define PitSquid_alrm2
	alarm2 = 40 + random(20);
	
	if(pit_height >= 1 && intro){
		 // Electroplasma Volley:
		if(ammo > 0){
			spit = 0.6;
			
			 // Aiming:
			var _targetDis = 96;
			if(enemy_target(x, y) && target_visible){
				_targetDis = target_distance;
				
				var	_tx = target.x + ((_targetDis / 12) * target.hspeed),
					_ty = target.y + ((_targetDis / 12) * target.vspeed);
					
				gunangle += clamp(angle_difference(point_direction(x, y, _tx, _ty), gunangle) * 0.5, -60, 60);
			}
			
			 // Projectile:
			var	_last = electroplasma_last,
				_ang  = (2000 / max(1, _targetDis)) * image_xscale;
				
			with(call(scr.projectile_create, x, y, "ElectroPlasma", gunangle + (_ang * electroplasma_side), 5)){
				tether_inst = _last;
				image_xscale *= other.image_xscale;
				image_yscale *= other.image_yscale;
				damage = 1;
				
				_last = self;
			}
			electroplasma_last = _last;
			electroplasma_side *= -1;
			
			 // Sounds:
			sound_play_pitch(sndOasisShoot,       1.1 + random(0.3));
			sound_play_pitchvol(sndGammaGutsProc, 0.9 + random(0.5), 0.4);
			
			 // Effects:
			instance_create(x + orandom(8), y + orandom(8), PortalL);
			view_shake_max_at(x, y, 5);
			 
			 // Continue:
			if(--ammo > 0){
				alarm2 = 5 + random(2);
				alarm1 = alarm1 + alarm2;
			}
			
			 // End:
			else{
				sound_play_pitchvol(sndOasisDeath, 0.9 + random(0.3), 2.4);
			}
		}
		
		else if(enemy_target(x, y)){
			var	_targetDis = target_distance,
				_targetDir = target_direction;
				
			if(target_visible){
				 // Bite Player:
				if(point_distance(x + hspeed, y + vspeed, target.x, target.y) < 64){
					motion_set(_targetDir, _targetDis / 32);
					bite = 1.2;
				}
				
				 // Ranged Attack:
				else{
					 // Half-Health Laser:
					if(eye_laser <= 0 && eye_laser_delay <= 0 && my_health < maxhealth / 2){
						eye_laser = 90 + random(450);
						eye_laser_delay = 60;
						right *= -1;
						sound_play_pitchvol(sndGammaGutsKill,      0.6 + random(0.1), 0.8);
						sound_play_pitchvol(sndHyperCrystalSearch, 0.6 + random(0.1), 0.8);
					}
					
					 // Begin Volley Attack:
					else{
						spit = 1.2;
						alarm2 = 15;
						alarm1 = alarm1 + alarm2;
						
						ammo = 3 + irandom(2 * image_xscale);
						gunangle = _targetDir;
						
						 // Sounds:
						sound_play_pitchvol(sndOasisHorn, 0.9, 2.4);
					}
				}
			}
		}
	}
	
	 // Just in Case:
	else{
		ammo = 0;
	}
	
#define PitSquid_alrm3
	var	_floors = FloorPit,
		_sparks = instances_matching_ne(obj.PitSpark, "id");
		
	alarm3 = random_range(1, 12) + (12 * array_length(_sparks)) + (30 / array_length(_floors));
	
	 // Cool tentacle effects:
	if(pit_height >= 1 && intro){
		var _tries = 10;
		while(_tries-- > 0){
			with(call(scr.instance_random, _floors)){
				var _dis = point_distance(bbox_center_x, bbox_center_y, other.x, other.y);
				if(_dis > 96 && _dis < 256){
					if(!array_length(call(scr.instances_meeting_instance, self, _sparks))){
						with(call(scr.obj_create, bbox_center_x, bbox_center_y, "PitSpark")){
							move_dir = point_direction(other.x, other.y, x, y);
						}
						_tries = 0;
					}
				}
			}
		}
	}
	
#define PitSquid_hurt(_damage, _force, _direction)
	x = xpos;
	y = ypos;
	
	my_health -= _damage;
	nexthurt = current_frame + 6;
	call(scr.sound_play_at, x, y, snd_hurt, 1.4 + orandom(0.4), 3);
	
	 // Half HP:
	var _half = maxhealth / 2;
	if(my_health <= _half && my_health + _damage > _half){
		if(snd_lowh == sndNothing2HalfHP){
			sound_play_pitch(snd_lowh, 0.6);
		}
		else sound_play(snd_lowh);
		
		bite = 1;
		if(ammo <= 0){
			alarm2 = max(alarm2, 45 + random(15));
		}
	}
	
	xpos = x;
	ypos = y;
	x    = 0;
	y    = 0;

#define PitSquid_death
	x = xpos;
	y = ypos;
	
	 // Sound:
	sound_play_pitch(snd_dead, 0.6);
	sound_play_pitchvol(sndBallMamaHalfHP, 0.6, 2);
	snd_dead = -1;
	
	 // Death Time:
	with(call(scr.obj_create, x, y, "PitSquidDeath")){
		eye           = other.eye;
		eye_dir       = other.eye_dir;
		eye_dir_speed = other.eye_dir_speed;
		eye_dis       = other.eye_dis;
		pit_height    = other.pit_height;
		direction     = other.direction;
		speed         = min(other.speed, 2);
		raddrop       = other.raddrop;
	}
	raddrop = 0;
	
	 // Boss Win Music:
	with(MusCont){
		alarm_set(1, 1);
	}
	
	
#define PitSquidArm_create(_x, _y)
	/*
		PitSquid's tentacles, when hurt they deal damage to PitSquid
		Do an epic plasma bomb attack
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle      = spr.TentacleIdle;
		spr_walk      = spr.TentacleIdle;
		spr_hurt      = spr.TentacleHurt;
		spr_dead      = spr.TentacleDead;
		spr_appear    = spr.TentacleSpwn;
		spr_disappear = spr.TentacleTele;
		hitid         = [spr_idle, "PIT SQUID"];
		sprite_index  = spr_appear;
		image_speed   = 0.4 + orandom(0.1);
		depth         = -2;
		
		 // Sound:
		snd_hurt = sndOasisHurt;
		snd_dead = sndMeatExplo;
		snd_mele = sndPlantSnare;
		
		 // Vars:
		mask        = mskLaserCrystal;
		mask_index  = mskNone;
		friction    = 0.8;
		maxhealth   = irandom_range(20, 60);
		raddrop     = 0;
		size        = 3;
		creator     = noone;
		canfly      = true;
		kills       = 0;
		walk        = 0;
		walkspeed   = 2;
		minspeed    = 1.2;
		maxspeed    = 3.5;
		meleedamage = 1;
		canmelee    = false;
		wave        = 0;
		bomb        = 0;
		bomb_delay  = 0;
		teleport    = false;
		teleport_x  = x;
		teleport_y  = y;
		
		 // Alarms:
		alarm1  = 15;
		alarm2  = -1;
		alarm11 = 30; // Contact damage delay
		
		return self;
	}
	
#define PitSquidArm_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Wave:
	wave += current_time_scale;
	
	 // Teleporting:
	if(teleport){
		if(visible){
			if(sprite_index != spr_disappear){
				if(sprite_index != spr_appear || anim_end){
					sprite_index = spr_disappear;
					image_index  = 0;
				}
			}
			else if(anim_end){
				visible = false;
			}
		}
		
		 // Disable:
		if(!visible){
			mask_index = mskNone;
		}
		canmelee = false;
		alarm11  = 30;
		speed    = 0;
		walk     = 0;
	}
	
	else{
		 // Movement:
		if(walk > 0){
			walk -= current_time_scale;
			speed += walkspeed * current_time_scale;
		}
		if(speed < minspeed){
			speed = minspeed;
		}
		if(speed > maxspeed){
			speed = maxspeed;
		}
		
		 // Animate:
		if(sprite_index != spr_appear){
			sprite_index = enemy_sprite;
		}
		else if(anim_end){
			sprite_index = enemy_sprite;
			mask_index   = mask;
		}
	}
	
	 // Dead:
	if(creator != noone){
		if(!instance_exists(creator) || (!bomb && creator.pit_height < 1)){
			if(sprite_index != spr_appear && sprite_index != spr_disappear){
				my_health = 0;
				spr_dead  = spr_disappear;
				snd_dead  = -1;
			}
		}
	}
	
#define PitSquidArm_end_step
	if(visible){
		var _lastMask = mask_index;
		mask_index = mask;
		
		 // Squid Collision:
		if(instance_exists(creator)){
			var	_x   = creator.xpos,
				_y   = creator.ypos - 8,
				_dis = 48 * abs(creator.image_xscale);
				
			if(point_distance(x, y, _x, _y) < _dis){
				speed    /= 2;
				direction = point_direction(_x, _y, x, y);
				x         = _x + lengthdir_x(_dis, direction);
				y         = _y + lengthdir_y(_dis, direction);
				xprevious = x;
				yprevious = y;
			}
		}
		
		 // Pit Collision:
		if(pitless_meeting(x, y)){
			x = xprevious;
			y = yprevious;
			
			 // Bounce:
			if(pitless_meeting(x + hspeed_raw, y)) hspeed_raw *= -1;
			if(pitless_meeting(x, y + vspeed_raw)) vspeed_raw *= -1;
			speed *= 0.5;
			enemy_look(direction);
			
			 // Smash Floors:
			with(call(scr.wall_clear, self)){
				pit_clear = 1;
			}
		}
		
		mask_index = _lastMask;
	}
	
#define PitSquidArm_alrm1
	alarm1 = 20 + irandom(20);
	
	if(enemy_target(x, y) && sprite_index != spr_appear){
		if(target_visible){
			if(
				!instance_exists(creator) ||
				!collision_line(
					x        - creator.xpos,
					y        - creator.ypos,
					target.x - creator.xpos,
					target.y - creator.ypos,
					creator,
					false,
					false
				)
			){
				var	_targetDir = target_direction,
					_targetDis = target_distance;
					
				 // Keep away:
				if(_targetDis < 16){
					enemy_walk(_targetDir + 180 + orandom(30), random_range(10, 20));
					enemy_look(direction);
					alarm1 = walk + irandom(10);
				}
				
				 // Attack:
				else if(_targetDis < 160 && chance(1, 2)){
					alarm2     = 1;
					bomb       = true;
					bomb_delay = 18;
					
					 // Sounds:
					sound_play_pitchvol(sndPlasmaReloadUpg, 0.8 + random(0.3), 0.6);
					sound_play_pitch(sndOasisPortal, 1.1 + random(0.3));
				}
				
				 // Wander Passively:
				else if(_targetDis < 96){
					direction += orandom(30);
					enemy_look(direction);
					
					 // Effects:
					instance_create(x, y, Bubble);
				}
				
				 // Get closer:
				else{
					enemy_walk(_targetDir + orandom(10), random_range(10, 20));
					enemy_look(direction);
					alarm1 = walk + random(5);
				}
			}
			
			 // Teleport:
			else alarm2 = 1;
		}
	}
	
#define PitSquidArm_alrm2
	enemy_target(x, y);
	
	 // Teleport Appear:
	if(teleport){
		if(instance_exists(target)){
			teleport     = false;
			x            = teleport_x;
			y            = teleport_y;
			xprevious    = x;
			yprevious    = y;
			visible      = true;
			mask_index   = mask;
			sprite_index = spr_appear;
			image_index  = 0;
			
			 // Sound:
			sound_play_pitchvol(sndOasisMelee, 1.0 + random(0.3), 0.6);
		}
		else{
			instance_delete(self);
			exit;
		}
	}
	
	else{
		 // Plasma Bomb Attack:
		if(bomb_delay > 0){
			alarm2 = 1;
			bomb_delay--;
			
			 // Effects:
			var	_depth   = depth - 1,
				_yoffset = 8;
				
			repeat(1 + irandom(1)){
				with(instance_create(irandom_range(bbox_left, bbox_right + 1), irandom_range(bbox_top, bbox_bottom + 1) - _yoffset, PlasmaTrail)){
					depth = _depth;
					sprite_index = spr.EnemyPlasmaTrail;
				}
			}
			
			 // Full charge:
			if(bomb_delay <= 0){
				 // Effects:
				with(instance_create(x, y - _yoffset, ImpactWrists)){
					depth = _depth;
					sprite_index = spr.SquidCharge;
				}
				repeat(2 + irandom(4)){
					with(instance_create(x, y - _yoffset, LaserCharge)){
						depth = _depth;
						alarm0 = 6 + irandom(6);
						motion_set(irandom(359), 2 + random(2));
					}
				}
				
				 // Sounds:
				sound_play_pitch(sndPlasmaReload, 1.8 + random(0.4));
				sound_play_pitchvol(sndCrystalJuggernaut, 1.3 + random(0.4), 0.5);
			}
		}
		
		 // Teleport Disappear:
		else{
			teleport = true;
			alarm2   = 20 + random(20);
			
			 // Determine Teleport Coordinates:
			if(instance_exists(target)){
				 // Bomb Attack:
				if(bomb){
					bomb = false;
					with(call(scr.projectile_create, x, y, "PitSquidBomb", target_direction)){
						target  = other.target;
						triple  = false;
						ammo    = 4 + irandom(3);
						alarm0  = 10;
						alarm1 += alarm0;
					}
				}
				
				 // Teleport Closer to Player:
				else{
					var	_emptyPits = [],
						_validPits = [],
						_tx        = target.x,
						_ty        = target.y;
						
					 // Find Clear Pits:
					with(FloorPit){
						if(!pitless_meeting(x, y)){
							array_push(_emptyPits, self);
						}
					}
					
					 // Find Pits Near Target:
					with(_emptyPits){
						if(!place_meeting(x, y, hitme)){
							var	_x         = bbox_center_x,
								_y         = bbox_center_y,
								_targetDis = point_distance(_x, _y, _tx, _ty);
								
							if(_targetDis > 32 && _targetDis < 128){
								if(!instance_exists(other.creator)){
									array_push(_validPits, self);
								}
								else{
									var _squidDis = point_distance(_x, _y, other.creator.xpos, other.creator.ypos);
									if(
										_squidDis >  60 * other.creator.image_xscale &&
										_squidDis < 180 * other.creator.image_xscale
									){
										array_push(_validPits, self);
									}
								}
							}
						}
					}
					
					 // Teleport to Random Pit:
					with(call(scr.instance_random, 
						array_length(_validPits)
						? _validPits
						: _emptyPits
					)){
						other.teleport_x = bbox_center_x;
						other.teleport_y = bbox_center_y;
					}
				}
			}
			
			 // Sounds:
			sound_play_pitchvol(sndOasisMelee, 0.7 + random(0.3), 1.0);
		}
	}
	
	alarm1 += alarm2;
	
#define PitSquidArm_draw
	var _hurt = (sprite_index != spr_hurt && nexthurt >= current_frame + 4);
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	draw_self_enemy();
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
#define PitSquidArm_hurt(_damage, _force, _direction)
	var _armHealth = my_health;
	my_health -= _damage;
	
	 // Hurt Papa Squid:
	if(creator != noone){
		with(instance_exists(other) ? other : self){
			projectile_hit(other.creator, min(_damage, max(0, _armHealth)), _force, _direction);
		}
		with(instances_matching(obj.PitSquidArm, "creator", creator)){
			nexthurt = current_frame + 6;
		}
	}
	
	 // Sound:
	sound_play_hit(snd_hurt, 0.3);
	
	 // Visual:
	enemy_look(_direction + 180);
	if(sprite_index != spr_appear && sprite_index != spr_disappear){
		sprite_index = spr_hurt;
		image_index  = 0;
	}

#define PitSquidArm_death
	 // Pickups:
	pickup_drop(30, 0);
	
	 // Effects:
	//repeat(3) with(call(scr.fx, x, y, 1, Smoke)) depth = 2;
	if(spr_dead != spr_disappear){
		for(var _dir = direction; _dir < direction + 360; _dir += (360 / 3)){
			with(call(scr.fx, x, y, [_dir + orandom(10), 3], BloodStreak)){
				sprite_index = spr.SquidBloodStreak;
			}
		}
		sleep(35);
	}
	
	
#define PitSquidBomb_create(_x, _y)
	/*
		Used by PitSquidArm to create a trail of plasma explosions
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		hitid = -1;
		
		 // Vars:
		mask_index = mskBandit;
		creator    = noone;
		target     = noone;
		team       = 0;
		ammo       = 0;
		triple     = true;
		
		 // Alarms:
		alarm0 = 3;
		alarm1 = 20;
		
		return self;
	}
	
#define PitSquidBomb_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	
#define PitSquidBomb_alrm0
	var	_len = 24,
		_dir = direction;
		
	 // Adjust Direction:
	if(instance_exists(target) && instance_exists(creator)){
		var _clamp = 45;
		_dir += clamp(angle_difference(_dir, target_direction), -_clamp, _clamp);
	}
	
	var	_x = x + lengthdir_x(_len, _dir),
		_y = y + lengthdir_y(_len, _dir);
		
	if(call(scr.pit_get, _x, _y) && !place_meeting(_x, _y, Wall)){
		 // Relocate Creator:
		with(creator){
			teleport_x = _x;
			teleport_y = _y;
			
			alarm2 = other.alarm1 + 10;
			alarm1 = max(alarm1, alarm2);
		}
		
		 // Spawn Next Bomb:
		if(ammo > 0){
			with(call(scr.projectile_create, _x, _y, "PitSquidBomb", _dir)){
				target = other.target;
				ammo   = other.ammo - 1;
			}
		}
	}
	
	 // Effects:
	repeat(irandom_range(3, 7)){
		with(instance_create(x + orandom(12), y + orandom(12), PlasmaTrail)){
			sprite_index = spr.EnemyPlasmaTrail;
		}
	}
	
	repeat(irandom_range(1, 2)){
		with(instance_create(x + orandom(6), y + orandom(6), LaserCharge)){
			motion_set(_dir, 1);
			alarm0 = 10 + irandom(5);
		}
	}
	
#define PitSquidBomb_alrm1
	instance_destroy();
	
#define PitSquidBomb_destroy
	var	_len   = 8,
		_explo = [];
		
	 // Triple Sucker:
	if(triple){
		for(var _dir = direction; _dir < direction + 360; _dir += 120){
			var	_x = x + lengthdir_x(_len, _dir),
				_y = y + lengthdir_y(_len, _dir);
				
			with(call(scr.projectile_create, _x, _y, "PlasmaImpactSmall", direction)){
				sprite_index = spr.EnemyPlasmaImpactSmall;
				array_push(_explo, self);
			}
		}
	}

	 // Single Sucker:
	else{
		with(call(scr.projectile_create, _x, _y, PlasmaImpact, direction)){
			sprite_index = spr.EnemyPlasmaImpact;
			array_push(_explo, self);
		}
		
		 // Mortar Time:
		if(instance_exists(target) && GameCont.loops > 0){
			with(call(scr.projectile_create, x, y, "MortarPlasma", target_direction, 3)){
				zspeed = (point_distance(x, y, other.target.x, other.target.y) * zfriction) / (speed * 2);
			}
		}
	}
	
	 // PlasmaImpact Setup:
	with(_explo){
		image_angle = 0;
		call(scr.obj_create, x, y, "FakeDust");
	}
	
	 // Sounds:
	sound_play_hit(sndEliteShielderFire, 0.6);
	sound_play_hit(sndOasisExplosionSmall, 0.4);


#define PitSquidDeath_create(_x, _y)
	/*
		PitSquid's death animation, creates bubble explosions and pickups and sinks into the pit
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_bite = spr.PitSquidMawBite;
		
		 // Vars:
		friction      = 0.01;
		eye           = [];
		eye_dir       = random(360);
		eye_dir_speed = 0;
		eye_dis       = 0;
		pit_height    = 0;
		raddrop       = 0;
		explo         = true;
		sink          = false;
		
		 // Alarms:
		alarm0 = 30;
		
		 // No Portals:
		with(call(scr.obj_create, 0, 0, "PortalPrevent")){
			creator = other;
		}
		
		return self;
	}
	
#define PitSquidDeath_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Sink Into the Abyss:
	if(pit_height > 0.1){
		 // Sinkin':
		var _pitHeightGoal = (sink ? (explo ? 0.5 : 0) : 1);
		if(explo && !sink && pit_height != _pitHeightGoal){
			if(abs(_pitHeightGoal - pit_height) < 0.2){
				explo = false;
				with(eye){
					call(scr.obj_create, x, y, "BubbleExplosion");
					sound_play_pitchvol(sndNothingDeath2, 0.6, 0.8);
					
					 // Pickups:
					with(other){
						var	_x = x,
							_y = y;
							
						x = other.x;
						y = other.y;
						pickup_drop(80, 0);
						x = _x;
						y = _y;
					}
				}
				
				 // Rads:
				call(scr.rad_drop, x, y, raddrop, direction, speed);
			}
		}
		pit_height += ((_pitHeightGoal - pit_height) / (sink ? 30 : 4)) * current_time_scale;
		
		 // Eyes:
		eye_dis -= (eye_dis / 5) * current_time_scale;
		eye_dir += eye_dir_speed * current_time_scale;
		eye_dir_speed -= (eye_dir_speed * (explo ? 0.1 : 0.05)) * current_time_scale;
		for(var i = 0; i < array_length(eye); i++){
			var	_dis = (24 + eye_dis) * max(pit_height, 0),
				_dir = image_angle + eye_dir + ((360 / array_length(eye)) * i),
				_x = x + hspeed_raw + lengthdir_x(_dis * image_xscale, _dir),
				_y = y + vspeed_raw + lengthdir_y(_dis * image_yscale, _dir);
				
			with(eye[i]){
				x = _x + orandom(2/3);
				y = _y + orandom(2/3);
				
				dis -= dis * 0.3 * current_time_scale;
				
				if(chance_ct(1, 16)){
					with(instance_create(x + orandom(8), y + orandom(8), PortalL)){
						image_xscale = 0.5;
						image_yscale = 0.5;
					}
				}
			}
		}
	}
	else instance_destroy();

#define PitSquidDeath_alrm0
	if(explo || !sink){
		alarm0 = (sink ? 30 : 33);
		sink = !sink;
		if(explo) eye_dir_speed -= 12 + random(4);
		else vspeed += 2/3;
	}

#define PitSquidDeath_destroy
	instance_create(x, y, Bubble);
	
	 // Allow Portals:
	with(instances_matching(obj.PortalPrevent, "creator", self)){
		instance_destroy();
	}
	with(instance_create(xstart, ystart, Corpse)){
		alarm0 = 10;
	}
	
	
#define PitSquidL_create(_x, _y)
	/*
		Pit Squid lightning, like Portal lightning (PortalL)
	*/
	
	with(instance_create(_x, _y, PortalL)){
		 // Visual:
		sprite_index = spr.PitSpark[irandom(array_length(spr.PitSpark) - 1)];
		
		return self;
	}
	
	
#define QuasarBeam_create(_x, _y)
	/*
		Bendy lasers bro, they bend
		
		Vars:
			sprite_index   - The main laser beam sprite
			spr_strt       - The start of the laser sprite
			spr_stop       - The end of the laser sprite
			loop_snd       - The index of the beam's looping sound, used to stop the sound when destroyed
			primary        - Shot by a player's primary weapon (true) or secondary weapon (false)
			hit_time       - Custom frame count for custom invincibility frames system
			hit_list       - ds_map of hit enemies and what 'hit_time' they were hit at
			blast_hit      - Initial hit, true/false, does more damage and effects
			flash_frame    - Visually flash white, used to give it more impact
			line_seg       - Array of LWOs containing the laser's drawing information
			line_dis       - The beam's current max possible hitscan distance
			line_dis_max   - The beam's max possible hitscan distance
			line_dir_turn  - Rotation speed, adds to 'image_angle'
			line_dir_fric  - Multiplicative friction for 'line_dir_turn' and 'bend'
			line_dir_goal  - The direction to add 'line_dir_turn' towards, keep undefined for no goal
			turn_max       - Max rotation speed
			turn_factor    - Rotation speed increasement factor
			bend           - How much the beam should bend
			bend_fric      - Multiplicative friction for 'bend'
			shrink_delay   - Delay in frames before shrinking
			shrink         - Shrink speed, subtracted from image_xscale/image_yscale
			scale_goal     - image_xscale/image_yscale to reach when not shrinking
			follow_creator - Follow the 'creator', true/false
			offset_dis     - Offset towards 'image_angle' when following the creator
			hold_x/hold_y  - Force this position, keep undefined to not hold
			ring           - Is a QuasarRing, true/false
			ring_size      - Scale of ring, multiplier (cause I don't wanna figure out the epic math)
			ring_lasers    - Array of QuasarBeams created from being a QuasarRing
			wave           - Ticks up every frame, used for visual stuff
			ultra          - Is ultra, true/false
			alarm0         - Creates QuasarBeams for the QuasarRing variant
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.QuasarBeam;
		spr_strt     = spr.QuasarBeamStart;
		spr_stop     = spr.QuasarBeamEnd;
		spr_hit      = spr.QuasarBeamHit;
		spr_trail    = spr.QuasarBeamTrail;
		spr_flame    = -1;
		image_speed  = 0.5;
		depth        = -2;
		
		 // Vars:
		friction       = 0.02;
		mask_index     = msk.QuasarBeam;
		image_xscale   = 1;
		image_yscale   = image_xscale;
		creator        = noone;
		primary        = true;
		damage         = 12;
		force          = 4;
		typ            = 0;
		loop_snd       = -1;
		hit_time       = 0;
		hit_list       = -1;
		blast_hit      = true;
		flash_frame    = current_frame + 2;
		line_seg       = [];
		line_dis       = 0;
		line_dis_max   = 300;
		line_dir_turn  = 0;
		line_dir_fric  = 1/4;
		line_dir_goal  = null;
		turn_max       = 8;
		turn_factor    = 1/8;
		bend           = 0;
		bend_fric      = 0.3;
		shrink_delay   = 0;
		shrink         = 0.05;
		scale_goal     = 1;
		follow_creator = true;
		offset_dis     = 0;
		offset_ang	   = 0;
		hold_x         = null;
		hold_y         = null;
		ring           = false;
		ring_size      = 1;
		ring_lasers    = [];
		wave           = random(100);
		ultra          = false;
		
		on_end_step = QuasarBeam_quick_fix;
		
		 // Merged Weapon Support:
		temerge_on_fire  = script_ref_create(QuasarBeam_temerge_fire);
		temerge_on_setup = script_ref_create(QuasarBeam_temerge_setup);
		
		return self;
	}
	
#define QuasarBeam_quick_fix
	on_end_step = [];
	
	var _l = line_dis_max;
	line_dis_max = 0;
	QuasarBeam_step();
	if(instance_exists(self)){
		line_dis_max = _l;
	}
	
#define QuasarBeam_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Wave:
	wave += current_time_scale;
	
	 // Custom I-Frames:
	hit_time += current_time_scale;
	
	 // Shrink:
	if(shrink_delay <= 0){
		var f = shrink * current_time_scale;
		if(!instance_is(creator, enemy)){
			f *= power(2/3, skill_get(mut_laser_brain));
		}
		image_xscale -= f;
		image_yscale -= f;
	}
	else{
		var f = current_time_scale;
		if(!instance_is(creator, enemy)){
			f *= power(2/3, skill_get(mut_laser_brain));
		}
		shrink_delay -= f;
		
		if(shrink_delay <= 0 || (follow_creator && !instance_exists(creator))){
			shrink_delay = -1;
		}
		
		 // Growin:
		var _goal = scale_goal;
		if(!instance_is(creator, enemy)){
			_goal *= power(1.2, skill_get(mut_laser_brain));
		}
		if(abs(_goal - image_xscale) > 0.05 || abs(_goal - image_yscale) > 0.05){
			image_xscale += (_goal - image_xscale) * 0.4 * current_time_scale;
			image_yscale += (_goal - image_yscale) * 0.4 * current_time_scale;
			
			 // FX:
			if(follow_creator){
				var p = (image_yscale * 0.5);
				if(image_yscale < 1){
					sound_play_pitchvol(sndLightningCrystalHit, p - random(0.1), 0.8);
					sound_play_pitchvol(sndPlasmaHit, p, 0.6);
				}
				sound_play_pitchvol(sndEnergySword, p * 0.8, 0.6);
			}
		}
		else{
			image_xscale = _goal;
			image_yscale = _goal;
		}
	}
	
	 // Player Stuff:
	if(follow_creator){
		var _gunAngle = image_angle + offset_ang;
		with(creator){
			 // Visually Force Player's Gunangle:
			if(instance_is(self, Player)) with(other){
				var	_ang  = angle_difference(_gunAngle, other.gunangle),
					_inst = instances_matching(instances_matching(instances_matching(CustomEndStep, "name", "QuasarBeam_wepangle"), "creator", creator), "primary", primary);
					
				if(!array_length(_inst)){
					with(script_bind_end_step(QuasarBeam_wepangle, 0)){
						name    = script[2];
						creator = other.creator;
						primary = other.primary;
						angle   = 0;
						_inst   = self;
					}
				}
				
				with(_inst){
					angle = _ang;
				}
			}
			
			 // Kickback:
			if(other.shrink_delay > 0){
				var _kick = (other.primary ? "" : "b") + "wkick";
				if(_kick in self){
					var _num = (8 * (1 + (max(other.image_xscale - 1, 0)))) / max(1, abs(_ang / 30))
					variable_instance_set(self, _kick, max(_num, variable_instance_get(self, _kick)));
				}
			}
			
			 // Knockback:
			if(friction > 0){
				motion_add(_gunAngle + 180, other.image_yscale / 2.5);
			}
			
			 // Follow Player:
			other.hold_x = x;
			other.hold_y = y + (other.primary ? 0 : -4);
			if(!place_meeting(x + hspeed_raw, y, Wall)) other.hold_x += hspeed_raw;
			if(!place_meeting(x, y + vspeed_raw, Wall)) other.hold_y += vspeed_raw;
			if("gunangle" in self) other.line_dir_goal = gunangle;
		}
	}

	 // Stay:
	var _l = offset_dis + (sprite_get_width(spr_strt) * image_xscale * 0.5),
		_d = image_angle;
		
	if(hold_x != null){
		x         = hold_x + lengthdir_x(_l, _d);
		xprevious = x;
	}
	if(hold_y != null){
		y         = hold_y + lengthdir_y(_l, _d);
		yprevious = y;
	}
	
	 // Rotation:
	line_dir_turn -= line_dir_turn * line_dir_fric * current_time_scale;
	if(line_dir_goal != null){
		var _turn = angle_difference(line_dir_goal, image_angle + offset_ang); // <<
		if(abs(_turn) > 90 && abs(line_dir_turn) > 1){
			_turn = abs(_turn) * sign(line_dir_turn);
		}
		line_dir_turn += _turn * turn_factor * current_time_scale;
	}
	line_dir_turn = clamp(line_dir_turn, -turn_max, turn_max);
	image_angle += line_dir_turn * current_time_scale;
	image_angle = (image_angle + 360) % 360;
	
	 // Bending:
	bend -= (bend * bend_fric) * current_time_scale;
	bend -= line_dir_turn * current_time_scale;
	
	 // Line:
	var	_lineAdd    = 20,
		_lineRadius = sprite_get_height(sprite_index) / 2,
		_lineDir    = image_angle,
		_lineChange = (instance_is(creator, Player) ? 120 : 40) * current_time_scale,
		_dis        = 0,
		_dir        = _lineDir,
		_dirGoal    = _lineDir + bend,
		_cx         = x,
		_cy         = y,
		_lx         = _cx,
		_ly         = _cy,
		_walled     = false,
		_enemies    = instances_matching_ne(hitme, "team", team),
		_wob        = 0;
		
	if(ring){
		_lineAdd = 24 * ring_size;
		
		 // Offset Ring Center:
		var	_xoff = -_lineAdd / 2,
			_yoff = 57 * ring_size;
			
		_cx += lengthdir_x(_xoff, _dir) + lengthdir_x(_yoff, _dir - 90);
		_cy += lengthdir_y(_xoff, _dir) + lengthdir_y(_yoff, _dir - 90);
		_lx = _cx;
		_ly = _cy;
		
		 // Movin:
		motion_add_ct(random(360), 0.2 / (speed + 1));
		if(place_meeting(x, y, object_index)){
			with(call(scr.instances_meeting_instance, self, obj.QuasarBeam)){
				if(ring && place_meeting(x, y, other)){
					var	_l = 0.5 * current_time_scale,
						_d = point_direction(other.x, other.y, x, y);
						
					x += lengthdir_x(_l, _d);
					y += lengthdir_y(_l, _d);
					motion_add_ct(_d, 0.03);
				}
			}
		}
		
		 // Position Beams:
		if(array_length(ring_lasers)){
			var	_l = _yoff + ((ultra ? 10 : 6) * image_yscale),
				_t = 4 * current_time_scale,
				_x = x + hspeed,
				_y = y + vspeed,
				_n = 0;
				
			ring_lasers = instances_matching_ne(ring_lasers, "id");
			
			with(ring_lasers){
				hold_x = _x + lengthdir_x(_l, image_angle);
				hold_y = _y + lengthdir_y(_l, image_angle);
				line_dir_goal += _t * sin((wave / 30) + array_length(other.ring_lasers) + _n);
				_n++;
			}
		}
	}
	else{
		var _l = (sprite_get_width(spr_strt) / 2) * image_xscale;
		_lx -= lengthdir_x(_l, _dir);
		_ly -= lengthdir_y(_l, _dir);
	}
	
	line_seg = [];
	line_dis += _lineChange;
	line_dis = clamp(line_dis, 0, line_dis_max);
	if(collision_line(_lx, _ly, _cx, _cy, TopSmall, false, false)){
		line_dis = 0;
	}
	
	if(_lineAdd > 0 && line_dis > 0) while(true){
		var	b = _lineAdd * 2,
			_seen = point_seen_ext(_lx, _ly, b, b, -1);
			
		if(!_walled){
			if(!ring && collision_line(_lx, _ly, _cx, _cy, Wall, false, false)){
				_walled = true;
			}
			
			 // Add to Line Draw:
			else if(_seen){
				var	_l    = _lineRadius,
					_d    = _dir - 90,
					_x    = _cx + hspeed_raw,
					_y    = _cy + vspeed_raw,
					_xtex = (_dis / line_dis);
					
				 // Ring Collapse:
				if(ring){
					var _o = (2 + (2 * ring_size * image_yscale)) / max(shrink_delay / 20, 1);
					_x += lengthdir_x(_o, _d) * dcos((_dir *  2) + (wave * 4));
					_y += lengthdir_y(_o, _d) * dsin((_dir * 10) + (wave * 4));
					_d -= (_lineAdd / ring_size) * 0.5;
				}
				
				 // Pulsate:
				else{
					_l *= 1 + (0.1 * sin((wave / 6) + (_wob / 10)) * min(1, _wob / 3));
				}
				
				for(var _a = -1; _a <= 1; _a += 2){
					array_push(line_seg, {
						x    : _x,
						y    : _y,
						dir  : _dir,
						xoff : lengthdir_x(_l * _a, _d),
						yoff : lengthdir_y(_l * _a, _d),
						xtex : _xtex,
						ytex : !!_a
					});
				}
			}
		}
		
		 // Wall Collision:
		else{
			blast_hit = false;
			line_dis -= _lineChange;
			if(!array_length(line_seg)){
				line_dis = 0;
			}
		}
		if(ring && place_meeting(_cx, _cy, Wall)){
			speed *= 0.96;
			
			var	_lastX = x,
				_lastY = y;
				
			x = _cx;
			y = _cy;
			
			with(call(scr.instances_meeting_instance, self, Wall)){
				if(place_meeting(x, y, other)){
					instance_create(x, y, FloorExplo);
					instance_destroy();
				}
			}
			
			x = _lastX;
			y = _lastY;
		}
		
		 // Hit Enemies:
		if(place_meeting(_cx, _cy, hitme)){
			var	_lastX = x,
				_lastY = y;
				
			x = _cx;
			y = _cy;
			
			with(call(scr.instances_meeting_instance, self, _enemies)){
				if(place_meeting(x, y, other)){
					if(!instance_is(self, Player) || (!_walled && !collision_line(x, y, _lx, _ly, Wall, false, false))){
						with(other){
							if(!ds_map_valid(hit_list)){
								hit_list = ds_map_create();
							}
							if(!ds_map_exists(hit_list, other) || hit_list[? other] <= hit_time){
								 // Effects:
								with(instance_create(x + orandom(8), y + orandom(8), BulletHit)){
									motion_add(point_direction(other.x, other.y, x, y), 1);
									sprite_index = other.spr_hit;
									image_angle  = direction;
									image_xscale = other.image_yscale;
									image_yscale = other.image_yscale;
									depth        = other.depth - 1;
								}
								
								 // Damage:
								if(!ring){
									direction = _dir;
								}
								x = _lastX;
								y = _lastY;
								event_perform(ev_collision, hitme);
								x = _cx;
								y = _cy;
							}
							
							 // Hit the BRAKES:
							if(instance_is(creator, Player)){
								if(!instance_exists(other) || other.my_health <= 0 || other.size >= ((image_yscale <= 1) ? 3 : 4) || blast_hit){
									line_dis = _dis;
								}
							}
							
							blast_hit = false;
						}
					}
				}
			}
			
			x = _lastX;
			y = _lastY;
		}
		
		 // Effects:
		if(_seen && random(160 / _lineAdd) < current_time_scale){
			if(position_meeting(_cx, _cy, Floor)){
				var _off = (ultra ? 24 : 32) * image_yscale;
				with(instance_create(_cx + orandom(_off), _cy + orandom(_off), PlasmaTrail)){
					
					sprite_index = other.spr_trail;
					if(other.ultra){
						image_angle  = _dir;
						image_xscale = random_range(2/3, 1);
						image_yscale = image_xscale;
					}
					
					motion_add(_dir, 1 + random(max(other.image_yscale - 1, 0)));
					if(other.image_yscale > 1) depth = other.depth - 1;
				}
			}
		}
		
		 // Move:
		_lx   = _cx;
		_ly   = _cy;
		_cx  += lengthdir_x(_lineAdd, _dir);
		_cy  += lengthdir_y(_lineAdd, _dir);
		_dis += _lineAdd;
		
		 // Turn:
		if(ring){
			_dir += (_lineAdd / ring_size);
		}
		else{
			_dir = clamp(_dir + (bend / (48 / _lineAdd)), _lineDir - 90, _lineDir + 90);
		}
		
		 // End:
		if((!ring && _dis >= line_dis) || (ring && abs(_dir - _lineDir) > 360)){
			if(_dis >= line_dis_max){
				blast_hit = false;
			}
			if(ring && array_length(line_seg)){
				array_push(line_seg, line_seg[0]);
				array_push(line_seg, line_seg[1]);
			}
			break;
		}
		
		_wob++;
	}

	 // Effects:
	if(!ring){
		if(chance_ct(1, 4)){
			var	_xoff = orandom(12) - ((12 * image_xscale) + _lineAdd),
				_yoff = orandom(random(28 * image_yscale)),
				_x    = (_walled ? _lx : _cx) + lengthdir_x(_xoff, _dir) + lengthdir_x(_yoff, _dir - 90),
				_y    = (_walled ? _ly : _cy) + lengthdir_y(_xoff, _dir) + lengthdir_y(_yoff, _dir - 90);
				
			if(!position_meeting(_x, _y, TopSmall)){
				with(instance_create(_x, _y, BulletHit)){
					sprite_index = other.spr_hit;
					image_xscale = other.image_yscale;
					image_yscale = other.image_yscale;
					depth        = other.depth - 1;
					instance_create(x, y, Smoke);
				}
				/*
				with(instance_create(_x, _y, PortalClear)){
					image_xscale = other.image_xscale / 3;
					image_yscale = other.image_xscale / 3;
				}
				*/
			}
		}
		view_shake_max_at(_cx, _cy, 4);
	}
	view_shake_max_at(x, y, 4);
	
	 // Sound:
	if(!audio_is_playing(loop_snd)){
		loop_snd = audio_play_sound(sndNothingBeamLoop, 0, true);
	}
	audio_sound_pitch(loop_snd, 0.3 + (0.1 * sin(current_frame / 10)));
	audio_sound_gain(loop_snd, image_xscale, 0);
	
	 // End:
	if(image_xscale <= 0 || image_yscale <= 0){
		instance_destroy();
	}
	
#define QuasarBeam_draw
	if(flash_frame > current_frame){
		draw_set_fog(true, c_white, 0, 0);
	}
	
	QuasarBeam_draw_laser(image_xscale, image_yscale, image_alpha);

	 // Visually Connect Laser to Quasar Ring:
	if(ring){
		if(array_length(ring_lasers)){
			var _inst = instances_matching_ne(ring_lasers, "id");
			with(_inst){
				draw_set_alpha(image_alpha);
				draw_set_color(image_blend);
				draw_circle(x - 1, y - 1, 6 * image_yscale, false);
			}
			with(_inst){
				QuasarBeam_draw();
			}
		}
		draw_set_alpha(1);
		
		/*
		var	i = 0,
			_x1 = null,
			_y1 = null,
			_x2 = null,
			_y2 = null;
			
		with(line_seg){
			_x1 = x + (xoff * 2 * other.image_yscale);
			_y1 = y + (yoff * 2 * other.image_yscale);
			if(_x2 != null){
				draw_set_color([c_green, c_blue][i++ % 2]);
				draw_line(_x1, _y1, _x2, _y2);
			}
			_x2 = _x1;
			_y2 = _y1;
		}
		*/
	}
	
	if(flash_frame > current_frame){
		draw_set_fog(false, 0, 0, 0);
	}
	
	/*
	 // Flame:
	QuasarBeam_draw_flame(1, 1, 1);
	*/
	
#define QuasarBeam_alrm0
	alarm0 = random_range(4 + (8 * array_length(ring_lasers)), 16);
	
	 // Laser:
	with(call(scr.projectile_create, x, y, (ultra ? "UltraQuasarBeam" : "QuasarBeam"), random(360))){
		spr_strt       = -1;
		follow_creator = false;
		line_dir_goal  = image_angle + random(orandom(180));
		shrink_delay   = min(other.shrink_delay, random_range(10, 120));
		scale_goal     = other.scale_goal - random(0.6);
		image_xscale   = 0;
		image_yscale   = 0;
		visible        = false;
		
		array_push(other.ring_lasers, self);
	}
	
#define QuasarBeam_hit
	if(!ds_map_valid(hit_list)){
		hit_list = ds_map_create();
	}
	if(!ds_map_exists(hit_list, other) || hit_list[? other] <= hit_time){
		hit_list[? other] = hit_time + (ring ? 3 : 6);
		
		 // Slow:
		speed *= 1 - (0.05 * other.size);
		
		 // Effects:
		with(other){
			repeat(3) instance_create(x, y, Smoke);
			if(other.blast_hit){
				call(scr.sleep_max, 30);
				call(scr.sound_play_at, x, y, sndExplosionS, 0.7 + random(0.1), 1.2);
				call(scr.sound_play_at, x, y, sndMeatExplo,  1.2 + random(0.1), 1.4);
			}
		}
		
		 // Damage:
		var _lastDir = direction;
		if(place_meeting(x, y, other) || ring){
			direction = point_direction(x, y, other.x, other.y);
		}
		projectile_hit_np(
			other,
			ceil((damage + (blast_hit * damage * (1 + skill_get(mut_laser_brain)))) * image_yscale),
			((instance_is(other, prop) || other.team == 0) ? 0 : force),
			40
		);
		direction = _lastDir;
		
		 // Death Effect:
		if(ultra && instance_exists(other) && other.my_health <= 0){
			with(other){
				if(size >= 2){
					with(instance_create(x, y, GreenExplosion)){
						hitid = 99;
					}
					repeat(3){
						with(instance_create(x, y, SmallExplosion)){
							hitid = 56;
						}
					}
				}
				else with(instance_create(x, y, SmallExplosion)){ // kinda looks better orange i think
					hitid = 56;
					// call(scr.obj_create, x, y, "SmallGreenExplosion");
				}
				sound_play_hit_big(sndExplosionS, 0.3);
			}
		}
	}
	
#define QuasarBeam_wall
	// dust

#define QuasarBeam_cleanup
	audio_stop_sound(loop_snd);
	if(ds_map_valid(hit_list)){
		ds_map_destroy(hit_list);
	}
	
	 // Clear Ring Beams:
	if(array_length(ring_lasers)){
		with(instances_matching_ne(ring_lasers, "id")){
			instance_destroy();
		}
	}
	
#define QuasarBeam_draw_laser(_xscale, _yscale, _alpha)
	var	_lastColor = draw_get_color(),
		_angle     = image_angle,
		_x         = x,
		_y         = y;
		
	 // Beam Start:
	if(spr_strt != -1){
		draw_sprite_ext(spr_strt, image_index, _x, _y, _xscale, _yscale, _angle, image_blend, _alpha);
	}
	
	 // Quasar Ring Core:
	if(ring){
		draw_set_alpha((_alpha < 1) ? (_alpha / 2) : _alpha);
		draw_set_color(image_blend);
		
		var _o = 0;
		repeat(2){
			draw_circle(
				_x - 1 + (_o * cos(wave / 8)),
				_y - 1 + (_o * sin(wave / 8)),
				((18 * ring_size) + floor(image_index)) * _xscale,
				false
			);
			_o = (2 * _xscale * cos(wave / 13)) / max(shrink_delay / 20, 1);
		}
		
		draw_set_alpha(1);
	}
	
	 // Main Laser:
	if(array_length(line_seg) > 0){
		draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(sprite_index, image_index));
		draw_set_alpha(_alpha);
		draw_set_color(image_blend);
		
		with(line_seg){
			draw_vertex_texture(x + (xoff * _yscale), y + (yoff * _yscale), xtex, ytex);
		}
		
		draw_set_alpha(1);
		draw_primitive_end();
		
		with(line_seg[array_length(line_seg) - 1]){
			_angle = dir;
			_x = x;
			_y = y;
		}
	}
	
	 // Laser End:
	if(spr_stop != -1){
		var	_x1 = x - lengthdir_x(1,				 _angle),
			_y1 = y - lengthdir_y(1,				 _angle),
			_x2 = x + lengthdir_x(16 / image_xscale, _angle),
			_y2 = y + lengthdir_y(16 / image_yscale, _angle);
			
		if(!collision_line(_x1, _y1, _x2, _y2, TopSmall, false, false)){
			draw_sprite_ext(spr_stop, image_index, _x, _y, min(_xscale, 1.25), _yscale, _angle, image_blend, _alpha);
		}
	}
	
	draw_set_color(_lastColor);

#define QuasarBeam_draw_flame(_xscale, _yscale, _alpha)
	
	 // Draw Ultra Flame:
	if(sprite_exists(spr_flame) && instance_is(creator, Player)){
		var _wep = creator.wep;
		if(weapon_get_rads(_wep) > 0 && call(scr.weapon_get, "ntte_quasar", _wep) > 0){
			var _spr = spr_flame,
				_len = 2 + sprite_get_xoffset(weapon_get_sprite(_wep)) + creator.wkick,
				_dir = image_angle,
				_sin = sin(wave / 10);
				
			draw_sprite_ext(
				_spr,
				wave % sprite_get_number(_spr),
				creator.x - lengthdir_x(_len, _dir),
				creator.y - lengthdir_y(_len, _dir),
				((_xscale / 4 )+ (flash_frame > current_frame)) * (image_xscale + lerp(image_yscale, 1, 1/3) + random(max(_sin, 0))),
				((_yscale / 4) + (flash_frame > current_frame)) * (image_yscale + (_sin / 5)),
				_dir,
				image_blend,
				image_alpha * _alpha
			);
		}
	}
	
#define QuasarBeam_wepangle
	if(instance_exists(creator) && abs(angle) > 1){
		with(creator){
			if(call(scr.weapon_get, "ntte_quasar", (other.primary ? wep : bwep)) > 0){
				if(other.primary){
					wepangle += other.angle;
					enemy_face(gunangle + other.angle);
					back = ((dsin(gunangle + other.angle) > 0) ? 1 : -1);
				}
				else{
					bwepangle += other.angle;
				}
			}
		}
		angle *= power(0.7, current_time_scale);
	}
	else instance_destroy();
	
#define QuasarBeam_temerge_fire(_at, _setupInfo)
	_setupInfo.spr_hit      = spr_hit;
	_setupInfo.spr_trail    = spr_trail;
	_setupInfo.line_dis_max = line_dis_max;
	_setupInfo.scale_goal   = scale_goal;
	_setupInfo.is_ring      = ring;
	
#define QuasarBeam_temerge_setup(_instanceList, _setupInfo)
	 // Big:
	call(scr.projectile_add_temerge_scale,  _instanceList, 0.25 * _setupInfo.scale_goal);
	
	 // Hits Hard:
	call(scr.projectile_add_temerge_damage, _instanceList, 3 * _setupInfo.scale_goal);
	call(scr.projectile_add_temerge_force,  _instanceList, 2 * _setupInfo.scale_goal);
	
	 // Pierces Enemies:
	call(scr.projectile_add_temerge_effect, _instanceList, "piercing", [1]);
	
	 // Break Walls:
	if(_setupInfo.is_ring){
		with(_instanceList){
			call(scr.projectile_add_temerge_effect, self, "wall_piercing", [sqrt(damage)]);
		}
	}
	
	 // Beamular:
	else{
		var _minID = instance_max;
		call(scr.projectile_add_temerge_effect,
			call(scr.array_shuffle, instances_matching_ne(_instanceList, "speed", 0)),
			"laser",
			[_setupInfo.line_dis_max]
		);
		var _effectInst = instances_matching_gt(Effect, "id", _minID);
		if(array_length(_effectInst)){
			with(instances_matching(_effectInst, "sprite_index", sprPlasmaTrail     )) sprite_index = _setupInfo.spr_hit;
			with(instances_matching(_effectInst, "sprite_index", spr.AllyLaserCharge)) sprite_index = _setupInfo.spr_trail;
		}
	}
	
	
#define QuasarRing_create(_x, _y)
	/*
		The cannon variant of QuasarBeams, breaks walls and emits QuasarBeams
	*/
	
	with(call(scr.obj_create, _x, _y, "QuasarBeam")){
		 // Visual:
		spr_strt = -1;
		spr_stop = -1;
		
		 // Vars:
		mask_index     = mskExploder;
		follow_creator = false;
		shrink_delay   = 120;
		ring           = true;
		force          = 1;
		
		 // Alarms:
		alarm0 = 10 + random(20);
		
		instance_create(x, y, PortalClear);
		
		return self;
	}
	
	
#define TeslaCoil_create(_x, _y)
	/*
		A small lightning ball that follows its creator and arcs lightning to the nearest enemy
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprLightningBall;
		image_speed  = 0.4 + orandom(0.1);
		image_xscale = 0.4;
		image_yscale = image_xscale;
		
		 // Vars:
		damage       = 14;
		force        = 4;
		typ          = 0;
		team         = -1;
		creator      = noone;
		creator_offx = 17;
		creator_offy = 2;
		num          = 3;
		wave         = random(960);
		time         = random_range(8, 16) * (1 + (0.5 * skill_get(mut_laser_brain)));
		target       = noone;
		target_x     = x;
		target_y     = y;
		dist_max     = 96;
		primary      = true;
		purple       = false;
		
		 // Alarms:
		alarm0 = 1;
		
		 // Merged Weapon Support:
		temerge_on_setup = script_ref_create(TeslaCoil_temerge_setup);
		
		return self;
	}
	
#define TeslaCoil_alrm0
	var	_maxDis       = dist_max,
		_target       = [],
		_teamPriority = 0; // Higher teams get priority (Always target IDPD first. Props are targeted only when no enemies are around)
		
	 // Find Targetable Enemies:
	with(instances_matching_ne(instances_matching_ne(hitme, "team", team), "mask_index", mskNone)){
		if(distance_to_point(other.x, other.y) < _maxDis){
			if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
				if(team > _teamPriority){
					_teamPriority = team;
					_target       = [];
				}
				array_push(_target, self);
			}
		}
	}
	
	 // Random Arc:
	if(!array_length(_target)){
		var	_dis = _maxDis * random_range(0.2, 0.8),
			_dir = random(360);
			
		do{
			target_x = x + lengthdir_x(_dis, _dir);
			target_y = y + lengthdir_y(_dis, _dir);
			_dis -= 4;
		}
		until(_dis < 12 || !collision_line(x, y, target_x, target_y, Wall, false, false));
	}
	
	 // Enemy Arc:
	else{
		target   = call(scr.instance_random, _target);
		target_x = target.x;
		target_y = target.y;
		time    *= 1.5;
	}
	
#define TeslaCoil_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Wave:
	wave += current_time_scale;
	
	 // Active:
	if(instance_exists(creator)){
		 // Follow Creator:
		if(instance_exists(creator)){
			var	_xdis = creator_offx - (variable_instance_get(creator, (primary ? "" : "b") + "wkick", 0) / 3),
				_xdir = (("gunangle" in creator) ? creator.gunangle : direction),
				_ydis = creator_offy * variable_instance_get(creator, "right", 1),
				_ydir = _xdir - 90;
				
			x         = creator.x + creator.hspeed_raw + lengthdir_x(_xdis, _xdir) + lengthdir_x(_ydis, _ydir);
			y         = creator.y + creator.vspeed_raw + lengthdir_y(_xdis, _xdir) + lengthdir_y(_ydis, _ydir) + (primary ? 0 : -4);
			xprevious = x;
			yprevious = y;
		}
		
		 // Targeting:
		if(instance_exists(target)){
			with(target){
				other.target_x = x + orandom(2);
				other.target_y = y + orandom(2);
			}
		}
		else if(target != noone){
			target = noone;
			time   = min(time, 8);
		}
		
		 // Arc Lightning:
		var	_tx = target_x,
			_ty = target_y;
			
		if((instance_exists(target) || point_distance(x, y, _tx, _ty) < dist_max + 32) && !collision_line(x, y, _tx, _ty, Wall, false, false)){
			var	_wave = (("wave" in creator) ? creator.wave : wave),
				_arc  = (power(point_distance(x, y, _tx, _ty), 0.6) * sin((_wave / 240) * 2 * pi)) + (4 * cos((_wave / 960) * 2 * pi)),
				_inst = lightning_connect(
					x,
					y,
					_tx,
					_ty,
					4 * sqrt(abs(_arc)) * sign(_arc),
					false,
					self
				);
				
			 // Purpify:
			if(purple){
				with(_inst){
					damage       = floor(other.damage * 7/3);
					sprite_index = spr.ElectroPlasmaTether;
					depth        = -3;
					
					 // Effects:
					if(chance_ct(1, 16)){
						with(instance_create(x, y, PlasmaTrail)){
							sprite_index = spr.ElectroPlasmaTrail;
							motion_set(other.direction, 1);
						}
					}
				}
				
				 // Hit FX:
				if(chance_ct(1, 15)){
					call(scr.fx, _tx, _ty, 1, PortalL);
				}
				if(!place_meeting(_tx, _ty, Smoke)){
					instance_create(_tx, _ty, Smoke);
				}
			}
			
			 // Normal Hit FX:
			else if(!place_meeting(_tx, _ty, LightningHit)){
				with(instance_create(_tx, _ty, LightningHit)){
					image_speed = 0.2 + random(0.2);
				}
			}
		}
		
		 // Effects:
		view_shake_max_at(x, y, 3);
		var _kick = (primary ? "" : "b") + "wkick";
		if(_kick in creator){
			variable_instance_set(creator, _kick, 3);
		}
		
		 // Death Timer:
		if(time > 0){
			time -= current_time_scale;
			if(time <= 0){
				instance_destroy();
			}
		}
	}
	else instance_destroy();
	
#define TeslaCoil_wall
	// ...
	
#define TeslaCoil_hit
	if(projectile_canhit_melee(other)){
		projectile_hit(other, damage, force);
	}
	
#define TeslaCoil_temerge_setup(_instanceList)
	 // Zap Nearby:
	with(_instanceList){
		with(call(scr.projectile_create, x, y, "TeslaCoil", random(360))){
			creator      = other;
			creator_offx = 0;
			creator_offy = 0;
		}
	}
	
	
#define TopDecalWaterMine_create(_x, _y)
	/*
		Used for Trench's water mine top decal, creates a water mine when the decal is destroyed
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		mask_index = spr.TopDecalTrenchMine;
		creator    = noone;
		
		return self;
	}
	
#define TopDecalWaterMine_step
	if(instance_exists(creator)){
		x = creator.x;
		y = creator.y;
	}
	else{
		if(place_meeting(x, y, FloorExplo)){
			 // Mine:
			with(instance_create(x, y, WaterMine)){
				my_health = 0;
				spr_dead = spr.TrenchMineDead;
			}
			
			 // Clear Walls:
			call(scr.wall_clear, self);
		}
		instance_destroy();
	}
	
	
#define TrenchFloorChunk_create(_x, _y)
	/*
		The z-axis chunks created when PitSquid smashes through floors
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.FloorTrenchBreak;
		image_index  = irandom(image_number - 1)
		image_speed  = 0;
		image_alpha  = 0;
		depth        = -9;

		 // Vars:
		z            = 0;
		zspeed       = 6 + random(4);
		zfriction    = 0.3;
		friction     = 0.05;
		image_angle += orandom(20);
		debris       = false;
		rotspeed     = random_range(1, 2) * choose(-1, 1);
		rotfriction  = 0;
		if(chance(1, 3)){
			rotspeed *= 8;
			rotfriction = 1;
		}
		
		 // Lets gOOO
		motion_add(random(360), 2 + random(3));
		
		return self;
	}

#define TrenchFloorChunk_step
	z += zspeed * current_time_scale;
	zspeed -= zfriction * current_time_scale;
	image_angle += rotspeed * current_time_scale;
	rotspeed -= clamp(rotspeed, -rotfriction, rotfriction) * current_time_scale;

	 // Stay above walls:
	/*depth = clamp(-z / 8, -8, 0);
	if(place_meeting(x, y - z, Wall) || !place_meeting(x, y - z, Floor)){
		depth = min(depth, -8);
	}*/

	 // Effects:
	if(chance_ct(1, 10)){
		instance_create(x, y - z, Bubble);
	}

	if(z <= 0) instance_destroy();

#define TrenchFloorChunk_draw
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, 1);

#define TrenchFloorChunk_destroy
	sound_play_pitchvol(sndOasisExplosionSmall, 0.5 + random(0.3), 0.3 + random(0.1));
	
	 // Fall into Pit:
	if(!place_meeting(x, y, Wall) && call(scr.pit_get, x, y)){
		with(instance_create(x, y, Debris)){
			sprite_index = other.sprite_index;
			image_index  = other.image_index;
			image_angle  = other.image_angle;
			direction    = other.direction;
			speed        = other.speed;
		}
		if(!other.debris) repeat(3){
			call(scr.fx, x, y, 2, Smoke);
		}
	}
	
	 // Break on ground:
	else{
		y -= 2;
		sound_play_pitchvol(sndWallBreak, 0.5 + random(0.3), 0.4);
		for(var _d = direction; _d < direction + 360; _d += 360 / (debris ? 1 : 3)){
			with(instance_create(x, y, Debris)){
				motion_set(_d + orandom(20), other.speed + random(1));
				if(other.debris){
					image_angle = other.image_angle;
				}
				else speed += 2 + random(1);
				if(!place_meeting(x, y, Floor)){
					depth = -7;
				}
				
				 // Dusty:
				with(call(scr.fx, [x, 4], [y, 4], [direction, speed], "FakeDust")){
					depth = other.depth;
				}
			}
		}
	}
	
	
#define UltraQuasarBeam_create(_x, _y)
	/*
		The ultra variant of quasar beams.
	*/
	with(call(scr.obj_create, _x, _y, "QuasarBeam")){
		 // Visual:
		sprite_index = spr.UltraQuasarBeam;
		spr_strt     = spr.UltraQuasarBeamStart;
		spr_stop     = spr.UltraQuasarBeamEnd;
		spr_hit      = spr.UltraQuasarBeamHit;
		spr_trail    = spr.UltraQuasarBeamTrail;
		spr_flame    = spr.UltraQuasarBeamFlame;
		
		 // Vars:
		mask_index   = msk.UltraQuasarBeam;
		turn_factor  = 1/50;
	//	bend_fric	 = 0.3;
		ultra        = true;
		damage		 = 24; // 2x
		
		return self;
	}
	
	
#define Vent_create(_x, _y)
	/*
		Bro it's a bubble prop, I love it
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle   = spr.VentIdle;
		spr_hurt   = spr.VentHurt;
		spr_dead   = spr.VentDead;
		spr_shadow = mskNone;
		depth      = -2;
		
		 // Sounds
		snd_hurt = sndOasisHurt;
		snd_dead = sndOasisExplosionSmall;
		
		 // Vars:
		maxhealth = 12;
		size      = 1;
		
		return self;
	}
	
#define Vent_step
	 // Effects:
	if(chance_ct(1, 5)){
		with(instance_create(x, y, Bubble)){
			friction = 0.2;
			motion_set(90 + orandom(5), random_range(4, 7));
		}
		//with instance_create(x,y-8,Smoke){
		//	motion_set(irandom_range(65,115),random_range(10,100));
		//}
	}
	
#define Vent_death
	call(scr.obj_create, x, y, "BubbleExplosion");
	
	
#define WantEel_create(_x, _y)
	/*
		An Eel waiting to come out of the pit, he's waiting
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.WantEel;
		image_xscale = choose(-1, 1);
		visible      = false;
		depth        = 1000;
		
		 // Vars:
		mask_index = mskRat;
		friction   = 0.4;
		walk       = 0;
		walkspeed  = 0.6;
		maxspeed   = 2.4;
		pit_height = 0;
		elite      = 10;
		target     = noone;
		
		 // Alarms:
		alarm1 = irandom_range(150, 600);
		alarm2 = -1;
		
		 // No Portals:
		with(call(scr.obj_create, 0, 0, "PortalPrevent")){
			creator = other;
		}
		
		return self;	
	}
	
#define WantEel_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Active:
	if(visible){
		 // Movement:
		if(walk > 0){
			walk -= current_time_scale;
			speed += walkspeed * current_time_scale;
		}
		if(speed > maxspeed){
			speed = maxspeed;
		}
		
		 // Effects:
		if(chance_ct(1, 30)){
			with(call(scr.obj_create, x + orandom(6), y + orandom(6), "PitSpark")){
				tentacle_visible = false;
			}
		}
		
		 // Rise From Pits:
		pit_height += 0.02 * current_time_scale;
		if(pit_height >= 1){
			instance_destroy();
		}
	}
	else walk = 0;
	
#define WantEel_end_step
	 // Pit Collision:
	if(visible){
		if(pitless_meeting(x, y)){
			x = xprevious;
			y = yprevious;
			
			 // Bounce:
			if(pitless_meeting(x + hspeed_raw, y)) hspeed_raw *= -1;
			if(pitless_meeting(x, y + vspeed_raw)) vspeed_raw *= -1;
			if(hspeed != 0){
				image_xscale = abs(image_xscale) * sign(hspeed);
			}
			speed *= 0.5;
		}
	}
	
#define WantEel_alrm1
	alarm1 = 30 + random(60);
	
	 // Activate:
	if(enemy_target(x, y) && !visible){
		var _numEels = array_length(instances_matching_ne(obj.Eel, "id"));
		if(
			(chance(1, 3) || _numEels <= 1) &&
			_numEels + array_length(instances_matching(obj.WantEel, "visible", true)) <= 6 + (4 * GameCont.loops)
		){
			var	_pitInst = noone,
				_pitDis  = 160,
				_tx      = target.x,
				_ty      = target.y;
				
			 // Find Pit:
			with(call(scr.array_shuffle, FloorPit)){
				if(!pitless_meeting(x, y)){
					if(point_distance(bbox_center_x, bbox_center_y, _tx, _ty) < _pitDis){
						_pitInst = self;
						break;
					}
				}
			}
			
			 // Make Pit:
			if(!instance_exists(_pitInst)){
				with(call(scr.array_shuffle, FloorPitless)){
					if(point_distance(bbox_center_x, bbox_center_y, _tx, _ty) < _pitDis){
						with(call(scr.obj_create, choose(bbox_left, bbox_right + 1), choose(bbox_top, bbox_bottom + 1), PortalClear)){
							pit_clear = 0.75;
							pit_smash = true;
							sound_play_hit(sndOasisExplosionSmall, 0.2);
						}
						_pitInst = self;
						break;
					}
				}
			}
			
			 // Goto Pit:
			with(_pitInst){
				other.x         = bbox_center_x;
				other.y         = bbox_center_y;
				other.xprevious = other.x;
				other.yprevious = other.y;
				other.visible   = true;
				other.alarm2    = 30;
			}
		}
	}

	 // Motionize:
	if(visible){
		alarm1 = 20 + random(20);
		enemy_walk(
			((instance_exists(target) && target_visible) ? (target_direction + orandom(30)) : random(360)),
			random_range(20, 60)
		);
		if(hspeed != 0){
			image_xscale = abs(image_xscale) * sign(hspeed);
		}
	}
	
#define WantEel_alrm2
	alarm2 = -1;
	
	 // Watch Out:
	if(enemy_target(x, y) && target_distance < 96){
		instance_create(x, y, AssassinNotice);
	}
	
#define WantEel_destroy
	 // Become Eel:
	with(call(scr.obj_create, x, y, "Eel")){
		direction = other.direction;
		speed     = other.speed;
		walk      = other.walk;
		elite     = other.elite;
		right     = other.image_xscale;
		alarm1    = 30;
	}
	
	 // Effects:
	repeat(3 + irandom(4)) instance_create(x, y, Bubble);
	repeat(1 + irandom(2)) instance_create(x, y, PortalL);
	
	 // Allow Portals:
	with(instances_matching(obj.PortalPrevent, "creator", self)){
		instance_destroy();
	}
	
	
/// GENERAL
#define ntte_draw_bloom
	 // Canister Bloom:
	if(array_length(obj.Angler)){
		var _inst = instances_matching(obj.Angler, "hiding", true);
		if(array_length(_inst)){
			with(_inst){
				draw_sprite_ext(sprRadChestGlow, image_index, x + (6 * right), y + 8, image_xscale * 2 * right, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
			}
		}
	}
	
	 // Lightning Discs:
	if(array_length(obj.LightningDisc)){
		with(instances_matching_ne(obj.LightningDisc, "id")){
			scrDrawLightningDisc(sprite_index, image_index, x, y, ammo, radius, 2 * stretch, image_xscale, image_yscale, image_angle + rotation, image_blend, 0.1 * image_alpha);
		}
	}
	
	 // Quasar Beams:
	if(array_length(obj.QuasarBeam)){
		with(instances_matching_ne(obj.QuasarBeam, "id")){
			var	_alp = 0.1 * (1 + (skill_get(mut_laser_brain) * 0.5)),
				_xsc = 2,
				_ysc = 2;
				
			if(blast_hit){
				_alp *= 1.5 / image_yscale;
			}
			
			QuasarBeam_draw_laser(_xsc * image_xscale, _ysc * image_yscale, _alp * image_alpha);
			/*
			QuasarBeam_draw_flame(_xsc,                _ysc,                _alp);
			*/
			/*if(ring && array_length(ring_lasers)){
				with(instances_matching(ring_lasers, "visible", false)){
					QuasarBeam_draw_laser(_xsc * image_xscale, _ysc * image_yscale, _alp * image_alpha);
				}
			}*/
		}
	}
	
	 // Hot Quasar Weapons:
	if(instance_exists(Player) && !instance_exists(PlayerSit)){
		var _instPlayer = instances_matching(Player, "visible", true);
		if(array_length(_instPlayer)){
			for(var i = 0; i < 2; i++){
				var _inst = instances_matching_gt(_instPlayer, ((i == 0) ? "reload" : "breload"), 0);
					
				if(i == 1){
					if(!array_length(_inst)){
						continue;
					}
					_inst = instances_matching(_inst, "race", "steroids");
				}
				
				if(array_length(_inst)){
					with(_inst){
						var	_wep    = ((i == 0) ? wep : bwep),
							_quasar = call(scr.weapon_get, "ntte_quasar", _wep);
							
						if(_quasar > 0){
							var	_ang  = ((i == 0) ? wepangle : bwepangle),
								_kick = ((i == 0) ? wkick    : bwkick),
								_flip = (weapon_is_melee(_wep) ? ((i == 0) ? wepflip : bwepflip) : right) * ((i == 1) ? -1 : 1),
								_dis  = ((i == 1) ? -1 : -2) * sign(_flip),
								_dir  = gunangle + (_ang * (1 - (_kick / 20))) - 90;
								
							draw_set_color_write_enable(true, (weapon_get_rads(_wep) > 0), false, true);
							
							call(scr.draw_weapon, 
								weapon_get_sprt(_wep),
								gunshine,
								x + lengthdir_x(_dis, _dir),
								y + lengthdir_y(_dis, _dir) + swapmove - (4 * i),
								gunangle,
								_ang,
								_kick,
								_flip,
								image_blend,
								image_alpha * (((i == 0) ? reload : breload) / weapon_get_load(_wep)) * (1 + (0.2 * skill_get(mut_laser_brain))) * _quasar
							);
						}
					}
				}
			}
			
			draw_set_color_write_enable(true, true, true, true);
		}
	}
	
	 // Pit Spark:
	if(array_length(obj.PitSpark)){
		with(instances_matching(obj.PitSpark, "visible", true)){
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.2);
		}
	}
	if(array_length(obj.PitSquidL)){
		with(instances_matching_ne(obj.PitSquidL, "id")){
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
		}
	}
	
#define ntte_draw_shadows
	 // Squid-Launched Floor Chunks:
	if(array_length(obj.TrenchFloorChunk)){
		with(instances_matching(obj.TrenchFloorChunk, "visible", true)){
			if(place_meeting(x, y, Floor)){
				var _scale = clamp(1 / ((z / 200) + 1), 0.1, 0.8);
				draw_sprite_ext(sprite_index, image_index, x, y, _scale * image_xscale, _scale * image_yscale, image_angle, image_blend, 1);
			}
		}
	}
	
#define ntte_draw_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
			
			var _gray = (_type == "normal");
			
			 // Kelp:
			if(_gray && array_length(obj.Kelp)){
				with(instances_matching_ne(obj.Kelp, "id")){
					draw_circle(x, y, 32 + orandom(1), false);
				}
			}
			
			 // Electroplasma:
			if(array_length(obj.ElectroPlasma)){
				var _r = 24 + (24 * _gray);
				with(instances_matching_ne(obj.ElectroPlasma, "id")){
					draw_circle(x, y, _r, false);
				}
			}
			
			 // Lightning Discs:
			if(array_length(obj.LightningDisc)){
				var _scale  = 1.5 + (1.5 * _gray),
					_border = 4;
					
				with(instances_matching_ne(obj.LightningDisc, "id")){
					draw_circle(x - 1, y - 1, (((radius * image_xscale) + _border) * _scale) + orandom(1), false);
				}
			}
			
			 // Quasar Beams:
			if(array_length(obj.QuasarBeam)){
				var _beamScale  = 2   + (3   * _gray),
					_ringRadius = 120 + (160 * _gray);
					
				draw_set_fog(true, draw_get_color(), 0, 0);
				
				with(instances_matching_ne(obj.QuasarBeam, "id")){
					 // Normal:
					if(!ring){
						var	_xscale = _beamScale * image_xscale,
							_yscale = _beamScale * image_yscale;
							
						QuasarBeam_draw_laser(_xscale, _yscale, 1);
						
						 // Rounded Ends:
						var	_x = x,
							_y = y,
							_r = (12 + (1 * ((image_number - 1) - floor(image_index)))) * _yscale;
							
						draw_circle(_x - lengthdir_x(16 * _xscale, image_angle), _y - lengthdir_y(16 * _xscale, image_angle), _r * 1.5, false);
						
						if(array_length(line_seg)){
							with(line_seg[array_length(line_seg) - 1]){
								_x = x - 1 + lengthdir_x(8 * _xscale, dir);
								_y = y - 1 + lengthdir_y(8 * _xscale, dir);
							}
						}
						
						draw_circle(_x, _y, _r, false);
					}
					
					 // Ring:
					else draw_circle(x, y, (_ringRadius * ring_size) + random(4), false);
				}
				
				draw_set_fog(false, 0, 0, 0);
			}
			
			 // Anglers:
			if(array_length(obj.Angler)){
				draw_set_fog(true, draw_get_color(), 0, 0);
				if(!_gray){
					draw_set_blend_mode(bm_subtract);
				}
				with(instances_matching_ne(obj.Angler, "id")){
					var _img = image_index;
					if(sprite_index != spr_appear){
						_img = sprite_get_number(spr.AnglerLight) - 1;
					}
					
					 // Funny manual buzziness since it's a sprite:
					var _off = random(2);
					for(var _ang = 0; _ang < 360; _ang += 45){
						draw_sprite_ext(spr.AnglerLight, _img, x + lengthdir_x(_off, _ang), y + lengthdir_y(_off, _ang), right, 1, 0, c_white, 1);
					}
				}
				if(!_gray){
					draw_set_blend_mode(bm_normal);
				}
				draw_set_fog(false, 0, 0, 0);
			}
			
			 // Jellies:
			if(array_length(obj.Jelly)){
				var _r = 40 + (40 * _gray);
				with(instances_matching_ne(obj.Jelly, "id")){
					var	_off = 0,
						_img = floor(image_index);
						
					if(
						sprite_index == spr_fire
						|| (sprite_index == spr_hurt && _img != 1)
						|| (sprite_index == spr_idle && (_img == 1 || _img == 3))
					){
						_off = 5;
					}
					
					draw_circle(x, y, _r + _off + orandom(1), false);
				}
			}
			
			 // Elite Eels:
			if(array_length(obj.Eel)){
				var _inst = instances_matching_gt(obj.Eel, "elite", 0);
				if(array_length(_inst)){
					with(_inst){
						var _r = (
							_gray
							? 48
							: min(32, (elite / 2) + 3)
						);
						draw_circle(x, y, _r + orandom(2), false);
					}
				}
			}
			
			 // Squid Arms:
			if(array_length(obj.PitSquidArm)){
				var _inst = instances_matching(obj.PitSquidArm, "visible", true);
				if(array_length(_inst)){
					var _r = 24 + (48 * _gray);
					with(_inst){
						draw_circle(x, y - 12, _r + orandom(1), false);
					}
				}
			}
			
			 // Pit Squid:
			if(array_length(obj.PitSquid)){
				var _inst = instances_matching_ge(obj.PitSquid, "pit_height", 1);
				if(array_length(_inst)){
					if(_gray){
						with(_inst){
							with(eye){
								draw_circle(x, y, ((blink ? 48 : 64) + orandom(1)), false);
							}
						}
					}
					else with(_inst){
						with(eye){
							if(!blink){
								draw_circle(x, y, 32 + orandom(1), false);
							}
						}
					}
				}
			}
			
			break;
			
	}
	
#define draw_anglertrail
	if(instance_exists(Player) || array_length(obj.Angler)){
		var _inst = [[], []];
		
		 // Gather Instances:
		if(array_length(obj.Angler)){
			_inst[0] = instances_matching(instances_matching(obj.Angler, "hiding", false), "visible", true);
		}
		if(instance_exists(Player)){
			_inst[1] = instances_matching(instances_matching(Player, "bskin", "angler fish"), "visible", true);
		}
		
		 // Draw:
		if(array_length(_inst[0]) || array_length(_inst[1])){
			if(lag) trace_time();
			
			var	_vx = view_xview_nonsync,
				_vy = view_yview_nonsync,
				_gw = game_width,
				_gh = game_height;
				
			with(call(scr.surface_setup, "AnglerTrail", _gw * 2, _gh * 2, call(scr.option_get, "quality:minor"))){
				x = pfloor(_vx, _gw);
				y = pfloor(_vy, _gh);
				
				surface_set_target(surf);
				//d3d_set_projection_ortho(x, y, w, h, 0);
				
				 // Reset:
				if(reset){
					reset = false;
					draw_clear_alpha(c_black, 0);
				}
				
				 // Clear Over Time:
				if(current_frame_active){
					with(other){
						draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
						draw_sprite_tiled(
							sprBullet1,
							0,
							32 * dcos(current_frame * 20),
							8  * dsin(current_frame * 17)
						);
						draw_set_blend_mode(bm_normal);
					}
				}
				
				d3d_set_projection_ortho(x, y, w, h, 0);
				
				 // Draw Trails:
				if(array_length(_inst[0])){
					_inst[0] = instances_matching_ge(_inst[0], "ammo", 0);
				}
				if(array_length(_inst[1])){
					_inst[1] = instances_matching_ne(_inst[1], "roll", 0);
				}
				with(_inst){
					if(array_length(self)){
						with(self){
							var _isPlayer = instance_is(self, Player);
							
							if(_isPlayer || sprite_index != spr_appear){
								var	_x1    = x,
									_y1    = y,
									_x2    = xprevious,
									_y2    = yprevious,
									_dis   = point_distance(_x1, _y1, _x2, _y2),
									_dir   = point_direction(_x1, _y1, _x2, _y2),
									_spr   = (_isPlayer ? spr.FishAnglerTrail : spr.AnglerTrail),
									_img   = image_index,
									_xsc   = image_xscale * right,
									_ysc   = image_yscale,
									_ang   = (_isPlayer ? (sprite_angle + angle) : image_angle),
									_col   = image_blend,
									_alp   = image_alpha,
									_charm = (_col == c_white && "ntte_charm" in self && ntte_charm.charmed);
									
								if(_charm){
									draw_set_fog(true, make_color_rgb(56, 252, 0), 0, 0);
								}
								
								for(var i = 0; i <= _dis; i++){
									draw_sprite_ext(_spr, _img, _x1 + lengthdir_x(i, _dir), _y1 + lengthdir_y(i, _dir), _xsc, _ysc, _ang, _col, _alp);
								}
								
								if(_charm){
									draw_set_fog(false, 0, 0, 0);
								}
							}
						}
					}
				}
				
				d3d_set_projection_ortho(_vx, _vy, _gw, _gh, 0);
				surface_reset_target();
				
				 // Draw Surface:
				draw_set_blend_mode(bm_add);
				call(scr.draw_surface_scale, surf, x, y, 1 / scale);
				draw_set_blend_mode(bm_normal);
			}
			
			if(lag) trace_time(script[2]);
		}
	}
	
#define lightning_connect // x1, y1, x2, y2, arc, enemy=false, inst=self
	/*
		Creates a lightning arc between the two given points
		Automatically sets team, creator, and hitid based on the calling instance
		
		Args:
			x1, y1 - The starting position
			x2, y2 - The ending position
			arc    - How far the lightning can offset from its main travel line
			enemy  - If it's an enemy lightning arc, defaults to false
			inst   - The creator of the lightning, defaults to self
			
		Ex:
			lightning_connect(x, y, mouse_x, mouse_y, 8 * sin(wave / 60), false, self)
	*/
	
	var	_x1      = argument[0],
		_y1      = argument[1],
		_x2      = argument[2],
		_y2      = argument[3],
		_arc     = argument[4],
		_enemy   = ((argument_count > 5) ? argument[5] : false),
		_inst    = ((argument_count > 6) ? argument[6] : self),
		_disMax  = point_distance(_x1, _y1, _x2, _y2),
		_disAdd  = min(_disMax / 8, 10) + ((_enemy && array_find_index(obj.Eel, _inst) >= 0) ? max(0, array_length(instances_matching_ge(obj.Eel, "arcing", 1)) - 1) : 0),
		_dis     = _disMax,
		_dir     = point_direction(_x1, _y1, _x2, _y2),
		_x       = _x1,
		_y       = _y1,
		_lx      = _x,
		_ly      = _y,
		_wx      = _x,
		_wy      = _y,
		_ox      = lengthdir_x(_disAdd, _dir),
		_oy      = lengthdir_y(_disAdd, _dir),
		_obj     = (_enemy ? EnemyLightning : Lightning),
		_proj    = [],
		_creator = (("creator" in _inst && !instance_is(_inst, hitme)) ? _inst.creator : _inst),
		_hitid   = (("hitid" in _inst) ? _inst.hitid : -1),
		_team    = (("team" in _inst) ? round(_inst.team) : -1),
		_imgInd  = -1,
		_wave    = 0,
		_off     = 0;
		
	while(_dis > _disAdd){
		_dis -= _disAdd;
		
		_x += _ox;
		_y += _oy;
		
		 // Wavy Offset:
		if(_dis > _disAdd){
			_wave = (_dis / _disMax) * pi;
			_off  = (_arc / 6) * sin((_dis / 8) + (current_frame / 6));
			_wx   = _x + lengthdir_x(_off, _dir - 90) + (_arc * sin(_wave));
			_wy   = _y + lengthdir_y(_off, _dir - 90) + (_arc * sin(_wave / 2));
		}
		
		 // End:
		else{
			_wx = _x2;
			_wy = _y2;
		}
		
		 // Lightning:
		with(instance_create(_wx, _wy, _obj)){
			ammo         = ceil(_dis / _disAdd);
			image_xscale = -point_distance(_lx, _ly, x, y) / 2;
			image_angle  = point_direction(_lx, _ly, x, y);
			direction    = image_angle;
			creator      = _creator;
			hitid        = _hitid;
			team         = _team;
			
			 // Exists 1 Frame:
			if(_imgInd < 0){
				_imgInd = ((current_frame * image_speed) + (instance_exists(creator) ? (creator.xstart + creator.ystart) : 0)) % image_number;
			}
			image_index     = _imgInd;
			image_speed_raw = image_number;
			
			array_push(_proj, self);
		}
		
		_lx = _wx;
		_ly = _wy;
	}
	
	 // FX:
	if(chance_ct(array_length(_proj), 200)){
		with(_proj[irandom(array_length(_proj) - 1)]){
			with(instance_create(x + orandom(8), y + orandom(8), PortalL)){
				motion_add(random(360), 1);
			}
			if(_enemy){
				sound_play_hit(sndLightningReload, 0.5);
			}
			else{
				sound_play_pitchvol(sndLightningReload, 1.25 + random(0.5), 0.5);
			}
		}
	}
	
	return _proj;
	
#define lightning_disappear(_inst)
	/*
		Hides or destroys the given lightning instance(s), and replaces them with a BoltTrail disappearing visual
		Returns the BoltTrail instance(s)
	*/
	
	var _instTrail = [];
	
	with(_inst){
		with(instance_create(x, y, object_index)){
			other.image_speed = image_speed;
			instance_delete(self);
		}
		with(instance_create(x, y, BoltTrail)){
			sprite_index = other.sprite_index;
			image_index  = other.image_index;
			image_speed  = other.image_speed;
			image_xscale = other.image_xscale;
			image_yscale = other.image_yscale * power(0.4 / other.image_speed, 4/3);
			image_angle  = other.image_angle;
			image_blend  = other.image_blend;
			image_alpha  = other.image_alpha;
			depth        = other.depth;
			
			 // Dissipate Enemy Lightning Faster:
			if(instance_is(other, EnemyLightning)){
				image_yscale -= random(0.4);
			}
			
			array_push(_instTrail, self);
		}
		
		 // Hide / Destroy Lightning:
		if(instance_is(self, EnemyLightning)){
			instance_delete(self);
		}
		else{
			image_index = 0;
			image_alpha = 0;
		}
	}
	
	return (
		array_length(_instTrail)
		? ((array_length(_instTrail) > 1) ? _instTrail : _instTrail[0])
		: noone
	);
	
	
/// Pits Yo
#define pitless_meeting(_x, _y)
	var	_lastX = x,
		_lastY = y;
		
	x = _x;
	y = _y;
	
	var	_x1 = floor(bbox_left        / 16),
		_y1 = floor(bbox_top         / 16),
		_x2 = ceil((bbox_right  + 1) / 16),
		_y2 = ceil((bbox_bottom + 1) / 16);
		
	x = _lastX;
	y = _lastY;
	
	for(var _px = _x1; _px < _x2; _px++){
		for(var _py = _y1; _py < _y2; _py++){
			if(!global.pit_grid[# _px, _py]){
				return true;
			}
		}
	}
	
	return false;
	
	
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