#define init
	 // Version:
	global.version = "";
	git_branch     = "";
	git_version    = "";
	
	 // Loading Vars:
	global.load = {};
	with(global.load){
		num        = 0;
		total      = 0;
		text       = "";
		type       = load_type_menu;
		open       = false;
		open_scale = 0;
		bloom      = 0;
		noinput    = 0;
		
		 // Sprites:
		spr = {
			"bar"  : sprite_add("sprites/menu/sprNTTELoading.png",     1, 34, 10),
			"fill" : sprite_add("sprites/menu/sprNTTELoadingFill.png", 3, 28,  8)
		};
		
		 // Mod Paths:
		list = [
			"teassets.mod.gml",
			"telib.mod.gml",
			"temenu.mod.gml",
			"teevents.mod.gml",
			"temerge.mod.gml",
			"ntte.mod.gml",
			"petlib.mod.gml",
			"objects/tegeneral.mod.gml",
			"objects/tepickups.mod.gml",
			"objects/tedesert.mod.gml",
			"objects/tecoast.mod.gml",
			"objects/teoasis.mod.gml",
			"objects/tetrench.mod.gml",
			"objects/tesewers.mod.gml",
			"objects/tescrapyard.mod.gml",
			"objects/tecaves.mod.gml",
			"objects/telabs.mod.gml",
			"areas/coast.area.gml",
			"areas/oasis.area.gml",
			"areas/trench.area.gml",
			"areas/pizza.area.gml",
			"areas/lair.area.gml",
			"areas/red.area.gml",
			"races/parrot.race.gml",
			"races/beetle.race.gml",
			"skins/angler fish.skin.gml",
			"skins/red crystal.skin.gml",
			"skins/bat eyes.skin.gml",
			"skins/orchid plant.skin.gml",
			"skins/coat venuz.skin.gml",
			"skins/bonus robot.skin.gml",
			"skins/cool frog.skin.gml",
			"skills/compassion.skill.gml",
			"skills/silver tongue.skill.gml",
			"skills/reroll.skill.gml",
			"skills/annihilation.skill.gml",
			"skills/lead ribs.skill.gml",
			"skills/toad breath.skill.gml",
			"skills/bat ears.skill.gml",
			"skills/magnetic pulse.skill.gml",
			"crowns/bonus.crown.gml",
			"crowns/crime.crown.gml",
			"crowns/red.crown.gml",
		//	"weps/merge.wep.gml",
			"weps/tewrapper.wep.gml",
			"weps/crabbone.wep.gml",
			"weps/scythe.wep.gml",
			"weps/teleport gun.wep.gml",
			"weps/super teleport gun.wep.gml",
			"weps/beetle pistol.wep.gml",
			"weps/rogue carbine.wep.gml",
			"weps/energy bat.wep.gml",
			"weps/annihilator.wep.gml",
			"weps/entangler.wep.gml",
			"weps/tunneller.wep.gml",
			"weps/bat disc launcher.wep.gml",
			"weps/bat disc cannon.wep.gml",
			"weps/pizza cutter.wep.gml",
			"weps/harpoon launcher.wep.gml",
			"weps/net launcher.wep.gml",
			"weps/clam shield.wep.gml",
			"weps/trident.wep.gml",
			"weps/bubble rifle.wep.gml",
			"weps/bubble shotgun.wep.gml",
			"weps/bubble minigun.wep.gml",
			"weps/bubble cannon.wep.gml",
			"weps/hyper bubbler.wep.gml",
			"weps/bubble bat.wep.gml",
			"weps/lightring launcher.wep.gml",
			"weps/super lightring launcher.wep.gml",
			"weps/tesla coil.wep.gml",
			"weps/electroplasma rifle.wep.gml",
			"weps/electroplasma shotgun.wep.gml",
			"weps/electroplasma cannon.wep.gml",
			"weps/quasar blaster.wep.gml",
			"weps/quasar rifle.wep.gml",
			"weps/quasar cannon.wep.gml",
			"weps/ultra quasar rifle.wep.gml"
		];
	}
	
	 // Changelog (Everything related to this is expected to be nonsync, except for the changelog viewer being open or not):
	global.log = {};
	with(global.log){
		list   = ds_list_create();
		index  = -1;
		x      = 40;
		y      = 36;
		width  = 0;
		height = 0;
		
		 // Previous Frame Stuff:
		game_width_previous     = game_width;
		game_height_previous    = game_height;
		mouse_xprevious_nonsync = mouse_x_nonsync;
		mouse_yprevious_nonsync = mouse_y_nonsync;
		
		 // Lines:
		lines = {};
		with(lines){
			x      = 0;
			y      = 0;
			width  = 0;
			height = 0;
			offset = 12;
			appear = 0;
			list   = [];
			filter = {};
			
			 // Splat:
			splat = {};
			with(splat){
				index        = 0;
				index_last   = index;
				x            = -1;
				y            = 0;
				sprite_index = sprDailySplat;
				image_index  = 0;
				image_angle  = point_direction(0, 0, 240, 2);
			}
		}
		
		 // Scrolling:
		scroll = {};
		with(scroll){
			index      = 0;
			index_last = index;
			mouse      = false;
			speed      = 0;
			
			 // Scroll Bar:
			bar = {};
			with(bar){
				active       = false;
				appear       = 0;
				x            = 28;
				y            = 16;
				sprite_index = sprite_add("sprites/menu/sprScrollBar.png", 1, 5, 0);
				image_index  = 0;
				image_xscale = 1;
				image_yscale = 1;
				
				 // Friend:
				cuz = {};
				with(cuz){
					x            = -1;
					y            = 0;
					sprite_index = sprCuzIdle;
					image_index  = 0;
					image_xscale = -1;
					image_yscale = 1;
				}
			}
		}
		
		 // Cycle Buttons:
		cycle = {};
		with(cycle){
			x            = 27;
			y            = -17;
			sprite_index = sprBossNameSplat;
			image_index  = 0;
			appear       = 0;
		}
		
		 // Filter:
		filter = {};
		with(filter){
			x            = -22;
			y            = 3;
			width        = 32;
			sprite_index = sprBossNameSplat;
			image_index  = 0;
			image_angle  = 90;
			appear       = 0;
			
			 // Filter Types:
			name = "Filter";
			list = {
				"+" : "New",
				"~" : "Change",
				"*" : "Fix",
				"-" : "Removal"
			};
		}
	}
	
	 // Retrieve Local Version:
	var _version = file_read(path_version);
	if(!is_undefined(_version)){
		global.version = _version;
	}
	
	 // Retrieve GitHub Version:
	try{
		 // Make Sure Current Branch Exists:
		var _gitBranchExists = false;
		with(github_repo_request(git_user, git_repo, git_token, "branches")){
			if(git_branch == name){
				_gitBranchExists = true;
				break;
			}
		}
		if(!_gitBranchExists){
			with(github_repo_request(git_user, git_repo, git_token, "")){
				git_branch = default_branch;
			}
		}
		
		 // Retrieve Latest Version:
		with(github_repo_request(git_user, git_repo, git_token, `contents/${path_version}?ref=${git_branch}`)){
			var _path = "github_data/" + name;
			
			 // Download:
			file_download(download_url, _path);
			while(!file_loaded(_path)){
				wait 0;
			}
			
			 // Get:
			if(file_exists(_path)){
				git_version = string_load(_path);
				file_delete(_path);
			}
			else file_unload(_path);
		}
	}
	catch(_error){}
	if(git_version == ""){
		git_version = global.version;
	}
	
	 // Retrieve Changelog File:
	var _fileText = undefined;
	if(global.version != git_version){
		try{
			with(github_repo_request(git_user, git_repo, git_token, `contents/${path_changelog}?ref=${git_branch}`)){
				var _path = "github_data/" + name;
				
				 // Download:
				file_download(download_url, _path);
				while(!file_loaded(_path)){
					wait 0;
				}
				
				 // Get:
				if(file_exists(_path)){
					_fileText = string_load(_path);
					file_delete(_path);
				}
				else file_unload(_path);
			}
		}
		catch(_error){
			_fileText = file_read(path_changelog);
		}
	}
	else _fileText = file_read(path_changelog);
	
	 // Parse Changelog File:
	if(!is_undefined(_fileText)){
		var	_name  = "",
			_text  = "",
			_index = 0;
			
		_fileText = string_replace_all(_fileText, chr(13) + chr(10), chr(10));
		_fileText = string_replace_all(_fileText, chr(10),           chr(13) + chr(10));
		
		with(string_split(_fileText, chr(13) + chr(10))){
			var _line = self;
			
			 // New Changelog:
			if(_line != "" && string_char_at(_line, 1) != chr(9)){
				if(_name != ""){
					changelog_add(_name, _text);
				}
				_name  = _line;
				_text  = "";
				_index = 0;
			}
			
			 // Add Line:
			else{
				_line = string_delete(_line, 1, 1);
				if(_index++ > 0 || _line != ""){
					_text += _line + chr(13) + chr(10);
				}
			}
		}
		if(_name != ""){
			changelog_add(_name, _text);
		}
	}
	
	 // Force Update:
	if(global.version == "" && global.version != git_version){
		global.load.type = load_type_updating;
	}
	
	 // Waiting for...
	global.load.open = true;
	while(
		global.load.open
		&& (
			!mod_sideload()                       // Mod loading permissions
			|| !instance_exists(Menu)             // Menu to exist
			|| global.load.open_scale < 1         // Loading bar to appear
			|| global.load.type == load_type_menu // Player to click button
		)
	){
		 // Disable "spec" Input:
		if(global.load.type == load_type_menu && instance_exists(Menu)){
			with(BackFromCharSelect){
				var _hover = false;
				for(var i = 0; i < maxp; i++){
					if(position_meeting((mouse_x[i] - (view_xview[i] + xstart)) + x, (mouse_y[i] - (view_yview[i] + ystart)) + y, id)){
						_hover = true;
						break;
					}
				}
				if(!_hover){
					noinput = 3;
				}
			}
		}
		wait 0;
	}
	
	 // Loading Time:
	switch(global.load.type){
		
		case load_type_loading: // LOAD MODS
			
			global.load.num   = 0;
			global.load.total = array_length(global.load.list);
			
			wait 10;
			
			var _modName = ds_map_create();
			
			 // Unload Mods:
			with(global.load.list){
				var	_path      = self,
					_pathSplit = string_split(_path, "/"),
					_fileSplit = string_split(_pathSplit[array_length(_pathSplit) - 1], "."),
					_type      = "",
					_name      = "";
					
				if(array_length(_fileSplit) >= 3){
					_type = _fileSplit[array_length(_fileSplit) - 2];
					_name = array_join(array_slice(_fileSplit, 0, array_length(_fileSplit) - 2), ".");
					if(_type == "wep"){
						_type = "weapon";
					}
					if(mod_exists(_type, _name)){
						mod_unload(_path);
					}
				}
				
				_modName[? _path] = [_type, _name];
			}
			
			 // Fetch Custom Weapon Mod Scripts:
			var	_wrapperScrt  = ds_list_create(),
				_wrapperTries = 10,
				_wrapperLoad  = [0];
				
			ds_list_add_array(_wrapperScrt, wrapper_script_base);
			
			for(var i = 0; i < maxp; i++){
				if(player_is_active(i)){
					_wrapperTries = max(_wrapperTries, (player_get_uid(i) - 1) * 30);
				}
			}
			
			wrapper_script_search(
				"../..",
				_wrapperScrt,
				wrapper_script_avoid,
				_wrapperTries,
				_wrapperLoad
			);
			
			 // Load Mods:
			with(global.load.list){
				var	_path = self,
					_type = _modName[? _path][0],
					_name = _modName[? _path][1];
					
				 // Loading Text:
				switch(string_split(_path, "/")[0]){
					case "teassets.mod.gml" : global.load.text = "Assets";     break;
					case "objects"          : global.load.text = "Objects";    break;
					case "areas"            : global.load.text = "Areas";      break;
					case "races"            : global.load.text = "Mutants";    break;
					case "skins"            : global.load.text = "Skins";      break;
					case "skills"           : global.load.text = "Mutations";  break;
					case "crowns"           : global.load.text = "Crowns";     break;
					case "weps"             : global.load.text = "Weapons";    break;
					default                 : global.load.text = "Main Files"; break;
				}
				
				 // Generate Wrapper Weapon File:
				if(_type == "weapon" && _name == "tewrapper"){
					while(_wrapperLoad[0]){
						wait 0;
					}
					wrapper_save(_name, _wrapperScrt, _path);
					_path = `data/${mod_current}.mod/` + _path;
				}
				
				 // Load:
				var _tries = 10;
				file_unload(_path);
				file_load(_path);
				while(!file_loaded(_path)){
					_tries++;
					wait 0;
				}
				if(file_exists(_path)){
					mod_load(_path);
					
					 // Wait:
					while(_tries-- > 0 && !mod_exists(_type, _name)){
						wait 0;
					}
				}
				file_unload(_path);
				
				 // Fully Loaded:
				if(mod_exists(_type, _name)){
					 // Wait for Sprites to Load:
					if(_type == "mod" && _name == "teassets"){
						if(array_length(mod_variable_get(_type, _name, "spr_load")) > 0){
							var _spritePercent = 0.2;
							
							global.load.num   /= (1 - _spritePercent);
							global.load.total /= (1 - _spritePercent);
							
							var	_loadA = global.load.num,
								_loadB = lerp(_loadA, global.load.total, _spritePercent);
								
							while(true){
								var _sprLoad = mod_variable_get(_type, _name, "spr_load");
								if(array_length(_sprLoad)){
									global.load.num = lerp(_loadA, _loadB, _sprLoad[0, 1] / lq_size(_sprLoad[0, 0]));
								}
								else break;
								wait 0;
							}
						}
					}
				}
				
				 // Failed to Load:
				else{
					with(global.load.list){
						if(mod_exists(_modName[? self][0], _modName[? self][1])){
							mod_unload(self);
						}
					}
					global.load.type = load_type_failed;
					trace("");
					trace_color("NT:TE | Loading Failed", c_yellow);
					trace(
						(git_version == "")
						? "Try redownloading the mod from NT:TE's itch.io page: yokin.itch.io/ntte"
						: "Will attempt to redownload files, please wait..."
					);
					break;
				}
				
				 // Advance Loading Bar:
				global.load.num += 1 + random(0.2);
			}
			
			ds_list_destroy(_wrapperScrt);
			ds_map_destroy(_modName);
			
			break;
			
		case load_type_updating: // UPDATE DA MOD
			
			try{
				var	_pathList = [""],
					_fileList = [];
					
				 // Display Changelog:
				if(!changelog_exists(changelog_get_display())){
					wait 15;
					changelog_set_display(0);
					wait 30;
				}
				
				 // Clear Version While Updating:
				string_save("", path_download + path_version);
				
				 // Only Download Changed Files:
				if(global.version != ""){
					try{
						global.load.text = "Searching";
						if(global.version == github_repo_request(git_user, git_repo, git_token, "commits/" + global.version).sha){
							var	_page    = 1,
								_pagePer = 30,
								_search  = true;
								
							_pathList = [];
							
							while(_search){
								var _list = github_repo_request(git_user, git_repo, git_token, `commits?sha=${git_branch}&page=${_page}&per_page=${_pagePer}`);
								if(is_array(_list) && array_length(_list) > 0){
									with(_list){
										global.load.num++;
										
										 // Stop Searching at the Local Version:
										with(parents){
											if(sha == global.version){
												_search = false;
											}
										}
										if(!_search){
											break;
										}
										
										 // Gather Files:
										with(github_repo_request(git_user, git_repo, git_token, "commits/" + sha).files){
											if(array_find_index(_fileList, filename) < 0){
												array_push(_fileList, filename);
												
												 // Specifics:
												switch(status){
													case "removed":
														file_delete(path_download + filename);
														break;
														
													case "renamed":
														file_delete(path_download + previous_filename);
														break;
												}
												
												 // New / Changed File:
												if(status != "removed"){
													var	_pathSplit = string_split(filename, "/");
														_path      = array_join(array_slice(_pathSplit, 0, array_length(_pathSplit) - 1), "/");
														
													if(array_find_index(_pathList, _path) < 0){
														array_push(_pathList, _path);
													}
												}
											}
										}
									}
									_page++;
								}
								else _search = false;
							}
						}
					}
					catch(_error){
						_pathList = [""];
					}
				}
				
				 // Search Directories & Download Files:
				for(var i = 0; i < array_length(_pathList); i++){
					var	_path = `contents/${_pathList[i]}?ref=${git_branch}`,
						_list = [];
						
					with(github_repo_request(git_user, git_repo, git_token, _path)){
						if(array_length(_fileList) <= 0 || array_find_index(_fileList, path) >= 0){
							switch(type){
								case "dir":
									array_push(_pathList, path);
									break;
									
								case "file":
									if(path != path_version){
										array_push(_list, path);
										file_download(download_url, path_download + path);
									}
									break;
							}
						}
					}
					
					 // Advance Loading Bar:
					global.load.num   = 0;
					global.load.total = array_length(_list);
					with(_list){
						while(!file_loaded(path_download + self)){
							wait 0;
						}
						file_unload(path_download + self);
						
						var _split = string_split(self, "/");
						global.load.text = array_join(array_slice(_split, 0, max(1, array_length(_split) - 1)), "/");
						global.load.num++;
					}
				}
				
				 // Save Version:
				string_save(git_version, path_download + path_version);
				
				 // Just in Case:
				if(global.load.total == 0){
					global.load.total = 1;
					global.load.num   = global.load.total;
				}
			}
			
			 // Update Failed:
			catch(_error){
				global.load.type = load_type_failed;
				trace("");
				trace_color(_error, c_yellow);
				trace("");
				trace_color("NT:TE | Update Failed", c_yellow);
				trace("Are you connected to the internet? Try downloading the latest version manually from NT:TE's itch.io page: yokin.itch.io/ntte");
			}
			
			break;
			
	}
	
	 // Finished:
	with(global.load){
		if(type != load_type_menu){
			sound_play_pitchvol(sndEXPChest, 1.5 + random(0.1), 0.6);
			
			 // Failure:
			if(type == load_type_failed){
				sound_play_pitchvol(sndCrownRandom, 0.6 + random(0.1), 0.5);
				text  = choose("Uh oh", "Something happened", "That's weird", "Failed", "ERROR");
				num   = 0;
				total = 1;
				wait 150;
			}
			
			 // Success:
			else{
				sound_play_pitchvol(sndNoSelect, 0.6 + random(0.1), 0.5);
				text = `@q@(color:${make_color_rgb(235, 0, 67)})Complete!`;
				wait 15;
			}
		}
		
		 // Wait for Changelog to Close:
		while(open && changelog_exists(changelog_get_display())){
			wait 0;
		}
		
		 // Close:
		open = false;
		while(open_scale > 0){
			wait 0;
		}
		
		 // Reload:
		if(type == load_type_updating){
			var	_path  = path_download + path_loader,
				_tries = 1;
				
			file_unload(_path);
			file_load(_path);
			while(!file_loaded(_path)){
				_tries++;
				wait 0;
			}
			if(file_exists(_path)){
				mod_load(_path);
				
				 // Wait:
				while(_tries-- > 0){
					wait 0;
				}
			}
			file_unload(_path);
			
			 // Failed to Reload:
			type = load_type_failed;
		}
		
		 // Unload:
		mod_loadtext(path_main_unload);
	}
	
#macro load_type_menu     -1 // Button menu
#macro load_type_loading   0 // Loading the mod
#macro load_type_updating  1 // Updating the mod
#macro load_type_failed    2 // Errored while loading

#macro path_download    "../../mods/NTTE/"
#macro path_main_load   "main.txt"
#macro path_main_allow  "main2.txt"
#macro path_main_unload "main3.txt"
#macro path_loader      mod_current + ".mod.gml"
#macro path_version     "NTTE-Version.txt"
#macro path_changelog   "NTTE-Changelog.txt"

#macro git_user    "Yokinman"
#macro git_repo    "NTTE-public"
#macro git_token   "8027349" + `5c4985b9a${'ef1078a'}1` + "36799068" + 'a1772033'
#macro git_branch  global.git_branch
#macro git_version global.git_version

#macro wrapper_script_base  ["init", "cleanup", "wep_base", "wep_swap", "projectile_setup", "weapon_raw", "weapon_name", "weapon_text", "weapon_swap", "weapon_sprt", "weapon_sprt_hud", "weapon_loadout", "weapon_area", "weapon_type", "weapon_cost", "weapon_rads", "weapon_load", "weapon_auto", "weapon_melee", "weapon_gold", "weapon_laser_sight", "weapon_fire", "weapon_reloaded", "step"]
#macro wrapper_script_avoid ["weapon_get_list", "weapon_get_name", "weapon_get_text", "weapon_get_swap", "weapon_get_sprt", "weapon_get_sprite", "weapon_get_sprt_hud", "weapon_get_area", "weapon_get_type", "weapon_get_cost", "weapon_get_rads", "weapon_get_load", "weapon_get_auto", "weapon_is_melee", "weapon_get_gold", "weapon_get_laser_sight", "weapon_set_name", "weapon_set_text", "weapon_set_swap", "weapon_set_sprt", "weapon_set_sprite", "weapon_set_area", "weapon_set_type", "weapon_set_cost", "weapon_set_rads", "weapon_set_load", "weapon_set_auto", "weapon_post"]

#define game_start
	 // Disable Changelog:
	changelog_set_display(-1);
	
#define draw_gui
	var _logIndex = changelog_get_display();
	
	 // Changelog Title:
	if(changelog_exists(_logIndex)){
		draw_set_font(fntM);
		draw_set_halign(fa_center);
		draw_set_valign(fa_bottom);
		draw_text_nt(round(game_width / 2), 32, changelog_get(_logIndex).name);
	}
	
	 // Loading Bar:
	with(global.load){
		 // Hiding/Showing Loading Bar:
		if(open){
			if(num < total || total == 0){
				 // Sound:
				if(open_scale <= 0){
					sound_play_pitchvol(sndMeleeFlip, 1.4 + random(0.1), 0.25);
					sound_play_pitchvol(sndHitMetal,  1.4 + random(0.1), 0.25);
				}
				
				 // Revealing:
				var _add = (1 - open_scale);
				if(abs(_add) > 0.01 * current_time_scale){
					_add *= 0.3 * current_time_scale;
				}
				open_scale += _add;
				bloom = 0;
				
				 // FAILED:
				if(type == load_type_failed){
					var _max = 0.9 + (0.03 * sin(current_frame / 60) * sin(current_frame / 97));
					num += (total / 100) * lerp(4, 0.5, (num / total) / _max) * current_time_scale;
					num = min(num, total * _max);
				}
			}
			
			 // Grow Bloom:
			else if(bloom < 2){
				bloom += 0.15 * current_time_scale;
			}
		}
		else{
			open_scale = max(open_scale - (0.4 * current_time_scale), 0);
		}
		
		 // Loading Bar:
		if(open_scale > 0){
			var	_x       = round(game_width / 2),
				_y       = round((12 + (11 * (instance_exists(CharSelect) || instance_exists(GameOverButton)))) * open_scale),
				_spr     = spr.bar,
				_sprFill = spr.fill,
				_img     = max(0, type),
				_xsc     = (changelog_exists(_logIndex) ? 1.1 : 1),
				_ysc     = 1,
				_load    = ((total == 0) ? 0 : (num / total));
				
			with(UberCont){
				draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, 0, c_white, 1);
			}
			
			if(type != load_type_menu){
				 // Disable Character Buttons:
				with(CharSelect){
					noinput = max(noinput, 10);
				}
				
				 // Fill:
				for(var i = 0; i <= 1; i++){
					var	_bloom  = ((i == 0) ? 0 : clamp(bloom, 0.4, 1)),
						_alpha  = ((i == 0) ? 1 : (0.25 - (0.025 * bloom))),
						_xscale = (1 + (0.15 * _bloom)) * _xsc,
						_yscale = (1 + (0.5  * _bloom)) * _ysc;
						
					if(_bloom > 0){
						draw_set_blend_mode(bm_add);
					}
					with(UberCont){
						draw_sprite_part_ext(
							_sprFill,
							_img,
							0,
							0,
							(sprite_get_width(_sprFill) * _load) + i,
							sprite_get_height(_sprFill),
							_x - (sprite_get_xoffset(_sprFill) * _xscale),
							_y - (sprite_get_yoffset(_sprFill) * _yscale),
							_xscale,
							_yscale,
							c_white,
							_alpha
						);
					}
					if(_bloom > 0){
						draw_set_blend_mode(bm_normal);
					}
				}
				
				 // % Text:
				draw_set_font(fntM);
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
				draw_text_nt(_x + (string_width("%") / 4), _y, `${floor(_load * 100)}%`);
				
				 // Secret Changelog Opener:
				if(changelog_exists(_logIndex) || (instance_exists(Menu) && Menu.mode == 1)){
					var	_x1 = _x - sprite_get_xoffset(_spr),
						_y1 = _y - sprite_get_yoffset(_spr),
						_x2 = _x1 + sprite_get_width(_spr),
						_y2 = _y1 + sprite_get_height(_spr);
						
					for(var i = 0; i < maxp; i++){
						if(button_pressed(i, "fire")){
							if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _x1, _y1, _x2, _y2)){
								if(changelog_exists(_logIndex)){
									sound_play(sndClickBack);
									changelog_set_display(-1);
								}
								else{
									changelog_set_display(0);
								}
								break;
							}
						}
					}
				}
			}
			
			 // Button Menu:
			else{
				var	_hover  = array_create(maxp, null),
					_button = [
						{	"x"      : 0,
							"y"      : 0,
							"font"   : fntSmall,
							"text"   : (changelog_exists(_logIndex) ? "Update" : "Load"),
							"color"  : "s",
							"input"  : (changelog_exists(_logIndex) ? "swap" : "pick"),
							"active" : (instance_exists(Menu) && mod_sideload() && (!changelog_exists(_logIndex) || global.version != git_version))
						},
						{	"x"      : -17 * _xsc,
							"y"      : 0,
							"font"   : fntM,
							"text"   : "X",
							"color"  : "s",
							"input"  : (changelog_exists(_logIndex) ? "" : "spec"),
							"active" : mod_sideload()
						},
						{	"x"      : 17 * _xsc,
							"y"      : 0,
							"font"   : fntM,
							"text"   : "!",
							"color"  : ((changelog_exists(_logIndex) || git_version == global.version || (current_frame % 24) < 8) ? "s" : "y"),
							"input"  : (changelog_exists(_logIndex) ? "" : "swap"),
							"active" : (instance_exists(Menu) && (mod_sideload() || changelog_exists(_logIndex)))
						}
					];
					
				 // Selection:
				if(open){
					for(var i = array_length(_button) - 1; i >= 0; i--){
						with(_button[i]){
							if(active){
								draw_set_font(font);
								
								var	_bx = (string_width(text)  / 2) + 4,
									_by = (string_height(text) / 2) + 4;
									
								for(var j = 0; j < maxp; j++){
									if(is_undefined(_hover[j])){
										var _pick = (
											button_pressed(j, input)
											&& other.noinput <= 0
											&& instance_exists(Menu)
										);
										if(
											_pick ||
											point_in_rectangle(
												mouse_x[j] - view_xview[j],
												mouse_y[j] - view_yview[j],
												_x + x - _bx,
												_y + y - _by,
												_x + x + _bx - 1,
												_y + y + _by - 1
											)
										){
											_hover[j] = self;
											
											 // Confirm:
											if(_pick || button_pressed(j, "fire")){
												sound_play_pitchvol(sndClick, 1 + random_range(-0.1, 0.1), 0.6);
												switch(text){
													case "Load":
														other.type = load_type_loading;
														break;
														
													case "Update":
														other.type = load_type_updating;
														
														 // Lets GOOO
														with(global.log.scroll.bar.cuz){
															sprite_index = sprCuzHorn;
															image_index  = 14;
															sound_play(sndCuzWep);
														}
														break;
														
													case "X":
														other.open = false;
														sound_play_pitchvol(sndNoSelect, 0.8 + random(0.1), 0.5);
														break;
														
													case "!":
														changelog_set_display(
															changelog_exists(changelog_get_display())
															? -1
															: 0
														);
														break;
												}
											}
										}
									}
								}
							}
						}
					}
				}
				
				 // Draw Buttons:
				draw_set_halign(fa_center);
				draw_set_valign(fa_middle);
				with(_button){
					draw_set_font(font);
					draw_text_nt(
						_x + x,
						_y + y,
						"@" + (active ? ((array_find_index(_hover, self) >= 0) ? "w" : color) : "d") + text
					);
				}
			}
			
			 // Loading Text:
			if(text != ""){
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
				
				 // Main:
				draw_set_font(fntM);
				draw_text_nt(
					_x + (33 * _xsc),
					_y - (7  * _ysc),
					["Loading", "Updating", "Failed"][max(0, type)]
				);
				
				 // Subtext:
				draw_set_font(fntSmall);
				draw_text_nt(
					_x + (34 * _xsc),
					_y + (2  * _ysc),
					text + string_repeat(".", round(1.5 - (1.5 * cos(total - num))))
				);
			}
			
			 // Instructional Text:
			if(open && total == 0){
				var _text = "";
				if(!instance_exists(Menu)){
					_text = "RETURN TO THE @yCAMPFIRE";
				}
				else if(!mod_sideload()){
					_text = `/@yallowmod @w${mod_current}.mod`;
				}
				if(_text != ""){
					draw_set_font(fntSmall);
					draw_set_halign(fa_center);
					draw_set_valign(fa_top);
					draw_text_nt(_x, _y + (12 * _ysc), _text);
				}
			}
		}
		
		 // Button Input Delay:
		if(noinput > 0){
			noinput -= current_time_scale;
		}
	}
	
#define draw_pause
	 // Paused Loading Bar:
	draw_set_projection(0);
	draw_gui();
	draw_reset_projection();
	
#define draw
	var	_mx    = mouse_x_nonsync,
		_my    = mouse_y_nonsync,
		_vx    = view_xview_nonsync,
		_vy    = view_yview_nonsync,
		_gw    = game_width,
		_gh    = game_height,
		_index = player_find_local_nonsync();
		
	 // Changelog:
	with(global.log){
		 // Screen Size Update:
		if(game_width_previous != _gw || game_height_previous != _gh){
			changelog_update();
		}
		
		 // Main Code:
		if(changelog_exists(changelog_get_display())){
			global.load.noinput = max(global.load.noinput, 6);
			
			if(!instance_exists(Menu) || Menu.mode == 1){
				var	_logW      = width,
					_logH      = height,
					_logX      = x + _vx,
					_logY      = y + _vy,
					_lines     = lines,
					_splatMin  = 0,
					_splatMax  = max(_splatMin, array_length(_lines.list)),
					_splatLast = _lines.splat.index_last,
					_scroll    = scroll,
					_scrollMin = 0,
					_scrollMax = max(_scrollMin, array_length(_lines.list) - (_lines.height / _lines.offset));
					
				 // Disable Menu:
				with(Menu){
					mode      = 0;
					alarm0    = -1;
					charsplat = 1;
					for(var i = 0; i < array_length(charx); i++){
						charx[i] = 0;
					}
					sound_volume(sndMenuCharSelect, 0);
				}
				with(Loadout) instance_destroy();
				with(loadbutton) instance_destroy();
				with(menubutton) instance_destroy();
				with(BackFromCharSelect) noinput = 10;
				
				 // Dim Screen:
				draw_set_color(c_black);
				draw_set_alpha(0.8);
				draw_rectangle(_vx, _vy, _vx + _gw, _vy + _gh, false);
				draw_set_alpha(1);
				
				 // Scrolling:
				with(_scroll){
					var	_barX1 = bar.x + _logX + _logW - (5 * bar.image_xscale),
						_barY1 = bar.y + _logY,
						_barX2 = _barX1 + (10  * bar.image_xscale),
						_barY2 = _barY1 + (100 * bar.image_yscale),
						_check = button_check_nonsync(_index, "fire"),
						_press = button_pressed_nonsync(_index, "fire");
						
					if(_scrollMax - 1 > 0){
						 // Scroll Bar:
						if(
							(_check && bar.active) ||
							(_press && point_in_rectangle(_mx, _my, _barX1 - 3, _barY1 - 8, _barX2 + 3, _barY2 + 8))
						){
							index = clamp((_my - _barY1) / (_barY2 - _barY1), 0, 1) * (_scrollMax - 1);
							speed = 0;
							
							 // Sound:
							if(!bar.active){
								bar.active = true;
								sound_play_pitch(sndCrownAppear, 0.9 + random_nonsync(0.2));
							}
						}
						else if(bar.active){
							bar.active = false;
							sound_play_pitch(sndMutAppear, 0.9 + random_nonsync(0.2));
						}
						
						 // Mouse Drag Scrolling:
						if(
							!bar.active &&
							(
								(_check && mouse) ||
								(_press && _mx >= _logX && _mx <= _logX + _logW)
							)
						){
							mouse = true;
							speed = (other.mouse_yprevious_nonsync - _my) / _lines.offset;
							index += speed;
						}
						else if(mouse){
							mouse = false;
							sound_play_pitch(sndMutAppear, 1 + ((speed / 16) * (240 / _gh)));
						}
					}
					else{
						bar.active = false;
						mouse      = false;
					}
					
					 // Normal:
					if(!bar.active && !mouse){
						 // Push Back to Changelog Zone:
						index += (max(min(index, _scrollMax - 1), _scrollMin) - index) * 0.7 * current_time_scale;
						
						 // Basic Scroll (Up/Down):
						var _move = (button_check_nonsync(_index, "sout") - button_check_nonsync(_index, "nort"));
						if(_move != 0){
							if(_scrollMax - 1 > 0){
								index += _move * current_time_scale;
							}
							if(index <= _scrollMin || index >= _scrollMax - 1){
								if(_splatMax > _splatMin){
									_lines.splat.index += _move * current_time_scale;
								}
							}
							speed = 0;
						}
						
						 // Splat Selection (Left/Right):
						else if(_splatMax > _splatMin){
							if(speed == 0){
								var _move = (button_pressed_nonsync(_index, "east") - button_pressed_nonsync(_index, "west"));
								if(_move != 0){
									_lines.splat.index += _move;
									sound_play_pitch(sndMutAppear, 1.2 + random_nonsync(0.4));
								}
								if(_scrollMax > _scrollMin){
									var _goal = min(
										_lines.splat.index,
										max(
											_lines.splat.index - (_lines.height / _lines.offset) + 1,
											index
										)
									);
									if(index != _goal){
										var _diff = (_goal - index);
										if(abs(_diff) > 0.01 * current_time_scale){
											_diff *= 2/3 * current_time_scale;
										}
										index      += _diff;
										index_last += _diff;
									}
								}
							}
						}
						
						 // Leftover Mouse Drag Scrolling Motion:
						if(abs(speed) > 0.05){
							index += speed * current_time_scale;
							speed *= power(0.9, current_time_scale);
						}
						else speed = 0;
					}
				}
				
				 // Cycle Splat:
				with(cycle){
					with(UberCont){
						draw_sprite_ext(
							other.sprite_index,
							other.image_index,
							other.x + _logX + _logW - 11,
							other.y + _logY + _logH + 5,
							1,
							1,
							0,
							c_white,
							1
						);
					}
					image_index = min(
						image_index + current_time_scale,
						sprite_get_number(sprite_index) - 1
					);
				}
				
				 // Filter Splat:
				with(filter){
					with(UberCont){
						draw_sprite_ext(
							other.sprite_index,
							other.image_index,
							other.x + _logX - 4,
							other.y + _logY + 40,
							1,
							1,
							other.image_angle,
							c_white,
							1
						);
					}
					image_index = clamp(
						image_index + (((appear > 0) ? 1 : -1) * current_time_scale),
						0,
						sprite_get_number(sprite_index) - 1
					);
				}
				
				 // Line Selection Splat:
				if(_splatMax > _splatMin){
					var	_x = _logX + _lines.x,
						_y = _logY + _lines.y;
						
					with(_lines.splat){
						 // Mouse Selection:
						if(
							(
								(
									clamp(_scroll.index, _scrollMin, _scrollMax - 1) != clamp(_scroll.index_last, _scrollMin, _scrollMax - 1)
									|| _mx != other.mouse_xprevious_nonsync
									|| _my != other.mouse_yprevious_nonsync
								)
								&& _mx >= _x
								&& _my >  _y
								&& _mx <= _x + _lines.width
								&& _my <  _y + _lines.height
							)
							|| _scroll.mouse
						){
							var _num = (((_my - 6) - _y) / _lines.offset) + _scroll.index;
							if(
								round(_num) >= 0                        &&
								round(_num) < array_length(_lines.list) &&
								_lines.list[round(_num)].splat
							){
								index      = _num;
								index_last = index;
							}
						}
						
						 // Keep Within Screen & Changelog:
						var _lock = (abs(_scroll.index - _scroll.index_last) < 1/3 * current_time_scale);
						if(_scroll.mouse || _lock){
							index      = round(index);
							index_last = round(index_last);
						}
						if(_scroll.mouse || !_lock){
							var	_min = _scroll.index,
								_max = _min + (_lines.height / _lines.offset) - 1;
								
							index      = max(_min, min(_max, index));
							index_last = max(_min, min(_max, index_last));
						}
						index      = clamp(index,      _splatMin, _splatMax - 1);
						index_last = clamp(index_last, _splatMin, _splatMax - 1);
						
						 // Avoid Blank Lines:
						var _add = 1;
						if(index != index_last){
							_add = sign(index - index_last);
						}
						else if(_scroll.index != _scroll.index_last){
							_add = sign(_scroll.index - _scroll.index_last);
						}
						repeat(2){
							while(
								!_lines.list[floor(index)].splat
								&& index + _add >= _splatMin
								&& index + _add <  _splatMax
							){
								index = floor(index + _add);
							}
							_add *= -1;
						}
						
						 // Animate & Draw:
						if(index != _splatLast){
							if(_scroll.bar.active){
								image_index = 0;
							}
							else{
								image_index -= min(
									image_index,
									0.5 * abs(_splatLast - index)
								);
							}
						}
						if(_lines.list[floor(index)].splat){
							with(UberCont){
								draw_sprite_ext(
									other.sprite_index,
									other.image_index,
									other.x + _x,
									other.y + _y + ((other.index - _scroll.index + 0.5) * _lines.offset),
									1,
									1,
									other.image_angle,
									c_white,
									1
								);
							}
						}
						if(!_scroll.bar.active && index < _lines.appear + max(floor(_scroll.index), 0)){
							image_index = clamp(
								image_index + current_time_scale,
								0,
								sprite_get_number(sprite_index) - 1
							);
						}
					}
				}
				
				 // Draw Text:
				with(_lines){
					var	_x      = x + _logX,
						_y      = y + _logY - (_scroll.index * offset),
						_min    = max(0, floor(_scroll.index)),
						_max    = min(array_length(list) - 1, floor(_scroll.index + (height / offset))) + 1,
						_pop    = appear + _min,
						_popAdd = 2 * current_time_scale;
						
					appear += _popAdd;
					
					draw_set_halign(fa_left);
					draw_set_valign(fa_top);
					
					for(var i = _min; i < min(_pop, _max); i++){
						with(list[list[i].index]){
							var	_dx = _x,
								_dy = _y + (index * other.offset);
								
							draw_set_font(font);
							
							 // Pop-in:
							if(i + _popAdd >= _pop){
								_dy--;
								sound_play(sndAppear);
							}
							
							 // Compile Lines:
							var _text = text;
							for(
								i = index;
								i < array_length(other.list) - 1 && index == other.list[i + 1].index;
								i++
							){
								_text += "#" + other.list[i + 1].text;
							}
							
							 // Title:
							if(title){
								 // Splat:
								with(UberCont){
									var _spr = sprScoreSplat;
									draw_sprite_ext(
										_spr,
										sprite_get_number(_spr) - 1,
										_dx,
										_dy + (string_height(_text) / 2),
										string_width(string_delete_nt(_text)) / (sprite_get_width(_spr) - (1 + sprite_get_xoffset(_spr))),
										1,
										0,
										c_white,
										1
									);
								}
								
								 // Text:
								draw_text_nt(_dx, _dy, _text);
							}
							
							 // Normal:
							else draw_text_nt(_dx, _dy, "@s" + _text);
						}
					}
				}
				
				 // Cycle Buttons:
				with(cycle){
					var	_x     = x + _logX + _logW,
						_y     = y + _logY + _logH,
						_oy    = 2 * max(0, 1 - appear),
						_cycle = 0;
						
					 // Q + E Swap:
					_cycle = (button_check_nonsync(_index, "pick") - button_check_nonsync(_index, "swap"));
					if(_cycle != 0){
						if((button_pressed_nonsync(_index, "pick") || button_pressed_nonsync(_index, "swap"))){
							var _logCycle = changelog_get_display() + _cycle;
							if(changelog_exists(_logCycle)){
								changelog_set_display(_logCycle);
							}
							else{
								sound_play_pitchvol(sndNoSelect, 1.2 + random_nonsync(0.2), 0.3);
								
								 // Update:
								if(_logCycle < 0 && global.version != git_version && global.load.type == load_type_menu){
									global.load.noinput = 0;
								}
							}
						}
						_oy += _cycle;
					}
					
					 // Click Button:
					if(point_in_rectangle(_mx, _my, _x - 16, _y - 16, _x + 16, _y + 16)){
						_cycle = ((_my < _y) ? -1 : 1);
						if(button_check_nonsync(_index, "fire")){
							if(button_pressed_nonsync(_index, "fire")){
								var _logCycle = changelog_get_display() + _cycle;
								if(changelog_exists(_logCycle)){
									changelog_set_display(_logCycle);
								}
								else{
									sound_play_pitchvol(sndNoSelect, 1.2 + random_nonsync(0.2), 0.3);
								}
								sound_play_pitchvol(sndClick, 1, 0.3);
							}
							_oy += _cycle;
							_cycle = 0;
						}
						_oy--;
					}
					
					 // Draw:
					with(UberCont){
						for(var i = 0; i <= 1; i++){
							var	_side   = ((i == 0) ? -1 : 1),
								_active = changelog_exists(changelog_get_display() + _side),
								_color  = merge_color((_active ? c_white : c_dkgray), c_black, ((_cycle == _side) ? 0 : 0.4));
								
							for(var _shadow = 1; _shadow >= 0; _shadow--){
								draw_sprite_ext(
									sprLoadoutArrow,
									i,
									_x - (_cycle == _side),
									_y + _oy + (6 * _side) + _shadow,
									-_side,
									1,
									0,
									((_shadow > 0) ? c_black : _color),
									1
								);
							}
						}
					}
					
					appear += current_time_scale;
				}
				
				 // Filter Buttons:
				with(filter){
					var _pop = appear;
					
					appear = clamp(appear + current_time_scale, 0, lq_size(_lines.filter));
					
					if(appear > 0){
						var	_x = x + _logX,
							_y = y + _logY,
							_w = width;
							
						draw_set_font(fntSmall);
						draw_set_halign(fa_center);
						draw_set_valign(fa_top);
						
						 // Title:
						draw_text_nt(_x, _y, name);
						_y += string_height(name) + 1;
						
						 // Buttons:
						for(var i = 0; i < min(appear, lq_size(_lines.filter)); i++){
							var	_type   = lq_get_key(_lines.filter, i),
								_active = lq_get_value(_lines.filter, i),
								_hover  = false,
								_text   = lq_defget(list, _type, _type),
								_rx     = _x - (_w / 2),
								_ry     = _y,
								_h      = string_height(_text) + 2;
								
							 // Pop-In:
							if(i >= _pop){
								_ry++;
							}
							
							 // Mouse Clicky:
							if(point_in_rectangle(_mx, _my, _rx, _ry, _rx + _w, _ry + _h)){
								_hover = true;
								if(button_check_nonsync(_index, "fire")){
									_hover = false;
									if(button_pressed_nonsync(_index, "fire")){
										 // Toggle:
										_active = !_active;
										lq_set(_lines.filter, _type, _active);
										
										 // Sound:
										sound_play_pitch(
											(_active ? sndClick : sndClickBack),
											lerp(1.3, 0.7, i / (lq_size(_lines.filter) - 1))
										);
										
										 // Display Update:
										changelog_set_display(changelog_get_display());
										_lines.appear = 1;
										draw_set_font(fntSmall);
									}
								}
							}
							
							 // Hover Extend:
							if(_hover){
								draw_set_color(merge_color(
									make_color_rgb(39, 43, 65),
									c_black,
									(_active ? 0 : 0.4)
								));
								draw_rectangle(_rx, _ry, _rx + _w - 1, _ry + _h - 1, false);
								if(_active){
									_rx++;
								}
							}
							
							 // Shadow:
							draw_set_color(c_black);
							draw_rectangle(_rx, _ry, _rx + _w, _ry + _h, false);
							
							 // Outline:
							draw_set_color(merge_color(make_color_rgb(59, 64, 89), c_black, (_active ? 0 : 0.4)));
							draw_rectangle(_rx, _ry, _rx + _w - 1, _ry + _h - 1, false);
							
							 // Filling:
							draw_set_color(merge_color(make_color_rgb(29, 42, 56), c_black, (_active ? 0 : 0.4)));
							draw_rectangle(_rx + 1, _ry + 1, _rx + _w - 2, _ry + _h - 2, false);
							
							 // Text:
							draw_text_nt(
								_rx + (_w / 2),
								_ry + 1,
								(_hover ? "" : (_active ? "@s" : "@d")) + _text
							);
							
							_y += _h + 1;
						}
					}
				}
				
				 // Draw Scroll Bar:
				with(_scroll.bar){
					var	_spr = sprite_index,
						_img = image_index,
						_xsc = image_xscale,
						_ysc = image_yscale * appear,
						_x   = x + _logX + _logW,
						_y   = y + _logY,
						_l   = 0,
						_t   = 0,
						_w   = sprite_get_width(_spr),
						_h   = sprite_get_height(_spr) * clamp(_scroll.index / max(1, _scrollMax - 1), 0, 1);
						
					if(appear > 0){
						 // Bar:
						with(UberCont){
							draw_sprite_ext(_spr, _img, _x - 1, _y + 2, _xsc, _ysc, 0, c_black, 1);
							draw_sprite_part_ext(_spr, _img, _t, _l, _w, _h, _x - (sprite_get_xoffset(_spr) * _xsc), _y - (sprite_get_yoffset(_spr) * _ysc), _xsc, _ysc, c_white, 1);
						}
						
						 // Keys:
						var	_nX = _x,
							_nY = _y - 8 + (2.5 * max(0, 2 - abs(_h))),
							_sX = _x,
							_sY = _y + (sprite_get_height(_spr) * _ysc) + 4 - (2.5 * max(0, 2 - abs(sprite_get_height(_spr) - _h)));
							
						draw_set_font(fntSmall);
						
						draw_text_nt(_nX,                                         _nY,                                         "@(sprKeySmall:nort)");
						draw_text_nt(_nX + !button_check_nonsync(_index, "nort"), _nY - !button_check_nonsync(_index, "nort"), "@(sprKeySmall:nort)");
						draw_text_nt(_sX,                                         _sY,                                         "@(sprKeySmall:sout)");
						draw_text_nt(_sX + !button_check_nonsync(_index, "sout"), _sY - !button_check_nonsync(_index, "sout"), "@(sprKeySmall:sout)");
					}
					
					 // Cuz Time:
					with(cuz){
						 // HORN!!!!
						if(button_pressed_nonsync(_index, "horn")){
							sound_play(sndCuzHorn);
							sprite_index = sprCuzHorn;
							image_index  = 0;
						}
						
						 // Draw:
						with(UberCont){
							draw_sprite_ext(
								other.sprite_index,
								other.image_index,
								other.x + _x,
								other.y + _y + (_h * _ysc),
								other.image_xscale,
								other.image_yscale,
								0,
								c_white,
								1
							);
						}
						
						 // Animate:
						image_index += 0.4 * current_time_scale;
						if(image_index >= sprite_get_number(sprite_index)){
							image_index -= sprite_get_number(sprite_index);
							
							if(_scroll.index > 0 && _scroll.index >= _scrollMax - 1){
								sprite_index = sprCuzCry;
							}
							else switch(sprite_index){
								case sprCuzInteract:
								case sprCuzInteractTo:
									sprite_index = (
										(_scroll.index == _scroll.index_last && _scroll.index > 0)
										? sprCuzInteract
										: sprCuzInteractFrom
									);
									break;
									
								default:
									sprite_index = (
										(_scroll.index == _scroll.index_last && _scroll.index > 0)
										? sprCuzInteractTo
										: sprCuzIdle
									);
							}
						}
					}
					
					 // Grow/Shrink:
					var _diff = ((_scrollMax - 1 > 0) - appear);
					if(abs(_diff) > 0.01){
						_diff *= 0.5 * current_time_scale;
					}
					appear += _diff;
				}
				
				 // Close Changelog:
				var _close = false;
				for(var i = 0; i < maxp; i++){
					with(BackFromCharSelect){
						if(position_meeting((mouse_x[i] - (view_xview[i] + xstart)) + x, (mouse_y[i] - (view_yview[i] + ystart)) + y, id)){
							if(button_pressed(i, "fire")){
								_close = true;
								break;
							}
						}
					}
					if(button_pressed(i, "spec") || button_pressed(i, "paus")){
						_close = true;
						break;
					}
				}
				if(_close){
					sound_play(sndClickBack);
					changelog_set_display(-1);
				}
			}
			else changelog_set_display(-1);
		}
		
		 // Previous Frame Stuff:
		lines.splat.index_last  = lines.splat.index;
		scroll.index_last       = scroll.index;
		game_width_previous     = _gw;
		game_height_previous    = _gh;
		mouse_xprevious_nonsync = _mx;
		mouse_yprevious_nonsync = _my;
	}
	
#define changelog_get_display()
	/*
		Returns the index of the currently displayed changelog, or -1 if the changelog display is disabled
	*/
	
	return global.log.index;
	
#define changelog_set_display(_index)
	/*
		Sets the displayed changelog to the one at the given index, use -1 to disable the changelog display
	*/
	
	with(global.log){
		var _lastIndex = index;
		index = (
			changelog_exists(_index)
			? _index
			: -1
		);
		
		 // Lines:
		with(lines){
			 // Reset Pop-In:
			appear = 0;
			
			 // Reset Splat:
			with(splat){
				index       = 0;
				index_last  = index;
				image_index = 0;
			}
		}
		
		 // Reset Scrolling:
		with(scroll){
			index      = 0;
			index_last = index;
			speed      = 0;
			bar.active = false;
		}
		
		 // Opened:
		if(changelog_exists(_index)){
			if(!changelog_exists(_lastIndex)){
				 // Reset Scroll Bar:
				with(scroll.bar){
					appear = 0;
					
					 // WOO
					with(cuz){
						if(global.version == git_version){
							sprite_index = sprCuzIdle;
							image_index  = random_nonsync(sprite_get_number(sprite_index));
						}
						else{
							sprite_index = sprCuzHorn;
							image_index  = 10;
							sound_play(sndCuzGreet);
						}
					}
				}
				
				 // Reset Cycle:
				with(cycle){
					image_index = 0;
					appear      = 0;
				}
				
				 // Reset Filter:
				with(filter){
					image_index = 0;
					appear      = 0;
				}
			}
			
			 // Sound:
			sound_play_pitch(sndMenuCredits, 0.9 + random_nonsync(0.2));
		}
		
		 // Closed:
		else if(changelog_exists(_lastIndex)){
			 // Reset Menu:
			with(Menu) with(self){
				mode = 0;
				event_perform(ev_step, ev_step_end);
				sound_volume(sndMenuCharSelect, 1);
				sound_stop(sndMenuCharSelect);
			}
			with(Loadout) selected = 0;
		}
	}
	
	 // Display Update:
	changelog_update();
	
#define changelog_size()
	/*
		Returns the current number of changelogs
	*/
	
	return ds_list_size(global.log.list);
	
#define changelog_get(_index)
	/*
		Returns the changelog at the given index, or 'noone' if it doesn't exist
	*/
	
	return (
		changelog_exists(_index)
		? global.log.list[| _index]
		: noone
	);
	
#define changelog_set(_index, _name, _text)
	/*
		Sets a new changelog with the given name and text at the given index
	*/
	
	changelog_insert(_index, _name, _text);
	changelog_delete(_index + 1);
	
#define changelog_add(_name, _text)
	/*
		Appends a new changelog with the given name and text
	*/
	
	changelog_insert(changelog_size(), _name, _text);
	
#define changelog_insert(_index, _name, _text)
	/*
		Inserts a new changelog at the given index with given name and text
	*/
	
	var	_lineList = [],
		_sprList  = ds_map_create(),
		_filter   = {};
		
	 // Compile Lines:
	if(_text != ""){
		var	_lastType  = "",
			_lastFrame = current_frame;
			
		if(fork()){
			with(string_split(_text, chr(13) + chr(10))){
				var	_textList = [],
					_raw      = string_delete_nt(self),
					_rawSpace = string_replace_all(_raw, chr(9), " "),
					_font     = fntChat,
					_type     = string_copy(_raw, 1, string_pos(" ", _rawSpace + " ") - 1),
					_title    = false,
					_indent   = "";
					
				 // Determine Line Type (Filter):
				if(_raw != "" && string_lettersdigits(_type) == ""){
					if(_type == ""){
						_type = _lastType;
					}
					else if(_type not in _filter){
						lq_set(_filter, _type, true);
					}
				}
				_lastType = _type;
				
				 // Title Line:
				if(_raw == string_upper(_raw)){
					if(string_lettersdigits(_raw) != ""){
						_title = true;
						_font  = fntM;
					}
				}	
				
				 // Determine Line Wrapping Indent:
				for(var i = 1; i <= string_length(_raw); i++){
					if(string_char_at(_rawSpace, i) == " "){
						_indent += string_char_at(_raw, i);
					}
					else{
						var _add = string_copy(_raw, 1, string_pos(" ", string_delete(_rawSpace, 1, string_length(_indent)) + " "));
						if(string_letters(_add) == ""){
							_indent += _add;
						}
						break;
					}
				}
				for(var i = 1 + string_length(_indent); i <= string_length(_raw); i++){
					if(string_char_at(_rawSpace, i) == " "){
						_indent += string_char_at(_raw, i);
					}
					else break;
				}
				
				 // Compile Words:
				var	_formatIndex  = 0,
					_formatSplit  = string_split(self, "@"),
					_formatCancel = false;
					
				with(_formatSplit){
					var _add = self;
					
					 // Special Formatting:
					if(_formatCancel){
						_formatCancel = false;
						_add = "@" + _add;
					}
					else if(_formatIndex > 0){
						var _char = string_char_at(_add, 1);
						
						_add = string_delete(_add, 1, string_length(_char));
						
						switch(_char){
							
							 /// CANCEL
							case "":
								
								_add = "@" + _add;
								_formatCancel = true;
								
								break;
							
							 /// BASIC
							case "w": _add = "@w" + _add; break; // WHITE
							case "s": _add = "@s" + _add; break; // SILVER
							case "d": _add = "@d" + _add; break; // DARK GRAY
							case "r": _add = `@(color:${make_color_rgb(235,   0,  67)})` + _add; break; // RED
							case "g": _add = `@(color:${make_color_rgb(100, 255,   0)})` + _add; break; // GREEN
							case "b": _add = `@(color:${make_color_rgb( 24, 126, 242)})` + _add; break; // BLUE
							case "p": _add = `@(color:${make_color_rgb(169,  36, 179)})` + _add; break; // PURPLE
							case "y": _add = "@y" + _add; break; // YELLOW
							case "q": _add = "@q" + _add; break; // QUAKE
							
							 /// ADVANCED
							case "(":
								
								var _end = string_pos(")", _add);
								
								if(_end > 0){
									var _args = string_split(string_copy(_add, 1, _end - 1), ":");
									
									_add = string_delete(_add, 1, _end);
									
									switch(_args[0]){
										
										case "rgb":
											
											if(array_length(_args) > 3){
												_add = `@(color:${make_color_rgb(real(_args[1]), real(_args[2]), real(_args[3]))})` + _add;
											}
											
											break;
											
										case "sprite":
											
											if(array_length(_args) > 1 && ds_map_valid(_sprList)){
												var	_spr = -1,
													_num = ((array_length(_args) > 2) ? real(_args[2]) :  0);
													
												 // Normal Sprite:
												if(_num <= 0){
													_spr = asset_get_index(_args[1]);
												}
												
												 // Load Sprite:
												else{
													var	_path = `sprites/${_args[1]}`,
														_key  = _path + ":" + string(_num);
														
													if(!ds_map_exists(_sprList, _key)){
														_sprList[? _key] = -1;
														
														 // Load File Manually & Make Sure it Exists:
														if(file_loaded(_path)){
															file_unload(_path);
														}
														if(global.version != git_version){
															try{
																file_download(
																	github_repo_request(git_user, git_repo, git_token, `contents/${_path}?ref=${git_branch}`).download_url,
																	_path
																);
															}
															catch(_error){
																file_load(_path);
															}
														}
														else file_load(_path);
														while(!file_loaded(_path)){
															wait 0;
														}
														
														 // Load Sprite:
														if(file_exists(_path)){
															_sprList[? _key] = sprite_add(_path, _num, 0, 0);
														}
													}
													if(ds_map_exists(_sprList, _key)){
														_spr = _sprList[? _key];
													}
												}
												
												 // Add Sprite:
												if(sprite_exists(_spr)){
													var	_img    = ((array_length(_args) > 3) ? real(_args[3]) : -0.4),
														_width  = ((array_length(_args) > 4) ? real(_args[4]) : -1),
														_height = ((array_length(_args) > 5) ? real(_args[5]) : -1);
														
													 // Find Sprite's Bounding Box:
													if(_width < 0 || _height < 0){
														if(_img < 0){
															if(_width  < 0) _width  = (sprite_get_bbox_right(_spr) + 1) - sprite_get_bbox_left(_spr);
															if(_height < 0) _height = ((sprite_get_bbox_bottom(_spr) + 1) - (sprite_get_height(_spr) / 2)) * 2;
														}
														else{
															var _sprCut = sprite_duplicate_ext(_spr, _img, 1);
															if(_width  < 0) _width  = (sprite_get_bbox_right(_sprCut) + 1) - sprite_get_bbox_left(_sprCut);
															if(_height < 0) _height = ((sprite_get_bbox_bottom(_sprCut) + 1) - (sprite_get_height(_sprCut) / 2)) * 2;
															sprite_delete(_sprCut);
														}
													}
													
													 // Add:
													array_push(_textList, {
														"text"   : `@(${_spr}:${_img})`,
														"space"  : 0,
														"width"  : _width,
														"height" : _height
													});
												}
											}
											
											break;
											
									}
								}
								
								break;
								
						}
					}
					
					 // Add Words:
					if(_add != ""){
						var _wordList = string_split(string_replace_all(_add, chr(9), chr(9) + " "), " ");
						for(var i = 0; i < array_length(_wordList); i++){
							var	_word  = _wordList[i],
								_space = (
									(i < array_length(_wordList) - 1 || _formatIndex >= array_length(_formatSplit) - 1)
									? ((string_pos(chr(9), _word) > 0) ? 2 : 1)
									: 0
								);
								
							if(_word != "" || _space > 0){
								array_push(_textList, {
									"text"   : string_replace_all(_word, chr(9), ""),
									"space"  : _space,
									"width"  : 0,
									"height" : 0
								});
							}
						}
					}
					
					_formatIndex++;
				}
				
				 // Add Line:
				array_push(_lineList, {
					"list"   : _textList,
					"font"   : _font,
					"type"   : _type,
					"title"  : _title,
					"indent" : _indent
				});
				
				 // Update Displayed Changelog:
				if(current_frame != _lastFrame){
					_lastFrame = current_frame;
					if(changelog_get_display() == _index && changelog_exists(_index)){
						if(_lineList == changelog_get(_index).list){
							changelog_update();
						}
					}
				}
			}
			
			 // Update Displayed Changelog:
			if(changelog_get_display() == _index && changelog_exists(_index)){
				if(_lineList == changelog_get(_index).list){
					changelog_update();
				}
			}
			
			exit;
		}
	}
	
	 // Fill Empty Slots:
	for(var i = changelog_size(); i < _index; i++){
		changelog_set(i, "", "");
	}
	
	 // Insert Changelog:
	ds_list_insert(global.log.list, _index, {
		"name"    : _name,
		"list"    : _lineList,
		"sprites" : _sprList,
		"filter"  : _filter
	});
	
	 // Offset Displayed Changelog:
	if(changelog_get_display() >= _index){
		global.log.index++;
	}
	
#define changelog_delete(_index)
	/*
		Deletes the changelog at the given index and unloads any sprites it contained
		If that changelog was currently displayed, the one before it is displayed
	*/
	
	if(changelog_exists(_index)){
		 // Unload Sprites:
		with(changelog_get(_index)){
			with(ds_map_keys(sprites)){
				file_unload(string_split(self, ":")[0]);
				sprite_delete(other.sprites[? self]);
			}
			ds_map_destroy(sprites);
		}
		
		 // Delete Changelog:
		ds_list_delete(global.log.list, _index);
		
		 // Offset Displayed Changelog:
		if(_index == changelog_get_display()){
			changelog_set_display(_index - 1);
		}
		else if(changelog_get_display() > _index){
			global.log.index--;
		}
	}
	
#define changelog_exists(_index)
	/*
		Returns 'true' if a changelog exists at the given index, 'false' otherwise
	*/
	
	return (_index >= 0 && _index < changelog_size());
	
#define changelog_update()
	/*
		Updates the changelog's variables for display purposes
	*/
	
	with(global.log){
		width  = game_width  - (2 * x);
		height = game_height - (2 * y);
		
		 // Scale Scroll Bar:
		with(scroll.bar){
			var _sprH = sprite_get_height(sprite_index);
			image_yscale = max(0.1, (game_height - (240 - _sprH)) / _sprH);
		}
		
		 // Format Lines:
		with(lines){
			x      = max(0, round(other.width / 2) - 120);
			width  = other.width - x;
			height = other.height;
			list   = [];
			
			var _lines = self;
			
			with(changelog_get(changelog_get_display())){
				other.filter = filter;
				with(list){
					if(lq_defget(other.filter, type, true)){
						var	_text    = "",
							_font    = font,
							_title   = title,
							_indent  = "",
							_tabSize = 3;
							
						draw_set_font(_font);
						
						 // Generate Indentation Text:
						for(var i = 1; i <= string_length(indent); i++){
							var _char = string_char_at(indent, i);
							if(_char == chr(9)){
								var _tabLevel = string_width(_indent) / (string_width(" ") * _tabSize);
								_char = string_repeat(" ", ceil(_tabSize * ((floor(_tabLevel) + 1) - _tabLevel)));
							}
							_indent += _char;
						}
						
						 // Line Wrapping:
						var	_line       = "",
							_lineHeight = 0;
							
						with(list){
							var	_width   = ceil((width                    / 2) / string_width(" ")),
								_height  = ceil(((height - _lines.offset) / 2) / string_height(" ")),
								_lineAdd = string_repeat(" ", _width) + text + string_repeat(" ", _width);
								
							 // Auto Line Breaking:
							if(string_width(string_delete_nt(_line + _lineAdd)) > _lines.width){
								if(string_delete_nt(_line) != _indent){
									_text += string_repeat("#", _lineHeight) + _line + string_repeat("#", _lineHeight);
									_line = "#" + string_repeat(" ", round(string_width(_indent) / string_width(" ")));
									_lineHeight = 0;
								}
							}
							_lineHeight = max(_height, _lineHeight);
							
							 // Add:
							_line += _lineAdd;
							switch(space){
								case 1: // Space
									_line += " ";
									break;
									
								case 2: // Tab
									var _tabLevel = string_width(string_delete_nt(_line)) / (string_width(" ") * _tabSize);
									_line += string_repeat(" ", ceil(_tabSize * ((floor(_tabLevel) + 1) - _tabLevel)));
									break;
							}
						}
						
						_text += string_repeat("#", _lineHeight) + _line + string_repeat("#", _lineHeight);
						
						 // Add Lines:
						var	_index    = array_length(_lines.list),
							_lineList = string_split(_text, "#"),
							_lineMax  = array_length(_lineList);
							
						for(var i = 0; i < _lineMax; i++){
							var _line = _lineList[i];
							
							 // Group Lines Within Offset Height:
							for(var j = i + 1; j < _lineMax; j++){
								if(string_height(_line + chr(13) + chr(10) + _lineList[j] + " ") <= _lines.offset){
									_line += "#" + _lineList[j];
									i = j;
								}
								else break;
							}
							
							 // Add:
							array_push(_lines.list, {
								"text"  : _line,
								"font"  : _font,
								"index" : _index,
								"title" : _title,
								"splat" : (string_trim(string_delete_nt(_line)) != "")
							});
						}
					}
				}
			}
		}
	}
	
#define file_read(_path)
	/*
		Loads the file at the given path, returns its string contents, and unloads the file
		Delays further code execution until the file is loaded
	*/
	
	var _load = undefined;
	
	 // Unload:
	if(file_loaded(_path)){
		file_unload(_path);
	}
	
	 // Load:
	file_load(_path);
	while(!file_loaded(_path)){
		wait 0;
	}
	
	 // Retrieve:
	if(file_exists(_path)){
		_load = string_load(_path);
	}
	
	 // Unload:
	file_unload(_path);
	
	return _load;
	
#define github_repo_request(_gitUser, _gitRepo, _gitToken, _gitPath)
	/*
		Returns the API for a given GitHub repository via HTTP GET
		If unsuccessful, returns 'undefined' - see the latest file in 'data/name.mod/github_data/' to find the issue
		Delays further code execution until the file is loaded
		
		Args:
			gitUser  - The owner of the repository
			gitRepo  - The name of the repository
			gitToken - A personal access token, use "" for no token (https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
			gitPath  - The path to retrieve API from
			
		Ex:
			with(github_repo_request("Yokinman", "NTTE-public", "d5bc40c0fb8964158bfa99577f3e2c823c553aa5", "branches")){
				trace(name);
			}
	*/
	
	 // Global Variable Setup:
	if(!mod_variable_exists(script_ref_create(0)[0], mod_current, "github_repo_request_id")){
		global.github_repo_request_id = 0;
	}
	
	 // Setup URL:
	var	_url = `https://api.github.com/repos/${_gitUser}/${_gitRepo}`;
	if(_gitPath != ""){
		_url += "/" + _gitPath;
	}
	
	 // Setup HTTP Headers:
	var _headers = ds_map_create();
	if(_gitToken != ""){
		_headers[? "Authorization"] = "token " + _gitToken;
	}
	_headers[? "Cache-Control"] = "no-cache";
	_headers[? "Accept"       ] = "application/vnd.github.v3.full+json";
	_headers[? "User-Agent"   ] = "Nuclear Throne Together";
	
	 // Request Data:
	var _dataPath = `github_data/repo_request_${_gitUser}_${_gitRepo}_${global.github_repo_request_id++}.txt`;
	http_request(_url, "GET", _headers, "", _dataPath);
	ds_map_destroy(_headers);
	while(!file_loaded(_dataPath)){
		wait 0;
	}
	
	 // Decode Data:
	var _data = undefined;
	try{
		_data = json_decode(string_load(_dataPath));
		file_delete(_dataPath);
	}
	catch(_error){
		string_save(_error, _dataPath);
		file_unload(_dataPath);
	}
	
	return _data;
	
#define wrapper_save(_name, _scrList, _path)
	/*
		Generates a wrapper weapon file
		
		Args:
			name    - The name of the wrapper weapon's LWO container variable
			scrList - A ds_list of scripts to add to the file
			path    - The path used to save the file
	*/
	
	var	_gml = "",
		_new = chr(13) + chr(10) + chr(9); // Line Break + Indent
		
	with(ds_list_to_array(_scrList)){
		var _scrName = self;
		
		if(_gml != ""){
			_gml += _new + chr(13) + chr(10);
		}
		
		switch(_scrName){
		
			case "init":
			case "cleanup":
			
				_gml += `#define ${_scrName}`
				_gml += _new + `mod_script_call("mod", "teassets", "ntte_${_scrName}", script_ref_create(${_scrName}));`
				
				 // Macros:
				if(_scrName == "cleanup"){
					_gml += _new;
					_gml += chr(13) + chr(10) + `#macro call script_ref_call`;
					_gml += chr(13) + chr(10) + `#macro scr  global.scr`;
				}
				
				break;
				
			case "wep_base": // Returns the base "wep" value for a LWO weapon
			
				_gml += `#define ${_scrName}(_wep)`
				_gml += _new + `while(is_object(_wep)){`
				_gml += _new + `	_wep = (("wep" in _wep) ? _wep.wep : wep_none);`
				_gml += _new + `}`
				_gml += _new + `return _wep;`
				_gml += _new;
				_gml += chr(13) + chr(10) + `#macro wep_raw  (is_object(wep)  ? ${_scrName}(wep)  : wep)`;
				_gml += chr(13) + chr(10) + `#macro bwep_raw (is_object(bwep) ? ${_scrName}(bwep) : bwep)`;
				
				break;
				
			case "wep_swap": // For non-LWO weapons, this swaps the wrapper weapons in the given weapon slots with their stored weapon (to fix LWO weapon initialization)
			
				_gml += `#define ${_scrName}(_swap, _slot, _wep)`
				_gml += _new + `var _wrap = _wep.${_name};`
				_gml += _new + `if(!_wrap.lwo){`
				                	 // Swap To:
				_gml += _new + `	if(_swap == true){`
				_gml += _new + `		var	_slotMax = array_length(_slot),`
				_gml += _new + `			_slotWep = [(("bwep" in self) ? bwep : undefined), (("wep" in self) ? wep : undefined)],`
				_gml += _new + `			_slotNew = [];`
				_gml += _new + `			`
				_gml += _new + `		for(var i = 0; i < _slotMax; i++){`
				_gml += _new + `			var _primary = _slot[i];`
				_gml += _new + `			if(_slotWep[_primary] == _wep){`
				_gml += _new + `				if(_primary){`
				_gml += _new + `					if(object_index == WepPickup){`
				_gml += _new + `						try{`
				_gml += _new + `							if(!null){`
				_gml += _new + `								var	_lastVisible = visible,`
				_gml += _new + `									_lastDepth   = depth,`
				_gml += _new + `									_lastSprite  = sprite_index,`
				_gml += _new + `									_lastMask    = mask_index,`
				_gml += _new + `									_lastSolid   = solid,`
				_gml += _new + `									_lastPersist = persistent;`
				_gml += _new + `									`
				_gml += _new + `								instance_change(Player, false);`
				_gml += _new + `								wep = _wrap.wep;`
				_gml += _new + `								instance_change(WepPickup, false);`
				_gml += _new + `								`
				_gml += _new + `								visible      = _lastVisible;`
				_gml += _new + `								depth        = _lastDepth;`
				_gml += _new + `								sprite_index = _lastSprite;`
				_gml += _new + `								mask_index   = _lastMask;`
				_gml += _new + `								solid        = _lastSolid;`
				_gml += _new + `								persistent   = _lastPersist;`
				_gml += _new + `							}`
				_gml += _new + `						}`
				_gml += _new + `						catch(_error){}`
				_gml += _new + `					}`
				_gml += _new + `					else wep = _wrap.wep;`
				_gml += _new + `				}`
				_gml += _new + `				else{`
				_gml += _new + `					bwep = _wrap.wep;`
				_gml += _new + `				}`
				_gml += _new + `				array_push(_slotNew, _primary);`
				_gml += _new + `			}`
				_gml += _new + `		}`
				_gml += _new + `		`
				_gml += _new + `		if(array_length(_slotNew)){`
				_gml += _new + `			return [_slotWep, _slotNew];`
				_gml += _new + `		}`
				_gml += _new + `	}`
				                	
				                	 // Swap Back:
				_gml += _new + `	else for(var i = array_length(_slot) - 1; i >= 0; i--){`
				_gml += _new + `		var	_primary = _slot[i],`
				_gml += _new + `			_swapped = false;`
				_gml += _new + `			`
				                		 // Check if Weapon is Held:
				_gml += _new + `		if(`
				_gml += _new + `			_primary`
				_gml += _new + `			? ("wep"  in self && wep_raw  == _wrap.wep)`
				_gml += _new + `			: ("bwep" in self && bwep_raw == _wrap.wep)`
				_gml += _new + `		){`
				_gml += _new + `			_swapped = true;`
				_gml += _new + `		}`
				_gml += _new + `		else if(`
				_gml += _new + `			_primary`
				_gml += _new + `			? ("bwep" in self && bwep_raw == _wrap.wep && bwep != _swap[0])`
				_gml += _new + `			: ("wep"  in self && wep_raw  == _wrap.wep && wep  != _swap[1])`
				_gml += _new + `		){`
				_gml += _new + `			_swapped = true;`
				_gml += _new + `			_primary = !_primary;`
				_gml += _new + `		}`
				_gml += _new + `		`
				                		 // Set Weapon:
				_gml += _new + `		if(_swapped){`
				_gml += _new + `			if(is_object(_primary ? wep : bwep)){`
				_gml += _new + `				_wrap.lwo = true;`
				_gml += _new + `				_wrap.wep = (_primary ? wep_raw : bwep_raw);`
				_gml += _new + `				for(var i = lq_size(_wep) - 1; i >= 0; i--){`
				_gml += _new + `					lq_set((_primary ? wep : bwep), lq_get_key(_wep, i), lq_get_value(_wep, i));`
				_gml += _new + `				}`
				_gml += _new + `			}`
				_gml += _new + `			else if(_primary){`
				_gml += _new + `				if(object_index == WepPickup){`
				_gml += _new + `					try{`
				_gml += _new + `						if(!null){`
				_gml += _new + `							var	_lastVisible = visible,`
				_gml += _new + `								_lastDepth   = depth,`
				_gml += _new + `								_lastSprite  = sprite_index,`
				_gml += _new + `								_lastMask    = mask_index,`
				_gml += _new + `								_lastSolid   = solid,`
				_gml += _new + `								_lastPersist = persistent;`
				_gml += _new + `								`
				_gml += _new + `							instance_change(Player, false);`
				_gml += _new + `							wep = _wep;`
				_gml += _new + `							instance_change(WepPickup, false);`
				_gml += _new + `							`
				_gml += _new + `							visible      = _lastVisible;`
				_gml += _new + `							depth        = _lastDepth;`
				_gml += _new + `							sprite_index = _lastSprite;`
				_gml += _new + `							mask_index   = _lastMask;`
				_gml += _new + `							solid        = _lastSolid;`
				_gml += _new + `							persistent   = _lastPersist;`
				_gml += _new + `						}`
				_gml += _new + `					}`
				_gml += _new + `					catch(_error){}`
				_gml += _new + `				}`
				_gml += _new + `				else wep = _wep;`
				_gml += _new + `			}`
				_gml += _new + `			else{`
				_gml += _new + `				bwep = _wep;`
				_gml += _new + `			}`
				_gml += _new + `		}`
				_gml += _new + `	}`
				_gml += _new + `}`
				_gml += _new + `return false;`
				
				break;
				
			case "projectile_setup": // Calls custom setup code for the given projectile instances
			
				_gml += `#define ${_scrName}(_inst, _wep, _isMain, _mainX, _mainY, _mainDirection, _mainAccuracy, _mainTeam, _mainCreator)`
				_gml += _new + `if(is_object(_wep) && "${_name}" in _wep){`
				_gml += _new + `	var _wrap = _wep.${_name};`
				_gml += _new + `	`
				                	 // Re-Tag Team:
				_gml += _new + `	if(_isMain){`
				_gml += _new + `		with(_inst){`
				_gml += _new + `			var	_lastTeam  = call(scr.projectile_tag_get_value, _mainTeam, _mainCreator, "${_name}_projectile_setup_team", round(_mainTeam)),`
				_gml += _new + `				_scriptRef = script_ref_create(${_scrName}, _wep, false, _mainX, _mainY, _mainDirection, _mainAccuracy, _lastTeam, _mainCreator),`
				_gml += _new + `				_teamTag   = call(scr.projectile_tag_create, _lastTeam, _mainCreator, _scriptRef, max(1, weapon_get_load(_wrap.wep)));`
				_gml += _new + `				`
				_gml += _new + `			_scriptRef[9] = _teamTag;`
				_gml += _new + `			`
				_gml += _new + `			team = _teamTag;`
				_gml += _new + `		}`
				_gml += _new + `	}`
				_gml += _new + `	`
				                	 // Custom:
				_gml += _new + `	if("${_scrName}" in _wrap.scr_ref){`
				_gml += _new + `		var _wrapScrRefs = _wrap.scr_ref.${_scrName};`
				_gml += _new + `		for(var i = array_length(_wrapScrRefs) - 1; i >= 0; i--){`
				_gml += _new + `			script_ref_call(_wrapScrRefs[i], _inst, _wep, _isMain, _mainX, _mainY, _mainDirection, _mainAccuracy, _mainTeam, _mainCreator);`
				_gml += _new + `			_inst = instances_matching_ne(_inst, "id");`
				_gml += _new + `		}`
				_gml += _new + `	}`
				_gml += _new + `}`
				                
				                 // Reset Team:
				_gml += _new + `else if(_isMain){`
				_gml += _new + `	with(_inst){`
				_gml += _new + `		team = _lastTeam;`
				_gml += _new + `	}`
				_gml += _new + `}`
				
				break;
				
			case "weapon_raw": // Returns the original wrapped weapon 
			
				_gml += `#define ${_scrName}(_wep)`
				_gml += _new + `if(argument_count && is_object(_wep) && "${_name}" in _wep){`
				_gml += _new + `	return _wep.${_name}.wep;`
				_gml += _new + `}`
				_gml += _new + `return mod_current;`
				
				break;
				
			/// Generic Scripts:
			case "weapon_name":
			case "weapon_text":
			case "weapon_swap":
			case "weapon_sprt":
			case "weapon_sprt_hud":
			case "weapon_loadout":
			case "weapon_area":
			case "weapon_type":
			case "weapon_cost":
			case "weapon_rads":
			case "weapon_load":
			case "weapon_auto":
			case "weapon_melee":
			case "weapon_gold":
			case "weapon_laser_sight":
			case "weapon_fire":
			
			//	var _scrCall = "0";
			//	
			//	 // Default Value:
			//	switch(_scrName){
			//		case "weapon_name"        : _scrCall = `(is_string(_wrapWep) ? _wrapWep : ("WEAPON" + string(_wrapWep)))`; break;
			//		case "weapon_text"        : _scrCall = `""`;                                                               break;
			//		case "weapon_sprt"        : _scrCall = `sprErrorGun`;                                                      break;
			//		case "weapon_sprt_hud"    : _scrCall = `weapon_get_sprt(_wep)`;                                            break;
			//		case "weapon_area"        : _scrCall = `-1`;                                                               break;
			//		case "weapon_cost"        : _scrCall = `((weapon_get_type(_wep) == 0) ? 0 : 1)`;                           break;
			//		case "weapon_load"        : _scrCall = `1`;                                                                break;
			//		case "weapon_melee"       : _scrCall = `(weapon_get_type(_wep) == 0)`;                                     break;
			//		case "weapon_laser_sight" : _scrCall = `(weapon_get_type(_wep) == 3)`;                                     break;
			//	}
				
				 // Main Code:
				_gml += `#define ${_scrName}(_wep)`
			//	_gml += _new + `trace_time();`
				_gml += _new + `if(argument_count && is_object(_wep) && "${_name}" in _wep){`
				_gml += _new + `	var	_call    = 0,`
				_gml += _new + `		_wrap    = _wep.${_name},`
				_gml += _new + `		_wrapWep = _wrap.wep;`
				_gml += _new + `		`
			//	_gml += _new + `	if("${_scrName}" not in _wrap.scr_use || _wrap.scr_use.${_scrName}){`
				
				if(_scrName == "weapon_fire"){
					                	 // Player-Specific On-Fire Code:
					_gml += _new + `	if(lq_defget(_wrap, "scr_use_player_fire", true)){` // replace with '_wrap.scr_use.player_fire' if re-added
					_gml += _new + `		var	_wrapHasPlayerFire      = ("player_fire"      in _wrap.scr_ref),`
					_gml += _new + `			_wrapHasProjectileSetup = ("projectile_setup" in _wrap.scr_ref);`
					_gml += _new + `			`
					_gml += _new + `		if(_wrapHasPlayerFire || _wrapHasProjectileSetup){`
					_gml += _new + `			var	_creator = (("creator" in self && instance_is(self, FireCont)) ? creator : self),`
					_gml += _new + `				_at      = {`
					_gml += _new + `					"x"                  : undefined,`
					_gml += _new + `					"y"                  : undefined,`
					_gml += _new + `					"position_distance"  : 0,`
					_gml += _new + `					"position_direction" : undefined,`
					_gml += _new + `					"position_rotation"  : 0,`
					_gml += _new + `					"direction"          : undefined,`
					_gml += _new + `					"direction_rotation" : 0,`
					_gml += _new + `					"accuracy"           : undefined,`
					_gml += _new + `					"wep"                : undefined,`
					_gml += _new + `					"team"               : undefined,`
					_gml += _new + `					"creator"            : _creator`
					_gml += _new + `				};`
					_gml += _new + `				`
					                			 // Setup Projectile Tracking Tag:
					_gml += _new + `			if(_wrapHasProjectileSetup){`
					_gml += _new + `				_at.team = team;`
					_gml += _new + `				if(call(scr.projectile_tag_get_value, team, _creator, "${_name}_projectile_setup_team") == undefined){`
					_gml += _new + `					var _scriptRef = script_ref_create(projectile_setup, _wep, true, x, y, gunangle, accuracy, team, _creator);`
					_gml += _new + `					_at.team = call(scr.projectile_tag_create, team, _creator, _scriptRef, max(1, weapon_get_load(_wrapWep)));`
					_gml += _new + `					call(scr.projectile_tag_set_value, _at.team, _creator, "${_name}_projectile_setup_team", team);`
					_gml += _new + `					_scriptRef[9] = _at.team;`
					_gml += _new + `				}`
					_gml += _new + `			}`
					_gml += _new + `			`
					                			 // Call Scripts:
					_gml += _new + `			if(_wrapHasPlayerFire){`
					_gml += _new + `				var _wrapScrRefs = _wrap.scr_ref.player_fire;`
					_gml += _new + `				for(var i = array_length(_wrapScrRefs) - 1; i >= 0; i--){`
					_gml += _new + `					script_ref_call(_wrapScrRefs[i], _wep, _at);`
					_gml += _new + `				}`
					_gml += _new + `			}`
					_gml += _new + `			`
					                			 // Player-Adjusted Firing:
					_gml += _new + `			if(`
					_gml += _new + `				_wrapHasProjectileSetup`
					_gml += _new + `				|| _at.x                  != undefined`
					_gml += _new + `				|| _at.y                  != undefined`
					_gml += _new + `				|| _at.position_distance  != 0`
					_gml += _new + `				|| _at.direction          != undefined`
					_gml += _new + `				|| _at.direction_rotation != 0`
					_gml += _new + `				|| _at.accuracy           != undefined`
					_gml += _new + `				|| _at.wep                != undefined`
					_gml += _new + `				|| _at.team               != undefined`
					_gml += _new + `				|| _at.creator            != _creator`
					_gml += _new + `			){`
					                				 // Re-Setup Projectile Tracking Tag if Needed:
					_gml += _new + `				if(_wrapHasProjectileSetup){`
					_gml += _new + `					var	_atTeam    = ((_at.team == undefined) ? team : _at.team),`
					_gml += _new + `						_atCreator = _at.creator;`
					_gml += _new + `						`
					_gml += _new + `					if(call(scr.projectile_tag_get_value, _atTeam, _atCreator, "${_name}_projectile_setup_team") == undefined){`
					_gml += _new + `						var _scriptRef = script_ref_create(projectile_setup, _wep, true, x, y, gunangle, accuracy, _atTeam, _atCreator);`
					_gml += _new + `						_at.team = call(scr.projectile_tag_create, _atTeam, _atCreator, _scriptRef, max(1, weapon_get_load(_wrapWep)));`
					_gml += _new + `						call(scr.projectile_tag_set_value, _at.team, _atCreator, "${_name}_projectile_setup_team", _atTeam);`
					_gml += _new + `						_scriptRef[9] = _at.team;`
					_gml += _new + `					}`
					_gml += _new + `				}`
					_gml += _new + `				`
					                				 // Setup Weapon for FireCont:
					_gml += _new + `				if(_at.wep == undefined && !instance_is(self, Player)){`
					_gml += _new + `					_at.wep = _wep;`
					_gml += _new + `				}`
					_gml += _new + `				`
					                				 // Fire:
				//	_gml += _new + `				var _lastWrapScrUsePlayerFire = _wrap.scr_use_player_fire;`
					_gml += _new + `				_wrap.scr_use_player_fire = false;`
					_gml += _new + `				call(scr.pass, other, scr.player_fire_at,`
					_gml += _new + `					{`
					_gml += _new + `						"x"         : _at.x,`
					_gml += _new + `						"y"         : _at.y,`
					_gml += _new + `						"distance"  : _at.position_distance,`
					_gml += _new + `						"direction" : _at.position_direction,`
					_gml += _new + `						"rotation"  : _at.position_rotation`
					_gml += _new + `					},`
					_gml += _new + `					{`
					_gml += _new + `						"direction" : _at.direction,`
					_gml += _new + `						"rotation"  : _at.direction_rotation`
					_gml += _new + `					},`
					_gml += _new + `					_at.accuracy,`
					_gml += _new + `					_at.wep,`
					_gml += _new + `					_at.team,`
					_gml += _new + `					_at.creator,`
					_gml += _new + `					true`
					_gml += _new + `				);`
					_gml += _new + `				_wrap.scr_use_player_fire = true;`
					_gml += _new + `				`
					                				 // Capture New Projectiles:
					_gml += _new + `				if(_wrapHasProjectileSetup){`
					_gml += _new + `					call(scr.ntte_setup);`
					_gml += _new + `				}`
					_gml += _new + `				`
					                				 // Exit Script:
					_gml += _new + `				exit;`
					_gml += _new + `			}`
					_gml += _new + `		}`
					_gml += _new + `	}`
					_gml += _new + `	`
				//	                	 // Apply Projectile Tracking Tag:
				//	_gml += _new + `	if(_wrapHasProjectileSetup){`
				//	_gml += _new + `		var	_team    = team,`
				//	_gml += _new + `			_teamTag = _team,`
				//	_gml += _new + `			_creator = (("creator" in self && instance_is(self, FireCont)) ? creator : self);`
				//	_gml += _new + `			`
				//	_gml += _new + `		if(call(scr.projectile_tag_get_value, _team, _creator, "${_name}_projectile_setup_team") == undefined){`
				//	_gml += _new + `			var _scriptRef = script_ref_create(projectile_setup, _wep, true, x, y, gunangle, accuracy, _team, _creator);`
				//	_gml += _new + `			_teamTag = call(scr.projectile_tag_create, _team, _creator, _scriptRef, max(1, weapon_get_load(_wrapWep)));`
				//	_gml += _new + `			call(scr.projectile_tag_set_value, _teamTag, _creator, "${_name}_projectile_setup_team", _team);`
				//	_gml += _new + `			_scriptRef[9] = _teamTag;`
				//	_gml += _new + `			team          = _teamTag;`
				//	_gml += _new + `		}`
				//	_gml += _new + `	}`
				//	_gml += _new + `	`
				//	                	 // Store Melee Angle:
				//	_gml += _new + `	var _lastWepAngle = wepangle;`
				//	_gml += _new + `	`
				}
				
				                	 // Modded:
				_gml += _new + `	if(is_string(_wrapWep) && mod_script_exists("weapon", _wrapWep, "${_scrName}")){`
				_gml += _new + `		var _swap = wep_swap(true, [true, false], _wep);`
				_gml += _new + `		_call = [_call];`
				_gml += _new + `		if(fork()){`
				_gml += _new + `			_call[0] = mod_script_call("weapon", _wrapWep, "${_scrName}", (_wrap.lwo ? _wep : _wrapWep));`
				_gml += _new + `			exit;`
				_gml += _new + `		}`
				_gml += _new + `		_call = _call[0];`
				_gml += _new + `		if(_swap != false){`
				_gml += _new + `			wep_swap(_swap[0], _swap[1], _wep);`
				_gml += _new + `		}`
				_gml += _new + `	}`
				
				                	 // Normal:
				                	var _weaponGetText = (
			                			(array_find_index(["weapon_loadout", "weapon_fire"], _scrName) >= 0)
			                			? `call(scr.pass, [self, other], scr.weapon_get, "${string_replace(_scrName, "weapon_", "")}", `
			                			: `${string_replace(_scrName, "_", ((_scrName == "weapon_melee") ? "_is_" : "_get_"))}(`
			                		);
				_gml += _new + `	else if(_wrap.lwo){`
				_gml += _new + `		var _lastSubWep = _wep.wep;`
				_gml += _new + `		_wep.wep = _wrapWep;`
				_gml += _new + `		_call = ${_weaponGetText}_wep);`
				_gml += _new + `		_wep.wep = _lastSubWep;`
				_gml += _new + `	}`
				_gml += _new + `	else{`
				_gml += _new + `		_call = ${_weaponGetText}_wrapWep);`
				_gml += _new + `	}`
				
			//	if(_scrName == "weapon_fire"){
			//		_gml += _new + `	`
			//		                	 // Flip Melee Angle:
			//		_gml += _new + `	if(instance_exists(self) && wepangle == _lastWepAngle && weapon_is_melee(_wep)){`
			//		_gml += _new + `		var _lastSubWep = _wep.wep;`
			//		_gml += _new + `		_wep.wep = _wrapWep;`
			//		_gml += _new + `		if(!weapon_is_melee(_wep)){`
			//		_gml += _new + `			wepangle *= -1;`
			//		_gml += _new + `		}`
			//		_gml += _new + `		_wep.wep = _lastSubWep;`
			//		_gml += _new + `	}`
			//	}
				
			//	_gml += _new + `	}`
			//	_gml += _new + `	else _call = ${_scrCall};`
				_gml += _new + `	`
				                	 // Custom:
				_gml += _new + `	if("${_scrName}" in _wrap.scr_ref){`
				_gml += _new + `		var _wrapScrRefs = _wrap.scr_ref.${_scrName};`
				_gml += _new + `		for(var i = array_length(_wrapScrRefs) - 1; i >= 0; i--){`
				_gml += _new + `			_call = script_ref_call(_wrapScrRefs[i], _wep, _call);`
				_gml += _new + `		}`
				_gml += _new + `	}`
				_gml += _new + `	`
				
			//	if(_scrName == "weapon_fire"){
			//		                	 // Projectile Tracking:
			//		_gml += _new + `	if(_wrapHasProjectileSetup){`
			//		                		 // Revert Team:
			//		_gml += _new + `		if(instance_exists(self) && team == _teamTag){`
			//		_gml += _new + `			team = _team;`
			//		_gml += _new + `		}`
			//		_gml += _new + `		`
			//	//	                		 // Track Any New Tags:
			//	//	_gml += _new + `		var	_maxID  = instance_max,`
			//	//	_gml += _new + `			_tagMap = ds_map_create();`
			//	//	_gml += _new + `			`
			//	//	_gml += _new + `		_tagMap[? string(_teamTag)] = _teamTag;`
			//	//	_gml += _new + `		`
			//	//	_gml += _new + `		for(var _inst = _minID; _inst < _maxID; _inst++){`
			//	//	_gml += _new + `			if("team" in _inst){`
			//	//	_gml += _new + `				var _tagKey = string(_inst.team);`
			//	//	_gml += _new + `				if(!ds_map_exists(_tagMap, _tagKey)){`
			//	//	_gml += _new + `					var	_scriptRef   = script_ref_create(projectile_setup, _wep, true, _x, _y, _direction, _accuracy, _inst.team, _creator),`
			//	//	_gml += _new + `						_instTeamTag = call(scr.projectile_tag_create, _inst.team, _creator, _scriptRef, max(1, weapon_get_load(_wrapWep)));`
			//	//	_gml += _new + `						`
			//	//	_gml += _new + `					call(scr.projectile_tag_set_value, _instTeamTag, _creator, "${_name}_projectile_setup_team", _inst.team);`
			//	//	_gml += _new + `					`
			//	//	_gml += _new + `					_tagMap[? _tagKey] = _instTeamTag;`
			//	//	_gml += _new + `					_scriptRef[9]      = _instTeamTag;`
			//	//	_gml += _new + `					_inst.team         = _instTeamTag;`
			//	//	_gml += _new + `				}`
			//	//	_gml += _new + `				else{`
			//	//	_gml += _new + `					trace("??");`
			//	//	_gml += _new + `					_inst.team = _tagMap[? _tagKey];`
			//	//	_gml += _new + `				}`
			//	//	_gml += _new + `			}`
			//	//	_gml += _new + `		}`
			//	//	_gml += _new + `		`
			//	//	_gml += _new + `		ds_map_destroy(_tagMap);`
			//	//	_gml += _new + `		`
			//		                		 // Capture New Projectiles:
			//		_gml += _new + `		call(scr.ntte_setup);`
			//		_gml += _new + `	}`
			//		_gml += _new + `	`
			//	}
				
			//	_gml += _new + `	trace_time("${_scrName}");`
				_gml += _new + `	return _call;`
				_gml += _new + `}`
			//	_gml += _new + `trace_time("${_scrName}");`
				
				 // Fixes:
				switch(_scrName){
					case "weapon_text" : _gml += _new + `return "";`; break;
					case "weapon_area" : _gml += _new + `return -1;`; break;
				}
				
				break;
				
			/// Slot Scripts:
			case "weapon_reloaded":
			case "step":
			
				_gml += `#define ${_scrName}(_primary)`
			//	_gml += _new + `trace_time();`
				_gml += _new + `var _wep = (_primary ? wep : bwep);`
				_gml += _new + `if(is_object(_wep) && "${_name}" in _wep){`
				_gml += _new + `	var	_wrap    = _wep.${_name},`
				_gml += _new + `		_wrapWep = _wrap.wep;`
				_gml += _new + `		`
			//	_gml += _new + `	if("${_scrName}" not in _wrap.scr_use || _wrap.scr_use.${_scrName}){`
				                	 // Modded:
				_gml += _new + `	if(is_string(_wrapWep) && mod_script_exists("weapon", _wrapWep, "${_scrName}")){`
				_gml += _new + `		var _swap = wep_swap(true, [_primary], _wep);`
				_gml += _new + `		if(fork()){`
				_gml += _new + `			mod_script_call("weapon", _wrapWep, "${_scrName}", _primary);`
				_gml += _new + `			exit;`
				_gml += _new + `		}`
				_gml += _new + `		if(_swap != false){`
				_gml += _new + `			wep_swap(_swap[0], _swap[1], _wep);`
				_gml += _new + `		}`
				_gml += _new + `	}`
				_gml += _new + `	`
				                	 // Normal:
				switch(_scrName){
					
					case "weapon_reloaded":
					
						_gml += _new + `	else{`
						                		 // Melee:
						_gml += _new + `		if(weapon_is_melee(_wrapWep)){`
						_gml += _new + `			sound_play(sndMeleeFlip);`
						_gml += _new + `		}`
						_gml += _new + `		`
						                		 // Shell / Bolt:
						_gml += _new + `		switch(weapon_get_type(_wrapWep)){`
						_gml += _new + `			`
						_gml += _new + `			case 2:`
						_gml += _new + `			`
						_gml += _new + `				sound_play(sndShotReload);`
						_gml += _new + `				`
						_gml += _new + `				 // Casings:`
						_gml += _new + `				var _num = weapon_get_cost(_wrapWep) * (_primary ? interfacepop : binterfacepop);`
						_gml += _new + `				if(_num > 0) repeat(_num){`
						_gml += _new + `					with(instance_create(x, y, Shell)){`
						_gml += _new + `						sprite_index = (`
						_gml += _new + `							(skill_get(mut_shotgun_shoulders) > 0)`
						_gml += _new + `							? sprShotShellBig`
						_gml += _new + `							: sprShotShell`
						_gml += _new + `						);`
						_gml += _new + `						motion_add(`
						_gml += _new + `							other.gunangle + (other.right * 100) + random_range(-20, 20),`
						_gml += _new + `							random_range(2, 4)`
						_gml += _new + `						);`
						_gml += _new + `					}`
						_gml += _new + `				}`
						_gml += _new + `				`
						                				 // Weapon Kick:
						_gml += _new + `				var _kick = ((_wrapWep == wep_double_shotgun) ? -2 : -1);`
						_gml += _new + `				if(_primary){`
						_gml += _new + `					wkick  = _kick;`
						_gml += _new + `				}`
						_gml += _new + `				else{`
						_gml += _new + `					bwkick = _kick;`
						_gml += _new + `				}`
						_gml += _new + `				`
						_gml += _new + `				break;`
						_gml += _new + `				`
						_gml += _new + `			case 3:`
						_gml += _new + `			`
						_gml += _new + `				sound_play(sndCrossReload);`
						_gml += _new + `				`
						_gml += _new + `				break;`
						_gml += _new + `				`
						_gml += _new + `		}`
						_gml += _new + `		`
						                		 // Grenade:
						_gml += _new + `		switch(_wrapWep){`
						_gml += _new + `			case wep_grenade_launcher:`
						_gml += _new + `			case wep_sticky_launcher:`
						_gml += _new + `			case wep_golden_grenade_launcher:`
						_gml += _new + `			case wep_hyper_launcher:`
						_gml += _new + `			case wep_toxic_launcher:`
						_gml += _new + `			case wep_cluster_launcher:`
						_gml += _new + `			case wep_grenade_shotgun:`
						_gml += _new + `			case wep_grenade_rifle:`
						_gml += _new + `			case wep_auto_grenade_shotgun:`
						_gml += _new + `			case wep_ultra_grenade_launcher:`
						_gml += _new + `			case wep_heavy_grenade_launcher:`
						_gml += _new + `				sound_play(sndNadeReload);`
						_gml += _new + `				break;`
						_gml += _new + `		}`
						_gml += _new + `		`
						                		 // Energy:
						_gml += _new + `		var _wepName = weapon_get_name(_wrapWep);`
						_gml += _new + `		if(string_pos("PLASMA", _wepName) == 1){`
						_gml += _new + `			sound_play(`
						_gml += _new + `				(skill_get(mut_laser_brain) > 0)`
						_gml += _new + `				? sndPlasmaReloadUpg`
						_gml += _new + `				: sndPlasmaReload`
						_gml += _new + `			);`
						_gml += _new + `		}`
						_gml += _new + `		else if(string_pos("LIGHTNING", _wepName) == 1){`
						_gml += _new + `			sound_play(sndLightningReload);`
						_gml += _new + `		}`
						_gml += _new + `	}`
						_gml += _new + `	`
						
						break;
						
					case "step":
					
						_gml += _new + `	else switch(_wrapWep){`
						_gml += _new + `		`
						_gml += _new + `		case wep_blood_launcher:`
						_gml += _new + `		case wep_blood_cannon:`
						_gml += _new + `		`
						_gml += _new + `			if(infammo == 0){`
						_gml += _new + `				if(`
						_gml += _new + `					_primary`
						_gml += _new + `					? (drawempty  == 30 && canfire && button_pressed(index, "fire"))`
						_gml += _new + `					: (drawemptyb == 30 && canspec && button_pressed(index, "spec") && race == "steroids")`
						_gml += _new + `				){`
						_gml += _new + `					var	_type = weapon_get_type(_wep),`
						_gml += _new + `						_cost = weapon_get_cost(_wep),`
						_gml += _new + `						_ammo = ammo[_type],`
						_gml += _new + `						_amax = typ_amax[_type];`
						_gml += _new + `						`
						_gml += _new + `					if(_ammo < _cost && _cost < _amax){`
						_gml += _new + `						var _add = min(_cost, _amax - _ammo);`
						_gml += _new + `						ammo[_type] += _add;`
						_gml += _new + `						`
						                						 // Damage:
						_gml += _new + `						lasthit = [weapon_get_sprt(_wep), weapon_get_name(_wep)];`
						_gml += _new + `						projectile_hit_raw(self, floor(sqrt(_add)), true);`
						_gml += _new + `						sound_play_hit(sndBloodHurt, 0.1);`
						_gml += _new + `						sleep(40);`
						_gml += _new + `						`
						                						 // Insta-Use Ammo:
						_gml += _new + `						if(_primary && can_shoot == true){`
						_gml += _new + `							clicked = true;`
						_gml += _new + `						}`
						_gml += _new + `					}`
						_gml += _new + `				}`
						_gml += _new + `			}`
						_gml += _new + `			`
						_gml += _new + `			break;`
						_gml += _new + `			`
						_gml += _new + `	}`
						_gml += _new + `	`
						
						break;
						
				}
			//	_gml += _new + `	}`
			//	_gml += _new + `	`
				                	 // Custom:
				_gml += _new + `	if("${_scrName}" in _wrap.scr_ref){`
				_gml += _new + `		var _wrapScrRefs = _wrap.scr_ref.${_scrName};`
				_gml += _new + `		for(var i = array_length(_wrapScrRefs) - 1; i >= 0; i--){`
				_gml += _new + `			script_ref_call(_wrapScrRefs[i], _primary);`
				_gml += _new + `		}`
				_gml += _new + `	}`
			//	_gml += _new + `	trace_time("${_scrName}");`
				_gml += _new + `}`
			//	_gml += _new + `trace_time("${_scrName}");`
				
				break;
				
			default: /// Custom Scripts
			
				_gml += `#define ${_scrName}`
			//	_gml += _new + `trace_time();`
				_gml += _new + `var	_wep = undefined,`
				_gml += _new + `	_ref = script_ref_create(${_scrName});`
				_gml += _new + `	`
				                 // Compile Args:
				_gml += _new + `for(var i = 0; i < argument_count; i++){`
				_gml += _new + `	var _arg = argument[i];`
				_gml += _new + `	if(_wep == undefined && (is_object(_arg) ? wep_base(_arg) : _arg) == mod_current){`
				_gml += _new + `		_wep = _arg;`
				_gml += _new + `	}`
				_gml += _new + `	array_push(_ref, _arg);`
				_gml += _new + `}`
				_gml += _new + ``
				                 // Weapon Slot Check:
				_gml += _new + `if(_wep == undefined){`
				_gml += _new + `	var	_primary   = array_find_index(_ref, true),`
				_gml += _new + `		_secondary = array_find_index(_ref, false);`
				_gml += _new + `		`
				_gml += _new + `	if(_primary <= _secondary && "wep" in self && wep_raw == mod_current){`
				_gml += _new + `		_wep = wep;`
				_gml += _new + `	}`
				_gml += _new + `	else if(_secondary <= _primary && "bwep" in self && bwep_raw == mod_current){`
				_gml += _new + `		_wep = bwep;`
				_gml += _new + `	}`
				_gml += _new + `}`
				_gml += _new + ``
				                 // Call Script:
				_gml += _new + `if(is_object(_wep) && "${_name}" in _wep){`
				_gml += _new + `	var	_call    = 0,`
				_gml += _new + `		_wrap    = _wep.${_name},`
				_gml += _new + `		_wrapWep = _wrap.wep`
				_gml += _new + `		`
				                	 // Normal:
			//	_gml += _new + `	if("${_scrName}" not in _wrap.scr_use || _wrap.scr_use.${_scrName}){`
				_gml += _new + `	if(is_string(_wrapWep) && mod_script_exists(_ref[0], _wrapWep, _ref[2])){`
				_gml += _new + `		var _callRef = _ref;`
				_gml += _new + `		`
				                		 // Replace Wep Arguments:
				_gml += _new + `		_callRef[1] = _wrapWep;`
				_gml += _new + `		if(!_wrap.lwo){`
				_gml += _new + `			_callRef = array_clone(_callRef);`
				_gml += _new + `			for(`
				_gml += _new + `				var i = array_find_last_index(_callRef, _wep);`
				_gml += _new + `				i > 2;`
				_gml += _new + `				i = array_find_last_index_ext(_callRef, _wep, i)`
				_gml += _new + `			){`
				_gml += _new + `				_callRef[i] = _wrapWep;`
				_gml += _new + `			}`
				_gml += _new + `		}`
				_gml += _new + `		`
				                		 // Call Script:
				_gml += _new + `		var _swap = wep_swap(true, [true, false], _wep);`
				_gml += _new + `		_call = [_call];`
				_gml += _new + `		if(fork()){`
				_gml += _new + `			_call[0] = script_ref_call(_callRef);`
				_gml += _new + `			exit;`
				_gml += _new + `		}`
				_gml += _new + `		_call = _call[0];`
				_gml += _new + `		if(_swap != false){`
				_gml += _new + `			wep_swap(_swap[0], _swap[1], _wep);`
				_gml += _new + `		}`
				_gml += _new + `	}`
			//	_gml += _new + `	}`
				_gml += _new + `	`
				                	 // Custom:
				_gml += _new + `	if("${_scrName}" in _wrap.scr_ref){`
				_gml += _new + `		var _wrapScrRefs = _wrap.scr_ref.${_scrName};`
				_gml += _new + `		for(var i = array_length(_wrapScrRefs) - 1; i >= 0; i--){`
				_gml += _new + `			var _wrapScrRef = array_clone(_wrapScrRefs[i]);`
				_gml += _new + `			array_copy(_wrapScrRef, array_length(_wrapScrRef), _ref, 3, array_length(_ref) - 3);`
				_gml += _new + `			_call = script_ref_call(_wrapScrRef, _call);`
				_gml += _new + `		}`
				_gml += _new + `	}`
				_gml += _new + `	`
			//	_gml += _new + `	trace_time("${_scrName}");`
				_gml += _new + `	return _call;`
				_gml += _new + `}`
			//	_gml += _new + `trace_time("${_scrName}");`
				
		}
	}
	
	string_save(_gml, _path);
	
#define wrapper_script_search(_path, _scrList, _scrAvoid, _triesMax, _load)
	/*
		Reads weapon files and adds any custom "weapon_x" scripts to the given ds_list
		Searches the given path and all of its subfolders until it reaches a dead end
		
		Args:
			path     - The path to search
			scrList  - A ds_list for storing script names
			scrAvoid - An array of script names to avoid storing
			triesMax - How many frames to wait before determining that the current directory is empty
			load     - An array containing an integer to help externally determine when the search is finished
	*/
	
	var	_find       = [],
		_tries      = _triesMax,
		_scrListMax = 85; // Temporary just-in-case check until 9945(?)
		
	if(fork()){
		 // Reduce Game Freeze:
		while(_load[0] > 250){
			wait 0;
		}
		
		 // Scan the Current Directory:
		if(ds_list_size(_scrList) < _scrListMax){
			_load[@0]++;
			file_find_all(_path, _find, 0);
			while(!array_length(_find) && _tries-- > 0){
				wait 0;
			}
			_load[@0]--;
			
			 // Scan Folders:
			with(_find){
				if(is_dir && string_pos(`../../data/${mod_current}.mod`, path) != 1){
					wrapper_script_search(path, _scrList, _scrAvoid, _triesMax, _load);
				}
			}
			
			 // Read Weapon Files for Scripts:
			with(_find){
				if(ext == ".gml" || ext == ".txt"){
					var _nameLength = string_length(name);
					if(
						string_copy(name, _nameLength -  7, 4) == ".wep" ||
						string_copy(name, _nameLength - 10, 7) == ".weapon"
					){
						if(fork()){
							_load[@0]++;
							var _text = file_read(path);
							if(!is_undefined(_text)){
								var i = 0;
								with(string_split(_text, "#define")){
									if(i++ > 0){
										var	_scrText = string_ltrim(self),
											_scrName = "weapon_";
											
										if(string_pos(_scrName, _scrText) == 1){
											var _scrTextLength = string_length(_scrText);
											
											 // Read Script Name:
											for(var j = string_length(_scrName) + 1; j <= _scrTextLength; j++){
												var _char = string_char_at(_scrText, j);
												if(string_lettersdigits(_char) == "" && _char != "_"){
													break;
												}
												_scrName += _char;
											}
											
											 // Add Script Name:
											if(ds_list_find_index(_scrList, _scrName) < 0){
												if(array_find_index(_scrAvoid, _scrName) < 0){
													if(ds_list_size(_scrList) < _scrListMax){
														ds_list_add(_scrList, _scrName);
													}
												}
											}
										}
									}
								}
							}
							_load[@0]--;
							exit;
						}
					}
				}
			}
		}
		
		exit;
	}
	
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
							_current = string_repeat(" ", real(_char)) + _current;
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
	
#define cleanup
	 // FAILED:
	if(global.load.type == load_type_updating){
		if(global.load.open || global.load.open_scale > 0){
			global.load.type = load_type_failed;
		}
	}
	if(global.load.type == load_type_failed){
		string_save("", path_download + path_version);
		file_delete(path_download + path_loader);
		mod_loadtext(path_main_load);
	}
	
	 // Help Out New teloader:
	else if(global.load.type == load_type_updating && mod_sideload()){
		mod_loadtext(path_main_allow);
	}
	
	 // Unload Changelogs:
	for(var i = 0; i < changelog_size(); i++){
		changelog_delete(i);
	}