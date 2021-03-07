#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Mod Lists:
	ntte_mods = mod_variable_get("mod", "teassets", "mods");
	
	 // Bind Events:
	global.portal_pickups_bind = script_bind(CustomStep,      portal_pickups_step,                        0, false);
	global.rad_path_bind       = script_bind(CustomEndStep,   rad_path_step,                              0, false);
	global.floor_reveal_bind   = script_bind(CustomDraw,      floor_reveal_draw,                         -8, false);
	
	 // Object List (Used for cheats mod, basically):
	ntte_obj_list = ds_map_create();
	ntte_obj_list[? "tegeneral"  ] = ["AlertIndicator", "BigDecal", "BigIDPDSpawn", "BoneArrow", "BoneSlash", "BoneFX", "BuriedVault", "BuriedShrine", "CustomBullet", "CustomFlak", "CustomShell", "CustomPlasma", "GroundFlameGreen", "Igloo", "MergeFlak", "Pet", "PetRevive", "PetWeaponBecome", "PetWeaponBoss", "PortalPrevent", "ReviveNTTE", "SmallGreenExplosion", "TopDecal", "TopObject", "TopTiny", "WallDecal", "WallEnemy"];
	ntte_obj_list[? "tepickups"  ] = ["Backpack", "Backpacker", "BackpackPickup", "BatChest", /*"BloodLustPickup",*/ "BoneBigPickup", "BonePickup", "BonusAmmoChest", "BonusAmmoMimic", "BonusAmmoPickup", "BonusHealthChest", "BonusHealthMimic", "BonusHealthPickup", "BuriedVaultChest", "BuriedVaultChestDebris", "BuriedVaultPedestal", "CatChest", "ChestShop", "CursedAmmoChest", "CursedMimic", "CustomChest", "CustomPickup", "GatorStatue", "GatorStatueFlak", "HammerHeadPickup", "HarpoonPickup", "OrchidBall", "OrchidChest", "OrchidSkill", "PalaceAltar", "ParrotFeather", "ParrotChester", "Pizza", "PizzaChest", "PizzaStack", "Prompt", "RedAmmoChest", "RedAmmoPickup", "SpiritPickup", "SunkenChest", "SunkenCoin", "VaultFlower", "VaultFlowerSparkle", "WepPickupGrounded", "WepPickupStick"];
	ntte_obj_list[? "tedesert"   ] = ["BabyScorpion", "BabyScorpionGold", "BanditCamper", "BanditHiker", "BanditTent", "BigCactus", "BigMaggotSpawn", "Bone", "CoastBossBecome", "CoastBoss", "CowSkull", "FlySpin", "VenomBlast", "ScorpionRock", "SilverScorpion", "SilverScorpionDevastator", "SilverScorpionFlak", "VenomFlak", "VenomPellet", "VenomPelletBack", "WantBigMaggot"];
	ntte_obj_list[? "tecoast"    ] = ["BloomingAssassin", "BloomingAssassinHide", "BloomingBush", "BloomingCactus", "BuriedCar", "ClamShield", "ClamShieldSlash", "CoastBigDecal", "CoastDecal", "CoastDecalCorpse", "Creature", "Diver", "DiverHarpoon", "Gull", "Harpoon", "HarpoonStick", "NetNade", "Palanking", "PalankingDie", "PalankingSlash", "PalankingSlashGround", "PalankingStatue", "PalankingToss", "Palm", "Pelican", "Seal", "SealAnchor", "SealDisc", "SealHeavy", "SealMine", "TrafficCrab", "Trident"];
	ntte_obj_list[? "teoasis"    ] = ["BubbleBomb", "BubbleExplosion", "BubbleExplosionSmall", "BubbleSlash", "CrabTank", "HammerShark", "HyperBubble", "OasisPetBecome", "Puffer", "SunkenRoom", "SunkenSealSpawn", "WaterStreak"];
	ntte_obj_list[? "tetrench"   ] = ["Angler", "AnglerGold", "Eel", "EelSkull", "ElectroPlasma", "ElectroPlasmaBig", "ElectroPlasmaImpact", "Jelly", "JellyElite", "Kelp", "LightningDisc", "PitSpark", "PitSquid", "PitSquidArm", "PitSquidBomb", "PitSquidDeath", "QuasarBeam", "QuasarRing", "TeslaCoil", "TopDecalWaterMine", "TrenchFloorChunk", "Vent", "WantEel"];
	ntte_obj_list[? "tesewers"   ] = ["AlbinoBolt", "AlbinoGator", "AlbinoGrenade", "BabyGator", "Bat", "BatBoss", "BatCloud", "BatDisc", "BatScreech", "BoneGator", /*"BossHealFX",*/ "Cabinet", "Cat", "CatBoss", "CatBossAttack", "CatDoor", "CatDoorDebris", "CatGrenade", "CatHole", "CatHoleBig", "CatLight", "ChairFront", "ChairSide", "Couch", "LairBorder", "Manhole", "ManholeOpen", "NewTable", "Paper", "PizzaDrain", "PizzaManholeCover", "PizzaRubble", "PizzaTV", "SewerDrain", "SewerRug", "TurtleCool"];
	ntte_obj_list[? "tescrapyard"] = ["BoneRaven", "SawTrap", "SludgePool", "TopRaven", "TrapSpin", "Tunneler"];
	ntte_obj_list[? "tecaves"    ] = ["BigCrystalProp", "ChaosHeart", "CrystalBat", "CrystalBrain", "CrystalBrainDeath", "CrystalBrainEffect", "CrystalClone", "CrystalHeart", "CrystalHeartBullet", "CrystalPropRed", "CrystalPropWhite", "EnergyBatSlash", "InvCrystalBat", "InvMortar", "MinerBandit", "Mortar", "MortarPlasma", "NewCocoon", "PlasmaImpactSmall", "RedBullet", "RedExplosion", "RedShank", "RedSlash", "RedSpider", "Spiderling", "Tesseract", "TesseractArmDeath", "TesseractDeath", "TesseractStrike", /*"TesseractWarp",*/ "TwinOrbital", "VlasmaBullet", "VlasmaCannon", "WallFake", "Warp", "WarpPortal"];
	ntte_obj_list[? "telabs"     ] = ["Button", "ButtonChest", "ButtonOld", "ButtonPickup", "ButtonReviveArea", "FreakChamber", "MutantVat", "PickupReviveArea", "PopoSecurity", "PortalBullet", "PortalGuardian", "WallSlide"];
	
	 // Object Create Event Script References:
	ntte_obj_scrt = ds_map_create();
	with(ds_map_keys(ntte_obj_list)){
		var	_modName = self,
			_modObjs = ntte_obj_list[? _modName];
			
		with(_modObjs){
			var _name = self;
			ntte_obj_scrt[? _name] = script_ref_create_ext("mod", _modName, _name + "_create");
		}
	}
	
	 // Object Event References:
	ntte_obj_event = ds_map_create();
	with([CustomObject, CustomHitme, CustomProp, CustomProjectile, CustomSlash, CustomEnemy]){
		var _eventList = [];
		with(instance_create(0, 0, self)){
			with(["step", "begin_step", "end_step", "draw", "destroy", "cleanup", "anim", "death", "hurt", "hit", "wall", "projectile", "grenade"]){
				if(("on_" + self) in other){
					array_push(_eventList, self);
				}
			}
			instance_delete(self);
		}
		if(array_find_index(_eventList, "step") >= 0){
			for(var i = ntte_alarm_min; i < ntte_alarm_max; i++){
				array_push(_eventList, `alrm${i}`);
			}
		}
		ntte_obj_event[? self] = _eventList;
	}
	
	 // Object Script Binding:
	ntte_obj_bind      = ds_map_create();
	ntte_obj_bind_draw = ds_map_create();
	
	 // Lag Debugging:
	lag_bind = ds_map_create();
	
	 // Projectile Team Variants:
	var _teamGrid = [
		[[spr.EnemyBullet,             EnemyBullet4  ], [sprBullet1,            Bullet1        ], [sprIDPDBullet,        IDPDBullet    ]], // Bullet
		[[sprEnemyBulletHit                          ], [sprBulletHit                          ], [sprIDPDBulletHit                    ]], // Bullet Hit
		[[spr.EnemyHeavyBullet,        "CustomBullet"], [sprHeavyBullet,        HeavyBullet    ], [                                    ]], // Heavy Bullet
		[[spr.EnemyHeavyBulletHit                    ], [sprHeavyBulletHit                     ], [                                    ]], // Heavy Bullet Hit
		[[sprLHBouncer,                LHBouncer     ], [sprBouncerBullet,      BouncerBullet  ], [                                    ]], // Bouncer Bullet
		[[sprLHBouncer,                LHBouncer     ], [sprBouncerShell,       BouncerBullet  ], [                                    ]], // Bouncer Bullet 2
		[[sprEnemyBullet1,             EnemyBullet1  ], [sprAllyBullet,         AllyBullet     ], [                                    ]], // Bandit Bullet
		[[sprEnemyBulletHit                          ], [sprAllyBulletHit                      ], [sprIDPDBulletHit                    ]], // Bandit Bullet Hit
		[[sprEnemyBullet4,             EnemyBullet4  ], [spr.AllySniperBullet,  AllyBullet     ], [                                    ]], // Sniper Bullet
		[[sprEBullet3,                 EnemyBullet3  ], [sprBullet2,            Bullet2        ], [                                    ]], // Shell
		[[sprEBullet3Disappear,        EnemyBullet3  ], [sprBullet2Disappear,   Bullet2        ], [                                    ]], // Shell Disappear
		[[spr.EnemySlug,               "CustomShell" ], [sprSlugBullet,         Slug           ], [sprPopoSlug,          PopoSlug      ]], // Slug
		[[spr.EnemySlugDisappear,      "CustomShell" ], [sprSlugDisappear,      Slug           ], [sprPopoSlugDisappear, PopoSlug      ]], // Slug Disappear
		[[spr.EnemySlugHit                           ], [sprSlugHit                            ], [sprIDPDBulletHit                    ]], // Slug Hit
		[[spr.EnemySlug,               "CustomShell" ], [sprHyperSlug,          Slug           ], [sprPopoSlug,          PopoSlug      ]], // Hyper Slug
		[[spr.EnemySlugDisappear,      "CustomShell" ], [sprHyperSlugDisappear, Slug           ], [sprPopoSlugDisappear, PopoSlug      ]], // Hyper Slug Disappear
		[[spr.EnemyHeavySlug,          "CustomShell" ], [sprHeavySlug,          HeavySlug      ], [                                    ]], // Heavy Slug
		[[spr.EnemyHeavySlugDisappear, "CustomShell" ], [sprHeavySlugDisappear, HeavySlug      ], [                                    ]], // Heavy Slug Disappear
		[[spr.EnemyHeavySlugHit                      ], [sprHeavySlugHit,                      ], [                                    ]], // Heavy Slug Hit
		[[sprEFlak,                    "CustomFlak"  ], [sprFlakBullet,         FlakBullet     ], [                                    ]], // Flak
		[[sprEFlakHit                                ], [sprFlakHit                            ], [                                    ]], // Flak Hit
		[[spr.EnemySuperFlak,          "CustomFlak"  ], [sprSuperFlakBullet,    SuperFlakBullet], [                                    ]], // Super Flak
		[[spr.EnemySuperFlakHit                      ], [sprSuperFlakHit                       ], [                                    ]], // Super Flak Hit
		[[sprEFlak,                    EFlakBullet   ], [sprFlakBullet,         "CustomFlak"   ], [                                    ]], // Gator Flak
		[[sprTrapFire                                ], [sprWeaponFire                         ], [sprFireLilHunter                    ]], // Fire
		[[sprSalamanderBullet                        ], [sprDragonFire                         ], [sprFireLilHunter                    ]], // Fire 2
		[[sprTrapFire                                ], [sprCannonFire                         ], [sprFireLilHunter                    ]], // Fire 3
	//	[[sprFireBall                                ], [sprFireBall                           ], [                                    ]], // Fire Ball
	//	[[sprFireShell                               ], [sprFireShell                          ], [                                    ]], // Fire Shell
		[[sprEnemyLaser,               EnemyLaser    ], [sprLaser,              Laser          ], [                                    ]], // Laser
		[[sprEnemyLaserStart                         ], [sprLaserStart                         ], [                                    ]], // Laser Start
		[[sprEnemyLaserEnd                           ], [sprLaserEnd                           ], [                                    ]], // Laser End
		[[sprLaserCharge                             ], [spr.AllyLaserCharge                   ], [                                    ]], // Laser Particle
		[[sprEnemyLightning,           EnemyLightning], [sprLightning,          Lightning      ], [                                    ]], // Lightning
	//	[[sprLightningHit                            ], [sprLightningHit                       ], [                                    ]], // Lightning Hit
	//	[[sprLightningSpawn                          ], [sprLightningSpawn                     ], [                                    ]], // Lightning Particle
		[[spr.EnemyPlasmaBall,         "CustomPlasma"], [sprPlasmaBall,         PlasmaBall     ], [sprPopoPlasma,        PopoPlasmaBall]], // Plasma
		[[spr.EnemyPlasmaBig,          "CustomPlasma"], [sprPlasmaBallBig,      PlasmaBig      ], [                                    ]], // Plasma Big
		[[spr.EnemyPlasmaHuge,         "CustomPlasma"], [sprPlasmaBallHuge,     PlasmaHuge     ], [                                    ]], // Plasma Huge
		[[spr.EnemyPlasmaImpact                      ], [sprPlasmaImpact                       ], [sprPopoPlasmaImpact                 ]], // Plasma Impact
		[[spr.EnemyPlasmaImpactSmall                 ], [spr.PlasmaImpactSmall                 ], [spr.PopoPlasmaImpactSmall           ]], // Plasma Impact Small
		[[spr.EnemyPlasmaTrail                       ], [sprPlasmaTrail                        ], [sprPopoPlasmaTrail                  ]], // Plasma Particle
		[[spr.EnemyVlasmaBullet                      ], [spr.VlasmaBullet                      ], [spr.PopoVlasmaBullet                ]], // Vector Plasma
		[[spr.EnemyVlasmaCannon                      ], [spr.VlasmaCannon                      ], [spr.PopoVlasmaCannon                ]], // Vector Plasma Cannon
		[[sprEnemySlash                              ], [sprSlash                              ], [sprEnemySlash                       ]]  // Slash
		// Devastator
		// Lightning Cannon
		// Hyper Slug (kinda)
	];
	
	sprite_team_map     = ds_map_create();
	team_sprite_map     = ds_map_create();
	team_sprite_obj_map = ds_map_create();
	
	with(_teamGrid){
		var	_teamList = self,
			_teamSize = array_length(_teamList),
			_sprtList = array_create(_teamSize, -1),
			_objsList = array_create(_teamSize, -1);
			
		for(var i = 0; i < _teamSize; i++){
			var _team = _teamList[i];
			if(array_length(_team)){
				_sprtList[i] = _team[0];
				if(array_length(_team) > 1){
					_objsList[i] = _team[1];
				}
			}
		}
		
		 // Compiling Sprite Maps:
		with(_sprtList){
			var _sprt = self;
			if(sprite_exists(_sprt)){
				if(!ds_map_exists(team_sprite_map, _sprt)){
					team_sprite_map[? _sprt] = _sprtList;
				}
				if(!ds_map_exists(sprite_team_map, _sprt)){
					sprite_team_map[? _sprt] = sprite_team_start + array_find_index(_sprtList, _sprt);
				}
			}
		}
		
		 // Compiling Object~Object Map:
		with(_objsList){
			var _obj = self;
			if(!is_real(_obj) || object_exists(_obj)){
				if(!ds_map_exists(team_sprite_obj_map, _obj)){
					var _map = ds_map_create();
					
					with(_teamGrid){
						var	_tList = self,
							_tSize = array_length(_tList),
							_sList = array_create(_tSize, -1),
							_oList = array_create(_tSize, -1);
							
						for(var i = 0; i < _tSize; i++){
							var _team = _tList[i];
							if(array_length(_team)){
								_sList[i] = _team[0];
								if(array_length(_team) > 1){
									_oList[i] = _team[1];
								}
							}
						}
						
						for(var i = 0; i < _tSize; i++){
							if(_oList[i] == _obj){
								var _sprt = _sList[i];
								if(!ds_map_exists(_map, _sprt)) _map[? _sprt] = _oList;
							}
						}
					}
					
					team_sprite_obj_map[? _obj] = _map;
				}
			}
		}
	}
	
	 // floor_set():
	floor_reset_style();
	floor_reset_align();
	
	 // sleep_max():
	global.sleep_max = 0;
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#macro lag      global.debug_lag
#macro lag_bind global.debug_lag_bind

#macro ntte_mods global.mods

#macro area_campfire     0
#macro area_desert       1
#macro area_sewers       2
#macro area_scrapyards   3
#macro area_caves        4
#macro area_city         5
#macro area_labs         6
#macro area_palace       7
#macro area_vault        100
#macro area_oasis        101
#macro area_pizza_sewers 102
#macro area_mansion      103
#macro area_cursed_caves 104
#macro area_jungle       105
#macro area_hq           106
#macro area_crib         107

#macro infinity 1/0

#macro mod_current_type script_ref_create(0)[0]

#macro instance_max instance_create(0, 0, DramaCamera)

#macro current_frame_active ((current_frame % 1) < current_time_scale)

#macro anim_end (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0)

#macro bbox_center_x (bbox_left + bbox_right + 1) / 2
#macro bbox_center_y (bbox_top + bbox_bottom + 1) / 2
#macro bbox_width    (bbox_right  + 1) - bbox_left
#macro bbox_height   (bbox_bottom + 1) - bbox_top

#macro FloorNormal instances_matching(Floor, "object_index", Floor)

#macro ntte_alarm_min 0
#macro ntte_alarm_max 10

#macro ntte_obj_event     global.object_event
#macro ntte_obj_list      global.object_list
#macro ntte_obj_scrt      global.object_scrt
#macro ntte_obj_bind      global.object_bind
#macro ntte_obj_bind_draw global.object_bind_draw

#macro sprite_team_start   1
#macro sprite_team_map     global.sprite_team_map
#macro team_sprite_map     global.team_sprite_map
#macro team_sprite_obj_map global.team_sprite_object_map

#define obj_create(_x, _y, _name)
	 // Normal Object:
	if(is_real(_name) && object_exists(_name)){
		return instance_create(_x, _y, _name);
	}
	
	 // Search for Create Event if Unstored:
	if(!ds_map_exists(ntte_obj_scrt, _name) && is_string(_name)){
		with(ds_map_keys(ntte_obj_list)){
			var _modName = self;
			if(mod_script_exists("mod", _modName, _name + "_create")){
				ntte_obj_scrt[? _name] = script_ref_create_ext("mod", _modName, _name + "_create");
				break;
			}
		}
	}
	
	 // Creating Object:
	if(ds_map_exists(ntte_obj_scrt, _name)){
		 // Call Create Event:
		var	_scrt = array_combine(ntte_obj_scrt[? _name], [_x, _y]),
			_inst = script_ref_call(_scrt);
			
		if(is_undefined(_inst) || _inst == 0){
			_inst = noone;
		}
		
		 /// Auto Assign Things:
		if(is_real(_inst) && instance_exists(_inst)){
			with(_inst){
				name = _name;
				
				var	_isCustom = ds_map_exists(ntte_obj_event, object_index),
					_modType  = _scrt[0],
					_modName  = _scrt[1];
					
				 // Bind Events:
				with(
					_isCustom
					? ntte_obj_event[? object_index]
					: ["begin_step", "step", "end_step", "draw"]
				){
					var _event = self;
					if(("on_" + _event) not in _inst || is_undefined(variable_instance_get(_inst, "on_" + _event))){
						var _varName = (_isCustom ? "on_" : "ntte_bind_") + _event;
						if(_isCustom || _varName not in _inst || is_undefined(variable_instance_get(_inst, _varName))){
							var _modScrt = _name + "_" + _event;
							
							if(mod_script_exists(_modType, _modName, _modScrt)){
								variable_instance_set(_inst, _varName, script_ref_create_ext(_modType, _modName, _modScrt));
								
								 // Auto Script Binding:
								if(!_isCustom){
									if(!ds_map_exists(ntte_obj_bind, _event)){
										ntte_obj_bind[? _event] = {
											"list"        : [],
											"object_list" : []
										};
									}
									var _bind = ntte_obj_bind[? _event];
									
									 // Bind Draw Event:
									if(_event == "draw"){
										if(!ds_map_exists(ntte_obj_bind_draw, _inst.depth)){
											with(script_bind_draw(obj_draw, _inst.depth)){
												persistent = true;
												ntte_obj_bind_draw[? depth] = self;
											}
										}
									}
									
									 // Add to Instance List:
									array_push(_bind.list, _inst);
									
									 // Add to Object List:
									var	_obj     = _inst.object_index,
										_objList = _bind.object_list;
										
									if(array_length(_objList)){
										 // Object/Parents Already in List:
										for(var i = _obj; object_exists(i); i = object_get_parent(i)){
											if(array_find_index(_objList, i) >= 0){
												_obj = -1;
												break;
											}
										}
									}
									if(object_exists(_obj)){
										 // Remove Children From List:
										with(_objList){
											if(object_is_ancestor(self, _obj)){
												_objList = array_delete_value(_objList, self);
											}
										}
										
										 // Add:
										array_push(_objList, _obj);
										_bind.object_list = _objList;
									}
								}
							}
							
							 // Defaults:
							else if(_isCustom){
								with(_inst){
									switch(_event){
										case "hurt":
											on_hurt = enemy_hurt;
											break;
											
										case "draw":
											if(instance_is(self, CustomEnemy)){
												on_draw = draw_self_enemy;
											}
											break;
									}
								}
							}
						}
					}
				}
				
				 // Automatic Stuff:
				if(_isCustom){
					on_create = script_ref_create(obj_create, _x, _y, _name);
					
					 // hitmes:
					if(instance_is(self, hitme)){
						 // Fill HP:
						if(my_health == 1){
							if(instance_is(self, CustomHitme) || instance_is(self, CustomProp)){
								my_health = maxhealth;
							}
						}
						
						 // Set Sprite:
						if(sprite_index == -1 && "spr_idle" in self){
							sprite_index = spr_idle;
						}
					}
				}
			}
		}
		
		return _inst;
	}
	
	 // Return List of Objects:
	else if(is_undefined(_name)){
		var _list = [];
		
		with(ds_map_values(ntte_obj_list)){
			_list = array_combine(_list, self);
		}
		
		return _list;
	}
	
	return noone;
	
#define ntte_update(_newID)
	 // Bound Events, 'instance_copy()' Fix:
	if(ds_map_size(ntte_obj_bind)){
		with(ds_map_keys(ntte_obj_bind)){
			var	_event    = self,
				_bind     = ntte_obj_bind[? _event],
				_instList = _bind.list;
				
			with(_bind.object_list){
				if(instance_exists(self) && self.id > _newID){
					var _inst = instances_matching_ne(instances_matching_gt(self, "id", _newID), "ntte_bind_" + _event, null);
					if(array_length(_inst)){
						with(_inst){
							if(array_find_index(_instList, self) < 0){
								variable_instance_set(self, "ntte_bind_" + _event, array_clone(variable_instance_get(self, "ntte_bind_" + _event)));
								array_push(_instList, self);
							}
						}
					}
				}
			}
		}
	}
	
#define ntte_begin_step
	 // sleep_max():
	if(global.sleep_max > 0){
		sleep(global.sleep_max);
		global.sleep_max = 0;
	}
	
	 // Bound Begin Step Events:
	if(!obj_bind_call("begin_step")){
		ds_map_delete(ntte_obj_bind, "begin_step");
	}
	
	 // Lag Debugging:
	lag_bind_call("begin_step");
	
#define ntte_step
	 // Bound Step Events:
	if(!obj_bind_call("step")){
		ds_map_delete(ntte_obj_bind, "step");
	}
	
	 // Lag Debugging:
	lag_bind_call("step");
	
#define ntte_end_step
	 // Bound End Step Events:
	if(!obj_bind_call("end_step")){
		ds_map_delete(ntte_obj_bind, "end_step");
	}
	
	 // Bound Draw Event Depth Update:
	if(ds_map_exists(ntte_obj_bind, "draw")){
		var _inst = ntte_obj_bind[? "draw"].list;
		with(ds_map_keys(ntte_obj_bind_draw)){
			_inst = instances_matching_ne(_inst, "depth", self);
		}
		if(array_length(_inst)){
			with(_inst){
				with(script_bind_draw(obj_draw, depth)){
					persistent = true;
					ntte_obj_bind_draw[? depth] = self;
				}
			}
		}
	}
	
	 // Lag Debugging:
	lag_bind_call("end_step");
	
#define obj_draw
	if(lag) trace_time();
	
	 // Bound Draw Events:
	if(!obj_bind_call("draw")){
		ds_map_delete(ntte_obj_bind_draw, depth);
		if(!ds_map_size(ntte_obj_bind_draw)){
			ds_map_delete(ntte_obj_bind, "draw");
		}
		instance_destroy();
		exit;
	}
	
	if(lag) trace_time(`obj_draw, ${depth}`);
	
#define obj_bind_call(_event)
	/*
		Calls the given event for the instances bound to it
	*/
	
	if(ds_map_exists(ntte_obj_bind, _event)){
		var _bind = ntte_obj_bind[? _event],
			_inst = instances_matching_ne(_bind.list, "id", null);
			
		_bind.list = _inst;
		
		 // Match Depth:
		if(_event == "draw"){
			_inst = instances_matching(_inst, "depth", depth);
		}
		
		 // Call Scripts:
		if(array_length(_inst)){
			switch(_event){
				case "begin_step":
					with(_inst){
						mod_script_call_self(ntte_bind_begin_step[0], ntte_bind_begin_step[1], ntte_bind_begin_step[2]);
					}
					break;
					
				case "step":
					with(_inst){
						mod_script_call_self(ntte_bind_step[0], ntte_bind_step[1], ntte_bind_step[2]);
					}
					break;
				
				case "end_step":
					with(_inst){
						mod_script_call_self(ntte_bind_end_step[0], ntte_bind_end_step[1], ntte_bind_end_step[2]);
					}
					break;
				
				case "draw":
					with(instances_matching(_inst, "visible", true)){
						mod_script_call_self(ntte_bind_draw[0], ntte_bind_draw[1], ntte_bind_draw[2]);
					}
					break;
			}
			
			return true;
		}
	}
	
	return false;
	
#define lag_bind_call(_event)
	/*
		Overrides all "Custom" object step events for debugging lag
	*/
	
	if((ds_map_exists(lag_bind, _event) && lag_bind[? _event]) || lag){
		lag_bind[? _event] = lag;
		
		var _obj = [CustomObject, CustomHitme, CustomEnemy, CustomProp, CustomProjectile];
		
		if(lag){
			trace_time("pre-on_" + _event);
			
			 // Enable Events:
			with(instances_matching_ne(_obj, "ntte_lag_" + _event, null)){
				variable_instance_set(self, "on_" + _event, variable_instance_get(self, "ntte_lag_" + _event));
			}
			
			 // Call Events:
			var _inst = instances_matching_ne(_obj, "on_" + _event, null);
			if(array_length(_inst)){
				trace_time();
				switch(_event){
					case "begin_step" : with(_inst) event_perform(ev_step, ev_step_begin);  break;
					case "step"       : with(_inst) event_perform(ev_step, ev_step_normal); break;	
					case "end_step"   : with(_inst) event_perform(ev_step, ev_step_end);    break;
				}
				trace_time(`on_${_event} (${array_length(_inst)})`);
				
				 // Disable Events:
				with(instances_matching_ne(_inst, "id", null)){
					variable_instance_set(self, "ntte_lag_" + _event, variable_instance_get(self, "on_" + _event));
					variable_instance_set(self, "on_"       + _event, []);
				}
			}
			
			trace_time();
		}
		
		 // Reset Events:
		else with(instances_matching_ne(_obj, "ntte_lag_" + _event, null)){
			variable_instance_set(self, "on_"       + _event, variable_instance_get(self, "ntte_lag_" + _event));
			variable_instance_set(self, "ntte_lag_" + _event, null);
		}
	}
	
/// SCRIPTS
#define trace_error(_error)
	trace(_error);
	trace_color(" ^ Screenshot that error and post it on NT:TE's itch.io page, thanks!", c_yellow);
	
#define draw_self_enemy()
	/*
		'draw_self()' for enemies
	*/
	
	image_xscale *= right;
	draw_self(); // This is faster than draw_sprite_ext yea
	image_xscale /= right;
	
#define draw_weapon(_sprite, _image, _x, _y, _angle, _angleMelee, _kick, _flip, _blend, _alpha)
	/*
		Drawing weapon sprites
		
		Ex:
			draw_weapon(sprBanditGun, gunshine, x, y, gunangle, 0, wkick, right, image_blend, image_alpha)
			draw_weapon(sprPipe, 0, x, y, gunangle, wepangle, wkick, wepflip, image_blend, image_alpha)
	*/
	
	 // Melee Offset:
	if(_angleMelee != 0){
		_angle += _angleMelee * (1 - (_kick / 20));
	}
	
	 // Kick:
	if(_kick != 0){
		_x -= lengthdir_x(_kick, _angle);
		_y -= lengthdir_y(_kick, _angle);
	}
	
	 // Draw:
	draw_sprite_ext(_sprite, _image, _x, _y, 1, _flip, _angle, _blend, _alpha);
	
#define draw_lasersight(_x, _y, _dir, _disMax, _width)
	/*
		Performs hitscan and draws a laser sight line
		Returns the line's ending position
	*/
	
	var	_dis  = _disMax,
		_disX = lengthdir_x(_dis, _dir),
		_disY = lengthdir_y(_dis, _dir);
		
	 // Major Hitscan Mode (Start at max, halve distance until no collision line):
	while(_dis >= 1 && collision_line(_x, _y, _x + _disX, _y + _disY, Wall, false, false)){
		_dis  /= 2;
		_disX /= 2;
		_disY /= 2;
	}
	
	 // Minor Hitscan Mode (Increment until walled):
	if(_dis < _disMax){
		var	_disAdd  = max(2, _dis / 32),
			_disAddX = lengthdir_x(_disAdd, _dir),
			_disAddY = lengthdir_y(_disAdd, _dir);
			
		while(_dis > 0 && !position_meeting(_x + _disX, _y + _disY, Wall)){
			_dis  -= _disAdd;
			_disX += _disAddX;
			_disY += _disAddY;
		}
	}
	
	 // Draw:
	draw_line_width(
		_x - 1,
		_y - 1,
		_x - 1 + _disX,
		_y - 1 + _disY,
		_width
	);
	
	return [_x + _disX, _y + _disY];
	
#define draw_surface_scale(_surf, _x, _y, _scale)
	/*
		Draws a given surface at a given position with a given scale
		Useful when working with surfaces that support pixel scaling
	*/
	
	draw_surface_ext(_surf, _x, _y, _scale, _scale, 0, c_white, draw_get_alpha());
	
#define draw_text_bn(_x, _y, _string, _angle)
	/*
		Draw big portrait name text
		Portrait names use an angle of 1.5
		
		Ex:
			draw_set_font(fntBigName)
			draw_text_bn(x, y, "FISH", 1.5);
	*/
	
	_string = string_upper(_string);
	
	var _col = draw_get_color();
	draw_set_color(c_black);
	draw_text_transformed(_x + 1, _y,     _string, 1, 1, _angle);
	draw_text_transformed(_x,     _y + 2, _string, 1, 1, _angle);
	draw_text_transformed(_x + 1, _y + 2, _string, 1, 1, _angle);
	draw_set_color(_col);
	draw_text_transformed(_x,     _y,     _string, 1, 1, _angle);
	
#define string_delete_nt(_string)
	/*
		Returns a given string with "draw_text_nt()" formatting removed
		
		Ex:
			string_delete_nt("@2(sprBanditIdle:0)@rBandit") == "  Bandit"
			string_width(string_delete_nt("@rHey")) == 3
	*/
	
	var	_split          = "@",
		_stringSplit    = string_split(_string, _split),
		_stringSplitMax = array_length(_stringSplit);
		
	for(var i = 1; i < _stringSplitMax; i++){
		if(_stringSplit[i - 1] != _split){
			var	_current = _stringSplit[i],
				_char    = string_upper(string_char_at(_current, 1));
				
			switch(_char){
				
				case "": // CANCEL : "@@rHey" -> "@rHey"
					
					if(i < _stringSplitMax - 1){
						_current = _split;
					}
					
					break;
					
				case "W":
				case "S":
				case "D":
				case "R":
				case "G":
				case "B":
				case "P":
				case "Y":
				case "Q": // BASIC : "@qHey" -> "Hey"
					
					_current = string_delete(_current, 1, 1);
					
					break;
					
				case "0":
				case "1":
				case "2":
				case "3":
				case "4":
				case "5":
				case "6":
				case "7":
				case "8":
				case "9": // SPRITE OFFSET : "@2(sprBanditIdle:1)Hey" -> "  Hey"
					
					if(string_char_at(_current, 2) == "("){
						_current = string_delete(_current, 1, 1);
						
						 // Offset if Drawing Sprite:
						var _spr = string_split(string_copy(_current, 2, string_pos(")", _current) - 2), ":")[0];
						if(
							real(_spr) > 0
							|| sprite_exists(asset_get_index(_spr))
							|| _spr == "sprKeySmall"
							|| _spr == "sprButSmall"
							|| _spr == "sprButBig"
						){
							// draw_text_nt uses width of "A" instead of " ", so this is slightly off on certain fonts
							if(string_width(" ") > 0){
								_current = string_repeat(" ", real(_char) * (string_width("A") / string_width(" "))) + _current;
							}
						}
					}
					
					 // NONE : "@2Hey" -> "@2Hey"
					else{
						_current = _split + _current;
						break;
					}
					
				case "(": // ADVANCED : "@(sprBanditIdle:1)Hey" -> "Hey"
					
					var	_bgn = string_pos("(", _current),
						_end = string_pos(")", _current);
						
					if(_bgn < _end){
						_current = string_delete(_current, _bgn, 1 + _end - _bgn);
						break;
					}
					
				default: // NONE : "@Hey" -> "@Hey"
					
					_current = _split + _current;
					
			}
			
			_stringSplit[i] = _current;
		}
	}
	
	return array_join(_stringSplit, "");
	
#define string_space(_string)
	/*
		Returns the given string with spaces inserted between numbers<->letters, letters<->numbers, and lowercase<->uppercase
		
		Ex:
			string_space("CoolGuy123") == "Cool Guy 123"
	*/
	
	var	_char     = "",
		_charLast = "",
		_charNext = "";
		
	for(var i = 0; i <= string_length(_string); i++){
		_charNext = string_char_at(_string, i + 1);
		
		if(
			(_char != string_lower(_char) && (_charLast != string_upper(_charLast) || (_charLast != string_lower(_charLast) && _charNext != string_upper(_charNext))))
			|| (string_digits(_char) != "" && string_letters(_charLast) != "")
			|| (string_letters(_char) != "" && string_digits(_charLast) != "") 
		){
			_string = string_insert(" ", _string, i);
			i++;
		}
		
		_charLast = _char;
		_char = _charNext;
	}
	
	return _string;
	
#define projectile_create(_x, _y, _obj, _dir, _spd)
	/*
		Creates a given projectile with the given motion applied
		Automatically sets 'team', 'creator', and 'hitid' based on the calling instance
		Automatically applies Euphoria to the projectile if the creator is an enemy
		
		Ex:
			projectile_create(x, y, Bullet2, gunangle + orandom(30), 16)
			projectile_create(x, y, "DiverHarpoon", gunangle, 7)
	*/
	
	var _inst = obj_create(_x, _y, _obj);
	
	with(_inst){
		 // Motion:
		direction += _dir;
		if(_spd != 0){
			motion_add(_dir, _spd);
		}
		image_angle += direction;
		
		 // Auto Setup:
		var	_team    = (("team" in other) ? other.team : (("team" in self) ? team : -1)),
			_creator = (("creator" in other && !instance_is(other, hitme)) ? other.creator : other);
			
		projectile_init(_team, _creator);
		
		if("team"    in self) team    = _team;
		if("creator" in self) creator = _creator;
		if("hitid"   in self) hitid   = (("hitid" in other) ? other.hitid : hitid);
		
		 // Euphoria:
		if(
			is_string(_obj)
			&& skill_get(mut_euphoria) != 0
			&& (instance_exists(_creator) ? instance_is(_creator, enemy) : (_team != 2))
			&& !instance_is(self, EnemyBullet1)
			&& !instance_is(self, EnemyBullet3)
			&& !instance_is(self, EnemyBullet4)
			&& !instance_is(self, HorrorBullet)
			&& !instance_is(self, IDPDBullet)
			&& !instance_is(self, PopoPlasmaBall)
			&& !instance_is(self, LHBouncer)
			&& !instance_is(self, FireBall)
			&& !instance_is(self, ToxicGas)
			&& !instance_is(self, Shank)
			&& !instance_is(self, Slash)
			&& !instance_is(self, EnemySlash)
			&& !instance_is(self, GuitarSlash)
			&& !instance_is(self, CustomSlash)
			&& !instance_is(self, BloodSlash)
			&& !instance_is(self, LightningSlash)
			&& !instance_is(self, EnergyShank)
			&& !instance_is(self, EnergySlash)
			&& !instance_is(self, EnergyHammerSlash)
			&& !instance_is(other, FireCont)
		){
			script_bind_begin_step(projectile_euphoria, 0, self);
		}
	}
	
	return _inst;
	
#define projectile_euphoria(_inst)
	with(_inst){
		speed *= power(0.8, skill_get(mut_euphoria));
	}
	instance_destroy();
	
#define enemy_hurt(_damage, _force, _direction)
	my_health -= _damage;           // Damage
	nexthurt = current_frame + 6;   // I-Frames
	motion_add(_direction, _force); // Knockback
	sound_play_hit(snd_hurt, 0.3);  // Sound
	
	 // Hurt Sprite:
	sprite_index = spr_hurt;
	image_index  = 0;
	
#define chest_create(_x, _y, _obj, _levelStart)
	/*
		Creates a given chest/mimic with some special spawn conditions applied, such as Crown of Love, Crown of Life, and Rogue
		!!! Don't use this for creating a custom area's basic chests during level gen, the game should handle that
		!!! Don't use this for replacing chests with custom chests, put that in level_start or something
		
		Ex:
			chest_create(x, y, WeaponChest, true)
			chest_create(x, y, "BatChest", false)
	*/
	
	if(
		is_string(_obj)
		|| object_is(_obj, chestprop)
		|| object_is(_obj, RadChest)
		|| object_is(_obj, Mimic)
		|| object_is(_obj, SuperMimic)
	){
		 // Rad Canisters:
		if(is_real(_obj) && object_is(_obj, RadChest)){
			if(_levelStart){
				 // Rogue:
				for(var i = 0; i < maxp; i++){
					if(player_get_race(i) == "rogue"){
						_obj = RogueChest;
						break;
					}
				}
				
				 // Low HP:
				if(chance(1, 2)){
					with(Player){
						if(my_health < (maxhealth + chickendeaths) / 2){
							_obj = HealthChest;
							break;
						}
					}
				}
				
				 // Legacy Revive Mode:
				var _players = 0;
				for(var i = 0; i < maxp; i++){
					_players += player_is_active(i);
				}
				if(instance_number(Player) < _players){
					_obj = HealthChest;
				}
			}
			
			 // More Health Chests:
			if(chance(2, 3) && crown_current == crwn_life){
				_obj = HealthChest;
			}
		}
		
		 // Only Ammo Chests:
		if(crown_current == crwn_love){
			if(!is_real(_obj) || !object_is(_obj, AmmoChest)){
				if(array_find_index([ProtoChest, RogueChest, "Backpack", "BonusAmmoChest", "BonusAmmoMimic", "BuriedVaultChest", "CatChest", "CursedAmmoChest", "CursedMimic", "SunkenChest"], _obj) < 0){
					var _name = (is_real(_obj) ? object_get_name(_obj) : _obj);
					if(string_pos("Mimic", _name) > 0){
						_obj = Mimic;
					}
					else if(string_pos("Giant", _name) > 0){
						_obj = GiantAmmoChest;
					}
					else{
						_obj = AmmoChest;
					}
				}
			}
		}
		
		if(_levelStart){
			 // Big Weapon Chests:
			if(chance(GameCont.nochest, 4) && _obj == WeaponChest){
				_obj = BigWeaponChest;
			}
			
			 // Mimics:
			if(!is_real(GameCont.area) || GameCont.area >= 2 || GameCont.loops >= 1){
				if(chance(1, 11) && is_real(_obj) && object_is(_obj, AmmoChest)){
					_obj = Mimic;
				}	
				if(chance(1, 51) && is_real(_obj) && object_is(_obj, HealthChest)){
					_obj = SuperMimic;
				}
			}
		}
	}
	
	 // Create:
	var	_inst   = noone,
		_rads   = GameCont.norads,
		_health = [];
		
	if(!_levelStart){
		GameCont.norads = 0;
		with(Player){
			array_push(_health, [self, my_health]);
			my_health = maxhealth;
		}
	}
	
	_inst = obj_create(_x, _y, _obj);
	
	if(!_levelStart){
		GameCont.norads = _rads;
		with(_health) with(self[0]){
			my_health = other[1];
		}
	}
	
	 // Replaced:
	if(!instance_exists(_inst)){
		with(instances_matching_gt([chestprop, RadChest, Mimic, SuperMimic], "id", _inst)){
			if(!instance_exists(_inst) || id < _inst){
				_inst = id;
			}
		}
	}
	
	return _inst;
	
#define object_is(_object, _parent)
	/*
		Returns whether the given object is a child of, or equal to, the given parent object (true) or not (false)
	*/
	
	return (_object == _parent || object_is_ancestor(_object, _parent));
	
#define chance(_numer, _denom)
	/*
		Returns true or false randomly, based on the given probability
		
		Ex:
			if(chance(1, 3)) trace("1/3 chance");
	*/
	
	return (random(_denom) < _numer);
	
#define chance_ct(_numer, _denom)
	/*
		Like 'chance()', but used when being called every frame (for timescale support)
	*/
	
	return (random(_denom) < _numer * current_time_scale);
	
#define lerp_ct(_val1, _val2, _amount)
	/*
		Like 'lerp()', but used when modifying a persistent value every frame (for timescale support)
	*/
	
	return lerp(_val2, _val1, power(1 - _amount, current_time_scale));
	
#define angle_lerp(_ang1, _ang2, _num)
	/*
		Linearly interpolates between the two given angles
		
		Ex:
			lerp(90, 180, 0.5) == 135
			lerp(20, 270, 0.1) == 9
	*/
	
	return _ang1 + (angle_difference(_ang2, _ang1) * _num);
	
#define angle_lerp_ct(_ang1, _ang2, _num)
	/*
		Like 'angle_lerp()', but used when modifying a persistent value every frame (for timescale support)
	*/
	
	return _ang2 + (angle_difference(_ang1, _ang2) * power(1 - _num, current_time_scale));
	
#define script_bind(_scriptObj, _scriptRef, _depth, _visible)
	return mod_script_call_nc('mod', 'teassets', 'script_bind', script_ref_create(script_bind), _scriptObj, (is_real(_scriptRef) ? script_ref_create(_scriptRef) : _scriptRef), _depth, _visible);
	
#define save_get(_name, _default)
	return mod_script_call_nc("mod", "teassets", "save_get", _name, _default);
	
#define save_set(_name, _value)
	mod_script_call_nc("mod", "teassets", "save_set", _name, _value);
	
#define option_get(_name)
	return mod_script_call_nc("mod", "teassets", "option_get", _name);
	
#define option_set(_name, _value)
	mod_script_call_nc("mod", "teassets", "option_set", _name, _value);
	
#define stat_get(_name)
	return mod_script_call_nc("mod", "teassets", "stat_get", _name);
	
#define stat_set(_name, _value)
	mod_script_call_nc("mod", "teassets", "stat_set", _name, _value);
	
#define unlock_get(_name)
	return mod_script_call_nc("mod", "teassets", "unlock_get", _name);
	
#define unlock_set(_name, _value)
	return mod_script_call_nc("mod", "teassets", "unlock_set", _name, _value);
	
#define unlock_get_name(_name)
	/*
		Returns the title associated with a given unlock's corner splat
	*/
	
	var _split = string_split(_name, ":");
	
	if(array_length(_split) >= 2){
		switch(_split[0]){
			
			case "pack": // PACK
				
				var _pack = _split[1];
				
				switch(_pack){
					case "coast"  : return "BEACH GUNS";
					case "oasis"  : return "BUBBLE GUNS";
					case "trench" : return "TECH GUNS";
					case "lair"   : return "SAWBLADE GUNS";
					case "red"    : return `@3(${spr.RedText}:-0.8) GUNS`;
					case "crown"  : return "CROWNS";
				}
					
				return _pack;
				
			case "race": // CHARACTER
				
				return race_get_title(_split[1]);
				
			case "skin": // SKIN
				
				var	_race = "",
					_skin = _split[1];
					
				 // Race Mod:
				if(array_length(_split) > 2){
					_race = _skin;
					_skin = real(_split[2]);
				}
				
				 // Skin Mod:
				else if(mod_exists("skin", _skin)){
					_race = mod_script_call("skin", _skin, "skin_race");
				}
				
				 // Get Unlock Name:
				var _skinName = string_upper(skin_get_name(_race, _skin));
				if(string_delete(_skinName, 1, string_length(_skinName) - 5) == " SKIN"){
					_skinName = race_get_title(_race) + " " + _skinName;
				}
				else{
					_skinName = _skinName + " " + race_get_title(_race);
				}
				
				return _skinName;
				
			case "wep": // WEAPON
				
				return weapon_get_name(_split[1]);
				
			case "crown": // CROWN
				
				return crown_get_name(_split[1]);
				
			case "loadout": // LOADOUT
				
				switch(_split[1]){
					
					case "wep":
						
						return weapon_get_name(unlock_get(_name));
						
					case "crown":
						
						if(array_length(_split) > 2){
							return crown_get_name(_split[2]) + "@s";
						}
						
						break;
						
				}
				
				break;
				
		}
	}
	
	return "";
	
#define unlock_get_text(_name)
	/*
		Returns the description associated with a given unlock's corner splat
	*/
	
	var _split = string_split(_name, ":");
	
	if(array_length(_split) >= 2){
		switch(_split[0]){
			
			case "pack": // PACK
				
				switch(_split[1]){
					case "coast"  : return "GRAB YOUR FRIENDS";
					case "oasis"  : return "SOAP AND WATER";
					case "trench" : return "TERRORS FROM THE DEEP";
					case "lair"   : return "DEVICES OF TORTURE";
					case "red"    : return "SPACE BENDS AND BREAKS";
				}
				
				break;
				
			case "race": // CHARACTER
				
				var	_race = _split[1],
					_text = mod_script_call("race", _race, "race_unlock");
					
				 // Loading Tip:
				if(!is_string(_text)){
					_text = mod_script_call("skin", _race, "race_ttip");
				}
				
				if(is_string(_text)){
					return _text;
				}
				
				break;
				
			case "skin": // SKIN
				
				var	_skin = _split[1],
					_text = "";
					
				 // Race Mod:
				if(array_length(_split) > 2){
					var _race = _skin;
					_skin = real(_split[2]);
					_text = mod_script_call("race", _race, "race_skin_unlock", _skin);
				}
				
				 // Skin Mod:
				else if(mod_exists("skin", _skin)){
					_text = mod_script_call("skin", _skin, "skin_unlock");
					
					 // Loading Tip:
					if(!is_string(_text)){
						_text = mod_script_call("skin", _skin, "skin_ttip");
					}
				}
				
				if(is_string(_text)){
					return _text;
				}
				
				break;
				
			case "wep": // WEAPON
				
				var	_wep  = _split[1],
					_text = mod_script_call("weapon", _wep, "weapon_unlock", _wep);
					
				 // Loading Tip:
				if(!is_string(_text)){
					_text = mod_script_call("weapon", _wep, "weapon_text", _wep);
				}
				
				if(is_string(_text)){
					return _text;
				}
				
				break;
				
			case "crown": // CROWN
				
				var	_crown = _split[1],
					_text  = mod_script_call("crown", _crown, "crown_unlock");
				
				 // Loading Tip:
				if(!is_string(_text)){
					_text = mod_script_call("weapon", _crown, "crown_tip");
				}
				
				if(is_string(_text)){
					return _text;
				}
				
				break;
				
			case "loadout": // LOADOUT
				
				switch(_split[1]){
					case "wep"   : return "STORED!";
					case "crown" : return "FOR @w" + ((array_length(_split) > 3) ? race_get_title(_split[3]) : "EVERYONE");
				}
				
				break;
		}
	}
	
	return "";
	
#define unlock_splat(_name, _text, _sprite, _sound)
	 // Make Sure UnlockCont Exists:
	if(!array_length(instances_matching(CustomObject, "name", "UnlockCont"))){
		obj_create(0, 0, "UnlockCont");
	}
	
	 // Add New Unlock:
	var _unlock = {
		"nam" : [_name, _name], // [splash popup, gameover popup]
		"txt" : _text,
		"spr" : _sprite,
		"img" : 0,
		"snd" : _sound
	};
	
	with(instances_matching(CustomObject, "name", "UnlockCont")){
		if(splash_index >= array_length(unlock) - 1 && splash_timer <= 0){
			splash_delay = 40;
		}
		array_push(unlock, _unlock);
	}
	
	return _unlock;
	
#define prompt_create(_text)
	/*
		Creates an E key prompt with the given text that targets the current instance
	*/
	
	with(obj_create(x, y, "Prompt")){
		text    = _text;
		creator = other;
		depth   = other.depth;
		
		return self;
	}
	
	return noone;
	
#define alert_create(_inst, _sprite)
	/*
		Creates an "AlertIndicator" with the given sprite that targets the given instance
		Automatically spaces out the icon and alert sprite from the instance so everything is readable
	*/
	
	 // Group:
	if((is_real(_inst) && object_exists(_inst)) || is_array(_inst)){
		var _list = [];
		with(_inst){
			array_push(_list, alert_create(self, _sprite));
		}
		return _list;
	}
	
	 // Normal:
	else{
		var	_x = 0,
			_y = 0;
			
		if(instance_exists(_inst)){
			_x = _inst.x;
			_y = _inst.y;
		}
		else{
			if("x" in self) _x = x;
			if("y" in self) _y = y;
		}
		
		with(obj_create(_x, _y, "AlertIndicator")){
			target       = _inst;
			sprite_index = _sprite;
			image_index  = irandom(image_number - 1);
			
			 // Auto-Offset:
			if(instance_exists(target)){
				var	_spr = ((target.sprite_index == sprAllyAppear) ? sprAllyIdle : target.sprite_index),
					_h1  = abs((sprite_get_yoffset(_spr) - sprite_get_bbox_top(_spr)) * image_yscale),
					_h2  = abs(((sprite_get_bbox_bottom(sprite_index) + 1) - sprite_get_yoffset(sprite_index)) * image_yscale);
					
				target_y = -(1 + _h1 + _h2);
			}
			alert.x = (sprite_get_bbox_left(sprite_index) - sprite_get_xoffset(sprite_index));
			
			return self;
		}
	}
	
	return noone;
	
#define charm_instance(_inst, _charm)
	/*
		Charms or uncharms the given instance(s) and returns a LWO containing their charm-related vars
		
		Ex:
			with(charm_instance(Bandit, true)){
				time = 300;
			}
	*/
	
	return mod_script_call_nc("race", "parrot", "charm_instance_raw", _inst, _charm);
	
#define boss_hp(_hp)
	var _players = 0;
	for(var i = 0; i < maxp; i++){
		_players += player_is_active(i);
	}
	return round(_hp * (1 + (1/3 * GameCont.loops)) * (1 + (0.5 * (_players - 1))));
	
#define boss_intro(_name)
	/*
		Plays a given boss's intro and their music
	*/
	
	 // Music:
	with(MusCont){
		alarm_set(2, 1);
		alarm_set(3, -1);
	}
	
	 // Bind begin_step to fix TopCont.darkness flash
	if(_name != ""){
		with(script_bind_begin_step(boss_intro_step, 0)){
			boss    = _name;
			loops   = 0;
			intro   = true;
			sprites = [
				[`sprites/intros/spr${boss}Main.png`, sprBossIntro,          0],
				[`sprites/intros/spr${boss}Back.png`, sprBossIntroBackLayer, 0],
				[`sprites/intros/spr${boss}Name.png`, sprBossName,           0]
			];
			
			 // Preload Sprites:
			with(sprites){
				if(!file_loaded(self[0])){
					file_load(self[0]);
				}
			}
			
			return self;
		}
	}
	
	return noone;

#define boss_intro_step
	if(intro){
		intro = false;
		
		 // Preload Sprites:
		with(sprites){
			if(!file_loaded(self[0])){
				other.intro = true;
				break;
			}
		}
		
		 // Boss Intro Time:
		if(!intro && option_get("intros") && GameCont.loops <= loops){
			 // Replace Big Bandit's Intro:
			with(sprites){
				if(file_exists(self[0])){
					sprite_replace_image(self[1], self[0], self[2]);
				}
			}
			
			 // Call Big Bandit's Intro:
			var	_lastSub   = GameCont.subarea,
				_lastLoop  = GameCont.loops,
				_lastIntro = UberCont.opt_bossintros;
				
			GameCont.loops          = 0;
			UberCont.opt_bossintros = true;
			
			with(instance_create(0, 0, BanditBoss)){
				with(self){
					event_perform(ev_alarm, 6);
				}
				sound_stop(sndBigBanditIntro);
				instance_delete(self);
			}
			
			GameCont.subarea        = _lastSub;
			GameCont.loops          = _lastLoop;
			UberCont.opt_bossintros = _lastIntro;
		}
	}
	
	 // End:
	else{
		with(sprites){
			sprite_restore(self[1]);
		}
		instance_destroy();
	}
	
#define scrFX(_x, _y, _motion, _object)
	/*
		Creates a given Effect object with the given motion applied
		Automatically reorients the effect towards its new direction
		
		Args:
			x/y    - Spawn position, can be a 2-element array for [position, randomized offset]
			motion - Can be a speed to apply toward a random direction, or a 2-element array to apply a [direction, speed]
			object - The effect's object index, or an NT:TE object's name string
			
		Ex:
			scrFX([x, 4], [y, 4], 3, Dust)
			scrFX(x, y, [90 + orandom(30), random(3)], AcidStreak);
	*/
	
	with(obj_create(
		(is_array(_x) ? (_x[0] + orandom(_x[1])) : _x),
		(is_array(_y) ? (_y[0] + orandom(_y[1])) : _y),
		_object
	)){
		var _face = (image_angle == direction || (speed == 0 && (object_index == AcidStreak || object_index == BloodStreak)));
		
		 // Motion:
		if(is_array(_motion)){
			motion_add(_motion[0], _motion[1]);
		}
		else{
			motion_add(random(360), _motion);
		}
		
		 // Facing:
		if(_face){
			image_angle = direction;
		}
		
		return self;
	}
	
	return noone;

#define corpse_drop(_dir, _spd)
	/*
		Creates a corpse with a given direction and speed
		Automatically transfers standard variables to the corpse and applies impact wrists
	*/
	
	with(instance_create(x, y, Corpse)){
		size         = other.size;
		sprite_index = other.spr_dead;
		image_xscale = variable_instance_get(other, "right", other.image_xscale);
		direction    = _dir;
		speed        = _spd;
		
		 // Non-Props:
		if(!instance_is(other, prop) && instance_is(other, hitme)){
			mask_index = other.mask_index;
			speed += max(0, -other.my_health / 5);
			speed += 8 * skill_get(mut_impact_wrists) * instance_is(other, enemy);
		}
		
		 // Clamp Speed:
		speed = min(speed, 16);
		if(size > 0) speed /= size;
		
        return self;
	}

#define player_swap()
	/*
		Swaps weapons and weapon-related vars
		Called from a Player object
	*/
	
	with(["%wep", "%curse", "%reload", "%wkick", "%wepflip", "%wepangle", "%can_shoot", "%interfacepop", "drawempty%"]){
		var	_name = [string_replace_all(self, "%", ""), string_replace_all(self, "%", "b")],
			_temp = variable_instance_get(other, _name[0]);
			
		variable_instance_set(other, _name[0], variable_instance_get(other, _name[1]));
		variable_instance_set(other, _name[1], _temp);
	}
	
	 // bclicked...
	clicked = false;
	
#define portal_poof()
	/*
		Get rid of normal portals, but make it look cool
	*/
	
	if(instance_exists(Portal)){
		var _inst = instances_matching(instances_matching(instances_matching(instances_matching(Portal, "object_index", Portal), "type", 1, 3), "endgame", 100), "image_alpha", 1);
		if(array_length(_inst)) with(_inst){
			if(!place_meeting(x, y, Player)){
				//sound_stop(sndPortalClose);
				sound_stop(sndPortalLoop);
				
				 // Guardian:
				if(
					visible
					&& type == 1
					&& endgame >= 100
					&& !position_meeting(x, y, PortalShock)
					&& point_seen_ext(x, y, -8, -8, -1)
					&& chance(1, 2)
				){
					with(obj_create(x, y, "PortalGuardian")){
						x = xstart;
						y = ystart;
						sprite_index = spr_appear;
						right = other.image_xscale;
						portal = true;
					}
					sound_play_hit_ext(
						asset_get_index(`sndPortalFlyby${irandom_range(1, 4)}`),
						2 + orandom(0.1),
						3
					);
				}
				
				 // Normal:
				else with(instance_create(x, y, BulletHit)){
					name         = "PortalPoof";
					sprite_index = [mskNone, sprPortalDisappear, sprProtoPortalDisappear, sprPopoPortalDisappear][other.type];
					image_xscale = other.image_xscale;
					image_yscale = other.image_yscale;
					image_angle  = other.image_angle;
					image_blend  = other.image_blend;
					image_alpha  = other.image_alpha;
					depth        = other.depth;
				}
				
				 // Rescue Players:
				if(timer > 30){
					with(instances_matching(instances_matching_ne(Player, "angle", 0), "roll", 0)){
						if(point_distance(x, y, other.x, other.y) < 48){
							if(!collision_line(x, y, other.x, other.y, Wall, false, false)){
								if(skill_get(mut_throne_butt) > 0){
									angle = 0;
								}
								else{
									roll = true;
								}
							}
						}
					}
				}
				
				instance_destroy();
			}
		}
	}
	
	 // Prevent Corpse Portal:
	if(instance_exists(Corpse)){
		var _inst = instances_matching_gt(Corpse, "alarm0", 0);
		if(array_length(_inst)) with(_inst){
			alarm0 = -1;
		}
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
				with(instances_matching_ne([AmmoPickup, HPPickup, RoguePickup], "id", null)){
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

#define orandom(_num)
	/*
		For offsets
	*/
	
	return random_range(-_num, _num);
	
#define pround(_num, _precision)
	/*
		Precision 'round()'
		
		Ex:
			pround(7, 3) == 6
	*/
	
	if(_precision != 0){
		return round(_num / _precision) * _precision;
	}
	
	return _num;
	
#define pfloor(_num, _precision)
	/*
		Precision 'floor()'
		
		Ex:
			pfloor(2.7, 0.5) == 2.5
	*/
	
	if(_precision != 0){
		return floor(_num / _precision) * _precision;
	}
	
	return _num;
	
#define pceil(_num, _precision)
	/*
		Precision 'ceil()'
		
		Ex:
			pceil(-9, 5) == -5
	*/
	
	if(_precision != 0){
		return ceil(_num / _precision) * _precision;
	}
	
	return _num;
	
#define array_count(_array, _value)
	/*
		Returns the number of times a given value was found in the given array
	*/
	
	var _count = 0;
	
	if(array_find_index(_array, _value) >= 0){
		with(_array){
			if(self == _value){
				_count++;
			}
		}
	}
	
	return _count;
	
#define array_flip(_array)
	/*
		Flips a given array
		
		Ex:
			array_flip([1, 7, 5, 9]) == [9, 5, 7, 1]
	*/
	
	var	a = array_clone(_array),
		m = array_length(_array);
		
	for(var i = 0; i < m; i++){
		_array[@i] = a[(m - 1) - i];
	}
	
	return _array;
	
#define array_combine(_array1, _array2)
	/*
		Returns a new array made by joining the two given arrays
	*/
	
	var _new = array_clone(_array1);
	
	array_copy(_new, array_length(_new), _array2, 0, array_length(_array2));
	
	return _new;

#define array_shuffle(_array)
	var	_size = array_length(_array),
		j, t;
		
	for(var i = 0; i < _size; i++){
		j = irandom_range(i, _size - 1);
		if(i != j){
			t = _array[i];
			_array[@i] = _array[j];
			_array[@j] = t;
		}
	}
	
	return _array;
	
#define pool(_pool)
	/*
		Accepts a LWO or array of value:weight pairs, and returns one of the values based on random chance
		
		Ex:
			pool({
				"A" : 4, // 50%
				"B" : 3, // 37.5%
				"C" : 1  // 12.5%
			})
			pool([
				[Bandit,    5], // 50%
				[Scorpion,  3], // 30%
				[BigMaggot, 1], // 10%
				[Maggot,    1]  // 10%
			])
	*/
	
	 // Turn LWO Into Array:
	if(is_object(_pool)){
		var _poolNew = [];
		for(var i = 0; i < lq_size(_pool); i++){
			array_push(_poolNew, [lq_get_key(_pool, i), lq_get_value(_pool, i)]);
		}
		_pool = _poolNew;
	}
	
	 // Roll Max Number:
	var _roll = 0;
	with(_pool) _roll += self[1];
	_roll -= random(_roll);
	
	 // Find Rolled Value:
	if(_roll > 0){
		with(_pool){
			_roll -= self[1];
			if(_roll <= 0) return self[0];
		}
	}
	
	return null;
	
#define array_delete(_array, _index)
	/*
		Returns a new array with the value at the given index removed
		
		Ex:
			array_delete([1, 2, 3], 1) == [1, 3]
	*/
	
	var _new = array_slice(_array, 0, _index);
	
	array_copy(_new, array_length(_new), _array, _index + 1, array_length(_array) - (_index + 1));
	
	return _new;
	
#define array_delete_value(_array, _value)
	/*
		Returns a new array with the given value removed
		
		Ex:
			array_delete_value([1, 2, 3, 2], 2) == [1, 3]
	*/
	
	var _new = _array;
	
	while(array_find_index(_new, _value) >= 0){
		_new = array_delete(_new, array_find_index(_new, _value));
	}
	
	return _new;
	
#define instance_get_name(_inst)
	/*
		Returns a displayable name for a given instance or object
	*/
	
	var _name  = "";
	
	 // Instance:
	if(instance_exists(_inst) && !object_exists(_inst)){
		 // Cause of Death:
		if("hitid" in _inst){
			var _hitid = _inst.hitid;
			
			if(is_real(_hitid)){
				_hitid = floor(_hitid);
				
				 // Built-In:
				var _list = ["bandit", "maggot", "rad maggot", "big maggot", "scorpion", "golden scorpion", "big bandit", "rat", "big rat", "green rat", "gator", "frog", "super frog", "mom", "assassin", "raven", "salamander", "sniper", "big dog", "spider", "new cave thing", "laser crystal", "hyper crystal", "snow bandit", "snowbot", "wolf", "snowtank", "lil hunter", "freak", "explo freak", "rhino freak", "necromancer", "turret", "technomancer", "guardian", "explo guardian", "dog guardian", "throne", "throne II", "bonefish", "crab", "turtle", "molefish", "molesarge", "fireballer", "super fireballer", "jock", "@p@qc@qu@qr@qs@qe@qd @qs@qp@qi@qd@qe@qr", "@p@qc@qu@qr@qs@qe@qd @qc@qr@qy@qs@qt@qa@ql", "mimic", "health mimic", "grunt", "inspector", "shielder", "crown guardian", "explosion", "small explosion", "fire trap", "shield", "toxic", "horror", "barrel", "toxic barrel", "golden barrel", "car", "venus car", "venus car fixed", "venus car 2", "icy car" , "thrown car", "mine", "crown of death", "rogue strike", "blood launcher", "blood cannon", "blood hammer", "disc", "@p@qc@qu@qr@qs@qe", "big dog missile", "halloween bandit", "lil hunter fly", "throne death", "jungle bandit", "jungle assassin", "jungle fly", "crown of hatred", "ice flower", "@p@qc@qu@qr@qs@qe@qd @qa@qm@qm@qo @qp@qi@qc@qk@qu@qp", "electrocution", "elite grunt", "blood gamble", "elite shielder", "elite inspector", "captain", "van", "buff gator", "generator", "lightning crystal", "golden snowtank", "green explosion", "small generator", "golden disc", "big dog explosion", "popo freak", "throne II death", "big fish"];
				if(_hitid >= 0 && _hitid < array_length(_list)){
					_name = loc(`CauseOfDeath:${_hitid}`, _list[_hitid]);
				}
				
				 // Sprite:
				else if(sprite_exists(_hitid)){
					_name = sprite_get_name(_hitid);
				}
			}
			
			 // Custom:
			else if(is_array(_hitid) && array_length(_hitid)){
				_name = string(_hitid[1]);
			}
		}
		
		 // Named:
		if(_name == ""){
			if("name" in _inst && string_pos("Custom", object_get_name(variable_instance_get(_inst, "object_index", -1))) == 1){
				_name = string(_inst.name);
				if(string_pos(" ", _name) <= 0){
					_name = string_space(_name);
				}
			}
		}
	}
	
	 // Object:
	if(_name == ""){
		var _obj = (
			object_exists(_inst)
			? _inst
			: variable_instance_get(_inst, "object_index", -1)
		);
		if(object_exists(_obj)){
			switch(_obj){
				case Bullet1      : _name = "Bullet";            break;
				case Bullet2      : _name = "Shell";             break;
				case EnemyBullet1 : _name = "Enemy Bullet";      break;
				case EnemyBullet2 : _name = "Venom";             break;
				case EnemyBullet3 : _name = "Enemy Shell";       break;
				case EnemyBullet4 : _name = "Sniper Bullet";     break;
				case EFlakBullet  : _name = "Enemy Flak Bullet"; break;
				case PlasmaBig    : _name = "Big Plasma";        break;
				case PlasmaHuge   : _name = "Huge Plasma";       break;
				default           : _name  = string_space(object_get_name(_obj));
			}
		}
	}
	
	return _name;
	
#define instance_nearest_array(_x, _y, _obj)
	/*
		Returns the instance closest to a given point from an array of instances
		
		Ex:
			instance_nearest_array(x, y, instances_matching_ne(hitme, "team", 2));
	*/
	
	var	_disMax  = infinity,
		_nearest = noone;
		
	with(instances_matching_ne(_obj, "id", null)){
		var _dis = point_distance(_x, _y, x, y);
		if(_dis < _disMax){
			_disMax  = _dis;
			_nearest = self;
		}
	}
	
	return _nearest;
	
#define instance_nearest_bbox(_x, _y, _obj)
	/*
		Returns the instance closest to a given point based on their bounding box
		Accepts an array argument like 'instance_nearest_array()' does
		
		Ex:
			instance_nearest_bbox(x, y, Floor);
	*/
	
	var	_disMax  = infinity,
		_nearest = noone;
		
	with(instances_matching_ne(_obj, "id", null)){
		var _dis = distance_to_point(_x, _y);
		if(_dis < _disMax){
			_disMax  = _dis;
			_nearest = self;
		}
	}
	
	return _nearest;
	
#define instance_nearest_rectangle(_x1, _y1, _x2, _y2, _obj)
	/*
		Returns the instance closest to a given rectangle based on their position
		If multiple instances are equally distant from the rectangle, a bias exists for the one closer to its center
		Accepts an array argument like 'instance_nearest_array()' does
		
		Ex:
			instance_nearest_rectangle(x, y, x + 160, y + 64, chestprop)
	*/
	
	var	_cx      = (_x1 + _x2) / 2,
		_cy      = (_y1 + _y2) / 2,
		_disAMax = infinity,
		_disBMax = infinity,
		_nearest = noone;
		
	with(instances_matching_ne(_obj, "id", null)){
		var	_disA = point_distance(x, y, clamp(x, _x1, _x2), clamp(y, _y1, _y2)),
			_disB = point_distance(x, y, _cx, _cy);
			
		if(_disA < _disAMax || (_disA == _disAMax && _disB < _disBMax)){
			_disAMax = _disA;
			_disBMax = _disB;
			_nearest = self;
		}
	}
	
	return _nearest;
	
#define instance_nearest_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)
	/*
		Returns the instance closest to a given rectangle based on their bounding box
		If multiple instances are equally distant from the rectangle, a bias exists for the one closer to its center
		Accepts an array argument like 'instance_nearest_array()' does
		
		Ex:
			instance_nearest_rectangle_bbox(x - 16, y - 16, x + 16, y + 16, Floor)
	*/
	
	var	_cx      = (_x1 + _x2) / 2,
		_cy      = (_y1 + _y2) / 2,
		_disAMax = infinity,
		_disBMax = infinity,
		_nearest = noone;
		
	with(instances_matching_ne(_obj, "id", null)){
		var	_x    = clamp(_cx, bbox_left, bbox_right + 1),
			_y    = clamp(_cy, bbox_top, bbox_bottom + 1),
			_disA = point_distance(_x, _y, clamp(_x, _x1, _x2), clamp(_y, _y1, _y2)),
			_disB = point_distance(_x, _y, _cx, _cy);
			
		if(_disA < _disAMax || (_disA == _disAMax && _disB < _disBMax)){
			_disAMax = _disA;
			_disBMax = _disB;
			_nearest = self;
		}
	}
	
	return _nearest;
	
#define instances_at(_x, _y, _obj)
	/*
		Returns all given instances with their bounding boxes touching a given position
		Much better performance than manually performing 'position_meeting()' on every instance
	*/
	
	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x), "bbox_left", _x), "bbox_bottom", _y), "bbox_top", _y);
	
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)
	/*
		Returns all given instances with their coordinates touching a given rectangle
		Much better performance than manually performing 'point_in_rectangle()' on every instance
	*/
	
	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "x", _x1), "x", _x2), "y", _y1), "y", _y2);
	
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)
	/*
		Returns all given instances with their bounding box touching a given rectangle
		Much better performance than manually performing 'place_meeting()' on every instance
	*/
	
	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x1), "bbox_left", _x2), "bbox_bottom", _y1), "bbox_top", _y2);
	
#define instances_meeting(_x, _y, _obj)
	/*
		Returns all instances whose bounding boxes overlap the calling instance's bounding box at the given position
		Much better performance than manually performing 'place_meeting(x, y, other)' on every instance
	*/
	
	var	_tx = x,
		_ty = y;
		
	x = _x;
	y = _y;
	
	var _inst = instances_matching_ne(instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", bbox_left), "bbox_left", bbox_right), "bbox_bottom", bbox_top), "bbox_top", bbox_bottom), "id", id);
	
	x = _tx;
	y = _ty;
	
	return _inst;
	
#define instances_seen(_obj, _bx, _by, _index)
	/*
		Returns all given instances currently on a given player's screen
		Much better performance than manually performing 'point_seen()' or 'point_seen_ext()' on every instance
		
		Args:
			obj   - The object or instances to search
			bx/by - X/Y border offsets, like 'point_seen_ext()'
			index - The index of the player's screen, use -1 to search the overall bounding area of every player's screen
	*/
	
	var	_x1 = 0,
		_y1 = 0,
		_x2 = 0,
		_y2 = 0;
		
	 // All:
	if(_index < 0){
		_x1 = +infinity;
		_y1 = +infinity;
		_x2 = -infinity;
		_y2 = -infinity;
		for(var i = 0; i < maxp; i++){
			if(player_is_active(i)){
				var	_x = view_xview[i],
					_y = view_yview[i];
					
				if(_x < _x1) _x1 = _x;
				if(_y < _y1) _y1 = _y;
				if(_x > _x2) _x2 = _x;
				if(_y > _y2) _y2 = _y;
			}
		}
		_x2 += game_width;
		_y2 += game_width;
	}
	
	 // Normal:
	else{
		_x1 = view_xview[_index];
		_y1 = view_yview[_index];
		_x2 = _x1 + game_width;
		_y2 = _y1 + game_height;
	}
	
	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x1 - _bx), "bbox_left", _x2 + _bx), "bbox_bottom", _y1 - _by), "bbox_top", _y2 + _by);
	
#define instances_seen_nonsync(_obj, _bx, _by)
	/*
		Returns all given instances currently on the local player's screen
		Much better performance than manually performing 'point_seen()' or 'point_seen_ext()' on every instance
		!!! Beware of DESYNCS
		
		Args:
			obj   - The object or instances to search
			bx/by - X/Y border offsets, like 'point_seen_ext()'
	*/
	
	var	_x1 = view_xview_nonsync,
		_y1 = view_yview_nonsync,
		_x2 = _x1 + game_width,
		_y2 = _y1 + game_height;
		
	return instances_matching_le(instances_matching_ge(instances_matching_le(instances_matching_ge(_obj, "bbox_right", _x1 - _bx), "bbox_left", _x2 + _bx), "bbox_bottom", _y1 - _by), "bbox_top", _y2 + _by);
	
#define instance_random(_obj)
	/*
		Returns a random instance of the given object
		Also accepts an array of instances
	*/
	
	var	_inst = instances_matching_ne(_obj, "id", null),
		_size = array_length(_inst);
		
	return (
		(_size > 0)
		? _inst[irandom(_size - 1)]
		: noone
	);
	
#define instance_clone()
	/*
		Duplicates an instance like 'instance_copy(false)', but clones all of their variables
	*/
	
	var _inst = instance_copy(false);
	
	with(variable_instance_get_names(_inst)){
		var	_value = variable_instance_get(_inst, self),
			_clone = data_clone(_value, 0);
			
		if(_value != _clone){
			variable_instance_set(_inst, self, _clone);
		}
	}
	
	return _inst;
	
#define data_clone(_value, _depth)
	/*
		Returns an exact copy of the given value, and any data stored within the value based on the given depth
		
		Ex:
			list = [1, [ds_list_create(), 3], surface_create(1, 1)];
			data_clone(list, 0) == Returns a clone of the main array
			data_clone(list, 1) == Returns a clone of the main array, sub array, and surface
			data_clone(list, 2) == Returns a clone of the main array, sub array, surface, and ds_list
	*/
	
	if(_depth >= 0){
		_depth--;
		
		 // Array:
		if(is_array(_value)){
			var _clone = array_clone(_value);
			
			if(_depth >= 0){
				for(var i = array_length(_value) - 1; i >= 0; i--){
					_clone[i] = data_clone(_value[i], _depth);
				}
			}
			
			return _clone;
		}
		
		 // LWO:
		if(is_object(_value)){
			var _clone = lq_clone(_value);
			
			if(_depth >= 0){
				for(var i = lq_size(_value) - 1; i >= 0; i--){
					lq_set(_clone, lq_get_key(_value, i), data_clone(lq_get_value(_value, i), _depth));
				}
			}
			
			return _clone;
		}
		
		/* GM data structures are tied to mod files
		 // DS List:
		if(ds_list_valid(_value)){
			var _clone = ds_list_clone(_value);
			
			if(_depth >= 0){
				for(var i = ds_list_size(_value) - 1; i >= 0; i--){
					_clone[| i] = data_clone(_value[| i], _depth);
				}
			}
			
			return _clone;
		}
		
		 // DS Map:
		if(ds_map_valid(_value)){
			var _clone = ds_map_create();
			
			with(ds_map_keys(_value)){
				_clone[? self] = data_clone(_value[? self], _depth);
			}
			
			return _clone;
		}
		
		 // DS Grid:
		if(ds_grid_valid(_value)){
			var	_w     = ds_grid_width(_value),
				_h     = ds_grid_height(_value),
				_clone = ds_grid_create(_w, _h);
				
			for(var _x = _w - 1; _x >= 0; _x--){
				for(var _y = _h - 1; _y >= 0; _y--){
					_value[# _x, _y] = data_clone(_value[# _x, _y], _depth);
				}
			}
			
			return _clone;
		}
		*/
		
		 // Surface:
		if(surface_exists(_value)){
			return surface_clone(_value);
		}
	}
	
	return _value;
	
#define ds_list_clone(_list)
	/*
		Returns an exact copy of the given ds_list
	*/
	
	var _clone = ds_list_create();
	
	ds_list_add_array(_clone, ds_list_to_array(_list));
	
	return _clone;
	
#define surface_clone(_surf)
	/*
		Returns an exact copy of the given surface
	*/
	
	var _clone = surface_create(surface_get_width(_surf), surface_get_height(_surf));
	
	surface_set_target(_clone);
	draw_clear_alpha(0, 0);
	draw_surface(_surf, 0, 0);
	surface_reset_target();
	
	return _clone;
	
#define variable_instance_get_list(_inst)
	/*
		Returns all of a given instance's variable names and values as a LWO
	*/
	
	var _list = {};
	
	with(variable_instance_get_names(_inst)){
		lq_set(_list, self, variable_instance_get(_inst, self));
	}
	
	return _list;
	
#define variable_instance_set_list(_inst, _list)
	/*
		Sets all of a given LWO's variable names and values on a given instance
	*/
	
	if(instance_exists(_inst)){
		var	_listMax  = lq_size(_list),
			_isCustom = (string_pos("Custom", object_get_name(_inst.object_index)) == 1);
			
		for(var i = 0; i < _listMax; i++){
			var _name = lq_get_key(_list, i);
			if(!variable_is_readonly(_inst, _name)){
				if(_isCustom && string_pos("on_", _name) == 1){
					if(variable_instance_get(_inst, _name) != lq_get_value(_list, i)){
						try variable_instance_set(_inst, _name, lq_get_value(_list, i));
						catch(_error){}
					}
				}
				else variable_instance_set(_inst, _name, lq_get_value(_list, i));
			}
		}
	}
	
#define variable_is_readonly(_inst, _varName)
	/*
		Returns 'true' if the given variable on the given instance is read-only, 'false' otherwise
	*/
	
	if(array_find_index(["id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width"], _varName) >= 0){
		return true;
	}
	
	if(instance_is(_inst, Player)){
		if(array_find_index(["p", "index", "alias"], _varName) >= 0){
			return true;
		}
	}
	
	return false;
	
#define skill_get_icon(_skill)
	/*
		Returns an array containing the [sprite_index, image_index] of a mutation's HUD icon
	*/
	
	if(is_real(_skill)){
		return [sprSkillIconHUD, _skill];
	}
	
	if(is_string(_skill) && mod_script_exists("skill", _skill, "skill_icon")){
		return [mod_script_call("skill", _skill, "skill_icon"), 0];
	}
	
	return [sprEGIconHUD, 2];
	
#define skill_get_avail(_skill)
	/*
		Returns 'true' if the given skill can appear on the mutation selection screen, 'false' otherwise
	*/
	
	if(skill_get_active(_skill)){
		if(
			_skill != mut_heavy_heart
			|| skill_get(mut_heavy_heart) != 0
			|| (GameCont.wepmuts >= 3 && GameCont.wepmuted == false)
		){
			if(
				!is_string(_skill)
				|| !mod_script_exists("skill", _skill, "skill_avail")
				|| mod_script_call("skill", _skill, "skill_avail")
			){
				return true;
			}
		}
	}
	
	return false;
	
#define game_activate()
	/*
		Reactivates all objects and unpauses the game
	*/
	
	with(UberCont) with(self){
		event_perform(ev_alarm, 2);
	}
	
#define game_deactivate()
	/*
		Deactivates all objects, except GmlMods & most controllers
	*/
	
	with(UberCont) with(self){
		var	_lastIntro = opt_bossintros,
			_lastLoops = GameCont.loops,
			_player    = noone;
			
		 // Ensure Boss Intro Plays:
		opt_bossintros = true;
		GameCont.loops = 0;
		if(!instance_exists(Player)){
			_player = instance_create(0, 0, GameObject);
			with(_player){
				instance_change(Player, false);
			}
		}
		
		 // Call Boss Intro:
		with(instance_create(0, 0, GameObject)){
			instance_change(BanditBoss, false);
			with(self){
				event_perform(ev_alarm, 6);
			}
			sound_stop(sndBigBanditIntro);
			instance_delete(self);
		}
		
		 // Reset:
		alarm2         = -1;
		opt_bossintros = _lastIntro;
		GameCont.loops = _lastLoops;
		with(_player){
			instance_delete(self);
		}
		
		 // Unpause Game, Then Deactivate Objects:
		event_perform(ev_alarm, 2);
		event_perform(ev_draw, ev_draw_post);
	}
	
#define area_generate(_area, _subarea, _loops, _x, _y, _setArea, _overlapFloor, _scrSetup)
	/*
		Deactivates the game, generates a given area, and reactivates the game
		Returns the ID of the GenCont used to create the area, or null if the area couldn't be generated
		
		Args:
			area/subarea/loops - Area to generate
			x/y                - Spawn position
			setArea            - Set the current area to the generated area
			                       True  : Sets the area, background_color, BackCont vars, TopCont vars, and calls .mod level_start scripts
			                       False : Maintains the current area and deletes new IDPD spawns
			overlapFloor       - Number 0 to 1, determines the percent of current level floors that can be overlapped
			scrSetup           - Script reference, called right before floor generation
			
		Ex:
			var _genID = area_generate(area_scrapyards, 3, GameCont.loops, x, y, false, 0, null);
			with(instances_matching_gt(chestprop, "id", _genID)){
				instance_delete(self);
			}
	*/
	
	if(is_real(_area) || is_string(_area)){
		var	_lastArea            = GameCont.area,
			_lastSubarea         = GameCont.subarea,
			_lastLoops           = GameCont.loops,
			_lastBackgroundColor = background_color,
			_lastLetterbox       = game_letterbox,
			_lastViewObj         = [],
			_lastViewPan         = [],
			_lastViewShk         = [],
			_lastObjVars         = [],
			_lastSolid           = [];
			
		 // Remember Stuff:
		for(var i = 0; i < maxp; i++){
			_lastViewObj[i] = view_object[i];
			_lastViewPan[i] = view_pan_factor[i];
			_lastViewShk[i] = view_shake[i];
		}
		with([BackCont, TopCont]){
			var	_obj  = self,
				_vars = [];
				
			with(variable_instance_get_names(_obj)){
				if(array_find_index(["id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width"], self) < 0){
					array_push(_vars, [self, variable_instance_get(_obj, self)]);
				}
			}
			array_push(_lastObjVars, [_obj, _vars]);
		}
		
		 // Fix Ghost Collision:
		with(instances_matching(all, "solid", true)){
			solid = false;
			array_push(_lastSolid, self);
		}
		
		 // Clamp to Grid:
		with(instance_nearest_bbox(_x, _y, Floor)){
			_x = x + pfloor(_x - x, 16);
			_y = y + pfloor(_y - y, 16);
		}
		
		 // Floor Overlap Fixing:
		var	_overlapFloorBBox = [],
			_overlapFloorFill = [];
			
		if(_overlapFloor < 1){
			var	_floor = FloorNormal,
				_num = array_length(_floor) * (1 - _overlapFloor);
				
			with(array_shuffle(_floor)){
				if(_num-- > 0){
					array_push(_overlapFloorBBox, [bbox_left, bbox_top, bbox_right, bbox_bottom]);
				}
				else break;
			}
		}
		
		 // No Duplicates:
		with(BackCont) with(self){
			event_perform(ev_other, ev_room_end);
			instance_destroy();
		}
		with(TopCont) with(self){
			darkness = true;
			event_perform(ev_other, ev_room_end);
			instance_destroy();
		}
		with(SubTopCont){
			instance_destroy();
		}
		
		 // Deactivate Objects:
		game_deactivate();
		
		 // No Boss Death Music:
		if(_setArea){
			with(MusCont){
				alarm_set(3, -1);
			}
		}
		
		 // Generate Level:
		GameCont.area    = _area;
		GameCont.subarea = _subarea;
		GameCont.loops   = _loops;
		var _genID = instance_create(0, 0, GenCont);
		with(_genID) with(self){
			var	_ox = (_x - 10016),
				_oy = (_y - 10016);
				
			 // Music:
			if(_setArea){
				with(MusCont){
					alarm_set(11, 1);
				}
			}
			
			 // Delete Loading Spirals:
			with(SpiralCont  ) instance_destroy();
			with(Spiral      ) instance_destroy();
			with(SpiralStar  ) instance_destroy();
			with(SpiralDebris) instance_destroy(); // *might play a 0.1 pitched sound
			
			 // Custom Code:
			if(is_array(_scrSetup)){
				script_ref_call(_scrSetup);
			}
			
			 // Floors:
			var	_tries    = 100,
				_floorNum = 0;
				
			while(instance_exists(FloorMaker) && _tries-- > 0){
				with(FloorMaker){
					xprevious = x;
					yprevious = y;
					event_perform(ev_step, ev_step_normal);
				}
				if(instance_number(Floor) > _floorNum){
					_floorNum = instance_number(Floor);
					_tries    = 300;
				}
			}
			with(FloorMaker){
				instance_destroy();
			}
			
			 // Safe Spawns & Misc:
			event_perform(ev_alarm, 2);
			
			 // Remove Overlapping Floors:
			with(_overlapFloorBBox){
				var	_x1 = self[0] - _ox,
					_y1 = self[1] - _oy,
					_x2 = self[2] - _ox,
					_y2 = self[3] - _oy;
					
				with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, Floor)){
					array_push(_overlapFloorFill, [bbox_left + _ox, bbox_top + _oy, bbox_right + _ox, bbox_bottom + _oy]);
					instance_destroy();
				}
				with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, SnowFloor)){
					if(point_in_rectangle(bbox_center_x, bbox_center_y, _x1, _y1, _x2 + 1, _y2 + 1)){
						instance_destroy();
					}
				}
				with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, [chestprop, RadChest])){
					instance_delete(self);
				}
			}
			
			 // Populate Level:
			with(KeyCont) with(self){
				event_perform(ev_create, 0); // reset player counter
			}
			event_perform(ev_alarm, 0);
			if(!_setArea){
				with(WantPopo) instance_delete(self);
				with(WantVan ) instance_delete(self);
			}
			var _clearID = instance_max;
			event_perform(ev_alarm, 1);
			
			 // Player Reset:
			if(game_letterbox == false){
				game_letterbox = _lastLetterbox;
			}
			for(var i = 0; i < maxp; i++){
				if(view_object[i]     == noone) view_object[i]     = _lastViewObj[i];
				if(view_pan_factor[i] == null ) view_pan_factor[i] = _lastViewPan[i];
				if(view_shake[i]      == 0    ) view_shake[i]      = _lastViewShk[i];
				
				with(instances_matching(Player, "index", i)){
					 // Fix View:
					var	_vx1   = x - (game_width / 2),
						_vy1   = y - (game_height / 2),
						_vx2   = view_xview[i],
						_vy2   = view_yview[i],
						_shake = UberCont.opt_shake;
						
					UberCont.opt_shake = 1;
					gunangle = point_direction(_vx1, _vy1, _vx2, _vy2);
					weapon_post(0, point_distance(_vx1, _vy1, _vx2, _vy2), 0);
					UberCont.opt_shake = _shake;
					
					 // Delete:
					repeat(4) with(instance_nearest(x, y, PortalL)){
						instance_destroy();
					}
					instance_delete(self);
					break;
				}
			}
			with(instances_matching_gt(PortalClear, "id", _clearID)){
				instance_destroy();
			}
			
			 // Move Objects:
			with(instances_matching_ne(instances_matching_ne(instances_matching_gt(all, "id", _genID), "x", null), "y", null)){
				if(x != 0 || y != 0){
					x         += _ox;
					y         += _oy;
					xprevious += _ox;
					yprevious += _oy;
					xstart    += _ox;
					ystart    += _oy;
				}
			}
		}
		
		 // Call Funny Mod Scripts:
		if(_setArea){
			with(mod_get_names("mod")){
				try{
					mod_script_call_nc("mod", self, "level_start");
				}
				catch(_error){
					trace(_error);
				}
			}
		}
		
		 // Reactivate Objects:
		game_activate();
		with(_lastSolid){
			solid = true;
		}
		
		 // Overlap Fixes:
		var	_overlapObject = [Floor, Wall, InvisiWall, TopSmall, TopPot, Bones],
			_overlapObj    = array_clone(_overlapObject);
			
		while(array_length(_overlapObj)){
			var _obj = _overlapObj[0];
			
			 // New Overwriting Old:
			var _objNew = instances_matching_gt(_obj, "id", _genID);
			with(instances_matching_lt(_overlapObj, "id", _genID)){
				if(place_meeting(x, y, _obj) && array_length(instances_meeting(x, y, _objNew))){
					if(object_index == Floor){
						array_push(_overlapFloorFill, [bbox_left, bbox_top, bbox_right, bbox_bottom]);
					}
					instance_delete(self);
				}
			}
			
			 // Advance:
			_overlapObj = array_slice(_overlapObj, 1, array_length(_overlapObj) - 1);
			
			 // Old Overwriting New:
			var _objOld = instances_matching_lt(_obj, "id", _genID);
			with(instances_matching_gt(_overlapObj, "id", _genID)){
				if(place_meeting(x, y, _obj) && array_length(instances_meeting(x, y, _objOld))){
					instance_delete(self);
				}
			}
		}
		var _wallOld = instances_matching_lt(Wall, "id", _genID);
		with(instances_matching_lt(hitme, "id", _genID)){
			if(place_meeting(x, y, Wall) && !array_length(instances_meeting(x, y, _wallOld))){
				wall_clear(x, y);
			}
		}
		
		 // Fill Gaps:
		with(_overlapFloorFill){
			var	_x1 = self[0],
				_y1 = self[1],
				_x2 = self[2] + 1,
				_y2 = self[3] + 1;
				
			with(other){
				for(var _fx = _x1; _fx < _x2; _fx += 16){
					for(var _fy = _y1; _fy < _y2; _fy += 16){
						if(!position_meeting(_fx, _fy, Floor)){
							with(instance_create(_fx, _fy, FloorExplo)){
								with(instances_meeting(x, y, _overlapObject)){
									instance_delete(self);
								}
							}
						}
					}
				}
			}
		}
		
		 // Reset Area:
		if(!_setArea){
			GameCont.area    = _lastArea;
			GameCont.subarea = _lastSubarea;
			GameCont.loops   = _lastLoops;
			background_color = _lastBackgroundColor;
			with(_lastObjVars){
				var	_obj  = self[0],
					_vars = self[1];
					
				with(_obj){
					with(_vars){
						variable_instance_set(other, self[0], self[1]);
					}
				}
			}
		}
		with(_lastObjVars){
			var	_obj  = self[0],
				_vars = self[1];
				
			if(_obj == TopCont){
				with(_vars){
					if(self[0] == "fogscroll"){
						with(_obj){
							variable_instance_set(self, other[0], other[1]);
						}
						break;
					}
				}
			}
		}
		
		return _genID;
	}
	
	return null;
	
#define area_set(_area, _subarea, _loops)
	/*
		Sets the area and remembers the last non-secret area
		Also turns Crystal Caves into Cursed Crystal Caves if a Player has a cursed weapon
	*/
	
	with(GameCont){
		 // Remember:
		if(!area_get_secret(area)){
			lastarea    = area;
			lastsubarea = subarea;
		}
		
		 // Set Area:
		area    = _area;
		subarea = _subarea;
		loops   = _loops;
		
		 // Cursed:
		if(area == area_caves){
			with(Player) if(curse > 0 || bcurse > 0){
				other.area = area_cursed_caves;
				break;
			}
		}
	}
	
#define area_get_name(_area, _subarea, _loops)
	/*
		Returns the given area's name as it would appear on the map
	*/
	
	var _name = [_area, "-", _subarea];
	
	 // Custom Area:
	if(is_string(_area)){
		_name = ["MOD"];
		if(mod_script_exists("area", _area, "area_name")){
			var _custom = mod_script_call("area", _area, "area_name", _subarea, _loops);
			if(is_string(_custom)){
				_name = [_custom];
			}
		}
	}
	
	 // Secret Area:
	else if(area_get_secret(_area)){
		switch(_area){
			case area_vault : _name = ["???"];             break;
			case area_hq    : _name = ["HQ", _subarea];    break;
			case area_crib  : _name = ["$$$"];             break;
			default         : _name = [_area - 100, "-?"];
		}
	}
	
	 // Victory:
	if(GameCont.win == true){
		if(_area == area_palace || _area == area_hq){
			_name = ["END", (area_get_secret(_area) ? 2 : 1)];
		}
	}
	
	 // Loop:
	if(real(_loops) > 0){
		array_push(_name, " " + ((UberCont.hardmode == true) ? "H" : "L"));
		array_push(_name, _loops);
	}
	
	 // Compile Name:
	var _text = "";
	with(_name){
		_text += (
			(is_real(self) && frac(self) != 0)
			? string_format(self, 0, 2)
			: string(self)
		);
	}
	
	return _text;
	
#define area_get_subarea(_area)
	/*
		Returns how many subareas are in the given area
	*/
	
	 // Custom Area:
	if(is_string(_area)){
		var _scrt = "area_subarea";
		if(mod_script_exists("area", _area, _scrt)){
			return mod_script_call("area", _area, _scrt);
		}
	}
	
	 // Normal Area:
	else if(is_real(_area)){
		 // Secret Areas:
		if(_area == area_hq) return 3;
		if(_area >= 100) return 1;
		
		 // Transition Area:
		if((_area % 2) == 0) return 1;
		
		return 3;
	}
	
	return 1;
	
#define area_get_secret(_area)
	/*
		Returns whether or not an area is secret
		
		Means the area:
			Is not returned to from other secret areas like Crib, IDPD HQ, Crown Vault, etc.
			Has no Proto Statues
			Doesn't spawn IDPD on new Crowns
			Doesn't create rad canisters when below the desired amount
			..?
	*/
	
	 // Custom Area:
	if(is_string(_area)){
		var _scrt = "area_secret";
		if(mod_script_exists("area", _area, _scrt)){
			return mod_script_call("area", _area, _scrt);
		}
	}
	
	 // Normal Area:
	else if(is_real(_area)){
		return (_area >= 100);
	}
	
	return false;
	
#define area_get_underwater(_area)
	/*
		Returns if a given area is underwater, like Oasis
	*/
	
	 // Custom Area:
	if(is_string(_area)){
		var _scrt = "area_underwater";
		if(mod_script_exists("area", _area, _scrt)){
			return mod_script_call("area", _area, _scrt);
		}
	}
	
	 // Normal Area:
	return (_area == area_oasis);
	
#define area_get_back_color(_area)
	/*
		Returns a given area's background color, but also supports custom areas
	*/
	
	 // Custom Area:
	if(is_string(_area)){
		var _scrt = "area_background_color";
		if(mod_script_exists("area", _area, _scrt)){
			return mod_script_call("area", _area, _scrt);
		}
	}
	
	 // Normal Area:
	return area_get_background_color(_area);
	
//#define area_get_shad_color(_area)
//	/*
//		Return's a given area's shadow color, but also supports custom areas
//	*/
//	
//	 // Custom Area:
//	if(is_string(_area)){
//		var _scrt = "area_shadow_color";
//		if(mod_script_exists("area", _area, _scrt)){
//			return mod_script_call("area", _area, _scrt);
//		}
//	}
//	
//	 // Normal Area:
//	return area_get_shadow_color(_area);
	
#define area_get_sprite(_area, _spr)
	/*
		Returns a given area's variant of the given sprite
		
		Ex:
			area_get_sprite(area_sewers, sprFloor1) == sprFloor2
			area_get_sprite(area_city, sprDebris1)  == sprDebris5
			area_get_sprite(area_caves, sprBones)   == sprCaveDecal
	*/
	
	 // Store Sprites:
	if(!mod_variable_exists(mod_current_type, mod_current, "area_sprite_map")){
		var _map = ds_map_create();
		_map[? 0  ] = [sprFloor0,   sprFloor0,    sprFloor0Explo,   sprWall0Trans,   sprWall0Bot,   sprWall0Out,   sprWall0Top,   sprDebris0,   sprDetail0,   sprNightBones,      sprNightDesertTopDecal];
		_map[? 1  ] = [sprFloor1,   sprFloor1B,   sprFloor1Explo,   sprWall1Trans,   sprWall1Bot,   sprWall1Out,   sprWall1Top,   sprDebris1,   sprDetail1,   sprBones,           sprDesertTopDecal     ];
		_map[? 2  ] = [sprFloor2,   sprFloor2B,   sprFloor2Explo,   sprWall2Trans,   sprWall2Bot,   sprWall2Out,   sprWall2Top,   sprDebris2,   sprDetail2,   sprSewerDecal,      sprTopDecalSewers     ];
		_map[? 3  ] = [sprFloor3,   sprFloor3B,   sprFloor3Explo,   sprWall3Trans,   sprWall3Bot,   sprWall3Out,   sprWall3Top,   sprDebris3,   sprDetail3,   sprScrapDecal,      sprTopDecalScrapyard  ];
		_map[? 4  ] = [sprFloor4,   sprFloor4B,   sprFloor4Explo,   sprWall4Trans,   sprWall4Bot,   sprWall4Out,   sprWall4Top,   sprDebris4,   sprDetail4,   sprCaveDecal,       sprTopDecalCave       ];
		_map[? 5  ] = [sprFloor5,   sprFloor5B,   sprFloor5Explo,   sprWall5Trans,   sprWall5Bot,   sprWall5Out,   sprWall5Top,   sprDebris5,   sprDetail5,   sprIceDecal,        sprTopDecalCity       ];
		_map[? 6  ] = [sprFloor6,   sprFloor6B,   sprFloor6Explo,   sprWall6Trans,   sprWall6Bot,   sprWall6Out,   sprWall6Top,   sprDebris6,   sprDetail6,   -1,                 -1                    ];
		_map[? 7  ] = [sprFloor7,   sprFloor7B,   sprFloor7Explo,   sprWall7Trans,   sprWall7Bot,   sprWall7Out,   sprWall7Top,   sprDebris7,   -1,           -1,                 sprPalaceTopDecal     ];
		_map[? 100] = [sprFloor100, sprFloor100B, sprFloor100Explo, sprWall100Trans, sprWall100Bot, sprWall100Out, sprWall100Top, sprDebris100, -1,           -1,                 -1                    ];
		_map[? 101] = [sprFloor101, sprFloor101B, sprFloor101Explo, sprWall101Trans, sprWall101Bot, sprWall101Out, sprWall101Top, sprDebris101, sprDetail101, sprCoral,           -1                    ];
		_map[? 102] = [sprFloor102, sprFloor102B, sprFloor102Explo, sprWall102Trans, sprWall102Bot, sprWall102Out, sprWall102Top, sprDebris102, sprDetail102, sprPizzaSewerDecal, sprTopDecalPizzaSewers];
		_map[? 103] = [sprFloor103, sprFloor103B, sprFloor103Explo, sprWall103Trans, sprWall103Bot, sprWall103Out, sprWall103Top, sprDebris103, -1,           -1,                 -1                    ];
		_map[? 104] = [sprFloor104, sprFloor104B, sprFloor104Explo, sprWall104Trans, sprWall104Bot, sprWall104Out, sprWall104Top, sprDebris104, sprDetail104, sprInvCaveDecal,    sprTopDecalInvCave    ];
		_map[? 105] = [sprFloor105, sprFloor105B, sprFloor105Explo, sprWall105Trans, sprWall105Bot, sprWall105Out, sprWall105Top, sprDebris105, -1,           sprJungleDecal,     sprTopDecalJungle     ];
		_map[? 106] = [sprFloor106, sprFloor106B, sprFloor106Explo, sprWall106Trans, sprWall106Bot, sprWall106Out, sprWall106Top, sprDebris106, -1,           -1,                 sprTopPot             ];
		_map[? 107] = [sprFloor107, sprFloor107B, sprFloor107Explo, sprWall107Trans, sprWall107Bot, sprWall107Out, sprWall107Top, sprDebris107, -1,           -1,                 -1                    ];
		global.area_sprite_map = _map;
	}
	
	 // Convert to Desert Sprite:
	if(sprite_exists(_spr)){
		with(ds_map_values(global.area_sprite_map)){
			var i = array_find_index(self, _spr);
			if(i >= 0){
				_spr = global.area_sprite_map[? 1][i];
				if(_spr == sprDesertTopDecal) _spr = sprTopPot;
				break;
			}
		}
	}
	
	 // Custom:
	if(is_string(_area)){
		var s = mod_script_call("area", _area, "area_sprite", _spr);
		if(s != 0 && is_real(s)){
			return s;
		}
	}
	
	 // Normal:
	if(ds_map_exists(global.area_sprite_map, _area)){
		var	_list = global.area_sprite_map[? _area],
			i = array_find_index(global.area_sprite_map[? 1], _spr);
			
		if(i >= 0 && i < array_length(_list)){
			return _list[i];
		}
	}
	
	return -1;
	
#define floor_walls()
	var	_x1    = bbox_left   - 16,
		_y1    = bbox_top    - 16,
		_x2    = bbox_right  + 16 + 1,
		_y2    = bbox_bottom + 16 + 1,
		_minID = instance_max;
		
	for(var _x = _x1; _x < _x2; _x += 16){
		for(var _y = _y1; _y < _y2; _y += 16){
			if(_x == _x1 || _y == _y1 || _x == _x2 - 16 || _y == _y2 - 16){
				if(!position_meeting(_x, _y, Floor)){
					instance_create(_x, _y, Wall);
				}
			}
		}
	}
	
	return _minID;

#define floor_bones(_num, _chance, _linked)
	/*
		Checks if the current Floor is a vertical hallway and then creates Bones decals on the Walls left and right of the current Floor
		
		Args:
			num    - How many decals can be made vertically
			chance - Chance to create each decal
			linked - Decal should always spawn with one on the other side, true/false
			
		Ex:
			floor_bones(2, 1,    false) == DESERT / CAMPFIRE
			floor_bones(1, 1/10, true ) == SEWERS / PIZZA SEWERS / JUNGLE
			floor_bones(2, 1/7,  false) == SCRAPYARDS / FROZEN CITY
			floor_bones(2, 1/9,  false) == CRYSTAL CAVES / CURSED CRYSTAL CAVES / OASIS
	*/
	
	var _inst = [];
	
	if(!collision_rectangle(bbox_left - 16, bbox_top, bbox_right + 16, bbox_bottom, Floor, false, true)){
		for(var _y = bbox_top; _y < bbox_bottom + 1; _y += (32 / _num)){
			var _create = true;
			for(var _side = 0; _side <= 1; _side++){
				if(_side == 0 || !_linked){
					_create = (random(1) < _chance);
				}
				if(_create){
					var _x = lerp(bbox_left, bbox_right + 1, _side);
					with(obj_create(_x, _y, "WallDecal")){
						image_xscale = ((_side > 0.5) ? -1 : 1);
						array_push(_inst, self);
					}
				}
			}
		}
	}
	
	return _inst;

#define floor_reveal(_x1, _y1, _x2, _y2, _time)
	var _reveal = {
		"creator"     : global.floor_reveal_bind.id,
		"x1"          : _x1,
		"y1"          : _y1,
		"x2"          : _x2,
		"y2"          : _y2,
		"ox"          : 0,
		"oy"          : -8,
		"time"        : _time,
		"time_max"    : _time,
		"color"       : background_color,
		"flash"       : true,
		"flash_color" : c_white
	};
	
	 // Add to List:
	with(_reveal.creator){
		visible = true;
		if("list" not in self){
			list = [];
		}
		array_push(list, _reveal);
	}
	
	return _reveal;
	
#define floor_reveal_draw
	if(lag) trace_time();
	
	var _destroyInst = [FloorExplo, Explosion, PortalClear, EnergyHammerSlash];
	
	with(list){
		 // Revealing:
		if(time > 0 && (time <= time_max || !array_length(instance_rectangle_bbox(x1, y1, x2, y2, _destroyInst)))){
			var	_num = clamp(time / time_max, 0, 1),
				_col = ((time > time_max) ? color : merge_color(flash_color, color, (flash ? (1 - _num) : _num)));
				
			draw_set_alpha(_num);
			draw_set_color(_col);
			draw_rectangle(x1 + ox, y1 + oy, x2 + ox, y2 + oy, false);
			
			time -= current_time_scale;
		}
		
		 // Done:
		else other.list = array_delete_value(other.list, self);
	}
	draw_set_alpha(1);
	
	 // Goodbye:
	if(!array_length(list)){
		visible = false;
	}
	
	if(lag) trace_time(script[2]);
	
#define floor_set_style(_style, _area)
	global.floor_style = _style;
	global.floor_area  = _area;
	
#define floor_reset_style()
	floor_set_style(null, null);
	
#define floor_set_align(_alignX, _alignY, _alignW, _alignH)
	global.floor_align_x = _alignX;
	global.floor_align_y = _alignY;
	global.floor_align_w = _alignW;
	global.floor_align_h = _alignH;
	
#define floor_reset_align()
	floor_set_align(null, null, null, null);
	
#define floor_align(_x, _y, _w, _h, _type)
	/*
		Returns the given rectangle's position aligned to the floor grid
		Has a bias towards nearby floors to help prevent the rectangle from being disconnected from the level
	*/
	
	var	_gridXAuto = is_undefined(global.floor_align_x),
		_gridYAuto = is_undefined(global.floor_align_y),
		_gridWAuto = is_undefined(global.floor_align_w),
		_gridHAuto = is_undefined(global.floor_align_h),
		_gridX     = (_gridXAuto ? 10000 : global.floor_align_x),
		_gridY     = (_gridYAuto ? 10000 : global.floor_align_y),
		_gridW     = (_gridWAuto ? 16    : global.floor_align_w),
		_gridH     = (_gridHAuto ? 16    : global.floor_align_h),
		_gridXBias = 0,
		_gridYBias = 0;
		
	if(_gridXAuto || _gridYAuto || _gridWAuto || _gridHAuto){
		if(!instance_exists(FloorMaker)){
			 // Align to Nearest Floor:
			if(_gridXAuto || _gridYAuto){
				with(instance_nearest_rectangle_bbox(_x, _y, _x + _w, _y + _h, Floor)){
					if(_gridXAuto){
						_gridX     = x;
						_gridXBias = bbox_center_x - (_x + (_w / 2));
					}
					if(_gridYAuto){
						_gridY     = y;
						_gridYBias = bbox_center_y - (_y + (_h / 2));
					}
				}
			}
			
			 // Align to Largest Colliding Floor:
			var	_fx    = _gridX + floor_align_round(_x - _gridX, _gridW, _gridXBias),
				_fy    = _gridY + floor_align_round(_y - _gridY, _gridH, _gridYBias),
				_fwMax = _gridW,
				_fhMax = _gridH;
				
			with(instance_rectangle_bbox(_fx, _fy, _fx + _w - 1, _fy + _h - 1, Floor)){
				var	_fw = bbox_width,
					_fh = bbox_height;
					
				if(_fw >= _fwMax){
					_fwMax = _fw;
					if(_gridWAuto){
						_gridW = _fwMax;
					}
					if(_gridXAuto){
						_gridX     = x;
						_gridXBias = bbox_center_x - (_x + (_w / 2));
					}
				}
				if(_fh >= _fhMax){
					_fhMax = _fh;
					if(_gridHAuto){
						_gridH = _fhMax;
					}
					if(_gridYAuto){
						_gridY     = y;
						_gridYBias = bbox_center_y - (_y + (_h / 2));
					}
				}
			}
			
			 // No Unnecessary Bias:
			if(_gridXBias != 0 || _gridYBias != 0){
				_fx = _gridX + floor_align_round(_x - _gridX, _gridW, 0);
				_fy = _gridY + floor_align_round(_y - _gridY, _gridH, 0);
				if(
					(_type == "round")
					? (
						collision_rectangle(_fx + 32, _fy,     _fx + _w - 32 - 1, _fy + _h - 1,      Floor, false, false) ||
						collision_rectangle(_fx,      _fy + 32, _fx + _w - 1,     _fy + _h - 32 - 1, Floor, false, false)
					)
					: collision_rectangle(_fx, _fy, _fx + _w - 1, _fy + _h - 1, Floor, false, false)
				){
					_gridXBias = 0;
					_gridYBias = 0;
				}
			}
		}
		
		 // FloorMaker:
		else with(instance_nearest(_x + max(0, (_w / 2) - 16), _y + max(0, (_h / 2) - 16), FloorMaker)){
			if(_gridXAuto) _gridX = x;
			if(_gridYAuto) _gridY = y;
			if(_gridWAuto) _gridW = min(_w, 32);
			if(_gridHAuto) _gridH = min(_h, 32);
		}
	}
	
	 // Align:
	return [
		_gridX + floor_align_round(_x - _gridX, _gridW, _gridXBias),
		_gridY + floor_align_round(_y - _gridY, _gridH, _gridYBias)
	];
	
#define floor_align_round(_num, _precision, _bias)
	var _value = _num;
	if(_precision != 0){
		_value /= _precision;
		
		if(_bias < 0){
			_value = floor(_value);
		}
		else if(_bias > 0 || frac(_value) == 0.5){ // No sig-fig rounding
			_value = ceil(_value);
		}
		else{
			_value = round(_value);
		}
		
		_value *= _precision;
	}
	return _value;
	
#define floor_set(_x, _y, _state) // imagine if floors and walls just used a ds_grid bro....
	var _inst = noone;
	
	 // Create Floor:
	if(_state){
		var	_obj = ((_state >= 2) ? FloorExplo : Floor),
			_msk = object_get_mask(_obj),
			_w = ((sprite_get_bbox_right (_msk) + 1) - sprite_get_bbox_left(_msk)),
			_h = ((sprite_get_bbox_bottom(_msk) + 1) - sprite_get_bbox_top (_msk));
			
		 // Align to Adjacent Floors:
		var _gridPos = floor_align(_x, _y, _w, _h, "");
		_x = _gridPos[0];
		_y = _gridPos[1];
		
		 // Clear Floors:
		if(!instance_exists(FloorMaker)){
			if(_obj == FloorExplo){
				with(instances_matching(instances_matching(_obj, "x", _x), "y", _y)){
					instance_delete(self);
				}
			}
			else{
				floor_delete(_x, _y, _x + _w - 1, _y + _h - 1);
			}
		}
		
		 // Auto-Style:
		var	_floormaker = noone,
			_lastArea = GameCont.area;
			
		if(!is_undefined(global.floor_style)){
			GameCont.area = area_campfire;
			with(instance_create(_x, _y, FloorMaker)){
				with(instances_matching_gt(Floor, "id", id)){
					instance_delete(self);
				}
				styleb = global.floor_style;
				_floormaker = self;
			}
			GameCont.area = _lastArea;
		}
		if(!is_undefined(global.floor_area)){
			GameCont.area = global.floor_area;
		}
		
		 // Floorify:
		_inst = instance_create(_x, _y, _obj);
		with(_floormaker) instance_destroy();
		GameCont.area = _lastArea;
		with(_inst){
			if(!instance_exists(FloorMaker)){
				 // Clear Area:
				wall_delete(bbox_left, bbox_top, bbox_right, bbox_bottom);
				
				 // Details:
				if(chance(1, 6)){
					instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Detail);
				}
			}
			
			 // Wallerize:
			if(instance_exists(Wall)){
				floor_walls();
				wall_update(bbox_left - 16, bbox_top - 16, bbox_right + 16, bbox_bottom + 16);
			}
		}
	}
	
	 // Destroy Floor:
	else with(instances_at(_x, _y, Floor)){
		var	_x1 = bbox_left   - 16,
			_y1 = bbox_top    - 16,
			_x2 = bbox_right  + 16,
			_y2 = bbox_bottom + 16;
			
		with(instances_meeting(x, y, SnowFloor)){
			if(point_in_rectangle(bbox_center_x, bbox_center_y, other.bbox_left, other.bbox_top, other.bbox_right + 1, other.bbox_bottom + 1)){
				instance_destroy();
			}
		}
		
		instance_destroy();
		
		if(instance_exists(Wall)){
			with(other){
				 // Un-Wall:
				wall_delete(_x1, _y1, _x2, _y2);
				
				 // Re-Wall:
				for(var _fx = _x1; _fx < _x2 + 1; _fx += 16){
					for(var _fy = _y1; _fy < _y2 + 1; _fy += 16){
						if(!position_meeting(_fx, _fy, Floor)){
							if(collision_rectangle(_fx - 16, _fy - 16, _fx + 31, _fy + 31, Floor, false, false)){
								instance_create(_fx, _fy, Wall);
							}
						}
					}
				}
				wall_update(_x1 - 16, _y1 - 16, _x2 + 16, _y2 + 16);
			}
		}
	}
	
	return _inst;
	
#define floor_delete(_x1, _y1, _x2, _y2)
	/*
		Deletes all Floors and Floor-related objects within the given rectangular area
	*/
	
	with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, Floor)){
		for(var	_x = bbox_left; _x < bbox_right + 1; _x += 16){
			for(var	_y = bbox_top; _y < bbox_bottom + 1; _y += 16){
				if(
					!rectangle_in_rectangle(_x, _y, _x + 15, _y + 15, _x1, _y1, _x2, _y2)
					&& !collision_rectangle(_x, _y, _x + 15, _y + 15, Floor, false, true)
				){
					var	_shake = UberCont.opt_shake,
						_sleep = UberCont.opt_freeze,
						_sound = sound_play_pitchvol(0, 0, 0);
						
					UberCont.opt_shake  = 0;
					UberCont.opt_freeze = 0;
					
					with(instances_matching_gt(GameObject, "id", instance_create(_x, _y, FloorExplo))){
						instance_delete(self);
					}
					
					UberCont.opt_shake  = _shake;
					UberCont.opt_freeze = _sleep;
					
					for(var i = _sound; audio_is_playing(i); i++){
						sound_stop(i);
					}
				}
			}
		}
		with(instance_rectangle(bbox_left, bbox_top, bbox_right + 1, bbox_bottom + 1, Detail)){
			instance_destroy();
		}
		with(instances_meeting(x, y, SnowFloor)){
			if(point_in_rectangle(bbox_center_x, bbox_center_y, other.bbox_left, other.bbox_top, other.bbox_right + 1, other.bbox_bottom + 1)){
				instance_destroy();
			}
		}
		instance_destroy();
	}
	
#define floor_tunnel(_x1, _y1, _x2, _y2)
	/*
		Creates and returns a PortalClear that destroys all Walls between two given points, making a FloorExplo tunnel
		Tunnel's height defaults to 32 (image_yscale=16), set its 'image_yscale' to change
	*/
	
	with(instance_create(_x1, _y1, PortalClear)){
		var	_dis = point_distance(x, y, _x2, _y2),
			_dir = point_direction(x, y, _x2, _y2);
			
		sprite_index = sprBoltTrail;
		image_speed  = 16 / _dis;
		image_xscale = _dis;
		image_yscale = 16;
		image_angle  = _dir;
		
		 // Ensure Tunnel:
		if(instance_exists(Wall) && !place_meeting(x, y, Wall) && !place_meeting(x, y, Floor)){
			with(instance_nearest_bbox(x, y, Wall)){
				instance_create(x + pfloor(other.x - x, 16), y + pfloor(other.y - y, 16), Wall);
			}
		}
		
		return self;
	}
	
	return noone;
	
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)
	/*
		Returns a safe starting x/y and direction to use with 'floor_room_create()'
		Searches through the given Floor tiles for one that is far enough away from the spawn and can be reached from the spawn (no Walls in between)
		
		Args:
			spawnX/spawnY - The spawn point
			spawnDis      - Minimum distance that the starting x/y must be from the spawn point
			spawnFloor    - Potential starting floors to search
			
		Ex:
			with(floor_room_start(10016, 10016, 128, FloorNormal)){
				floor_room_create(x, y, 2, 2, "", direction, [60, 90], 96);
			}
	*/
	
	with(array_shuffle(instances_matching_ne(_spawnFloor, "id", null))){
		var	_x = bbox_center_x,
			_y = bbox_center_y;
			
		if(point_distance(_spawnX, _spawnY, _x, _y) >= _spawnDis){
			var _spawnReached = false;
			
			 // Make Sure it Reaches the Spawn Point:
			var _pathWall = [Wall, InvisiWall];
			for(var _fx = bbox_left; _fx < bbox_right + 1; _fx += 16){
				for(var _fy = bbox_top; _fy < bbox_bottom + 1; _fy += 16){
					if(path_reaches(path_create(_fx + 8, _fy + 8, _spawnX, _spawnY, _pathWall), _spawnX, _spawnY, _pathWall)){
						_spawnReached = true;
						break;
					}
				}
				if(_spawnReached) break;
			}
			
			 // Success bro!
			if(_spawnReached){
				return {
					"x"         : _x,
					"y"         : _y,
					"direction" : point_direction(_spawnX, _spawnY, _x, _y),
					"id"        : id
				};
			}
		}
	}
	
	return noone;
	
#define floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)
	/*
		Moves toward a given direction until an open space is found, then creates a room based on the width, height, and type
		Rooms will always connect to the level as long as floorDis <= 0 (and the starting x/y is over a floor)
		Rooms will not overlap existing Floors as long as floorDis >= 0 (they can still overlap FloorExplo)
		
		Args:
			x/y      - The point to begin the search for an open space to create the room
			w/h      - Width/height of the room to create
			type     - The type of room to create (see 'floor_fill' script)
			dirStart - The direction to search towards for an open space
			dirOff   - Random directional offset to use while searching towards dirStart
			floorDis - How far from the level to create the room
			           Use 0 to spawn adjacent to the level, >0 to create an isolated room, <0 to overlap the level
			
		Ex:
			floor_room_create(10016, 10016, 5, 3, "round", random(360), 0, 0)
	*/
	
	 // Find Space:
	var	_move       = true,
		_floorAvoid = FloorNormal,
		_dis        = 16,
		_dir        = 0,
		_ow         = (_w * 32) / 2,
		_oh         = (_h * 32) / 2,
		_sx         = _x,
		_sy         = _y;
		
	if(!is_array(_dirOff)){
		_dirOff = [_dirOff];
	}
	while(array_length(_dirOff) < 2){
		array_push(_dirOff, 0);
	}
	
	while(_move){
		var	_x1   = _x - _ow,
			_y1   = _y - _oh,
			_x2   = _x + _ow,
			_y2   = _y + _oh,
			_inst = instance_rectangle_bbox(_x1 - _floorDis, _y1 - _floorDis, _x2 + _floorDis - 1, _y2 + _floorDis - 1, _floorAvoid);
			
		 // No Corner Floors:
		if(_type == "round" && _floorDis <= 0){
			with(_inst){
				if((bbox_right < _x1 + 32 || bbox_left >= _x2 - 32) && (bbox_bottom < _y1 + 32 || bbox_top >= _y2 - 32)){
					_inst = array_delete_value(_inst, self);
				}
			}
		}
		
		 // Floors in Range:
		_move = false;
		if(array_length(_inst)){
			if(_floorDis <= 0){
				_move = true;
			}
			
			 // Floor Distance Check:
			else with(_inst){
				var	_fx = clamp(_x, bbox_left, bbox_right + 1),
					_fy = clamp(_y, bbox_top, bbox_bottom + 1),
					_fDis = (
						(_type == "round")
						? min(
							point_distance(_fx, _fy, clamp(_fx, _x1 + 32, _x2 - 32), clamp(_fy, _y1,      _y2     )),
							point_distance(_fx, _fy, clamp(_fx, _x1,      _x2     ), clamp(_fy, _y1 + 32, _y2 - 32))
						)
						: point_distance(_fx, _fy, clamp(_fx, _x1, _x2), clamp(_fy, _y1, _y2))
					);
					
				if(_fDis < _floorDis){
					_move = true;
					break;
				}
			}
			
			 // Keep Searching:
			if(_move){
				_dir = pround(_dirStart + (random_range(_dirOff[0], _dirOff[1]) * choose(-1, 1)), 90);
				_x += lengthdir_x(_dis, _dir);
				_y += lengthdir_y(_dis, _dir);
			}
		}
	}
	
	 // Create Room:
	var	_floorNumLast = array_length(FloorNormal),
		_floors       = mod_script_call_nc(mod_current_type, mod_current, "floor_fill", _x, _y, _w, _h, _type),
		_floorNum     = array_length(FloorNormal),
		_x1           = _x,
		_y1           = _y,
		_x2           = _x,
		_y2           = _y;
		
	if(array_length(_floors)){
		with(_floors[0]){
			_x1 = bbox_left;
			_y1 = bbox_top;
			_x2 = bbox_right  + 1;
			_y2 = bbox_bottom + 1;
		}
		with(_floors){
			var	_fx1 = bbox_left,
				_fy1 = bbox_top,
				_fx2 = bbox_right,
				_fy2 = bbox_bottom;
				
			 // Determine Room's Dimensions:
			_x1 = min(_x1, _fx1);
			_y1 = min(_y1, _fy1);
			_x2 = max(_x2, _fx2 + 1);
			_y2 = max(_y2, _fy2 + 1);
			
			 // Fix Potential Wall Softlock:
			if(_floorDis <= 0 && _floorNum == _floorNumLast + array_length(_floors)){
				with(array_combine(
					instance_rectangle_bbox(_fx1 - 1, _fy1,     _fx2 + 1, _fy2,     Wall),
					instance_rectangle_bbox(_fx1,     _fy1 - 1, _fx2,     _fy2 + 1, Wall)
				)){
					if(instance_exists(self) && place_meeting(x, y, Floor)){
						with(instances_meeting(x, y, [Bones, TopPot])){
							if(place_meeting(x, y, other)){
								instance_delete(self);
							}
						}
						instance_delete(self);
					}
				}
			}
		}
	}
	
	 // Done:
	return {
		"floors" : _floors,
		"x"      : (_x1 + _x2) / 2,
		"y"      : (_y1 + _y2) / 2,
		"x1"     : _x1,
		"y1"     : _y1,
		"x2"     : _x2,
		"y2"     : _y2,
		"xstart" : _sx,
		"ystart" : _sy
	};
	
#define floor_room(_spawnX, _spawnY, _spawnDis, _spawnFloor, _w, _h, _type, _dirOff, _floorDis)
	/*
		Automatically creates a room a safe distance from the spawn point
		Rooms will always connect to the level as long as floorDis <= 0
		Rooms will not overlap existing Floors as long as floorDis >= 0 (they can still overlap FloorExplo)
		
		Args:
			spawnX/spawnY - The spawn point
			spawnDis      - Minimum distance from the spawn point to begin searching for an open space
			spawnFloor    - Potential starting floors to begin searching for an open space from
			w/h           - Width/height of the room to create
			type          - The type of room to create (see 'floor_fill' script)
			dirOff        - Random directional offset to use while moving away from the spawn point to find an open space
			floorDis      - How far from the level to create the room
			                Use 0 to spawn adjacent to the level, >0 to create an isolated room, <0 to overlap the level
			
		Ex:
			floor_room(10016, 10016, 96, FloorNormal, 4, 4, "round", 60, -32)
	*/
	
	with(floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)){
		return floor_room_create(x, y, _w, _h, _type, direction, _dirOff, _floorDis);
	}
	
	return noone;
	
#define wall_clear(_x, _y)
	/*
		Creates and returns a PortalClear that destroys all Walls touching the calling instance at the given position
	*/
	
	with(instance_create(_x, _y, PortalClear)){
		sprite_index = ((other.mask_index < 0) ? other.sprite_index : other.mask_index);
		image_xscale = other.image_xscale;
		image_yscale = other.image_yscale;
		image_angle  = other.image_angle;
		
		return self;
	}
	
#define wall_delete(_x1, _y1, _x2, _y2)
	/*
		Deletes all Walls and Wall-related objects within the given rectangular area
	*/
	
	with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, [Wall, InvisiWall])){
		with(instances_matching(instances_matching(TrapScorchMark, "x", x), "y", y)){
			instance_delete(self);
		}
		instance_delete(self);
	}
	with(instance_rectangle_bbox(_x1, _y1, _x2, _y2, [TopSmall, TopPot, Bones])){
		instance_delete(self);
	}
	
#define wall_tops()
	/*
		Creates the outer TopSmall tiles around the calling Wall instance
	*/
	
	var _minID = instance_max;
	
	instance_create(x - 16, y - 16, Top);
	instance_create(x - 16, y,      Top);
	instance_create(x,      y - 16, Top);
	instance_create(x,      y,      Top);
	
	return instances_matching_gt(TopSmall, "id", _minID);
	
#define wall_update(_x1, _y1, _x2, _y2)
	with(instance_rectangle(_x1, _y1, _x2, _y2, Wall)){
		 // Fix:
		visible = place_meeting(x, y + 16, Floor);
		l = (place_free(x - 16, y) ?  0 :  4);
		w = (place_free(x + 16, y) ? 24 : 20) - l;
		r = (place_free(x, y - 16) ?  0 :  4);
		h = (place_free(x, y + 16) ? 24 : 20) - r;
		
		 // TopSmalls:
		wall_tops();
	}
	
#define instance_budge(_objAvoid, _disMax)
	/*
		Moves the current instance to the nearest space within the given distance that isn't touching the given object
		Also avoids moving an instance outside of the level if they were touching a Floor
		Returns 'true' if the instance was moved to an open space, 'false' otherwise
		
		Args:
			objAvoid - The object(s) or instance(s) to avoid
			disMax   - The maximum distance that the current instance can be moved
			           Use -1 to automatically determine the distance using the bounding boxes of the current instance and objAvoid
	*/
	
	var	_inLevel  = !place_meeting(xprevious, yprevious, Floor),
		_objArray = is_array(_objAvoid),
		_dirStart = direction + 180,
		_disMultX = 1,
		_disMultY = 1;
		
	 // Starting Direction:
	if(x != xprevious || y != yprevious){
		_dirStart = point_direction(x, y, xprevious, yprevious);
	}
	
	 // Auto Max Distance:
	if(_disMax < 0){
		var	_objW = 0,
			_objH = 0;
			
		with(_objArray ? _objAvoid : [_objAvoid]){
			if(object_exists(self)){
				var _mask = object_get_mask(self);
				if(_mask < 0){
					_mask = object_get_sprite(self);
				}
				_objW = max(_objW, (sprite_get_bbox_right(_mask)  + 1) - sprite_get_bbox_left(_mask));
				_objH = max(_objH, (sprite_get_bbox_bottom(_mask) + 1) - sprite_get_bbox_top(_mask));
			}
			else{
				_objW = max(_objW, bbox_width);
				_objH = max(_objH, bbox_height);
			}
		}
		
		var	_w = _objW + bbox_width,
			_h = _objH + bbox_height;
			
		_disMultX = max(1, _w / _h);
		_disMultY = max(1, _h / _w);
		_disMax   = sqrt(sqr(min(_w, _h) - 1) * 2);
	}
	
	 // Search for Open Space:
	var	_dis     = 0,
		_disAdd  = max(1, _disMax / 16);
		
	while(true){
		var	_dir    = _dirStart,
			_dirAdd = 360 / max(1, 4 * _dis);
			
		 // Look Around:
		repeat(ceil(360 / abs(_dirAdd))){
			var	_x = x + lengthdir_x(_dis * _disMultX, _dir),
				_y = y + lengthdir_y(_dis * _disMultY, _dir);
				
			if(
				_objArray
				? !array_length(instances_meeting(_x, _y, _objAvoid))
				: !place_meeting(_x, _y, _objAvoid)
			){
				if(_inLevel || (place_free(_x, _y) && (position_meeting(_x, _y, Floor) || place_meeting(_x, _y, Floor)))){
					x = _x;
					y = _y;
					xprevious = x;
					yprevious = y;
					
					return true;
				}
			}
			
			_dir += _dirAdd;
		}
		
		 // Go Outward:
		if(_dis >= _disMax){
			break;
		}
		_dis = min(_dis + clamp(_dis, 1, _disAdd), _disMax);
	}
	
	return false;
	
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)
	/*
		Creates a lightning arc between the two given points
		Automatically sets team, creator, and hitid based on the calling instance
		
		Args:
			x1/y1 - The starting position
			x2/y2 - The ending position
			arc   - How far the lightning can offset from its main travel line
			enemy - If it's an enemy lightning arc or not, true/false
			
		Ex:
			lightning_connect(x, y, mouse_x, mouse_y, 8 * sin(wave / 60), false)
	*/
	
	var	_disMax  = point_distance(_x1, _y1, _x2, _y2),
		_disAdd  = min(_disMax / 8, 10) + (_enemy ? (array_length(instances_matching_ge(instances_matching(CustomEnemy, "name", "Eel"), "arcing", 1)) - 1) : 0),
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
		_inst    = [],
		_creator = (("creator" in self && !instance_is(self, hitme)) ? creator : self),
		_hitid   = variable_instance_get(self, "hitid", -1),
		_team    = variable_instance_get(self, "team", -1),
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
			_off  = 4 * sin((_dis / 8) + (current_frame / 6));
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
				_imgInd = ((current_frame + _arc) * image_speed) % image_number;
			}
			image_index     = _imgInd;
			image_speed_raw = image_number;
			
			array_push(_inst, self);
		}
		
		_lx = _wx;
		_ly = _wy;
	}
	
	 // FX:
	if(chance_ct(array_length(_inst), 200)){
		with(_inst[irandom(array_length(_inst) - 1)]){
			with(instance_create(x + orandom(8), y + orandom(8), PortalL)){
				motion_add(random(360), 1);
			}
			if(_enemy) sound_play_hit(sndLightningReload, 0.5);
			else sound_play_pitchvol(sndLightningReload, 1.25 + random(0.5), 0.5);
		}
	}
	
	return _inst;
	
#define wep_raw(_wep)
	/*
		For use with LWO weapons
		Call a weapon's "weapon_raw" script in case of wrapper weapons
		
		Ex:
			wep_raw({ wep:{ wep:{ wep:123 }}}) == 123
	*/
	
	var _raw = _wep;
	
	 // Find Base Weapon:
	while(is_object(_raw)){
		_raw = (("wep" in _raw) ? _raw.wep : wep_none);
	}
	
	 // Wrapper:
	if(is_string(_raw) && mod_script_exists("weapon", _raw, "weapon_raw")){
		_raw = mod_script_call("weapon", _raw, "weapon_raw", _wep);
	}
	
	return _raw;
	
#define wep_wrap(_wep, _scrName, _scrRef)
	/*
		Returns the given weapon as an NT:TE wrapper weapon, with the given script modification
		
		Args:
			wep     - The weapon to modify
			scrName - The name of the script to modify
			scrAdd  - A script reference to call after the given script, which can return a custom value for the weapon
			          The script is called with its 'argument0' being the weapon's current value, and then the normal script's arguments
			          Can also be a boolean value to toggle the script's base execution
			
		Ex:
			wep  = wep_wrap(wep,  "weapon_sprt", script_ref_create(coolspr));
			bwep = wep_wrap(bwep, "weapon_fire", false);
			
			#define coolspr(_spr, _wep)
				return sprBanditGun;
	*/
	
	 // Wrapper Setup:
	if(!is_object(_wep) || "tewrapper" not in _wep){
		var _wrap = {
			"wep"     : wep_raw(_wep),
			"lwo"     : is_object(_wep),
			"scr_use" : {},
			"scr_ref" : {}
		};
		
		if(!_wrap.lwo){
			_wep = {};
		}
		
		_wep.wep       = "tewrapper";
		_wep.tewrapper = _wrap;
	}
	
	 // Toggle Base Script:
	if(is_real(_scrRef)){
		lq_set(_wep.tewrapper.scr_use, _scrName, _scrRef);
	}
	
	 // Add Script:
	else{
		if(_scrName not in _wep.tewrapper.scr_ref){
			lq_set(_wep.tewrapper.scr_ref, _scrName, [_scrRef]);
		}
		else{
			array_push(lq_get(_wep.tewrapper.scr_ref, _scrName), _scrRef);
		}
	}
	
	return _wep;
	
#define wep_skin(_wep, _race, _skin)
	/*
		Returns the given weapon as a resprited variant for the given skin if one exists
	*/
	
	if(is_string(_skin) && array_find_index(ntte_mods.skin, _skin) >= 0){
		var _refSprt = script_ref_create_ext("skin", _skin, "skin_weapon_sprite");
		if(mod_script_exists(_refSprt[0], _refSprt[1], _refSprt[2])){
			var _spr = weapon_get_sprt(_wep);
			if(_spr != script_ref_call(_refSprt, _spr, _wep)){
				_wep = wep_wrap(wep_wrap(wep_wrap(
					_wep,
					"weapon_sprt", _refSprt),
					"weapon_name", script_ref_create(wep_skin_name, _race, _skin)),
					"weapon_fire", script_ref_create(wep_skin_fire, _race, _skin)
				);
				with([
					["weapon_sprt_hud", "skin_weapon_sprite_hud"],
					["weapon_swap",     "skin_weapon_swap"]
				]){
					var _ref = script_ref_create_ext("skin", _skin, self[1]);
					if(mod_script_exists(_ref[0], _ref[1], _ref[2])){
						_wep = wep_wrap(_wep, self[0], _ref);
					}
				}
			}
		}
	}
	
	return _wep;
	
#define wep_skin_name(_race, _skin, _name, _wep)
	/*
		Returns the given weapon's name with "GOLDEN" replaced by the given skin's name, or prefixed by it if "GOLDEN" isn't mentioned
	*/
	
	if(!is_string(_name)){
		_name = weapon_get_name(wep_raw(_wep));
	}
	
	var	_nameSplit = string_split(_name, " "),
		_skinName  = skin_get_name(_race, _skin);
		
	for(var i = array_length(_nameSplit) - 1; i >= 0; i--){
		if(string_upper(_nameSplit[i]) == "GOLDEN"){
			_nameSplit[i] = _skinName;
		}
	}
	
	return (
		(array_find_index(_nameSplit, _skinName) >= 0)
		? array_join(_nameSplit, " ")
		: (
			(wep_raw(_wep) == wep_frog_pistol)
			? _name
			: (_skinName + " " + _name)
		)
	);
	
#define wep_skin_fire(_race, _skin, _fireID, _wep)
	/*
		Resprites projectiles shot by the given weapon to the given skin
	*/
	
	if(instance_exists(projectile)){
		var _inst = instances_matching_gt(projectile, "id", _fireID);
		if(array_length(_inst)) with(_inst){
			var _spr = mod_script_call("skin", _skin, "skin_weapon_sprite", sprite_index, _wep);
			if(sprite_index != _spr){
				 // Cause of Death:
				if(hitid == 101){
					hitid = [sprGoldDisc, "GOLDEN DISC"];
				}
				if(array_length(hitid) && sprite_index == hitid[0]){
					hitid[0] = _spr;
					if(array_length(hitid) > 1 && is_string(hitid[1])){
						hitid[1] = wep_skin_name(_race, _skin, hitid[1], _wep);
					}
				}
				
				 // Hitbox:
				if(mask_index < 0){
					mask_index = sprite_index;
				}
				
				 // Sprite:
				sprite_index = _spr;
			}
		}
	}
	
	return _fireID;
	
#define wep_merge(_stock, _front)
	return mod_script_call_nc("weapon", "merge", "weapon_merge", _stock, _front);

#define wep_merge_decide(_hardMin, _hardMax)
	return mod_script_call_nc("weapon", "merge", "weapon_merge_decide", _hardMin, _hardMax);

#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)
	/*
		Returns a random weapon that spawns within the given difficulties
		Takes standard weapon chest spawning conditions into account
		
		Args:
			hardMin - The minimum weapon spawning difficulty
			hardMax - The maximum weapon spawning difficulty
			gold    - Spawn golden weapons like a mansion chest, true/false
			          Use -1 to completely exclude golden weapons
			noWep   - A weapon or array of weapons to exclude from spawning
			
		Ex:
			wep = weapon_decide(0, 1 + (2 * curse) + GameCont.hard, false, null);
			wep = weapon_decide(2, GameCont.hard, false, [p.wep, p.bwep]);
	*/
	
	 // Hardmode:
	_hardMax += ceil((GameCont.hard - (UberCont.hardmode * 13)) / (1 + (UberCont.hardmode * 2))) - GameCont.hard;
	
	 // Robot:
	for(var i = 0; i < maxp; i++){
		if(player_get_race(i) == "robot"){
			_hardMax++;
		}
	}
	_hardMin += 5 * ultra_get("robot", 1);
	
	 // Just in Case:
	_hardMax = max(0, _hardMax);
	_hardMin = min(_hardMin, _hardMax);
	
	 // Default:
	var _wepDecide = wep_screwdriver;
	if("wep" in self && wep != wep_none){
		_wepDecide = wep;
	}
	else if(_gold > 0){
		_wepDecide = choose(wep_golden_wrench, wep_golden_machinegun, wep_golden_shotgun, wep_golden_crossbow, wep_golden_grenade_launcher, wep_golden_laser_pistol);
		if(GameCont.loops > 0 && random(2) < 1){
			_wepDecide = choose(wep_golden_screwdriver, wep_golden_assault_rifle, wep_golden_slugger, wep_golden_splinter_gun, wep_golden_bazooka, wep_golden_plasma_gun);
		}
	}
	
	 // Decide:
	var	_list    = ds_list_create(),
		_listMax = weapon_get_list(_list, _hardMin, _hardMax);
		
	ds_list_shuffle(_list);
	
	for(var i = 0; i < _listMax; i++){
		var	_wep    = ds_list_find_value(_list, i),
			_canWep = true;
			
		 // Weapon Exceptions:
		if(_wep == _noWep || (is_array(_noWep) && array_find_index(_noWep, _wep) >= 0)){
			_canWep = false;
		}
		
		 // Gold Check:
		else if((_gold > 0 && !weapon_get_gold(_wep)) || (_gold < 0 && weapon_get_gold(_wep) == 0)){
			_canWep = false;
		}
		
		 // Specific Spawn Conditions:
		else switch(_wep){
			case wep_super_disc_gun       : if("curse" not in self || curse <= 0) _canWep = false; break;
			case wep_golden_nuke_launcher : if(!UberCont.hardmode)                _canWep = false; break;
			case wep_golden_disc_gun      : if(!UberCont.hardmode)                _canWep = false; break;
			case wep_gun_gun              : if(crown_current != crwn_guns)        _canWep = false; break;
		}
		
		 // Success:
		if(_canWep){
			_wepDecide = _wep;
			break;
		}
	}
	
	ds_list_destroy(_list);
	
	return _wepDecide;
	
#define weapon_get(_name, _wep)
	/*
		Calls the given script from a weapon mod and fetches its return value
	*/
	
	var _raw = _wep;
	
	 // Find Base Weapon:
	while(is_object(_raw) && "wep" in _raw){
		_raw = _raw.wep;
	}
	
	 // Call Script:
	if(is_string(_raw)){
		var _scrt = "weapon_" + _name;
		if(mod_script_exists("weapon", _raw, _scrt)){
			return mod_script_call_self("weapon", _raw, _scrt, _wep);
		}
	}
	
	 // Default:
	switch(_name){
		
		case "avail":
		case "burst":
			
			return 1;
			
		case "loadout":
			
			switch(_raw){
				case wep_revolver                : return sprRevolverLoadout;
				case wep_golden_revolver         : return sprGoldRevolverLoadout;
				case wep_chicken_sword           : return sprChickenSwordLoadout;
				case wep_rogue_rifle             : return sprRogueRifleLoadout;
				case wep_rusty_revolver          : return sprRustyRevolverLoadout;
				case wep_golden_wrench           : return sprGoldWrenchLoadout;
				case wep_golden_machinegun       : return sprGoldMachinegunLoadout;
				case wep_golden_shotgun          : return sprGoldShotgunLoadout;
				case wep_golden_crossbow         : return sprGoldCrossbowLoadout;
				case wep_golden_grenade_launcher : return sprGoldGrenadeLauncherLoadout;
				case wep_golden_laser_pistol     : return sprGoldLaserPistolLoadout;
				case wep_golden_screwdriver      : return sprGoldScrewdriverLoadout;
				case wep_golden_assault_rifle    : return sprGoldAssaultRifleLoadout;
				case wep_golden_slugger          : return sprGoldSluggerLoadout;
				case wep_golden_splinter_gun     : return sprGoldSplintergunLoadout;
				case wep_golden_bazooka          : return sprGoldBazookaLoadout;
				case wep_golden_plasma_gun       : return sprGoldPlasmaGunLoadout;
				case wep_golden_nuke_launcher    : return sprGoldNukeLauncherLoadout;
				case wep_golden_disc_gun         : return sprGoldDiscgunLoadout;
				case wep_golden_frog_pistol      : return sprGoldToxicGunLoadout;
			}
			
			break;
			
		case "raw":
			
			return (is_object(_wep) ? wep_none : _wep);
			
	}
	
	return 0;
	
#define weapon_fire_init(_wep)
	/*
		Called from a 'weapon_fire' script to do some basic weapon firing setup
		Returns a LWO with some useful variables
		
		Vars:
			wep     - The weapon's value, may be modified from the given argument
			creator - The actual instance firing, for 'player_fire_ext()' support
			primary - The weapon is in the primary slot (true) or secondary slot (false)
			wepheld - The weapon is physically stored in the creator's 'wep' variable
			spec    - The weapon is being shot by an active (YV, Steroids, Skeleton)
			burst   - The current burst shot (starts at 1)
	*/
	
	var _fire = {
		"wep"     : _wep,
		"creator" : noone,
		"primary" : true,
		"wepheld" : false,
		"spec"    : false,
		"burst"   : 1
	};
	
	 // Creator:
	_fire.creator = self;
	if(instance_is(self, FireCont) && "creator" in self){
		_fire.creator = creator;
	}
	
	 // Weapon Held by Creator:
	_fire.wepheld = (variable_instance_get(_fire.creator, "wep") == _fire.wep);
	
	 // Active / Secondary Firing:
	_fire.spec = variable_instance_get(self, "specfiring", false);
	if(race == "steroids" && _fire.spec){
		_fire.primary = false;
	}
	
	 // LWO Setup:
	var _lwo = mod_variable_get("weapon", wep_raw(_fire.wep), "lwoWep");
	if(is_object(_lwo)){
		if(!is_object(_fire.wep)){
			_fire.wep = { "wep" : _fire.wep };
			if(_fire.wepheld){
				_fire.creator.wep = _fire.wep;
			}
		}
		for(var i = lq_size(_lwo) - 1; i >= 0; i--){
			var _key = lq_get_key(_lwo, i);
			if(_key not in _fire.wep){
				lq_set(_fire.wep, _key, lq_get_value(_lwo, i));
			}
		}
	}
	
	 // NT:TE Systems:
	var _other = other;
	with(instance_exists(_fire.creator) ? _fire.creator : self){
		 // Charge Weapon:
		if(weapon_get("chrg", _fire.wep) && _fire.wep.chrg >= 0){
			var	_load = variable_instance_get(self, "reloadspeed", 1) * current_time_scale,
				_auto = ((other.race == "steroids") ? (weapon_get_auto(_fire.wep) >= 0) : weapon_get_auto(_fire.wep));
				
			 // Charging (chrg: -1==Released, 0==None, 1==Charging, 2==Charged):
			_fire.wep.chrg = ((_fire.wep.chrg_num < _fire.wep.chrg_max) ? 1 : 2);
			switch(_fire.wep.chrg){
				
				case 1: // Charging
					
					_fire.wep.chrg_num = min(_fire.wep.chrg_num + _load, _fire.wep.chrg_max);
					
					 // Pop Pop:
					if(_fire.spec && _fire.primary){
						_fire.wep.chrg_num = _fire.wep.chrg_max;
					}
					
					break;
					
				case 2: // Fully Charged - Blink
					
					if((current_frame % 12) < current_time_scale){
						with(_fire.creator) if(instance_is(self, Player)){
							gunshine = 2;
						}
					}
					
					break;
					
			}
			
			 // Hold to Charge:
			if(_auto || _fire.wep.chrg_num >= _fire.wep.chrg_max){
				 // Manual Reload:
				other.reload += _load - weapon_get_load(_fire.wep);
				
				 // Charge Controller:
				with(other){
					var _inst = instances_matching(instances_matching(CustomObject, "name", "WeaponCharger"), "wep", _fire.wep);
					if(!array_length(_inst)){
						_inst = instance_create(x, y, CustomObject);
						with(_inst){
							name    = "WeaponCharger";
							on_step = weapon_chrg_step;
							wep     = _fire.wep;
						}
					}
					with(_inst){
						x         = other.x;
						y         = other.y;
						direction = other.gunangle;
						accuracy  = other.accuracy;
						team      = other.team;
						creator   = _fire.creator;
						primary   = _fire.primary;
						fire      = !_auto;
					}
				}
			}
		}
		
		 // Normal Weapon:
		else{
			 // Melee:
			if(weapon_is_melee(_fire.wep)){
				other.wepangle *= -1;
			}
			
			 // Burst Fire:
			if(instance_is(_other, CustomObject) && "name" in _other && _other.name == "WeaponBurst"){
				_fire.burst = _other.burst;
			}
			else{
				var _burst = ceil(weapon_get("burst", _fire.wep));
				if(_burst > 1 || _burst < 0){
					var _time = weapon_get("burst_time", _fire.wep);
					if(_time == 0){
						_time = weapon_get_load(_fire.wep) / max(1, _burst);
					}
					with(other){
						with(instance_create(x, y, CustomObject)){
							name      = "WeaponBurst";
							on_step   = weapon_burst_step;
							direction = other.gunangle;
							accuracy  = other.accuracy;
							team      = other.team;
							creator   = _fire.creator;
							primary   = _fire.primary;
							wep       = _fire.wep;
							burst     = 0;
							ammo      = _burst - 1;
							time      = _time;
							time_max  = _time;
							chrg      = lq_get(_fire.wep, "chrg");
							chrg_num  = lq_get(_fire.wep, "chrg_num");
							
							 // Insta-Fire:
							time -= random(current_time_scale);
							if(time <= 0){
								time += current_time_scale;
								with(self){
									event_perform(ev_step, ev_step_normal);
								}
							}
							
							 // Burst Level:
							if(instance_exists(self)){
								burst++;
								_fire.burst = burst;
							}
						}
					}
				}
			}
		}
	}
	
	return _fire;
	
#define weapon_burst_step
	if(time > 0 && ammo != 0){
		time -= current_time_scale;
		while(time <= 0 && time_max >= 0 && ammo-- != 0){
			var _wep = wep;
			burst++;
			
			 // Delay:
			with(creator){
				var _time = weapon_get("burst_time", _wep);
				if(_time != 0){
					other.time_max = _time;
				}
			}
			time += time_max;
			
			 // Fire:
			if(instance_exists(creator)){
				x = creator.x;
				y = creator.y;
				if("gunangle" in creator){
					direction = creator.gunangle;
				}
				
				 // Charge Weapon Fix:
				var	_lastChrg    = undefined,
					_lastChrgNum = undefined;
					
				if(is_object(_wep)){
					if("chrg"     in _wep && !is_undefined(chrg)    ){ _lastChrg    = _wep.chrg;     _wep.chrg     = chrg;     }
					if("chrg_num" in _wep && !is_undefined(chrg_num)){ _lastChrgNum = _wep.chrg_num; _wep.chrg_num = chrg_num; }
				}
				
				 // Player:
				if(instance_is(creator, Player)){
					with(creator){
						 // Steroids:
						if(!other.primary){
							player_swap();
							specfiring = true;
						}
						
						 // Fire:
						var	_lastTeam     = team,
							_lastAccuracy = accuracy;
							
						team     = other.team;
						accuracy = other.accuracy;
						
						weapon_get("fire", _wep);
						
						team     = _lastTeam;
						accuracy = _lastAccuracy;
						
						 // Steroids:
						if(!other.primary){
							specfiring = false;
							player_swap();
						}
					}
				}
				
				 // Non-Player:
				else with(player_fire_ext(direction, wep_none, x, y, team, creator, accuracy)){
					wep = _wep;
					weapon_get("fire", wep);
				}
				
				 // Charge Weapon Fix Reset:
				if(is_object(_wep)){
					if("chrg"     in _wep && !is_undefined(chrg)     && _wep.chrg     == chrg    ) _wep.chrg     = _lastChrg;
					if("chrg_num" in _wep && !is_undefined(chrg_num) && _wep.chrg_num == chrg_num) _wep.chrg_num = _lastChrgNum;
				}
			}
		}
	}
	else instance_destroy();
	
#define weapon_chrg_step
	if(fire){
		if(is_object(wep) && "chrg" in wep){
			if(wep.chrg){
				wep.chrg = -1;
				
				var _wepName = (primary ? "wep" : "bwep");
				
				with(creator){
					if(visible){
						other.x = x;
						other.y = y;
						if(_wepName not in self || variable_instance_get(self, _wepName) == other.wep){
							 // Player:
							if(instance_is(self, Player)){
								 // Steroids:
								if(!other.primary){
									player_swap();
									specfiring = true;
								}
								
								 // Fire:
								var	_type = weapon_get_type(other.wep),
									_cost = weapon_get_cost(other.wep),
									_rads = weapon_get_rads(other.wep),
									_ammo = ammo[_type];
									
								if(infammo != 0 || (_ammo >= _cost && GameCont.rad >= _rads)){
									var	_lastTeam     = team,
										_lastAccuracy = accuracy;
										
									team     = other.team;
									accuracy = other.accuracy;
									
									player_fire(other.direction);
									
									team     = _lastTeam;
									accuracy = _lastAccuracy;
								}
								
								 // Low Ammo:
								else{
									wkick     = -2;
									clicked   = false;
									drawempty = 30;
									sound_play((_ammo < _cost) ? sndEmpty : sndUltraEmpty);
									with(instance_create(x, y, PopupText)){
										target = other.index;
										text   = ((_ammo < _cost) ? ((_ammo > 0) ? "NOT ENOUGH " + other.typ_name[_type] : "EMPTY") : "NOT ENOUGH RADS");
									}
								}
								
								 // Steroids:
								if(!other.primary){
									specfiring = false;
									player_swap();
								}
							}
							
							 // Non-Player:
							else player_fire_ext(other.direction, other.wep, other.x, other.y, other.team, other.creator, other.accuracy);
						}
					}
				}
				wep.chrg = 0;
			}
			wep.chrg_num = 0;
		}
		instance_destroy();
	}
	else fire = true;
	
#define weapon_ammo_fire(_wep)
	/*
		Called from a 'weapon_fire' script to process LWO weapons with internal ammo
		Returns 'true' if the weapon had enough internal ammo to fire, 'false' otherwise
	*/
	
	 // Gun Warrant:
	if(infammo != 0){
		return true;
	}
	
	 // Ammo Cost:
	var _cost = lq_defget(_wep, "cost", 1);
	with(_wep) if(ammo >= _cost){
		ammo -= _cost;
		
		 // Can Fire:
		return true;
	}
	
	 // Not Enough Ammo:
	reload = variable_instance_get(self, "reloadspeed", 1) * current_time_scale;
	if("anam" in _wep){
		if(button_pressed(index, (specfiring ? "spec" : "fire"))){
			wkick = -2;
			sound_play(sndEmpty);
			with(instance_create(x, y, PopupText)){
				target = other.index;
				text   = ((_wep.ammo > 0) ? "NOT ENOUGH " + _wep.anam : "EMPTY");
			}
		}
	}
	
	return false;
	
#define weapon_ammo_hud(_wep)
	/*
		Called from a 'weapon_sprt_hud' script to draw HUD for LWO weapons with internal ammo
		Returns the weapon's normal sprite for easy returning
		
		Ex:
			#define weapon_sprt_hud(w)
				return weapon_ammo_hud(w);
	*/
	
	 // Draw Ammo:
	if(
		instance_is(self, Player)
		&& (instance_is(other, TopCont) || instance_is(other, UberCont))
		&& is_object(_wep)
	){
		var	_ammo    = lq_defget(_wep, "ammo", 0),
			_ammoMax = lq_defget(_wep, "amax", _ammo),
			_ammoMin = lq_defget(_wep, "amin", round(_ammoMax * 0.2));
			
		draw_ammo(index, (bwep != _wep), (race == "steroids"), _ammo, _ammoMin);
	}
	
	 // Default Sprite:
	return weapon_get_sprt(_wep);
	
#define draw_ammo(_index, _primary, _steroids, _ammo, _ammoMin)
	/*
		Draws ammo HUD text
		
		Args:
			index    - The player to draw HUD for
			primary  - Is a primary weapon, true/false
			steroids - Player can dual wield, true/false
			ammo     - Ammo, can be a string or number
			ammoMin  - Low ammo threshold
	*/
	
	var _local = player_find_local_nonsync();
	
	if(player_is_active(_local) && player_get_show_hud(_index, _local)){
		if(!instance_exists(menubutton) || _index == _local){
			var	_x = view_xview_nonsync + (_primary ? 42 : 86),
				_y = view_yview_nonsync + 21;
				
			 // Co-op Offset:
			var _active = 0;
			for(var i = 0; i < maxp; i++){
				_active += player_is_active(i);
			}
			if(_active > 1){
				_x -= 19;
			}
			
			 // Color:
			var _text = "";
			if(is_real(_ammo)){
				_text += "@";
				if(_ammo > 0){
					if(_primary || _steroids){
						if(_ammo > _ammoMin){
							_text += "w";
						}
						else _text += "r";
					}
					else _text += "s";
				}
				else _text += "d";
			}
			_text += string(_ammo);
			
			 // !!!
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			draw_set_projection(2, _index);
			draw_text_nt(_x, _y, _text);
			draw_reset_projection();
		}
	}
	
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)
	 // Auto-Determine Grid Size:
	var	_tileSize   = 16,
		_areaWidth  = pceil(abs(_xtarget - _xstart), _tileSize) + 320,
		_areaHeight = pceil(abs(_ytarget - _ystart), _tileSize) + 320;
		
	_areaWidth  = max(_areaWidth, _areaHeight);
	_areaHeight = max(_areaWidth, _areaHeight);
	
	var _triesMax = 4 * ceil((_areaWidth + _areaHeight) / _tileSize);
	
	 // Clamp Path X/Y:
	_xstart  = pfloor(_xstart,  _tileSize);
	_ystart  = pfloor(_ystart,  _tileSize);
	_xtarget = pfloor(_xtarget, _tileSize);
	_ytarget = pfloor(_ytarget, _tileSize);
	
	 // Grid Setup:
	var	_gridw    = ceil(_areaWidth  / _tileSize),
		_gridh    = ceil(_areaHeight / _tileSize),
		_gridx    = pround(((_xstart + _xtarget) / 2) - (_areaWidth  / 2), _tileSize),
		_gridy    = pround(((_ystart + _ytarget) / 2) - (_areaHeight / 2), _tileSize),
		_grid     = ds_grid_create(_gridw, _gridh),
		_gridCost = ds_grid_create(_gridw, _gridh);
		
	ds_grid_clear(_grid, -1);
	
	 // Mark Walls:
	with(instance_rectangle(_gridx, _gridy, _gridx + _areaWidth, _gridy + _areaHeight, _wall)){
		if(position_meeting(x, y, self)){
			_grid[# (x - _gridx) / _tileSize, (y - _gridy) / _tileSize] = -2;
		}
	}
	
	 // Pathing:
	var	_x1         = (_xtarget - _gridx) / _tileSize,
		_y1         = (_ytarget - _gridy) / _tileSize,
		_x2         = (_xstart  - _gridx) / _tileSize,
		_y2         = (_ystart  - _gridy) / _tileSize,
		_searchList = [[_x1, _y1, 0]],
		_tries      = _triesMax;
		
	while(_tries-- > 0){
		var	_search = _searchList[0],
			_sx     = _search[0],
			_sy     = _search[1],
			_sp     = _search[2];
			
		if(_sp >= infinity) break; // No more searchable tiles
		_search[2] = infinity;
		
		 // Sort Through Neighboring Tiles:
		var _costSoFar = _gridCost[# _sx, _sy];
		for(var i = 0; i < 2*pi; i += pi/2){
			var	_nx = _sx + cos(i),
				_ny = _sy - sin(i),
				_nc = _costSoFar + 1;
				
			if(
				_nx >= 0     &&
				_ny >= 0     &&
				_nx < _gridw &&
				_ny < _gridh &&
				_grid[# _nx, _ny] == -1
			){
				_gridCost[# _nx, _ny] = _nc;
				_grid[# _nx, _ny] = point_direction(_nx, _ny, _sx, _sy);
				
				 // Add to Search List:
				array_push(_searchList, [
					_nx,
					_ny,
					point_distance(_x2, _y2, _nx, _ny) + (abs(_x2 - _nx) + abs(_y2 - _ny)) + _nc
				]);
			}
			
			 // Path Complete:
			if(_nx == _x2 && _ny == _y2){
				_tries = 0;
				break;
			}
		}
		
		 // Next:
		array_sort_sub(_searchList, 2, true);
	}
	
	 // Pack Path into Array:
	var	_x     = _xstart,
		_y     = _ystart,
		_path  = [[_x + (_tileSize / 2), _y + (_tileSize / 2)]],
		_tries = _triesMax;
		
	while(_tries-- > 0){
		var _dir = _grid[# ((_x - _gridx) / _tileSize), ((_y - _gridy) / _tileSize)];
		if(_dir >= 0){
			_x += lengthdir_x(_tileSize, _dir);
			_y += lengthdir_y(_tileSize, _dir);
			array_push(_path, [_x + (_tileSize / 2), _y + (_tileSize / 2)]);
		}
		else{
			_path = []; // Couldn't find path
			break;
		}
		
		 // Done:
		if(_x == _xtarget && _y == _ytarget){
			break;
		}
	}
	if(_tries <= 0) _path = []; // Couldn't find path
	
	ds_grid_destroy(_grid);
	ds_grid_destroy(_gridCost);
	
	return _path;
	
#define path_shrink(_path, _wall, _skipMax)
	var	_pathNew = [],
		_link    = 0;
		
	if(!is_array(_wall)){
		_wall = [_wall];
	}
	
	for(var i = 0; i < array_length(_path); i++){
		 // Save Important Points on Path:
		var _save = (
			i <= 0                       ||
			i >= array_length(_path) - 1 ||
			i - _link >= _skipMax
		);
		
		 // Save Points Going Around Walls:
		if(!_save){
			var	_x1 = _path[i + 1, 0],
				_y1 = _path[i + 1, 1],
				_x2 = _path[_link, 0],
				_y2 = _path[_link, 1];
				
			for(var j = 0; j < array_length(_wall); j++){
				if(collision_line(_x1, _y1, _x2, _y2, _wall[j], false, false)){
					_save = true;
					break;
				}
			}
		}
		
		 // Store:
		if(_save){
			array_push(_pathNew, _path[i]);
			_link = i;
		}
	}
	
	return _pathNew;
	
#define path_reaches(_path, _xtarget, _ytarget, _wall)
	if(!is_array(_wall)) _wall = [_wall];
	
	var m = array_length(_path);
	if(m > 0){
		var	_x = _path[m - 1, 0],
			_y = _path[m - 1, 1];
			
		for(var i = 0; i < array_length(_wall); i++){
			if(collision_line(_x, _y, _xtarget, _ytarget, _wall[i], false, false)){
				return false;
			}
		}
		
		return true;
	}
	
	return false;
	
#define path_direction(_path, _x, _y, _wall)
	if(!is_array(_wall)) _wall = [_wall];
	
	 // Find Nearest Unobstructed Point on Path:
	var	_disMax  = infinity,
		_nearest = -1;
		
	for(var i = 0; i < array_length(_path); i++){
		var	_px = _path[i, 0],
			_py = _path[i, 1],
			_dis = point_distance(_x, _y, _px, _py);
			
		if(_dis < _disMax){
			var _walled = false;
			for(var j = 0; j < array_length(_wall); j++){
				if(collision_line(_x, _y, _px, _py, _wall[j], false, false)){
					_walled = true;
					break;
				}
			}
			if(!_walled){
				_disMax = _dis;
				_nearest = i;
			}
		}
	}
	
	 // Find Direction to Next Point on Path:
	if(_nearest >= 0){
		var	_follow = min(_nearest + 1, array_length(_path) - 1),
			_nx = _path[_follow, 0],
			_ny = _path[_follow, 1];
			
		 // Go to Nearest Point if Path to Next Point Obstructed:
		for(var j = 0; j < array_length(_wall); j++){
			if(collision_line(x, y, _nx, _ny, _wall[j], false, false)){
				_nx = _path[_nearest, 0];
				_ny = _path[_nearest, 1];
				break;
			}
		}
		
		return point_direction(x, y, _nx, _ny);
	}
	
	return null;
	
//#define path_draw(_path)
//	var	_x = x,
//		_y = y;
//		
//	with(_path){
//		draw_line(self[0], self[1], _x, _y);
//		_x = self[0];
//		_y = self[1];
//	}
	
#define race_get_sprite(_race, _sprite)
	/*
		Returns the matching sprite for a given race
		
		Ex:
			race_get_sprite("crystal", sprMutant1Walk) == sprMutant2Walk
	*/
	
	 // Custom:
	var _scrt = "race_sprite";
	if(is_string(_race) && mod_script_exists("race", _race, _scrt)){
		var _new = mod_script_call("race", _race, _scrt, _sprite);
		if(is_real(_new) && sprite_exists(_new)){
			_sprite = _new;
		}
	}
	
	 // Normal:
	else{
		var	_id   = race_get_id(_race),
			_name = race_get_name(_race);
			
		if(_id >= 17){
			_id = 1;
		}
		
		switch(_sprite){
			case sprMutant1Idle:
			case sprMutant1Walk:
			case sprMutant1Hurt:
			case sprMutant1Dead:
			case sprMutant1GoSit:
			case sprMutant1Sit:
				
				var _new = asset_get_index(string_replace(
					sprite_get_name(_sprite),
					"1",
					_id
				));
				
				if(sprite_exists(_new)){
					_sprite = _new;
				}
				
				break;
				
			 // Menu:
			case sprFishMenu:
			case sprFishMenuSelected:
			case sprFishMenuSelect:
			case sprFishMenuDeselect:
				
				var _new = asset_get_index(string_replace(
					sprite_get_name(_sprite),
					"Fish",
					string_upper(string_char_at(_name, 1)) + string_lower(string_delete(_name, 1, 1))
				));
				
				if(sprite_exists(_new)){
					_sprite = _new;
				}
				
				break;
				
			 // Shadow:
			case shd24:
				
				if(_id == char_bigdog){
					_sprite = shd96;
				}
				
				break;
		}
	}
	
	return skin_get_sprite(variable_instance_get(self, "bskin", 0), _sprite);
	
#define race_get_title(_race)
	/*
		The same as 'race_get_alias(_race)', but supports modded races
	*/
	
	var _id = race_get_id(_race);
		
	 // Custom:
	if(is_string(_race) && _id == 17){
		var	_scrt  = "race_name",
			_title = mod_script_call("race", _race, _scrt);
			
		if(is_string(_title)){
			return _title;
		}
		
		return _scrt;
	}
	
	 // Normal:
	return race_get_alias(_id);
	
#define race_get_skin_list(_race)
	/*
		Returns a list of a given race's skins
	*/
	
	var _num = 1;
	
	switch(race_get_id(_race)){
		case char_fish:
		case char_crystal:
		case char_eyes:
		case char_melting:
		case char_plant:
		case char_steroids:
		case char_chicken:
		case char_rebel:
		case char_horror:
		case char_rogue:
		case char_skeleton:
			_num = 2;
			break;
			
		case char_venuz:
		case char_robot:
			_num = 3;
			break;
			
		default: // CUSTOM
			if(is_string(_race)){
				var _skins = mod_script_call("race", _race, "race_skins");
				if(is_real(_skins)){
					_num = _skins;
				}
			}
	}
	
	 // Add Normal Skins to List:
	var _list = array_create(_num, 0);
	for(var i = 0; i < array_length(_list); i++){
		_list[i] = i;
	}
	
	 // Add Skin Mods to List:
	with(mod_get_names("skin")){
		if(race_get_id(mod_script_call_nc("skin", self, "skin_race")) == race_get_id(_race)){
			array_push(_list, self);
		}
	}
	
	return _list;
	
#define skin_get_sprite(_skin, _sprite)
	/*
		Returns a given skin's variant of a given sprite
		
		Ex:
			skin_get_sprite(1,      sprShield) == sprShieldB
			skin_get_sprite("tree", sprShield) == (Shield sprite for 'tree.skin.gml')
	*/
	
	switch(_sprite){
		 /// FISH:
		case sprMutant1Idle            : return sprite_skin(_skin, _sprite, sprMutant1BIdle);
		case sprMutant1Walk            : return sprite_skin(_skin, _sprite, sprMutant1BWalk);
		case sprMutant1Hurt            : return sprite_skin(_skin, _sprite, sprMutant1BHurt);
		case sprMutant1Dead            : return sprite_skin(_skin, _sprite, sprMutant1BDead);
		case sprMutant1GoSit           : return sprite_skin(_skin, _sprite, sprMutant1BGoSit);
		case sprMutant1Sit             : return sprite_skin(_skin, _sprite, sprMutant1BSit);
		
		 /// CRYSTAL:
		case sprMutant2Idle            : return sprite_skin(_skin, _sprite, sprMutant2BIdle);
		case sprMutant2Walk            : return sprite_skin(_skin, _sprite, sprMutant2BWalk);
		case sprMutant2Hurt            : return sprite_skin(_skin, _sprite, sprMutant2BHurt);
		case sprMutant2Dead            : return sprite_skin(_skin, _sprite, sprMutant2BDead);
		case sprMutant2GoSit           : return sprite_skin(_skin, _sprite, sprMutant2BGoSit);
		case sprMutant2Sit             : return sprite_skin(_skin, _sprite, sprMutant2BSit);
		case sprShield                 : return sprite_skin(_skin, _sprite, sprShieldB);
		case sprCrystTrail             : return sprite_skin(_skin, _sprite, sprCrystTrailB);
		case sprCrystalShieldIdleFront : return sprite_skin(_skin, _sprite, sprCrystalShieldBIdleFront);
		case sprCrystalShieldWalkFront : return sprite_skin(_skin, _sprite, sprCrystalShieldBWalkFront);
		case sprCrystalShieldIdleBack  : return sprite_skin(_skin, _sprite, sprCrystalShieldBIdleBack);
		case sprCrystalShieldWalkBack  : return sprite_skin(_skin, _sprite, sprCrystalShieldBWalkBack);
		
		 /// EYES:
		case sprMutant3Idle            : return sprite_skin(_skin, _sprite, sprMutant3BIdle);
		case sprMutant3Walk            : return sprite_skin(_skin, _sprite, sprMutant3BWalk);
		case sprMutant3Hurt            : return sprite_skin(_skin, _sprite, sprMutant3BHurt);
		case sprMutant3Dead            : return sprite_skin(_skin, _sprite, sprMutant3BDead);
		case sprMutant3GoSit           : return sprite_skin(_skin, _sprite, sprMutant3BGoSit);
		case sprMutant3Sit             : return sprite_skin(_skin, _sprite, sprMutant3BSit);
		
		 /// MELTING:
		case sprMutant4Idle            : return sprite_skin(_skin, _sprite, sprMutant4BIdle);
		case sprMutant4Walk            : return sprite_skin(_skin, _sprite, sprMutant4BWalk);
		case sprMutant4Hurt            : return sprite_skin(_skin, _sprite, sprMutant4BHurt);
		case sprMutant4Dead            : return sprite_skin(_skin, _sprite, sprMutant4BDead);
		case sprMutant4GoSit           : return sprite_skin(_skin, _sprite, sprMutant4BGoSit);
		case sprMutant4Sit             : return sprite_skin(_skin, _sprite, sprMutant4BSit);
		
		 /// PLANT:
		case sprMutant5Idle            : return sprite_skin(_skin, _sprite, sprMutant5BIdle);
		case sprMutant5Walk            : return sprite_skin(_skin, _sprite, sprMutant5BWalk);
		case sprMutant5Hurt            : return sprite_skin(_skin, _sprite, sprMutant5BHurt);
		case sprMutant5Dead            : return sprite_skin(_skin, _sprite, sprMutant5BDead);
		case sprMutant5GoSit           : return sprite_skin(_skin, _sprite, sprMutant5BGoSit);
		case sprMutant5Sit             : return sprite_skin(_skin, _sprite, sprMutant5BSit);
		case sprTangle                 : return sprite_skin(_skin, _sprite, sprTangleB);
		case sprTangleSeed             : return sprite_skin(_skin, _sprite, sprTangleSeedB);
		
		 /// YV:
		case sprMutant6Idle            : return sprite_skin(_skin, _sprite, sprMutant6BIdle,  sprMutant16Idle);
		case sprMutant6Walk            : return sprite_skin(_skin, _sprite, sprMutant6BWalk,  sprMutant16Walk);
		case sprMutant6Hurt            : return sprite_skin(_skin, _sprite, sprMutant6BHurt,  sprMutant16Hurt);
		case sprMutant6Dead            : return sprite_skin(_skin, _sprite, sprMutant6BDead,  sprMutant16Dead);
		case sprMutant6GoSit           : return sprite_skin(_skin, _sprite, sprMutant6BGoSit, sprMutant16GoSit);
		case sprMutant6Sit             : return sprite_skin(_skin, _sprite, sprMutant6BSit,   sprMutant16Sit);
		
		 /// STEROIDS:
		case sprMutant7Idle            : return sprite_skin(_skin, _sprite, sprMutant7BIdle);
		case sprMutant7Walk            : return sprite_skin(_skin, _sprite, sprMutant7BWalk);
		case sprMutant7Hurt            : return sprite_skin(_skin, _sprite, sprMutant7BHurt);
		case sprMutant7Dead            : return sprite_skin(_skin, _sprite, sprMutant7BDead);
		case sprMutant7GoSit           : return sprite_skin(_skin, _sprite, sprMutant7BGoSit);
		case sprMutant7Sit             : return sprite_skin(_skin, _sprite, sprMutant7BSit);
		
		 /// ROBOT:
		case sprMutant8Idle            : return sprite_skin(_skin, _sprite, sprMutant8BIdle,  sprMutant8CIdle);
		case sprMutant8Walk            : return sprite_skin(_skin, _sprite, sprMutant8BWalk,  sprMutant8CWalk);
		case sprMutant8Hurt            : return sprite_skin(_skin, _sprite, sprMutant8BHurt,  sprMutant8CHurt);
		case sprMutant8Dead            : return sprite_skin(_skin, _sprite, sprMutant8BDead,  sprMutant8CDead);
		case sprMutant8GoSit           : return sprite_skin(_skin, _sprite, sprMutant8BGoSit, sprMutant8CGoSit);
		case sprMutant8Sit             : return sprite_skin(_skin, _sprite, sprMutant8BSit,   sprMutant8CSit);
		
		 /// CHICKEN:
		case sprMutant9Idle            : return sprite_skin(_skin, _sprite, sprMutant9BIdle);
		case sprMutant9Walk            : return sprite_skin(_skin, _sprite, sprMutant9BWalk);
		case sprMutant9Hurt            : return sprite_skin(_skin, _sprite, sprMutant9BHurt);
		case sprMutant9GoSit           : return sprite_skin(_skin, _sprite, sprMutant9BGoSit);
		case sprMutant9Sit             : return sprite_skin(_skin, _sprite, sprMutant9BSit);
		case sprMutant9HeadIdle        : return sprite_skin(_skin, _sprite, sprMutant9BHeadIdle);
		case sprMutant9HeadHurt        : return sprite_skin(_skin, _sprite, sprMutant9BHeadHurt);
		
		 /// REBEL:
		case sprMutant10Idle           : return sprite_skin(_skin, _sprite, sprMutant10BIdle, sprMutant10CIdle);
		case sprMutant10Walk           : return sprite_skin(_skin, _sprite, sprMutant10BWalk, sprMutant10CWalk);
		case sprMutant10Hurt           : return sprite_skin(_skin, _sprite, sprMutant10BHurt, sprMutant10CHurt);
		case sprMutant10Dead           : return sprite_skin(_skin, _sprite, sprMutant10BDead, sprMutant10CDead);
		case sprMutant10GoSit          : return sprite_skin(_skin, _sprite, sprMutant10BGoSit);
		case sprMutant10Sit            : return sprite_skin(_skin, _sprite, sprMutant10BSit);
		
		 /// HORROR:
		case sprMutant11Idle           : return sprite_skin(_skin, _sprite, sprMutant11BIdle);
		case sprMutant11Walk           : return sprite_skin(_skin, _sprite, sprMutant11BWalk);
		case sprMutant11Hurt           : return sprite_skin(_skin, _sprite, sprMutant11BHurt);
		case sprMutant11Dead           : return sprite_skin(_skin, _sprite, sprMutant11BDead);
		case sprMutant11GoSit          : return sprite_skin(_skin, _sprite, sprMutant11BGoSit);
		case sprMutant11Sit            : return sprite_skin(_skin, _sprite, sprMutant11BSit);
		case sprHorrorBullet           : return sprite_skin(_skin, _sprite, sprHorrorBBullet);
		case sprHorrorBulletHit        : return sprite_skin(_skin, _sprite, sprHorrorBulletHitB);
		case sprHorrorHit              : return sprite_skin(_skin, _sprite, sprHorrorHitB);
		
		 /// ROGUE:
		case sprMutant12Idle           : return sprite_skin(_skin, _sprite, sprMutant12BIdle);
		case sprMutant12Walk           : return sprite_skin(_skin, _sprite, sprMutant12BWalk);
		case sprMutant12Hurt           : return sprite_skin(_skin, _sprite, sprMutant12BHurt);
		case sprMutant12Dead           : return sprite_skin(_skin, _sprite, sprMutant12BDead);
		case sprMutant12GoSit          : return sprite_skin(_skin, _sprite, sprMutant12BGoSit);
		case sprMutant12Sit            : return sprite_skin(_skin, _sprite, sprMutant12BSit);
		
		 /// SKELETON:
		case sprMutant14Idle           : return sprite_skin(_skin, _sprite, sprMutant14BIdle);
		case sprMutant14Walk           : return sprite_skin(_skin, _sprite, sprMutant14BWalk);
		case sprMutant14Hurt           : return sprite_skin(_skin, _sprite, sprMutant14BHurt);
		case sprMutant14Dead           : return sprite_skin(_skin, _sprite, sprMutant14BDead);
		case sprMutant14GoSit          : return sprite_skin(_skin, _sprite, sprMutant14BGoSit);
		case sprMutant14Sit            : return sprite_skin(_skin, _sprite, sprMutant14BSit);
	}
	
	return sprite_skin(_skin, _sprite);
	
#define skin_get_name(_race, _skin)
	/*
		Returns the name of a race's skin as it appears on the loadout menu
	*/
	
	 // Modded Skin:
	if(is_string(_skin)){
		var _name = mod_script_call("skin", _skin, "skin_name", true);
		if(is_string(_name)){
			return _name;
		}
	}
	
	 // Modded Race:
	else if(is_string(_race)){
		var _name = mod_script_call("race", _race, "race_skin_name", _skin);
		if(is_string(_name)){
			return _name;
		}
	}
	
	 // Default:
	var _skinList = race_get_skin_list(_race);
	return chr(ord("A") + max(0, array_find_index(_skinList, _skin))) + " SKIN";
	
#define pet_create(_x, _y, _name, _modType, _modName)
	/*
		Creates the given NT:TE pet, and sets up its stats, sprites, and other variables
		
		Ex:
			pet_create(x, y, "Parrot", "mod", "petlib")
	*/
	
	with(obj_create(_x, _y, "Pet")){
		pet      = _name;
		mod_name = _modName;
		mod_type = _modType;
		
		 // Stats:
		var _stat = `pet:${pet}.${mod_name}.${mod_type}`;
		if(!is_object(stat_get(_stat))){
			stat_set(_stat, {
				"found" : 0,
				"owned" : 0
			});
		}
		stat = stat_get(_stat);
		
		 // Custom Create Event:
		mod_script_call(mod_type, mod_name, pet + "_create");
		
		 // Auto-Set:
		if(instance_exists(self)){
			 // Fill Health:
			if(my_health == 0){
				my_health = maxhealth;
			}
			
			 // Cause of Death Name:
			if(is_array(hitid) && array_length(hitid) && hitid[1] == ""){
				hitid[1] = pet_get_name(pet, mod_type, mod_name, 0);
			}
			
			 // Sprites:
			pet_set_skin(bskin);
		}
		
		return self;
	}
	
	return noone;
	
#define pet_spawn(_x, _y, _name)
	return pet_create(_x, _y, _name, "mod", "petlib");
	
#define pet_get_name(_name, _modType, _modName, _skin)
	/*
		Returns the display name of the given NT:TE pet
		Defaults to the A-skin, or ultimately the pet's raw name if no name was found
		
		Ex:
			pet_get_name("CoolGuy", "mod", "petlib", 1) == "CoolGuy?"
	*/
	
	var _title = undefined;
	
	 // Custom:
	if(is_array(_skin)){
		var _ref = array_clone(_skin);
		if(array_length(_ref) >= 3){
			_ref[2] += "_name";
		}
		_title = script_ref_call(_ref);
	}
	
	 // Normal:
	else _title = mod_script_call(_modType, _modName, _name + "_name", _skin);
	
	 // Return:
	if(is_string(_title)){
		return _title;
	}
	return (
		(_skin == 0)
		? _name
		: pet_get_name(_name, _modType, _modName, 0)
	);
	
#define pet_get_ttip(_name, _modType, _modName, _skin)
	/*
		Returns a random loading screen tip for the given NT:TE pet
		Defaults to the A-skin, or ultimately a blank string if no tip was found
	*/
	
	var _tip = undefined;
	
	 // Custom:
	if(is_array(_skin)){
		var _ref = array_clone(_skin);
		if(array_length(_ref) >= 3){
			_ref[2] += "_ttip";
		}
		_tip = script_ref_call(_ref);
	}
	
	 // Normal:
	else _tip = mod_script_call(_modType, _modName, _name + "_ttip", _skin);
	
	 // Auto-Choose:
	if(is_array(_tip) && array_length(_tip)){
		_tip = _tip[irandom(array_length(_tip) - 1)];
	}
	
	 // Return:
	if(is_string(_tip)){
		return _tip;
	}
	return (
		(_skin == 0)
		? ""
		: pet_get_ttip(_name, _modType, _modName, 0)
	);
	
#define pet_get_sprite(_name, _modType, _modName, _skin, _sprName)
	/*
		Returns the sprite index associated with the given name and NT:TE pet
		Defaults to the A-skin, or ultimately '0' if no sprite was found
		
		Ex:
			pet_get_sprite("Parrot", "mod", "petlib", 1, "idle") == spr.PetParrotBIdle
	*/
	
	var _spr = undefined;
	
	 // Custom:
	if(is_array(_skin)){
		var _ref = array_clone(_skin);
		if(array_length(_ref) >= 3){
			_ref[2] += "_sprite";
		}
		_spr = script_ref_call(_ref, _sprName);
	}
	
	 // Normal:
	else{
		var _modScrt = _name + "_sprite";
		if(mod_script_exists(_modType, _modName, _modScrt)){
			_spr = mod_script_call(_modType, _modName, _modScrt, _skin, _sprName);
		}
		
		 // Legacy Support:
		else if(_sprName == "icon"){
			_spr = mod_script_call(_modType, _modName, _name + "_icon");
			if(is_object(_spr) && "spr" in _spr){
				_spr = _spr.spr;
			}
		}
	}
	
	 // Return:
	if(_spr != 0 && is_real(_spr)){
		return _spr;
	}
	return (
		(_skin == 0)
		? 0
		: pet_get_sprite(_name, _modType, _modName, 0, _sprName)
	);
	
#define pet_get_sound(_name, _modType, _modName, _skin, _sndName)
	/*
		Returns the sound index associated with the given name and NT:TE pet, or 0 by default
		Defaults to the A-skin, or ultimately '0' if no sound was found
		
		Ex:
			pet_get_sound("Scorpion", "mod", "petlib", 0, "hurt") == sndScorpionMelee
	*/
	
	var _snd = undefined;
	
	 // Custom:
	if(is_array(_skin)){
		var _ref = array_clone(_skin);
		if(array_length(_ref) >= 3){
			_ref[2] += "_sound";
		}
		_snd = script_ref_call(_ref, _sndName);
	}
	
	 // Normal:
	else _snd = mod_script_call(_modType, _modName, _name + "_sound", _skin, _sndName);
	
	 // Return:
	if(_snd != 0 && is_real(_snd)){
		return _snd;
	}
	return (
		(_skin == 0)
		? 0
		: pet_get_sound(_name, _modType, _modName, 0, _sndName)
	);
	
#define pet_set_skin(_skin)
	/*
		Called from an NT:TE pet to update their sprites and sounds to the given skin
		The skin can be a script reference for setting a custom skin
	*/
	
	bskin = _skin;
	
	 // Update Variables:
	var _sprCurrent = sprite_index;
	with(variable_instance_get_names(self)){
		 // Sprites:
		if(string_pos("spr_", self) == 1){
			var _name = string_delete(self, 1, 4);
			with(other){
				var _spr = pet_get_sprite(pet, mod_type, mod_name, bskin, _name);
				if(_spr != 0){
					if(sprite_exists(_sprCurrent) && _sprCurrent == variable_instance_get(self, other)){
						_sprCurrent = -1;
						sprite_index = _spr;
					}
					variable_instance_set(self, other, _spr);
				}
			}
		}
		
		 // Sounds:
		else if(string_pos("snd_", self) == 1){
			var _name = string_delete(self, 1, 4);
			with(other){
				var _snd = pet_get_sound(pet, mod_type, mod_name, bskin, _name)
				if(_snd != 0){
					variable_instance_set(self, other, _snd);
				}
			}
		}
	}
	
	 // Cause of Death Sprite:
	if(is_array(hitid) && array_length(hitid)){
		var _spr = pet_get_sprite(pet, mod_type, mod_name, bskin, "stat");
		if(_spr == 0){
			_spr = spr_idle;
		}
		hitid[0] = _spr;
	}
	
	 // Prompt:
	var	_icon = spr_icon,
		_text = pet_get_name(pet, mod_type, mod_name, bskin);
		
	with(prompt){
		text = `@2(${_icon})${_text}`;
	}
	
#define pet_get_icon(_modType, _modName, _name)
	/*
		Returns a LWO containing 'draw_sprite_ext()' arguments for the given NT:TE pet's icon
		
		!!! Legacy script, use 'pet_get_sprite()' instead
	*/
	
	return {
		"spr" : pet_get_sprite(_name, _modType, _modName, 0, "icon"),
		"img" : 0.4 * current_frame,
		"x"   : 0,
		"y"   : 0,
		"xsc" : 1,
		"ysc" : 1,
		"ang" : 0,
		"col" : c_white,
		"alp" : 1
	};
	
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)
	/*
		Creates a wall-top object at the given position and automatically moves them away from floors
		Set spawnDir/spawnDis to -1 for spawnDir/spawnDis to be automatic
		Also accepts an instance as the object argument
		
		Ex:
			top_create(mouse_x, mouse_y, Bandit, -1, -1)
	*/
	
	var _inst = _obj;
	if(!is_real(_obj) || _obj < 100000){
		_inst = obj_create(_x, _y, _obj);
	}
	with(_inst){
		x = _x;
		y = _y;
		xprevious = x;
		yprevious = y;
		
		 // Don't Clear Walls:
		if(instance_is(self, hitme) || instance_is(self, chestprop)){
			with(instances_matching(instances_matching(instances_matching_gt([PortalClear, PortalShock], "id", id), "xstart", xstart), "ystart", ystart)){
				instance_destroy();
			}
		}
	}
	
	 // Top-ify:
	if(!array_length(instances_matching(instances_matching(CustomObject, "name", "TopObject"), "target", _inst))){
		with(obj_create(_x, _y, "TopObject")){
			target = _inst;
			
			if(instance_exists(target)){
				target.top_object = self;
				spawn_dis = random_range(16, 48);
				
				 // Object-General Setup:
				if(instance_is(target, hitme)){
					unstick = true;
					
					 // Enemy:
					if(instance_is(target, enemy)){
						type = enemy;
						idle_time = 90 + random(90);
						
						 // Fix Facing:
						if(target.direction == 0 && "walk" not in target && "right" in target){
							with(target){
								direction = random(360);
								if(direction < 90 || direction > 270){
									right = 1;
								}
								else if(direction > 90 && direction < 270){
									right = -1;
								}
							}
						}
					}
					
					 // Prop:
					else if(instance_is(target, prop)){
						spawn_dis = random_range(8, 16);
						
						 // Death on Impact:
						if(target.team == 0 && target.size <= 1 && target.maxhealth < 50){
							target_save.my_health = 0;
						}
					}
				}
				/*else if(instance_is(target, Effect) || instance_is(target, Corpse)){
					override_depth = false;
					depth = -6.01;
					if(instance_is(target, Corpse)) depth -= 0.001;
				}*/
				else if(instance_is(target, chestprop) || instance_is(target, Pickup)){
					wobble = 8;
					spawn_dis = 8;
					if(instance_is(target, Pickup)){
						//override_depth = false;
						//depth = -6.0111;
						jump = 0;
					}
					if(instance_is(target, chestprop) || instance_is(target, WepPickup)){
						unstick = true;
					}
				}
				else if(instance_is(target, projectile)){
					jump = 0;
					type = projectile;
				}
				else if(instance_is(target, Explosion) || instance_is(target, MeatExplosion) || instance_is(target, PlasmaImpact)){
					jump = 0;
					grav = 0;
					type = projectile;
					override_mask = false;
					//override_depth = false;
					//depth = -8;
				}
				else if(instance_is(target, ReviveArea) || instance_is(target, NecroReviveArea) || instance_is(target, RevivePopoFreak)){
					jump = 0;
					grav = 0;
					override_mask = false;
					//override_depth = false;
					//depth = -6.01;
				}
				else if(instance_is(target, IDPDSpawn) || instance_is(target, VanSpawn)){
					jump = 0;
					grav = 0;
					//override_depth = false;
					//depth = -6.01;
				}
				
				 // Object-Specific Setup:
				switch((string_pos("Custom", object_get_name(target.object_index)) == 1 && "name" in target) ? target.name : target.object_index){
					// /// ENEMIES ///
					//case BoneFish:
					//case "Puffer":
					//case "HammerShark":
					//	idle_walk        = [0, 5];
					//	idle_walk_chance = 1/2;
					//	break;
					//	
					//case Exploder:
					//	jump_time = 1;
					//	break;
					//	
					//case ExploFreak:
					//	jump *= 1.2;
					//	idle_walk        = [0, 5];
					//	idle_walk_chance = 1;
					//	
					//	 // Important:
					//	target_save.my_health = 0;
					//	break;
					//	
					//case Freak:
					//	idle_walk        = [0, 5];
					//	idle_walk_chance = 1;
					//	break;
						
					case JungleFly:
						jump = 0;
						grav = random_range(0.1, 0.3);
						idle_walk        = [8, 12];
						idle_walk_chance = 1/2;
						break;
						
					case MeleeBandit:
						idle_walk        = [10, 30];
						idle_walk_chance = 1/2;
						break;
						
					//case Necromancer:
					//	jump *= 2/3;
					//	idle_walk_chance = 1/16;
					//	break;
					//	
					//case "Seal":
					//	idle_walk_chance = 1/12;
					//	break;
						
					case "Spiderling":
						jump *= 4/5;
						idle_walk_chance = 1/4;
						break;
						
					case "TopRaven":
					case "BoneRaven":
						type    = RavenFly;
						jump    = 2;
						grav    = 0;
						canmove = true;
						spr_shadow_y--;
						break;
						
					 /// PROPS ///
					case Anchor:
					case OasisBarrel:
					case WaterMine:
						mask_index   = target.spr_shadow;
						image_xscale = 0.5;
						image_yscale = 0.5;
						spr_shadow   = mskNone;
						break;
						
					case Barrel:
					case GoldBarrel:
					case ToxicBarrel:
						jump        *= 1.5;
						spr_shadow   = shd16;
						spr_shadow_y = 4;
						wobble       = 8;
						break;
						
					case BigFlower:
					case IceFlower:
						//override_depth = false;
						//depth = -6.01;
						spr_shadow   = target.spr_idle;
						spr_shadow_y = 1;
						break;
						
					case Bush:
					case JungleAssassinHide:
						spr_shadow_y = -1;
						break;
						
					case Cactus:
						with(target){
							var _t = choose("", "3");
							spr_idle = asset_get_index("sprCactusB" + _t);
							spr_hurt = asset_get_index("sprCactusB" + _t + "Hurt");
							spr_dead = asset_get_index("sprCactusB" + _t + "Dead");
						}
						//case NightCactus:
						spr_shadow   = sprMine;
						spr_shadow_y = 9;
						break;
						
					case Cocoon:
					case "NewCocoon":
						spr_shadow   = shd16;
						spr_shadow_y = 3;
						break;
						
					case FireBaller:
					case SuperFireBaller:
						z   += random(8);
						jump = random(1);
						grav = random_range(0.1, 0.2);
						break;
						
					case FrogEgg:
						grav = 1.5;
						break;
						
					case Generator:
						spr_shadow = ((target.image_xscale < 0) ? spr.shd.BigGeneratorR : spr.shd.BigGenerator);
						target_save.my_health = 0;
						break;
						
					case Hydrant:
						 // Icicle:
						if(chance(1, 2) || target.spr_idle == sprIcicle){
							with(target){
								spr_idle     = sprIcicle;
								spr_hurt     = sprIcicleHurt;
								spr_dead     = sprIcicleDead;
								snd_hurt     = sndHitRock;
								snd_dead     = sndIcicleBreak;
								spr_shadow   = shd16;
								spr_shadow_y = 3;
							}
						}
						break;
						
					case MeleeFake:
						spr_shadow   = sprMine;
						spr_shadow_y = 7;
						break;
						
					case MoneyPile:
						spawn_dis    = 8;
						spr_shadow_y = -1;
						break;
						
					case Pillar:
						spr_shadow_y = -3;
						break;
						
					case Pipe:
						spr_shadow   = sprMine;
						spr_shadow_y = 7;
						break;
						
					case Server:
						spr_shadow   = sprHydrant;
						spr_shadow_y = 5;
						break;
						
					case SmallGenerator:
						spr_shadow   = target.spr_idle;
						spr_shadow_y = 1;
						target.image_xscale = 1;
						break;
						
					case SnowMan:
						spr_shadow   = sprNewsStand;
						spr_shadow_y = 5;
						break;
						
					case Terminal:
						spr_shadow_y = 1;
						break;
						
					case Tires:
						spr_shadow_y = -1;
						break;
						
					case "WepPickupGrounded":
						jump    = 3;
						wobble  = 8;
						unstick = true;
						break;
				}
				
				 // Shadow:
				if("spr_shadow" in target){
					if(spr_shadow   == -1) spr_shadow   = target.spr_shadow;
					if(spr_shadow_x ==  0) spr_shadow_x = target.spr_shadow_x;
					if(spr_shadow_y ==  0) spr_shadow_y = target.spr_shadow_y;
				}
				
				 // Hitbox:
				if(mask_index < 0){
					image_xscale = 0.5;
					image_yscale = 0.5;
					
					 // Default:
					if(spr_shadow == -1){
						mask_index = target.sprite_index;
					}
					
					 // Shadow-Based:
					else{
						mask_index = spr_shadow;
						mask_y = spr_shadow_y + (((bbox_top - y) * (1 - image_yscale)));
					}
				}
				
				 // Push Away From Floors:
				if(_spawnDir >= 0){
					spawn_dir = ((_spawnDir % 360) + 360) % 360;
				}
				else with(instance_nearest_bbox(x, y, Floor)){
					other.spawn_dir = point_direction(bbox_center_x, bbox_center_y, other.x, other.y);
				}
				if(_spawnDis >= 0){
					spawn_dis = _spawnDis;
				}
				if(spawn_dis > 0){
					while(true){
						var _dis = max(
							spawn_dis      - distance_to_object(Floor),
							spawn_dis + 16 - distance_to_object(PortalClear),
							16             - distance_to_object(Bones),
							8              - distance_to_object(TopPot),
							8              - distance_to_object(CustomObject)
						);
						if(_dis > 0){
							_dis = max(1, _dis);
							x += lengthdir_x(_dis, spawn_dir);
							y += lengthdir_y(_dis, spawn_dir);
						}
						else break;
					}
				}
				x = round(x);
				y = round(y);
				
				/// Post-Setup:
					 // Enemy:
					if(instance_is(target, enemy)){
						 // Setup Time Until Jump Mode:
						if(jump_time == 0){
							with(instance_nearest(x - 16, y - 16, Floor)){ //instance_nearest_bbox(x, y, Floor)){
								other.jump_time = 90 + (distance_to_object(Player) * (2 + GameCont.loops));
							}
						}
						
						 // No Movin:
						if("walk" not in target && type != RavenFly){
							canmove = false;
						}
					}
					
					 // Object-Specific Post-Setup:
					switch(target.object_index){
						//case BoneFish:
						//case Freak:
						//case "Puffer":
						//case "HammerShark": // Swimming bro
						//	if(area_get_underwater(GameCont.area)){
						//		z += random_range(8, distance_to_object(Floor) / 2) * ((target.object_index == "Puffer") ? 0.5 : 1);
						//	}
						//	break;
						//	
						//case FrogEgg: // Hatch
						//	target.alarm0 = irandom(150) + (distance_to_object(Player) * (1 + GameCont.loops));
						//	target_save.alarm0 = random_range(10, 30);
						//	break;
							
						case JungleFly: // Bro hes actually flying real
							z += random_range(4, 16 + (distance_to_object(Floor) / 2));
							break;
					}
					
					 // Type-Specific:
					switch(type){
						case enemy:
							
							 // Disable AI:
							with(target){
								for(var i = 0; i <= 10; i++){
									lq_set(other.target_save, `alarm${i}`, alarm_get(i));
									alarm_set(i, -1);
								}
							}
							
							break;
					}
					
				 // C'mere:
				with(target){
					x = other.x;
					y = other.y - other.z;
					xprevious = x;
					yprevious = y;
				}
				
				 // Underwater Time:
				if(area_get_underwater(GameCont.area)){
					jump /= 6;
					grav /= 4;
				}
				
				 // Insta-Land:
				var _n = instance_nearest(x - 16, y - 16, Floor); //instance_nearest_bbox(x, y, Floor);
				if(
					instance_exists(_n)
					&& !instance_exists(NothingSpiral)
					&& !collision_line(x, y + 8, (_n.bbox_left + _n.bbox_right + 1) / 2, (_n.bbox_top + _n.bbox_bottom + 1) / 2, Wall,     false, false)
					&& !collision_line(x, y + 8, (_n.bbox_left + _n.bbox_right + 1) / 2, (_n.bbox_top + _n.bbox_bottom + 1) / 2, TopSmall, false, false)
				){
					zspeed    = jump;
					zfriction = grav;
				}
				
				 // TopSmalls:
				else if(instance_is(target, prop)){
					with(target){
						var _xsc = image_xscale;
						image_xscale = sign(image_xscale * variable_instance_get(self, "right", 1));
						
						var	_west = bbox_left - 8,
							_east = bbox_right + 1 + 8,
							_nort = y - 8,
							_sout = bbox_bottom + 1 + 8,
							_shad = ((other.spr_shadow != -1) ? other.spr_shadow : spr_shadow),
							_chance = 4/5;
							
						if(sprite_get_bbox_right(_shad) - sprite_get_bbox_left(_shad) > 64){
							_chance = 1;
						}
						
						for(var _ox = _west; _ox < _east; _ox += 16){
							for(var _oy = _nort; _oy < _sout; _oy += 16){
								if(chance(_chance, 1)){
									var	_sx = pfloor(_ox, 16),
										_sy = pfloor(_oy, 16);
										
									if(!position_meeting(_sx, _sy, Floor) && !position_meeting(_sx, _sy, Wall) && !position_meeting(_sx, _sy, TopSmall)){
										instance_create(_sx, _sy, TopSmall);
									}
								}
							}
						}
						
						image_xscale = _xsc;
					}
				}
				
				
				with(target){
					 // Depth:
					//if(override_depth) depth = -6 - ((y - 8) / 10000);
					other.target_save.depth = depth;
					depth = object_get_depth(SubTopCont) + min(-1, depth);
					
					 // Search Zone:
					var _m = mask_index;
					mask_index = -1;
					other.search_x1 = min(x - 8, bbox_left);
					other.search_x2 = max(x + 8, bbox_right);
					other.search_y1 = min(y - 8, bbox_top);
					other.search_y2 = max(y + 8, bbox_bottom);
					mask_index = _m;
				}
			}
			
			with(self){
				event_perform(ev_step, ev_step_end);
			}
			
			return self;
		}
	}
	
	return noone;
	
#define floor_fill(_x, _y, _w, _h, _type)
	/*
		Creates a rectangular area of floors around the given position
		The type can be "" for default, "round" for no corners, or "ring" for no inner floors
		
		Ex:
			floor_fill(x, y, 3, 3, "")
				###
				###
				###
				
			floor_fill(x, y, 5, 4, "round")
				 ###
				#####
				#####
				 ###
				 
			floor_fill(x, y, 4, 4, "ring")
				####
				#  #
				#  #
				####
	*/
	
	var	_ow = 32,
		_oh = 32;
		
	_w *= _ow;
	_h *= _oh;
	
	 // Center & Align:
	_x -= (_w / 2);
	_y -= (_h / 2);
	var _gridPos = floor_align(_x, _y, _w, _h, _type);
	_x = _gridPos[0];
	_y = _gridPos[1];
	
	 // Floors:
	var	_ax   = global.floor_align_x,
		_ay   = global.floor_align_y,
		_aw   = global.floor_align_w,
		_ah   = global.floor_align_h,
		_inst = [];
		
	floor_set_align(_x, _y, _ow, _oh);
	
	for(var _oy = 0; _oy < _h; _oy += _oh){
		for(var _ox = 0; _ox < _w; _ox += _ow){
			var _make = true;
			
			 // Type-Specific:
			switch(_type){
				case "round": // No Corner Floors
					_make = ((_ox != 0 && _ox != _w - _ow) || (_oy != 0 && _oy != _h - _oh));
					break;
					
				case "ring": // No Inner Floors
					_make = (_ox == 0 || _oy == 0 || _ox == _w - _ow || _oy == _h - _oh);
					break;
			}
			
			if(_make){
				array_push(_inst, floor_set(_x + _ox, _y + _oy, true));
			}
		}
	}
	
	floor_set_align(_ax, _ay, _aw, _ah);
	
	return _inst;
	
#define door_create(_x, _y, _dir)
	/*
		Creates a double CatDoor for a normal Floor
		Returns an array containing both doors
		
		Ex:
			with(FloorNormal){
				door_create(bbox_center_x, bbox_center_y, 90);
			}
	*/
	
	var	_dx      = _x + lengthdir_x(16 - 2, _dir),
		_dy      = _y + lengthdir_y(16 - 2, _dir) + 1,
		_partner = noone,
		_inst    = [];
		
	for(var i = -1; i <= 1; i += 2){
		var _side = i;
		if(_dir < 90 || _dir > 270){
			_side *= -1; // Depth fix, create bottom door first
		}
		with(obj_create(_dx + lengthdir_x(16 * _side, _dir - 90), _dy + lengthdir_y(16 * _side, _dir - 90), "CatDoor")){
			image_angle  = _dir;
			image_yscale = -_side;
			
			 // Link Doors:
			partner = _partner;
			with(partner){
				partner = other;
			}
			_partner = self;
			
			 // Ensure LoS Wall Creation:
			with(self){
				event_perform(ev_step, ev_step_normal);
			}
			
			array_push(_inst, self);
		}
	}
	
	return _inst;
	
#define sleep_max(_milliseconds)
	/*
		Like 'sleep()', but doesn't stack with multiple 'sleep_max()' calls on the same frame
	*/
	
	global.sleep_max = max(global.sleep_max, _milliseconds);
	
#define view_shift(_index, _dir, _pan)
	/*
		Moves a given player's screen a given distance toward a given direction
		Basically the second argument of "weapon_post()", but usable outside of a Player object
	*/
	
	if(_index < 0){
		for(var i = 0; i < maxp; i++){
			view_shift(i, _dir, _pan);
		}
	}
	else{
		var _shake = UberCont.opt_shake;
		UberCont.opt_shake = 1;
		
		with(instance_create(0, 0, Revive)){
			try{
				p = _index;
				instance_change(Player, false);
				gunangle = _dir;
				weapon_post(0, _pan * current_time_scale, 0);
			}
			catch(_error){
				trace_error(_error);
			}
			
			instance_delete(self);
		}
		
		UberCont.opt_shake = _shake;
	}
	
#define motion_step(_mult)
	/*
		Performs an instance's basic movement code, scaled by a given number
	*/
	
	if(_mult > 0){
		if(friction_raw != 0 && speed_raw != 0){
			speed_raw -= min(abs(speed_raw), friction_raw * _mult) * sign(speed_raw);
		}
		if(gravity_raw != 0){
			hspeed_raw += lengthdir_x(gravity_raw, gravity_direction) * _mult;
			vspeed_raw += lengthdir_y(gravity_raw, gravity_direction) * _mult;
		}
		if(speed_raw != 0){
			x += hspeed_raw * _mult;
			y += vspeed_raw * _mult;
		}
	}
	else{
		if(speed_raw != 0){
			x += hspeed_raw * _mult;
			y += vspeed_raw * _mult;
		}
		if(gravity_raw != 0){
			hspeed_raw += lengthdir_x(gravity_raw, gravity_direction) * _mult;
			vspeed_raw += lengthdir_y(gravity_raw, gravity_direction) * _mult;
		}
		if(friction_raw != 0 && speed_raw != 0){
			speed_raw -= min(abs(speed_raw), friction_raw * _mult) * sign(speed_raw);
		}
	}
	
#define sound_play_hit_ext(_sound, _pitch, _volume)
	/*
		'sound_play_hit()' distance-based sound, but with pitch and volume arguments
	*/
	
	var _snd = sound_play_hit(_sound, 0);
	
	sound_pitch(_snd, _pitch);
	sound_volume(_snd, audio_sound_get_gain(_snd) * _volume);
	
	return _snd;

#define rad_drop(_x, _y, _raddrop, _dir, _spd)
	/*
		Creates rads at the given coordinates in enemy death fashion
	*/
	
	var _inst = [];
	
	while(_raddrop > 0){
		var _big = (_raddrop > 15);
		_raddrop -= (_big ? 10 : 1);
		with(instance_create(_x, _y, (_big ? BigRad : Rad))){
			motion_add(_dir, _spd);
			motion_add(random(360), 3 + random(_raddrop / 2));
			speed *= power(0.9, speed);
			array_push(_inst, self);
		}
	}
	
	return _inst;

#define rad_path(_inst, _target)
	with(global.rad_path_bind.id){
		visible = true;
		
		if("inst" not in self) inst = [];
		if("vars" not in self) vars = [];
		
		var i = array_length(vars);
		
		with(_inst){
			if(array_find_index(other.inst, self) < 0){
				array_push(other.inst, self);
				array_push(other.vars, {
					"targ"     : _target,
					"path"     : [],
					"can_path" : true,
					"heal"     : 0
				});
			}
		}
		
		return array_slice(vars, i, array_length(vars) - i);
	}
	
	return [];
	
#define rad_path_step
	if(visible){
		if(lag) trace_time();
		
		var	_instList = (("inst" in self) ? inst : []),
			_varsList = (("vars" in self) ? vars : []),
			i = 0;
			
		with(_instList){
			var	_vars = _varsList[i],
				_targ = _vars.targ;
				
			if(instance_exists(self) && instance_exists(_targ)){
				var	_tx   = _targ.x,
					_ty   = _targ.y,
					_path = _vars.path;
					
				if(array_length(_path)){
					 // Direction to Follow:
					var _dir = null;
					if(collision_line(x, y, _tx, _ty, Wall, false, false)){
						_dir = path_direction(_path, x, y, Wall);
					}
					else{
						_dir = point_direction(x, y, _tx, _ty);
					}
					
					 // Movin:
					if(_dir != null){
						 // Accelerate:
						speed = min(speed + random(max(friction_raw, 2 * current_time_scale)), 12);
						
						 // Follow Path:
						direction += angle_difference(_dir, direction) * min(1, max(0.2, 16 / point_distance(x, y, _tx, _ty)) * current_time_scale);
						
						 // Spinny:
						image_angle += speed_raw;
						
						 // Bounce Less:
						if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
							var _min = min(speed, 2);
							if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw = 0;
							if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw = 0;
							speed = max(_min, speed);
							if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw = 0;
							if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw = 0;
						}
					}
					else _vars.path = [];
					
					 // Done:
					if(place_meeting(x, y, _targ) || point_distance(x, y, _tx, _ty) <= speed_raw){
						if(instance_is(_targ, Player)) speed = 0;
						else{
							if("raddrop" in _targ) _targ.raddrop += rad;
							
							 // Heal:
							var _heal = _vars.heal;
							if(_heal > 0) with(_targ){
								my_health += _heal;
								
								 // Effects:
								sound_play_hit(sndHPPickup, 0.3);
								with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), FrogHeal)){
									if(chance(1, 3)) sprite_index = spr.BossHealFX;
									depth = other.depth - 1;
								}
							}
							
							 // Effects:
							sound_play_hit(sndRadPickup, 0.5);
							with(instance_create(x, y, EatRad)){
								if(other.sprite_index == sprBigRad) sprite_index = sprEatBigRad;
							}
							
							instance_destroy();
						}
					}
				}
				else if(speed <= friction_raw * 2){
					speed = max(speed, friction_raw);
					
					 // Target in Sight:
					if(!_vars.can_path){
						if(!collision_line(x, y, _tx, _ty, Wall, false, false)){
							_vars.can_path = true;
						}
					}
					
					 // Create Path:
					if(_vars.can_path && !path_reaches(_path, _tx, _ty, Wall)){
						_path = path_create(x, y, _tx, _ty, Wall);
						_path = path_shrink(_path, Wall, 2);
						_vars.path = _path;
						_vars.can_path = false;
						
						 // Send Path to Bros:
						var j = 0;
						with(_instList){
							var v = _varsList[j++];
							if(v.targ == _targ && !array_length(v.path) && self != other){
								if(instance_exists(self) && !collision_line(x, y, other.x, other.y, Wall, false, false)){
									v.path = _path;
									v.can_path = false;
								}
							}
						}
					}
				}
				i++;
			}
			
			 // Done:
			else{
				_instList = array_delete(_instList, i);
				_varsList = array_delete(_varsList, i);
				
				 // Heal FX:
				if(_vars.heal){
					var _num = 0;
					with(_varsList) if(targ == _targ){
						_num++;
					}
					if(_num <= 0) with(_targ){
						with(instance_create(x, y, FrogHeal)){
							sprite_index  = spr.BossHealFX;
							depth         = other.depth - 1;
							image_xscale *= 1.5;
							image_yscale *= 1.5;
							vspeed       -= 1;
						}
						with(instance_create(x, y, LevelUp)){
							creator = other;
						}
						sound_play_hit_ext(sndLevelUltra, 2 + orandom(0.1), 1.7);
					}
				}
			}
		}
		inst = _instList;
		vars = _varsList;
		
		 // Goodbye:
		if(!array_length(_instList)){
			visible = false;
		}
		
		if(lag) trace_time(script[2]);
	}
	
#define sprite_get_team(_sprite)
	/*
		Returns what team a sprite is based on
		
		Example:
			sprite_get_team(sprAllyBullet) == 2
	*/
	
	if(ds_map_exists(sprite_team_map, _sprite)){
		return sprite_team_map[? _sprite];
	}
	
	return -1;
	
#define team_get_sprite(_team, _sprite)
	/*
		Returns the given team's variant of a sprite, returns _sprite if none exists
		
		Example:
			team_get_sprite(1, sprFlakBullet) == sprEFlak
	*/
	
	var	_spriteList  = team_sprite_map[? _sprite],
		_spriteIndex = _team - sprite_team_start;
		
	if(_spriteIndex >= 0 && _spriteIndex < array_length(_spriteList)){
		return _spriteList[_spriteIndex];
	}
	
	return _sprite;
	
#define team_instance_sprite(_team, _inst)
	/*
		Visually changes a projectile to a given team's variant, if it exists
	*/
	
	var _newInst = [_inst];
	
	with(_inst){
		var	_spr = sprite_index,
			_obj = (("name" in self && string_pos("Custom", object_get_name(object_index)) == 1) ? name : object_index);
			
		 // Sprite:
		sprite_index = team_get_sprite(_team, _spr);
		
		 // Object, for hardcoded stuff:
		if(ds_map_exists(team_sprite_obj_map, _obj)){
			var	_objList  = team_sprite_obj_map[? _obj][? _spr],
				_objIndex = _team - sprite_team_start;
				
			if(_objIndex >= 0 && _objIndex < array_length(_objList)){
				var _newObj = _objList[_objIndex];
				if(_obj != _newObj){
					var _varList = variable_instance_get_list(self);
					
					 // Normal:
					if(is_real(_newObj)){
						if(object_exists(_newObj)){
							with(self){
								instance_change(_newObj, false);
								event_perform(ev_create, 0);
								variable_instance_set_list(self, _varList);
								
								 // Object-Specifics:
								switch(_obj){
									case EnemyBullet3:
									case PopoSlug:
										bonus = false;
										break;
								}
							}
						}
					}
					
					 // Custom:
					else if(is_string(_newObj)){
						with(obj_create(x, y, _newObj)){
							with(variable_instance_get_names(self)){
								if(self not in _varList){
									lq_set(_varList, self, variable_instance_get(other, self));
								}
							}
							with(other){
								instance_change(other.object_index, false);
								event_perform(ev_create, 0);
								variable_instance_set_list(self, _varList);
								
								 // Object-Specifics:
								if(array_find_index(["CustomBullet", "CustomFlak", "CustomShell", "CustomPlasma"], _newObj) >= 0){
									var _sprAlly = team_get_sprite(2, sprite_index);
									
									 // Destruction Sprite:
									switch(_sprAlly){
										case sprHeavyBullet        : spr_dead = sprHeavyBulletHit;   break;
										case sprAllyBullet         : spr_dead = sprAllyBulletHit;    break;
										case sprBullet2            :
										case sprBullet2Disappear   : spr_dead = sprBullet2Disappear; break;
										case sprSlugBullet         :
										case sprSlugDisappear      :
										case sprHyperSlug          :
										case sprHyperSlugDisappear : spr_dead = sprSlugHit;          break;
										case sprHeavySlug          :
										case sprHeavySlugDisappear : spr_dead = sprHeavySlugHit;     break;
										case sprFlakBullet         : spr_dead = sprFlakHit;          break;
										case sprSuperFlakBullet    : spr_dead = sprSuperFlakHit;     break;
										case sprPlasmaBall         : spr_dead = sprPlasmaImpact;     break;
										default                    : spr_dead = sprBulletHit;
									}
									spr_dead = team_get_sprite(_team, spr_dead);
									
									 // Specifics:
									switch(_newObj){
										
										case "CustomFlak":
										
											 // Specifics:
											switch(_obj){
												case SuperFlakBullet:
													snd_dead     = sndSuperFlakExplode;
													bonus_damage = 5;
													flak         = array_create(5, FlakBullet);
													super        = true;
													break;
													
												case EFlakBullet:
													bonus_damage = 0;
													flak         = array_create(10);
													for(var i = 0; i < array_length(flak); i++){
														flak[i] = {
															object_index : EnemyBullet3,
															speed        : random_range(9, 12)
														};
													}
													break;
											}
											
											break;
											
										case "CustomShell":
										
											 // Disappear Sprite:
											switch(_sprAlly){
												case sprSlugBullet:
												case sprSlugDisappear:
													spr_dead = sprSlugDisappear;
													break;
													
												case sprHeavySlug:
												case sprHeavySlugDisappear:
													spr_dead = sprHeavySlugDisappear;
													break;
													
												default:
													spr_dead = sprBullet2Disappear;
											}
											spr_fade = team_get_sprite(_team, spr_dead);
											
											 // Specifics:
											switch(_obj){
												case Slug      : bonus_damage = 2;  break;
												case HeavySlug : bonus_damage = 10; break;
												case PopoSlug  : bonus_damage = 0;  break;
											}
											
											break;
											
										case "CustomPlasma":
											
											 // Trail Sprite:
											spr_trail = team_get_sprite(_team, sprPlasmaTrail);
											
											 // Specifics:
											switch(_obj){
												case PlasmaBig:
												case PlasmaHuge:
													snd_dead = sndPlasmaBigExplode;
													minspeed = 6;
													flak     = ((_obj == PlasmaHuge) ? array_create(4, PlasmaBig) : array_create(10, PlasmaBall));
													break;
											}
											
											break;
											
									}
								}
							}
							instance_delete(self);
						}
					}
				}
			}
		}
	}
	
	_newInst = instances_matching_ne(_newInst, "id", null);
	
	if(array_length(_newInst)){
		return ((array_length(_newInst) == 1) ? _newInst[0] : _newInst);
	}
	
	return noone;