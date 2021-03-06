#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Mod Lists:
	ntte_mods = mod_variable_get("mod", "teassets", "mods");
	
	 // Bind Events:
	script_bind(CustomDraw, draw_menu, object_get_depth(Menu) - 1, true);
	global.loadout_bind = ds_map_create();
	global.loadout_bind[? "behind" ] = script_bind(CustomDraw, draw_loadout_behind,  object_get_depth(Loadout) + 1,      false);
	global.loadout_bind[? "above"  ] = script_bind(CustomDraw, draw_loadout_above,   object_get_depth(Loadout) - 1,      false);
	global.loadout_bind[? "crown"  ] = script_bind(CustomDraw, draw_loadout_crown,   object_get_depth(LoadoutCrown) - 1, false);
	global.loadout_bind[? "weapon" ] = script_bind(CustomDraw, draw_loadout_weapon,  object_get_depth(LoadoutWep) - 1,   false);
	global.loadout_bind[? "tooltip"] = script_bind(CustomDraw, draw_loadout_tooltip, -100000,                            false);
	
	 // Menu Layout:
	NTTEMenu = {
		"open"			: false,
		"slct"			: array_create(maxp, menu_base),
		"pop"			: array_create(maxp, 0),
		"splat"			: 0,
		"splat_blink"	: 0,
		"splat_options"	: 0,
		
		"list" : {
			"options" : {
				"x"    : 0,
				"y"    : -64,
				"slct" : array_create(maxp, -1),
				"list" : [
					
					{	name : "Use Shaders",
						type : opt_toggle,
						text : "Used for certain visuals#@sShaders may cause the game# to @rcrash @son certain systems!",
						save : "option:shaders",
						sync : false
						},
						
					{	name : "Reminders",
						type : opt_toggle,
						text : "@sRemind you to enable#@wboss intros @s& @wmusic",
						save : "option:reminders"
						},
						
					{	name : "NTTE Intros",
						type : opt_toggle,
						pick : ["OFF", "ON", "AUTO"],
						text : "@sSet @wAUTO @sto obey the#@wboss intros @soption",
						save : "option:intros"
						},
						
					{	name : "NTTE Outlines :",
						type : opt_title,
						text : "@sSet @wAUTO @sto#obey @w/outlines"
						},
						{	name : "Pets",
							type : opt_toggle,
							pick : ["OFF", "ON", "AUTO"],
							save : "option:outline:pets",
							sync : false
							},
						{	name : "Charm",
							type : opt_toggle,
							pick : ["OFF", "ON", "AUTO"],
							save : "option:outline:charm",
							sync : false
							},
							
					{	name : "Visual Quality :",
						type : opt_title,
						text : "@sReduce to improve#@wperformance"
						},
						{	name : "Main",
							type : opt_slider,
							text : "Obvious @svisuals",
							save : "option:quality:main",
							sync : false
							},
						{	name : "Minor",
							type : opt_slider,
							text : "@wLesser @svisuals",
							save : "option:quality:minor",
							sync : false
							}
							
				]
			},
			
			"stats" : {
				"slct" : array_create(maxp, 0),
				"list" : {
					"mutants" : {
						"x"    : 56,
						"y"    : -48,
						"slct" : array_create(maxp, 0),
						"list" : {/*Filled in Later*/}
					},
					
					"pets" : {
						"x"    : 56,
						"y"    : -16,
						"slct" : array_create(maxp, ""),
						"list" : [ // Pets that show up by default
							"Scorpion"   + ".petlib.mod",
							"Parrot"     + ".petlib.mod",
							"Slaughter"  + ".petlib.mod",
							"CoolGuy"    + ".petlib.mod",
							"Salamander" + ".petlib.mod",
							"Mimic"      + ".petlib.mod",
							"Octo"       + ".petlib.mod",
							"Spider"     + ".petlib.mod",
							"Prism"      + ".petlib.mod",
							"Orchid"     + ".petlib.mod",
							"Weapon"     + ".petlib.mod",
							"Twins"      + ".petlib.mod",
							"Cuz"        + ".petlib.mod"
						]
					},
					
					"unlocks" : {
						"slct" : array_create(maxp, 0),
						"list" : [
							{	name : "UNLOCKS",
								list : ["coast", "oasis", "trench", "lair", "red", "crown"]
							},
							{	name : "OTHER",
								list : [
									["Time",  "time", stat_time],
									["Bones", "bone", stat_base]
								]
							}
						]
					}
				}
			},
			
			"credits" : {
				"x"    : 0,
				"y"    : -79,
				"slct" : array_create(maxp, false),
				"list" : [
					{	name : "Yokin",
						role : [[cred_coder, "Lead Programmer"]],
						link : [[cred_twitter, "Yokinman"], [cred_discord, "Yokin\#1322"]]
						},
					{	name : "THX",
						role : [[cred_artist, "Sprite Artist"]],
						link : [[cred_twitter, "thxsprites"], [cred_discord, "THX\#0011"]]
						},
					{	name : "smash brothers",
						role : [[cred_artist, "Sprite Artist"], [cred_coder, "Programmer"]],
						link : [[cred_twitter, "attfooy"], [cred_discord, "smash brothers\#5026"]]
						},
					{	name : "peas",
						role : [[cred_artist, "Sprite Artist"]],
						link : [[cred_twitter, "realestpeas"], [cred_discord, "peas\#8304"]]
						},
					{	name : "jsburg",
						role : [[cred_coder, "Programmer?"]],
						link : [[cred_itchio, "jsburg"], [cred_discord, "Jsburg\#1045"]]
						},
					{	name : "karmelyth",
						role : [[cred_artist, "Weapon Sprites"], [cred_coder, "Weapon Programming"]],
						link : [[cred_twitter, "karmelyth"], [cred_discord, "Karmelyth\#7168"]]
						},
					{	name : "Mista Jub",
						role : [[cred_music, "Music"]],
						link : [[cred_twitter, "JDubbsishere"], [cred_soundcloud, "jdubmmusic"], [cred_discord, "Mista Jub\#8521"]]
						},
					{	name : "Wildebee", // formerly BioOnPc
						role : [[cred_music, "Sound Design"], [cred_coder, "Programmer"], "Trailers"],
						link : [[cred_twitter, "Wilde_bee"], [cred_discord, "Wildebee\#6521"]]
						},
					{	name : "Special Thanks",
						role : [[cred_yellow, "blaac"], "Bub", "Emffles", "minichibis"],
						link : [[cred_twitter + cred_yellow, "blaac_"], [cred_twitter, "Bubonto"], [cred_twitter, "EmfflesTWO"], [cred_twitter, "minichibisart"]]
						}
				]
			}
		}
	}
	
	 // Menu Defaulterize:
	for(var i = 0; i < lq_size(MenuList); i++){
		var o = lq_get_value(MenuList, i);
		if("slct" in o && array_length(o.slct) > 0){
			if("slct_default" not in o){
				o.slct_default = o.slct[0];
			}
		}
	}
	with(MenuList.options.list){
		if("name" not in self) name = "";
		if("type" not in self) type = opt_title;
		if("pick" not in self){
			switch(type){
				case opt_toggle : pick = ["OFF", "ON"]; break;
				case opt_slider : pick = [0, 1];        break;
				default         : pick = [];            break;
			}
		}
		if("save"    not in self) save = "";
		if("sync"    not in self) sync = true;
		if("splat"   not in self) splat = 0;
		if("clicked" not in self) clicked = array_create(maxp, false);
	}
	with(MenuList.credits.list){
		if("name" not in self) name = "";
		if("role" not in self) role = [];
		if("link" not in self) link = [];
		
		 // Role Defaulterize:
		if(!is_array(role)) role = [role];
		for(var i = 0; i < array_length(role); i++){
			if(!is_array(role[i])) role[i] = [role[i]];
		}
		
		 // Link Defaulterize:
		if(!is_array(link)) link = [link];
		for(var i = 0; i < array_length(link); i++){
			if(!is_array(link[i])) link[i] = [link[i]];
		}
		if(array_length(link) >= 4){
			with(link){
				for(var i = 0; i < array_length(self); i++){
					self[@i] = string_replace(self[i], "Twitter: ", "@@");
				}
			}
		}
	}
	
	 // Race Stats:
	if(fork()){
		while(mod_exists("mod", "teloader")){
			wait 0;
		}
		with(ntte_mods.race){
			var	_race = self,
				_path = "race:" + _race + ":",
				_stat = [
					{	name : "",
						list : [
							["Kills",  _path + "kill", stat_base],
							["Loops",  _path + "loop", stat_base],
							["Runs",   _path + "runs", stat_base],
							["Deaths", _path + "lost", stat_base],
							["Wins",   _path + "wins", stat_base],
							["Time",   _path + "time", stat_time]
							]
						},
					{	name : "Best Run",
						list : [
							["Area",  _path + "best:area", stat_area],
							["Kills", _path + "best:kill", stat_base]
							]
						}
				];
				
			switch(_race){
				case "parrot":
					array_push(_stat[0].list, ["Charmed", _path + "spec", stat_base]);
					break;
			}
			
			lq_set(MenuList.stats.list.mutants.list, _race, _stat);
		}
		exit;
	}
	
	 // Loadout Crown System:
	crownLoadout = {
		compare : [],
		race    : {},
		camp    : crwn_none
	};
	global.clock_fix = false;
	if(instance_exists(LoadoutCrown)){
		with(loadbutton) instance_destroy();
		with(Loadout) selected = false;
	}
	
	 // Loadout Weapon System:
	wepLoadout = [
		{ name: "",     inst: noone, hover: false, alarm0: -1, addy: 0, overy: 0, dix: -0.00001, diy: 0 },
		{ name: "main", inst: noone, hover: false, alarm0: -1, addy: 0, overy: 0, dix: -1,       diy: 0 }
	];
	
	 // Mouse:
	global.mouse_x_previous = array_create(maxp, 0);
	global.mouse_y_previous = array_create(maxp, 0);
	
	 // Menu Command Helper:
	chat_comp_add("ntte", "manually opens NT:TE's menu");
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
	 // Remove Chat Command Helper:
	chat_comp_remove("ntte");
	
	 // Fix Options:
	if(MenuOpen){
		with(Menu) mode = 0;
		sound_volume(sndMenuCharSelect, 1);
	}
	
	 // Reset Clock Parts:
	if(global.clock_fix){
		sprite_restore(sprClockParts);
	}
	
	 // Destroy Inactive LoadoutWeps:
	with(wepLoadout){
		with(inst) instance_destroy();
	}
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro ntte_mods global.mods

#macro NTTEMenu         global.menu
#macro MenuOpen         NTTEMenu.open
#macro MenuSlct         NTTEMenu.slct
#macro MenuPop          NTTEMenu.pop
#macro MenuList         NTTEMenu.list
#macro MenuSplat        NTTEMenu.splat
#macro MenuSplatBlink   NTTEMenu.splat_blink
#macro MenuSplatOptions NTTEMenu.splat_options

#macro menu_options 0
#macro menu_stats   1
#macro menu_credits 2
#macro menu_base    menu_options

#macro opt_title  -1
#macro opt_toggle  0
#macro opt_slider  1

#macro stat_base    0
#macro stat_time    1
#macro stat_area    2
#macro stat_display 3

#macro cred_artist     `@(color:${make_color_rgb(30, 160, 240)})`
#macro cred_coder      `@(color:${make_color_rgb(250, 170, 0)})`
#macro cred_music      `@(color:${make_color_rgb(255, 60, 0)})`
#macro cred_twitter    cred_artist + "Twitter: @w"
#macro cred_itchio     cred_coder  + "Itch.io: @w"
#macro cred_soundcloud cred_music  + "Soundcloud: @w"
#macro cred_discord    `@(color:${make_color_rgb(160, 70, 200)})Discord: @w`
#macro cred_yellow     "@y"

#macro loadoutPlayer (player_is_active(player_find_local_nonsync()) ? player_find_local_nonsync() : 0)

#macro crownLoadout global.loadout_crown
#macro crownCompare crownLoadout.compare
#macro crownRace    crownLoadout.race
#macro crownCamp    crownLoadout.camp
#macro crownIconW   28
#macro crownIconH   28
#macro crownPath    "crownCompare/"
#macro crownPathD   ""
#macro crownPathA   "A"
#macro crownPathB   "B"

#macro wepLoadout global.loadout_wep
#macro wepIconW   48
#macro wepIconH   48

#define chat_command(_cmd, _arg, _ind)
	if(_cmd == "ntte" || _cmd == "NTTE"){
		if(_cmd == "NTTE" || instance_exists(Menu) || instance_exists(BackMainMenu)){
			NTTEMenu.open = !NTTEMenu.open;
			
			 // Paused:
			if(instance_exists(BackMainMenu)){
				 // Clear Options:
				if(NTTEMenu.open){
					with([OptionMenuButton, AudioMenuButton, VisualsMenuButton, GameMenuButton, ControlMenuButton]){
						with(self){
							instance_destroy();
						}
					}
				}
				
				 // Unpause:
				else with(UberCont){
					with(self){
						event_perform(ev_alarm, 2);
					}
				}
			}
		}
		return true;
	}
	
#define game_start
	 // Reset Haste Hands:
	if(global.clock_fix){
		global.clock_fix = false;
		sprite_restore(sprClockParts);
	}
	
	 // Special Loadout Crown Selected:
	var	_p           = loadoutPlayer,
		_crown       = lq_get(crownRace, player_get_race_fix(_p)),
		_crownPoints = GameCont.crownpoints;
		
	if(!is_undefined(_crown)){
		if(_crown.custom.slct != -1 && crown_current == _crown.slct && _crown.custom.slct != _crown.slct){
			switch(_crown.custom.slct){
				case crwn_random:
					 // Get Unlocked Crowns:
					var	_listLocked = [],
						_list = [];
						
					with(_crown.icon) if(locked){
						array_push(_listLocked, crwn);
					}
					for(var i = crwn_death; i <= crwn_protection; i++){
						if(array_find_index(_listLocked, i) < 0) array_push(_list, i);
					}
					
					 // Add Modded Crowns:
					var _scrt = "crown_menu_avail";
					with(mod_get_names("crown")){
						if(!mod_script_exists("crown", self, _scrt) || mod_script_call_nc("crown", self, _scrt)){
							array_push(_list, self);
						}
					}
					
					 // Pick Random Crown:
					var _m = ((array_length(_list) > 0) ? _list[irandom(array_length(_list) - 1)] : crwn_none);
					if(_m != crown_current){
						crown_current = _m;
						
						 // Destiny Fix:
						if(crown_current == crwn_destiny){
							GameCont.skillpoints--;
						}
					}
					break;
					
				default:
					crown_current = _crown.custom.slct;
			}
			
			 // Death Fix:
			if(_crown.slct == crwn_death){
				with(Player) my_health = maxhealth;
			}
		}
	}
	GameCont.crownpoints = _crownPoints;
	
#define ntte_end_step
	var _visible = false;
	
	 // NTTE Character Selection Stuff:
	if(instance_exists(Menu)){
		 // Campfire Crown Boy:
		var _inst = instances_matching(Menu, "ntte_campcrown_check", null);
		if(array_length(_inst)) with(_inst){
			ntte_campcrown_check = (crownCamp != crwn_none);
			if(ntte_campcrown_check){
				var _inst = instance_create(0, 0, Crown);
				with(_inst){
					alarm0 = -1;
					with(self){
						event_perform(ev_alarm, 0);
					}
					
					 // Place by Last Played Character:
					for(var i = 0; i < maxp; i++){
						if(player_is_active(i)){
							with(array_combine(
								instances_matching(CampChar, "num", player_get_race_id(i)),
								instances_matching(CampChar, "race", player_get_race(i))
							)){
								other.x = x + (random_range(12, 24) * choose(-1, 1));
								other.y = y + orandom(8);
							}
							break;
						}
					}
					
					 // Visual Setup:
					var _crown = crownCamp;
					if(is_string(_crown)){
						mod_script_call("crown", _crown, "crown_object");
					}
					else if(is_real(_crown)){
						spr_idle = asset_get_index(`sprCrown${_crown}Idle`);
						spr_walk = asset_get_index(`sprCrown${_crown}Walk`);
					}
					depth = -2;
				}
				
				 // Delete:
				if(fork()){
					wait 5;
					with(instances_matching_ne(Crown, "id", _inst)){
						instance_destroy();
					}
					exit;
				}
			}
		}
		
		 // LoadoutSkin Offset:
		if(instance_exists(LoadoutSkin)){
			var _inst = instances_matching(LoadoutSkin, "ntte_crown_xoffset", null);
			if(array_length(_inst)) with(_inst){
				ntte_crown_xoffset = -22;
				xstart += ntte_crown_xoffset;
			}
		}
		
		 // Custom Loadout Weapons:
		if(instance_exists(LoadoutWep)){
			 // Create Inactive LoadoutWeps:
			with(wepLoadout){
				if(!instance_exists(inst)){
					if(name == "" || unlock_get(`loadout:wep:${player_get_race_fix(loadoutPlayer)}:${name}`) != wep_none){
						inst   = instance_create(0, 0, FloorMaker);
						alarm0 = 2;
						overy  = 0;
						addy   = 2;
						
						 // Destroy FloorMaker Things:
						with(instances_matching_gt(GameObject, "id", inst)){
							instance_delete(self);
						}
						
						 // Become LoadoutWep:
						with(inst){
							dix = other.dix;
							instance_change(LoadoutWep, true);
							other.alarm0 = alarm_get(0);
							alarm_set(0, -1);
						}
					}
				}
			}
			
			 // Loadout Wep Selection:
			with(wepLoadout){
				hover = false;
				with(other){
					for(var i = 0; i < maxp; i++){
						if(player_is_active(i) && position_meeting(mouse_x[i], mouse_y[i], other.inst)){
							other.hover = true;
							break;
						}
					}
				}
			}
			for(var i = 0; i < maxp; i++){
				if(player_is_active(i) && button_pressed(i, "fire")){
					if(position_meeting(mouse_x[i], mouse_y[i], LoadoutWep)){
						var	_race     = player_get_race_fix(i),
							_slctPath = `loadout:wep:${_race}`,
							_slctSnd  = sndMenuGoldwep,
							_slct     = "";
							
						with(wepLoadout) if(hover){
							_slct = name;
							if(_slct == ""){
								switch(_race){
									case "venuz"   : _slctSnd = sndMenuGoldwep;  break;
									case "chicken" : _slctSnd = sndMenuSword;    break;
									default        : _slctSnd = sndMenuRevolver; break;
								}
							}
							break;
						}
						
						 // Selected:
						if(_slct != save_get(_slctPath, "")){
							save_set(_slctPath, _slct);
							sound_play(_slctSnd);
						}
					}
				}
			}
		}
		
		 // Initialize Crown Selection:
		var _mods = mod_get_names("race");
		for(var i = 0; i < 17 + array_length(_mods); i++){
			var _race = ((i < 17) ? race_get_name(i) : _mods[i - 17]);
			if(_race not in crownRace){
				lq_set(crownRace, _race, {
					"icon"   : [],
					"slct"   : crwn_none,
					"custom" : { "icon" : [], "slct" : -1 }
				});
			}
		}
		
		 // Loadout Drawing Visibility:
		var _players = 0;
		for(var i = 0; i < maxp; i++){
			_players += player_is_active(i);
		}
		if(_players <= 1){
			_visible = true;
		}
	}
	
	 // Remember Last Crown:
	else crownCamp = crown_current;
	
	 // Loadout Drawing Visibility:
	with(ds_map_values(global.loadout_bind)){
		if(instance_exists(id)){
			id.visible = _visible;
		}
	}
	if(_visible && instance_exists(Loadout)){
		with(global.loadout_bind[? "behind"].id) depth = Loadout.depth + 1;
		with(global.loadout_bind[? "above" ].id) depth = Loadout.depth - 1;
	}
	
#define draw_gui_end
	 // Save Previous Mouse Position:
	for(var i = 0; i < maxp; i++){
		global.mouse_x_previous[i] = mouse_x[i];
		global.mouse_y_previous[i] = mouse_y[i];
	}
	
#define draw_pause
	 // NTTE Options Button:
	if(!MenuOpen){
		if(instance_exists(OptionMenuButton)){
			var _draw = true;
			with(OptionMenuButton) if(alarm_get(0) > 0 || alarm_get(1) > 0){
				_draw = false;
				break;
			}
			if(_draw){
				var	_vx    = view_xview_nonsync,
					_vy    = view_yview_nonsync,
					_gw    = game_width,
					_gh    = game_height,
					_x     = (_gw / 2),
					_y     = (_gh / 2) + 59,
					_hover = false;
					
				 // Button Clicking:
				for(var i = 0; i < maxp; i++){
					if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _x - 57, _y - 12, _x + 57, _y + 12)){
						_hover = true;
						if(button_pressed(i, "fire")){
							MenuOpen = true;
							with(OptionMenuButton) instance_destroy();
							sound_play(sndClick);
							break;
						}
					}
				}
				
				 // Splat:
				MenuSplatOptions += (_hover ? 1 : -1) * current_time_scale;
				MenuSplatOptions = clamp(MenuSplatOptions, 0, sprite_get_number(sprMainMenuSplat) - 1);
				draw_sprite(sprMainMenuSplat, MenuSplatOptions, _vx + (_gw / 2), _vy + _y);
				
				 // Gray Out Other Options:
				if(MenuSplatOptions > 0){
					var _spr = sprOptionsButtons;
					for(var j = 0; j < sprite_get_number(_spr); j++){
						var	_dx = _vx + (_gw / 2),
							_dy = _vy + (_gh / 2) - 36 + (j * 24);
							
						draw_sprite_ext(_spr, j, _dx, _dy, 1, 1, 0, make_color_hsv(0, 0, 155), 1);
					}
				}
				
				 // Button:
				draw_set_fog(true, c_black, 0, 0);
				draw_sprite(spr.OptionNTTE, 0, _vx + _x + 1, _vy + _y);
				draw_sprite(spr.OptionNTTE, 0, _vx + _x,     _vy + _y + 1);
				draw_sprite(spr.OptionNTTE, 0, _vx + _x + 1, _vy + _y + 1);
				draw_set_fog(false, 0, 0, 0);
				draw_sprite_ext(spr.OptionNTTE, 0, _vx + _x, _vy + _y, 1, 1, 0, (_hover ? c_white : make_color_hsv(0, 0, 155)), 1);
			}
			else MenuSplatOptions = 0;
		}
	}
	else if(instance_exists(menubutton)){
		MenuOpen = false;
	}
	
	 // Main Code:
	ntte_menu();
	
#define draw_menu
	 // Animate NTTE Splat:
	var _add = 1;
	if(mod_exists("mod", "teloader")){
		if(mod_variable_exists("mod", "teloader", "load")){
			if(mod_variable_get("mod", "teloader", "load").total > 0){
				_add *= -1;
			}
		}
	}
	MenuSplat = clamp(MenuSplat + (_add * current_time_scale), 0, sprite_get_number(sprBossNameSplat) - 1);
	
	 // Campfire Menu Button:
	if(instance_exists(Menu)){
		if(Menu.mode == 1){
			var	_vx = view_xview_nonsync,
				_vy = view_yview_nonsync,
				_gw = game_width,
				_gh = game_height;
				
			if(MenuOpen){
				 // Hide Things:
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
				draw_set_alpha(0.75);
				draw_rectangle(_vx, _vy, _vx + _gw, _vy + _gh, 0);
				draw_set_alpha(1);
				
				 // Leave:
				for(var i = 0; i < maxp; i++){
					with(BackFromCharSelect){
						if(position_meeting((mouse_x[i] - (view_xview[i] + xstart)) + x, (mouse_y[i] - (view_yview[i] + ystart)) + y, self)){
							if(button_pressed(i, "fire")){
								MenuOpen = false;
								break;
							}
						}
					}
					if(button_pressed(i, "spec") || button_pressed(i, "paus")){
						MenuOpen = false;
						break;
					}
				}
				
				 // Closed:
				if(!MenuOpen){
					MenuSplat = 1;
					sound_play(sndClickBack);
					
					 // Reset Menu:
					with(Menu) with(self){
						mode = 0;
						event_perform(ev_step, ev_step_end);
						sound_volume(sndMenuCharSelect, 1);
						sound_stop(sndMenuCharSelect);
						with(CharSelect) alarm0 = 2;
					}
					with(Loadout) selected = 0;
					
					 // Tiny Partial Fix:
					draw_loadout_behind();
				}
			}
			
			 // Open:
			else if(MenuSplat > 0){
				var	_x = _gw - 40,
					_y = 40,
					_w = 40,
					_h = 24;
					
				 // Co-op Offset:
				var _max = 0;
				for(var i = 0; i < array_length(Menu.charx); i++){
					if(Menu.charx[i] != 0){
						_max = i;
					}
				}
				if(_max >= 2){
					_x = (_gw / 2) - 20;
					_y += 2;
				}
				
				 // Player Clicky:
				var _hover = false;
				if(!instance_exists(Loadout) || !Loadout.selected){
					for(var i = 0; i < maxp; i++){
						if(point_in_rectangle(mouse_x[i] - view_xview[i], mouse_y[i] - view_yview[i], _x, _y - 8, _x + _w, _y + _h)){
							_hover = true;
							if(button_pressed(i, "fire")){
								sound_play_pitch(sndMenuCredits, 1 + orandom(0.1));
								MenuOpen = true;
								MenuSplat = 1;
								break;
							}
						}
					}
				}
				
				 // Button Visual:
				draw_sprite_ext(sprBossNameSplat, MenuSplat, _vx + _x + 17, _vy + _y + 12 + MenuSplat, 1, 1, 90, c_white, 1);
				if(!MenuOpen){
					var _wave = (MenuSplatBlink % 300) - 60,
						_col  = ((_hover || (_wave >= 0 && _wave <= 5) || (_wave >= 8 && _wave <= 10)) ? c_white : c_silver);
						
					draw_sprite_ext(spr.MenuNTTE, 0, _vx + _x + (_w / 2), _vy + _y + 8 + _hover, 1, 1, 0, _col, 1);
				}
				if(MenuSplatBlink >= 0){
					MenuSplatBlink += current_time_scale;
					if(_hover || !option_get("reminders")){
						MenuSplatBlink = -1;
					}
				}
			}
		}
		else MenuOpen = false;
	}
	
	 // Main Code:
	ntte_menu();
	
#define draw_loadout_crown
	var	_p     = loadoutPlayer,
		_race  = player_get_race_fix(_p),
		_crown = lq_get(crownRace, _race),
		_vx    = view_xview_nonsync,
		_vy    = view_yview_nonsync,
		_w     = 20,
		_h     = 20,
		_cx    = game_width - 102,
		_cy    = 75;
		
	if(!is_undefined(_crown) && instance_exists(Loadout)){
		if(array_length(instances_matching(Loadout, "selected", true)) > 0){
			 // Loadout Reset:
			with(_crown.icon){
				if("inst" not in self/*<- 9940 'with' scoping bug*/ || !instance_exists(inst)){
					_crown.icon = [];
					_crown.custom.icon = [];
					break;
				}
			}
			
			 // Generate Comparison Files:
			if(array_length(crownCompare) <= 0){
				with(surface_setup("CrownCompare", _w, _h, 1)){
					surface_set_target(surf);
					
					var _x = w / 2,
						_y = h / 2;
						
					with(UberCont){
						for(var i = 0; i <= 13; i++){
							var a = crownPath + string(i) + crownPathA,
								b = crownPath + string(i) + crownPathB;
								
							 // Selected:
							draw_clear(c_black);
							draw_sprite(sprLoadoutCrown, i, _x, _y - 2);
							surface_save(other.surf, a);
							
							 // Locked:
							draw_clear(c_black);
							draw_sprite_ext(sprLockedLoadoutCrown, i, _x, _y, 1, 1, 0, c_gray, 1);
							surface_save(other.surf, b);
							
							 // Store MD5 Hashes:
							var _compare = { slct:"", lock:"" };
							array_push(crownCompare, _compare);
							file_load(a);
							file_load(b);
							if(fork()){
								wait 0;
								_compare.slct = file_md5(a);
								_compare.lock = file_md5(b);
								file_unload(a);
								file_unload(b);
								exit;
							}
						}
					}
					
					surface_reset_target();
				}
			}
			
			 // Normal Crown Icons:
			if(array_length(_crown.icon) <= 0){
				var	_crownList = instances_matching(LoadoutCrown, "", null),
					_crownCol  = 2,  // crwn_none column
					_crownRow  = -1; // crwn_none row
					
				for(var i = array_length(_crownList) - 1; i >= 0; i--){
					var n = ((array_length(_crownList) - 1) - i);
					
					array_push(_crown.icon, {
						inst    : _crownList[i],
						crwn    : n + 1,
						locked  : false,
						x       : 0,
						y       : 0,
						dix     : _crownCol,
						diy     : _crownRow,
						addy    : 2,
						visible : false
					});
					
					 // Determine Position on Screen:
					_crownCol++;
					if((n % 4) == 0){
						_crownCol = 0;
						_crownRow++;
					}
					
					 // Delay Crowns (Necessary for scanning the image without any overlapping):
					with(_crownList[i]){
						alarm_set(0, 4 - floor((n - 1) / 4));
					}
				}
				
				 // Another Hacky Fix:
				if(fork()){
					wait 2;
					sprite_replace_base64(sprClockParts, "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==", 1);
					global.clock_fix = true;
					exit;
				}
			}
			with(_crown.icon){
				x = _vx + _cx + (dix * crownIconW);
				y = _vy + _cy + (diy * crownIconH);
				
				 // Appear + Initial Crown Reading:
				if(!visible){
					with(inst) if(alarm_get(0) == 0){
						with(other){
							visible = true;
							
							var	_crwn  = crwn,
								_crwnX = x,
								_crwnY = y + 2;
								
							with(surface_setup("CrownCompareScreen", game_width, game_height, 1)){
								x = _vx;
								y = _vy;
								
								 // Capture Screen:
								surface_set_target(surf);
								draw_clear(c_black);
								surface_reset_target();
								draw_set_blend_mode_ext(bm_one, bm_inv_src_alpha);
								surface_screenshot(surf);
								draw_set_blend_mode(bm_normal);
								
								 // Capture Crown Icon:
								with(surface_setup("CrownCompare", _w, _h, 1)){
									x = (w / 2);
									y = (h / 2);
									
									 // Draw Crown Icon from Screen Surface:
									surface_set_target(surf);
									draw_clear_alpha(0, 0);
									draw_surface(other.surf, -(_crwnX - x - other.x), -(_crwnY - y - other.y));
									surface_reset_target();
									
									 // Compare MD5 Hashes w/ Selected/Locked Variants to Determine Crown's Current State (Bro if LoadoutCrown gets exposed pls tell me):
									var _path = crownPath + string(_crwn) + crownPathD;
									surface_save(surf, _path);
									file_load(_path);
									if(fork()){
										wait 0;
										var _hash = file_md5(_path);
										locked = (_hash == crownCompare[_crwn].lock);
										if(_hash == crownCompare[_crwn].slct){
											_crown.slct = _crwn;
										}
										file_unload(_path);
										exit;
									}
								}
							}
						}
					}
				}
				
				 // Active:
				if(visible){
					var	_x   = x,
						_y   = y + addy,
						_spr = (locked ? sprLockedLoadoutCrown : sprLoadoutCrown),
						_img = real(crwn),
						_col = c_gray;
						
					if(addy > 0){
						addy -= 2 * current_time_scale;
					}
					
					 // Selection:
					if(instance_exists(inst)){
						if(player_is_active(_p)){
							with(UberCont){
								if(position_meeting(mouse_x[_p], mouse_y[_p], other.inst)){
									with(other){
										 // Select:
										if(!locked && button_pressed(_p, "fire")){
											if(_crown.custom.slct != -1 && crwn == _crown.slct){
												sound_play(sndMenuCrown);
											}
											_crown.slct = crwn;
											_crown.custom.slct = -1;
										}
										
										 // Hovering Over Button:
										if(crwn != _crown.slct || _crown.custom.slct != -1){
											_y -= 1;
											_col = merge_color(c_gray, c_white, 0.6);
										}
									}
								}
							}
						}
						
						 // Selected:
						if(crwn == _crown.slct && _crown.custom.slct == -1){
							_y -= 2;
							_col = c_white;
						}
					}
					
					 // Dull Normal Crown Selection:
					if(crwn == _crown.slct && _crown.custom.slct != -1){
						with(UberCont){
							draw_sprite_ext(_spr, _img, _x, _y, 1, 1, 0, _col, 1);
						}
					}
					
					 // Haste Fix:
					if(crwn == crwn_haste && !locked){
						if("time" not in self){
							time = current_frame / 12;
						}
						if(crwn == _crown.slct && _crown.custom.slct == -1){
							time += current_time_scale / 12;
						}
						with(UberCont){
							draw_sprite_ext(spr.ClockParts, 0, _x - 2, _y - 1, 1, 1, other.time,      _col, 1);
							draw_sprite_ext(spr.ClockParts, 0, _x - 2, _y - 1, 1, 1, other.time * 12, _col, 1);
							draw_sprite_ext(spr.ClockParts, 1, _x - 2, _y - 1, 1, 1, 0,               _col, 1);
						}
					}
				}
			}
			
			 // Custom Crown Icons:
			if(array_length(_crown.custom.icon) <= 0){
				with(array_combine([crwn_random], ntte_mods.crown)){
					with({
						crwn         : self,
						locked       : false,
						x            : 0,
						y            : 0,
						dix          : 0,
						diy          : 0,
						addy         : 2,
						hover        : false,
						alarm0       : -1,
						visible      : false,
						sprite_index : sprLoadoutCrown,
						image_index  : 0
					}){
						 // Modded:
						if(is_string(crwn)){
							var _scrt = "crown_menu_avail";
							locked = (mod_script_exists("crown", crwn, _scrt) && !mod_script_call_nc("crown", crwn, _scrt));
							
							var _scrt = "crown_menu_button";
							if(mod_script_exists("crown", crwn, _scrt)){
								with(instance_create(0, 0, GameObject)){
									variable_instance_set_list(self, other);
									mod_script_call_self("crown", crwn, _scrt);
									if(instance_exists(self)){
										for(var i = 0; i < lq_size(other); i++){
											lq_set(other, lq_get_key(other, i), variable_instance_get(self, lq_get_key(other, i)));
										}
										instance_delete(self);
									}
								}
								array_push(_crown.custom.icon, self);
							}
						}
						
						 // Other:
						else{
							switch(crwn){
								case crwn_random:
									dix = 1;
									diy = -1;
									sprite_index = spr.CrownRandomLoadout;
									break;
							}
							array_push(_crown.custom.icon, self);
						}
						
						if(alarm0 < 0){
							alarm0 = max(1, 5 - diy);
						}
					}
				}
			}
			with(_crown.custom.icon){
				x = _vx + _cx + (dix * crownIconW);
				y = _vy + _cy + (diy * crownIconH);
				
				 // Locked:
				if(_crown.custom.slct == crwn && locked){
					_crown.custom.slct = -1;
				}
				
				 // Appear:
				if(alarm0 >= 0 && --alarm0 == 0){
					visible = true;
				}
				
				 // Active:
				if(visible){
					var	_x   = x,
						_y   = y + addy,
						_spr = sprite_index,
						_img = image_index,
						_col = c_gray;
						
					if(addy > 0){
						addy -= 2 * current_time_scale;
					}
					
					 // Hovering:
					if(player_is_active(_p) && point_in_rectangle(mouse_x[_p], mouse_y[_p], x - 10, y - 10, x + 10, y + 10)){
						 // Sound:
						if(!hover) sound_play(sndHover);
						hover = min(hover + 1, 2);
						
						 // Select:
						if(!locked && button_pressed(_p, "fire") && _crown.custom.slct != crwn){
							_crown.custom.slct = crwn;
							sound_play(sndMenuCrown);
						}
						
						 // Highlight:
						if(crwn != _crown.custom.slct){
							_y--;
							_col = merge_color(c_gray, c_white, 0.6);
						}
					}
					else hover = false;
					
					 // Selected:
					if(crwn == _crown.custom.slct){
						_y -= 2;
						_col = c_white;
					}
					
					 // Draw:
					with(other){
						draw_sprite_ext(_spr, _img, _x, _y, 1, 1, 0, _col, 1);
					}
				}
			}
			
			 // Custom Crown Tooltip:
			with(_crown.custom.icon) if(visible && hover){
				with(global.loadout_bind[? "tooltip"].id){
					x    = other.x;
					y    = other.y - 5 - other.hover;
					text = (other.locked ? "LOCKED" : (crown_get_name(other.crwn) + "#@s" + crown_get_text(other.crwn)));
				}
			}
		}
		else crownCompare = [];
	}
	
#define draw_loadout_weapon
	for(var i = 0; i < array_length(wepLoadout); i++){
		with(wepLoadout[i]){
			if(alarm0 >= 0) alarm0--;
			if(alarm0 <= 0){
				var	_real     = (name != ""),
					_savePath = `loadout:wep:${player_get_race_fix(loadoutPlayer)}`,
					_slct     = (save_get(_savePath, "") == name),
					_wep      = unlock_get(_savePath + ":" + name),
					_x        = view_xview_nonsync + game_width  - 86 + (dix * wepIconW),
					_y        = view_yview_nonsync + game_height - 78 + (diy * wepIconH) + addy;
					
				if(addy > 0){
					addy -= current_time_scale;
				}
				
				with(inst){
					 // Perform Important Code & Cover Normal LoadoutWeps:
					if(_real || _slct){
						// Disable drawing
						draw_set_blend_mode_ext(bm_zero, bm_dest_alpha);
					}
					else if(!_real){
						// Cover
						draw_set_color(c_black);
						draw_rectangle(_x - 16, _y - 16, _x + 16, _y + 16, false);
					}
					with(self){
						event_perform(ev_draw, 0);
					}
					draw_set_blend_mode(bm_normal);
					
					 // Draw Manually:
					if(_real){
						draw_loadoutwep(_wep, 0, _x, _y - (_slct ? 2 : other.hover), 1, 1, 0, merge_color(c_white, c_black, (_slct ? 0 : (other.hover ? 0.2 : 0.5))), 1);
						
						 // Tooltip:
						with(other){
							if(hover){
								with(global.loadout_bind[? "tooltip"].id){
									x    = _x;
									y    = _y - 7 + other.overy;
									text = weapon_get_name(_wep);
								}
								if(overy > 0) overy--;
							}
							else overy = 1;
						}
					}
				}
			}
		}
	}
	
#define draw_loadout_behind
	if(instance_exists(Loadout)){
		var	_vx = view_xview_nonsync,
			_vy = view_yview_nonsync,
			_gw = game_width,
			_gh = game_height;
			
		 // Fix Haste Hands:
		if(global.clock_fix){
			if(array_length(instances_matching(Loadout, "selected", false))){
				global.clock_fix = false;
				sprite_restore(sprClockParts);
			}
		}
		
		 // Cool Unused Splat:
		with(instances_matching(Loadout, "visible", true)){
			if(selected == true){
				closeanim = 0;
			}
			else{
				var _spr = sprLoadoutClose;
				if("closeanim" in self && closeanim < sprite_get_number(_spr)){
					draw_sprite(_spr, closeanim, _vx + _gw, _vy + _gh - 36);
					closeanim += current_time_scale;
					
					image_index = 0;
					image_speed_raw = image_number - 1;
				}
			}
		}
		
		 // Hiding Crown/Weapon Icons Setup:
		var	_p     = loadoutPlayer,
			_race  = player_get_race_fix(_p),
			_crown = lq_get(crownRace, _race);
			
		with(surface_setup("LoadoutHide", 64, 64, game_scale_nonsync)){
			with(Loadout){
				var	_x         = _vx + _gw,
					_y         = _vy + _gh - 36 + introsettle,
					_surf      = other.surf,
					_surfW     = other.w,
					_surfH     = other.h,
					_surfScale = other.scale,
					_surfX     = _x - 32 - _surfW,
					_surfY     = _y +  4 - _surfH;
					
				with(surface_setup("LoadoutHideScreen", _gw, _gh, _surfScale)){
					x = _vx;
					y = _vy;
					
					 // Capture Screen:
					surface_set_target(surf);
					draw_clear(c_black);
					surface_reset_target();
					draw_set_blend_mode_ext(bm_one, bm_inv_src_alpha);
					surface_screenshot(surf);
					draw_set_blend_mode(bm_normal);
					
					with(other){
						surface_set_target(_surf);
						draw_clear_alpha(0, 0);
						
						 // Offset:
						var _off = 0;
						if(player_is_active(_p) && position_meeting(mouse_x[_p], mouse_y[_p], self)){
							_off = 1;
						}
						if(selected == true){
							if(openanim <= 0) _off = 2;
							if(openanim == 1) _off = 1;
						}
						
						/// Draw Mask of What to Hide:
						
							draw_set_fog(true, c_black, 0, 0);
							
							 // The Currently Selected Crown:
							if(!is_undefined(_crown) && _crown.custom.slct != -1 && _crown.slct != crwn_none){
								draw_sprite_ext(sprLoadoutCrown, _crown.slct, (_x - _surfX - 60 - _off) * _surfScale, (_y - _surfY - 39 - _off) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
							}
							
							 // The Character's Starting Weapon:
							if(unlock_get(`loadout:wep:${_race}:${save_get(`loadout:wep:${_race}`, "")}`) != wep_none){
								var _wep = wep_revolver;
								
								 // Determine Starting Wep:
								switch(race_get_id(_race)){
									case char_random   : _wep = wep_none;               break;
									case char_venuz    : _wep = wep_golden_revolver;    break;
									case char_chicken  : _wep = wep_chicken_sword;      break;
									case char_rogue    : _wep = wep_rogue_rifle;        break;
									case char_bigdog   : _wep = wep_dog_spin_attack;    break;
									case char_skeleton : _wep = wep_rusty_revolver;     break;
									case char_frog     : _wep = wep_golden_frog_pistol; break;
									
									default: // Custom
										if(is_string(_race) && mod_script_exists("race", _race, "race_swep")){
											_wep = mod_script_call_self("race", _race, "race_swep");
										}
								}
								
								 // Draw:
								draw_loadoutwep(_wep, 0, (_x - _surfX - 60 - _off) * _surfScale, (_y - _surfY - 14 + _off) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
							}
							
							draw_set_fog(false, 0, 0, 0);
							
						/// Overlay Screen + Loadout Splat Over Mask:
							
							draw_set_color_write_enable(true, true, true, false);
							
							 // Screen:
							with(other){
								draw_surface_scale(surf, (x - _surfX) * _surfScale, (y - _surfY) * _surfScale, _surfScale / scale);
							}
							
							 // Loadout:
							draw_sprite_ext(sprLoadoutSplat, image_index, (_x - _surfX) * _surfScale, ((_y - introsettle) - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
							if(selected == true){
								draw_sprite_ext(sprLoadoutOpen, openanim, (_x - _surfX) * _surfScale, ((_y - introsettle) - _surfY) * _surfScale, _surfScale, _surfScale, 0, c_white, 1);
							}
							if(_race == "steroids"){
								draw_loadoutwep(wep_revolver, 0, ((_x - 40 - _off) - _surfX) * _surfScale, ((_y - introsettle - 14) - _surfY + _off) * _surfScale, _surfScale, _surfScale, 0, c_ltgray, 1);
							}
							
							draw_set_color_write_enable(true, true, true, true);
							
						surface_reset_target();
					}
				}
				
				other.x = _surfX;
				other.y = _surfY;
			}
		}
	}
	
#define draw_loadout_above
	if(instance_exists(Loadout)){
		 // Drawing Custom Loadout Icons (Collapsed Loadout):
		var	_p     = loadoutPlayer,
			_race  = player_get_race_fix(_p),
			_crown = lq_get(crownRace, _race);
			
		with(surface_setup("LoadoutHide", null, null, null)){
			with(Loadout) if(visible && (selected == false || openanim <= 2)){
				var	_x = view_xview_nonsync + game_width,
					_y = view_yview_nonsync + game_height - 36 + introsettle;
					
				 // Hide Normal Icons:
				with(other){
					draw_surface_scale(surf, x, y, 1 / scale);
				}
				
				 // Offset:
				var _off = 0;
				if(player_is_active(_p) && position_meeting(mouse_x[_p], mouse_y[_p], self)){
					_off = 1;
				}
				if(selected == true){
					if(openanim <= 0) _off = 2;
					if(openanim == 1) _off = 1;
				}
				
				 // Custom Crown:
				if(!is_undefined(_crown) && _crown.custom.slct != -1){
					with(_crown.custom.icon) if(crwn == _crown.custom.slct){
						with(other){
							draw_sprite(other.sprite_index, other.image_index, _x - 60 - _off, _y - 39 - _off);
						}
					}
				}
				
				 // Custom Weapon:
				var _wep = unlock_get(`loadout:wep:${_race}:${save_get(`loadout:wep:${_race}`, "")}`);
				if(_wep != wep_none){
					with(self){
						draw_loadoutwep(_wep, 0, _x - 60 - _off, _y - 14 + _off, 1, 1, 0, c_white, 1);
					}
				}
			}
		}
	}
	
#define draw_loadoutwep(_wep, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	/*
		Draws a given weapon's loadout sprite as it would appear on the character selection screen
	*/
	
	var _spr = weapon_get("loadout", _wep);
	
	 // Default to 2x Normal Sprite:
	if(_spr == 0 || _spr == null){
		_spr = weapon_get_sprt(_wep);
		_xsc *= 2;
		_ysc *= 2;
		_ang += point_direction(0, 0, 2, -1);
		
		 // Offset:
		var	_xoff = (1 - ((sprite_get_width(_spr)  / 2) - sprite_get_xoffset(_spr))) * _xsc,
			_yoff = (1 - ((sprite_get_height(_spr) / 2) - sprite_get_yoffset(_spr))) * _ysc;
			
		_x += lengthdir_x(_xoff, _ang) + lengthdir_x(_yoff, _ang - 90);
		_y += lengthdir_y(_xoff, _ang) + lengthdir_y(_yoff, _ang - 90);
	}
	
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	
#define draw_loadout_tooltip
	if("text" in self && text != ""){
		draw_set_font(fntM);
		draw_tooltip(x, y, text);
		text = "";
	}
	
#define player_get_race_fix(_player)
	/*
		Used for custom loadout, predicts character selection scrolling
	*/
	
	var _race = player_get_race(_player);
	
	 // Fix 1 Frame Delay Thing:
	if(player_is_active(_player)){
		var _raceChange = (button_pressed(_player, "east") - button_pressed(_player, "west"));
		if(_raceChange != 0){
			with(Menu){
				var _new = _race;
				
				with(instances_matching(CharSelect, "race", _race)){
					var	_slct = instances_matching_ne(instances_matching_ne(CharSelect, "id", id), "race", 16/*==Locked in game logic??*/),
						_inst = _slct;
						
					if(_raceChange > 0){
						_inst = instances_matching_gt(_slct, "xstart", xstart);
					}
					else{
						_inst = instances_matching_lt(_slct, "xstart", xstart);
					}
					
					 // Find Next CharSelect:
					if(array_length(_inst) > 0){
						var _min = 0;
						with(_inst){
							var _x = (xstart - other.xstart);
							if(_min <= 0 || abs(_x) < _min){
								_min = abs(_x);
								_new = race;
							}
						}
					}
					
					 // Loop Around to Farthest CharSelect:
					else{
						var _max = 0;
						with(_slct){
							var _x = (xstart - other.xstart);
							if(_max <= 0 || abs(_x) > _max){
								_max = abs(_x);
								_new = race;
							}
						}
					}
				}
				
				_race = _new;
			}
		}
	}
	
	return _race;
	
#define ntte_menu()
	if(MenuOpen){
		if(lag) trace_time();
		
		var _userSeen = [];
		
		for(var _index = 0; _index < maxp; _index++){
			if(player_is_active(_index)){
				var _user = player_get_uid(_index);
				if(array_find_index(_userSeen, _user) < 0){
					array_push(_userSeen, _user);
					
					draw_set_visible_all(false);
					draw_set_visible(_index, true);
					
					var	_menuCurrent = MenuSlct[_index],
						_vx          = view_xview[_index],
						_vy          = view_yview[_index],
						_mx          = mouse_x[_index],
						_my          = mouse_y[_index],
						_gw          = game_width,
						_gh          = game_height,
						_local       = player_is_local_nonsync(_index),
						_tooltip     = "";
						
					/// Menu Swap:
						var	_tx = _vx + _gw - 3,
							_ty = _vy + 35 + min(3, 2 * MenuSplat);
							
						draw_set_halign(fa_right);
						draw_set_valign(fa_top);
						draw_set_font(fntSmall);
						
						 // Splat:
						draw_sprite_ext(sprBossNameSplat, MenuSplat, _tx - 15 - MenuSplat, _ty + 17, 1, 1, 90, c_white, 1);
						
						 // Cycle Through Menus:
						if(button_pressed(_index, "swap")){
							_menuCurrent = ((_menuCurrent + 1) % lq_size(MenuList));
						}
						
						 // Menu List:
						for(var _m = 0; _m < lq_size(MenuList); _m++){
							var	_text    = lq_get_key(MenuList, _m),
								_hover   = false,
								_current = (MenuSlct[_index] == _m);
								
							 // Selecting:
							if(!_current){
								if(point_in_rectangle(
									_mx,
									_my,
									_tx - 40,
									_ty,
									_tx + 2,
									_ty + 1 + string_height(_text)
								)){
									_hover = true;
									if(MenuPop[_index] >= 3 && button_pressed(_index, "fire")){
										_menuCurrent = _m;
									}
								}
							}
							
							 // Text:
							draw_text_nt(_tx - _current, _ty, (_current ? "" : (_hover ? "@s" : "@d")) + _text);
							
							_ty += string_height(_text) + 2;
						}
						
						 // Menu Swapped:
						if(_menuCurrent != MenuSlct[_index]){
							MenuPop[_index] = 0;
							
							 // Sound:
							switch(_menuCurrent){
								case menu_options : sound_play(sndMenuOptions); break;
								case menu_stats   : sound_play(sndMenuStats);   break;
								case menu_credits : sound_play(sndMenuCredits); break;
								default           : sound_play(sndClick);
							}
						}
						
					 // Menu Code:
					var	_menu     = lq_get_value(MenuList, _menuCurrent),
						_menuList = lq_defget(_menu, "list", []),
						_menuSlct = lq_defget(_menu, "slct", []),
						_menuX    = _vx + (_gw / 2) + lq_defget(_menu, "x", 0),
						_menuY    = _vy + (_gh / 2) + lq_defget(_menu, "y", 0);
						
					draw_set_font(fntM);
					
					MenuPop[_index] += current_time_scale;
					var _pop = floor(MenuPop[_index]);
					
					switch(_menuCurrent){
						case menu_options:
							draw_set_halign(fa_left);
							draw_set_valign(fa_middle);
							
							 // Arrow Key Selection Change:
							var _moveOption = sign(button_pressed(_index, "sout") - button_pressed(_index, "nort"));
							if(_moveOption != 0){
								var _m = _menuSlct[_index];
								do{
									_m += _moveOption;
									_m = ((_m + array_length(_menuList)) % array_length(_menuList));
								}
								until (_menuList[_m].type >= 0);
								_menuSlct[_index] = _m;
							}
							
							 // Option Selecting & Splat:
							for(var i = 0; i < array_length(_menuList); i++){
								var _option = _menuList[i];
								with(_option){
									appear = i + 3;
								}
								
								 // Select:
								var	_hover    = (point_in_rectangle(_mx, _my, _menuX - 80, _menuY - 8, _menuX + 159, _menuY + 6) && (_mx < _vx + _gw - 48 || _my > _vy + 64)),
									_selected = (_menuSlct[_index] == i);
									
								if(_hover || _selected){
									if(_option.type >= 0){
										if(
											!_hover
											|| _mx != global.mouse_x_previous[_index]
											|| _my != global.mouse_y_previous[_index]
										){
											_menuSlct[_index] = i;
										}
									}
									
									with(_option) if(_pop >= appear){
										var	_click   = button_pressed(_index, "fire"),
											_confirm = ((_click && _hover) || button_pressed(_index, "okay"));
											
										 // Click:
										if(type >= 0){
											if(!clicked[_index]){
												if(_confirm){
													if(_click){
														clicked[_index] = true;
													}
													if(_selected){
														switch(type){
															case opt_slider:
																if(_click) sound_play(sndSlider);
																break;
																
															default:
																sound_play(sndClick);
																break;
														}
													}
												}
											}
											else if(!button_check(_index, "fire")){
												clicked[_index] = false;
												if(_selected){
													switch(type){
														case opt_slider:
															sound_play(sndSliderLetGo);
															break;
													}
												}
											}
										}
										
										 // Option Specifics:
										if(_selected && (sync || _local)){
											switch(type){
												case opt_toggle:
													if(_confirm){
														save_set(save, (save_get(save, 1) + 1) % array_length(pick));
													}
													break;
													
												case opt_slider:
													if(_hover && button_check(_index, "fire") && clicked[_index]){
														var _slider = clamp(round(_mx - (_menuX + 40)) / 100, 0, 1);
														save_set(save, _slider);
													}
													else{
														var _adjust = 0.1 * sign(button_pressed(_index, "east") - button_pressed(_index, "west"));
														if(_adjust != 0){
															save_set(save, clamp(save_get(save, 1) + _adjust, pick[0], pick[1]));
														}
													}
													break;
											}
										}
										
										 // Description on Hover:
										if(_hover && "text" in self){
											//if(!button_check(_index, "fire") || type == opt_title){
												if(_mx < _vx + (_gw / 2) + 32){
													_tooltip = text;
												}
											//}
										}
									}
								}
								else _option.clicked[_index] = false;
								
								with(_option){
									if(type == opt_title){
										_menuY += 2;
									}
									x = _menuX;
									y = _menuY;
									
									if(_pop >= appear){
										 // Appear Pop:
										if(_pop == appear && MenuPop[_index] - _pop <= current_time_scale){
											sound_play_pitch(sndAppear, random_range(0.5, 1.5));
										}
										
										 // Selection Splat:
										if(_local){
											if(_moveOption == 0){
												splat += ((_menuSlct[_index] == i) ? 1 : -1) * current_time_scale;
												splat = clamp(splat, 0, sprite_get_number(sprMainMenuSplat) - 1);
											}
											if(splat > 0){
												with(UberCont){
													draw_sprite(sprMainMenuSplat, other.splat, other.x, other.y);
												}
											}
										}
									}
								}
								_menuY += 16;
							}
							
							 // Option Text:
							if(_local){
								var _titleFound = false;
								for(var i = 0; i < array_length(_menuList); i++){
									var	_option   = _menuList[i],
										_selected = (_local && _menuSlct[_index] == i);
										
									with(_option) if(_pop >= appear){
										 // Option Name:
										var	_x    = x - 80,
											_y    = y,
											_name = name;
											
										if(type == opt_title){
											_titleFound = true;
											draw_set_color(c_white);
										}
										else if(_titleFound){
											_name = " " + _name;
										}
										
										if(_selected){
											_y--;
											draw_set_color(c_white);
										}
										else draw_set_color(make_color_rgb(125, 131, 141));
										if(_pop < appear + 1){
											_y++;
										}
										
										draw_text_shadow(_x, _y, _name);
										
										 // Option Specifics:
										_x += 124;
										var _value = save_get(save, 1);
										with(other){
											switch(other.type){
												case opt_toggle:
													draw_text_shadow(_x, _y, other.pick[clamp(_value, 0, array_length(other.pick) - 1)]);
													break;
													
												case opt_slider:
													var	_dx = _x - 5,
														_dy = _y - 2,
														_w  = 6 + (100 * _value),
														_h  = sprite_get_height(sprOptionSlider);
														
													 // Slider:
													draw_sprite(sprOptionSlider,      0,               _dx,            _dy);
													draw_sprite_part(sprOptionSlider, 1, 0, 0, _w, _h, _dx - 5,        _dy - 6);
													draw_sprite(sprSliderEnd,         1,               _dx + _w - 2,   _y);
													
													 // Text:
													draw_set_color(c_white);
													draw_text_shadow(_x, _y + 1, string_format(_value * 100, 0, 0) + "%");
													break;
											}
											
											switch(_name){
												
												case "Visual Quality :": // Surface Quality Visual
													
													var	_active    = (_menuSlct[_index] >= i && _menuSlct[_index] <= i + 2),
														_spr       = spr.GullIdle,
														_img       = (current_frame * 0.4),
														_col       = (_active ? c_white : c_gray),
														_surfW     = sprite_get_width(_spr),
														_surfH     = sprite_get_height(_spr),
														_surfScale = [
															option_get("quality:minor"),
															option_get("quality:main")
														],
														_wadeColor = merge_color(
															make_color_rgb(44, 37, 122),
															make_color_rgb(27, 118, 184),
															0.25 + (0.25 * sin(current_frame / 30))
														),
														_wadeHeight = _surfH / 2;
														
													for(var _s = 0; _s < array_length(_surfScale); _s++){
														with(surface_setup(`VisualQuality${_s}`, _surfW, _surfH, _surfScale[_s])){
															x = _x - 20 - (w / 2);
															y = _y + 24 - (h / 2);
															
															 // Draw Sprite:
															var	_dx = (w / 2),
																_dy = (h / 2) - (2 + sin(current_frame / 10));
																
															surface_set_target(surf);
															draw_clear_alpha(0, 0);
															with(UberCont){
																if(_s == 0) draw_set_fog(true, _wadeColor, 0, 0);
																draw_sprite_ext(_spr, _img, _dx * other.scale, _dy * other.scale, other.scale, other.scale, 0, c_white, 1);
																if(_s == 0) draw_set_fog(false, 0, 0, 0);
															}
															surface_reset_target();
															
															 // Draw Clipped Surface:
															if(_s == 0){ // Bottom
																draw_surface_part_ext(surf, 0, _wadeHeight * scale, w * scale, (h - _wadeHeight) * scale, x, y + _wadeHeight, 1 / scale, 1 / scale, _col, 1);
															}
															else{ // Top
																draw_surface_part_ext(surf, 0, 0, w * scale, (_wadeHeight + 1) * scale, x, y, 1 / scale, 1 / scale, _col, 1);
																draw_set_fog(true, _col, 0, 0);
																draw_surface_part_ext(surf, 0, _wadeHeight * scale, w * scale, max(1, scale), x, y + _wadeHeight, 1 / scale, 1 / scale, c_white, 0.8);
																draw_set_fog(false, 0, 0, 0);
															}
														}
													}
													
													break;
													
											}
										}
									}
								}
							}
							
							break;
							
						case menu_stats:
							
							var _statSlct = _menuSlct[_index];
							
							/// Stat Menu Swap:
								var	_tx = _vx + _gw,
									_ty = _vy + _gh - 36;
									
								 // Splat:
								var _spr = sprLoadoutSplat;
								draw_sprite(_spr, min(_pop, sprite_get_number(_spr) - 1), _tx, _ty);
								
								 // Cycle Through:
								if(button_pressed(_index, "pick")){
									_statSlct = ((_statSlct + 1) % lq_size(_menuList));
								}
								
								 // Tabs:
								_tx -= 4;
								_ty -= 4;
								draw_set_halign(fa_right);
								draw_set_valign(fa_bottom);
								for(var i = lq_size(_menuList) - 1; i >= 0; i--){
									var	_text = lq_get_key(_menuList, i),
										_hover = false,
										_selected = (_menuSlct[_index] == i);
									
									 // Selecting:
									if(!_selected && point_in_rectangle(
										_mx,
										_my,
										_tx - 68,
										_ty - string_height(_text) - 1,
										_tx + 4,
										_ty
									)){
										_hover = true;
										
										 // Select:
										if(button_pressed(_index, "fire")){
											_statSlct = i;
										}
									}
									
									draw_text_nt(_tx - _selected, _ty + (_pop <= 1), (_selected ? "" : (_hover ? "@s" : "@d")) + _text);
									
									_ty -= string_height(_text) + 2;
								}
								
								 // Swapped:
								if(_statSlct != _menuSlct[_index]){
									_menuSlct[_index] = _statSlct;
									
									_pop = 2;
									MenuPop[_index] = _pop;
									
									switch(lq_get_key(_menuList, _statSlct)){
										case "pets"    : sound_play_pitch(sndMenuStats,  1.2); break;
										case "unlocks" : sound_play_pitch(sndMenuScores, 1.1); break;
										default        : sound_play(sndMenuStats);
									}
								}
							
							 // Stat Menus:
							var	_statMenu = lq_get_value(_menuList, _statSlct),
								_statX    = _menuX + lq_defget(_statMenu, "x", 0),
								_statY    = _menuY + lq_defget(_statMenu, "y", 0),
								_statDraw = [];
								
							switch(lq_get_key(_menuList, _statSlct)){
								case "mutants":
									
									var	_raceList    = _statMenu.list,
										_raceSlct    = _statMenu.slct,
										_raceCurrent = lq_get_key(_raceList, _raceSlct[_index]);
										
									if(is_undefined(_raceCurrent)) _raceCurrent = "";
									
									 // Auto-Select First Loaded Character:
									if(!mod_exists("race", _raceCurrent)){
										for(var i = 0; i < lq_size(_raceList); i++){
											var _race = lq_get_key(_raceList, i);
											if(mod_exists("race", _race)){
												_raceCurrent = _race;
												_raceSlct[_index] = i;
												break;
											}
										}
									}
									
									 // Locked:
									if(mod_script_exists("race", _raceCurrent, "race_avail")){
										var _avail = mod_script_call("race", _raceCurrent, "race_avail");
										if(is_real(_avail) && !_avail){
											_raceCurrent = "";
										}
									}
									
									/// Character Swap:
										
										 // Splat:
										var	_x   = _vx,
											_y   = _vy + 36,
											_spr = sprUnlockPopupSplat;
											
										if(!instance_exists(BackMainMenu)){
											draw_sprite_ext(_spr, clamp(_pop - 2, 0, sprite_get_number(_spr) - 1), _x, _y, 1, 1, 180, c_white, 1);
										}
										else _x -= 16;
										
										 // Icons:
										if(_pop >= 4){
											_x += 40;
											_y += 10;
											for(var i = 0; i < lq_size(_raceList); i++){
												var	_race  = lq_get_key(_raceList, i),
													_avail = true;
													
												if(mod_exists("race", _race)){
													 // Locked:
													if(mod_script_exists("race", _race, "race_avail")){
														_avail = mod_script_call("race", _race, "race_avail");
														if(!is_real(_avail)) _avail = true;
													}
													
													var	_selected = (_raceSlct[_index] == i && _avail),
														_sprt     = mod_script_call("race", _race, "race_mapicon", _index, 0);
														
													if(!is_real(_sprt) || !sprite_exists(_sprt)){
														_sprt = sprMapIconChickenHeadless;
													}
													
													 // Selection:
													var _hover = false;
													if(!_selected && point_in_rectangle(
														_mx,
														_my,
														_x - 8,
														_y - 8,
														_x + 8,
														_y + 8
													)){
														_hover = true;
														if(!_avail) _tooltip = "LOCKED";
														
														 // Select:
														if(button_pressed(_index, "fire")){
															if(_avail){
																_raceSlct[_index] = i;
																_pop = 4;
																MenuPop[_index] = _pop;
																sound_play((i & 1) ? sndMenuBSkin : sndMenuASkin);
															}
															
															 // Locked:
															else{
																sound_play(sndNoSelect);
																_selected = true;
															}
														}
													}
													
													if(!_avail) draw_set_fog(true, make_color_hsv(0, 0, 22 * (1 + _hover)), 0, 0);
													draw_sprite_ext(_sprt, 0.4 * current_frame, _x, _y - _selected, 1, 1, 0, (_selected ? c_white : (_hover ? c_silver : c_gray)), 1);
													if(!_avail) draw_set_fog(false, 0, 0, 0);
													
													_x += 32;
												}
											}
											
											 // Temporary:
											if(instance_exists(Menu) && unlock_get("race:parrot")){
												_y -= 2;
												
												var _hover = point_in_rectangle(_mx, _my, _x - 12, _y - 8, _x + 12, _y + 8);
												
												if(_hover && button_pressed(_index, "fire")){
													sound_play(sndNoSelect);
													_y += choose(-1, 1);
												}
												
												draw_set_fog(true, make_color_hsv(0, 0, (_hover ? 50 : 30)), 0, 0);
												draw_sprite(sprMapIcon, 4, _x, _y - _hover)
												draw_set_fog(false, 0, 0, 0);
												
												//draw_set_halign(fa_center);
												//draw_set_valign(fa_middle);
												//draw_text_nt(_x, _y + (_hover * sin(current_frame / 10)), (_hover ? "@s" : "@d") + "COMING#SOON")
												
												if(_hover) _tooltip = "@sCOMING#SOON@w?";
											}
										}
										
										 // Get Stats to Display:
										with(lq_defget(_raceList, _raceCurrent, [])){
											with(list) if(stat_get(self[1]) != 0){
												array_push(_statDraw, other);
												break;
											}
										}
										
									/// Portrait:
										var	_sprt  = sprBigPortraitChickenHeadless,
											_x     = _vx,
											_y     = _vy + _gh,
											_portX = (90 * min(0, _pop - 5)) - min(2, (_pop - 5) * 2);
											
										if(mod_script_exists("race", _raceCurrent, "race_portrait")){
											_sprt = mod_script_call("race", _raceCurrent, "race_portrait", _index, 0)
											if(sprite_exists(_sprt)){
												draw_sprite(_sprt, 0.4 * current_frame, _x + _portX, _y);
											}
										}
										
										 // Splat:
										var _spr = sprCharSplat;
										draw_sprite(_spr, clamp(_pop - 1, 0, sprite_get_number(_spr) - 1), _x, _y - 36);
										
										 // Name:
										draw_set_color(c_white);
										draw_set_font(fntBigName);
										draw_set_halign(fa_left);
										draw_set_valign(fa_top);
										if(mod_script_exists("race", _raceCurrent, "race_name")){
											draw_text_bn(
												_x + 6 + (_portX * 1.5),
												_y - 80,
												race_get_title(_raceCurrent),
												1.5
											);
										}
										else{
											draw_text_bn(
												_x + 16 + (_portX * 0.6),
												_y - 80,
												"NONE",
												1.5
											);
										}
										
									break;
									
								case "pets":
									
									var _petSlct = _statMenu.slct;
									
									 // Add Any Pets Found in Stats:
									var	_petStatList = save_get("stat:pet", {}),
										_petListFull = array_clone(_statMenu.list);
										
									for(var i = 0; i < lq_size(_petStatList); i++){
										var _pet = lq_get_key(_petStatList, i);
										if(array_find_index(_petListFull, _pet) < 0){
											var _petStat = lq_defget(_petStatList, _pet, {});
											if(
												lq_size(_petStat) > (lq_exists(_petStat, "found") + lq_exists(_petStat, "owned"))
												|| lq_defget(_petStat, "found", 0) > 0
												|| lq_defget(_petStat, "owned", 0) > 0
											){
												array_push(_petListFull, _pet);
											}
										}
									}
									
									 // Compile Pet List:
									var _petList = {};
									with(_petListFull){
										var	_pet   = self,
											_split = string_split(_pet, ".");
											
										if(array_length(_split) >= 3){
											var	_modName = array_join(array_slice(_split, 1, array_length(_split) - 2), "."),
												_modType = _split[array_length(_split) - 1];
												
											if(mod_exists(_modType, _modName)){
												var	_petStat  = lq_defget(_petStatList, _pet, {}),
													_petAvail = (lq_defget(_petStat, "found", 0) > 0 || lq_defget(_petStat, "owned", 0) > 0);
													
												 // Auto-Select First Unlocked Pet:
												if(_petAvail && _petSlct[_index] == ""){
													_petSlct[_index] = _pet;
												}
												
												 // Add:
												lq_set(_petList, _pet, {
													"name"     : _split[0],
													"mod_name" : array_join(array_slice(_split, 1, array_length(_split) - 2), "."),
													"mod_type" : _split[array_length(_split) - 1],
													"stat"     : _petStat,
													"avail"    : _petAvail
												});
											}
										}
									}
									
									 // Splat:
									var	_x   = _vx + (instance_exists(BackMainMenu) ? -48 : -96),
										_y   = _vy + _gh - 36,
										_spr = sprLoadoutOpen;
										
									draw_sprite_ext(_spr, clamp(_pop - 1, 0, (instance_exists(BackMainMenu) ? 1 : sprite_get_number(_spr) - 1)), _x, _y, -1, (_gh - 72) / (240 - 72), 0, c_white, 1);
									
									 // Icons:
									if(_pop >= 3){
										var	_col = min(4, floor(sqrt(lq_size(_petList)))),
											_w   = 13,
											_h   = 13,
											_x   = _vx + 40 - round(_w * ((_col - 1) / 2)) - (2 * (_pop <= 3)) + (_pop == 4),
											_y   = _vy + 96;
											
										 // Arrow Key Selection:
										var	_swaph = (button_pressed(_index, "east") - button_pressed(_index, "west")),
											_swapv = (button_pressed(_index, "sout") - button_pressed(_index, "nort")) * _col;
											
										if(_swaph != 0 || _swapv != 0){
											 // Get Current Pet Index:
											var _slct = -1;
											for(var i = 0; i < lq_size(_petList); i++){
												if(lq_get_key(_petList, i) == _petSlct[_index]){
													_slct = i;
													break;
												}
											}
											
											 // Swap:
											if(_slct >= 0) while(true){
												var _max = pceil(lq_size(_petList), _col);
												_slct = (_slct + _swaph + _swapv + _max) % _max;
												if(_swapv != 0) _slct = min(_slct, lq_size(_petList) - 1);
												
												 // Back at Start:
												if(lq_get_key(_petList, _slct) == _petSlct[_index]){
													break;
												}
												
												 // New Selection:
												if(lq_defget(lq_get_value(_petList, _slct), "avail", false)){
													_petSlct[_index] = lq_get_key(_petList, _slct);
													
													_pop = 4;
													MenuPop[_index] = _pop;
													sound_play((_slct & 1) ? sndMenuBSkin : sndMenuASkin);
													
													break;
												}
											}
										}
										
										for(var i = 0; i < lq_size(_petList); i++){
											var	_pet      = lq_get_key(_petList, i),
												_info     = lq_get_value(_petList, i),
												_icon     = pet_get_sprite(_info.name, _info.mod_type, _info.mod_name, 0, "icon"),
												_avail    = _info.avail,
												_hover    = false,
												_selected = (_petSlct[_index] == _pet && _avail);
												
											 // Selecting:
											if(!_selected && point_in_rectangle(
												_mx,
												_my,
												_x - 6,
												_y - 6,
												_x + 6,
												_y + 6
											)){
												_hover = true;
												_tooltip = (_avail ? pet_get_name(_info.name, _info.mod_type, _info.mod_name, 0) : "UNKNOWN");
												
												 // Select:
												if(button_pressed(_index, "fire")){
													if(_avail){
														_petSlct[_index] = _pet;
														
														_pop = 4;
														MenuPop[_index] = _pop;
														sound_play((i & 1) ? sndMenuBSkin : sndMenuASkin);
													}
													
													 // No:
													else{
														sound_play(sndNoSelect);
														_selected = true;
													}
												}
											}
											
											if(sprite_exists(_icon)){
												if(!_avail){
													draw_set_fog(true, make_color_hsv(0, 0, 22 * (1 + _hover)), 0, 0);
												}
												
												draw_sprite_ext(_icon, 0.4 * current_frame, _x, _y - _selected, 1, 1, 0, merge_color(c_white, c_black, (_selected || _hover) ? 0 : 0.5), 1);
												
												if(!_avail){
													draw_set_fog(false, 0, 0, 0);
												}
											}
											
											_x += _w;
											if((i % _col) == _col - 1){
												_x -= ceil(_w * (_col - max(0, (_col - ((lq_size(_petList) - 1) - i)) / 2)));
												_y += _h;
											}
										}
									}
									
									var	_pet = lq_get(_petList, _petSlct[_index]);
									
									 // Name:
									var _appear = 5;
									if(_pop >= _appear){
										draw_set_color(c_white);
										draw_set_font(fntBigName);
										draw_set_halign(fa_left);
										draw_set_valign(fa_top);
										draw_text_bn(
											_vx + 28 + (2 * max(0, (_appear + 1) - _pop)),
											_vy + 46,
											((_pet != null) ? (_pet.avail ? pet_get_name(_pet.name, _pet.mod_type, _pet.mod_name, 0) : "UNKNOWN") : "NONE"),
											1.5
										);
									}
									
									 // Get Stats to Display:
									if(_pet != null && _pet.avail){
										var	_stat     = { name: "", list: [] },
											_scrt     = _pet.name + "_stat",
											_statPath = `pet:${_pet.name}.${_pet.mod_name}.${_pet.mod_type}:`;
											
										for(var i = -1; i < lq_size(_pet.stat); i++){
											var	_name  = ((i < 0) ? "" : lq_get_key(_pet.stat, i)),
												_value = lq_get_value(_pet.stat, i),
												_type  = ((_name == "owned") ? stat_time : stat_base);
												
											 // Call Stats Script:
											if(mod_script_exists(_pet.mod_type, _pet.mod_name, _scrt)){
												var _s = mod_script_call(_pet.mod_type, _pet.mod_name, _scrt, _name, _value);
												if(_s != 0){
													if(is_array(_s)){
														if(array_length(_s) > 0){
															_name = _s[0];
														}
														if(array_length(_s) > 1){
															_value = _s[1];
															_type = stat_display;
														}
													}
													else _name = _s;
												}
											}
											if(i < 0 && _name == ""){
												var _spr = pet_get_sprite(_pet.name, _pet.mod_type, _pet.mod_name, 0, "stat");
												if(_spr == 0){
													_spr = pet_get_sprite(_pet.name, _pet.mod_type, _pet.mod_name, 0, "idle");
												}
												if(sprite_exists(_spr)){
													_name = _spr;
												}
											}
											
											if(_name != ""){
												 // Title:
												if(i < 0){
													if(is_real(_name) && sprite_exists(_name)){
														_name = `@(${_name}:-0.4)${chr(13) + chr(10)} `;
													}
													_stat.name = string(_name);
												}
												
												 // Stat:
												else array_push(_stat.list, [
													string(_name),
													((_type == stat_display) ? _value : (_statPath + lq_get_key(_pet.stat, i))),
													_type
												]);
											}
										}
										
										array_push(_statDraw, _stat);
									}
										
									break;
									
								case "unlocks":
									
									var _otherList = _statMenu.list;
									
									 // Splat:
									var	_x   = _vx - 64,
										_y   = _vy + _gh - 36,
										_spr = sprLoadoutOpen;
										
									draw_sprite_ext(_spr, clamp(_pop - 1, 0, sprite_get_number(_spr) - 1), _x, _y, -1, (_gh - 72) / (240 - 72), 0, c_white, 1);
									
									 // Draw Categories:
									var	_appear = 5,
										_sx     = _vx + 6 + (2 * max(0, (_appear + 1) - _pop)),
										_sy     = _vy + 44;
										
									draw_set_halign(fa_left);
									draw_set_valign(fa_top);
									
									with(_otherList){
										 // Name:
										draw_set_font(fntBigName);
										if(_pop >= _appear){
											var _scale = 0.95;
											draw_set_color(c_black);
											draw_text_transformed(_sx + 1, _sy,     name, _scale, _scale, 0);
											draw_text_transformed(_sx,     _sy + 2, name, _scale, _scale, 0);
											draw_text_transformed(_sx + 1, _sy + 2, name, _scale, _scale, 0);
											draw_set_color(c_white);
											draw_text_transformed(_sx,     _sy,     name, _scale, _scale, 0);
										}
										_sy += string_height(name) + 4;
										
										 // Main Drawing:
										switch(name){
											
											case "UNLOCKS":
												
												if(_pop >= _appear){
													draw_set_font(fntM);
													
													var _slct = _statMenu.slct;
													
													 // Auto-Select First Unlocked Pack:
													if(!unlock_get("pack:" + list[_slct[_index]])){
														for(var i = 0; i < array_length(list); i++){
															if(unlock_get("pack:" + list[i])){
																_slct[_index] = i;
																break;
															}
														}
													}
													
													 // Compile Pack Items:
													var _packList = {};
													with(list){
														lq_set(_packList, self, []);
													}
													with(["crown", "weapon"]){
														var _modType = self;
														with(mod_get_names(_modType)){
															var	_modName = self,
																_modScrt = _modType + "_ntte_pack";
																
															if(mod_script_exists(_modType, _modName, _modScrt)){
																switch(_modType){
																	case "weapon":
																		var _pack = mod_script_call_nc(_modType, _modName, _modScrt, _modName);
																		if(is_string(_pack) && _pack in _packList){
																			array_push(
																				lq_get(_packList, _pack),
																				[_modType, _modName, mod_variable_get(_modType, _modName, "sprWep")]
																			);
																		}
																		break;
																		
																	case "crown":
																		var _pack = mod_script_call_nc(_modType, _modName, _modScrt);
																		if(is_string(_pack) && _pack in _packList){
																			array_push(
																				lq_get(_packList, _pack),
																				[_modType, _modName, mod_variable_get(_modType, _modName, "sprCrownIdle")]
																			);
																		}
																		break;
																}
															}
														}
													}
													
													 // Arrow Key Select:
													var	_swap     = (button_pressed(_index, "east") - button_pressed(_index, "west")) + (3 * (button_pressed(_index, "sout") - button_pressed(_index, "nort"))),
														_slctSwap = _slct[_index];
														
													while(_swap != 0){
														_slctSwap = (_slctSwap + _swap + array_length(list)) % array_length(list);
														if(unlock_get("pack:" + list[_slctSwap]) || _slctSwap == _slct[_index]){
															break;
														}
													}
													
													 // Draw Unlock Icons:
													with(UberCont){
														var _ox = 0;
														for(var i = 0; i < lq_size(_packList); i++){
															var	_pack       = lq_get_key(_packList, i),
																_unlockList = lq_get_value(_packList, i),
																_unlockName = "pack:" + _pack,
																_unlocked   = unlock_get(_unlockName),
																_name       = (_unlocked ? unlock_get_name(_unlockName) : "LOCKED"),
																_selected   = (_unlocked && _slct[_index] == i),
																_hover      = false;
																
															if(_selected){
																var	_dx = _sx + 116,
																	_dy = _sy + 8;
																	
																 // Splat:
																var	_spr = sprKilledBySplat,
																	_img = min(_pop - (_appear + 1), sprite_get_number(_spr) - 1);
																	
																if(_img >= 0){
																	draw_sprite(_spr, _img, _dx + 32, _dy - (string_height(_name) / 2));
																}
																
																 // Unlock Icons:
																_dy += 2;
																for(var j = 0; j < array_length(_unlockList); j++){
																	var _unlockAppear = _appear + 2 + j;
																	if(_pop >= _unlockAppear){
																		var	_modType = _unlockList[j, 0],
																			_modName = _unlockList[j, 1],
																			_modIcon = _unlockList[j, 2];
																			
																		if(is_real(_modIcon) && sprite_exists(_modIcon)){
																			var _found = stat_get("found:" + _modName + "." + ((_modType == "weapon") ? "wep" : _modType));
																			
																			 // Animate:
																			var	_num = sprite_get_number(_modIcon),
																				_img = (_found ? ((_pop * 0.4) - (3 * j)) : 0);
																				
																			if(
																				(_img + _num) % ((1 + array_length(_unlockList)) * _num) >= _num
																				||
																				(_modType == "weapon" && _img % _num < 2) // No White Flash
																			){
																				_img = 0;
																			}
																			
																			 // Loop Over:
																			if(_dx + sprite_get_width(_modIcon) > _vx + _gw){
																				_dx = _sx + 124;
																				_dy += 16;
																			}
																			
																			 // Not Found:
																			if(!_found){
																				 // Shadow:
																				draw_set_fog(true, c_black, 0, 0);
																				draw_sprite(
																					_modIcon,
																					_img,
																					_dx + sprite_get_xoffset(_modIcon) - (_pop == _unlockAppear),
																					_dy + 1
																				);
																				
																				 // Draw in Flat Gray:
																				draw_set_fog(true, make_color_hsv(0, 0, 28 + (10 * instance_exists(BackMainMenu))), 0, 0);
																			}
																			
																			 // Icon:
																			draw_sprite(
																				_modIcon,
																				_img,
																				_dx + sprite_get_xoffset(_modIcon) - (_pop == _unlockAppear),
																				_dy
																			);
																			
																			if(!_found){
																				draw_set_fog(false, 0, 0, 0);
																			}
																			
																			_dx += 1 + sprite_get_width(_modIcon);
																		}
																		
																		 // Sound:
																		if(_pop == _unlockAppear){
																			sound_play_pitch(sndAppear, 1 + (j * 0.05));
																		}
																	}
																}
															}
															
															 // Pack Icon:
															var	_spr = lq_defget(spr.UnlockIcon, _pack, -1),
																_img = (_unlocked ? 0 : 1),
																_x   = _sx + 24 + _ox,
																_y   = _sy + 12;
																
															if(point_in_rectangle(_mx + sprite_get_xoffset(_spr), _my + sprite_get_yoffset(_spr), _x, _y, _x + sprite_get_width(_spr), _y + sprite_get_height(_spr))){
																_hover = true;
																
																 // Tooltip:
																//if(!_selected){
																	_tooltip = (_unlocked ? unlock_get_name(_unlockName) : "LOCKED");
																//}
																
																 // Select:
																if(button_pressed(_index, "fire")){
																	_selected = true;
																	
																	if(_unlocked){
																		_slctSwap = i;
																	}
																	
																	 // No:
																	else sound_play(sndNoSelect);
																}
															}
															draw_sprite_ext(_spr, _img, _x, _y - _selected, 1, 1, 0, ((_selected || _hover) ? c_white : c_gray), 1);
															
															 // Next:
															_ox += 24 + 1;
															if(_ox > 60 && i < lq_size(_packList) - 1){
																_ox = 0;
																_sy += 24 + 1;
															}
														}
													}
													
													 // Selection Swapped:
													if(_slctSwap != _slct[_index]){
														_slct[_index] = _slctSwap;
														
														_pop = _appear + 1;
														MenuPop[_index] = _pop;
														sound_play_pitchvol(sndClick, 1 + (0.2 * _slct[_index]), 2/3);
													}
												}
												
												_sy += 16;
												
												break;
												
											case "OTHER":
												
												_statX    = _sx + 44;
												_statY    = _sy;
												_statDraw = {
													"name" : "",
													"list" : ((_pop >= _appear) ? list : [])
												};
												
												break;
												
										}
										
										_sy += 16;
									}
									
									break;
							}
							
							 // Draw Stats:	
							draw_set_font(fntM);
							draw_set_valign(fa_top);
							
							var	_x      = _statX,
								_y      = _statY,
								_appear = 5;
								
							if(is_object(_statDraw)) _statDraw = [_statDraw];
							
							if(array_length(_statDraw)) with(_statDraw){
								if(_pop >= _appear){
									if(_pop == _appear){
										_x--;
									}
									
									 // Category Name:
									draw_set_halign(fa_center);
									draw_text_nt(_x, _y, name);
									_y += string_height(name);
									
									 // Stats:
									with(list){
										var	_name = self[0],
											_stat = self[1],
											_type = self[2];
											
										if(_type != stat_display){
											_stat = stat_get(_stat);
										}
										switch(_type){
											
											case stat_time:
												
												var _t = "";
												_t += string_lpad(string(floor((_stat / power(60, 2))     )), "0", 1); // Hours
												_t += ":";
												_t += string_lpad(string(floor((_stat / power(60, 1)) % 60)), "0", 2); // Minutes
												_t += ":";
												_t += string_lpad(string(floor((_stat / power(60, 0)) % 60)), "0", 2); // Seconds
												_stat = _t;
												
												break;
												
											case stat_area:
												
												var	_area    = _stat,
													_subarea = 1,
													_loops   = 0;
													
												if(is_array(_stat)){
													if(array_length(_stat) > 0){
														_area = _stat[0];
														if(array_length(_stat) > 1){
															_subarea = _stat[1];
															if(array_length(_stat) > 2){
																_loops = _stat[2];
															}
														}
													}
												}
												
												if(!is_string(_area) || mod_exists("area", _area)){
													_stat = area_get_name(_area, _subarea, _loops);
												}
												
												break;
												
										}
										_stat = string(_stat);
										
										draw_set_halign(fa_right);
										draw_text_nt(_x - 1, _y, "@s" + _name);
										
										draw_set_halign(fa_left);
										draw_text_nt(_x + 1, _y, _stat);
										
										_y += max(string_height(_name), string_height(_stat));
									}
									
									_y += string_height(" ");
								}
								_appear += 2;
							}
							
							 // No Stats to Display:
							else if(_pop >= _appear){
								draw_set_halign(fa_center);
								draw_set_valign(fa_middle);
								draw_text_nt(_x - 4 - (_pop == _appear), _vy + (_gh / 2), "@sNOTHING TO# DISPLAY YET!")
							}
							
							break;
							
						case menu_credits:
							
							var _links = _menuSlct[_index];
							
							for(var i = 0; i <= array_length(_menuList); i++){
								var _appear = 1 + floor(i / 2);
								if(_pop >= _appear){
									var	_side = ((i & 1) ? 1 : -1),
										_tx   = _menuX + (_side * 8),
										_ty   = _menuY + (32 * floor(i / 2)) - (_pop == _appear);
										
									draw_set_halign(_side ? fa_left : fa_right);
									draw_set_valign(fa_top);
									
									 // Link Mode Left Align:
									if(_links && !_side){
										_tx -= 128;
										draw_set_halign(fa_left);
									}
									
									 // Draw Credits:
									if(i < array_length(_menuList)){
										 // Name:
										draw_set_font(fntM);
										if(!_links || i < array_length(_menuList) - 1){ // No "Special Thanks" Name for Links
											draw_text_nt(_tx, _ty, _menuList[i].name);
										}
										_ty += string_height(_menuList[i].name);
										
										 // Links:
										if(_links){
											var	_link = _menuList[i].link,
												_font = fntChat;
												
											if(array_length(_link) >= 4) _font = fntSmall;
											
											if(_font == fntChat) _ty -= 3;
											
											draw_set_font(_font);
											
											with(_link){
												var _text = array_join(self, "");
												draw_text_nt(_tx, _ty, _text);
												_ty += string_height(_text) - (4 * (_font == fntChat));
											}
										}
										
										 // Roles:
										else{
											var _text = "";
											with(_menuList[i].role){
												_text += array_join(self, "") + "#@w";
											}
											
											draw_set_font(fntSmall);
											draw_text_nt(_tx, _ty, _text);
										}
									}
									
									 // Links/Roles Button:
									else{
										_tx += 32;
										_ty += 16;
										
										 // Hovering:
										var _hover = false;
										if(point_in_rectangle(
											_mx,
											_my,
											_tx - 32,
											_ty - 20,
											_tx + 32,
											_ty + 20
										)){
											_hover = true;
										}
										
										 // Splat:
										var _spr = sprKilledBySplat;
										draw_sprite(_spr, min(_pop - _appear, sprite_get_number(_spr) - 1), _tx + 4, _ty - 6);
										
										 // Text:
										draw_set_font(fntM);
										draw_set_halign(fa_center);
										draw_set_valign(fa_middle);
										draw_text_nt(_tx - _hover + (!instance_exists(BackMainMenu) && _pop > _appear + 1), _ty, (_hover ? "" : "@s") + (_links ? "Roles" : "Links"));
									}
								}
							}
							
							 // Switch Between Roles/Links:
							if(_pop >= 3){
								if(button_pressed(_index, "fire")){
									_menuSlct[_index] = !_menuSlct[_index];
									sound_play_pitch(sndMenuCredits, (_menuSlct[_index] ? 1.3 : 1));
									MenuPop[_index] = 0;
								}
							}
							
							break;
					}
					
					 // Tooltips:
					if(_local && _tooltip != ""){
						if(mouse_x[player_find_local_nonsync()] != 0 || mouse_y[player_find_local_nonsync()] != 0){ // Gamepad fix
							draw_tooltip(mouse_x_nonsync, mouse_y_nonsync, _tooltip);
						}
					}
					
					MenuSlct[_index] = _menuCurrent;
				}
			}
		}
		
		draw_set_visible_all(true);
		
		if(lag) trace_time("ntte_menu");
	}
	
	 // Closed:
	else{
		 // Reset Menus:
		for(var i = 0; i < maxp; i++){
			MenuSlct[i] = menu_base;
			MenuPop[i] = 0;
		}
		for(var i = 0; i < lq_size(MenuList); i++){
			var o = lq_get_value(MenuList, i);
			
			 // Selection:
			for(var j = 0; j < array_length(o.slct); j++){
				o.slct[j] = o.slct_default;
			}
			
			 // Options Splat:
			if(o == MenuList.options){
				for(var j = 0; j < array_length(o.list); j++){
					o.list[j].splat = 0;
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
#macro  instance_max                                                                            instance_create(0, 0, DramaCamera)
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
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
#define pround(_num, _precision)                                                        return  (_num == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_num == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_num == 0) ? _num :  ceil(_num / _precision) * _precision;
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define lerp_ct(_val1, _val2, _amount)                                                  return  lerp(_val2, _val1, power(1 - _amount, current_time_scale));
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define angle_lerp_ct(_ang1, _ang2, _num)                                               return  _ang2 + (angle_difference(_ang1, _ang2) * power(1 - _num, current_time_scale));
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_dir, _num)                                                                  direction = _dir; walk = _num; if(speed < friction_raw) speed = friction_raw;
#define enemy_face(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1;
#define enemy_look(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1; if('gunangle' in self) gunangle = _dir;
#define enemy_target(_x, _y)                                                                    target = (instance_exists(Player) ? instance_nearest(_x, _y, Player) : ((instance_exists(target) && target >= 0) ? target : noone)); return (target != noone);
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
#define script_bind(_scriptObj, _scriptRef, _depth, _visible)                           return  mod_script_call_nc  ('mod', 'teassets', 'script_bind', script_ref_create(script_bind), _scriptObj, (is_real(_scriptRef) ? script_ref_create(_scriptRef) : _scriptRef), _depth, _visible);
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
#define draw_weapon(_spr, _img, _x, _y, _ang, _angMelee, _kick, _flip, _blend, _alpha)          mod_script_call_nc  ('mod', 'telib', 'draw_weapon', _spr, _img, _x, _y, _ang, _angMelee, _kick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc  ('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_surface_scale(_surf, _x, _y, _scale)                                               mod_script_call_nc  ('mod', 'telib', 'draw_surface_scale', _surf, _x, _y, _scale);
#define array_count(_array, _value)                                                     return  mod_script_call_nc  ('mod', 'telib', 'array_count', _array, _value);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc  ('mod', 'telib', 'array_combine', _array1, _array2);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc  ('mod', 'telib', 'array_delete', _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc  ('mod', 'telib', 'array_delete_value', _array, _value);
#define array_flip(_array)                                                              return  mod_script_call_nc  ('mod', 'telib', 'array_flip', _array);
#define array_shuffle(_array)                                                           return  mod_script_call_nc  ('mod', 'telib', 'array_shuffle', _array);
#define data_clone(_value, _depth)                                                      return  mod_script_call_nc  ('mod', 'telib', 'data_clone', _value, _depth);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc  ('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define enemy_hurt(_damage, _force, _direction)                                                 mod_script_call_self('mod', 'telib', 'enemy_hurt', _damage, _force, _direction);
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
#define player_swap()                                                                   return  mod_script_call_self('mod', 'telib', 'player_swap');
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_wrap(_wep, _scrName, _scrRef)                                               return  mod_script_call_nc  ('mod', 'telib', 'wep_wrap', _wep, _scrName, _scrRef);
#define wep_skin(_wep, _race, _skin)                                                    return  mod_script_call_nc  ('mod', 'telib', 'wep_skin', _wep, _race, _skin);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc  ('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc  ('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call_self('mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define weapon_get(_name, _wep)                                                         return  mod_script_call     ('mod', 'telib', 'weapon_get', _name, _wep);
#define skill_get_icon(_skill)                                                          return  mod_script_call_self('mod', 'telib', 'skill_get_icon', _skill);
#define skill_get_avail(_skill)                                                         return  mod_script_call_self('mod', 'telib', 'skill_get_avail', _skill);
#define string_delete_nt(_string)                                                       return  mod_script_call_nc  ('mod', 'telib', 'string_delete_nt', _string);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc  ('mod', 'telib', 'path_create', _xstart, _ystart, _xtarget, _ytarget, _wall);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc  ('mod', 'telib', 'path_shrink', _path, _wall, _skipMax);
#define path_reaches(_path, _xtarget, _ytarget, _wall)                                  return  mod_script_call_nc  ('mod', 'telib', 'path_reaches', _path, _xtarget, _ytarget, _wall);
#define path_direction(_path, _x, _y, _wall)                                            return  mod_script_call_nc  ('mod', 'telib', 'path_direction', _path, _x, _y, _wall);
#define portal_poof()                                                                   return  mod_script_call_nc  ('mod', 'telib', 'portal_poof');
#define portal_pickups()                                                                return  mod_script_call_nc  ('mod', 'telib', 'portal_pickups');
#define pet_spawn(_x, _y, _name)                                                        return  mod_script_call_nc  ('mod', 'telib', 'pet_spawn', _x, _y, _name);
#define pet_get_name(_name, _modType, _modName, _skin)                                  return  mod_script_call_self('mod', 'telib', 'pet_get_name', _name, _modType, _modName, _skin);
#define pet_get_sprite(_name, _modType, _modName, _skin, _sprName)                      return  mod_script_call_self('mod', 'telib', 'pet_get_sprite', _name, _modType, _modName, _skin, _sprName);
#define pet_set_skin(_skin)                                                             return  mod_script_call_self('mod', 'telib', 'pet_set_skin', _skin);
#define team_get_sprite(_team, _sprite)                                                 return  mod_script_call_nc  ('mod', 'telib', 'team_get_sprite', _team, _sprite);
#define team_instance_sprite(_team, _inst)                                              return  mod_script_call_nc  ('mod', 'telib', 'team_instance_sprite', _team, _inst);
#define sprite_get_team(_sprite)                                                        return  mod_script_call_nc  ('mod', 'telib', 'sprite_get_team', _sprite);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call_self('mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_inst, _charm)                                                   return  mod_script_call_nc  ('mod', 'telib', 'charm_instance', _inst, _charm);
#define motion_step(_mult)                                                              return  mod_script_call_self('mod', 'telib', 'motion_step', _mult);
#define pool(_pool)                                                                     return  mod_script_call_nc  ('mod', 'telib', 'pool', _pool);
#define unlock_get_name(_name)                                                          return  mod_script_call_nc  ('mod', 'telib', 'unlock_get_name', _name);
#define draw_text_bn(_x, _y, _string, _angle)                                                   mod_script_call_nc  ('mod', 'telib', 'draw_text_bn', _x, _y, _string, _angle);