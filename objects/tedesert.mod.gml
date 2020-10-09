#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;

#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

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
		
		return id;
	}

#define BabyScorpion_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
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
		if(instance_seen(x, y, target)){
			scrAim(point_direction(x, y, target.x, target.y));
		}
		scrWalk(gunangle + orandom(10), alarm1 + 3);
		
		 // Golden venom shot:
		if(gold){
			var o = random_range(20, 60);
			for(var a = -o; a <= o; a += o){
				projectile_create(
					x,
					y,
					"VenomPellet",
					gunangle + a,
					((a == 0) ? 10 : 6) + random(2)
				);
			}
		}
		
		 // Normal venom shot:
		else projectile_create(
			x,
			y,
			"VenomPellet",
			gunangle + orandom(20),
			7 + random(4)
		);
		
		 // Effects:
		sound_play_pitch(sndScorpionFire, 1.4 + random(0.2));
		if(chance(1, 4)){
			with(scrFX(x, y, [gunangle + orandom(24), random_range(2, 6)], AcidStreak)){
				image_angle = direction;
			}
		}
		
		 // End:
		if(ammo <= 0){
			alarm1 = 20 + irandom(20);
			sprite_index = spr_idle;
			sound_play_pitchvol(sndSalamanderEndFire, 1.6, 0.4);
		}
	}
	
	 // Normal AI:
	else if(instance_seen(x, y, target)){
		scrAim(point_direction(x, y, target.x + target.hspeed, target.y + target.vspeed));
		
		 // Start attack:
		if(instance_near(x, y, target, [32, 96]) && chance(2, 3)){
			alarm1 = 1;
			ammo = 6 + irandom(2);
			sound_play_pitch(snd_fire, 1.6);
		}
		
		 // Move Away From Target:
		else if(instance_near(x, y, target, 32)){
			alarm1 = 20 + irandom(30);
			scrWalk(gunangle + 180 + orandom(40), [10, 20]);
			scrAim(direction);
		}
		
		 // Move Towards Target:
		else{
			alarm1 = 30 + irandom(20);
			scrWalk(gunangle + orandom(40), [20, 35]);
		}
	}
	
	 // Wander:
	else{
		scrWalk(random(360), 30);
		scrAim(direction);
	}

#define BabyScorpion_hurt(_hitdmg, _hitvel, _hitdir)
	my_health -= _hitdmg;			// Damage
	motion_add(_hitdir, _hitvel);	// Knockback
	nexthurt = current_frame + 6;	// I-Frames

	 // Pitched Sound:
	var v = clamp(50 / (distance_to_object(Player) + 1), 0, 2);
	sound_play_pitchvol(snd_hurt, 1.2 + random(0.3), v);

	 // Hurt Sprite:
	sprite_index = spr_hurt;
	image_index = 0;

#define BabyScorpion_death
	pickup_drop(16, 0);
	
	 // Venom Explosion:
	if(gold){
		repeat(4 + irandom(4)) projectile_create(x, y, "VenomPellet", random(360), 8 + random(4));
		repeat(8 + irandom(8)) projectile_create(x, y, "VenomPellet", random(360), 4 + random(4));
	}
	
	 // Effects:
	var l = 6;
	repeat(gold ? 3 : 2){
		var d = direction + orandom(60);
		with(scrFX(x + lengthdir_x(l, d), y + lengthdir_y(l, d), [d, 4 + random(4)], AcidStreak)){
			image_angle = direction;
		}
	}
	sound_play_pitchvol(snd_dead, 1.5 + random(0.3), 1.3);
	snd_dead = -1;


#define BabyScorpionGold_create(_x, _y)
	with(obj_create(_x, _y, "BabyScorpion")){
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
		
		return id;
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
		
		return id;
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
		maxhealth = 16;
		my_health = maxhealth;
		path = [];
		path_delay = 0;
		can_path = true;
		
		return id;
	}
	
#define BanditHiker_step
	 // Aggro++
	var d = ceil(current_time_scale);
	if(alarm1 > d && current_frame_active) alarm1 -= d;
	
	 // Path to Player:
	if(path_delay > 0) path_delay -= current_time_scale;
	if(walk > 0 && instance_exists(target)){
		if(!instance_seen(x, y, target)){
			var	_tx = target.x,
				_ty = target.y,
				_pathDir = path_direction(path, x, y, Wall);
				
			 // Follow Path:
			if(_pathDir != null && path_reaches(path, _tx, _ty, Wall)){
				can_path = true;
				direction = angle_lerp(direction, _pathDir, 0.25 * current_time_scale);
			}
			
			 // Create Path:
			else if(can_path && path_delay <= 0){
				can_path = false;
				path_delay = 60;
				path = path_create(x, y, _tx, _ty, Wall);
				path = path_shrink(path, Wall, 4);
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
		my_health   = 8;
		team        = 1;
		size        = 1;
		target      = noone;
		target_mask = mskNone;
		
		 // Bandits:
		with(obj_create(x, y, "BanditCamper")){
			instance_budge(Wall, -1);
		}
		
		return id;
	}
	
#define BanditTent_step
	 // Holding Chest:
	with(target){
		x = other.x;
		y = other.y + 4;
		if(mask_index != mskNone){
			other.target_mask = mask_index;
			mask_index = mskNone;
		}
	}
	
	 // Propped Up:
	if(spr_idle == spr.BanditTentWallIdle){
		if(!collision_circle(x - (8 * image_xscale), y, 1, Wall, false, false)){
			my_health = 0;
		}
	}
	
#define BanditTent_death
	 // Release Chest:
	if(target_mask != mskNone){
		with(target) mask_index = other.target_mask;
	}
	
	 // FX:
	var _ang = random(360);
	for(var d = _ang; d < _ang + 360; d += (360 / 3)){
		scrFX(x, y, [d, 3], Dust);
	}


#define BigCactus_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_shadow = shd32;
		spr_shadow_y = 4;
		depth = -1;
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
		
		 // Spawn Enemies:
		instance_create(x, y, PortalClear);
		if(!instance_near(x, y, Player, 96) && place_meeting(x, y, Floor)){
			repeat(choose(2, 3)){
				obj_create(x, y, ((GameCont.area == "coast") ? "Gull" : "BabyScorpion"));
			}
		}
		
		return id;
	}

#define BigCactus_death
	 // Dust-o:
	var _ang = random(360);
	for(var d = _ang; d < _ang + 360; d += random_range(60, 180)){
		with(scrFX(x, y, [d, random_range(4, 5)], Dust)){
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
			with(obj_create(x, y, "FlySpin")){
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
		
		return id;
	}

#define BigMaggotSpawn_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Stay Still:
	x = xstart;
	y = ystart;
	speed = 0;
	
	 // Idle Sound:
	if(distance_to_object(Player) < 64){
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
			var a = ((loop_snd == -1) ? 0.2 : 0.3);
			image_index += random(image_speed_raw * a) - image_speed_raw;
		}
	}
	
	 // Clear Walls:
	if(place_meeting(x, y, Wall)){
		with(instances_meeting(x, y, Wall)){
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
				l = (24 + orandom(2)) * image_xscale,
				d = (_loop ? random(360) : random_range(200, 340));
				
			with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l * 0.5, d), (_loop ? FiredMaggot : Maggot))){
				x = xstart;
				y = ystart;
				kills = 1; // FiredMaggot Fix
				creator = other;
				
				 // Effects:
				for(var i = 0; i <= (4 * _loop); i += 2){
					with(instance_create(x, y, DustOLD)){
						motion_add(d + orandom(10), 2 + i);
						depth = other.depth - 1;
						image_blend = make_color_rgb(170, 70, 60);
						image_speed /= max(1, (i / 2.5));
					}
				}
				
				 // Sounds:
				var s = audio_play_sound((_loop ? sndFlyFire : sndHitFlesh), 0, false);
				audio_sound_gain(s, min(0.9, random_range(24, 32) / (distance_to_object(Player) + 1)), 0);
				audio_sound_pitch(s, 1.2 + random(0.2));
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
			|| (chance(1, 3) && instance_seen(x, y, target))
		){
			my_health -= 2;
		}
	}

#define BigMaggotSpawn_hurt(_hitdmg, _hitvel, _hitdir)
	if(my_health > 1){
		enemy_hurt(_hitdmg, _hitvel, _hitdir);
		my_health = max(1, my_health);
	}
	else if(alarm0 > 2) alarm0 = 2;

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
				with(alert_create(self, spr.FlyAlert)){
					alarm0 = 75;
					blink = 20;
				}
			}
		}
	}
	
	 // Flies:
	repeat(irandom_range(3, 6)){
		obj_create(x + orandom(32), y + orandom(16), "FlySpin");
	}
	
	 // Pickups:
 	pickup_drop(50, 35, 0);
	pickup_drop(50, 35, 1);
	pickup_drop(100, 0);
	pickup_drop(100, 0);
	
	/*
	if(chance(1, 10)){
		with(chest_create(x, y, BigWeaponChest, false)){
			motion_add(random(360), 2);
			repeat(12) scrFX(x, y, random_range(4, 6), Dust);
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
		hitid        = [sprite_index, "BONE"];
		
		 // Vars:
		mask_index = mskFlakBullet;
		friction   = 1;
		damage     = 34;
		force      = 1;
		typ        = 1;
		curse      = false;
		creator    = noone;
		rotspeed   = 1/3 * choose(-1, 1);
		broken     = false;
		
		 // Annoying Fix:
		if(place_meeting(x, y, PortalShock)){
			Bone_destroy();
		}
		
		return id;
	}
	
#define Bone_step
	 // Spin:
	image_angle += speed_raw * rotspeed;
	
	 // Into Portal:
	if(place_meeting(x, y, Portal)){
		if(speed > 0){
			sound_play_pitchvol(sndMutant14Turn, 0.6 + random(0.2), 0.8);
			repeat(3) instance_create(x, y, Smoke);
		}
		instance_destroy();
	}
	
	 // Turn Back Into Weapon:
	else if(speed <= 0 || place_meeting(x + hspeed_raw, y + vspeed_raw, PortalShock)){
		 // Don't Get Stuck on Wall:
		mask_index = mskWepPickup;
		if(place_meeting(x, y, Wall) && instance_budge(Wall, -1)){
			instance_create(x, y, Dust);
		}
		
		 // Goodbye:
		instance_destroy();
	}
	
#define Bone_hit
	 // Secret:
	if(other.object_index = ScrapBoss){
		with(other){
			var c = charm_instance(self, true);
			c.time = 300;
		}
		sound_play(sndBigDogTaunt);
		instance_delete(id);
		exit;
	}

	projectile_hit_push(other, damage, speed * force);
	if(!instance_exists(self)) exit;

	 // Sound:
	sound_play_hit_ext(sndBloodGamble, 1.2 + random(0.2), 3);

	 // Break:
	if(!instance_near(x, y, instances_matching(CustomProp, "name", "CoastBossBecome"), 32)){
		broken = true;
		instance_destroy();
	}

#define Bone_wall
	 // Bounce Off Wall:
	if(place_meeting(x + hspeed, y, Wall)) hspeed *= -1;
	if(place_meeting(x, y + vspeed, Wall)) vspeed *= -1;
	speed /= 2;
	rotspeed *= -1;

	 // Effects:
	sound_play_hit(sndHitWall, 0.2);
	instance_create(x, y, Dust);

#define Bone_destroy
	instance_create(x, y, Dust);
	
	 // Darn:
	if(broken){
		sound_play_hit_ext(sndHitRock, 1.4 + random(0.2), 2.5);
		
		 // for u yokin:
		repeat(2) with(obj_create(x, y, "BonePickup")){
			sprite_index = spr.BoneShard;
			motion_add(random(360), 2);
		}
	}
	
	 // Pickupable:
	else with(instance_create(x, y, WepPickup)){
		wep      = "crabbone";
		curse    = other.curse;
		rotation = other.image_angle;
	}
	
	
#define CoastBossBecome_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle = spr.BigFishBecomeIdle;
		spr_hurt = spr.BigFishBecomeHurt;
		spr_dead = sprBigSkullDead;
		spr_shadow = shd32;
		image_speed = 0;
		depth = -1;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = -1;
		
		 // Vars:
		mask_index = mskScorpion;
		maxhealth = 100 * (1 + GameCont.loops);
		size = 2;
		part = 0;
		team = 0;
		
		 // Easter:
		prompt = prompt_create("DONATE");
		with(prompt) on_meet = script_ref_create(CoastBossBecome_prompt_meet);
		
		 // Part Bonus:
		part += variable_instance_get(GameCont, "ntte_visits_coast", 0);
		part += GameCont.loops;
		part = min(part, sprite_get_number(spr_idle) - 2);
		
		return id;
	}
	
#define CoastBossBecome_step
	speed = 0;
	x = xstart;
	y = ystart;
	
	 // Animate:
	image_index = clamp(part, 0, image_number - 1);
	if(nexthurt > current_frame + 3) sprite_index = spr_hurt;
	else sprite_index = spr_idle;
	
	 // Boneman Feature:
	if(instance_exists(prompt)){
		with(player_find(prompt.pick)){
			projectile_hit(id, 1);
			lasthit = [sprBone, "GENEROSITY"];
			
			with(other) with(obj_create(x, y, "Bone")){
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
			
		with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, Wall)){
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
		
		 // Complete:
		if(part >= sprite_get_number(spr_idle) - 1){
			with(obj_create(x - (image_xscale * 8), y - 6, "CoastBoss")){
				x = xstart;
				y = ystart;
				right = other.image_xscale;
			}
			with(WantBoss) instance_destroy();
			with(BanditBoss) my_health = 0;
			portal_poof();
			
			instance_delete(id);
			exit;
		}
	}
	
	 // Death:
	if(my_health <= 0) instance_destroy();
	
#define CoastBossBecome_hurt(_hitdmg, _hitvel, _hitdir)
	my_health -= _hitdmg;			// Damage
	nexthurt = current_frame + 6;	// I-Frames
	sound_play_hit(snd_hurt, 0.3);  // Sound
	
	 // Secret:
	with(other){
		if(
			(instance_is(self, ThrownWep) && wep_raw(wep) == "crabbone")
			||
			(instance_is(self, CustomProjectile) && "name" in self && (name == "Bone" || name == "BoneArrow"))
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
			
			instance_delete(id);
		}
	}
	
#define CoastBossBecome_destroy
	corpse_drop(0, 0);
	
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
	else for(var a = direction; a < direction + 360; a += (360 / 10)){
		with(instance_create(x, y, Dust)) motion_add(a, 3);
	}
	
#define CoastBossBecome_prompt_meet
	if(other.race == "skeleton") return true;
	return false;
	
	
#define CoastBoss_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
		 // For Sani's bosshudredux:
		bossname = "BIG FISH";
		col      = c_red;
		
		/// Visual:
			spr_spwn     = spr.BigFishSpwn;
			spr_idle     = sprBigFishIdle;
			spr_walk     = sprBigFishWalk;
			spr_hurt     = sprBigFishHurt;
			spr_dead     = sprBigFishDead;
			spr_weap     = mskNone;
			spr_shad     = shd48;
			spr_shadow   = spr_shad;
			hitid        = 105; // Big Fish
			sprite_index = spr_spwn;
			depth        = -2;
			
			 // Fire:
			spr_chrg = sprBigFishFireStart;
			spr_fire = sprBigFishFire;
			spr_efir = sprBigFishFireEnd;
			
			 // Swim:
			spr_dive = spr.BigFishLeap;
			spr_rise = spr.BigFishRise;
			
		 // Sound:
		snd_hurt = sndOasisBossHurt;
		snd_dead = sndOasisBossDead;
		snd_mele = sndOasisBossMelee;
		snd_lowh = sndOasisBossHalfHP;
		
		 // Vars:
		mask_index      = mskBigMaggot;
		maxhealth       = boss_hp(150);
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
		
		return id;
	}
	
#define CoastBoss_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	if(alarm3_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Animate:
	if(!array_exists([spr_hurt, spr_spwn, spr_dive, spr_rise, spr_efir, spr_fire, spr_chrg], sprite_index)){
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
				repeat(2) scrFX(x, y, [_dir + orandom(30), 5], Dust);
				with(obj_create(x, y, "WaterStreak")){
					motion_set(_dir + orandom(30), 1 + random(4));
					image_angle = direction;
					image_speed *= random_range(0.8, 1.2);
				}
			}
			sound_play_hit_ext(sndOasisBossDead, 1.2 + random(0.1), 1.2);
			
			 // Intro:
			if(!intro){
				intro = true;
				boss_intro("BigFish");
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
				
			if(instance_near(x, y, swim_target, 100)){
				var	_dis = 80,
					_dir = direction + (10 * right);
					
				_x += lengthdir_x(_dis, _dir);
				_y += lengthdir_y(_dis, _dir);
			}
			
			direction = angle_lerp(direction, point_direction(x, y, _x, _y), current_time_scale / 16);
		}
		else swim = 0;
		
		 // Turn Fins:
		swim_ang_frnt = angle_lerp(swim_ang_frnt, direction,     current_time_scale / 3);
		swim_ang_back = angle_lerp(swim_ang_back, swim_ang_frnt, current_time_scale / 10);
		
		 // Break Walls:
		if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
			speed *= 2/3;
			
			 // Effects:
			with(instance_nearest_bbox(x, y, Wall)){
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
				_ang = [20, 30];
				
			for(var o = 0; o < array_length(_oDis); o++){
				for(var i = -1; i <= 1; i += 2){
					var	_x = _cx + lengthdir_x(_oDis[o], _oDir[o]),
						_y = _cy + lengthdir_y(_oDis[o], _oDir[o]),
						a = (i * _ang[o]);
						
					 // Cool Trail FX:
					if(speed > 1){
						with(instance_create(_x, _y, BoltTrail)){
							motion_add(_oDir[o] + 180 + a, other.speed * random_range(0.5, 1));
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
							motion_add(_oDir[o] + 180 + (2 * a), other.speed);
							image_xscale *= .75;
							image_yscale  = image_xscale;
							depth         = other.depth;
						}
					}
				}
			}
			
			 // Quakes:
			if(chance(1, 4)) view_shake_at(_cx, _cy, 4);
		}
		
		 // Manual Collisions:
		if(place_meeting(x, y, Player)){
			with(instances_meeting(x, y, instances_matching_ne(Player, "team", team))){
				if(place_meeting(x, y, other)) with(other){
					event_perform(ev_collision, Player);
				}
			}
		}
		if(place_meeting(x, y, prop)){
			with(instances_meeting(x, y, prop)){
				if(place_meeting(x, y, other)) with(other){
					event_perform(ev_collision, prop);
				}
			}
		}
		
		 // Bolts No:
		with(instances_matching(BoltStick, "target", id)){
			sound_play_hit(sndCrystalPropBreak, 0.3);
			repeat(5) with(instance_create(x, y, Dust)){
				motion_add(random(360), 3);
			}
			instance_destroy();
		}
		
		 // Disable Hitbox:
		if(swim_mask == -1) swim_mask = mask_index;
		mask_index = mskNone;
		
		 // Un-Dive:
		if(swim <= 0){
			swim = 0;
			alarm3 = -1;
			scrRight(direction);
			speed = 0;
			
			spr_shadow   = spr_shad;
			sprite_index = spr_rise;
			image_index  = 0;
			depth        = -2;
			
			mask_index = swim_mask;
			swim_mask = -1;
			
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
	if(array_length(fish_train) > 0){
		var	_leader    = id,
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
						
						_fish = obj_create(_leader.x, _leader.y, (chance(1, 100) ? "Puffer" : BoneFish));
						
						with(_fish){
							kills = 0;
							creator = other;
							
							 // Keep Distance:
							var	_l = 2,
								_d = _leader.direction + 180;
								
							while(instance_near(x, y, _leader, 24)){
								x += lengthdir_x(_l, _d);
								y += lengthdir_y(_l, _d);
								direction = _d;
							}
							
							 // Spawn Poof:
							//sound_play(snd)
							repeat(8) with(scrFX(x, y, 1, Dust)){
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
							scrRight(point_direction(x, y, _leader.x, _leader.y));
							
							if(speed > 0 && chance(1, 3)){
								with(instance_create(x + orandom(6), y + random(8), Sweat)){
									direction = other.direction + choose(-60, 60) + orandom(10);
									speed = 0.5;
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
						_leader = id;
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
	
#define CoastBoss_hurt(_hitdmg, _hitvel, _hitdir)
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
		my_health -= _hitdmg;          // Damage
		nexthurt = current_frame + 6;  // I-Frames
		sound_play_hit(snd_hurt, 0.3); // Sound
		
		 // Half HP:
		var h = (maxhealth / 2);
		if(in_range(my_health, h - _hitdmg + 1, h)){
			sound_play(snd_lowh);
		}
		
		 // Knockback:
		if(swim <= 0){
			motion_add(_hitdir, _hitvel);
		}
		
		 // Hurt Sprite:
		if(!array_exists([spr_fire, spr_chrg, spr_efir, spr_dive, spr_rise], sprite_index)){
			sprite_index = spr_hurt;
			image_index  = 0;
		}
	//}
	
#define CoastBoss_draw
	var _hurt = (nexthurt > current_frame + 3);
	
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
			draw_set_fog(1, image_blend, 0, 0);
		}
		draw_self_enemy();
	}
	
	if(_hurt){
		draw_set_fog(false, 0, 0, 0);
	}
	
#define CoastBoss_alrm1
	alarm1 = 30 + random(20);
	
	if(enemy_target(x, y)){
		if(instance_near(x, y, target, 160) && (variable_instance_get(target, "reload", 0) <= 0 || chance(2, 3))){
			scrAim(point_direction(x, y, target.x, target.y));
			
			 // Move Towards Target:
			if((instance_near(x, y, target, 64) && chance(1, 2)) || chance(1, 4)){
				scrWalk(gunangle + orandom(10), [30, 40]);
				alarm1 = walk + random(10);
			}
			
			 // Bubble Blow:
			else{
				ammo = 4 * (GameCont.loops + 2);
				
				scrWalk(gunangle + orandom(30), 8);
				
				image_index  = 0;
				sprite_index = spr_chrg;
				sound_play_pitch(sndOasisBossFire, 1 + orandom(0.2));
				
				alarm2 = 3;
				alarm1 = -1;
			}
		}
		
		 // Dive:
		else alarm3 = 6;
	}
	
	 // Passive Movement:
	else{
		alarm1 = 40 + random(20);
		scrWalk(random(360), 20);
		scrAim(direction);
	}
	
#define CoastBoss_alrm2
	 // Fire Bubble Bombs:
	repeat(irandom_range(1, 2)){
		if(ammo > 0){
			alarm2 = 2;
			
			 // Blammo:
			sound_play(sndOasisShoot);
			projectile_create(
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
			projectile_create(x, y, "BubbleBomb", direction + orandom(10), 4);
			sound_play_hit(sndBouncerBounce, 0.3);
		}
	}
	
#define CoastBoss_death
	 // Coast Entrance:
	GameCont.killenemies = true;
	area_set("coast", 0, GameCont.loops);
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
		var	l = random(16),
			d = 90 + orandom(110);
			
		with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "FlySpin")){
			depth = other.depth;
		}
		
		return id;
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
		
		return id;
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
		spr_idle     = spr.ScorpionRockEnemy;
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
		
		return id;
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
		if(anim_end){
			if(friendly == false && !instance_exists(enemy)){
				friendly = true;
			}
			if(friendly && spr_idle == spr.ScorpionRockEnemy){
				spr_idle = spr.ScorpionRockFriend;
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
	if(friendly) pet_spawn(x, y, "Scorpion");
	else obj_create(x, y, "BabyScorpion");
	
	 // Light Snack:
	repeat(3) if(chance(1, 2)){
		instance_create(x, y, Maggot);
	}
	
	 // Play Date:
	if(chance(1, 100)){
		obj_create(x, y, "Spiderling");
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
		
		return id;
	}
	
#define SilverScorpion_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	/*
	 // Flak Target Tracking:
	if(instance_exists(flak)){
		if(flak.time < flak.time_max){
			 // Retarget:
			if(instance_seen(x, y, target)){
				var _d = point_direction(x, y, target.x, target.y);
				scrAim(angle_lerp(gunangle, _d, 1/3));
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
	scrWalk(random(360), random_range(20, 30));
	
	if(ammo <= 0){
		 // Aggroed:
		if(enemy_target(x, y) && (my_health < maxhealth || instance_seen(x, y, target))){
			scrAim(point_direction(x, y, target.x, target.y));
			direction = gunangle + orandom(40);
			
			 // Attack:
			if(!chance(point_distance(x, y, target.x, target.y) - 128, 192)){
				alarm1 = irandom_range(75, 120);
				alarm2 = 1;
				/*
				sprite_index = spr_fire;
				flak = projectile_create(x, y, "SilverScorpionFlak", gunangle, 8);
				*/
			}
		}
		
		 // Wander:
		else scrAim(direction);
	}
	
#define SilverScorpion_alrm2
	 // Start Firing:
	if(ammo <= 0){
		ammo = 10;
		
		 // Flak:
		with(projectile_create(x, y, "VenomFlak", gunangle, 3)){
			friction      = 0.2;
			image_xscale *= 1.25;
			image_yscale *= 1.25;
			charge_time   = other.ammo * 3;
			alarm0        = charge_time;
		}
		
		 // Sound:
		sound_play_hit_ext(sndGoldScorpionFire,  1.2 + random(0.2), 6);
		sound_play_hit_ext(sndCrownGuardianFire, 0.5 + random(0.2), 4);
		sound_play_hit_ext(sndGuardianAppear,    0.5 + random(0.2), 3.5);
	}
	
	 // Fire:
	if(ammo > 0){
		if(--ammo > 0){
			alarm2 = 3;
		}
		
		 // Pew pew:
		projectile_create(
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
	sound_play_hit_ext(sndSuperSlugger, 1.3 + random(0.2), 1.5);
	view_shake_at(x, y, 30);
	
	 // Splat:
	var _ang = direction + 45;
	for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 4)){
		with(scrFX(x, y, [_dir, 9], AcidStreak)){
			image_angle = direction;
		}
	}
	
	 // Venom:
	with(projectile_create(x, y, "VenomFlak", direction, 0)){
		charging = false;
		repeat(12){
			projectile_create(x, y, EnemyBullet2,  random(360), random_range(3, 5));
			projectile_create(x, y, "VenomPellet", random(360), random_range(8, 12));
		}
	}
	/*
	var n = 7;
	for(var d = 0; d < 360; d += 360 / n){
		projectile_create(x, y, "SilverScorpionDevastator", direction + d, random_range(5, 6));
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
		
		return id;
	}
	
#define SilverScorpionDevastator_step
	if(current_frame_active){
		projectile_create(
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
		projectile_create(x, y, "VenomPellet", random(360), random_range(3, 7));
	}
	
	
#define SilverScorpionFlak_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.SilverScorpionFlak;
		image_speed  = 0.4;
		depth        = -4;
		
		 // Vars:
		mask_index = mskBullet1;
		damage     = 2;
		force      = 12;
		typ        = 2;
		time       = 0;
		time_max   = 20;
		//wave       = random(360);
		
		return id;
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
			with(projectile_create(
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
			projectile_create(
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
				var l = sin(wave / 2) * 16,
					d = direction + (90 * i);
					
				with(projectile_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "VenomPellet", direction, (speed * 1/3))){
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
	if(projectile_canhit_melee(other)){
		projectile_hit_push(other, damage, force);
	}
	
#define SilverScorpionFlak_destroy
	 // Bullets:
	var n = 7;
	for(var d = 0; d < 360; d += 360 / n){
		projectile_create(x, y, "SilverScorpionDevastator", direction + d, random_range(5, 6));
	}
	repeat(12){
		projectile_create(x, y, "VenomPellet", random(360), random_range(4, 8));
	}
	
	 // Effects:
	view_shake_at(x, y, 20);
	sound_play_hit_ext(sndToxicBoltGas, 1, 1);
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
		
		return id;
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
			sound_play_hit_ext(sndScorpionFire, 0.5 + (1.5 * (image_xscale / charge_goal)), 4);
			if(chance_ct(1, 4)){
				var	_l = random(sprite_width),
					_d = random(360);
					
				with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), AcidStreak)){
					motion_set(_d + 180, 2);
					image_angle = direction;
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
		projectile_hit(other, damage, force, direction);
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
				with(projectile_create(
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
			else projectile_create(
				x,
				y,
				"VenomPellet",
				_dir + (45 * i) + orandom(16) + (i * random(6 * _lvl)),
				4 + random(10)
			);
		}
		
		 // Effects:
		with(instance_create(x, y, AcidStreak)){
			motion_set(_dir + (45 * i), 4);
			image_angle = direction;
			image_xscale = 1.6;
			image_yscale = 1.0;
		}
	}
	
	 // Sounds:
	sound_play_hit_ext(sndFlyFire,          1.0 + random(0.4), 2.5);
	sound_play_hit_ext(sndGoldScorpionFire, 1.6 + random(0.4), 2.5);
	
	
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
		
		return id;
	}
	
#define VenomFlak_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Charging Up:
	if(charging){
		var _angry = (array_length(instances_matching(CustomEnemy, "name", "CatBoss")) <= 0) + (0.5 * GameCont.loops);
		speed += friction_raw + (0.3 * _angry * current_time_scale);
		
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
	if(charging){
		if(projectile_canhit_melee(other)){
			projectile_hit(other, 1);
		}
	}
	else if(projectile_canhit(other)){
		projectile_hit(other, damage, force, direction);
		instance_destroy();
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
				scrFX([x, 6], [y, 6], [gunangle + orandom(2), 4 + random(4)], Smoke);
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
		sound_play_hit_ext(sndShotgunHitWall, 1.2, 1.5);
		sound_play_hit_ext(sndFrogEggHurt,    0.7, 0.3);
		
		 // Effects:
		with(instance_create(x, y, AcidStreak)){
			motion_set(other.direction, 3);
			image_angle = direction;
			image_yscale *= 2; // fat splat
		}
	}
	
#define VenomFlak_destroy
	instance_create(x, y, PortalClear);
	if(!instance_is(creator, Player)){
		pickup_drop(50, 0);
	}
	
	 // Effects:
	for(var a = 0; a < 360; a += (360 / 20)){
		scrFX(x, y, [a, 4 + random(4)], Smoke);
	}
	
	view_shake_at(x, y, 20);
	
	sound_play_pitchvol(sndHeavyMachinegun, 1,					0.8);
	sound_play_pitchvol(sndSnowTankShoot,	1.4,				0.7);
	sound_play_pitchvol(sndFrogEggHurt,		0.4 + random(0.2),	3.5);
	
	 // Projectiles:
	for(var d = 0; d < 360; d += (360 / 12)){
		 // Venom Lines:
		if((d mod 90) == 0){
			for(var i = 0; i <= 4; i++){
				with(projectile_create(
					x,
					y,
					"VenomPellet",
					direction + d + orandom(2 + i),
					2 * i
				)){
					move_contact_solid(direction, 4 + (4 * i));
					
					 // Effects:
					with(instance_create(x, y, AcidStreak)){
						motion_set(other.direction + orandom(4), other.speed * 0.8);
						image_angle = direction;
					}
				}
			}
		}
		
		 // Individual:
		else with(projectile_create(
			x,
			y,
			"VenomPellet",
			direction + d + orandom(2),
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
		
		 // Vars:
		mask_index = mskEnemyBullet1;
		friction   = 0.75;
		damage     = 2;
		force      = 4;
		typ        = 2;
		minspeed   = 4;
		hit_list   = [];
		
		return id;
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
	var _firstHit = !array_exists(hit_list, other);
	if(projectile_canhit_melee(other) || (_firstHit && !instance_is(other, Player))){
		projectile_hit_push(other, damage, force);
		
		if(_firstHit){
			array_push(hit_list, other);
			
			 // Catch on Enemy / Pseudo Freeze Frames:
			if(instance_exists(other) && other.my_health > 0){
				x -= hspeed_raw;
				y -= vspeed_raw;
				speed -= friction;
			}
		}
		
		 // Effects:
		with(instance_create(x, y, ScorpionBulletHit)){
			sprite_index = other.spr_dead;
		}
	}
	
#define VenomPellet_wall
	instance_create(x, y, Dust);
	sound_play_hit(sndHitWall, 0.2);
	instance_destroy()
	
#define VenomPellet_destroy
	if(sprite_index != spr_fade){
		with(instance_create(x, y, ScorpionBulletHit)){
			sprite_index = other.spr_dead;
		}
	}
	
	
#define VenomPelletBack_create(_x, _y)
	with(obj_create(_x, _y, "VenomPellet")){
		 // Visual:
		spr_idle = spr.VenomPelletBack;
		spr_fade = spr.VenomPelletBackDisappear;
		sprite_index = spr_idle;
		depth++;
		
		return id;
	}
	
	
#define WantBigMaggot_create(_x, _y)
	with(instance_create(_x, _y, BigMaggot)){
		instance_change(BigMaggotBurrow, false);
		sprite_index = sprBigMaggotBurrow;
		visible = false;
		alarm0 = -1;
		
		 // Vars:
		unburrow_check_timer = random_range(150, 450);
		
		return id;
	}
	
#define WantBigMaggot_step
	if(unburrow_check_timer > 0){
		unburrow_check_timer -= current_time_scale;
	}
	else{
		unburrow_check_timer = random_range(120, 300);
		
		 // Unburrow:
		if(instance_near(x, y, Player, 160) || !instance_exists(enemy)){
			sound_play_hit_big(sndBigMaggotUnburrowSand, 0.2);
			sprite_index = sprBigMaggotAppear;
			image_index = 0;
			visible = true;
			alarm1 = 12;
		}
	}
	
	 // Stay Burrowed:
	if(!visible){
		sprite_index = sprBigMaggotBurrow;
		image_index = 0;
	}
	
	 // Unburrowing:
	else if(anim_end){
		with(instance_create(x, y, BigMaggot)){
			x = xstart;
			y = ystart;
			right = other.right;
		}
		instance_delete(id);
	}
	
	
/// GENERAL
#define ntte_begin_step
	 // Baby Scorpion Spawn:
	if(instance_exists(MaggotSpawn)){
		var _inst = instances_matching_gt(instances_matching_le(MaggotSpawn, "my_health", 0), "babyscorp_drop", 0);
		if(array_length(_inst)) with(_inst){
			repeat(babyscorp_drop){
				obj_create(x, y, "BabyScorpion");
			}
		}
	}
	
	 // Hiker Backpack:
	if(instance_exists(Bandit)){
		var _inst = instances_matching_le(instances_matching(Bandit, "name", "BanditHiker"), "my_health", 0);
		if(array_length(_inst)) with(_inst){
			speed /= 2;
			with(obj_create(x, y, "BackpackPickup")){
				target = chest_create(x, y, "Backpack", false);
				direction = other.direction + orandom(10);
				event_perform(ev_step, ev_step_end);
			}
			repeat(5) scrFX(x, y, 4, Dust);
			sound_play_pitchvol(sndMenuASkin, 1.2, 0.6);
		}
	}
	
	 // Big Fish Train Pickups:
	if(instance_exists(BoneFish)){
		var _inst = instances_matching_le(BoneFish, "my_health", 0);
		if(array_length(_inst)) with(_inst){
			if("creator" in self && "name" in creator && creator.name == "CoastBoss"){
				pickup_drop(10, 0);
			}
		}
	}
	
#define ntte_step
	 // Separate Bones:
	if(instance_exists(WepPickup)){
		var _inst = instances_matching(WepPickup, "crabbone_splitcheck", null);
		if(array_length(_inst)) with(_inst){
			if(
				is_object(wep)
				&& wep_raw(wep) == "crabbone"
				&& lq_defget(wep, "ammo", 1) > 1
			){
				wep.ammo--;
				with(instance_create(x, y, WepPickup)){
					wep = wep_raw(other.wep);
				}
			}
			else crabbone_splitcheck = true;
		}
	}
	
#define ntte_end_step
	 // Skeletons Drop Bones:
	if(instance_exists(BonePile) || instance_exists(BonePileNight) || instance_exists(BigSkull)){
		var _inst = instances_matching_le([BonePile, BonePileNight, BigSkull], "my_health", 0);
		if(array_length(_inst)) with(_inst){
			 // Enter the bone zone:
			with(instance_create(x, y, WepPickup)){
				wep = "crabbone";
				motion_add(random(360), 3);
			}
			
			 // Effects:
			repeat(2) scrFX(x, y, 3, Dust);
		}
	}
	
#define ntte_bloom
	if(instance_exists(CustomProjectile)){
		 // Silver Scorpion Pet Attack:
		var _inst = instances_matching(CustomProjectile, "name", "VenomBlast");
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * (charge ? (image_xscale / charge_goal) : 1) * 0.2);
		}
		
		 // Silver Scorpion Flak:
		var _inst = instances_matching(CustomProjectile, "name", "VenomFlak");
		if(array_length(_inst)) with(_inst){
			var	_xsc = 2,
				_ysc = 2,
				_alp = 0.2;
				
			image_xscale *= _xsc;
			image_yscale *= _ysc;
			image_alpha  *= _alp;
			event_perform(ev_draw, 0);
			image_xscale /= _xsc;
			image_yscale /= _ysc;
			image_alpha  /= _alp;
		}
		var _inst = instances_matching(CustomProjectile, "name", "SilverScorpionFlak");
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.2 * image_alpha);
		}
	}
	
#define ntte_shadows
	 // SharkBoss Loop Train:
	if(instance_exists(CustomEnemy)){
		var _inst = instances_matching(CustomEnemy, "name", "CoastBoss");
		if(array_length(_inst)) with(_inst){
			var _fishIndex = 0;
			with(fish_train){
				if(instance_exists(self) && other.fish_swim[_fishIndex++]){
					draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
				}
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