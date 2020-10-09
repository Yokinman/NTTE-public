#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Top Object Searching:
	TopObjectSearchMap = ds_map_create();
	with(TopObjectSearch){
		ds_map_set(TopObjectSearchMap, self, max(variable_instance_get(GameObject, "id", 0), other));
	}
	
	 // Floor Related:
	global.floor_num    = 0;
	global.floor_min    = 0;
	global.floor_left   = 0;
	global.floor_right  = 0;
	global.floor_top    = 0;
	global.floor_bottom = 0;
	
	 // Pet History (MutantVats Event):
	global.pet_history = ds_list_create();
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro TopObjectSearch    [hitme, projectile, becomenemy, Pickup, chestprop, Corpse, Effect, Explosion, MeatExplosion, PlasmaImpact, BigDogExplo, NothingDeath, Nothing2Death, FrogQueenDie, PopoShield, CrystalShield, SharpTeeth, ReviveArea, NecroReviveArea, RevivePopoFreak]
#macro TopObjectSearchMap global.top_object_search_map

#define AlertIndicator_create(_x, _y)
	/*
		A cool alert effect used to quickly draw the Player's attention
		Generally you should use 'alert_create()' to create alert indicators
		
		Vars:
			sprite_index      - The main icon sprite
			alert             - A LWO containing alert/exclamation variables
			                    Uses: spr, img, x (offset), y (offset), xsc, ysc, ang, col, alp
			target            - The instance to follow, use 'noone' to stay still
			target_x/target_y - The x/y offset used when following its target
			canview           - True/false, can it be seen while in the view
			alarm0            - How long before blinking out, set -1 to never blink out
			blink             - How many times it should blink before destroying itself
			flash             - How many frames its flash-in effect should take
			snd_flash         - The sound that plays once its 'flash' timer hits 0
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.BanditAlert;
		image_speed  = 0.4;
		image_alpha  = -1; // CustomObject
		alert        = {
			"spr" : spr.AlertIndicator,
			"col" : make_color_rgb(252, 56, 0),
			"x"   : -6,
			"y"   : 0
		};
		
		 // Sound:
		snd_flash = sndSlider;
		
		 // Vars:
		target   = noone;
		target_x = 0;
		target_y = -16;
		canview  = true;
		blink    = 30;
		flash    = 3;
		
		 // Alarms:
		alarm0 = 90;
		
		return id;
	}
	
#define AlertIndicator_begin_step
	if(flash > 0){
		flash -= current_time_scale;
		
		 // Sound:
		if(flash <= 0){
			sound_play(snd_flash);
			sound_play_pitch(sndCrownAppear, 0.9 + random(0.2));
			if(friction <= 0) friction = 0.5;
		}
	}
	
#define AlertIndicator_step
	 // Alarms:
	if(alarm0_run) exit;
	
#define AlertIndicator_end_step
	 // Follow the Leader:
	if(instance_exists(target)){
		x = target.x + target_x;
		y = target.y + target_y;
		target_x += hspeed_raw;
		target_y += vspeed_raw;
	}
	
	 // Stay Hidden:
	image_alpha = -abs(image_alpha);
	
#define AlertIndicator_alrm0
	alarm0 = 2;
	
	 // Blink Out:
	visible = !visible;
	if(blink-- <= 0) instance_destroy();


#define BigDecal_create(_x, _y)
	/*
		A giant version of the TopDecal/TopPot object
		If the area doesn't have a spr.BigTopDecal sprite variant then nothing is created
	*/
	
	var _area = GameCont.area;
	
	if(ds_map_exists(spr.BigTopDecal, _area)){
		with(instance_create(_x, _y, CustomObject)){
			 // Visual: 
			visible      = false;
			sprite_index = spr.BigTopDecal[? _area];
			image_xscale = choose(-1, 1);
			image_speed  = 0.4;
			depth        = object_get_depth(SubTopCont) - 1;
			
			 // Vars:
			mask_index = msk.BigTopDecal[? (ds_map_exists(msk.BigTopDecal, _area) ? _area : area_desert)];
			target     = noone;
			area       = _area;
			
			 // Scorpion:
			if(area == area_desert && instance_exists(mod_script_call("mod", "teevents", "teevent_get_active", "ScorpionCity"))){
				sprite_index = spr.BigTopDecalScorpion;
			}
			
			 // Relocate:
			var	_xoff  = (sprite_get_xoffset(mask_index) - ((sprite_get_bbox_left(mask_index) + sprite_get_bbox_right(mask_index) + 1) / 2)) * image_xscale,
				_yoff  = (sprite_get_yoffset(mask_index) - ((sprite_get_bbox_top(mask_index) + sprite_get_bbox_bottom(mask_index) + 1) / 2)) * image_yscale,
				_dis   = 24,
				_dir   = random(360),
				_tries = 1000;
				
			with(instance_nearest_bbox(x, y, Floor)){
				_dir = point_direction(bbox_center_x, bbox_center_y, other.x, other.y);
			}
			
			x = pround(_x, 16) + _xoff;
			y = pround(_y, 16) + _yoff;
			
			while(
				_tries-- > 0
				&& (
					place_meeting(x, y, Floor)       ||
					place_meeting(x, y, Bones)       ||
					place_meeting(x, y, TopPot)      ||
					place_meeting(x, y, PortalClear) ||
					place_meeting(x, y, CustomObject)
				)
			){
				x = pround(x - _xoff + lengthdir_x(_dis, _dir), 16) + _xoff;
				y = pround(y - _yoff + lengthdir_y(_dis, _dir), 16) + _yoff;
			}
			
			 // TopSmalls:
			for(var _ox = -64; _ox < 64; _ox += 32){
				for(var _oy = -48; _oy < 64; _oy += 32){
					with(instances_matching_gt(TopSmall, "id", instance_create(pround(x + _ox, 16), pround(y + _oy, 16), Top))){
						if(chance(1, 2) && !point_in_rectangle(bbox_center_x, bbox_center_y, other.bbox_left - 16, other.bbox_top - 16, other.bbox_right + 1 + 16, other.bbox_bottom + 1 + 64)){
							instance_destroy();
						}
					}
				}
			}
			
			 // TopDecals:
			var	_num = irandom(4),
				_ang = random(360);
				
			for(var i = _ang; i < _ang + 360; i += (360 / _num)){
				var	_dis = 24 + random(12),
					_dir = i + orandom(30);
					
				with(obj_create(x, y, "TopDecal")){
					 // Placement:
					x = xstart + lengthdir_x(_dis * 1.5, _dir);
					y = ystart + lengthdir_y(_dis,       _dir);
					while(place_meeting(x, y, other)){
						x += lengthdir_x(8, _dir);
						y += lengthdir_y(8, _dir);
					}
					
					 // Remove Danger:
					if(sprite_index == sprTopDecalScrapyard){
						image_index = choose(1, 2);
					}
					
					 // Nevermind:
					if(place_meeting(x, y, Floor)){
						instance_delete(id);
					}
				}
			}
			
			 // Specifics:
			switch(area){
				
				case area_scrapyards: // Ravens
					
					var	_ang = random(360),
						_dis = 8;
						
					for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 3)){
						top_create(
							x + lengthdir_x(_dis * random_range(1, 2.5), _dir),
							y + lengthdir_y(_dis,                        _dir) - 12,
							"TopRaven",
							0,
							0
						);
					}
					
					break;
					
				case area_caves:
				case area_cursed_caves: // Face drill
					
					with(instance_nearest_bbox(x, y, instances_matching_ge(instances_matching_le(Floor, "bbox_top", y + 32), "bbox_bottom", y - 16))){
						var _fx = bbox_center_x;
						if(_fx != other.x){
							other.image_xscale = -sign(_fx - other.x);
						}
					}
					
					break;
					
			}
			
			 // Decal Setup:
			BigDecal_step();
			
			return id;
		}
	}
	
	return noone;
	
#define BigDecal_step
	if(!instance_exists(target)){
		 // Decal Setup:
		if(!place_meeting(x, y, Floor)){
			target = instance_create(x, y, Bones);
			with(target){
				name         = "BigDecal";
				mask_index   = other.mask_index;
				sprite_index = other.sprite_index;
				image_index  = other.image_index;
				image_speed  = other.image_speed;
				image_xscale = other.image_xscale;
				image_yscale = other.image_yscale;
				image_angle  = other.image_angle;
				image_blend  = other.image_blend;
				image_alpha  = other.image_alpha;
				//depth        = other.depth;
				
				 // Lay Flat:
				/*if(depth == object_get_depth(SubTopCont)){
					if(fork()){
						wait 0;
						with(SubTopCont){
							with(instance_create(0, 0, TopCont)){
								darkness = true;
								event_perform(ev_other, ev_room_end);
								instance_destroy();
							}
							instance_destroy();
						}
						exit;
					}
				}*/
				
				 // Override Top Decals:
				with(instances_meeting(x, y, [TopPot, Bones])){
					if(place_meeting(x, y, other)){
						instance_delete(id);
					}
				}
			}
		}
		
		 // Death:
		if(!instance_exists(target)){
			instance_destroy();
		}
	}
	
	 // Step:
	else{
		x = target.x;
		y = target.y;
		
		 // Area-Specifics:
		switch(area){
			
			case "trench": // Vent Bubbles
				
				with([
					[  2, -46],
					[ 15, -24],
					[  1, -32],
					[-19, -15],
					[-12,  -7],
					[ 11,  -4],
					[ 24, -14]
				]){
					if(chance_ct(1, 8)){
						var	_ox = self[0],
							_oy = self[1];
							
						with(other.target){
							with(instance_create(x + (_ox * image_xscale), y + (_oy * image_yscale), Bubble)){
								motion_set(90 + orandom(5), random_range(4, 7));
								friction = 0.2;
							}
						}
					}
				}
				
				break;
				
		}
	}
	
#define BigDecal_destroy
	with(target){
		other.x = x;
		other.y = y;
		instance_destroy();
	}
	
	if(place_meeting(x, y, Floor)){
		y -= 8;
		
		 // Break Walls:
		wall_clear(x, y);
		
		 // General FX:
		sleep(100);
		view_shake_at(x, y, 50);
		repeat(irandom_range(9, 18)){
			with(instance_create(x, y, Debris)){
				speed = random_range(6, 12);
				if(!place_meeting(x + hspeed_raw, y + vspeed_raw, Floor)){
					speed /= 3;
				}
			}
		}
		
		 // Area-Specifics:
		switch(area){
			
			case area_desert: /// Bones and Scorps
				 
				 // Scorpion Mode:
				if(sprite_index == spr.BigTopDecalScorpion){
					 // Clear Walls:
					with(instance_create(x, y, PortalClear)){
						image_xscale *= 1.5;
						image_yscale *= 1.5;
						with(instances_meeting(x, y, Wall)){
							if(place_meeting(x, y, other)){
								with(other){
									event_perform(ev_collision, Wall);
								}
							}
						}
					}
					
					 // Baboom:
					repeat(75){
						var	_dir = random(360),
							_spd = random_range(2, 6);
							
						repeat(2){
							with(projectile_create(x, y, EnemyBullet2, _dir, max(0.1, _spd--))){
								team     = -1;
								hitid    = [other.sprite_index, "GRAND SCORPION"];
								friction = -0.2;
							}
						}
					}
					with(projectile_create(x, y, "VenomFlak", 0, 0)){
						charging = false;
						alarm0   = 1;
					}
					with(projectile_create(x, y, GreenExplosion, 0, 0)){
						alarm0 = -1;
						
						 // Small Explosions:
						var _ang = random(360);
						for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 3)){
							var _dis = random_range(12, 24);
							with(projectile_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), "SmallGreenExplosion", 0, 0)){
								hitid = other.hitid;
								instance_create(x, y, ScorchGreen);
							}
						}
					}
					
					 // Pickups:
					/*var _part = mod_script_call("weapon", "merge", "weapon_merge_decide_raw", 0, 1 + GameCont.hard, -1, wep_frog_pistol, false);
					if(array_length(_part) >= 2){
						with(obj_create(x, y, "WepPickupGrounded")){
							target = instance_create(x, y, WepPickup);
							with(target){
								wep  = wep_merge(_part[0], _part[1]);
								ammo = true;
							}
						}
					}*/
					with(rad_drop(x, y, 50, 0, 0)){
						speed += 0.4;
					}
					
					 // Corpse Bits:
					var _spr = spr.BigTopDecalScorpionDebris;
					for(var _img = 0; _img < sprite_get_number(_spr); _img++){
						with(instance_create(x, y, Debris)){
							sprite_index = _spr;
							image_index  = _img;
							image_xscale = choose(-1, 1);
							depth        = object_get_depth(Corpse);
							speed        = random_range(10, 14);
						}
					}
					
					 // Effects:
					repeat(50){
						with(scrFX(x, y, random(6), Dust)){
							image_xscale = 2 + random(2);
							image_yscale = image_xscale;
							friction     = speed * 0.02;
						}
					}
					
					 // Sound:
					sound_play_pitchvol(sndGoldScorpionDead, 0.8,               2.0);
					sound_play_hit_ext(sndBigMaggotDie,      0.5 + random(0.2), 3.0);
					sound_play_hit_ext(sndExplosionCar,      0.8 + random(0.4), 1.5);
				}
				
				 // Boneage:
				else{
					repeat(irandom_range(2, 3)){
						with(instance_create(x, y, WepPickup)){
							wep = "crabbone";
							motion_set(random(360), random_range(3, 6));
							repeat(3) scrFX(x, y, 2, Smoke);
						}
					}
					
					 // Sound:
					sound_play_hit_ext(sndWallBreakBrick, 0.5 + random(0.2), 2.5);
				}
				
				break;
				
			case area_sewers: /// Egg Vat
				
				var	_ang  = random(360),
					_num  = irandom_range(3, 5),
					_sort = [];
					
				for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
					var _dis = random_range(8, 12);
					with(instance_create(
						x + lengthdir_x(_dis * random_range(1, 1.5), _dir),
						y + lengthdir_y(_dis,                        _dir) + 4,
						FrogEgg
					)){
						alarm0       = irandom_range(20, 60);
						nexthurt     = current_frame + 6;
						sprite_index = sprFrogEggSpawn;
						image_index  = 0;
						image_speed *= random_range(0.25, 1);
						
						 // FX:
						repeat(2){
							with(instance_create(x + orandom(4), y + orandom(4), AcidStreak)){
								motion_add(random(360), 1);
								image_angle = direction;
								image_speed *= random_range(0.5, 1);
							}
						}
						
						array_push(_sort, [id, y]);
					}
				}
				
				 // Depth Fix:
				array_sort_sub(_sort, 1, false);
				with(_sort){
					with(self[0]){
						depth++;
						depth--;
					}
				}
				
				 // Sound:
				sound_play_hit_ext(sndFrogExplode,    0.6 + random(0.2), 5);
				sound_play_hit_ext(sndToxicBarrelGas, 0.6 + random(0.1), 3.5);
				
				break;
				
			case area_scrapyards: /// Nest Bits
				
				repeat(irandom_range(12, 14)){
					with(instance_create(x + orandom(24), y - random(24), Feather)){
						motion_add(point_direction(other.x, other.y, x, y), random(6));
						sprite_index = spr.NestDebris;
						image_index  = irandom(irandom(image_number - 1));
						image_speed  = 0;
						depth        = -1;
						fall        /= 1 + (image_index / 8);
					}
				}
				
				 // Sound:
				sound_play_hit_ext(sndMoneyPileBreak,  0.6 + random(0.2), 5.5);
				sound_play_hit_ext(sndWallBreakJungle, 1.2 + random(0.2), 2.5);
				
				break;
				
			case area_caves:
			case area_cursed_caves: /// Spider Nest
				
				y += 8;
				
				 // Floorify:
				floor_set_style(1, area);
				floor_fill(x, y, 2, 1, "");
				floor_reset_style();
				with(instance_create(x, y, PortalClear)){
					image_xscale *= 1.5;
					image_yscale *= 1.2;
				}
				
				 // Inhabitants:
				repeat(irandom_range(2, 3)){
					obj_create(
						x + orandom(32),
						y + orandom(16) - 8,
						(chance(1, 2) ? "MinerBandit" : "Spiderling")
					);
				}
				
				 // Props:
				repeat(irandom_range(3, 4)){
					with(instance_create(
						x + orandom(32),
						y + orandom(16) - 8,
						choose(InvCrystal, Cocoon)
					)){
						nexthurt = current_frame + 6;
						instance_budge(prop, 16);
					}
				}
				
				 // Effects:
				repeat(irandom_range(12, 14)){
					with(instance_create(x + orandom(32), y - random(32), Feather)){
						motion_add(point_direction(other.x, other.y, x, y), random(6));
						sprite_index = spr.PetSpiderWebBits;
						image_index  = irandom(irandom(image_number - 1));
						image_speed  = 0;
						depth        = -1;
						fall        *= random(2);
					}
				}
				
				 // Sound:
				sound_play_hit_ext(sndHitMetal,       0.4 + random(0.2), 5);
				sound_play_hit_ext(sndPlantPotBreak,  0.4 + random(0.2), 2.5);
				sound_play_hit_ext(sndWallBreakScrap, 0.6 + random(0.2), 2.5);
				
				break;
				
			case area_palace: /// Enormous Headphone Jack
				
				 // Explo:
				var	_ang = random(360),
					_dis = 12;
					
				for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 3)){
					with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), GreenExplosion)){
						hitid = 99;
					}
				}
				
				 // Rads:
				repeat(16){
					with(obj_create(x + orandom(8), y + orandom(8) + 8, "BackpackPickup")){
						z      = random(32);
						zspeed = random_range(4, 8);
						target = instance_create(x, y, (chance(1, 6) ? BigRad : Rad));
						with(target) depth = -6;
					}
				}
				
				 // Sound:
				sound_play_hit_ext(sndBigGeneratorBreak, 0.8 + orandom(0.1), 1.5);
				sound_play_hit_ext(sndHitMetal,          0.2 + random(0.1),  5);
				
				break;
				
			case "pizza":
			case area_pizza_sewers: /// Pizza time
				
				repeat(irandom_range(4, 6)){
					obj_create(x + orandom(4), y + orandom(4), "Pizza");
					with(obj_create(x, y, "WaterStreak")){
						speed        = 1 + random(3);
						direction    = random(360);
						image_angle  = direction;
						image_blend  = c_orange;
						image_speed *= random_range(0.4, 1.25);
						depth        = -3;
						mask_index   = mskNone;
					}
				}
				
				 // Sound:
				sound_play_hit_ext(sndPizzaBoxBreak,  0.3 + random(0.1), 5);
				sound_play_hit_ext(sndWallBreakBrick, 0.6 + random(0.2), 1.5);
				
				break;
				
			case "oasis":
			case area_oasis: // Life
				
				y += 8;
				
				 // Floorify:
				floor_set_style(1, area);
				floor_fill(x, y, 2, 1, "");
				floor_reset_style();
				with(instance_create(x, y, PortalClear)){
					image_xscale *= 1.5;
					image_yscale *= 1.2;
				}
				
				 // They livin in there u kno:
				repeat(4){
					var	_sx = x + orandom(24),
						_sy = y + orandom(16) - 8;
						
					 // Enemy:
					if(chance(1, 100)){
						instance_create(_sx, _sy, Freak);
					}
					else{
						obj_create(_sx, _sy, (chance(1, 4) ? Crab : choose(BoneFish, "Puffer")));
					}
					
					 // Prop:
					with(obj_create(_sx + orandom(4), _sy + orandom(4), choose(WaterPlant, WaterPlant, OasisBarrel))){
						nexthurt = current_frame + 30;
						instance_budge(prop, 24);
					}
				}
				
				 // Bubls:
				repeat(20){
					instance_create(x + orandom(24), y + orandom(24), Bubble);
				}
				
				 // Sound:
				sound_play_hit_ext(sndHitMetal,       0.5 + orandom(0.2), 2.5);
				sound_play_hit_ext(sndOasisPortal,    2.0 + orandom(0.2), 4);
				sound_play_hit_ext(sndOasisExplosion, 1.0 + orandom(0.2), 4);
				
				break;
				
			case "trench": /// Bubbles
				
				 // Explo:
				obj_create(x, y, "BubbleExplosion");
				repeat(3){
					obj_create(x, y, "BubbleExplosionSmall");
				}
				
				 // Effects:
				repeat(150){
					scrFX([x, 32], [y, 24], random(2), Bubble);
				}
				
				 // Sond:
				sound_play_hit_ext(sndOasisExplosion,      0.6 + random(0.2), 3);
				sound_play_hit_ext(sndOasisExplosionSmall, 0.4 + random(0.2), 6);
				
				break;
				
		}
	}
	
	
#define BigIDPDSpawn_create(_x, _y)
	with(instance_create(_x, _y, IDPDSpawn)){
		 // Visual:
		depth = -3;
		
		 // Vars:
		elite = true;
		num   = 2 * (1 + GameCont.loops);
		
		 // Vars:
		alarm0 += 30;
		sound_stop(sndIDPDPortalSpawn);
		sound_play(sndEliteIDPDPortalSpawn);
		
		return id;
	}
	
#define BigIDPDSpawn_end_step
	 // Effects:
	if(sprite_index == sprVanPortalCharge){
		if(chance_ct(2, 3)){
			var	l = 64,
				d = random(360);
			
			with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), IDPDPortalCharge)){
				alarm0 = 20 + random(20);
				speed = l / alarm0;
				direction = d + 180;
			}
		}
		if(chance_ct(1, 4)){
			with(scrFX(x, y, [random(360), 1 + random(1)], PlasmaTrail)){
				sprite_index = sprPopoPlasmaTrail;
			}
		}
	}
	
	 // Force Spawns:
	if(alarm1 > 0 && alarm1 <= ceil(current_time_scale)){
		depth = 0;
		repeat(num){
			event_perform(ev_alarm, 1);
			with(instance_create(x, y, PortalClear)){
				image_xscale = 2;
				image_yscale = image_xscale;
			}
		}
		alarm1 = -1;
	}
	
	 // Animate:
	if(anim_end){
		switch(sprite_index){
			case sprVanPortalStart:
				sprite_index = sprVanPortalCharge;
				break;
				
			case sprVanPortalClose:
				instance_destroy();
				break;
		}
	}
	else switch(sprite_index){
		case sprIDPDPortalClose  : sprite_index = sprVanPortalClose;  break;
		case sprIDPDPortalCharge : sprite_index = sprVanPortalCharge; break;
		case sprIDPDPortalStart  : sprite_index = sprVanPortalStart;  break;
	}
	
	
#define BoneArrow_create(_x, _y)
	/*
		A projectile used for the bone scythe's ranged modes
	*/
	
	var	_shotgunShoulders = skill_get(mut_shotgun_shoulders),
		_boltMarrow       = skill_get(mut_bolt_marrow);
		
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = spr.BoneArrow;
		
		 // Vars:
		mask_index = mskBolt;
		friction = 0.6;
		damage = 14;
		force = 8;
		typ = 2;
		damage_falloff = current_frame + 2;
		wallbounce = 4 * _shotgunShoulders;
		home_inst = noone;
		home_dir = 0;
		setup = true;
		big = false;
		
		return id;
	}

#define BoneArrow_setup
	setup = false;
	
	 // Bigify:
	if(big){
		 // Visual:
		sprite_index = spr.BoneArrowHeavy;
		
		 // Vars:
		friction = 0;
		damage = 42;
	}
	
#define BoneArrow_step
	 // Bone Marrow:
	if(home_inst != noone){
		if(instance_exists(home_inst) && projectile_canhit_melee(home_inst)){
			 // Homing:
			if(
				abs(angle_difference(point_direction(x, y, home_inst.x, home_inst.y), home_dir)) < 90
				&&
				!place_meeting(x + lengthdir_x(speed, home_dir), y + lengthdir_y(speed, home_dir), home_inst)
			){
				var	_tx = home_inst.x - lengthdir_x(speed, home_dir),
					_ty = home_inst.y - lengthdir_y(speed, home_dir),
					_diff = angle_difference(point_direction(x, y, _tx, _ty), direction) * 0.5 * current_time_scale;
					
				direction += _diff;
				image_angle += _diff;
			}
			
			 // Done Homing:
			else{
				home_inst = noone;
				direction = home_dir;
				image_angle = direction;
			}
		}
		
		 // Return to Original Direction:
		else if(direction != home_dir){
			var _diff = angle_difference(home_dir, direction);
			if(abs(_diff) > 10) _diff = _diff * 0.5 * current_time_scale;
			direction += _diff;
			image_angle += _diff;
		}
		
		 // Done Homing:
		else home_inst = noone;
	}
	
	else{
		home_dir = direction;
		
		 // Home on Nearest Enemy:
		var _disMax = 24 * skill_get(mut_bolt_marrow);
		if(_disMax > 0){
			var _nearest = noone;
			with(instances_matching_ne(hitme, "team", team, 0)){
				if(!instance_is(self, prop)){
					var _dis = distance_to_point(other.x + other.hspeed, other.y + other.vspeed);
					if(_dis < _disMax){
						if(place_meeting(other.x, other.y, other)){
							_disMax = _dis;
							_nearest = id;
						}
					}
				}
			}
			home_inst = _nearest;
		}
	}

	 // Particles:
	if(chance_ct(1, 7)) scrBoneDust(x, y);
	if(speed <= 4 && current_frame_active){
		scrFX(x, y, [direction, speed], Dust);
	}

	 // Destroy:
	if(speed <= 2) instance_destroy();
	
#define BoneArrow_end_step
	 // Setup:
	if(setup) BoneArrow_setup();

	 // Trail:
	var	_dis = point_distance(x, y, xprevious, yprevious),
		_dir = point_direction(x, y, xprevious, yprevious);
		
	with(instance_create(x, y, BoltTrail)){
		image_xscale  = _dis;
		image_yscale += (0.5 * other.big);
		image_angle   = _dir;
	}
	
#define BoneArrow_wall
	 // Movin' Closer:
	move_contact_solid(direction, speed);
	
	var	_dis = point_distance(x, y, xprevious, yprevious),
		_dir = point_direction(x, y, xprevious, yprevious);
		
	with(instance_create(x, y, BoltTrail)){
		image_xscale  = _dis;
		image_yscale += (0.5 * other.big);
		image_angle   = _dir;
	}
	
	xprevious = x;
	yprevious = y;

	 // Big:
	if(big){
		friction = 1.2;
		sleep(12);
		view_shake_at(x, y, 8);
	}

	 // Effects:
	scrFX(x, y, [direction, 2], Dust);
	repeat(3) scrBoneDust(x, y);
	
	 // Bounce:
	var d = direction;
	speed *= 0.8;
	move_bounce_solid(true);
	image_angle = direction;
	home_dir += angle_difference(direction, d);
	
	 // Shotgun Shoulders:
	var _skill = skill_get(mut_shotgun_shoulders);
	speed = min(speed + wallbounce, 18);
	wallbounce *= 0.9;
	
	 // Sounds:
	if(speed > 4){
		sound_play_hit_ext(sndShotgunHitWall, 0.7 + random(0.3), 1.2);
		sound_play_hit_ext(sndPillarBreak,    0.9 + random(0.3), 0.75);
	}
	
#define BoneArrow_hit
	 // Setup:
	if(setup) BoneArrow_setup();
	
	if(projectile_canhit_melee(other)){
		var _damage = damage + ((damage_falloff > current_frame) * 2);
		projectile_hit(other, _damage, force, direction);
	}
	
#define scrBoneDust(_x, _y)
	var c = [
		make_color_rgb(208, 197, 180),
		make_color_rgb(157, 133, 098),
		make_color_rgb(111, 082, 043)
	];
	
	 // Create the guy aready:
	with(instance_create(_x, _y, Sweat)){
		image_blend = c[irandom(array_length(c) - 1)];
		return id;
	}


#define BoneFX_create(_x, _y)
	/*
		An effect used when swapping the bone scythe's mode
	*/
	
	with(instance_create(_x, _y, Shell)){
		 // Visual:
		sprite_index = spr.BonePickup[irandom(array_length(spr.BonePickup) - 1)];
		image_speed = 0;
		depth = -3;
		
		 // Vars:
		creator = noone;
		delay = 2 + random(4);
		speed = (8 - delay) + random(2);
		direction = random(360);
		
		return id;
	}
	
#define BoneFX_step
	if(instance_exists(creator)){
		delay -= current_time_scale;
		if(delay <= 0){
			 // Gravitate:
			if(!place_meeting(x, y, creator) && !place_meeting(x, y, Portal)){
				x += creator.hspeed_raw / 2;
				y += creator.vspeed_raw / 2;
				
				var d = direction;
				motion_add_ct(point_direction(x, y, creator.x, creator.y), 2.4);
				image_angle += (direction - d);
				speed = min(speed, 8);
				
				xprevious = x + hspeed_raw*2;
				yprevious = y + vspeed_raw*2;
			}
			
			 // Goodbye:
			else{
				scrFX(x, y, [direction, 2 + random(3)], Dust);
				
				sleep(14);
				instance_destroy();
			}
		}
	}


#define BoneSlash_create(_x, _y)
	/*
		A scythe slash, creates BonePickups from kills
	*/
	
	with(instance_create(_x, _y, CustomSlash)){
		 // Visual:
		sprite_index = spr.BoneSlashLight;
		image_speed  = 0.4;
		
		 // Vars:
		mask_index = msk.BoneSlashLight;
		friction   = 0.1;
		damage     = 24;
		force      = 8;
		heavy      = false;
		walled     = false;
		rotspeed   = 0;
		setup      = true;
		
		return id;
	}
	
#define BoneSlash_setup
	setup = false;

	 // Become Heavy Slash:
	if(heavy){
		 // Visual:
		sprite_index = spr.BoneSlashHeavy;

		 // Vars:
		mask_index = msk.BoneSlashHeavy;
		damage = 32;
		force = 12;
	}
	
	repeat(3){
		var	_flip = sign(image_yscale),
			_l = (heavy ? 24 : 16) + orandom(2),
			_d = direction + (random_range(30, 120) * _flip);
			
		with(scrBoneDust(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d))){
			motion_set(_d + (random_range(90, 120) * _flip), 1 + random(2));
		}
	}

#define BoneSlash_end_step
	if(setup) BoneSlash_setup();

#define BoneSlash_step
	 // Brotate:
	image_angle += rotspeed * current_time_scale;
	
#define BoneSlash_hit
	if(setup) BoneSlash_setup();
	
	if(projectile_canhit_melee(other) && other.my_health > 0){
		projectile_hit(other, damage, force, direction);
		
		 // Bone Pickup Drops:
		with(other) if(my_health <= 0){
			var	_max = round(maxhealth / power(0.8, skill_get(mut_scarier_face))),
				_num = ceil(maxhealth / 5);
				
			if(_num > 0){
				if(
					!instance_is(self, prop)
					|| string_pos("Bone",  object_get_name(object_index)) > 0
					|| string_pos("Skull", object_get_name(object_index)) > 0
					|| ("name" in self && (string_pos("Bone", name) > 0 || string_pos("Skull", name) > 0))
				){
					 // Big Pickups:
					var _numLarge = floor((_num - 1) div 10);
					if(_numLarge > 0) repeat(_numLarge){
						with(obj_create(x, y, "BoneBigPickup")){
							motion_set(random(360), 3 + random(1));
						}
					}
					
					 // Small Pickups:
					var _numSmall = ceil((_num - 1) mod 10) + 1;
					if(_numSmall > 0) repeat(_numSmall){
						with(obj_create(x, y, "BonePickup")){
							motion_set(random(360), 3 + random(1));
						}
					}
					
					/*
					 // Reap Soul:
					if(other.heavy && size >= 1 && !instance_is(self, prop)){
						with(instance_create(x, y - 4, ReviveFX)){
							sprite_index = sprMeltGhost;
							image_xscale = other.image_xscale * (("right" in other) ? other.right : 1);
							image_yscale = other.image_yscale;
							image_speed = 0.4 + random(0.4);
							depth = -1;
							
							 // Ghost FX:
							repeat(3) with(scrFX(x, y, random_range(2, 4), Dust)){
								depth = 1;
							}
							sound_play_hit_ext(sndCorpseExploDead, image_speed * 5, 0.8);
						}
						
						 // Stat:
						stat_set("soul", stat_get("soul") + 1);
					}
					*/
				}
			}
		}
	}
	
#define BoneSlash_wall
	if(!walled){
		walled = true;
		friction = 0.4;
		
		 // Hit Wall FX:
		var	_x = bbox_center_x + hspeed_raw,
			_y = bbox_center_y + vspeed_raw,
			_col = choose(c_white, make_color_rgb(208, 197, 180), make_color_rgb(157, 133, 098), make_color_rgb(111, 082, 043));
			
		with(instance_is(other, Wall) ? instance_nearest_bbox(_x, _y, instances_meeting(_x, _y, Wall)) : other){
			with(instance_create(bbox_center_x, bbox_center_y, MeleeHitWall)){
				image_angle = point_direction(_x, _y, x, y);
				image_blend = _col;
				sound_play_hit_ext(sndMeleeWall, 1.2 + random(0.5), 2);
			}
		}
	}


#define BuriedVault_create(_x, _y)
	/*
		Creates a vault buried in the wall with cool treasures
		Uncovers itself if any of its layout comes into contact with normal Floors
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		mask_index      = mskWall;
		image_xscale    = 6;
		image_yscale    = 4;
		floor_num       = 0;
		floor_min       = 0;
		floor_vars      = {};
		floor_room_vars = { sprite_index : spr.VaultFlowerFloor };
		layout          = [];
		layout_delay    = 6;
		obj_prop        = Torch;
		obj_loot        = "BuriedVaultPedestal";
		area            = area_vault;
		x               = pfloor(bbox_left, 16);
		y               = pfloor(bbox_top,  16);
		
		return id;
	}
	
#define BuriedVault_step
	 // Generate Layout:
	if(array_length(layout) <= 0){
		if(layout_delay > 0){
			layout_delay -= current_time_scale;
		}
		else{
			var _areaCurrent = GameCont.area;
			
			 // Move Away From Floors:
			var	_move = 32,
				_dis  = random_range(40, 80);
				
			direction = random(360);
			with(instance_nearest_bbox(x, y, Floor)){
				other.direction = point_direction(bbox_center_x, bbox_center_y, other.x, other.y);
			}
			
			while(distance_to_object(Floor) < _dis){
				x = pfloor(x + lengthdir_x(_move, direction), 16);
				y = pfloor(y + lengthdir_y(_move, direction), 16);
			}
			
			 // TopSmalls:
			var	_x1      = random_range(bbox_left,      bbox_right  + 1),
				_y1      = random_range(bbox_top,       bbox_bottom + 1),
				_x2      = random_range(bbox_left + 16, bbox_right  + 1 - 16),
				_y2      = random_range(bbox_top  + 16, bbox_bottom + 1 - 16),
				_tileOld = [],
				_tileNew = [];
				
			for(var _x = 0; _x < image_xscale; _x++){
				for(var _y = 0; _y < image_xscale; _y++){
					var _center = (
						_x > 0                &&
						_y > 0                &&
						_x < image_xscale - 1 &&
						_y < image_xscale - 1
					);
					if(_center || chance(1, 3)){
						var	_sx = x + (_x * 16),
							_sy = y + (_y * 16);
							
						if(
							!position_meeting(_sx, _sy, Floor)    &&
							!position_meeting(_sx, _sy, Wall)     &&
							!position_meeting(_sx, _sy, TopSmall)
						){
							with(instance_create(_sx, _sy, TopSmall)){
								if(collision_line(_x1, _y1, _x2, _y2, id, false, false)){
									GameCont.area = other.area;
									event_perform(ev_create, 0);
									if(!instance_exists(self)) break;
									array_push(_tileNew, self);
								}
								else array_push(_tileOld, self);
								
								 // Variance:
								if(position_meeting(_x2, _y2, id) || chance(2, 3)){
									sprite_index = area_get_sprite(GameCont.area, sprWall1Top);
								}
							}
							GameCont.area = _areaCurrent;
						}
					}
				}
			}
			GameCont.area = area;
			with(array_shuffle(_tileNew)){
				for(var _x = bbox_left - 8; _x < bbox_right + 1 + 8; _x += 8){
					for(var _y = bbox_top - 8; _y < bbox_bottom + 1 + 8; _y += 8){
						if(array_length(instances_at(_x, _y, _tileNew)) <= 0){
							if(chance(1, 10)){
								with(obj_create(_x, _y, "TopTiny")){
									array_push(_tileNew, id);
								}
							}
						}
					}
				}
			}
			GameCont.area = _areaCurrent;
			
			 // Decal:
			with(array_shuffle(_tileOld)){
				if(array_length(instances_meeting(x, y, _tileNew)) <= 0){
					with(obj_create(
						irandom_range(bbox_left, bbox_right + 1),
						irandom_range(bbox_top, bbox_bottom + 1),
						"TopDecal"
					)){
						x = xstart;
						y = ystart;
					}
					break;
				}
			}
			
			 // Generate Room Layout:
			var	_fx    = pfloor(bbox_center_x, 16),
				_fy    = pfloor(bbox_center_y, 16),
				_num   = irandom_range(6, 12),
				_dir   = direction,
				_ped   = true,
				_tries = 100;
				
			while(_num > 0 && _tries-- > 0){
				var	_moveDis = 32,
					_moveDir = pround(_dir, 90);
					
				_fx += lengthdir_x(_moveDis, _moveDir);
				_fy += lengthdir_y(_moveDis, _moveDir);
				
				var	_spawnPed = chance(_ped, 1 + ((_num - 1) * 2)),
					_floorDis = 48 + (32 * _spawnPed),
					_nearest  = instance_nearest_bbox(_fx + 16, _fy + 16, Floor);
					
				if(
					!instance_exists(_nearest)
					|| abs(_fx - _nearest.x) > _floorDis
					|| abs(_fy - _nearest.y) > _floorDis
				){
					_num--;
					_tries = 100;
					
					 // Main Loot:
					if(_spawnPed){
						_ped = false;
						
						var _room = 0;
						for(var _oy = -32; _oy <= 32; _oy += 32){
							for(var _ox = -32; _ox <= 32; _ox += 32){
								array_push(layout, {
									x	 : _fx + _ox,
									y	 : _fy + _oy,
									obj	 : Floor,
									room : _room++
								});
							}
						}
						
						array_push(layout, {
							x	: _fx + 16,
							y	: _fy + 8,
							obj	: obj_loot
						});
						
						_fx += lengthdir_x(_moveDis, _moveDir);
						_fy += lengthdir_y(_moveDis, _moveDir);
					}
					
					 // Floor:
					else{
						array_push(layout, {
							x	: _fx,
							y	: _fy,
							obj	: Floor
						});
						
						 // Prop:
						if(chance(1, 8)){
							array_push(layout, {
								x	: _fx + 16,
								y	: _fy + 16,
								obj	: obj_prop
							});
						}
					}
					
					 // Turn:
					_dir += orandom(60);
				}
				else{
					_fx -= lengthdir_x(_moveDis, _moveDir);
					_fy -= lengthdir_y(_moveDis, _moveDir);
					_dir = _moveDir + 180 + orandom(90);
				}
			}
		}
	}
	
	 // Create Vault:
	else if(instance_exists(Floor)){
		if(floor_num != instance_number(Floor) || floor_min < Floor.id){
			floor_num = instance_number(Floor);
			floor_min = GameObject.id;
			
			 // Check if Vault Uncovered:
			var	_open = false,
				_sx   = bbox_center_x,
				_sy   = bbox_center_y;
				
			if(place_meeting(x, y, Floor)){
				_open = true;
				wall_clear(x, y);
			}
			with(layout) if(!_open && obj == Floor){
				var	_x = x,
					_y = y;
					
				with(other) if(collision_rectangle(_x - 1, _y - 1, _x + 32, _y + 32, Wall, false, false)){
					_open = true;
					_sx = _x;
					_sy = _y;
				}
			}
			
			 // Uncovered:
			if(_open){
				var _areaCurrent = GameCont.area;
				GameCont.area = area;
				
				 // Clear Obstructions:
				with(layout) if(obj == Floor){
					var	_x1 = x - 16,
						_y1 = y - 16,
						_x2 = x + 48 - 1,
						_y2 = y + 48 - 1;
						
					wall_delete(_x1, _y1, _x2, _y2);
					with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, [Floor, SnowFloor])){
						instance_destroy();
					}
				}
				
				 // Generate:
				var	_minID = GameObject.id;
				with(layout){
					var _room = lq_defget(self, "room", -1);
					
					 // Clear Space for Special Floors:
					if(_room >= 0 && (obj == Floor || object_is_ancestor(obj, Floor))){
						with(instance_rectangle_bbox(x, y, x + 32 - 1, y + 32 - 1, [Floor, SnowFloor])){
							instance_destroy();
						}
					}
					
					 // Create:
					with(other){
						with(obj_create(other.x, other.y, other.obj)){
							if(instance_is(self, Floor)){
								if(_room >= 0){
									image_index = _room;
								}
								variable_instance_set_list(id, ((_room < 0) ? other.floor_vars : other.floor_room_vars));
							}
						}
					}
				}
				
				 // Wallerize:
				var	_tiles = [],
					_floor = [];
					
				with(instances_matching_gt(Floor, "id", _minID)){
					floor_walls();
				}
				with(instances_matching_gt(Wall, "id", _minID)){
					 // TopSmalls:
					if(array_length(instance_rectangle_bbox(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, instances_matching_lt(Floor, "id", _minID))) <= 0){
						if(chance(2, 5)){
							GameCont.area = _areaCurrent;
							wall_tops();
							GameCont.area = other.area;
						}
						else with(wall_tops()){
							array_push(_tiles, self);
						}
					}
					
					 // Less Softlock:
					else{
						array_push(_floor, instance_create(x, y, FloorExplo));
						instance_destroy();
					}
				}
				with(instances_matching(_tiles, "", null)){
					 // TopTinys:
					for(var _x = bbox_left - 8; _x < bbox_right + 1 + 8; _x += 8){
						for(var _y = bbox_top - 8; _y < bbox_bottom + 1 + 8; _y += 8){
							if(array_length(instances_at(_x, _y, _tiles)) <= 0){
								if(chance(1, 5)){
									obj_create(_x, _y, "TopTiny");
								}
							}
						}
					}
				}
				
				 // Even Less Softlock: i dislike walls as objects
				with(instances_matching(_floor, "", null)){
					if(
						position_meeting(x - 16, y,      Wall) &&
						position_meeting(x,      y - 16, Wall) &&
						position_meeting(x + 16, y,      Wall) &&
						position_meeting(x,      y + 16, Wall)
					){
						with([
							instances_meeting(x - 16, y,      Wall),
							instances_meeting(x,      y - 16, Wall),
							instances_meeting(x + 16, y,      Wall),
							instances_meeting(x,      y + 16, Wall)
						]){
							with(other){
								with(instances_matching(other, "", null)){
									if(id < _minID) GameCont.area = _areaCurrent;
									instance_create(x, y, FloorExplo);
									instance_destroy();
									GameCont.area = other.area;
								}
							}
						}
					}
				}
				
				GameCont.area = _areaCurrent;
				
				 // Cool Reveal:
				view_shake_at(_sx, _sy, 20);
				sound_play_pitch(sndStatueCharge, 1.6 + orandom(0.2));
				sound_play_pitch(sndStatueDead, 0.4 + random(0.1));
				with(instances_matching_gt([Floor, Wall, TopSmall], "id", _minID)){
					var _time = (point_distance(bbox_center_x, bbox_center_y, _sx, _sy) - 32) / 4.5;
					with(floor_reveal(bbox_left, bbox_top, bbox_right, bbox_bottom, 4)){
						time  = _time;
						flash = false;
					}
				}
				
				instance_destroy();
			}
		}
	}
	
	
#define BuriedShrine_create(_x, _y)
	with(obj_create(_x, _y, "BuriedVault")){
		 // Visual:
		floor_room_vars.sprite_index = spr.FloorPalaceShrineRoomLarge;
		floor_vars.sprite_index      = spr.FloorPalaceShrine;
		
		 // Vars:
		obj_loot = "PalaceAltar";
		obj_prop = Pillar;
		area     = area_palace;
		
		return id;
	}
	
	
#define CustomBullet_create(_x, _y)
	/*
		A Bullet1-type projectile that allows for extra customization
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprBullet1;
		spr_dead = sprBulletHit;
		
		 // Vars:
		mask_index = mskBullet1;
		damage = 3;
		force = 8;
		typ = 1;
		
		return id;
	}
	
#define CustomBullet_anim
	image_index = image_number - 1;
	image_speed = 0;
	
#define CustomBullet_wall
	instance_create(x, y, Dust);
	sound_play_hit(sndHitWall, 0.2);
	instance_destroy();
	
#define CustomBullet_destroy
	with(instance_create(x, y, BulletHit)){
		sprite_index = other.spr_dead;
	}
	
	
#define CustomFlak_create(_x, _y)
	/*
		A FlakBullet/EFlakBullet-type projectile that allows for extra customization
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprFlakBullet;
		spr_dead     = sprFlakHit;
		
		 // Sounds:
		snd_dead = sndFlakExplode;
		
		 // Vars:
		mask_index   = mskFlakBullet;
		friction     = 0.4;
		damage       = 4;
		force        = 6;
		typ          = 1;
		bonus        = true;
		bonus_damage = 2;
		flak         = array_create(16, Bullet2);
		super        = false;
		
		 // Alarms:
		alarm2 = 2;
		
		return id;
	}
	
#define CustomFlak_step
	 // Alarms:
	if(alarm2_run) exit;
	
	 // Trail:
	if(super || chance_ct(1, 3)){
		var o = (3 * super);
		scrFX([x, o], [y, o], random(2), Smoke);
	}

	 // Animate:
	image_speed = (speed / 12);

	 // Explode:
	if(speed == 0 || place_meeting(x, y, Explosion)){
		instance_destroy();
	}
	
#define CustomFlak_alrm2
	bonus = false;
	
#define CustomFlak_hit
	if(projectile_canhit(other)){
		sleep(30);
		projectile_hit_push(other, damage + (bonus_damage * bonus), force);
		instance_destroy();
	}
	
#define CustomFlak_destroy
	var	_dir      = random(360),
		_flak     = flak,
		_flakSize = array_length(_flak);
		
	for(var i = 0; i < _flakSize; i++){
		var _lq = _flak[i];
		if(!is_object(_lq)){
			_lq = (is_array(_lq) ? { flak:_lq } : { object_index:_lq });
		}
		
		 // Create Projectile:
		var _inst = projectile_create(
			lq_defget(_lq, "x",            0) + x,
			lq_defget(_lq, "y",            0) + y,
			lq_defget(_lq, "object_index", name),
			lq_defget(_lq, "direction",    (super ? _dir + (360 * (i / _flakSize)) : random(360))),
			lq_defget(_lq, "speed",        (super ? 12 : random_range(8, 16)))
		);
		variable_instance_set_list(_inst, _lq);
		team_instance_sprite(sprite_get_team(sprite_index), _inst);
	}
	
	 // Effects:
	var _num = 1 + super;
	if(_num > 0) repeat(6 * _num){
		scrFX(x, y, random(3), Smoke);
	}
	with(instance_create(x, y, BulletHit)){
		sprite_index = other.spr_dead;
	}
	sound_play_hit_big(snd_dead, 0.2);
	view_shake_at(x, y, 6 * _num);
	sleep(10 * _num);
	
	
#define CustomShell_create(_x, _y)
	/*
		A Bullet2/EnemyBullet3-type projectile that allows for extra customization
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprBullet2;
		spr_fade     = sprBullet2Disappear;
		spr_dead     = sprBullet2Disappear;
		
		 // Vars:
		mask_index   = mskBullet2;
		friction     = 0.6;
		damage       = 2;
		force        = 3;
		typ          = 1;
		bonus        = true;
		bonus_damage = 1;
		minspeed     = 6;
		maxspeed     = 16;
		wallbounce   = 0;
		
		 // Alarms:
		alarm2 = 2;
		
		return id;
	}
	
#define CustomShell_step
	 // Alarms:
	if(alarm2_run) exit;
	
	 // Facing:
	image_angle = direction;
	
	 // Disappear:
	if(speed < minspeed && sprite_index != spr_fade){
		sprite_index = spr_fade;
		image_index  = 0;
		image_speed  = 0.4;
	}
	
#define CustomShell_anim
	if(sprite_index != spr_fade){
		image_speed = 0;
		image_index = image_number - 1;
	}
	
	 // Poof:
	else instance_destroy();
	
#define CustomShell_alrm2
	bonus = false;
	
#define CustomShell_hit
	if(projectile_canhit(other)){
		projectile_hit_push(other, damage + (bonus_damage * bonus), force);
		
		 // Goodbye:
		with(instance_create(x, y, BulletHit)){
			sprite_index = other.spr_dead;
		}
		instance_destroy();
	}
	
#define CustomShell_wall
	instance_create(x, y, Dust);
	if(speed > minspeed){
		sound_play_hit(sndShotgunHitWall, 0.2);
	}
	
	 // Reset Bonus Damage:
	if(wallbounce > 0 && !bonus){
		bonus = true;
		alarm2 = 2;
	}
	
	 // Bounce:
	move_bounce_solid(true);
	image_angle = direction;
	speed = min((speed * 0.8) + wallbounce, maxspeed);
	wallbounce *= 0.95;
	
	
#define CustomPlasma_create(_x, _y)
	/*
		A PlasmaBall/PlasmaBig/PlasmaHuge-type projectile that allows for extra customization
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = sprPlasmaBall;
		spr_dead     = sprPlasmaImpact;
		spr_trail    = sprPlasmaTrail;
		image_speed  = 0.5;
		
		 // Sound:
		snd_dead = sndPlasmaHit;
		
		 // Vars:
		mask_index = mskPlasma;
		damage     = 4;
		force      = 4;
		typ        = 2;
		minspeed   = 7;
		minscale   = 0.5;
		flak       = [];
		
		return id;
	}
	
#define CustomPlasma_step
	var	_width = sprite_get_width(sprite_index),
		_minWidth = minscale * _width;
		
	 // Trail:
	if(chance_ct(_width - 16, 16)){
		var	o = _minWidth * ((_width >= 32) ? 3/4 : 1/2);
		with(instance_create(x + orandom(o), y + orandom(o), PlasmaTrail)){
			sprite_index = other.spr_trail;
		}
	}
	
	 // Shake:
	view_shake_max_at(x, y, floor(_width / 24));
		
	 // Explode:
	if(sprite_width < _minWidth || (friction > 0 && speed == 0)){
		instance_destroy();
	}
	
#define CustomPlasma_draw
	draw_sprite_ext(sprite_index, image_index, x, y, lerp(minscale, 1, image_xscale), lerp(minscale, 1, image_yscale), image_angle, image_blend, image_alpha);
	
#define CustomPlasma_anim
	image_speed = 0;
	image_index = image_number - 1;
	speed = minspeed;
	
#define CustomPlasma_hit
	if(projectile_canhit(other)){
		projectile_hit_push(other, round(damage * image_xscale), force);
		
		 // Shrink:
		image_xscale -= 0.1;
		image_yscale -= 0.1;
		x -= hspeed_raw;
		y -= vspeed_raw;
		
		 // Effects:
		var	_sleep = (10 / 3) * floor(sprite_width / 16),
			_shake = 2 + (4 * floor(sprite_get_width(sprite_index) / 32));
			
		if(array_length(flak) > 0){
			_sleep *= 3;
		}
		if(!instance_is(creator, Player)){
			_sleep *= 3;
			_shake *= 0.5;
		}
		
		sleep(_sleep);
		view_shake_at(x, y, _shake);
	}
	
#define CustomPlasma_wall
	 // Shrink:
	image_xscale -= 0.1;
	image_yscale -= 0.1;
	x -= hspeed_raw;
	y -= vspeed_raw;
	
	 // Effects:
	instance_create(x, y, Dust);
	sound_play_hit(sndHitWall, 0.2);
	
#define CustomPlasma_destroy
	sound_play_hit_big(snd_dead, 0.3);
	
	 // Cannon:
	var	_dir      = random(360),
		_flak     = flak,
		_flakSize = array_length(_flak);
		
	if(_flakSize > 0){
		for(var i = 0; i < _flakSize; i++){
			var _lq = _flak[i];
			if(!is_object(_lq)){
				_lq = (is_array(_lq) ? { flak:_lq } : { object_index:_lq });
			}
			
			 // Big Plasma:
			if(array_length(lq_get(_lq, "flak")) > 0){
				with(_lq){
					if("sprite_index" not in self) sprite_index = sprPlasmaBallBig;
					if("snd_dead"     not in self) snd_dead     = sndPlasmaBigExplode;
					if("damage"       not in self) damage       = 15;
					if("force"        not in self) force        = 8;
					if("typ"          not in self) typ          = 1;
					if("minspeed"     not in self) minspeed     = 6;
				}
			}
			
			 // Create Projectile:
			var _inst = projectile_create(
				lq_defget(_lq, "x",            0) + x,
				lq_defget(_lq, "y",            0) + y,
				lq_defget(_lq, "object_index", name),
				lq_defget(_lq, "direction",    _dir + (360 * (i / _flakSize))),
				lq_defget(_lq, "speed",        2)
			);
			variable_instance_set_list(_inst, _lq);
			team_instance_sprite(sprite_get_team(sprite_index), _inst);
		}
		instance_create(x, y, PortalClear);
		sleep(10);
	}
	
	 // Normal:
	else{
		with(projectile_create(x, y, PlasmaImpact, 0, 0)){
			sprite_index = other.spr_dead;
			if(!instance_is(creator, Player)){
				mask_index = mskPopoPlasmaImpact;
			}
		}
		sleep(3);
	}
	
	
#define GroundFlameGreen_create(_x, _y)
	/*
		Green variant of the GroundFlame effect
	*/
	
	with(instance_create(_x, _y, GroundFlame)){
		 // Visual:
		var _big = chance(1, 3);
		sprite_index = (_big ? spr.GroundFlameGreenBig          : spr.GroundFlameGreen         );
		spr_dead     = (_big ? spr.GroundFlameGreenBigDisappear : spr.GroundFlameGreenDisappear);
		
		return id;
	}
	
	return noone;
	
#define GroundFlameGreen_end_step
	 // Override Disappear Animation:
	if(sprite_index == sprGroundFlameDisappear){
		sprite_index = spr_dead;
	}
	if(sprite_index == spr_dead && anim_end){
		instance_destroy();
	}
	
	
#define Igloo_create(_x, _y)
	/*
		Buildings for the Frozen City bro, seals live here
		
		Vars:
			num   - Number of seals that live here
			type  - The main type of seal that lives here
			alert - Alert the player before releasing seals, true/false
			chest - Drops a chest on death, true/false
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		 // Facing:
		front = chance(1, 3);
		with(instances_matching(CustomProp, "name", "PalankingStatue")){
			if(other.x >= bbox_left && other.x < bbox_right + 1){
				if(y > other.y){
					other.front = true;
				}
			}
			else if(other.y >= bbox_top && other.y < bbox_bottom + 1){
				other.front = false;
				if(other.x != x){
					other.image_xscale = sign(x - other.x);
				}
			}
		}
		
		 // Visual:
		spr_idle     = (front ? spr.IglooFrontIdle : spr.IglooSideIdle);
		spr_hurt     = (front ? spr.IglooFrontHurt : spr.IglooSideHurt);
		spr_dead     = (front ? spr.IglooFrontDead : spr.IglooSideDead);
		sprite_index = spr_idle;
		depth        = -1;
		
		 // Sound:
		snd_hurt = sndHitRock;
		snd_dead = sndSnowmanBreak;
		
		 // Vars:
		mask_index = -1;
		maxhealth  = 30;
		team       = 1;
		size       = 2;
		num        = irandom_range(5, 6);
		type       = irandom_range(4, 6);
		alert      = true;
		chest      = chance(1, 5);
		
		 // Alarms:
		alarm0 = irandom_range(150, 240);
		
		 // No Portals:
		with(obj_create(0, 0, "PortalPrevent")){
			creator = other;
		}
		
		return id;
	}
	
#define Igloo_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Allow Portals:
	if(num <= 0){
		with(instances_matching(instances_matching(becomenemy, "name", "PortalPrevent"), "creator", id)){
			instance_destroy();
		}
	}
	
#define Igloo_alrm0
	if(num > 0){
		alarm0 = 60 + random(60);
		
		if(instance_exists(Player)){
			 // Seal Spew:
			if(!alert || chance(num, 16)){
				num--;
				
				if(alert) alarm0 += random(30);
				else alarm0 = 2 + random(3);
				
				 // The Boys:
				with(obj_create(x, y, "Seal")){
					type = choose(other.type, 4);
				}
			}
			
			 // Alert:
			if(alert){
				var	_player = instance_nearest(x, y, Player),
					_enemy  = instance_nearest(x, y, enemy);
					
				if(
					my_health < maxhealth
					|| !instance_exists(_enemy)
					|| point_distance(x, y, _player.x, _player.y) < point_distance(x, y, _enemy.x, _enemy.y)
				){
					alert = false;
					alarm0 = 30;
					
					with(alert_create(self, spr.SealArcticAlert)){
						flash = other.alarm0;
						if(other.chest){
							alert = { spr:sprBreath, x:1, y:2 };
						}
					}
				}
			}
		}
	}
	
#define Igloo_death
	 // Seal Spew Pt.2:
	if(num > 0){
		repeat(num){
			with(obj_create(x, y, "Seal")){
				type = choose(other.type, 4);
			}
		}
		if(alert){
			with(alert_create(self, spr.SealArcticAlert)){
				vspeed = -3;
				if(other.chest){
					alert = { spr:sprBreath, x:1, y:2 };
				}
			}
		}
	}
	
	 // Pickups:
	if(chest){
		var	_num = 1 + skill_get(mut_open_mind);
		if(_num > 0) repeat(_num){
			var _obj = (chance(1, 5) ? "Backpack" : choose(WeaponChest, AmmoChest));
			if(crown_current == crwn_life && chance(2, 3)){
				_obj = HealthChest;
			}
			with(chest_create(x, y, _obj, false)){
				motion_add(random(360), 1);
			}
		}
	}
	else for(var i = 0; i < 2; i++){
		pickup_drop(50, 20, i);
	}
	
	 // Effects:
	for(var _dir = 0; _dir < 360; _dir += (360 / (12 + num))){
		with(scrFX([x, 4], [y + 6, 4], 0, Smoke)){
			direction = _dir + orandom(10);
			speed = random_range(1, 3);
			sprite_index = sprSnowFlake;
			image_index = irandom(image_number - 1);
			image_xscale *= 2;
			image_yscale *= 2;
			//friction *= 2/3;
			vspeed -= 1.5;
			gravity = 0.085;
		}
	}
	sound_play_hit_ext(sndMaggotSpawnDie, 1.2 + random(0.2), 7);
	
	
#define MergeFlak_create(_x, _y)
	/*
		A projectile that groups a bunch of other projectiles into a flak ball
		Used for merged weapon flak cannons
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		sprite_index = -1;
		image_speed = 0;
		
		 // Vars:
		mask_index = mskFlakBullet;
		friction   = 0.4;
		damage     = 0;
		force      = 6;
		rotation   = 0;
		rotspeed   = random_range(12, 16) * choose(-1, 1);
		inst       = [];
		inst_vars  = {};
		flag       = [];
		
		return id;
	}
	
#define MergeFlak_step
	image_index += speed_raw / 12;
	
	 // Create Sprite:
	if(!sprite_exists(sprite_index)){
		var _instMergeFlak = instances_matching_ne(instances_matching(object_index, "name", name), "id", id);
		if(array_length(instances_matching(instances_matching(_instMergeFlak, "sprite_width", 16), "sprite_height", 16)) <= 0){
			var	_inst = instances_matching(inst, "", null),
				_size = 24,
				_num  = 2;
				
			with(_inst){
				_size = max(_size, 2 * max(sprite_width, sprite_height));
			}
			
			with(surface_setup(name, _size * _num, _size, 1)){
				surface_set_target(surf);
				draw_clear_alpha(0, 0);
				
				with(other){
					for(var i = 0; i < _num; i++){
						with(_inst){
							var	_spr = sprite_index,
								_img = image_index,
								_xsc = image_xscale,
								_ysc = image_yscale,
								_ang = image_angle,
								_col = image_blend,
								_alp = abs(image_alpha),
								_dis = (sprite_xoffset - (sprite_width / 2)),
								_x   = (_size / 2) + lengthdir_x(_dis, _ang) + (i * _size),
								_y   = (_size / 2) + lengthdir_y(_dis, _ang),
								_pulse = 1 + min(4 / sprite_get_width(_spr), i * (sprite_get_height(_spr) / 64));
								
							if(array_exists(_instMergeFlak, self)){
								_img = i;
								_pulse = 1;
							}
							
							else switch(_spr){
								case sprGrenade:
								case sprStickyGrenade:
								case sprBloodGrenade:
								case sprFlare:
								case sprPopoNade:
								case sprToxicGrenade:
								case sprClusterNade:
								case sprUltraGrenade:
									_spr = sprClusterGrenadeBlink;
									_img = i;
									break;
									
								case sprMininade:
								case sprConfettiBall:
									_spr = sprGrenadeBlink;
									_img = i;
									break;
									
								case sprHeavyNade:
									_spr = sprHeavyGrenadeBlink;
									_img = i;
									break;
									
								case sprDisc:
								case sprGoldDisc:
									if(i) _spr = sprDiscTrail;
									_xsc *= 1.25;
									_ysc *= 1.25;
									_ang = 0;
									break;
									
								case sprLaser:
									_spr = sprPlasmaBall;
									_ysc /= 3;
									_xsc = _ysc;
									break;
									
								case sprPlasmaBall:
								case sprPlasmaBallBig:
								case sprPlasmaBallHuge:
								case sprUltraBullet:
								case sprUltraShell:
									_xsc *= 0.8;
									_ysc *= 0.8;
									break;
									
								case sprLightning:
									_spr = sprLightningBall;
									_img = (i * 3);
									_ang = other.image_angle;
									_xsc /= 2;
									_ysc /= 2;
									break;
									
								case sprTrapFire:
								case sprWeaponFire:
									_img = irandom(3);
									break;
									
								case sprLightningBall:
								case sprFlameBall:
								case sprBloodBall:
									_img = irandom(image_number - 1);
									break;
									
								case sprFireShell:
									_spr = sprFireBall;
									_img = 1;
									break;
									
								case sprBolt:
								case sprBoltGold:
								case sprToxicBolt:
								case sprHeavyBolt:
								case sprSplinter:
								case sprUltraBolt:
								case sprSeeker:
									_img = image_number - 1;
									break;
									
								case sprScorpionBullet:
									_ysc *= 2;
									break;
							}
							
							_xsc *= _pulse;
							_ysc *= _pulse;
							
							draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
						}
					}
				}
				
				surface_reset_target();
				
				 // Add Sprite:
				surface_save(surf, `spr${name}.png`);
				other.sprite_index = sprite_add(`spr${name}.png`, _num, _size / 2, _size / 2);
			}
		}
	}
	
	 // Hold Instances:
	var _vars = inst_vars;
	with(inst){
		if(instance_exists(self) && speed > 0){
			 // Store Vars:
			var _id = string(id);
			if(_id not in _vars){
				var v = {
					mask_index	: mask_index,
					image_index	: image_index,
					speed		: speed,
					alarm		: []
				};
				for(var i = 0; i < 12; i++){
					var a = alarm_get(i);
					if(a > 0){
						array_push(v.alarm, [i, a + 1]);
					}
				}
				lq_set(_vars, _id, v);
			}
			
			 // Hold Vars:
			var v = lq_get(_vars, _id);
			image_index = v.image_index;
			speed = v.speed;
			var a = v.alarm;
			for(var i = 0; i < array_length(a); i++){
				alarm_set(a[i, 0], a[i, 1]);
			}
			
			 // Freeze Movement:
			x = other.x - hspeed_raw;
			y = other.y - vspeed_raw;
			
			 // Object-Specific:
			switch(object_index){
				case Laser:
					xstart = x;
					ystart = y;
					image_yscale += 0.3 * current_time_scale;
					break;
					
				case Bolt:
				case ToxicBolt:
				case Splinter:
				case HeavyBolt:
				case UltraBolt:
					x += lengthdir_x(sprite_height / 4, image_angle + other.rotation);
					y += lengthdir_y(sprite_height / 4, image_angle + other.rotation);
					break;
					
				case CustomProjectile:
					if("name" in self && name == other.name){
						rotation = other.rotation;
						image_index = other.image_index;
					}
					break;
			}
			
			 // Disable:
			if(mask_index != mskNone){
				v.mask_index = mask_index;
				mask_index = mskNone;
			}
			image_alpha = -abs(image_alpha);
		}
		else other.speed = 0;
	}
	
	 // Spin:
	rotation += rotspeed * current_time_scale;
	rotspeed -= clamp(rotspeed, -friction, friction) * current_time_scale;
	
	 // Effects:
	if(chance_ct(1, 3)){
		instance_create(x, y, Smoke);
	}
	
	 // Explode:
	if(speed == 0 || place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
		instance_destroy();
	}
	
#define MergeFlak_draw
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, rotation, image_blend, image_alpha);
	
#define MergeFlak_hit
	with(other){
		var _hit = 4;
		with(other.inst) if(instance_exists(self)){
			if(other.my_health > 0 && (_hit > 0 || (object_index == CustomProjectile && "name" in self && name == "MergeFlak"))){
				event_perform(ev_collision, hitme);
				if(instance_exists(other)) _hit = 0;
				else _hit--;
			}
		}
	}
	
	 // Slow:
	x -= hspeed_raw / 2;
	y -= vspeed_raw / 2;
	
#define MergeFlak_destroy
	 // Activate Projectiles:
	var _vars = inst_vars;
	with(inst) if(instance_exists(self)){
		image_alpha = abs(image_alpha);
		direction += other.rotation;
		image_angle = direction;
		x = other.x;
		y = other.y;
		
		var _id = string(id);
		if(_id in _vars){
			var v = lq_get(_vars, _id);
			mask_index = v.mask_index;
		}
		
		 // Activate Lasers, Lightning, etc.
		mod_script_call("weapon", "merge", "proj_post", other.flag);
		
		 // Object Specific:
		switch(object_index){
			case Laser:
				sound_play_pitch((skill_get(mut_laser_brain) ? sndLaserUpg : sndLaser), 1 + orandom(0.2));
				break;
				
			case CustomProjectile:
				if("name" in self && name == other.name){
					rotspeed += random_range(12, 16) * choose(-1, 1);
				}
				break;
		}
	}
	
	 // Effects:
	sleep(20);
	view_shake_at(x, y, (array_length(inst) / 2));
	sound_play(sndFlakExplode);
	repeat(6) with(instance_create(x, y, Smoke)){
		motion_add(random(360), random(3));
	}
	with(instance_create(x, y, BulletHit)){
		sprite_index = sprFlakHit;
	}
	
	
#define Pet_create(_x, _y)
	/*
		An NTTE pet object
		Generally don't create this object manually, use 'pet_spawn()' to create pets
	*/
	
	with(instance_create(_x, _y, CustomHitme)){
		 // Visual:
		spr_idle       = spr.PetParrotIdle;
		spr_walk       = spr.PetParrotWalk;
		spr_hurt       = spr.PetParrotHurt;
		spr_dead       = mskNone;
		spr_icon       = -1;
		spr_shadow     = shd24;
		spr_shadow_x   = 0;
		spr_shadow_y   = -1;
		spr_bubble     = sprPlayerBubble;
		spr_bubble_pop = sprPlayerBubblePop;
		spr_bubble_x   = 0;
		spr_bubble_y   = 0;
		hitid          = -1;
		right          = choose(1, -1);
		image_speed    = 0.4;
		depth          = -2;
		
		 // Sound:
		snd_hurt = sndAllyHurt;
		snd_dead = sndAllyDead;
		
		 // Vars:
		mask_index   = mskPlayer;
		direction    = random(360);
		friction     = 0.4;
		leader       = noone;
		can_take     = true;
		can_path     = true;
		path         = [];
		path_dir     = 0;
		path_wall    = [Wall, InvisiWall];
		path_delay   = 0;
		maxhealth    = 0;
		my_health    = 0;
		team         = 0;
		size         = 1;
		push         = 1;
		wave         = random(1000);
		walk         = 0;
		walkspeed    = 2;
		maxspeed     = 3;
		loops        = 0;
		stat         = {};
		stat_found   = true;
		light        = true;
		light_radius = [32, 96]; // [Inner, Outer]
		mask_store   = null;
		portal_angle = 0;
		portal_inst  = noone;
		corpse       = true;
		corpse_inst  = noone;
		revive       = noone;
		history      = ["spr_idle", "spr_walk", "spr_hurt", "spr_dead", "spr_icon", "spr_shadow", "spr_shadow_x", "spr_shadow_y", "spr_bubble", "spr_bubble_pop", "spr_bubble_x", "spr_bubble_y", "hitid", "snd_hurt", "snd_dead", "team", "stat_found"];
		
		 // Prompt:
		prompt = prompt_create("");
		with(prompt){
			mask_index = mskShield;
			icon       = other.spr_icon;
		}
		
		 // Scripts:
		pet      = "";
		mod_type = "";
		mod_name = "";
		
		 // Alarms:
		alarm0 = 20 + random(10);
		
		return id;
	}
	
#define Pet_begin_step
	 // Reset Hitbox:
	if(mask_index == mskNone && mask_store != null){
		mask_index = mask_store;
		mask_store = null;
	}
	
	 // Loading Screen Visual:
	if(instance_exists(SpiralCont) && (instance_exists(GenCont) || instance_exists(LevCont))){
		if(!instance_exists(portal_inst)){
			portal_inst = instance_create(SpiralCont.x, SpiralCont.y, SpiralDebris);
			with(portal_inst){
				sprite_index = other.spr_hurt;
				image_index = 2;
				turnspeed *= 1.5;
				dist /= 2;
				
				if(!in_range(turnspeed, -3, 3)){
					turnspeed /= 2;
				}
				if(in_range(rotspeed, -8, 8)){
					rotspeed += 8 * sign(rotspeed);
				}
			}
		}
		with(portal_inst){
			image_xscale = 0.85 + (0.15 * sin((-image_angle / 2) / 200));
			image_yscale = image_xscale;
			grow = 0;
		}
	}
	
#define Pet_step
	 // Reset Hitbox:
	if(mask_index == mskNone && mask_store != null){
		mask_index = mask_store;
		mask_store = null;
	}
	
	 // Don't Persist to Menu:
	if(instance_exists(Menu)){
		instance_delete(id);
		exit;
	}
	
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Wave:
	wave += current_time_scale;
	
	 // Pathfinding Delay:
	if(path_delay > 0) path_delay -= current_time_scale;
	
	 // Loop HP Scaling:
	if(loops != GameCont.loops){
		maxhealth = round(maxhealth / (1 + (0.5 * loops)));
		loops = GameCont.loops;
		maxhealth = round(maxhealth * (1 + (0.5 * loops)));
	}
	
	 // End of Level Revive:
	if(instance_exists(revive)){
		if(instance_exists(GenCont) || (instance_exists(leader) && instance_exists(Portal))){
			with(revive){
				instance_destroy();
			}
		}
	}
	
	 // Loading/Level Up Screen:
	if((instance_exists(GenCont) && instance_exists(FloorMaker)) || instance_exists(LevCont)){
		visible      = false;
		portal_angle = 0;
		
		 // Follow Player:
		var _inst = (instance_exists(leader) ? leader : instance_nearest(x, y, Player));
		if(instance_exists(_inst)){
			x = _inst.x;
			y = _inst.y;
		}
	}
	
	if(visible){
		 // Movement:
		enemy_walk(walkspeed, maxspeed);
		
		 // Animate:
		var _scrt = pet + "_anim";
		if(mod_script_exists(mod_type, mod_name, _scrt)){ // Custom Animation Event
			mod_script_call(mod_type, mod_name, _scrt);
		}
		else sprite_index = enemy_sprite;
		
		 // Push:
		if(place_meeting(x, y, hitme)){
			if(place_meeting(x, y, enemy)){
				with(instances_meeting(x, y, enemy)){
					if(place_meeting(x, y, other)){
						if(size <= other.size){
							motion_add_ct(point_direction(other.x, other.y, x, y), 1);
						}
						if(size >= other.size){
							with(other){
								motion_add_ct(point_direction(other.x, other.y, x, y), push);
							}
						}
					}
				}
			}
			if(place_meeting(x, y, Player)){
				with(instances_meeting(x, y, instances_matching_ne(Player, "speed", 0))){
					if(place_meeting(x, y, other)){
						if(size - 3 <= other.size){
							motion_add_ct(point_direction(other.x, other.y, x, y), 1);
						}
						if(size - 3 >= other.size){
							with(other){
								motion_add_ct(point_direction(other.x, other.y, x, y), push);
							}
						}
					}
				}
			}
		}
		if(place_meeting(x, y, object_index)){
			with(instances_meeting(x, y, instances_matching_ge(instances_matching(instances_matching(object_index, "name", name), "visible", true), "size", size))){
				if(place_meeting(x, y, other)){
					with(other){
						motion_add_ct(point_direction(other.x, other.y, x, y), push);
					}
				}
			}
		}
		
		 // Custom Step Event:
		var _scrt = pet + "_step";
		if(mod_script_exists(mod_type, mod_name, _scrt)){
			mod_script_call(mod_type, mod_name, _scrt);
		}
	}
	else walk = 0;
	
	 // Death:
	if(maxhealth > 0 && my_health <= 0){
		if(revive == noone){
			revive = obj_create(x, y, "PetRevive");
			with(revive){
				creator = other;
				
				 // Unowned:
				if(!instance_exists(other.leader)){
					damage = 0;
				}
				
				 // Text:
				var _text = "";
				with(other.prompt){
					_text = text;
				}
				with(prompt){
					if(other.damage > 0){
						draw_set_font(fntM);
						
						var	_name          = other.creator.pet,
							_nameLength    = string_length(string_delete_nt(_name)),
							_prenameLength = string_length(string_delete_nt(string_copy(_text, 1, string_pos(_name, _text) - 1))),
							_reviveLength  = string_length(string_delete_nt(text));
							
						_text += "#" + string_repeat(" ", _prenameLength + (_reviveLength - _nameLength)) + text;
					}
					text = _text;
				}
			}
			
			 // Push:
			motion_add(
				direction + orandom(20),
				speed * 2
			);
			
			 // Truly Dead:
			if(corpse && !instance_exists(corpse_inst)){
				corpse_inst = corpse_drop(direction, speed);
			}
			sound_play_hit(snd_dead, 0.3);
			sprite_index = spr_hurt;
			image_index  = 0;
			
			 // Custom Death Event:
			var _scrt = pet + "_death";
			if(mod_script_exists(mod_type, mod_name, _scrt)){
				mod_script_call(mod_type, mod_name, _scrt);
			}
		}
	}
	else{
		 // Destroy Revive:
		if(revive != noone){
			with(revive) instance_destroy();
			revive = noone;
		}
		
		 // Destroy Corpse:
		if(corpse_inst != noone){
			with(corpse_inst){
				repeat(2){
					scrFX([x, 4], [y, 4], 0, Smoke);
				}
				instance_destroy();
			}
			corpse_inst = noone;
		}
	}
	
	 // Portal Attraction:
	var _spin = 0;
	if(visible || instance_exists(revive)){
		with(instances_matching_ne(Portal, "sprite_index", sprPortalSpawn, sprBigPortalSpawn)){
			if(instance_near(x, y, other, 64) || (object_index == BigPortal && timer > 30)){
				if(instance_seen(x, y, other)){
					with(other){
						var	_l = 4 * current_time_scale,
							_d = point_direction(x, y, other.x, other.y),
							_x = x + lengthdir_x(_l, _d),
							_y = y + lengthdir_y(_l, _d)
							
						if(place_free(_x, y)) x = _x;
						if(place_free(x, _y)) y = _y;
						_spin = (30 * right);
					}
				}
			}
		}
		
		 // Enter:
		if(place_meeting(x, y, Portal)){
			repeat(3) instance_create(x, y, Dust);
			with(revive) instance_destroy();
			visible    = false;
			persistent = true;
		}
	}
	
	 // Portal Spin:
	if(_spin != 0){
		portal_angle += _spin;
		sprite_index = spr_hurt;
		image_index = 1;
		
		 // No Escape:
		speed -= min(speed, friction_raw * 3);
		walk = 0;
	}
	else if(portal_angle != 0){
		portal_angle = ((portal_angle % 360) + 360) % 360;
		portal_angle -= portal_angle * 0.2 * current_time_scale;
	}
	
	 // Player Owns Pet:
	if(instance_exists(leader)){
		can_take   = false;
		persistent = true;
		
		 // Check if Target in Line of Sight:
		var	_xtarget    = leader.x,
			_ytarget    = leader.y,
			_targetSeen = true;
			
		for(var i = 0; i < array_length(path_wall); i++){
			var _wall = path_wall[i];
			if(collision_line(x, y, _xtarget, _ytarget, _wall, false, false)){
				_targetSeen = false;
				break;
			}
		}
		
		 // Create Path:
		if(visible && can_path && !_targetSeen){
			if(!path_reaches(path, _xtarget, _ytarget, path_wall)){
				if(path_delay <= 0){
					path_delay = 300;
					path = path_create(x, y, _xtarget, _ytarget, path_wall);
					path = path_shrink(path, path_wall, 10);
				}
			}
			else path_delay = 0;
		}
		else{
			path = [];
			path_delay = 0;
		}
		
		 // Breadcrumbs:
		if(array_length(path) > 2 && (wave % 90) < 60 && chance_ct(1, 15 / maxspeed)){
			var	i = round((wave / 10) % array_length(path)),
				_x1 = ((i > 0) ? path[i - 1, 0] : x),
				_y1 = ((i > 0) ? path[i - 1, 1] : y),
				_x2 = ((i < array_length(path)) ? path[i, 0] : leader.x),
				_y2 = ((i < array_length(path)) ? path[i, 1] : leader.y);
				
			with(instance_create(lerp(_x1, _x2, random(1)) + orandom(4), lerp(_y1, _y2, random(1)) + orandom(4), Dust)){
				motion_set(point_direction(x, y, _x2, _y2) + orandom(20), min(random_range(1, 5), point_distance(x, y, _x2, _y2) / 3));
			}
		}
		
		 // Time Stat:
		if(
			instance_is(leader, Player)
			&& array_exists(leader.ntte_pet, id)
			&& "owned" in stat
		){
			stat.owned += (current_time_scale / 30);
		}
	}
	
	 // No Owner:
	else{
		 // Leader Died or Something:
		if(leader != noone){
			leader   = noone;
			can_take = true;
		}
		
		 // Looking for a home:
		if(visible){
			persistent = false;
			
			if(can_take && instance_exists(prompt)){
				with(player_find(prompt.pick)){
					var _max = array_length(ntte_pet);
					if(_max > 0){
						 // Remove Oldest Pet:
						for(var i = _max - 1; i >= 0; i--){
							if(!instance_exists(ntte_pet[i]) || i == 0){
								with(ntte_pet[i]){
									leader = noone;
									can_take = true;
									
									 // Effects:
									with(instance_create(x + hspeed, y + vspeed, HealFX)){
										sprite_index = spr.PetLost;
										image_xscale = choose(-1, 1);
										image_speed = 0.5;
										friction = 1/8;
										depth = -9;
									}
								}
								ntte_pet = array_delete(ntte_pet, i);
								break;
							}
						}
						
						 // Add New Pet:
						array_push(ntte_pet, other);
						with(other){
							leader = other;
							direction = point_direction(x, y, other.x, other.y);
							
							 // Found Stat:
							if(stat_found){
								stat_found = false;
								if("found" in stat) stat.found++;
							}
						}
						
						 // Effects:
						with(instance_create(x, y, WepSwap)){
							sprite_index = ((skill_get("compassion") > 0) ? sprHealBigFX : sprHealFX);
							creator = other;
						}
						sound_play(sndHealthChestBig);
						sound_play(sndHitFlesh);
					}
				}
			}
		}
	}
	with(prompt){
		visible = other.can_take;
		
		 // Update Icon:
		if("icon" in self && icon != other.spr_icon){
			text = string_replace(text, string(icon), string(other.spr_icon));
			icon = other.spr_icon;
		}
	}
	
	if(visible || instance_exists(revive)){
		 // Allied:
		if(instance_exists(leader)){
			team = leader.team;
		}
		
		 // Dodge Collision:
		if(maxhealth <= 0){
			if(place_meeting(x, y, projectile) || place_meeting(x, y, Explosion) || place_meeting(x, y, PlasmaImpact) || place_meeting(x, y, MeatExplosion)){
				with(instances_matching_ne(instances_meeting(x, y, [projectile, Explosion, PlasmaImpact, MeatExplosion]), "team", team)){
					if(place_meeting(x, y, other)) with(other){
						Pet_hurt(
							other.damage,
							other.force,
							point_direction(other.x, other.y, x, y)
						);
					}
				}
			}
		}
		
		 // Wall Collision:
		if(visible || instance_exists(revive)){
			motion_step(1);
			
			with(path_wall){
				var _walled = false;
				with(other){
					if(place_meeting(x, y, other)){
						_walled = true;
						
						x = xprevious;
						y = yprevious;
						
						var	_mx = 1,
							_my = 1;
							
						with(path_wall) with(other){
							for(var _mx; _mx >= 0; _mx -= 0.5){
								if(!place_meeting(x + (hspeed_raw * _mx), y, other)){
									break;
								}
							}
							for(var _my; _my >= 0; _my -= 0.5){
								if(!place_meeting(x, y + (vspeed_raw * _my), other)){
									break;
								}
							}
						}
						
						hspeed_raw *= max(0, _mx);
						vspeed_raw *= max(0, _my);
						x += hspeed_raw;
						y += vspeed_raw;
					}
				}
				if(_walled) break;
			}
			
			motion_step(-1);
		}
	}
	
	 // Disabling Collision to Avoid Projectiles:
	if(my_health <= 0){
		mask_store = mask_index;
		mask_index = mskNone;
	}
	
#define Pet_end_step
	 // Reset Hitbox:
	if(mask_index == mskNone && mask_store != null){
		mask_index = mask_store;
		mask_store = null;
	}
	
	/*
	 // Custom End Step Event:
	var _scrt = pet + "_end_step";
	if(mod_script_exists(mod_type, mod_name, _scrt)){
		mod_script_call(mod_type, mod_name, _scrt);
	}
	*/
	
#define Pet_draw
	 // Outline Setup:
	var _outline = (
		option_get("outline:pets")
		&& instance_exists(leader)
		&& !instance_exists(revive)
		&& player_is_local_nonsync(player_find_local_nonsync())
	);
	if(_outline){
		var	_surfScreen = surface_setup("PetScreen", game_width, game_height, game_scale_nonsync),
			_surfPet    = surface_setup("Pet",       game_width, game_height, option_get("quality:main"));
			
		with([_surfScreen, _surfPet]){
			x = view_xview_nonsync;
			y = view_yview_nonsync;
			
			 // Clear:
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			surface_reset_target();
		}
		
		 // Copy & Clear Screen:
		with(_surfScreen){
			draw_set_blend_mode_ext(bm_one, bm_zero);
			surface_screenshot(surf);
			draw_set_alpha(0);
			draw_surface_scale(surf, x, y, 1 / scale);
			draw_set_alpha(1);
			draw_set_blend_mode(bm_normal);
		}
	}
	
	 // Draw:
	var	_scr = pet + "_draw",
		_spr = sprite_index,
		_img = image_index,
		_x   = x,
		_y   = y,
		_xsc = image_xscale * right,
		_ysc = image_yscale,
		_ang = image_angle + (((portal_angle % 360) + 360) % 360),
		_col = image_blend,
		_alp = image_alpha * (instance_exists(revive) ? 0.4 : 1);
		
	if(mod_script_exists(mod_type, mod_name, _scr)){
		mod_script_call(mod_type, mod_name, _scr, _spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	}
	else draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	
	 // Draw Outline:
	if(_outline){
		with(_surfPet){
			 // Copy Pet Drawing & Redraw Old Screen:
			draw_set_blend_mode_ext(bm_one, bm_zero);
			surface_screenshot(surf);
			with(_surfScreen){
				draw_surface_scale(surf, x, y, 1 / scale);
			}
			draw_set_blend_mode(bm_normal);
			
			 // Outline:
			draw_set_fog(true, player_get_color(other.leader.index), 0, 0);
			for(var a = 0; a < 360; a += 90){
				draw_surface_scale(surf, x + dcos(a), y - dsin(a), 1 / scale);
			}
			draw_set_fog(false, 0, 0, 0);
			
			 // Self:
			draw_surface_scale(surf, x, y, 1 / scale);
		}
	}
	
#define Pet_alrm0
	alarm0 = 30;
	
	if(visible){
		 // Where leader be:
		var	_leaderDir = 0,
			_leaderDis = 0;
			
		if(instance_exists(leader)){
			_leaderDir = point_direction(x, y, leader.x, leader.y);
			_leaderDis = point_distance(x, y, leader.x, leader.y);
		}
		
		 // Find Current Path Direction:
		path_dir = path_direction(path, x, y, path_wall);
		
		 // Custom Alarm Event:
		var _scrt = pet + "_alrm0";
		if(mod_script_exists(mod_type, mod_name, _scrt)){
			var a = mod_script_call(mod_type, mod_name, _scrt, _leaderDir, _leaderDis);
			if(is_real(a) && a != 0) alarm0 = a;
		}
		
		 // Default:
		else{
			 // Follow Leader Around:
			if(instance_exists(leader)){
				if(_leaderDis > 24){
					 // Pathfinding:
					if(path_dir != null){
						scrWalk(path_dir + orandom(20), 8);
						alarm0 = walk;
					}
					
					 // Move Toward Leader:
					else{
						scrWalk(_leaderDir + orandom(10), 10);
						alarm0 = 10 + random(5);
					}
				}
			}
			
			 // Wander:
			else scrWalk(random(360), 15);
		}
	}
	
#define Pet_hurt(_hitdmg, _hitvel, _hitdir)
	if(visible && !instance_is(other, Corpse)){
		var _scrt = pet + "_hurt";
		
		 // Hurt:
		if(my_health > 0){
			if(!instance_is(other, Debris)){
				 // Manual debris exit cause debris don't call on_hurt correctly:
				if(other == self && _hitvel == 0 && _hitdir == 0){
					if(place_meeting(x, y, Debris)){
						with(instances_meeting(x, y, instances_matching_ge(instances_matching_gt(Debris, "speed", 2), "size", size - 1))){
							if(place_meeting(x, y, other)){
								if(_hitdmg == round(1 + (speed / 10))){
									exit;
								}
							}
						}
					}
				}
				
				 // Custom Hurt Event:
				if(mod_script_exists(mod_type, mod_name, _scrt)){
					mod_script_call(mod_type, mod_name, _scrt, _hitdmg, _hitvel, _hitdir);
				}
				
				 // Default:
				else enemy_hurt(_hitdmg, _hitvel, _hitdir);
			}
		}
		
		 // Dodge:
		else if(maxhealth <= 0){
			if(sprite_index != spr_hurt){
				if(_hitvel > 0 && (speed > 0 || !instance_is(self, projectile))){
					 // Custom Dodge Event:
					if(mod_script_exists(mod_type, mod_name, _scrt)){
						mod_script_call(mod_type, mod_name, _scrt, _hitdmg, _hitvel, _hitdir);
					}
					
					 // Default:
					else{
						sprite_index = spr_hurt;
						image_index = 0;
					}
				}
			}
		}
	}
	
#define Pet_cleanup
	 // Custom Cleanup Event:
	var _scrt = pet + "_cleanup";
	if(mod_script_exists(mod_type, mod_name, _scrt)){
		mod_script_call(mod_type, mod_name, _scrt);
	}
	
	 // Add to Pet History (MutantVats Event):
	if(!stat_found && array_length(history) > 0){
		var _vars = {};
		with(history){
			if(self in other){
				lq_set(_vars, self, variable_instance_get(other, self));
			}
		}
		ds_list_add(global.pet_history, [pet, mod_type, mod_name, _vars]);
	}
	
	
#define PetRevive_create(_x, _y)
	/*
		The death controller object for Pets
		Handles the visuals and prompt for dead Pets
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		depth = -5;
		
		 // Vars:
		damage     = 1;
		creator    = noone;
		persistent = true;
		
		 // Prompt:
		prompt = prompt_create(`@rREVIVE`);
		with(prompt){
			mask_index = mskReviveArea; // revive hahahahoho
		}
		
		return id;
	}
	
#define PetRevive_step
	if(instance_exists(creator)){
		creator.visible = false;
		
		 // Spinny:
		creator.x += (sin(current_frame / 10) / 3) * current_time_scale;
		creator.y += (cos(current_frame / 10) / 3) * current_time_scale;
		x = creator.x;
		y = creator.y;
		
		 // Revive:
		if(instance_exists(prompt) && player_is_active(prompt.pick)){
			 // Damage:
			if(damage > 0){
				with(player_find(prompt.pick)){
					with(other) projectile_hit_raw(other, damage, true);
					lasthit = [sprHealBigFX, "LOVE"];
				}
				
				 // FX:
				with(creator){
					 // Visual:
					sprite_index = spr_hurt;
					image_index = 0;
					with(instance_create(x, y, HealFX)){
						depth = other.depth - 1;
					}
					
					 // Sound:
					sound_play_hit(snd_hurt, 0.2);
					sound_play(sndHealthChestBig);
				}
			}
			
			 // Friendify:
			var _prompt = prompt;
			with(creator) with(prompt){
				pick = _prompt.pick;
			}
			
			instance_destroy();
		}
	}
	else instance_destroy();
	
#define PetRevive_draw
	with(creator){
		event_perform(ev_draw, 0);
	}
	
#define PetRevive_destroy
	with(creator){
		visible   = true;
		my_health = maxhealth;
	}
	
	
#define PetWeaponBecome_create(_x, _y)
	/*
		The pet weapon boss chest, press E to fight bro
	*/
	
	with(instance_create(_x, _y, chestprop)){
		 // Visual:
		sprite_index = spr.PetWeaponChst;
		 
		 // Vars:
		type = choose(type_melee, type_bullet, type_shell, type_bolt, type_explosive, type_energy);
		
		 // Prompt:
		prompt = prompt_create("BATTLE");
		with(prompt){
			yoff = -1;
		}
		
		 // Curse:
		switch(crown_current){
			case crwn_none   : curse = false;        break;
			case crwn_curses : curse = chance(2, 3); break;
			default          : curse = chance(1, 7);
		}
		
		return id;
	}
	
#define PetWeaponBecome_step
	 // Cursed:
	if(curse && sprite_index == spr.PetWeaponChst){
		sprite_index = spr.PetWeaponChstCursed;
	}
	
	 // Activated:
	if(instance_exists(prompt) && player_is_active(prompt.pick)){
		with(obj_create(x, y, "PetWeaponBoss")){
			type  = other.type;
			curse = other.curse;
			
			 // Push Away:
			with(player_find(other.prompt.pick)){
				with(other){
					motion_add(point_direction(other.x, other.y, x, y), 3);
				}
			}
		}
		GameCont.nochest = 0;
		portal_poof();
		
		instance_destroy();
	}
	
	
#define PetWeaponBoss_create(_x, _y)
	/*
		The pet weapon boss bro
		Has an AI variant for each weapon type, with 3 possible weapons for each variant (1 standard, 1 loop, and 1 rare)
		Becomes a pet when killed
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		boss = true;
		
		 // For Sani's bosshudredux:
		bossname = "WEAPON MIMIC";
		col      = c_red;
		
		 // HP:
		maxhealth = boss_hp(120);
		var _hp = maxhealth;
		
		 // Stats:
		var s = "pet:Weapon.petlib.mod";
		if(!is_object(stat_get(s))){
			stat_set(s, { found:0, owned:0 });
		}
		stat = stat_get(s);
		
		 // Base Code:
		history = [];
		mod_script_call("mod", "petlib", "Weapon_create");
		
		 // Visual:
		spr_idle     = spr.PetWeaponIdle;
		spr_walk     = spr.PetWeaponWalk;
		spr_hurt     = spr.PetWeaponHurt;
		spr_dead     = spr.PetWeaponDead;
		spr_icon     = spr.PetWeaponIcon;
		spr_shadow   = shd24;
		spr_shadow_y = -1;
		depth        = -2;
		
		 // Vars:
		mask_index  = mskFreak;
		maxhealth   = _hp;
		size        = 1;
		walk        = 0;
		walkspeed   = 2;
		maxspeed    = 3;
		intro       = false;
		corpse      = false;
		path        = [];
		path_delay  = 0;
		cover_x     = x;
		cover_y     = y;
		cover_peek  = false;
		cover_delay = 0;
		stat_battle = true;
		
		 // Alarms:
		alarm1 = 60;
		alarm2 = reload;
		
		return id;
	}
	
#define PetWeaponBoss_step
	 // Alarms:
	if(alarm1_run) exit;
	if(alarm2_run) exit;
	
	 // Timers:
	if(path_delay  > 0) path_delay -= current_time_scale;
	if(cover_delay > 0) cover_delay -= current_time_scale;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Base Code:
	mod_script_call("mod", "petlib", "Weapon_anim");
	mod_script_call("mod", "petlib", "Weapon_step");
	
	 // Boss Intro:
	if(!intro && sprite_index != spr_hide && sprite_index != spr_spwn){
		intro = true;
		boss_intro(curse ? "PetWeaponCursed" : "PetWeapon");
		sound_play(curse ? sndBigCursedChest : sndBigWeaponChest);
	}
	
	 // Laser Cannon:
	with(instances_matching(LaserCannon, "creator", id)){
		time = 1 + floor(abs(angle_difference(other.gunangle, other.gunangle_goal)) / 4);
	}
	with(instances_matching(instances_matching(Laser, "creator", id), "petweaponbosslaser_check", null)){
		petweaponbosslaser_check = true;
		image_yscale = 1.4;
		hitid = other.hitid;
		team_instance_sprite(1, self);
	}
	
	 // Weapon Win:
	if(!instance_exists(Player) && stat_battle){
		stat_battle = false;
		stat.battle[1]++;
		alarm1 = max(alarm1, 60);
	}
	
#define PetWeaponBoss_draw
	mod_script_call("mod", "petlib", "Weapon_draw", sprite_index, image_index, x, y, image_xscale * right, image_yscale, image_angle, image_blend, image_alpha);
	
#define PetWeaponBoss_alrm1
	alarm1 = 10 + random(30);
	
	if(sprite_index != spr_hide && sprite_index != spr_spwn){
		if(enemy_target(x, y)){
			var	_tx = target.x,
				_ty = target.y,
				_targetDir = point_direction(x, y, _tx, _ty),
				_pathWall = Wall,
				_pathX = null,
				_pathY = null;
				
			switch(type){
				case type_melee: // MELEE
					
					 // Movement:
					if(instance_seen(x, y, target)){
						scrWalk(_targetDir + choose(-60, 60), 5 + random(10));
						alarm1 = walk;
					}
					
					 // Find Player:
					else{
						_pathX = _tx;
						_pathY = _ty;
					}
					
					 // Avoid:
					with(instances_matching_ne(instances_matching(projectile, "typ", 1), "team", team)){
						if(abs(angle_difference(other.gunangle, point_direction(other.x, other.y, x, y))) < 60){
							if(instance_near(x, y, other, 96)){
								other.direction += 180;
								break;
							}
						}
					}
					
					break;
					
				case type_shell: /// CLOSE RANGE
					
					 // Movement:
					if(instance_seen(x, y, target)){
						scrWalk(gunangle + orandom(60), 20);
						alarm1 = walk;
					}
					
					 // Find Player:
					else{
						_pathX = _tx;
						_pathY = _ty;
					}
					
					break;
					
				case type_bolt: /// LONG RANGE + COVER
				
					 // Go to Cover:
					if(cover_delay > 0 || PetWeaponBoss_point_is_cover(cover_x, cover_y, _tx, _ty)){
						if(point_distance(x, y, cover_x, cover_y) > 8 || cover_peek){
							 // Cover in Sight:
							if(!collision_line(x, y, cover_x, cover_y, Wall, false, false)){
								scrWalk(point_direction(x, y, cover_x, cover_y), (cover_peek ? [5, 10] : 1));
								alarm1 = (cover_peek ? random_range(walk, 30) : walk);
								cover_peek = false;
							}
							
							 // Pathfind to Cover:
							else{
								_pathX = cover_x;
								_pathY = cover_y;
							}
						}
						
						 // Peek Out of Cover:
						else{
							cover_peek = true;
							gunangle_goal = _targetDir;
							
							alarm1 = 15;
							alarm2 = alarm1 - random(3);
							
							 // Peekin:
							var	_l = 16,
								_d = pround(point_direction(cover_x, cover_y, _tx, _ty), 90),
								_peekLeft  = !collision_line(cover_x + lengthdir_x(_l, _d - 90), cover_y + lengthdir_y(_l, _d - 90), _tx, _ty, Wall, false, false),
								_peekRight = !collision_line(cover_x - lengthdir_x(_l, _d - 90), cover_y - lengthdir_y(_l, _d - 90), _tx, _ty, Wall, false, false),
								_peekSide = sign(_peekRight - _peekLeft);
								
							scrWalk(_d + (90 * ((_peekSide == 0) ? choose(-1, 1) : _peekSide)), 4);
							
							 // Stay in Cover:
							if(_peekRight || _peekLeft){
								cover_delay = random_range(60, 90);
							}
						}
					}
					
					 // Find Cover:
					else{
						cover_x = _tx;
						cover_y = _ty;
						cover_peek = false;
						cover_delay = 30;
						
						scrWalk(point_direction(_tx, _ty, x, y), 15);
						alarm1 = walk;
						
						var	_coverDisMax = null,
							_targetDisMin = null;
							
						with(instance_rectangle_bbox(_tx - shootdis_max, _ty - shootdis_max, _tx + shootdis_max, _ty + shootdis_max, Floor)){
							for(var _x = bbox_left; _x < bbox_right + 1; _x += 16){
								for(var _y = bbox_top; _y < bbox_bottom + 1; _y += 16){
									var	_cx = _x + 8,
										_cy = _y + 8,
										_coverDis = point_distance(_cx, _cy, other.x, other.y),
										_targetDis = point_distance(_cx, _cy, _tx, _ty);
										
									if((is_undefined(_coverDisMax) || _coverDis < _coverDisMax) && (is_undefined(_targetDisMin) || _targetDis > _targetDisMin)){
										with(other) if(PetWeaponBoss_point_is_cover(_cx, _cy, _tx, _ty)){
											_coverDisMax = _coverDis;
											_targetDisMin = _targetDis;
											cover_x = _cx;
											cover_y = _cy;
										}
									}
								}
							}
						}
					}
					
					break;
					
				case type_energy: /// BIG FIREPOWER, LOW MOVEMENT
				
					 // Movement:
					if(instance_seen(x, y, target)){
						if(instance_near(x, y, target, shootdis_max)){
							if(chance(1, 3)){
								scrWalk(random(360), random_range(5, 20));
							}
						}
						else{
							scrWalk(gunangle, 20);
							alarm1 = walk;
						}
					}
					
					 // Find Player:
					else{
						_pathX = _tx;
						_pathY = _ty;
					}
					
					break;
					
				default: /// DEFAULT
				
					 // Movement:
					if(instance_seen(x, y, target)){
						if(instance_near(x, y, target, shootdis_max * 2/3)){
							scrWalk(_targetDir + (90 * sign(angle_difference(direction, _targetDir))), 15);
						}
						else{
							scrWalk(gunangle, 20);
						}
						alarm1 = walk;
					}
					
					 // Find Player:
					else{
						_pathX = _tx;
						_pathY = _ty;
					}
					
					break;
			}
			
			 // Pathfind:
			if(is_real(_pathX) && is_real(_pathY)){
				 // Create Path:
				if(path_delay <= 0 && !path_reaches(path, _pathX, _pathY, _pathWall)){
					path = path_create(x, y, _pathX, _pathY, _pathWall);
					path = path_shrink(path, _pathWall, 2);
					path_delay = 30;
				}
				
				 // Follow Path:
				var _pathDir = path_direction(path, x, y, _pathWall);
				if(_pathDir != null){
					scrWalk(_pathDir, [1, 5]);
					alarm1 = walk;
					
					 // Searching:
					if(!instance_seen(x, y, target)){
						if(abs(angle_difference(gunangle_goal, _pathDir)) > 60){
							gunangle_goal = _pathDir + orandom(60);
						}
						if(instance_near(x, y, target, 64)){
							alarm1 += random(random(random(30)));
							gunangle_goal = angle_lerp(gunangle_goal, _targetDir, 1/2);
						}
					}
				}
				else path = [];
			}
			else path = [];
		}
		
		 // Hide:
		else{
			sprite_index = spr_hide;
			image_index = 0;
			//scrWalk(random(360), [15, 30]);
			//gunangle_goal = direction;
		}
	}
	
#define PetWeaponBoss_alrm2
	alarm2 = 30;
	
	 // Shootin:
	if(sprite_index != spr_spwn){
		if(
			enemy_target(x, y)
			&& instance_seen(x, y, target)
			&& instance_near(x, y, target, shootdis_max)
		){
			if(abs(angle_difference(gunangle, point_direction(x, y, target.x, target.y))) < 30){
				var _shot = false;
				with(["", "b"]){
					var b = self;
					with(other){
						var	_wep      = variable_instance_get(self, b + "wep"),
							_reload   = variable_instance_get(self, b + "reload"),
							_canShoot = variable_instance_get(self, b + "can_shoot");
							
						if(_canShoot <= 0 && _wep != wep_none && _reload <= 0){
							if(
								(!weapon_get_laser_sight(_wep) && !instance_near(x, y, target, shootdis_min))
								||
								variable_instance_get(self, b + "wep_laser") >= 1
							){
								_shot = true;
								_canShoot = 1;
								
								 // Fire Multiple Times:
								var _wepLoad = weapon_get_load(_wep);
								if(weapon_get_auto(_wep) || _wepLoad <= 10){
									_canShoot += floor(random(30) / _wepLoad);
								}
								if(type == type_explosive || _wep == wep_jackhammer){
									_canShoot += irandom(ceil(3 * (1 - (my_health / maxhealth))));
								}
								
								 // Shooting Delay:
								alarm2 = 30 + (_canShoot * _wepLoad);
								switch(type){
									case type_melee:
										alarm2 += 15 + (30 * (wep == wep_jackhammer));
										break;
										
									case type_shell: // Warning
										_reload = 9;
										with(alert_create(self, spr_icon)){
											alert.x--;
											flash = 2;
											blink = 10;
											alarm0 = _reload + 5;
											snd_flash = sndShotReload;
										}
										break;
										
									case type_energy:
										alarm2 += random(30);
										break;
								}
							}
						}
						
						variable_instance_set(self, b + "reload",    _reload);
						variable_instance_set(self, b + "can_shoot", _canShoot);
					}
					if(_shot) break;
				}
			}
		}
	}
	
#define PetWeaponBoss_hurt(_hitdmg, _hitvel, _hitdir)
	if(type == type_melee || type == type_shell){
		_hitdir = angle_lerp(_hitdir, _hitdir + 180, random_range(0.5, 1));
	}
	enemy_hurt(_hitdmg, _hitvel, _hitdir);
	
#define PetWeaponBoss_death
	 // Boss Win Music:
	with(MusCont){
		var _area = GameCont.area;
		GameCont.area = -1;
		event_perform(ev_alarm, 11);
		GameCont.area = _area;
		alarm_set(1, 1);
	}
	
	 // Player Win:
	if(stat_battle){
		stat_battle = false;
		stat.battle[0]++;
	}
	
	 // Pet Time:
	with(pet_spawn(x, y, "Weapon")){
		direction = other.direction;
		speed = other.speed;
		wep = other.wep;
		bwep = other.bwep;
		curse = other.curse;
		my_health = 0;
	}
	
#define PetWeaponBoss_point_is_cover(_coverX, _coverY, _fromX, _fromY)
	if(in_range(point_distance(_coverX, _coverY, _fromX, _fromY), shootdis_min, shootdis_max)){
		if(collision_line(_coverX, _coverY, _fromX, _fromY, Wall, false, false)){
			if(!position_meeting(_coverX, _coverY, Wall)){
				var	_l = 16,
					_d = pround(point_direction(_coverX, _coverY, _fromX, _fromY), 90);
					
				if(
					position_meeting(_coverX + lengthdir_x(_l, _d),      _coverY + lengthdir_y(_l, _d),      Wall) ||
					position_meeting(_coverX + lengthdir_x(_l, _d - 90), _coverY + lengthdir_y(_l, _d - 90), Wall) ||
					position_meeting(_coverX + lengthdir_x(_l, _d + 90), _coverY + lengthdir_y(_l, _d + 90), Wall)
				){
					if(
						!collision_line(_coverX + lengthdir_x(_l, _d - 90), _coverY + lengthdir_y(_l, _d - 90), _fromX, _fromY, Wall, false, false) ||
						!collision_line(_coverX - lengthdir_x(_l, _d - 90), _coverY - lengthdir_y(_l, _d - 90), _fromX, _fromY, Wall, false, false)
					){
						return true;
					}
				}
			}
		}
	}
	return false;
	
	
#define PortalBullet_create(_x, _y)
	/*
		A projectile that teleports its creator to itself when destroyed
		Also teleports non-prop hitmes that it damages to its creator's position, basically swapping their positions
	*/
	
	with(instance_create(_x, _y, CustomProjectile)){
		 // Visual:
		spr_spwn     = spr.PortalBulletSpawn;
		spr_idle     = spr.PortalBullet;
		sprite_index = spr_spwn;
		image_speed  = 0.4;
		depth        = -5;
		
		 // Vars:
		mask_index = mskNone;
		mask       = mskSuperFlakBullet;
		damage     = 2;
		force      = 0;
		typ        = 1;
		offset     = 12;
		creator    = noone;
		portal     = false;
		hold       = true;
		spec       = false;
		roids      = false;
		
		return id;
	}
	
#define PortalBullet_anim
	if(sprite_index == spr_spwn){
		sprite_index = spr_idle;
		mask_index   = mask;
		
		 // FX:
		var _snd = audio_play_sound(sndGuardianHurt, 0, false);
		audio_sound_pitch(_snd, 0.4 + random(0.1));
		audio_sound_gain(_snd, 0.3, 0);
		repeat(3){
			scrFX(x, y, 3, Smoke);
		}
	}
	
#define PortalBullet_step
	 // Charging:
	if(hold){
		 // Hold Still:
		var _wep = variable_instance_get(creator, (roids ? "b" : "") + "wep");
		if(
			sprite_index == spr_spwn
			|| (
				instance_is(creator, Player)
				&& creator.visible
				&& array_length(instances_matching(CrystalShield, "creator", creator)) <= 0
				&& button_check(creator.index, (spec ? "spec" : "fire"))
				&& is_object(_wep)
				&& is_array(lq_get(_wep, "inst"))
				&& array_exists(_wep.inst, id)
			)
		){
			if(instance_exists(creator)){
				var _lastMask = mask_index;
				mask_index = mskAlly;
				
				x = creator.x;
				y = creator.y;
				move_contact_solid(
					direction,
					offset - variable_instance_get(creator, (roids ? "b" : "") + "wkick", 0)
				);
				
				mask_index = _lastMask;
			}
			motion_step(-1);
		}
		
		 // Fire:
		else{
			hold = false;
			
			 // FX:
			var _kick = (roids ? "b" : "") + "wkick";
			if(_kick in creator){
				variable_instance_set(creator, _kick, 10);
			}
			sound_play_pitch(sndGuardianHurt, 1.5 + orandom(0.2));
			repeat(5) scrFX(x, y, [direction + orandom(60), 3], Dust);
		}
	}
	
	 // Slow Down:
	else{
		var	_slowMax = 0.5,
			_slowDis = 32;
			
		if(distance_to_object(hitme) < _slowDis){
			with(instance_rectangle_bbox(x - _slowDis, y - _slowDis, x + _slowDis, y + _slowDis, instances_matching_gt(instances_matching(hitme, "team", team), "size", 0))){
				if(_slowMax > 0){
					if(distance_to_object(other) < _slowDis){
						var _slow = min(_slowMax, size / 20);
						with(other){
							_slowMax -= _slow;
							x -= hspeed_raw * _slow;
							y -= vspeed_raw * _slow;
						}
					}
				}
				else break;
			}
		}
	}
	
	 // FX:
	if(chance_ct(1, 15)){
		with(instance_create(x + hspeed_raw, y + vspeed_raw, PortalL)){
			depth = other.depth + choose(0, -1);
		}
	}
	
#define PortalBullet_hit
	if(projectile_canhit(other) && other.my_health > 0){
		if(instance_is(creator, Player) || (!instance_is(other, prop) && other.team != 0)){
			projectile_hit_push(other, damage, force);
			
			 // Portal:
			var _portal = (portal && instance_is(other, Player));
			if(_portal){
				with(creator){
					speed     = 0;
					my_health = 0;
				}
			}
			
			 // Swap Positions:
			with(other){
				if(size < 6){
					if(
						(!instance_is(self, prop) && team != 0)
						|| instance_is(self, RadChest)
						|| instance_is(self, Car)
						|| instance_is(self, CarVenus)
						|| instance_is(self, CarVenusFixed)
						|| instance_is(self, CarThrow)
						|| instance_is(self, MeleeFake)
						|| instance_is(self, JungleAssassinHide)
					){
						if(instance_exists(other.creator)){
							x = other.creator.x;
							y = other.creator.y;
						}
						else{
							x = other.xstart;
							y = other.ystart;
						}
						xprevious = x;
						yprevious = y;
						
						 // Effects:
						with(instance_create(x, y, BulletHit)){
							sprite_index = sprPortalDisappear;
							depth        = other.depth - 1;
							image_angle  = 0;
						}
						repeat(3) scrFX(x, y, 2, Smoke);
						sound_play_hit_ext(sndPortalAppear, 2.5, 2);
						
						 // Just in Case:
						wall_clear(x, y);
					}
				}
			}
			
			 // Portal:
			if(_portal){
				instance_destroy();
				if(instance_exists(other)){
					instance_create(other.x, other.y, Portal);
				}
			}
			
			 // Death:
			else instance_destroy();
		}
	}
	
#define PortalBullet_destroy
	repeat(5) scrFX(x, y, [direction, 2], Smoke);
	sound_play_hit_ext(sndGuardianDisappear, 2, 2);
	
	 // Teleport:
	if(
		instance_exists(creator)
		&& (creator.visible || ("wading" in creator && creator.wading > 0))
		&& (
			position_meeting(x, y, Floor) ||
			place_meeting(x, y, Floor)    ||
			(instance_near(x, y, creator, 512) && instance_seen(x, y, creator) && !collision_line(x, y, creator.x, creator.y, InvisiWall, false, false))
		)
	){
		with(creator){
			 // Disappear:
			if("name" in self && name == "PortalGuardian"){
				with(instance_create(x, y, BulletHit)){
					sprite_index = other.spr_disappear;
					image_xscale = other.image_xscale * other.right;
					image_yscale = other.image_yscale;
					image_angle  = other.image_angle;
					depth        = other.depth - 1;
				}
			}
			else with(instance_create(x, y, BulletHit)){
				sprite_index = sprPortalDisappear;
				image_angle  = 0;
			}
			
			 // Move & Avoid Walls:
			x = other.x;
			y = other.y;
			if(!instance_budge(Wall, 40)){
				wall_clear(x, y);
			}
			xprevious = x;
			yprevious = y;
			
			 // Appear:
			image_index = 0;
			if("name" in self && name == "PortalGuardian"){
				sprite_index = spr_appear;
			}
			else with(instance_create(x, y, BulletHit)){
				sprite_index = spr.PortalBulletHit;
				image_angle  = 0;
			}
			sound_play_hit_ext(sndPortalAppear, 3, (instance_is(id, Player) ? 0.5 : 1.5));
			
			 // Move Shield:
			with(instances_matching(CrystalShield, "creator", id)){
				instance_create(x, y, CrystalShieldDisappear);
				x = other.x;
				y = other.y;
			}
			
			 // Player Impact Zone:
			if(instance_is(self, Player)){
				var _minID = GameObject.id;
				with(projectile_create(x, y, "BatScreech", 0, 0)){
					image_alpha = 0;
					damage      = 4;
					force       = 1.5;
				}
				with(instances_matching_gt(Dust, "id", _minID)){
					instance_delete(id);
				}
				
				 // Effects:
				sleep(80);
				view_shake_at(x, y, 40);
				motion_add(direction + 180, 4);
				var _ang = random(360);
				for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / 5)){
					with(instance_create(x, y, PortalL)){
						mask_index = mskAlly;
						move_contact_solid(_dir + orandom(30), random_range(32, 40));
					}
				}
			}
		}
	}
	
	 // Can't Teleport:
	else with(instance_create(x, y, BulletHit)){
		sprite_index = sprPortalDisappear;
		image_xscale = 0.7;
		image_yscale = image_xscale;
	}
	
	
#define PortalGuardian_create(_x, _y)
	/*
		A rare palace enemy, shoots a projectile that swaps positions with itself and whatever it hit
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle      = spr.PortalGuardianIdle;
		spr_walk      = spr.PortalGuardianIdle;
		spr_hurt      = spr.PortalGuardianHurt;
		spr_dead      = spr.PortalGuardianDead;
		spr_appear    = spr.PortalGuardianAppear;
		spr_disappear = spr.PortalGuardianDisappear;
		spr_shadow    = shd24;
		hitid         = [spr_idle, "PORTAL GUARDIAN"];
		depth         = -2;
		
		 // Sound:
		snd_hurt = sndExploGuardianHurt;
		snd_dead = sndDogGuardianDead;
		snd_mele = sndGuardianFire;
		
		 // Vars:
		mask_index  = mskBandit;
		maxhealth   = 55; //45
		raddrop     = 16;
		meleedamage = 2;
		size        = 2;
		walk        = 0;
		walkspeed   = 0.8;
		maxspeed    = 4;
		gunangle    = random(360);
		portal      = false;
		
		 // Alarms:
		alarm1 = 40 + irandom(20);
		
		return id;
	}
	
#define PortalGuardian_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Movement:
	enemy_walk(walkspeed, maxspeed);
	
	 // Hovery:
	if(!place_meeting(x, y, projectile) || array_length(instances_meeting(x, y, instances_matching(projectile, "creator", id))) <= 0){
		speed = max(1, speed);
	}
	
	 // Animate:
	if(sprite_index == spr_appear){
		speed = 0;
		
		if(anim_end){
			image_index = 0;
			sprite_index = spr_idle;
			
			 // Effects:
			repeat(8){
				scrFX(x, y, 3, Dust);
			}
			repeat(3){
				with(instance_create(x + orandom(16), y + orandom(16), PortalL)){
					depth = other.depth - 1;
				}
			}
			sound_play_hit_ext(sndGuardianFire, 1.5 + orandom(0.2), 2);
		}
	}
	else if(sprite_index != spr_disappear || anim_end){
		sprite_index = enemy_sprite;
	}
	
	 // FX:
	if(chance_ct(1, 30)){
		with(instance_create(x + hspeed_raw, y + vspeed_raw, PortalL)){
			depth = other.depth + choose(0, -1);
		}
	}
	
#define PortalGuardian_alrm1
	alarm1 = 20 + random(30);
	
	if(enemy_target(x, y)){
		scrAim(point_direction(x, y, target.x, target.y));
		
		if(instance_seen(x, y, target)){
			 // Attack:
			if(chance(2, 3) && array_length(instances_matching(projectile, "creator", id)) <= 0){
				with(projectile_create(x, y, "PortalBullet", gunangle, 10)){
					portal = other.portal;
				}
				
				 // Sound:
				sound_play_pitchvol(sndPortalOld, 2 + random(2), 1.5);
			}
			
			 // Move:
			else{
				scrWalk(gunangle + (random_range(60, 100) * choose(-1, 1)), [20, 40]);
				
				 // Away From Target:
				if(instance_near(x, y, target, 128)){
					direction = gunangle + 180 + orandom(30);
				}
			}
		}
		
		 // Wander:
		else{
			scrWalk(gunangle + orandom(40), [10, 20]);
			scrAim(direction);
		}
	}
	
	 // Wander:
	else{
		scrWalk(random(360), 30);
		scrAim(direction);
	}
	
#define PortalGuardian_death
	with(instance_create(x, y, PortalClear)){
		image_xscale = 2/3;
		image_yscale = image_xscale;
	}
	
	 // Pickups:
	pickup_drop(40, 10, 0);
	
	
#define PortalPrevent_create(_x, _y)
	/*
		Prevent Corpses from creating Portals
		
		Vars:
			creator - Destroys itself if this instance no longer exists
	*/
	
	with(instance_create(_x, _y, becomenemy)){
		creator = noone;
		return id;
	}
	
#define PortalPrevent_step
	 // Die:
	if(creator != noone && !instance_exists(creator)){
		instance_destroy();
	}
	
	
#define ReviveNTTE_create(_x, _y)
	/*
		Used to transfer custom NTTE vars through a Player's Revive object
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		persistent = true;
		creator    = noone;
		vars       = {};
		p          = -1;
		
		return id;
	}
	
#define ReviveNTTE_step
	if(instance_exists(creator)){
		x = creator.x;
		y = creator.y;
		p = creator.p;
	}
	else{
		 // Set Vars on Newly Revived Player:
		if(player_is_active(p)){
			var _vars = vars;
			with(instance_nearest_array(x, y, instances_matching_gt(instances_matching(Player, "p", p), "id", id))){
				for(var i = 0; i < lq_size(_vars); i++){
					variable_instance_set(id, lq_get_key(_vars, i), lq_get_value(_vars, i));
				}
				
				 // Grab Back Pet:
				if("ntte_pet" in self){
					with(ntte_pet) if(instance_exists(self) && !instance_exists(leader)){
						leader = other;
						
						 // FX:
						with(instance_create(x, y, HealFX)){
							depth = other.depth - 1;
						}
						sound_play_pitch(sndHealthChestBig, 1.2 + random(0.1));
					}
				}
			}
		}
		
		instance_destroy();
	}
	
	
#define SmallGreenExplosion_create(_x, _y)
	/*
		A SmallExplosion variant of the GreenExplosion
	*/
	
	with(instance_create(_x, _y, SmallExplosion)){
		 // Visual:
		sprite_index = spr.SmallGreenExplosion;
		hitid        = [sprite_index, "SMALL GREEN#EXPLOSION"];
		
		 // Vars:
		damage = 12;
		force  = 8;
		
		return id;
	}
	
	
#define TopDecal_create(_x, _y)
	/*
		Creates the current area's TopDecal object with the current area's sprTopPot sprite variant
		If the area doesn't have a sprTopPot sprite variant then nothing is created
	*/
	
	var _area = GameCont.area;
	
	 // Custom:
	if(is_string(_area)){
		var _spr = area_get_sprite(_area, sprTopPot);
		if(sprite_exists(_spr)){
			with(instance_create(_x, _y, TopPot)){
				 // Visual:
				image_speed  = 0;
				sprite_index = area_get_sprite(_area, sprTopPot);
				image_index  = irandom(image_number - 1);
				
				 // Relocate:
				x = _x;
				y = _y;
				event_perform(ev_create, 0);
				
				return self;
			}
		}
	}
	
	 // Normal:
	switch(_area){
		case area_campfire     : return instance_create(_x, _y, TopDecalNightDesert);
		case area_desert       : return instance_create(_x, _y, TopDecalDesert);
		case area_sewers       : return instance_create(_x, _y, TopDecalSewers);
		case area_scrapyards   : return instance_create(_x, _y, TopDecalScrapyard);
		case area_caves        : return instance_create(_x, _y, TopDecalCave);
		case area_city         : return instance_create(_x, _y, TopDecalCity);
		case area_palace       : return instance_create(_x, _y, TopDecalPalace);
		case area_pizza_sewers : return instance_create(_x, _y, TopDecalPizzaSewers);
		case area_cursed_caves : return instance_create(_x, _y, TopDecalInvCave);
		case area_jungle       : return instance_create(_x, _y, TopDecalJungle);
		case area_hq           : return instance_create(_x, _y, TopPot);
	}
	
	return noone;
	
	
#define TopObject_create(_x, _y)
	/*
		Creates a top object controller that gives an object walltop z-axis powers
		Generally don't create this object manually, use 'top_create()' to create top objects
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		spr_shadow   = -1;
		spr_shadow_x = 0;
		spr_shadow_y = 0;
	//	depth        = -6 - (y / 10000);
		
		 // Vars:
		mask_index       = -1;
		mask_x           = 0;
		mask_y           = 8;
		target           = noone;
		target_save      = {};
		z                = 8;
		zspeed           = 0;
		zfriction        = 0;
		maxspeed         = 0;
		grav             = 0.8;
		jump             = random_range(3, 4);
		jump_x           = x;
		jump_y           = y;
		jump_time        = 0;
		idle_time        = 0;
		idle_wait        = [15, 90];
		idle_walk        = [5, 20];
		idle_walk_chance = 1/6;
		canmove          = true;
		spawn_dis        = 0;
		spawn_dir        = 0;
		type             = -1;
		wobble           = 0;
		wobble_num       = 0;
		override_mask    = true;
	//	override_depth   = true;
		unstick          = false;
		search_x1        = x - 8;
		search_x2        = x + 8;
		search_y1        = y - 8;
		search_y2        = y + 8;
		
		 // Up down:
		y += z;
		
		return id;
	}
	
#define TopObject_end_step
	if(instance_exists(target)){
		if(zspeed != 0) z += zspeed * current_time_scale;
		if(zfriction != 0) zspeed -= zfriction * current_time_scale;
		
		 // Target Management:
		with(target){
			 // Position:
			if(x != xprevious || y != yprevious){
				if(other.canmove){
					other.x += (x - xprevious);
					other.y += (y - yprevious);
					
					 // Depth:
					/*if(other.override_depth){
						if(depth != other.depth){
							other.target_save.depth = depth;
						}
						other.depth = -6 - ((other.y - 8) / 10000);
						depth = other.depth;
					}*/
				}
				
				var _spd = point_distance(xprevious, yprevious, x, y);
				other.direction = point_direction(xprevious, yprevious, x, y);
				if(_spd > other.maxspeed) other.maxspeed = _spd;
				
				if("spr_shadow" in self && other.z <= 8){
					 // Trail:
					if(chance_ct(sqr(_spd), 90)){
						var	o = abs(sprite_width / 16),
							_leaf = (GameCont.area == area_jungle);
							
						with(instance_create(x + orandom(o), y + o + random(o), (_leaf ? Feather : Dust))){
							if(_leaf){
								sprite_index = sprLeaf;
								speed *= random_range(0.5, 1);
							}
							depth = other.depth/* + 0.1*/;
						}
					}
					
					 // Push Bros:
					/*
					var	_inst = id,
						_saveMask = mask_index;
						
					mask_index = lq_defget(other.target_save, "mask_index", mask_index);
					
					with(instances_matching(instances_matching_ne(instance_rectangle(x - 32, y - 32, x + 32, y + 32, instances_matching(other.object_index, "name", other.name)), "id", other), "zfriction", 0)){
						with(target) if(instance_is(self, hitme) && !instance_is(self, prop)){
							var m = mask_index;
							mask_index = lq_defget(other.target_save, "mask_index", mask_index);
							
							if(place_meeting(x, y, _inst)){
								var _dir = point_direction(_inst.x, _inst.y, x, y);
								if(x == _inst.x && y == _inst.y) _dir = random(360);
								motion_add_ct(_dir, 1);
							}
							
							mask_index = m;
						}
					}
					
					mask_index = _saveMask;
					*/
				}
				
				 // Update Object Auto-Topify Range:
				var m = mask_index;
				mask_index = -1;
				other.search_x1 = min(x - 8, bbox_left);
				other.search_x2 = max(x + 8, bbox_right + 1);
				other.search_y1 = min(y - 8, bbox_top);
				other.search_y2 = max(y + 8, bbox_bottom + 1);
				mask_index = m;
			}
			if(x != other.x || y != other.y - other.z){
				x = other.x;
				y = other.y - other.z;
				xprevious = x;
				yprevious = y;
				
				 // Update Object Auto-Topify Range (copy-paste edition):
				var m = mask_index;
				mask_index = -1;
				other.search_x1 = min(x - 8, bbox_left);
				other.search_x2 = max(x + 8, bbox_right + 1);
				other.search_y1 = min(y - 8, bbox_top);
				other.search_y2 = max(y + 8, bbox_bottom + 1);
				mask_index = m;
			}
			
			 // Disable Hitbox:
			if(mask_index != mskNone && other.override_mask){
				other.target_save.mask_index = mask_index;
				mask_index = mskNone;
			}
			
			 // Disable Shadow:
			if("spr_shadow" in self && spr_shadow != -1){
				other.target_save.spr_shadow = spr_shadow;
				spr_shadow = -1;
			}
			
			 // Depth:
			/*if(depth != other.depth){
				other.target_save.depth = depth;
				depth = other.depth;
			}*/
			
			 // Disable Death:
			if("canfly" in self && !canfly){
				other.target_save.canfly = canfly;
				canfly = true;
			}
		}
		
		 // Landing:
		if(z < 8){
			if(place_meeting(x, y, Floor)) with(target){
				mask_index = lq_defget(other.target_save, "mask_index", mask_index);
				if(place_meeting(x, y, Wall)) mask_index = mskNone;
			}
			
			 // Depth:
			if(z > 0){
				if(!collision_rectangle(bbox_left + 4, bbox_top + 8 - z, bbox_right - 4, bbox_bottom - z, Wall, false, false)){
					target.depth = min(-1, lq_defget(target_save, "depth", 0));
				}
			}
			
			 // Landed:
			else{
				if(!instance_exists(NothingSpiral) || place_meeting(x, y, Floor)){
					instance_destroy();
				}
				
				 // Abyss Time:
				else{
					target.depth = max(12, target.depth);
					if(!point_seen(x, bbox_top - z, -1)){
						with(target) instance_delete(id);
						instance_delete(id);
					}
				}
			}
		}
		
		 // Specific Stuff:
		else switch(type){
			
			case enemy: // Idle, Then Run to Player + Jump Off Wall
				
				if(zfriction == 0){
					if(idle_time > 0) idle_time -= current_time_scale;
					else{
						 // Time to Jump Off:
						if(jump_time == 0){
							with(target){
								if("walk" not in self || walk <= 0 || instance_is(self, Freak) || instance_is(self, ExploFreak)){
									other.idle_time = 10 + random(20);
									
									var _target = (instance_exists(Player) ? instance_nearest(other.x, other.y, Player) : instance_nearest(other.x - 16, other.y - 16, Floor));
									direction = point_direction(other.x, other.y, _target.x, _target.y - 8);
									speed += current_time_scale;
									
									if("walk"     in self) walk = other.idle_time;
									if("gunangle" in self) gunangle = direction;
									if("right"    in self) scrRight(direction);
								}
							}
						}
						
						 // Idling:
						else{
							idle_time = random_range(idle_wait[0], idle_wait[1]);
							
							var _target = instance_nearest(x, y, Player);
							
							with(target){
								 // Face Player:
								if(instance_exists(_target)){
									var _targetDir = point_direction(x, y, _target.x, _target.y - 8) + orandom(5);
									if("gunangle" in self){
										gunangle = _targetDir;
									}
									if("right" in self){
										if("gunangle" not in self){
											direction = _targetDir;
										}
										scrRight(_targetDir);
									}
								 }
								
								 // Wander:
								if(chance(other.idle_walk_chance, 1)){
									direction = random(360);
									if("walk" in self){
										walk = random_range(other.idle_walk[0], other.idle_walk[1]);
									}
								}
								
								 // Cold:
								if(GameCont.area == area_city && chance(2, 3)){
									with(instance_create(x, y, Breath)){
										image_xscale = sign(other.image_xscale) * variable_instance_get(other, "right", 1);
										depth = other.depth - 1;
									}
								}
							}
							
							 // Let's Roll:
							if(chance(1, 5) && instance_near(x, y, _target, 160)){
								jump_time = 1;
							}
						}
					}
					
					 // Time Until Jump Off:
					if(jump_time > 0){
						jump_time -= current_time_scale;
						if(jump_time <= 0){
							jump_time = 0;
							canmove   = true;
							
							 // Cmon Bros:
							with(instances_matching_gt(instances_matching(object_index, "name", name), "jump_time", 0)){
								if(instance_exists(target) && target.object_index == other.target.object_index && instance_near(x, y, other, 64)){
									jump_time = 0;
									idle_time = random_range(10, 60);
									canmove   = true;
								}
							}
						}
					}
				}
				else canmove = false;
				
				break;
				
			case RavenFly: // Flight
				
				 // Time Until Flight:
				if(jump_time > 0){
					jump_time -= current_time_scale;
					
					 // Early Flight:
					if(zspeed == 0 && speed == 0){
						if(instance_exists(ScrapBoss)){
							jump_time = 0;
						}
						else if(distance_to_object(projectile) < 16 || distance_to_object(BulletHit) < 16){
							jump_time = 0;
							idle_time = random(3);
						}
					}
					
					if(jump_time <= 0){
						jump_time = 0;
						
						 // Prepare to Fly w/ Bros:
						if(zspeed == 0){
							with(instances_matching(instances_matching(instances_matching_gt(instances_matching(object_index, "name", name), "jump_time", 0), "zspeed", 0), "speed", 0)){
								if(instance_exists(target) && target.object_index == other.target.object_index && instance_near(x, y, other, 64)){
									jump_time = 0;
									idle_time = min(idle_time, random_range(10, 60));
								}
							}
						}
						
						 // Stop Rising:
						else{
							speed  = 6;
							zspeed = 0;
						}
					}
				}
				
				if(zspeed == 0){
					 // Flying:
					if(speed > 0){
						direction = point_direction(x, y, jump_x, jump_y);
						if(point_distance(x, y, jump_x, jump_y) <= speed_raw){
							speed  = 0;
							x      = jump_x;
							y      = jump_y;
							zspeed = -jump * max(1, (z - 8) / 20);
						}
					}
					
					 // Idle:
					else{
						if(idle_time > 0) idle_time -= current_time_scale;
						else{
							 // Take Flight:
							if(jump_time == 0){
								jump_x    = x;
								jump_y    = y;
								zspeed    = jump;
								zfriction = grav;
							}
							
							 // Lookin Around:
							else{
								idle_time = random_range(idle_wait[0], idle_wait[1]);
								
								with(target){
									right *= choose(-1, 1);
									if(instance_exists(Player)){
										var _target = instance_nearest(x, y, Player);
										scrRight(point_direction(x, y, _target.x, _target.y));
									}
								}
							}
						}
					}
				}
				
				 // Find Landing Zone:
				else{
					canmove = false;
					
					if(zspeed > 0){
						with(target){
							var _saveMask = mask_index;
							mask_index = lq_defget(other.target_save, "mask_index", mask_index);
							
							if(
								(other.jump_x == other.x && other.jump_y == other.y)
								|| !place_meeting(other.jump_x, other.jump_y, Floor)
								||  place_meeting(other.jump_x, other.jump_y, Wall)
							){
								var	_x = other.x,
									_y = other.y;
									
								 // Search Floors by Player:
								var _target = instance_nearest(_x, _y, Player);
								if(instance_exists(_target)){
									scrRight(point_direction(_x, _y, _target.x, _target.y));
									
									_x = _target.x;
									_y = _target.y;
									
									with(array_shuffle(instance_rectangle_bbox(_x - 64, _y - 64, _x + 64, _y + 64, Floor))){
										var	_fx = bbox_center_x + orandom(4),
											_fy = bbox_center_y + orandom(4),
											_break = false;
											
										with(other){
											if(!place_meeting(_fx, _fy, Wall)){
												_x = _fx;
												_y = _fy;
												_break = true;
											}
										}
										if(_break) break;
									}
								}
								
								 // Random Nearby Floor:
								else{
									var	_l = random_range(48, 96),
										_d = random(360);
										
									with(instance_nearest_bbox(_x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), Floor)){
										_x = bbox_center_x;
										_y = bbox_center_y;
									}
								}
								
								other.jump_x = _x;
								other.jump_y = _y;
							}
							
							mask_index = _saveMask;
						}
						
						 // Stop Rising:
						if(speed > 0) zspeed = 0;
						else if(jump_time <= 0 || jump_time > 12){
							jump_time = 12;
						}
					}
				}
				
				break;
				
			case projectile: // Damage Related
				
				with(target){
					var	_inst     = id,
						_saveMask = mask_index;
						
					mask_index = lq_defget(other.target_save, "mask_index", mask_index);
					
					with(instances_matching_ne(instance_rectangle(x - 32, y - 32, x + 32, y + 32, instances_matching(other.object_index, "name", other.name)), "id", other)){
						with(target) if(instance_is(self, hitme)){
							var _lastMask = mask_index;
							mask_index = lq_defget(other.target_save, "mask_index", mask_index);
							
							if(place_meeting(x, y, _inst)){
								with(_inst){
									event_perform(ev_collision, hitme);
								}
								if(!instance_exists(self)) break;
								if(!instance_exists(other)) exit;
							}
							
							mask_index = _lastMask;
						}
					}
					
					if(instance_exists(self)){
						mask_index = _saveMask;
					}
				}
				
				break;
				
		}
	}
	
	 // Target Destroyed:
	else{
		if(target != noone) target = noone; // 1 frame delay for auto top object searching
		else instance_destroy();
	}
	
#define TopObject_destroy
	with(target){
		top_object = noone;
		x          = other.x;
		y          = other.y;
		xprevious  = x;
		yprevious  = y;
		xstart     = x;
		ystart     = y;
		
		 // Unwobble:
		if(other.wobble_num != 0){
			image_angle = 0;
		}
		
		 // Restore Vars:
		variable_instance_set_list(id, other.target_save);
		
		 // Not today, Walls:
		if(other.unstick && place_meeting(x, y, Wall)){
			if(place_meeting(x, y, Floor)){
				 // Emergency:
				if(other.maxspeed <= 0 || !instance_budge(Wall, 24)){
					 // Emergency+:
					wall_clear(x, y);
					
					 // No Baby Jails:
					with(instance_nearest_bbox(x, y, Floor)){
						with(floor_tunnel(bbox_center_x, bbox_center_y, other.x, other.y)){
							image_yscale = 1;
						}
					}
				}
			}
			
			 // Emergency++:
			else with(instance_nearest_bbox(x, y, Floor)){
				other.x = bbox_center_x;
				other.y = bbox_center_y;
			}
		}
		
		 // Effects:
		if("spr_shadow" in self){
			var _num = abs(sprite_width / 4) + irandom(2);
			for(var d = direction; d < direction + 360; d += (360 / _num)){
				var _obj = (chance(1, 8) ? Debris : Dust);
				with(instance_create(x, y, Dust)){
					motion_add(d + orandom(20), random_range(2, 4));
					hspeed += other.hspeed / 2;
					vspeed += other.vspeed / 2;
					depth = max(depth, other.depth);
				}
			}
			view_shake_max_at(x, y, 6);
		}
		
		 // Sounds:
		if(!area_get_underwater(GameCont.area)){
			if(instance_is(self, hitme)){
				sound_play_hit_ext(sndAssassinHit, 1 + orandom(0.3), abs(other.zspeed) / 4);
			}
			else if(instance_is(self, chestprop)){
				sound_play_hit_ext(sndWeaponChest, 0.5 + random(0.2), 1.6);
			}
		}
		
		 // Other Stuff:
		if(instance_is(self, CustomObject) && "name" in self){
			switch(name){
				case "WepPickupGrounded":
					instance_destroy();
					break;
			}
		}
	}
	
	
#define TopTiny_create(_x, _y)
	/*
		Creates a TopSmall but even smaller
		If the area doesn't have a spr.TopTiny sprite variant then nothing is created
	*/
	
	if(position_meeting(_x, _y, TopSmall)){
		with(instance_create(pfloor(_x, 16), pfloor(_y, 16), TopSmall)){
			if(sprite_exists(sprite_index)){
				 // Setup Sprite:
				if(!ds_map_exists(spr.TopTiny, sprite_index)){
					spr.TopTiny[? sprite_index] = mod_script_call_nc("mod", "teassets", "sprite_add_toptiny", sprite_index);
				}
				
				 // Hitbox:
				mask_index = ((mask_index < 0) ? sprite_index : mask_index);
				
				 // Visual:
				sprite_index = spr.TopTiny[? sprite_index][(_x >= x + 8), (_y >= y + 8)];
				image_index  = irandom(image_number - 1);
				
				 // Fix Drawing Order:
				if(fork()){
					wait 0;
					if(instance_exists(self)){
						var _inst = instances_matching_ne(instance_rectangle_bbox(bbox_left - 1, bbox_top - 1, bbox_right, bbox_bottom, TopSmall), "name", "TopTiny");
						array_sort(_inst, true);
						with(_inst){
							instance_copy(false);
							instance_delete(id);
						}
					}
					exit;
				}
			}
			
			return id;
		}
	}
	
	return noone;
	
	
#define UnlockCont_create(_x, _y)
	/*
		Used to handle NTTE's custom unlock splat system
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		depth = UberCont.depth - 1;
		
		 // Vars:
		persistent            = true;
		unlock                = [];
		unlock_sprit          = sprMutationSplat;
		unlock_image          = 0;
		unlock_delay          = 50;
		unlock_index          = 0;
		unlock_porty          = 0;
		unlock_delay_continue = 0;
		splash_sprit          = sprUnlockPopupSplat;
		splash_image          = 0;
		splash_delay          = 0;
		splash_index          = -1;
		splash_texty          = 0;
		splash_timer          = 0;
		splash_timer_max      = 150;
		
		return id;
	}
	
#define UnlockCont_step
	if(instance_exists(Menu)){
		instance_destroy();
		exit;
	}
	
	depth = UberCont.depth - 1;
	
	 // Animate Corner Popup:
	if(splash_delay > 0) splash_delay -= current_time_scale;
	else{
		var _img = 0;
		if(instance_exists(Player) || instance_exists(BackMainMenu) || instance_exists(PauseButton)){
			if(splash_timer > 0){
				splash_timer -= current_time_scale;
				
				_img = sprite_get_number(splash_sprit) - 1;
				
				 // Text Offset:
				if(splash_image >= _img && splash_texty > 0){
					splash_texty -= current_time_scale;
				}
			}
			else{
				splash_texty = 2;
				
				 // Splash Next Unlock:
				if(splash_index < array_length(unlock) - 1){
					splash_index++;
					splash_timer = splash_timer_max;
				}
			}
		}
		splash_image += clamp(_img - splash_image, -1, 1) * current_time_scale;
	}
	
	 // Game Over Splash:
	if(instance_exists(UnlockScreen)) unlock_delay = 1;
	else if(!instance_exists(Player) && !instance_exists(BackMainMenu) && !instance_exists(PauseButton)){
		while(
			unlock_index >= 0                   &&
			unlock_index < array_length(unlock) &&
			unlock[unlock_index].spr == -1
		){
			unlock_index++; // No Game Over Splash
		}
		
		if(unlock_index < array_length(unlock)){
			 // Disable Game Over Screen:
			with(GameOverButton){
				if(game_letterbox) alarm_set(0, 30);
				else instance_destroy();
			}
			with(TopCont){
				gameoversplat = 0;
				go_addy1 = 9999;
				dead = false;
			}
			
			 // Delay Unlocks:
			if(unlock_delay > 0){
				unlock_delay -= current_time_scale;
				var _delayOver = (unlock_delay <= 0);
				
				unlock_delay_continue = 20;
				unlock_porty = 0;
				
				 // Screen Dim + Letterbox:
				with(TopCont){
					visible = _delayOver;
					if(darkness){
					   visible = true;
					   darkness = 2;
					}
				}
				game_letterbox = _delayOver;
				
				 // Sound:
				if(_delayOver){
					sound_play(sndCharUnlock);
					sound_play(unlock[unlock_index].snd);
				}
			}
			else{
				 // Animate Unlock Splash:
				var _img = sprite_get_number(unlock_sprit) - 1;
				unlock_image += clamp(_img - unlock_image, -1, 1) * current_time_scale;
				
				 // Portrait Offset:
				if(unlock_porty < 3){
					unlock_porty += current_time_scale;
				}
				
				 // Next Unlock:
				if(unlock_delay_continue > 0) unlock_delay_continue -= current_time_scale;
				else for(var i = 0; i < maxp; i++){
					if(button_pressed(i, "fire") || button_pressed(i, "okay")){
						if(unlock_index < array_length(unlock)){
							unlock_index++;
							unlock_delay = 1;
						}
						break;
					}
				}
			}
		}
		
		 // Done:
		else{
			with(TopCont){
				go_addy1 = 55;
				dead = true;
			}
			instance_destroy();
		}
	}
	
#define UnlockCont_draw
	var	_vx = view_xview_nonsync,
		_vy = view_yview_nonsync,
		_gw = game_width,
		_gh = game_height;
		
	 // Game Over Splash:
	if(unlock_delay <= 0){
		if(unlock_image > 0){
			var	_unlock = unlock[unlock_index],
				_nam    = _unlock.nam[1],
				_spr    = _unlock.spr,
				_img    = _unlock.img,
				_x      = _gw / 2,
				_y      = _gh - 20;
				
			 // Unlock Portrait:
			var	_px = _vx + _x - 60,
				_py = _vy + _y + 9 + unlock_porty;
				
			draw_sprite(_spr, _img, _px, _py);
			
			 // Splash:
			draw_sprite(unlock_sprit, unlock_image, _vx + _x, _vy + _y);
			
			 // Unlock Name:
			var	_tx = _vx + _x,
				_ty = _vy + _y - 92 + (unlock_porty < 2);
				
			draw_set_font(fntBigName);
			draw_set_halign(fa_center);
			draw_set_valign(fa_top);
			
			var _t = string_upper(_nam);
			draw_text_nt(_tx, _ty, _t);
			
			 // Unlocked!
			_ty += string_height(_t) + 3;
			if(unlock_porty >= 3){
				d3d_set_fog(1, 0, 0, 0);
				draw_sprite(sprTextUnlocked, 4, _tx + 1, _ty);
				draw_sprite(sprTextUnlocked, 4, _tx,     _ty + 1);
				draw_sprite(sprTextUnlocked, 4, _tx + 1, _ty + 1);
				d3d_set_fog(0, 0, 0, 0);
				draw_sprite(sprTextUnlocked, 4, _tx,     _ty);
			}
			
			 // Continue Button:
			if(unlock_delay_continue <= 0){
				var	_cx    = _x,
					_cy    = _y - 4,
					_blend = make_color_rgb(102, 102, 102);
					
				for(var i = 0; i < maxp; i++){
					if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _cx - 64, _cy - 12, _cx + 64, _cy + 16)){
						_blend = c_white;
						break;
					}
				}
				
				draw_sprite_ext(sprUnlockContinue, 0, _vx + _cx, _vy + _cy, 1, 1, 0, _blend, 1);
			}
		}
	}
	
	 // Corner Popup:
	if(splash_image > 0){
		 // Splash:
		var	_x = _vx + _gw,
			_y = _vy + _gh;
			
		draw_sprite(splash_sprit, splash_image, _x, _y);
		
		 // Unlock Text:
		if(splash_texty < 2){
			var	_unlock = unlock[splash_index],
				_nam    = _unlock.nam[0],
				_txt    = _unlock.txt,
				_tx     = _x - 4,
				_ty     = _y - 16 + splash_texty;
				
			draw_set_font(fntM);
			draw_set_halign(fa_right);
			draw_set_valign(fa_bottom);
			
			 // Title:
			if(_nam != ""){
				draw_text_nt(_tx, _ty, _nam);
			}
			
			 // Description:
			if(splash_texty <= 0){
				_ty += max(string_height("A"), string_height(_nam));
				draw_text_nt(_tx, _ty, "@s" + _txt);
			}
		}
	}
	
	
#define WallDecal_create(_x, _y)
	/*
		Creates a Bones wall decal object with the current area's sprBones sprite variant
		If the area doesn't have a sprBones sprite variant then nothing is created
	*/
	
	var	_area = GameCont.area,
		_spr  = area_get_sprite(_area, sprBones);
		
	if(sprite_exists(_spr)){
		with(instance_create(_x, _y, Bones)){
			sprite_index = area_get_sprite(_area, sprBones);
			image_index = irandom(image_number - 1);
			return self;
		}
	}
	
	return noone;
	
	
#define WallEnemy_create(_x, _y)
	/*
		Creates a wall-residing enemy that pops out of the wall when destroyed
		Uses a TopPot/TopDecal object to handle collision and drawing
		
		Types:
			Desert - Bandits
			Caves  - Spiders
	*/
	
	var	_area = GameCont.area,
		_spr = -1;
		
	 // Determine Type:
	with(instances_at(_x, _y, [TopSmall, Wall])){
		switch(instance_is(self, Wall) ? topspr : sprite_index){
			case sprWall1Top:
			case sprWall1Trans:
				_area = area_desert;
				break;
				
			case sprWall4Top:
			case sprWall4Trans:
				_area = area_caves;
				break;
		}
	}
	switch(_area){
		case area_desert:
			_spr = spr.WallBandit;
			break;
			
		case area_caves:
			_spr = (position_meeting(_x, _y, Wall) ? spr.WallSpiderling : spr.WallSpiderlingTrans);
			break;
	}
	
	 // Create:
	if(sprite_exists(_spr)){
		with(instance_create(_x, _y, CustomObject)){
			 // Visual:
			visible      = false;
			sprite_index = _spr;
			image_index  = irandom(image_number - 1);
			image_speed  = 0;
			
			 // Vars:
			mask_index = -1;
			area       = _area;
			special    = false;
			eyeblink   = random(10000);
			eyedir     = 90;
			
			 // Area-Specific:
			switch(area){
				
				case area_desert:
					
					 // Variation:
					image_xscale = choose(-1, 1);
					
					break;
					
				case area_caves:
					
					 // No Orange Crystals:
					if(place_meeting(x, y, Wall)){
						with(instances_meeting(x, y, Wall)){
							if(place_meeting(x, y, other)){
								topindex = irandom(1);
							}
						}
					}
					
					break;
					
			}
			
			 // Top Decal:
			target = instance_create(x, y, TopPot);
			with(target){
				name         = "WallEnemy";
				x            = other.x;
				y            = other.y;
				mask_index   = other.mask_index;
				sprite_index = other.sprite_index;
				image_index  = other.image_index;
				image_speed  = other.image_speed;
				image_xscale = other.image_xscale;
				image_yscale = other.image_yscale;
				image_angle  = other.image_angle;
				image_blend  = other.image_blend;
				image_alpha  = other.image_alpha;
			}
			
			return id;
		}
	}
	
	return noone;
	
#define WallEnemy_step
	if(instance_exists(target)){
		x = target.x;
		y = target.y;
		
		switch(area){
			
			case area_desert: // WALL BANDIT
				
				eyeblink += current_time_scale;
				
				 // Lookin'
				var	_dir    = 90,
					_target = instance_near(
						x,
						y,
						instances_matching(Player, "visible", true),
						8 + (64 * (1 + !position_meeting(x, y, Wall)) * (1 + instance_exists(enemy)))
					);
					
				if(instance_exists(_target)){
					if(_target.y < y - 8){
						_dir = 270 + (30 * sin(eyeblink / 40));
					}
					else{
						_dir = point_direction(x, y - 8, _target.x, _target.y);
					}
				}
				
				eyedir = angle_lerp(eyedir, _dir, 0.2 * current_time_scale);
				eyedir = (eyedir + 360) % 360;
				
				 // Target Eye Control:
				var	_num   = 0.5 + (0.5 * (angle_difference(eyedir, 270) / 120)),
					_blink = ((eyeblink % 250) < 6 || (eyeblink % 300) < 6);
					
				with(target){
					image_index = 0;
					
					 // Flinch:
					if(distance_to_object(projectile) < 8){
						other.eyeblink = -random_range(3, 6);
					}
					
					 // Lookin'
					else if(in_range(_num, 0, 1) && !_blink){
						if(sign(image_xscale) < 0) _num = 1 - _num;
						image_index = round(lerp(1, image_number - 1, _num));
					}
				}
				
				break;
				
			case area_caves: // WALL SPIDERS
				
				 // Sparkle:
				if(special > 0 && chance_ct(special, 90)){
					with(instance_create(x + orandom(12), y - 8 + orandom(12), CaveSparkle)){
						sprite_index = spr.PetSparkle;
						depth = -9;
					}
				}
				
				break;
				
		}
	}
	else instance_destroy();
	
#define WallEnemy_destroy
	with(target){
		other.x = x;
		other.y = y;
		instance_destroy();
	}
	
	if(place_meeting(x, y, Floor)){
		switch(area){
			
			case area_desert:
				
				with(instance_create(x, y, Bandit)){
					wkick = 8;
					
					 // Alert:
					if(point_seen(x, y, -1)){
						with(alert_create(self, spr.BanditAlert)){
							flash = 6;
							alarm0 = 60;
							blink = 15;
						}
					}
					
					 // Launch:
					with(instance_nearest_bbox(x, y, FloorNormal)){
						other.direction = point_direction(other.x, other.y, bbox_center_x, bbox_center_y) + orandom(30);
					}
					with(obj_create(x, y, "BackpackPickup")){
						target    = other;
						zspeed    = random_range(2.5, 5);
						speed     = random_range(1, 2.5);
						direction = other.direction;
						event_perform(ev_step, ev_step_end);
					}
					
					 // Pickup:
					pickup_drop(100 / pickup_chance_multiplier, 0);
					with(instances_matching_gt([Pickup, chestprop], "id", id)){
						with(obj_create(x, y, "BackpackPickup")){
							target    = other;
							direction = other.direction + orandom(60);
							event_perform(ev_step, ev_step_end);
						}
					}
					
					 // Effects:
					if(chance(1, 15)){
						with(scrFX(x, y, [direction + orandom(60), 4], Shell)){
							sprite_index = sprSodaCan;
							image_index  = irandom(image_number - 1);
							image_speed  = 0;
						}
					}
					sound_play_hit_ext(sndWallBreakCrystal, 2 + random(0.5), 1.6);
				}
				
				break;
				
			case area_caves: // CRYSTAL CAVES
				
				 // Special Spider:
				if(special){
					with(pet_spawn(x, y, "Spider")){
						sprite_index = spr_hurt;
						sound_play_hit_ext(sndSpiderMelee, 0.6 + random(0.2), 1.5);
						
						 // Alert:
						with(alert_create(self, spr_icon)){
							alert.x--;
							alert.col = make_color_rgb(16, 226, 165);
							flash = 6;
							blink = 15;
						}
					}
				}
				
				 // Spiderlings:
				else repeat(irandom_range(1, 3)){
					if(chance(3, 5)){
						with(obj_create(x, y, "Spiderling")){
							sprite_index = spr_hurt;
							sound_play_hit_ext(sndSpiderHurt, 0.5 + random(0.3), 1.5);
							
							 // Launch:
							with(obj_create(x, y, "BackpackPickup")){
								target = other;
								zspeed = random_range(2, 4);
								speed = random_range(1, 2.5);
								direction = random(360);
								event_perform(ev_step, ev_step_end);
							}
						}
					}
					
					 // Sparkle:
					with(instance_create(x + orandom(8), y - 8 + orandom(8), CaveSparkle)){
						sprite_index = spr.PetSparkle;
						depth = -3;
					}
				}
				
				break;
				
		}
	}
	
	
/// GENERAL
#define game_start
	 // Delete:
	with(instances_matching_lt(instances_matching(CustomHitme,  "name", "Pet"       ), "id", GameCont.id)) instance_delete(id);
	with(instances_matching_lt(instances_matching(CustomObject, "name", "ReviveNTTE"), "id", GameCont.id)) instance_delete(id);
	with(instances_matching_lt(instances_matching(CustomObject, "name", "UnlockCont"), "id", GameCont.id)) instance_destroy();
	
	 // Reset Pet History:
	ds_list_clear(global.pet_history);
	
#define ntte_step
	 // Pet Leveling Up FX:
	if(instance_exists(LevelUp)){
		var _inst = instances_matching(LevelUp, "nttepet_levelup", null);
		if(array_length(_inst)) with(_inst){
			nttepet_levelup = true;
			if(instance_is(creator, Player)){
				if("ntte_pet" in creator) with(creator.ntte_pet){
					if(instance_exists(self)) with(other){
						instance_copy(false).creator = other;
					}
				}
			}
		}
	}
	
	 // Floor Update:
	if(instance_exists(Floor)){
		if(global.floor_num != instance_number(Floor) || global.floor_min < Floor.id){
			global.floor_num = instance_number(Floor);
			
			 // Find Floor Collision Area:
			global.floor_left   = Floor.bbox_left;
			global.floor_right  = Floor.bbox_right;
			global.floor_top    = Floor.bbox_top;
			global.floor_bottom = Floor.bbox_bottom;
			with(Floor){
				global.floor_left   = min(bbox_left,   global.floor_left);
				global.floor_right  = max(bbox_right,  global.floor_right);
				global.floor_top    = min(bbox_top,    global.floor_top);
				global.floor_bottom = max(bbox_bottom, global.floor_bottom);
			}
			
			 // Tiny TopSmall Fix:
			if(global.floor_min < Floor.id){
				var _inst = instances_matching_gt(FloorExplo, "id", global.floor_min);
				if(array_length(_inst)) with(_inst){
					var _instSmall = instances_matching(instances_matching(TopSmall, "x", x), "y", y);
					if(array_length(_instSmall)) with(_instSmall){
						instance_destroy();
					}
				}
				global.floor_min = GameObject.id;
			}
		}
	}
	
	 // Auto-Topify New Objects:
	with(TopObjectSearch){
		var _object = self;
		if(instance_exists(_object)){
			var _lastID = TopObjectSearchMap[? _object];
			if(_object.id > _lastID){
				TopObjectSearchMap[? _object] = _object.id;
				
				var _instTop = instances_matching(CustomObject, "name", "TopObject");
				
				if(array_length(_instTop)){
					var _inst  = instances_matching(instances_matching_gt(_object, "id", _lastID), "z", null),
						_break = false;
						
					 // Object-Specifics:
					switch(_object){
						case hitme: // Avoid Wall-Breaking Bros (Big Bandit)
							with(instances_matching(_inst, "top_object_wallcheck", null)){
								if(instance_exists(self)){
									top_object_wallcheck = false;
									
									motion_step(1);
									
									if(place_meeting(x, y, Wall)){
										 // Check for Wall-Breaking Capabilities:
										if(position_meeting(x, y, PortalClear)){
											top_object_wallcheck = true;
										}
										else with(instances_meeting(x, y, Wall)){
											if(instance_exists(self) && place_meeting(x, y, other)){
												with(other){
													if(other.solid || solid){
														x = xprevious;
														y = yprevious;
														other.x = other.xprevious;
														other.y = other.yprevious;
													}
													event_perform(ev_collision, Wall);
													
													 // Check for Wall Breakage:
													if(instance_exists(self)){
														if(!instance_exists(other)){
															top_object_wallcheck = true;
															break;
														}
													}
													else break;
												}
											}
										}
										
										 // Cancel Topification:
										if(!instance_exists(self) || top_object_wallcheck){
											_inst = instances_matching_ne(_inst, "id", self);
											if(!instance_exists(self)){
												continue;
											}
										}
									}
									
									motion_step(-1);
								}
							}
							break;
							
						case Effect: // Anti-Lag
							_inst = instances_matching_ne(_inst, "object_index", RainSplash, RainDrop, SnowFlake, Bubble);
							if(instance_number(Smoke) >= 100){
								_inst = instances_matching_ne(_inst, "object_index", Smoke);
							}
							if(instance_number(Dust) >= 100){
								_inst = instances_matching_ne(_inst, "object_index", Dust);
							}
							break;
					}
					
					 // Topify:
					if(array_length(_inst)){
						with(_instTop){
							with(
								instances_matching(
								instances_matching_le(
								instances_matching_ge(
								instances_matching_le(
								instances_matching_ge(
								_inst,
								"xstart", search_x1),
								"xstart", search_x2),
								"ystart", search_y1),
								"ystart", search_y2),
								"creator", null, noone, target)
							){
								_inst = array_delete_value(_inst, self);
								
								switch(_object){
									case Effect:
										if(!position_meeting(x, y, Floor)){
											switch(object_index){
												case ChestOpen:
												case Debris:
												case Scorchmark:
													top_create(x, y, id, 0, 0);
													break;
													
												case MeltSplat:
													instance_destroy();
													break;
													
												default:
													depth = object_get_depth(SubTopCont) + min(-1, depth);
											}
										}
										break;
										
									case SharpTeeth:
										depth = object_get_depth(SubTopCont) + min(-1, depth);
										break;
										
									default:
										if(place_meeting(x, y, Wall) || !position_meeting(x, y, Floor)){
											top_create(x, y, id, 0, 0);
										}
								}
							}
							if(array_length(_inst) <= 0){
								break;
							}
						}
					}
				}
			}
		}
	}
	
	 // Top Objects:
	if(instance_exists(CustomObject)){
		var _instTop = instances_matching(instances_matching(instances_matching(instances_matching(CustomObject, "name", "TopObject"), "zspeed", 0), "zfriction", 0), "speed", 0);
		if(array_length(_instTop)){
			 // Top Object Floor Collision:
			if(instance_exists(Floor)){
				var _instTopFloor = instance_rectangle_bbox(global.floor_left - 16, global.floor_top - 16, global.floor_right + 16, global.floor_bottom + 16, _instTop);
				if(array_length(_instTopFloor)) with(_instTopFloor){
					if(place_meeting(x + mask_x, y + mask_y, Floor) && (jump != 0 || grav > 0)){
						 // Wobble:
						if(wobble != 0 && place_meeting(x + mask_x, y + mask_y, Wall)){
							var	_wobWest = position_meeting(bbox_left, y, Floor),
								_wobEast = position_meeting(bbox_right, y, Floor);
								
							if(_wobWest || _wobEast){
								var _wobMove = ((_wobWest - _wobEast) - wobble_num) * 0.1 * current_time_scale;
								wobble_num += _wobMove;
								
								with(target){
									image_angle += other.wobble * _wobMove;
									image_angle += (other.wobble / 16) * sin(current_frame / 10) * other.wobble_num;
								}
							}
						}
						
						 // Jump to Ground:
						else if(type != RavenFly || !canmove || !position_meeting(x + mask_x, y + mask_y + 8, Wall)){
							if(instance_exists(target)){
								jump_x    = x;
								jump_y    = y;
								zspeed    = jump;
								zfriction = grav;
								
								if(type != RavenFly){
									 // Find Open Space to Jump, if Possible:
									if(unstick) with(target){
										var	_disMin = 5 * max(speed, other.maxspeed),
											_disMax = 4 * _disMin,
											_dir = other.direction,
											_sx = x + lengthdir_x(_disMin, _dir),
											_sy = y + lengthdir_y(_disMin, _dir),
											_tx = _sx,
											_ty = _sy,
											_saveMask = mask_index;
											
										mask_index = lq_defget(other.target_save, "mask_index", mask_index);
										
										if(!place_meeting(_tx, _ty, Floor) || place_meeting(_tx, _ty, Wall)){
											with(instance_rectangle_bbox(x - _disMax - 1, y - _disMax - 1, x + _disMax, y + _disMax, Floor)){
												with(other){
													for(var _fx = other.bbox_left; _fx < other.bbox_right + 1; _fx += 8){
														for(var _fy = other.bbox_top; _fy < other.bbox_bottom + 1; _fy += 8){
															if(!place_meeting(_fx, _fy, Wall)){
																var _dis = point_distance(x, y, _fx, _fy);
																if(_dis < _disMax || (_dis > _disMin && _disMax < _disMin)){
																	if(abs(angle_difference(point_direction(x, y, _fx, _fy), _dir)) < 90){
																		_disMax = _dis;
																		_tx = _fx;
																		_ty = _fy;
																	}
																}
															}
														}
													}
												}
											}
										}
										
										mask_index = _saveMask;
										
										other.jump_x = _tx;
										other.jump_y = _ty;
									}
									
									 // Jump to Target Position:
									if(target.speed == 0) zspeed *= 2/3;
									direction = point_direction(x, y, jump_x, jump_y);
									var d = point_distance(x, y, jump_x, jump_y);
									speed = min(maxspeed + target.friction, (sqrt(max(0, sqr(d) * ((2 * zfriction * z) + sqr(zspeed)))) - (d * zspeed)) / (2 * z));
									
									 // Facing:
									if(speed > 0){
										with(target){
											if("gunangle" in self) gunangle = other.direction;
											if("right" in self) scrRight(other.direction);
										}
									}
									
									 // Sound:
									sound_play_hit_ext(sndAssassinAttack, 1 + orandom(0.4), abs(zspeed) / 3);
								}
							}
						}
					}
					
					 // Unwobble:
					else if(wobble_num != 0){
						wobble_num -= wobble_num * 0.5 * current_time_scale;
						with(target) image_angle -= image_angle * 0.5 * current_time_scale;
						
						if(abs(wobble_num) < 0.5){
							wobble_num = 0;
							with(target) image_angle = 0;
						}
					}
				}
			}
			
			 // Emergency Activation:
			if(!instance_exists(NothingSpiral)){
				var _instTopIdle = instances_matching_gt(_instTop, "jump_time", 60);
				if(array_length(_instTopIdle)){
					if(instance_number(enemy) - array_length(_instTopIdle) < 5 * (1 + GameCont.loops) * (1 + (crown_current == crwn_blood))){
						with(instance_random(_instTopIdle)){
							jump_time = random_range(1, 60);
						}
					}
				}
			}
			
			 // Throne II Abyss:
			else with(_instTop){
				 // Delete if directly above any floors cause the portal background & floor stalactites draw at the same depth :(
				if(type != RavenFly && array_length(instances_matching_gt(instances_matching_lt(instances_matching_gt(Floor, "bbox_top", y), "bbox_left", x), "bbox_right", x)) > 0){
					if(instance_exists(target)){
						instance_delete(target);
					}
				}
				
				 // Fall Into Abyss:
				else{
					zspeed    = jump;
					zfriction = grav;
					if(type == enemy){
						motion_add(random(360), 2);
					}
				}
			}
		}
	}
	
#define ntte_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
			
			var _gray = (_type == "normal");
			
			 // Big Decals:
			var _inst = instances_matching(instances_matching(CustomObject, "name", "BigDecal"), "area", area_caves, area_cursed_caves);
			if(array_length(_inst)){
				var _r = 40 + (56 * _gray);
				with(_inst){
					draw_circle(x, y - 8, _r, false);
				}
			}
			
			 // Pets:
			if(instance_exists(CustomHitme)){
				var _inst = instances_matching(instances_matching(CustomHitme, "name", "Pet"), "visible", true);
				if(array_length(_inst)) with(_inst){
					if(light && light_radius[_gray] > 0){
						draw_circle(x, y, light_radius[_gray] + orandom(1), false);
					}
				}
			}
			
			 // Portal Guardians:
			if(instance_exists(CustomEnemy)){
				var _inst = instances_matching(CustomEnemy, "name", "PortalGuardian");
				if(array_length(_inst)){
					var _r = 24 + (68 * _gray),
						_o = 4  + (2  * _gray);
						
					with(_inst){
						draw_circle(x, y, _r + random(_o), false);
					}
				}
			}
			
			break;
	}
	
#define ntte_bloom
	if(instance_exists(CustomProjectile)){
		 // Custom Bullets/Plasma:
		var _inst = instances_matching(CustomProjectile, "name", "CustomBullet", "CustomPlasma");
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
		}
		
		 // Custom Shells/Flak:
		var _inst = instances_matching(CustomProjectile, "name", "CustomFlak", "CustomShell");
		if(array_length(_inst)) with(_inst){
			if(bonus > 0){
				draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.3 * bonus * image_alpha);
			}
			draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
		}
		
		 // Crab Venom:
		var _inst = instances_matching(CustomProjectile, "name", "VenomPellet");
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.2 * image_alpha);
		}
		
		 // Portal Ball:
		var _inst = instances_matching(CustomProjectile, "name", "PortalBullet");
		if(array_length(_inst)) with(_inst){
			draw_sprite_ext(sprite_index, image_index, x, y, 2 * image_xscale, 2 * image_yscale, image_angle, image_blend, 0.1 * image_alpha);
		}
		
		 // Merged Flak Ball:
		var _inst = instances_matching(CustomProjectile, "name", "MergeFlak");
		if(array_length(_inst)) with(_inst){
			var	_scale = 1.5,
				_alpha = 0.1 * clamp(array_length(inst) / 12, 1, 2);
				
			if(array_length(instances_matching(inst, "name", name))){
				_alpha *= 1.5;
			}
			
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * _scale, image_yscale * _scale, rotation, image_blend, image_alpha * _alpha);
		}
	}
	
	 // GunCont (Laser Cannon):
	if(instance_exists(CustomObject)){
		var _inst = instances_matching_gt(instances_matching(CustomObject, "name", "GunCont"), "bloom", 0);
		if(array_length(_inst)) with(_inst){
			var _scr = on_draw;
			if(array_length(_scr) >= 3){
				var	_xsc = 2,
					_ysc = 2,
					_alp = 0.1 * bloom;
					
				image_xscale *= _xsc;
				image_yscale *= _ysc;
				image_alpha  *= _alp;
				
				mod_script_call(_scr[0], _scr[1], _scr[2]);
				
				image_xscale /= _xsc;
				image_yscale /= _ysc;
				image_alpha  /= _alp;
			}
		}
	}
	
#define ntte_shadows
	 // Top Objects:
	if(!instance_exists(NothingSpiral) && instance_exists(CustomObject)){
		var _inst = instances_matching(instances_matching_ne(instance_rectangle_bbox(global.floor_left, global.floor_top, global.floor_right, global.floor_bottom, instances_matching(CustomObject, "name", "TopObject")), "spr_shadow", -1), "visible", true);
		if(array_length(_inst)) with(_inst){
			var	_xsc = image_xscale,
				_ysc = image_yscale;
				
			image_xscale = 1;
			image_yscale = 1;
			
			if(place_meeting(x + spr_shadow_x, y + spr_shadow_y, Floor) && "visible" in target && target.visible){
				draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
			}
			
			image_xscale = _xsc;
			image_yscale = _ysc;
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