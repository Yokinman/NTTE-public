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
	
	 // Underwater Stuff:
	global.underwater_bind_draw    = script_bind(CustomDraw, underwater_draw, -3, false);
	global.underwater_sound_active = false;
	global.underwater_sound        = {
		"sndOasisShoot" : [
			sndBloodLauncher,
			sndBouncerShotgun,
			sndBouncerSmg,
			sndClusterLauncher,
			sndConfettiGun,
			sndCrossbow,
			sndDiscgun,
			sndDoubleMinigun,
			sndDragonStart,
			sndEnemyFire,
			sndFireShotgun,
			sndFlakCannon,
			sndFlare,
			sndFlareExplode,
			sndFrogPistol,
			sndGoldCrossbow,
			sndGoldDiscgun,
			sndGoldFrogPistol,
			sndGoldGrenade,
			sndGoldLaser,
			sndGoldLaserUpg,
			sndGoldMachinegun,
			sndGoldPistol,
			sndGoldPlasma,
			sndGoldPlasmaUpg,
			sndGoldRocket,
			sndGoldShotgun,
			sndGoldSlugger,
			sndGoldSplinterGun,
			sndGrenade,
			sndGrenadeRifle,
			sndGrenadeShotgun,
			sndGruntFire,
			sndGunGun,
			sndHeavyCrossbow,
			sndHeavyMachinegun,
			sndHeavyNader,
			sndHeavyRevoler,
			sndHyperLauncher,
			sndHyperRifle,
			sndIncinerator,
			sndMachinegun,
			sndMinigun,
			sndLaser,
			sndLaserUpg,
			sndLaserCannon,
			sndLaserCannonUpg,
			sndLightningHammer,
			sndLightningPistol,
			sndLightningPistolUpg,
			sndLightningRifle,
			sndLightningRifleUpg,
			sndPistol,
			sndPlasma,
			sndPlasmaUpg,
			sndPlasmaMinigun,
			sndPlasmaMinigunUpg,
			sndPlasmaRifle,
			sndPlasmaRifleUpg,
			sndPopgun,
			sndQuadMachinegun,
			sndRogueRifle,
			sndRustyRevolver,
			sndSeekerPistol,
			sndSeekerShotgun,
			sndShotgun,
			sndSlugger,
			sndSmartgun,
			sndSplinterGun,
			sndSplinterPistol,
			sndSuperCrossbow,
			sndSuperDiscGun,
			sndSuperSplinterGun,
			sndToxicLauncher,
			sndTripleMachinegun,
			sndTurretFire,
			sndUltraPistol,
			sndWaveGun
		],
		"sndOasisMelee" : [
			sndBlackSword,
			sndBloodHammer,
			sndChickenSword,
			//sndClusterOpen,
			sndCrossReload,
			sndEnergyHammer,
			sndEnergyHammerUpg,
			sndEnergyScrewdriver,
			sndEnergyScrewdriverUpg,
			sndEnergySword,
			sndEnergySwordUpg,
			sndFlamerStart,
			sndGoldScrewdriver,
			sndGoldWrench,
			sndGuitar,
			sndHammer,
			sndJackHammer,
			sndScrewdriver,
			sndShotReload,
			sndShovel,
			sndUltraShovel,
			sndWrench
		],
		"sndOasisExplosion" : [
			sndBloodCannonEnd,
			sndBloodLauncherExplo,
			sndCorpseExplo,
			sndDevastator,
			sndDevastatorExplo,
			sndDevastatorUpg,
			sndExplosion,
			sndExplosionCar,
			sndExplosionL,
			sndExplosionXL,
			sndFlameCannonEnd,
			sndGoldNukeFire,
			sndLightningCannonEnd,
			sndLightningCannonUpg,
			sndNukeFire,
			sndNukeExplosion,
			sndPlasmaBigExplode,
			sndPlasmaBigUpg,
			sndPlasmaHuge,
			sndPlasmaHugeUpg,
			sndSuperFlakCannon,
			sndSuperFlakExplode
		],
		"sndOasisExplosionSmall" : [
			sndBloodCannon,
			sndDoubleFireShotgun,
			sndDoubleShotgun,
			sndEraser,
			sndExplosionS,
			sndFlakExplode,
			sndFlameCannon,
			sndHeavySlugger,
			sndHyperSlugger,
			sndIDPDNadeExplo,
			sndLightningCannon,
			sndLightningShotgun,
			sndLightningShotgunUpg,
			sndPlasmaBig,
			sndPlasmaHit,
			sndRocket,
			sndSawedOffShotgun,
			sndSuperBazooka,
			sndUltraCrossbow,
			sndUltraGrenade,
			sndUltraShotgun,
			sndUltraLaser,
			sndUltraLaserUpg,
			sndWallBreakRock
		],
		"sndOasisPopo" : [
			sndEliteIDPDPortalSpawn,
			sndIDPDPortalSpawn
		],
		"sndOasisPortal" : [
			sndGoldRocketFly,
			sndPortalOpen,
			sndRocketFly,
			sndLaserCannonCharge,
			sndPlasmaReload,
			sndPlasmaReloadUpg,
			sndBasicUltra,
			sndCoopUltraA,
			sndCoopUltraB,
			sndFishUltraA,
			sndFishUltraB,
			sndCrystalUltraA,
			sndCrystalUltraB,
			sndEyesUltraA,
			sndEyesUltraB,
			sndMeltingUltraA,
			sndMeltingUltraB,
			sndPlantUltraA,
			sndPlantUltraB,
			sndYVUltraA,
			sndYVUltraB,
			sndSteroidsUltraA,
			sndSteroidsUltraB,
			sndRobotUltraA,
			sndRobotUltraB,
			sndChickenUltraA,
			sndChickenUltraB,
			sndRebelUltraA,
			sndRebelUltraB,
			sndHorrorUltraA,
			sndHorrorUltraB,
			sndHorrorUltraC,
			sndRogueUltraA,
			sndRogueUltraB,
			sndSkeletonUltraA,
			sndSkeletonUltraB,
			sndFrogUltraA,
			sndFrogUltraB
		],
		"sndOasisChest" : [
			sndAmmoChest,
			sndBigCursedChest,
			sndBigWeaponChest,
			sndChest,
			sndCursedChest,
			//sndGoldChest,
			sndHealthChest,
			sndHealthChestBig,
			sndHitWall,
			sndShotgunHitWall,
			sndToxicBoltGas,
			sndWeaponChest
		],
		"sndOasisHurt" : [
			sndBoltHitWall,
			sndMeleeWall,
			sndMutant1Hurt,
			sndMutant2Hurt,
			sndMutant3Hurt,
			sndMutant4Hurt,
			sndMutant5Hurt,
			sndMutant6Hurt,
			sndMutant7Hurt,
			sndMutant8Hurt,
			sndMutant9Hurt,
			sndMutant10Hurt,
			sndMutant11Hurt,
			sndMutant12Hurt,
			sndMutant13Hurt,
			sndMutant14Hurt,
			sndMutant15Hurt,
			sndMutant16Hurt,
			sndMut,
			sndMutRhinoSkin,
			sndMutExtraFeet,
			sndMutPlutoniumHunger,
			sndMutRabbitPaw,
			sndMutThroneButt,
			sndMutLuckyShot,
			sndMutBloodLust,
			sndMutGammaGuts,
			sndMutSecondStomach,
			sndMutBackMuscle,
			sndMutScarierFace,
			sndMutEuphoria,
			sndMutLongArms,
			sndMutBoilingVeins,
			sndMutShotgunFingers,
			sndMutRecycleGland,
			sndMutLaserBrain,
			sndMutLastWish,
			sndMutEagleEyes,
			sndMutImpactWrists,
			sndMutBoltMarrow,
			sndMutStress,
			sndMutTriggerFingers,
			sndMutSharpTeeth,
			sndMutPatience,
			sndMutHammerhead,
			sndMutStrongSpirit,
			sndMutOpenMind,
			sndMutHeavyHeart
		],
		"sndOasisDeath" : [
			sndEliteShielderFire,
			sndGrenadeHitWall,
			sndMutant1Dead,
			sndMutant2Dead,
			sndMutant3Dead,
			sndMutant4Dead,
			sndMutant5Dead,
			sndMutant6Dead,
			sndMutant7Dead,
			sndMutant8Dead,
			sndMutant9Dead,
			sndMutant10Dead,
			sndMutant11Dead,
			sndMutant12Dead,
			sndMutant13Dead,
			sndMutant14Dead,
			sndMutant15Dead,
			sndMutant16Dead,
			sndSuperSlugger
		],
		"sndOasisHorn" : [
			sndVenuz,
			sndCrownRandom,
			sndCrownNo,
			sndCrownDeath,
			sndCrownLife,
			sndCrownHaste,
			sndCrownGuns,
			sndCrownHatred,
			sndCrownBlood,
			sndCrownDestiny,
			sndCrownLove,
			sndCrownLuck,
			sndCrownCurses,
			sndCrownRisk,
			sndCrownProtection
		]
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
	 // Reset Water Sounds:
	underwater_sound(false);
	
#macro underwater_area   ((GameCont.area == area_vault) ? GameCont.lastarea : GameCont.area)
#macro underwater_active (!instance_exists(GenCont) && !instance_exists(LevCont) && array_find_index(ntte.mods.area, underwater_area) >= 0 && call(scr.area_get_underwater, underwater_area))

#define BubbleBomb_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.BubbleBomb;
		image_speed  = 0.5;
		depth        = -4;
		
		 // Vars:
		mask_index = mskSuperFlakBullet;
		friction   = 0.4;
		damage     = 3;
		force      = 2;
		typ        = 1;
		z          = 0;
		zspeed     = -0.5;
		zfriction  = -0.02;
		big        = 0;
		held       = [];
		setup      = true;
		
		 // Merged Weapon Support:
		temerge_on_fire  = script_ref_create(BubbleBomb_temerge_fire);
		temerge_on_setup = script_ref_create(BubbleBomb_temerge_setup);
		
		return self;
	}
	
#define BubbleBomb_setup
	setup = false;
	
	 // Become Big:
	if(big > 0){
		sprite_index = spr.BubbleBombBig;
		mask_index   = mskExploder;
	}
	
	 // Become Enemy Bubble:
	else if(team == 1){
		sprite_index = spr.BubbleBombEnemy;
	}
	
#define BubbleBomb_step
	 // Float Up:
	z      += zspeed * current_time_scale;
	zspeed -= zfriction * current_time_scale;
	if(z > 8 && depth > -6){
		depth = -8;
	}
	
	 // Spin:
	image_angle += (sin(current_frame / 8) * 10) * current_time_scale;
	
	 // Charge FX:
	if(speed == 0 && chance_ct(1, 12)){
		if(chance(1, 2)){
			var _off = image_index / 3;
			instance_create(x + orandom(_off), y + orandom(_off), PortalL);
		}
		with(instance_create(x, y - z, BulletHit)){
			sprite_index = spr.BubbleCharge;
		}
	}
	
	 // Bubble Excrete:
	if(big > 0 && z < 24 && image_index >= 6 && chance_ct(big, 5 + max(z, 0))){
		with(call(scr.projectile_create, x + orandom(8), y - z - 8 + orandom(8), "BubbleBomb")){
			image_speed *= random_range(0.8, 1);
		}
	}
	
	 // Hold Projectile:
	if(array_length(held)){
		var	_x   = x,
			_y   = y - z,
			_num = 0;
			
		held = instances_matching_ne(held, "id");
		
		with(held){
			 // Push Bubble:
			if(instance_is(self, hitme)){
				other.x += (hspeed_raw * size) / 6;
				other.y += (vspeed_raw * size) / 6;
			}
			
			 // Float in Bubble:
			if(other.big <= 0){
				x = _x;
				y = _y;
			}
			else{
				var	_dis = 2 + ((_num * 123) % 8),
					_dir = (current_frame / (10 + speed)) + direction,
					_spd = (instance_is(self, hitme) ? max(0.3 - (_num * 0.05), 0.1) : 0.5);
					
				x += (_x + (_dis * cos(_dir)) - x) * _spd;
				y += (_y + (_dis * sin(_dir)) - y) * _spd;
				_num++;
			}
			call(scr.motion_step, self, -1);
		}
	}
	
#define BubbleBomb_end_step
	if(setup) BubbleBomb_setup();
	
	y -= z;
	
	 // Push:
	if(place_meeting(x, y, Player)){
		with(call(scr.instances_meeting_instance, self, Player)){
			if(place_meeting(x, y, other)) with(other){
				motion_add_ct(point_direction(other.x, other.y, x, y), 1.5);
			}
		}
	}
	
	 // Projectile / Enemy Collision:
	if(place_meeting(x, y, projectile) || place_meeting(x, y, enemy)){
		var _meeting = call(scr.instances_meeting_instance, self, [enemy, projectile]);
		
		 // Baseball:
		var _inst = instances_matching(_meeting, "object_index", Slash, GuitarSlash, BloodSlash, EnergySlash, EnergyHammerSlash, LightningSlash, CustomSlash);
		if(array_length(_inst)) with(_inst){
			if(place_meeting(x, y, other)){
				with(other){
					var	_lastAlrm = alarm1,
						_lastFric = friction,
						_lastSpd  = speed;
						
					with(other){
						event_perform(ev_collision, Grenade);
						if(!instance_exists(other)){
							exit;
						}
					}
					
					alarm1   = _lastAlrm;
					friction = _lastFric;
					if(speed != _lastSpd){
						speed = _lastSpd;
						if(speed < 8){
							speed = max(0, 10 - (4 * ((array_length(held) > 0) - 1 + big)));
							sound_play_pitchvol(sndBouncerBounce, ((big > 0) ? 0.5 : 0.8) + random(0.1), 3);
						}
					}
				}
			}
		}
		
		 // Poppable:
		var _inst = instances_matching(instances_matching_ne(_meeting, "team", team), "object_index", Flame, Bolt, Splinter, HeavyBolt, UltraBolt);
		if(array_length(_inst)) with(_inst){
			if(place_meeting(x, y, other)){
				with(other){
					instance_destroy();
					exit;
				}
			}
		}
		
		 // Grabbing:
		if(z < 24){
			if(!array_length(held) || big > 0){
				var _inst = instances_matching(_meeting, "bubble_bombed", null, false);
				if(big > 0){
					_inst = instances_matching_ne(_inst, "team", team);
				}
				if(array_length(_inst)) with(_inst){
					if(place_meeting(x, y, other)){
						if("size" not in self || size - (object_index == DogGuardian) <= (3 * other.big)){
							if(!instance_is(self, projectile) || (typ != 0 && array_find_index(obj.BubbleBomb, self) < 0)){
								bubble_bombed = true;
								
								array_push(other.held, self);
								
								with(other){
									if(big <= 0){
										x = lerp(x, other.x, 0.5);
										y = lerp(y, other.y, 0.5);
										friction = max(0.3, friction);
										motion_add(other.direction, other.speed / 2);
									}
									if(instance_is(other, hitme)){
										speed *= 0.8;
									}
									
									 // Effects:
									instance_create(x, y, Dust);
									repeat(4) instance_create(x, y, Bubble);
									sound_play(sndOasisHurt);
								}
								
								break;
							}
						}
					}
				}
			}
		}
		
		y += z;
		
		 // Bubble Collision:
		var _inst = instances_matching_ge(_meeting, "big", big);
		if(array_length(_inst)){
			with(_inst){
				if(array_find_index(obj.BubbleBomb, self) >= 0 && place_meeting(x, y, other)){
					with(other){
						motion_add_ct(point_direction(other.x, other.y, x, y) + orandom(4), 0.5);
					}
				}
			}
		}
	}
	else y += z;
	
#define BubbleBomb_draw
	var _blink = chance_ct(1, 8 + (image_number - image_index));
	
	 // Blink:
	if(_blink){
		var _lastCol = image_blend;
		image_blend = c_black;;
	}
	
	 // Draw:
	y -= z;
	draw_self();
	y += z;
	
	 // Unblink:
	if(_blink){
		image_blend = _lastCol;
	}
	
#define BubbleBomb_hit
	if(z < 24 && !instance_is(other, prop) && other.team != 0){
		 // Knockback:
		if(instance_is(other, enemy)){
			if(chance(1, 2) && ("bubble_bombed" not in other || other.bubble_bombed == false)){
				speed *= 0.9;
				with(other){
					motion_add(other.direction, other.force);
				}
			}
		}
		
		 // Speed Up:
		if(big <= 0 && team == 2){
			image_index += image_speed * 2;
		}
	}
	
#define BubbleBomb_wall
	 // Bounce:
	if(speed > 0){
		sound_play(sndBouncerBounce);
		move_bounce_solid(false);
		speed *= 0.5;
	}
	
#define BubbleBomb_anim
	 // Popo Nade Logic:
	if(deflected){
		team = (instance_is(creator, Player) ? creator.team : -1);
	}
	
	 // Explode:
	var	_dis = 16 * big,
		_ang = direction,
		_num = lerp(1, 3, big);
		
	for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
		with(call(scr.projectile_create, x + lengthdir_x(_dis, _dir), y - z + lengthdir_y(_dis, _dir), "BubbleExplosion")){
			damage = other.damage;
		}
	}
	
	 // Big Bombage Effects:
	sleep(15 * big);
	view_shake_at(x, y, 60 * big);
	if(big > 0){
		sound_play_pitch(sndOasisExplosion, 0.8 + orandom(0.05));
	}
	
	 // Make Sure Projectile Dies:
	with(instances_matching_ne(held, "creator", creator)){
		if(instance_is(self, projectile)){
			instance_destroy();
		}
	}
	
	instance_destroy();
	
#define BubbleBomb_destroy
	with(held) if(instance_exists(self)){
		bubble_bombed = false;
	}
	
	 // Pop:
	sound_play_pitchvol(sndLilHunterBouncer, 2 + random(0.5), 0.5);
	with(instance_create(x, y - z, BulletHit)){
		sprite_index = sprPlayerBubblePop;
		image_angle = other.image_angle;
		image_xscale = 0.5 + (0.01 * other.image_index);
		image_yscale = image_xscale;
	}
	
#define BubbleBomb_temerge_fire(_at, _setupInfo)
	_setupInfo.is_big = big;
	
#define BubbleBomb_temerge_setup(_instanceList, _setupInfo)
	 // Bubble Explosion:
	call(scr.projectile_add_temerge_effect, _instanceList, "explosion", [{ "is_bubble" : true }, (_setupInfo.is_big ? 3 : 1)]);
	
	
#define BubbleExplosion_create(_x, _y)
	with(instance_create(_x, _y, PopoExplosion)){
		 // Visual:
		sprite_index = spr.BubbleExplosion;
		hitid        = [sprite_index, "BUBBLE EXPLOSION"];
		
		 // Vars:
		mask_index = mskExplosion;
		damage     = 3;
		force      = 1;
		alarm0     = -1; // No scorchmark
		alarm1     = -1; // No CoDeath
		
		 // Crown of Explosions:
		if(crown_current == crwn_death){
			script_bind_end_step(BubbleExplosion_death, 0, self);
		}
		
		 // FX:
		sound_play_pitch(sndExplosionS, 2);
		sound_play_pitch(sndOasisExplosion, 1 + random(1));
		repeat(10) instance_create(x, y, Bubble);
		
		return self;
	}
	
#define BubbleExplosion_death(_inst)
	with(_inst){
		repeat(choose(2, 3)){
			with(call(scr.obj_create, x + orandom(9), y + orandom(9), "BubbleExplosionSmall")){
				team = other.team;
			}
		}
	}
	instance_destroy();
	
	
#define BubbleExplosionSmall_create(_x, _y)
	with(instance_create(_x, _y, SmallExplosion)){
		 // Visual:
		sprite_index = spr.BubbleExplosionSmall;
		hitid        = [sprite_index, "SMALL BUBBLE#EXPLOSION"];
		
		 // Vars:
		mask_index = mskSmallExplosion;
		damage     = 3;
		force      = 1;
		
		 // FX:
		sound_play_pitch(sndOasisExplosionSmall, 1 + random(2));
		repeat(5) instance_create(x, y, Bubble);
		
		return self;
	}
	
#define BubbleExplosionSmall_step
	 // Projectile Kill:
	if(place_meeting(x, y, projectile)){
		with(call(scr.instances_meeting_instance, self, instances_matching_ne(instances_matching_ne(projectile, "team", team), "typ", 0))){
			if(place_meeting(x, y, other)){
				instance_destroy();
			}
		}
	}
	
	
#define BubbleSlash_create(_x, _y)
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.BubbleSlash;
		image_speed  = 0.4;
		
		 // Vars:
		mask_index = mskSlash;
		damage     = 16;
		force      = 12;
		walled     = false;
		
		return self;
	}
	
#define BubbleSlash_projectile
	if(instance_exists(self)){
		with(other){
			if(typ == 1 || typ == 2){
				 // Deflect:
				if(typ == 1 && other.candeflect){
					deflected   = true;
					team        = other.team;
					direction   = other.direction;
					image_angle = direction;
					with(instance_create(x, y, Deflect)){
						image_angle = other.image_angle;
					}
					
					 // Enbubble:
					if(variable_instance_get(self, "bubble_bombed", false) == false){
						bubble_bombed = true;
						
						 // Bubble Bomb:
						with(other){
							array_push(call(scr.projectile_create, other.x, other.y, "BubbleBomb").held, other);
						}
						
						 // Effects:
						with(instance_create(x, y, Bubble)){
							image_xscale = 0.75;
							image_yscale = image_xscale;
							image_angle  = random(360);
						}
						with(instance_create(x, y, BubblePop)){
							image_index  = 1;
							image_xscale = 0.8;
							image_yscale = image_xscale;
							image_angle  = random(360);
							depth        = other.depth - 1;
						}
					}
				}
				
				 // Destroy:
				else{
					with(other){
						call(scr.projectile_create, other.x, other.y, ((other.damage < 6) ? "BubbleExplosionSmall" : "BubbleExplosion"));
					}
					instance_destroy();
				}
			}
		}
	}
	
#define BubbleSlash_hit
	if(projectile_canhit_melee(other)){
		projectile_hit_push(other, damage, force);
		
		 // Game Feel Shit:
		with(other){
			repeat(clamp((size * 2), 1, 6)){
				with(instance_create(other.x, other.y, Bubble)){
					motion_add(
						other.direction + orandom(12),
						irandom(3) + 2
					);
					friction     = 0.1;
					image_xscale = 0.75;
					image_yscale = image_xscale;
					image_angle  = random(360);
				}
			}
			if(size > 0){
				with(instance_create(x, y, BubblePop)){
					sprite_index = ((other.size < 2) ? sprPlayerBubblePop : spr.BigBubblePop);
					image_index  = 1;
					image_angle  = random(360);
					depth        = other.depth - 1;
					/*
					image_xscale = min(0.75 + 0.25 * other.size, 3);
					image_yscale = image_xscale;
					*/
				}
				if(my_health <= 0){
					view_shake_at(x, y, 5);
					sleep(12);
				}
			}
		}
	}
	
#define BubbleSlash_wall
	if(!walled){
		walled = true;
		
		x += hspeed_raw;
		y += vspeed_raw;
		
		 // Hit Wall FX:
		var	_x = bbox_center_x,
			_y = bbox_center_y;
			
		with(
			instance_is(other, Wall)
			? call(scr.instance_nearest_bbox, _x, _y, call(scr.instances_meeting_instance, self, Wall))
			: other
		){
			with(instance_create(bbox_center_x, bbox_center_y, MeleeHitWall)){
				image_angle = point_direction(_x, _y, x, y);
				call(scr.sound_play_at, x, y, sndMeleeWall, 1.6 + random(0.3), 0.8);
			}
		}
		
		x -= hspeed_raw;
		y -= vspeed_raw;
	}
	
	
#define CrabTank_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
		 // For Sani's bosshudredux:
		bossname = "CRAB TANK";
		col      = c_red;
		
		 // Visual:
		spr_idle     = spr.CrabTankIdle;
		spr_walk     = spr.CrabTankWalk;
		spr_hurt     = spr.CrabTankHurt;
		spr_dead     = spr.CrabTankDead;
		spr_shadow   = shd32;
		hitid        = [spr_idle, "CRAB TANK"];
		sprite_index = spr_idle;
		depth        = -2;
		
		 // Yeehaw:
		image_blend = merge_color(c_white, c_red, 0.2);
		image_xscale *= 1.4;
		image_yscale *= 1.2;
		
		 // Sounds:
		snd_hurt = sndOasisHurt;
		snd_dead = sndOasisDeath;
		snd_mele = sndOasisMelee;
		
		 // Vars:
		mask_index  = mskScorpion;
		maxhealth   = call(scr.boss_hp, 300);
		raddrop     = 100;
		size        = 3;
		meleedamage = 3;
		canmelee    = true;
		
		return self;
	}
	
	
#define FakeDust_create(_x, _y)
	/*
		Fake Dust, useful in underwater areas
	*/
	
	with(instance_create(_x, _y, Smoke)){
		 // Visual:
		sprite_index = sprDust;
		image_index  = random(image_number);
		
		 // Vars:
		motion_set(random(360), random(2));
		friction     = 0.3;
		image_xscale = 0.8;
		image_yscale = image_xscale;
		growspeed    = random(0.005) - 0.025;
		
		return self;
	}
	
	
#define HammerShark_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.HammerSharkIdle;
		spr_walk     = spr.HammerSharkIdle;
		spr_hurt     = spr.HammerSharkHurt;
		spr_dead     = spr.HammerSharkDead;
		spr_chrg     = spr.HammerSharkChrg;
		spr_shadow   = shd48;
		spr_shadow_y = 2;
		hitid        = [spr_idle, "HAMMERHEAD"];
		depth        = -2;
		
		 // Sound:
		snd_hurt = sndSalamanderHurt;
		snd_dead = sndOasisDeath;
		snd_mele = sndBigBanditMeleeHit;
		
		 // Vars:
		mask_index  = mskScorpion;
		maxhealth   = 40;
		raddrop     = 12;
		size        = 2;
		walk        = 0;
		walkspeed   = 0.8;
		maxspeed    = 4;
		meleedamage = 4;
		direction   = random(360);
		rotate      = 0;
		charge      = 0;
		charge_dir  = 0;
		charge_wait = 0;
		
		 // Alarms:
		alarm1 = 40 + random(20);
		
		return self;
	}
	
#define HammerShark_step
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
	if(sprite_index != spr_chrg || anim_end){
		sprite_index = enemy_sprite;
	}
	
	 // Swim in a circle:
	if(rotate != 0){
		rotate    -= clamp(rotate, -current_time_scale, current_time_scale);
		direction += rotate * current_time_scale;
		if(speed != 0){
			enemy_look(direction);
		}
	}
	
	 // Charge:
	if(charge > 0 || charge_wait > 0){
		direction = angle_lerp_ct(direction, charge_dir + (sin(charge / 5) * 20), 1/3);
		enemy_look(direction);
	}
	if(charge_wait > 0){
		charge_wait -= current_time_scale;
		
		x += (orandom(1) - lengthdir_x(charge_wait / 5, charge_dir)) * current_time_scale;
		y += (orandom(1) - lengthdir_y(charge_wait / 5, charge_dir)) * current_time_scale;
		sprite_index = choose(spr_hurt, spr_chrg);
		
		 // Start Charge:
		if(charge_wait <= 0){
			sound_play_pitch(sndRatkingCharge, 0.4 + random(0.2));
			view_shake_at(x, y, 15);
		}
	}
	else if(charge > 0){
		charge -= current_time_scale;
		
		if(sprite_index != spr_hurt){
			sprite_index = spr_chrg;
		}
		
		 // Fast Movement:
		motion_add(direction, 3);
		enemy_look(direction);
		
		 // Break Walls:
		call(scr.motion_step, self, 1);
		if(place_meeting(x, y, Wall)){
			with(call(scr.instances_meeting_instance, self, Wall)){
				if(place_meeting(x, y, other)){
					 // Effects:
					if(chance(1, 2)){
						with(instance_create(bbox_center_x, bbox_center_y, Hammerhead)){
							motion_add(random(360), 1);
						}
					}
					instance_create(x, y, Smoke);
					sound_play_pitchvol(sndHammerHeadProc, 0.75, 0.5);
					
					 // Destroy:
					instance_create(x, y, FloorExplo);
					instance_destroy();
				}
			}
		}
		call(scr.motion_step, self, -1);
		
		 // Effects:
		if(current_frame_active){
			call(scr.fx, [x, 8], y + 8, 1, Dust);
		}
		if((charge % 5) < current_time_scale){
			view_shake_at(x, y, 10);
		}
		
		 // Charge End:
		if(charge <= 0){
			sound_play_pitch(sndRatkingChargeEnd, 0.6);
		}
	}
	
#define HammerShark_alrm1
	alarm1 = 30 + random(20);
	
	if(enemy_target(x, y) && target_distance < 256){
		if(target_visible){
			 // Close Range Charge:
			if(target_distance < 96 && chance(3, 4)){
				charge      = 15 + random(10);
				charge_wait = 15;
				charge_dir  = target_direction;
				sound_play_pitchvol(sndHammerHeadEnd, 0.6, 0.25);
			}
			
			 // Move Towards Target:
			else{
				enemy_walk(
					target_direction + orandom(20),
					30
				);
				rotate = orandom(20);
			}
		}
		
		else{
			 // Charge Through Walls:
			if(my_health < maxhealth && chance(1, 3)){
				charge      = 30;
				charge_wait = 15;
				charge_dir  = target_direction;
				alarm1      = charge + charge_wait + random(10);
				sound_play_pitchvol(sndHammerHeadEnd, 0.6, 0.25);
			}
			
			 // Movement:
			else{
				enemy_walk(
					target_direction + orandom(90),
					random_range(20, 30)
				);
				rotate = orandom(30);
			}
		}
	}
	
	 // Passive Movement:
	else{
		enemy_walk(direction, 30);
		rotate = orandom(30);
		alarm1 += random(walk);
	}
	
#define HammerShark_death
	pickup_drop(30, 8, 0);
	
	
#define HyperBubble_create(_x, _y)
	with(instance_create(_x, _y, CustomProjectile)){
		 // Vars:
		mask_index = mskNone;
		hits       = 3;
		damage     = 12;
		force      = 12;
		
		 // Merged Weapon Support:
		temerge_on_setup = script_ref_create(HyperBubble_temerge_setup);
		
		return self;
	}
	
#define HyperBubble_end_step
	mask_index = mskBullet1;
	
	var	_dist    = 100,
		_proj    = [],
		_dis     = 16,
		_dir     = direction,
		_mx      = lengthdir_x(_dis, _dir),
		_my      = lengthdir_y(_dis, _dir),
		_targets = instances_matching_ne(hitme, "team", team);
		
	 // Muzzle Explosion:
	call(scr.projectile_create, x, y, "BubbleExplosionSmall");
	
	 // Hitscan:
	while(_dist-- > 0 && hits > 0 && !place_meeting(x, y, Wall)){
		x += _mx;
		y += _my;
		
		 // Effects:
		if(chance(1, 3)){
			with(call(scr.fx, [x, 4], [y, 4], [_dir + orandom(4), 6 + random(4)], Bubble)){
				friction = 0.2;
			}
		}
		if(chance(2, 3)){
			call(scr.fx, [x, 2], [y, 2], [_dir + orandom(4), 2 + random(2)], Smoke);
		}
		
		 // Explosion:
		if(place_meeting(x, y, hitme)){
			var _inst = call(scr.instances_meeting_instance, self, instances_matching_gt(_targets, "my_health", 0));
			if(array_length(_inst)){
				var _hit = false;
				with(_inst){
					if(place_meeting(x, y, other)){
						if(!_hit){
							_hit = true;
							with(other){
								hits--;
								call(scr.projectile_create, x, y, "BubbleExplosionSmall");
							}
						}
						
						 // Impact Damage:
						projectile_hit(self, other.damage, other.force, _dir);
					}
				}
			}
		}
	}
	
	 // End Explosion:
	call(scr.projectile_create, x, y, "BubbleExplosion");
	if(hits > 0) repeat(hits){
		call(scr.projectile_create, x, y, "BubbleExplosionSmall");
	}
	
	 // Goodbye:
	instance_destroy();
	
#define HyperBubble_temerge_setup(_instanceList)
	 // Hyper:
	call(scr.projectile_add_temerge_effect, _instanceList, "hyper");
	
	 // Bubble Explosion:
	call(scr.projectile_add_temerge_effect, _instanceList, "explosion", [{ "is_bubble" : true }]);
	
	
#define OasisPetBecome_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle     = spr.SlaughterPropIdle;
		spr_hurt     = spr.SlaughterPropHurt;
		spr_dead     = spr.SlaughterPropDead;
		spr_shadow   = shd24;
		spr_shadow_y = -2;
		image_speed  = 0.4;
		depth        = -1;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = sndOasisDeath;
		
		 // Vars:
		mask_index   = mskFrogEgg;
		image_xscale = choose(-1, 1);
		maxhealth    = 30;
		raddrop      = 0;
		size         = 1;
		team         = 0;
		prompt       = call(scr.prompt_create, self, "SHARE");
		
		return self;
	}
	
#define OasisPetBecome_step
	 // Donate Rad Chunk:
	if(instance_exists(prompt)){
		var _cost = 10;
		
		prompt.visible = (GameCont.rad >= _cost && raddrop <= 0);
		
		with(player_find(prompt.pick)){
			GameCont.rad -= _cost;
			var _rad = instance_create(x, y, BigRad);
			with(_rad){
				call(scr.sound_play_at, x, y, sndHitFlesh, 2.5, 0.5);
				motion_add(random(360), 4);
				depth = -2;
			}
			call(scr.rad_path, _rad, other);
		}
	}
	
	 // Eye Recieved:
	if(raddrop > 0){
		call(scr.sound_play_at, x, y, sndRadPickup, 0.5 + orandom(0.1), 6);
		with(instance_nearest(x, y, EatRad)){
			x = other.x;
			y = other.y;
			depth = -3;
		}
		
		 // Boy:
		with(call(scr.pet_create, x, y, "Slaughter")){
			right = other.image_xscale;
		}
		
		instance_delete(self);
	}
	
#define OasisPetBecome_death
	repeat(3){
		call(scr.fx, x, y, 3, Dust);
	}
	
	 // Bro come back:
	with(call(scr.obj_create, x, y, "OasisPetBecomeCorpse")){
		inst = id + 1;
	}
	
	
#define OasisPetBecomeCorpse_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		inst = noone;
		time = 300;
		
		return self;
	}
	
#define OasisPetBecomeCorpse_step
	if(instance_exists(inst)){
		if(time > 0){
			time -= current_time_scale;
			
			 // Effects:
			if(chance_ct(1, 1 + (time / 5))){
				with(inst) call(scr.fx, [x, 4], [y, 4], 0, Dust);
			}
		}
		
		 // Respawn:
		else with(inst){
			with(call(scr.obj_create, x, y, "OasisPetBecome")){
				image_xscale = other.image_xscale;
				sprite_index = spr_hurt;
				
				 // Effects:
				sound_play_hit(sndOasisMelee, 0.4);
				with(call(scr.obj_create, x, y, "WaterStreak")){
					motion_set(random(360), 2);
					image_angle = direction + 180;
					call(scr.fx, x, y, [direction, 2], Smoke);
				}
			}
			instance_destroy();
		}
	}
	else instance_destroy();
	
	
#define Puffer_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.PufferIdle;
		spr_walk     = spr.PufferIdle;
		spr_hurt     = spr.PufferHurt;
		spr_dead     = spr.PufferDead;
		spr_chrg     = spr.PufferChrg;
		spr_fire     = spr.PufferFire[0, 0];
		spr_shadow   = shd16;
		spr_shadow_y = 7;
		hitid        = [spr_idle, "PUFFER"];
		depth        = -2;
		
		 // Sound:
		snd_hurt = sndOasisHurt;
		snd_dead = sndOasisDeath;
		snd_mele = sndOasisMelee;
		
		 // Vars:
		mask_index  = mskFreak;
		maxhealth   = 10;
		raddrop     = 4;
		size        = 1;
		walk        = 0;
		walkspeed   = 0.8;
		maxspeed    = 3;
		meleedamage = 2;
		direction   = random(360);
		blow        = 0;
		
		 // Alarms:
		alarm1 = 40 + random(80);
		
		return self;
	}
	
#define Puffer_step
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
	if(sprite_index != spr_fire){
		if(sprite_index != spr_chrg){
			sprite_index = enemy_sprite;
		}
		
		 // Charged:
		else if(anim_end){
			blow = 1;
		}
	}
	
	 // Puffering:
	if(blow > 0){
		blow -= 0.03 * current_time_scale;
		
		 // Blowing:
		motion_add_ct(direction + (10 * sin(current_frame / 6)), 2);
		enemy_look(direction + 180);
		
		 // Effects:
		if(chance_ct(3, 4)){
			var	l = 8,
				d = direction + 180;
				
			with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Bubble)){
				motion_add(d, 3);
			}
			sound_play_pitchvol(sndRoll, 1.2 + random(0.4), 0.6);
		}
		
		 // Animate:
		var	_sprFire = spr.PufferFire,
			_blowLvl = clamp(floor(blow * array_length(_sprFire)), 0, array_length(_sprFire) - 1),
			_back = (direction > 180);
			
		spr_fire = _sprFire[_blowLvl, _back];
		sprite_index = spr_fire;
	}
	else if(sprite_index == spr_fire){
		sprite_index = spr_idle;
	}
	
#define Puffer_draw
	var _hurt = (sprite_index != spr_hurt && nexthurt >= current_frame + 4);
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	draw_self_enemy();
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
#define Puffer_alrm1
	alarm1 = 20 + random(30);
	
	if(blow <= 0){
		if(enemy_target(x, y)){
			var _targetDir = target_direction;
			
			 // Puff Time:
			if(
				chance(1, 2)
				&& target_distance < 256
				&& target_visible
			){
				alarm1 = 30;
				
				enemy_walk(_targetDir, 8);
				enemy_look(direction + 180);
				sprite_index = spr_chrg;
				image_index  = 0;
				
				 // Effects:
				repeat(3) instance_create(x, y, Dust);
				sound_play_pitch(sndOasisCrabAttack, 0.8);
				sound_play_pitchvol(sndBouncerBounce, 0.6 + orandom(0.2), 2);
			}
			
			 // Get Closer:
			else enemy_walk(_targetDir + orandom(20), alarm1);
		}
		
		 // Passive Movement:
		else enemy_walk(random(360), 10);
	}
	
#define Puffer_hurt(_damage, _force, _direction)
	my_health -= _damage;
	nexthurt = current_frame + 6;
	motion_add(_direction, _force);
	sound_play_hit(snd_hurt, 0.3);
	
	 // Hurt Sprite:
	if(sprite_index != spr_fire && sprite_index != spr_chrg){
		sprite_index = spr_hurt;
		image_index  = 0;
	}
	
#define Puffer_death
	pickup_drop(30, 0);
	
	 // Powerful Death:
	var _num = 3;
	if(blow > 0){
		_num *= ceil(blow * 4);
	}
	if(sprite_index == spr_chrg){
		_num += image_index;
	}
	if(_num > 3){
		sound_play_pitch(sndOasisExplosionSmall, 1 + random(0.2));
		sound_play_pitchvol(sndOasisExplosion, 0.8 + random(0.4), _num / 15);
	}
	while(_num-- > 0){
		with(instance_create(x, y, Bubble)){
			motion_add(random(360), _num / 2);
			hspeed += other.hspeed / 3;
			vspeed += other.vspeed / 3;
			friction *= 2;
		}
	}
	
	
#define SunkenChest_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.SunkenChest;
		spr_dead     = spr.SunkenChestOpen;
		spr_shadow_y = 0;
		
		 // Sounds:
		snd_open = sndGoldChest;
		
		 // Vars:
		num   = 2;
		wep   = wep_none;
		skeal = false;
		if(GameCont.area == "coast"){
			wep = { wep: "trident", gold: true };
		}
		
		 // Events:
		on_step = script_ref_create(SunkenChest_step);
		on_open = script_ref_create(SunkenChest_open);
		
		return self;
	}
	
#define SunkenChest_step
	 // Shiny:
	if(chance_ct(1, 90)){
		with(instance_create(x + orandom(16), y + orandom(8), CaveSparkle)){
			depth = other.depth - 1;
		}
	}
	
	 // Ancient Treasure Guards:
	var _num = 3 * skeal;
	if(_num > 0){
		var _spawn = false;
		with(Player){
			if(point_distance(x, y, other.x, other.y) < 192){
				if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
					_spawn = true;
					break;
				}
			}
		}
		if(_spawn){
			skeal = 0;
			
			 // Skeals:
			var _ang = random(360);
			for(var _d = _ang; _d < _ang + 360; _d += 360 / _num){
				var	_dis = 32,
					_dir = _d + orandom(30);
					
				call(scr.obj_create, x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "SunkenSealSpawn");
			}
			
			 // Clear Area:
			with(instance_create(x, y, PortalClear)){
				image_xscale = 1.2;
				image_yscale = image_xscale;
			}
			
			 // Alert:
			with(call(scr.alert_create, self, spr.SkealAlert)){
				flash = 10;
			}
			
			 // Sound:
			sound_play_pitchvol(sndMutant14Turn, 0.2 + random(0.1), 1);
		}
	}
	
#define SunkenChest_open
	instance_create(x, y, PortalClear);
	
	 // Sunken Chest Count:
	with(GameCont){
		if("sunkenchests" not in self){
			sunkenchests = 0;
		}
		sunkenchests = max(sunkenchests, GameCont.loops + 1);
	}
	
	 // Important:
	if(instance_is(other, Player)){
		sound_play(other.snd_chst);
	}
	
	 // Trident Unlock:
	var _wepRaw = call(scr.wep_raw, wep);
	if(_wepRaw == "trident" && !call(scr.weapon_get, "avail", wep)){
		call(scr.unlock_set, `wep:${_wepRaw}`, true);
	}
	
	 // Weapon:
	var _num = 1 + ultra_get("steroids", 1);
	if(_num > 0){
		var _wep = wep;
		
		 // Golden Merged Weapon:
		if(_wep == wep_none){
			_wep = call(scr.temerge_decide_weapon, 0, max(1, GameCont.hard - 1), true);
		}
		
		 // Create:
		repeat(_num){
			with(instance_create(x, y, WepPickup)){
				wep  = _wep;
				ammo = true;
			}
		}
	}
	
	 // Real Loot:
	if(num > 0){
		repeat(num * 10){
			with(call(scr.obj_create, x, y, "SunkenCoin")){
				motion_add(random(360), 2 + random(2.5));
			}
		}
		
		 // Ammo:
		var _ang = random(360);
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / num)){
			with(call(scr.obj_create, x, y, "BackpackPickup")){
				target    = instance_create(x, y, AmmoPickup);
				direction = _dir;
				speed     = random_range(2, 3);
				with(self){
					event_perform(ev_step, ev_step_end);
				}
			}
		}
	}
	
	
#define SunkenCoin_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = (chance(1, 3) ? spr.SunkenCoinBig : spr.SunkenCoin);
		image_angle  = random(360);
		spr_open     = sprCaveSparkle;
		spr_fade     = sprCaveSparkle;
		shine        = 0.075;
		
		 // Sound:
		snd_open = sndRadPickup;
		snd_fade = -1;
		
		 // Vars:
		mask_index = mskRad;
		alarm0     = call(scr.pickup_alarm, 200 + random(30), 1/4);
		pull_dis   = 18 + (12 * skill_get(mut_plutonium_hunger));
		
		 // Events:
		on_pull = script_ref_create(SunkenCoin_pull);
		on_open = script_ref_create(SunkenCoin_open);
		
		return self;
	}
	
#define SunkenCoin_pull
	return (speed <= 0);
	
#define SunkenCoin_open
	 // Can't Grab While Moving:
	if(speed > 0){
		return true;
	}
	
	
#define SunkenRoom_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		mask_index   = mskFloor;
		image_xscale = 1;
		image_yscale = 1;
		floors       = [];
		size         = 1;
		
		return self;
	}
	
#define SunkenRoom_step
	if(instance_exists(Floor)){
		if(
			place_meeting(x, y, Player) ||
			place_meeting(x, y, Portal) ||
			place_meeting(x, y, enemy)
		){
			var _tunnel = false;
			
			 // Player/Enemy Check:
			with(instances_matching_ne(floors, "id")){
				if(
					place_meeting(x, y, Player) ||
					place_meeting(x, y, Portal) ||
					place_meeting(x, y, enemy)
				){
					_tunnel = true;
					break;
				}
			}
			
			 // Tunnel to Main Level:
			if(_tunnel){
				var	_x           = bbox_center_x,
					_y           = bbox_center_y,
					_spawnX      = 10016,
					_spawnY      = 10016,
					_tunnelSize  = size,
					_tunnelFloor = [];
					
				 // Get Position of Oldest Floor & Sort Floors by Closest First:
				with(FloorNormal){
					_spawnX = bbox_center_x;
					_spawnY = bbox_center_y;
					if(array_find_index(other.floors, self) < 0){
						array_push(_tunnelFloor, [self, point_distance(bbox_center_x, bbox_center_y, _x, _y)]);
					}
				}
				array_sort_sub(_tunnelFloor, 1, true);
				
				 // Tunnel to the Nearest Main-Level Floor:
				with(_tunnelFloor){
					var _break = false;
					with(self[0]){
						for(var	_fx = bbox_left; _fx < bbox_right + 1; _fx += 16){
							for(var	_fy = bbox_top; _fy < bbox_bottom + 1; _fy += 16){
								if(call(scr.path_reaches, call(scr.path_create, _fx + 8, _fy + 8, _spawnX, _spawnY, Wall), _spawnX, _spawnY, Wall)){
									if(!call(scr.path_reaches, call(scr.path_create, bbox_center_x, bbox_center_y, _x, _y, Wall), _x, _y, Wall)){
										with(call(scr.floor_tunnel, bbox_center_x, bbox_center_y, _x, _y)){
											image_yscale *= _tunnelSize;
										}
									}
									_break = true;
									break;
								}
							}
							if(_break) break;
						}
					}
					if(_break) break;
				}
				
				instance_destroy();
			}
		}
	}
	
	
#define SunkenSealSpawn_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		//var _inCoast = (GameCont.area == "coast" || (GameCont.area == area_vault && GameCont.lastarea == "coast"));
		
		 // Vars:
		mask_index = mskBandit;
		type       = irandom_range(1, 3);
		skeal      = true; //!_inCoast;
		
		 // Alarms:
		alarm0 = 30 + (10 * array_length(instances_matching_ne(obj.SunkenSealSpawn, "id")));
		
		 // FX:
		repeat(3){
			instance_create(x, y, Smoke);
		}
		
		return self;
	}
	
#define SunkenSealSpawn_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // No Portal:
	call(scr.portal_poof);
	
	 // Make Room:
	if(place_meeting(x, y, Wall)){
		with(call(scr.instances_meeting_instance, self, Wall)){
			if(place_meeting(x, y, other)){
				instance_create(x, y, FloorExplo);
				instance_destroy();
			}
		}
	}
	
#define SunkenSealSpawn_alrm0
	with(call(scr.obj_create, x, y, "Seal")){
		skeal = other.skeal;
		type = other.type;
		
		 // Effects:
		instance_create(x, y, AssassinNotice);
		if(skeal){
			call(scr.sound_play_at, x, y, sndBloodGamble, 1.6 + random(0.2), 1.8);
		}
		sound_play_hit(sndChickenRegenHead, 0.1);
		sound_play_pitchvol(sndSharpTeeth, 0.6 + random(0.4), 0.4);
	}
	
	instance_destroy();
	
	
#define WaterStreak_create(_x, _y)
	with(instance_create(_x, _y, AcidStreak)){
		 // Visual:
		sprite_index = spr.WaterStreak;
		image_speed  = 0.4 + random(0.2);
		depth        = 0;
		
		 // Vars:
		vspeed     -= 2;
		image_angle = direction;
		
		return self;
	}
	
	
#define YetiCrab_create(_x, _y)
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle     = spr.YetiCrabIdle;
		spr_walk     = spr.YetiCrabIdle;
		spr_hurt     = spr.YetiCrabIdle;
		spr_dead     = spr.YetiCrabIdle;
		spr_weap     = mskNone;
		spr_shadow   = shd24;
		spr_shadow_y = 6;
		hitid        = [spr_idle, "YETI CRAB"];
		mask_index   = mskFreak;
		depth        = -2;
		
		 // Sound:
		snd_hurt = sndScorpionHit;
		snd_dead = sndScorpionDie;
		snd_mele = sndScorpionMelee;
		
		 // Vars:
		maxhealth   = 12;
		raddrop     = 3;
		size        = 1;
		walk        = 0;
		walkspeed   = 1;
		maxspeed    = 4;
		meleedamage = 2;
		is_king     = 0; // Decides leader
		direction   = random(360);
		
		 // Alarms:
		alarm1 = 20 + irandom(10);
		
		return self;
	}
	
#define YetiCrab_step
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
	
#define YetiCrab_alrm1
	alarm1 = 30 + random(10);
	enemy_target(x, y);
	
	if(is_king = 0) { // Is a follower:
		if(instance_exists(call(scr.instance_nearest_array, x, y, instances_matching(CustomEnemy, "is_king", 1)))) { // Track king:
			var nearest_king = call(scr.instance_nearest_array, x, y, instances_matching(CustomEnemy, "is_king", 1));
			var king_dir = point_direction(x, y, nearest_king.x, nearest_king.y);
			if(point_distance(x, y, nearest_king.x, nearest_king.y) > 16 and target_distance < point_distance(x, y, nearest_king.x, nearest_king.y)) { // Check distance from king:
				 // Follow king in a jittery manner:
				enemy_walk(king_dir + orandom(5), 5);
				alarm1 = 5 + random(5);
			}
			
			 // Chase player instead:
			else if(instance_exists(target) && target_visible) {
				enemy_walk(target_direction + orandom(10), 30);
			} else {
				 // Crab rave:
				enemy_walk(random(360), 30);
			}
		}
		 // No leader to follow:
		else if(instance_exists(target) && target_visible) {
			 // Sad chase :( :
			if(fork()) {
				repeat(irandom_range(4, 10)) {
					wait random_range(1, 3);
					if(!instance_exists(other)) exit; else instance_create(x, y, Sweat); // Its tears shhh
				}
				
				exit;
			}
			enemy_walk(target_direction + orandom(10), 30);
		} else {
			 // Crab rave:
			enemy_walk(random(360), 30);
		}
	}
	
	 // Is a leader:
	else {
		 // Chase player:
		enemy_walk(target_direction + orandom(10), 30);
	}
	
	enemy_look(direction);
	
	
/// GENERAL
#define ntte_setup_hitme(_inst)
	 // Air Bubble Setup:
	with(_inst){
		if("spr_bubble" not in self){
			spr_bubble     = -1;
			spr_bubble_pop = -1;
			spr_bubble_x   = 0;
			spr_bubble_y   = 0;
			
			 // Auto-Setup:
			if(
				team != 0
				&& !instance_is(self, prop)
				&& !instance_is(self, Freak)
				&& snd_dead != sndOasisDeath
				&& snd_hurt != sndOasisHurt
				&& snd_hurt != sndOasisBossHurt
				&& snd_hurt != sndMutant1Hurt
				&& snd_hurt != sndMutant14Hurt
				&& snd_hurt != sndSpiderHurt
				&& snd_hurt != sndLaserCrystalHit
				&& snd_hurt != sndLightningCrystalHit
				&& snd_hurt != sndHyperCrystalHurt
				&& snd_hurt != sndTechnomancerHurt
				&& snd_hurt != sndNothingHurtHigh
				&& snd_hurt != sndNothingHurtMid
				&& snd_hurt != sndNothingHurtLow
				&& snd_hurt != sndNothing2Hurt
				&& snd_hurt != sndVanHurt
			){
				var	_left   = sprite_get_bbox_left(spr_hurt),
					_top    = sprite_get_bbox_top(spr_hurt),
					_right  = sprite_get_bbox_right(spr_hurt)  + 1,
					_bottom = sprite_get_bbox_bottom(spr_hurt) + 1;
					
				 // Big:
				if(_right - _left < 28 && _bottom - _top < 28){
					spr_bubble     = sprPlayerBubble;
					spr_bubble_pop = sprPlayerBubblePop;
				}
				
				 // Normal:
				else{
					spr_bubble     = spr.BigBubble;
					spr_bubble_pop = spr.BigBubblePop;
				}
				
				 // Vertical Offset:
				spr_bubble_y = floor(((_bottom + _top) / 2) - sprite_get_yoffset(spr_hurt));
			}
		}
		
		 // Death Pop Setup:
		if(spr_bubble != -1){
			if("ntte_bubble_pop" not in GameCont){
				GameCont.ntte_bubble_pop = [];
			}
			array_push(
				GameCont.ntte_bubble_pop,
				[self, x + spr_bubble_x, y + spr_bubble_y, spr_bubble_pop, true]
			);
		}
	}
	
#define ntte_setup_underwater_sprite(_sprNormal, _sprWater, _inst)
	 // Clam Chests:
	with(instances_matching(_inst, "sprite_index", _sprNormal)){
		sprite_index = _sprWater;
	}
	
#define ntte_setup_underwater_sound(_inst)
	 // Watery Enemy Sounds:
	with(instances_matching_ne(_inst, "object_index", CustomEnemy)){
		if(snd_hurt != -1) snd_hurt = sndOasisHurt;
		if(snd_dead != -1) snd_dead = sndOasisDeath;
		if(snd_mele != -1) snd_mele = sndOasisMelee;
	}
	
#define ntte_setup_underwater_bubble(_num, _destroy, _inst)
	 // Bubbles:
	with(instances_matching_ne(_inst, "image_xscale", 0)){
		if(_num >= 1 || chance(_num, 1)){
			repeat(max(1, _num)){
				instance_create(x, y, Bubble);
			}
		}
		
		 // Replace:
		if(_destroy){
			instance_destroy();
		}
		
		 // Go Away Ugly Flame Smoke:
		else switch(object_index){
			case Smoke:
				if(distance_to_object(Flame) < 8 || distance_to_object(TrapFire) < 8){
					sprite_index = sprBubble;
				}
				break;
		}
	}
	
#define ntte_setup_underwater_flame(_inst)
	 // Extinguish Flames:
	with(_inst){
	    instance_create(x, y, Smoke);
	    instance_destroy();
	}
	
#define ntte_begin_step
	 // Underwater Code:
	if(underwater_active){
		 // Lightning:
		if(instance_exists(Lightning)){
			var _inst = instances_matching_gt(Lightning, "image_alpha", 0);
			if(array_length(_inst)){
				with(_inst){
					image_index -= image_speed_raw * 0.75;
					
					 // Zap:
					if(anim_end){
						with(instance_create(x, y, EnemyLightning)){
							image_speed  = 0.3;
							image_xscale = other.image_xscale;
							image_angle  = other.image_angle;
							hitid        = 88;
							
							 // FX:
							if(chance(1, 8)){
								sound_play_hit(sndLightningHit,0.2);
								with(instance_create(x, y, GunWarrantEmpty)){
									image_angle = other.direction;
								}
							}
							else if(chance(1, 3)){
								instance_create(x + orandom(18), y + orandom(18), PortalL);
							}
						}
						instance_destroy();
					}
				}
			}
		}
		
		 // Flames Boil Water:
		if(instance_exists(Flame) || instance_exists(TrapFire)){
			with(instances_matching_ne([Flame, TrapFire], "id")){
				if(sprite_index != sprFishBoost){
					if(image_index > 2){
						sprite_index = sprFishBoost;
						image_index  = 0;
						
						 // FX:
						if(chance(1, 3)){
							var	_x   = x,
								_y   = y,
								_vol = 0.4;
								
							if(fork()){
								repeat(1 + irandom(3)){
									instance_create(_x, _y, Bubble);
									
									view_shake_max_at(_x, _y, 3);
									sleep(6);
									
									sound_play_pitchvol(sndOasisPortal, 1.4 + random(0.4), _vol);
									audio_sound_set_track_position(sndOasisPortal, 0.52 + random(0.04));
									_vol -= 0.1;
									
									wait(10 + irandom(20));
								}
								exit;
							}
						}
					}
				}
				
				 // Hot hot hot:
				else if(chance_ct(1, 100)){
					instance_create(x, y, Bubble);
				}
			}
		}
		
		 // Replace Lame MineExplosion:
		if(instance_exists(MineExplosion)){
			var _inst = instances_matching_gt(instances_matching_le(MineExplosion, "alarm0", ceil(current_time_scale)), "alarm0", 0);
			if(array_length(_inst)) with(_inst){
				with(call(scr.obj_create, x, y - 12, "SealMine")){
					my_health = 0;
				}
				instance_destroy();
			}
		}
		
		 // Bind Underwater Object Setup Scripts:
		if(lq_get(ntte, "bind_setup_underwater_list") == undefined){
			ntte.bind_setup_underwater_list = [
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_underwater_flame), [GroundFlame, BlueFlame]),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_underwater_bubble, 1,   true),  Dust),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_underwater_bubble, 1,   false), [Smoke, BulletHit, EBulletHit, ScorpionBulletHit]),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_underwater_bubble, 1/4, false), BoltTrail),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_underwater_bubble, 3,   false), ChestOpen),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_underwater_sprite, sprWeaponChest,     sprClamChest),     WeaponChest),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_underwater_sprite, sprWeaponChestOpen, sprClamChestOpen), ChestOpen),
				call(scr.ntte_bind_setup, script_ref_create(ntte_setup_underwater_sound), enemy)
			];
			with(instances_matching(WeaponChest, "sprite_index", sprWeaponChest)){
				sprite_index = sprClamChest;
			}
		}
	}
	
	 // Unbind Underwater Object Setup Scripts:
	else if(lq_get(ntte, "bind_setup_underwater_list") != undefined){
		with(ntte.bind_setup_underwater_list){
			call(scr.ntte_unbind, self);
		}
		ntte.bind_setup_underwater_list = undefined;
	}
	
#define ntte_step
	 // Underwater Sounds:
	if(global.underwater_sound_active || array_find_index(ntte.mods.area, underwater_area) >= 0){
		underwater_sound(call(scr.area_get_underwater, underwater_area));
	}
	
#define ntte_end_step
	 // Underwater Code:
	var _active = underwater_active;
	if(_active){
		 // Air Bubble Pop:
		if("ntte_bubble_pop" in GameCont && array_length(GameCont.ntte_bubble_pop)){
			with(GameCont.ntte_bubble_pop){
				var _inst = self[0];
				
				 // Follow Papa:
				if(instance_exists(_inst) && _inst.visible){
					self[@1] = _inst.x + _inst.spr_bubble_x;
					self[@2] = _inst.y + _inst.spr_bubble_y;
					self[@3] = _inst.spr_bubble_pop;
					self[@4] = true;
				}
				
				 // Pop:
				else{
					if(self[4]){
						self[@4] = false;
						with(instance_create(self[1], self[2], BubblePop)){
							sprite_index = other[3];
						}
					}
					if(!instance_exists(_inst)){
						GameCont.ntte_bubble_pop = call(scr.array_delete_value, GameCont.ntte_bubble_pop, self);
					}
				}
			}
		}
	}
	with(global.underwater_bind_draw.id){
		visible = _active;
	}
	
#define ntte_draw_shadows
	 // Big Bubble Bombs:
	if(array_length(obj.BubbleBomb)){
		var _inst = instances_matching(instances_matching_gt(obj.BubbleBomb, "big", 0), "visible", true);
		if(array_length(_inst)){
			with(_inst){
				var	_f = min((z / 6) - 4, 6),
					_w = max(6 + _f, 0) + sin((x + y + z) / 8),
					_h = max(4 + _f, 0) + cos((x + y + z) / 8),
					_x = x,
					_y = y + 6;
					
				draw_ellipse(_x - _w, _y - _h, _x + _w, _y + _h, false);
			}
		}
	}
	
#define underwater_draw
	if(lag) trace_time();
	
	 // Air Bubbles:
	if(instance_exists(hitme)){
		var _inst = instances_matching(call(scr.instances_seen_nonsync, instances_matching_ne(hitme, "spr_bubble", -1, null), 16, 16), "visible", true);
		if(array_length(_inst)){
			with(_inst){
				draw_sprite(spr_bubble, -1, x + spr_bubble_x, y + spr_bubble_y);
			}
		}
	}
	
	 // Boiling Water:
	if(instance_exists(Flame)){
		var _inst = instances_matching_ne(Flame, "sprite_index", sprFishBoost);
		if(array_length(_inst)){
			draw_set_fog(true, make_color_rgb(255, 70, 45), 0, 0);
			draw_set_blend_mode(bm_add);
			with(_inst){
				var	_scale = 1.5,
					_alpha = 0.2;
					
				draw_sprite_ext(sprDragonFire, image_index + 2, x, y, image_xscale * _scale, image_yscale * _scale, image_angle, image_blend, image_alpha * _alpha);
			}
			draw_set_blend_mode(bm_normal);
			draw_set_fog(false, 0, 0, 0);
		}
	}
	
	if(lag) trace_time(script[2]);
	
#define underwater_sound(_active)
	if(global.underwater_sound_active ^^ _active){
		for(var i = 0; i < lq_size(global.underwater_sound); i++){
			var _sndOasis = asset_get_index(lq_get_key(global.underwater_sound, i));
			with(lq_get_value(global.underwater_sound, i)){
				var _snd = self;
				if(_active) sound_assign(_snd, _sndOasis);
				else sound_restore(_snd);
			}
		}
	}
	global.underwater_sound_active = _active;
	
	
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