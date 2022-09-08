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
	with([pickup_alarm, pickup_text]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // Bind Events:
	script_bind(CustomDraw, draw_bonus_spirit, -8, true);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro BonusAmmo_text   loc("NTTE:Bonus:Ammo",       `@5(${spr.BonusText}:-0.3) AMMO`)
#macro BonusHealth_text loc("NTTE:Bonus:Health",     `@5(${spr.BonusText}:-0.3) HP`)
#macro RedAmmo_text     loc("NTTE:Red:Ammo",         `@3(${spr.RedText  }:-0.8) AMMO`)
#macro ChestShop_text   loc("NTTE:ChestShop:Open:1", call(scr.loc_format, "NTTE:ChestShop:Open", "PICK %!", "ONE"))
#macro ChestShop2_text  loc("NTTE:ChestShop:Open:2", call(scr.loc_format, "NTTE:ChestShop:Open", "PICK %!", "TWO"))

#define AllyBackpack_create(_x, _y)
	/*
		Like a Backpack, but spawns an Ally to wield the the merged weapon, and only drops HP instead of ammo
	*/
	
	with(call(scr.obj_create, _x, _y, "Backpack")){
		 // Visual:
		sprite_index = spr.AllyBackpack;
		spr_dead     = spr.AllyBackpackOpen;
		
		 // Vars:
		curse = 0;
		ally  = 1 + ultra_get("rebel", 2);
		
		return self;
	}
	
	
#define Backpack_create(_x, _y)
	/*
		Goody bag chest
		Gives ammo, HP, rads, a merged weapon, and restores strong spirit
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.Backpack;
		spr_dead     = spr.BackpackOpen;
		spr_shadow   = shd16;
		spr_shadow_y = 2;
		
		 // Sounds:
		snd_open = choose(sndMenuASkin, sndMenuBSkin);
		
		 // Vars:
		num     = 2;
		raddrop = 8;
		ally    = 0;
		
		 // Cursed:
		switch(crown_current){
			case crwn_none   : curse = false;        break;
			case crwn_curses : curse = chance(2, 3); break;
			default          : curse = chance(1, 7);
		}
		if(curse > 0){
			sprite_index = spr.BackpackCursed;
			spr_dead     = spr.BackpackCursedOpen;
		}
		
		 // Events:
		on_step = script_ref_create(Backpack_step);
		on_open = script_ref_create(Backpack_open);
		
		return self;
	}
	
#define Backpack_step
	 // Curse FX:
	if(chance_ct(curse, 20)){
		with(instance_create(x + orandom(8), y + orandom(8), Curse)){
			depth = other.depth - 1;
		}
	}
	
#define Backpack_open
	 // Remember:
	GameCont.ntte_backpack_opened = true;
	
	 // Sound:
	sound_play_pitchvol(sndPickupDisappear, 1 + orandom(0.4), 2);
	if(curse > 0){
		sound_play(sndCursedChest);
	}
	
	 // Weapon:
	var _wepAng = random(360);
	for(var _wepDir = _wepAng; _wepDir < _wepAng + 360; _wepDir += (360 / max(1, ally))){
		var _wepNum = 1 + ultra_get("steroids", 1);
		if(_wepNum > 0){
			var _wep = wep_none;
			
			 // DefPack Integration:
			if(ally <= 0 && mod_exists("mod", "defpack tools") && chance(1, 5)){
				var _jsGrub = [
					"lightning blue lifting drink(tm)",
					"extra double triple coffee",
					"expresso",
					"saltshake",
					"munitions mist",
					"vinegar",
					"guardian juice",
					"stopwatch" // a beautiful mistake
				];
				
				if(skill_get(mut_boiling_veins) > 0){
					array_push(_jsGrub, "sunset mayo");
				}
				if(array_length(instances_matching(Player, "notoxic", false))){
					array_push(_jsGrub, "frog milk");
				}
				
				_wep = _jsGrub[irandom(array_length(_jsGrub) - 1)];
			}
			
			 // Merged Weapon:
			else{
				_wep = call(scr.temerge_decide_weapon, 0, max(1, GameCont.hard - 1) + (2 * curse));
				
				 // Parts:
				repeat(_wepNum){
					var	_ang = random(360),
						_num = irandom_range(2, 3);
						
					for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
						with(call(scr.fx, x, y, [_dir + orandom(70), 3], Shell)){
							sprite_index = spr.BackpackDebris;
							image_index  = irandom(image_number - 1);
							image_speed  = 0;
							image_xscale = choose(-1, 1);
							image_angle  = orandom(10);
						}
					}
				}
			}
			
			 // Create Weapon Ally:
			if(ally > 0){
				var _creator = (instance_is(other, Player) ? other : instance_nearest(x, y, Player));
				with(instance_create(x, y, Ally)){
					motion_add(_wepDir, 3);
					creator = _creator;
					
					 // Alert:
					sprite_index = sprAllyIdle;
					with(call(scr.alert_create, self, spr.AllyAlert)){
						flash = 6 + random(3);
					}
					sprite_index = spr_idle;
					
					 // Give Weapon:
					if(_wep != wep_none){
						with(call(scr.obj_create, x, y, "FireWeapon")){
							creator       = other;
							wep           = _wep;
							search_object = AllyBullet;
						}
					}
				}
				_wepNum--;
			}
			
			 // Create Weapon Pickup:
			if(_wep != wep_none && _wepNum > 0){
				repeat(_wepNum){
					with(instance_create(x, y, WepPickup)){
						curse = other.curse;
						ammo  = true;
						wep   = _wep;
					}
				}
			}
		}
	}
	
	 // Pickups:
	var	_ang = random(360),
		_num = ceil(num * power(1.4, skill_get(mut_rabbit_paw)));
		
	if(_num > 0){
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
			var _minID = instance_max;
			
			 // Puf:
			with(instance_create(x, y, Dust)){
				depth = other.depth;
			}
			
			 // Determine Drop:
			if(ally <= 0 && chance(1, 40)){ // wtf this isnt a pickup
				with(instance_create(x, y, Bandit)){
					sprite_index = spr_hurt;
					with(call(scr.alert_create, self, spr.BanditAlert)){
						flash = 6 + random(3);
					}
				}
			}
			else{
				pickup_drop(100 / pickup_chance_multiplier, 0);
				
				var	_ally  = (ally > 0),
					_rogue = false,
					_red   = false;
					
				with(instance_is(other, Player) ? other : instance_nearest(x, y, Player)){
					 // Rogue-Opened:
					if(race == "rogue"){
						_rogue = true;
					}
					
					 // Red-Opened:
					if(
						call(scr.weapon_get, "red", wep)  > 0 ||
						call(scr.weapon_get, "red", bwep) > 0
					){
						_red = true;
					}
				}
				
				 // Modify Pickup:
				with(instances_matching_gt([Pickup, chestprop], "id", _minID)){
					switch(object_index){
						
						case AmmoPickup:
						
							 // Health:
							if(_ally){
								instance_create(x, y, HPPickup);
								instance_delete(self);
							}
							
							 // Portal Strikes:
							else if(chance(_rogue, 4)){
								instance_create(x, y, RoguePickup);
								instance_delete(self);
							}
							
							 // Red Ammo:
							else if(chance(_red, 4)){
								call(scr.obj_create, x, y, "RedAmmoPickup");
								instance_delete(self);
							}
							
							 // Cursed:
							else if(other.curse > cursed){
								sprite_index = sprCursedAmmo;
								cursed       = other.curse;
								num          = 1 + (0.5 * cursed);
								alarm0       = pickup_alarm(200 + random(30), 1/5) / (1 + (2 * cursed));
							}
							
							break;
							
						case AmmoChest:
						
							 // Health:
							if(_ally){
								instance_create(x, y, HealthChest);
								instance_delete(self);
							}
							
							 // Portal Strikes:
							else if(chance(_rogue, 4)){
								call(scr.chest_create, x, y, RogueChest);
								instance_delete(self);
							}
							
							 // Red Ammo:
							else if(chance(_red, 4)){
								call(scr.chest_create, x, y, "RedAmmoChest");
								instance_delete(self);
							}
							
							 // Cursed:
							else if(other.curse > 0){
								call(scr.chest_create, x, y, "CursedAmmoChest");
								instance_delete(self);
							}
							
							break;
							
					}
				}
			}
			
			 // Coolify:
			with(instances_matching_gt([Pickup, chestprop, hitme], "id", _minID)){
				with(call(scr.obj_create, x, y, "BackpackPickup")){
					direction = _dir;
					target    = other;
					with(self){
						event_perform(ev_step, ev_step_end);
					}
				}
			}
		}
	}
	
	 // Rads:
	var _rad = raddrop;
	for(var i = 0; i < maxp; i++){
		_rad += (player_get_race(i) == "melting");
	}
	if(_rad > 0) repeat(_rad){
		with(instance_create(x, y, Rad)){
			motion_add(random(360), random_range(3, 5));
		}
	}
	
	 // Restore Strong Spirit:
	if(skill_get(mut_strong_spirit) > 0){
		with(instance_is(other, Player) ? other : Player){
			if(canspirit == false){
				canspirit = true;
				GameCont.canspirit[index] = false;
				
				 // Effects:
				with(instance_create(x, y, StrongSpirit)){
					sprite_index = sprStrongSpiritRefill;
					creator = other;
				}
				sound_play(sndStrongSpiritGain);
			}
		}
	}
	
	
#define Backpacker_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		var _type = irandom(array_length(spr.BackpackerIdle) - 1);
		
		 // Visual:
		spr_idle     = spr.BackpackerIdle[_type];
		spr_hurt     = spr.BackpackerHurt[_type];
		spr_dead     = mskNone;
		spr_shadow_y = -2;
		sprite_index = spr_idle;
		depth        = -1;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndHitRock;
		
		 // Vars:
		mask_index = mskBandit;
		my_health  = 5;
		raddrop    = 2;
		size       = 1;
		team       = 1;
		wep        = "crabbone";
		
		return self;
	}
	
#define Backpacker_death
	 // BONE!!!
	if(wep != wep_none){
		with(instance_create(x, y, WepPickup)){
			ammo = true;
			wep  = other.wep;
		}
	}
	
	 // Effects:
	repeat(8){
		call(scr.fx, [x, 4], [y, 4], random(4), Dust);
	}
	repeat(6){
		with(call(scr.obj_create, x, y, "BonePickup")){
			motion_add(random(360), 2 + random(3));
		}
	}
	

#define BackpackPickup_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		sprite_index = mskPickup;
		mask_index = mskPickup;
		visible = false;
		target = noone;
		target_x = x;
		target_y = y;
		z = 0;
		zfriction = 0.7;
		zspeed = random_range(2, 4);
		speed = random_range(1, 3);
		direction = random(360);
		
		return self;
	}
	
#define BackpackPickup_end_step
	if(instance_exists(target)){
		z += zspeed * current_time_scale;
		zspeed -= zfriction * current_time_scale;
		if(z > 0 || zspeed > 0){
			with(target){
				x              = other.x;
				y              = other.y - other.z;
				xprevious      = x;
				yprevious      = y;
			//	other.target   = id;
				other.target_x = x;
				other.target_y = y;
				
				 // Important:
				if(instance_is(self, enemy)){
					sprite_index = spr_hurt;
					if(!canfly){
						other.canfly = canfly;
						canfly = true;
					}
				}
				
				 // Disable Collision:
				if(mask_index != mskNone){
					other.mask_index = mask_index;
					mask_index = mskNone;
				}
			}
			
			 // Collision:
			if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
				if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
				if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
			}
		}
		else instance_destroy();
	}
	
	else{
		 // Grab Pickup (In case it was replaced or something):
		with(instances_matching(instances_matching_gt(instances_matching_gt(instances_matching(instances_matching(GameObject, "xstart", target_x), "ystart", target_y), "id", id), "id", target), "backpackpickup_grab", null)){
			backpackpickup_grab = true;
			with(other){
				target = other.id;
				BackpackPickup_end_step();
			}
			exit;
		}
		
		 // Time to die:
		instance_destroy();
	}
	
#define BackpackPickup_destroy
	 // Reset Vars:
	with(target){
		x = other.x;
		y = other.y;
		xprevious = x;
		yprevious = y;
		mask_index = other.mask_index;
		direction = other.direction;
		speed = other.speed;
		if("canfly" in other) canfly = other.canfly;
		
		 // Effects:
		repeat(3){
			with(instance_create(x, y, Dust)){
				motion_add(random(360), 3);
				motion_add(other.direction, 1);
				depth = 0;
			}
		}
	}


#define BatChest_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.BatChest;
		spr_dead     = spr.BatChestOpen;
		
		 // Sound:
		snd_open = sndWeaponChest;
		
		 // Big:
		big     = false;
		setup   = true;
		nochest = 1;
		
		 // Cursed:
		switch(crown_current){
			case crwn_none   : curse = false;        break;
			case crwn_curses : curse = chance(2, 3); break;
			default          : curse = chance(1, 7);
		}
		
		 // Events:
		on_step = script_ref_create(BatChest_step);
		on_open = script_ref_create(BatChest_open);
		
		return self;
	}

#define BatChest_setup
	setup = false;
	
	 // Big:
	if(big){
		nochest++;
		if(curse > 0){
			sprite_index = spr.BatChestBigCursed;
			spr_dead     = spr.BatChestBigCursedOpen;
			snd_open     = sndBigCursedChest;
		}
		else{
			sprite_index = spr.BatChestBig;
			spr_dead     = spr.BatChestBigOpen;
			snd_open     = sndBigWeaponChest;
		}
		spr_shadow = shd32;
	}
	
	 // Cursed:
	else if(curse > 0){
		sprite_index = spr.BatChestCursed;
		spr_dead     = spr.BatChestCursedOpen;
		snd_open     = sndCursedChest;
	}

#define BatChest_step
	if(setup) BatChest_setup();
	
	 // Curse FX:
	if(chance_ct(curse, 16)){
		with(instance_create(x + orandom(8), y + orandom(8), Curse)){
			depth = other.depth - 1;
		}
	}
	
#define BatChest_open
	 // Sound:
	sound_play_pitchvol(sndEnergySword,       0.5 + orandom(0.1), 0.8);
	sound_play_pitchvol(sndEnergyScrewdriver, 1.5 + orandom(0.1), 0.5);
	
	 // Text:
	if(instance_is(other, Player)){
		var _text = instance_create(x, y, PopupText);
		_text.text   = (big ? ChestShop2_text : ChestShop_text);
		_text.alarm1 = 18;
		_text.target = other.index;
	}
	
	 // Clear Walls:
	instance_create(x, y, PortalClear);
	
	 // Big:
	if(big){
		 // Important:
		if(instance_is(other, Player)){
			sound_play(other.snd_chst);
		}
		
		 // Clear Big Chest Chance:
		GameCont.nochest = 0;
	}
	
	 // Create Weapon Shops:
	var	_angOff = 50 / (1 + (0.5 * big)),
		_shop   = [];
		
	for(var _ang = -_angOff * (1 + big); _ang <= _angOff * (1 + big); _ang += _angOff){
		var	_len = 28,
			_dir = _ang + 90;
			
		with(call(scr.obj_create, x, y, "ChestShop")){
			x      += lengthdir_x(_len, _dir) * ((3 + other.big) / 3);
			y      += lengthdir_y(_len, _dir);
			type    = ChestShop_wep;
			drop    = wep_screwdriver;
			open   += other.big;
			curse   = other.curse;
			creator = other;
			array_push(_shop, self);
		}
	}
	
	 // Determine Weapons:
	var	_maxHard        = max(1, GameCont.hard - 1) + (2 * curse),
		_avoidedWepList = [],
		_wep            = call(scr.weapon_decide, 0, _maxHard),
		_shopSize       = array_length(_shop);
		
	for(var _index = 0; _index < _shopSize; _index += 2){
		var _nextIndex = _index + 1;
		
		_shop[_index].drop = (
			(_nextIndex != _shopSize && (_index == 0 || chance(1, 2)))
			? call(scr.weapon_add_temerge, wep_none, _wep)
			: call(scr.weapon_add_temerge, _wep, wep_none)
		);
		
		array_push(_avoidedWepList, _wep);
		
		var _stockWep = call(scr.weapon_decide, 0, _maxHard, false, _avoidedWepList);
		
		if(_nextIndex < _shopSize){
			_shop[_nextIndex].drop = call(scr.weapon_add_temerge, _stockWep, _wep);
		}
		
		_wep = _stockWep;
	}
	
	
//#define BloodLustPickup_create(_x, _y)
//	with(call(scr.obj_create, _x, _y, "CustomPickup")){
//		 // Visual:
//		sprite_index = sprHP;
//		image_blend = c_red;
//		
//		 // Sounds:
//		snd_open = sndHPPickup;
//		snd_fade = sndBloodlustProc;
//		
//		 // Vars:
//		num      = -1 + (crown_current == crwn_haste);
//		pull_dis = 30 + (30 * skill_get(mut_plutonium_hunger));
//		pull_spd = 4;
//		
//		 // Events:
//		on_open = script_ref_create(BloodLustPickup_open);
//		on_fade = script_ref_create(BloodLustPickup_fade);
//		
//		return self;
//	}
//	
//#define BloodLustPickup_open
//	var _num = num;
//	
//	 // Regen:
//	if(fork()){
//		with(instance_is(other, Player) ? other : Player){
//			while(instance_exists(self)){
//				my_health += clamp(maxhealth - my_health, 0, _num);
//				
//				sound_play(sndBloodlustProc);
//				with(instance_create(x, y, BloodLust)){
//					creator = other;
//				}
//				
//				pickup_text("HP", ((my_health < maxhealth) ? "add" : "max"), _num);
//				
//				if(my_health >= maxhealth) break;
//				
//				wait 45;
//			}
//		}
//		exit;
//	}
//	
//#define BloodLustPickup_fade
//	 // Effects:
//	instance_create(x, y, BloodLust);
	
	
#define BoneBigPickup_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "BonePickup")){
		 // Visual:
		sprite_index = spr.BonePickupBig[irandom(array_length(spr.BonePickupBig) - 1)];
		
		 // Vars:
		mask_index = mskBigRad;
		num        = 10;
		
		return self;
	}
	
	
#define BonePickup_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = spr.BonePickup[irandom(array_length(spr.BonePickup) - 1)];
		image_angle  = random(360);
		spr_open     = -1;
		spr_fade     = -1;
		
		 // Sound:
		snd_open = sndRadPickup;
		snd_fade = -1;
		
		 // Vars:
		mask_index = mskRad;
		alarm0     = pickup_alarm(150 + random(30), 1/4);
		pull_dis   = 80 + (60 * skill_get(mut_plutonium_hunger));
		pull_spd   = 12;
		
		 // Events:
		on_pull = script_ref_create(BonePickup_pull);
		on_open = script_ref_create(BonePickup_open);
		on_fade = script_ref_create(BonePickup_fade);
		
		 // Undercover:
		var _active = false;
		with(Player){
			with(other){
				if(BonePickup_pull()){
					_active = true;
				}
			}
			if(_active) break;
		}
		if(_active){
			image_index = random(image_number);
		}
		else{
			shine = 0;
			blink = 0;
		}
		
		return self;
	}
	
#define BonePickup_pull
	if(speed <= 0){
		if(call(scr.wep_raw, other.wep) == "scythe" || call(scr.wep_raw, other.bwep) == "scythe"){
			return true;
		}
	}
	return false;

#define BonePickup_open
	var _num = num;
	
	 // Only Players Holding Scythes:
	if(instance_is(other, Player)){
		if(call(scr.wep_raw, other.wep) != "scythe" && call(scr.wep_raw, other.bwep) != "scythe"){
			return true;
		}
	}
	
	 // Give Ammo:
	with(instance_is(other, Player) ? other : Player){
		with([wep, bwep]){
			if(is_object(self) && call(scr.wep_raw, self) == "scythe"){
				if(ammo < amax){
					ammo = min(ammo + _num, amax);
					break;
				}
			}
		}
	}
	
	 // Effects:
	instance_create(x, y, Dust);

#define BonePickup_fade
	 // Effects:
	instance_create(x, y, Dust);
	
	
#define BonusAmmoChest_create(_x, _y)
	/*
		A chest that gives Bonus Ammo, wooooooo
	*/
	
	with(call(scr.obj_create, _x, _y, "BonusChest")){
		 // Visual:
		sprite_index = spr.BonusAmmoChest;
		spr_dead     = spr.BonusAmmoChestOpen;
		
		 // Vars:
		num = 2;
		
		 // Get Loaded:
		if(ultra_get("steroids", 2) != 0){
			sprite_index = spr.BonusAmmoChestSteroids;
			spr_dead     = spr.BonusAmmoChestSteroidsOpen;
			num         *= power(2, ultra_get("steroids", 2));
		}
		
		 // Events:
		on_open = script_ref_create(BonusAmmoChest_open);
		
		return self;
	}
	
#define BonusAmmoChest_open
	var _num = num;
	
	 // Bonus Ammo:
	if(instance_is(other, Player)){
		with(ultra_get(char_random, 2) ? Player : other){
			bonus_ammo       = (("bonus_ammo" in self) ? bonus_ammo : 0) + (_num * 60);
			bonus_ammo_flash = 1;
			
			 // Ammo:
			var _type = weapon_get_type(wep);
			if(_type == type_melee || ammo[_type] >= typ_amax[_type]){
				_type = irandom_range(1, array_length(ammo) - 1);
			}
			if(ammo[_type] < typ_amax[_type]){
				ammo[_type] = min(ammo[_type] + round(/*0.5 * typ_ammo[_type] * */_num), typ_amax[_type]);
			}
			
			 // Text:
			pickup_text(BonusAmmo_text, "add", _num);
		}
	}
	else repeat(2){
		with(call(scr.obj_create, x, y, "BonusAmmoPickup")){
			num = _num / 2;
		}
	}
	
	 // Effects:
	sound_play_pitchvol(sndRogueCanister, 0.7, 0.7);
	sound_play_pitch(sndRogueRifle, 0.5);
	
	
#define BonusAmmoFire_create(_x, _y)
	/*
		Effect used for Players shooting with Bonus Ammo
	*/
	
	with(instance_create(_x, _y, WepSwap)){
		 // Visual:
		sprite_index = sprImpactWrists;
		image_blend  = merge_color(c_aqua, choose(c_white, c_blue), random(0.4));
		image_speed  = 0.35;
		
		return self;
	}
	
	
#define BonusAmmoMimic_create(_x, _y)
	/*
		A mimic that drops Bonus Ammo when it dies or bites
	*/
	
	with(call(scr.obj_create, _x, _y, "BonusMimic")){
		 // Visual:
		spr_idle = spr.BonusAmmoMimicIdle;
		spr_walk = spr.BonusAmmoMimicFire;
		spr_hurt = spr.BonusAmmoMimicHurt;
		spr_dead = spr.BonusAmmoMimicDead;
		spr_chrg = spr.BonusAmmoMimicTell;
		hitid    = [spr_walk, "OVERSTOCK MIMIC"];
		
		 // Vars:
		maxhealth = 12;
		num       = 2;
		
		 // Events:
		on_melee = script_ref_create(BonusAmmoMimic_melee);
		
		return self;
	}
	
#define BonusAmmoMimic_melee
	 // Give Bonus Ammo on Contact:
	call(scr.obj_create, other.x, other.y, "BonusAmmoPickup");
	
#define BonusAmmoMimic_death
	 // Pickups:
	repeat(num){
		call(scr.obj_create, x, y, "BonusAmmoPickup");
	}
	
	
#define BonusAmmoPickup_create(_x, _y)
	/*
		A pickup that gives Bonus Ammo, woooooo
	*/
	
	with(call(scr.obj_create, _x, _y, "BonusPickup")){
		 // Visuals:
		sprite_index = spr.BonusAmmoPickup;
		
		 // Sounds:
		snd_open = sndAmmoPickup;
		
		 // Vars:
		num = 1 + (crown_current == crwn_haste);
		
		 // Events:
		on_open = script_ref_create(BonusAmmoPickup_open);
		
		return self;	
	}
	
#define BonusAmmoPickup_open
	var _num = num;
	
	 // Bonus Ammo:
	with(
		(!instance_is(other, Player) || ultra_get(char_random, 2))
		? Player
		: other
	){
		bonus_ammo       = (("bonus_ammo" in self) ? bonus_ammo : 0) + (_num * 60);
		bonus_ammo_flash = 1;
		
		 // Ammo:
		var _type = weapon_get_type((bwep == wep_none) ? wep : choose(wep, bwep));
		if(_type == type_melee || ammo[_type] >= typ_amax[_type]){
			_type = irandom_range(1, array_length(ammo) - 1);
		}
		if(ammo[_type] < typ_amax[_type]){
			ammo[_type] = min(ammo[_type] + round(/*0.5 * typ_ammo[_type] * */_num), typ_amax[_type]);
		}
		
		 // Text:
		pickup_text(BonusAmmo_text, "add", _num);
	}
	
	 // Effects:
	sound_play_pitchvol(sndRogueCanister, 0.7, 0.7);
	sound_play_pitch(sndRogueRifle, 1.5);
	
	
#define BonusChest_create(_x, _y)
	/*
		The base object used for Bonus Ammo and Bonus Health chests
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		spr_open = spr.BonusFXChestOpen;
		
		 // Vars:
		wave = random(90);
		
		 // Events:
		on_step = script_ref_create(BonusChest_step);
		
		return self;
	}
	
#define BonusChest_step
	 // FX:
	wave += current_time_scale;
	if((wave % 30) < current_time_scale){
		with(call(scr.fx, [x, 4], [y, 4], 0, FireFly)){
			sprite_index = spr.BonusFX;
			depth        = other.depth - 1;
		}
	}
	
	
#define BonusHealthChest_create(_x, _y)
	/*
		A chest that gives Bonus Health, weeeeeee
	*/
	
	with(call(scr.obj_create, _x, _y, "BonusChest")){
		var _skill = skill_get(mut_second_stomach);
		
		 // Visual:
		sprite_index = spr.BonusHealthChest;
		spr_dead     = spr.BonusHealthChestOpen;
		
		 // Sound:
		snd_open = ((_skill > 0) ? sndHPPickupBig : sndHPPickup);
		
		 // Vars:
		num = 2 * (1 + _skill);
		
		 // Events:
		on_open = script_ref_create(BonusHealthChest_open);
		
		return self;
	}
	
#define BonusHealthChest_open
	var _num = num;
	
	 // Bonus HP:
	if(instance_is(other, Player)){
		with(ultra_get(char_random, 1) ? Player : other){
			bonus_health       = (("bonus_health" in self) ? bonus_health : 0) + (_num * 30);
			bonus_health_flash = 1;
			
			 // Health:
			if(my_health < maxhealth){
				my_health = min(my_health + _num, maxhealth);
			}
			
			 // Chicken:
			if(chickendeaths > 0){
				chickendeaths--;
				maxhealth++;
			}
			
			 // Text:
			pickup_text(BonusHealth_text, "add", _num);
			
			 // Effects:
			with(instance_create(x, y, HealFX)){
				sprite_index = ((skill_get(mut_second_stomach) > 0) ? spr.BonusHealBigFX : spr.BonusHealFX);
				depth = other.depth - 1;
			}
		}
	}
	else repeat(2){
		with(call(scr.obj_create, x, y, "BonusHealthPickup")){
			num = _num / 2;
		}
	}
	
	 // Effects:
	sound_play_pitchvol(sndRogueCanister, 1.3, 0.7);
	sound_play_pitch(sndRogueRifle, 0.5);
	
	
#define BonusHealthMimic_create(_x, _y)
	/*
		A mimic that drops Bonus Health when it dies or bites
	*/
	
	with(call(scr.obj_create, _x, _y, "BonusMimic")){
		 // Visual:
		spr_idle = spr.BonusHealthMimicIdle;
		spr_walk = spr.BonusHealthMimicFire;
		spr_hurt = spr.BonusHealthMimicHurt;
		spr_dead = spr.BonusHealthMimicDead;
		spr_chrg = spr.BonusHealthMimicTell;
		hitid    = [spr_walk, "OVERHEAL MIMIC"];
		
		 // Sound:
		snd_tell = sndHPMimicTaunt;
		
		 // Vars:
		maxhealth     = 12;
		raddrop       = 15;
		meleedamage   = 4;
		tell_wait_min = 180;
		tell_wait_max = 480;
		num           = 2;
		
		 // Alarms:
		alarm1 = random_range(tell_wait_min, tell_wait_max);
		
		 // Events:
		on_melee = script_ref_create(BonusHealthMimic_melee);
		
		return self;
	}
	
#define BonusHealthMimic_melee
	 // Give Bonus Health on Contact:
	call(scr.obj_create, other.x, other.y, "BonusHealthPickup");
	
	 // No Fun Allowed:
	with(instances_matching_ne(obj.BonusHealthMimic, "id")){
		if(canmelee == true){
			canmelee = false;
			alarm11  = other.alarm11;
		}
		else if(alarm11 > 0){
			alarm11 = max(alarm11, other.alarm11);
		}
	}
	
#define BonusHealthMimic_death
	 // Pickups:
	repeat(num){
		call(scr.obj_create, x, y, "BonusHealthPickup");
	}
	
	
#define BonusHealthPickup_create(_x, _y)
	/*
		A pickup that gives Bonus Health, weeeeee
	*/
	
	with(call(scr.obj_create, _x, _y, "BonusPickup")){
		var _skill = skill_get(mut_second_stomach);
		
		 // Visuals:
		sprite_index = spr.BonusHealthPickup;
		
		 // Sounds:
		snd_open = ((_skill > 0) ? sndHPPickupBig : sndHPPickup);
		
		 // Vars:
		num = (1 * (1 + _skill)) + (crown_current == crwn_haste);
		
		 // Events:
		on_open = script_ref_create(BonusHealthPickup_open);
		
		return self;
	}
	
#define BonusHealthPickup_open
	var _num = num;
	
	 // Bonus Health:
	with(
		(!instance_is(other, Player) || ultra_get(char_random, 1))
		? Player
		: other
	){
		bonus_health       = (("bonus_health" in self) ? bonus_health : 0) + (_num * 30);
		bonus_health_flash = 1;
		
		 // Health:
		if(my_health < maxhealth){
			my_health = min(my_health + _num, maxhealth);
		}
		
		 // Text:
		pickup_text(BonusHealth_text, "add", _num);
		
		 // Effects:
		with(instance_create(x, y, HealFX)){
			sprite_index = ((skill_get(mut_second_stomach) > 0) ? spr.BonusHealBigFX : spr.BonusHealFX);
			depth        = other.depth - 1;
		}
	}
	
	 // Effects:
	sound_play_pitchvol(sndRogueCanister, 1.3, 0.7);
	sound_play_pitch(sndRogueRifle, 1.5);
	
	
#define BonusMimic_create(_x, _y)
	/*
		The base object used for Bonus Ammo and Bonus Health mimics
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomMimic")){
		 // Vars:
		wave = random(90);
		
		 // Events:
		on_step = script_ref_create(BonusMimic_step);
		
		return self;
	}
	
#define BonusMimic_step
	 // Inherit:
	BonusChest_step();
	CustomMimic_step();
	
	
#define BonusPickup_create(_x, _y)
	/*
		The base object used for Bonus Ammo and Bonus Health pickups
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomPickup")){
		 // Visual:
		spr_open = spr.BonusFXPickupOpen;
		spr_fade = spr.BonusFXPickupFade;
		
		 // Sounds:
		snd_fade = sndPickupDisappear;
		
		 // Vars:
		pull_dis   = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd   = 4;
		pull_delay = 9;
		wave       = random(90);
		
		 // Events:
		on_step = script_ref_create(BonusPickup_step);
		on_pull = script_ref_create(BonusPickup_pull);
		
		return self;
	}
	
#define BonusPickup_step
	 // Attraction Delay:
	if(pull_delay > 0){
		pull_delay -= current_time_scale;
	}
	
	 // FX:
	wave += current_time_scale;
	if(((wave % 30) < current_time_scale || pull_delay > 0) && chance(1, max(2, pull_delay))){
		with(call(scr.fx, [x, 4], [y, 4], 0, FireFly)){
			sprite_index = spr.BonusFX;
			depth = other.depth - 1;
		}
	}
	
#define BonusPickup_pull
	if(pull_delay <= 0){
		 // Pull FX:
		if(chance_ct(1, 2)){
			if(point_distance(x, y, other.x, other.y) < pull_dis || instance_exists(Portal)){
				with(call(scr.fx, [x, 4], [y, 4], 0, FireFly)){
					sprite_index = spr.BonusFX;
					depth = other.depth - 1;
					image_index = 1;
				}
			}
		}
		
		return true;
	}
	return false;
	
	
#define BuriedVaultChest_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.BuriedVaultChest;
		spr_dead     = spr.BuriedVaultChestOpen;
		spr_shadow   = -1;
		
		 // Sound:
		snd_open = sndBigWeaponChest;
		
		 // Vars:
		num = 3 + skill_get(mut_open_mind);
		
		 // Events:
		on_open = script_ref_create(BuriedVaultChest_open);
		
		return self;
	}
	
#define BuriedVaultChest_open
	 // Important:
	if(instance_is(other, Player)){
		sound_play(other.snd_chst);
	}
	
	 // Loot:
	var _ang = random(360);
	if(num > 0){
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / num)){
			with(call(scr.obj_create, x, y, "BackpackPickup")){
				zfriction = 0.6;
				zspeed    = random_range(3, 4);
				speed     = 1.5 + orandom(0.2);
				direction = _dir;
				
				 // Decide Chest:
				target = call(scr.chest_create, 
					x,
					y,
					call(scr.pool, [
						[AmmoChest,     1],
						[WeaponChest,   1],
						[HealthChest,   1],
						["Backpack",    1],
						["OrchidChest", 1]
					])
				);
				
				with(self){
					event_perform(ev_step, ev_step_end);
				}
			}
		}
	}
	
	 // Blast Off:
	sound_play_pitch(sndStatueXP, 0.5 + orandom(0.1));
	sound_play_pitchvol(sndExplosion, 1.4 + random(0.3), 0.8);
	with(instance_create(x, y - 2, FXChestOpen)){
		sprite_index  = sprMutant6Dead;
		image_index   = 9;
		image_xscale *= 0.75;
		image_yscale  = image_xscale;
		image_blend   = make_color_rgb(random_range(120, 190), 255, 8);
	}
	with(call(scr.obj_create, x, y - 2, "BuriedVaultChestDebris")){
		direction = _ang + ((360 / other.num) * random_range(1/3, 2/3));
	}
	
	
#define BuriedVaultChestDebris_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = spr.BuriedVaultChestDebris;
		image_speed = 0.4 * choose(-1, 1);
		depth = -8;
		
		 // Sounds:
		snd_land = -1;
		
		 // Vars:
		friction = 0.15;
		direction = random(360);
		speed = random_range(1, 2);
		z = 0;
		zspeed = 10;
		zfriction = 1;
		rotspeed = orandom(30);
		bounce = 0;
		land = false;
		
		return self;
	}
	
#define BuriedVaultChestDebris_step
	z += zspeed * current_time_scale;
	zspeed -= zfriction * current_time_scale;
	
	 // Spinny:
	if(zspeed > 0){
		image_angle += rotspeed * current_time_scale;
		image_angle = (image_angle + 360) % 360;
	}
	else{
		image_angle -= image_angle * 0.2 * current_time_scale;
	}
	
	 // Land:
	if(z <= 0 || z <= 8){
		var _land = false;
		
		if(position_meeting(x, y + 8, Wall) || place_meeting(x, y + 8, TopSmall)){
			z = 8;
			depth = -7;
			_land = true;
		}
		else if(z <= 0){
			z = 0;
			depth = 0;
			_land = true;
			
			 // Collision:
			if(position_meeting(x, y - 8, Wall)){
				y += current_time_scale;
				depth = -1;
			}
			if(position_meeting(x + hspeed_raw, y + 8 + vspeed_raw, Wall)){
				if(position_meeting(x + hspeed_raw, y + 8, Wall)) hspeed_raw = 0;
				if(position_meeting(x, y + 8 + vspeed_raw, Wall)) vspeed_raw = 0;
			}
		}
		
		if(_land){
			if(abs(zspeed) > zfriction){
				call(scr.sound_play_at, x, y, snd_land, 0.9 + random(0.2), 0.5);
				repeat(3) with(call(scr.fx, x, y - z, 2, Dust)){
					depth = other.depth;
				}
			}
			if(bounce-- > 0){
				zspeed *= -2/3;
			}
			else{
				image_index = 0;
				image_angle = 0;
				zspeed = 0;
			}
		}
	}
	else{
		depth = -9;
		speed += friction_raw;
	}
	
#define BuriedVaultChestDebris_draw
	image_alpha = abs(image_alpha);
	draw_sprite_ext(sprite_index, image_index, x, y - z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	image_alpha *= -1;
	
	
#define BuriedVaultPedestal_create(_x, _y)
	with(instance_create(_x, _y, (instance_exists(CrownPed) ? CustomObject : CrownPed))){
		 // Visual:
		sprite_index = spr.BuriedVaultChestBase;
		image_speed  = 0.4;
		depth        = 2;
		
		 // Vars:
		mask_index = mskSalamander;
		spawn      = irandom_range(1, 2) + GameCont.vaults;
		spawn_time = 0;
		spawn_inst = [];
		
		 // Loot:
		var _chest = call(scr.pool, [
			["BuriedVaultChest", 4],
			[BigWeaponChest,     1],
			//[RadChest,         1],
			[ProtoChest,         1 * (!instance_exists(ProtoChest))],
			[ProtoStatue,        2 * (GameCont.subarea == 2)], // (proto statues do not support non-subarea of 2)
			[EnemyHorror,        1/5]
		]);
		target = call(scr.chest_create, x, y + 2, _chest);
		with(target){
			x = xstart;
			y = ystart;
			
			switch(object_index){
				case EnemyHorror:
					instance_create(x, y, PortalShock);
					other.spawn = 0;
					break;
					
				case ProtoChest:
					 // Cool Wep:
					if(wep == wep_rusty_revolver){
						sprite_index = spr.ProtoChestMerge;
						wep = call(scr.temerge_decide_weapon, 0, 3 + GameCont.hard);
					}
					break;
					
				case ProtoStatue:
					y -= 12;
					spr_shadow = -1;
					with(instances_matching_gt(Bandit, "id", id)){
						instance_delete(self);
					}
					break;
					
				case RadChest:
					y -= 4;
					spr_idle = sprRadChestBig;
					spr_hurt = sprRadChestBigHurt;
					spr_dead = sprRadChestBigDead;
					break;
			}
			
			 // Fix:
			with(instances_matching_gt(PortalClear, "id", id)){
				instance_destroy();
			}
		}
		
		 // Rads:
		var	_rad = (instance_is(target, RadChest) ? 30 : 15),
			_num = irandom_range(1, 2) + floor(_rad / 15) + skill_get(mut_open_mind) + (_chest == ProtoStatue),
			_ang = random(360);
			
		if(_num > 0){
			for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / _num)){
				var	_l = random_range(16, 36),
					_d = _dir + orandom((360 / _num) * 0.4);
					
				with(call(scr.chest_create, x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), (chance(1, 4) ? "OrchidChest" : RadChest))){
					if(instance_is(self, RadChest) && chance(1, 6)){
						spr_idle = sprRadChestBig;
						spr_hurt = sprRadChestBigHurt;
						spr_dead = sprRadChestBigDead;
					}
				}
			}
		}
		call(scr.rad_drop, x, y, _rad, random(360), 0);
		
		return self;
	}
	
#define BuriedVaultPedestal_step
	if(image_speed != 0){
		 // Holding Loot:
		if(
			place_meeting(x, y, target)
			&& (!instance_is(target, ProtoChest)  || target.sprite_index != sprProtoChestOpen)
			&& (!instance_is(target, ProtoStatue) || target.my_health >= target.maxhealth * 0.7)
		){
			image_index = 0;
			
			 // Hold Chest:
			if(array_find_index(obj.BuriedVaultChest, target) >= 0){
				target.x     = x;
				target.y     = y;
				target.speed = 0;
			}
		}
		
		 // Loot Taken:
		else if(anim_end){
			image_speed = 0;
			image_index = image_number - 1;
		}
	}
	
	 // Guardians:
	else if(spawn > 0){
		if(spawn_time > 0){
			spawn_time -= current_time_scale;
			if(spawn_time <= 0){
				spawn_time = 10;
				spawn--;
				
				sound_play_pitch(sndCrownGuardianAppear, 1 + random(0.4));
				
				var _inst = noone;
				with(call(scr.instance_random, call(scr.instances_meeting_rectangle, x - 96, y - 96, x + 96, y + 96, instances_matching_ne(Floor, "id", call(scr.instance_nearest_bbox, x, y, Floor))))){
					_inst = instance_create(bbox_center_x, bbox_center_y, CrownGuardian);
					call(scr.portal_poof);
				}
				with(_inst){
					spr_idle = sprCrownGuardianAppear;
					sprite_index = spr_idle;
					
					 // Just in Case:
					call(scr.wall_clear, self);
				}
				
				array_push(spawn_inst, _inst);
			}
		}
		
		 // Begin Spawnage:
		else{
			spawn_time = 30;
			GameCont.buried_vaults = variable_instance_get(GameCont, "buried_vaults", 0) + 1;
			call(scr.portal_poof);
			
			 // Sound/Music:
			sound_play_pitch(sndCrownGuardianDisappear, 0.7 + random(0.2));
			with(MusCont) with(self){
				var _area = GameCont.area;
				GameCont.area = -1;
				event_perform(ev_alarm, 11);
				GameCont.area = _area;
				alarm_set(3, -1);
				alarm_set(4, 1);
			}
		}
	}
	
	 // Proto Statue Charged:
	if(instance_is(target, ProtoStatue) && target.canim > 0){
		image_index = max(0, (image_number - 1) - (0.5 * target.canim));
		image_speed = 0.4;
	}
	
	
#define CatChest_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.CatChest;
		spr_dead = spr.CatChestOpen;
		
		 // Sound:
		snd_open = sndAmmoChest;
		
		on_open = script_ref_create(CatChest_open);
		
		return self;
	}
	
#define CatChest_open
	 // Sound:
	sound_play_pitchvol(sndEnergySword,   0.5 + orandom(0.1), 0.8);
	sound_play_pitchvol(sndLuckyShotProc, 0.8 + orandom(0.1), 0.7);
	
	 // Text:
	if(instance_is(other, Player)){
		var _text = instance_create(x, y, PopupText);
		_text.text   = ChestShop_text;
		_text.alarm1 = 18;
		_text.target = other.index;
	}
	
	 // Clear Walls:
	instance_create(x, y, PortalClear);
	
	 // Shop Pool:
	var	_hard = GameCont.hard,
		_pool = {
			"ammo"         : 1,
			"health"       : 1,
			"rads"         : 1,
			"bonus_ammo"   : 1   * (_hard >= 6),
			"bonus_health" : 1   * (_hard >= 6),
			"soda"         : 0.3 * (_hard >= 10 && mod_exists("mod", "defpack tools")),
			"hammerhead"   : 0.3 * (_hard >= 10),
			"spirit"       : 0.3 * (_hard >= 12),
			"turret"       : 0.7 * (GameCont.loops > 0),
			"coat"         : 0,
			"rogue"        : 0,
			"parrot"       : 0,
			"bone"         : 0,
			"bones"        : 0,
			"red"          : 0
		};
		
	with(Player){
		 // Character-Specific:
		switch(race){
			case "venuz"  : if(!call(scr.unlock_get, "skin:coat venuz")) _pool.coat++; break;
			case "rogue"  : _pool.rogue++;  break;
			case "parrot" : _pool.parrot++; break;
		}
		
		 // Bones:
		if(_hard >= 4){
			if(call(scr.wep_raw, wep) == "crabbone" || call(scr.wep_raw, bwep) == "crabbone"){
				_pool.bone = 0.5;
			}
		}
		if(call(scr.wep_raw, wep) == "scythe" || call(scr.wep_raw, bwep) == "scythe"){
			_pool.bones++;
		}
		
		 // Red Ammo:
		if(
			call(scr.weapon_get, "red", wep)  > 0 ||
			call(scr.weapon_get, "red", bwep) > 0
		){
			_pool.red++;
		}
	}
	
	 // Create Shops:
	var _angOff = 50;
	for(var _ang = -_angOff; _ang <= _angOff; _ang += _angOff){
		var	_len = 28,
			_dir = _ang + 90;
			
		with(call(scr.obj_create, x, y, "ChestShop")){
			x      += lengthdir_x(_len, _dir);
			y      += lengthdir_y(_len, _dir);
			type    = ChestShop_basic;
			creator = other;
			
			 // Decide Item:
			var _drop = call(scr.pool, _pool);
			if(_drop != undefined){
				drop = _drop;
				lq_set(_pool, drop, lq_get(_pool, drop) - 1);
			}
		}
	}
	
	
#macro ChestShop_basic 0
#macro ChestShop_wep   1
#macro ChestShop_skill 2

#define ChestShop_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = mskNone;
		image_speed  = 0.4;
		image_blend  = c_white;
		image_alpha  = 0.7;
		depth        = -8;
		
		 // Vars:
		mask_index = mskWepPickup;
		friction   = 0.4;
		creator    = noone;
		prompt     = call(scr.prompt_create, self);
		shine      = 1/16;
		open_state = 0;
		open       = 1;
		wave       = random(100);
		type       = ChestShop_basic;
		drop       = 0;
		num        = 0;
		text       = "";
		desc       = "";
		soda       = "";
		curse      = false;
		setup      = true;
		
		 // Hide:
		with(prompt){
			visible = false;
		}
		
		return self;
	}
	
#define ChestShop_setup
	setup = false;
	
	 // Default:
	num          = 1;
	text         = "";
	desc         = "";
	sprite_index = sprAmmo;
	image_blend  = c_white;
	
	 // Shop Setup:
	switch(type){
		
		case ChestShop_basic:
		
			 // Loop:
			if(GameCont.loops > 0){
				switch(drop){
					case "ammo"   : drop = "ammo_chest";   break;
					case "health" : drop = "health_chest"; break;
					case "rads"   : drop = "rads_chest";   break;
				}
			}
			
			 // Crowns:
			switch(crown_current){
				
				case crwn_love:
				
					switch(drop){
						case "health"             :
						case "rads"               :
						case "hammerhead"         :
						case "spirit"             :
						case "red"                : drop = "ammo";             break;
						case "health_chest"       :
						case "rads_chest"         : drop = "ammo_chest";       break;
						case "bonus_health"       : drop = "bonus_ammo";       break;
						case "bonus_health_chest" : drop = "bonus_ammo_chest"; break;
					}
					
					break;
					
				case crwn_life:
				
					if(drop == "health"){
						drop = "ammo";
					}
					
					break;
					
				case crwn_guns:
				
					if(drop == "ammo"){
						drop = "health";
					}
					
					break;
					
				case "bonus":
				
					switch(drop){
						case "ammo"         : drop = "bonus_ammo";         break;
						case "ammo_chest"   : drop = "bonus_ammo_chest";   break;
						case "health"       : drop = "bonus_health";       break;
						case "health_chest" : drop = "bonus_health_chest"; break;
					}
					
					break;
					
			}
			
			 // Setup:
			switch(drop){
				
				case "ammo":
				
					num *= 2;
					text = call(scr.loc_format, "NTTE:ChestShop:Ammo:Name", "AMMO");
					desc = call(scr.loc_format, "NTTE:ChestShop:Ammo:Text", "% PICKUPS", num);
					
					 // Visual:
					sprite_index = sprAmmo;
					image_blend  = make_color_rgb(255, 255, 0);
					
					break;
					
				case "health":
				
					num *= 2;
					text = call(scr.loc_format, "NTTE:ChestShop:Health:Name", "HEALTH");
					desc = call(scr.loc_format, "NTTE:ChestShop:Health:Text", "% PICKUPS", num);
					
					 // Visual:
					sprite_index = sprHP;
					image_blend  = make_color_rgb(255, 255, 255);
					
					break;
					
				case "rads":
				
					num *= 25;
					text = call(scr.loc_format, "NTTE:ChestShop:Rads:Name", "RADS");
					desc = call(scr.loc_format, "NTTE:ChestShop:Rads:Text", `% ${text}`, num);
					
					 // Visual:
					sprite_index = sprBigRad;
					image_blend  = make_color_rgb(120, 230, 60);
					
					break;
					
				case "ammo_chest":
				
					text = call(scr.loc_format, "NTTE:ChestShop:AmmoChest:Name", loc("NTTE:ChestShop:Ammo:Name", "AMMO"));
					desc = call(scr.loc_format, "NTTE:ChestShop:AmmoChest:Text", "% CHEST", num);
					
					 // Visual:
					sprite_index = (ultra_get("steroids", 2) ? sprAmmoChestSteroids : sprAmmoChest);
					image_blend  = make_color_rgb(255, 255, 0);
					
					break;
					
				case "health_chest":
				
					text = call(scr.loc_format, "NTTE:ChestShop:HealthChest:Name", loc("NTTE:ChestShop:Health:Name", "HEALTH"));
					desc = call(scr.loc_format, "NTTE:ChestShop:HealthChest:Text", "% CHEST", num);
					
					 // Visual:
					sprite_index = sprHealthChest;
					image_blend  = make_color_rgb(255, 255, 255);
					
					break;
					
				case "rads_chest":
				
					text = call(scr.loc_format, "NTTE:ChestShop:RadsChest:Name", loc("NTTE:ChestShop:Rads:Name", "RADS"));
					desc = call(scr.loc_format, "NTTE:ChestShop:RadsChest:Text", `% ${text}`, 45 * num);
					
					 // Visual:
					sprite_index = sprRadChestBig;
					image_blend  = make_color_rgb(120, 230, 60);
					
					break;
					
				case "bonus_ammo":
				
					text = call(scr.loc_format, "NTTE:ChestShop:BonusAmmo:Name", "OVERSTOCK");
					desc = call(scr.loc_format, "NTTE:ChestShop:BonusAmmo:Text", `@5(${spr.BonusText}:0) AMMO`, num);
					
					 // Visual:
					sprite_index = spr.BonusAmmoPickup;
					image_blend  = make_color_rgb(100, 255, 255);
					
					break;
					
				case "bonus_ammo_chest":
				
					text = call(scr.loc_format, "NTTE:ChestShop:BonusAmmoChest:Name", loc("NTTE:ChestShop:BonusAmmo:Name", "OVERSTOCK"));
					desc = call(scr.loc_format, "NTTE:ChestShop:BonusAmmoChest:Text", "% CHEST", num);
					
					 // Visual:
					sprite_index = (ultra_get("steroids", 2) ? spr.BonusAmmoChestSteroids : spr.BonusAmmoChest);
					image_blend  = make_color_rgb(100, 255, 255);
					
					break;
					
				case "bonus_health":
				
					text = call(scr.loc_format, "NTTE:ChestShop:BonusHealth:Name", "OVERHEAL");
					desc = call(scr.loc_format, "NTTE:ChestShop:BonusHealth:Text", `@5(${spr.BonusText}:0) HEALTH`, num);
					
					 // Visual:
					sprite_index = spr.BonusHealthPickup;
					image_blend  = make_color_rgb(200, 160, 255);
					
					break;
					
				case "bonus_health_chest":
				
					text = call(scr.loc_format, "NTTE:ChestShop:BonusHealthChest:Name", loc("NTTE:ChestShop:BonusHealth:Name", "OVERHEAL"));
					desc = call(scr.loc_format, "NTTE:ChestShop:BonusHealthChest:Text", "% CHEST", num);
					
					 // Visual:
					sprite_index = spr.BonusHealthChest;
					image_blend  = make_color_rgb(200, 160, 255);
					
					break;
					
				case "coat":
				
					text = call(scr.loc_format, "NTTE:ChestShop:Coat:Name", "COAT");
					desc = call(scr.loc_format, "NTTE:ChestShop:Coat:Text", "STYLISH", num);
					
					 // Visual:
					sprite_index = spr.YVCoat;
					image_blend  = make_color_rgb(230, 204, 32);
					
					break;
					
				case "rogue":
				
					text = call(scr.loc_format, "NTTE:ChestShop:Rogue:Name", call(scr.string_delete_nt, loc("Races:12:Active", "PORTAL STRIKE")));
					desc = call(scr.loc_format, "NTTE:ChestShop:Rogue:Text", `% PICKUP`, num);
					
					 // Visual:
					sprite_index = sprRogueAmmo;
					image_blend  = make_color_rgb(140, 180, 255);
					
					break;
					
				case "parrot":
				
					num *= 6;
					text = call(scr.loc_format, "NTTE:ChestShop:Parrot:Name", "FEATHERS");
					desc = call(scr.loc_format, "NTTE:ChestShop:Parrot:Text", `% ${text}`, num);
					
					 // Visual:
					sprite_index = spr.Race.parrot[0].Feather;
					image_blend  = make_color_rgb(255, 120, 120);
					image_xscale = -1.2;
					image_yscale = 1.2;
					
					 // B-Skin:
					with(call(scr.instance_nearest_array, x, y, instances_matching(Player, "race", "parrot"))){
						if(bskin == 1){
							other.image_blend = make_color_rgb(0, 220, 255);
						}
						other.sprite_index = call(scr.race_get_sprite, race, bskin, sprChickenFeather);
					}
					
					break;
					
				case "infammo":
				
					num *= 90;
					text = call(scr.loc_format, "NTTE:ChestShop:InfAmmo:Name", "INFINITE AMMO");
					desc = call(scr.loc_format, "NTTE:ChestShop:InfAmmo:Text", "FOR A MOMENT", num);
					
					 // Visual:
					sprite_index = sprFishA;
					shine        = 1;
					
					break;
					
				case "hammerhead":
				
					text = call(scr.loc_format, "NTTE:ChestShop:HammerHead:Name", `BONUS @(color:${c_yellow})` + loc(`Skills:${mut_hammerhead}:Name`, "HAMMERHEAD"));
					desc = call(scr.loc_format, "NTTE:ChestShop:HammerHead:Text", `+% TILES`, num * 10);
					
					 // Visual:
					sprite_index = spr.HammerHeadPickup;
					image_blend  = make_color_rgb(180, 30, 255);
					
					break;
					
				case "spirit":
				
					text = call(scr.loc_format, "NTTE:ChestShop:Spirit:Name", "BONUS SPIRIT");
					desc = call(scr.loc_format, "NTTE:ChestShop:Spirit:Text", "LIVE FOREVER", num);
					
					 // Visual:
					sprite_index = spr.SpiritPickup;
					image_blend  = make_color_rgb(255, 200, 140);
					
					break;
					
				case "bone":
				
					text = call(scr.loc_format, "NTTE:ChestShop:Bone:Name", loc("NTTE:Bone", "BONE"));
					desc = call(scr.loc_format, "NTTE:ChestShop:Bone:Text", text, num);
					
					 // Visual:
					sprite_index = sprBone;
					image_blend  = make_color_rgb(220, 220, 60);
					
					break;
					
				case "bones":
				
					num *= 30;
					text = call(scr.loc_format, "NTTE:ChestShop:Bones:Name", "BONES");
					desc = call(scr.loc_format, "NTTE:ChestShop:Bones:Text", `% ${text}`, num);
					
					 // Visual:
					sprite_index = spr.BonePickupBig[0];
					image_blend  = make_color_rgb(220, 220, 60);
					
					break;
					
				case "red":
				
					text = call(scr.loc_format, "NTTE:ChestShop:Red:Name", RedAmmo_text);
					desc = call(scr.loc_format, "NTTE:ChestShop:Red:Text", `% PICKUP`, num);
					
					 // Visual:
					sprite_index = spr.RedAmmoPickup;
					image_blend  = make_color_rgb(255, 120, 120);
					
					break;
					
				case "soda":
				
					 // Decide Brand:
					var _list = ["lightning blue lifting drink(tm)", "extra double triple coffee", "expresso", "saltshake", "munitions mist", "vinegar", "guardian juice"];
					if(skill_get(mut_boiling_veins) > 0){
						array_push(_list, "sunset mayo");
					}
					if(array_length(instances_matching(Player, "notoxic", false))){
						array_push(_list, "frog milk");
					}
					soda = _list[irandom(array_length(_list) - 1)];
					
					 // Vars:
					text = call(scr.loc_format, "NTTE:ChestShop:Soda:Name", "SODA");
					desc = call(scr.loc_format, "NTTE:ChestShop:Soda:Text", "%2", num, weapon_get_name(soda));
					
					 // Visual:
					sprite_index = weapon_get_sprt(soda);
					image_blend  = make_color_rgb(220, 220, 220);
					
					break;
					
				case "turret":
				
					text = call(scr.loc_format, "NTTE:ChestShop:Turret:Name", loc("CauseOfDeath:32", "TURRET"));
					desc = call(scr.loc_format, "NTTE:ChestShop:Turret:Text", "EXTRA OFFENSE", num);
					
					 // Visual:
					sprite_index = spr.LairTurretIdle;
					image_blend  = make_color_rgb(200, 160, 180);
					image_xscale = 0.9;
					image_yscale = image_xscale;
					
					break;
					
			}
			
			break;
			
		case ChestShop_wep:
		
			var _merged = call(scr.weapon_has_temerge, drop);
			
			 // Text:
			text = call(scr.loc_format,
				"NTTE:ChestShop:Weapon",
				"%1%2WEAPON",
				(curse   ? loc("NTTE:ChestShop:Weapon:Cursed", "CURSED ") : ""),
				(_merged ? loc("NTTE:ChestShop:Weapon:Merged", "MERGED ") : "")
			);
			desc = weapon_get_name(drop);
			
			 // Visual:
			sprite_index = weapon_get_sprt(drop);
			var _hue = [0, 40, 120, 0, 160, 80];
			if(_merged){
				call(scr.weapon_deactivate_temerge, drop);
				var _stockType = weapon_get_type(drop);
				call(scr.weapon_activate_temerge, drop);
				var _frontType = weapon_get_type(call(scr.weapon_get_temerge_weapon, drop));
				
				if(call(scr.wep_raw, drop) == wep_none){
					_stockType = _frontType;
				}
				else if(call(scr.weapon_has_temerge_weapon, drop, wep_none)){
					_frontType = _stockType;
				}
				
				var	_hueA = _hue[clamp(_stockType, 0, array_length(_hue) - 1)],
					_hueB = _hue[clamp(_frontType, 0, array_length(_hue) - 1)],
					_diff = abs(_hueA - _hueB) % 256;
					
				if(_diff > 128){
					_diff -= 256;
				}
					
				image_blend = merge_color(
					make_color_hsv(
						(min(_hueA, _hueB) + (_diff / 2) + 256) % 256,
						255,
						255
					),
					c_white,
					0.5
				);
			}
			else{
				image_blend = merge_color(
					make_color_hsv(
						_hue[clamp(weapon_get_type(drop), 0, array_length(_hue) - 1)],
						255,
						255
					),
					c_white,
					0.2
				);
			}
			
			 // Cursed:
			if(curse > 0){
				image_blend = merge_color(image_blend, make_color_rgb(255, 0, 255), 0.5);
			}
			
			break;
			
		case ChestShop_skill:
		
			 // Text:
			text = skill_get_name(drop);
			desc = skill_get_text(drop);
			if(string_char_at(desc, string_length(desc)) != "#"){
				desc += "#"; // What the hammerhead??
			}
			desc += loc("NTTE:ChestShop:Temporarily", "@wTEMPORARILY");
			
			 // Visual:
			var _icon = call(scr.skill_get_icon, drop);
			sprite_index = _icon[0];
			image_index  = _icon[1];
			image_speed  = 0;
			image_blend  = make_color_rgb(130, 255, 100);
			
			 // Special Option:
			/*if(
				is_string(drop)
				&& mod_script_exists("skill", drop, "skill_rat")
				&& mod_script_call("skill", drop, "skill_rat")
			){
				image_blend = c_white;
			}*/
			
			break;
			
	}
	image_alpha = -abs(image_alpha);
	
	 // Prompt Text:
	with(prompt){
		text = `${other.text}#@s${other.desc}`;
	}
	
	 // Crown of Crime Bounty:
	if(crown_current == "crime"){
		call(scr.crime_alert, xstart, ystart, 120, 30);
	}
	
#define ChestShop_step
	if(setup) ChestShop_setup();
	
	 // Animate / Shine:
	wave += current_time_scale;
	if(image_index < 1 && shine != 1){
		image_index -= image_speed_raw * (1 - random(shine * current_time_scale));
	}
	
	 // Particles:
	if(chance_ct(1, 8 * ((open > 0) ? 1 : open_state))){
		var	_x = xstart,
			_y = ystart,
			_l = point_distance(_x, _y, x, y),
			_d = point_direction(_x, _y, x, y) + orandom(8);
			
		if(open > 0){
			_l = random(_l);
		}
		else{
			_l = random_range(_l * (1 - open_state), _l);
		}
		
		with(instance_create(_x + lengthdir_x(_l, _d) + orandom(4), _y + lengthdir_y(_l, _d) + orandom(4), BulletHit)){
			motion_add(_d + choose(0, 180), random(0.5));
			if(other.type == ChestShop_skill){
				sprite_index = sprEatRad;
				depth        = other.depth + choose(1, -1);
			}
			else{
				sprite_index = sprLightning;
				image_alpha  = 1.5 * (_l / point_distance(_x, _y, other.x, other.y)) * random(abs(other.image_alpha));
				depth        = other.depth - 1;
			}
			image_blend = other.image_blend;
		}
		
		 // Curse:
		if(curse && chance(1, 5)){
			instance_create(_x + lengthdir_x(_l, _d) + orandom(4), _y + lengthdir_x(_l, _d) + orandom(4), Curse);
		}
	}
	
	 // Open for Business:
	if(instance_exists(prompt)){
		prompt.visible = (open > 0);
	}
	if(open > 0){
		open_state += (1 - open_state) * 0.15 * current_time_scale;
		
		 // Slow Bounty Indicator:
		if(instance_exists(Player)){
			var _dis = 32;
			if(instance_exists(Crown) && distance_to_object(Crown) < _dis){
				var _inst = instances_matching_ne(Crown, "ntte_crime_alert", null);
				if(array_length(_inst)){
					with(_inst){
						if(array_length(instances_matching_ne(ntte_crime_alert, "id"))){
							if(distance_to_object(other) < _dis){
								speed = 0;
							}
						}
					}
				}
			}
		}
		
		 // No Customers:
		else if(open_state >= 1){
			open = 0;
		}
		
		 // Take Item:
		var _p = (
			instance_exists(prompt)
			? player_find(prompt.pick)
			: noone
		);
		if(!instance_exists(_p) && instance_exists(PortalShock) && place_meeting(x, y, PortalShock)){
			with(call(scr.instances_meeting_instance, self, PortalShock)){
				if(place_meeting(x, y, other)){
					var	_disMax  = infinity,
						_nearest = other;
						
					with(call(scr.instances_meeting_instance, self, instances_matching_gt(obj.ChestShop, "open", 0))){
						var _dis = point_distance(x, y, other.x, other.y);
						if(_dis < _disMax){
							_disMax  = _dis;
							_nearest = self;
						}
					}
					
					if(_nearest == other){
						_p = instance_nearest(other.x, other.y, Player);
						break;
					}
				}
			}
		}
		if(instance_exists(_p)){
			var	_x      = xstart,
				_y      = ystart - 4,
				_num    = num,
				_numDec = 1;
				
			 // Ambidextrous:
			if(type == ChestShop_wep){
				_num += ultra_get("steroids", 1);
			}
			
			while(_num > 0){
				_numDec = 1;
				switch(type){
					
					case ChestShop_basic:
					
						switch(drop){
							
							case "ammo":
							
								instance_create(_x + orandom(2), _y + orandom(2), AmmoPickup);
								
								break;
								
							case "health":
							
								instance_create(_x + orandom(2), _y + orandom(2), HPPickup);
								
								break;
								
							case "rads":
							
								_numDec = _num;
								with(call(scr.rad_drop, _x, _y, _num, random(360), 4)){
									depth--;
								}
								
								break;
								
							case "ammo_chest":
							
								instance_create(_x, _y - 2, AmmoChest);
								repeat(3) call(scr.fx, _x, _y, [90 + orandom(60), 4], Dust);
								instance_create(_x, _y, FXChestOpen);
								sound_play_pitchvol(sndChest, 0.6 + random(0.2), 3);
								
								break;
								
							case "health_chest":
							
								instance_create(_x, _y - 2, HealthChest);
								repeat(3) call(scr.fx, _x, _y, [90 + orandom(60), 4], Dust);
								instance_create(_x, _y, FXChestOpen);
								sound_play_pitchvol(sndHealthChest, 0.8 + random(0.2), 1.5);
								
								break;
								
							case "rads_chest":
							
								with(instance_create(_x, _y - 6, RadChest)){
									spr_idle = sprRadChestBig;
									spr_hurt = sprRadChestBigHurt;
									spr_dead = sprRadChestBigDead;
									instance_create(x, y, ExploderExplo);
								}
								sound_play_pitch(sndRadMaggotDie, 0.6 + random(0.2));
								
								break;
								
							case "bonus_ammo":
							
								with(call(scr.obj_create, _x, _y, "BonusAmmoPickup")) pull_delay = 0;
								instance_create(_x, _y, GunWarrantEmpty);
								
								break;
								
							case "bonus_ammo_chest":
							
								call(scr.obj_create, _x, _y - 2, "BonusAmmoChest");
								repeat(3) call(scr.fx, _x, _y, [90 + orandom(60), 4], Dust);
								instance_create(_x, _y, GunWarrantEmpty);
								sound_play_pitchvol(sndChest, 0.6 + random(0.2), 3);
								
								break;
								
							case "bonus_health":
							
								with(call(scr.obj_create, _x, _y, "BonusHealthPickup")) pull_delay = 0;
								instance_create(_x, _y, GunWarrantEmpty);
								
								break;
								
							case "bonus_health_chest":
							
								call(scr.obj_create, _x, _y - 2, "BonusHealthChest");
								repeat(3) call(scr.fx, _x, _y, [90 + orandom(60), 4], Dust);
								instance_create(_x, _y, GunWarrantEmpty);
								sound_play_pitchvol(sndHealthChest, 0.8 + random(0.2), 1.5);
								
								break;
								
							case "coat":
							
								call(scr.unlock_set, "skin:coat venuz", true);
								with(_p){
									if(race == "venuz"){
										bskin = "coat venuz";
										player_set_skin(index, bskin);
										sprite_index = spr_hurt;
										image_index  = 0;
										sound_play(snd_chst);
										repeat(2){
											with(instance_create(x + orandom(8), y + orandom(8), CaveSparkle)){
												depth = other.depth - 1;
											}
										}
									}
								}
								with(instance_create(_x, _y, WepPickup)){
									wep  = call(scr.wep_skin, wep_golden_revolver, "venuz", "coat venuz");
									ammo = true;
								}
								sound_play(sndMenuASkin);
								
								break;
								
							case "rogue":
							
								with(instance_create(_x + orandom(2), _y + orandom(2), RoguePickup)){
									motion_add(point_direction(x, y, _p.x, _p.y), 3);
								}
								
								break;
								
							case "parrot":
							
								_numDec = _num;
								with(call(scr.obj_create, _x, _y, "ParrotChester")){
									num = _num;
								}
								
								break;
								
							case "infammo":
							
								_numDec = _num;
								with(_p){
									infammo = _num;
									reload = max(reload, 1);
								}
								
								break;
								
							case "hammerhead":
							
								call(scr.obj_create, _x, _y, "HammerHeadPickup");
								instance_create(_x, _y, Hammerhead);
								
								break;
								
							case "spirit":
							
								call(scr.obj_create, _x, _y, "SpiritPickup");
								instance_create(_x, _y, ImpactWrists);
								
								break;
								
							case "bone":
							
								with(instance_create(_x, _y, WepPickup)){
									motion_set(point_direction(x, y, _p.x, _p.y) + orandom(8), 4);
									ammo = true;
									wep  = "crabbone";
								}
								instance_create(_x, _y, Dust);
								sound_play_pitchvol(sndBloodGamble, 0.8, 1);
								
								break;
								
							case "bones":
							
								_numDec = ((_num > 10) ? 10 : 1);
								with(call(scr.obj_create, _x, _y, ((_num > 10) ? "BoneBigPickup" : "BonePickup"))){
									motion_set(random(360), 3 + random(1));
								}
								
								break;
								
							case "red":
							
								call(scr.obj_create, _x, _y, "RedAmmoPickup");
								call(scr.obj_create, _x, _y, "CrystalBrainEffect");
								
								break;
								
							case "soda":
							
								with(instance_create(_x, _y, WepPickup)){
									motion_set(point_direction(x, y, _p.x, _p.y) + orandom(8), 5);
									ammo = true;
									wep  = other.soda;
								}
								repeat(16) with(instance_create(_x, _y, Shell)){
									sprite_index = sprSodaCan;
									image_index  = irandom(image_number - 1);
									image_speed  = 0;
									depth        = -1;
									motion_add(random(360), 2 + random(3));
								}
								sound_play_pitch(sndSodaMachineBreak, 1 + orandom(0.3));
								
								break;
								
							case "turret":
							
								with(instance_create(_x, _y - 4, Turret)){
									x          = xstart;
									y          = ystart;
									maxhealth *= 2;
									my_health *= 2;
									depth      = -3;
									
									with(call(scr.charm_instance, self, true)){
										time = 900;
										kill = true;
									}
								}
								
								break;
								
						}
						
						 // Effects:
						instance_create(_x, _y, WepSwap);
						sound_play_pitchvol(sndGunGun,    1.2 + random(0.4), 0.5);
						sound_play_pitchvol(sndAmmoChest, 0.5 + random(0.2), 0.8);
						
						break;
						
					case ChestShop_wep:
					
						var	_wep  = undefined,
							_drop = drop;
							
						 // Generate Merged Weapon:
						while(true){
							var _dropWep = call(scr.wep_raw, _drop);
							if(_dropWep == wep_none){
								_dropWep = call(scr.wep_raw, _p.wep);
							}
							_wep = (
								(_wep == undefined)
								? _dropWep
								: call(scr.weapon_add_temerge, _wep, _dropWep)
							);
							if(call(scr.weapon_has_temerge, _drop)){
								_drop = call(scr.weapon_get_temerge_weapon, _drop);
							}
							else break;
						}
						
						 // Weapon:
						with(instance_create(_x, _y, WepPickup)){
							motion_set(point_direction(x, y, _p.x, _p.y) + orandom(8), 5);
							ammo  = true;
							curse = other.curse;
							wep   = _wep;
						}
						
						 // Effects:
						sound_play(weapon_get_swap(_wep));
						sound_play_pitchvol(sndGunGun,           0.8 + random(0.4), 0.6);
						sound_play_pitchvol(sndPlasmaBigExplode, 0.6 + random(0.2), 0.8);
						if(curse > 0){
							sound_play_pitchvol(sndCursedPickup, 1 + orandom(0.2), 1.4);
						}
						instance_create(_x, _y, GunGun);
						
						break;
						
					case ChestShop_skill:
					
						_numDec = _num;
						
						 // Mutation:
						with(call(scr.obj_create, _x, _y, "OrchidBall")){
							skill      = other.drop;
							num        = _num;
							type       = "portal";
							creator    = other.creator;
							direction  = point_direction(other.x, other.y, _x, _y);
							direction += (90 * sign(angle_difference(90, direction))) + orandom(30);
						}
						
						 // Rads:
						var _rad = 25 * _num;
						if(_rad > 0) repeat(_rad){
							with(instance_create(_x, _y, Rad)){
								motion_add(random(360), random(5));
							}
						}
						
						 // Effects:
						with(instance_create(_x, _y, BulletHit)){
							sprite_index = sprGuardianBulletHit;
						}
						
						 // Sound:
						sound_play_pitchvol(sndNothingSmallball, 1.4 + orandom(0.1), 2/3);
						sound_play_pitchvol(sndMut,              0.7 +  random(0.1), 1.5);
						
						break;
						
				}
				_num -= _numDec;
			}
			
			 // Text:
			if(text != ""){
				with(pickup_text(text)){
					if(instance_exists(other.prompt)){
						target = other.prompt.pick;
					}
				}
			}
			if(desc != ""){
				with(pickup_text(desc + "@w", "got")){
					if(instance_exists(other.prompt)){
						target = other.prompt.pick;
					}
				}
			}
			
			 // Sounds:
			sound_play_pitchvol(sndGammaGutsProc, 1.4 + random(0.1), 0.6);
			
			 // Remove other options:
			with(instances_matching(obj.ChestShop, "creator", creator)){
				if(creator != noone || self == other){
					if(--open <= 0){
						open_state += random(1/3);
					}
				}
			}
			open_state = 3/4;
			open       = 0;
			
			 // Crown of Crime Bounty:
			if(crown_current == "crime"){
				GameCont.ntte_crime_active = true;
				
				 // Bounty UP:
				if("ntte_crime_bounty" not in GameCont){
					GameCont.ntte_crime_bounty = 0;
				}
				if(GameCont.ntte_crime_bounty < 3){
					GameCont.ntte_crime_bounty = min(GameCont.ntte_crime_bounty + 1, 3);
					if(GameCont.ntte_crime_bounty >= 3 && player_count_race(char_eyes) > 0){
						call(scr.unlock_set, "skin:bat eyes", true);
					}
				}
				
				 // Display Bounty:
				with(call(scr.crime_alert, xstart, ystart, 60, 15)[1]){
					flash     = max(flash, 6);
					snd_flash = sndCrownRandom;
				}
				
				/*with(instances_matching(Crown, "ntte_crown", crown_current)){
					enemy_time = 30;
					enemies += (1 + GameCont.loops) + irandom(min(3, GameCont.hard - 1));
				}*/
			}
		}
	}
	
	 // Close Up Shop:
	else{
		open_state -= 0.04 * current_time_scale;
		if(open_state <= 0){
			instance_destroy();
		}
	}
	
#define ChestShop_draw
	image_alpha = abs(image_alpha);
	
	var	_openState = clamp(open_state, 0, 1),
		_spr       = sprite_index,
		_img       = image_index,
		_xsc       = image_xscale * max((open > 0) * 0.8, _openState),
		_ysc       = image_yscale * max((open > 0) * 0.8, _openState),
		_ang       = image_angle + (8 * sin(wave / 12)),
		_col       = merge_color(c_black, image_blend, _openState),
		_alp       = image_alpha,
		_x         = x,
		_y         = y;
		
	if(type == ChestShop_basic && x < xstart){
		_xsc *= -1;
	}
	
	 // Projector Beam:
	var	_sx = xstart,
		_sy = ystart,
		_d  = point_direction(_sx, _sy, _x, _y);
		
	//_d = angle_lerp(_d, 90, 1 - clamp(open_state, 0, 1));
	
	var	_w  = point_distance(_sx, _sy, _x, _y) * ((open > 0) ? _openState : min(_openState * 3, 1)),
		_h  = ((sqrt(sqr(sprite_get_width(_spr) * image_xscale * dsin(_d)) + sqr(sprite_get_height(_spr) * image_yscale * dcos(_d))) * 2/3) + random(2)) * max(0, (_openState - 0.5) * 2),
		_x1 = _sx + lengthdir_x(0.5, _d),
		_y1 = _sy + lengthdir_y(1,   _d),
		_x2 = _sx + lengthdir_x(_w, _d) + lengthdir_x(_h / 2, _d - 90),
		_y2 = _sy + lengthdir_y(_w, _d) + lengthdir_y(_h / 2, _d - 90),
		_x3 = _sx + lengthdir_x(_w, _d) - lengthdir_x(_h / 2, _d - 90),
		_y3 = _sy + lengthdir_y(_w, _d) - lengthdir_y(_h / 2, _d - 90);
		
	if(type == ChestShop_wep){
		_y2 = max(_y + 2, _y2);
		_y3 = max(_y + 2, _y3);
	}
	
	_x = _sx + lengthdir_x(_w, _d);
	_y = _sy + lengthdir_y(_w, _d);
	
	draw_set_blend_mode(bm_add);
	draw_set_color(merge_color(_col, c_blue, 0.4));
	
	 // Main:
	draw_primitive_begin(pr_trianglestrip);
	
	draw_set_alpha(_alp);
	draw_vertex(_x1, _y1);
	draw_set_alpha(_alp / 8);
	draw_vertex(_x2, _y2);
	draw_vertex(_x3, _y3);
	
	draw_primitive_end();
	
	 // Side Lines:
	draw_primitive_begin(pr_linestrip);
	
	draw_set_alpha(_alp / 3);
	draw_vertex(_x2, _y2);
	draw_set_alpha(0);
	draw_vertex(_x1, _y1);
	draw_set_alpha(_alp / 3);
	draw_vertex(_x3, _y3);
	
	draw_primitive_end();
	
	draw_set_alpha(1);
	draw_set_blend_mode(bm_normal);
	
	 // Projected Object:
	_x -= ((sprite_get_width(_spr) / 2) - sprite_get_xoffset(_spr)) * _xsc;
	_y += sin(wave / 20);
	
	draw_set_color_write_enable(true, true, false, true);
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	draw_set_color_write_enable(true, true, true, true);
	
	draw_set_blend_mode_ext(bm_src_alpha, bm_one);
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, merge_color(_col, c_black, 0.5 + (0.1 * sin(wave / 8))), image_alpha * 1.5);
	draw_set_blend_mode(bm_normal);
	
	 // CustomObject:
	image_alpha = -abs(image_alpha);
	
	
#define CursedAmmoChest_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.CursedAmmoChest;
		spr_dead     = spr.CursedAmmoChestOpen;
		
		 // Sound:
		snd_open = sndAmmoChest;
		
		 // Vars:
		num = 10;
		
		 // Get Loaded:
		if(ultra_get("steroids", 2)){
			sprite_index = spr.CursedAmmoChestSteroids;
			spr_dead = spr.CursedAmmoChestSteroidsOpen;
			num *= 2;
		}
		
		 // Events:
		on_step = script_ref_create(CursedAmmoChest_step);
		on_open = script_ref_create(CursedAmmoChest_open);
		
		return self;
	}

#define CursedAmmoChest_step
	if(chance_ct(1, 12)){
		with(instance_create(x + orandom(4), y - 2 + orandom(4), Curse)){
			depth = other.depth - 1;
		}
	}

#define CursedAmmoChest_open
	sound_play(sndCursedChest);
	instance_create(x, y, PortalClear);
	instance_create(x, y, ReviveFX);
	repeat(num){
		with(call(scr.obj_create, x + orandom(4), y + orandom(4), "BackpackPickup")){
			target = instance_create(x, y, AmmoPickup);
			with(target){
				sprite_index = sprCursedAmmo;
				cursed = true;
				num = 1.5;
				
				 // Shorten Timer:
				alarm0 = pickup_alarm(120 + random(30), 1/5);
			}
			
			 // Spread Out:
			var s = random_range(1.5, 2);
			speed *= s;
			zspeed *= s - 0.5;

			 // Effects:
			with(instance_create(x, y, Curse)){
				depth = other.depth - 1;
				motion_add(other.direction, random(s));
			}
			
			with(self){
				event_perform(ev_step, ev_step_end);
			}
		}
	}


#define CursedMimic_create(_x, _y)
	/*
		A cursed variant of the Mimic, don't touch it bro......
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomMimic")){
		 // Visual:
		spr_idle = spr.CursedMimicIdle;
		spr_walk = spr.CursedMimicFire;
		spr_hurt = spr.CursedMimicHurt;
		spr_dead = spr.CursedMimicDead;
		spr_chrg = spr.CursedMimicTell;
		hitid    = [spr_walk, "CURSED MIMIC"];
		
		 // Vars:
		maxhealth   = 12;
		raddrop     = 16;
		meleedamage = 4;
		num         = 4;
		
		 // Events:
		on_step  = script_ref_create(CursedMimic_step);
		on_melee = script_ref_create(CursedMimic_melee);
		
		return self;
	}
	
#define CursedMimic_step
	 // Curse FX:
	if(chance_ct(1, 12)){
		with(instance_create(x + orandom(4), y - 2 + orandom(4), Curse)){
			depth = other.depth - 1;
		}
	}
	
	 // Inherit:
	CustomMimic_step();
	
#define CursedMimic_melee
	 // Curse:
	if(other.curse <= 0){
		other.curse++;
		sound_play(sndBigCursedChest);
	}
	
#define CursedMimic_death
	 // Sound:
	sound_play_hit(sndCursedChest, 0.1);
	
	 // Pickups:
	var _minID = instance_max;
	repeat(num){
		pickup_drop(100 / pickup_chance_multiplier, 0);
	}
	
	 // Make Dropped Ammo Cursed:
	with(instances_matching_lt(instances_matching_gt(AmmoPickup, "id", _minID), "cursed", 1)){
		sprite_index = sprCursedAmmo;
		cursed       = true;
		num          = 1 + (0.5 * cursed);
		alarm0       = pickup_alarm(200 + random(30), 1/5) / (1 + (2 * cursed));
		
		 // Spread Out:
		var _s = random_range(1, 1.5);
		with(call(scr.obj_create, x, y, "BackpackPickup")){
			target  = other;
			speed  *= _s;
			zspeed *= _s - 0.5;
		}
	}
	
	
#define CustomChest_create(_x, _y)
	/*
		A basic customizable chestprop object
	*/
	
	with(instance_create(_x, _y, chestprop)){
		 // Visual:
		sprite_index = sprAmmoChest;
		spr_dead     = sprAmmoChestOpen;
		spr_open     = sprFXChestOpen;
		
		 // Sound:
		snd_open = sndAmmoChest;
		
		 // Vars:
		nochest = 0; // Adds to GameCont.nochest if not grabbed
		
		 // Events:
		on_step = undefined;
		on_open = undefined;
		
		return self;
	}
	
#define CustomChest_step
	 // Call Custom Step Event:
	if(is_array(on_step)){
		mod_script_call(on_step[0], on_step[1], on_step[2]);
	}
	
	 // Open Chest:
	var _meet = [Player, PortalShock];
	for(var i = 0; i < 2; i++){
		if(place_meeting(x, y, _meet[i])){
			with(instance_nearest(x, y, _meet[i])) with(other){
				 // Hatred:
				if(crown_current == crwn_hatred){
					repeat(16) with(instance_create(x, y, Rad)){
						motion_add(random(360), random_range(2, 6));
					}
					if(instance_is(other, Player)){
						projectile_hit(other, 1);
					}
				}
				
				 // Call Custom Open Event:
				if(is_array(on_open)){
					mod_script_call(on_open[0], on_open[1], on_open[2]);
				}
				
				 // Effects:
				if(sprite_exists(spr_dead)){
					with(instance_create(x, y, ChestOpen)){
						sprite_index = other.spr_dead;
					}
				}
				if(sprite_exists(spr_open)){
					with(instance_create(x, y, FXChestOpen)){
						sprite_index = other.spr_open;
					}
				}
				sound_play(snd_open);
				
				instance_destroy();
				exit;
			}
		}
	}
	
	 // Increase Big Weapon Chest Chance if Skipped:
	if(nochest != 0){
		with(GameCont){
			if(fork()){
				var _add = other.nochest;
				wait 0;
				if(!instance_exists(other) && instance_exists(self)){
					if(instance_exists(GenCont) || instance_exists(LevCont)){
						nochest += _add;
					}
				}
				exit;
			}
		}
	}
	
	
#define CustomMimic_create(_x, _y)
	/*
		A basic customizable Mimic object
	*/
	
	with(instance_create(_x, _y, CustomEnemy)){
		 // Visual:
		spr_idle   = sprMimicIdle;
		spr_walk   = sprMimicFire;
		spr_hurt   = sprMimicHurt;
		spr_dead   = sprMimicDead;
		spr_chrg   = sprMimicTell;
		spr_shadow = shd24;
		hitid      = 49;
		
		 // Sound:
		snd_hurt = sndMimicHurt;
		snd_dead = sndMimicDead;
		snd_mele = sndMimicMelee;
		snd_tell = sndMimicSlurp;
		
		 // Vars:
		mask_index    = -1;
		raddrop       = 6;
		size          = 1;
		maxspeed      = 2;
		meleedamage   = 3;
		tell_wait_min = 90;
		tell_wait_max = 240;
		
		 // Alarms:
		alarm1 = random_range(tell_wait_min, tell_wait_max);
		
		 // Events:
		on_melee = undefined;
		
		return self;
	}
	
#define CustomMimic_step
	 // Alarms:
	if(alarm1_run) exit;
	
	 // Clamp Speed:
	if(speed > maxspeed){
		speed = maxspeed;
	}
	
	 // Animate:
	if(sprite_index != spr_chrg || anim_end){
		sprite_index = enemy_sprite;
	}
	if(sprite_index == spr_hurt && enemy_target(x, y) && target_distance < 48){
		sprite_index = spr_walk;
	}
	
#define CustomMimic_end_step
	 // Custom Code on Contact:
	if(on_melee != undefined && place_meeting(x, y, Player)){
		with(instances_matching(call(scr.instances_meeting_instance, self, Player), "lasthit", hitid)){
			if(place_meeting(x, y, other)){
				if(sprite_index == spr_hurt && image_index == 0){
					with(other){
						mod_script_call(on_melee[0], on_melee[1], on_melee[2]);
					}
				}
			}
		}
	}
	
#define CustomMimic_alrm1
	alarm1 = random_range(tell_wait_min, tell_wait_max);
	
	 // Subtle Tell:
	sprite_index = spr_chrg;
	image_index  = 0;
	sound_play_hit(snd_tell, 0.1);
	
	
#define CustomPickup_create(_x, _y)
	/*
		A basic customizable Pickup object
		
		Vars:
			shine      - Randomized animation speed multiplier for the sprite's first frame, use 1 to animate normally
			spr_open   - The sprite that plays when opened by a Player
			spr_fade   - The sprite that plays after disappearing
			snd_open   - The sound that plays when opened by a Player
			snd_fade   - The sound that plays after disappearing
			mask_index - The hitbox, use mskPickup to collide with Ammo/HP-style pickups
			num        - General multiplier for what it gives to Players
			blink      - How many times it can blink on or off before disappearing
			alarm0     - The number of frames before blinking starts
			pull_dis   - The range in which it gets attracted to Players
			pull_spd   - The speed at which it moves toward Players
			on_step    - Script reference, called every frame for general code
			on_pull    - Script reference, called to determine if the pickup should attract toward a given Player (other=Player)
			on_open    - Script reference, called when the pickup is opened by a Player or Portal (other=Player/Portal)
			on_fade    - Script reference, called when the pickup disappears
	*/
	
	with(instance_create(_x, _y, Pickup)){
		 // Visual:
		sprite_index = sprAmmo;
		spr_open     = sprSmallChestPickup;
		spr_fade     = sprSmallChestFade;
		image_speed  = 0.4;
		shine        = 0.1;
		
		 // Sound:
		snd_open = sndAmmoPickup;
		snd_fade = sndPickupDisappear;
		
		 // Vars:
		mask_index = mskPickup;
		friction   = 0.2;
		num        = 1;
		blink      = 30;
		alarm0     = pickup_alarm(200 + random(30), 1/5);
		pull_dis   = 40 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd   = 6;
		
		 // Events:
		on_step = undefined;
		on_pull = script_ref_create(CustomPickup_pull);
		on_open = undefined;
		on_fade = undefined;
		
		return self;
	}
	
#define CustomPickup_pull
	return true;
	
#define CustomPickup_step
	 // Animate:
	if(image_index < 1 && shine != 1){
		image_index -= image_speed_raw * (1 - random(shine * current_time_scale));
	}
	
	 // Fading:
	if(alarm0 >= 0 && --alarm0 == 0){
		 // Blink:
		if(blink >= 0){
			blink--;
			alarm0 = 2;
			visible = !visible;
		}
		
		 // Fade:
		else{
			 // Call Fade Event:
			if(is_array(on_fade)){
				mod_script_call(on_fade[0], on_fade[1], on_fade[2]);
			}
			
			 // Effects:
			if(sprite_exists(spr_fade)){
				with(instance_create(x, y, SmallChestFade)){
					sprite_index = other.spr_fade;
					image_xscale = other.image_xscale;
					image_yscale = other.image_yscale;
					image_angle  = other.image_angle;
				}
			}
			sound_play_hit(snd_fade, 0.1);
			
			instance_destroy();
			exit;
		}
	}
	
	 // Call Custom Step Event:
	if(is_array(on_step)){
		mod_script_call(on_step[0], on_step[1], on_step[2]);
	}
	
	 // Attraction:
	if(is_array(on_pull)){
		var	_disMax  = (instance_exists(Portal) ? infinity : pull_dis),
			_nearest = noone;
			
		 // Find Nearest Attractable Player:
		with(Player){
			var _dis = point_distance(x, y, other.x, other.y);
			if(_dis < _disMax){
				with(other){
					if(mod_script_call(on_pull[0], on_pull[1], on_pull[2])){
						_disMax  = _dis;
						_nearest = other;
					}
				}
			}
		}
		
		 // Move:
		if(_nearest != noone){
			var	_l = pull_spd * current_time_scale,
				_d = point_direction(x, y, _nearest.x, _nearest.y),
				_x = x + lengthdir_x(_l, _d),
				_y = y + lengthdir_y(_l, _d);
				
			if(place_free(_x, y)) x = _x;
			if(place_free(x, _y)) y = _y;
		}
	}
	
	 // Pickup Collision:
	if(mask_index == mskPickup && place_meeting(x, y, Pickup)){
		with(call(scr.instances_meeting_instance, self, instances_matching(Pickup, "mask_index", mskPickup))){
			if(place_meeting(x, y, other)){
				if(object_index == AmmoPickup || object_index == HPPickup || object_index == RoguePickup){
					motion_add_ct(point_direction(other.x, other.y, x, y) + orandom(10), 0.8);
				}
				with(other){
					motion_add_ct(point_direction(other.x, other.y, x, y) + orandom(10), 0.8);
				}
			}
		}
	}
	
	 // Wall Collision:
	if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
		if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
		if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
	}
	
	
#define HammerHeadChest_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.HammerHeadChest;
		spr_open     = sprHammerHead;
		spr_dead     = spr.HammerHeadChestOpen;
		spr_halo     = spr.HammerHeadChestEffectSpawn;
		img_halo     = 0;
		
		 // Sounds:
		snd_open = sndBigWeaponChest;
		
		 // Vars:
		num = 20;
		
		 // Events:
		on_step = script_ref_create(HammerHeadChest_step);
		on_open = script_ref_create(HammerHeadChest_open);
		 
		return self;
	}
	
#define HammerHeadChest_step
	img_halo += 0.4 * current_time_scale;
	if(img_halo >= sprite_get_number(spr_halo)){
		img_halo %= sprite_get_number(spr_halo);
		spr_halo = spr.HammerHeadChestEffect;
	}
	
#define HammerHeadChest_draw
	draw_sprite(spr_halo, img_halo, x, y);
	
#define HammerHeadChest_open
	 // Hammer Time:
	if(instance_is(other, Player)){
		HammerHeadPickup_open();
	}
	
	 // Pickups:
	else if(num > 0){
		repeat(ceil(num / 10)){
			call(scr.obj_create, x, y, "HammerHeadPickup");
		}
	}
	
	 // Effects:
	sound_play(sndHammerHeadProc);
	sleep(20);
	
	
#define HammerHeadPickup_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = spr.HammerHeadPickup;
		spr_open     = sprHammerHead;
		spr_fade     = sprHammerHead;
		spr_halo     = spr.HammerHeadPickupEffectSpawn;
		img_halo     = 0;
		
		 // Sounds:
		snd_open = sndLuckyShotProc;
		snd_fade = sndHammerHeadEnd;
		
		 // Vars:
		num      = 10 + (crown_current == crwn_haste);
		pull_dis = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd = 4;
		
		 // Events:
		on_step = script_ref_create(HammerHeadPickup_step);
		on_open = script_ref_create(HammerHeadPickup_open);
		on_fade = script_ref_create(HammerHeadPickup_fade);
		
		return self;
	}
	
#define HammerHeadPickup_step
	 // Animate Indicator:
	img_halo += image_speed_raw;
	if(img_halo >= sprite_get_number(spr_halo)){
		img_halo %= sprite_get_number(spr_halo);
		spr_halo = spr.HammerHeadPickupEffect;
	}
	
#define HammerHeadPickup_draw
	draw_sprite(spr_halo, img_halo, x, y);
	
#define HammerHeadPickup_open
	var _num = num;
	
	 // Hammer Time:
	with(instance_is(other, Player) ? other : Player){
		hammerhead += _num;
		
		 // Text:
		var _hammerText = `@(color:${c_yellow})` + loc(`Skills:${mut_hammerhead}:Name`, "HAMMERHEAD");
		pickup_text(_hammerText, "add", _num);
	}
	
	 // Effects:
	sound_play(sndHammerHeadProc);
	sleep(20); // i am karmelyth now
	
#define HammerHeadPickup_fade
	 // Effects:
	repeat(1 + irandom(2)){
		call(scr.fx, x, y, random(2), Smoke);
	}
	sound_play_hit(sndBurn, 0.4);
	
	
#define HugeWeaponChest_create(_x, _y)
	/*
		A larger than usual weapon chest
		The only way to acquire the ultra quasar rifle
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.HugeWeaponChest;
		spr_dead     = spr.HugeWeaponChestOpen;
		spr_shadow   = shd64;
		spr_shadow_y = 4;
		depth        = -1;
		
		 // Sounds:
		snd_open = sndBigWeaponChest;
		
		 // Vars:
		wep     = "ultra quasar rifle";
		curse   = false;
		nochest = 2;
		
		 // Events:
		on_open = script_ref_create(HugeWeaponChest_open);
		
		 // Clear Walls:
		instance_create(x, y, PortalClear);
		
		return self;
	}
	
#define HugeWeaponChest_open
	 // Clear Big Chest Chance:
	GameCont.nochest = 0;
	
	 // Effects:
	with(instance_create(x, y - 12, FXChestOpen)){
		sprite_index = sprMutant6Dead;
		image_index  = 11;
	}
	view_shake_at(x, y, 30);
	sleep(30);
	
	 // Clear Walls:
	with(instance_create(x, y, PortalClear)){
		image_xscale = 1.5;
		image_yscale = image_xscale;
	}
	
	 // Sounds:
	if(instance_is(other, Player)){
		sound_play(other.snd_chst);
	}
	
	 // Dusty Filthy Chest:
	call(scr.unlock_set, "race:beetle", true);
	
	 // The Definitive Gun:
	var _y = y;
	repeat(1 + ultra_get("steroids", 1)){
		with(instance_create(x, _y--, WepPickup)){
			ammo  = true;
			curse = other.curse;
			wep   = other.wep;
		}
	}
	
//	weapon_get_list(_list, 0, GameCont.hard);
//	var	_size = ds_list_size(_list),
//		_num  = (_unlock ? 3 : 5),
//		_egg  = !_unlock;
//		
//	 // Extras:
//	if(_size > 0){
//		ds_list_shuffle(_list);
//		
//		for(var i = 0; i < _size; i++){
//			var w = ds_list_find_value(_list, i);
//			if(weapon_get_gold(w) != 0 || weapon_get_rads(w) > 0){
//				with(instance_create(x, y, WepPickup)){
//					wep = w;
//				}
//				
//				_egg = false;
//				if(--_num <= 0) break;
//			}
//		}
//	}
//		
//	 // Consolation Prize
//	if(_egg){
//		with(instance_create(x, y, WepPickup)){
//			wep = wep_eggplant;
//		}
//	}
//	
//	ds_list_destroy(_list);
	
	
#define OrchidBall_create(_x, _y)
	/*
		The Orchid pet's mutation projectile
		
		Args:
			spr_sparkle - The sparkle effect's sprite
			trail_col   - The trail's color
			flash       - How many frames to draw in flat white
			maxspeed    - How fast the ball can travel
			skill       - The mutation to give, automatically decided by default
			num         - The value of the mutation
			time        - The lifespan of the given mutation, use 0 for default
			target      - The instance to fly towards
			target_seek - True/false can fly toward the target, gets set to 'true' when not moving
			creator     - Who created this ball, bro
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		sprite_index = -1;
		image_speed  = 0.5;
		depth        = -9;
		spr_sparkle  = -1;
		trail_col    = -1;
		flash        = 3;
		
		 // Vars:
		mask_index   = mskSuperFlakBullet;
		image_xscale = 1.5;
		image_yscale = image_xscale;
		friction     = 0.6;
		direction    = random(360);
		speed        = 8;
		maxspeed     = 10;
		skill        = mut_none;
		num          = 1;
		type         = "basic";
		time         = 0;
		target       = instance_nearest(x, y, Player);
		target_seek  = false;
		portal_inst  = noone;
		creator      = noone;
		setup        = true;
		
		return self;
	}
	
#define OrchidBall_setup
	setup = false;
	
	 // Type-Specific Setup:
	switch(type){
		
		case "portal":
		
			if(sprite_index == -1) sprite_index = spr.RadSkillBall;
			if(spr_sparkle  == -1) spr_sparkle  = sprEatBigRadPlut;
		//	if(trail_col    == -1) trail_col    = make_color_rgb(68, 197, 22);
			
			break;
			
		case "red":
		
			if(sprite_index ==  -1) sprite_index = spr.RedSkillBall;
			if(spr_sparkle  ==  -1) spr_sparkle  = sprLaserCharge;
			if(friction     == 0.6) friction     = 0.3;
			
			break;
			
		default: // Basic
		
			if(sprite_index == -1) sprite_index = spr.PetOrchidBall;
			if(spr_sparkle  == -1) spr_sparkle  = spr.VaultFlowerSparkle;
			if(trail_col    == -1) trail_col    = make_color_rgb(128, 104, 34); // make_color_rgb(84, 58, 24);
			
			 // Enable Orchid Chest Spawning:
			call(scr.save_set, "orchid:seen", true);
			
	}
	
#define OrchidBall_begin_step
	 // Unflash:
	if(flash > 0){
		flash -= current_time_scale;
	}
	
	 // Loading Screen Visual:
	if(instance_exists(SpiralCont) && (instance_exists(GenCont) || instance_exists(LevCont))){
		if(!instance_exists(portal_inst)){
			var _lastSeed = random_get_seed();
			portal_inst = instance_create(SpiralCont.x, SpiralCont.y, SpiralDebris);
			with(portal_inst){
				sprite_index = other.sprite_index;
				image_index  = other.image_index;
				image_speed  = other.image_speed;
				turnspeed    = orandom(4);
				rotspeed     = random_range(5, 10) * choose(-1, 1);
				dist         = random_range(40, 60);
			}
			random_set_seed(_lastSeed);
		}
		with(portal_inst){
			image_xscale = 1 + (0.1 * sin((-image_angle / 2) / 200));
			image_yscale = image_xscale;
			grow         = 0;
		}
	}
	
#define OrchidBall_step
	if(setup) OrchidBall_setup();
	
	if(visible){
		 // Grow / Shrink:
		var	_scale    = 1 + (0.1 * sin(current_frame / 10)),
			_scaleAdd = (current_time_scale / 15);
			
		image_xscale += clamp(_scale - image_xscale, -_scaleAdd, _scaleAdd);
		image_yscale += clamp(_scale - image_yscale, -_scaleAdd, _scaleAdd);
		
		 // Spin:
		image_angle += hspeed_raw / 3;
		
		 // Effects:
		if(sprite_exists(spr_sparkle) && chance_ct(1, ((trail_col < 0) ? 8 : 4))){
			with(call(scr.fx, [x, 6], [y, 6], random(1), "VaultFlowerSparkle")){
				sprite_index = other.spr_sparkle;
				if(!position_meeting(x, y, Floor)){
					depth = other.depth + 1;
				}
			}
		}
		
		 // Doin':
		if(target_seek){
			if(target != noone){
				var _lastTarget = target;
				
				if(instance_exists(target)){
					 // Red Orb Targeting:
					if(type == "red"){
						var _disMax = distance_to_object(target);
						if(distance_to_object(enemy) < _disMax){
							with(call(scr.instances_meeting_rectangle,
								x - _disMax,
								y - _disMax,
								x + _disMax,
								y + _disMax,
								instances_matching_ne(enemy, "team", 0, 2)
							)){
								var _dis = distance_to_object(other);
								if(_dis < _disMax){
									if(array_find_index(obj.Tesseract, self) < 0){
										_disMax      = _dis;
										other.target = self;
									}
								}
							}
						}
					}
					
					 // Enter Portal:
					if(instance_is(target, Player) && place_meeting(x, y, Portal)){
						persistent  = true;
						visible     = false;
						target_seek = false;
						
						 // Effects:
						call(scr.sound_play_at, x, y, sndMutHover, 0.8, 2);
						with(instance_create(x, y, BulletHit)){
							sprite_index = sprThrowHit;
							image_speed  = 0.4;
							image_xscale = other.image_xscale;
							image_yscale = other.image_yscale;
							image_angle  = other.image_angle;
							depth        = -5;
						}
						if(sprite_exists(spr_sparkle)){
							var _len = random_range(8, 12);
							for(var _dir = 0; _dir < 360; _dir += (360 / 16)){
								with(call(scr.fx,
									x + lengthdir_x(_len, _dir),
									y + lengthdir_y(_len, _dir),
									[_dir + orandom(30), random(2)],
									Smoke
								)){
									sprite_index = other.spr_sparkle;
									image_index  = random(image_number);
									image_xscale *= 1.2;
									image_yscale *= 1.2;
									depth        = -5;
								}
							}
						}
					}
					
					 // Epic Success:
					else if(place_meeting(x, y, target)){
						instance_destroy();
						exit;
					}
					
					 // Movin':
					else{
						motion_add_ct(target_direction, 1.5);
						if(speed > maxspeed){
							speed = maxspeed;
						}
						
						 // Trail:
						if(trail_col >= 0 && current_frame_active){
							repeat(1 + chance(1, 3)){
								with(instance_create(x + orandom(8), y + orandom(8), DiscTrail)){
									sprite_index = choose(sprWepSwap, sprWepSwap, sprThrowHit);
									image_blend  = other.trail_col;
									image_xscale = 0.8;
									image_yscale = image_xscale;
									image_angle  = random(360);
									depth        = other.depth + 1;
								}
							}
						}
					}
				}
				
				 // Fresh Meat:
				else if(instance_exists(Player)){
					target = instance_nearest(x, y, Player);
				}
					
				 // Disappear:
				else{
					instance_destroy();
					exit;
				}
				
				 // Red Orb Tether:
				if(type == "red"){
					call(scr.motion_step, self, 1);
					
					 // Tethering:
					if(instance_exists(target)){
						var	_arc  = lerp(20, 4, clamp(point_distance(x, y, target.x, target.y) / 96, 0, 1)) * sin(current_frame / 5),
							_inst = call(scr.lightning_connect, x, y, target.x, target.y, _arc, true, target);
							
						with(_inst){
							sprite_index = spr.RedSkillBallTether;
							
							 // Appear Over Walls:
							var _lastMask = mask_index;
							mask_index = -1;
							if(place_meeting(x, y + 8, Wall) || !place_meeting(x, y + 8, Floor)){
								depth = -8;
							}
							else{
								depth = -1;
							}
							mask_index = _lastMask;
						}
						
						 // Newly Tethered:
						if(flash > 0 || target != _lastTarget){
							with(call(scr.instance_random, _inst)){
								instance_create(x, y, PortalL);
							}
							call(scr.sound_play_at, x, y, sndLightningHit, 2);
						}
					}
					
					 // Untether:
					if(target != _lastTarget && instance_exists(_lastTarget) && flash <= 0){
						var	_arc  = lerp(20, 4, clamp(point_distance(x, y, _lastTarget.x, _lastTarget.y) / 96, 0, 1)) * sin(current_frame / 5),
							_inst = call(scr.lightning_connect, x, y, _lastTarget.x, _lastTarget.y, _arc, true, _lastTarget);
							
						with(call(scr.lightning_disappear, _inst)){
							sprite_index = spr.RedSkillBallTether;
							
							 // Appear Over Walls:
							if(place_meeting(x, y + 8, Wall) || !place_meeting(x, y + 8, Floor)){
								depth = -8;
							}
							else{
								depth = -1;
							}
						}
					}
					
					call(scr.motion_step, self, -1);
				}
			}
		}
		else{
			 // Red Orb Zippy Zappy:
			if(type == "red"){
				if(frame_active(8) || chance_ct(1, 16)){
					var _minID = instance_max;
					with(call(scr.projectile_create, x, y, EnemyLightning, random(360))){
						ammo = irandom_range(3, irandom_range(3, 5));
						event_perform(ev_alarm, 0);
					}
					with(call(scr.lightning_disappear, instances_matching_gt(EnemyLightning, "id", _minID))){
						sprite_index = spr.RedSkillBallTether;
						image_yscale = random_range(1, 1.5);
						depth        = other.depth + 1;
						speed        = other.speed;
						friction     = other.friction;
						direction    = other.direction;
					}
					with(instances_matching_gt(LightningHit, "id", _minID)){
						sprite_index = asset_get_index(`sprPortalL${irandom_range(1, 5)}`);
						image_angle  = 0;
						depth        = other.depth + 1;
						speed        = other.speed;
						friction     = other.friction;
						direction    = other.direction;
					}
				}
			}
			
			 // Start Seeking Target:
			if(speed <= ((type == "red") ? 1 : 3)){
				target_seek = true;
				flash       = max(flash, 3);
			}
		}
	}
	
#define OrchidBall_draw
	if(setup) OrchidBall_setup();
	
	 // Self:
	if(flash > 0){
		draw_set_fog(true, image_blend, 0, 0);
	}
	draw_self();
	if(flash > 0){
		draw_set_fog(false, 0, 0, 0);
	}
	
	 // Bloom:
	var	_scale = 2,
		_alpha = 0.1;
		
	draw_set_blend_mode(bm_add);
	image_xscale *= _scale;
	image_yscale *= _scale;
	image_alpha  *= _alpha;
	draw_self();
	image_xscale /= _scale;
	image_yscale /= _scale;
	image_alpha  /= _alpha;
	draw_set_blend_mode(bm_normal);
	
#define OrchidBall_destroy
	 // Annihilate:
	if(type == "red"){
		instance_create(x, y, PortalClear);
	}
	if(type == "red" && skill == mut_none){
		if(instance_exists(target)){
			call(scr.enemy_annihilate, target, time);
		}
	}
	
	 // Mutate:
	else with(call(scr.obj_create, x, y, "OrchidSkill")){
		if(other.skill == mut_none){
			other.skill = skill;
		}
		skill   = other.skill;
		num     = other.num;
		type    = other.type;
		time    = other.time;
		creator = other.creator;
		with(self){
			event_perform(ev_step, ev_step_normal);
		}
	}
	
	 // Alert:
	if(instance_exists(target)){
		var _icon = call(scr.skill_get_icon, skill);
		with(call(scr.alert_create, target, _icon[0])){
			image_index = _icon[1];
			image_speed = 0;
			alarm0      = 60;
			blink       = 15;
			snd_flash   = sndLevelUp;
			
			 // Alert Icon:
			switch(other.type){
				case "basic"  : alert = { spr:spr.AlertIndicatorOrchid, x:6, y:6 }; break;
				case "portal" : alert = { spr:sprEatRad, img:-0.25,     x:6, y:6 }; break;
				default       : alert = {};
			}
			
			 // Fix Overlap:
			x = target.x + target_x;
			y = target.y + target_y;
			while(array_length(call(scr.instances_meeting_instance, self, instances_matching(obj.AlertIndicator, "target", target)))){
				y        -= 16;
				target_y -= 16;
			}
		}
	}
	
	 // Effects:
	if(sprite_exists(spr_sparkle)){
		repeat(10 + irandom(10)){
			with(call(scr.fx, [x, 16], [y, 16], [direction, 3 + random(3)], "VaultFlowerSparkle")){
				sprite_index = other.spr_sparkle;
				depth        = -9;
				friction     = 0.2;
			}
		}
	}
	var _len = 0;
	with(instance_create(x + lengthdir_x(_len, direction), y + lengthdir_y(_len, direction), BulletHit)){
		speed        = max(4, other.speed);
		direction    = other.direction;
		friction     = 1;
		sprite_index = sprMutant6Dead;
		image_index  = 11;
		image_speed  = 0.5;
		image_xscale = 0.75;
		image_yscale = image_xscale;
		image_angle  = direction - 90;
		depth        = -4;
		if(array_find_index([sprEatRad, sprEatBigRad, sprEatRadPlut, sprEatBigRadPlut], other.spr_sparkle) >= 0){
			image_blend = make_color_rgb(255, 255, 0);
		}
	}
	sleep(20);
	
	
#define OrchidChest_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.OrchidChest;
		spr_dead     = spr.OrchidChestOpen;
		//spr_shadow_y = 2;
		
		 // Sounds:
		snd_open = sndChest;
		
		 // Vars:
		num   = 1;
		alive = true;
		
		 // Events:
		on_step = script_ref_create(OrchidChest_step);
		on_open = script_ref_create(OrchidChest_open);
		
		return self;
	}
	
#define OrchidChest_step
	 // Sparkle:
	if(alive && chance_ct(1, 5)){
		call(scr.fx, [x, 7], [y, 6], 0, "VaultFlowerSparkle");
	}
	
#define OrchidChest_open
	var _target = (instance_is(other, Player) ? other : instance_nearest(x, y, Player));
	
	 // Effects:
	repeat(5){
		VaultFlower_debris(x, y, random(360), random(3));
	}
	
	 // Normal:
	if(alive){
		 // Skill:
		with(call(scr.obj_create, x, y, "OrchidBall")){
			if(instance_is(_target, Player)){
				target    = _target;
			}
			num       = other.num;
			creator   = other;
			direction = 90 + orandom(45);
		}
		
		 // Effects:
		repeat(10){
			call(scr.fx, [x, 5], y + random(5), [90, random(1)], "VaultFlowerSparkle");
		}
		with(instance_create(x, y - 10, FXChestOpen)){
			sprite_index = sprMutant6Dead;
			image_index  = 12;
			image_xscale = 0.75;
			image_yscale = image_xscale;
		}
		
		 // Sound:
		sound_play_pitchvol(sndUncurse,            0.9 + random(0.2), 1.0);
		sound_play_pitchvol(sndJungleAssassinWake, 0.9 + random(0.2), 0.8);
		sound_play_pitchvol(sndWallBreakBrick,     1,                 0.6);
	}
	
	 // Dead:
	else repeat(5){
		with(call(scr.obj_create, x, y, "BonePickup")){
			motion_add(random(360), random(4));
		}
	}
	
	
#define OrchidSkill_create(_x, _y)
	/*
		Manages the pet Orchid's timed mutation
		
		Vars:
			color1     - The main HUD color
			color2     - The secondary HUD color
			flash      - HUD flashes white for this many frames
			star_scale - Scale of the star flashed behind the HUD
			skill      - The mutation to give, automatically decided by default
			num        - The value of the mutation
			time       - How long the mutation lasts
			type       - Determines its default color and how its 'time' ticks down
			             "basic" for one tick every frame (not on loading or mutation screens)
			             "portal" for one tick when the portal closes
	*/
	
	with(instance_create(_x, _y, CustomObject)){
		 // Visual:
		color1     = -1;
		color2     = -1;
		flash      = -1;
		star_scale = 1;
		
		 // Vars:
		persistent = true;
		skill      = OrchidSkill_decide();
		num        = 1;
		type       = "basic";
		time       = 0;
		time_max   = 0;
		setup      = true;
		chest      = [];
		spirit     = [];
		creator    = noone;
		
		return self;
	}
	
#define OrchidSkill_decide
	/*
		Returns a random mutation that could currently appear on the mutation selection screen
		If the player already has every available mutation then a random one is returned
		Returns 'mut_none' if there were no available mutations
	*/
	
	var _skillList = [],
		_skillMods = mod_get_names("skill"),
		_skillMax  = 30,
		_skillAll  = true; // Already have every available skill
		
	for(var i = _skillMax + array_length(_skillMods) - 1; i >= 1; i--){
		var _skill = ((i < _skillMax) ? i : _skillMods[i - _skillMax]);
		if(call(scr.skill_get_avail, _skill)){
			array_push(_skillList, _skill);
			if(skill_get(_skill) == 0){
				_skillAll = false;
			}
		}
	}
	
	with(call(scr.array_shuffle, _skillList)){
		var _skill = self;
		if(_skillAll || skill_get(_skill) == 0){
			return _skill;
		}
	}
	
	return mut_none;
	
#define OrchidSkill_setup
	setup = false;
	
	 // Type-Specific:
	switch(type){
		
		case "basic":
		
			 // Colors:
			if(color1 == -1) color1 = make_color_rgb(255, 255, 80);
			if(color2 == -1) color2 = make_color_rgb( 84,  58, 24);
			
			 // Time:
			if(time_max == 0){
				if(time == 0){
					time = 600; // 20 Seconds
				}
				time_max = time;
			}
			
			break;
			
		case "portal":
		
			 // Colors:
			if(color1 == -1) color1 = make_color_rgb(72, 253,  8);
			if(color2 == -1) color2 = make_color_rgb(50,  72, 40);
			
			 // Time:
			if(time_max == 0){
				if(time == 0){
					time = 2; // 2 Areas
				}
				time_max = time;
			}
			
			break;
			
	}
	
	 // Mutation:
	if(num != 0){
		var	_lastMut = skill_get(skill),
			_lastPat = GameCont.hud_patience;
			
		skill_set(skill, (
			(num < 0)
			? min(num, _lastMut + num)
			: max(num, _lastMut + num)
		));
		
		switch(skill){
			
			case mut_scarier_face:
			
				 // Manually Reduce Enemy HP:
				with(instances_matching_lt(enemy, "id", id)){
					maxhealth = round(maxhealth * power(0.8, other.num));
					my_health = round(my_health * power(0.8, other.num));
					
					 // Hurt FX:
					sprite_index = spr_hurt;
					image_index  = 0;
					if(point_seen(x, y, -1)){
						sound_play_hit(snd_hurt, 0.3);
					}
				}
				
				break;
				
			case mut_patience:
			
				 // Remove Patience Mutation:
				if(_lastPat != undefined){
					if(_lastPat == mut_none){
						GameCont.skillpoints--;
					}
					else with(call(scr.obj_create, x, y, "OrchidSkill")){
						skill = _lastPat;
						num   = skill_get(skill);
						instance_destroy();
					}
				}
				
				break;
				
			case mut_hammerhead:
			
				 // Give Hammerhead Points:
				with(instances_matching_lt(Player, "id", id)){
					hammerhead += 20 * other.num;
				}
				
				break;
				
			case mut_strong_spirit:
			
				with(Player){
					var _num = other.num;
					if(_num > 0){
						 // Restore Strong Spirit:
						if(canspirit == false || _lastMut <= 0){
							canspirit = true;
							_num--;
							
							 // Effects:
							with(instance_create(x, y, StrongSpirit)){
								sprite_index = sprStrongSpiritRefill;
								creator      = other;
							}
							sound_play(sndStrongSpiritGain);
						}
						
						 // Bonus Spirit (Strong Spirit's built-in mutation stacking sucks):
						if(_num > 0){
							if("bonus_spirit" not in self){
								bonus_spirit = [];
							}
							repeat(_num){
								var _spirit = {};
								array_push(other.spirit, _spirit);
								array_push(bonus_spirit, _spirit);
								sound_play(sndStrongSpiritGain);
							}
						}
					}
				}
				
				break;
				
			case mut_open_mind:
			
				if(num > 0){
					 // Duplicate Chest:
					with(call(scr.instance_random, instances_matching_ne([chestprop, RadChest], "mask_index", mskNone))){
						repeat(other.num){
							array_push(other.chest, call(scr.instance_clone, self));
						}
						
						 // Manual Offset:
						if(instance_is(self, RadChest)){
							with(other.chest){
								call(scr.instance_budge, self, other);
							}
						}
					}
					
					 // Alert:
					with(chest){
						with(other){
							var _icon = call(scr.skill_get_icon, skill);
							with(call(scr.alert_create, other, _icon[0])){
								image_index = _icon[1];
								image_speed = 0;
								alert       = {};
								alarm0      = ((other.type == "basic") ? other.time : 300) - (2 * blink);
								flash       = 4;
								snd_flash   = sndChest;
							}
						}
					}
				}
				
				break;
				
			case mut_heavy_heart:
			
				 // Don't Appear on Mutation Screen:
				if(GameCont.wepmuted == false || GameCont.wepmuted == true){
					GameCont.wepmuted = (skill_get(skill) == 0);
				}
				
				break;
				
		}
	}
	
	 // Flash:
	if(flash == -1){
		flash = 3;
	}
	
	 // Sound:
	sound_play_gun(call(scr.skill_get_sound, skill), 0, 0.3);
	sound_play_pitchvol(sndStatueXP, 0.8, 0.8);
	
#define OrchidSkill_begin_step
	 // Unflash:
	if(flash > 0){
		flash -= current_time_scale;
	}
	if(star_scale > 0){
		star_scale -= current_time_scale / 60;
	}
	
#define OrchidSkill_step
	if(setup) OrchidSkill_setup();
	
	 // Timer:
	if(skill_get(skill) != 0){
		 // Normal Tick:
		if(time > 0 && type == "basic"){
			if(!instance_exists(GenCont) && !instance_exists(LevCont)){
				time -= min(time, current_time_scale);
				if(time <= 0){
					flash = 2;
				}
			}
		}
		
		 // Goodbye:
		else if(time == 0 && flash <= 0){
			instance_destroy();
		}
	}
	
	 // Mutation Not Active:
	else instance_delete(self);
	
#define OrchidSkill_end_step
	 // Blink Chests:
	if(type == "basic" && array_length(chest)){
		if(array_length(obj.AlertIndicator)){
			var _inst = instances_matching_ne(chest, "id");
			if(array_length(_inst)){
				with(_inst){
					var _instAlert = instances_matching(obj.AlertIndicator, "target", self);
					if(array_length(_instAlert)){
						visible = _instAlert[0].visible;
					}
				}
			}
		}
	}
	
#define OrchidSkill_destroy
	var	_lastMut = skill_get(skill),
		_lastPat = GameCont.hud_patience,
		_lastHP  = [];
		
	 // Remember HP:
	with(Player){
		array_push(_lastHP, [self, my_health]);
	}
	
	 // Lose Mutation:
	if(skill == mut_last_wish){
		skill_set(skill, 0);
	}
	skill_set(skill, (
		(_lastMut < 0)
		? min(0, _lastMut - num)
		: max(0, _lastMut - num)
	));
	
	 // Restore HP:
	with(_lastHP){
		with(self[0]){
			my_health = min(max(other[1], my_health), maxhealth);
		}
	}
	
	 // Blip:
	sound_play_pitchvol(sndMutHover,       0.5 +  random(0.2), 3.0);
	sound_play_pitchvol(sndCursedReminder, 1.0 + orandom(0.1), 3.0);
	sound_play_pitchvol(sndStatueHurt,     0.7 +  random(0.1), 0.4);
	
	 // Delete Alerts:
	with(instances_matching(obj.AlertIndicator, "creator", self)){
		flash   = 1;
		blink   = 1;
		alarm0  = 1 + flash;
		visible = true;
	}
	
	 // Delete Open Mind Chests:
	with(instances_matching_ne(chest, "id")){
		//instance_create(x, y, FishA);
		instance_delete(self);
	}
	
	 // Skill-Specific:
	switch(skill){
		
		case mut_throne_butt:
		
			 // Fix Sound Looping:
			if(skill_get(skill) <= 0){
				if(array_length(instances_matching_ne(Player, "roll", 0))){
					sound_stop(sndFishTB);
				}
			}
			
			break;
			
		case mut_scarier_face:
		
			 // Restore Enemy HP:
			if(num != 0){
				with(instances_matching_lt(enemy, "id", id)){
					maxhealth = round(maxhealth / power(0.8, other.num));
					my_health = round(my_health / power(0.8, other.num));
					
					 // Heal FX:
					sprite_index = spr_hurt;
					image_index  = 0;
					with(instance_create(x, y, BloodLust)){
						sprite_index = sprHealFX;
						creator      = other;
					}
					sound_play_pitchvol(sndHPPickup, 1.5, 0.3);
				}
			}
			
			break;
			
		case mut_patience:
		
			 // Remove Patience Mutation:
			if(_lastPat != undefined){
				if(_lastPat == mut_none){
					GameCont.skillpoints--;
				}
				else with(call(scr.obj_create, x, y, "OrchidSkill")){
					skill = _lastPat;
					num   = skill_get(skill);
					instance_destroy();
				}
			}
			
			break;
			
		case mut_hammerhead:
		
			 // Remove Hammerhead Points:
			with(instances_matching_gt(instances_matching_lt(Player, "id", id), "hammerhead", 0)){
				hammerhead = max(0, hammerhead - (20 * other.num));
			}
			
			break;
			
		case mut_strong_spirit:
		
			 // Remove Bonus Spirit:
			with(spirit) if(lq_defget(self, "active", true)){
				active       = false;
				sprite_index = sprStrongSpirit;
				image_index  = 0;
				sound_play(sndStrongSpiritLost);
			}
			
			 // Remove Strong Spirit:
			if(num - array_length(spirit) > 0){
				with(instances_matching(instances_matching_lt(Player, "id", id), "canspirit", true)){
					if(skill_get(mut_strong_spirit) > 0){
						canspirit = false;
					}
					with(instance_create(x, y, StrongSpirit)){
						creator = other;
					}
					sound_play(sndStrongSpiritLost);
				}
			}
			
			break;
			
		case mut_heavy_heart:
		
			 // Can Appear Mutation Screen:
			if(GameCont.wepmuted == false || GameCont.wepmuted == true){
				GameCont.wepmuted = (skill_get(skill) == 0);
			}
			
			break;
			
	}
	
	
#define PalaceAltar_create(_x, _y)
	/*
		7-2 event prop. Grants a temporary weapon mutation based on the player's loadout.
	*/
	
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle     = spr.PalaceAltarIdle;
		spr_hurt     = spr.PalaceAltarHurt;
		spr_dead     = spr.PalaceAltarDead;
		sprite_index = spr_idle;
		
		 // Sounds:
		snd_hurt = sndHitRock;
		snd_dead = sndGeneratorBreak;
		
		 // Vars:
		maxhealth    = 80;
		raddrop      = 6;
		team         = 1;
		size         = 3;
		skill        = OrchidSkill_decide();
		effect_color = make_color_rgb(72, 253, 8); // make_color_rgb(190, 253, 8);
		direction    = 90 + orandom(45);
		
		 // Prompt:
		prompt = call(scr.prompt_create, self, loc("NTTE:PalaceAltar:Prompt", "  CHOOSE"), mskReviveArea, -8, -16);
		with(prompt){
			on_meet = script_ref_create(VaultFlower_prompt_meet);
		}
		
		 // Alarms:
		alarm0 = -1;
		
		return self;
	}
	
#define PalaceAltar_step
	 // Alarms:
	if(alarm0_run) exit;
	
	 // Radiate:
	if(chance_ct(2, 3)){
		with(call(scr.fx, [x, 2], y - random(16), [90, random(2)], EatRad)){
			sprite_index = choose(sprEatRadPlut, sprEatBigRadPlut);
			image_speed  = 0.4;
			depth        = -7;
		} 
	}
	
	 // Damage Sparks:
	if(sprite_index == spr_hurt && chance_ct(1, 3)){
		instance_create(x + orandom(16), y + 8 + orandom(16), PortalL);
	}
	
	 // Pickup:
	if(instance_exists(prompt)){
		if(player_is_active(prompt.pick)){
			 // Grant Blessing:
			/*with(call(scr.obj_create, x, y, "OrchidSkill")){
				skill   = other.skill;
				type    = "portal";
				creator = other;
				with(self){
					event_perform(ev_step, ev_step_normal);
				}
			}*/
			
			 // Sound:
			sprite_index = spr_hurt;
			image_index  = 0;
			sound_play_hit(snd_dead, 0.2);
			
			 // Effect:
			with(instance_create(x, y, ImpactWrists)){
				image_blend = other.effect_color;
				depth       = -4;
			}
			
			 // Disable All Altars:
			with(instances_matching_ne(obj.PalaceAltar, "id")){
				alarm0 = irandom_range(10, 20);
				if(self != other){
					skill = mut_none;
				}
				with(prompt){
					visible = false;
				}
			}
		}
	}
	
#define PalaceAltar_alrm0
	my_health = 0;
	
#define PalaceAltar_death
	 // Debris:
	repeat(10){
		with(instance_create(x, y, Shell)){
			sprite_index = spr.PalaceAltarDebris;
			image_index  = irandom(image_number - 1);
			image_speed  = 0;
			image_angle  = random(360);
			motion_set(random(360), random_range(4, 8));
		}
	}
	
	 // Grant Blessing:
	if(skill != mut_none){
		with(call(scr.obj_create, x, y, "OrchidBall")){
			skill     = other.skill;
			type      = "portal";
			creator   = other;
			direction = other.direction;
			speed     = 10;
		}
	}
	
	 // Disable Altars:
	with(instances_matching_lt(instances_matching_ne(obj.PalaceAltar, "id", id), "alarm0", 0)){
		alarm0 = irandom_range(10, 20);
		skill  = mut_none;
		with(prompt){
			visible = false;
		}
	}
	
	 // Alert:
	/*if(array_length(instances_matching(obj.OrchidSkill, "creator", self))){
		var _icon = call(scr.skill_get_icon, skill);
		with(call(scr.alert_create, self, _icon[0])){
			image_index = _icon[1];
			image_speed = 0;
			vspeed      = -2.5;
			target_y    = 0;
			alert       = { spr:sprEatRad, img:-0.25, x:6, y:6 };
			alarm0      = 60;
			blink       = 15;
			flash       = 6;
			snd_flash   = sndLevelUp;
		}
	}*/
	
	 // Effects:
	instance_create(x, y, PortalClear);
	repeat(4){
		call(scr.obj_create, x + orandom(24), (y + 8) + orandom(24), "GroundFlameGreen");
	}
	/*
	repeat(2 + irandom(1)){
		with(call(scr.obj_create, x + orandom(16), (y + 8) + orandom(16), "GroundFlameGreen")){
			spr_dead = sprThroneFlameEnd;
			sprite_index = sprThroneFlameIdle;
			image_yscale = 0.6;
			image_xscale = 0.8;
		}
	}
	*/
	repeat(15){
		with(call(scr.fx, [x, 16], [y, 16], [90, random(1)], EatRad)){
			sprite_index = choose(sprEatRadPlut, sprEatBigRadPlut);
			image_index  = random(2);
			image_speed  = 0.4;
			depth        = -4;
		}
	}
	with(instance_create(x, y - 8, EatRad)){
		sprite_index = sprMutant6Dead;
		image_speed  = 0.4;
		image_index  = 9;
		image_blend  = other.effect_color;
		depth        = -4;
	}
	view_shake_max_at(x, y, 50);
	call(scr.sleep_max, 50);
	
	 // Sounds:
	sound_play_pitch(sndGunGun,          0.6 + random(0.2));
	sound_play_pitch(sndSnowTankDead,    0.6 + random(0.2));
	sound_play_pitch(sndEnergyHammerUpg, 0.5);
	
	
#define Pizza_create(_x, _y)
	with(instance_create(_x, _y, HPPickup)){
		 // Visual:
		sprite_index = sprSlice;
		
		 // Vars:
		num = ceil(num / 2);
		
		return self;
	}


#define PizzaChest_create(_x, _y)
	with(instance_create(_x, _y, HealthChest)){
		 // Visual:
		sprite_index = choose(sprPizzaChest1, sprPizzaChest2);
		spr_dead     = sprPizzaChestOpen;
		
		 // Vars:
		num = ceil(num / 2);
		
		return self;
	}


#define PizzaStack_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = sprPizzaBox;
		spr_hurt = sprPizzaBoxHurt;
		spr_dead = sprPizzaBoxDead;
		
		 // Sound:
		snd_hurt = sndHitPlant;
		snd_dead = sndPizzaBoxBreak;
		
		 // Vars:
		maxhealth = 4;
		size      = 1;
		num       = choose(1, 2);
		
		 // Big luck:
		if(chance(1, 10)) num = 4;
		
		return self;
	}
	
#define PizzaStack_death
	 // Big:
	if(num >= 4){
		sound_play_pitch(snd_dead, 0.6);
		snd_dead = -1;
	}
	
	 // +Yum
	repeat(num){
		call(scr.obj_create, x + orandom(2 * num), y + orandom(2 * num), "Pizza");
		instance_create(x + orandom(4), y + orandom(4), Dust);
	}
	
	
#define Prompt_create(_x, _y)
	with(instance_create(_x, _y, CustomObject)){
		 // Vars:
		persistent = true;
		mask_index = mskWepPickup;
		depth      = 0; // Priority (0==WepPickup)
		creator    = noone;
		nearwep    = noone;
		text       = "";
		pick       = -1;
		xoff       = 0;
		yoff       = 0;
		
		 // Events:
		on_meet = null;
		
		return self;
	}
	
#define Prompt_begin_step
	if(instance_exists(nearwep)){
		instance_delete(nearwep);
	}
	
#define Prompt_end_step
	 // Follow Creator:
	if(creator != noone){
		if(instance_exists(creator)){
			if(instance_exists(nearwep)){
				with(nearwep){
					x += other.creator.x - other.x;
					y += other.creator.y - other.y;
					visible = true;
				}
			}
			x = creator.x;
			y = creator.y;
		}
		else instance_destroy();
	}
	
#define Prompt_cleanup
	if(instance_exists(nearwep)){
		instance_delete(nearwep);
	}
	
	
#define RatChest_create(_x, _y)
	/*
		Shop chest for mutations, replaces rad canisters
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.RatChest;
		spr_dead     = spr.RatChestOpen;
		
		 // Sound:
		snd_open = sndEXPChest;
		
		 // Events:
		on_open = script_ref_create(RatChest_open);
		
		return self;
	}
	
#define RatChest_open
	var _pool = [];
	
	 // Sounds:
	sound_play_pitchvol(sndEnergySword, 0.5 + orandom(0.1), 0.8);
	sound_play_pitchvol(sndSkillPick,   2.0 + orandom(0.1), 0.5);
	
	 // Text:
	if(instance_is(other, Player)){
		var _text = instance_create(x, y, PopupText);
		_text.text   = ChestShop_text;
		_text.alarm1 = 18;
		_text.target = other.index;
	}
	
	 // Clear Walls:
	instance_create(x, y, PortalClear);
	
	 // Generate Mutation Pool:
	var _skillMods = mod_get_names("skill"),
		_skillMax  = 30;
		
	for(var i = _skillMax + array_length(_skillMods) - 1; i >= 1; i--){
		var _skill = ((i < _skillMax) ? i : _skillMods[i - _skillMax]);
		if(skill_get(_skill) == 0){
			if(
				call(scr.skill_get_avail, _skill)
				|| (
					is_string(_skill)
					&& mod_script_exists("skill", _skill, "skill_rat")
					&& mod_script_call("skill", _skill, "skill_rat")
				)
			){
				array_push(_pool, _skill);
			}
		}
	}
	_pool = call(scr.array_shuffle, _pool);
	
	 // Create Shops:
	if(array_length(_pool)){
		var	_angOff  = 35,
			_poolNum = 0;
			
		for(var _ang = -_angOff; _ang <= _angOff; _ang += _angOff * 2){
			var	_len = 28,
				_dir = _ang + 90;
				
			with(call(scr.obj_create, x, y, "ChestShop")){
				x      += lengthdir_x(_len, _dir);
				y      += lengthdir_y(_len, _dir);
				type    = ChestShop_skill;
				creator = other;
				
				 // Decide Mutation:
				drop = _pool[_poolNum % array_length(_pool)];
				_poolNum++;
			}
		}
	}
	
	
#define RedAmmoChest_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.RedAmmoChest;
		spr_dead     = spr.RedAmmoChestOpen;
		spr_shadow_y = -3;
		
		 // Sounds:
		snd_open = sndRogueCanister;
		
		 // Vars:
		num = 1;
		
		 // Events:
		on_open = script_ref_create(RedAmmoChest_open);
		
		return self;
	}
	
#define RedAmmoChest_open
	var _num = num;
	
	 // Red Ammo:
	if(instance_is(other, Player) && "red_ammo" in other){
		with(other){
			red_ammo = min(red_ammo + _num, red_amax);
			
			 // Text:
			pickup_text(
				RedAmmo_text,
				((red_ammo < red_amax) ? "add" : "max"),
				_num
			);
		}
	}
	else with(call(scr.obj_create, x, y, "RedAmmoPickup")){
		num = _num;
	}
	
	
#define RedAmmoPickup_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = spr.RedAmmoPickup;
		
		 // Sounds:
		snd_open = sndRogueCanister;
		snd_dead = sndPickupDisappear;
		
		 // Vars:
		num = 1 + (crown_current == crwn_haste);
		
		 // Events:
		on_pull = script_ref_create(RedAmmoPickup_pull);
		on_open = script_ref_create(RedAmmoPickup_open);
		
		return self;
	}
	
#define RedAmmoPickup_pull
	return (
		call(scr.weapon_get, "red", other.wep)  > 0 ||
		call(scr.weapon_get, "red", other.bwep) > 0
	);
	
#define RedAmmoPickup_open
	var	_num  = num;
	
	 // Red Ammo:
	with(instance_is(other, Player) ? other : Player){
		if("red_ammo" in self){
			red_ammo = min(red_ammo + _num, red_amax);
			
			 // Text:
			pickup_text(
				RedAmmo_text,
				((red_ammo < red_amax) ? "add" : "max"),
				_num
			);
		}
	}
	
	
#define RedChest_create(_x, _y)
	/*
		Releases an orb that targets and annihilates the nearest Player/enemy
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.RedChest;
		spr_dead     = spr.RedChestOpen;
		spr_shadow   = shd16;
		spr_shadow_y = 4;
		
		 // Sounds:
		//snd_open = ;
		
		 // Vars:
		num = 2;
		
		 // Events:
		on_open = script_ref_create(RedChest_open);
		
		return self;
	}
	
#define RedChest_open
	var _target = (instance_is(other, Player) ? other : instance_nearest(x, y, Player));
	
	 // Clear Walls:
	instance_create(x, y, PortalClear);
	
	 // Annihilation Orb:
	with(call(scr.obj_create, x, y, "OrchidBall")){
		target  = _target;
		type    = "red";
		time    = other.num;
		creator = other;
		with(instance_nearest(x, y, enemy)){
			other.direction = point_direction(other.x, other.y, x, y) + orandom(15);
		}
	}
	
	/*with(instance_create(x, y, PopupText)){
		text = "AVOID";
	}*/
	
	
#define RogueBackpack_create(_x, _y)
	/*
		Rogue's backpack in chest form, spawns portal strike ammo and upgrades IDPD tech
	*/
	
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.RogueBackpack;
		spr_dead     = spr.RogueBackpackOpen;
		spr_shadow   = shd16;
		spr_shadow_y = 2;
		
		 // Sounds:
		snd_open = choose(sndMenuASkin, sndMenuBSkin);
		
		 // Vars:
		num = 2;
		
		 // Events:
		on_open = script_ref_create(RogueBackpack_open);
		
		return self;
	}
	
#define RogueBackpack_open
	 // Sound:
	if(snd_open == sndMenuASkin || snd_open == sndMenuBSkin){
		sound_play_pitch(sndWeaponChest, 0.5);
	}
	
	 // Strike Ammo:
	if(num > 0){
		var _ang = random(360);
		for(var _dir = _ang; _dir < _ang + 360; _dir += (360 / num)){
			with(instance_create(x, y, RoguePickup)){
				with(call(scr.obj_create, x, y, "BackpackPickup")){
					direction = _dir;
					target    = other;
					with(self){
						event_perform(ev_step, ev_step_end);
					}
				}
			}
		}
	}
	
	 // Upgrade Rogue Rifle:
	if(instance_is(other, Player)){
		with(other){
			var _wep = "rogue carbine";
			if(call(scr.wep_raw, wep) == wep_rogue_rifle){
				wep       = _wep;
				drawempty = 30;
				swapmove  = 1;
			}
			else if(call(scr.wep_raw, bwep) == wep_rogue_rifle){
				bwep       = _wep;
				drawemptyb = 30;
			}
			else _wep = wep_none;
			
			 // Swapped:
			if(_wep != wep_none){
				 // Text:
				pickup_text(weapon_get_name(_wep), "got");
				
				 // Explosion:
				with(call(scr.pass, self, scr.projectile_create, other.x, other.y, PopoExplosion)){
					sprite_index = sprRogueExplosion;
					mask_index   = mskExplosion;
				}
				sound_play_hit_big(sndIDPDNadeExplo, 0.2);
				
				 // Sounds:
				sound_play(snd_chst);
				sound_play_pitch(weapon_get_swap(_wep), 0.6);
			}
		}
	}
	
	
#define SpiritChest_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomChest")){
		 // Visual:
		sprite_index = spr.SpiritChest;
		spr_dead     = spr.SpiritChestOpen;
		spr_halo     = sprStrongSpiritRefill;
		img_halo     = 0;
		
		 // Sounds:
		snd_open = sndWeaponChest;
		sound_play_pitchvol(sndStrongSpiritGain, 1.2 + random(0.2), 0.7);
		
		 // Vars:
		num  = 2;
		wave = random(90);
		
		 // Events:
		on_step = script_ref_create(SpiritChest_step);
		on_open = script_ref_create(SpiritChest_open);
		
		return self;
	}
	
#define SpiritChest_step
	 // Animate Halo:
	wave += current_time_scale;
	img_halo += 0.4 * current_time_scale;
	if(img_halo >= sprite_get_number(spr_halo)){
		img_halo %= sprite_get_number(spr_halo);
		spr_halo = sprHalo;
	}
	
#define SpiritChest_draw
	 // Halos:
	for(var i = 0; i < num; i++){
		draw_sprite(spr_halo, img_halo, x, y + 3 + sin(wave * 0.1) - (i * 7));
	}
	
#define SpiritChest_open
	 // Acquire Bonus Spirit:
	if(instance_is(other, Player)){
		SpiritPickup_open();
	}
	
	 // Pickups:
	else if(num > 0){
		repeat(num){
			call(scr.obj_create, x, y, "SpiritPickup");
		}
	}
	
	
#define SpiritPickup_create(_x, _y)
	with(call(scr.obj_create, _x, _y, "CustomPickup")){
		 // Visual:
		sprite_index = spr.SpiritPickup;
		spr_halo     = sprStrongSpiritRefill;
		img_halo     = 0;
		
		 // Sounds:
		snd_open = sndAmmoPickup;
		snd_fade = sndStrongSpiritLost;
		sound_play_pitchvol(sndStrongSpiritGain, 1.4 + random(0.3), 0.7);
		
		 // Vars:
		num        = 1 + (crown_current == crwn_haste); // haste confirmed epic
		alarm0     = pickup_alarm(90 + random(30), 1/5);
		pull_dis   = 30 + (30 * skill_get(mut_plutonium_hunger));
		pull_spd   = 4;
		pull_delay = 30;
		wave       = random(90);
		
		 // Events:
		on_step = script_ref_create(SpiritPickup_step);
		on_pull = script_ref_create(SpiritPickup_pull);
		on_open = script_ref_create(SpiritPickup_open);
		on_fade = script_ref_create(SpiritPickup_fade);
		
		return self;
	}
	
#define SpiritPickup_step
	 // Attraction Delay:
	if(pull_delay > 0){
		pull_delay -= current_time_scale;
	}
	
	 // Animate Halo:
	wave += current_time_scale;
	img_halo += image_speed_raw;
	if(img_halo >= sprite_get_number(spr_halo)){
		img_halo %= sprite_get_number(spr_halo);
		spr_halo = sprHalo;
	}

#define SpiritPickup_draw
	 // Halos:
	for(var i = 0; i < num; i++){
		draw_sprite(spr_halo, img_halo, x, y + 3 + sin(wave * 0.1) - (i * 7));
	}

#define SpiritPickup_open
	var _num = num;
	
	 // Acquire Bonus Spirit:
	with(instance_is(other, Player) ? other : Player){
		if("bonus_spirit" not in self){
			bonus_spirit = [];
		}
		
		 // Adding Spirits:
		if(_num > 0){
			repeat(_num){
				array_push(bonus_spirit, {});
				sound_play(sndStrongSpiritGain);
			}
		}
		
		 // Negative Spirits (just cause):
		else if(_num < 0){
			repeat(-_num){
				with(call(scr.array_flip, bonus_spirit)){
					if(active){
						active       = false;
						sprite_index = sprStrongSpirit;
						image_index  = 0;
						sound_play(sndStrongSpiritLost);
						break;
					}
				}
			}
		}
		
		 // Text:
		var _spiritText = call(scr.loc_format,
			`NTTE:Bonus:Spirit:${_num}`,
			"%" + ((abs(_num) == 1) ? "" : "S"),
			loc("NTTE:Bonus:Spirit", "@yBONUS @wSPIRIT")
		);
		pickup_text(_spiritText, "add", _num);
	}
	
#define SpiritPickup_fade
	 // Kill Spirits:
	for(var i = 0; i < num; i++){
		instance_create(x, (y + 3) - (i * 7), StrongSpirit);
	}
	
	 // Pity HP:
	instance_create(x, y, HPPickup);
	
#define SpiritPickup_pull
	return (pull_delay <= 0);
	
	
#define VaultFlower_create(_x, _y)
	with(instance_create(_x, _y, CustomProp)){
		 // Visual:
		spr_idle = spr.VaultFlowerIdle;
		spr_hurt = spr.VaultFlowerHurt;
		spr_dead = spr.VaultFlowerDead;
		
		 // Sounds:
		snd_hurt = sndHitPlant;
		snd_dead = sndMoneyPileBreak;
		
		 // Vars:
		mask_index = mskBigSkull;
		maxhealth  = 30;
		size       = 3;
		skill      = mut_last_wish;
		alive      = (skill_get("reroll") == 0 && ("ntte_reroll_hud" not in GameCont || GameCont.ntte_reroll_hud == undefined));
		prompt     = noone;
		unlock     = false;
		
		 // Determine Skill:
		if(alive){
			 // Orchid Plant Skin Unlock:
			if(player_count_race(char_plant) > 0 && skill_get(mut_heavy_heart) != 0 && !call(scr.unlock_get, "skin:orchid plant")){
				skill  = mut_heavy_heart;
				unlock = true;
			}
			
			 // Normal:
			else if(skill_get(skill) == 0){
				var _skillList = [];
				for(var i = 0; skill_get_at(i) != undefined; i++){
					var _skill = skill_get_at(i);
					if(_skill != mut_patience && call(scr.skill_get_avail, _skill)){
						array_push(_skillList, _skill);
					}
				}
				if(array_length(_skillList)){
					skill = _skillList[irandom(array_length(_skillList) - 1)];
				}
			}
			
			 // Wilt:
			if(skill_get(skill) == 0){
				alive = false;
			}
		}
		
		 // Prompt:
		if(alive){
			prompt = call(scr.prompt_create, self, loc("NTTE:VaultFlower:Prompt", "  REROLL"), mskLast, -8, -10);
			with(prompt){
				on_meet = script_ref_create(VaultFlower_prompt_meet);
			}
		}
		
		return self;
	}
	
#define VaultFlower_step
	x = xstart;
	y = ystart;
	
	if(alive){
		 // Sprites:
		if(spr_idle == spr.VaultFlowerWiltedIdle) spr_idle = spr.VaultFlowerIdle;
		if(spr_hurt == spr.VaultFlowerWiltedHurt) spr_hurt = spr.VaultFlowerHurt;
		if(spr_dead == spr.VaultFlowerWiltedDead) spr_dead = spr.VaultFlowerDead;
		
		 // Camera Pan:
		if(!instance_exists(Menu) && !instance_exists(PopoScene)){
			var _userSeen = [];
			for(var i = 0; i < maxp; i++){
				if(player_is_active(i)){
					var _user = player_get_uid(i);
					if(array_find_index(_userSeen, _user) < 0){
						array_push(_userSeen, _user);
						
						var	_x   = 0,
							_y   = 0,
							_num = 0;
							
						 // Camera Position:
						for(var j = 0; j < maxp; j++){
							if(_user == player_get_uid(j)){
								if(!instance_exists(view_object[j])){
									with(instances_matching(Player, "index", j)){
										_x += x;
										_y += y;
										_num++;
									}
								}
								else{
									_num = 0;
									break;
								}
							}
						}
						
						 // Pan:
						if(_num > 0){
							_x /= _num;
							_y /= _num;
							
							var	_dis = min(960 / point_distance(_x, _y, x, y), point_distance(_x, _y, x, y) / 3),
								_dir = point_direction(_x, _y, x, y);
								
							if(_dis > 0){
								call(scr.view_shift, i, _dir, _dis);
							}
						}
					}
				}
			}
		}
		
		 // Wilt:
		if(
			skill_get(skill)    == 0 ||
			skill_get("reroll") != 0 ||
			("ntte_reroll_hud" in GameCont && GameCont.ntte_reroll_hud != undefined)
		){
			alive = false;
		}
		
		 // Interact:
		else if(instance_exists(prompt) && player_is_active(prompt.pick)){
			 // Reroll:
			GameCont.ntte_reroll = skill;
			skill_set("reroll", true);
			
			 // Orchid Plant Skin Unlock:
			if(unlock){
				call(scr.unlock_set, "skin:orchid plant", true);
			}
			
			 // FX:
			sprite_index = spr.VaultFlowerHurt;
			image_index  = 0;
			with(call(scr.alert_create, self, call(scr.skill_get_icon, "reroll")[0])){
				image_speed = 0;
				alert       = {};
				snd_flash   = sndLevelUp;
			}
			for(var _ang = 0; _ang < 360; _ang += (360 / 10)){
				var	_l = 8 + (8 * dcos(_ang * 4)),
					_d = _ang + orandom(60);
					
				with(call(scr.fx, 
					x + lengthdir_x(_l, _d),
					y + lengthdir_y(_l, _d),
					[90, random_range(0.25, 1.5)],
					"VaultFlowerSparkle"
				)){
					depth = -8;
				}
			}
			/*repeat(8) with(call(scr.fx, [x, 16], [y - 4, 16], [90, random(2)], CaveSparkle)){
				depth = -8;
			}*/
			sound_play_pitchvol(sndStatueXP, 0.3, 2);
			with(player_find(prompt.pick)){
				sound_play(snd_crwn);
			}
			
			/*if(fork()){
				alive = false;
				while(button_check(0, "pick")) wait 0;
				if(instance_exists(self)){
					alive = true;
					with(instances_matching(obj.AlertIndicator, "target", self)){
						instance_destroy();
					}
				}
				exit;
			}*/
		}
		
		 // Effects:
		if(chance_ct(1, 12)){
			with(instance_create(x + orandom(12), (y - 6) + orandom(8), CaveSparkle)){
				depth = other.depth - 1;
			}
		}
		/*if(chance_ct(1, 10)){
			with(call(scr.fx, [x, 12], [(y - 4), 8], [90, 0.1], "VaultFlowerSparkle")){
				depth = other.depth + choose(-1, -1, 1);
			}
		}*/
	}
	
	 // Wilted:
	else{
		maxhealth = min(9, maxhealth);
		my_health = min(my_health, maxhealth);
		
		 // Sprites:
		if(spr_idle == spr.VaultFlowerIdle) spr_idle = spr.VaultFlowerWiltedIdle;
		if(spr_hurt == spr.VaultFlowerHurt) spr_hurt = spr.VaultFlowerWiltedHurt;
		if(spr_dead == spr.VaultFlowerDead) spr_dead = spr.VaultFlowerWiltedDead;
		
		 // Effects:
		if(chance_ct(1, 150)){
			with(VaultFlower_debris(x + orandom(12), (y - 4) + orandom(8), 0, 0)){
				with(call(scr.fx, x, y, [270 + orandom(60), 0.5], Dust)){
					image_blend = make_color_rgb(84, 58, 24);
					image_xscale /= 2;
					image_yscale /= 2;
				}
			}
		}
	}
	
	 // Hurt Effects:
	if(sprite_index == spr_hurt){
		if(image_index >= 1 && image_index < 1 + image_speed_raw){
			VaultFlower_debris(x, y, direction + orandom(random(180)), 2 + random(3.5));
		}
	}
	
	with(prompt) visible = other.alive;
	
#define VaultFlower_death
	 // Effects:
	for(var _dir = direction; _dir < direction + 360; _dir += (360 / 6)){
		call(scr.fx, x, y, [_dir + orandom(45), 3], Dust);
		VaultFlower_debris(x, y - 6, _dir + orandom(45), 4 + random(2));
		repeat(2){
			with(VaultFlower_debris(x, y - 6, _dir + orandom(45), random(4))){
				vspeed--;
			}
		}
	}
	call(scr.sound_play_at, x, y, sndPlantSnare, 0.8, 2.5);
	
	 // Secret:
	if(alive){
		call(scr.pet_create, x, y, "Orchid");
		
		 // Permadeath:
		GameCont.ntte_vault_flower = false;
		
		 // FX:
		repeat(20) with(call(scr.fx, x, (y - 6), [90 + orandom(100), random(4)], "VaultFlowerSparkle")){
			depth = -7;
			friction = 0.1;
			alarm0 = (speed / friction) + random(20);
		}
		sound_play_pitch(sndCrystalPropBreak, 1.2 + random(0.1));
		audio_sound_set_track_position(sound_play_pitchvol(sndUncurse, 0.5, 5), 0.66);
		/*with(instance_create(x, y, BulletHit)){
			sprite_index = sprSlugHit;
			image_speed = 0.25;
			depth = -3;
		}
		audio_sound_set_track_position(sound_play_pitchvol(sndVaultBossWin, 1.75, 0.5), 0.5);*/
	}
	
#define VaultFlower_prompt_meet
	if(instance_exists(TopCont)){
		script_bind_draw(VaultFlower_prompt_icon, TopCont.depth, self, other);
	}
	return true;
	
#define VaultFlower_prompt_icon(_inst, _instMeet)
	with(_instMeet){
		var _local = player_find_local_nonsync();
		if(player_is_active(_local) && player_get_show_prompts(index, _local)){
			with(_inst){
				 // Draw Mutation Icon:
				if(nearwep == other.nearwep && "skill" in creator){
					var	_x    = x - xoff,
						_y    = y + yoff - 13,
						_icon = call(scr.skill_get_icon, creator.skill);
						
					draw_sprite(_icon[0], _icon[1], _x, _y);
					
					 // Patience Icon:
					if(GameCont.hud_patience == creator.skill){
						draw_sprite(sprPatienceIconHUD, 0, _x, _y);
					}
				}
			}
		}
	}
	instance_destroy();
	
#define VaultFlower_debris(_x, _y, _dir, _spd)
	with(instance_create(_x, _y, Feather)){
		sprite_index = (variable_instance_get(other, "alive", true) ? spr.VaultFlowerDebris : spr.VaultFlowerWiltedDebris);
		image_index = irandom(image_number - 1);
		image_angle = orandom(30);
		image_speed = 0;
		depth = other.depth - 1;
		direction = _dir;
		speed = _spd;
		rot *= 0.5;
		//alarm0 = 60 + random(30);
		
		return self;
	}
	

#define VaultFlowerSparkle_create(_x, _y)
	with(instance_create(_x, _y, LaserCharge)){
		 // Visual:
		sprite_index = spr.VaultFlowerSparkle;
		image_angle  = random(360);
		image_xscale = 0;
		image_yscale = 0;
		depth        = -3;
		
		 // Alarms:
		alarm0 = random_range(10, 45);
		
		 // Grow & Shrink & Spin:
		if(fork()){
			wait 0;
			
			if(instance_exists(self)){
				var	_rot        = orandom(4),
					_alarmMax   = alarm0,
					_scaleAlarm = 5 + (alarm0 / 3),
					_scaleMax   = random_range(1, 1.25);
					
				while(instance_exists(self)){
					image_angle += _rot * current_time_scale;
					
					image_xscale = _scaleMax;
					if(alarm0 > _scaleAlarm){
						image_xscale *= 1 - (abs(alarm0 - _scaleAlarm) / max(1, abs(_alarmMax - _scaleAlarm)));
					}
					else{
						image_xscale *= alarm0 / _scaleAlarm;
					}
					image_yscale = image_xscale;
					
					wait 0;
				}
			}
			
			exit;
		}
		
		return self;
	}
	
	
/// GENERAL
#define game_start
	 // Delete Orchid Mutations:
	with(instances_matching_lt(call(scr.array_combine, obj.OrchidSkill, obj.OrchidBall), "id", GameCont.id)){
		instance_delete(self);
	}
	
#define ntte_setup_feather_chestprop(_inst)
	 // Chests Give Feathers (Parrot):
	with(_inst){
		with(call(scr.obj_create, x, y, "ParrotChester")){
			creator = other;
			switch(other.object_index){
				case WeaponChest:
					if(ultra_get("steroids", 1) > 0){
						num *= 2;
					}
					break;
					
				case AmmoChest:
				case AmmoChestMystery:
					if(ultra_get("steroids", 2) > 0){
						num *= 2;
					}
					break;
					
				case IDPDChest:
					num *= 2;
					break;
					
				case BigWeaponChest:
				case BigCursedChest:
					num *= 3;
					break;
					
				case GiantWeaponChest:
				case GiantAmmoChest:
					num *= 6;
					break;
			}
		}
	}
	
#define ntte_setup_feather_Pickup(_inst)
	 // Pickups Give Feathers (Parrot Throne Butt):
	with(instances_matching(_inst, "mask_index", mskPickup)){
		with(call(scr.obj_create, x, y, "ParrotChester")){
			creator = other;
			small   = true;
			num     = ceil(skill_get(mut_throne_butt));
		}
	}
	
#define ntte_setup_bonus_Shell(_inst)
	 // Cool Bonus Shells:
	var _instBonus = instances_matching_ne(Player, "bonus_ammo", 0, null);
	if(array_length(_instBonus)){
		with(instances_matching_ne(_inst, "sprite_index", sprSodaCan)){
			if(array_length(call(scr.instances_meeting_point, x, y, _instBonus))){
				sprite_index = (
					((sprite_get_bbox_right(sprite_index) + 1) - sprite_get_bbox_left(sprite_index) > 3)
					? spr.BonusShellHeavy
					: spr.BonusShell
				);
				if(chance(1, 5)){
					image_blend = merge_color(image_blend, c_blue, 0.25);
				}
			}
		}
	}
	
	 // Unbind Script:
	else if(lq_get(ntte, "bind_setup_bonus_Shell") != undefined){
		call(scr.ntte_unbind, ntte.bind_setup_bonus_Shell);
		ntte.bind_setup_bonus_Shell = undefined;
	}
	
#define ntte_setup_AmmoChest(_inst)
	 // Cursed Ammo Chests:
	ntte_setup_Mimic(instances_matching(_inst, "object_index", AmmoChest, AmmoChestMystery));
	
	 // Fix Steroids Mystery Chests:
	if(ultra_get("steroids", 2) > 0){
		with(instances_matching(instances_matching(_inst, "object_index", AmmoChestMystery), "sprite_index", sprAmmoChestMystery)){
			sprite_index = sprAmmoChestSteroids;
		}
	}
	
#define ntte_setup_Mimic(_inst)
	var	_cursedArea   = (crown_current == crwn_curses || GameCont.area == area_cursed_caves),
		_cursedPlayer = array_length(instances_matching_gt(instances_matching_gt(Player, "curse", 0), "bcurse", 0));
		
	 // Cursed:
	with(instances_matching(_inst, "curse", null)){
		if(chance(_cursedArea, (instance_is(self, Mimic) ? 3 : 5)) || chance(_cursedPlayer, _cursedPlayer + 1)){
			with(script_bind_step(cursedchester_step, 0, self)){
				event_perform(ev_step, ev_step_normal);
			}
		}
	}
	
#define cursedchester_step(_target)
	/*
		Waits until the level has finished generating to curse the given ammo chest
	*/
	
	if(instance_exists(_target)){
		if(!instance_exists(GenCont)){
			call(scr.chest_create,
				_target.x,
				_target.y,
				(instance_is(_target, enemy) ? "CursedMimic" : "CursedAmmoChest")
			);
			instance_delete(_target);
		}
	}
	else instance_destroy();
	
#define ntte_begin_step
	 // Bonus Spirits:
	if(instance_exists(Player)){
		var _inst = instances_matching_ne(Player, "bonus_spirit", null);
		if(array_length(_inst)) with(_inst){
			if(array_length(bonus_spirit)){
				 // Grant Grace:
				if(my_health <= 0 /*&& lsthealth > 0*/ && player_active){
					if(skill_get(mut_strong_spirit) <= 0 || canspirit != true){
						for(var i = array_length(bonus_spirit) - 1; i >= 0; i--){
							var _spirit = bonus_spirit[i];
							if(lq_defget(_spirit, "active", true)){
								my_health    = 1;
								spiriteffect = 5;
								
								 // Lost:
								with(_spirit){
									active       = false;
									sprite_index = sprStrongSpirit;
									image_index  = 0;
								}
								sound_play(sndStrongSpiritLost);
								
								break;
							}
						}
					}
				}
				
				 // Override Halos:
				with(instances_matching(instances_matching(StrongSpirit, "creator", self), "visible", true)){
					visible = false;
					array_push(other.bonus_spirit, {
						active       : false,
						sprite_index : sprite_index,
						image_index  : image_index
					});
				}
				
				 // Animate and Cull Spirits:
				with(bonus_spirit){
					if("active"       not in self) active = true;
					if("sprite_index" not in self) sprite_index = (active ? sprStrongSpiritRefill : sprStrongSpirit);
					if("image_index"  not in self) image_index = 0;
					
					 // Animate:
					if(active || sprite_index != mskNone){
						image_index += 0.4 * current_time_scale;
						if(image_index >= sprite_get_number(sprite_index)){
							if(active) sprite_index = sprHalo;
							else sprite_index = mskNone;
							image_index = 0;
						}
					}
					
					 // Gone:
					else other.bonus_spirit = call(scr.array_delete_value, other.bonus_spirit, self);
				}
				
				 // Wobble:
				if("bonus_spirit_bend" not in self){
					bonus_spirit_bend = 0;
					bonus_spirit_bend_spd = 0;
				}
				var _num = array_length(bonus_spirit) + (skill_get(mut_strong_spirit) > 0 && canspirit == true && !array_length(instances_matching(StrongSpirit, "creator", self)));
				bonus_spirit_bend_spd += hspeed_raw / (3 * max(1, _num));
				bonus_spirit_bend_spd += 0.1 * (0 - bonus_spirit_bend) * current_time_scale;
				bonus_spirit_bend += bonus_spirit_bend_spd * current_time_scale;
				bonus_spirit_bend_spd -= bonus_spirit_bend_spd * 0.15 * current_time_scale;
			}
			else{
				bonus_spirit_bend = 0;
				bonus_spirit_bend_spd = 0;
			}
		}
	}
	
	 // Mutation Pickup Drops:
	if(instance_exists(enemy)){
		var _inst = instances_matching(instances_matching_le(enemy, "my_health", 0), "mutationpickup_check", null);
		if(array_length(_inst)) with(_inst){
			if(!instance_is(self, CustomEnemy) || candie >= 1){
				mutationpickup_check = false;
				
				if(GameCont.hard > 3){
					if(enemy_boss){
						if(
							(!instance_exists(Generator) || !instance_is(self, Nothing)) &&
							(!instance_exists(LastChair) || !instance_is(self, Last))
						){
							mutationpickup_check = true;
							
							 // Is Last Boss on Level:
							with(enemy){
								if(my_health > 0 || id > other.id){
									if(enemy_boss){
										other.mutationpickup_check = false;
										break;
									}
								}
							}
							
							 // Pickup Time:
							if(mutationpickup_check){
								var	_x = x,
									_y = y;
									
								if(array_find_index(obj.PitSquid, self) >= 0){
									_x = xpos;
									_y = ypos;
								}
								
								if(position_meeting(_x, _y, Floor)){
									var	_type      = "",
										_health    = 0,
										_healthMax = 0;
										
									with(Player){
										_health    += my_health;
										_healthMax += maxhealth;
									}
									
									 // Spirit:
									if(_health <= ceil(_healthMax / 2) && chance(1, 1 + (_health / instance_number(Player)))){
										_type = "Spirit";
									}
									
									 // HammerHead:
									else if(chance(1 + GameCont.loops, 5 + GameCont.loops)){
										_type = "HammerHead";
										
										 // Sound:
										call(scr.sound_play_at, _x, _y, sndWeaponPickup,  0.3 + random(0.1));
										call(scr.sound_play_at, _x, _y, sndHammerHeadEnd, 0.2 + random(0.1), 1.5);
									}
									
									 // Create:
									if(_type != ""){
										var _chest = chance(ultra_get("fish", 1), 5);
										call(scr.obj_create,
											_x + orandom(4),
											_y + orandom(4),
											_type + (_chest ? "Chest" : "Pickup")
										);
										if(_chest){
											instance_create(x, y, FishA);
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	 // Bind Parrot Chest Setup Scripts:
	var _parrot = false;
	for(var i = 0; i < maxp; i++){
		if(player_get_race(i) == "parrot"){
			_parrot = true;
			break;
		}
	}
	var _bind = lq_get(ntte, "bind_setup_feather_chestprop");
	if(_parrot){
		if(_bind == undefined){
			ntte.bind_setup_feather_chestprop = call(scr.ntte_bind_setup, script_ref_create(ntte_setup_feather_chestprop), chestprop);
		}
	}
	else if(_bind != undefined){
		call(scr.ntte_unbind, _bind);
		ntte.bind_setup_feather_chestprop = undefined;
	}
	var _bind = lq_get(ntte, "bind_setup_feather_Pickup");
	if(_parrot && skill_get(mut_throne_butt) > 0){
		if(_bind == undefined){
			ntte.bind_setup_feather_Pickup = call(scr.ntte_bind_setup, script_ref_create(ntte_setup_feather_Pickup), Pickup);
		}
	}
	else if(_bind != undefined){
		call(scr.ntte_unbind, _bind);
		ntte.bind_setup_feather_Pickup = undefined;
	}
	
#define ntte_step
	if(instance_exists(Player)){
		 // Bonus Ammo:
		var _inst = instances_matching_ne(Player, "bonus_ammo", 0, null);
		if(array_length(_inst)){
			with(_inst){
				if(player_active){
					var _ammo = 0;
					
					 // Restore Ammo:
					if("bonus_ammo_save" in self){
						for(var i = min(array_length(ammo), array_length(bonus_ammo_save)) - 1; i >= 0; i--){
							var _diff = bonus_ammo_save[i] - ammo[i];
							if(_diff > 0){
								if(bonus_ammo_save[i] <= typ_amax[i] || ("bonus_ammo_tick" in self && bonus_ammo_tick != 0)){
									ammo[i] += _diff;
									_ammo   += _diff;
								}
							}
						}
					}
					bonus_ammo_save = array_clone(ammo);
					drawempty       = 0;
					drawemptyb      = 0;
					
					 // Restore Internal Ammo:
					if("bonus_ammo_save_internal" not in self){
						bonus_ammo_save_internal = [];
					}
					var _wepList = [wep, bwep];
					for(var i = 0; i < array_length(_wepList); i++){
						var _wep = _wepList[i];
						if(
							is_object(_wep)
							&& "ammo" in _wep
							&& "cost" in _wep
							&& i < array_length(bonus_ammo_save_internal)
						){
							var	_save = bonus_ammo_save_internal[i],
								_diff = (_save[1] - _wep.ammo);
								
							if(_save[0] == _wep && _diff > 0){
								_wep.ammo += _diff;
								_ammo     += _diff;
							}
						}
						bonus_ammo_save_internal[i] = [_wep, lq_defget(_wep, "ammo", 0)];
					}
					
					 // Timer:
					if("bonus_ammo_max" not in self || abs(bonus_ammo_max) < abs(bonus_ammo)){
						bonus_ammo_max = bonus_ammo;
					}
					if(bonus_ammo > 0){
						if("bonus_ammo_tick" not in self){
							bonus_ammo_tick = 0;
						}
						if(bonus_ammo_tick == 0 && _ammo > 0){
							bonus_ammo_tick = 1;
						}
						
						var	_last = bonus_ammo,
							_tick = bonus_ammo_tick * current_time_scale;
							
						bonus_ammo -= _tick;
						
						 // End:
						if(bonus_ammo <= 0){
							bonus_ammo               = 0;
							bonus_ammo_max           = 0;
							bonus_ammo_tick          = 0;
							bonus_ammo_flash         = 0;
							bonus_ammo_save          = [];
							bonus_ammo_save_internal = [];
						}
						
						 // Particles:
						else if((_last % 30) < _tick){
							with(instance_create(x, y, WepSwap)){
								sprite_index = sprGunWarrant;
								image_angle  = other.gunangle - 90;
								image_blend  = c_aqua;
								creator      = other;
							}
						}
					}
					
					 // Effects:
					if(_ammo > 0 || bonus_ammo == 0){
						 // Sound:
						sound_play_pitchvol(
							choose(sndGruntFire, sndRogueRifle),
							(0.6 + random(1)) / clamp(_ammo, 1, 3),
							0.8 + (0.1 * _ammo)
						);
						
						 // Visual:
						with(call(scr.obj_create, x, y, "BonusAmmoFire")){
							creator = other;
							
							 // Normal:
							if(other.bonus_ammo != 0){
								image_index  = max(2 - image_speed, 3 - (_ammo / 3));
								image_xscale = 0.425 + (0.075 * _ammo);
								image_xscale = min(1.2, image_xscale);
								image_yscale = image_xscale;
							}
							
							 // End:
							else{
								sound_play_pitchvol(sndLaserCannon, 1.4 + random(0.2), 0.8);
								sound_play_pitchvol(sndEmpty,       0.8 + random(0.1), 1);
							}
						}
						
						 // HUD:
						bonus_ammo_flash = 1;
					}
				}
				else bonus_ammo_tick = 0;
			}
			
			 // Bind Shell Resprite Script:
			if(lq_get(ntte, "bind_setup_bonus_Shell") == undefined){
				ntte.bind_setup_bonus_Shell = call(scr.ntte_bind_setup, script_ref_create(ntte_setup_bonus_Shell), Shell);
			}
		}
		
		 // Eyes Custom Pickup Attraction:
		if(array_length(obj.CustomPickup)){
			var _inst = instances_matching(Player, "race", "eyes");
			if(array_length(_inst)){
				with(_inst){
					if(player_active && canspec && button_check(index, "spec")){
						var	_vx = view_xview[index],
							_vy = view_yview[index];
							
						with(call(scr.instances_in_rectangle, _vx, _vy, _vx + game_width, _vy + game_height, obj.CustomPickup)){
							if(!is_array(on_pull) || mod_script_call(on_pull[0], on_pull[1], on_pull[2])){
								var	_l = (1 + skill_get(mut_throne_butt)) * current_time_scale,
									_d = point_direction(x, y, other.x, other.y),
									_x = x + lengthdir_x(_l, _d),
									_y = y + lengthdir_y(_l, _d);
									
								if(place_free(_x, y)) x = _x;
								if(place_free(x, _y)) y = _y;
							}
						}
					}
				}
			}
		}
	}
	
	 // Grabbing Custom Pickups:
	if(array_length(obj.CustomPickup)){
		if(instance_exists(Player) || instance_exists(Portal)){
			var _inst = instances_matching_ne([Player, Portal], "id");
			if(array_length(_inst)){
				with(_inst){
					if(place_meeting(x, y, Pickup)){
						with(call(scr.instances_meeting_instance, self, obj.CustomPickup)){
							if(instance_exists(self) && place_meeting(x, y, other)){
								if(!is_array(on_open) || !mod_script_call(on_open[0], on_open[1], on_open[2])){
									 // Effects:
									if(sprite_exists(spr_open)){
										with(instance_create(x, y, SmallChestPickup)){
											sprite_index = other.spr_open;
											image_xscale = other.image_xscale;
											image_yscale = other.image_yscale;
											image_angle  = other.image_angle;
										}
									}
									sound_play(snd_open);
									
									instance_destroy();
								}
							}
						}
					}
				}
			}
		}
	}
	
	 // Prompt Collision:
	if(array_length(obj.Prompt)){
		 // Reset:
		var _instReset = instances_matching_ne(obj.Prompt, "pick", -1);
		if(array_length(_instReset)){
			with(_instReset){
				pick = -1;
			}
		}
		
		 // Player Collision:
		if(instance_exists(Player)){
			var _inst = instances_matching(obj.Prompt, "visible", true);
			if(array_length(_inst)){
				with(instances_matching(Player, "visible", true)){
					if(
						place_meeting(x, y, CustomObject)
						&& !place_meeting(x, y, IceFlower)
						&& !place_meeting(x, y, CarVenusFixed)
					){
						var _noVan = true;
						
						 // Van Check:
						if(instance_exists(Van) && place_meeting(x, y, Van)){
							with(call(scr.instances_meeting_instance, self, instances_matching(Van, "drawspr", sprVanOpenIdle))){
								if(place_meeting(x, y, other)){
									_noVan = false;
									break;
								}
							}
						}
						
						if(_noVan){
							var	_nearest  = noone,
								_maxDis   = null,
								_maxDepth = null;
								
							// Find Nearest Touching Indicator:
							if(instance_exists(nearwep)){
								_maxDis   = point_distance(x, y, nearwep.x, nearwep.y);
								_maxDepth = nearwep.depth;
							}
							with(call(scr.instances_meeting_instance, self, _inst)){
								if(place_meeting(x, y, other)){
									if(!instance_exists(creator) || creator.visible){
										if(!is_array(on_meet) || mod_script_call(on_meet[0], on_meet[1], on_meet[2])){
											if(_maxDepth == null || depth < _maxDepth){
												_maxDepth = depth;
												_maxDis   = null;
											}
											if(depth == _maxDepth){
												var _dis = point_distance(x, y, other.x, other.y);
												if(_maxDis == null || _dis < _maxDis){
													_maxDis  = _dis;
													_nearest = self;
												}
											}
										}
									}
								}
							}
							
							 // Secret IceFlower:
							with(_nearest){
								nearwep = instance_create(x + xoff, y + yoff, IceFlower);
								with(nearwep){
									name         = other.text;
									x            = xstart;
									y            = ystart;
									xprevious    = x;
									yprevious    = y;
									visible      = false;
									mask_index   = mskNone;
									sprite_index = mskNone;
									spr_idle     = mskNone;
									spr_walk     = mskNone;
									spr_hurt     = mskNone;
									spr_dead     = mskNone;
									spr_shadow   = -1;
									snd_hurt     = -1;
									snd_dead     = -1;
									size         = 0;
									team         = 0;
									my_health    = 99999;
									nexthurt     = current_frame + 99999;
								}
								with(other){
									nearwep = other.nearwep;
									if(button_pressed(index, "pick")){
										other.pick = index;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
#define ntte_end_step
	//if(instance_exists(Player)){
		 // HammerHead Pickup Persistence:
		if(instance_exists(GenCont)){
			var	_hammerMin = 20 * skill_get(mut_hammerhead),
				_inst      = instances_matching_gt(Player, "hammerhead", _hammerMin);
				
			if(array_length(_inst)) with(_inst){
				var _save = (hammerhead - _hammerMin);
				hammerhead_save = _save + variable_instance_get(self, "hammerhead_save", 0);
				hammerhead -= _save;
			}
		}
		else{
			var _inst = instances_matching_ne(Player, "hammerhead_save", 0, null);
			if(array_length(_inst)) with(_inst){
				hammerhead += hammerhead_save;
				hammerhead_save = 0;
			}
		}
		
		 // Bonus HP / Overheal:
		var _inst = instances_matching_ne(Player, "bonus_health", 0, null);
		if(array_length(_inst)) with(_inst){
			if(player_active){
				var	_col = merge_color(c_aqua, c_blue, random(0.4)),
					_spd = 0.5,
					_dir = direction,
					_dis = 12;
					
				 // Max:
				if("bonus_health_max" not in self || abs(bonus_health_max) < abs(bonus_health)){
					if("bonus_health_max" not in self || bonus_health_max == 0){
						lsthealth = min(lsthealth, my_health, maxhealth);
					}
					bonus_health_max = bonus_health;
				}
				
				 // Restore Health:
				var _heal = (ceil(lsthealth) - my_health);
				if(_heal > 0){
					my_health += _heal;
				}
				drawlowhp = 0;
				
				 // Timer:
				if(bonus_health > 0){
					if("bonus_health_tick" not in self){
						bonus_health_tick = 0;
					}
					if(bonus_health_tick == 0 && _heal > 0){
						bonus_health_tick = 1;
					}
					
					var	_last = bonus_health,
						_tick = bonus_health_tick * current_time_scale;
						
					bonus_health -= _tick;
					
					 // End:
					if(bonus_health <= 0){
						bonus_health       = 0;
						bonus_health_max   = 0;
						bonus_health_tick  = 0;
						bonus_health_flash = 0;
						
						 // HUD Flash:
						sprite_index = spr_hurt;
						image_index  = 0;
						
						 // Effects:
						sound_play_pitchvol(sndLaserCannon, 1.4 + random(0.2), 0.8);
						sound_play_pitchvol(sndEmpty,       0.8 + random(0.1), 1.0);
						with(instance_create(x, y, BulletHit)){
							sprite_index = sprThrowHit;
							image_xscale = random_range(2/3, 1);
							image_yscale = image_xscale;
							image_blend  = _col;
							image_speed  = 0.5;
							depth        = -4;
							speed        = _spd + 0.5;
							direction    = _dir;
						}
					}
					
					 // Particles:
					else if((_last % 15) < _tick){
						var	_len = random_range(4, 12),
							_dir = wave * 8;
							
						with(instance_create(x + lengthdir_x(_len, _dir), y + lengthdir_y(_len, _dir), FireFly)){
							sprite_index = spr.BonusFX;
							depth = other.depth - 1;
						}
					}
				}
				
				 // Effects:
				if(_heal > 0){
					 // Sound:
					call(scr.sound_play_at, x, y, sndRogueAim, 2.0 + random(0.5), 0.7);
					call(scr.sound_play_at, x, y, sndHPPickup, 0.6 + random(0.1), 0.7);
					
					 // Visual:
					if("bonus_health_flash" not in self || bonus_health_flash <= 0){
						var	_x1 = x,
							_y1 = y,
							_x2 = x,
							_y2 = y;
							
						for(var _ang = _dir; _ang <= _dir + 360; _ang += (360 / 16)){
							_x1 = x + lengthdir_x(_dis, _ang);
							_y1 = y + lengthdir_y(_dis, _ang);
							if(_ang > _dir){
								with(instance_create(_x1, _y1, BoltTrail)){
									image_xscale = point_distance(_x1, _y1, _x2, _y2) * 1.1;
									image_yscale = 1.5 + dsin(_dir + _ang);
									image_angle  = point_direction(_x1, _y1, _x2, _y2);
									image_blend  = _col;
									depth        = -4;
									speed        = _spd;
									direction    = _dir;
									if(other.bonus_health != 0){
										image_yscale = max(1.7, image_yscale);
									}
								}
							}
							_x2 = _x1;
							_y2 = _y1;
						}
					}
					with(instance_create(x, y, BulletHit)){
						sprite_index = sprPortalClear;
						image_xscale = 0.4;
						image_yscale = image_xscale;
						image_speed  = 1;
						depth        = -3;
						speed        = _spd;
						direction    = _dir;
					}
					with(instance_create(x, y, BulletHit)){
						visible      = false;
						sprite_index = sprImpactWrists;
						image_blend  = _col;
						speed        = _spd;
						direction    = _dir;
					}
					
					 // HUD:
					bonus_health_flash = 1;
				}
			}
		}
		
		 // Red Weapon Pickup Ammo:
		if(instance_exists(WepPickup)){
			var _inst = instances_matching_gt(WepPickup, "ammo", 0);
			if(array_length(_inst)) with(_inst){
				if(place_meeting(x, y, Player)){
					if(call(scr.weapon_get, "red", wep) > 0){
						with(call(scr.instance_nearest_array, x, y, instances_matching_ne(Player, "red_ammo", null))){
							other.ammo = false;
							
							 // Crown of Protection:
							if(crown_current == crwn_protection){
								var _lastWep = other.wep;
								other.wep = wep_revolver;
								event_perform(ev_collision, WepPickup);
								other.wep = _lastWep;
							}
							
							 // Normal:
							else{
								var _num = 1;
								red_ammo = min(red_ammo + _num, red_amax);
								
								 // Text:
								pickup_text(
									RedAmmo_text,
									((red_ammo < red_amax) ? "add" : "max"),
									_num
								);
							}
						}
					}
				}
			}
		}
	//}
	
	 // Portal Mutation Update:
	if(instance_exists(Portal) && array_length(instances_matching_le(Portal, "endgame", 0))){
		if(instance_exists(Player)){
			if("ntte_portal_closed" not in GameCont || !GameCont.ntte_portal_closed){
				GameCont.ntte_portal_closed = true;
				
				 // Tick Orchid Portal Mutations:
				if(array_length(obj.OrchidSkill)){
					var _inst = instances_matching_gt(instances_matching(obj.OrchidSkill, "type", "portal"), "time", 0);
					if(array_length(_inst)){
						with(_inst){
							time      -= min(time, 1);
							flash      = 2;
							star_scale = 4/5;
						}
						
						 // Sound:
						var _lastSeed = random_get_seed();
						sound_play_pitch(sndMut, 1.5 + orandom(0.2));
						random_set_seed(_lastSeed);
					}
				}
				
				 // Reduce Annihilation Counters:
				if("annihilation_list" in GameCont){
					with(GameCont.annihilation_list){
						if(ammo > 0 && --ammo <= 0){
							GameCont.annihilation_list = call(scr.array_delete_value, GameCont.annihilation_list, self);
						}
					}
				}
				
				 // Reduce Crown of Crime Bounty:
				/*if("ntte_crime_active" not in GameCont || !GameCont.ntte_crime_active){
					if("ntte_crime_bounty" in GameCont && GameCont.ntte_crime_bounty > 0){
						GameCont.ntte_crime_bounty = max(0, GameCont.ntte_crime_bounty - 1);
						
						with(instances_matching_le(Portal, "endgame", 0)){
							var _instAlert = call(scr.crime_alert, x, y, 120, 30);
							with(_instAlert){
								flash = 3;
							}
							with(_instAlert[1]){
								with(call(scr.instance_clone, self)){
									image_index = min(image_index + 1, image_number - 1);
									depth       = other.depth + 1;
								}
								flash     = 15;
								snd_flash = sndIcicleBreak;
							}
						}
					}
				}*/
			}
		}
	}
	else if("ntte_portal_closed" in GameCont && GameCont.ntte_portal_closed){
		GameCont.ntte_portal_closed = false;
	}
	
#define ntte_draw_shadows
	 // Weapons Stuck in Ground:
	if(array_length(obj.WepPickupGrounded)){
		with(instances_matching_ne(obj.WepPickupGrounded, "id")){
			draw_sprite(spr_shadow, 0, x + spr_shadow_x, y + spr_shadow_y);
		}
	}
	
#define ntte_draw_bloom
	 // Bonus Ammo FX:
	if(array_length(obj.BonusAmmoFire)){
		with(instances_matching_ne(obj.BonusAmmoFire, "id")){
			draw_sprite_ext(sprite_index, image_index, x, y, image_xscale * 2, image_yscale * 2, image_angle, image_blend, image_alpha * ((image_xscale + image_yscale) / 12));
		}
	}
	
#define ntte_draw_dark(_type)
	switch(_type){
		
		case "normal":
		case "end":
		
			var _gray = (_type == "normal");
			
			 // Shops:
			if(array_length(obj.ChestShop)){
				var _r = 32 + (48 * _gray);
				with(instances_matching_ne(obj.ChestShop, "id")){
					draw_circle(
						lerp(x, xstart, 0.2) - 1,
						lerp(y, ystart, 0.2) - 1,
						(_r * clamp(open_state, 0, 1)) + random(1),
						false
					);
				}
			}
			
			 // Bonus Pickups:
			if(array_length(obj.BonusPickup)){
				var _r = 16 + (32 * _gray);
				with(instances_matching_ne(obj.BonusPickup, "id")){
					draw_circle(x - 1, y - 1, _r + random(2), false);
				}
			}
			
			 // Bonus Chests:
			if(array_length(obj.BonusChest) || array_length(obj.BonusMimic)){
				var _r = 16 + (48 * _gray);
				with(instances_matching_ne(call(scr.array_combine, obj.BonusChest, obj.BonusMimic), "id")){
					draw_circle(x - 1, y - 1, _r + random(2), false);
				}
			}
			
			 // Vault Flower:
			if(array_length(obj.VaultFlower)){
				var _inst = instances_matching(obj.VaultFlower, "alive", true);
				if(array_length(_inst)){
					var _r = 24 + (40 * _gray) + (2 * sin(current_frame / 10));
					with(_inst){
						draw_circle(x - 1, y - 1, _r, false);
					}
				}
			}
			
			 // Mutation Orbs:
			if(array_length(obj.OrchidBall)){
				var _r = 32 + (64 * _gray) + random(8);
				with(instances_matching(obj.OrchidBall, "visible", true)){
					draw_circle(x - 1, y - 1, _r, false);
				}
			}
			
			break;
			
	}
	
#define draw_bonus_spirit
	//if(instance_exists(Player)){
		var _inst = instances_matching(instances_matching_ne(Player, "bonus_spirit", null), "visible", true);
		if(array_length(_inst)){
			var _lag = false;
			
			if(lag) trace_time();
			
			with(_inst){
				var _num = array_length(bonus_spirit);
				if(_num > 0){
					var	_bend = (("bonus_spirit_bend" in self) ? bonus_spirit_bend : 0),
						_dir  = 90,
						_dis  = 7,
						_x    = x,
						_y    = y + sin(wave * 0.1);
						
					if(skill_get(mut_strong_spirit) > 0 && canspirit == true && !array_length(instances_matching(StrongSpirit, "creator", self))){
						_x += lengthdir_x(_dis, _dir);
						_y += lengthdir_y(_dis, _dir);
						_dir += _bend;
					}
					
					for(var i = 0; i < _num; i++){
						draw_sprite_ext(lq_defget(bonus_spirit[i], "sprite_index", mskNone), lq_defget(bonus_spirit[i], "image_index", 0), _x, _y, 1, 1, _dir - 90, c_white, 1);
						_x += lengthdir_x(_dis, _dir);
						_y += lengthdir_y(_dis, _dir);
						_dir += _bend;
					}
					
					_lag = true;
				}
			}
			
			if(_lag && lag) trace_time(script[2]);
		}
	//}
	
#define pickup_alarm(_time, _loopDecay)
	/*
		Returns the alarm0 to set on a pickup, affected by loop and crown of haste
		
		Args:
			time      - The pickup's base alarm value
			loopDecay - The percentage decay per loop
	*/
	
	 // Loop:
	_time /= 1 + (GameCont.loops * _loopDecay);
	
	 // Haste:
	if(crown_current == crwn_haste){
		_time /= (instance_is(self, BigRad) ? 2 : 3);
	}
	
	return _time;
	
#define pickup_text // text, ?type, ?num
	/*
		Creates a PopupText with the given text modified by the given type (and number if using type "add")
		If called from a Player, the text will only appear on that Player's screen
		Automatically supports the current locale
		
		Args:
			text - The main text
			type - The modifier, can be "add", "max", "low", "ins", "out", or "got" (leave undefined for none)
			num  - The number to be used with type "add"
			
		Ex:
			pickup_text("BULLETS", "add", 32)                == "+32 BULLETS"
			pickup_text("HP", "max")                         == "MAX HP"
			pickup_text("RADS", "low")                       == "LOW RADS"
			pickup_text("RADS", "ins")                       == "NOT ENOUGH RADS"
			pickup_text("BOLTS", "out")                      == "EMPTY"
			pickup_text(weapon_get_name(wep_slugger), "got") == "SLUGGER!"
	*/
	
	var	_text     = argument[0],
		_type     = ((argument_count > 1) ? argument[1] : undefined),
		_num      = ((argument_count > 2) ? argument[2] : undefined),
		_ammo     = ["MELEE", "BULLETS", "SHELLS", "BOLTS", "EXPLOSIVES", "ENERGY"],
		_ammoType = -1;
		
	 // Determine Ammo Type (Auto-Locale Support):
	for(var i = array_length(_ammo) - 1; i >= 0; i--){
		if(_text == loc(`Ammo:Type:${i}`, _ammo[i])){
			_ammoType = i;
		}
	}
	
	 // Create Popup Text:
	with(instance_create(x, y, PopupText)){
		switch(_type){
			
			case "add": // +# TEXT
			
				switch(_text){
					
					case "HP":
					
						text = call(scr.loc_format, "Pickups:AddHealth", "+% HP", _num);
						
						break;
						
					case "PORTAL STRIKES":
					
						text = loc(
							`Pickups:AddStrikes:${_num}`,
							call(scr.loc_format, "Pickups:AddStrikes", "+% PORTAL STRIKES", _num)
						);
						
						break;
						
					default:
					
						 // Ammo Types:
						if(_ammoType >= 0){
							text = call(scr.loc_format,
								`Pickups:AddAmmo:${_ammoType}`,
								call(scr.loc_format, "Pickups:AddAmmo", "+%1 %2", "%", _text),
								_num
							);
						}
						
						 // Normal:
						else text = call(scr.loc_format, "Pickups:AddAmmo", "+%1 %2", _num, _text);
						
				}
				
				 // Flip Sign:
				if(_num < 0){
					text = string_replace_all(text, "+", "");
				}
				
				break;
				
			case "max": // MAX TEXT
			
				switch(_text){
					
					case "HP":
					
						text = loc("Pickups:MaxHealth", "MAX HP");
						
						break;
						
					case "PORTAL STRIKES":
					
						text = loc("Pickups:MaxStrikes", "MAX PORTAL STRIKES");
						
						break;
						
					default:
					
						text = call(scr.loc_format, "Pickups:MaxAmmo", "MAX %", _text);
						
						 // Ammo Types:
						if(_ammoType >= 0){
							text = loc(`Pickups:MaxAmmo:${_ammoType}`, text);
						}
						
				}
				
				break;
				
			case "low": // LOW TEXT
			
				switch(_text){
					
					case "HP":
					
						text = loc("HUD:LowHealth", "LOW HP");
						
						break;
						
					default:
					
						text = call(scr.loc_format, "HUD:LowAmmo", "LOW %", _text);
						
						 // Ammo Types:
						if(_ammoType >= 0){
							text = loc(`HUD:LowAmmo:${_ammoType}`, text);
						}
						
				}
				
				break;
				
			case "ins": // NOT ENOUGH TEXT
			
				switch(_text){
					
					case "RADS":
					
						text = loc("HUD:InsRads", "NOT ENOUGH RADS");
						
						break;
						
					default:
					
						text = call(scr.loc_format, "HUD:InsAmmo", "NOT ENOUGH %", _text);
						
						 // Ammo Types:
						if(_ammoType >= 0){
							text = loc(`HUD:InsAmmo:${_ammoType}`, text);
						}
						
				}
				
				break;
				
			case "out": // EMPTY
			
				text = call(scr.loc_format, "HUD:NoAmmo", "EMPTY", _text);
				
				 // Ammo Types:
				if(_ammoType >= 0){
					text = loc(`HUD:NoAmmo:${_ammoType}`, text);
				}
				
				break;
				
			case "got": // TEXT!
			
				text = call(scr.loc_format, "HUD:GotWeapon", "%!", _text);
				
				break;
				
			default: // TEXT
			
				text = _text;
				
		}
		
		 // Target Player's Screen:
		if(instance_is(other, Player)){
			target = other.index;
		}
		
		return self;
	}
	
	return noone;
	
	
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