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
		
		return self;
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
		sound_play_pitchvol(sndSniperTarget,     0.8 + random(0.2), 0.6);
		sound_play_pitchvol(sndUltraGrenadeSuck, 2.0 + random(1.0), 0.7);
		repeat(6) call(scr.fx, x, y, [image_angle + 180, random(3)], Smoke);
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
				call(scr.sleep_max, 25);
			}
			
			 // Splinters:
			var d = 90 * (1 - (ammo / ammo_max));
			for(var i = -sign(d); i <= sign(d); i += 2){
				with(call(scr.projectile_create,
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
			repeat(5) call(scr.fx, x, y, [random(360), 1 + random(2)], Smoke);
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
		projectile_hit(other, damage, force);
		if(instance_exists(other) && other.my_health > 0){
			target = other;
			speed = 0;
		}
		
		 // FX:
		repeat(4) call(scr.fx, x, y, 2, Smoke);
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
			call(scr.sound_play_at, x, y, sndHammer, 1.3 + random(0.2), 1.2);
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
		
		return self;
	}
	
#define AlbinoGator_step
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
			enemy_look(angle_lerp(gunangle, direction, 2/3));
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
		if(enemy_target(x, y) && target_visible){
			var _clamp = 2.4 * aim_factor;
			enemy_look(gunangle + clamp(angle_difference(target_direction, gunangle), -_clamp, _clamp));
		}
		
		 // Fire:
		if(gonnafire <= 0){
			alarm1 = 30;
			
			call(scr.projectile_create, x, y, "AlbinoBolt", gunangle, 16);
			
			sound_play_pitchvol(sndHeavyCrossbow, 1.2 + random(0.2), 0.8);
			sound_play_pitchvol(sndTurretFire,    0.8 + random(0.2), 0.8);
			
			motion_set(gunangle + 180, 3);
			wkick = 8;
		}
	}
	
	else if(enemy_target(x, y)){
		var _targetDir = target_direction;
		
		if(target_visible){
			enemy_look(_targetDir);
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
			else enemy_walk(
				gunangle + orandom(15),
				random_range(40, 60)
			);
		}
		
		 // Grenades:
		else if(
			grenades > 0
			&& cangrenade
			&& chance(1, 2)
			&& target_distance < 160
			&& !array_length(instances_matching(instances_matching(projectile, "creator", self), "team", team))
		){
			grenades--;
			alarm1 += 30;
			
			 // Re-aim:
			if(abs(angle_difference(_targetDir, gunangle)) > 60){
				enemy_look(_targetDir + orandom(30));
			}
			
			 // Throw Grenade:
			call(scr.projectile_create, x, y, "AlbinoGrenade", gunangle, random_range(8, 12));
			motion_add(gunangle + 180, 2);
			
			 // Sound:
			call(scr.sound_play_at, x, y, sndAssassinAttack, 1.0 + random(0.2), 2.5);
		}
		
		 // Wander:
		else{
			enemy_walk(gunangle + orandom(30), random_range(20, 60));
			enemy_look(direction);
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
	var	_hurt = (sprite_index != spr_hurt && nexthurt >= current_frame + 4),
		_back = (gunangle > 180);
		
	 // Laser Sight:
	if(gonnafire > 0){
		draw_set_color(make_color_rgb(252, 56, 0));
		call(scr.draw_lasersight, x, y, gunangle, 1000, aim_factor);
		draw_set_color(c_white);
	}
		
	 // Body and Gun:
	if(_hurt) draw_set_fog(true, c_black, 0, 0);
	if(_back) draw_self_enemy();
	
	call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
	
	if(!_back) draw_self_enemy();
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
	 // Halo:
	draw_sprite(spr_halo, halo_index, x, (y - 3) + sin(wave * 0.1));
	
#define AlbinoGator_hurt(_damage, _force, _direction)
	spirit = max(spirit - _damage, 0);
	nexthurt = current_frame + 6;
	
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
			motion_add(_direction, _force / 4);
		}
		
		 // Take Damage:
		else call(scr.enemy_hurt, _damage, _force, _direction);
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
		
		return self;
	}
	
#define AlbinoGrenade_step
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
	
	 // Effects:
	var _ang = pround(angle, 45);
	for(var _dir = _ang; _dir < _ang + 360; _dir += 90){
		if(chance_ct(1 + (alarm2 < 0), 4)){
			var _spd = random_range(1, 3);
			with(call(scr.fx, x, y, [_dir, _spd], PlasmaTrail)){
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
	call(scr.sound_play_at, x, y, sndIDPDNadeAlmost, 1.1 + random(0.2), 2);
	
#define AlbinoGrenade_alrm2
	 // Warning:
	sprite_index = sprHeavyGrenadeBlink;
	call(scr.sound_play_at, x, y, sndIDPDNadeLoad, 1.3 + random(0.2), 1.5);
	
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
		with(call(scr.projectile_create, x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "QuasarBeam", _dir)){
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
	call(scr.sound_play_at, x, y, sndExplosionL, 1.8 + random(0.2), 1.8);
	
	
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
		kick_invul = current_frame + 30;
		gunangle   = random(360);
		direction  = gunangle;
		
		 // Alarms:
		alarm1 = 30;
		
		return self;
	}
	
#define BabyGator_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Kickable:
	if(current_frame >= kick_invul && z <= 0 && place_meeting(x, y, Player)){
		with(call(scr.instances_meeting_instance, self, instances_matching_ne(Player, "team", team))){
			if(speed > 0 && place_meeting(x, y, other)){
				projectile_hit(other, 3, speed);
				
				 // Effects:
				sound_play_hit_big(sndImpWristKill, 0.3);
				
				instance_create(x, y, ImpactWrists);
				call(scr.fx, x, y, [direction, 4], "WaterStreak");
				
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
			projectile_hit_raw(self, 1, 1);
			
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
		if(current_frame_active){
			alarm1++;
		}
	}
	else if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
	}
	if(speed > maxspeed){
		speed = maxspeed;
	}

	 // Bounce:
	if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
		if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
		if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
		enemy_look(direction);
	}
	
	 // Animate:
	sprite_index = enemy_sprite;
	
#define BabyGator_alrm1
	alarm1 = 30 + random(60);
	
	if(
		enemy_target(x, y)
		&& target_distance < 160
		&& target_visible
	){
		enemy_look(target_direction);
		
		 // Attack:
		if(chance(1, 2)){
			wkick = 6;
			
			var	_l = 8,
				_d = gunangle + orandom(12),
				_x = x + lengthdir_x(_l, _d),
				_y = y + lengthdir_y(_l, _d);
				
			call(scr.projectile_create, _x, _y, LHBouncer, _d, 3);
			call(scr.fx, _x, _y, [_d, 2], Smoke);
			
			sound_play_hit(sndBouncerSmg, 0.2);
			motion_add(gunangle + 180, 2);
		}
		
		 // Wander:
		else if(chance(1, 3)){
			enemy_walk(random(360), random_range(30, 70));
			enemy_look(direction);
		}
	}
	
	else{
		enemy_walk(direction + orandom(60), random_range(40, 70));
		enemy_look(direction);
	}
	
#define BabyGator_draw
	var _angle = image_angle + ((right * (current_frame * current_time_scale) * 12) * (z > 0));
	if(gunangle >  180) draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * right, image_yscale, _angle, image_blend, image_alpha);
	call(scr.draw_weapon, spr_weap, 0, x, y - z, gunangle, 0, wkick, right, image_blend, image_alpha);
	if(gunangle <= 180) draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale * right, image_yscale, _angle, image_blend, image_alpha);

#define BabyGator_hurt(_damage, _force, _direction)
	 // Kick:
	if(speed > 0){
		zspeed  = 3;
		zbounce = 1;
	}

	 // Hurt:
	call(scr.enemy_hurt, _damage, _force, _direction);
	
	 // Effects:
	call(scr.fx, x, y - z, [_direction, 1], Smoke);
	
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
		
		return self;
	}
	
#define Bat_step
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
	var	_hurt = (sprite_index == spr_fire && nexthurt >= current_frame + 4),
		_back = (gunangle > 180);
		
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	if(_back) draw_self_enemy();
	
	call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
	
	if(!_back) draw_self_enemy();
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
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
			with(call(scr.projectile_create, x, y, "VenomPellet", gunangle + orandom(2 + i), _spd * i)){
				move_contact_solid(direction, _dis + (_dis * i));
				
				 // Effects:
				call(scr.fx, x, y, [direction + orandom(4), speed * 0.8], AcidStreak);
				
				if(i <= 2){
					call(scr.fx, x, y, [direction + orandom(8 * i), (4 - i)], Smoke);
				}
			}
		}
		
		 // Effects:
		wkick += 7;
		with(call(scr.fx, x, y, [gunangle + (130 * choose(-1, 1)) + orandom(20),  5], Shell)){
			sprite_index = sprShotShell;
		}
		
		canfire = false;
	}
	
	else{
		if(instance_exists(target) && target_visible){
			enemy_look(target_direction);
			
			var _targetDis = target_distance;
			
			 // Walk to target:
			if(_targetDis > 72){
				if(chance(4, 5)){
					enemy_walk(
						gunangle + orandom(8),
						random_range(15, 35)
					);
				}
			}
			
			 // Walk away from target:
			else if(_targetDis < 48){
				enemy_walk(
					gunangle + 180 + orandom(12),
					random_range(10, 15)
				);
				alarm1 = walk;
			}
			
			 // Attack target:
			if(chance(2, 5) && _targetDis > 48 && _targetDis < 192){
				alarm1  = 10;
				canfire = true;
				instance_create(x + (4 * right), y, AssassinNotice);
				
				 // Sounds:
				sound_play_hit(sndShotReload, 0.2);
			}
			
			 // Screech:
			else{
				if(irandom(stress) >= 15){
					stress -= 8;
					scrBatScreech();
					
					 // Fewer mass screeches:
					with(instances_matching_ne(obj.Bat, "id")){
						stress = max(stress - 4, 10);
					}
				}
				
				 // Build up stress:
				else stress += 4;
			}
		}
		
		else{
			 // Follow nearest ally:
			var _follow = call(scr.instance_nearest_array, x, y, call(scr.array_combine, obj.Cat, obj.CatBoss, obj.BatBoss));
			if(
				instance_exists(_follow)
				&& point_distance(x, y, _follow.x, _follow.y) > 64
				&& !collision_line(x, y, _follow.x, _follow.y, Wall, false, false)
			){
				enemy_walk(
					point_direction(x, y, _follow.x, _follow.y) + orandom(8),
					random_range(15, 35)
				);
			}
			
			 // Wander:
			else if(chance(1, 3)){
				enemy_walk(
					direction + orandom(24),
					random_range(10, 30)
				);
			}
			
			enemy_look(direction);
		}
	}
	
	
#define Bat_hurt(_damage, _force, _direction)
	 // Get Hurt:
	stress += _damage;
	call(scr.enemy_hurt, _damage, _force, _direction);
	
	 // Clear Gas:
	if(instance_is(other, ToxicGas)){
		stress -= 4;
		nexthurt = current_frame + 6;
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
	with(call(scr.instance_nearest_array, x, y, obj.Cat)){
		cantravel = true;
	}
	
	 // Screech:
	with(call(scr.pass, self, scr.projectile_create, x, y, "BatScreech")){
		if(_scale != undefined){
			image_xscale = _scale;
			image_yscale = _scale;
		}
	}
	sprite_index = spr_fire;
	image_index  = 0;
	
	
#define BatBoss_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
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
		maxhealth   = call(scr.boss_hp, 200);
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
		
		 // For Sani's bosshudredux:
		bossname = hitid[1];
		col      = c_green;
		
		return self;
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
		var _bat = instances_matching(obj.Bat, "creator", self);
		with(call(scr.instance_nearest_array, x, y, _bat)){
			other.x        = x;
			other.y        = y;
			other.right    = right;
			other.gunangle = gunangle;
		}
		
		 // Reappear:
		if(
			alarm2 < 0
			&& array_length(_bat) <= 1
			&& !array_length(cloud)
			&& !array_length(instances_matching_ne(obj.BatCloud, "id"))
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
				repeat(3) with(call(scr.fx, [_x, 4], [_y, 4], 0, Dust)){
					image_blend = c_black;
					depth       = _depth;
				}
				
				 // End:
				y += y_add * current_time_scale;
				if(y >= _h){
					with(other){
						cloud = call(scr.array_delete_value, cloud, other);
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
			with(instances_matching(obj.Bat, "creator", self)){
				walk        = 0;
				speed       = 0;
				alarm1      = 20 + random(20);
				image_blend = merge_color(image_blend, c_black, 0.1 * current_time_scale);
			}
			with(instances_matching(obj.BatCloud, "creator", self)){
				instance_destroy();
			}
		}
	}
	else cloud_blend = 0;
	
	 // Movement:
	if(walk > 0){
		walk -= current_time_scale;
		speed += walkspeed * current_time_scale;
		if(speed > maxspeed){
			speed = maxspeed;
		}
	}
	else if(speed > maxspeed / 2){
		speed = maxspeed / 2;
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
	var _blend = image_blend;
	
	 // Cloudin:
	image_blend = merge_color(image_blend, c_black, cloud_blend);
	
	 // Self:
	var	_hurt = (sprite_index == spr_fire && nexthurt >= current_frame + 4),
		_back = (gunangle > 180);
		
	if(_hurt) draw_set_fog(true, _blend, 0, 0);
	if(_back) draw_self_enemy();
	
	call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
	
	if(!_back) draw_self_enemy();
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
	 // Uncloud:
	image_blend = _blend;
	
	 // Debug:
	//draw_text_nt(x, y - 30, string(charge) + "/" + string(max_charge) + "(" + string(charged) + ")");
	
#define BatBoss_alrm0
	intro = true;
	call(scr.boss_intro, "CatBat");
	sound_play(sndScorpionFireStart);
	
	 // Disable Bros:
	with(instances_matching_gt(call(scr.array_combine, obj.BatBoss, obj.CatBoss), "alarm0", 0)){
		intro  = true;
		alarm0 = -1;
	}
	
#define BatBoss_alrm1
	alarm1 = 20 + random(20);
	with(instances_matching_le(obj.CatBoss, "supertime", 0)){
		alarm1 = 20 + random(20);
		other.alarm1 += alarm1;
	}
	
	if(active){
		if(enemy_target(x, y)){
			if(target_distance < 240 && target_visible){
				enemy_look(target_direction);
				
				 // Move Away:
				if(chance(1, 5)){
					enemy_walk(
						gunangle + 180 + (irandom_range(25, 45) * right),
						random_range(20, 35)
					);
					
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
					call(scr.projectile_create, x, y, "VenomFlak", gunangle + orandom(10), 12);
				}
			}
			
			else{
				 // Follow Cat Boss:
				var _cat = call(scr.instance_nearest_array, x, y, obj.CatBoss);
				if(
					instance_exists(_cat)
					&& point_distance(x, y, _cat.x, _cat.y) > 64
					&& !collision_line(x, y, _cat.x, _cat.y, Wall, false, false)
				){
					enemy_walk(
						point_direction(x, y, _cat.x, _cat.y) + orandom(8),
						random_range(15, 35)
					);
				}
				
				 // Wander:
				else if(chance(2, 3)){
					enemy_walk(
						direction + orandom(24),
						random_range(10, 30)
					);
				}
				
				 // Bat Morph:
				else{
					alarm2 = 24;
					for(var i = 0; i < 3; i++){
						array_push(cloud, { delay: 8 * i });
					}
				}
				
				enemy_look(direction);
			}
		}
		
		 // Wander:
		else{
			alarm1 = 45 + random(60);
			enemy_walk(random(360), 5);
			enemy_look(direction);
		}
	}
	
	 // More Aggressive Bats:
	else with(instances_matching(obj.Bat, "creator", self)){
		alarm1 = ceil(alarm1 / 2);
		
		if(enemy_target(x, y)){
			if(target_visible && target_distance < 128){
				enemy_walk(target_direction, alarm1);
				enemy_look(direction);
			}
			
			 // Zoom Ovah:
			else if(chance(1, 3)){
				with(call(scr.obj_create, x, y + 16, "BatCloud")){
					target    = other.target;
					creator   = other.creator;
					my_health = other.my_health;
					direction = 90 + orandom(20);
				}
				
				 // Effects:
				sound_play_pitchvol(sndBloodHammer, 1.4 + random(0.2), 0.5);
				repeat(10){
					with(call(scr.fx, [x, 8], [y, 8], random(3), Smoke)){
						image_blend = c_black;
					}
				}
				
				instance_delete(self);
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
			with(call(scr.obj_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "BatCloud")){
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
		with(instances_matching(obj.Bat, "creator", self)){
			repeat(8) with(call(scr.fx, x, y, 3, Dust)){
				image_blend = c_black;
			}
			instance_delete(self);
		}
		with(instances_matching(obj.BatCloud, "creator", self)){
			instance_delete(self);
		}
		
		 // Effects:
		sound_play_pitchvol(sndBloodHammer, 0.5 + random(0.2), 0.8);
	}
	
	 // Effects:
	with(call(scr.instances_meeting_instance, self, Dust)){
		if(chance(1, 3)){
			with(call(scr.fx, x, y, [point_direction(other.x, other.y, x, y), random_range(1.5, 2)], Smoke)){
				image_blend = c_black;
				depth = -7;
			}
		}
	}
	
#define BatBoss_hurt(_damage, _force, _direction)
	 // Get hurt:
	stress += _damage;
	call(scr.enemy_hurt, _damage, _force, _direction);
	
	 // Pitch Hurt:
	if(snd_hurt == sndMutant10Hurt){
		audio_sound_set_track_position(
			call(scr.sound_play_at, x, y, snd_hurt, 0.6 + random(0.2)),
			0.07
		);
		call(scr.sound_play_at, x, y, sndHitFlesh, 1 + orandom(0.3), 1.4);
	}
	
	 // Half HP:
	var _half = maxhealth / 2;
	if(my_health <= _half && my_health + _damage > _half){
		if(snd_lowh == sndNothing2HalfHP){
			sound_play_pitch(sndNothing2HalfHP, 1.3);
		}
		else sound_play(snd_lowh);
		
		 // Biggo Screech:
		scrBatBossScreech(5);
	}
	
	 // Screech:
	else if(instance_is(other, ToxicGas)){
		stress -= 4;
		nexthurt = current_frame + 6;
		scrBatBossScreech(1);
	}
	
#define BatBoss_death
	instance_create(x, y, PortalClear);
	
	 // Die:
	with(instances_matching(obj.Bat, "creator", self)){
		my_health = 0;
	}
	
	 // Pitch Death:
	if(snd_dead == sndMutant10Dead){
		call(scr.sound_play_at, x, y, snd_dead, 0.55 + random(0.1), 1.5);
	}
	
	 // Pickups:
	repeat(2){
		pickup_drop(100, 0);
	}
	
	 // Buff Partner:
	var _partner = instances_matching_ne(obj.CatBoss, "id");
	if(array_length(_partner)){
		with(_partner){
			var _heal = ceil(maxhealth / 4);
			maxhealth += _heal;
			
			 // Rad Heals:
			with(other){
				 // Rads:
				var	_num = min(raddrop, 24),
					_rad = call(scr.rad_drop, x, y, _num, direction, speed);
					
				raddrop -= _num;
				with(_rad){
					alarm0 /= 3;
					direction = random(360);
					speed = max(2, speed);
					image_index = 1;
					depth = -3;
				}
				
				 // Partner Sucks Up Rads:
				with(call(scr.rad_path, _rad, other)){
					heal = ceil(_heal / array_length(_rad));
				}
			}
		}
	}
	
	 // Boss Win Music:
	else with(MusCont){
		alarm_set(1, 1);
	}
	
#define scrBatBossScreech /// scrBatBossScreech(_extraNum = 3, _extraScale = 0.5)
	var _extraNum = argument_count > 0 ? argument[0] : 3;
var _extraScale = argument_count > 1 ? argument[1] : 0.5;
	
	 // Effects:
	sound_play_pitchvol(sndNothing2Hurt, 1.4 + random(0.2), 0.7);
	sound_play_pitchvol(sndSnowTankShoot, 0.8 + random(0.4), 0.5);
	
	view_shake_at(x, y, 16);
	sleep(40);
	
	 // Alert nearest cat:
	with(call(scr.instance_nearest_array, x, y, obj.Cat)){
		cantravel = true;
	}
	
	 // Screech:
	call(scr.pass, self, scr.projectile_create, x, y, "BatScreech");
	if(_extraNum > 0){
		var _l = 56;
		for(var _d = gunangle; _d < gunangle + 360; _d += (360 / _extraNum)){
			with(call(scr.pass, self, scr.projectile_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "BatScreech")){
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
		
		return self;
	}

#define BatCloud_step
	if(speed > 6) speed -= 2 * current_time_scale;
	
	if(current_frame_active){
		 // Visual:
		repeat(4) with(call(scr.fx, [x, 4], [y, 4], 0, Dust)){
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
	with(call(scr.obj_create, x, y, "Bat")){
		x = xstart;
		y = ystart;
		motion_add(other.direction, 4);
		nexthurt = current_frame + 12;
		creator  = other.creator;
		kills    = 0;
		
		 // Save HP:
		if("my_health" in other){
			my_health = other.my_health;
		}
		
		 // Aim:
		if(instance_exists(other.target)){
			enemy_look(point_direction(x, y, other.target.x, other.target.y));
		}
		
		 // Effects:
		var _col = other.image_blend;
		for(var _dir = 0; _dir < 360; _dir += (360 / 12)){
			with(call(scr.fx, x, y + 6, [_dir, 2], Smoke)){
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
		image_speed  = 0;
		depth        = -2;
		
		 // Vars:
		mask_index = mskFlakBullet;
		friction   = 0.4;
		maxspeed   = 12;
		damage     = 2;
		typ        = 2;
		setup      = true;
		wep        = noone;
		ammo       = 1;
		has_hit    = false;
		returning  = false;
		target     = noone;
		big        = false;
		key        = "";
		seek       = 48 * skill_get(mut_bolt_marrow);
		walled     = false;
		speed      = maxspeed;
		
		 // Merged Weapons Support:
		temerge_on_fire = script_ref_create(BatDisc_temerge_fire);
		
		return self;
	}
	
#define BatDisc_setup
	setup = false;
	
	 // Big:
	if(big){
		if(sprite_index == spr.BatDisc){
			sprite_index = spr.BatDiscBig;
		}
		if(alarm0 < 0){
			alarm0 = 30;
		}
		seek *= 4/3;
	}
	
#define BatDisc_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Clamp Speed:
	speed = min(speed, maxspeed);
	
	 // Spin:
	image_angle += 40 * current_time_scale;
	
	 // Targeting:
	var _disMax = infinity;
	with(instances_matching([Player, WepPickup, ThrownWep, ProtoChest], "wep", wep)){
		var _dis = point_distance(x, y, other.x, other.y);
		if(_dis < _disMax){
			_disMax = _dis;
			other.target = self;
		}
	}
	with(instances_matching(Player, "bwep", wep)){
		var _dis = point_distance(x, y, other.x, other.y);
		if(_dis < _disMax){
			_disMax = _dis;
			other.target = self;
		}
	}
	if(!instance_exists(target)){
		target = creator;
	}
	
	 // Inside Wall:
	if(walled){
		 // Effects:
		if(current_frame_active){
			view_shake_max_at(x, y, 4);
		}
		if(chance_ct(1, 3)){
			with(instance_create(x, y, Dust)){
				depth = -7;
			}
		}
		
		 // Exit Wall:
		visible = place_meeting(x, y, Floor);
		if(visible && !place_meeting(x, y, Wall)){
			walled = false;
			
			 // Effects:
			with(instance_create(x, y, Debris)){
				motion_set(other.direction + orandom(40), 4 + random(4));
			}
			instance_create(x, y, Smoke);
		}
	}
	
	 // Outside Wall:
	else{
		 // Baseball:
		if(place_meeting(x, y, projectile)){
			var _inst = call(scr.instances_meeting_instance, self, [Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash]);
			if(array_length(_inst)) with(_inst){
				if(place_meeting(x, y, other)){
					with(other){
						deflected = true;
						returning = false;
						has_hit   = false;
						seek      = max(seek, 48 * skill_get(mut_bolt_marrow));
						direction = other.direction;
						speed     = maxspeed + 8;
						
						 // Game Feel:
						//x -= hspeed;
						//y -= vspeed;
						
						 // Effects:
						call(scr.sleep_max, 12);
						view_shake_at(x, y, 3);
						call(scr.sound_play_at, x, y, sndDiscBounce, 1.3 + random(0.3), 0.5);
						with(instance_create(x, y, Deflect)){
							image_angle = other.direction;
						}
					}
				}
			}
		}
		 
		 // Trail:
		if(current_frame_active){
			with(instance_create(x, y, DiscTrail)){
				sprite_index = (other.big ? spr.BigDiscTrail : sprDiscTrail);
			}
		}
	}
	
	 // Bolt Marrow:
	var	_seekDis  = seek,
		_seekInst = noone;
		
	if(
		_seekDis > 0
		&& instance_exists(creator)
		&& point_distance(x, y, creator.x, creator.y) < 160
	){
		with(instances_matching_ne(instances_matching_ne(hitme, "team", team, 0), "mask_index", mskNone)){
			if(!instance_is(self, prop)){
				var _dis = point_distance(x, y, other.x, other.y);
				if(_dis < _seekDis){
					_seekDis  = _dis;
					_seekInst = self;
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
			var	_tx = xstart,
				_ty = ystart;
				
			if(instance_exists(target)){
				_tx = target.x;
				_ty = target.y;
			}
			
			 // Returning:
			if(
				(instance_exists(target) && place_meeting(_tx, _ty, target))
				? (distance_to_object(target) > 0)
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
				 // Kick:
				with(target){
					if("gunangle" in self){
						var _kick = 6 * sign(angle_difference(other.direction, gunangle + 90)) * (weapon_is_melee(other.wep) ? -1 : 1);
						if("wkick" in self && variable_instance_get(self, "wep") == other.wep){
							wkick  = _kick;
						}
						if("bwkick" in self && variable_instance_get(self, "bwep") == other.wep){
							bwkick  = _kick;
						}
					}
				}
				
				 // Effects:
				with(instance_exists(target) ? target : self){
					view_shake_max_at(x, y, 12);
					if(friction > 0){
						motion_add(other.direction, 2);
					}
					call(scr.sound_play_at, x, y, sndDiscgun,     0.8 + random(0.4), 0.6);
					call(scr.sound_play_at, x, y, sndCrossReload, 0.6 + random(0.4), 0.8);
				}
				
				 // Die:
				instance_destroy();
			}
		}
		
		 // Return When Slow:
		else if(speed <= 5 && !big){
			returning = true;
		}
	}
	
#define BatDisc_end_step
	if(setup) BatDisc_setup();
	
	 // Pass Through Walls:
	if(
		x == xprevious &&
		y == yprevious &&
		place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)
	){
		x += hspeed_raw;
		y += vspeed_raw;
	}
	
#define BatDisc_alrm0
	 // Projectiles:
	if(ammo > 0){
		for(var _dir = direction; _dir < direction + 360; _dir += (360 / ammo)){
			with(call(scr.projectile_create, x, y, "BatDisc", _dir)){
				wep     = other.wep;
				walled  = other.walled;
				visible = other.visible;
			}
			
			 // Effects:
			repeat(irandom_range(1, 2)){
				with(call(scr.fx, x, y, random(6), Smoke)){
					if(other.walled){
						depth = -7;
						speed /= 2;
					}
				}
			}
		}
		ammo = 0;
	}
	
	 // Effects:
	view_shake_at(x, y, 20);
	sound_play_pitch(sndClusterLauncher, 0.8 + random(0.4));
	
	 // Goodbye:
	instance_destroy();
	
#define BatDisc_hit
	if(projectile_canhit(other) && current_frame_active){
		projectile_hit_push(other, damage, force);
		has_hit = true;
		
		 // Slow Down:
		speed *= 0.9;
		
		 // Effects:
		var _big = (instance_exists(other) && other.size >= 3 && big);
		view_shake_max_at(x, y, (_big ? 12 : 6));
		if(!instance_exists(other) || other.my_health <= 0){
			call(scr.sleep_max, _big ? 48 : 24);
			view_shake_max_at(x, y, (_big ? 32 : 16))
		}
		instance_create(x, y, Smoke);
		
		 // Less Bolt Marrow Seeking:
		seek *= 0.8;
	}
	
#define BatDisc_wall
	 // Bounce Back:
	if(!returning && !has_hit && instance_exists(target)){
		//direction = target_direction;
		move_bounce_solid(true);
		if(!big){
			returning = true;
		}
		
		 // Effects:
		sound_play_hit(sndDiscBounce, 0.4);
		with(instance_create(x - hspeed_raw, y - vspeed_raw, MeleeHitWall)){
			image_angle = other.direction + 180;
		}
	}
	
	 // Enter Wall:
	else if(!walled){
		walled = true;
		
		 // Effects:
		instance_create(x, y, Smoke);
		view_shake_max_at(x, y, 8);
		call(scr.sleep_max, 8);
		
		 // Sounds:
		sound_play_hit(sndPillarBreak, 0.4);
		sound_play_hit(sndDiscHit,     0.4);
	}
	
#define BatDisc_destroy
	 // Effects:
	with(instance_create(x, y, DiscDisappear)){
		sprite_index = (other.big ? spr.BigDiscTrail : sprDiscTrail);
	}
	with(call(scr.fx, x, y, [direction, 3], Smoke)){
		growspeed /= 2;
	}
	
#define BatDisc_cleanup
	 // Restore:
	if("ammo" in wep){
		wep.ammo += ammo;
		if("amax" in wep){
			wep.ammo = min(wep.ammo, wep.amax);
		}
	}
	
	 // Hold up:
	if(!lq_defget(wep, "canload", true)){
		 // Activate:
		if(lq_defget(wep, "ammo", 0) >= lq_defget(wep, "amax", 0)){
			wep.canload = true;
		}
		
		 // No Shooting:
		else{
			with(instances_matching(Player, "wep",  wep)) can_shoot  = false;
			with(instances_matching(Player, "bwep", wep)) bcan_shoot = false;
		}
	}
	
	 // Update Weapon Sprite:
	if(instance_is(target, WepPickup) || instance_is(target, ThrownWep)){
		with(target){
			sprite_index = weapon_get_sprt(wep);
		}
	}
	
#define BatDisc_temerge_fire
	temerge_can_delete = false;
	
	
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
			call(scr.fx, x, y, 4 + random(4), Dust);
		}
		*/
		
		return self;
	}
	
/*#define BatScreech_step
	if(can_effect && chance(1, 3)){
		var l = random(min((sprite_width * image_xscale), (sprite_height * image_yscale)) / 2),
			d = random(360);
		with(call(scr.fx, x + lengthdir_x(l, d), y + lengthdir_y(l, d), [d, 4], Dust)){
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
		 // Damage:
		if(damage > 0 && projectile_canhit_melee(other)){
			projectile_hit_push(other, damage, force);
		}
		
		 // Normal:
		else with(other){
			motion_add(point_direction(other.x, other.y, x, y), other.force);
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
		
		return self;
	}
	
#define BoneGator_step
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
	
#define BoneGator_draw
	if(gunangle >  180) draw_self_enemy();
	call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
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
			enemy_look(gunangle + clamp(angle_difference(target_direction, gunangle), -_clamp, _clamp) + orandom(5));
		}
		
		var	_x = x + lengthdir_x(6, gunangle),
			_y = y + lengthdir_y(6, gunangle);
		
		 // Cluster Nade Final Shot: 
		if(ammo <= 0){
			alarm1 = 20;
			
			with(call(scr.projectile_create, _x, _y, Grenade, gunangle, 9)){
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
			call(scr.projectile_create, _x, _y, MiniNade, gunangle, 7 + random(2));
			
			 // Effects:
			wkick = 6;
			view_shake_max_at(x, y, 6);
			motion_add(gunangle + 180, 1);
			sound_play_pitch(sndGrenadeRifle, 0.8 + random(0.4));
		}
		
		 // Shared Effects:
		with(call(scr.projectile_create, _x, _y, TrapFire, gunangle, random(1))){
			image_speed = 0.4;
		}
		repeat(1 + irandom(2)) with(call(scr.obj_create, _x, _y, "FlameSpark")) motion_set(other.gunangle + orandom(30), random(5));
		repeat(1 + irandom(2)) call(scr.fx, _x, _y, [gunangle, random(4)], Smoke);
	}
	
	 // Normal Behavior:
	else if(enemy_target(x, y)){
		if(target_visible){
			enemy_look(target_direction);
			
			var _targetDis = target_distance;
			
			if(_targetDis < 192){
				 // Attack:
				if(_targetDis < 128 || chance(1, 5)){
					alarm1 = 12;
					ammo   = 6;
					
					 // Warning:
					instance_create(x, y, AssassinNotice);
					sound_play_pitch(sndDragonStart, 0.8 + random(0.4));
				}
				
				 // Advance:
				else enemy_walk(
					gunangle + orandom(20),
					random_range(30, 50)
				);
				
				 // Retreat:
				if(_targetDis < 32){
					enemy_walk(
						gunangle + 180 + orandom(30),
						random_range(20, 50)
					);
				}
			}
			
			 // Chase:
			else enemy_walk(
				gunangle + orandom(60),
				random_range(20, 50)
			);
		}
		
		 // Wander:
		else if(chance(2, 5)){
			alarm1 += random(10);
			enemy_walk(direction + orandom(40), random_range(20, 40));
			enemy_look(direction);
		}
	}
	
#define BoneGator_hurt(_damage, _force, _direction)
	 // Boiling Veins:
	if(instance_is(other, Explosion)){
		if(nextheal <= current_frame){
			my_health = min(my_health + 12, maxhealth);
			nextheal = current_frame + 8;
			
			with(instance_create(x, y, HealFX)){
				sprite_index = spr.BoneGatorHeal;
				depth = -8;
			}
			sound_play_hit(sndBurn, 0.2);
		}
	}
	
	 // Damage:
	else{
		call(scr.enemy_hurt, _damage, _force, _direction);
		call(scr.sound_play_at, x, y, sndBloodHurt, 0.8 + orandom(0.2), 0.9);
	}
	
#define BoneGator_death
	 // Explodin':
	sound_play(sndExplosionL);
	sound_play(sndFlameCannonEnd);
	with(call(scr.projectile_create, x, y, Explosion)){
		team = -1;
	}
	repeat(1 + irandom(2)){
		with(call(scr.projectile_create, x, y, SmallExplosion)){
			team = -1;
		}
	}
	
	var _l = 12;
	for(var _d = 0; _d < 360; _d += (360 / 20)){
		var	_x = x + lengthdir_x(_l, _d),
			_y = y + lengthdir_y(_l, _d);
			
		if(position_meeting(_x, _y, Floor)){
			call(scr.projectile_create, _x, _y, TrapFire, _d + random_range(60, 90), random(2));
		}
		with(call(scr.obj_create, _x, _y, "FlameSpark")){
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
		
		return self;
	}*/
	
/*#define BossHealFX_step
	if(!instance_exists(target)){
		instance_destroy();
		exit;
	}
	
	 // Effects:
	if(chance_ct(1, 6)) with(call(scr.fx, [x, 2], [y, 2], 0, EatRad)){
		sprite_index = choose(sprEatRadPlut, sprEatRadPlut, sprEatBigRadPlut);
		depth = -13;
	}
	
	 // Wavy:
	wave += current_time_scale;
	image_yscale += 0.5 * sin(wave * 2) * current_time_scale;
	
	 // Seek Target:
	if(distance_to_object(target) > 12){
		motion_add_ct(target_direction, seek_speed);
		speed = min(speed, 16);
		seek_speed += (0.2 * current_time_scale);
	}
	
	 // Collide:
	else if(chance_ct(1, 3)){
		sound_play_hit(sndHealthChestBig, 0.4);
		sound_play_pitchvol(sndToxicBarrelGas, 1.8 + random(0.6), 0.4 + random(0.4));
		
		call(scr.fx, x, y, [direction + 180, 6], AcidStreak);
		with(call(scr.fx, x, y, [direction, 1], AcidStreak)){
			sprite_index = spr.AcidPuff;
			image_angle = random(360);
		}
		
		repeat(2 + irandom(2)) with(call(scr.fx, [x, 8], [(y - 16), 8], 0, EatRad)){
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
		
		return self;
	}
	
#define Cabinet_death
	repeat(irandom_range(8, 16)){
		with(call(scr.obj_create, x, y, "Paper")){
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
		var _instSit = call(scr.array_combine,
			instances_matching_ne(call(scr.array_combine, obj.ChairFront, obj.ChairSide, obj.Couch), "id"),
			instances_matching_ne(chestprop, "id")
		);
		with(call(scr.array_shuffle, _instSit)){
			if(place_meeting(x, y, Floor)){
				if(!collision_line(x, y, other.x, other.y, Wall, false, false) || (instance_exists(GenCont) && chance(1, 2))){
					if(!array_length(instances_matching(obj.Cat, "sit", self))){
						other.sit = self;
						break;
					}
				}
			}
		}
		
		return self;
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
					if(
						instance_is(sit, VenuzCouch)
						|| array_find_index(obj.ChairFront, sit) >= 0
						|| array_find_index(obj.Couch,      sit) >= 0
					){
						sprite_index = spr_sit1;
					}
					image_index = 0;
				}
			}
			
			 // Sittin:
			if(instance_exists(sit) && !position_meeting(sit.x, sit.y, Wall)){
				x         = sit.x;
				y         = sit.y;
				xprevious = x;
				yprevious = y;
				if(instance_is(sit, enemy)){
					sit.alarm1 = max(sit.alarm1, 30);
				}
				else{
					y         -= 5;
					yprevious += 1;
					right     = -sit.image_xscale;
				}
			}
			else if(sit >= 100000){
				sit = false;
			}
		}
		
		 // Normal:
		else{
			 // Movement:
			if(walk > 0){
				walk -= current_time_scale;
				speed += walkspeed * current_time_scale;
			}
			if(speed > maxspeed){
				speed = maxspeed;
			}
			
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
				call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
				if(gunangle <= 180) draw_self_enemy();
				
				x = _x;
				y = _y;
			}
		}
		else draw_self_enemy();
	}
	else{
		if(gunangle >  180) draw_self_enemy();
		call(scr.draw_weapon, spr_weap, 0, x, y, gunangle, 0, wkick, right, image_blend, image_alpha);
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
			with(call(scr.projectile_create, _x, _y, "CatToxicGas", gunangle + orandom(6), 4)){
				friction = 0.12;
				if(!instance_is(other.sit, enemy)){
					team = 0;
				}
			}
		}
		gunangle += 12;
		
		 // End:
		if(--ammo <= 0){
			alarm1 = 40;
			
			 // Effects:
			repeat(3){
				call(scr.fx, _x, _y, [gunangle + orandom(16), 3], AcidStreak);
			}
			sound_play_pitch(sndEmpty, random_range(0.75, 0.9));
			sound_stop(toxer_loop);
			toxer_loop = -1;
			wkick += 6;
		}
		else wkick++;
	}
	
	 // Normal AI:
	else{
		enemy_target(x, y);
		
		 // Normal AI:
		if(active){
			 // Notice Target:
			if(!cantravel || sit){
				if(
					my_health < maxhealth
					|| (
						instance_exists(target)
						&& target_distance < 128
						&& (
							("reload" in target && target.reload > 0 && target_distance < 96)
							|| target_visible
						)
					)
				){
					cantravel = true;
					if(sit && !instance_is(sit, enemy)){
						sit = false;
						instance_create(x, y, AssassinNotice);
					}
				}
			}
			
			 // Do Something Bro:
			if(!sit || instance_is(sit, enemy) || chance(1, 12)){
				if(!instance_is(sit, enemy)){
					sit = false;
				}
				
				 // Aggroed:
				if(instance_exists(target) && target_visible){
					enemy_look(target_direction);
					
					 // Start Attack:
					if(target_distance < 140 && chance(1, 3)){
						alarm1 = 4;
						ammo = 10;
						gunangle -= 45;
						
						 // Effects:
						var _l = 8;
						with(instance_create(x + lengthdir_x(_l, gunangle), y + lengthdir_y(_l, gunangle), AcidStreak)) {
							sprite_index = spr.AcidPuff;
							image_angle  = other.gunangle;
						}
						sound_play(sndToxicBoltGas);
						sound_play(sndEmpty);
						toxer_loop = audio_play_sound(sndFlamerLoop, 0, true);
						wkick += 4;
					}
					
					 // Walk Toward Player:
					else{
						alarm1 = 20 + irandom(20);
						enemy_walk(
							gunangle + orandom(20),
							random_range(20, 25)
						);
					}
				}
				
				 // To the CatHole:
				else if(cantravel && chance(3, 4)){
					var _hole = instances_matching(obj.CatHole, "image_index", 0);
					
					if(array_length(_hole) && !array_length(instances_matching(_hole, "target", self))){
						alarm1 = 30 + irandom(30);
						
						with(call(scr.instance_nearest_array, x, y, _hole)){
							 // Open CatHole:
							if(point_distance(x, y, other.x, other.y) < 48){
								target = other;
								image_index = 1;
								other.alarm1 += 45;
							}
							
							 // Walk to CatHole:
							else with(other){
								enemy_walk(point_direction(x, y, other.x, other.y), random_range(20, 40));
								enemy_look(direction);
							}
						}
					}
				}
				
				 // Wander:
				else if((instance_exists(target) && cantravel) || chance(3, 4)){
					alarm1 = 30 + irandom(20);
					enemy_walk(
						choose(random(360), direction + orandom(30)),
						random_range(20, 30)
					);
					enemy_look(direction);
				}
				
				 // Sittin:
				else if(!sit){
					sit = true;
					
					 // Face Prop:
					var	_disMax  = infinity,
						_nearest = noone;
						
					with(prop){
						var _dis = point_distance(x, y, other.x, other.y);
						if(_dis < _disMax){
							if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
								_disMax  = _dis;
								_nearest = self;
							}
						}
					}
					
					if(instance_exists(_nearest)){
						enemy_look(point_direction(x, y, _nearest.x, _nearest.y));
					}
				}
			}
		}
		
		 // Manhole Travel:
		else{
			alarm1 = 40 + random(40);
			
			with(call(scr.array_shuffle, instances_matching(obj.CatHole, "image_index", 0))){
				if(!instance_exists(target)){
					if(!instance_exists(other.target) || point_distance(x, y, other.target.x, other.target.y) < 140){
						target = other;
						image_index = 1;
						break;
					}
				}
			}
		}
	}
	
#define Cat_hurt(_damage, _force, _direction)
	if(!instance_is(other, ToxicGas)){
		if(active){
			call(scr.enemy_hurt, _damage, _force, _direction)
			if(!instance_is(sit, enemy)){
				sit = false;
			}
		}
	}
	
	 // Toxic immune
	else with(other){
		instance_copy(false);
		instance_delete(self);
		for(var i = 0; i < maxp; i++){
			view_shake[i] -= 1;
		}
	}
	
#define Cat_death
	pickup_drop(20, 0);
	
#define Cat_cleanup
	sound_stop(toxer_loop);
	
	
#define CatBoss_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
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
		maxhealth     = call(scr.boss_hp, 200);
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
		
		 // For Sani's bosshudredux:
		bossname = hitid[1];
		col      = c_green;
		
		return self;
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
		var _max = maxspeed + (3.5 * (dash > 0));
		if(walk > 0){
			walk -= current_time_scale;
			speed += walkspeed * current_time_scale;
		}
		if(speed > _max){
			speed = _max;
		}
		
		 // Bounce:
		if(dash <= 0 && walk > 0 && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
			if(!array_length(instances_matching(obj.CatBossAttack, "creator", self))){
				if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
				if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
				enemy_look(angle_lerp(gunangle, direction, 0.5));
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
	call(scr.boss_intro, "CatBat");
	sound_play(sndScorpionFireStart);
	
	 // Disable Bros:
	with(instances_matching_gt(call(scr.array_combine, obj.BatBoss, obj.CatBoss), "alarm0", 0)){
		intro  = true;
		alarm0 = -1;
	}

#define CatBoss_alrm1
	alarm1 = 20 + random(20);

	if(supertime > 0){
		alarm1 = 1;
		supertime -= 1;
		
		 // Mid charge:
		wkick    = 6;
		gunangle = 270 + (50 * right) + orandom(5);
		
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
		with(instances_matching_ne(obj.BatBoss, "id")){
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
				enemy_look(target_direction);
				
				if(chance(4, 5)){
					 // Attack:
					if(
						chance(3, 4)
						&& target_visible
						&& (target_distance < 80 || chance(1, 2))
					){
						alarm1 = 10;
						
						with(call(scr.projectile_create, x, y, "CatBossAttack", gunangle)){
							target = other.target;
							type   = other.super;
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
					else if(target_distance > 40){
						alarm2 = 15;
						alarm1 += alarm2;
						sprite_index = spr_chrg;
						
						 // Effects:
						repeat(16) call(scr.fx, x, y, random(5), Dust);
						sound_play_pitchvol(sndBigBanditMeleeStart, 0.6 + random(0.2), 1.2);
					}
				}
				
				 // Circle Target:
				else{
					var	_l = 64,
						_d = target_direction + 180;
						
					_d += 30 * sign(angle_difference(direction, _d));
					
					enemy_walk(
						point_direction(x, y, target.x + lengthdir_x(_l, _d), target.y + lengthdir_y(_l, _d)),
						random_range(15, 40)
					);
				}
			}
		}
		
		 // Wander:
		else{
			enemy_walk(direction + orandom(30), random_range(15, 40));
			enemy_look(direction);
		}
	}

#define CatBoss_alrm2
	alarm2 = 1;
	
	var _targetDir = (
		enemy_target(x, y)
		? target_direction
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
	call(scr.motion_step, self, 1);
	if(place_meeting(x, y, Wall)){
		with(call(scr.instances_meeting_instance, self, Wall)){
			view_shake_at(x, y, 3);
			instance_create(x, y, FloorExplo);
			instance_destroy();
		}
	}
	call(scr.motion_step, self, -1);
	
	 // Gas:
	repeat(2 + irandom(3)){
		with(call(scr.projectile_create,
			x,
			y,
			"CatToxicGas",
			direction + 180 + orandom(15),
			2 + random(1)
		)){
			friction = 0.16;
			team     = 0;
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
		enemy_walk(
			direction + orandom(20),
			random_range(15, 30)
		);
		sprite_index = spr_walk;
		
		 // Effects:
		view_shake_at(x, y, 12);
		sound_play(sndFlamerStop);
		sound_stop(jetpack_loop);
	}
	
	enemy_look(angle_lerp(
		gunangle,
		angle_lerp(_targetDir, direction, 0.5),
		0.5
	));
	
#define CatBoss_alrm3
	alarm3 = 150;
	
	 // Underground Cats:
	if(chance(1, 1 + array_length(instances_matching_ne(obj.Cat, "id")))){
		with(call(scr.obj_create, 0, 0, "Cat")){
			active    = false;
			cantravel = true;
			alarm1    = random_range(60, 150);
		}
	}
	
#define CatBoss_hurt(_damage, _force, _direction)
	if(!instance_is(other, ToxicGas)){
		call(scr.enemy_hurt, _damage, (dash ? 0 : _force), _direction);
		
		 // Pitch Hurt:
		if(snd_hurt == sndBuffGatorHit){
			call(scr.sound_play_at, x, y, snd_hurt, 0.6 + random(0.3), 3);
		}
		
		 // Half HP:
		var _half = maxhealth / 2;
		if(my_health <= _half && my_health + _damage > _half){
			if(snd_lowh == sndBallMamaAppear){
				audio_sound_set_track_position(
					sound_play_pitchvol(snd_lowh, 0.8, 1.5),
					1.5
				);
			}
			else sound_play(snd_lowh);
		}
		
		 // Break charging:
		if(supertime > 0 && superbreakmax > 0){
			supertime += _damage * 4;
			superbreakmax--;
			
			if(supertime >= maxsupertime){
				alarm1 = 40 + irandom(20);
				supertime = 0;
				gunangle = (right ? 300 : 240);
				sleep(100);
				view_shake_at(x, y, 20);
				motion_add(_direction, 4);
				
				 // Sounds:
				sound_play_pitch(sndGunGun, 0.8);
				sound_play_pitch(sndStrongSpiritLost, 1.2);
				
				 // Effects:
				with(instance_create(x, y, ImpactWrists)){
					depth = -3;
				}
				repeat(2 + irandom(2)){
					with(instance_create(x, y, Rad)){
						motion_set(_direction + orandom(30), 4 + random(4));
						friction = 0.4;
					}
				}
				repeat(3 + irandom(6)){
					with(instance_create(x, y, Smoke)){
						motion_set(_direction + orandom(30), 4 + random(4));
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
		instance_delete(self);
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
	var _partner = instances_matching_ne(obj.BatBoss, "id");
	if(array_length(_partner)){
		with(_partner){
			var _heal = ceil(maxhealth / 4);
			maxhealth += _heal;
			
			 // Rad Heals:
			with(other){
				 // Rads:
				var	_num = min(raddrop, 24),
					_rad = call(scr.rad_drop, x, y, _num, direction, speed);
					
				raddrop -= _num;
				with(_rad){
					alarm0 /= 3;
					direction = random(360);
					speed = max(2, speed);
					image_index = 1;
					depth = -3;
				}
				
				 // Partner Sucks Up Rads:
				with(call(scr.rad_path, _rad, other)){
					heal = ceil(_heal / array_length(_rad));
				}
			}
		}
	}
	
	 // Boss Win Music:
	else with(MusCont){
		alarm_set(1, 1);
	}
	
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
		
		return self;
	}
	
#define CatBossAttack_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Setup Fire Lines:
	if(array_length(fire_line) <= 0){
		var	_num    = (3 + GameCont.loops) * (type ? 2.5 : 1),
			_off    = 30 + (12 * GameCont.loops),
			_offPos = (_num / 2) * type;
			
		if(_num > 0) repeat(_num){
			array_push(fire_line, {
				"dir"      : (type ? orandom(_off) : 0),
				"dis"      : 0,
				"dir_goal" : (type ? 0 : orandom(_off)),
				"dis_goal" : 1000,
				"x"        :  0 + orandom(_offPos),
				"y"        : -4 + orandom(_offPos)
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
			var	_d = target_direction,
				_m = 60;
				
			with(creator){
				enemy_look(gunangle + ((clamp(angle_difference(_d, gunangle), -_m, _m) / 20) * current_time_scale));
			}
			direction += (clamp(angle_difference(_d, direction), -_m, _m) / 16) * current_time_scale;
		}
		
		 // Follow Creator:
		if(instance_exists(creator)){
			var _o = (type ? 28 : 16) - creator.wkick;
			x = creator.x + lengthdir_x(_o, creator.gunangle);
			y = creator.y + lengthdir_y(_o, creator.gunangle);
		}
		
		 // Hitscan Lines:
		with(fire_line){
			dir = angle_lerp_ct(dir, dir_goal, 1/7);
			
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
			_x    = x + _line.x,
			_y    = y + _line.y,
			_dis  = _line.dis,
			_dir  = _line.dir + direction;
			
		 // Wall Break:
		if(type){
			var _o = 24;
			instance_create(_x + lengthdir_x(_dis - _o, _dir), _y + lengthdir_y(_dis - _o, _dir), PortalClear);
			instance_create(_x + lengthdir_x(_dis,      _dir), _y + lengthdir_y(_dis,      _dir), ToxicDelay);
		}
		
		 // Create Toxic Rails:
		while(_dis > 0){
			var	_lx     = _x + lengthdir_x(_dis, _dir),
				_ly     = _y + lengthdir_y(_dis, _dir),
				_radius = (12 + GameCont.loops) * type;
				
			 // Instadamage:
			if(type && collision_circle(_lx, _ly, _radius / 2, hitme, true, false)){
				with(instance_exists(creator) ? instances_matching_ne(hitme, "id", creator.id) : hitme){
					with(other){
						if(projectile_canhit_melee(other)){
							if(collision_circle(_lx, _ly, _radius / 2, other, true, false)){
								projectile_hit(other, damage, force, _dir);
							}
						}
					}
				}
			}
			
			 // Gas:
			with(call(scr.projectile_create, _lx + orandom(_radius), _ly + orandom(_radius), ToxicGas, _dir, 1 + random(1))){
				friction  += random_range(0.1, 0.2);
				growspeed *= _dis / _line.dis;
				team       = 0;
				
				 // Effects:
				if(chance(1, 2)){
					call(scr.fx, [x, 8], [y, 8], [_dir + orandom(8), 4], AcidStreak);
				}
			}
			
			_dis -= 6;
		}
		
		 // Knockback gas:
		with(call(scr.projectile_create, _x, _y, ToxicGas, _dir + 180 + orandom(20), 3)){
			move_contact_solid(_dir + 180, 20);
			friction = 0.1;
			team     = 0;
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
		surf_door    = noone;
		
		 // Auto-Sprite:
		switch(GameCont.area){
			case "pizza":
			case area_pizza_sewers:
				sprite_index = spr.PizzaDoor;
				break;
		}
		
		return self;
	}
	
#define CatDoor_step
	x = xstart;
	y = ystart;
	
	 // Link to Wall:
	if(!instance_exists(partner_wall)){
		var	_l = 8 * image_yscale,
			_d = image_angle + 90;
			
		if(position_meeting(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), Wall)){
			with(call(scr.instances_meeting_point, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), Wall)){
				other.partner_wall = self;
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
		with(call(scr.instances_meeting_instance, self, instances_matching_ne(instances_matching_ne(hitme, "team", 0), "mask_index", mskNone))){
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
					call(scr.sound_play_at,
						x,
						y,
						sndMeleeFlip,
						1 + random(0.4)
					);
					call(scr.sound_play_at,
						x,
						y,
						((other.openang > 0) ? sndAmmoChest : sndWeaponChest),
						0.4 + random(0.2)
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
		call(scr.sound_play_at, x, y, snd_dead, 1.8 + random(0.2), 0.8);
		call(scr.sound_play_at, x, y, snd_hurt, 0.6 + random(0.2), 2.0);
		
		 // Chunks:
		var _d = image_angle - (90 * image_yscale);
		for(var _l = 0; _l <= abs(sprite_height); _l += random_range(4, 8)){
			with(call(scr.obj_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "CatDoorDebris")){
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
			
			with(call(scr.fx, x, y, [direction + orandom(20), min(speed, 10) / 2], Dust)){
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
		var	_surfX     = x - (_surfW / 2),
			_surfY     = y - (_surfH / 2),
			_surfScale = call(scr.option_get, "quality:main"),
			_hurt      = (nexthurt >= current_frame + 4);
			
		surf_door   = call(scr.surface_setup, `CatDoor${self}`, _surfW, _surfH, _surfScale);
		surf_door.x = _surfX;
		surf_door.y = _surfY;
		
		 // Draw:
		if(_hurt) draw_set_fog(true, image_blend, 0, 0);
		draw_surface_ext(surf_door.surf, _surfX, _surfY, 1 / _surfScale, 1 / _surfScale, 0, image_blend, image_alpha);
		if(_hurt) draw_set_fog(false, 0, 0, 0);
		
		 // Update:
		if(surf_door.reset || abs(openang - lq_defget(surf_door, "lastang", 0)) > 1){
			surf_door.reset   = false;
			surf_door.lastang = openang;
			
			surface_set_target(surf_door.surf);
			draw_clear_alpha(c_black, 0);
			d3d_set_projection_ortho(_surfX, _surfY, _surfW, _surfH, 0);
			
			 // Draw 3D Door:
			for(var i = 0; i < image_number; i++){
				draw_sprite_ext(sprite_index, i, x, y - i, image_xscale, image_yscale, image_angle + (openang * image_yscale), c_white, 1);
			}
			
			d3d_set_projection_ortho(view_xview_nonsync, view_yview_nonsync, game_width, game_height, 0);
			surface_reset_target();
		}
	}

#define CatDoor_hurt(_damage, _force, _direction)
	my_health -= _damage;
	nexthurt = current_frame + 6;
	motion_add(_direction, _force);
	sound_play_hit(snd_hurt, 0.3);
	
	 // Push Open Force:
	if(instance_exists(other)){
		var	_sx = lengthdir_x(other.hspeed, image_angle),
			_sy = lengthdir_y(other.vspeed, image_angle);
			
		openang += (_sx + _sy);
	}
	
	 // Shared Hurt:
	if(_damage > 0){
		if(instance_exists(partner) && partner.my_health > my_health){
			with(instance_exists(other) ? other : self){
				projectile_hit(other.partner, _damage, _force, _direction);
			}
		}
	}
	
#define CatDoor_cleanup
	//instance_delete(my_wall);
	with(surf_door){
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
		
		return self;
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
//		return self;
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
//	call(scr.projectile_create, x, y, Explosion);
//	
//	repeat(18){
//		with(call(scr.projectile_create, x, y, ToxicGas, random(360), 4)) {
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
		hole        = noone;
		
		 // don't mess with the big boy
		with(call(scr.instances_meeting_instance, self, obj.CatHoleBig)){
			if(place_meeting(x, y, other)){
				with(other){
					instance_destroy();
					return self;
				}
			}
		}
		
		return self;
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
			with(call(scr.instances_meeting_instance, self, Player)){
				if(place_meeting(x, y, other)){
					motion_add(point_direction(other.x, other.y, x, y), 2);
				}
			}
		}
		
		 // Open:
		if(image_index < close_index){
			depth = min(depth, -6);
			
			 // Hole:
			if(!instance_exists(hole)){
				hole = call(scr.obj_create, x, y, "ManholeOpen");
			}
			
			 // Come Here Bro:
			if(instance_exists(target)){
				if(!target.visible){
					with(target){
						visible = true;
						alarm1  = 15 + random(30);
						active  = true;
						canfly  = false;
						x       = other.x;
						y       = other.y;
						
						 // Move:
						if(instance_exists(target)){
							enemy_look(target_direction + orandom(50));
						}
						else{
							enemy_look(random(360));
						}
						enemy_walk(gunangle, random_range(4, 8));
						
						 // Effects:
						sound_play_pitchvol(sndFireballerHurt, 1.4, 0.6);
						repeat(4){
							call(scr.fx, [x, 4], [y, 4], [direction, 3], Dust);
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
							enemy_face(direction);
						}
					}
				}
			}
		}
		
		 // Close:
		else if(instance_exists(hole)){
			depth = 5;
			
			 // Delete Hole:
			with(hole){
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
			
		with(call(scr.floor_fill, x, y, 2)){
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
		with(call(scr.obj_create, x, y - 48, "CatLight")){
			sprite_index = spr.CatLightBig;
		}
		
		 // No Portals:
		with(call(scr.obj_create, 0, 0, "PortalPrevent")){
			creator = other;
		}
		
		return self;
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
					if(!array_length(instances_matching_ne(obj.CatToxicGas, "id"))){
						alarm0 = 20;
						alarm1 = alarm0 + 20;
					}
				}
			}
		}
	}
	
	 // Dim Music:
	else if("ntte_music_index" in GameCont){
		if(audio_is_playing(GameCont.ntte_music_index)){
			var _vol = audio_sound_get_gain(GameCont.ntte_music_index);
			sound_volume(GameCont.ntte_music_index, _vol + min(0, (((phase < 2) ? 0.4 : 0) - _vol) * 0.05 * current_time_scale));
		}
	}
	
	 // Camera Pan:
	if(alarm1 > 0){
		for(var i = 0; i < maxp; i++){
			view_object[i]     = self;
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
			var _clang = (phase < 1);
			if(!_clang){
				with(Player){
					if(point_distance(x, y, other.x, other.y) < 180){
						if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
							_clang = true;
							break;
						}
					}
				}
			}
			if(_clang){
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
			var _boss = call(scr.array_shuffle, ["BatBoss", "CatBoss"]);
			for(var i = 0; i < array_length(_boss); i++){
				with(call(scr.obj_create, x, y - 4, _boss[i])){
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
		if(view_object[i] == self){
			view_object[i] = noone;
		}
		view_pan_factor[i] = null;
	}
	
#define CatHoleBig_destroy
	 // Hole:
	with(call(scr.obj_create, x, y, "ManholeOpen")){
		sprite_index = spr.BigManholeOpen;
		canportal    = true;
		big          = true;
		
		 // Launch Player:
		if(place_meeting(x, y, Player)){
			var	_bx = bbox_center_x,
				_by = bbox_center_y;
				
			with(call(scr.instances_meeting_instance, self, Player)){
				if(place_meeting(x, y, other)){
					var	_dir   = point_direction(_bx, _by, x, y),
						_force = min(1, point_distance(_bx, _by, x, y) / 24);
						
					with(call(scr.obj_create, x, y, "PalankingToss")){
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
	with(instances_matching(obj.PortalPrevent, "creator", self)){
		instance_destroy();
	}
	
	 // Remove Light:
	with(instances_matching_ne(obj.CatLight, "id")){
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
	
	 // Silver Tongue:
	if("ntte_lairmut" not in GameCont){
		GameCont.skillpoints++;
		GameCont.ntte_lairmut = true; // Change this system later if you add secret area mutations
	}
	
	
#define CatLight_create(_x, _y)
	/*
		Flickering ceiling lights used on dark areas
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.CatLight;
		image_xscale = 1/4;
		image_yscale = 1/4;
		image_alpha  = -1;
		light_angle  = image_angle;
		
		return self;
	}
	
#define CatLight_step
	 // Flicker:
	if(current_frame_active){
		image_angle = light_angle + orandom(1.5);
		visible     = !chance(1, 60);
	}
	
	 // Invert Alpha:
	if(image_alpha > 0){
		image_alpha *= -1;
	}
	
	
#define CatToxicGas_create(_x, _y)
	/*
		ToxicGas that shrinks faster when it stops moving (shrink code in lair.area.gml)
	*/
	
	return instance_create(_x, _y, ToxicGas);
	
	
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
		
		return self;
	}
	
	
#define ChairSide_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "ChairFront")){
		 // Visual:
		spr_idle = spr.ChairSideIdle;
		spr_hurt = spr.ChairSideHurt;
		spr_dead = spr.ChairSideDead;
		
		return self;
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
		
		return self;
	}
	
	
#define FlameSpark_create(_x, _y)
	/*
		Particle used for the Bone Gator enemy
	*/
	
	with(instance_create(_x, _y, Sweat)){
		 // Visual:
		sprite_index = spr.FlameSpark;
		image_speed  = 0.4;
		image_index  = 0;
		
		return self;
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
		prompt     = call(scr.prompt_create, self, loc("NTTE:GatorStatue:Prompt", "BLESSING"), mskReviveArea, 0, -10);
		
		return self;
	}
	
#define GatorStatue_step
	 // Accept Blessing:
	if(instance_exists(prompt) && player_is_active(prompt.pick)){
		prompt.visible = false;
		
		 // Mutation:
		with(call(scr.obj_create, x, y, "OrchidBall")){
			skill   = other.skill;
			type    = "portal";
			creator = other;
		}
		
		 // Sound:
		sound_play_gun(sndFlakCannon,   0.2,  0.3);
		sound_play_gun(sndGuardianFire, 0.2,  0.3);
		sound_play_gun(sndGatorDie,     0.2, -0.5);
		with(player_find(prompt.pick)){
			sound_play(snd_valt);
		}
		
		 // Effects:
		sprite_index = spr_hurt;
		image_index  = 0;
		with(instance_create(x + prompt.xoff, y + prompt.yoff - 16, PopupText)){
			text   = loc("NTTE:GatorStatue:Blessed", "BLESSED!");
			target = other.prompt.pick;
		}
	}
	
#define GatorStatue_death
	var _wepNum = 2;
	
	 // Revenge:
	repeat(4){
		call(scr.projectile_create, x, y, "GatorStatueFlak");
	}
	if(instance_exists(prompt) && prompt.visible){
		with(call(scr.projectile_create, x, y, "CustomFlak", 90, 0.1)){
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
		with(instance_create(x + orandom(4), y + orandom(4), WepPickup)){
			ammo = true;
			wep  = call(scr.weapon_add_temerge,
				call(scr.weapon_decide, 0, max(1, GameCont.hard - 1)),
				call(scr.weapon_decide, 0, max(1, GameCont.hard - 1), false, _wepAvoid)
			);
		}
	}
	
	 // Effects:
	call(scr.sound_play_at, x, y, sndCrownNo,      0.8, 0.4);
	call(scr.sound_play_at, x, y, sndStatueCharge, 0.8, 0.4);
	repeat(10){
		call(scr.fx,     [x, 16], [y, 16], [90, 1 + random(4)], Dust);
		call(scr.fx,      x,       y,      2 + random(3),       Debris);
		with(call(scr.fx, x,       y,      1 + random(4),       Shell)){
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
		ntte_bloom   = 0.1;
		
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
			with(call(scr.array_shuffle, instances_matching_ne(Floor, "id"))){
				if(!place_meeting(x, y, Wall)){
					if(distance_to_object(Player) < 96 && !place_meeting(x, y, Player)){
						other.x = bbox_center_x;
						other.y = bbox_center_y;
					}
				}
			}
		}
		
		return self;
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
			with(call(scr.fx, x, y, random_range(2, 5) * _scale, PlasmaTrail)){
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
	call(scr.sound_play_at, x, y, sndServerBreak, 2 + orandom(0.2), 1.2);
	
#define GatorStatueFlak_destroy
	 // Blammo:
	call(scr.team_instance_sprite, 
		call(scr.sprite_get_team, sprite_index),
		call(scr.projectile_create, x, y, EFlakBullet)
	);
	
	
#define LairBorder_create(_x, _y)
	/*
		Handles the border and cave-in between Pizza Sewers and Lair
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		image_blend = background_color;
		depth       = 1000;
		
		 // Vars:
		area            = GameCont.area;
		cavein          = false;
		cavein_dis      = 800;
		cavein_pan      = 0;
		cavein_inst     = [];
		bind_setup_list = [];
		
		 // Bind Update Scripts:
		with([Wall, TopSmall, FloorExplo, Debris]){
			array_push(other.bind_setup_list, call(scr.ntte_bind_setup, script_ref_create(LairBorder_setup_sprite, other, self), self));
		}
		
		return self;
	}
	
#define LairBorder_step
	 // Cave-In:
	if(cavein){
		cavein_inst = instances_matching_ne(cavein_inst, "id");
		
		if(cavein_dis > 0){
			var _spd = max(4, random(
				(instance_exists(Player) && array_length(instances_matching_gt(Player, "y", y - 64)))
				? 12
				: 18
			));
			cavein_dis = max(0, cavein_dis - (_spd * current_time_scale));
			
			 // Effects:
			if(current_frame_active){
				var _floors = instances_matching_gt(Floor, "bbox_bottom", y);
				if(array_length(_floors)){
					 // Debris:
					with(call(scr.instances_seen, _floors)){
						if(object_index != FloorExplo || chance(1, 10)){
							if(chance(1, 2 * array_length(instances_matching_gt(_floors, "bbox_bottom", bbox_bottom)))){
								with(instance_create(choose(bbox_left + 4, bbox_right - 3), choose(bbox_top + 4, bbox_bottom - 3), Debris)){
									motion_set(90 + orandom(90), 4 + random(4));
								}
							}
						}
					}
					
					 // Dust:
					_floors = instances_matching_gt(_floors, "bbox_bottom", y + cavein_dis);
					if(array_length(_floors)) with(_floors){
						repeat(choose(1, choose(1, 2))){
							with(instance_create(random_range(bbox_left - 12, bbox_right + 13), bbox_bottom + 1, Dust)){
								image_xscale *= 2;
								image_yscale *= 2;
								depth         = -8;
								vspeed       -= 5;
								sound_play_hit(choose(sndWallBreak, sndWallBreakBrick), 0.3);
							}
						}
					}
				}
			}
			
			 // Screenshake:
			if(cavein_pan < 1){
				cavein_pan += current_time_scale / 20;
			}
			for(var i = 0; i < maxp; i++){
				view_shake[i] = max(view_shake[i], 5);
				with(
					instance_exists(view_object[i])
					? view_object[i]
					: player_find(i)
				){
					view_shake_max_at(x, other.y + other.cavein_dis, 20);
					
					 // Pan Down:
					call(scr.view_shift, i, 270, clamp(y - (other.y - 64), 0, min(20, other.cavein_dis / 10)) * other.cavein_pan);
				}
			}
			
			 // Destroy:
			if(cavein_dis < 400){
				var _inst = instances_matching_ne(instances_matching_gt(GameObject, "y", y + cavein_dis), "object_index", Dust);
				if(array_length(_inst)){
					var _y = y;
					with(_inst){
						if(instance_exists(self)){
							 // Kill:
							if(y > _y + 64 && instance_is(self, hitme) && my_health > 0){
								my_health = 0;
								if("lasthit" in self){
									lasthit = [sprTurtleDead, "CAVE IN"];
								}
							}
							
							 // Save:
							else if(
								persistent
								|| instance_is(self, chestprop)
								|| (instance_is(self, Pickup) && object_index != Rad && object_index != BigRad)
								|| (instance_is(self, Corpse) && y < _y + 240)
								|| array_find_index(obj.Pet, self) >= 0
							){
								if(array_find_index(other.cavein_inst, self) < 0){
									array_push(other.cavein_inst, self);
								}
							}
							
							 // Destroy:
							else instance_destroy();
						}
					}
				}
				
				 // Hide Wall Shadows:
				if(instance_exists(Wall)){
					var _inst = instances_matching_gt(Wall, "bbox_bottom", y + cavein_dis - 32);
					if(array_length(_inst)) with(_inst){
						outspr = -1;
					}
				}
			}
			
			 // Saved Caved Instances:
			if(array_length(cavein_inst)){
				var	_x = x,
					_y = y + cavein_dis + 16;
					
				with(call(scr.instance_nearest_bbox, x, y, instances_matching_lt(instances_matching_gt(Floor, "bbox_bottom", y), "bbox_top", y))){
					_x = bbox_center_x;
				}
				
				with(instances_matching_ne(cavein_inst, "id")){
					visible = false;
					x       = lerp_ct(x, _x, 0.1);
					y       = _y;
					
					 // Why do health chests break walls again
					if(instance_is(self, HealthChest)){
						mask_index = mskNone;
					}
				}
			}
		}
		
		 // Finished Caving In:
		else{
			cavein = -1;
			
			 // Reset Dead Player Camera:
			with(Revive){
				if(view_object[p] == self){
					view_object[p] = noone;
				}
			}
			
			 // Reset Visibilities:
			with(cavein_inst){
				visible = true;
			}
			
			 // Wallerize:
			call(scr.floor_walls, instances_matching_gt(Floor, "bbox_bottom", y));
			call(scr.wall_tops,   instances_matching_gt(Wall,  "bbox_bottom", y));
			
			 // Rubble:
			var _inst = cavein_inst;
			with(call(scr.instance_nearest_bbox, x, y, instances_matching_gt(FloorNormal, "bbox_bottom", y))){
				with(call(scr.obj_create, bbox_center_x, other.y, "PizzaRubble")){
					inst = _inst;
					
					 // Fix Potential Softlockyness:
					var	_x2 = x,
						_y2 = y - 8;
						
					with(instances_matching_lt(instances_matching_gt(FloorExplo, "bbox_bottom", y - 4), "bbox_top", y - 4)){
						var	_x1 = bbox_center_x,
							_y1 = bbox_center_y;
							
						if(collision_line(_x1, _y1, _x2, _y1, Wall, false, false)){
							call(scr.floor_tunnel, _x1, _y2, _x2, _y2);
						}
					}
					
					 // Lets goooo:
					with(self){
						event_perform(ev_step, ev_step_normal);
					}
				}
			}
		}
	}
	
	 // Start Cave In:
	else if(cavein == false){
		if(instance_exists(Player) && array_length(instances_matching_lt(Player, "y", y))){
			cavein = true;
			sound_play_pitchvol(sndStatueXP, 0.2 + random(0.2), 3);
		}
	}
	
	 // Dead Player Camera:
	if(cavein >= 0 && instance_exists(Revive)){
		with(Revive){
			if(!instance_exists(view_object[p]) && !instance_exists(player_find(p))){
				view_object[p] = self;
			}
		}
	}
	
#define LairBorder_draw
	 // Background:
	if(y < view_yview_nonsync + game_height){
		draw_set_color(image_blend);
		draw_rectangle(
			view_xview_nonsync,
			y,
			view_xview_nonsync + game_width,
			view_yview_nonsync + game_height,
			false
		);
	}
	
#define LairBorder_cleanup
	 // Unbind Update Scripts:
	with(bind_setup_list){
		call(scr.ntte_unbind, self);
	}
	
#define LairBorder_setup_sprite(_borderInst, _object, _objectInst)
	 // Forcing Lair/Pizza Sewers Border Wall Sprites:
	with(_borderInst){
		var _inst = instances_matching_ge(_objectInst, "y", y);
		if(array_length(_inst)){
			switch(_object){
				case Debris : _inst = instances_matching(_inst, "sprite_index", call(scr.area_get_sprite, GameCont.area, sprDebris1)); break;
				default     : _inst = instances_matching(_inst, "area", GameCont.area);
			}
			if(array_length(_inst)){
				switch(_object){
					
					case Wall:
						
						var	_sprBot = call(scr.area_get_sprite, area, sprWall1Bot),
							_sprTop = call(scr.area_get_sprite, area, sprWall1Top),
							_sprOut = call(scr.area_get_sprite, area, sprWall1Out);
							
						with(_inst){
							sprite_index = _sprBot;
							topspr       = _sprTop;
							outspr       = _sprOut;
							area         = other.area;
						}
						
						break;
						
					default:
						
						var _spr = -1;
						
						switch(_object){
							case TopSmall   : _spr = call(scr.area_get_sprite, area, sprWall1Trans);  break;
							case FloorExplo : _spr = call(scr.area_get_sprite, area, sprFloor1Explo); break;
							case Debris     : _spr = call(scr.area_get_sprite, area, sprDebris1);     break;
						}
						
						with(_inst){
							sprite_index = _spr;
							area         = other.area;
						}
						
				}
			}
		}
	}
	
	
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
		with(call(scr.instances_meeting_point, x, y, FloorNormal)){
			switch(sprite_index){
				case sprFloor2   : image_index = choose(0, 2, 4, 5); break;
				case sprFloor101 : break;
				default          : image_index = 0;
			}
		}
		
		return self;
	}
	
#define Manhole_step
	if(visible){
		 // Effects:
		if(call(scr.area_get_underwater, GameCont.area) && chance_ct(1, 4)){
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
					instance_destroy();
				}
			}
		}
	}
	
	 // Activate:
	else if(instance_exists(Portal)){
		visible = true;
		
		 // Notice me bro:
		call(scr.sound_play_at, x, y, sndPillarBreak, 0.7 + random(0.1), 8);
		repeat(3) call(scr.fx, x, y, 2, Smoke);
	}
	
#define Manhole_destroy
	 // Hole:
	with(call(scr.obj_create, x, y, "ManholeOpen")){
		sprite_index = other.sprite_index;
		image_index  = image_number - 1;
		mask_index   = mskExploder;
		canportal    = true;
	}
	
	 // Effects:
	sleep(50);
	view_shake_at(x, y, 20);
	if(call(scr.area_get_underwater, GameCont.area)){
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
				with(call(scr.obj_create, x, y, "WaterStreak")){
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
			sound_play_pitchvol(sndOasisPortal,   1.0, 0.3);
			sound_play_pitchvol(sndSnowTankShoot, 0.6, 0.3);
			
			break;
			
	}
	
	 // Area:
	call(scr.area_set, area, subarea, loops);
	
	 // Portal:
	GameCont.killenemies = true;
	instance_create(x, y, Portal);
	sound_stop(sndPortalOpen);
	
	
#define ManholeOpen_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.ManholeOpen;
		image_speed  = 0;
		depth        = 5;
		
		 // Vars:
		mask_index = -1;
		canportal  = false;
		my_portal  = noone;
		big        = false;
		
		return self;
	}
	
#define ManholeOpen_step
	 // Collision:
	var	_obj = [Pickup, chestprop, ChestOpen, Corpse],
		_dis = 4 + (min(bbox_width, bbox_height) / 2),
		_spd = 3;
		
	if(big && !place_meeting(x, y, Portal)){
		array_push(_obj, hitme);
	}
	
	for(var i = array_length(_obj) - 1; i >= 0; i--){
		var _oy = -8 * (_obj[i] == hitme);
		y += _oy;
		if(instance_exists(_obj[i]) && place_meeting(x, y, _obj[i])){
			var	_bx = bbox_center_x,
				_by = bbox_center_y;
				
			with(call(scr.instances_meeting_instance, self, _obj[i])){
				if(place_meeting(x, y, other)){
					var _dir = point_direction(_bx, _by, x, y);
					
					 // Force Off:
					if(
						other.big
						&& instance_is(self, Player)
						&& point_distance(_bx, _by, x, y) < _dis
					){
						var	_x = _bx + lengthdir_x(_dis, _dir),
							_y = _by + lengthdir_y(_dis, _dir);
							
						if(place_free(_x, _y)){
							x         = _x;
							y         = _y;
							xprevious = _x;
							yprevious = _y;
						}
						else if(place_free(_x, y)){
							x         = _x;
							xprevious = _x;
						}
						else if(place_free(x, _y)){
							y         = _y;
							yprevious = _y;
						}
						direction = angle_lerp_ct(direction, _dir, 1/12);
					}
					
					 // Push:
					else if(speed < _spd){
						if(("size" not in self || size < 4) && !instance_is(self, crystaltype)){
							if(friction > 0 && object_index != Rad){
								motion_add_ct(_dir, friction + 0.4);
							}
							else{
								x += lengthdir_x(_spd - 0.4, _dir) * current_time_scale;
								y += lengthdir_y(_spd - 0.4, _dir) * current_time_scale;
							}
						}
					}
				}
			}
		}
		y -= _oy;
	}
	
	 // Grab Portal:
	if(canportal && instance_exists(Portal)){
		if(my_portal == noone){
			my_portal = call(scr.instance_nearest_array, x, y, instances_matching_ge(instances_matching(instances_matching(instances_matching(Portal, "object_index", Portal), "type", 1), "endgame", 100), "image_alpha", 1));
			with(my_portal){
				image_alpha = 0;
				mask_index  = ((other.mask_index < 0) ? other.sprite_index : other.mask_index);
				
				 // Relocating:
				x = other.x;
				y = other.y;
				with(instance_nearest(xstart, ystart, PortalShock)){
					x = other.x;
					y = other.y;
				}
				repeat(5) with(instance_nearest(xstart, ystart, PortalL)){
					x = other.x;
					y = other.y;
				}
				
				 // FX:
				if(other.big){
					var _l = _dis - 6;
					for(var _d = 0; _d < 360; _d += random_range(10, 12)){
						call(scr.fx, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), [_d, (chance(1, 6) ? 4 : 2.5)], Dust);
						if(chance(1, 12)){
							with(instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), Debris)){
								sprite_index = sprDebris102;
								direction = _d + orandom(30);
								speed *= random_range(0.5, 1);
							}
						}
					}
				}
			}
		}
		
		 // No Zap:
		if(instance_exists(my_portal)){
			with(my_portal){
				if(place_meeting(x, y, PortalL)){
					with(call(scr.instances_meeting_instance, self, PortalL)){
						if(place_meeting(x, y, other)){
							instance_destroy();
						}
					}
				}
			}
		}
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
		
		return self;
	}
	
	
#define Paper_create(_x, _y)
	with(instance_create(_x, _y, Feather)){
		 // Visual:
		sprite_index = spr.Paper;
		image_index  = irandom(image_number - 1);
		image_speed  = 0;
		
		 // Vars:
		friction = 0.2;
		
		return self;
	}
	
	
#define PizzaDrain_create(_x, _y)
	/*
		The shiny drain found in the Turtle's den, contains a secret tunnel
	*/
	
	with(call(scr.obj_create, _x, _y, "SewerDrain")){
		 // Visual:
		spr_idle  = spr.PizzaDrainIdle;
		spr_walk  = spr_idle;
		spr_hurt  = spr.PizzaDrainHurt;
		spr_dead  = spr.PizzaDrainDead;
		spr_floor = -1;
		
		 // Vars:
		type         = "area";
		area         = "lair";
		styleb       = 1;
		hallway_size = 320;
		
		return self;
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
		
		return self;
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
		repeat(12) with(call(scr.fx, [x, 8], [y, 8], 4, Dust)){
			image_xscale *= 2;
			image_yscale *= 2;
			depth = -8;
		}
		
		return self;
	}
	
#define PizzaRubble_step
	 // Manual Collision for Projectiles Hitting Wall:
	if(place_meeting(x, y, projectile)){
		with(call(scr.instances_meeting_instance, self, projectile)){
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
				with(call(scr.fx, x, y, [90 + orandom(30), random(3)], Dust)){
					depth = other.depth + choose(0, -1);
				}
			}
			x = other.x;
			y = other.y + 16;
			xprevious = x;
			yprevious = y;
			speed = 0;
		}
		else other.inst = call(scr.array_delete_value, other.inst, self);
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

#define PizzaRubble_hurt(_damage, _force, _direction)
	call(scr.enemy_hurt, _damage, _force, _direction);

	 // Diggin FX:
	if(chance(_force, 8)){
		repeat(irandom_range(1, ceil(sqrt(_damage)))){
			if(chance(1, my_health / 10)){
				with(instance_create(random_range(bbox_left, bbox_right + 1), y + 8, Debris)){
					depth = 1;
					direction = 90 + orandom(60);
					sound_play_hit(sndWallBreak, 0.4);
				}
			}
		}
	}
	
#define PizzaRubble_destroy
	 // Sound:
	sound_play_pitch(snd_dead, 1 + random(0.3));
	
	 // Corpse:
	repeat(12){
		with(call(scr.obj_create, x + orandom(8), y + orandom(8), "CatDoorDebris")){
			sprite_index = sprDebris102;
			image_index = irandom(image_number - 1);
			direction = random(360);
			speed = random_range(2, 8);
			shine = 5;
		}
		call(scr.fx, x, y, 4, Dust);
	}
	
	 // Destroy Walls:
	with(instance_create(x, y + 24, PortalClear)){
		sprite_index = mskPlasmaImpact;
		image_index = image_number - 4;
		image_speed = -1.2;
	}
	with(call(scr.instances_meeting_instance, self, [Wall, InvisiWall])){
		if(object_index == Wall) instance_create(x, y, FloorExplo);
		instance_destroy();
	}
	
	 // Free Boys:
	with(inst) if(instance_exists(self)){
		visible = true;
		x += orandom(4);
		y += orandom(4);
		
		 // Why do they break walls tell me
		if(instance_is(self, HealthChest)){
			mask_index = -1;
		}
	}
	
	 // Pizza time:
	call(scr.pet_set_skin,
		call(scr.pet_create, x, y + 16, "CoolGuy"),
		(peas ? "peas" : 0)
	);
	
	
#define PizzaTV_create(_x, _y)
	with(instance_create(_x, _y, TV)){
		 // Visual:
		spr_hurt = spr.TVHurt;
		spr_dead = spr_hurt;
		
		 // Vars:
		maxhealth = 15;
		my_health = maxhealth;
		
		return self;
	}
	
#define PizzaTV_end_step
	x     = xstart;
	y     = ystart;
	depth = 0; // why must i force depth every frame mmmm
	
	 // Death without needing a corpse sprite haha:
	if(my_health <= 0){
		call(scr.corpse_drop, self, 0, 0);
		
		 // Zap:
		sound_play_pitch(sndPlantPotBreak, 1.6);
		sound_play_pitchvol(sndLightningHit, 1, 2);
		repeat(2) instance_create(x, y, PortalL);
		
		instance_delete(self);
	}
	
	
#define SewerDrain_create(_x, _y)
	/*
		A drain found in the Sewers, generates a little room behind it when destroyed
	*/
	
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle     = spr.SewerDrainIdle;
		spr_walk     = spr_idle;
		spr_hurt     = spr.SewerDrainHurt;
		spr_dead     = spr.SewerDrainDead;
		spr_floor    = spr.FloorSewerDrain;
		spr_shadow   = -1;
		sprite_index = spr_idle;
		image_speed  = 0.4;
		image_xscale = choose(-1, 1);
		depth        = -1;
		
		 // Sound:
		snd_hurt = sndHitMetal;
		snd_dead = sndStatueDead;
		
		 // Vars:
		mask_index   = msk.SewerDrain;
		maxhealth    = 40;
		team         = 0;
		size         = 3;
		area         = area_sewers;
		subarea      = 1;
		loops        = GameCont.loops;
		styleb       = 0;
		hallway_size = 160;
		my_floor     = noone;
		
		 // Room Type:
		type = call(scr.pool, [
			[WeaponChest,   4],
			[AmmoChest,     4],
			["Backpack",    4],
			[HealthChest,   3],
			["LairChest",   3 * call(scr.unlock_get, "crown:crime")],
			["Pizza",       2],
			["GatorStatue", 2 * (skill_get(mut_shotgun_shoulders) <= 0)],
			["RedSpider",   2],
			[FrogQueen,     1]
		]);
		
		 // Cool Floor:
		with(call(scr.instance_nearest_bbox, _x - 16, _y, Floor)){
			image_index = 3;
		}
		
		return self;
	}
	
#define SewerDrain_step
	 // Manual Collision for Projectiles Hitting Wall:
	if(place_meeting(x, y, projectile)){
		with(call(scr.instances_meeting_instance, self, projectile)){
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
				
			call(scr.floor_set_align, 16, 16, x);
			
			 // Clear:
			with(call(scr.instances_meeting_rectangle, x - _w, y - _h, x + _w - 1, y - 1, [Floor, TopPot, Bones])){
				instance_delete(self);
			}
			
			 // Side Tiles:
			for(var _x = x - _w; _x < x + _w; _x += 16){
				call(scr.floor_set, _x, y - 16, 2);
			}
			
			 // Main Floor:
			call(scr.floor_set_style, styleb, area);
			my_floor = call(scr.floor_set, x - 16, y - 32, true);
			with(my_floor){
				if(sprite_exists(other.spr_floor)){
					sprite_index = other.spr_floor;
				}
			}
			call(scr.floor_reset_align);
			call(scr.floor_reset_style);
			
			 // Walls:
			for(var	_x = x - _w; _x < x + _w; _x += 16){
				for(var	_y = y - _h; _y < y; _y += 16){
					instance_create(_x, _y, Wall);
				}
			}
		}
		
		 // Takeover Walls:
		if(place_meeting(x, y, Wall)){
			with(call(scr.instance_nearest_bbox, bbox_left  - 8, y - 8, Wall)) outindex = 0;
			with(call(scr.instance_nearest_bbox, bbox_right + 8, y - 8, Wall)) outindex = 0;
			while(place_meeting(x, y, Wall)){
				with(call(scr.instances_meeting_instance, self, Wall)){
					instance_create(x, y, InvisiWall);
					sprite_index = call(scr.area_get_sprite, GameCont.area, sprWall1Trans);
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
			
		with(call(scr.instances_meeting_instance, self, hitme)){
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
	if(type == "area"){
		with(instances_matching_le(FloorExplo, "y", y - hallway_size)){
			instance_create(clamp(other.x, bbox_left, bbox_right + 1), y, PortalClear);
			other.my_health = 0;
		}
	}
	with(call(scr.instances_in_rectangle, bbox_left - 16, y - hallway_size, bbox_right + 16, bbox_top - 16, FloorExplo)){
		instance_create(clamp(other.x, bbox_left, bbox_right + 1), y, PortalClear);
		other.my_health = 0;
	}
	
	 // Death:
	if(my_health <= 0){
		instance_destroy();
	}
	
#define SewerDrain_end_step
	 // Stay Still:
	x     = pround(xstart, 16) - 16;
	y     = pround(ystart, 16);
	speed = 0;
	
#define SewerDrain_destroy
	var _roomType = type;
	
	 // Sound:
	sound_play_pitch(snd_dead, 1 - random(0.3));
	with(instance_nearest(x, y, Player)){
		sound_play_pitchvol(snd_chst, 1, 0.9);
	}
	
	 // Turt:
	with(instances_matching_lt(obj.TurtleCool, "notice_delay", 1)){
		notice_delay = 1;
	}
	
	 // Deleet Stuff:
	var	_x1 = bbox_left,
		_y1 = bbox_top - (16 * (type == "area")),
		_x2 = bbox_right,
		_y2 = bbox_bottom;
		
	if(fork()){
		repeat(2){
			call(scr.wall_delete, _x1, _y1, _x2, _y2);
			wait 0;
		}
		exit;
	}
	
	 // Corpse:
	call(scr.corpse_drop, self, 0, 0);
	repeat(6){
		with(instance_create(x + orandom(8), y + orandom(8), Debris)){
			direction = angle_lerp(direction, 90, 1/4);
		}
	}
	
	 // Area Entrance:
	if(_roomType == "area"){
		var	_sx = pfloor(x, 32),
			_sy = pfloor(y, 32) - 16;
			
		 // Borderize Area:
		var _borderY = _sy - hallway_size + 72;
		call(scr.obj_create, x, _borderY, "LairBorder");
		
		 // Path Gen:
		var	_dir  = 90,
			_path = [];
			
		instance_create(_sx + 16, _sy + 16, PortalClear);
		
		while(_sy >= _borderY - 224){
			with(instance_create(_sx, _sy, Floor)){
				array_push(_path, self);
				call(scr.wall_delete, bbox_left, bbox_top, bbox_right, bbox_bottom);
			}
			
			 // Turn:
			if(_sy >= _borderY - 160 && _sy <= _borderY - 32){
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
		var	_lastArea = GameCont.area,
			_scrSetup = null,
			_bgColor  = background_color;
			
		if(crown_current == "red"){
			_scrSetup = script_ref_create_ext("crown", crown_current, "step");
		}
		
		call(scr.area_generate, area, subarea, loops, _sx + 16, _sy - 16, true, 0, _scrSetup);
		
		 // Finish Path:
		var _minID = instance_max;
		with(_path){
			area         = GameCont.area;
			styleb       = true;
			sprite_index = call(scr.area_get_sprite, area, sprFloor1B);
			call(scr.floor_walls, self);
			
			 // Pipe Decals:
			if(_borderY < bbox_top || _borderY > bbox_bottom + 1){
				GameCont.area = ((y > _borderY) ? _lastArea : area);
				call(scr.floor_bones, self, 1, 1/12, true);
				GameCont.area = area;
			}
		}
		call(scr.wall_tops, instances_matching_gt(Wall, "id", _minID));
		with(instances_matching_gt(TopSmall, "id", _minID)){
			with(self){
				event_perform(ev_alarm, 0);
			}
		}
		
		 // Reveal Path:
		var	_y    = y - 48,
			_time = 7,
			_wait = 0;
			
		with(call(scr.floor_reveal, bbox_left, _y, bbox_right, y - 16 - 1, 10)){
			color = _bgColor;
			_wait += time - _time;
		}
		with(instances_matching_lt(_path, "bbox_top", _y)){
			if(bbox_bottom > _borderY){
				with(call(scr.floor_reveal, bbox_left, bbox_top, bbox_right, min(_y - 1, bbox_bottom), _time)){
					y1 = max(y1, _borderY - oy);
					time += _wait;
					color = _bgColor;
				}
			}
			if(bbox_top < _borderY){
				with(call(scr.floor_reveal, bbox_left, bbox_top, bbox_right, bbox_bottom, _time)){
					y2 = min(y2, _borderY - oy - 1);
					time += _wait;
				}
			}
			_wait += 3;
		}
		
		 // Crown Time:
		if(GameCont.area == "lair"){
			call(scr.unlock_set, "crown:crime", true);
		}
	}
	
	 // Secret Room:
	else with(my_floor){
		var	_x        = bbox_center_x,
			_y        = bbox_center_y,
			_w        = 4,
			_h        = 3,
			_type     = "",
			_dirStart = 90,
			_dirOff   = 0,
			_floorDis = 32,
			_minID    = instance_max;
			
		with(call(scr.floor_room_create, _x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)){
			 // Entrance Hallway:
			with(call(scr.floor_tunnel, x, y2, _x, _y)){
				call(scr.floor_reveal, bbox_left, bbox_top, bbox_right, bbox_bottom, 10);
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
			with(call(scr.array_shuffle, floors)){
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
						
					with(call(scr.fx, _dx, _dy, [point_direction(_dx, _dy, _x, _y) + orandom(30), 3], Dust)){
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
						call(scr.chest_create, 
							x + orandom(1) + lerp(-_ox, _ox, i / max(1, _num - 1)),
							y + orandom(1),
							_obj[i % array_length(_obj)],
							true
						);
					}
					
					break;
					
				case "Pizza":
					
					 // Manhole:
					with(call(scr.instance_nearest_bbox, x + _ox, y, FloorNormal)){
						call(scr.obj_create, bbox_center_x, bbox_center_y, "Manhole");
						
						 // Pizza:
						if(chance(2, 3)){
							var _px = bbox_center_x + orandom(4) + random(16 * sign(_ox)),
								_py = bbox_center_y + orandom(4);
								
							if(chance(1, 2)){
								call(scr.obj_create, _px, _py, "PizzaStack");
							}
							else{
								call(scr.chest_create, _px, _py, "PizzaChest", true);
							}
						}
					}
					
					 // Nader:
					with(call(scr.obj_create, x - _ox, y, "WepPickupGrounded")){
						target = instance_create(x, y, WepPickup);
						with(target){
							ammo = true;
							wep  = wep_grenade_launcher;
						}
					}
					
					break;
					
				case "RedSpider":
					
					var _num = irandom_range(2, 5);
					with(call(scr.array_shuffle, floors)){
						if(_num > 0){
							if(!place_meeting(x, y, Wall)){
								_num--;
								
								 // Props:
								if((_num % 2) == 1){
									call(scr.obj_create, bbox_center_x + orandom(8), bbox_center_y + orandom(8), "CrystalPropRed");
								}
								
								 // Enemies:
								else{
									call(scr.obj_create, bbox_center_x, bbox_center_y, _roomType);
								}
							}
						}
						else break;
					}
					
					break;
					
				case FrogQueen:
					
					 // Cool Floors:
					call(scr.floor_set_style, 1);
					call(scr.floor_fill, x1 + 16, y, 1, _h);
					call(scr.floor_fill, x2 - 16, y, 1, _h);
					call(scr.floor_reset_style);
					
					 // Herself:
					with(instance_create(x, y, _roomType)){
						maxhealth = round(maxhealth / 2);
						my_health = round(my_health / 2);
						alarm3 = 60;
						
						 // Ammo:
						_ox = (((_w * 32) / 2) - 16) * sign(_ox);
						var _num = 2 + skill_get(mut_open_mind);
						for(var i = 0; i < _num; i++){
							call(scr.chest_create, 
								x + orandom(1) + lerp(-_ox, _ox, i / max(1, _num - 1)),
								y + orandom(1),
								choose(AmmoChest, WeaponChest),
								true
							);
						}
					}
					
					break;
					
				case "GatorStatue":
					
					with(call(scr.obj_create, x, y - 4, _roomType)){
						with(call(scr.obj_create, x, y - 22, "CatLight")){
							image_xscale *= 1.1;
						}
					}
					
					break;
					
			}
			
			 // Decorate:
			repeat(2){
				call(scr.obj_create, x, y, "TopDecal");
			}
		}
		
		 // Room Revealing Visual:
		with(instances_matching_gt(Floor, "id", _minID)){
			call(scr.floor_reveal, bbox_left, bbox_top, bbox_right, bbox_bottom, 10);
		}
		sleep(100);
	}
	
	 // No Leaving:
	if(instance_exists(enemy)){
		call(scr.portal_poof);
	}
	
	
#define SewerRug_create(_x, _y)
	with(instance_create(_x, _y, Carpet)){
		 // Visual:
		sprite_index = spr.Rug;
		image_index  = ((array_find_index([area_pizza_sewers, "pizza"], GameCont.area) < 0) ? 0 : 1);
		image_speed  = 0;
		
		return self;
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
		with(call(scr.obj_create, 0, 0, "PortalPrevent")){
			creator = other;
		}
		
		return self;
	}
	
#define TurtleCool_step
	if(patience <= 0 || point_seen(x, y, -1)){
		 // Noticable Players:
		var _players = [];
		with(Player){
			if(point_distance(x, y, other.x, other.y) < 96){
				array_push(_players, self);
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
		if(array_length(_players) && notice > 0){
			var _target = call(scr.instance_nearest_array, x, y, _players);
			
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
				enemy_look(point_direction(x, y, _target.x, _target.y));
			}
		}
		
		 // Watchin TV:
		else{
			var _target = instance_nearest(x, y, TV);
			if(instance_exists(_target) && point_distance(x, y, _target.x, _target.y) < 96){
				enemy_look(point_direction(x, y, _target.x, _target.y));
			}
		}
		
		 // Push Collision:
		if(place_meeting(x, y, hitme)){
			with(call(scr.instances_meeting_instance, self, hitme)){
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
		var _angered = (my_health < maxhealth || !instance_exists(TV));
		if(!_angered){
			if(instance_exists(Corpse)){
				with(instances_matching(Corpse, "sprite_index", sprTurtleDead, sprRatDead)){
					if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
						_angered = true;
						break;
					}
				}
			}
			if(!_angered){
				if(instance_exists(Turtle) || instance_exists(Rat)){
					with(instances_matching_ne([Turtle, Rat], "id")){
						if(my_health < maxhealth && !collision_line(x, y, other.x, other.y, Wall, false, false)){
							_angered = true;
							break;
						}
					}
				}
			}
		}
		if(_angered){
			with(instances_matching_gt(obj.TurtleCool, "patience", 0)){
				patience = 0;
			}
		}
		if(patience <= 0){
			var	_damage = (my_health - maxhealth),
				_vars   = { "x":x, "y":y, "nexthurt":nexthurt, "sprite_index":sprite_index, "image_index":image_index, "snd_dead":snd_dead, "right":right };
				
			instance_change(become, true);
			
			if(instance_exists(self)){
				my_health += _damage;
				alarm1 = 10 + random(10);
				call(scr.variable_instance_set_list, self, _vars);
				
				 // Alert:
				sound_play_hit(sndTurtleMelee, 0.3);
				with(instance_create(x, y, AssassinNotice)){
					depth = -8;
				}
				if(my_health < maxhealth){
					enemy_look(direction + 180);
				}
			}
			
			 // Allow Portals:
			with(instances_matching(obj.PortalPrevent, "creator", self)){
				instance_destroy();
			}
		}
	}
	
#define TurtleCool_draw
	draw_self_enemy();
	
	
/// GENERAL
#define ntte_draw_shadows
	 // Doors:
	if(array_length(obj.CatDoor)){
		var _inst = call(scr.instances_seen_nonsync, instances_matching_ne(instances_matching(obj.CatDoor, "visible", true), "surf_door", noone), 16, 24);
		if(array_length(_inst)){
			with(_inst){
				if(surface_exists(surf_door.surf)){
					var	_yscale = 0.5 + (0.5 * max(abs(dcos(image_angle + openang)), abs(dsin(image_angle + openang))));
					draw_surface_ext(
						surf_door.surf,
						surf_door.x,
						surf_door.y + (surf_door.h / 2) + (((image_number - 1) - (surf_door.h / 2)) * _yscale),
						1       / surf_door.scale,
						_yscale / surf_door.scale,
						0,
						c_white,
						1
					);
				}
			}
		}
	}
	
	 // Fix Sewer Drain Shadows:
	if(array_length(obj.SewerDrain)){
		with(instances_matching(obj.SewerDrain, "visible", true)){
			draw_sprite_ext(sprite_index, image_index, x, y - 14, image_xscale, -image_yscale, image_angle, c_white, 1);
		}
	}
	
#define ntte_draw_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
			
			var _gray = (_type == "normal");
			
			 // Cat Light:
			if(array_length(obj.CatLight)){
				var	_xAdd = 16 * _gray,
					_yAdd =  8 * _gray,
					_inst = call(scr.instances_seen_nonsync, instances_matching(obj.CatLight, "visible", true), _xAdd, _yAdd);
					
				if(array_length(_inst)){
					draw_set_fog(true, draw_get_color(), 0, 0);
					
					 // Border:
					if(_gray){
						with(_inst){
							var	_xscAdd = _xAdd / sprite_get_width(sprite_index),
								_yscAdd = _yAdd / sprite_get_height(sprite_index);
								
							image_xscale += _xscAdd;
							image_yscale += _yscAdd;
							image_alpha   = abs(image_alpha);
							
							draw_self();
							
							image_xscale -= _xscAdd;
							image_yscale -= _yscAdd;
							image_alpha  *= -1;
						}
					}
					
					 // Normal:
					else with(_inst){
						image_alpha = abs(image_alpha);
						draw_self();
						image_alpha *= -1;
					}
					
					draw_set_fog(false, 0, 0, 0);
				}
			}
			
			 // Manhole Cover:
			if(array_length(obj.PizzaManholeCover)){
				 // Circle:
				if(_gray){
					with(instances_matching_ne(obj.PizzaManholeCover, "id")){
						draw_circle(xstart, ystart - 16, 40 + random(2), false);
					}
				}
				
				 // Hole in Ceiling:
				else with(instances_matching_ne(obj.PizzaManholeCover, "id")){
					draw_sprite_ext(spr.CatLightThin, 0, xstart, ystart - 32, 1/3.5, 1/4.25, orandom(1), c_white, 1);
				}
			}
			
			 // Boss Manhole:
			if(_gray){
				if(array_length(obj.CatHoleBig)){
					with(instances_matching_ne(obj.CatHoleBig, "id")){
						draw_circle(x, y, 192 + random(2), false);
					}
				}
			}
			
			 // TV:
			if(array_length(obj.PizzaTV)){
				 // Circle:
				if(_gray){
					with(instances_matching_ne(obj.PizzaTV, "id")){
						draw_circle(x, y, 64 + random(2), false);
					}
				}
				
				 // TV Beam:
				else with(instances_matching_ne(obj.PizzaTV, "id")){
					var _scale = 1 + orandom(0.025);
					draw_sprite_ext(spr.CatLight, 0, x, y - 5, _scale / 3.5, _scale / 2.5, 0, c_white, 1);
				}
			}
			
			 // Big Shots:
			if(array_length(obj.BatBoss) || array_length(obj.CatBoss)){
				var _r = 28 + (36 * _gray);
				with(instances_matching(call(scr.array_combine, obj.BatBoss, obj.CatBoss), "visible", true)){
					draw_circle(x, y, _r + random(2), false);
				}
			}
			
			break;
			
	}
	
#define ntte_draw_bloom
	 // Flame Spark:
	if(array_length(obj.FlameSpark)){
		with(instances_matching_ne(obj.FlameSpark, "id")){
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 3, image_yscale * 3, image_angle, image_blend, image_alpha * 0.1);
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