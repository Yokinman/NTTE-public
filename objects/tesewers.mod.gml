#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#define AlbinoBolt_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.AlbinoBolt;
		depth        = -2;
		
		 // Vars:
		mask_index = mskBolt;
		creator    = noone;
		target     = noone;
		damage     = 6;
		force      = 12;
		typ        = 1;
		ammo       = 0;
		ammo_max   = 4;
		setup      = true;
		small      = false;
		
		return id;
	}
	
#define AlbinoBolt_setup
	setup = false;
	
	if(small){
		 // Visual:
		sprite_index = spr.AlbinoSplinter;
		
		 // Vars:
		damage   = 3;
		force    = 6;
		blink    = 0;
		ammo_max = 0;
	}
	
#define AlbinoBolt_step
	if(setup) AlbinoBolt_setup();
	
	 // Alarms:
	if(alarm0_run) exit;
	
#define AlbinoBolt_end_step
	if(setup) AlbinoBolt_setup();
	
	 // Stuck:
	if(instance_exists(target)){
		var	_l = 12,
			_d = image_angle + 180;
			
		x = target.x + lengthdir_x(_l, _d);
		y = target.y + lengthdir_y(_l, _d);
		speed = 0;
		
		 // Small:
		if(small){
			with(instance_create(x, y, BoltStick)){
				sprite_index = other.sprite_index;
				image_angle = other.image_angle;
				target = other.target;
			}
		}
	}
	
	 // Trail:
	if(speed > 0){
		var	_x1 = x,
			_y1 = y,
			_x2 = xprevious,
			_y2 = yprevious;
			
		with(instance_create(x, y, BoltTrail)){
			image_yscale = (other.small ? 0.6 : 1.5);
			image_xscale = point_distance(_x1, _y1, _x2, _y2);
			image_angle = point_direction(_x1, _y1, _x2, _y2);
			image_blend = ((other.team == 2) ? c_yellow : make_color_rgb(250, 56, 0));
		}
	}
	
	 // Explo Time:
	else if(alarm0 < 0){
		alarm0 = 20;
		typ = 0;
	}
	
#define AlbinoBolt_draw
	var _blink = (ammo > 0 && ((current_frame % 4) < 2));
	if(_blink) draw_set_fog(true, c_white, 0, 0);
	
	draw_self();
	
	if(_blink) draw_set_fog(false, 0, 0, 0);
	
#define AlbinoBolt_alrm0
	var _sndInst = (instance_exists(target) ? target : self);
	
	 // Prepare:
	if(ammo <= 0 && ammo_max > 0){
		alarm0 = 30;
		ammo = ammo_max;
		
		 // Warning:
		sound_play_pitchvol(sndSniperTarget,     0.8 + random(0.2),  0.6);
		sound_play_pitchvol(sndUltraGrenadeSuck, 2.5 + orandom(0.5), 0.7);
		repeat(6) scrFX(x, y, [image_angle + 180, random(3)], Smoke);
	}
	
	 // Shooting:
	else{
		alarm0 = 1;
		
		if(ammo > 0){
			 // Explo FX:
			if(visible){
				visible = false;
				with(instance_create(x, y, PortalClear)){
					image_xscale = 0.5;
					image_yscale = image_xscale;
				}
				with(instance_create(x, y, BulletHit)){
					sprite_index = ((other.team == 2) ? sprFlakHit : sprEFlakHit);
					image_index  = 3 - image_speed;
					image_xscale = 0.9;
					image_yscale = 0.9;
				}
				sound_play_pitchvol(sndFlakExplode, 1 + random(0.2), 0.8);
				sleep_max(25);
			}
			
			 // Splinters:
			var d = 90 * (1 - (ammo / ammo_max));
			for(var i = -sign(d); i <= sign(d); i += 2){
				with(projectile_create(
					x,
					y,
					"AlbinoBolt",
					direction + 180 + (d * i),
					15
				)){
					small = true;
				}
			}
			
			 // Effects:
			sound_play_pitchvol(
				((ammo & 1) ? sndTurretFire : sndSplinterPistol),
				1 + orandom(0.2),
				1.2
			);
			repeat(5) scrFX(x, y, [random(360), 1 + random(2)], Smoke);
			view_shake_at(x, y, 15);
		}
		
		 // End:
		if(--ammo <= 0) instance_destroy();
	}
	
#define AlbinoBolt_hit
	 // Setup:
	if(setup) AlbinoBolt_setup();
	
	 // Hit:
	if(speed > 0 && projectile_canhit(other)){
		projectile_hit(other, damage, force, direction);
		if(instance_exists(other) && other.my_health > 0){
			target = other;
			speed = 0;
		}
		
		 // FX:
		repeat(4) scrFX(x, y, 2, Smoke);
	}
	
#define AlbinoBolt_wall
	 // Stick in Wall:
	if(speed > 0){
		speed = 0;
		instance_create(x, y, Smoke);
		
		move_contact_solid(direction, 16);
		x += lengthdir_x(6, direction);
		y += lengthdir_y(6, direction);
		xprevious = x;
		yprevious = y;
		
		 // FX:
		sound_play_hit(sndBoltHitWall, 0.2);
		instance_create(x, y, Smoke);
		if(!small){
			sound_play_hit_ext(sndHammer, 1.3 + random(0.2), 1.2);
			view_shake_at(x, y, 20);
		}
	}


#define AlbinoGator_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.AlbinoGatorIdle;
		spr_walk     = spr.AlbinoGatorWalk;
		spr_hurt     = spr.AlbinoGatorHurt;
		spr_dead     = spr.AlbinoGatorDead;
		spr_weap     = spr.AlbinoGatorWeap;
		spr_halo     = sprStrongSpiritRefill;
		halo_index   = 0;
		sprite_index = spr_idle;
		hitid        = [spr_idle, "ALBINO GATOR"];
		spr_shadow   = shd24;
		depth        = -2;
		
		 // Sounds:
		snd_hurt = sndBuffGatorHit;
		snd_dead = sndBuffGatorDie;
		
		 // Vars:
		mask_index   = mskBandit;
		maxhealth    = 32;
		raddrop      = 7;
		size         = 2;
		walk         = 0;
		walkspeed    = 1.2;
		maxspeed     = 3.6;
		gunangle     = random(360);
		direction    = gunangle;
		gonnafire    = 0;
		wave         = 0;
		canspirit    = true;                       // Has spirit or not
		maxspirit    = 15;                         // Threshold for spirit regain
		spirit_bonus = GameCont.hard;              // Bonus spirit gained on spirit regain
		spirit_regen = 10;                         // Alarm interval for spirit regain
		spirit       = (maxspirit + spirit_bonus); // Current spirit number
		spirit_hurt  = current_frame;              // Spirit loss iframe cutoff
		aim_factor   = 0;
		cangrenade   = false;
		grenades     = 2;
		
		 // Alarms:
		alarm1 = 30;
		alarm2 = spirit_regen;
		
		return id;
	}
	
#define AlbinoGator_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Halo Animation:
	var _haloNumber = sprite_get_number(spr_halo);
	halo_index += image_speed_raw;
	if(halo_index >= _haloNumber){
		halo_index %= _haloNumber;
		switch(spr_halo){
			case sprStrongSpirit       : spr_halo = mskNone; break;
			case sprStrongSpiritRefill : spr_halo = sprHalo; break;
		}
	}
	
	 // Aiming:
	var _rate = (0.1 * current_time_scale);
	if(gonnafire > 0){
		if(aim_factor < 1){
			aim_factor = min(aim_factor + _rate, 1);
		}
	}
	else if(aim_factor > 0){
		aim_factor = max(aim_factor - _rate, 0);
	}
	
	 // Bounce:
	if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
		if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -0.5;
		if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -0.5;
		if(gonnafire <= 0){
			scrAim(angle_lerp(gunangle, direction, 2/3));
		}
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	wave += current_time_scale;
	
#define AlbinoGator_alrm1
	alarm1 = 20 + random(30);
	
	 // Attack:
	if(gonnafire > 0){
		alarm1 = 1;
		gonnafire--;
		
		 // Can't Aim if you Can't See:
		if(enemy_target(x, y) && instance_seen(x, y, target)){
			var _clamp = 2.4 * aim_factor;
			scrAim(gunangle + clamp(angle_difference(point_direction(x, y, target.x, target.y), gunangle), -_clamp, _clamp));
		}
		
		 // Fire:
		if(gonnafire <= 0){
			alarm1 = 30;
			
			projectile_create(x, y, "AlbinoBolt", gunangle, 16);
			
			sound_play_pitchvol(sndHeavyCrossbow, 1.2 + random(0.2), 0.8);
			sound_play_pitchvol(sndTurretFire,    0.8 + random(0.2), 0.8);
			
			motion_set(gunangle + 180, 3);
			wkick = 8;
		}
	}
	
	else if(enemy_target(x, y)){
		var _targetDir = point_direction(x, y, target.x, target.y);
		
		if(instance_seen(x, y, target)){
			scrAim(_targetDir);
			cangrenade = true;
			
			 // Begin Attack:
			if(chance(2, 3)){
				alarm1 = 1;
				gonnafire = 30;
				sound_play_pitchvol(sndCrossReload,  0.8 + random(0.2), 1.2);
				sound_play_pitchvol(sndSnowTankAim,  1.5 + random(0.2), 0.6);
				sound_play_pitchvol(sndSniperTarget, 1.4 + random(0.2), 0.5);
			}
			
			 // Approach Target:
			else scrWalk(gunangle + orandom(15), [40, 60]);
		}
		
		 // Grenades:
		else if(
			grenades > 0
			&& cangrenade
			&& chance(1, 2)
			&& instance_near(x, y, target, 160)
			&& array_length(instances_matching(instances_matching(projectile, "creator", id), "team", team)) <= 0
		){
			grenades--;
			alarm1 += 30;
			
			 // Re-aim:
			if(abs(angle_difference(_targetDir, gunangle)) > 60){
				scrAim(_targetDir + orandom(30));
			}
			
			 // Throw Grenade:
			projectile_create(x, y, "AlbinoGrenade", gunangle, random_range(8, 12));
			motion_add(gunangle + 180, 2);
			
			 // Sound:
			sound_play_hit_ext(sndAssassinAttack, 1.0 + random(0.2), 2.5);
		}
		
		 // Wander:
		else{
			scrWalk(gunangle + orandom(30), [20, 60]);
			scrAim(direction);
		}
	}
	
#define AlbinoGator_alrm2
	alarm2 = spirit_regen;
	
	if(spirit < maxspirit){
		spirit += 1;
		if(spirit >= maxspirit && !canspirit){
			canspirit = true;
			spirit = (maxspirit + spirit_bonus);
			
			spr_halo = sprStrongSpiritRefill;
			halo_index = 0;
			
			 // Sounds:
			sound_play_hit(sndStrongSpiritGain, 0.2);
		}
	}
	
#define AlbinoGator_draw
	var	h = (nexthurt > (current_frame + 3) && sprite_index != spr_hurt),
		b = (gunangle > 180);
		
	 // Laser Sight:
	if(gonnafire > 0){
		draw_set_color(make_color_rgb(252, 56, 0));
		draw_lasersight(x, y, gunangle, 1000, aim_factor);
		draw_set_color(c_white);
	}
		
	 // Body and Gun:
	if(h) d3d_set_fog(true, c_black, 0, 0);
	if(b) draw_self_enemy();
	
	draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
	
	if(!b) draw_self_enemy();
	if(h) d3d_set_fog(false, 0, 0, 0);
	
	 // Halo:
	draw_sprite(spr_halo, halo_index, x, (y - 3) + sin(wave * 0.1));
	
#define AlbinoGator_hurt(_hitdmg, _hitvel, _hitdir)
	spirit = max(spirit - _hitdmg, 0);
	nexthurt = (current_frame + 6);
	
	if(spirit_hurt <= current_frame){
		if(canspirit){
			 // Spirit Break:
			if(spirit <= 0){
				canspirit = false;
				spirit_hurt = (current_frame + 6);
				
				spr_halo = sprStrongSpirit;
				halo_index = 0;
				
				sound_play_hit(sndStrongSpiritLost, 0.2);
				sound_play_hit(sndSuperFireballerFire, 0.2);
			}
			
			 // Spirit Damage Sounds:
			else{
				sound_play_hit(sndCursedPickup, 0.2);
				sound_play_hit(sndFireballerFire, 0.2);
			}
			
			 // Effects:
			with(instance_create(x + (5 * right), y - 5, ThrowHit)){
				depth = other.depth - 1;
			}
			motion_add(_hitdir, (_hitvel / 4));
		}
		
		 // Take Damage:
		else enemy_hurt(_hitdmg, _hitvel, _hitdir);
	}
	
#define AlbinoGator_death
	pickup_drop(80, 0);
	pickup_drop(80, 20, 0);
	
	
#define AlbinoGrenade_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.AlbinoGrenade;
		image_speed = 0.4;
		depth = -2;
		
		 // Vars:
		friction = 0.1;
		mask_index = mskBigRad;
		creator = noone;
		damage = 4;
		force = 4;
		typ = 1;
		angle = pround(random(360), 45);
		turn = orandom(1);
		
		 // Alarms:
		alarm0 = 80;
		alarm1 = 6;
		alarm2 = max(1, alarm0 - 30);
		
		return id;
	}
	
#define AlbinoGrenade_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Baseball:
	if(place_meeting(x, y, projectile)){
		with(instances_matching(instances_meeting(x, y, projectile), "object_index", Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, CustomSlash)){
			if(place_meeting(x, y, other)){
				event_perform(ev_collision, Grenade);
				if(!instance_exists(other)) exit;
			}
		}
	}
	
	 // Effects:
	var _ang = pround(angle, 45);
	for(var _dir = _ang; _dir < _ang + 360; _dir += 90){
		if(chance_ct(1 + (alarm2 < 0), 4)){
			var _spd = random_range(1, 3);
			with(scrFX(x, y, [_dir, _spd], PlasmaTrail)){
				sprite_index = spr.QuasarBeamTrail;
			}
		}
	}
	
#define AlbinoGrenade_hit
	// ...
	
#define AlbinoGrenade_wall
	 // Bounce:
	if(speed > 0){
		move_bounce_solid(false);
		
		 // Slow:
		speed *= 1/3;
		alarm1 = min(alarm1, 1);
		
		 // Effects:
		sound_play_hit(sndGrenadeHitWall, 0);
	}
	
#define AlbinoGrenade_alrm0
	instance_destroy();
	
#define AlbinoGrenade_alrm1
	friction = 0.4;
	
	 // Effects:
	with(instance_create(x, y, BulletHit)) sprite_index = spr.QuasarBeamHit;
	sound_play_hit_ext(sndIDPDNadeAlmost, 1.1 + random(0.2), 2);
	
#define AlbinoGrenade_alrm2
	 // Warning:
	sprite_index = sprHeavyGrenadeBlink;
	sound_play_hit_ext(sndIDPDNadeLoad, 1.3 + random(0.2), 1.5);
	
#define AlbinoGrenade_destroy
	 // Explosive:
	with(instance_create(x, y, Explosion)){
		team         = -1;
		hitid        = 55;
		mask_index   = mskPopoExplo;
		image_xscale = 0.9;
		image_yscale = image_xscale;
		depth        = 0;
	}
	
	 // Quasars:
	var	_dis = 16,
		_ang = pround(angle, 45);
		
	for(var _dir = _ang; _dir < _ang + 360; _dir += 90){
		with(projectile_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "QuasarBeam", _dir, 0)){
			hold_x         = x;
			hold_y         = y;
			scale_goal     = 0.8;
			shrink_delay   = 12;
			line_dir_fric  = 0;
			line_dir_turn  = other.turn;
			follow_creator = false;
		}
	}
	
	 // Effects:
	sound_play_hit_ext(sndExplosionL, 1.8 + random(0.2), 1.8);
	
	
#define BabyGator_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.BabyGatorIdle;
		spr_walk     = spr.BabyGatorWalk;
		spr_hurt     = spr.BabyGatorHurt;
		spr_dead     = spr.BabyGatorDead;
		spr_weap     = spr.BabyGatorWeap;
		sprite_index = spr_idle;
		hitid        = [spr_idle, "BABY GATOR"];
		spr_shadow   = shd16;
		spr_shadow_y = 1;
		depth        = -2;
		
		 // Sounds:
		snd_hurt = sndHitFlesh;
		snd_dead = sndGatorDie;
		
		 // Vars:
		mask_index = mskMaggot;
		maxhealth  = 12;
		raddrop    = 2;
		size       = 0;
		walk       = 0;
		walkspeed  = 1.2;
		maxspeed   = 3.4;
		z          = 0;
		maxz       = 12;
		zspeed     = 0;
		zfriction  = 0.5;
		zbounce    = 0;
		kick_invul = (current_frame + 30);
		gunangle   = random(360);
		direction  = gunangle;
		
		 // Alarms:
		alarm1 = 30;
		
		return id;
	}
	
#define BabyGator_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Kickable:
	if(current_frame >= kick_invul && z <= 0 && place_meeting(x, y, Player)){
		with(instances_meeting(x, y, instances_matching_ne(Player, "team", team))){
			if(speed > 0 && place_meeting(x, y, other)){
				projectile_hit(other, 3, speed, direction);
				
				 // Effects:
				sound_play_hit_big(sndImpWristKill, 0.3);
				
				instance_create(x, y, ImpactWrists);
				scrFX(x, y, [direction, 4], "WaterStreak");
				
				view_shake_at(x, y, 20);
				sleep(20);
			}
		}
	} 
	
	 // Ya boy z axis:
	if(z > 0 || zspeed > 0){
		z = min(14, z + (zspeed * current_time_scale));
		zspeed -= zfriction * current_time_scale;
		
		if(z <= 0 && zbounce){
			projectile_hit_raw(id, 1, true);
			
			 // Effects:
			sound_play_hit(sndImpWristHit, 0.3);
			instance_create(x, y, ThrowHit);
			view_shake_at(x, y, 10);
			
			zspeed = (1.6 * zbounce);
			zbounce = 0;
		}
	}
	else if(z < 0) z = 0;
	
	 // Movin:
	if(z > 0){
		motion_add(direction, abs(zspeed));
		speed = min(speed, maxspeed);
		if(current_frame_active){
			alarm1 += ceil(current_time_scale);
		}
	}
	else{
		enemy_walk(walkspeed, maxspeed);
	}

	 // Bounce:
	if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
		if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
		if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
		scrAim(direction);
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	
#define BabyGator_alrm1
	alarm1 = 30 + random(60);
	
	if(
		enemy_target(x, y)
		&& instance_seen(x, y, target)
		&& instance_near(x, y, target, 160)
	){
		scrAim(point_direction(x, y, target.x, target.y));
		
		 // Attack:
		if(chance(1, 2)){
			wkick = 6;
			
			var	_l = 8,
				_d = gunangle + orandom(12),
				_x = x + lengthdir_x(_l, _d),
				_y = y + lengthdir_y(_l, _d);
				
			projectile_create(_x, _y, LHBouncer, _d, 3);
			scrFX(_x, _y, [_d, 2], Smoke);
			
			sound_play_hit(sndBouncerSmg, 0.2);
			motion_add(gunangle + 180, 2);
		}
		
		 // Wander:
		else if(chance(1, 3)){
			scrWalk(random(360), [30, 70]);
			scrAim(direction);
		}
	}
	
	else{
		scrWalk(direction + orandom(60), [40, 70]);
		scrAim(direction);
	}
	
#define BabyGator_draw
	var _angle = image_angle + ((right * (current_frame * current_time_scale) * 12) * (z > 0));
	if(gunangle >  180) draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * right, image_yscale, _angle, image_blend, image_alpha);
	draw_weapon(spr_weap, x, y - z, gunangle, 0, wkick, right, image_blend, image_alpha);
	if(gunangle <= 180) draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * right, image_yscale, _angle, image_blend, image_alpha);

#define BabyGator_hurt(_hitdmg, _hitvel, _hitdir)
	 // Kick:
	if(speed > 0){
		zspeed = 3;
		zbounce = 1;
	}

	 // Hurt:
	enemy_hurt(_hitdmg, _hitvel, _hitdir);
	
	 // Effects:
	scrFX(x, (y - z), [_hitdir, 1], Smoke);
	
#define BabyGator_death
	sound_play_pitch(snd_hurt, 1.3 + random(0.3));
	snd_hurt = -1;
	
	 // Pickups:
	pickup_drop(20, 0);

	 // Height Corpse:
	if(place_free(x, y - (z / 2))){
		y -= z / 2;
		vspeed += z / 5;
		speed /= max(1, z / 10);
	}

#define Bat_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle   = spr.BatIdle;
		spr_walk   = spr.BatWalk;
		spr_hurt   = spr.BatHurt;
		spr_dead   = spr.BatDead;
		spr_fire   = spr.BatYell;
		spr_weap   = spr.BatWeap;
		spr_shadow = shd48;
		hitid      = [spr_idle, "BAT"];
		depth      = -2;
		
		 // Sound:
		snd_hurt = sndSuperFireballerHurt;
		snd_dead = sndFrogEggDead;
		
		 // Vars:
		mask_index = mskScorpion;
		maxhealth  = 30;
		raddrop    = 12;
		size       = 2;
		walk       = 0;
		scream     = 0;
		stress     = 20;
		walkspeed  = 0.8;
		maxspeed   = 2.5;
		gunangle   = random(360);
		direction  = gunangle;
		canfire    = false;
		
		 // Alarms:
		alarm1 = 60;
		alarm2 = 120;
		
		return id;
	}
	
#define Bat_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Bounce:
	if(speed > 0){
		if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
			if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
			if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
		}
	}
	
	 // Animate:
	if(sprite_index != spr_fire || anim_end){
		sprite_index = enemy_sprite;
	}
	
#define Bat_draw
	if(gunangle >  180) draw_self_enemy();
	draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
	if(gunangle <= 180) draw_self_enemy();
	
#define Bat_alrm1
	alarm1 = 20 + irandom(30);
	
	enemy_target(x, y);
	
	if(canfire){
		 // Sounds:
		sound_play_pitchvol(sndRustyRevolver, 0.8, 0.7);
		sound_play_pitchvol(sndSnowTankShoot, 1.2, 0.6);
		sound_play_pitchvol(sndFrogEggHurt, 1 + random(0.4), 3.5);
		
		 // Bullets:
		var	_dis = 4,
			_spd = 2;
			
		for(var i = 0; i <= 5; i++){
			with(projectile_create(x, y, "VenomPellet", gunangle + orandom(2 + i), _spd * i)){
				move_contact_solid(direction, _dis + (_dis * i));
				
				 // Effects:
				with(scrFX(x, y, [direction + orandom(4), speed * 0.8], AcidStreak)){
					image_angle = direction;
				}
				
				if(i <= 2){
					scrFX(x, y, [direction + orandom(8 * i), (4 - i)], Smoke);
				}
			}
		}
		
		 // Effects:
		wkick += 7;
		with(scrFX(x, y, [gunangle + (130 * choose(-1, 1)) + orandom(20),  5], Shell)){
			sprite_index = sprShotShell;
		}
		
		canfire = false;
	}
	
	else{
		if(instance_seen(x, y, target)){
			scrAim(point_direction(x, y, target.x, target.y));
			
			 // Walk to target:
			if(!instance_near(x, y, target, 75)){
				if(chance(4, 5)){
					scrWalk(gunangle + orandom(8), [15, 35]);
				}
			}
			
			 // Walk away from target:
			else if(instance_near(x, y, target, 50)){
				scrWalk(gunangle + 180 + orandom(12), [10, 15]);
				alarm1 = walk;
			}
			
			 // Attack target:
			if(chance(2, 5) && instance_near(x, y, target, [50, 200])){
				alarm1 = 10;
				canfire = true;
				instance_create(x + (4 * right), y, AssassinNotice);

				 // Sounds:
				sound_play_hit(sndShotReload, 0.2);
			}
			
			 // Screech:
			else{
				if irandom(stress) >= 15{
					stress -= 8;
					scrBatScreech();
					
					 // Fewer mass screeches:
					with(instances_matching(object_index, "name", name)){
						stress = max(stress - 4, 10);
					}
				}
				
				 // Build up stress:
				else stress += 4;
			}
		}
		
		else{
			 // Follow nearest ally:
			var c = instance_nearest_array(x, y, instances_matching(CustomEnemy, "name", "Cat", "CatBoss", "BatBoss"));
			if(instance_seen(x, y, c) && !instance_near(x, y, c, 64)){
				scrWalk(point_direction(x, y, c.x, c.y) + orandom(8), [15, 35]);
			}
			
			 // Wander:
			else if(chance(1, 3)){
				scrWalk(direction + orandom(24), [10, 30]);
			}
			
			scrAim(direction);
		}
	}
	
	
#define Bat_hurt(_hitdmg, _hitvel, _hitdir)
	 // Get hurt:
	if(!instance_is(other, ToxicGas)){
		stress += _hitdmg;
		enemy_hurt(_hitdmg, _hitvel, _hitdir);
	}
	
	 // Screech:
	else{
		stress -= 4;
		nexthurt = current_frame + 5;
		
		scrBatScreech(0.5);
	}
	
#define Bat_death
	sound_play_pitch(sndScorpionFireStart, 1.2);
	pickup_drop(60, 5, 0);
	//pickup_drop(0, 100, 1);
	
#define scrBatScreech /// scrBatScreech(?_scale = undefined)
	var _scale = argument_count > 0 ? argument[0] : undefined;
	
	 // Effects:
	sound_play_pitchvol(sndNothing2Hurt, 1.4 + random(0.2), 0.7);
	sound_play_pitchvol(sndSnowTankShoot, 0.8 + random(0.4), 0.5);
	
	view_shake_at(x, y, 16);
	sleep(40);
	
	 // Alert nearest cat:
	with(instance_nearest_array(x, y, instances_matching(CustomEnemy, "name", "Cat"))){
		cantravel = true;
	}
	
	 // Screech:
	with(projectile_create(x, y, "BatScreech", 0, 0)){
		if(!is_undefined(_scale)){
			image_xscale = _scale;
			image_yscale = _scale;
		}
	}
	sprite_index = spr_fire;
	image_index = 0;
	
	
#define BatBoss_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
		 // For Sani's bosshudredux:
		bossname = "BIG BAT";
		col      = c_green;
		
		 // Visual:
		spr_idle     = spr.BatBossIdle;
		spr_walk     = spr.BatBossWalk;
		spr_hurt     = spr.BatBossHurt;
		spr_dead     = spr.BatBossDead;
		spr_fire     = spr.BatBossYell;
		spr_weap     = spr.BatBossWeap;
		spr_shadow   = shd64;
		spr_shadow_y = 12;
		hitid        = [spr_idle, "BIG BAT"];
		depth        = -2;
		
		 // Sound:
		snd_hurt = sndMutant10Hurt;
		snd_dead = sndMutant10Dead;
		snd_lowh = sndNothing2HalfHP;
		
		 // Vars:
		mask_index  = mskBanditBoss;
		friction    = 0.01;
		maxhealth   = boss_hp(200);
		raddrop     = 24;
		size        = 3;
		walk        = 0;
		scream      = 0;
		stress      = 20;
		walkspeed   = 0.8;
		maxspeed    = 3;
		intro       = false;
		tauntdelay  = 60;
		gunangle    = random(360);
		direction   = gunangle;
		active      = true;
		cloud       = [];
		cloud_blend = 0;
		
		 // Alarms:
		alarm0 = 6;
		alarm1 = 60;
		alarm2 = -1;
		
		return id;
	}
	
#define BatBoss_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Disabled:
	if(!active){
		mask_index = mskNone;
		visible    = false;
		canfly     = true;
		
		 // hello i am bat:
		var _bat = instances_matching(instances_matching(CustomEnemy, "name", "Bat"), "creator", id);
		with(instance_nearest_array(x, y, _bat)){
			other.x        = x;
			other.y        = y;
			other.right    = right;
			other.gunangle = gunangle;
		}
		
		 // Reappear:
		if(
			array_length(_bat) <= 1  &&
			array_length(cloud) <= 0 &&
			array_length(instances_matching(CustomObject, "name", "BatCloud")) <= 0
		){
			alarm2 = 20;
			for(var i = 0; i < 3; i++){
				array_push(cloud, { y_add: 1.2, delay: 5 * i });
			}
			
			 // Make any remaining bats unkillable:
			with(_bat){
				my_health = 9999;
			}
		}
	}
	
	 // Death Taunt:
	if(tauntdelay > 0 && !instance_exists(Player)){
		tauntdelay -= current_time_scale;
		if(tauntdelay <= 0){
			sound_play_pitchvol(sndMutant10KillBigBandit, 0.7 + orandom(0.05), 1);
		}
	}
	
	 // Morph Cloud:
	if(array_length(cloud) > 0){
		walk  = 0;
		speed = 0;
		
		var	_w  = (active ? 24 : 16),
			_h  = (active ? 32 : 20),
			_x1 = x - (_w / 2),
			_y1 = y - (_h / 2),
			_x2 = x + (_w / 2),
			_y2 = y + (_h / 2);
			
		with(cloud){
			if("y"     not in self) y     = 0;
			if("y_add" not in self) y_add = 1.5;
			if("delay" not in self) delay = 0;
			if("right" not in self) right = choose(-1, 1);
			
			if(delay > 0) delay -= current_time_scale;
			else{
				var	_y = _y1 + y,
					_o = (_y / 2),
					_x = other.x + (cos(_o) * ((_w / 2) * right));
					
				 // Visual:
				var _depth = other.depth + ((sin(_o) < 0) ? -1 : 1);
				repeat(3) with(scrFX([_x, 4], [_y, 4], 0, Dust)){
					image_blend = c_black;
					depth       = _depth;
				}
				
				 // End:
				y += y_add * current_time_scale;
				if(y >= _h){
					with(other){
						cloud = array_delete_value(cloud, other);
					}
				}
			}
		}
		
		 // Morphing:
		if(active){
			cloud_blend += 0.05 * current_time_scale;
			cloud_blend = clamp(cloud_blend, 0, 1);
		}
		
		 // Morphing Back:
		else{
			with(instances_matching(instances_matching(CustomEnemy, "name", "Bat"), "creator", id)){
				walk        = 0;
				speed       = 0;
				alarm1      = 20 + random(20);
				image_blend = merge_color(image_blend, c_black, 0.1 * current_time_scale);
			}
			with(instances_matching(instances_matching(CustomObject, "name", "BatCloud"), "creator", id)){
				instance_destroy();
			}
		}
	}
	else cloud_blend = 0;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	if(walk <= 0){
		speed = min(speed, maxspeed / 2);
	}
	
	 // Bounce:
	if(speed > 0){
		if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
			if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
			if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
		}
	}
	
	 // Animate:
	if(sprite_index != spr_fire || anim_end){
		sprite_index = enemy_sprite;
	}
	
#define BatBoss_draw
	 // Cloudin:
	var _blend = image_blend;
	image_blend = merge_color(image_blend, c_black, cloud_blend);
	
	 // Self:
	var h = (sprite_index != spr_hurt && nexthurt > current_frame + 3);
	if(h) draw_set_fog(true, _blend, 0, 0);
	
	if(gunangle >  180) draw_self_enemy();
	draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
	if(gunangle <= 180) draw_self_enemy();
	
	if(h) draw_set_fog(false, 0, 0, 0);
	
	image_blend = _blend;
	
	//draw_text_nt(x, y - 30, string(charge) + "/" + string(max_charge) + "(" + string(charged) + ")");
	
#define BatBoss_alrm0
	intro = true;
	boss_intro("CatBat");
	sound_play(sndScorpionFireStart);
	
	 // Disable Bros:
	with(instances_matching_gt(instances_matching(CustomEnemy, "name", "BatBoss", "CatBoss"), "alarm0", 0)){
		intro = true;
		alarm0 = -1;
	}
	
#define BatBoss_alrm1
	alarm1 = 20 + random(20);
	with(instances_matching_le(instances_matching(CustomEnemy, "name", "CatBoss"), "supertime", 0)){
		alarm1 = 20 + random(20);
		other.alarm1 += alarm1;
	}
	
	if(active){
		if(enemy_target(x, y)){
			if(instance_seen(x, y, target) && instance_near(x, y, target, 240)){
				scrAim(point_direction(x, y, target.x, target.y));
				
				 // Move Away:
				if(chance(1, 5)){
					scrWalk(gunangle + 180 + (irandom_range(25, 45) * right), [20, 35]);
					
					 // Bat Morph:
					if(chance(1, 8) && !chance(maxhealth, my_health)){
						alarm2 = 24;
						for(var i = 0; i < 3; i++){
							array_push(cloud, { delay: 8 * i });
						}
					}
				}
				
				 // Screech:
				if(chance(1, 3)){
					if(irandom(stress) >= 15){
						stress -= 8;
						scrBatBossScreech();
					}
					else stress += 4;
				}
				
				 // Flak Time:
				else{
					wkick -= 4;
					projectile_create(x, y, "VenomFlak", gunangle + orandom(10), 12);
				}
			}
			
			else{
				 // Follow Cat Boss:
				var c = instance_nearest_array(x, y, instances_matching(CustomEnemy, "name", "CatBoss"));
				if(instance_seen(x, y, c) && !instance_near(x, y, c, 64)){
					scrWalk(point_direction(x, y, c.x, c.y) + orandom(8), [15, 35]);
				}
				
				 // Wander:
				else if(chance(2, 3)){
					scrWalk(direction + orandom(24), [10, 30]);
				}
				
				 // Bat Morph:
				else{
					alarm2 = 24;
					for(var i = 0; i < 3; i++){
						array_push(cloud, { delay: 8 * i });
					}
				}
				
				scrAim(direction);
			}
		}
		
		 // Wander:
		else{
			alarm1 = 45 + random(60);
			scrWalk(random(360), 5);
			scrAim(direction);
		}
	}
	
	 // More Aggressive Bats:
	else with(instances_matching(instances_matching(CustomEnemy, "name", "Bat"), "creator", id)){
		alarm1 = ceil(alarm1 / 2);
		
		if(enemy_target(x, y)){
			if(instance_seen(x, y, target) && instance_near(x, y, target, 128)){
				scrWalk(point_direction(x, y, target.x, target.y), alarm1);
				scrAim(direction);
			}
			
			 // Zoom Ovah:
			else if(chance(1, 3)){
				with(obj_create(x, y + 16, "BatCloud")){
					target    = other.target;
					creator   = other.creator;
					my_health = other.my_health;
					direction = 90 + orandom(20);
				}
				
				 // Effects:
				sound_play_pitchvol(sndBloodHammer, 1.4 + random(0.2), 0.5);
				repeat(10){
					with(scrFX([x, 8], [y, 8], random(3), Smoke)){
						image_blend = c_black;
					}
				}
				
				instance_delete(id);
			}
		}
	}
	
#define BatBoss_alrm2
	enemy_target(x, y);
	cloud = [];
	
	 // Disappear:
	if(active){
		active = false;
		
		 // Turnin Into Bats:
		var _ang = random(360);
		for(var _d = _ang; _d < _ang + 360; _d += (360 / (3 + (2 * GameCont.loops)))){
			var _l = 8;
			with(obj_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "BatCloud")){
				target        = other.target;
				target_offdir = _d;
				creator       = other;
				direction     = _d;
			}
		}
		
		 // Sound:
		sound_play_pitchvol(sndBloodHurt, 0.7 + random(0.2), 0.8);
	}
	
	 // Reappear:
	else{
		active = true;
		
		alarm1 += 30;
		mask_index = mskBanditBoss;
		visible = true;
		canfly = false;
		instance_create(x, y, PortalClear);
		
		 // Poof:
		with(instances_matching(instances_matching(CustomEnemy, "name", "Bat"), "creator", id)){
			repeat(8) with(scrFX(x, y, 3, Dust)){
				image_blend = c_black;
			}
			instance_delete(id);
		}
		with(instances_matching(instances_matching(CustomObject, "name", "BatCloud"), "creator", id)){
			instance_delete(id);
		}
		
		 // Effects:
		sound_play_pitchvol(sndBloodHammer, 0.5 + random(0.2), 0.8);
	}
	
	 // Effects:
	with(instances_meeting(x, y, Dust)){
		if(chance(1, 3)) with(scrFX(x, y, [point_direction(other.x, other.y, x, y), random_range(1.5, 2)], Smoke)){
			image_blend = c_black;
			depth = -7;
		}
	}
	
#define BatBoss_hurt(_hitdmg, _hitvel, _hitdir)
	 // Get hurt:
	if(!instance_is(other, ToxicGas)){
		stress += _hitdmg;
		enemy_hurt(_hitdmg, _hitvel, _hitdir);
		
		 // Pitch Hurt:
		if(snd_hurt == sndMutant10Hurt){
			audio_sound_set_track_position(
				sound_play_hit_ext(snd_hurt, 0.6 + random(0.2), 1),
				0.07
			);
			sound_play_hit_ext(sndHitFlesh, 1 + orandom(0.3), 1.4);
		}
		
		 // Half HP:
		var h = (maxhealth / 2);
		if(in_range(my_health, h - _hitdmg + 1, h)){
			if(snd_lowh == sndNothing2HalfHP){
				sound_play_pitch(sndNothing2HalfHP, 1.3);
			}
			else sound_play(snd_lowh);
			
			 // Biggo Screech:
			scrBatBossScreech(5);
		}
	}
	
	 // Screech:
	else{
		stress -= 4;
		nexthurt = current_frame + 5;
		
		scrBatBossScreech(1);
	}
	
#define BatBoss_death
	instance_create(x, y, PortalClear);
	
	 // Die:
	with(instances_matching(instances_matching(CustomEnemy, "name", "Bat"), "creator", id)){
		my_health = 0;
	}
	
	 // Pitch Death:
	if(snd_dead == sndMutant10Dead){
		sound_play_hit_ext(snd_dead, 0.55 + random(0.1), 1.5);
	}
	
	 // Pickups:
	repeat(2){
		pickup_drop(100, 0);
	}
	
	 // Buff Partner:
	var _partner = instances_matching(CustomEnemy, "name", "CatBoss");
	if(array_length(_partner) > 0) with(_partner){
		var _heal = ceil(maxhealth / 4);
		maxhealth += _heal;
		
		 // Rad Heals:
		with(other){
			 // Rads:
			var	_num = min(raddrop, 24),
				_rad = rad_drop(x, y, _num, direction, speed);
				
			raddrop -= _num;
			with(_rad){
				alarm0 /= 3;
				direction = random(360);
				speed = max(2, speed);
				image_index = 1;
				depth = -3;
			}
			
			 // Partner Sucks Up Rads:
			with(rad_path(_rad, other)){
				heal = ceil(_heal / array_length(_rad));
			}
		}
	}
	
	 // Boss Win Music:
	else with(MusCont) alarm_set(1, 1);
	
#define scrBatBossScreech /// scrBatBossScreech(_extraNum = 3, _extraScale = 0.5)
	var _extraNum = argument_count > 0 ? argument[0] : 3;
var _extraScale = argument_count > 1 ? argument[1] : 0.5;
	
	 // Effects:
	sound_play_pitchvol(sndNothing2Hurt, 1.4 + random(0.2), 0.7);
	sound_play_pitchvol(sndSnowTankShoot, 0.8 + random(0.4), 0.5);
	
	view_shake_at(x, y, 16);
	sleep(40);
	
	 // Alert nearest cat:
	with(instance_nearest_array(x, y, instances_matching(CustomEnemy, "name", "Cat"))){
		cantravel = true;
	}
	
	 // Screech:
	projectile_create(x, y, "BatScreech", 0, 0);
	if(_extraNum > 0){
		var _l = 56;
		for(var _d = gunangle; _d < gunangle + 360; _d += (360 / _extraNum)){
			with(projectile_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "BatScreech", 0, 0)){
				image_xscale = _extraScale;
				image_yscale = _extraScale;
			}
		}
	}
	sprite_index = spr_fire;
	image_index  = 0;
	
	
#define BatCloud_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		image_blend = c_black;
		depth       = -9;
		
		 // Vars:
		friction      = 0.5;
		direction     = random(360);
		speed         = 16;
		creator       = noone;
		target        = noone;
		target_offdis = 32;
		target_offdir = random(360);

		return id;
	}

#define BatCloud_step
	if(speed > 6) speed -= 2 * current_time_scale;
	
	if(current_frame_active){
		 // Visual:
		repeat(4) with(scrFX([x, 4], [y, 4], 0, Dust)){
			image_blend = other.image_blend;
			depth       = other.depth;
		}
		
		 // Wobblin:
		direction += orandom(16);
	}
	
	if(instance_exists(target)){
		 // Get Landing Position:
		var	_dis = target_offdis,
			_dir = target_offdir;
			
		do{
			var	_tx = target.x + lengthdir_x(_dis, _dir),
				_ty = target.y + lengthdir_y(_dis, _dir);
				
			_dis -= 8;
		}
		until (_dis <= 0 || (!position_meeting(_tx, _ty, Wall) && position_meeting(_tx, _ty, Floor)));
		
		 // Moving:
		var	_dis = point_distance(x, y, _tx, _ty),
			_dir = point_direction(x, y, _tx, _ty);
			
		if(speed < 8){
			if(_dis > 96){
				_dir = point_direction(x, y, _tx, _ty - 96);
			}
			motion_add_ct(_dir, random_range(1, 4));
		}
		
		 // Land:
		if(_dis < 8) instance_destroy();
	}
	else instance_destroy();
	
#define BatCloud_destroy
	instance_create(x, y, PortalClear);
	with(obj_create(x, y, "Bat")){
		x = xstart;
		y = ystart;
		motion_add(other.direction, 4);
		nexthurt = current_frame + 12;
		creator = other.creator;
		kills = 0;
		
		 // Save HP:
		if("my_health" in other){
			my_health = other.my_health;
		}
		
		 // Aim:
		if(instance_exists(other.target)){
			scrAim(point_direction(x, y, other.target.x, other.target.y));
		}
		
		 // Effects:
		var _col = other.image_blend;
		for(var _dir = 0; _dir < 360; _dir += (360 / 12)){
			with(scrFX(x, y + 6, [_dir, 2], Smoke)){
				motion_add(other.direction, 1);
				image_blend = _col;
				growspeed  *= -10;
				depth       = -3;
			}
		}
	}
	
	 // Effects:
	sound_play_pitchvol(sndBouncerSmg,  0.2 + random(0.2), 0.6);
	sound_play_pitchvol(sndBloodHammer, 1.6 + random(0.4), 0.4);


#define BatDisc_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.BatDisc;
		mask_index   = mskFlakBullet;
		depth        = -2;
		
		 // Vars:
		friction  = 0.4;
		maxspeed  = 12;
		damage    = 3;
		typ       = 2;
		setup     = true;
		wep       = noone;
		ammo      = 1;
		has_hit   = false;
		returning = false;
		return_to = noone;
		big       = false;
		key       = "";
		seek      = 40;
		in_wall   = false;
		speed     = maxspeed;
		
		return id;
	}
	
#define BatDisc_setup
	setup = false;
	
	 // Big:
	if(big){
		 // Visual:
		sprite_index = spr.BatDiscBig;
		mask_index = mskSuperFlakBullet;
		
		 // Vars:
		damage = 8;
		seek = 64;
		
		 // Explodo Timer:
		alarm0 = 30;
	}
	
#define BatDisc_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Clamp Speed:
	speed = min(speed, maxspeed);
	
	 // Spin:
	image_angle += 40 * current_time_scale;
	
	 // Targeting:
	var	_disMax = infinity,
		_wepVar = ["wep", "bwep"];
		
	for(var i = 0; i < array_length(_wepVar); i++){
		with(instances_matching([Player, WepPickup, ThrownWep], _wepVar[i], wep)){
			var _dis = point_distance(x, y, other.x, other.y);
			if(_dis < _disMax){
				_disMax = _dis;
				other.return_to = id;
			}
		}
	}
	if(!instance_exists(return_to)) return_to = creator;
	
	 // Effects:
	if(in_wall){
		if(current_frame_active){
			view_shake_max_at(x, y, 4);
		}
		
		 // Dust trail:
		if(chance_ct(1, 3)){
			with(instance_create(x, y, Dust)){
				depth = -7;
			}
		}
		
		 // Exit wall:
		if(place_meeting(x, y, Floor) && !place_meeting(x, y, Wall)){
			in_wall = false;
			
			 // Effects:
			var d = direction;
			
			with(instance_create(x, y, Debris)) motion_set(d + orandom(40), 4 + random(4));
			instance_create(x, y, Smoke);
		}
		
		 // Be invisible inside walls:
		if(place_meeting(x, y, TopSmall) || !place_meeting(x, y, Floor)){
			visible = false;
		}
		else visible = true;
	}
	
	else{
		 // Baseball:
		if(place_meeting(x, y, projectile)){
			var _inst = instances_meeting(x, y, [Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, CustomSlash]);
			if(array_length(_inst) > 0) with(_inst){
				if(place_meeting(x, y, other)){
					with(other){
						var	_lastAlrm = alarm1,
							_lastFric = friction,
							_lastSpd  = speed;
							
						with(other){
							event_perform(ev_collision, Grenade);
							if(!instance_exists(other)) exit;
						}
						
						alarm1 = _lastAlrm;
						friction = _lastFric;
						if(speed != _lastSpd) speed = max(_lastSpd, 16);
					}
				}
			}
		}
		 
		 // Disc trail:
		if(current_frame_active){
			with(instance_create(x, y, DiscTrail)){
				sprite_index = (other.big ? spr.BigDiscTrail : sprDiscTrail);
			}
		}
	}
	
	 // Bolt Marrow:
	var	_seekInst = noone,
		_seekDis = (seek * skill_get(mut_bolt_marrow));
		
	if(_seekDis > 0 && instance_near(x, y, creator, 160)){
		with(instances_matching_ne(instances_matching_ne(hitme, "team", team, 0), "mask_index", mskNone, sprVoid)){
			if(!instance_is(self, prop)){
				var _dis = point_distance(x, y, other.x, other.y);
				if(_dis < _seekDis){
					_seekDis = _dis;
					_seekInst = id;
				}
			}
		}
	}
	if(instance_exists(_seekInst)){
		image_index = 1;
		
		 // Homin'
		speed = max(speed - friction_raw, 0);
		motion_add_ct(point_direction(x, y, _seekInst.x, _seekInst.y), 1);
	}
	
	 // Return Home:
	else{
		image_index = 0;
		
		if(returning){
			var	_tx = (instance_exists(return_to) ? return_to.x : xstart),
				_ty = (instance_exists(return_to) ? return_to.y : ystart);
				
			 // Returning:
			if(
				instance_exists(return_to)
				? (distance_to_object(return_to) > 0)
				: (point_distance(x, y, _tx, _ty) > speed_raw)
			){
				var _speed = friction * 2;
				
				 // Slow Near Destination:
				if(point_distance(x, y, _tx, _ty) < 32){
					_speed = 2;
					speed = max(0, speed - (0.8 * current_time_scale));
				}
				
				motion_add_ct(point_direction(x, y, _tx, _ty), _speed);
			}
			
			 // Returned:
			else{
				var	_wep = wep,
					_dir = direction;
					
				with(instance_exists(return_to) ? return_to : self){
					 // Epic:
					if("gunangle" in self){
						var _kick = 6 * sign(angle_difference(_dir, gunangle + 90));
						if("wkick" in self && variable_instance_get(self, "wep") == _wep){
							wkick  = _kick;
						}
						if("bwkick" in self && variable_instance_get(self, "bwep") == _wep){
							bwkick  = _kick;
						}
					}
					
					 // Effects:
					view_shake_max_at(x, y, 12);
					if(friction > 0) motion_add(_dir, 2);
					sound_play_hit_ext(sndDiscgun,     0.8 + random(0.4), 0.6);
					sound_play_hit_ext(sndCrossReload, 0.6 + random(0.4), 0.8);
				}
				
				instance_destroy();
			}
		}
		
		 // Return when slow:
		else if(!big && speed <= 5){
			returning = true;
		}
	}
	
#define BatDisc_end_step
	if(setup) BatDisc_setup();
	
	 // Go through walls:
	if(returning && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
		if(place_meeting(x + hspeed_raw, y, Wall)) x += hspeed_raw;
		if(place_meeting(x, y + vspeed_raw, Wall)) y += vspeed_raw;
	}
	
	 // Unstick:
	if(x == xprevious && hspeed_raw != 0) x += hspeed_raw;
	if(y == yprevious && vspeed_raw != 0) y += vspeed_raw;
	
#define BatDisc_alrm0
	 // Projectiles:
	for(var _dir = direction; _dir < direction + 360; _dir += (360 / 7)){
		with(projectile_create(x, y, "BatDisc", _dir, 0)){
			visible = other.visible;
			in_wall = other.in_wall;
			wep     = other.wep;
			ammo   *= sign(other.ammo);
		}
		
		 // Effects:
		repeat(irandom_range(1, 2)){
			with(scrFX(x, y, random(6), Smoke)){
				if(other.in_wall){
					depth = -7;
					speed /= 2;
				}
			}
		}
	}
	
	 // Effects:
	view_shake_at(x, y, 20);
	sound_play_pitch(sndClusterLauncher, 0.8 + random(0.4));
	
	 // Goodbye:
	ammo = 0;
	instance_destroy();
	
#define BatDisc_hit
	if(projectile_canhit(other)){
		projectile_hit_raw(other, damage, sndDiscHit);
		
		has_hit = true;
		
		 // Effects:
		instance_create(x, y, Smoke);
		
		var _big = ((instance_exists(other) && other.size >= 3 && big));
		
		view_shake_max_at(x, y, (_big ? 12 : 6));
		
		if(!instance_exists(other) || other.my_health <= 0){
			sleep_max(_big ? 48 : 24);
			view_shake_max_at(x, y, (_big ? 32 : 16))
		}
	}
	
#define BatDisc_wall
	if(!returning && !has_hit && instance_exists(return_to)){
		if(!big) returning = true;
		
		 // Bounce towards creator:
		direction = point_direction(x, y, return_to.x, return_to.y);
		
		 // Effects:
		sound_play_hit(sndDiscBounce, 0.4);
		with(instance_create(x + hspeed, y + vspeed, MeleeHitWall)){
			image_angle = other.direction;
		}
	}
	
	 // Enter Wall:
	else if(!in_wall){
		in_wall = true;
		
		 // Effects:
		instance_create(x, y, Smoke);
		view_shake_max_at(x, y, 8);
		sleep_max(8);
		
		 // Sounds:
		sound_play_hit(sndPillarBreak, 0.4);
		sound_play_hit(sndDiscHit, 0.4);
	}
	
#define BatDisc_destroy
	 // Effects:
	with(instance_create(x, y, DiscDisappear)){
		sprite_index = (other.big ? spr.BigDiscTrail : sprDiscTrail);
	}
	with(scrFX(x, y, [direction, 3], Smoke)){
		growspeed /= 2;
	}
	
#define BatDisc_cleanup
	 // Hold up:
	with(instances_matching(Player, "wep", wep)){
		can_shoot = false;
	}
	with(instances_matching(Player, "bwep", wep)){
		bcan_shoot = false;
	}
	
	 // Restore:
	with(wep){
		ammo += other.ammo;
		if("amax" in self){
			ammo = min(ammo, amax);
		}
	}
	
	
#define BatScreech_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.BatScreech;
		image_speed  = 0.4;
		image_alpha  = 0.4;
		depth        = -9;
		hitid        = [sprite_index, "SOUND"];
		
		 // Vars:
		mask_index = msk.BatScreech;
		typ        = 0;
		team       = 1;
		force      = 1;
		damage     = 0;
		creator    = noone;
		candeflect = false;
		//can_effect = true;
		
		/*
		 // Effects:
		repeat(12 + irandom(6)){
			scrFX(x, y, 4 + random(4), Dust);
		}
		*/
		
		return id;
	}
	
/*#define BatScreech_step
	if(can_effect && chance(1, 3)){
		var l = random(min((sprite_width * image_xscale), (sprite_height * image_yscale)) / 2),
			d = random(360);
		with(scrFX(x + lengthdir_x(l, d), y + lengthdir_y(l, d), [d, 4], Dust)){
			friction = 0.4;
		}
	}
	*/
	
#define BatScreech_projectile
	if(instance_exists(self)){
		with(other){
			if(typ == 1 || typ == 2){
				 // Deflect:
				if(other.candeflect){
					deflected   = true;
					team        = other.team;
					direction   = point_direction(other.x, other.y, x, y);
					image_angle = direction;
					
					 // Effects:
					with(instance_create(x, y, Deflect)){
						image_angle = other.image_angle;
					}
				}
				
				 // Destroy:
				else{
					if(instance_is(self, ToxicGas)){
						with(instance_create(x, y, BulletHit)){
							sprite_index = sprExploderExplo;
							image_index = 2;
						}
					}
					else{
						repeat(2) with(instance_create(x, y, Dust)){
							motion_set(other.direction + orandom(8), irandom(min(8, other.speed)));
							friction = 0.4;
						}
						instance_create(x, y, ThrowHit);
					}
					instance_destroy();
				}
			}
		}
	}
	
#define BatScreech_grenade
	if(instance_exists(self)){
		 // Deflect:
		if(candeflect){
			with(other){
				deflected = true;
				direction = point_direction(other.x, other.y, x, y);
				speed     = 10;
				friction  = 0.1;
				alarm1    = 6;
				
				 // Effects:
				with(instance_create(x, y, Deflect)){
					image_angle = other.direction;
				}
				view_shake_at(x, y, 3);
				sleep(10);
			}
		}
		
		 // Destroy:
		else if(team != other.team){
			BatScreech_projectile();
		}
	}
	
	
#define BatScreech_draw
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	draw_set_blend_mode(bm_normal);
	
#define BatScreech_hit
	 // Push Dudes Away:
	if(projectile_canhit(other)){
		with(other){
			motion_add(point_direction(other.x, other.y, x, y), other.force);
		}
		
		 // Damage?:
		if(damage > 0 && projectile_canhit_melee(other)){
			projectile_hit(other, damage);
		}
	}
	
	
#define BoneGator_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.BoneGatorIdle;
		spr_walk     = spr.BoneGatorWalk;
		spr_hurt     = spr.BoneGatorHurt;
		spr_dead     = spr.BoneGatorDead;
		spr_weap     = spr.BoneGatorWeap;
		sprite_index = spr_idle;
		spr_shadow   = shd24;
		hitid        = [spr_idle, "BONE GATOR"];
		
		 // Sounds:
		snd_hurt = sndGatorHit;
		snd_dead = sndGatorDie;
		
		 // Vars:
		mask_index = mskBandit;
		maxhealth  = 24;
		raddrop    = 6;
		size       = 2;
		walk       = 0;
		walkspeed  = 0.8;
		maxspeed   = 3.6;
		gunangle   = random(360);
		ammo       = 0;
		nextheal   = 0;
		
		 // Alarms:
		alarm1 = 30;
		
		return id;
	}
	
#define BoneGator_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Animate:
	sprite_index = enemy_sprite;
	
#define BoneGator_draw
	if(gunangle >  180) draw_self_enemy();
	draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
	if(gunangle <= 180) draw_self_enemy();
	
#define BoneGator_alrm1
	alarm1 = 20 + random(20);
	
	 // Fire:
	if(ammo > 0){
		ammo--;
		alarm1 = 4;
		
		 // Move Gun:
		if(enemy_target(x, y)){
			var _clamp = 20;
			scrAim(gunangle + clamp(angle_difference(point_direction(x, y, target.x, target.y), gunangle), -_clamp, _clamp) + orandom(5));
		}
		
		var	_x = x + lengthdir_x(6, gunangle),
			_y = y + lengthdir_y(6, gunangle);
		
		 // Cluster Nade Final Shot: 
		if(ammo <= 0){
			alarm1 = 20;
			
			with(projectile_create(_x, _y, Grenade, gunangle, 9)){
				alarm0 = 10 + random(10);
			}
			
			 // Effects:
			wkick = 12;
			view_shake_max_at(x, y, 12);
			motion_add(gunangle + 180, 4);
			sound_play_pitch(sndGrenadeShotgun, 0.8 + random(0.4));
			sound_play_pitch(sndFlamerStop, 0.8 + random(0.4));
		}
		
		 // Mini Nade Shots:
		else{
			projectile_create(_x, _y, MiniNade, gunangle, 7 + random(2));
			
			 // Effects:
			wkick = 6;
			view_shake_max_at(x, y, 6);
			motion_add(gunangle + 180, 1);
			sound_play_pitch(sndGrenadeRifle, 0.8 + random(0.4));
		}
		
		 // Shared Effects:
		with(projectile_create(_x, _y, TrapFire, gunangle, random(1))){
			image_speed = 0.4;
		}
		repeat(1 + irandom(2)) with(scrFlameSpark(_x, _y)) motion_set(other.gunangle + orandom(30), random(5));
		repeat(1 + irandom(2)) scrFX(_x, _y, [gunangle, random(4)], Smoke);
	}

	 // Normal Behavior:
	else if(enemy_target(x, y)){
		if(instance_seen(x, y, target)){
			scrAim(point_direction(x, y, target.x, target.y));
			
			if(instance_near(x, y, target, 192)){
				 // Attack:
				if(instance_near(x, y, target, 128) || chance(1, 5)){
					alarm1 = 12;
					ammo = 6;
					
					 // Warning:
					instance_create(x, y, AssassinNotice);
					sound_play_pitch(sndDragonStart, 0.8 + random(0.4));
				}
				
				 // Advance:
				else{
					scrWalk(gunangle + orandom(20), [30, 50]);
				}
				
				 // Retreat:
				if(instance_near(x, y, target, 32)){
					scrWalk((gunangle + 180) + orandom(30), [20, 50]);
				}
			}

			 // Chase:
			else scrWalk(gunangle + orandom(60), [20, 50]);
		}

		 // Wander:
		else if(chance(2, 5)){
			alarm1 += random(10);
			scrWalk(direction + orandom(40), [20, 40]);
			scrAim(direction);
		}
	}

#define BoneGator_hurt(_hitdmg, _hitvel, _hitdir)
	if(!instance_is(other, Explosion)){
		enemy_hurt(_hitdmg, _hitvel, _hitdir);
		sound_play_hit_ext(sndBloodHurt, 0.8 + orandom(0.2), 0.9);
	}

	 // Boiling Veins:
	else if(nextheal <= current_frame){
		my_health = min(my_health + 12, maxhealth);
		nextheal = current_frame + 8;
		
		with(instance_create(x, y, HealFX)){
			sprite_index = spr.BoneGatorHeal;
			depth = -8;
		}
		sound_play_hit(sndBurn, 0.2);
	}
	
#define BoneGator_death
	 // Explodin':
	sound_play(sndExplosionL);
	sound_play(sndFlameCannonEnd);
	instance_create(x, y, Explosion);
	repeat(1 + irandom(2)) instance_create(x, y, SmallExplosion);
	
	var _l = 12;
	for(var _d = 0; _d < 360; _d += (360 / 20)){
		var	_x = x + lengthdir_x(_l, _d),
			_y = y + lengthdir_y(_l, _d);
			
		if(position_meeting(_x, _y, Floor)){
			projectile_create(_x, _y, TrapFire, _d + random_range(60, 90), random(2));
		}
		with(scrFlameSpark(_x, _y)){
			motion_add(_d + random_range(30, 90), random(5));
		}
	}
	view_shake_at(x, y, 20);
	
	 // Pickups:
	pickup_drop(16, 0);
	if(chance(1, 40)){
		with(instance_create(x, y, WepPickup)){
			wep = "crabbone";
		}
	}
	
#define scrFlameSpark(_x, _y)
	with(instance_create(_x, _y, Sweat)){
		name = "FlameSpark";
		
		sprite_index = spr.FlameSpark;
		image_speed = 0.4;
		image_index = 0;
		
		return id;
	}
	
	
/*#define BossHealFX_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		image_blend = make_color_rgb(133, 249, 26);
		image_xscale = 1.2;
		image_yscale = image_xscale;
		image_speed = 0.4;
		depth = -12;
		
		 // Vars:
		mask_index = mskRad;
		target = noone;
		seek_speed = 0;
		wave = random(100);
		
		return id;
	}*/
	
/*#define BossHealFX_step
	if(!instance_exists(target)){
		instance_destroy();
		exit;
	}
	
	 // Effects:
	if(chance_ct(1, 6)) with(scrFX([x, 2], [y, 2], 0, EatRad)){
		sprite_index = choose(sprEatRadPlut, sprEatRadPlut, sprEatBigRadPlut);
		depth = -13;
	}
	
	 // Wavy:
	wave += current_time_scale;
	image_yscale += 0.5 * sin(wave * 2) * current_time_scale;
	
	 // Seek Target:
	if(distance_to_object(target) > 12){
		motion_add_ct(point_direction(x, y, target.x, target.y), seek_speed);
		speed = min(speed, 16);
		seek_speed += (0.2 * current_time_scale);
	}
	
	 // Collide:
	else if(chance_ct(1, 3)){
		sound_play_hit(sndHealthChestBig, 0.4);
		sound_play_pitchvol(sndToxicBarrelGas, 1.8 + random(0.6), 0.4 + random(0.4));
		
		with(scrFX(x, y, [direction + 180, 6], AcidStreak)) image_angle = direction;
		scrFX(x, y, [direction, 1], AcidStreak).sprite_index = spr.AcidPuff;
		
		repeat(2 + irandom(2)) with(scrFX([x, 8], [(y - 16), 8], 0, EatRad)){
			sprite_index = choose(sprEatRadPlut, sprEatRadPlut, sprEatBigRadPlut);
			depth = -13;
		}
		with(instance_create(x, y, HealFX)){
			sprite_index = spr.BossHealFX;
			image_speed = 0.5 + random(0.1);
			depth = -12;
		}
		
		instance_destroy();
	}*/
	
/*#define BossHealFX_end_step
	 // Trail:
	var	l = point_distance(x, y, xprevious, yprevious),
		d = point_direction(x, y, xprevious, yprevious);
		
	with(instance_create(x, y, BoltTrail)){
		depth = other.depth;
		image_blend = other.image_blend;
		image_yscale = other.image_yscale;
		image_xscale = l;
		image_angle = d;
	}*/
	
/*#define BossHealFX_draw
	draw_set_color(image_blend);
	draw_circle(x - 1, y - 1, image_yscale, false);*/
	
	
#define Cabinet_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.CabinetIdle;
		spr_hurt = spr.CabinetHurt;
		spr_dead = spr.CabinetDead;
		
		 // Sounds:
		snd_hurt = sndHitMetal;
		snd_dead = sndSodaMachineBreak;
		
		 // Vars:
		maxhealth = 20;
		size = 1;
		
		return id;
	}
	
#define Cabinet_death
	repeat(irandom_range(8, 16)){
		with(obj_create(x, y, "Paper")){
			motion_set(random(360), random_range(2, 8));
		}
	}
	
	
#define Cat_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		var _snow = (GameCont.area == area_city);
		
		 // Visual:
		spr_idle      = (_snow ?  spr.CatSnowIdle    : spr.CatIdle);
		spr_walk      = (_snow ?  spr.CatSnowWalk    : spr.CatWalk);
		spr_hurt      = (_snow ?  spr.CatSnowHurt    : spr.CatHurt);
		spr_dead      = (_snow ?  spr.CatSnowDead    : spr.CatDead);
		spr_sit1      = (_snow ?  spr.CatSnowSit1[0] : spr.CatSit1[0]);
		spr_sit2      = (_snow ?  spr.CatSnowSit2[0] : spr.CatSit2[0]);
		spr_sit1_side = (_snow ?  spr.CatSnowSit1[1] : spr.CatSit1[1]);
		spr_sit2_side = (_snow ?  spr.CatSnowSit2[1] : spr.CatSit2[1]);
		spr_weap      = spr.CatWeap;
		spr_shadow    = shd24;
		hitid         = [spr_idle, "CAT"];
		depth         = -2;
		
		 // Sound:
		snd_hurt = sndGatorHit;
		snd_dead = sndSalamanderDead;
		toxer_loop = -1;
		
		 // Vars:
		mask_index = mskRat;
		maxhealth  = 10;
		raddrop    = 6;
		size       = 1;
		walk       = 0;
		walkspeed  = 0.8;
		maxspeed   = 3;
		hole       = noone;
		ammo       = 0;
		active     = true;
		cantravel  = false;
		gunangle   = random(360);
		direction  = gunangle;
		sit        = false;
		sit_side   = 0;
		
		 // Alarms:
		alarm1 = 40 + irandom(20);
		alarm2 = 40 + irandom(20);
		
		 // Sittin:
		with(array_shuffle(array_combine(instances_matching(CustomProp, "name", "ChairFront", "ChairSide", "Couch"), instances_matching(chestprop, "", null)))){
			if(instance_seen(x, y, other) || chance(1, 2)){
				if(array_length(instances_matching(instances_matching(CustomEnemy, "name", "Cat"), "sit", id)) <= 0){
					other.sit = id;
					break;
				}
			}
		}
		
		return id;
	}

#define Cat_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Active:
	if(active){
		 // Sitting:
		if(sit){
			walk  = 0;
			speed = 0;
			
			 // Animate:
			if(sprite_index == spr_sit2 || sprite_index == spr_sit2_side){
				if(image_index < 1){
					image_index = max(0, image_index - (image_speed_raw * random_range(0.96, 1)));
				}
			}
			else{
				if(sprite_index == spr_sit1 || sprite_index == spr_sit1_side){
					if(anim_end){
						if(sprite_index == spr_sit1) sprite_index = spr_sit2;
						else sprite_index = spr_sit2_side;
						image_index = 0;
					}
				}
				else{
					sprite_index = spr_sit1_side;
					if(array_exists(["ChairFront", "Couch"], variable_instance_get(sit, "name")) || instance_is(sit, VenuzCouch)){
						sprite_index = spr_sit1;
					}
					image_index = 0;
				}
			}
			
			 // Sittin:
			if(instance_exists(sit)){
				if(instance_is(sit, enemy)){
					x = sit.x;
					y = sit.y;
					xprevious = x;
					yprevious = y;
					sit.alarm1 = max(sit.alarm1, 30);
				}
				else{
					x = sit.x;
					y = sit.y - 5;
					xprevious = x;
					yprevious = y + 6;
					right = -sit.image_xscale;
				}
			}
			else if(sit >= 100000){
				sit = false;
			}
		}
		
		 // Normal:
		else{
			 // Movement:
			enemy_walk(walkspeed, maxspeed);
			
			 // Animation:
			sprite_index = enemy_sprite;
		}
	}
	
	 // Disabled:
	else{
		x       = 0;
		y       = 0;
		visible = false;
		canfly  = true;
		walk    = 0;
	}
	
#define Cat_draw
	if(sit){
		if(instance_exists(sit) && !object_exists(sit)){
			if(instance_is(sit, prop)){
				y += 2;
				draw_self_enemy();
				y -= 2;
			}
			else{
				var	_x = x,
					_y = y;
					
				x = sit.x;
				y = sit.bbox_top;
				
				if(gunangle >  180) draw_self_enemy();
				draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
				if(gunangle <= 180) draw_self_enemy();
				
				x = _x;
				y = _y;
			}
		}
		else draw_self_enemy();
	}
	else{
		if(gunangle >  180) draw_self_enemy();
		draw_weapon(spr_weap, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
		if(gunangle <= 180) draw_self_enemy();
	}
	
#define Cat_alrm1
	alarm1 = 20 + irandom(20);
	
	 // Spraying Toxic Gas:
	if(ammo > 0){
		alarm1 = 2;
		
		var	_x = x,
			_y = y;
			
		if(instance_is(sit, enemy)){
			_x = sit.x;
			_y = sit.bbox_top;
		}
		else sit = false;
		
		 // Toxic:
		repeat(2){
			with(projectile_create(_x, _y, ToxicGas, gunangle + orandom(6), 4)){
				friction  = 0.12;
				cat_toxic = true;
				if(!instance_is(other.sit, enemy)) team = 0;
			}
		}
		gunangle += 12;
		
		 // End:
		if(--ammo <= 0){
			alarm1 = 40;
			
			 // Effects:
			repeat(3){
				with(instance_create(_x, _y, AcidStreak)){
					motion_add(other.gunangle + orandom(16), 3);
					image_angle = direction;
				}
			}
			sound_play_pitch(sndEmpty, random_range(0.75, 0.9));
			sound_stop(toxer_loop);
			toxer_loop = -1;
			wkick += 6;
		}
		else wkick++;
	}
	
	else{
		enemy_target(x, y);
		
		 // Normal AI:
		if(active){
			 // Notice Target:
			if(
				my_health < maxhealth
				||
				(
					instance_near(x, y, target, 128) &&
					(instance_seen(x, y, target) || (instance_near(x, y, target, 96) && variable_instance_get(target, "reload", 0) > 0))
				)
			){
				cantravel = true;
				if(sit && !instance_is(sit, enemy)){
					sit = false;
					instance_create(x, y, AssassinNotice);
				}
			}
			
			if(!sit || instance_is(sit, enemy) || chance(1, 12)){
				if(!instance_is(sit, enemy)) sit = false;
				
				if(instance_seen(x, y, target)){
					scrAim(point_direction(x, y, target.x, target.y));
					
					 // Start Attack:
					if(instance_near(x, y, target, 140) && chance(1, 3)){
						alarm1 = 4;
						ammo = 10;
						gunangle -= 45;
						
						 // Effects:
						var o = 8;
						with(instance_create(x + lengthdir_x(o, gunangle), y + lengthdir_y(o, gunangle), AcidStreak)) {
							sprite_index = spr.AcidPuff;
							image_angle = other.gunangle;
						}
						sound_play(sndToxicBoltGas);
						sound_play(sndEmpty);
						toxer_loop = audio_play_sound(sndFlamerLoop, 0, true);
						wkick += 4;
					}
					
					 // Walk Toward Player:
					else{
						alarm1 = 20 + irandom(20);
						scrWalk(gunangle + orandom(20), [20, 25]);
					}
				}
				
				else{
					 // To the CatHole:
					if(cantravel && chance(3, 4)){
						var _hole = instances_matching(instances_matching(CustomObject, "name", "CatHole"), "image_index", 0);
						
						if(array_length(_hole) > 0 && array_length(instances_matching(_hole, "target", id)) <= 0){
							alarm1 = 30 + irandom(30);
							
							with(instance_nearest_array(x, y, _hole)){
								 // Open CatHole:
								if(instance_near(x, y, other, 48)){
									target = other;
									image_index = 1;
									other.alarm1 += 45;
								}
								
								 // Walk to CatHole:
								else with(other){
									scrWalk(point_direction(x, y, other.x, other.y), [20, 40]);
									scrAim(direction);
								}
							}
						}
					}
					
					 // Wander:
					else if((instance_exists(target) && cantravel) || chance(3, 4)){
						alarm1 = 30 + irandom(20);
						scrWalk(direction + orandom(30), [20, 30]);
						if(chance(1, 2)) direction = random(360);
						scrAim(direction);
					}
					
					 // Sittin:
					else if(!sit){
						sit = true;
						var n = instance_nearest(x, y, prop);
						if(instance_seen(x, y, n)) scrAim(point_direction(x, y, n.x, n.y));
					}
				}
			}
		}
		
		 // Manhole Travel:
		else{
			alarm1 = 40 + random(40);
			
			with(array_shuffle(instances_matching(instances_matching(CustomObject, "name", "CatHole"), "image_index", 0))){
				if(!instance_exists(target)){
					if(!instance_exists(other.target) || instance_near(x, y, other.target, 140)){
						target = other;
						image_index = 1;
						break;
					}
				}
			}
		}
	}
	
#define Cat_hurt(_hitdmg, _hitvel, _hitdir)
	if(!instance_is(other, ToxicGas)){
		if(active){
			enemy_hurt(_hitdmg, _hitvel, _hitdir)
			if(!instance_is(sit, enemy)) sit = false;
		}
	}
	
	 // Toxic immune
	else with(other){
		instance_copy(false);
		instance_delete(id);
		for(var i = 0; i < maxp; i++) view_shake[i] -= 1;
	}
	
#define Cat_cleanup
	sound_stop(toxer_loop);
	
	
#define CatBoss_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
		 // For Sani's bosshudredux:
		bossname = "BIG CAT";
		col      = c_green;
		
		 // Visual:
		spr_idle      = spr.CatBossIdle;
		spr_walk      = spr.CatBossWalk;
		spr_hurt      = spr.CatBossHurt;
		spr_dead      = spr.CatBossDead;
		spr_chrg      = spr.CatBossChrg;
		spr_fire      = spr.CatBossFire;
		spr_weap      = spr.CatBossWeap;
		spr_weap_chrg = spr.CatBossWeapChrg;
		spr_shadow    = shd48;
		spr_shadow_y  = 3;
		hitid         = [spr_idle, "BIG CAT"];
		depth         = -2;
		
		 // Sound:
		snd_hurt     = sndBuffGatorHit;
		snd_dead     = sndSalamanderDead;
		snd_lowh     = sndBallMamaAppear;
		jetpack_loop = -1;
		
		 // Vars:
		mask_index    = mskBanditBoss;
		maxhealth     = boss_hp(200);
		raddrop       = 24;
		meleedamage   = 3;
		canmelee      = false;
		size          = 3;
		walk          = 0;
		walkspeed     = 0.8;
		maxspeed      = 3;
		intro         = false;
		tauntdelay    = 40;
		dash          = 0;
		super         = false;
		supertime     = 0;
		maxsupertime  = 30;
		superbreakmax = 6; // used in on_hurt to prevent catboss from being locked in the charge animation 
		gunangle      = random(360);
		direction     = gunangle;
		
		 // Alarms:
		alarm0 = 6;
		alarm1 = 30 + random(20);
		alarm2 = -1;
		alarm3 = 300 + random(150);
		
		return id;
	}
	
#define CatBoss_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	if(alarm3_run) exit;
	
	 // Death Taunt:
	if(tauntdelay > 0 && !instance_exists(Player)){
		tauntdelay -= current_time_scale;
		if(tauntdelay <= 0){
			var _snd = sound_play_pitchvol(sndBallMamaTaunt, 0.9, 3);
			audio_sound_set_track_position(_snd, 1);
			
			 // Epic Fart:
			walk = 0;
			sound_play_pitchvol(sndToxicBoltGas, 0.4, 0.5);
			with(instance_create(x, y + 8, ToxicDelay)){
				alarm0 = 1;
			}
		}
	}
	
	 // Boutta Dash:
	if(sprite_index == spr_chrg){
		walk  = 0;
		speed = 0;
		
		 // Gassy:
		repeat(2) if(chance_ct(1, 3)){
			with(instance_create(x + orandom(4), y + orandom(4), AcidStreak)){
				motion_add(random(360), 1);
				motion_add(other.gunangle + 180 + orandom(40), random_range(2, 4));
				image_angle = direction;
				image_blend = merge_color(image_blend, c_lime, random(0.1));
				depth       = other.depth;
			}
		}
	}
	
	 // Movement:
	else{
		enemy_walk(walkspeed, maxspeed + (3.5 * (dash > 0)));
		
		 // Bounce:
		if(dash <= 0 && walk > 0 && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
			if(array_length(instances_matching(instances_matching(CustomObject, "name", "CatBossAttack"), "creator", id)) <= 0){
				if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
				if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
				scrAim(angle_lerp(gunangle, direction, 0.5));
			}
		}
	}
	
	 // Animate:
	if(sprite_index != spr_chrg){
		sprite_index = enemy_sprite;
	}
	
	 // Super FX:
	if(super && chance_ct(1, 10)){
		var	_l = 12,
			_d = gunangle;
			
		with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), PortalL)){
			depth = -3;
		}
	}
	
#define CatBoss_draw
	if(gunangle >  180) draw_self_enemy();
	
	 // Weapon:
	var	_spr = spr_weap,
		_img = (super ? (current_frame * image_speed) : 0);
		
	if(supertime > 0){
		_spr = spr_weap_chrg;
		_img = sprite_get_number(spr_weap_chrg) * (1 - (supertime / maxsupertime));
	}
	draw_sprite_ext(_spr, _img, x - lengthdir_x(wkick, gunangle), y - lengthdir_y(wkick, gunangle), 1, right, gunangle, image_blend, image_alpha);
	
	if(gunangle <= 180) draw_self_enemy();
	
#define CatBoss_alrm0
	intro = true;
	boss_intro("CatBat");
	sound_play(sndScorpionFireStart);
	
	 // Disable Bros:
	with(instances_matching_gt(instances_matching(CustomEnemy, "name", "BatBoss", "CatBoss"), "alarm0", 0)){
		intro = true;
		alarm0 = -1;
	}

#define CatBoss_alrm1
	alarm1 = 20 + random(20);

	if(supertime > 0){
		alarm1 = 1;
		supertime -= 1;
		
		 // Mid charge:
		wkick = 6;
		gunangle = (right ? 320 : 220) + orandom(5);
		
		 // Effects:
		view_shake_max_at(x, y, 4);
		if(chance(1, 2)){
			var	_w = (1 - (supertime / maxsupertime)) * 12,
				_h = irandom(8) * right;
				
			with(instance_create(x + lengthdir_x(_w, gunangle) + lengthdir_x(_h, gunangle + 90), y + lengthdir_y(_w, gunangle) + lengthdir_y(_h, gunangle + 90), EatRad)){
				sprite_index = choose(sprEatRadPlut, sprEatRadPlut, sprEatBigRadPlut);
				depth = -3;
			}
		}
		
		 // End charge:
		if(supertime <= 0){
			super = true;
			
			alarm1 = 12;
			wkick = -3;
			gunangle = (right ? 340 : 200);
			
			 // Sounds:
			sound_play_pitch(sndLaserCannon, 0.8);
			sound_play_pitch(sndGunGun, 1.2);
			sound_play_pitch(sndStrongSpiritLost, 0.8);
			
			 // Effects:
			var l = 20;
			with(instance_create(x + lengthdir_x(l, gunangle), y + lengthdir_y(l, gunangle), ThrowHit)){
				depth = -3;
			}
		}
	}
	else{
		with(instances_matching(CustomEnemy, "name", "BatBoss")){
			alarm1 = 20 + random(20);
			other.alarm1 += alarm1;
		}
		
		if(enemy_target(x, y)){
			 // Start Charge:
			if(!super && chance(1, 5)){
				alarm1 = 1;
				supertime = maxsupertime;
				superbreakmax = 6;
				
				 // FX:
				sound_play_pitch(sndLaserCannonCharge, 0.6);
				sound_play_pitch(sndTechnomancerActivate, 1.4);
			}
			
			else{
				scrAim(point_direction(x, y, target.x, target.y));
				
				if(chance(4, 5)){
					 // Attack:
					if(chance(3, 4) && instance_seen(x, y, target) && (instance_near(x, y, target, 80) || chance(1, 2))){
						alarm1 = 10;
						
						with(projectile_create(x, y, "CatBossAttack", gunangle, 0)){
							target = other.target;
							type = other.super;
							other.alarm1 += alarm0;
						}
						
						 // Effects:
						sound_play(sndShotReload);
						sound_play_pitch(sndSnowTankAim, 2.5 + random(0.5));
						sound_play_pitchvol(sndLilHunterSniper, (super ? 0.25 : 1.5) + random(0.5), 0.5);
						if(super) sound_play_pitchvol(sndLaserCannonCharge, 0.4 + orandom(0.1), 0.5);
						
						super = false;
					}
					
					 // Gas dash:
					else if(!instance_near(x, y, target, 40)){
						alarm2 = 15;
						alarm1 += alarm2;
						sprite_index = spr_chrg;
						
						 // Effects:
						repeat(16) scrFX(x, y, random(5), Dust);
						sound_play_pitchvol(sndBigBanditMeleeStart, 0.6 + random(0.2), 1.2);
					}
				}
				
				 // Circle Target:
				else{
					var	l = 64,
						d = point_direction(target.x, target.y, x, y);
						
					d += 30 * sign(angle_difference(direction, d));
					
					scrWalk(point_direction(x, y, target.x + lengthdir_x(l, d), target.y + lengthdir_y(l, d)), [15, 40]);
				}
			}
		}
		
		 // Wander:
		else{
			scrWalk(direction + orandom(30), [15, 40]);
			scrAim(direction);
		}
	}

#define CatBoss_alrm2
	alarm2 = 1;
	
	var _targetDir = (enemy_target(x, y)
		? point_direction(x, y, target.x, target.y)
		: gunangle
	);
	
	 // Dash Start:
	if(dash <= 0){
		dash         = 16 + random(8);
		canmelee     = true;
		direction    = gunangle + (random_range(40, 60) * choose(-1, 1));
		sprite_index = spr_fire;
		
		 // Effects:
		sleep(26);
		view_shake_at(x, y, 18);
		sound_play(sndToxicBoltGas);
		sound_play(sndFlamerStart);
		jetpack_loop = audio_play_sound(sndFlamerLoop, 0, true);
	}
	
	 // Zoomin'
	motion_add(direction,  1.4);
	motion_add(_targetDir, 0.7);
	
	 // Wall break:
	if(place_meeting(x + hspeed, y + vspeed, Wall)){
		with(instances_meeting(x + hspeed, y + vspeed, Wall)){
			view_shake_at(x, y, 3);
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
	}
	
	 // Gas:
	repeat(2 + irandom(3)){
		with(projectile_create(
			x,
			y,
			ToxicGas,
			direction + 180 + orandom(15),
			2 + random(1)
		)){
			friction  = 0.16;
			team      = 0;
			cat_toxic = true;
		}
	}
	
	 // Effects:
	wkick = 6;
	repeat(1 + irandom(2)){
		with(instance_create(x, y, AcidStreak)){
			image_angle = other.direction + 180 + orandom(64);
		}
	}
	
	 // End Dash:
	if(--dash <= 0){
		alarm2   = -1;
		alarm11  = -1;
		canmelee = false;
		
		 // Movin'
		scrWalk(direction + orandom(20), [15, 30]);
		sprite_index = spr_walk;
		
		 // Effects:
		view_shake_at(x, y, 12);
		sound_play(sndFlamerStop);
		sound_stop(jetpack_loop);
	}
	
	scrAim(angle_lerp(
		gunangle,
		angle_lerp(_targetDir, direction, 0.5),
		0.5 * current_time_scale
	));
	
#define CatBoss_alrm3
	alarm3 = 150;
	
	 // Underground Cats:
	if(chance(1, 1 + array_length(instances_matching(CustomEnemy, "name", "Cat")))){
		with(obj_create(0, 0, "Cat")){
			active    = false;
			cantravel = true;
			alarm1    = random_range(60, 150);
		}
	}
	
#define CatBoss_hurt(_hitdmg, _hitvel, _hitdir)
	if(!instance_is(other, ToxicGas)){
		enemy_hurt(_hitdmg, (dash ? 0 : _hitvel), _hitdir);
		
		 // Pitch Hurt:
		if(snd_hurt == sndBuffGatorHit){
			sound_play_hit_ext(snd_hurt, 0.6 + random(0.3), 3);
		}
		
		 // Half HP:
		var h = (maxhealth / 2);
		if(in_range(my_health, h - _hitdmg + 1, h)){
			if(snd_lowh == sndBallMamaAppear){
				var s = sound_play_pitchvol(snd_lowh, 0.8, 1.5);
				audio_sound_set_track_position(s, 1.5);
			}
			else sound_play(snd_lowh);
		}
		
		 // Break charging:
		if(supertime > 0 && superbreakmax > 0){
			supertime += _hitdmg * 4;
			superbreakmax--;
			
			if(supertime >= maxsupertime){
				alarm1 = 40 + irandom(20);
				supertime = 0;
				gunangle = (right ? 300 : 240);
				sleep(100);
				view_shake_at(x, y, 20);
				motion_add(_hitdir, 4);
				
				 // Sounds:
				sound_play_pitch(sndGunGun, 0.8);
				sound_play_pitch(sndStrongSpiritLost, 1.2);
				
				 // Effects:
				with(instance_create(x, y, ImpactWrists)){
					depth = -3;
				}
				repeat(2 + irandom(2)){
					with(instance_create(x, y, Rad)){
						motion_set(_hitdir + orandom(30), 4 + random(4));
						friction = 0.4;
					}
				}
				repeat(3 + irandom(6)){
					with(instance_create(x, y, Smoke)){
						motion_set(_hitdir + orandom(30), 4 + random(4));
					}
				}
				with(instance_create(x + lengthdir_x(16, gunangle), y + lengthdir_y(16, gunangle), FishA)){
					image_angle = other.gunangle;
					depth = -3;
				}
			}
		}
	}
	
	 // Toxic immune
	else with(other){
		instance_copy(false);
		instance_delete(id);
		for(var i = 0; i < maxp; i++) view_shake[i] -= 1;
	}
	
#define CatBoss_death
	 // Hmmmm
	instance_create(x, y, PortalClear);
	instance_create(x, y, ToxicDelay);
	
	 // Pickups:
	repeat(2){
		pickup_drop(100, 0);
	}
	
	 // Buff Partner:
	var _partner = instances_matching(CustomEnemy, "name", "BatBoss");
	if(array_length(_partner) > 0) with(_partner){
		var _heal = ceil(maxhealth / 4);
		maxhealth += _heal;
		
		 // Rad Heals:
		with(other){
			 // Rads:
			var	_num = min(raddrop, 24),
				_rad = rad_drop(x, y, _num, direction, speed);
				
			raddrop -= _num;
			with(_rad){
				alarm0 /= 3;
				direction = random(360);
				speed = max(2, speed);
				image_index = 1;
				depth = -3;
			}
			
			 // Partner Sucks Up Rads:
			with(rad_path(_rad, other)){
				heal = ceil(_heal / array_length(_rad));
			}
		}
	}
	
	 // Boss Win Music:
	else with(MusCont) alarm_set(1, 1);
	
#define CatBoss_cleanup
	sound_stop(jetpack_loop);
	
	
#define CatBossAttack_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		image_yscale = 1.5;
		hitid        = [spr.CatIdle, "BIG CAT"];
		
		 // Vars:
		type      = 0;
		team      = 1;
		force     = 12;
		damage    = 8;
		target    = noone;
		creator   = noone;
		fire_line = [];
		
		 // Alarms:
		alarm0     = 30;
		alarm0_max = alarm0;
		
		return id;
	}
	
#define CatBossAttack_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Setup Fire Lines:
	if(array_length(fire_line) <= 0){
		var	_num = (3 + GameCont.loops) * (type ? 2.5 : 1),
			_off = 30 + (12 * GameCont.loops),
			_offPos = (_num / 2) * type;
			
		if(_num > 0) repeat(_num){
			array_push(fire_line, {
				dir : (type ? orandom(_off) : 0),
				dis : 0,
				dir_goal : (type ? 0 : orandom(_off)),
				dis_goal : 1000,
				x :  0 + orandom(_offPos),
				y : -4 + orandom(_offPos)
			});
		}
	}
	
	if(creator == noone || instance_exists(creator)){
		 // Chargin Up:
		with(creator){
			wkick = 5 * (1 - (other.alarm0 / other.alarm0_max));
		}
		
		 // Aim:
		if(type && instance_exists(target) && target.team != team){
			var	d = point_direction(x, y, target.x, target.y),
				m = 60;
				
			with(creator){
				scrAim(gunangle + ((clamp(angle_difference(d, gunangle), -m, m) / 20) * current_time_scale));
			}
			direction += (clamp(angle_difference(d, direction), -m, m) / 16) * current_time_scale;
		}
		
		 // Follow Creator:
		if(instance_exists(creator)){
			var o = (type ? 28 : 16) - creator.wkick;
			x = creator.x + lengthdir_x(o, creator.gunangle);
			y = creator.y + lengthdir_y(o, creator.gunangle);
		}
		
		 // Hitscan Lines:
		with(fire_line){
			dir = angle_lerp(dir, dir_goal, current_time_scale / 7);
			
			 // Line Hitscan:
			var	_dir = dir + other.direction,
				_sx  = other.x + x,
				_sy  = other.y + y,
				_lx  = _sx,
				_ly  = _ly,
				_md  = 1000,
				_d   = _md,
				_m   = 0; // Minor hitscan increment distance
				
			with(other) while(_d > 0){
				 // Major Hitscan Mode (Start at max, go back until no collision line):
				if(_m <= 0){
					_lx = _sx + lengthdir_x(_d, _dir);
					_ly = _sy + lengthdir_y(_d, _dir);
					_d -= sqrt(_md);
					
					 // Enter minor hitscan mode:
					if(!collision_line(_sx, _sy, _lx, _ly, Wall, false, false)){
						if(position_meeting(_lx, _ly, Floor)){
							_m = 2;
							_d = sqrt(_md);
						}
					}
				}
				
				 // Minor Hitscan Mode (Move until collision):
				else{
					if(position_meeting(_lx, _ly, Wall)) break;
					_lx += lengthdir_x(_m, _dir);
					_ly += lengthdir_y(_m, _dir);
					_d -= _m;
				}
			}
			
			dis = point_distance(_sx, _sy, _lx, _ly);
			
			 // Effects:
			if(chance_ct(1, 10)){
				var	_l = random(dis),
					_d = _dir;
					
				with(instance_create(
					_sx + lengthdir_x(_l, _d) + orandom(4),
					_sy + lengthdir_y(_l, _d) + orandom(4),
					EatRad
				)){
					sprite_index = choose(sprEatRadPlut, sprEatBigRad);
					motion_set(_dir + 180 + orandom(60), 2);
				}
			}
		}
	}
	else instance_destroy();

#define CatBossAttack_draw
	 // Laser Sights:
	var	_cx = x,
		_cy = y,
		_scale1 = image_yscale * (1 + (3 * (1 - (alarm0 / alarm0_max)))),
		_scale2 = 3 * (image_yscale * 3),
		_colors = [make_color_rgb(133, 249, 26), make_color_rgb(190, 253, 8)];
		
	draw_set_color(_colors[current_frame % 2]);
	
	with(fire_line){
		var	_x = _cx + x,
			_y = _cy + y,
			_dir = dir + other.direction;
			
		draw_line_width(_x, _y, _x + lengthdir_x(dis, _dir), _y + lengthdir_y(dis, _dir), _scale1 / 2);
		if(other.type){
			draw_circle(_x, _y, _scale1, false);
		}
		
		 // Bloom:
		draw_set_blend_mode(bm_add);
		draw_set_alpha(0.025);
		if(other.type){
			draw_circle(_x, _y, _scale2, false);
		}
		draw_line_width(_x, _y, _x + lengthdir_x(dis, _dir), _y + lengthdir_y(dis, _dir), _scale2);
		draw_set_alpha(1);
		draw_set_blend_mode(bm_normal);
	}
	
#define CatBossAttack_alrm0
	 // Hitscan Toxic:
	for(var i = 0; i < array_length(fire_line); i++){
		var	_line = fire_line[i],
			_x = x + _line.x,
			_y = y + _line.y,
			_dis = _line.dis,
			_dir = _line.dir + direction;
			
		 // Wall Break:
		if(type){
			var o = 24;
			instance_create(_x + lengthdir_x(_dis - o, _dir), _y + lengthdir_y(_dis - o, _dir), PortalClear);
			instance_create(_x + lengthdir_x(_dis,     _dir), _y + lengthdir_y(_dis,     _dir), ToxicDelay);
		}
		
		 // Create Toxic Rails:
		while(_dis > 0){
			var	_lx = _x + lengthdir_x(_dis, _dir),
				_ly = _y + lengthdir_y(_dis, _dir),
				o = (12 + GameCont.loops) * type;
				
			 // Instadamage:
			if(type && collision_circle(_lx, _ly, o / 2, hitme, false, false)){
				with(instances_matching_ne(hitme, "id", creator)) with(other){
					if(projectile_canhit_melee(other)){
						if(collision_circle(_lx, _ly, o / 2, other, false, false)){
							projectile_hit(other, damage, force, _dir);
						}
					}
				}
			}
			
			 // Gas:
			with(projectile_create(_lx + orandom(o), _ly + orandom(o), ToxicGas, _dir, 1 + random(1))){
				friction  += random_range(0.1, 0.2);
				growspeed *= _dis / _line.dis;
				team       = 0;
				
				 // Effects:
				if(chance(1, 2)){
					with(instance_create(x + orandom(8), y + orandom(8), AcidStreak)){
						motion_add(_dir + orandom(8), 4);
						image_angle = direction;
					}
				}
			}
			
			_dis -= 6;
		}
		
		 // Knockback gas:
		with(projectile_create(_x, _y, ToxicGas, _dir + 180 + orandom(20), 3)){
			move_contact_solid(_dir + 180, 20);
			friction = 0.1;
			team = 0;
		}
	}
	
	 // Effects:
	view_shake_at(x, y, 32);
	sound_play(sndToxicBarrelGas);
	if(type){
		sound_play_pitch(sndHyperSlugger, 0.4 + random(0.4));
		sound_play_pitch(sndUltraCrossbow, 2 + random(0.5));
	}
	else{
		sound_play(sndHyperSlugger);
	}
	
	 // Cat knockback:
	with(creator){
		motion_add(other.direction + 180, 4);
		wkick = 16;
	}
	
	instance_destroy();


#define CatDoor_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		sprite_index = spr.CatDoor;
		spr_shadow   = mskNone;
		image_speed  = 0;
		depth        = -3;
		
		 // Sound:
		snd_hurt = sndHitMetal;
		snd_dead = sndWallBreakScrap;
		
		 // Vars:
		mask_index   = msk.CatDoor;
		maxhealth    = 15;
		size         = 2;
		team         = 0;
		openang      = 0;
	//	my_wall      = noone;
		partner      = noone;
		partner_wall = noone;
		
		 // Auto-Sprite:
		switch(GameCont.area){
			case "pizza":
			case area_pizza_sewers:
				sprite_index = spr.PizzaDoor;
				break;
		}
		
		return id;
	}
	
#define CatDoor_step
	x = xstart;
	y = ystart;
	
	 // Link to Wall:
	if(!instance_exists(partner_wall)){
		var	_l = 8 * image_yscale,
			_d = image_angle + 90;
			
		if(position_meeting(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), Wall)){
			with(instances_at(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), Wall)){
				other.partner_wall = id;
				break;
			}
		}
		
		 // No Wall:
		if(partner_wall != noone && !instance_exists(partner_wall)){
			my_health = 0;
		}
	}
	
	 // Opening & Closing:
	var	_push = 0,
		_open = false;
		
	if(mask_index == mskNone){
		mask_index = mskFrogQueen;
	}
	if(distance_to_object(hitme) <= 0){
		with(instances_meeting(x, y, instances_matching_ne(instances_matching_ne(hitme, "team", 0), "mask_index", mskNone))){
			if(!instance_is(self, prop)){
				_open = true;
				
				var	_h = lengthdir_x(hspeed, other.image_angle),
					_v = lengthdir_y(vspeed, other.image_angle),
					_p = 3 * (_h + _v);
					
				if(abs(_p) > abs(_push)){
					_push = _p;
				}
			}
		}
	}
	if(_open){
		if(_push != 0){
			if(abs(openang) < min(4, abs(_push)) && point_seen(x, y, -1)){
				with((distance_to_object(Player) > 0) ? self : instance_nearest(x, y, Player)){
					sound_play_hit_ext(
						sndMeleeFlip,
						1 + random(0.4),
						1
					);
					sound_play_hit_ext(
						((other.openang > 0) ? sndAmmoChest : sndWeaponChest),
						0.4 + random(0.2),
						1
					);
				}
			}
			openang += _push * current_time_scale;
		}
		openang = clamp(openang, -90, 90);
	}
	else openang *= power(0.8, current_time_scale);
	
	 // Collision:
	mask_index = (
		(abs(openang) > 20)
		? mskNone
		: msk.CatDoor
	);
	
	/*
	 // Block Line of Sight (no work in GMS2):
	if(!instance_exists(my_wall)){
		var _off = 0;
		while(!instance_exists(my_wall)){
			my_wall = instance_create(x, y + _off, Wall);
			with(my_wall){
				image_xscale = other.image_xscale;
				image_yscale = other.image_yscale;
				image_angle  = other.image_angle;
				x            = other.x;
				y            = other.y;
				xstart       = x;
				ystart       = y;
				xprevious    = x;
				yprevious    = y;
			}
			_off += 100;
		}
	}
	with(my_wall){
		if(other.mask_index == mskNone) mask_index = -1;
		else mask_index = msk.CatDoorLOS;
		visible = false;
		sprite_index = -1;
		topspr = -1;
		outspr = -1;
	}
	*/
	
	 // Death:
	if(my_health <= 0){
		sound_play_hit_ext(snd_dead, 1.8 + random(0.2), 0.8);
		sound_play_hit_ext(snd_hurt, 0.6 + random(0.2), 2.0);
		
		 // Chunks:
		var _d = image_angle - (90 * image_yscale);
		for(var _l = 0; _l <= abs(sprite_height); _l += random_range(4, 8)){
			with(obj_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "CatDoorDebris")){
				if(other.speed == 0){
					speed *= random_range(1, 3);
				}
				else motion_add(
					other.direction + orandom(20),
					clamp(other.speed, 6, 18) * random_range(0.6, 1)
				);
				if(other.sprite_index == spr.PizzaDoor){
					sprite_index = spr.PizzaDoorDebris;
				}
			}
			
			with(scrFX(x, y, [direction + orandom(20), min(speed, 10) / 2], Dust)){
				depth = 1;
			}
		}
		
		instance_destroy();
	}
	
	 // Stay Still:
	else speed = 0;
	
#define CatDoor_draw
	var	_surfW = 2 * max(abs(sprite_width), abs(sprite_height)),
		_surfH = _surfW + ((image_number - 1) * 2);
		
	if(point_seen_ext(x, y, _surfW, _surfH, -1)){
		var	_hurt = (nexthurt > current_frame + 3),
			_surfScale = option_get("quality:main");
			
		with(surface_setup(name + string(id), _surfW, _surfH, _surfScale)){
			x = other.x - (w / 2);
			y = other.y - (h / 2);
			
			 // Draw:
			if(_hurt) draw_set_fog(true, other.image_blend, 0, 0);
			draw_surface_ext(surf, x, y, 1 / scale, 1 / scale, 0, other.image_blend, other.image_alpha);
			if(_hurt) draw_set_fog(false, 0, 0, 0);
			
			 // Update:
			if(reset || abs(other.openang - lq_defget(self, "lastang", 0)) > 1){
				reset = false;
				lastang = other.openang;
				
				surface_set_target(surf);
				draw_clear_alpha(0, 0);
				
				 // Draw 3D Door:
				with(other){
					for(var i = 0; i < image_number; i++){
						draw_sprite_ext(sprite_index, i, (_surfW / 2) * _surfScale, ((_surfH / 2) - i) * _surfScale, image_xscale * _surfScale, image_yscale * _surfScale, image_angle + (openang * image_yscale), c_white, 1);
					}
				}
				
				surface_reset_target();
			}
		}
	}

#define CatDoor_hurt(_hitdmg, _hitvel, _hitdir)
	my_health -= _hitdmg;          // Damage
	motion_add(_hitdir, _hitvel);  // Knockback
	nexthurt = current_frame + 6;  // I-Frames
	sound_play_hit(snd_hurt, 0.3); // Sound
	
	 // Push Open Force:
	if(instance_exists(other)){
		var	_sx = lengthdir_x(other.hspeed, image_angle),
			_sy = lengthdir_y(other.vspeed, image_angle);
			
		openang += (_sx + _sy);
	}
	
	 // Shared Hurt:
	if(_hitdmg > 0){
		with(partner) if(my_health > other.my_health){
			CatDoor_hurt(_hitdmg, _hitvel, _hitdir);
		}
	}
	
#define CatDoor_cleanup
	//instance_delete(my_wall);
	with(surface_setup(name + string(id), null, null, null)){
		free = true;
	}
	
	
#define CatDoorDebris_create(_x, _y)
	with(instance_create(_x, _y, Shell)){
		 // Visual:
		sprite_index = spr.CatDoorDebris;
		image_index = irandom(image_number - 1);
		image_speed = 0;
		
		 // Vars:
		friction *= 2;
		flash = 1;
		
		motion_add(random(360), 2);
		
		return id;
	}
	
#define CatDoorDebris_draw
	if(flash > 0){
		flash -= 1/3 * current_time_scale;
		draw_set_fog(true, c_white, 0, 0);
		draw_self();
		draw_set_fog(false, 0, 0, 0);
	}


//#define CatGrenade_create(_x, _y)
//	with(instance_create(_x, _y, CustomProjectile)){
//		 // Visual:
//		sprite_index = sprToxicGrenade;
//		
//		 // Vars:
//		mask_index = mskNone;
//		z = 1;
//		zspeed = 0;
//		zfriction = 0.8;
//		damage = 0;
//		force = 0;
//		right = choose(-1, 1);
//		
//		return id;
//	}
//	
//#define CatGrenade_step
//	 // Rise & Fall:
//	z += zspeed * current_time_scale;
//	zspeed -= zfriction * current_time_scale;
//	depth = max(-z, -12);
//	
//	 // Trail:
//	if(chance_ct(1, 2)){
//		with(instance_create(x + orandom(4), y - z + orandom(4), PlasmaTrail)) {
//			sprite_index = sprToxicGas;
//			image_xscale = 0.25;
//			image_yscale = image_xscale;
//			image_angle = random(360);
//			image_speed = 0.4;
//			depth = other.depth;
//		}
//	}
//	
//	 // Hit:
//	if(z <= 0) instance_destroy();
//	
//#define CatGrenade_draw
//	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale * right, image_angle - (speed * 2) + (max(zspeed, -8) * 8), image_blend, image_alpha);
//	
//#define CatGrenade_hit
//	// nada
//	
//#define CatGrenade_wall
//	// nada
//	
//#define CatGrenade_destroy
//	projectile_create(x, y, Explosion, 0, 0);
//	
//	repeat(18){
//		with(projectile_create(x, y, ToxicGas, random(360), 4)) {
//			friction = 0.2;
//			team = 0;
//		}
//	}
//	
//	 // Sound:
//	sound_play(sndGrenade);
//	sound_play(sndToxicBarrelGas);
	
	
#define CatHole_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.Manhole;
		image_speed  = 0;
		depth        = 5;
		
		 // Vars:
		mask_index  = spr.ManholeOpen;
		close_index = 6;
		target      = noone;
		
		 // don't mess with the big boy
		with(instances_meeting(x, y, instances_matching(CustomObject, "name", "CatHoleBig"))){
			if(place_meeting(x, y, other)){
				with(other){
					instance_destroy();
					return self;
				}
			}
		}
		
		return id;
	}

#define CatHole_step
	if(image_index > 0){
		 // Animate:
		if(image_speed == 0){
			image_speed = 0.4;
		}
		
		 // Player Blocking:
		if(image_index < 2 + image_speed_raw && place_meeting(x, y, Player)){
			image_index = close_index;
			
			 // Push:
			with(instances_meeting(x, y, Player)){
				if(place_meeting(x, y, other)){
					motion_add(point_direction(other.x, other.y, x, y), 2);
				}
			}
		}
		
		if(image_index < close_index){
			depth = min(depth, -6);
			
			 // Hole:
			if(array_length(instances_matching(instances_matching(CustomObject, "name", "CatHoleOpen"), "creator", id)) <= 0){
				with(obj_create(x, y, "CatHoleOpen")){
					creator = other;
				}
			}
			
			 // Come Here Bro:
			if(instance_exists(target)){
				if(!target.visible){
					with(target){
						visible = true;
						alarm1 = 15 + random(30);
						active = true;
						canfly = false;
						x = other.x;
						y = other.y;
						
						 // Move:
						if(instance_exists(target)){
							scrAim(point_direction(x, y, target.x, target.y) + orandom(50));
						}
						else{
							scrAim(random(360));
						}
						scrWalk(gunangle, [4, 8]);
						
						 // Effects:
						sound_play_pitchvol(sndFireballerHurt, 1.4, 0.6);
						repeat(4){
							scrFX([x, 4], [y, 4], [direction, 3], Dust);
						}
					}
					target = noone;
				}
				else{
					var	_x = x,
						_y = y - 4;
						
					with(target){
						if(point_distance(x, y, _x, _y) > 5){
							motion_add(point_direction(x, y, _x, _y), 1);
							scrRight(direction);
						}
					}
				}
			}
			
			 // Close:
			if(image_index + image_speed_raw >= close_index){
				depth = 5;
				
				 // Delete Hole:
				with(instances_matching(instances_matching(CustomObject, "name", "CatHoleOpen"), "creator", id)){
					instance_destroy();
				}
				
				 // Grab Bro:
				if(instance_exists(target)){
					if(place_meeting(x, y, target)){
						target.active = false;
						
						 // Effects:
						sound_play_pitch(target.snd_hurt, 1.3 + random(0.2));
						for(var _dir = 0; _dir < 360; _dir += (360 / 5)){
							with(instance_create(target.x, target.y, Dust)){
								motion_set(_dir + orandom(20), 3 + random(1));
								depth = other.depth;
							}
						}
					}
					target = noone;
				}
				
				 // Effects:
				view_shake_at(x, y, 10);
				instance_create(x, y, ImpactWrists);
				if(point_seen(x, y, -1)){
					sound_play_pitch(sndHitMetal, 0.5 + random(0.2));
				}
			}
		}
		if(anim_end){
			image_index = 0;
			image_speed = 0;
		}
	}
	
	
#define CatHoleBig_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.BigManhole;
		image_index  = 0;
		image_speed  = 0;
		depth        = 8;
		
		 // Vars:
		phase = 0;
		
		 // Floors:
		var	_num = 0,
			_cx = 0,
			_cy = 0;
			
		with(floor_fill(x, y, 2, 2, "")){
			sprite_index = spr.BigManholeFloor;
			image_index = _num++;
			_cx += bbox_center_x;
			_cy += bbox_center_y;
		}
		if(_num > 0){
			x = _cx / _num;
			y = _cy / _num;
		}
		
		 // Cool Light:
		with(obj_create(x, y - 48, "CatLight")){
			w1 = 16;
			w2 = 48;
			h1 = 48;
			h2 = 24;
		}
		
		 // No Portals:
		with(obj_create(0, 0, "PortalPrevent")){
			creator = other;
		}
		
		return id;
	}
	
#define CatHoleBig_step
	 // Alarms:
	if(alarm0_run) exit;
	if(alarm1_run) exit;
	
	 // Begin Intro:
	if(alarm0 <= 0){
		if(instance_exists(Player)){
			if(!instance_exists(CorpseActive)){
				if(instance_number(enemy) - instance_number(Van) <= 0){
					if(array_length(instances_matching(ToxicGas, "cat_toxic", true)) <= 0){
						alarm0 = 20;
						alarm1 = alarm0 + 20;
					}
				}
			}
		}
	}
	
	 // Dim Music:
	else{
		var	_mus = mod_variable_get("mod", "ntte", "mus_current"),
			_vol = audio_sound_get_gain(_mus);
			
		if(audio_is_playing(_mus)){
			sound_volume(_mus, _vol + min(0, (((phase < 2) ? 0.4 : 0) - _vol) * 0.05 * current_time_scale));
		}
	}
	
	 // Camera Pan:
	if(alarm1 > 0){
		for(var i = 0; i < maxp; i++){
			view_object[i] = id;
			view_pan_factor[i] = 10000;
		}
		
		 // Safety Measures:
		if(current_frame_active){
			for(var i = 0; i <= 1; i++){
				with(instances_matching_gt([IDPDSpawn, VanSpawn, WantRevivePopoFreak], `alarm${i}`, 0)){
					alarm_set(i, alarm_get(i) + 1);
				}
			}
		}
	}
	
	 // Animation:
	if(anim_end){
		image_index = 0;
		image_speed = 0;
	}
	
#define CatHoleBig_alrm0
	alarm0 = 30 + irandom(30);
	
	if(instance_exists(Player)){
		 // Clang:
		if(phase < 3){
			if(phase < 1 || instance_near(x, y, instance_seen(x, y, Player), 180)){
				phase++;
				
				 // Animate:
				image_speed = 0.4;
				
				 // Debris:
				var _dis = 16;
				repeat(irandom_range(1, 3)){
					with(instance_create(x, y, Debris)){
						sprite_index = spr.BigManholeDebris;
						image_index = irandom(image_number - 1);
						motion_set(random(360), 4 + random(4));
						x += lengthdir_x(_dis, direction);
						y += lengthdir_y(_dis, direction);
					}
				}
				
				 // Effects:
				repeat(irandom_range(4, 12)){
					with(instance_create(x, y, Dust)){
						motion_set(random(360), random(2));
						x += lengthdir_x(_dis + 2, direction);
						y += lengthdir_y(_dis + 2, direction);
					}
				}
				sound_play_pitch(sndHitMetal, 0.5 + random(0.2));
				view_shake_at(x, y, 20);
				sleep(20);
			}
		}
		
		 // Release Bosses:
		else{
			var _boss = array_shuffle(["BatBoss", "CatBoss"]);
			for(var i = 0; i < array_length(_boss); i++){
				with(obj_create(x, y - 4, _boss[i])){
					sprite_index = spr_hurt;
					image_index  = image_speed * i;
				}
			}
			with(instance_create(x, y, PortalShock)){
				sprite_index = sprPortalClear;
			}
			instance_destroy();
		}
	}
	
#define CatHoleBig_alrm1
	 // Reset Camera:
	for(var i = 0; i < maxp; i++){
		if(view_object[i] == id) view_object[i] = noone;
		view_pan_factor[i] = null;
	}
	
#define CatHoleBig_destroy
	 // Hole:
	with(obj_create(x, y, "CatHoleOpen")){
		sprite_index = spr.BigManholeOpen;
		big = true;
		
		 // Launch Player:
		var _oy = -8 * big;
		y += _oy;
		if(place_meeting(x, y, Player)){
			with(instances_meeting(x, y, Player)){
				if(place_meeting(x, y, other)){
					var	_dir   = point_direction(other.x, other.y, x, y),
						_force = min(1, point_distance(other.x, other.y, x, y) / 24);
						
					with(obj_create(x, y, "PalankingToss")){
						direction    = _dir;
						speed        = 6 * _force;
						zfriction    = 0.6 + (0.4 * _force);
						zspeed       = 12;
						creator      = other;
						depth        = other.depth;
						mask_index   = other.mask_index;
						spr_shadow_y = other.spr_shadow_y;
					}
				}
			}
		}
		y -= _oy;
	}
	
	 // Debris:
	with([
		{	"num" : [6, 12],
			"spr" : spr.BigManholeDebris,
			"ang" : 0,
			"spd" : [2, 8],
			"off" : 16
		},
		{	"num" : [3, 6],
			"spr" : spr.BigManholeDebrisChunk,
			"spd" : [4, 8],
			"off" : 8,
			"ang" : 360
		}
	]){
		var d = self;
		repeat(irandom_range(num[0], num[1])){
			with(instance_create(other.x, other.y, ScrapBossCorpse)){
				sprite_index = d.spr;
				image_index = irandom(image_number - 1);
				image_angle = random(d.ang);
				motion_set(random(360), random_range(d.spd[0], d.spd[1]));
				x += lengthdir_x(d.off, direction);
				y += lengthdir_y(d.off, direction);
				size = 0;
			}
		}
	}
	
	 // Allow Portals:
	with(instances_matching(instances_matching(becomenemy, "name", "PortalPrevent"), "creator", id)){
		instance_destroy();
	}
	
	 // Remove Light:
	with(instances_matching(CustomObject, "name", "CatLight")){
		if(point_distance(x, y, other.x, other.y) < 64){
			instance_destroy();
		}
	}
	
	 // Effects:
	var _dis = 16;
	repeat(irandom_range(6, 18)){
		with(instance_create(x, y, Dust)){
			motion_set(90 + orandom(60), 6 + random(6));
			x += lengthdir_x(_dis, direction);
			y += lengthdir_y(_dis, direction);
			friction = 1;
		}
	}
	sound_play_pitchvol(sndExplosion, 0.8, 1);
	sound_play_pitchvol(sndHitMetal,  0.4, 1);
	view_shake_at(x, y, 60);
	sleep(60);
	
	
#define CatHoleOpen_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.ManholeOpen;
		depth        = 5;
		
		 // Vars:
		mask_index = -1;
		creator    = noone;
		big        = false;
		
		return id;
	}
	
#define CatHoleOpen_step
	 // Collision:
	var	_obj = [chestprop, Corpse, ChestOpen],
		_dis = 4 + (min(bbox_width, bbox_height) / 2),
		_spd = 3,
		_oy  = -8 * big;
		
	if(big){
		array_push(_obj, hitme);
	}
	
	y += _oy;
	
	for(var i = 0; i < array_length(_obj); i++){
		if(place_meeting(x, y, _obj[i])){
			with(instances_meeting(x, y, _obj[i])){
				if(place_meeting(x, y, other)){
					var _dir = point_direction(other.x, other.y, x, y);
					
					 // Force Off:
					if(
						other.big
						&& instance_is(self, Player)
						&& point_distance(other.x, other.y, x, y) < _dis
					){
						x = other.x + lengthdir_x(_dis, _dir);
						y = other.y + lengthdir_y(_dis, _dir);
						direction = angle_lerp(direction, _dir, 1/12);
					}
					
					 // Push:
					else if(speed < _spd){
						if(friction > 0){
							motion_add_ct(_dir, friction + 0.4);
						}
						else{
							x += lengthdir_x(_spd - 0.4, _dir);
							y += lengthdir_y(_spd - 0.4, _dir);
						}
					}
				}
			}
		}
	}
	
	y -= _oy;
	
	 // Grab Portal:
	if(big && instance_exists(Portal)){
		with(instance_nearest_array(x, y, instances_matching(Portal, "type", 1))){
			x = other.x;
			y = other.y;
			
			if(image_alpha > 0){
				image_alpha = 0;
				mask_index = mskReviveArea;
				
				 // Relocating:
				with(instance_nearest(xstart, ystart, PortalShock)){
					x = other.x;
					y = other.y;
				}
				repeat(5) with(instance_nearest(xstart, ystart, PortalL)){
					x = other.x;
					y = other.y;
				}
				
				 // FX:
				var _l = 18;
				for(var _d = 0; _d < 360; _d += random_range(10, 12)){
					scrFX(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), [_d, (chance(1, 6) ? 4 : 2.5)], Dust);
					if(chance(1, 12)){
						with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), Debris)){
							sprite_index = sprDebris102;
							direction = _d + orandom(30);
							speed *= random_range(0.5, 1);
						}
					}
				}
			}
			
			 // No Zap:
			if(place_meeting(x, y, PortalL)){
				with(instances_meeting(x, y, PortalL)){
					if(place_meeting(x, y, other)){
						instance_destroy();
					}
				}
			}
		}
	}
	
	
#define CatLight_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		w1     = 12;
		w2     = 32;
		h1     = 32;
		h2     = 8;
		offset = 0;
		
		return id;
	}
	
#define CatLight_step
	offset = orandom(1);
	
	 // Flicker:
	if(current_frame_active){
		visible = !chance(1, 60);
	}
	
#define draw_catlight(_x, _y, _w1, _w2, _h1, _h2, _offset)
	if(point_seen_ext(_x, _y, max(_w1, _w2), (_h1 + _h2), player_find_local_nonsync())){
		var	_x1a = _x - (_w1 / 2),
			_x2a = _x1a + _w1,
			_y1 = _y,
			_x1b = _x - (_w2 / 2) + _offset,
			_x2b = _x1b + _w2,
			_y2 = _y + _h1;
			
		 // Main Trapezoid:
		draw_primitive_begin(pr_trianglestrip);
		draw_vertex(_x1a, _y1);
		draw_vertex(_x1b, _y2);
		draw_vertex(_x2a, _y1);
		draw_vertex(_x2b, _y2);
		draw_primitive_end();
		
		 // Rounded Bottom:
		draw_ellipse(_x1b - 1, _y2 - 1 - _h2,  _x2b - 1, _y2 - 1 + _h2, false);
	}
	
	
#define ChairFront_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.ChairFrontIdle;
		spr_hurt = spr.ChairFrontHurt;
		spr_dead = spr.ChairFrontDead;
		
		 // Sounds:
		snd_hurt = sndHitMetal;
		snd_dead = sndStreetLightBreak;
		
		 // Vars:
		maxhealth = 4;
		size      = 1;
		
		return id;
	}
	
	
#define ChairSide_create(_x, _y)
	with(obj_create(_x, _y, "ChairFront")){
		 // Visual:
		spr_idle = spr.ChairSideIdle;
		spr_hurt = spr.ChairSideHurt;
		spr_dead = spr.ChairSideDead;
		
		return id;
	}
	
#define Couch_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.CouchIdle;
		spr_hurt = spr.CouchHurt;
		spr_dead = spr.CouchDead;
		
		 // Sounds:
		snd_hurt = sndHitPlant;
		snd_dead = sndWheelPileBreak;
		
		 // Vars:
		maxhealth = 20;
		size = 3;
		
		return id;
	}
	
	
#define GatorStatue_create(_x, _y)
	/*
		Homage to Blaac's Hardmode. You should play it.
	*/

	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle     = spr.GatorStatueIdle;
		spr_hurt     = spr.GatorStatueHurt;
		spr_dead     = spr.GatorStatueDead;
		spr_shadow   = shd32;
		spr_shadow_y = 7;
		sprite_index = spr_idle;
		hitid        = [spr.GatorStatueIdle, "GATOR STATUE"];
		depth        = -1;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndWallBreak;
		
		 // Vars:
		mask_index = mskScorpion;
		maxhealth  = 56;
		raddrop    = 8;
		size       = 3;
		team       = 1;
		skill      = mut_shotgun_shoulders;
		
		 // Prompt:
		prompt = prompt_create("BLESSING");
		with(prompt){
			mask_index = mskReviveArea;
			yoff = -10;
		}
		
		return id;
	}
	
#define GatorStatue_step
	 // Accept Blessing:
	if(instance_exists(prompt) && player_is_active(prompt.pick)){
		prompt.visible = false;
		
		 // Skill:
		with(obj_create(x, y, "OrchidSkill")){
			color1 = make_color_rgb(72, 253,  8); // make_color_rgb(252, 056, 000);
			color2 = make_color_rgb( 3,  33, 18)
			skill  = other.skill;
			time   = 3600; // 2 minutes
		}
		
		 // Effects:
		var _icon = skill_get_icon(skill);
		with(alert_create(self, _icon[0])){
			image_index = _icon[1];
			image_speed = 0;
			alert       = { spr:sprEatRad, img:-0.25, x:6, y:6 };
			blink       = 15;
			alarm0      = 60;
			snd_flash   = sndShotReload;
		}
		with(instance_create(x, y, PopupText)){
			text   = "BLESSED!";
			target = other.prompt.pick;
		}
		with(player_find(prompt.pick)){
			sound_play(snd_valt);
		}
	}
	
#define GatorStatue_death
	var _wepNum = 2;
	
	 // Revenge:
	repeat(4){
		projectile_create(x, y, "GatorStatueFlak", 0, 0);
	}
	if(instance_exists(prompt) && prompt.visible){
		with(projectile_create(x, y, "CustomFlak", 90, 0.1)){
			sprite_index = spr.EnemySuperFlak;
			spr_dead     = spr.EnemySuperFlakHit;
			depth        = -1;
			snd_dead     = sndSuperFlakExplode;
			mask_index   = mskSuperFlakBullet;
			friction     = speed / 60;
			damage       = 10;
			bonus_damage = 0;
			force        = 8;
			typ          = 2;
			flak         = array_create(5, EFlakBullet);
			super        = true;
			with(instance_create(x, y, BulletHit)){
				sprite_index = other.spr_dead;
				friction     = other.friction;
				hspeed       = other.hspeed;
				vspeed       = other.vspeed;
			}
		}
		_wepNum *= 2;
	}
	
	 // Merged Shell Weapons:
	if(_wepNum > 0) repeat(_wepNum){
		var	_wepNum   = 128,
			_wepMod   = mod_get_names("weapon"),
			_wepAvoid = [];
			
		 // Compile Non-Shell Weapons:
		for(var i = _wepNum + array_length(_wepMod) - 1; i >= 0; i--){
			var _wep = ((i < _wepNum) ? i : _wepMod[i - _wepNum]);
			if(weapon_get_type(_wep) != type_shell){
				array_push(_wepAvoid, _wep);
			}
		}
		
		 // Weapon:
		var _part = mod_script_call("weapon", "merge", "weapon_merge_decide_raw", 0, GameCont.hard, -1, _wepAvoid, false);
		if(array_length(_part) >= 2){
			with(instance_create(x + orandom(4), y + orandom(4), WepPickup)){
				wep  = wep_merge(_part[0], _part[1]);
				ammo = true;
			}
		}
	}
	
	 // Effects:
	sound_play_hit_ext(sndCrownNo,      0.8, 0.4);
	sound_play_hit_ext(sndStatueCharge, 0.8, 0.4);
	repeat(10){
		scrFX(    [x, 16], [y, 16], [90, 1 + random(4)], Dust);
		scrFX(     x,       y,      2 + random(3),       Debris);
		with(scrFX(x,       y,      1 + random(4),       Shell)){
			sprite_index = sprShotShell;
		}
	}
	sleep(100);
	
	
#define GatorStatueFlak_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprEFlak;
		image_speed  = 0.4;
		depth        = -1;
		
		 // Vars:
		mask_index   = mskFlakBullet;
		image_xscale = 0;
		image_yscale = 0;
		visible      = false;
		damage       = 4;
		typ          = 2;
		grow         = 1/45;
		effect_color = make_color_rgb(252, 56, 0);
		
		 // Alarms:
		alarm0 = irandom_range(1, 10);
		
		 // Find Player:
		if(instance_exists(Player)){
			with(array_shuffle(instances_matching(Floor, "", null))){
				if(!place_meeting(x, y, Wall)){
					if(distance_to_object(Player) < 96 && !place_meeting(x, y, Player)){
						other.x = bbox_center_x;
						other.y = bbox_center_y;
					}
				}
			}
		}
		
		return id;
	}
	
#define GatorStatueFlak_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Active:
	if(visible){
		 // Grow:
		image_xscale += grow * current_time_scale;
		image_yscale += grow * current_time_scale;
		var _scale = max(image_xscale, image_yscale);
		
		 // Particles:
		if(chance_ct(1, 2)){
			with(scrFX(x, y, random_range(2, 5) * _scale, PlasmaTrail)){
				sprite_index = spr.QuasarBeamTrail;
			}
		}
		
		 // Explode:
		if(_scale > 1){
			instance_destroy();
		}
	}
	
#define GatorStatueFlak_alrm0
	 // Activate:
	visible = true;
	with(instance_create(x, y, ThrowHit)){
		image_blend = other.effect_color;
	}
	sound_play_hit_ext(sndServerBreak, 2 + orandom(0.2), 1.2);
	
#define GatorStatueFlak_destroy
	 // Blammo:
	team_instance_sprite(
		sprite_get_team(sprite_index),
		projectile_create(x, y, EFlakBullet, 0, 0)
	);
	
	
#define Manhole_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.PizzaManhole[irandom(array_length(spr.PizzaManhole) - 1)];
		image_index  = 0;
		image_speed  = 0;
		depth        = 5;
		
		 // Vars:
		mask_index = mskWepPickup;
		contact    = false;
		area       = "pizza";
		subarea    = 0;
		loops      = GameCont.loops;
		
		 // Floor:
		with(instances_at(x, y, FloorNormal)){
			switch(sprite_index){
				case sprFloor2   : image_index = choose(0, 2, 4, 5); break;
				case sprFloor101 : break;
				default          : image_index = 0;
			}
		}
		
		return id;
	}
	
#define Manhole_step
	if(visible){
		 // Closed:
		if(image_index < image_number - 1){
			 // Effects:
			if(area_get_underwater(GameCont.area) && chance_ct(1, 4)){
				with(instance_create(x, y, Bubble)){
					motion_set(90 + orandom(5), 4 + random(3));
					friction = 0.2;
				}
			}
			
			 // Open:
			if(place_meeting(x, y, Explosion) || (contact && place_meeting(x, y, Player))){
				var _open = true;
				
				 // Boss Exists:
				with(enemy) if(enemy_boss){
					_open = false;
					break;
				}
				
				if(_open){
					image_index++;
					
					if(image_index >= image_number - 1){
						image_index = image_number - 1;
						
						 // Effects:
						sleep(50);
						view_shake_at(x, y, 20);
						if(area_get_underwater(GameCont.area)){
							repeat(10 + irandom(10)){
								with(instance_create(x, y, Bubble)){
									motion_set(random(360), 1 + random(2));
								}
							}
						}
						
						 // Area-Specific:
						switch(area){
							
							case "pizza":
								
								 // Splat:
								var _ang = random(360);
								for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 3)){
									with(obj_create(x, y, "WaterStreak")){
										direction   = _dir + orandom(20);
										speed       = 4 + random(1);
										image_angle = direction;
										image_blend = c_orange;
									}
								}
								
								break;
								
							case "trench":
								
								 // Debris:
								repeat(5 + irandom(5)){
									with(instance_create(x, y, Debris)){
										motion_set(random(360), 3 + random(5));
									}
								}
								
								 // Sound:
								sound_play_pitchvol(sndPillarBreak,   0.8, 1.2);
								sound_play_pitchvol(sndOasisPortal,   1,   0.3);
								sound_play_pitchvol(sndSnowTankShoot, 0.6, 0.3);
								
								break;
								
						}
						
						 // Area:
						area_set(area, subarea, loops);
						
						 // Portal:
						GameCont.killenemies = true;
						with(instance_create(x, y, Portal)){
							image_alpha = 0;
							mask_index = mskExploder;
						}
						sound_stop(sndPortalOpen);
					}
				}
			}
		}
		
		 // Opened:
		else{
			 // No Zap:
			if(place_meeting(x, y, PortalL)){
				with(instances_meeting(x, y, PortalL)){
					if(place_meeting(x, y, other)){
						instance_destroy();
					}
				}
			}
			
			 // Clear Corpses:
			var	_obj = [Corpse, ChestOpen],
				_dis = 16,
				_spd = 2;
				
			for(var i = 0; i < array_length(_obj); i++){
				if(place_meeting(x, y, _obj[i])){
					with(instances_matching_lt(instances_meeting(x, y, _obj[i]), "speed", _spd)){
						if(place_meeting(x, y, other)){
							var _dir = point_direction(other.x, other.y, x, y);
							if(friction > 0){
								motion_add_ct(_dir, friction + 0.4);
							}
							else{
								x += lengthdir_x(_spd - 0.4, _dir);
								y += lengthdir_y(_spd - 0.4, _dir);
							}
						}
					}
				}
			}
		}
	}
	
	 // Activate:
	else if(instance_exists(Portal)){
		visible = true;
		
		 // Notice me bro:
		sound_play_hit_ext(sndPillarBreak, 0.7 + random(0.1), 8);
		repeat(3) scrFX(x, y, 2, Smoke);
	}
	
	
#define NewTable_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle   = spr.TableIdle;
		spr_hurt   = spr.TableHurt;
		spr_dead   = spr.TableDead;
		spr_shadow = shd32;
		depth      = -1;
		
		 // Sounds:
		snd_hurt = sndHitMetal;
		snd_dead = sndHydrantBreak;
		
		 // Vars:
		maxhealth = 8;
		size      = 2;
		
		return id;
	}
	
	
#define Paper_create(_x, _y)
	with(instance_create(_x, _y, Feather)){
		 // Visual:
		sprite_index = spr.Paper;
		image_index  = irandom(image_number - 1);
		image_speed  = 0;
		
		 // Vars:
		friction = 0.2;
		
		return id;
	}
	
	
#define PizzaDrain_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle = spr.PizzaDrainIdle;
		spr_walk = spr_idle;
		spr_hurt = spr.PizzaDrainHurt;
		spr_dead = spr.PizzaDrainDead;
		spr_floor = -1;
		spr_shadow = -1;
		image_xscale = choose(-1, 1);
		image_speed = 0.4;
		depth = -1;
		
		 // Sound:
		snd_hurt = sndHitMetal;
		snd_dead = sndStatueDead;
		
		 // Vars:
		mask_index   = msk.PizzaDrain;
		maxhealth    = 40;
		team         = 0;
		size         = 3;
		area         = "lair";
		subarea      = 1;
		loops        = GameCont.loops;
		styleb       = 1;
		hallway_size = 320;
		my_floor     = noone;
		
		 // Cool Floor:
		with(instance_nearest_bbox(_x - 16, _y, Floor)){
			image_index = 3;
		}
		
		return id;
	}
	
#define PizzaDrain_step
	 // Manual Collision for Projectiles Hitting Wall:
	if(place_meeting(x, y, projectile)){
		with(instances_meeting(x, y, projectile)){
			if(place_meeting(x, y, other) && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
				event_perform(ev_collision, hitme);
			}
		}
	}
	
	 // Stay Still:
	x = pround(xstart, 16) - 16;
	y = pround(ystart, 16);
	speed = 0;
	
	if(!instance_exists(GenCont)){
		 // Floorerize:
		if(!instance_exists(my_floor)){
			var	_w = 32,
				_h = 32;
				
			floor_set_align(x, null, 16, 16);
			
			 // Clear:
			with(instance_rectangle_bbox(x - _w, y - _h, x + _w - 1, y - 1, [Floor, TopPot, Bones])){
				instance_delete(id);
			}
			
			 // Side Tiles:
			for(var _x = x - _w; _x < x + _w; _x += 16){
				floor_set(_x, y - 16, 2);
			}
			
			 // Main Floor:
			floor_set_style(styleb, area);
			my_floor = floor_set(x - 16, y - 32, true);
			with(my_floor){
				if(sprite_exists(other.spr_floor)){
					sprite_index = other.spr_floor;
				}
			}
			floor_reset_align();
			floor_reset_style();
			
			 // Walls:
			for(var	_x = x - _w; _x < x + _w; _x += 16){
				for(var	_y = y - _h; _y < y; _y += 16){
					instance_create(_x, _y, Wall);
				}
			}
		}
		
		 // Takeover Walls:
		if(place_meeting(x, y, Wall)){
			with(instance_nearest_bbox(bbox_left  - 8, y - 8, Wall)) outindex = 0;
			with(instance_nearest_bbox(bbox_right + 8, y - 8, Wall)) outindex = 0;
			while(place_meeting(x, y, Wall)){
				with(instances_meeting(x, y, Wall)){
					instance_create(x, y, InvisiWall);
					sprite_index = area_get_sprite(GameCont.area, sprWall1Trans);
					visible      = true;
					topspr       = -1;
					outspr       = -1;
					y           -= 16;
				}
			}
		}
	}
	
	 // Push:
	if(place_meeting(x, y, hitme)){
		var	_x = x,
			_y = y - 8;
			
		with(instances_meeting(x, y, hitme)){
			if(place_meeting(x, y, other) && !instance_is(self, prop)){
				motion_add_ct(((y <= _y) ? 270 : point_direction(_x, _y, x, y)), 0.6);
			}
		}
	}
	
	 // Animate:
	if(sprite_index == spr_idle){
		if(image_index < 1){
			image_index -= image_speed_raw * random_range(0.98, 1);
		}
	}
	else if(anim_end){
		sprite_index = spr_idle;
		image_index = 0;
	}
	
	 // Break:
	if(place_meeting(x, y, Explosion)){
		my_health = 0;
	}
	if(name == "PizzaDrain"){
		with(instances_matching_le(FloorExplo, "y", y - hallway_size)){
			instance_create(clamp(other.x, bbox_left, bbox_right + 1), y, PortalClear);
			other.my_health = 0;
		}
	}
	with(instance_rectangle(bbox_left - 16, y - hallway_size, bbox_right + 16, bbox_top - 16, FloorExplo)){
		instance_create(clamp(other.x, bbox_left, bbox_right + 1), y, PortalClear);
		other.my_health = 0;
	}
	
	 // Death:
	if(my_health <= 0) instance_destroy();

#define PizzaDrain_end_step
	x = pround(xstart, 16) - 16;
	y = pround(ystart, 16);
	speed = 0;

#define PizzaDrain_destroy
	portal_poof();
	
	 // Sound:
	sound_play_pitch(snd_dead, 1 - random(0.3));
	with(instance_nearest(x, y, Player)){
		sound_play_pitchvol(snd_chst, 1, 0.9);
	}
	
	 // Turt:
	with(instances_matching(CustomHitme, "name", "TurtleCool")){
		notice_delay = max(1, notice_delay);
	}
	
	 // Deleet Stuff:
	var	_x1 = bbox_left,
		_y1 = bbox_top - 16,
		_x2 = bbox_right,
		_y2 = bbox_bottom;
		
	if(fork()){
		repeat(2){
			wall_delete(_x1, _y1, _x2, _y2);
			wait 0;
		}
		exit;
	}
	
	 // Corpse:
	corpse_drop(0, 0);
	repeat(6){
		with(instance_create(x + orandom(8), y + orandom(8), Debris)){
			direction = angle_lerp(direction, 90, 1/4);
		}
	}
	
	/// Entrance:
		var	_sx = pfloor(x, 32),
			_sy = pfloor(y, 32) - 16,
			_bgColor = background_color;
			
		 // Borderize Area:
		var _borderY = _sy - hallway_size + 72;
		area_border(_borderY, string(GameCont.area), _bgColor);
		
		 // Path Gen:
		var	_dir = 90,
			_path = [];
			
		instance_create(_sx + 16, _sy + 16, PortalClear);
		
		while(_sy >= _borderY - 224){
			with(instance_create(_sx, _sy, Floor)){
				array_push(_path, id);
				wall_delete(bbox_left, bbox_top, bbox_right, bbox_bottom);
			}
			
			 // Turn:
			if(in_range(_sy, _borderY - 160, _borderY - 32)){
				_dir += choose(0, 0, 0, 0, -90, 90);
				if(abs(angle_difference(_dir, 90)) > 90){
					_dir = 90;
				}
			}
			else _dir = 90;
			
			 // Move:
			_sx += lengthdir_x(32, _dir);
			_sy += lengthdir_y(32, _dir);
		}
		
		 // Generate the Realm:
		var _lastArea = GameCont.area;
		if(!instance_exists(Portal)){
			var _scrSetup = null;
			if(crown_current == "red"){
				_scrSetup = script_ref_create_ext("crown", "red", "step");
			}
			area_generate(area, subarea, loops, _sx + 16, _sy - 16, true, 0, _scrSetup);
		}
		
		 // Finish Path:
		var _minID = GameObject.id;
		with(_path){
			styleb = true;
			area = GameCont.area;
			sprite_index = area_get_sprite(area, sprFloor1B);
			floor_walls();
			
			 // Pipe Decals:
			if(!in_range(_borderY, bbox_top, bbox_bottom + 1)){
				GameCont.area = ((y > _borderY) ? _lastArea : area);
				floor_bones(1, 1/12, true);
				GameCont.area = area;
			}
		}
		with(instances_matching_gt(Wall, "id", _minID)){
			wall_tops();
		}
		with(instances_matching_gt(TopSmall, "id", _minID)){
			with(self){
				event_perform(ev_alarm, 0);
			}
		}
		
		 // Reveal Path:
		var	_y    = y - 48,
			_time = 7,
			_wait = 0;
			
		with(floor_reveal(bbox_left, _y, bbox_right, y - 16 - 1, 10)){
			color = _bgColor;
			_wait += time - _time;
		}
		with(instances_matching_lt(_path, "bbox_top", _y)){
			if(bbox_bottom > _borderY){
				with(floor_reveal(bbox_left, bbox_top, bbox_right, min(_y - 1, bbox_bottom), _time)){
					y1 = max(y1, _borderY - oy);
					time += _wait;
					color = _bgColor;
				}
			}
			if(bbox_top < _borderY){
				with(floor_reveal(bbox_left, bbox_top, bbox_right, bbox_bottom, _time)){
					y2 = min(y2, _borderY - oy - 1);
					time += _wait;
				}
			}
			_wait += 3;
		}
		
		 // Crown Time:
		if(GameCont.area == "lair"){
			unlock_set("crown:crime", true);
		}
		
	
#define PizzaManholeCover_create(_x, _y)
	repeat(2 + irandom(2)){
		with(instance_create(_x + orandom(20), _y + orandom(20), GroundFlame)){
			sprite_index = (chance(1, 3) ? sprGroundFlameBig : sprGroundFlame);
			alarm0 = ceil(random(alarm0));
			image_blend = c_ltgray;
		}
	}
	
	with(instance_create(_x, _y, CustomObject)){
		sprite_index = spr.Manhole;
		image_angle  = 180 + (irandom_range(-3, 3) * 10);
		image_speed  = 0;
		depth        = 6;
		
		x += orandom(8);
		y += orandom(8);
		
		return id;
	}
	
	
#define PizzaRubble_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle = spr.PizzaRubbleIdle;
		spr_walk = spr_idle;
		spr_hurt = spr.PizzaRubbleHurt;
		spr_dead = mskNone;
		spr_shadow = mskNone;
		image_xscale = choose(-1, 1);
		image_speed = 0.4;
		depth = -7;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = sndWallBreakScrap;
		
		 // Vars:
		mask_index = msk.PizzaRubble;
		maxhealth = 40;
		team = 0;
		size = 3;
		inst = [];
		peas = false;
		
		 // Walls:
		instance_create(x,      y + 16, Wall);
		instance_create(x - 16, y + 16, Wall);
		instance_create(x,      y + 8,  InvisiWall);
		instance_create(x - 16, y + 8,  InvisiWall);
		
		 // Effects:
		view_shake_at(x, y, 20);
		repeat(12) with(scrFX([x, 8], [y, 8], 4, Dust)){
			image_xscale *= 2;
			image_yscale *= 2;
			depth = -8;
		}
		
		return id;
	}
	
#define PizzaRubble_step
	 // Manual Collision for Projectiles Hitting Wall:
	if(place_meeting(x, y, projectile)){
		with(instances_meeting(x, y, projectile)){
			if(place_meeting(x, y, other) && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
				event_perform(ev_collision, hitme);
			}
		}
	}
	
	 // Stay Still:
	x = xstart;
	y = ystart;
	speed = 0;
	
	 // Hold Caved Instances:
	with(inst){
		if(instance_exists(self)){
			if(instance_is(self, Pickup) && alarm0 > 0){
				alarm0 = max(alarm0, 90);
			}
			else if(instance_is(self, hitme) && !chance_ct(1, speed) && chance(1, 2)){
				with(scrFX(x, y, [90 + orandom(30), random(3)], Dust)){
					depth = other.depth + choose(0, -1);
				}
			}
			x = other.x;
			y = other.y + 16;
			xprevious = x;
			yprevious = y;
			speed = 0;
		}
		else other.inst = array_delete_value(other.inst, self);
	}
	
	 // Animate:
	if(sprite_index != spr_idle && anim_end){
		sprite_index = spr_idle;
	}
	
	 // Pea Sparkles:
	if(peas && chance_ct(1, 3)){
		with(instance_create(
			random_range(bbox_left, bbox_right),
			random_range(bbox_top,  bbox_bottom),
			LaserCharge
		)){
			sprite_index = sprSpiralStar;
			image_blend  = make_color_rgb(147, 202, 86);
			depth		 = other.depth - 1;
			alarm0		 = random_range(8, 16);
			motion_set(90, random_range(1, 2));
		}
	}
	
	 // Die:
	if(!place_meeting(x, y, Wall)) my_health = 0;
	if(my_health <= 0) instance_destroy();

#define PizzaRubble_hurt(_hitdmg, _hitvel, _hitdir)
	enemy_hurt(_hitdmg, _hitvel, _hitdir);

	 // Diggin FX:
	if(chance(_hitvel, 8)){
		repeat(irandom_range(1, ceil(sqrt(_hitdmg)))) if(chance(1, my_health / 10)){
			with(instance_create(random_range(bbox_left, bbox_right + 1), y + 8, Debris)){
				depth = 1;
				direction = 90 + orandom(60);
				sound_play_hit(sndWallBreak, 0.4);
			}
		}
	}

#define PizzaRubble_destroy
	 // Sound:
	sound_play_pitch(snd_dead, 1 + random(0.3));

	 // Corpse:
	repeat(12){
		with(obj_create(x + orandom(8), y + orandom(8), "CatDoorDebris")){
			sprite_index = sprDebris102;
			image_index = irandom(image_number - 1);
			direction = random(360);
			speed = random_range(2, 8);
			shine = 5;
		}
		scrFX(x, y, 4, Dust);
	}

	 // Destroy Walls:
	with(instance_create(x, y + 24, PortalClear)){
		sprite_index = mskPlasmaImpact;
		image_index = image_number - 4;
		image_speed = -1.2;
	}
	with(instances_meeting(x, y, [Wall, InvisiWall])){
		if(object_index == Wall) instance_create(x, y, FloorExplo);
		instance_destroy();
	}

	 // Free Boys:
	with(inst) if(instance_exists(self)){
		visible = true;
		x += orandom(4);
		y += orandom(4);
		
		 // Why do they break walls tell me
		if(instance_is(self, HealthChest)) mask_index = -1;
	}

	 // Pizza time:
	with(pet_spawn(x, y + 16, "CoolGuy")){
		
		 // Peas:
		if(other.peas){
			var _lastIcon = spr_icon;
			spr_icon = spr.PetPeasIcon;
			spr_idle = spr.PetPeasIdle;
			spr_walk = spr.PetPeasWalk;
			spr_hurt = spr.PetPeasHurt;
			sprite_index = spr_idle;
			
			with(prompt){
				text = string_replace(
					text, 
					string(_lastIcon), 
					string(other.spr_icon)
				) + "?";
			}
		}
	}


#define PizzaTV_create(_x, _y)
	with(instance_create(_x, _y, TV)){
		 // Visual:
		spr_hurt = spr.TVHurt;
		spr_dead = spr_hurt;

		 // Vars:
		maxhealth = 15;
		my_health = maxhealth;

		return id;
	}

#define PizzaTV_end_step
	x = xstart;
	y = ystart;
	depth = 0; // why must i force depth every frame mmmm
	
	 // Death without needing a corpse sprite haha:
	if(my_health <= 0){
		corpse_drop(0, 0);
		
		 // Zap:
		sound_play_pitch(sndPlantPotBreak, 1.6);
		sound_play_pitchvol(sndLightningHit, 1, 2);
		repeat(2) instance_create(x, y, PortalL);
		
		instance_delete(id);
	}
	
	
#define SewerDrain_create(_x, _y)
	with(obj_create(_x, _y, "PizzaDrain")){
		 // Visual:
		spr_idle     = spr.SewerDrainIdle;
		spr_walk     = spr_idle;
		spr_hurt     = spr.SewerDrainHurt;
		spr_dead     = spr.SewerDrainDead;
		spr_floor    = spr.FloorSewerDrain;
		sprite_index = spr_idle;
		
		 // Vars:
		area         = area_sewers;
		styleb       = 0;
		hallway_size = 160;
		
		 // Room Type:
		type = pool([
			[WeaponChest,   4],
			[AmmoChest,     4],
			["Backpack",    4],
			[HealthChest,   3],
			["LairChest",   3 * unlock_get("crown:crime")],
			["Pizza",       2],
			["GatorStatue", 2 * (skill_get(mut_shotgun_shoulders) <= 0)],
			["RedSpider",   2],
			[FrogQueen,     1]
		]);
		
		 // Events:
		on_destroy = script_ref_create(SewerDrain_destroy);
		
		return id;
	}
	
#define SewerDrain_destroy
	var _roomType = type;
	
	 // Sound:
	sound_play_pitch(snd_dead, 1 - random(0.3));
	with(instance_nearest(x, y, Player)){
		sound_play_pitchvol(snd_chst, 1, 0.9);
	}
	
	 // Deleet Stuff:
	var	_x1 = bbox_left,
		_y1 = bbox_top,
		_x2 = bbox_right,
		_y2 = bbox_bottom;
		
	if(fork()){
		repeat(2){
			wall_delete(_x1, _y1, _x2, _y2);
			wait 0;
		}
		exit;
	}
	
	 // Corpse:
	corpse_drop(0, 0);
	repeat(6){
		with(instance_create(x + orandom(8), y + orandom(8), Debris)){
			direction = angle_lerp(direction, 90, 1/4);
		}
	}
	
	 // Secret Room:
	with(my_floor){
		var	_x        = bbox_center_x,
			_y        = bbox_center_y,
			_w        = 4,
			_h        = 3,
			_type     = "",
			_dirStart = 90,
			_dirOff   = 0,
			_floorDis = 32,
			_minID    = GameObject.id;
			
		with(floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
			 // Entrance Hallway:
			with(floor_tunnel(x, y2, _x, _y)){
				floor_reveal(bbox_left, bbox_top, bbox_right, bbox_bottom, 10);
			}
			
			 // Walls:
			with([
				instance_create(x1,      y1 + 16, Wall),
				instance_create(x2 - 16, y1 + 16, Wall),
				instance_create(x1,      y2 - 32, Wall),
				instance_create(x2 - 16, y2 - 32, Wall)
			]){
				if(chance(1, 2)){
					topindex = irandom_range(1, sprite_get_number(topspr) - 1);
				}
			}
			
			 // Floor Setup:
			var _detailNum = 4;
			with(array_shuffle(floors)){
				 // Details:
				if(chance(1, 5) || _detailNum-- > 0){
					var	_dx = random_range(bbox_left, bbox_right),
						_dy = random_range(bbox_top, bbox_bottom);
						
					with(instance_create(_dx, _dy, Detail)){
						if(_roomType == "Pizza"){
							sprite_index = sprDetail102;
							image_index = irandom_range(1, 4);
						}
					}
					
					 // Shells:
					if(_roomType == "GatorStatue"){
						with(instance_create(_dx, _dy, Debris)){
							sprite_index = (chance(1, 4) ? sprShotShellBig : sprShotShell);
							motion_add(random(360), random(1));
							alarm0 = -1;
						}
					}
				}
				
				 // Dustify:
				repeat(2){
					var	_dx = random_range(bbox_left, bbox_right),
						_dy = random_range(bbox_top, bbox_bottom);
						
					with(scrFX(_dx, _dy, [point_direction(_dx, _dy, _x, _y) + orandom(30), 3], Dust)){
						image_xscale *= 2.5;
						image_yscale *= 2.5;
					}
				}
				
				 // Spiderize:
				if(_roomType != "Pizza" && chance(2, 3)){
					if(_roomType == "RedSpider" || (chance(1, 2) && !point_in_rectangle(other.x, other.y, bbox_left, bbox_top, bbox_right + 1, bbox_bottom + 1))){
						sprite_index = spr.FloorSewerWeb;
						material = 5;
						traction = 2;
					}
				}
			}
			
			 // Room Gen:
			var _ox = 24 * choose(-1, 1);
			switch(_roomType){
				
				case WeaponChest:
				case AmmoChest:
				case HealthChest:
				case "Backpack":
				case "LairChest":
					
					var	_num = 2 + skill_get(mut_open_mind),
						_obj = [_roomType];
						
					 // Type-Specific:
					switch(_roomType){
						case HealthChest:
						case "Backpack":
							_num--;
							break;
							
						case "LairChest":
							_obj = ["BatChest", "CatChest"];
							break;
					}
					
					 // Create Objects:
					if(_num <= 1) _ox = 0;
					for(var i = 0; i < _num; i++){
						chest_create(
							x + orandom(1) + lerp(-_ox, _ox, i / (_num - 1)),
							y + orandom(1),
							_obj[i % array_length(_obj)],
							true
						);
					}
					
					break;
					
				case "Pizza":
					
					 // Manhole:
					with(instance_nearest_bbox(x + _ox, y, FloorNormal)){
						obj_create(bbox_center_x, bbox_center_y, "Manhole");
						
						 // Pizza:
						if(chance(2, 3)){
							var _px = bbox_center_x + orandom(4) + random(16 * sign(_ox)),
								_py = bbox_center_y + orandom(4);
								
							if(chance(1, 2)){
								obj_create(_px, _py, "PizzaStack");
							}
							else{
								chest_create(_px, _py, "PizzaChest", true);
							}
						}
					}
					
					 // Nader:
					with(obj_create(x - _ox, y, "WepPickupGrounded")){
						target = instance_create(x, y, WepPickup);
						with(target){
							wep  = wep_grenade_launcher;
							ammo = true;
						}
					}
					
					break;
					
				case "RedSpider":
					
					with(floors){
						if(chance(2, 3) && !place_meeting(x, y, Wall) && !place_meeting(x, y, hitme)){
							 // Props:
							if(chance(1, 3)){
								obj_create(bbox_center_x + orandom(8), bbox_center_y + orandom(8), "CrystalPropRed");
							}
							
							 // Enemies:
							else{
								obj_create(bbox_center_x, bbox_center_y, _roomType);
							}
						}
					}
					
					break;
					
				case FrogQueen:
					
					 // Cool Floors:
					floor_set_style(1, null);
					floor_fill(x1 + 16, y, 1, _h, "");
					floor_fill(x2 - 16, y, 1, _h, "");
					floor_reset_style();
					
					 // Herself:
					with(instance_create(x, y, _roomType)){
						maxhealth = round(maxhealth / 2);
						my_health = round(my_health / 2);
						alarm3 = 60;
						
						 // Ammo:
						_ox = (((_w * 32) / 2) - 16) * sign(_ox);
						var _num = 2 + skill_get(mut_open_mind);
						for(var i = 0; i < _num; i++){
							chest_create(
								x + orandom(1) + lerp(-_ox, _ox, i / (_num - 1)),
								y + orandom(1),
								choose(AmmoChest, WeaponChest),
								true
							);
						}
					}
					
					break;
					
				case "GatorStatue":
					
					with(obj_create(x, y - 4, _roomType)){
						with(obj_create(x, y - 22, "CatLight")){
							w1 = 14;
							w2 = 34;
							h1 = 34;
							h2 = 7;
						}
					}
					
					break;
					
			}
			
			 // Decorate:
			repeat(2){
				obj_create(x, y, "TopDecal");
			}
		}
		
		 // Reveal Room:
		with(instances_matching_gt(Floor, "id", _minID)){
			floor_reveal(bbox_left, bbox_top, bbox_right, bbox_bottom, 10);
		}
	}
	sleep(100);
	
	 // No Leaving:
	if(instance_exists(enemy)) portal_poof();
	
	
#define SewerRug_create(_x, _y)
	with(instance_create(_x, _y, Carpet)){
		 // Visual:
		sprite_index = spr.Rug;
		image_index = (array_exists([area_pizza_sewers, "pizza"], GameCont.area) ? 1 : 0);
		image_speed = 0;
		
		return id;
	}
	
	
#define TurtleCool_create(_x, _y)
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle    = sprTurtleIdle;
		spr_walk    = sprTurtleFire;
		spr_hurt    = sprTurtleHurt;
		spr_dead    = sprTurtleDead;
		spr_shadow  = shd24;
		image_speed = 0.4;
		depth       = -2;
		
		 // Sound:
		snd_hurt = sndTurtleHurt;
		snd_dead = sndTurtleDead1;
		
		 // Vars:
		mask_index   = mskBandit;
		friction     = 0.4;
		maxhealth    = 15;
		maxspeed     = 2.5;
		size         = 4;
		team         = 0;
		right        = choose(-1, 1);
		patience     = random_range(30, 40);
		notice_delay = random_range(1, 8);
		notice_max   = 80;
		notice       = notice_max;
		become       = Turtle;
		
		 // No Portals:
		with(obj_create(0, 0, "PortalPrevent")){
			creator = other;
		}
		
		return id;
	}
	
#define TurtleCool_step
	if(!point_seen(x, y, -1) && patience > 0){
		exit;
	}
	
	 // Noticable Players:
	var _players = [];
	with(Player){
		if(instance_near(x, y, other, 96)){
			array_push(_players, id);
		}
	}
	
	 // Player Being Annoying:
	if(notice < 90){
		with(instances_matching_gt(_players, "reload", 0)){
			with(other){
				notice = max(notice, 8);
				notice += ((other.reload / 3) + random(3)) * current_time_scale;
				//patience -= current_time_scale;
			}
		}
		with(instances_matching_gt(instances_matching(_players, "race", "steroids"), "breload", 0)){
			with(other){
				notice = max(notice, 8);
				notice += ((other.breload / 3) + random(3)) * current_time_scale;
				//patience -= current_time_scale;
			}
		}
	}
	
	 // Watchin Player:
	if(array_length(_players) > 0 && notice > 0){
		var _target = instance_nearest_array(x, y, _players);
		
		if(notice_delay > 0){
			notice_delay -= current_time_scale;
			
			 // Initial Notice:
			if(notice_delay <= 0){
				with(instance_create(x, y, SteroidsTB)){
					depth = -8;
				}
			}
		}
		
		 // Face Player:
		else{
			notice -= current_time_scale;
			scrRight(point_direction(x, y, _target.x, _target.y));
		}
	}
	
	 // Watchin TV:
	else{
		var _target = instance_near(x, y, instance_seen(x, y, TV), 96);
		if(instance_exists(_target)){
			scrRight(point_direction(x, y, _target.x, _target.y));
		}
	}
	
	 // Push Collision:
	if(place_meeting(x, y, hitme)){
		with(instances_meeting(x, y, hitme)){
			if(place_meeting(x, y, other)){
				if(!instance_is(self, prop)){
					motion_add(point_direction(other.x, other.y, x, y), 1);
				}
				with(other){
					if(instance_is(other, Player)){
						notice = max(notice, 30);
						patience -= current_time_scale;
					}
					motion_add(point_direction(other.x, other.y, x, y), 1);
				}
			}
		}
	}
	speed = min(speed, maxspeed);
	
	 // Wall Collision:
	if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
		if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw = 0;
		if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw = 0;
	}
	
	 // Angered:
	var _angered = false;
	if(my_health < maxhealth || !instance_exists(TV)){
		_angered = true;
	}
	else{
		with(instances_matching([Turtle, Rat], "", null)){
			if(my_health < maxhealth && instance_seen(x, y, other)){
				_angered = true;
			}
		}
		with(instances_matching(Corpse, "sprite_index", sprTurtleDead, sprRatDead)){
			if(instance_seen(x, y, other)){
				_angered = true;
			}
		}
	}
	if(_angered){
		with(instances_matching(object_index, "name", name)) patience = 0;
	}
	if(patience <= 0){
		var	_damage = (my_health - maxhealth),
			_vars   = { "x":x, "y":y, "nexthurt":nexthurt, "sprite_index":sprite_index, "image_index":image_index, "snd_dead":snd_dead, "right":right };
			
		instance_change(become, true);
		
		if(instance_exists(self)){
			my_health += _damage;
			alarm1 = 10 + random(10);
			variable_instance_set_list(id, _vars);
			
			 // Alert:
			sound_play_hit(sndTurtleMelee, 0.3);
			with(instance_create(x, y, AssassinNotice)){
				depth = -8;
			}
			if(my_health < maxhealth){
				scrRight(direction + 180);
			}
		}
		
		 // Allow Portals:
		with(instances_matching(instances_matching(becomenemy, "name", "PortalPrevent"), "creator", self)){
			instance_destroy();
		}
	}
	
#define TurtleCool_draw
	draw_self_enemy();
	
	
/// GENERAL
#define ntte_step
	 // Dissipate Cat Gas Faster:
	if(instance_exists(ToxicGas)){
		var _inst = instances_matching_lt(instances_matching(ToxicGas, "cat_toxic", true), "speed", 0.1);
		if(array_length(_inst)) with(_inst){
			growspeed -= random(0.002 * current_time_scale);
		}
	}
	
#define ntte_shadows
	if(instance_exists(CustomHitme)){
		 // Doors:
		var _inst = instances_matching(instances_matching(CustomHitme, "name", "CatDoor"), "visible", true);
		if(array_length(_inst)) with(_inst){
			var	_yscale = 0.5 + (0.5 * max(abs(dcos(image_angle + openang)), abs(dsin(image_angle + openang))));
			with(surface_setup(name + string(id), null, null, null)){
				draw_surface_ext(surf, x, y + (h / 2) + (((other.image_number - 1) - (h / 2)) * _yscale), 1 / scale, _yscale / scale, 0, c_white, 1);
			}
		}
		
		 // Fix Pizza Drain Shadows:
		var _inst = instances_matching(instances_matching(CustomHitme, "name", "PizzaDrain", "SewerDrain"), "visible", true);
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(sprite_index, image_index, x, y - 14, image_xscale, -image_yscale, image_angle, c_white, 1);
		}
	}
	
#define ntte_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
			
			var _gray = (_type == "normal");
			
			if(instance_exists(CustomObject)){
				 // Cat Light:
				var _inst = instances_matching(instances_matching(CustomObject, "name", "CatLight"), "visible", true);
				if(array_length(_inst)){
					var _border = 2 * _gray;
					with(_inst){
						draw_catlight(x, y, w1 + _border, w2 + (6 * _border), h1 + (2 * _border), h2 + _border, offset);
					}
				}
				
				 // Manhole Cover:
				var _inst = instances_matching(instances_matching(CustomObject, "name", "PizzaManholeCover"), "visible", true);
				if(array_length(_inst)){
					 // Circle:
					if(_gray){
						with(_inst){
							draw_circle(xstart, ystart - 16, 40 + random(2), false);
						}
					}
					
					 // Hole in Ceiling:
					else with(_inst){
						var _off = (
							chance(1, 2)
							? orandom(1)
							: 0
						);
						draw_catlight(xstart, ystart - 32, 16, 19, 28, 8, _off);
					}
				}
				
				 // Boss Manhole:
				if(_gray){
					var _inst = instances_matching(instances_matching(CustomObject, "name", "CatHoleBig"), "visible", true);
					if(array_length(_inst)) with(_inst){
						draw_circle(x, y, 192 + random(2), false);
					}
				}
			}
			
			 // TV:
			if(instance_exists(TV)){
				var _inst = instances_matching(TV, "visible", true);
				if(array_length(_inst)){
					 // Circle:
					if(_gray){
						with(_inst){
							draw_circle(x, y, 64 + random(2), false);
						}
					}
					
					 // TV Beam:
					else with(_inst){
						var _off = orandom(1);
						draw_catlight(x + 1, y - 6, 12 + abs(_off), 48 + _off, 48, 8 + _off, 0);
					}
				}
			}
			
			 // Big Bat:
			if(instance_exists(CustomEnemy)){
				var _inst = instances_matching(instances_matching(CustomEnemy, "name", "BatBoss", "CatBoss"), "visible", true);
				if(array_length(_inst)){
					var _r = 28 + (36 * _gray);
					with(_inst){
						draw_circle(x, y, _r + random(2), false);
					}
				}
			}
			
			break;
	}
	
#define ntte_bloom
	 // Flame Spark:
	if(instance_exists(Sweat)){
		var _inst = instances_matching(Sweat, "name", "FlameSpark");
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 3, image_yscale * 3, image_angle, image_blend, image_alpha * 0.1);
		}
	}
	
	 // Gator Statue Flak:
	if(instance_exists(CustomProjectile)){
		var _inst = instances_matching(CustomProjectile, "name", "GatorStatueFlak");
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * 0.1);
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