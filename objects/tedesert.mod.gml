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
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
	
#define BabyScorpion_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.BabyScorpionIdle;
		spr_walk     = spr.BabyScorpionWalk;
		spr_hurt     = spr.BabyScorpionHurt;
		spr_dead     = spr.BabyScorpionDead;
		spr_fire     = spr.BabyScorpionFire;
		spr_shadow   = shd24;
		spr_shadow_y = -1;
		hitid        = [spr_idle, "BABY SCORPION"];
		depth        = -2;
		
		 // Sound:
		snd_hurt = sndScorpionHit;
		snd_dead = sndScorpionDie;
		snd_mele = sndScorpionMelee
		snd_fire = sndScorpionFireStart;
		
		 // Vars:
		mask_index  = mskBandit;
		gold        = false;
		maxhealth   = 7;
		meleedamage = 6;
		canmelee    = true;
		raddrop     = 4;
		size        = 1;
		walk        = 0;
		ammo        = 0;
		walkspeed   = 0.8;
		maxspeed    = 2.4;
		gunangle    = random(360);
		direction   = gunangle;
		
		 // Alarms:
		alarm1 = 40 + irandom(30);
		
		return self;
	}

#define BabyScorpion_step
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
	if(sprite_index != spr_hurt || anim_end){
		sprite_index = ((ammo > 0) ? spr_fire : enemy_sprite);
	}

#define BabyScorpion_alrm1
	alarm1 = 50 + irandom(30);
	
	enemy_target(x, y);
	
	 // Attack:
	if(ammo > 0){
		ammo--;
		alarm1 = (gold ? 2 : irandom_range(1, 3));
		
		 // Aim and walk:
		if(instance_exists(target) && target_visible){
			enemy_look(target_direction);
		}
		enemy_walk(
			gunangle + orandom(10),
			alarm1 + 3
		);
		
		 // Golden venom shot:
		if(gold){
			var _off = random_range(20, 60);
			for(var _ang = -_off; _ang <= _off; _ang += _off){
				call(scr.projectile_create,
					x,
					y,
					"VenomPellet",
					gunangle + _ang,
					((_ang == 0) ? 10 : 6) + random(2)
				);
			}
		}
		
		 // Normal venom shot:
		else call(scr.projectile_create,
			x,
			y,
			"VenomPellet",
			gunangle + orandom(20),
			7 + random(4)
		);
		
		 // Effects:
		sound_play_pitch(sndScorpionFire, 1.4 + random(0.2));
		if(chance(1, 4)){
			call(scr.fx, x, y, [gunangle + orandom(24), random_range(2, 6)], AcidStreak);
		}
		
		 // End:
		if(ammo <= 0){
			alarm1 = 20 + irandom(20);
			sprite_index = spr_idle;
			sound_play_pitchvol(sndSalamanderEndFire, 1.6, 0.4);
		}
	}
	
	 // Normal AI:
	else if(instance_exists(target) && target_visible){
		enemy_look(point_direction(x, y, target.x + target.hspeed, target.y + target.vspeed));
		
		var _targetDis = target_distance;
		
		 // Start attack:
		if(chance(2, 3) && _targetDis > 32 && _targetDis < 96){
			alarm1 = 1;
			ammo   = 6 + irandom(2);
			sound_play_pitch(snd_fire, 1.6);
		}
		
		 // Move Away From Target:
		else if(_targetDis <= 32){
			alarm1 = 20 + irandom(30);
			enemy_walk(gunangle + 180 + orandom(40), random_range(10, 20));
			enemy_look(direction);
		}
		
		 // Move Towards Target:
		else{
			alarm1 = 30 + irandom(20);
			enemy_walk(gunangle + orandom(40), random_range(20, 35));
		}
	}
	
	 // Wander:
	else{
		enemy_walk(random(360), 30);
		enemy_look(direction);
	}

#define BabyScorpion_hurt(_damage, _force, _direction)
	call(scr.enemy_hurt, _damage, _force, _direction);
	
	 // Pitched Sound:
	if(snd_hurt == sndScorpionHit || snd_hurt == sndGoldScorpionHurt){
		call(scr.sound_play_at, x, y, snd_hurt, 1.2 + random(0.3));
	}
	
#define BabyScorpion_death
	pickup_drop(16, 0);
	
	 // Venom Explosion:
	if(gold){
		repeat(4 + irandom(4)) call(scr.projectile_create, x, y, "VenomPellet", random(360), 8 + random(4));
		repeat(8 + irandom(8)) call(scr.projectile_create, x, y, "VenomPellet", random(360), 4 + random(4));
	}
	
	 // Effects:
	var _len = 6;
	repeat(gold ? 3 : 2){
		var _dir = direction + orandom(60);
		call(scr.fx,
			x + lengthdir_x(_len, _dir),
			y + lengthdir_y(_len, _dir),
			[_dir, 4 + random(4)],
			AcidStreak
		);
	}
	sound_play_pitchvol(snd_dead, 1.5 + random(0.3), 1.3);
	snd_dead = -1;


#define BabyScorpionGold_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "BabyScorpion")){
		 // Visual:
		spr_idle     = spr.BabyScorpionGoldIdle;
		spr_walk     = spr.BabyScorpionGoldWalk;
		spr_hurt     = spr.BabyScorpionGoldHurt;
		spr_dead     = spr.BabyScorpionGoldDead;
		spr_fire     = spr.BabyScorpionGoldFire;
		hitid        = [spr_idle, "BABY GOLDEN#SCORPION"];
		sprite_index = spr_idle;
		
		 // Sound:
		snd_hurt = sndGoldScorpionHurt;
		snd_dead = sndGoldScorpionDead;
		snd_mele = sndGoldScorpionMelee;
		snd_fire = sndGoldScorpionFire;
		
		 // Vars:
		gold      = true;
		maxhealth = 16;
		my_health = maxhealth;
		raddrop   = 14;
		
		return self;
	}
	
	
#define BanditCamper_create(_x, _y)
	with(instance_create(_x, _y, Bandit)){
		 // Visual:
		spr_idle = spr.BanditCamperIdle;
		spr_walk = spr.BanditCamperWalk;
		spr_hurt = spr.BanditCamperHurt;
		spr_dead = spr.BanditCamperDead;
		hitid    = [spr_idle, "CAMPER BANDIT"];
		
		 // Vars:
		rider_target = noone;
		
		return self;
	}
	
#define BanditCamper_end_step
	 // Riding Scorpion:
	if(instance_exists(rider_target)){
		 // Visual:
		if(sprite_index != spr_hurt){
			sprite_index = ((rider_target.speed <= 0) ? spr_idle : spr_walk);
		}
		depth = rider_target.depth - 1;
		right = rider_target.right;
		
		 // Hold:
		x = rider_target.x;
		y = rider_target.y;
		xprevious = x;
		yprevious = y;
		x -= ((sprite_index == spr_idle) ? 2 : 1) * right;
		y -= ((sprite_index == spr_idle) ? 10 : 8);
	}
	
	
#define BanditHiker_create(_x, _y)
	with(instance_create(_x, _y, Bandit)){
		 // Visual:
		spr_idle = spr.BanditHikerIdle;
		spr_walk = spr.BanditHikerWalk;
		spr_hurt = spr.BanditHikerHurt;
		spr_dead = spr.BanditHikerDead;
		gunspr   = sprAllyGunTB;
		hitid    = [spr_idle, "HIKER BANDIT"];
		
		 // Vars:
		maxhealth  = 16;
		my_health  = maxhealth;
		path       = [];
		path_delay = 0;
		can_path   = true;
		
		return self;
	}
	
#define BanditHiker_step
	 // Aggro++
	if(alarm1 > 1 && current_frame_active){
		alarm1--;
	}
	
	 // Path to Player:
	if(path_delay > 0){
		path_delay -= current_time_scale;
	}
	if(walk > 0 && instance_exists(target)){
		if(!target_visible){
			var	_tx      = target.x,
				_ty      = target.y,
				_pathDir = call(scr.path_direction, path, x, y, Wall);
				
			 // Follow Path:
			if(_pathDir != null && call(scr.path_reaches, path, _tx, _ty, Wall)){
				can_path  = true;
				direction = angle_lerp(direction, _pathDir, 0.25 * current_time_scale);
			}
			
			 // Create Path:
			else if(can_path && path_delay <= 0){
				can_path   = false;
				path_delay = 60;
				path       = call(scr.path_create, x, y, _tx, _ty, Wall);
				path       = call(scr.path_shrink, path, Wall, 4);
			}
		}
		else can_path = true;
	}
	
	
#define BanditTent_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle   = spr.BanditTentIdle;
		spr_hurt   = spr.BanditTentHurt;
		spr_dead   = spr.BanditTentDead;
		spr_shadow = spr.shd.BanditTent;
		depth      = -1;
		
		 // Sound:
		snd_hurt = sndHitPlant;
		snd_dead = sndMoneyPileBreak;
		
		 // Vars:
		mask_index  = -1;
		maxhealth   = 6;
		my_health   = maxhealth;
		team        = 1;
		size        = 1;
		target      = noone;
		target_mask = mskNone;
		
		 // Bandits:
		call(scr.instance_budge,
			call(scr.obj_create, x, y, "BanditCamper"),
			Wall
		);
		
		return self;
	}
	
#define BanditTent_step
	 // Holding Chest:
	if(instance_exists(target)){
		with(target){
			x         = other.x;
			y         = other.y + 4;
			xprevious = x;
			yprevious = y;
			
			 // Disable Hitbox:
			// if(mask_index != mskNone){
			// 	other.target_mask = mask_index;
			// 	mask_index        = mskNone;
			// }
		}
	}
	else if(target != noone){
		my_health = 0;
	}
	
	 // Propped Up:
	if(spr_idle == spr.BanditTentWallIdle){
		if(!collision_circle(x - (8 * image_xscale), y, 1, Wall, false, false)){
			my_health = 0;
		}
	}
	
#define BanditTent_death
	 // Release Chest:
	// if(target_mask != mskNone){
	// 	with(target){
	// 		mask_index = other.target_mask;
	// 	}
	// }
	
	 // FX:
	var _ang = random(360);
	for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 3)){
		call(scr.fx, x, y, [_dir, 3], Dust);
	}
	
	
#define BigCactus_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_shadow   = shd32;
		spr_shadow_y = 4;
		depth        = -1;
		switch(GameCont.area){
			case area_campfire:
				spr_idle = spr.BigNightCactusIdle;
				spr_hurt = spr.BigNightCactusHurt;
				spr_dead = spr.BigNightCactusDead;
				break;
				
			case "coast":
				spr_idle = spr.BigBloomingCactusIdle;
				spr_hurt = spr.BigBloomingCactusHurt;
				spr_dead = spr.BigBloomingCactusDead;
				break;
				
			default:
				spr_idle = spr.BigCactusIdle;
				spr_hurt = spr.BigCactusHurt;
				spr_dead = spr.BigCactusDead;
		}
		
		 // Sound:
		snd_hurt = sndHitPlant;
		snd_dead = sndPlantSnareTrapper;
		
		 // Vars:
		maxhealth = 24;
		size = 2;
		
		 // Clear Walls:
		instance_create(x, y, PortalClear);
		
		 // Spawn Enemies:
		if(place_meeting(x, y, Floor)){
			var _player = instance_nearest(x, y, Player);
			if(!instance_exists(_player) || point_distance(x, y, _player.x, _player.y) > 96){
				repeat(choose(2, 3)){
					call(scr.obj_create, x, y, ((GameCont.area == "coast") ? "Gull" : "BabyScorpion"));
				}
			}
		}
		
		return self;
	}

#define BigCactus_death
	 // Dust-o:
	var _ang = random(360);
	for(var _dir = _ang; _dir < _ang + 360; _dir += random_range(60, 180)){
		with(call(scr.fx, x, y, [_dir, random_range(4, 5)], Dust)){
			friction *= 2;
		}
	}


#define BigMaggotSpawn_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle   = spr.BigMaggotSpawnIdle;
		spr_walk   = spr_idle;
		spr_hurt   = spr.BigMaggotSpawnHurt;
		spr_dead   = spr.BigMaggotSpawnDead;
		spr_chrg   = spr.BigMaggotSpawnChrg;
		spr_shadow = shd64B;
		hitid      = [spr_idle, "BIG MAGGOT NEST"];
		depth      = -1;
		
		 // Sound:
		snd_hurt = sndHitFlesh;
		snd_dead = sndBigMaggotDie;
		
		 // Vars:
		mask_index = mskLast;
		maxhealth  = 42;
		lsthealth  = maxhealth;
		raddrop    = 6;
		size       = 4;
		loop_snd   = -1;
		scorp_drop = 0;
		
		 // Alarms:
		alarm0 = 150;
		
		 // Flies:
		var _flyPos = [
			[-18, -14],
			[  0, -28],
			[ 26, -16 + orandom(6)]
		];
		for(var i = 0; i < array_length(_flyPos); i++){
			with(call(scr.obj_create, x, y, "FlySpin")){
				target   = other;
				target_x = (_flyPos[i, 0] + orandom(2)) * other.right;
				target_y = (_flyPos[i, 1] + orandom(2));
			}
		}
		
		 // Mags:
		repeat(irandom_range(3, 6)){
			instance_create(x, y, Maggot);
		}
		
		 // Clear Walls:
		with(instance_create(x, y, PortalClear)){
			sprite_index = mskScrapBoss;
		}
		
		return self;
	}

#define BigMaggotSpawn_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Stay Still:
	x = xstart;
	y = ystart;
	speed = 0;
	
	 // Idle Sound:
	var _nearPlayer = (distance_to_object(Player) < 64);
	if(_nearPlayer){
		if(!audio_is_playing(loop_snd)){
			loop_snd = sound_play(sndMaggotSpawnIdle);
		}
	}
	else if(loop_snd != -1){
		sound_stop(loop_snd);
		loop_snd = -1;
	}
	
	 // Animate:
	if(sprite_index != spr_chrg || anim_end){
		sprite_index = enemy_sprite;
		if(image_index < 1 && sprite_index == spr_idle){
			var _num = (_nearPlayer ? 0.3 : 0.2);
			image_index += random(image_speed_raw * _num) - image_speed_raw;
		}
	}
	
	 // Clear Walls:
	if(place_meeting(x, y, Wall)){
		with(call(scr.instances_meeting_instance, self, Wall)){
			if(place_meeting(x, y, other)){
				instance_create(x, y, FloorExplo);
				instance_destroy();
			}
		}
	}
	
	 // True Maggot Spawn:
	if(lsthealth > my_health){
		if(current_frame_active){
			lsthealth -= 3;
			
			 // Maggot:
			var	_loop = chance(GameCont.loops, 3),
				_l    = (24 + orandom(2)) * image_xscale,
				_d    = (_loop ? random(360) : random_range(200, 340));
				
			with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l * 0.5, _d), (_loop ? FiredMaggot : Maggot))){
				x       = xstart;
				y       = ystart;
				kills   = 1; // FiredMaggot Fix
				creator = other;
				
				 // Effects:
				for(var i = 0; i <= (4 * _loop); i += 2){
					with(instance_create(x, y, DustOLD)){
						motion_add(_d + orandom(10), 2 + i);
						depth = other.depth - 1;
						image_blend = make_color_rgb(170, 70, 60);
						image_speed /= max(1, (i / 2.5));
					}
				}
				
				 // Sounds:
				var _snd = audio_play_sound((_loop ? sndFlyFire : sndHitFlesh), 0, false);
				audio_sound_gain(_snd, min(0.9, random_range(24, 32) / (distance_to_object(Player) + 1)), 0);
				audio_sound_pitch(_snd, 1.2 + random(0.2));
			}
		}
		
		 // Stayin Alive:
		if(my_health <= 1){
			nexthurt = current_frame + 6;
			sprite_index = spr_hurt;
			image_index = 0;
			alarm0 = 1 + ceil(current_time_scale);
		}
	}
	else{
		if(lsthealth > 0) lsthealth = my_health;
		else my_health = lsthealth;
	}
	
#define BigMaggotSpawn_alrm0
	alarm0 = irandom_range(15, 60);
	
	 // Fallin Apart:
	if(my_health > 0){
		enemy_target(x, y);
		
		if(
			my_health <= 1
			|| distance_to_object(target) < 64
			|| (chance(1, 3) && instance_exists(target) && target_visible)
		){
			my_health -= 2;
		}
	}

#define BigMaggotSpawn_hurt(_damage, _force, _direction)
	if(my_health > 1){
		call(scr.enemy_hurt, _damage, _force, _direction);
		my_health = max(1, my_health);
	}
	else alarm0 = min(alarm0, 2);

#define BigMaggotSpawn_death
	speed /= 5;
	
	 // Scrop:
	if(scorp_drop > 0) repeat(scorp_drop){
		instance_create(x, y, Scorpion);
	}
	
	 // Maggots:
	repeat(2){
		with(instance_create(x, y, MaggotExplosion)){
			creator = other;
		}
	}
	repeat(irandom_range(2, 3)){
		with(instance_create(x, y, (chance(max(0.01, GameCont.loops), 3) ? JungleFly : BigMaggot))){
			creator = other;
			raddrop = 4;
			
			 // Rare:
			if(instance_is(self, JungleFly) && GameCont.loops <= 0){
				with(call(scr.alert_create, self, spr.FlyAlert)){
					alarm0 = 75;
					blink  = 20;
				}
			}
		}
	}
	
	 // Flies:
	repeat(irandom_range(3, 6)){
		call(scr.obj_create, x + orandom(32), y + orandom(16), "FlySpin");
	}
	
	 // Pickups:
 	pickup_drop(50, 35, 0);
	pickup_drop(50, 35, 1);
	pickup_drop(100, 0);
	pickup_drop(100, 0);
	
	/*
	if(chance(1, 10)){
		with(call(scr.chest_create, x, y, BigWeaponChest)){
			motion_add(random(360), 2);
			repeat(12) call(scr.fx, x, y, random_range(4, 6), Dust);
		}
		sound_play_pitchvol(sndStatueHurt, 2 + orandom(0.2), 0.8);
		sound_play_pitchvol(sndChest, 0.6, 1.5);
	}
	else{
		pickup_drop(50, 35, 0);
		pickup_drop(50, 35, 1);
	}
	pickup_drop(100, 0);
	pickup_drop(100, 0);
	*/
	
#define BigMaggotSpawn_cleanup
	sound_stop(sndMaggotSpawnIdle);
	
	
#define Bone_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.Bone;
		image_speed  = 0;
		
		 // Vars:
		mask_index = mskFlakBullet;
		friction   = 1;
		damage     = 34;
		force      = 1;
		typ        = 1;
		wep        = "crabbone";
		curse      = false;
		creator    = noone;
		rotspeed   = 1/3 * choose(-1, 1);
		broken     = false;
		
		return self;
	}
	
#define Bone_step
	 // Spin:
	image_angle += speed_raw * rotspeed;
	
	 // Into Portal:
	if(instance_exists(Portal) && place_meeting(x, y, Portal)){
		if(speed > 0){
			sound_play_pitchvol(
				((lq_defget(wep, "type_index", 0) == 0) ? sndMutant14Turn : sndPlasmaReload),
				0.6 + random(0.2),
				0.8
			);
			repeat(3) instance_create(x, y, Smoke);
		}
		instance_destroy();
	}
	
	 // Turn Back Into Weapon:
	else if(speed <= 0 || (instance_exists(PortalShock) && place_meeting(x + hspeed_raw, y + vspeed_raw, PortalShock))){
		 // Don't Get Stuck on Wall:
		mask_index = object_get_mask(WepPickup);
		if(place_meeting(x, y, Wall) && call(scr.instance_budge, self, Wall)){
			instance_create(x, y, Dust);
		}
		
		 // Goodbye:
		instance_destroy();
	}
	
#define Bone_hit
	var _wepIsPart = (lq_defget(wep, "type_index", 0) > 0);
	
	 // Secret:
	if(instance_is(other, ScrapBoss) && !_wepIsPart){
		with(call(scr.charm_instance, other, true)){
			time = 300;
		}
		sound_play(sndBigDogTaunt);
		broken = true;
		instance_delete(self);
	}
	
	 // Damage:
	else{
		var _canPierce = (
			"race" in creator
			&& creator.race == "chicken"
			&& skill_get(mut_throne_butt) > 0
		);
		if(_canPierce ? projectile_canhit_melee(other) : true){
			var _enemySize = other.size;
			
			projectile_hit(other, damage, speed * force);
			
			if(instance_exists(self)){
				 // Part:
				if(_wepIsPart){
					var _wep = wep;
					while(true){
						var	_len = 8,
							_dir = image_angle,
							_x   = x + lengthdir_x(_len, _dir),
							_y   = y + lengthdir_y(_len, _dir);
							
						switch(lq_defget(_wep, "type_index", 0) - 1){
							
							case 0:
							
								var _protoWep = wep_rusty_revolver;
								
								 // Fetch Proto Weapon:
								if(instance_exists(ProtoChest)){
									with(ProtoChest){
										_protoWep = wep;
									}
								}
								else with(instance_create(0, 0, ProtoChest)){
									_protoWep = wep;
									instance_delete(self);
								}
								
								 // Effects:
								with(instance_create(_x, _y, GunGun)){
									sprite_index = spr.ProtoChestFire;
								}
								sound_play_pitch(sndGunGun, 1.5 + orandom(0.1));
								sound_play_gun(sndStatueXP, 0.3, 0.3);
								
								 // Fire Proto Weapon:
								call(scr.player_fire_at,
									[_x, _y],
									_dir,
									1,
									_protoWep,
									team,
									creator,
									true
								);
								
								break;
								
							case 1:
							
								 // Projectiles:
								var _tetherInst = noone;
								for(var _num = -2; _num <= 2; _num++){
									with(call(scr.projectile_create, _x, _y, "ElectroPlasma", _dir + (60 * _num), 1.5)){
										tether_inst = _tetherInst;
										_tetherInst = self;
										friction    = speed / 90;
									}
								}
								
								 // Plasma Impact:
								call(scr.projectile_create, _x, _y, "ElectroPlasmaImpact", _dir);
								
								 // Safety Zone:
								with(call(scr.projectile_create, _x, _y, "BatScreech")){
									image_speed *= 2/3;
									image_blend  = make_color_rgb(186, 62, 198);
								}
								
								 // Sound:
								if(skill_get(mut_laser_brain) > 0){
									sound_play_gun(sndLightningShotgunUpg, 0.4, 0.6);
								}
								else{
									sound_play_gun(sndLightningShotgun, 0.3, 0.3);
								}
								sound_play_pitchvol(sndHammer, 0.3, 2);
								
								break;
								
							case 2:
							
								var _stickTarget = other;
								if(instance_exists(_stickTarget)){
									_dir += 180;
									_x    = x + lengthdir_x(_len, _dir);
									_y    = y + lengthdir_y(_len, _dir);
									
									 // Projectiles:
									var _laserCannon = call(scr.projectile_create, _x, _y, "BoneArtifactLaserCannon", _dir);
									with(_laserCannon){
										var _ammoAdd = _enemySize * 2;
										target = other;
										delay += 3 * _ammoAdd;
										ammo  += _ammoAdd;
									}
									sound_play_gun(sndLaserCannonCharge, 0.3, 0.3);
									
									 // Stick in Enemy:
									if(_stickTarget.my_health > 0 && !broken){
										with(call(scr.obj_create, x, y, "WepPickupStick")){
											rotation     = other.image_angle;
											curse        = other.curse;
											wep          = other.wep;
											creator      = other.creator;
											if(ultra_get("chicken", 2) && instance_is(creator, Player) && creator.race == "chicken"){
												alarm0 = 30;
											}
											
											 // Sticking:
											stick_target = _stickTarget;
											with(stick_target){
												var	_len = 20,
													_dir = point_direction(other.x, other.y, x, y);
													
												if(max(bbox_width, bbox_height) > _len + 8){
													other.rotation = angle_lerp(other.rotation, _dir, 1/2);
												}
												else{
													other.x        = x - lengthdir_x(_len, _dir);
													other.y        = y - lengthdir_y(_len, _dir);
													other.rotation = _dir;
												}
											}
											stick_x = x - _stickTarget.x;
											stick_y = y - _stickTarget.y;
											
											 // Reorient Laser Cannon:
											with(_laserCannon){
												target      = other;
												direction   = other.rotation + 180;
												image_angle = direction;
											}
										}
										broken = true;
										instance_delete(self);
										exit;
									}
								}
								
								break;
								
							case 3:
							
								 // Projectiles:
								with(call(scr.projectile_create, _x, _y, PlasmaBig, _dir, 1.5)){
									var	_num    = 4,
										_len    = 64,
										_ang    = direction + ((360 / _num) / 2),
										_target = other;
										
									for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 4)){
										with(call(scr.projectile_create, x, y, "VlasmaBullet", _dir + 180)){
											x += lengthdir_x(_len, _dir);
											y += lengthdir_y(_len, _dir);
											target = _target;
											call(scr.team_instance_sprite, 1, self);
										}
									}
									
									call(scr.team_instance_sprite, 1, self);
								}
								
								 // Teleport:
								if(!broken){
									with(call(scr.array_shuffle, instances_matching_ne(Floor, "id"))){
										if(
											place_free(x, y)
											&& !place_meeting(x, y, hitme)
											&& !place_meeting(x, y, chestprop)
											&& !place_meeting(x, y, other)
										){
											var	_cx = bbox_center_x,
												_cy = bbox_center_y;
												
											if(point_distance(_cx, _cy, other.x, other.y) < 192){
												with(other){
													instance_create(x, y, ChickenB);
													x = _cx;
													y = _cy;
													image_index = 1;
													instance_create(x, y, ChickenB);
													
													 // Sound:
													sound_play_pitchvol(sndPlasma, 0.6 + orandom(0.1), 1.5);
													sound_play_pitch(sndEliteShielderTeleport, 1.6 + orandom(0.1));
												}
												break;
											}
										}
									}
								}
								
								 // Sound:
								if(skill_get(mut_laser_brain) > 0){
									sound_play_gun(sndPlasmaBigUpg, 0.3, -0.5);
								}
								else{
									sound_play_gun(sndPlasmaBig, 0.3, -0.5);
								}
								
								break;
								
						}
						if(call(scr.weapon_has_temerge, _wep)){
							_wep = call(scr.weapon_get_temerge_weapon, _wep);
						}
						else break;
					}
					if(!_canPierce){
						instance_destroy();
					}
				}
				
				 // Bone:
				else if(!_canPierce){
					 // Sound:
					call(scr.sound_play_at, x, y, sndBloodGamble, 1.2 + random(0.2), 3);
					
					 // Break:
					var _disSkull = infinity;
					with(instances_matching_ne(obj.CoastBossBecome, "id")){
						var _dis = point_distance(x, y, other.x, other.y);
						if(_dis < _disSkull){
							_disSkull = _dis;
						}
					}
					if(_disSkull > 32){
						broken = true;
						instance_destroy();
					}
				}
			}
		}
	}
	
#define Bone_wall
	 // Bounce Off Wall:
	move_bounce_solid(true);
	speed /= 2;
	rotspeed *= -1;
	
	 // Effects:
	sound_play_hit(sndHitWall, 0.2);
	instance_create(x, y, Dust);
	
#define Bone_destroy
	instance_create(x, y, Dust);
	
	 // Darn:
	if(broken){
		if(lq_defget(wep, "type_index", 0) == 0){
			call(scr.sound_play_at, x, y, sndHitRock, 1.4 + random(0.2), 2.5);
			
			 // for u yokin:
			repeat(2){
				with(call(scr.obj_create, x, y, "BonePickup")){
					sprite_index = spr.BoneShard;
					motion_add(random(360), 2);
				}
			}
		}
		else{
			instance_create(x, y, ChickenB);
			sound_play(sndPlasmaReloadUpg);
			if(instance_is(creator, Player)){
				creator.gunshine = max(creator.gunshine, 7);
			}
		}
	}
	
#define Bone_cleanup
	 // Pickupable:
	if(!broken){
		with(instance_create(x, y, WepPickup)){
			rotation = other.image_angle;
			curse    = other.curse;
			wep      = other.wep;
			creator  = other.creator;
			if(ultra_get("chicken", 2) && instance_is(creator, Player) && creator.race == "chicken"){
				alarm0 = 30;
			}
			
			 // Grab Projectiles:
			with(instances_matching(projectile, "target", other)){
				target = other;
			}
		}
	}
	
	
#define BoneArtifactLaserCannon_create(_x, _y)
	/*
		A custom laser cannon used for the "stolen" artifact weapon
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprPopoPlasma;
		image_speed  = 0;
		image_xscale = 0.2;
		image_yscale = image_xscale;
		ntte_bloom   = 0.1;
		
		 // Vars:
		damage = 4;
		force  = 7;
		delay  = 15;
		time   = 2;
		ammo   = 5 + (2 * skill_get(mut_laser_brain));
		target = noone;
		
		return self;
	}
	
#define BoneArtifactLaserCannon_step
	/*
		Bone artifact laser cannons follow their target and fire blue lasers
	*/
	
	if(ammo > 0){
		 // Grow:
		var	_maxScale  = 0.5,
			_growScale = 0.02 * current_time_scale;
			
		if(image_xscale < _maxScale || image_yscale < _maxScale){
			if(image_xscale < _maxScale) image_xscale = min(image_xscale + _growScale, _maxScale);
			if(image_yscale < _maxScale) image_yscale = min(image_yscale + _growScale, _maxScale);
		}
		else{
			var _scaleMult = 0.8;
			image_xscale *= _scaleMult;
			image_yscale *= _scaleMult;
			
			 // Sound:
			sound_play_pitch(sndIDPDNadeLoad, lerp(2, 1.2, delay / 30) + orandom(0.1));
		}
		
		 // Particles:
		if(chance_ct(1, 3)){
			with(instance_create(x + orandom(16), y + orandom(16), IDPDPortalCharge)){
				motion_add(point_direction(x, y, other.x, other.y), random_range(1, 2));
				alarm0 = 1 + (point_distance(x, y, other.x, other.y) / speed);
			}
		}
		
		 // Follow Creator:
		if(target != noone){
			if(!instance_exists(target) && distance_to_object(Player) < 24){
				target = instance_nearest(x, y, Player);
			}
			if(instance_exists(target)){
				var _len = 8;
				if("gunangle" in target){
					direction = target.gunangle;
					var _wepKick  = (("wkick" in target) ? target.wkick : 0);
					if("wepangle" in target){
						direction += target.wepangle * (1 - (_wepKick / 20));
					}
					direction += 180;
					_len      += _wepKick;
				}
				x         = target.x + target.hspeed_raw + lengthdir_x(_len, direction);
				y         = target.y + target.vspeed_raw + lengthdir_y(_len, direction);
				xprevious = x;
				yprevious = y;
			}
		}
		
		 // Firing:
		if(delay > 0){
			delay -= current_time_scale;
			if(delay <= 0){
				ammo--;
				delay = time;
				
				 // Shrink:
				image_xscale *= 0.5;
				image_yscale *= 0.5;
				
				 // Fire Laser:
				with(call(scr.projectile_create, x, y, "PopoLaser", direction + orandom(8))){
					image_yscale += 0.6 * skill_get(mut_laser_brain);
					depth         = other.depth;
					event_perform(ev_alarm, 0);
				}
				
				 // Sound:
				sound_play_gun(
					((skill_get(mut_laser_brain) > 0) ? sndLaserCannonUpg : sndLaserCannon),
					0.3,
					0.3
				);
				
				 // Effects:
				if(instance_is(target, Player)){
					with(target){
						weapon_post(-10, 3, 2);
					}
				}
				else{
					view_shake_at(x, y, 2);
				}
				
				 // Push:
				with(
					("stick_target" in target && instance_exists(target.stick_target))
					? target.stick_target
					: target
				){
					motion_add(other.direction + 180, 1.5);
					
					 // Clear Walls:
					call(scr.wall_clear, self, x + hspeed, y + vspeed);
				}
			}
		}
	}
	else instance_destroy();
	
#define BoneArtifactLaserCannon_wall
	// nothing here
	
#define BoneArtifactLaserCannon_hit
	if(projectile_canhit_melee(other)){
		projectile_hit_push(other, damage, force);
		
		 // Effects:
		view_shake_at(x, y, 2);
		sleep(5);
	}
	
	
#define CoastBossBecome_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle    = spr.BigFishBecomeIdle;
		spr_hurt    = spr.BigFishBecomeHurt;
		spr_dead    = sprBigSkullDead;
		spr_shadow  = shd32;
		image_speed = 0;
		depth       = -1;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = -1;
		
		 // Vars:
		mask_index = mskScorpion;
		maxhealth  = 100 * (1 + GameCont.loops);
		size       = 2;
		part       = 0;
		team       = 0;
		
		 // Easter:
		prompt = call(scr.prompt_create, self, "DONATE");
		with(prompt){
			on_meet = script_ref_create(CoastBossBecome_prompt_meet);
		}
		
		 // Part Bonus:
		part += variable_instance_get(GameCont, "ntte_visits_coast", 0);
		part += GameCont.loops;
		part = min(part, sprite_get_number(spr_idle) - 2);
		
		return self;
	}
	
#define CoastBossBecome_step
	speed = 0;
	x = xstart;
	y = ystart;
	
	 // Animate:
	sprite_index = ((nexthurt < current_frame + 4) ? spr_idle : spr_hurt);
	image_index  = clamp(part, 0, image_number - 1);
	
	 // Boneman Feature:
	if(instance_exists(prompt)){
		with(player_find(prompt.pick)){
			projectile_hit(self, 1);
			lasthit = [sprBone, "GENEROSITY"];
			
			with(other) with(call(scr.obj_create, x, y, "Bone")){
				projectile_hit(other, damage);
			}
		}
	}
	
	 // Rebuilding Skeleton:
	if(part > 0){
		 // Break Walls:
		var	_size = 4 * part,
			_x1 = bbox_left  - _size - (_size * image_xscale),
			_y1 = bbox_top,
			_x2 = bbox_right + _size - (_size * image_xscale),
			_y2 = bbox_bottom;
			
		with(call(scr.instances_meeting_rectangle, _x1, _y1, _x2, _y2, Wall)){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
		
		 // Complete:
		if(part >= sprite_get_number(spr_idle) - 1){
			with(call(scr.obj_create, x - (image_xscale * 8), y - 6, "CoastBoss")){
				x = xstart;
				y = ystart;
				right = other.image_xscale;
			}
			with(WantBoss) instance_destroy();
			with(BanditBoss) my_health = 0;
			call(scr.portal_poof);
			
			instance_delete(self);
			exit;
		}
	}
	
	 // Death:
	if(my_health <= 0){
		instance_destroy();
	}
	
#define CoastBossBecome_hurt(_damage, _force, _direction)
	my_health -= _damage;
	nexthurt = current_frame + 6;
	sound_play_hit(snd_hurt, 0.3);
	
	 // Secret:
	with(other){
		if(
			(
				(instance_is(self, ThrownWep) || array_find_index(obj.Bone, self) >= 0)
				&& call(scr.wep_raw, wep) == "crabbone"
				&& lq_defget(wep, "type_index", 0) == 0
			)
			|| array_find_index(obj.BoneArrow, self) >= 0
		){
			var _add = lq_defget(variable_instance_get(self, "wep"), "ammo", 1) + variable_instance_get(self, "big", 0);
			
			with(other){
				part += _add;
				my_health = max(my_health, maxhealth);
				
				 // Effects:
				sound_play_hit(sndMutant14Turn, 0.2);
				repeat(3 * _add){
					instance_create(other.x + orandom(4), other.y + orandom(4), Bubble);
					with(instance_create(x - (image_xscale * 8 * part), y, Smoke)){
						motion_add(random(360), 1);
						depth = -2;
					}
				}
			}
			
			if(array_find_index(obj.Bone, self) >= 0){
				broken = true;
			}
			instance_delete(self);
		}
	}
	
#define CoastBossBecome_destroy
	call(scr.corpse_drop, self, 0, 0);
	
	 // Death Effects:
	if(part > 0){
		sound_play(sndOasisDeath);
		repeat(part){
			with(instance_create(x, y, WepPickup)){
				wep = "crabbone";
				motion_add(random(360), 3);
			}
			repeat(2) instance_create(x, y, Bubble);
		}
	}
	else for(var _ang = direction; _ang < direction + 360; _ang += (360 / 10)){
		call(scr.fx, x, y, [_ang, 3], Dust);
	}
	
#define CoastBossBecome_prompt_meet
	if(other.race == "skeleton") return true;
	return false;
	
	
#define CoastBoss_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
		 // Visual:
		spr_spwn     = spr.BigFishSpwn;
		spr_idle     = sprBigFishIdle;
		spr_walk     = sprBigFishWalk;
		spr_hurt     = sprBigFishHurt;
		spr_dead     = sprBigFishDead;
		spr_weap     = mskNone;
		spr_chrg     = sprBigFishFireStart;
		spr_fire     = sprBigFishFire;
		spr_efir     = sprBigFishFireEnd;
		spr_dive     = spr.BigFishLeap;
		spr_rise     = spr.BigFishRise;
		spr_shad     = shd48;
		spr_shadow   = spr_shad;
		hitid        = 105; // Big Fish
		sprite_index = spr_spwn;
		depth        = -2;
		
		 // Sound:
		snd_hurt = sndOasisBossHurt;
		snd_dead = sndOasisBossDead;
		snd_mele = sndOasisBossMelee;
		snd_lowh = sndOasisBossHalfHP;
		
		 // Vars:
		mask_index      = mskBigMaggot;
		maxhealth       = call(scr.boss_hp, 150);
		raddrop         = 50;
		size            = 3;
		meleedamage     = 3;
		walk            = 0;
		walkspeed       = 0.8;
		maxspeed        = 3;
		ammo            = 4;
		swim            = 0;
		swim_mask       = -1;
		swim_target     = noone;
		gunangle        = random(360);
		direction       = gunangle;
		canfly          = true;
		intro           = false;
		tauntdelay      = 40;
		swim_ang_frnt   = direction;
		swim_ang_back   = direction;
		shot_wave       = 0;
		fish_train      = [];
		fish_swim       = [];
		fish_swim_delay = 0;
		fish_swim_regen = 0;
		for(var i = 0; i < (GameCont.loops * 3); i++){
			fish_train[i] = noone;
		}
		
		 // Alarms:
		alarm1 = 90;
		alarm2 = -1;
		alarm3 = -1;
		
		 // For Sani's bosshudredux:
		bossname = "BIG FISH";
		col      = c_red;
		
		return self;
	}
	
#define CoastBoss_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	if(alarm3_run) exit;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	if(array_find_index([spr_hurt, spr_spwn, spr_chrg, spr_fire, spr_efir, spr_dive, spr_rise], sprite_index) < 0){
		sprite_index = enemy_sprite;
	}
	else if(anim_end){
		if(sprite_index == spr_spwn){
			sprite_index = spr_hurt;
			image_index  = 0;
			
			 // Spawn FX:
			hspeed += 2 * right;
			vspeed += orandom(2);
			view_shake_at(x, y, 15);
			instance_create(x, y, PortalClear);
			for(var _dir = direction; _dir < direction + 360; _dir += (360 / 5)){
				repeat(2) call(scr.fx, x, y, [_dir + orandom(30), 5], Dust);
				with(call(scr.obj_create, x, y, "WaterStreak")){
					motion_set(_dir + orandom(30), 1 + random(4));
					image_angle = direction;
					image_speed *= random_range(0.8, 1.2);
				}
			}
			call(scr.sound_play_at, x, y, sndOasisBossDead, 1.2 + random(0.1), 1.2);
			
			 // Intro:
			if(!intro){
				intro = true;
				call(scr.boss_intro, "BigFish");
				sound_play(sndOasisBossIntro);
			}
		}
		else if(sprite_index = spr_dive){
			sprite_index = spr_idle;
			image_index  = 0;
			
			 // Start Swimming:
			swim          = 180;
			direction     = 90 - (right * 90);
			swim_ang_frnt = direction;
			swim_ang_back = direction;
			depth         = -1;
		}
		else if(sprite_index = spr_hurt || sprite_index == spr_rise || sprite_index == spr_efir){
			sprite_index = spr_idle;
			image_index  = 0;
		}
		else if(sprite_index = spr_chrg){
			sprite_index = spr_fire;
			image_index  = 0;
		}
		else if(sprite_index = spr_fire && ammo <= 0){
			sprite_index = spr_efir;
			image_index  = 0;
		}
	}
	
	 // Swimming:
	if(swim > 0){
		swim -= current_time_scale;
		
		if(swim_mask != -1) mask_index = swim_mask;
		
		 // Jus keep movin:
		if(instance_exists(swim_target)){
			speed += (friction + (swim / 120)) * current_time_scale;
			
			 // Turning:
			var	_x = swim_target.x,
				_y = swim_target.y;
				
			if(point_distance(x, y, _x, _y) < 100){
				var	_dis = 80,
					_dir = direction + (10 * right);
					
				_x += lengthdir_x(_dis, _dir);
				_y += lengthdir_y(_dis, _dir);
			}
			
			direction = angle_lerp_ct(direction, point_direction(x, y, _x, _y), 1/16);
		}
		else swim = 0;
		
		 // Turn Fins:
		swim_ang_frnt = angle_lerp_ct(swim_ang_frnt, direction,     1/3);
		swim_ang_back = angle_lerp_ct(swim_ang_back, swim_ang_frnt, 1/10);
		
		 // Break Walls:
		if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
			speed *= 2/3;
			
			 // Effects:
			with(call(scr.instance_nearest_bbox, x, y, Wall)){
				var	_cx = bbox_center_x,
					_cy = bbox_center_y;
					
				with(instance_create(_cx, _cy, MeleeHitWall)){
					motion_add(point_direction(x, y, _cx, _cy), 1);
					image_angle = direction + 180;
				}
			}
			sound_play_pitchvol(sndHammerHeadProc, 1.4 + random(0.2), 0.5);
			
			 // Break Walls:
			with(instance_create(x, y, PortalClear)){
				image_xscale /= 2;
				image_yscale = image_xscale;
			}
		}
		
		 // Visual:
		spr_shadow = mskNone;
		if(current_frame_active){
			image_angle = 0;
			var	_cx = x,
				_cy = y + 7;
				
			 // Debris:
			if((place_meeting(x, y, FloorExplo) && chance(1, 30)) || chance(1, 40)){
				repeat(irandom(2)){
					with(instance_create(_cx, _cy, Debris)){
						speed /= 2;
					}
				}
			}
			
			 // Ripping Through Ground:
			var	_oDis = [16, -4],
				_oDir = [swim_ang_frnt, swim_ang_back],
				_ang  = [20, 30];
				
			for(var _o = 0; _o < array_length(_oDis); _o++){
				for(var i = -1; i <= 1; i += 2){
					var	_x = _cx + lengthdir_x(_oDis[_o], _oDir[_o]),
						_y = _cy + lengthdir_y(_oDis[_o], _oDir[_o]),
						_a = (i * _ang[_o]);
						
					 // Cool Trail FX:
					if(speed > 1){
						with(instance_create(_x, _y, BoltTrail)){
							motion_add(_oDir[_o] + 180 + _a, other.speed * random_range(0.5, 1));
							image_xscale = speed * 2;
							image_yscale = (skill_get(mut_bolt_marrow) ? 0.6 : 1);
							image_angle  = direction;
							hspeed      += other.hspeed;
							vspeed      += other.vspeed;
							friction     = random(0.5);
							depth        = other.depth;
							//image_blend  = make_color_rgb(110, 184, 247);
						}
					}
					
					 // Kick up Dust:
					if(chance(1, 20)){
						with(instance_create(_x, _y, Dust)){
							hspeed += other.hspeed / 2;
							vspeed += other.vspeed / 2;
							motion_add(_oDir[_o] + 180 + (2 * _a), other.speed);
							image_xscale *= .75;
							image_yscale  = image_xscale;
							depth         = other.depth;
						}
					}
				}
			}
			
			 // Quakes:
			if(chance(1, 4)){
				view_shake_at(_cx, _cy, 4);
			}
		}
		
		 // Manual Collisions:
		if(place_meeting(x, y, Player)){
			with(call(scr.instances_meeting_instance, self, instances_matching_ne(Player, "team", team))){
				if(place_meeting(x, y, other)){
					with(other){
						event_perform(ev_collision, Player);
					}
				}
			}
		}
		if(place_meeting(x, y, prop)){
			with(call(scr.instances_meeting_instance, self, prop)){
				if(place_meeting(x, y, other)){
					with(other){
						event_perform(ev_collision, prop);
					}
				}
			}
		}
		
		 // Bolts No:
		with(instances_matching(BoltStick, "target", self)){
			sound_play_hit(sndCrystalPropBreak, 0.3);
			repeat(5) with(instance_create(x, y, Dust)){
				motion_add(random(360), 3);
			}
			instance_destroy();
		}
		
		 // Disable Hitbox:
		if(swim_mask == -1){
			swim_mask = mask_index;
		}
		mask_index = mskNone;
		
		 // Un-Dive:
		if(swim <= 0){
			swim   = 0;
			alarm3 = -1;
			
			 // Facing:
			enemy_face(direction);
			speed = 0;
			
			 // Visual:
			spr_shadow   = spr_shad;
			sprite_index = spr_rise;
			image_index  = 0;
			depth        = -2;
			
			 // Reset Hitbox:
			mask_index = swim_mask;
			swim_mask  = -1;
			
			 // Babbies:
			/*if(GameCont.loops > 0) repeat(GameCont.loops * 3){
				with(instance_create(x, y, BoneFish)) kills = 0;
			}*/
			
			 // Effects:
			instance_create(x, y, PortalClear);
			sound_play_pitchvol(sndFootOrgSand1, 0.5, 5);
			sound_play_pitchvol(sndToxicBoltGas, 0.5 + random(0.2), 0.5);
			repeat(10){
				var	_dis = 12,
					_dir = random(360);
					
				with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), Dust)){
					motion_add(_dir, 3);
				}
			}
		}
	}
	
	 // Death Taunt:
	if(tauntdelay > 0 && !instance_exists(Player)){
		tauntdelay -= current_time_scale;
		if(tauntdelay <= 0){
			sound_play_pitch(sndOasisBossHalfHP, 0.8);
		}
	}
	
	 // Fish Train:
	if(array_length(fish_train)){
		var	_creator   = self,
			_leader    = _creator,
			_broken    = false,
			_fishSwim  = fish_swim,
			_fishIndex = 0;
			
		with(fish_train){
			if(_broken){
				if(instance_exists(self)){
					visible = true;
				}
				other.fish_train[_fishIndex] = noone;
			}
			else{
				var _fish = self;
				
				 // Fish Regen:
				if(!instance_exists(_fish) && other.fish_swim_regen <= 0){
					if(_fishIndex < array_length(_fishSwim) && _fishSwim[_fishIndex]){
						other.fish_swim_regen = 3;
						
						_fish = call(scr.obj_create, _leader.x, _leader.y, (chance(1, 100) ? "Puffer" : BoneFish));
						
						with(_fish){
							kills   = 0;
							creator = _creator;
							
							 // Keep Distance:
							var	_l = 2,
								_d = _leader.direction + 180;
								
							while(point_distance(x, y, _leader.x, _leader.y) < 24){
								x += lengthdir_x(_l, _d);
								y += lengthdir_y(_l, _d);
								direction = _d;
							}
							
							 // Spawn Poof:
							//sound_play(snd)
							repeat(8) with(call(scr.fx, x, y, 1, Dust)){
								depth = other.depth - 1;
							}
						}
						
						other.fish_train[_fishIndex] = _fish;
					}
				}
				
				if(instance_exists(_fish)){
					with(_fish){
						alarm1 = 15 + (_fishIndex * 4);
						
						 // Swimming w/ Big Fish:
						visible = !_fishSwim[_fishIndex];
						if(_fishSwim[_fishIndex]){
							enemy_look(point_direction(x, y, _leader.x, _leader.y));
							
							if(speed > 0 && chance(1, 3)){
								with(instance_create(x + orandom(6), y + random(8), Sweat)){
									direction = other.direction + choose(-60, 60) + orandom(10);
									speed     = 0.5;
								}
							}
						}
						
						 // Follow the Leader:
						var	_dis = distance_to_object(_leader),
							_max = 6;
							
						if(_dis > _max){
							var	_l = 2,
								_d = point_direction(x, y, _leader.x, _leader.y);
								
							while(_dis > _max){
								x += lengthdir_x(_l, _d);
								y += lengthdir_y(_l, _d);
								_dis -= _l;
							}
							motion_add(_d, 1);
						}
						_leader = self;
					}
				}
				else{
					_broken = true;
					other.fish_train[_fishIndex] = noone;
				}
			}
			_fishIndex++;
		}
	}
	
	 // Gradual Swim Train:
	if(fish_swim_delay <= 0){
		fish_swim_delay = 3;
		for(var i = 0; i <= 1; i++){
			var _pos = array_find_last_index(fish_swim, i);
			if(_pos >= 0 && _pos < array_length(fish_train) - 1){
				fish_swim[_pos + 1] = i;
				
				 // EZ burrow:
				with(fish_train[_pos + 1]){
					repeat(8){
						with(instance_create(x + hspeed + orandom(8), y + vspeed + orandom(8), Dust)){
							depth = other.depth - 1;
						}
					}
				}
			}
		}
		fish_swim[0] = (swim > 0);
	}
	fish_swim_delay -= current_time_scale;
	fish_swim_regen -= current_time_scale;
	
#define CoastBoss_hurt(_damage, _force, _direction)
	 // Can't be hurt while swimming:
	/*if(swim){
		if("typ" not in other || other.typ != 0){
			sound_play_pitch(sndCrystalPropBreak, 0.7);
			sound_play_pitchvol(sndShielderDeflect, 1.5, 0.5);
			with(other) if("typ" in self){
				repeat(5) with(instance_create(x, y, Dust)){
					motion_add(random(360), 3);
				}
				
				 // Destroy (1 frame delay to prevent errors):
				if(fork()){
					wait 0;
					if(instance_exists(self)) instance_destroy();
					exit;
				}
			}
		}
	}*/
	
	//else{
		my_health -= _damage;
		nexthurt = current_frame + 6;
		sound_play_hit(snd_hurt, 0.3);
		
		 // Half HP:
		var _half = maxhealth / 2;
		if(my_health <= _half && my_health + _damage > _half){
			sound_play(snd_lowh);
		}
		
		 // Knockback:
		if(swim <= 0){
			motion_add(_direction, _force);
		}
		
		 // Hurt Sprite:
		if(array_find_index([spr_spwn, spr_chrg, spr_fire, spr_efir, spr_dive, spr_rise], sprite_index) < 0){
			sprite_index = spr_hurt;
			image_index  = 0;
		}
	//}
	
#define CoastBoss_draw
	var _hurt = (nexthurt >= current_frame + 4);
	
	 // Burrowed Fish Train:
	var _fishIndex = 0;
	with(fish_train){
		if(instance_exists(self) && other.fish_swim[_fishIndex]){
			var	_spr = sprite_index,
				_img = image_index,
				_xsc = image_xscale * right,
				_ysc = image_yscale,
				_x   = x - (sprite_get_xoffset(_spr) * _xsc),
				_y   = bbox_bottom - (sprite_get_yoffset(_spr) * _ysc) - 1 + spr_shadow_y;
				
			draw_sprite_part_ext(_spr, _img, 0, 0, sprite_get_width(_spr), sprite_get_yoffset(_spr), _x, _y, _xsc, _ysc, image_blend, image_alpha);
		}
		_fishIndex++;
	}
	
	 // Swimming:
	if(swim > 0){
		var	_cx  = x,
			_cy  = y + 7,
			_xsc = image_xscale,
			_ysc = image_yscale,
			_alp = image_alpha,
			_spd = current_frame / 3; // Swimming animation speed
			
		if(_hurt){
			draw_set_fog(true, image_blend, 0, 0);
		}
		
		for(var i = 0; i <= 270; i += 90){
			var	_x   = _cx,
				_y   = _cy,
				_col = image_blend,
				_spr = [spr.BigFishSwimFrnt,       spr.BigFishSwimBack             ],
				_ang = [swim_ang_frnt,             swim_ang_back                   ],
				_dis = [10 * _xsc,                 10 * _xsc                       ], // Offset Distance
				_dir = [_ang[0] + (5 * sin(_spd)), _ang[1] + 180 + (5 * sin(_spd)) ], // Offset Direction
				_trn = [15 * cos(_spd),            -25 * cos(_spd)                 ];
				
			 // Outline:
			if(i < 270){
				_x += dcos(i);
				_y -= dsin(i);
				_col = c_black;
			}
			
			 // Draw Front & Back Fins:
			for(var j = 0; j < array_length(_spr); j++){
				var	_dx   = _x + lengthdir_x(_dis[j], _dir[j]),
					_dy   = _y + lengthdir_y(_dis[j], _dir[j]),
					_dspr = _spr[j];
					
				for(var _img = 0; _img < sprite_get_number(_dspr); _img++){
					draw_sprite_ext(_dspr, _img, _dx, _dy - (_img * _ysc), _xsc, _ysc, _ang[j] - 90 + _trn[j], _col, _alp);
				}
			}
		}
	}
	
	 // Normal Self:
	else{
		if(_hurt && sprite_index != spr_hurt){
			draw_set_fog(true, image_blend, 0, 0);
		}
		draw_self_enemy();
	}
	
	if(_hurt){
		draw_set_fog(false, 0, 0, 0);
	}
	
#define CoastBoss_alrm1
	alarm1 = 30 + random(20);
	
	if(enemy_target(x, y)){
		var _targetDis = target_distance;
		if(_targetDis < 160 && ("reload" not in target || target.reload <= 0 || chance(2, 3))){
			enemy_look(target_direction);
			
			 // Move Towards Target:
			if((_targetDis < 64 && chance(1, 2)) || chance(1, 4)){
				enemy_walk(gunangle + orandom(10), random_range(30, 40));
				alarm1 = walk + random(10);
			}
			
			 // Bubble Blow:
			else{
				ammo   = 4 * (GameCont.loops + 2);
				alarm2 = 3;
				alarm1 = -1;
				
				enemy_walk(gunangle + orandom(30), 8);
				
				sprite_index = spr_chrg;
				image_index  = 0;
				
				 // Sound:
				sound_play_pitch(sndOasisBossFire, 1 + orandom(0.2));
			}
		}
		
		 // Dive:
		else alarm3 = 6;
	}
	
	 // Passive Movement:
	else{
		alarm1 = 40 + random(20);
		enemy_walk(random(360), 20);
		enemy_look(direction);
	}
	
#define CoastBoss_alrm2
	 // Fire Bubble Bombs:
	repeat(irandom_range(1, 2)){
		if(ammo > 0){
			alarm2 = 2;
			
			 // Blammo:
			sound_play(sndOasisShoot);
			call(scr.projectile_create,
				x,
				y,
				"BubbleBomb",
				gunangle + (sin(shot_wave / 4) * 16),
				8 + random(4)
			);
			shot_wave += alarm2;
			walk++;
			
			 // End:
			if(--ammo <= 0){
				alarm1 = 60;
			}
		}
	}
	
#define CoastBoss_alrm3
	enemy_target(x, y);
	swim_target = target;
	
	alarm3 = 8;
	alarm1 = alarm3 + 10;
	
	if(sprite_index != spr_dive){
		 // Dive:
		if(swim <= 0){
			sprite_index = spr_dive;
			image_index = 0;
			spr_shadow = mskNone;
			sound_play(sndOasisBossMelee);
		}
		
		 // Bubble Trail:
		else if(swim > 80){
			call(scr.projectile_create, x, y, "BubbleBomb", direction + orandom(10), 4);
			sound_play_hit(sndBouncerBounce, 0.3);
		}
	}
	
#define CoastBoss_death
	 // Coast Entrance:
	GameCont.killenemies = true;
	call(scr.area_set, "coast", 0, GameCont.loops);
	instance_create(x, y, Portal);
	
	 // Boss Win Music:
	with(MusCont) alarm_set(1, 1);
	
	
#define CowSkull_create(_x, _y)
	with(instance_create(_x, _y, BigSkull)){
		 // Visual:
		spr_idle = spr.CowSkullIdle;
		spr_hurt = spr.CowSkullHurt;
		spr_dead = spr.CowSkullDead;
		sprite_index = spr_idle;
		
		 // Fly:
		var	_l = random(16),
			_d = 90 + orandom(110);
			
		with(call(scr.obj_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "FlySpin")){
			depth = other.depth;
		}
		
		return self;
	}
	
	
#define FlySpin_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.FlySpin;
		image_index = irandom(image_number - 1);
		image_speed = 0.4 + random(0.1);
		image_xscale = choose(-1, 1);
		depth = -9;
		
		 // Vars:
		target = noone;
		target_x = 0;
		target_y = 0;
		
		return self;
	}
	
#define FlySpin_end_step
	if(target != noone){
		if(instance_exists(target)){
			x = target.x + target_x;
			y = target.y + target_y;
		}
		else instance_destroy();
	}
	
	
#define ScorpionRock_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle     = spr.ScorpionRock;
		spr_hurt     = spr.ScorpionRockHurt;
		spr_dead     = spr.ScorpionRockDead;
		spr_shadow   = shd32;
		spr_shadow_y = -3;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = sndPillarBreak;
		
		 // Vars:
		maxhealth = 32;
		size      = 1;
		team      = 1;
		friendly  = false;
		
		return self;
	}
	
#define ScorpionRock_step
	if(sprite_index == spr_idle){
		 // Animate Slower:
		var	_img = image_index - image_speed,
			_fac = 0;
			
		if(_img < 1){
			_fac = 0.975;
		}
		else if((_img >= 2 && _img < 3) || (_img >= 4 && _img < 5)){
			_fac = 0.9375;
		}
		
		image_index -= image_speed_raw * _fac;
		
		 // Friendify:
		if(image_index < 1){
			if(friendly == false && !instance_exists(enemy)){
				friendly = true;
			}
			if(friendly && spr_idle == spr.ScorpionRock){
				spr_idle = spr.ScorpionRockAlly;
				spr_hurt = spr.ScorpionRockAllyHurt;
				sprite_index = spr_idle;
				image_index = 0;
			}
		}
	}
	
#define ScorpionRock_death
	 // Debris:
	repeat(3 + irandom(3)){
		with(instance_create(x, y, Debris)){
			motion_set(random(360), 4 + random(4));
		}
	}
	
	 // Homeowner:
	if(friendly){
		call(scr.pet_create, x, y, "Scorpion");
	}
	else{
		call(scr.obj_create, x, y, "BabyScorpion");
	}
	
	 // Light Snack:
	repeat(3) if(chance(1, 2)){
		instance_create(x, y, Maggot);
	}
	
	 // Play Date:
	if(chance(1, 100)){
		call(scr.obj_create, x, y, "Spiderling");
	}
	
	 // Possessions:
	pickup_drop(60, 10, 0);
	
	
#define SilverScorpion_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.SilverScorpionIdle;
		spr_walk     = spr.SilverScorpionWalk;
		spr_hurt     = spr.SilverScorpionHurt;
		spr_dead     = spr.SilverScorpionDead;
		spr_fire     = spr.SilverScorpionFire;
		sprite_index = spr_idle;
		spr_shadow   = shd48;
		hitid        = [spr_idle, "SILVER SCORPION"];
		depth        = -2;
		
		 // Sounds:
		snd_hurt = sndSawedOffShotgun;
		snd_dead = sndExploGuardianDeadCharge;
		snd_mele = sndGoldScorpionMelee;
		
		 // Vars:
		mask_index  = mskScorpion;
		maxhealth   = 70;
		raddrop     = 20;
		size        = 3;
		meleedamage = 5;
		walk        = 0;
		walkspeed   = 1.2;
		maxspeed    = 2.5;
		gunangle    = random(360);
		ammo        = 0;
		//flak        = noone;
		//flak_offset = 5;
		
		 // Alarms:
		alarm1 = 90;
		alarm2 = -1;
		
		return self;
	}
	
#define SilverScorpion_step
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
	
	/*
	 // Flak Target Tracking:
	if(instance_exists(flak)){
		if(flak.time < flak.time_max){
			 // Retarget:
			if(instance_exists(target) && target_visible){
				enemy_look(angle_lerp_ct(gunangle, target_direction, 1/3));
			}
			
			 // Reposition:
			var _l = flak_offset,
				_d = gunangle;
				
			with(flak){
				x = other.x + lengthdir_x(_l, _d);
				y = other.y + lengthdir_y(_l, _d);
				xprevious   = x;
				yprevious   = y;
				direction   = _d;
				image_angle = _d;
			}
			
			 // Slow:
			x = lerp(x, xprevious, 1/3);
			y = lerp(y, yprevious, 1/3);
		}
		else{
			 // Freed:
			flak = noone;
		}
	}
	*/
	
	 // Animate:
	if(sprite_index != spr_fire /*|| (!instance_exists(flak) && anim_end)*/){
		sprite_index = enemy_sprite;
	}
	
#define SilverScorpion_alrm1
	alarm1 = irandom_range(60, 90);
	
	 // Movin'
	enemy_walk(
		random(360),
		random_range(20, 30)
	);
	
	if(ammo <= 0){
		 // Aggroed:
		if(enemy_target(x, y) && (my_health < maxhealth || target_visible)){
			enemy_look(target_direction);
			direction = gunangle + orandom(40);
			
			 // Attack:
			if(!chance(target_distance - 128, 192)){
				alarm1 = irandom_range(75, 120);
				alarm2 = 1;
				/*
				sprite_index = spr_fire;
				flak = call(scr.projectile_create, x, y, "SilverScorpionFlak", gunangle, 8);
				*/
			}
		}
		
		 // Wander:
		else enemy_look(direction);
	}
	
#define SilverScorpion_alrm2
	 // Start Firing:
	if(ammo <= 0){
		ammo = 10;
		
		 // Flak:
		with(call(scr.projectile_create, x, y, "VenomFlak", gunangle, 3)){
			friction      = 0.2;
			image_xscale *= 1.25;
			image_yscale *= 1.25;
			charge_time   = other.ammo * 3;
			alarm0        = charge_time;
		}
		
		 // Sound:
		call(scr.sound_play_at, x, y, sndGoldScorpionFire,  1.2 + random(0.2), 6);
		call(scr.sound_play_at, x, y, sndCrownGuardianFire, 0.5 + random(0.2), 4);
		call(scr.sound_play_at, x, y, sndGuardianAppear,    0.5 + random(0.2), 3.5);
	}
	
	 // Fire:
	if(ammo > 0){
		if(--ammo > 0){
			alarm2 = 3;
		}
		
		 // Pew pew:
		call(scr.projectile_create,
			x,
			y,
			EnemyBullet2,
			gunangle + (random_range(20, 140) * (((ammo % 2) < 1) ? -1 : 1)),
			3
		);
		
		 // Sound:
		sound_play_hit(sndScorpionFire, 0.2);
		
		 // Animate:
		if(ammo > 0 && sprite_index != spr_hurt){
			sprite_index = spr_fire;
		}
		else sprite_index = enemy_sprite;
	}
	
#define SilverScorpion_death
	 // Blammo:
	instance_create(x, y, PortalClear);
	call(scr.sound_play_at, x, y, sndSuperSlugger, 1.3 + random(0.2), 1.5);
	view_shake_at(x, y, 30);
	
	 // Splat:
	var _ang = direction + 45;
	for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 4)){
		call(scr.fx, x, y, [_dir, 9], AcidStreak);
	}
	
	 // Venom:
	with(call(scr.projectile_create, x, y, "VenomFlak", direction)){
		charging = false;
		repeat(12){
			call(scr.projectile_create, x, y, EnemyBullet2,  random(360), random_range(3, 5));
			call(scr.projectile_create, x, y, "VenomPellet", random(360), random_range(8, 12));
		}
	}
	/*
	var _num = 7;
	for(var _ang = 0; _ang < 360; _ang += 360 / _num){
		call(scr.projectile_create, x, y, "SilverScorpionDevastator", direction + _ang, random_range(5, 6));
	}
	*/
	
	 // Pickups:
	pickup_drop(0, 25, 0);
	
	
#define SilverScorpionDevastator_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Vars:
		mask_index = mskEnemyBullet1;
		damage     = 0;
		force      = 0;
		typ        = 2;
		
		return self;
	}
	
#define SilverScorpionDevastator_step
	if(current_frame_active){
		call(scr.projectile_create,
			x + orandom(9), 
			y + orandom(9), 
			choose("VenomPellet", "VenomPelletBack"), 
			direction, 
			speed + random(1)
		);
	}
	
#define SilverScorpionDevastator_hit
	 // No Damage:
	instance_destroy();
	
#define SilverScorpionDevastator_destroy
	repeat(7){
		call(scr.projectile_create, x, y, "VenomPellet", random(360), random_range(3, 7));
	}
	
	
#define SilverScorpionFlak_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.SilverScorpionFlak;
		image_speed  = 0.4;
		depth        = -4;
		ntte_bloom   = 0.2;
		
		 // Vars:
		mask_index = mskBullet1;
		damage     = 2;
		force      = 12;
		typ        = 2;
		time       = 0;
		time_max   = 20;
		//wave       = random(360);
		
		return self;
	}
	
#define SilverScorpionFlak_step
	// wave += current_time_scale;
	
	if(time < time_max){
		time += current_time_scale;
		
		
		if(time >= time_max){
			time = time_max;
			
			move_contact_solid(direction, speed_raw / 2);
			
			typ = 1;
		}
		
		var _scale = (time / time_max);
		image_xscale = _scale;
		image_yscale = _scale;
		
		if(current_frame_active){
			var _back = chance(1, 2);
			with(call(scr.projectile_create,
				x, 
				y, 
				(_back ? "VenomPelletBack" : "VenomPellet"), 
				random(360), 
				4 + (4 * _scale)
			)){
				if(_back){
					speed *= 4/5;
				}
			}
		}
		
		x -= hspeed_raw;
		y -= vspeed_raw;
	}
	else{
		
		 // Trailing:
		if(current_frame_active){
			call(scr.projectile_create,
				x + orandom(11), 
				y + orandom(11), 
				choose("VenomPellet", "VenomPelletBack"), 
				direction, 
				speed + random(1)
			);
		}
		 
		/*
		if(chance_ct(4, 5)){
			for(var i = -1; i <= 1; i += 2){
				var _l = sin(wave / 2) * 16,
					_d = direction + (90 * i);
					
				with(call(scr.projectile_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "VenomPellet", direction, (speed * 1/3))){
					if(i < 1){
						depth++;
						spr_idle = spr.VenomPelletBack;
						spr_fade = spr.VenomPelletBackDisappear;
						sprite_index = spr_idle;
					}
				}
			}
		}
		*/
	}
	
#define SilverScorpionFlak_wall
	if(time >= time_max){
		instance_destroy();
	}
	
#define SilverScorpionFlak_hit
	if(projectile_canhit_np(other) && (instance_is(other, Player) || current_frame_active)){
		projectile_hit_np(other, damage, force, 40);
	}
	
#define SilverScorpionFlak_destroy
	 // Bullets:
	var _num = 7;
	for(var _ang = 0; _ang < 360; _ang += 360 / _num){
		call(scr.projectile_create, x, y, "SilverScorpionDevastator", direction + _ang, random_range(5, 6));
	}
	repeat(12){
		call(scr.projectile_create, x, y, "VenomPellet", random(360), random_range(4, 8));
	}
	
	 // Effects:
	view_shake_at(x, y, 20);
	call(scr.sound_play_at, x, y, sndToxicBoltGas);
	instance_create(x, y, PortalClear);
	
	
#define VenomBlast_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.VenomFlak;
		image_speed  = 0.4;
		depth        = -3;
		
		 // Vars:
		mask_index   = mskSuperFlakBullet;
		image_xscale = 0.2;
		image_yscale = 0.2;
		damage       = 2;
		force        = 2;
		charge       = true;
		charge_goal  = 1;
		charge_speed = 1/30;
		
		return self;
	}
	
#define VenomBlast_step
	 // Charge:
	if(charge){
		if(
			image_xscale < charge_goal	&&
			image_yscale < charge_goal	&&
			instance_exists(creator)	&&
			creator.visible
		){
			image_xscale += charge_speed * current_time_scale;
			image_yscale += charge_speed * current_time_scale;
			
			 // Effects:
			call(scr.sound_play_at, x, y, sndScorpionFire, 0.5 + (1.5 * (image_xscale / charge_goal)), 4);
			if(chance_ct(1, 4)){
				var	_l = random(sprite_width),
					_d = random(360);
					
				with(call(scr.fx, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), [_d + 180, 2], AcidStreak)){
					image_xscale = 0.8;
					image_yscale = 0.8;
					
					 // Variance:
					if(chance(1, 2)){
						sprite_index = spr.AcidPuff;
						depth = other.depth - 1;
						image_angle += 180;
					}
					else depth = other.depth + 1;
					
					 // Follow Creator:
					hspeed += other.creator.hspeed;
					vspeed += other.creator.vspeed;
				}
			}
		}
		else charge = false;
	}
	
	 // Release:
	else{
		image_xscale -= (charge_goal / 7) * current_time_scale;
		image_yscale -= (charge_goal / 7) * current_time_scale;
		if(image_xscale <= 0.2) instance_destroy();
	}

#define VenomBlast_end_step
	 // Follow Papa:
	if(instance_exists(creator)){
		x = creator.x + lengthdir_x(10, direction);
		y = creator.y + lengthdir_y( 6, direction);
		xprevious = x;
		yprevious = y;
	}

#define VenomBlast_hit
	if(projectile_canhit_melee(other)){
		projectile_hit_push(other, damage, force);
		sleep(20);
	}

#define VenomBlast_wall
	//

#define VenomBlast_destroy
	var	_dir = direction,
		_lvl = GameCont.level;
		
	sleep(10);
	view_shake_max_at(x, y, 10 + (2 * _lvl));
	
	 // Fire:
	for(var i = -1; i <= 1; i++){
		repeat(irandom_range(4, 8) + (2 * (i == 0)) + (2 * _lvl)){
			 // Main Shot:
			if(i == 0){
				with(call(scr.projectile_create,
					x,
					y,
					EnemyBullet2,
					_dir + orandom(12),
					8 + random(6)
				)){
					force = 12;
				}
			}
			
			 // Side Shots:
			else call(scr.projectile_create,
				x,
				y,
				"VenomPellet",
				_dir + (45 * i) + orandom(16) + (i * random(6 * _lvl)),
				4 + random(10)
			);
		}
		
		 // Effects:
		with(call(scr.fx, x, y, [_dir + (45 * i), 4], AcidStreak)){
			image_xscale = 1.6;
			image_yscale = 1.0;
		}
	}
	
	 // Sounds:
	call(scr.sound_play_at, x, y, sndFlyFire,          1.0 + random(0.4), 2.5);
	call(scr.sound_play_at, x, y, sndGoldScorpionFire, 1.6 + random(0.4), 2.5);
	
	
#define VenomFlak_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.VenomFlak;
		image_speed  = 0.4;
		
		 // Vars:
		friction    = 0.4;
		damage      = 6;
		force       = 6;
		typ         = 2;
		creator     = noone;
		charging    = true;
		charge_time = max(1, 15 / (1 + (0.5 * GameCont.loops)));
		explo_time  = 40;
		
		 // Alarms:
		alarm0 = charge_time;
		
		return self;
	}
	
#define VenomFlak_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Charging Up:
	if(charging){
		var _angry = 1 + (0.5 * GameCont.loops);
		if(array_find_index(obj.BatBoss, creator) >= 0 && array_length(instances_matching_ne(obj.CatBoss, "id"))){
			_angry--;
		}
		speed += (friction + (0.3 * _angry)) * current_time_scale;
		
		 // Follow Creator:
		if(instance_exists(creator)){
			var	_dis = min(20, speed * 1.5),
				_dir = direction;
				
			xstart = creator.x + lengthdir_x(_dis, _dir);
			ystart = creator.y + lengthdir_y(_dis, _dir);
			
			 // Kick:
			if("wkick" in creator && creator.wkick < 8){
				creator.wkick += random_range(1, 2) * current_time_scale;
			}
		}
		
		 // Stay:
		x = xstart - hspeed_raw;
		y = ystart - vspeed_raw;
		xprevious = x;
		yprevious = y;
		
		 // Effects:
		if(chance_ct(1, 4)){
			var f = 0.6;
			with(instance_create(x + (hspeed * f) + orandom(4), y + (vspeed * f) + orandom(4), AcidStreak)){
				sprite_index = spr.AcidPuff;
				image_angle = other.direction + orandom(60);
				depth = -2;
				
				if(instance_exists(other.creator)){
					x += other.creator.hspeed;
					y += other.creator.vspeed;
				}
			}
		}
	}
	
	 // Smoke Trail:
	else if(chance_ct(1, 3)){
		with(instance_create(x + orandom(2), y + orandom(2), Smoke)){
			depth = other.depth + 1;
		}
	}
	
	 // Effects:
	if(chance_ct(1, 3)){
		with(instance_create(x + orandom(6), y + 16 + orandom(6), RecycleGland)){
			sprite_index = sprDrip; // Drip object is noisy :jwpensive:
			depth = 0;
		}
	}
	
#define VenomFlak_hit
	if(charging ? projectile_canhit_melee(other) : projectile_canhit_np(other)){
		projectile_hit_np(other, damage, force, 40);
		if(!charging){
			instance_destroy();
		}
	}
	
#define VenomFlak_draw
	if(charging){
		var _scale = 0.25 + (1 - (alarm0 / charge_time)) + random(0.2);
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * _scale, image_yscale * _scale, image_angle, image_blend, image_alpha);
	}
	else draw_self();
	
#define VenomFlak_alrm0
	if(charging){
		charging = false;
		
		alarm0 = explo_time;
		typ    = 1;
		
		with(creator){
			 // Fire:
			motion_add(gunangle + 180, maxspeed);
			
			 // Effects:
			wkick = min(wkick + 9, 16);
			sound_play_pitchvol(sndFlakCannon,        0.8,               0.4);
			sound_play_pitchvol(sndCrystalRicochet,   1.4 + random(0.4), 0.8);
			sound_play_pitchvol(sndLightningRifleUpg, 0.8,               0.4);
			
			repeat(3 + irandom(2)){
				call(scr.fx, [x, 6], [y, 6], [gunangle + orandom(2), 4 + random(4)], Smoke);
			}
		}
	}
	
	 // Explode:
	else instance_destroy();
	
#define VenomFlak_wall
	if(charging){
		 // Destroy:
		with(other){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
	}
	else if(speed > 1){
		 // Bounce:
		move_bounce_solid(true);
		speed = min(speed, 8);
		
		 // Sounds:
		call(scr.sound_play_at, x, y, sndShotgunHitWall, 1.2, 1.5);
		call(scr.sound_play_at, x, y, sndFrogEggHurt,    0.7, 0.3);
		
		 // Effects:
		with(call(scr.fx, x, y, [direction, 3], AcidStreak)){
			image_yscale *= 2; // fat splat
		}
	}
	
#define VenomFlak_destroy
	 // Clear Walls:
	instance_create(x, y, PortalClear);
	
	 // Pickup:
	if(!instance_is(creator, Player)){
		pickup_drop(50, 0);
	}
	
	 // Effects:
	for(var _ang = 0; _ang < 360; _ang += (360 / 20)){
		call(scr.fx, x, y, [_ang, 4 + random(4)], Smoke);
	}
	view_shake_at(x, y, 20);
	sleep(10);
	
	 // Sound:
	sound_play_pitchvol(sndHeavyMachinegun, 1,                 0.8);
	sound_play_pitchvol(sndSnowTankShoot,   1.4,               0.7);
	sound_play_pitchvol(sndFrogEggHurt,     0.4 + random(0.2), 3.5);
	
	 // Projectiles:
	for(var _ang = 0; _ang < 360; _ang += (360 / 12)){
		 // Venom Lines:
		if((_ang % 90) == 0){
			for(var i = 0; i <= 4; i++){
				with(call(scr.projectile_create,
					x,
					y,
					"VenomPellet",
					direction + _ang + orandom(2 + i),
					2 * i
				)){
					move_contact_solid(direction, 4 + (4 * i));
					
					 // Effects:
					call(scr.fx, x, y, [direction + orandom(4), speed * 0.8], AcidStreak);
				}
			}
		}
		
		 // Individual:
		else with(call(scr.projectile_create,
			x,
			y,
			"VenomPellet",
			direction + _ang + orandom(2),
			5.8 + random(0.4)
		)){
			move_contact_solid(direction, 6);
		}
	}
	
	
#define VenomPellet_create(_x, _y)
	/*
		A piercing shell variant of venom projectiles
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		spr_spwn     = spr.VenomPelletAppear;
		spr_idle     = spr.VenomPellet;
		spr_fade     = spr.VenomPelletDisappear;
		spr_dead     = sprScorpionBulletHit;
		sprite_index = spr_idle;
		image_speed  = 0.4;
		depth        = -3;
		ntte_bloom   = 0.2;
		
		 // Vars:
		mask_index = mskEnemyBullet1;
		friction   = 0.75;
		damage     = 2;
		force      = 4;
		typ        = 2;
		minspeed   = 4;
		hit_list   = [];
		wallbounce = 0;
		
		return self;
	}
	
#define VenomPellet_step
	 // Disappear:
	if(speed < minspeed && sprite_index != spr_fade){
		sprite_index = spr_fade;
		image_index  = 0;
	}
	
#define VenomPellet_anim
	if(instance_exists(self)){
		if(sprite_index == spr_spwn){
			image_speed = 0.4;
			sprite_index = spr_idle;
		}
		
		 // Goodbye:
		else if(sprite_index == spr_fade){
			instance_destroy();
		}
	}
	
#define VenomPellet_hit
	var _firstHit = (array_find_index(hit_list, other) < 0);
	if(projectile_canhit_melee(other) || (_firstHit && !instance_is(other, Player))){
		projectile_hit_np(other, damage, force, 10);
		
		if(_firstHit){
			array_push(hit_list, other);
			
			 // Catch on Enemy / Pseudo Freeze Frames:
			if(instance_exists(other) && other.my_health > 0){
				x     -= hspeed;
				y     -= vspeed;
				speed -= friction;
			}
		}
		
		 // Effects:
		with(instance_create(x, y, ScorpionBulletHit)){
			sprite_index = other.spr_dead;
		}
	}
	
#define VenomPellet_wall
	 // Dust:
	instance_create(x, y, Dust);
	
	 // Bounce:
	if(wallbounce > 0 && speed >= minspeed){
		sound_play_hit(sndShotgunHitWall, 0.2);
		move_bounce_solid(true);
		image_angle = direction;
		speed       = (speed * 0.8) + wallbounce;
		wallbounce *= 0.95;
	}
	
	 // Break:
	else{
		sound_play_hit(sndHitWall, 0.2);
		instance_destroy()
	}
	
#define VenomPellet_destroy
	if(sprite_index != spr_fade){
		with(instance_create(x, y, ScorpionBulletHit)){
			sprite_index = other.spr_dead;
		}
	}
	
	
#define VenomPelletBack_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "VenomPellet")){
		 // Visual:
		spr_idle = spr.VenomPelletBack;
		spr_fade = spr.VenomPelletBackDisappear;
		sprite_index = spr_idle;
		depth++;
		
		return self;
	}
	
	
#define WantBigMaggot_create(_x, _y)
	with(instance_create(_x, _y, BigMaggot)){
		 // Burrow:
		var _vars = call(scr.variable_instance_get_list, self);
		instance_change(BigMaggotBurrow, false);
		call(scr.variable_instance_set_list, self, _vars); // broo dont sandbox my variables i hate it
		sprite_index = sprBigMaggotBurrow;
		visible      = false;
		alarm0       = -1;
		
		 // Vars:
		unburrow_check_timer = random_range(150, 450);
		
		return self;
	}
	
#define WantBigMaggot_step
	if(unburrow_check_timer > 0){
		unburrow_check_timer -= current_time_scale;
	}
	else{
		unburrow_check_timer = random_range(120, 300);
		
		 // Unburrow:
		var _player = instance_nearest(x, y, Player);
		if((instance_exists(_player) && point_distance(x, y, _player.x, _player.y) < 160) || !instance_exists(enemy)){
			sound_play_hit_big(sndBigMaggotUnburrowSand, 0.2);
			sprite_index = sprBigMaggotAppear;
			image_index  = 0;
			visible      = true;
			alarm1       = 12;
		}
	}
	
	 // Stay Burrowed:
	if(!visible){
		sprite_index = sprBigMaggotBurrow;
		image_index  = 0;
	}
	
	 // Unburrowing:
	else if(anim_end){
		with(instance_create(x, y, BigMaggot)){
			x = xstart;
			y = ystart;
			right = other.right;
		}
		instance_delete(self);
	}
	
	
/// GENERAL
#define ntte_setup_WepPickup(_inst)
	 // Separate Bones:
	with(_inst){
		while(
			is_object(wep)
			&& call(scr.wep_raw, wep) == "crabbone"
			&& lq_defget(wep, "ammo", 1) > 1
		){
			wep.ammo--;
			var _ammoWep = lq_defget(wep, "ammo_wep", wep_none);
			if(_ammoWep != wep_none){
				with(instance_create(x, y, WepPickup)){
					wep   = _ammoWep;
					curse = other.curse;
				}
				wep.ammo_wep = wep_none;
			}
		}
	}
	
#define ntte_begin_step
	 // Baby Scorpion Spawn:
	if(instance_exists(MaggotSpawn)){
		var _inst = instances_matching_gt(instances_matching_le(MaggotSpawn, "my_health", 0), "babyscorp_drop", 0);
		if(array_length(_inst)){
			with(_inst){
				repeat(babyscorp_drop){
					call(scr.obj_create, x, y, "BabyScorpion");
				}
			}
		}
	}
	
	 // Hiker Backpack:
	if(array_length(obj.BanditHiker)){
		var _inst = instances_matching_le(obj.BanditHiker, "my_health", 0);
		if(array_length(_inst)){
			with(_inst){
				speed /= 2;
				with(call(scr.obj_create, x, y, "BackpackPickup")){
					target = call(scr.chest_create, x, y, "Backpack");
					direction = other.direction + orandom(10);
					with(self){
						event_perform(ev_step, ev_step_end);
					}
				}
				repeat(5) call(scr.fx, x, y, 4, Dust);
				sound_play_pitchvol(sndMenuASkin, 1.2, 0.6);
			}
		}
	}
	
	 // Big Fish Train Pickups:
	if(instance_exists(BoneFish) && array_length(obj.CoastBoss)){
		var _inst = instances_matching_le(BoneFish, "my_health", 0);
		if(array_length(_inst)){
			with(_inst){
				if("creator" in self && array_find_index(obj.CoastBoss, creator) >= 0){
					pickup_drop(10, 0);
				}
			}
		}
	}
	
#define ntte_end_step
	 // Skeletons Drop Bones:
	if(instance_exists(BonePile) || instance_exists(BonePileNight) || instance_exists(BigSkull)){
		var _inst = instances_matching_le([BonePile, BonePileNight, BigSkull], "my_health", 0);
		if(array_length(_inst)){
			with(_inst){
				 // Enter the bone zone:
				with(instance_create(x, y, WepPickup)){
					wep = "crabbone";
					motion_add(random(360), 3);
				}
				
				 // Effects:
				repeat(2){
					call(scr.fx, x, y, 3, Dust);
				}
			}
		}
	}
	
#define ntte_draw_bloom
	 // Silver Scorpion Pet Attack:
	if(array_length(obj.VenomBlast)){
		with(instances_matching_ne(obj.VenomBlast, "id")){
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * (charge ? (image_xscale / charge_goal) : 1) * 0.2);
		}
	}
	
	 // Silver Scorpion Flak:
	if(array_length(obj.VenomFlak)){
		var	_scale = 2,
			_alpha = 0.2;
			
		with(instances_matching_ne(obj.VenomFlak, "id")){
			image_xscale *= _scale;
			image_yscale *= _scale;
			image_alpha  *= _alpha;
			event_perform(ev_draw, 0);
			image_xscale /= _scale;
			image_yscale /= _scale;
			image_alpha  /= _alpha;
		}
	}
	
#define ntte_draw_shadows
	 // SharkBoss Loop Train:
	if(array_length(obj.CoastBoss)){
		with(instances_matching_ne(obj.CoastBoss, "id")){
			var _fishIndex = 0;
			with(fish_train){
				if(instance_exists(self) && other.fish_swim[_fishIndex]){
					draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
				}
				_fishIndex++;
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