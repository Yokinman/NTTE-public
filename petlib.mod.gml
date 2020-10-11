#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	lag = false;
	
	 // Bind Scripts:
	//script_bind("OctoBubbleDraw", CustomDraw, script_ref_create(octobubble_draw), -3, true);
	script_bind("WebDraw",        CustomDraw, script_ref_create(web_draw),         6, true);
	script_bind("WebDrawPost",    CustomDraw, script_ref_create(web_draw_post),    1, true);
	
	 // Pet Parrot Bobbing:
	global.parrot_bob = ds_map_create();
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro Pet instances_matching(CustomHitme, "name", "Pet")

#macro pet_target_inst instances_matching_ne(instances_matching_ne([enemy, Player, Sapling, Ally, SentryGun, CustomHitme], "team", team, 0), "mask_index", mskNone)

#macro player_moving (canwalk && (button_check(index, "nort") || button_check(index, "sout") || button_check(index, "east") || button_check(index, "west")))

#define CoolGuy_create
	 // Visual:
	spr_shadow   = shd16;
	spr_shadow_y = 4;
	
	 // Vars:
	maxspeed    = 3.5;
	poop        = 1;
	poop_delay  = 0;
	combo       = 0;
	combo_text  = noone;
	combo_texty = 0;
	combo_delay = 0;
	kills_last  = GameCont.kills;
	
	 // Stat:
	if("combo" not in stat){
		stat.combo = 0;
	}
	
#define CoolGuy_ttip
	return [
		"JUST A COOL GUY",
		"BRO",
		"HIGH SCORE!",
		"BACKWARD CAPS ARE COOL"
	];
	
#define CoolGuy_stat(_name, _value)
	if(_name == ""){
		return spr.PetCoolGuyIdle;
	}
	
#define CoolGuy_step
	 // Kill Combos:
	if(instance_exists(leader) && GameCont.kills > kills_last){
		combo += (GameCont.kills - kills_last);
		combo_delay = 40;
	}
	kills_last = GameCont.kills;
	
	 // Combo Counter:
	if(combo >= 2){
		 // Combo Color:
		var	c = [c_white, make_color_rgb(255, 230, 70), make_color_rgb(50, 210, 255), make_color_rgb(255, 110, 25), make_color_rgb(255, 110, 150)],
			_lvl = max(0, floor(combo / 10)),
			_col;
			
		if(_lvl < array_length(c)){
			_col = c[_lvl];
		}
		else{
			_col = c[(wave * (combo / 150)) % array_length(c)];
		}
		
		 // Text:
		var	_off = round(min(3, floor(combo / 5))),
			_x = x + hspeed_raw + orandom(_off),
			_y = y + vspeed_raw + orandom(_off) - 8 + combo_texty,
			_text = `x${combo}`;
			
		if(_lvl >= array_length(c)){
			_text = "COMBO#" + _text;
		}
		if(combo > stat.combo){
			_text += "!";
		}
		
		if(!instance_exists(combo_text)){
			combo_text = instance_create(0, 0, PopupText);
		}
		with(combo_text){
			text = _text;
			alarm1 = 15;
			alarm2 = -1;
			with(self){
				event_perform(ev_alarm, 2);
			}
			if(_col != c_white || _lvl >= array_length(c)){
				text = `@(color:${_col})#` + text;
			}
			
			x = _x;
			y = _y - (string_height(string_replace_all(text, "#", chr(13) + chr(10))) - 8);
			speed = 0;
		}
		
		combo_texty += (-8 - combo_texty) * 0.5 * current_time_scale;
	}
	else{
		combo_text = noone;
		combo_texty = 0;
	}
	
	 // Combo End:
	if(combo_delay > 0) combo_delay -= current_time_scale;
	else{
		if(combo > 0){
			 // Launch Combo Text:
			with(combo_text){
				vspeed = -4.5;
				friction = 1/3;
				time += (other.combo / 5);
			}
			if(combo >= 10){
				sound_play_pitchvol(sndCrownNo, 1.4, 0.5 + (combo / 50));
				sound_play_pitchvol((combo >= 50) ? sndLevelUltra : sndLevelUp, 0.8, (combo / 25));
			}
			
			 // Highscore!
			if(combo > stat.combo){
				stat.combo = combo;
				if(combo >= 10){
					with(combo_text) text += "@w#NEW RECORD";
				}
			}
			
			 // Poop Time:
			var _add = floor(combo / 5);
			if(_add > 0){
				if(poop <= 0){
					poop_delay = 30;
					alarm0 = poop_delay + 10;
				}
				poop += _add;
			}
		}
		combo = 0;
	}
	
	 // Poopin'
	if(!instance_exists(leader)) poop_delay = 30;
	if(poop_delay > 0){
		poop_delay -= current_time_scale;
	}
	else if(poop > 0){
		 // Delicious Pizza Juices:
		repeat(4){
			with(scrFX(x + orandom(2), y + 1, 1, "WaterStreak")){
				hspeed = 2 * -other.right;
				image_angle = direction;
				image_blend = make_color_rgb(255, 120, 25);
				image_xscale /= 2;
				image_yscale /= 2;
				depth = -1;
			}
		}
		if(poop >= 2){
			repeat(poop / 2){
				with(scrFX(x, y, 1, Dust)){
					sprite_index = sprBreath;
					image_index = irandom(4);
					image_blend = make_color_rgb(255, 105, 10);
					hspeed -= random(2) * other.right;
					vspeed += orandom(other.poop / 12);
					image_angle = direction + 180;
					image_xscale *= 2;
					image_yscale *= 2;
					growspeed /= 2;
					rot /= 2;
				}
			}
		}
		sound_play_pitchvol(sndHPPickup,        0.8 + random(0.2), 0.8);
		sound_play_pitchvol(sndFrogExplode,     1.2 + random(0.8), 0.8);
		
		 // Determine Pizza Output:
		var _inst = noone,
			_x = x + orandom(4),
			_y = y + orandom(4);
			
		if(chance(1, 2) && !chance(4, poop)){
			_inst = chest_create(_x, _y, "PizzaChest", false);
			poop -= 2;
		}
		else if(poop >= 2 && chance(1, 3)){
			_inst = obj_create(_x, _y, "PizzaStack");
			poop -= 2;
		}
		else{
			_inst = obj_create(_x, _y, "Pizza");
			poop--;
		}
		
		 // Excrete:
		with(_inst){
			hspeed = 3 * -other.right;
			vspeed = orandom(1);
			if(instance_is(self, prop)){
				x += hspeed;
				y += vspeed;
			}
			if(!instance_is(self, HPPickup)){
				sound_play_pitchvol(sndEnergyHammerUpg, 1.4 + random(0.2), 0.4);
			}
		}
		hspeed += min(poop + 1, 4) * right;
		
		poop_delay = 8 / max(1, poop);
	}
	
	 // He just keep movin
	if(poop <= 0 || poop_delay > 10) speed = maxspeed;
	if(array_length(path) <= 0){
		with(path_wall) with(other){
			if(place_meeting(x + hspeed_raw, y + vspeed_raw, other)){
				if(place_meeting(x + hspeed_raw, y, other)) hspeed_raw *= -1;
				if(place_meeting(x, y + vspeed_raw, other)) vspeed_raw *= -1;
			}
		}
	}
	scrRight(direction);
	
#define CoolGuy_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	 // Poopy Shake:
	if(poop > 0 && poop_delay < 20){
		_x += sin(wave * 5) * 1.5;
	}
	
	 // Self:
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	
#define CoolGuy_alrm0(_leaderDir, _leaderDis)
	 // Follow Leader Around:
	if(instance_exists(leader)){
		if(_leaderDis > 24){
			 // Pathfinding:
			if(path_dir != null){
				if(chance(1, 3)) direction = path_dir + orandom(20);
				else direction += angle_difference(path_dir, direction) / 2;
			}
			
			 // Turn Toward Leader:
			else direction += angle_difference(_leaderDir, direction) / 2;
		}
		else direction += orandom(16);
		scrRight(direction);
		
		return 8;
	}
	
	 // Idle Movement:
	else{
		direction += orandom(16);
		scrRight(direction);
		
		return 10 + random(10);
	}
	
	
#define Orchid_create
	 // Vars:
	raddrop    = 0;
	skill_rads = 60;
	skill_inst = [];
	
	 // Stat:
	if("mutations" not in stat){
		stat.mutations = 0;
	}
	
#define Orchid_ttip
	return [
		"ELEGANT",
		"FLORID",
		"GENETIC MAGIC",
		"YOU WERE THE KING OF KARAT FLOWERS" // i love you jesus christ // jesus christ i love you yes i do
	];
	
#define Orchid_stat(_name, _value)
	if(_name == ""){
		return spr.PetOrchidIdle;
	}
	
#define Orchid_step
	wave += current_time_scale;
	
	 // Mutate:
	if(raddrop >= skill_rads){
		raddrop -= skill_rads;
		
		 // Random Mutation:
		with(obj_create(x, y, "OrchidBall")){
			//direction = other.direction + orandom(30);
			creator = other;
		}
		
		 // Stat:
		stat.mutations++;
		
		 // Effects:
		repeat(5) with(scrFX([x + hspeed, 12], [y + vspeed, 12], [90, random(1)], CaveSparkle)){
			depth = -8;
			image_speed = lerp(0.2, 0.4, speed);
			hspeed += other.hspeed / 1.5;
			vspeed += other.vspeed / 1.5;
		}
		
		 // Sounds:
		sound_play_pitchvol(sndFlyFire,     1.5,               0.8);
		sound_play_pitchvol(sndCrownRandom, 0.8 + random(0.3), 0.2);
	}
	skill_inst = instances_matching(instances_matching(CustomObject, "name", "OrchidBall", "OrchidSkill"), "creator", self);
	
	 // Sparkle:
	if(chance_ct(1, 15 / (1 + (0.5 * array_length(skill_inst))))){
		with(scrFX([x, 8], [y, 8], [90, 0.1], "VaultFlowerSparkle")){
			depth = other.depth + choose(-1, -1, 1);
		}
	}
	
#define Orchid_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	
	 // Bloom:
	var	_scale = lerp(1.5, 1.8, 0.5 + (0.5 * sin(wave / 10))),
		_alpha = lerp(0.05, 0.25, (raddrop + (skill_rads * array_length(skill_inst))) / skill_rads);
		
	draw_set_blend_mode(bm_add);
	draw_sprite_ext(_spr, _img, _x, _y, _xsc * _scale, _ysc * _scale, _ang, _col, _alp * _alpha);
	draw_set_blend_mode(bm_normal);
	
	
#define Mimic_create
	 // Visual:
	spr_open     = spr.PetMimicOpen;
	spr_hide     = spr.PetMimicHide;
	spr_bubble_y = -1;
	depth        = -1;
	
	 // Vars:
	mask_index   = mskFreak;
	maxspeed     = 2;
	push         = 0;
	wep          = wep_none;
	wep_inst     = noone;
	ammo         = true;
	curse        = 0;
	open         = false;
	hush         = 0;
	hushtime     = 0;
	prompt_mimic = prompt_create("DROP");
	
	 // Remember:
	with(["wep", "curse"]){
		array_push(other.history, self);
	}
	
	 // Stat:
	if("weapons" not in stat){
		stat.weapons = [];
	}
	
#define Mimic_ttip
	return [
		"EXTERNAL STORAGE",
		"GUN DEALER",
		"WHAT YOU NEED",
		"BUY SOMETHING"
	];
	
#define Mimic_stat(_name, _value)
	switch(_name){
		case "":
			return spr.PetMimicIdle;
			
		case "weapons": // Stored/Total
			var	_num = 0,
				_max = 0;
				
			if(is_array(_value)){
				var	_mods = mod_get_names("weapon"),
					_wild = [
						wep_revolver,
						wep_golden_revolver,
						wep_chicken_sword,
						wep_rusty_revolver,
						wep_rogue_rifle,
						wep_guitar,
						wep_frog_pistol,
						wep_black_sword,
						wep_golden_frog_pistol,
						"crabbone",
						"merge",
						"super teleport gun"
					];
					
				for(var i = 128 + array_length(_mods) - 1; i >= 0; i--){
					var _wep = ((i < 128) ? i : _mods[i - 128]);
					
					 // Found:
					if(array_find_index(_value, _wep) >= 0){
						_num++;
						_max++;
					}
					
					 // In the Wild:
					else if(weapon_get_area(_wep) >= 0 || array_find_index(_wild, _wep) >= 0){
						_max++;
					}
				}
			}
			
			return [_name, string(_num) + "/" + string(_max)];
	}

#define Mimic_anim
	if(sprite_index != spr_hurt || anim_end){
		if(speed > 0) sprite_index = spr_walk;
		else if(sprite_index != spr_walk || in_range(image_index, 3, 3 + image_speed)){
			sprite_index = (instance_exists(leader) ? spr_idle : spr_hide);
		}
	}

#define Mimic_step
	 // Weapon Storage:
	with(prompt_mimic) visible = false;
	if(instance_exists(leader)){
		 // Open Chest:
		if(place_meeting(x, y, Player)){
			walk = 0;
			sprite_index = spr_open;
			if(!open){
				open = true;
				
				 // Drop Weapon:
				if(wep != wep_none){
					wep_inst = instance_create(x, y, WepPickup);
					with(wep_inst){
						wep   = other.wep;
						ammo  = other.ammo;
						curse = other.curse;
					}
					wep = wep_none;
				}
				
				 // Effects:
				sound_play_hit_ext(sndGoldChest,  0.9 + random(0.2), 0.8 - hush);
				sound_play_hit_ext(sndMimicSlurp, 0.9 + random(0.2), 0.8 - hush);
				with(instance_create(x, y, FXChestOpen)) depth = other.depth - 1;
				hush = min(hush + 0.2, 0.3);
				hushtime = 60;
			}

			 // Not Holding Weapon:
			if(wep == wep_none && !place_meeting(x, y, WepPickup) && instance_exists(prompt_mimic)){
				with(prompt_mimic) visible = true;

				 // Place Weapon:
				with(player_find(prompt_mimic.pick)){
					if(canpick && wep != wep_none){
						if(curse <= 0){
							with(other){
								wep_inst = instance_create(x, y, WepPickup);
								wep_inst.wep = other.wep;
							}
							wep = wep_none;
							player_swap();
							
							 // Effects:
							sound_play_hit(sndSwapGold, 0.1);
							sound_play_hit(sndWeaponPickup, 0.1);
							with(other) with(instance_create(x + orandom(4), y + orandom(4), CaveSparkle)){
								depth = other.depth - 1;
							}
							
							break;
						}
						else sound_play_hit(sndCursedReminder, 0.05);
					}
				}
			}
			
			 // Weapon Collection Stat:
			with(instance_nearest(x, y, WepPickup)){
				if(!array_exists(other.stat.weapons, wep_raw(wep))){
					array_push(other.stat.weapons, wep_raw(wep));
				}
			}
		}
		
		 // Regrab Weapon:
		else if(open){
			open = false;
			wep_inst = noone;
			if(wep == wep_none){
				if(place_meeting(x, y, WepPickup)){
					with(instance_nearest_array(x, y, instances_matching(WepPickup, "visible", true))){
						if(place_meeting(x, y, other)){
							other.wep   = wep;
							other.ammo  = ammo;
							other.curse = curse;
							instance_destroy();
						}
					}
				}
			}
		}

		 // Weapon Collection Stat:
		if(!array_exists(stat.weapons, wep_raw(wep))){
			array_push(stat.weapons, wep_raw(wep));
		}
	}
	if(hushtime <= 0) hush = max(hush - 0.1, 0);
	else hushtime -= current_time_scale;
	
	 // Hold Wep:
	if(instance_exists(wep_inst)){
		with(wep_inst){
			x = other.x;
			y = other.y;
			speed = 0;
		}
	}
	
	 // Sparkle:
	if(frame_active(10 + orandom(2))){
		instance_create(x + orandom(12), y + orandom(12), CaveSparkle);
	}

#define Mimic_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);

	 // Wep Depth Fix:
	if(place_meeting(x, y, WepPickup)){
		with(WepPickup) if(place_meeting(x, y, other)){
			with(self){
				event_perform(ev_draw, 0);
			}
		}
	}

#define Mimic_alrm0(_leaderDir, _leaderDis)
	if(instance_exists(leader)){
		if(_leaderDis > 16){
			 // Pathfinding:
			if(path_dir != null){
				scrWalk(path_dir, 12);
				return irandom_range(3, walk);
			}
			
			 // Wander Toward Leader:
			else if(_leaderDis > 48){
				scrWalk(_leaderDir + orandom(10), 20 + random(max(0, _leaderDis - 64)));
			}
		}
	}
	
	return 30 + irandom(30);

#define Mimic_hurt(_hitdmg, _hitvel, _hitdir)
	if(sprite_index != spr_open){
		sprite_index = spr_hurt;
		image_index = 0;
	}


#define Parrot_create
	 // Visual:
	spr_shadow   = shd16;
	spr_shadow_y = 4;
	spr_bubble_y = -2;
	depth        = -3;
	
	 // Vars:
	maxspeed    = 3.5;
	perched     = noone;
	perched_x   = 0;
	perched_y   = 0;
	pickup      = noone;
	pickup_x    = 0;
	pickup_y    = 0;
	pickup_held = false;
	path_wall   = [Wall];
	
	 // Stat:
	if("pickups" not in stat){
		stat.pickups = 0;
	}
	
#define Parrot_ttip
	return [
		"PARROTS RETRIEVE @wPICKUPS",
		"HANDY",
		"THEY LIKE YOU",
		"HAND OVER HAND"
	];

#define Parrot_stat(_name, _value)
	if(_name == ""){
		return spr.PetParrotIdle;
	}

#define Parrot_anim
	sprite_index = enemy_sprite;
	
	 // Nowhere to Land:
	if(sprite_index != spr_hurt && instance_exists(SpiralCont) && !place_meeting(x, y, Floor)){
		sprite_index = spr_walk;
	}
	
#define Parrot_step
	 // In Water:
	if("wading" in self && (speed > 0 || (instance_exists(perched) && ("wading" not in perched || perched.wading <= 0)))){
		canwade = false;
		wading = 0;
	}
	else canwade = true;
	
	 // Grabbing Pickup:
	if(instance_exists(pickup)){
		if(pickup_held){
			if(pickup.x == pickup_x && pickup.y == pickup_y){
				with(pickup){
					x = other.x;
					y = other.y + 4;
					xprevious = x;
					yprevious = y;
					
					 // Keep pickup alive:
					if(blink < 30){
						blink = 30;
						visible = true;
					}
				}
				pickup_x = pickup.x;
				pickup_y = pickup.y;
			}
			else other.pickup = noone;
		}
		
		 // Grab Pickup:
		else if(place_meeting(x, y, pickup)){
			pickup_held = true;
			pickup_x = pickup.x;
			pickup_y = pickup.y;
			
			 // Stat:
			if("ntte_statparrot" not in pickup){
				pickup.ntte_statparrot = true;
				stat.pickups++;
			}
		}
		
		 // Speed Bonus:
		if(speed >= maxspeed - friction){
			speed += abs(1 * sin(wave / 4));
		}
	}
	else pickup_held = false;
	
	 // Perching:
	if(
		instance_exists(perched)
		&& perched.speed <= 0
		&& !instance_exists(pickup)
		&& ("race" not in perched || perched.race != "horror")
	){
		x = perched.x;
		y = perched.y;
		perched_x = 0;
		perched_y = sprite_get_bbox_top(perched.sprite_index) - sprite_get_yoffset(perched.sprite_index) - 4;
		spr_bubble_y = -2 + perched_y;
	}
	
	else{
		 // Unperch:
		if(perched != noone){
			perched = noone;
			x += perched_x;
			y += perched_y;
			spr_bubble_y -= perched_y;
			perched_x = 0;
			perched_y = 0;
			scrWalk(random(360), 16);
			if(!instance_exists(leader)) can_take = true;
		}
		
		 // Perch on Leader:
		if(instance_exists(leader) && leader.visible){
			if("race" not in leader || leader.race != "horror"){ // Horror is too painful to stand on
				if(point_distance(x, y, leader.x, leader.bbox_top - 8) < 8 && leader.speed <= 0 && !instance_exists(pickup)){
					perched = leader;
					sound_play_pitch(sndBouncerBounce, 1.5 + orandom(0.1));
				}
			}
		}
	}
	
#define Parrot_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	 // Perched:
	if(instance_exists(perched)){
		var _perch = perched;
		
		_x += perched_x;
		_y += perched_y;
		
		 // Sittin:
		with(PlayerSit){
			var _player = instances_matching(Player, "", null);
			if(_perch == _player[array_length(_player) - 1]){
				_perch = self;
			}
		}
		
		 // Bobbing:
		var _bob = Parrot_bob(_perch.sprite_index, _perch.image_index);
		_x += _bob[0] * (("right" in _perch) ? _perch.right : 1);
		_y += _bob[1];
	}
	
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	
#define Parrot_bob(_spr, _img)
	/*
		Returns Parrot pet's [x, y] bobbing offset for the given frame of a given sprite
	*/
	
	 // Setup:
	if(!ds_map_exists(global.parrot_bob, _spr)){
		var _bob = [];
		
		 // Find Sprite's Precise Right & Top Positions:
		for(var i = 0; i < sprite_get_number(_spr); i++){
			var _copy = sprite_duplicate_ext(_spr, i, 1);
			sprite_collision_mask(_copy, true, 0, 0, 0, 0, 0, 1, 0);
			array_push(_bob, [
				sprite_get_bbox_right(_copy),
				sprite_get_bbox_top(_copy)
			]);
			sprite_delete(_copy);
		}
		
		 // Reduce to Offsets:
		for(var i = array_length(_bob) - 1; i >= 0; i--){
			for(var j = array_length(_bob[i]) - 1; j >= 0; j--){
				_bob[i, j] -= _bob[0, j];
			}
		}
		
		global.parrot_bob[? _spr] = _bob;
	}
	
	 // Retrieve:
	var	_bob = global.parrot_bob[? _spr],
		_max = array_length(_bob);
		
	if(_max > 0){
		return _bob[((_img % _max) + _max) % _max];
	}
	
	return [0, 0];
	
#define Parrot_alrm0(_leaderDir, _leaderDis)
	if(instance_exists(leader)){
		 // Fly Toward Pickup:
		if(instance_exists(pickup)){
			if(!pickup_held){
				scrWalk(point_direction(x, y, pickup.x, pickup.y) + orandom(5), [6, 10]);
				return walk;
			}
		}
		else{
			pickup_held = false;
			
			 // Find Pickup:
			if(instance_exists(Pickup)){
				var _inst = instances_matching(Pickup, "mask_index", mskPickup);
				if(array_length(_inst)){
					var	_pickup = noone,
						_disMax = 400;
						
					with(_inst){
						var _dis = point_distance(x, y, other.x, other.y);
						if(_dis < _disMax){
							if(instance_seen(x, y, other)){
								if(array_length(instances_matching(Pet, "pickup", id)) <= 0){
									_pickup = id;
									_disMax = _dis;
								}
							}
						}
					}
					
					if(instance_exists(_pickup)){
						pickup = _pickup;
						return 1;
					}
				}
			}
		}

		 // Fly Toward Leader:
		if(perched != leader){
			 // Pathfinding:
			if(path_dir != null){
				scrWalk(path_dir + orandom(4), [4, 8]);
				return walk;
			}

			 // Wander Toward Leader:
			else{
				scrWalk(_leaderDir + orandom(30), [10, 20]);
				if(_leaderDis > 32) return walk;
			}
		}

		 // Real Parrot:
		else if(chance(1, 4)){
			with(leader){
				sound_play_hit_ext(sndSaplingSpawn,                      1.8 + random(0.2), 0.33);
				sound_play_hit_ext(choose(snd_wrld, snd_chst, snd_crwn), 1.6,               0.4);
			}
			
			 // Real:
			hspeed = 4 * right;
			with(instance_create(x + (8 * right) + perched_x, y - 4 + perched_y, Wind)){
				sprite_index = spr.PetParrotNote;
				image_xscale = choose(-1, 1);
				depth = other.depth - 1;
				
				hspeed = random_range(1, 1.4) * other.right;
				gravity = -abs(speed / 10);
				friction = 0.1;
			}
			
			return 40 + random(20);
		}
	}

	 // Look Around:
	if(!instance_exists(leader) || instance_exists(perched)){
		scrRight(random(360));
		return 30 + random(30);
	}

	return 20 + random(20);

#define Parrot_hurt(_hitdmg, _hitvel, _hitdir)
	if(!instance_exists(perched)){
		sprite_index = spr_hurt;
		image_index = 0;
		
		 // Movin'
		if(speed <= 0){
			scrWalk(_hitdir, maxspeed);
			var o = 6;
			x += lengthdir_x(o, direction);
			y += lengthdir_y(o, direction);
		}
	}


#define Salamander_create
	 // Visual:
	spr_chrg     = spr.PetSalamanderChrg;
	spr_shadow_y = -2;
	depth        = -3;
	
	 // Vars:
	mask_index        = mskAlly;
	dash              = false;
	dash_max          = 3;
	dash_add          = dash_max / 20;
	dash_charge       = 0;
	dash_charging     = false;
	dash_direction    = direction;
	right_delay       = 0;
	mount             = false;
	mount_y           = 0;
	prompt_mount_time = -1;
	prompt_mount_text = ["MOUNT", "DISMOUNT"];
	prompt_mount      = prompt_create(prompt_mount_text[mount]);
	with(prompt_mount){
		image_xscale = 2;
		image_yscale = 2;
		on_meet      = script_ref_create(Salamander_prompt_meet);
	}
	
	 // Stat:
	if("tossed" not in stat){
		stat.tossed = 0;
	}
	
#define Salamander_ttip
	return [
		"VEHICULAR COMBAT",
		"NITROUS",
		"PUNT"
	];
	
#define Salamander_stat(_name, _value)
	if(_name == ""){
		return spr.PetSalamanderIdle;
	}
	
#define Salamander_anim
	 // Charging Up:
	if(dash_charge > 0 && !dash){
		if(dash_charge < dash_max){
			sprite_index = spr_chrg;
			image_index = image_number * (dash_charge / dash_max);
		}
		else{
			sprite_index = spr_hurt;
		}
	}
	
	 // Normal:
	else sprite_index = enemy_sprite;
	
#define Salamander_step
	 // Mount/Unmount:
	var _pickup = prompt_mount;
	if(instance_exists(_pickup)){
		if(player_is_active(_pickup.pick) || (mount && !instance_exists(leader))){
			mount = !mount;
			mount_y = 0;
			
			 // Prompt:
			prompt_mount_time = (mount ? 0 : -1);
			_pickup.text = prompt_mount_text[mount];
			_pickup.creator = (mount ? leader : self);
			
			 // Move Rider:
			if(instance_exists(leader)){
				leader.vspeed = -3;
				if(mount){
					leader.x = lerp(leader.x, x, 0.5);
					leader.y = lerp(leader.y, y, 0.5);
				}
			}
			
			 // Effects:
			repeat(3) with(scrFX(x, y, 1.5, Smoke)){
				image_xscale /= 1.2;
				image_yscale /= 1.2;
			}
			if(mount){
				repeat(5) scrFX(x, y, 3, Dust);
				sound_play_hit_ext(sndSalamanderCharge, 1.3 + random(0.2), 1);
				sound_play_hit_ext(sndSalamanderFire, 1 + orandom(0.2), 0.5);
			}
			else{
				sound_play_hit_ext(sndSalamanderEndFire, 1 + random(0.2), 1.2);
			}
		}
		
		 // Hide Prompt:
		if(prompt_mount_time > 0){
			prompt_mount_time = max(0, prompt_mount_time - current_time_scale);
			
			 // Puff Out:
			if(prompt_mount_time <= 2){
				_pickup.text = prompt_mount_text[mount];
				if(prompt_mount_time > 0){
					_pickup.text = `@(color:${merge_color(c_black, c_white, (prompt_mount_time - 1) / 2)})` + _pickup.text;
				}
				else{
					sound_play_hit_ext(sndSalamanderEndFire, 1.5 + orandom(0.1), 1);
				}
			}
		}
		_pickup.visible = (prompt_mount_time != 0 && instance_exists(leader));
		
		 // Unhide Prompt:
		if(prompt_mount_time == 0){
			with(leader) if(canpick && button_pressed(index, "pick") && !instance_exists(nearwep)){
				other.prompt_mount_time = 40;
				sound_play_hit_ext(sndAppear, 1 + orandom(0.1), 0.8);
			}
		}
	}
	
	 // Dashing:
	if((dash_charge > 0 || dash_charging) && portal_angle == 0){
		var	_dashAdd = dash_add * (dash_charging ? 1 : -1) * current_time_scale,
			_dashChargeLast = dash_charge;
			
		dash_charge = min(dash_charge + _dashAdd, dash_max);
		
		if(dash){
			with((mount && instance_exists(leader)) ? leader : self){
				 // Movement:
				direction = angle_lerp(direction, other.dash_direction, 0.2 * current_time_scale);
				speed = friction + maxspeed + 2 + (2 * other.dash_charge);
				other.direction = direction;
				other.speed = speed;
				
				 // Dash Bash:
				var	_bx = 6,
					_by = 6,
					_team = team,
					_inst = instances_matching_ne(instances_matching_ne(instance_rectangle_bbox(bbox_left + hspeed_raw - _bx, bbox_top + vspeed_raw - _by, bbox_right + hspeed_raw + _bx, bbox_bottom + vspeed_raw + _by, hitme), "team", _team), "mask_index", mskNone);
					
				if(array_length(_inst) > 0){
					with(other){
						var _damage = 4 + ceil(4 * dash_charge);
						with(_inst){
							projectile_hit(self, _damage, (instance_is(self, prop) ? 0 : other.speed * 2/3), other.direction);
							
							if(instance_exists(self)){
								 // Kill FX:
								if(my_health <= 0 && size > 0 && !instance_is(self, prop)){
									sound_play_hit_ext(sndBigBanditMeleeHit, max(0.2, 0.7 - (size / 10)) + random(0.1), 0.8);
								}
								
								 // Punt:
								if(
									chance(speed, 12)
									&& my_health <= 0
									&& size == 1
									&& team != 0
									&& !instance_is(self, prop)
								){
									with(obj_create(x, y, "PalankingToss")){
										direction    = other.direction;
										speed        = other.speed;
										zspeed       = 5;
										zfriction    = 2/3;
										creator      = other;
										depth        = other.depth;
										mask_index   = other.mask_index;
										spr_shadow_y = other.spr_shadow_y;
										explo        = skill_get(mut_throne_butt);
										team         = _team;
										
										 // Try not to go outside level:
										with(other){
											if(!place_meeting(x + lengthdir_x(96, direction), y + lengthdir_y(96, direction), Floor)){
												other.speed /= 10;
											}
										}
									}
									
									 // Don't Die:
									my_health = max(my_health, 1);
									if("canfly" in self) canfly = true;
									
									 // Disable:
									alarm1 = -1;
									if(instance_is(self, CustomEnemy) || instance_is(self, CustomHitme)){
										for(var i = 0; i < 12; i++){
											alarm_set(i, -1);
										}
									}
									
									 // Stat:
									other.stat.tossed++;
								}
								
								 // Large Dude, Stops Charge:
								if((1 + size > other.dash_charge && !instance_is(self, prop)) || maxhealth > _damage){
									with(other){
										dash_charge = 0;
										sprite_index = spr_hurt;
										image_index = 0;
									}
									
									 // Effects:
									repeat(5){
										with(scrFX(x, y, [other.direction + orandom(20), 4], Smoke)){
											friction *= 2;
										}
									}
								}
							}
						}
					}
				}
				
				 // Bounce:
				if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
					var _lastSpeed = speed;
					if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -0.1;
					if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -0.1;
					other.dash_direction = direction;
					
					 // Wall Bonk:
					if(other.dash_charge >= 1){
						other.dash_charge = max(1, other.dash_charge - (other.dash_add * 4));
						
						with(instance_nearest_bbox(x, y, Wall)){
							var	_dis = 8,
								_dir = point_direction(bbox_center_x, bbox_center_y, other.x, other.y);
								
							repeat(5){
								with(scrFX(
									bbox_center_x + lengthdir_x(_dis, _dir),
									bbox_center_y + lengthdir_y(_dis, _dir),
									[_dir, random_range(3, 4)],
									Smoke
								)){
									image_index = irandom(image_number - 1);
									image_xscale /= 1.5;
									image_yscale /= 1.5;
									friction *= 3;
									depth = -4;
								}
							}
						}
						
						 // Sound:
						sound_play_hit_ext(sndSalamanderHurt, 1.4 + random(0.2), lerp(0.3, 0.8, 1 - (speed / _lastSpeed)));
					}
				}
			}
			
			 // Flame Trail:
			if(current_frame_active){
				if(dash_charge < 1){
					scrFX(x, y, [direction + orandom(30), 3], Smoke);
				}
				else{
					with(projectile_create(x, y, Flame, other.direction + orandom(20), random_range(3, 4))){
						sprite_index = sprSalamanderBullet;
					}
					if(chance(1, 5)){
						with(instance_create(x + orandom(8), y + orandom(8), GroundFlame)){
							alarm0 = 25 + random(15);
							image_blend = merge_color(image_blend, c_orange, random(1/4));
						}
					}
				}
			}
		}
		
		 // Charging:
		else{
			with((mount && instance_exists(leader)) ? leader : self){
				 // Slow:
				var _min = friction + 0.6;
				speed = clamp(speed, _min, _min + 1);
				other.speed = speed;
				
				 // Charging Direction:
				if(instance_is(self, Player)){
					 // Towards Direction:
					if(player_moving){
						other.dash_direction = angle_lerp(other.dash_direction, direction, 0.5 * current_time_scale);
					}
					
					 // Towards Mouse:
					else{
						other.dash_direction = point_direction(x, y, mouse_x[index], mouse_y[index]);
						direction = angle_lerp(direction, other.dash_direction + 180, 0.2 * current_time_scale);
						other.direction = direction;
					}
				}
			}
			
			 // Charging Effects:
			if(_dashChargeLast < dash_max){
				 // Sound:
				sound_play_hit_ext(sndSalamanderEndFire, lerp(0.8, 2, dash_charge / dash_max), 1.4);
				if(dash_charge >= dash_max){
					audio_sound_set_track_position(
						sound_play_hit_ext(sndSalamanderCharge, 1 + orandom(0.05), 1.8),
						0.05
					);
				}
			}
			
			 // Start Dashing:
			else if(!dash_charging){
				dash = true;
				dash_charge = dash_max;
				
				 // Force Direction:
				direction = dash_direction;
				with((mount && instance_exists(leader)) ? leader : self){
					direction = other.direction;
				}
				
				 // Shake:
				view_shake_at(x, y, dash_charge * 5);
				
				 // Sound:
				var	_inst = (instance_exists(Player) ? instance_nearest(x, y, Player) : self),
					_snd = audio_play_sound_at(sndFiretrap, _inst.x - x, _inst.y - y, 0, 64, 320, 1, false, 0);
					
				audio_sound_gain(_snd, 2, 0);
				audio_sound_pitch(_snd, 2 + orandom(0.2));
				audio_sound_set_track_position(_snd, 2.5 * (1 - (dash_charge / dash_max)));
			}
			
			 // Effects:
			if(chance_ct(dash_charge, 12)){
				if(chance(2, 3)){
					with(scrFX(x, y, [dash_direction + 180, 1], Smoke)){
						hspeed += other.hspeed;
						vspeed += other.vspeed;
					}
				}
				with(scrFX([x - (13 * right * image_xscale), 2 * image_xscale], y + random(4 * image_yscale), random(random(1)), FireFly)){
					sprite_index = spr.FlameSpark;
					depth = other.depth - 1;
				}
			}
		}
		
		 // End:
		if(dash_charge <= 0){
			right_delay = max(right_delay, 15);
		}
	}
	else{
		dash = false;
		dash_charge = 0;
		dash_direction = direction;
	}
	
	 // Riding:
	if(mount && instance_exists(leader) && portal_angle == 0){
		with(leader){
			 // Sittin, Not Walkin:
			if(sprite_index == spr_walk) sprite_index = spr_idle;
			
			 // Disable Active:
			var _inst = instances_matching(instances_matching(CustomObject, "name", "SalamanderCanSpec"), "creator", id);
			if(array_length(_inst) <= 0){
				_inst = instance_create(x, y, CustomObject);
				with(_inst){
					name        = "SalamanderCanSpec";
					alive       = true;
					creator     = other;
					canspec     = other.canspec;
					on_end_step = script_ref_create(Salamander_canspec_end_step);
					on_cleanup  = script_ref_create(Salamander_canspec_cleanup);
					with(self){
						event_perform(ev_step, ev_step_end);
					}
				}
			}
			with(_inst) alive = true;
			
			 // Charging Dash:
			if(!other.dash){
				other.dash_charging = ((other.dash_charging ? button_check(index, "spec") : button_pressed(index, "spec")) || usespec > 0);
			}
			
			 // Hold Frog:
			if(race == "frog" && !player_moving){
				speed = other.speed;
			}
		}
		
		 // Offset:
		var _lastMask = leader.mask_index;
		leader.mask_index = -1;
		mount_y = lerp(mount_y, 2 + pfloor(round(leader.bbox_bottom - leader.y), 2), 0.25 * current_time_scale);
		leader.mask_index = _lastMask;
		
		var _yAdd = 0;
		while(_yAdd != mount_y && place_free(leader.x, leader.y + _yAdd + sign(mount_y))){
			_yAdd += clamp(mount_y - _yAdd, -1, 1);
		}
		
		if(_yAdd != mount_y){
			mount_y = _yAdd;
			
			 // Push Away:
			with(leader){
				var _push = 1.8;
				if(player_moving) _push /= 3;
				vspeed -= _push * sign(_yAdd) * current_time_scale;
			}
		}
		
		 // Hold:
		with(leader){
			other.x = x;
			other.y = y + other.mount_y;
			other.hspeed = hspeed * place_free(x + hspeed_raw, y);
			other.vspeed = vspeed * place_free(x, y + vspeed_raw);
		}
		
		 // Effects:
		if(chance_ct(1, 60)){
			instance_create(x, y, Smoke);
		}
	}
	else dash_charging = false;
	
	 // Facing:
	if(right_delay > 0) right_delay -= current_time_scale;
	else{
		if(!dash && dash_charge > 0){
			scrRight(dash_direction);
		}
		else if(hspeed != 0){
			scrRight(direction);
		}
	}
	
#define Salamander_alrm0(_leaderDir, _leaderDis)
	alarm0 = 30;
	
	if(!mount && !dash && dash_charge <= 0){
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
	
#define Salamander_prompt_meet
	if(creator == other || variable_instance_get(creator, "leader") == other){
		return true;
	}
	return false;
	
#define Salamander_canspec_end_step
	if(alive && instance_exists(creator)){
		alive = false;
		if(creator.canspec != false){
			canspec = creator.canspec;
			creator.canspec = false;
		}
	}
	else instance_destroy();
	
#define Salamander_canspec_cleanup
	with(creator) canspec = other.canspec;
	
	
#define Scorpion_create
	 // Visual:
	spr_fire   = spr.PetScorpionFire;
	spr_shield = spr.PetScorpionShield;
	hitid      = [spr_idle, "SILVER SCORPION"];
	
	 // Sounds:
	snd_hurt = sndScorpionMelee;
	snd_dead = sndScorpionDie;
	
	 // Vars:
	mask_index    = mskFrogEgg;
	maxhealth     = 12;
	maxspeed      = 3.4;
	target        = noone;
	my_venom      = noone;
	scorpion_city = true;
	
	 // Remember:
	array_push(history, "scorpion_city");
	
	 // Stat:
	if("blocked" not in stat){
		stat.blocked = 0;
	}
	
#define Scorpion_ttip
	return [
		"SPIT VENOM",
		"ROCKSLIDE",
		"HIGH ON THE FOOD CHAIN"
	];
	
#define Scorpion_stat(_name, _value)
	if(_name == ""){
		return spr.PetScorpionIdle;
	}
	
#define Scorpion_anim
	if((sprite_index != spr_hurt && sprite_index != spr_shield) || anim_end){
		if(instance_exists(my_venom)) sprite_index = spr_fire;
		else sprite_index = enemy_sprite;
	}
	
#define Scorpion_step
	 // Collision:
	if(place_meeting(x, y, hitme)){
		with(instances_meeting(x, y, hitme)){
			if(place_meeting(x, y, other)){
				if(size < other.size){
					motion_add_ct(point_direction(other.x, other.y, x, y), 1);
				}
				with(other){
					motion_add_ct(point_direction(other.x, other.y, x, y), 1);
				}
			}
		}
	}
	
	 // Chargin:
	if(instance_exists(my_venom) && my_venom.charge){
		 // Aimin:
		if(instance_exists(target)){
			with(my_venom){
				direction += angle_difference(point_direction(x, y, other.target.x, other.target.y), direction) * 0.1 * current_time_scale;
				image_angle = direction;
				depth = other.depth - (direction >= 180);
			}
		}
		scrRight(my_venom.direction);
		
		 // Bouncy:
		with(path_wall) with(other){
			if(place_meeting(x + hspeed_raw, y + vspeed_raw, other)){
				if(place_meeting(x + hspeed_raw, y, other)) hspeed_raw *= -1;
				if(place_meeting(x, y + vspeed_raw, other)) vspeed_raw *= -1;
				scrRight(direction);
			}
		}
	}
	
#define Scorpion_alrm0(_leaderDir, _leaderDis)
	alarm0 = 20 + irandom(10);
	
	target = instance_nearest_array(x, y, pet_target_inst);
	
	if(sprite_index != spr_shield){
		if(instance_exists(leader)){
			var _leaderSeeTarget = instance_seen(leader.x, leader.y, target);
			
			 // Pathfinding:
			if(path_dir != null && (!instance_seen(x, y, target) || _leaderDis > 48)){
				scrWalk(path_dir + orandom(15), 15);
				return 1 + irandom(walk);
			}
			
			else{
				 // Follow Leader:
				if(_leaderDis > 28){
					scrWalk(_leaderDir + orandom(20), [10, 30]);
				}
				
				 // Attacking:
				if(instance_exists(target) && !instance_exists(my_venom)){
					if(instance_seen(x, y, target) && _leaderSeeTarget && _leaderDis <= 96){
						if(chance(2, 3)){
							sound_play_hit_ext(sndScorpionFireStart, 1.2, 3);
							
							 // Venom Ball:
							var _targetDir = point_direction(x, y, target.x, target.y);
							my_venom = projectile_create(x, y, "VenomBlast", _targetDir, 0);
							scrRight(_targetDir);
						}
					}
				}
			}
		}
		
		 // Wander:
		else{
			scrWalk(random(360), [10, 20]);
			return 20 + irandom(20);
		}
	}

#define Scorpion_hurt(_hitdmg, _hitvel, _hitdir)
	 // Hurt:
	if(my_health > 0 && sprite_index == spr_fire && instance_exists(leader)){
		enemy_hurt(_hitdmg, _hitvel, _hitdir);
	}

	 // Dodge/Shield:
	else{
		nexthurt = current_frame + 6;
		sprite_index = spr_shield;
		image_index = 0;

		motion_add(_hitdir, 2);
		walk = 0;

		stat.blocked++;

		 // Effects:
		sound_play_hit_ext(sndGoldScorpionHurt,		 1.4 + random(0.4), 1.8);
		sound_play_hit_ext(sndCursedPickupDisappear, 0.8 + random(0.4), 1.8);
		with(instance_create(x, y, ThrowHit)) depth = other.depth - 1;
	}

#define Scorpion_death
	 // Sound:
	sound_play_hit_ext(snd_dead, 0.8 + random(0.1), 1.5);
	sound_play_hit_ext(sndGoldScorpionDead, 1.2 + random(0.2), 2.5);
	
	 // Venom Explo:
	var a = random(360);
	for(var d = a; d < a + 360; d += (360 / 5)){
		repeat(irandom_range(8, 12)){
			projectile_create(x, y, "VenomPellet", d + orandom(12), 8 + random(8));
		}
		
		 // Effects:
		with(instance_create(x, y, AcidStreak)){
			motion_set(d, 4);
			image_angle = direction;
		}
	}
	
	
#define Slaughter_create
	 // Visual:
	spr_spwn       = spr.PetSlaughterSpwn;
	spr_fire       = spr.PetSlaughterBite;
	hitid          = [spr_idle, "SLAUGHTERFISH"];
	sprite_index   = spr_spwn;
	spr_shadow_y   = -2;
	spr_bubble     = -1;
	spr_bubble_pop = -1;
	depth          = -3;
	
	 // Sound:
	snd_hurt = sndOasisBossHurt;
	snd_dead = sndFreakDead;
	
	 // Vars:
	mask_index = mskFrogEgg;
	maxhealth  = 30;
	maxspeed   = 3.4;
	size       = 2;
	nextexplo  = 0;
	target     = noone;
	my_bite    = noone;
	my_bone    = noone;
	
	 // Stat:
	if("bites" not in stat){
		stat.bites = 0;
	}
	
#define Slaughter_ttip
	return [
		"BUBBLE BLOWIN'",
		"BABY",
		"JAWS",
		"VICIOUS"
	];
	
#define Slaughter_stat(_name, _value)
	if(_name == ""){
		return spr.PetSlaughterIdle;
	}
	
#define Slaughter_anim
	if((sprite_index != spr_hurt && sprite_index != spr_spwn && sprite_index != spr_fire) || anim_end){
		 // Spawn Animation End:
		if(sprite_index == spr_spwn){
			sprite_index = spr_hurt;
			image_index = 0;
			depth = -2;
			
			 // Effects:
			sound_play_hit_ext(sndOasisBossDead, 1.2 + random(0.1), 1.2);
			var l = -8;
			for(var d = direction; d < direction + 360; d += (360 / 3)){
				repeat(2) scrFX(x, y, [d + orandom(40), 4], Dust);
				with(obj_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), "WaterStreak")){
					motion_set(d + orandom(20), 1.5);
					image_angle = direction;
					friction = 0.1;
				}
			}
		}
		
		 // Normal:
		else sprite_index = enemy_sprite;
	}
	
#define Slaughter_step
	 // Spawn Animation:
	if(sprite_index == spr_spwn){
		speed = 0;
	}
	
	 // Bubble Armor Active:
	if(nextexplo > current_frame){
		image_index = 0;
	}
	
	 // Biting:
	if(sprite_index == spr_fire){
		if(image_index < 3){
			 // Chompin:
			if(!instance_exists(my_bite)){
				my_bite = instance_create(x, y, RobotEat);
			}
			
			 // Drop Bone:
			with(my_bone){
				hspeed = 3.5 * other.right;
				vspeed = orandom(2);
				rotspeed = random_range(8, 16) * choose(-1, 1);
				
				 // Unstick From Wall:
				if(place_meeting(x, y, Wall) && instance_budge(Wall, -1)){
					instance_create(x, y, Dust);
				}
				instance_create(x, y, Dust);
			}
			my_bone = noone;
		}
		
		 // Bite:
		else if(image_index < 3 + image_speed_raw){
			stat.bites++;
			
			 // Attack:
			if(instance_is(target, hitme)){
				sound_play_hit_ext(sndExplosionS, 1.5, 1.2);
				with(projectile_create(target.x, target.y, "BubbleExplosionSmall", point_direction(x, y, target.x, target.y), 5)){
					repeat(2) scrFX(x, y, [direction + orandom(30), 3], Smoke);
					image_angle = 0;
					friction = 1;
					x -= hspeed;
					y -= vspeed;
				}
			}
			
			 // Fetch Bone:
			else if(instance_is(target, WepPickup)){
				my_bone = target;
				sound_play_pitchvol(sndBloodGamble, 2 + orandom(0.2), 0.6);
			}
			
			 // Effects:
			sound_play_pitchvol(sndSharpTeeth, 1.5 + orandom(0.2), 0.5)
		}
		
		with(my_bite){
			x = other.x;
			y = other.y;
			sprite_index = spr.SlaughterBite;
			image_index = other.image_index;
			image_xscale = other.right;
			depth = other.depth - 1;
		}
	}
	else if(!instance_exists(target)){
		target = noone;
	}
	
	 // Fetching:
	if(instance_exists(my_bone)){
		var	_x = x + hspeed_raw + (10 * right),
			_y = y + vspeed_raw + 2;
			
		with(my_bone){
			if(point_distance(x, y, _x, _y) > 2){
				x += (_x - x) * 0.8 * current_time_scale;
				y += (_y - y) * 0.8 * current_time_scale;
			}
			else{
				x = _x;
				y = _y;
			}
			xprevious = x;
			yprevious = y;
			speed = 0;
			rotation += angle_difference((10 + (10 * sin((x + y) / 10))) * other.right, rotation) * 0.5 * current_time_scale;
			
			 // Portal Takes Bone:
			if(!visible || instance_near(x, y, Portal, 96)){
				other.my_bone = noone;
			}
		}
	}
	
#define Slaughter_alrm0(_leaderDir, _leaderDis)
	alarm0 = 20 + random(10);
	
	if(sprite_index != spr_fire && sprite_index != spr_spwn){
		if(instance_exists(leader)){
			 // Pathfinding:
			if(path_dir != null && (!instance_seen(x, y, target) || _leaderDis > 96)){
				scrWalk(path_dir + orandom(20), 12);
				return 1 + irandom(walk);
			}
			
			else{
				if(
					target != my_bone
					&& instance_seen(x, y, target)
					&& instance_near(leader.x, leader.y, target, 160)
				){
					 // Bite:
					if(
						(target.visible || !instance_is(target, WepPickup))
						&&
						distance_to_object(target) < (instance_is(target, WepPickup) ? 2 : 32)
					){
						sprite_index = spr_fire;
						image_index = 0;
						speed = 0;
						walk = 0;
						scrRight(point_direction(x, y, target.x, target.y));
					}
					
					 // Towards Enemy:
					else{
						scrWalk(point_direction(x, y, target.x, target.y) + orandom(20), [8, 16]);
						alarm0 = 10;
					}
				}
				
				 // Towards Leader:
				else{
					if(_leaderDis > 48){
						scrWalk(_leaderDir + orandom(20), [15, 25]);
						if(instance_exists(my_bone)) walk = alarm0;
					}
					else if(!instance_exists(my_bone)){
						scrWalk(_leaderDir + orandom(90), [8, 16]);
					}
				}
				
				 // Targeting:
				if(sprite_index != spr_fire){
					var _disMax = infinity;
					with(pet_target_inst){
						var _dis = point_distance(x, y, other.x, other.y);
						if(_dis < _disMax){
							if(!instance_is(self, prop) && instance_seen(x, y, other)){
								_disMax = _dis;
								other.target = id;
							}
						}
					}
					
					 // Movin:
					if(instance_exists(target) && instance_seen(leader.x, leader.y, target)){
						motion_add(point_direction(x, y, target.x, target.y) + orandom(10), 2);
						scrRight(direction);
					}
					
					 // Fetch:
					if(!instance_exists(my_bone) && !instance_seen(x, y, target)){
						var _disMax = 160;
						with(instances_matching(WepPickup, "visible", true)){
							var _dis = point_distance(x, y, other.x, other.y);
							if(_dis < _disMax){
								if(wep_raw(wep) == "crabbone" && instance_seen(x, y, other)){
									_disMax = _dis;
									other.target = id;
								}
							}
						}
					}
					
					else return 5 + random(10);
				}
			}
		}
		
		 // Wander:
		else{
			scrWalk(random(360), [8, 16]);
			return 30 + random(10);
		}
	}
	
#define Slaughter_hurt(_hitdmg, _hitvel, _hitdir)
	if(sprite_index != spr_spwn){
		if(my_health > 0 && (instance_exists(leader) || (sprite_index != spr_fire && "typ" in other && other.typ == 1))){
			if(instance_exists(leader)){
				 // Damage:
				enemy_hurt(_hitdmg, _hitvel, _hitdir);
				
				 // Sound:
				if(snd_hurt == sndOasisBossHurt){
					sound_play_hit_ext(snd_hurt, 1.2 + random(0.1), 1.4);
				}
				
				 // Bubble Armor:
				if(nextexplo <= current_frame){
					nextexplo = current_frame + 6;
					
					var	_ang = random(360),
						_num = 3 + (crown_current == crwn_death),
						_l   = 8;
						
					for(var _d = _ang; _d < _ang + 360; _d += (360 / _num)){
						projectile_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), "BubbleExplosionSmall", 0, 0);
					}
					
					 // Sound:
					sound_play_hit_ext(sndExplosion, 1.5 + random(0.5), 1.2);
				}
			}
			
			 // Eat:
			else if(!instance_exists(other) || ("typ" in other && other.typ != 0)){
				nexthurt = current_frame + 6;
				sprite_index = spr_fire;
				image_index = 2;
				scrRight(direction);
				walk = 0;
			}
		}
		
		 // Dodge:
		else if(sprite_index != spr_fire){
			sprite_index = spr_fire;
			image_index = 3;
		}
	}
	
#define Slaughter_death
	sound_play_hit_ext(snd_dead, 1.5 + random(0.3), 1.4);
	
	
#define Spider_create
	 // Visual:
	spr_shadow_y = 0;
	spr_bubble_y = 1;

	 // Vars:
	maxspeed      = 3.4;
	web_list      = [];
	web_list_x1   = +infinity;
	web_list_y1   = +infinity;
	web_list_x2   = -infinity;
	web_list_y2   = -infinity;
	web_add_l     = 8;
	web_add_side  = choose(-90, 90);
	web_add_d     = direction + web_add_side;
	web_timer_max = 9;
	web_timer     = web_timer_max;
	web_frame     = 0;
	web_hit_list  = -1;
	web_bits      = 0;
	curse         = 0;
	
	 // Alarms:
	//alarm1 = -1;
	
	 // Remember:
	array_push(history, "curse");
	
	 // Stat:
	if("webbed" not in stat){
		stat.webbed = 0;
	}
	
#define Spider_ttip
	return [
		"A BIT STUCK",
		"STICKY SITUATION",
		"GROSS",
		"COCOONED"
	];
	
#define Spider_stat(_name, _value)
	switch(_name){
		case "":
			return spr.PetSpiderIdle;
			
		case "cursed":
			return [`${((current_frame % 60) < 15 || chance(1, 30)) ? "@y@q" : "@p"}${_name}`, _value];
	}
	
#define Spider_step
	 // Lay Webs:
	web_addx = x;
	web_addy = y;
	if(instance_exists(leader)){
		if(web_timer > 0){
			if(speed > 0) web_timer -= current_time_scale;
			if(web_timer <= 0){
				web_timer = web_timer_max;
				
				Spider_web_add(
					x + lengthdir_x(web_add_l, web_add_d),
					bbox_bottom + lengthdir_y(web_add_l, web_add_d)
				);
				
				web_add_l = 8 + orandom(2);
				web_add_d = direction + web_add_side + orandom(20);
				web_add_side *= -1;
			}
		}
	}
	else web_timer = web_timer_max;
	
	 // Sparkle:	 
	if(chance_ct(1, 20)){
		with(instance_create(x + orandom(8), y + orandom(8), CaveSparkle)){
			sprite_index = ((other.curse > 0) ? sprCaveSparkle : spr.PetSparkle);
			depth = other.depth - 1;
		}
	}
	
	 // Encurse:
	if(curse <= 0 && GameCont.area == 104){
		if(!instance_exists(GenCont) && !instance_exists(LevCont)){
			curse = 1;
			
			 // Stat:
			stat.cursed = lq_defget(stat, "cursed", 0) + 1;
			
			 // Swap Sprites:
			spr_idle = spr.PetSpiderCursedIdle;
			spr_walk = spr.PetSpiderCursedWalk;
			spr_hurt = spr.PetSpiderCursedHurt;
			spr_icon = spr.PetSpiderCursedIcon;
			sprite_index = spr_idle;
			
			 // Alert:
			with(alert_create(id, spr_icon)){
				alert     = { spr:sprCurse, x:alert.x + 1, y:3 };
				alarm0    = 90;
				flash     = 10;
				snd_flash = sndCursedChest;
			}
		}
	}
	
#define Spider_alrm0(_leaderDir, _leaderDis)
	alarm0 = 20 + irandom(20);
	
	if(instance_exists(leader)){
		 // Pathfinding:
		if(path_dir != null){
			scrWalk(path_dir + orandom(15), [5, 10]);
			return walk;
		}
		
		 // Move Towards Leader:
		else{
			scrWalk(_leaderDir + orandom(30), 20);
			if(_leaderDis > 160) return walk;
			
			/*
			var _target = noone;
			
			 // Find Larget:	
			with(leader){
				_target = instance_near(x, y, instance_seen(x, y, other), 256));
			}
			
			var t = array_length(instances_matching(instances_matching(CustomProjectile, "name", "SpiderTangle"), "creator", leader));
			if(instance_exists(_target) && (t < 3 || chance(1, 3 + (4 * t)))){
				
				 // Snare Larget:
				if(instance_seen(x, y, _target)){
					var _targetDir = point_direction(x, y, _target.x, _target.y);
					
					with(obj_create(x, y, "SpiderTangle")){
						creator =	other.leader;
						team =		other.team;
						motion_set(_targetDir + orandom(2), 8);
						image_angle = direction;
					}
					
					 // Effects:
					motion_add(_targetDir + 180, 2);
					scrRight(_targetDir);
				}
			}
			
			else{
				 // Follow Leader:
				if(_leaderDis > 64){
					scrWalk(_leaderDir, [20, 30]);
				}
				
				 // Wander:
				else{
					scrWalk(direction + orandom(45), [10, 20]);
				}
			}
			*/
		}
	}
	
	 // Wander:
	else{
		scrWalk(random(360), [5, 10]);
	}
	
#define Spider_cleanup
	if(ds_map_valid(web_hit_list)){
		ds_map_destroy(web_hit_list);
	}
	
#define Spider_web_add(_x, _y)
	array_push(web_list, {
		x      : _x,
		y      : _y,
		frame  : web_frame + 120,
		wading : (GameCont.area == "coast" && !position_meeting(_x, _y, Floor))
	});
	
	if(_x < web_list_x1) web_list_x1 = _x;
	if(_y < web_list_y1) web_list_y1 = _y;
	if(_x > web_list_x2) web_list_x2 = _x;
	if(_y > web_list_y2) web_list_y2 = _y;
	
#define Spider_web_delete(_index)
	web_list = array_delete(web_list, _index);
	
	web_list_x1 = +infinity;
	web_list_y1 = +infinity;
	web_list_x2 = -infinity;
	web_list_y2 = -infinity;
	with(web_list){
		if(x < other.web_list_x1) other.web_list_x1 = x;
		if(y < other.web_list_y1) other.web_list_y1 = y;
		if(x > other.web_list_x2) other.web_list_x2 = x;
		if(y > other.web_list_y2) other.web_list_y2 = y;
	}
	
	
#define Twins_create
	 // Visual:
	spr_idle       = mskNone;
	spr_walk       = mskNone;
	spr_hurt       = mskNone;
	spr_shadow_y   = 2;
	spr_bubble     = -1;
	spr_bubble_pop = -1;
	depth          = -3;
	
	 // Vars:
	mask_index  = mskExploder;
	friction    = 0.1;
	minspeed    = 0.2;
	maxspeed    = 3;
	walkspeed   = 0.3;
	path_wall   = [];
	partner     = noone;
	orbit_pull  = 0;
	orbit_dis   = 24;
	orbit_speed = 3;
	flash       = 0;
	white       = false;
	walled      = false;
	setup       = true;
	//team        = 1;
	
	 // Remember:
	with(["white", "partner"]){
		array_push(other.history, self);
	}
	
	 // Stat:
	if("diverted" not in stat){
		stat.diverted = 0;
	}
	
#define Twins_ttip
	return [
		"SUBSPACE HIGHWAY THROUGH YOUR HEAD",
		"WROUGHT FROM THE SOURCE",
		"AN ELEGANT DANCE"
	];
	
#define Twins_stat(_name, _value)
	if(_name == ""){
		return spr.PetTwinsStat;
	}
	
#define Twins_icon
	return (
		(("partner" in self && instance_exists(partner)) || "spr_icon" not in self)
		? spr.PetTwinsIcon
		: spr_icon
	);
	
#define Twins_setup
	setup = false;
	
	 // Spriterize:
	spr_icon = (white ? spr.PetTwinsWhiteIcon : spr.PetTwinsRedIcon);
	spr_idle = (white ? spr.PetTwinsWhite     : spr.PetTwinsRed);
	spr_walk = spr_idle;
	spr_hurt = spr_idle;
	
#define Twins_step
	if(setup) Twins_setup();
	
	 // Flash White:
	if(flash > 0){
		flash -= current_time_scale;
	}
	
	 // Partnerize:
	if(partner == noone){
		partner = pet_spawn(x, y, "Twins");
		with(partner){
			partner    = other;
			team       = other.team;
			stat_found = other.stat_found;
			white      = !other.white;
		}
	}
	if(instance_exists(leader) && instance_exists(partner)){
		if(instance_is(leader, Player) && array_exists(leader.ntte_pet, id)){
			partner.leader     = leader;
			partner.can_take   = can_take;
			partner.stat_found = stat_found;
		}
		else{
			leader     = partner.leader;
			can_take   = partner.can_take;
			stat_found = partner.stat_found;
		}
	}
	
	 // Orbit Leader:
	if(instance_exists(leader)){
		var	_twinList  = instances_matching(instances_matching(instances_matching(object_index, "name", name), "pet", pet), "leader", leader),
			_twinIndex = array_find_index(_twinList, id),
			_twinCount = array_length(_twinList),
			_orbitX    = leader.x,
			_orbitY    = leader.y,
			_orbitLen  = orbit_dis,
			_orbitDir  = (360 * (_twinIndex / _twinCount)) + (orbit_speed * leader.wave);
			
		if(orbit_pull > 0){
			x = lerp(x, _orbitX + lengthdir_x(_orbitLen, _orbitDir), orbit_pull);
			y = lerp(y, _orbitY + lengthdir_y(_orbitLen, _orbitDir), orbit_pull);
			
			 // Stay Close:
			var _dis = 2 * _orbitLen;
			if(point_distance(x, y, _orbitX, _orbitY) > _dis){
				instance_create(x, y, Dust);
				
				var _dir = point_direction(_orbitX, _orbitY, x, y);
				x = _orbitX + lengthdir_x(_dis, _dir);
				y = _orbitY + lengthdir_y(_dis, _dir);
				
				instance_create(x, y, Smoke);
			}
		}
		orbit_pull = min(orbit_pull + (current_time_scale / 6), 1);
		
		 // Ignore Walls:
		if(array_exists(path_wall, Wall)){
			path_wall = array_delete_value(path_wall, Wall);
		}
	}
	
	 // Idle Movement Stuff:
	else{
		orbit_pull = 0;
		speed = max(speed, minspeed + friction);
		//angle_lerp(direction, round(direction / 8) * 8, 1/3);
		
		 // Bounce Off Walls:
		if(!array_exists(path_wall, Wall)){
			array_push(path_wall, Wall);
		}
		if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
			if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
			if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
		}
	}
	
	 // Get Out of the Wall Bro:
	if(walled){
		if(!instance_exists(leader)){
			with(instance_nearest_bbox(x, y, Floor)){
				other.x = bbox_center_x;
				other.y = bbox_center_y;
			}
			instance_budge(Wall, 64);
		}
		if(place_meeting(x, y, Floor) && !place_meeting(x, y, Wall)){
			walled     = false;
			flash      = 2;
			spr_shadow = shd24;
			
			 // Sound:
			sound_play_hit_ext(sndCursedReminder, 0.6 + orandom(0.1), 0.3);
			
			 // Effects:
			repeat(5){
				with(instance_create(x, y, CrystTrail)){
					sprite_index = (other.white ? spr.CrystalWhiteTrail : spr.CrystalRedTrail);
					speed		*= 2/3;
				}
			}
			with(instance_create(x, y, ThrowHit)){
				sprite_index = (other.white ? sprImpactWrists : spr.SquidCharge);
				image_xscale = 0.6;
				image_yscale = 0.6;
				image_speed  = 0.4;
				depth        = other.depth - 1;
			}
		}
	}
	
	 // Not in Wall:
	else{
		 // Divert Projectiles:
		if(place_meeting(x, y, projectile)){
			with(instances_meeting(x, y, instances_matching_ne(projectile, "team", team))){
				if(instance_exists(self) && place_meeting(x, y, other)){
					var _inst = (
						(typ == 0)
						? noone
						: id
					);
					
					 // Specifics:
					switch(object_index){
						case Laser:
						case EnemyLaser:
							_inst = instance_clone();
							break;
							
						case Lightning:
						case EnemyLightning:
							_inst = id;
							
							 // Delete Lightning Manually:
							with(other){
								for(
									var i = _inst + ceil(_inst.ammo);
									(i > _inst - 100 && (!instance_exists(i) || (i.object_index == _inst.object_index && i.creator == _inst.creator && i.team == _inst.team)));
									i--
								){
									if(instance_exists(i) && i != _inst){
										if(i < _inst){
											if(place_meeting(x, y, i)){
												instance_delete(_inst);
												_inst = i;
											}
											else break;
										}
										else instance_delete(i);
									}
								}
							}
							break;
					}
					
					if(instance_exists(_inst)){
						with(other){
							orbit_pull = 0;
							
							 // Effects:
							flash = 6;
							Twins_effect((x + _inst.x) / 2, (y + _inst.y) / 2, white, -6, _inst.direction);
							
							 // Sound:
							with(partner){
								audio_sound_set_track_position(
									sound_play_hit_ext(sndLaserCrystalDeath, 0.8 + orandom(0.1), 0.5),
									0.4
								);
							}
							var _snd = sound_play_gun(
								sndCrystalJuggernaut,
								0,
								1 - ((_inst.damage / 3) / instance_number(_inst.object_index))
							);
							audio_sound_pitch(_snd, 1.6 + random(0.8));
							//audio_sound_gain(_snd, audio_sound_get_gain(_snd) * (_inst.damage / 3), 0);
							
							 // Send to Partner:
							if(instance_exists(partner)){
								with(partner){
									if(!walled){
										var _dir  = point_direction(x, y, _inst.xstart, _inst.ystart);
										
										 // Effects:
										flash = other.flash;
										Twins_effect(x, y, white, 12, _dir);
										
										 // Freez:
										if(!collision_line(x, y, _inst.xstart, _inst.ystart, Wall, false, false)){
											orbit_pull = 0;
										}
										
										 // Divert:
										with(team_instance_sprite(((team == 2) ? team : 1), _inst)){
											x         = other.x;
											y         = other.y;
											xprevious = x;
											yprevious = y;
											xstart    = x;
											ystart    = y;
											deflected = true;
											team      = other.team;
											
											var _dirOff = angle_difference(_dir, direction);
											direction   += _dirOff;
											image_angle += _dirOff;
											
											 // Rebounce:
											if("zspeed" in self) zspeed *= -1;
											if("zvel"   in self) zvel   *= -1;
											
											 // Specifics:
											switch(object_index){
												case Laser:
												case EnemyLaser:
													var _laserList = instances_matching_ne(instances_matching(instances_matching(instances_matching(object_index, "creator", creator), "team", team), "deflected", true), "id", id);
													if(array_length(_laserList) > 0){
														instance_delete(_laserList[array_length(_laserList) - 1]);
													}
													image_xscale = 1;
													with(self){
														event_perform(ev_alarm, 0);
													}
													break;
													
												case Lightning:
												case EnemyLightning:
													with(self){
														event_perform(ev_alarm, 0);
													}
													break;
											}
										}
									}
									
									 // Walled:
									else{
										sound_play_hit_ext(sndHitWall, 0.8 + orandom(0.1), 1.3);
										with(instance_create(x, y, ThrowHit)){
											image_xscale = 2/3;
											image_yscale = 2/3;
											depth        = -7;
										}
										instance_delete(_inst);
									}
								}
							}
							
							 // Send to the Warp Zone:
							else instance_delete(_inst);
							
							 // Stat:
							if(instance_exists(leader)){
								stat.diverted++;
							}
						}
					}
				}
			}
		}
		
		 // Contact Damage:
		if(instance_exists(leader) && place_meeting(x, y, hitme)){
			with(instances_meeting(x, y, instances_matching_ne(hitme, "team", team))){
				if(!instance_is(self, Player) && place_meeting(x, y, other)){
					with(other){
						if(projectile_canhit_melee(other)){
							 // Effects:
							repeat(3){
								with(instance_create(x, y, CrystTrail)){
									sprite_index = (other.white ? spr.CrystalWhiteTrail : spr.CrystalRedTrail);
									speed		*= 2/3;
								}
							}
							
							 // Push Away:
							if(instance_exists(leader)){
								other.direction = point_direction(leader.x, leader.y, other.x, other.y);
							}
							
							 // Damage:
							projectile_hit(other, 2);
						}
					}
				}
			}
		}
		
		 // Sparkles:
		if(white){
			if(chance_ct(1, 20)){
				with(scrFX([x, 6], [y, 6], [90, random_range(0.2, 0.5)], LaserCharge)){
					sprite_index = sprSpiralStar;
					image_index  = choose(0, irandom(image_number - 1));
					depth        = other.depth - 1;
					alarm0       = random_range(15, 30);
				}
			}
			if(chance_ct(1, 25)){
				with(instance_create(x + orandom(6), y + orandom(6), BulletHit)){
					sprite_index = sprThrowHit;
					image_xscale = 0.2 + random(0.3);
					image_yscale = image_xscale;
					depth        = other.depth - 1;
				}
			}
		}
		else if(chance_ct(1, 30)){
			with(instance_create(x + orandom(6), y + orandom(6), LaserCharge)){
				depth  = other.depth - 1;
				alarm0 = random_range(10, 20);
				motion_set(random(360), random(1));
				
				 // What If:
				image_speed = 0.4;
			}
		}
		
		 // Enter Wall:
		if(position_meeting(x, y, Wall)){
			walled     = true;
			flash      = 2;
			spr_shadow = mskNone;
			
			 // Sound:
			sound_play_hit_ext(sndCursedChest, 2 + orandom(0.1), 0.3);
			
			 // Effects:
			with(instance_create(x, y, ThrowHit)){
				sprite_index = (other.white ? sprImpactWrists : spr.SquidCharge);
				image_xscale = 2/3;
				image_yscale = 2/3;
				image_speed  = 0.4;
				depth        = other.depth - 1;
			}
		}
	}
	
#define Twins_alrm0(_leaderDis, _leaderDir)
	 // Bumpin' Around:
	if(!instance_exists(leader)){
		if(instance_exists(partner)){
			var _partnerDir = point_direction(x, y, partner.x, partner.y);
			if(instance_near(x, y, partner, 48) || chance(1, 5)){
				scrWalk(_partnerDir + (90 + orandom(30)), 5);
			}
			else{
				scrWalk(_partnerDir + orandom(10), 5 + random(10));
			}
		}
		else{
			scrWalk(random(360), 10 + random(20));
		}
		
		 // Face Right:
		right = 1;
		
		return walk + random(10);
	}
	
	 // Orbiting:
	return 30;
	
#define Twins_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	if(!walled || flash > 0){
		if(flash > 0){
			draw_set_fog(true, image_blend, 0, 0);
		}
		draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
		if(flash > 0){
			draw_set_fog(false, 0, 0, 0);
		}
	}
	
#define Twins_effect(_x, _y, _white, _len, _dir)
	with(instance_create(_x + lengthdir_x(_len, _dir), _y + lengthdir_y(_len, _dir), BulletHit)){
		sprite_index = (_white ? spr.PetTwinsWhiteEffect : spr.PetTwinsRedEffect);
		image_angle  = _dir;
		depth        = other.depth - 1;
	}
	
	
#define Octo_create
	 // Visual:
	spr_hide       = spr.PetOctoHide;
	spr_shadow     = shd16;
	spr_shadow_y   = 5;
	spr_bubble     = -1;
	spr_bubble_pop = -1;
	
	 // Vars:
	friction      = 0.1;
	maxspeed      = 3.4;
	hiding        = false;
	arcing        = 0;
	arcing_attack = 0;
	path_wall     = [Wall];
	
	 // Stat:
	if("arcing" not in stat){
		stat.arcing = 0;
	}

#define Octo_ttip
	return [
		"BRAIN WAVES",
		"TEAMWORK",
		"JUMP ROPE",
		"BRING FORTH THE MOLLUSK" // for peas
	];

#define Octo_stat(_name, _value)
	switch(_name){
		case "":
			return spr.PetOctoIdle;
		
		case "arcing":
			var _time = "";
			_time += string_lpad(string(floor((_value / power(60, 2))     )), "0", 1); // Hours
			_time += ":";
			_time += string_lpad(string(floor((_value / power(60, 1)) % 60)), "0", 2); // Minutes
			_time += ":";
			_time += string_lpad(string(floor((_value / power(60, 0)) % 60)), "0", 2); // Seconds
			
			return [_name, _time];
	}
	
#define Octo_anim
	sprite_index = (hiding ? spr_hide : enemy_sprite);
	
#define Octo_step
	if(instance_exists(leader)){
		 // Unhide:
		if(hiding){
			hiding = false;
			light = true;
			spr_shadow = shd16;
		}
		
		var	_lx = leader.x,
			_ly = leader.y,
			_leaderDir = point_direction(x, y, _lx, _ly),
			_leaderDis = point_distance(x, y, _lx, _ly);
			
		if(leader.visible && instance_seen(x, y, leader) && _leaderDis < 96 /*+ (45 * skill_get(mut_laser_brain))*/){
			 // Lightning Arcing Effects:
			if(arcing < 1){
				arcing += 0.15 * current_time_scale;
				
				if(current_frame_active){
					var	_dis = random(_leaderDis),
						_dir = _leaderDir;
						
					with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), choose(PortalL, LaserCharge))){
						if(object_index == LaserCharge){
							sprite_index = sprLightning;
							image_xscale = random_range(0.5, 2);
							image_yscale = random_range(0.5, 2);
							image_angle = random(360);
							alarm0 = 4 + random(4);
						}
						motion_add(random(360), 1);
					}
				}
				
				 // Arced:
				if(arcing >= 1){
					sound_play_pitch(sndLightningHit, 2);
					
					 // Laser Brain FX:
					if(skill_get(mut_laser_brain)){
						with(instance_create(x, y, LaserBrain)){
							image_angle = _leaderDir + orandom(10);
							creator = other;
						}
						with(instance_create(_lx, _ly, LaserBrain)){
							image_angle = _leaderDir + orandom(10) + 180;
							creator = other.leader;
						}
					}
				}
			}
			
			 // Lightning Arc:
			else{
				lightning_connect(_lx, _ly, x, y, 8 * sin(wave / 60), false);
				stat.arcing += (current_time_scale / 30);
			}
		}
		
		 // Stop Arcing:
		else{
			if(arcing > 0){
				arcing = 0;
				sound_play_pitchvol(sndLightningReload, 0.7 + random(0.2), 0.5);
				
				repeat(2){
					var	_dis = random(point_distance(x, y, _lx, _ly)),
						_dir = point_direction(x, y, _lx, _ly);
						
					with(instance_create(x + lengthdir_x(_dis, _dir), y + lengthdir_y(_dis, _dir), PortalL)){
						motion_add(random(360), 1);
					}
				}
			}
		}
		
		 // Arc to Nearby Things:
		if(arcing_attack > 0) arcing_attack -= current_time_scale;
		else{
			if(arcing >= 1){
				var	_nearest = noone,
					_disMax = 96;
					
				with(instances_matching_ne(instances_matching_ne(hitme, "team", team), "mask_index", mskNone)){
					var _dis = point_distance(x, y, other.x, other.y);
					if(_dis < _disMax){
						if(
							(!instance_is(self, prop) && team != 0)
							||
							(instance_is(self, prop) && sprite_get_width(sprite_index) <= 24 && sprite_get_height(sprite_index) <= 24)
						){
							if(instance_seen(x, y, other)){
								_disMax = _dis;
								_nearest = id;
							}
						}
					}
				}
				
				if(instance_exists(_nearest)){
					arcing_attack = 30 + random(30);
					with(projectile_create(x, y, "TeslaCoil", point_direction(x, y, _nearest.x, _nearest.y), 0)){
						dist_max = _disMax;
						creator_offx = 9;
						
						 // Manually Targeting:
						alarm0 = -1;
						target = _nearest;
						target_x = target.x;
						target_y = target.y;
						
						 // Effects:
						var _brain = skill_get(mut_laser_brain);
						sound_play_hit_ext((_brain ? sndLightningPistolUpg : sndLightningPistol), 1.5 + orandom(0.2), 1.2);
						if(_brain){
							with(instance_create(x, y, LaserBrain)){
								creator = other;
							}
						}
					}
				}
			}
			else arcing_attack = 10 + random(20);
		}
	}
	else arcing = 0;
	
	 // He is bouncy:
	if(array_length(path) <= 0){
		with(path_wall) with(other){
			if(place_meeting(x + hspeed_raw, y + vspeed_raw, other)){
				if(place_meeting(x + hspeed_raw, y, other)) hspeed_raw *= -0.5;
				if(place_meeting(x, y + vspeed_raw, other)) vspeed_raw *= -0.5;
				scrRight(direction);
			}
		}
	}
	
	 // Hiding:
	if(hiding){
		light      = false;
		spr_shadow = -1;
		
		 // Hop to New Pit:
		if(image_index < 1) image_index -= image_speed_raw * 0.95;
		else if(anim_end){
			with(instance_random(instances_matching(Floor, "sprite_index", spr.FloorTrenchB))){
				other.x = bbox_center_x;
				other.y = bbox_center_y;
			}
		}
		
		 // Move Slower:
		speed = clamp(speed, 0, maxspeed - 0.4);
		
		 // Can't be Grabbed Under Floors:
		can_take = (array_length(instances_matching(instances_at(x, y - 4, Floor), "sprite_index", spr.FloorTrenchB)) > 0);
	}

#define Octo_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	if(!hiding) draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);

#define Octo_alrm0(_leaderDir, _leaderDis)
	if(instance_exists(leader)){
		 // Follow Leader Around:
		if(_leaderDis > 64 || !instance_seen(x, y, leader)){
			 // Pathfinding:
			if(path_dir != null){
				scrWalk(path_dir + orandom(10), 6);
				return 1 + irandom(walk) + irandom(6);
			}
			
			 // Toward Leader:
			else{
				scrWalk(_leaderDir + orandom(20), [5, 15]);
			}
			
			return walk + random(5);
		}
		
		 // Idle Around Leader:
		else{
			motion_add(_leaderDir + orandom(60), 1.5 + random(1.5));
			scrRight(direction);
			
			 // More Aggressive:
			if(arcing >= 1 && instance_near(x, y, enemy, 160) && "index" in leader){
				motion_add(point_direction(x, y, mouse_x[leader.index], mouse_y[leader.index]) + orandom(10), 2);
			}
			
			return 20 + random(10);
		}
	}
	
	 // No Leader:
	else{
		 // Find trench pit:
		if(GameCont.area == "trench" && !hiding){
			 // Hide:
			if(array_length(instances_matching(instances_at(x, y - 4, Floor), "sprite_index", spr.FloorTrenchB))){
				hiding = true;
				
				sprite_index = spr_hide;
				image_index = 0;
				
				 // Effects:
				repeat(4 + irandom(4)){
					with(scrFX(x, y, 2, Dust)) waterbubble = chance(1, 2);
				}
			}
			
			 // Move Toward Nearest Seen Pit:
			else{
				var	_dir = -1,
					_disMax = infinity;
					
				with(instances_matching(Floor, "sprite_index", spr.FloorTrenchB)){
					var	_x = bbox_center_x,
						_y = bbox_center_y,
						_dis = point_distance(other.x, other.y, _x, _y);
						
					if(_dis < _disMax && instance_seen(_x, _y, other)){
						_dir = point_direction(other.x, other.y, _x, _y);
						_disMax = _dis;
					}
				}
				
				if(_dir >= 0){
					scrWalk(_dir, [10, 15]);
					return walk + random(5);
				}
			}
		}
		
		 // Idle Movement:
		instance_create(x, y, Bubble);
		scrWalk(direction + orandom(60), [5, 15]);
		return walk + random_range(30, 60);
	}
	
#define Octo_hurt(_hitdmg, _hitvel, _hitdir)
	if(!hiding){
		sprite_index = spr_hurt;
		image_index = 0;
		
		 // Movin'
		scrWalk(_hitdir, 10);
		scrRight(direction + 180);
	}
	
	
#define Prism_create
	 // Visual:
	spr_bubble     = -1;
	spr_bubble_pop = -1;
	depth          = -3;

	 // Vars:
	mask_index  = mskFrogEgg;
	maxspeed    = 2.5;
	tp_delay    = irandom(30);
	alarm0      = -1;
	spawn_loc   = [x, y];
	path_wall   = [Wall];
	flash_frame = 0;
	
	 // Stat:
	if("splits" not in stat){
		stat.splits = 0;
	}
	
#define Prism_ttip
	return [
		"STRANGE GEOMETRY",
		"CURSED REFRACTION",
		"YEAH OH ",
		"LIGHT BEAMS"
	];
	
#define Prism_stat(_name, _value)
	if(_name == ""){
		return spr.PetPrismIdle;
	}
	
#define Prism_step
	if(instance_exists(leader)){
		spawn_loc = [x, y];
		
		scrWalk(direction, 1); // Aimlessly floats
		
		 // Duplicate Friendly Bullets:
		with(
			instances_matching(
				instance_rectangle_bbox(bbox_left - 8, bbox_top - 8, bbox_right + 8, bbox_bottom + 8, array_combine(
					instances_matching(projectile, "team", leader.team),
					instances_matching(instances_matching_ne(projectile, "team", leader.team), "creator", leader)
				)),
				"can_prism_duplicate", true, null
			)
		){
			if(distance_to_object(other) < 8){
				if("prism_duplicate" not in self){
					prism_duplicate = false;
				}
				can_prism_duplicate = false;
				
				if(!prism_duplicate){
					with(other){
						speed *= 0.5;
						stat.splits++;
					}
					
					 // Slice FX:
					var	_dir = random(360),
						_disMax = 6;
						
					for(var _dis = _disMax; _dis >= -_disMax; _dis -= 2){
						with(instance_create(other.x + lengthdir_x(_dis, _dir), other.y + lengthdir_y(_dis, _dir), BoltTrail)){
							motion_add(_dir, 1);
							image_angle = _dir;
							image_xscale = 2;
							image_yscale = 1 + (1 * (1 - ((_dis + _disMax) / (2 * _disMax))));
							if(skill_get(mut_bolt_marrow) > 0) image_yscale *= 0.7;
							depth = -4;
						}
					}
					instance_create(x + orandom(16), y + orandom(16), CaveSparkle);
					sound_play_hit_ext(sndCrystalShield, 1.4 + orandom(0.1), 2.4);
					other.flash_frame = max(other.flash_frame, current_frame + max(1, sprite_height / 16));
					
					 // Curse:
					var _cursed = ("curse" in self && curse <= 0);
					if(_cursed){
						curse = true;
						
						 // FX:
						for(var i = 0; i < 3; i++){
							with(scrFX(x, y, [direction + orandom(5), 2 + (3 * i)], AcidStreak)){
								image_angle = direction;
								sprite_index = spr.WaterStreak;
								image_speed = random_range(0.2, 0.4);
								image_blend = make_color_rgb(103, 27, 131);
								depth = -4;
							}
						}
						sound_play_pitch(sndCursedChest, 0.8);
					}
					
					 // Duplicate:
					if(!_cursed || variable_instance_get(self, "name") != "Trident"){
						var	_clone    = instance_clone(),
							_accuracy = variable_instance_get(other.leader, "accuracy", 1);
							
						 // LWO Weapon Fix:
						if("wep" in self) _clone.wep = wep;
						
						 // Object-Specific:
						switch(_clone.object_index){
							
							case Laser:
								
								 // Manually Offset Lasers:
								var	_l = point_distance(xstart, ystart, other.x, other.y) + 12,
									_d = image_angle;
									
								with(_clone){
									x = other.xstart + lengthdir_x(_l, _d);
									y = other.ystart + lengthdir_y(_l, _d);
									xstart = x;
									ystart = y;
									image_angle += orandom(20 * _accuracy);
									with(self){
										event_perform(ev_alarm, 0);
									}
								}
								
								break;
								
							case Lightning:
								
								 // No Cloning Other Lightning Within the Chain:
								for(
									var i = id + ceil(ammo);
									(i > id || instance_is(i, Lightning) || (i > id - 100 && !instance_exists(i)));
									i--
								){
									if(instance_is(i, Lightning)) with(i){
										prism_duplicate = true;
									}
								}
								
								 // Make Lightning Epic:
								with(_clone){
									 // Offset Direction:
									image_angle = other.image_angle + (random_range(20, 40) * choose(-1, 1) * _accuracy);
									
									 // Grow:
									var	_varCopy = variable_instance_get_names(id),
										_varNo = [
											"id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width",
											"ammo", "x", "y", "xstart", "ystart", "xprevious", "yprevious", "image_xscale", "image_yscale", "image_angle", "direction"
										];
										
									ammo = min(30, ammo);
									with(self){
										event_perform(ev_alarm, 0);
									}
									with(instances_matching_gt(Lightning, "id", id)){
										prism_duplicate = true;
										with(_varCopy){
											if(!array_exists(_varNo, self)){
												variable_instance_set(other, self, variable_instance_get(_clone, self));
											}
										}
									}
								}
								
								break;
								
							default:
								
								 // Offset Direction:
								var _off = random_range(4, 16) * _accuracy;
								with([id, _clone]){
									direction += _off;
									image_angle += _off;
									_off *= -1;
								}
								
						}
					}
					
					prism_duplicate = true;
				}
				else if(speed > 1){
					sound_play_pitch(sndCursedReminder, 1.5);
				}
			}
		}
		var _prism = instances_matching(instances_matching(object_index, "name", name), "pet", pet);
		with(instances_matching(instances_matching_gt(projectile, "speed", 0), "can_prism_duplicate", false)){
			if(array_length(instance_rectangle_bbox(bbox_left - 16, bbox_top - 16, bbox_right + 16, bbox_bottom + 16, _prism)) <= 0){
				can_prism_duplicate = true;
			}
		}
		
		 // TP Around Player:
		if(tp_delay > 0) tp_delay -= current_time_scale;
		else{
			var	_dis = 96,
				_x = x,
				_y = y;
				
			if(!collision_circle(leader.x, leader.y, _dis, id, true, false)){
				tp_delay = 15;
				
				var _dir = point_direction(leader.x, leader.y, _x, _y) + 180;
				
				do{
					x = leader.x + lengthdir_x(_dis, _dir) + orandom(4);
					y = leader.y + lengthdir_y(_dis, _dir) + orandom(4);
					_dis -= 4;
				}
				until(
					_dis < -12 ||
					(
						!place_meeting(x, y, Wall) &&
						(
							place_meeting(x, y, Floor) ||
							!place_meeting(leader.x, leader.y, Floor)
						)
					)
				)
				
				 // Effects:
				if(!place_meeting(x, y, Wall)){
					flash_frame = max(flash_frame, current_frame + 1);
					repeat(4) with(instance_create(_x + orandom(6), _y + orandom(6), (chance(1, 6) ? CaveSparkle : Curse))){
						direction = random(360);
						depth = other.depth - 1;
					}
					sound_play_hit_ext(sndCursedReminder, 0.6 + orandom(0.1), 2);
				}
			}
		}
	}
	else{
		x += sin(current_frame / 10) * 0.4 * current_time_scale;
		y += cos(current_frame / 10) * 0.4 * current_time_scale;
		
		 // Jitters Around:
		if(tp_delay > 0) tp_delay -= current_time_scale;
		else if(instance_exists(Floor)){
			tp_delay = irandom(30);
			
			if(!position_meeting(spawn_loc[0], spawn_loc[1], Floor)){
				with(instance_random(Floor)){
					other.spawn_loc = [bbox_center_x, bbox_center_y];
				}
			}
			
			 // Teleport:
			with(instance_nearest_bbox(spawn_loc[0] + orandom(64), spawn_loc[1] + orandom(64), Floor)){
				var	_fx = bbox_center_x,
					_fy = bbox_center_y;
					
				with(other){
					if(!place_meeting(_fx, _fy, Wall)){
						x = _fx;
						y = _fy;
						flash_frame = max(flash_frame, current_frame + 1);
						
						 // Effects:
						repeat(4){
							with(scrFX([x, 6], [y, 6], 0, (chance(1, 6) ? CaveSparkle : Curse))){
								direction = random(360);
								depth = other.depth - 1;
							}
						}
						sound_play_hit_ext(sndCursedReminder, 0.6 + orandom(0.1), 2 + random(2));
					}
				}
			}
		}
	}
	
	 // Bouncin:
	with(path_wall) with(other){
		if(place_meeting(x + hspeed_raw, y + vspeed_raw, other)){
			if(place_meeting(x + hspeed_raw, y, other)) hspeed_raw *= -1;
			if(place_meeting(x, y + vspeed_raw, other)) vspeed_raw *= -1;
			direction += orandom(20);
		}
	}
	
	 // Effects:
	if(chance_ct(1, 3)) repeat(irandom(4)){
		instance_create(x + orandom(8), y + orandom(8), Curse);
	}
	
#define Prism_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	if(flash_frame > current_frame){
		draw_set_fog(true, image_blend, 0, 0);
	}
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	if(flash_frame > current_frame){
		draw_set_fog(false, 0, 0, 0);
	}
	
	
#define Weapon_create
	 // Visual:
	hitid        = [spr.PetWeaponIdle, "WEAPON MIMIC"];
	spr_spwn     = spr.PetWeaponSpwn;
	spr_hide     = spr.PetWeaponHide;
	spr_bubble_y = -1;
	sprite_index = spr_hide;
	image_index  = image_number - 1;
	
	 // Sounds:
	snd_hurt = sndMimicHurt;
	snd_dead = sndMimicDead;
	
	 // Vars:
	mask_index    = mskFrogEgg;
	maxhealth     = 20;
	type          = choose(type_melee, type_bullet, type_shell, type_bolt, type_explosive, type_energy);
	gunangle      = random(360);
	gunangle_goal = gunangle;
	gunangle_turn = 0.25;
	shootdis_min  = 0;
	shootdis_max  = 192;
	target        = noone;
	curse         = 0;
	setup         = true;
	
	 // Weapons:
	with(["", "b"]){
		var _b = self;
		with(other){
			variable_instance_set(self, _b + "wep",       wep_none);
			variable_instance_set(self, _b + "wkick",     0);
			variable_instance_set(self, _b + "wepangle",  0);
			variable_instance_set(self, _b + "wepflip",   choose(-1, 1));
			variable_instance_set(self, _b + "reload",    30);
			variable_instance_set(self, _b + "can_shoot", false);
			variable_instance_set(self, _b + "wep_laser", 0);
		}
	}
	
	 // Remember:
	with(["type", "curse", "wep", "bwep"]){
		array_push(other.history, self);
	}
	
	 // Stat:
	if("battle" not in stat){
		stat.battle = [0, 0];
	}
	
#define Weapon_ttip
	return [
		"MUTUAL RESPECT",
		"WALKING WEAPON"
	];
	
#define Weapon_stat(_name, _value)
	switch(_name){
		case "":
			return spr.PetWeaponIdle;
			
		case "battle":
			return [`@5(${spr.PetWeaponStat})`, array_join(_value, "-")]
	}
	
#define Weapon_setup
	setup = false;
	
	if(type >= 0){
		 // Auto-Wep:
		if(wep == wep_none){
			 // Cursed:
			if(curse > 0){
				wep  = wep_super_disc_gun;
				type = type_shell;
			}
			
			 // Normal:
			else{
				var _typeSub = (
					(chance(1, 15) && (stat.found > 0 || stat.owned > 0))
					? 2
					: (GameCont.loops > 0)
				);
				
				switch(type){                   // NORMAL //           // LOOP //           // RARE //
					case type_melee     : wep = [wep_wrench,           wep_energy_sword,    wep_jackhammer         ][_typeSub]; break;
					case type_bullet    : wep = [wep_revolver,         wep_heavy_revolver,  wep_minigun            ][_typeSub]; break;
					case type_shell     : wep = [wep_shotgun,          wep_eraser,          wep_heavy_slugger      ][_typeSub]; break;
					case type_bolt      : wep = [wep_crossbow,         wep_auto_crossbow,   wep_splinter_pistol    ][_typeSub]; break;
					case type_explosive : wep = [wep_grenade_launcher, wep_blood_launcher,  wep_sticky_launcher    ][_typeSub]; break;
					case type_energy    : wep = [wep_laser_cannon,     wep_plasma_cannon,   wep_super_plasma_cannon][_typeSub]; break;
				}
			}
			
			 // Akimbo:
			if(bwep == wep_none){
				var _name = string_upper(weapon_get_name(wep));
				if(string_pos("REVOLVER", _name) > 0 || string_pos("PISTOL", _name) > 0){
					bwep = wep;
				}
			}
		}
		else type = (
			weapon_is_melee(wep)
			? type_melee
			: weapon_get_type(wep)
		);
		
		 // Weapon Setup:
		gunangle_turn = 0.25;
		shootdis_min  = 32;
		shootdis_max  = 192;
		switch(type){
			case type_melee:
				shootdis_min = 0;
				break;
				
			case type_shell:
				shootdis_min = 0;
				shootdis_max = 96 + (64 * (wep == wep_eraser));
				break;
				
			case type_bolt:
				gunangle_turn = 0.5;
				shootdis_min  = 64;
				shootdis_max  = 320;
				break;
				
			case type_explosive:
				gunangle_turn = 0.1;
				break;
		}
		if(wep == wep_jackhammer){
			gunangle_turn = 0.1;
		}
	}
	
	 // Melee:
	var _ang = choose(-120, 120);
	wepangle  =  _ang * weapon_is_melee(wep);
	bwepangle = -_ang * weapon_is_melee(bwep);
	
	 // Cursed Sprites:
	if(curse > 0){
		with(["idle", "walk", "hurt", "dead", "spwn", "hide", "icon"]){
			var	_type    = self,
				_spr     = variable_instance_get(other, "spr_" + _type, -1),
				_sprName = "PetWeapon" + string_upper(string_char_at(_type, 1)) + string_delete(_type, 1, 1);
				
			if(_spr == lq_get(spr, _sprName)){
				with(other){
					var _new = lq_get(spr, _sprName + "Cursed");
					variable_instance_set(self, "spr_" + _type, _new);
					if(sprite_index == _spr) sprite_index = _new;
					
					 // Icon:
					if(_type == "icon" && name == "Pet"){
						with(prompt){
							text = string_replace_all(text, string(_spr), string(_new));
						}
					}
				}
			}
		}
		hitid = [spr_idle, "@q@pCURSED#WEAPON MIMIC"];
	}
	
#define Weapon_anim
	if(
		sprite_index != spr_hide
		|| (instance_is(self, enemy) && enemy_target(x, y))
		|| (name == "Pet" && instance_exists(leader))
	){
		 // Appear:
		if(sprite_index == spr_spwn || sprite_index == spr_hide){
			if(sprite_index == spr_hide){
				sprite_index = spr_spwn;
				image_index = 0;
			}
			
			 // Laugh:
			if(image_index <= 0){
				audio_sound_set_track_position(sound_play_hit_ext(sndBallMamaTaunt, 2, 3), 0.2); // don't like the part at tha end but audio_set_gain was being fucky
				audio_sound_gain(sound_play_hit(sndTechnomancerActivate, 0), 0.4, 300);
				sound_play_hit(sndBigWeaponChest, 0);
			}
			
			 // Swap to Weapons:
			if(anim_end){
				wkick = -2;
				bwkick = -2;
				sound_play(weapon_get_swap(wep));
				instance_create(x + lengthdir_x(8, gunangle), y + lengthdir_y(8, gunangle), WepSwap);
				sprite_index = enemy_sprite;
			}
		}
		
		 // Normal:
		else sprite_index = enemy_sprite;
	}
	
	 // Hiding:
	else{
		image_index = min(image_index, image_number - 1);
		
		 // Clunk:
		if(floor(image_index) == image_number - 2 && image_index < floor(image_index) + image_speed_raw){
			sound_play_pitch(sndChest, 0.8 + random(0.2));
			repeat(4) scrFX(x, y, 2, Dust);
		}
	}
	
#define Weapon_step
	if(setup) Weapon_setup();
	
	 // Pet Shootin Rootin Tootin:
	if(
		sprite_index != spr_spwn
		&& name == "Pet"
		&& (instance_seen(x, y, leader) || instance_seen(x, y, target))
		&& instance_is(leader, Player)
	){
		gunangle_goal = point_direction(x, y, mouse_x[leader.index], mouse_y[leader.index]);
		
		 // Fire:
		if(
			((weapon_get_auto(leader.wep) || leader.race == "steroids") && leader.can_shoot && leader.canfire && (leader.ammo[weapon_get_type(leader.wep)] >= weapon_get_cost(leader.wep) || leader.infammo != 0))
			? button_check(leader.index, "fire")
			: button_pressed(leader.index, "fire")
		){
			var _shot = false;
			with(["", "b"]){
				var _b = self;
				with(other){
					var	_wep      = variable_instance_get(self, _b + "wep"),
						_reload   = variable_instance_get(self, _b + "reload"),
						_canShoot = variable_instance_get(self, _b + "can_shoot");
						
					if(_canShoot <= 0 && _wep != wep_none && _reload <= 0){
						_shot = true;
						_canShoot = 1;
						
						 // Fire Multiple Times:
						var _wepLoad = weapon_get_load(_wep);
						if(weapon_get_auto(_wep) || _wepLoad <= 10){
							_canShoot += floor(random(15) / _wepLoad);
						}
						
						variable_instance_set(self, _b + "reload",    _reload);
						variable_instance_set(self, _b + "can_shoot", _canShoot);
					}
				}
				if(_shot) break;
			}
		}
	}
	
	 // Aim:
	if(instance_seen(x, y, target)){
		gunangle_goal = point_direction(x, y, target.x + target.hspeed, target.y + target.vspeed);
	}
	else target = noone;
	scrAim(angle_lerp(gunangle, gunangle_goal, gunangle_turn * current_time_scale));
	
	 // Weapons:
	with(["", "b"]){
		var _b = self;
		with(other){
			var	_wep    = variable_instance_get(self, _b + "wep"),
				_wkick  = variable_instance_get(self, _b + "wkick"),
				_reload = variable_instance_get(self, _b + "reload");
				
			 // Weapon Kick:
			if(!instance_is(self, enemy) || _b != ""){
				_wkick -= clamp(_wkick, -current_time_scale, current_time_scale);
			}
			
			 // Reloading:
			if(_reload > 0){
				_reload -= current_time_scale;
				
				 // Reload FX:
				if(
					_reload <= 0
					&& _wep != wep_none
					&& sprite_index != spr_spwn
					&& sprite_index != spr_hide
					&& variable_instance_get(self, _b + "can_shoot") <= 0
				){
					var _snd = -1;
					
					 // Melee:
					variable_instance_set(self, _b + "wepflip", -variable_instance_get(self, _b + "wepflip"));
					if(weapon_is_melee(_wep)){
						var	_l = 12,
							_d = gunangle + variable_instance_get(self, _b + "wepangle");
							
						instance_create(x + lengthdir_x(_l, _d), y + lengthdir_y(_l, _d), WepSwap);
						variable_instance_set(self, _b + "wkick", -3);
						_snd = sndMeleeFlip;
					}
					
					 // Normal:
					else switch(weapon_get_type(_wep)){
						case type_shell:
							_snd = sndShotReload;
							
							 // Epic:
							variable_instance_set(self, _b + "wkick", -4);
							repeat(weapon_get_cost(_wep)){
								with(instance_create(x, y, Shell)){
									sprite_index = sprShotShell;
									motion_add(other.gunangle + (100 * other.right) + orandom(20), 2 + random(2));
								}
							}
							break;
							
						case type_bolt:
							_snd = sndCrossReload;
							break;
							
						case type_explosive:
							if(array_exists([wep_grenade_launcher, wep_golden_grenade_launcher, wep_grenade_shotgun, wep_grenade_rifle, wep_auto_grenade_shotgun, wep_ultra_grenade_launcher, wep_sticky_launcher, wep_hyper_launcher, wep_toxic_launcher, wep_cluster_launcher, wep_heavy_grenade_launcher], _wep)){
								_snd = sndNadeReload;
							}
							break;
							
						case type_energy:
							if(string_pos("PLASMA", weapon_get_name(_wep)) == 1){
								_snd = sndPlasmaReload;
							}
							else if(string_pos("LIGHTNING", weapon_get_name(_wep)) == 1){
								_snd = sndLightningReload;
							}
							break;
					}
					
					if(sound_exists(_snd)){
						sound_play_hit_ext(_snd, 1.15 + orandom(0.25), 1.5);
					}
				}
			}
			
			 // Ready:
			else{
				var _wepLaser = variable_instance_get(self, _b + "wep_laser");
				
				 // Laser Sight:
				if(weapon_get_laser_sight(wep)){
					if(
						instance_seen(x, y, target)
						|| (name == "Pet" && instance_seen(x, y, leader))
						|| (name == "PetWeaponBoss" && point_distance(x, y, cover_x, cover_y) < 24)
					){
						_wepLaser += current_time_scale / (instance_near(x, y, target, shootdis_min) ? 60 : 5);
					}
					else if(_wepLaser > 0){
						_wepLaser -= current_time_scale / 3;
					}
				}
				
				 // Shoot:
				var _canShoot = variable_instance_get(self, _b + "can_shoot");
				if(_canShoot > 0){
					var	_minID    = GameObject.id,
						_wepangle = variable_instance_get(self, _b + "wepangle");
						
					_canShoot--;
					_wepLaser = 0;
					
					 // Mutation Fixes:
					var _muts = [];
					if(instance_is(self, enemy)){
						var _muts = [[mut_long_arms, 0], [mut_recycle_gland, 0], [mut_shotgun_shoulders, 0], [mut_bolt_marrow, 0], [mut_boiling_veins, 0], [mut_laser_brain, 0]];
						with(_muts){
							var v = self[1];
							self[@1] = skill_get(self[0]);
							skill_set(self[0], v);
						}
					}
					
					 // Fire:
					with(player_fire_ext(gunangle, _wep, x, y, team, id)){
						_reload = reload;
						_wkick = wkick * 1.5;
					}
					_wepangle *= -1;
					
					 // Reset Mutation Fixes:
					with(_muts) skill_set(self[0], self[1]);
					
					 // Projectiles:
					with(instances_matching_gt([projectile, LaserCannon], "id", _minID)){
						hitid = other.hitid;
						
						if(instance_is(other, enemy)){
							 // Euphoria:
							speed *= power(0.8, skill_get(mut_euphoria));
							
							 // Specifics:
							switch(object_index){
								case Bullet2: // Nerf Shotguns
									if(string_pos("SHOTGUN", string_upper(weapon_get_name(_wep))) > 0){
										speed *= 0.8;
									}
									break;
									
								case Bolt: // Bolt Marrow Fix
									variable_instance_set_list(
										projectile_create(x, y, "DiverHarpoon", 0, 0),
										variable_instance_get_list(self)
									);
									break;
									
								default:
									 // Time Nades:
									if(instance_is(self, Grenade) && alarm0 > 0){
										var a = (alarm2 - alarm0);
										alarm0 += (_canShoot * weapon_get_load(_wep));
										if(alarm2 > 0){
											if(TopCont.darkness) a -= 40;
											alarm2 = max(1, alarm0 + a);
										}
									}
							}
							
							 // Enemy Spriterize:
							team_instance_sprite(1, self);
						}
					}
					
					variable_instance_set(self, _b + "can_shoot", _canShoot);
					variable_instance_set(self, _b + "wepangle",  _wepangle);
				}
				
				variable_instance_set(self, _b + "wep_laser", _wepLaser);
			}
			
			variable_instance_set(self, _b + "wkick",  _wkick);
			variable_instance_set(self, _b + "reload", _reload);
		}
	}
	
	 // Burst Weapon Fix:
	with(instances_matching([LaserCannon, Burst, GoldBurst, HeavyBurst, HyperBurst, RogueBurst, SawBurst, SplinterBurst, NadeBurst, DragonBurst, ToxicBurst, FlameBurst, WaveBurst, SlugBurst, PopBurst], "creator", id)){
		direction = other.gunangle;
	}
	
#define Weapon_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	 // Gun Drawing Setup:
	var	_wepOffX = 1,
		_wepOffY = ((wep != wep_none && bwep != wep_none) ? 5 : 2),
		_wepDraw = [];
		
	if(_spr != spr_spwn && _spr != spr_hide && !instance_exists(variable_instance_get(self, "revive", noone))){
		with(["", "b"]){
			var _b = self;
			with(other){
				var	_wep     = variable_instance_get(self, _b + "wep"),
					_wepLoad = variable_instance_get(self, _b + "reload"),
					_wepAng  = variable_instance_get(self, _b + "wepangle"),
					_wepDir  = gunangle + _wepAng;
					
				array_push(_wepDraw, {
					"sprite_index" : weapon_get_sprt(_wep),
					"x"            : _x + lengthdir_x(_wepOffX, _wepDir) + lengthdir_x(_wepOffY,       _wepDir - 90),
					"y"            : _y + lengthdir_y(_wepOffX, _wepDir) + lengthdir_y(_wepOffY * 2/3, _wepDir - 90),
					"gunangle"     : gunangle,
					"wepangle"     : _wepAng,
					"wkick"        : variable_instance_get(self, _b + "wkick"),
					"wepflip"      : ((_wepAng != 0) ? variable_instance_get(self, _b + "wepflip") : 1) * ((_wepOffY == 0) ? right : sign(_wepOffY)),
					"image_blend"  : merge_color(_col, c_black, 0.15 * (_wepLoad > 0) * weapon_is_melee(_wep)),
					"image_alpha"  : _alp,
					"laser_sight"  : min(1, weapon_get_laser_sight(_wep) * variable_instance_get(self, _b + "wep_laser"))
				});
				
				_wepOffY *= -1;
			}
		}
	}
	
	 // Guns in Back:
	with(_wepDraw){
		 // Laser Sight:
		if(laser_sight > 0){
			draw_set_color(make_color_rgb(250, 54, 0));
			draw_lasersight(x, y, gunangle, 1000, laser_sight);
		}
		
		 // Gun:
		if(y < _y){
			draw_weapon(sprite_index, x, y, gunangle, wepangle, wkick, wepflip, image_blend, image_alpha);
		}
	}
	
	 // Self:
	var _hurt = (_spr != spr_hurt && nexthurt > current_frame + 3);
	if(_hurt) draw_set_fog(true, image_blend, 0, 0);
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	if(_hurt) draw_set_fog(false, 0, 0, 0);
	
	 // Guns in Front:
	with(_wepDraw) if(y >= _y){
		draw_weapon(sprite_index, x, y, gunangle, wepangle, wkick, wepflip, image_blend, image_alpha);
	}
	
#define Weapon_alrm0(_leaderDir, _leaderDis)
	alarm0 = irandom_range(20, 40);
	
	if(sprite_index != spr_hide && sprite_index != spr_spwn){
		if(instance_exists(leader)){
			 // Pathfind:
			if(path_dir != null){
				scrWalk(path_dir + orandom(20), [5, 10]);
				alarm0 = walk;
				gunangle_goal = angle_lerp(gunangle_goal, direction, 0.1);
			}
				
			 // Walkin':
			else{
				if(_leaderDis > 128){
					scrWalk(_leaderDir + orandom(30), [30, 60]);
				}
				
				 // Near Leader:
				else if("index" in leader){
					var	_mx = mouse_x[leader.index],
						_my = mouse_y[leader.index],
						_tx = lerp(leader.x, _mx, 0.5),
						_ty = lerp(leader.y, _my, 0.5);
						
					scrWalk(
						point_direction(x, y, _tx + orandom(24), _ty + orandom(24)),
						(point_distance(x, y, _tx, _ty) / 4) + irandom(20)
					);
					
					 // Lock-on Nearby Dudes:
					if(!instance_exists(target)){
						var _disMax = 64;
						with(pet_target_inst){
							var _dis = point_distance(x, y, other.x, other.y);
							if(_dis < _disMax && instance_seen(x, y, other)){
								_disMax = _dis;
								other.target = id;
							}
						}
						
						 // Nearby Mouse:
						if(!instance_exists(target)){
							var _disMax = 64;
							with(pet_target_inst){
								var _dis = point_distance(x, y, _mx, _my);
								if(_dis < _disMax && instance_seen(x, y, other)){
									_disMax = _dis;
									other.target = id;
								}
							}
						}
					}
				}
			}
		}
		
		 // Hide:
		else{
			sprite_index = spr_hide;
			image_index = 0;
		}
	}
	
#define Weapon_hurt(_hitdmg, _hitvel, _hitdir)
	enemy_hurt(_hitdmg, _hitvel, _hitdir);
	
	 // Seek Revenge:
	if(instance_exists(variable_instance_get(other, "creator", noone))){
		if("team" in other.creator && other.creator.team != team){
			target = other.creator;
		}
	}
	
	
/// GENERAL
#define ntte_step
	var _petInst = Pet;
	
	if(array_length(_petInst)){
		 // Mantis Rad Attraction:
		if(instance_exists(Rad) || instance_exists(BigRad)){
			var _targetInst = instances_matching(instances_matching(_petInst, "pet", "Orchid"), "visible", true);
			if(array_length(_targetInst)){
				var _inst = instances_matching([Rad, BigRad], "orchidmantisradattract_check", null);
				if(array_length(_inst)) with(_inst){
					orchidmantisradattract_check = true;
					
					var	_target = noone,
						_disMax = infinity;
						
					with(_targetInst){
						if(instance_exists(leader) && array_length(skill_inst) <= 0){
							var _dis = point_distance(x, y, other.x, other.y);
							if(_dis < _disMax){
								_disMax = _dis;
								_target = id;
							}
						}
					}
					
					 // Grab:
					if(instance_exists(_target)){
						with(scrFX(x + (hspeed / 2), y + (vspeed / 2), [direction, 0.4], "VaultFlowerSparkle")){
							alarm0 = random_range(20, 30);
							image_alpha *= 2;
						}
						rad_path(self, _target);
					}
				}
			}
		}
		
		 // Salamander Throne Butt Text:
		if(instance_exists(SkillIcon) && array_length(instances_matching(_petInst, "pet", "Salamander"))){
			var _inst = instances_matching(instances_matching(SkillIcon, "skill", mut_throne_butt), "petsalamander_check", null);
			if(array_length(_inst)) with(_inst){
				petsalamander_check = true;
				
				 // Append Player's Name:
				for(var i = 0; i < maxp; i++){
					if(player_is_active(i)){
						var _title = race_get_title(player_get_race(i));
						if(string_pos(_title, text) != 1){
							text = _title + " - " + text;
						}
						break;
					}
				}
				
				 // Add Salamander:
				text += "@s#SALAMANDER - @wPUNTED @sENEMIES @rEXPLODE@s";
			}
		}
	}
	
#define ntte_end_step
	 // Spider Webbing:
	var _instSpider = instances_matching(Pet, "pet", "Spider");
	if(instance_exists(GenCont)){
		 // Reset Webs:
		if(array_length(_instSpider)) with(_instSpider){
			web_list    = [];
			web_timer   = web_timer_max;
			web_list_x1 = +infinity;
			web_list_y1 = +infinity;
			web_list_x2 = -infinity;
			web_list_y2 = -infinity;
		}
	}
	with(surface_setup("PetWeb", game_width, game_height, option_get("quality:main"))){
		x = view_xview_nonsync;
		y = view_yview_nonsync;
		
		var	_surfX     = x,
			_surfY     = y,
			_surfScale = scale;
			
		surface_set_target(surf);
		draw_clear_alpha(0, 0);
		draw_set_color(c_black);
		
		if(array_length(_instSpider)){
			with(_instSpider){
				web_frame += current_time_scale;
				
				var	_instWeb   = instance_rectangle_bbox(web_list_x1, web_list_y1, web_list_x2, web_list_y2, pet_target_inst),
					_instSlow  = [],
					_vertexNum = 0,
					_x1, _x2, _x3,
					_y1, _y2, _y3;
					
				draw_primitive_begin(pr_trianglestrip);
				
				with(web_list){
					_x3 = _x2;
					_y3 = _y2;
					_x2 = _x1;
					_y2 = _y1;
					_x1 = x;
					_y1 = y;
					
					 // Drawing Web Mask:
					draw_vertex(
						(x - _surfX) * _surfScale,
						(y - _surfY) * _surfScale
					);
					
					 // Slow Enemies:
					if(_vertexNum++ >= 2){
						var _inst = _instWeb;
						if(array_length(_inst)){
							_inst = instances_matching_ge(_inst, "bbox_right", min(_x1, _x2, _x3));
							if(array_length(_inst)){
								_inst = instances_matching_le(_inst, "bbox_left", max(_x1, _x2, _x3));
								if(array_length(_inst)){
									_inst = instances_matching_ge(_inst, "bbox_bottom", min(_y1, _y2, _y3));
									if(array_length(_inst)){
										_inst = instances_matching_le(_inst, "bbox_top", max(_y1, _y2, _y3));
										if(array_length(_inst)){
											with(_inst){
												//if(point_in_triangle(x, bbox_bottom, _x1, _y1, _x2, _y2, _x3, _y3)){
													if(!collision_line(x, y, xprevious, yprevious, Wall, false, false)){
														array_push(_instSlow, id);
													}
													_instWeb = array_delete_value(_instWeb, id);
												//}
											}
										}
									}
								}
							}
						}
					}
					
					 // Dissipate:
					if(frame < other.web_frame){
						var	_x = x,
							_y = y;
							
						 // Shrink Towards Next Point:
						if(_vertexNum + 1 < array_length(other.web_list)){
							with(other.web_list[_vertexNum + 1]){
								_x = x;
								_y = y;
							}
						}
						x = lerp(x, _x, 0.2 * current_time_scale);
						y = lerp(y, _y, 0.2 * current_time_scale);
						
						 // Delete:
						if(point_distance(_x, _y, x, y) < 1){
							with(other){
								Spider_web_delete(--_vertexNum);
							}
						}
					}
					
					 // In Coast Water:
					else if(wading){
						var _off = sin((current_frame + frame) / 10) * current_time_scale;
						x += _off * 0.1;
						y += _off * 0.15;
					}
				}
				
				 // Finish Web Mask:
				if(instance_exists(leader)){
					var	_l = web_add_l * (1 - (web_timer / web_timer_max)),
						_d = web_add_d;
						
					draw_vertex(
						(x           + lengthdir_x(_l, _d) - _surfX) * _surfScale,
						(bbox_bottom + lengthdir_y(_l, _d) - _surfY) * _surfScale
					);
				}
				draw_primitive_end();
				
				 // Particles:
				if(web_bits > 0){
					web_bits -= current_time_scale;
				}
				else{
					web_bits = 10 + random(20);
					if(array_length(web_list)) with(web_list[0]){
						if(frame < other.web_frame){
							if(other.curse > 0){
								instance_create(x, y, Curse);
							}
							else with(instance_create(x, y, Dust)){
								image_xscale /= 2;
								image_yscale /= 2;
							}
							with(instance_create(x, y, Feather)){
								sprite_index = spr.PetSpiderWebBits;
								image_index  = irandom(image_number - 1);
								image_angle  = orandom(30);
								image_speed  = 0;
								speed       *= 0.5;
								rot         *= 0.5;
								alarm0       = 60 + random(30);
							}
						}
					}
				}
				
				 // Slow Enemies on Web:
				if(curse != 0 && !ds_map_valid(web_hit_list)){
					web_hit_list = ds_map_create();
				}
				if(array_length(_instSlow)){
					var	_slow    = 2/3 * current_time_scale,
						_damage  = 10 * curse,
						_hitList = web_hit_list,
						_hitTime = web_frame;
						
					with(_instSlow){
						x = lerp(x, xprevious, _slow);
						y = lerp(y, yprevious, _slow);
						
						 // Special Stat:
						if("ntte_statspider" not in self){
							ntte_statspider = true;
							other.stat.webbed++;
						}
						
						 // Curse Damage:
						if(_damage != 0 && my_health > 0){
							if(!ds_map_exists(_hitList, id) || _hitList[? id] <= _hitTime){
								_hitList[? id] = _hitTime + 30;
								
								 // Damage:
								with(other){
									projectile_hit(other, _damage);
								}
								
								 // Killed:
								if(instance_exists(self) && my_health <= 0){
									sound_play_hit(sndPlantTBKill, 0.2);
									with(instance_create(x, y, TangleKill)){
										sprite_index = spr.PetSpiderCursedKill;
									}
								}
							}
						}
					}
				}
			}
			
			 // Draw Web Sprite Over Web Mask:
			draw_set_blend_mode_ext(bm_inv_dest_alpha, bm_inv_dest_alpha);
			draw_rectangle(0, 0, w * scale, h * scale, false);
			with(other){
				draw_sprite_tiled_ext(spr.PetSpiderWeb, 0, (0 - _surfX) * _surfScale, (0 - _surfY) * _surfScale, _surfScale, _surfScale, c_white, 1);
			}
			draw_set_blend_mode(bm_normal);
		}
		
		surface_reset_target();
	}
	
#define octobubble_draw
	 // Octo Bubble Draw:
	if(instance_exists(CustomHitme)){
		if(!area_get_underwater(GameCont.area) && (GameCont.area != 100 || !area_get_underwater(GameCont.lastarea))){
			var _inst = instances_matching(instances_matching(instances_matching(Pet, "pet", "Octo"), "visible", true), "hiding", false);
			if(array_length(_inst)) with(_inst){
				draw_sprite(sprPlayerBubble, -1, x + spr_bubble_x, y + spr_bubble_y);
			}
		}
	}
	
#define web_draw
	 // Drawing Web Surface:
	with(surface_setup("PetWeb", null, null, null)){
		draw_set_fog(true, make_color_rgb(50, 41, 71), 0, 0);
		draw_surface_scale(surf, x, y + 1, 1 / scale);
		draw_set_fog(false, 0, 0, 0);
		draw_surface_scale(surf, x, y, 1 / scale);
	}
	
#define web_draw_post
	 // Web Bloom:
	with(surface_setup("PetWeb", null, null, null)){
		draw_set_alpha(1/3);
		draw_set_blend_mode(bm_add);
		draw_surface_scale(surf, x, y, 1 / scale);
		draw_set_blend_mode(bm_normal);
		draw_set_alpha(1);
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