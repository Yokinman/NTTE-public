#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Store Script References:
	with([enemy_annihilate, string_plural]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // Sprites:
	global.sprSkillHUD = sprite_add("../sprites/skills/Annihilation/sprSkillAnnihilationHUD.png", 1, 8, 8);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define skill_name   return "ANNIHILATION";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;

#define skill_text
	var _text = `@(color:${call(scr.area_get_back_color, "red")})DESTROY`;
	
	if("annihilation_list" in GameCont){
		var _list = [];
		
		 // Get Annihilated Enemies:
		with(GameCont.annihilation_list){
			array_push(_list, " @w" + string_upper(text));
		}
		
		 // Compile Text:
		var _max = array_length(_list);
		if(_max > 0){
			_text += "S @sALL";
			
			 // Enemy List:
			if(_max > 1){
				_list[_max - 1] = " @sAND" + _list[_max - 1];
				if(_max == 2){
					_text += "#";
				}
				else for(var i = 1; i < _max; i += 2){
					_list[i] = "#" + _list[i];
				}
			}
			_text += array_join(_list, ((_max > 2) ? "," : ""));
			
			 // Duration:
			if("annihilation_skill" in GameCont){
				with(GameCont.annihilation_skill){
					_text += "#@s";
					if(time > 2){
						_text += `FOR THE NEXT @w${time - 1} LEVELS`;
					}
					else if(time > 1){
						_text += "THROUGH THE @wNEXT LEVEL";
					}
					else{
						_text += "UNTIL THE @wNEXT LEVEL";
					}
				}
			}
		}
	}
	
	return _text;
	
#define skill_tip
	var _text = choose("GOODBYE", "SO LONG", "FAREWELL");
	
	if("annihilation_list" in GameCont){
		var _list = GameCont.annihilation_list;
		if(array_length(_list)){
			_text += ", " + `@(color:${call(scr.area_get_back_color, "red")})` + _list[irandom(array_length(_list) - 1)].text;
		}
	}
	
	return _text;
	
#define skill_lose
	if("annihilation_list" in GameCont){
		GameCont.annihilation_list = [];
	}
	
#define step
	 // Kill:
	if("annihilation_list" in GameCont && array_length(GameCont.annihilation_list)){
		with(GameCont.annihilation_list){
			with(instances_matching((custom ? instances_matching(object_index, "name", name) : object_index), "annihilation_check", null)){
				annihilation_check = true;
				
				 // Freeze:
				call(scr.sleep_max, 50);
				
				 // Less Rads:
				if("raddrop" in self){
					raddrop -= ceil(raddrop / 2);
				}
				
				 // Annihilate:
				with(call(scr.obj_create, x + orandom(1), y + orandom(1), "RedExplosion")){
					target = other;
					damage = min(damage, max(10, other.my_health));
					if(team == other.team){
						team = -1;
					}
					
					 // Insta-Hit:
					other.nexthurt = 0;
					event_perform(ev_collision, other.object_index);
					
					 // Player Safety:
					if(instance_is(other, Player)){
						other.nexthurt = current_frame + 30;
					}
				}
			}
		}
	}
	
#define enemy_annihilate(_inst, _time)
	/*
		Kills a given enemy for a given numbers of levels, only takes an instance argument right now
	*/
	
	if("annihilation_list" not in GameCont){
		GameCont.annihilation_list = [];
	}
	
	 // Add Enemy Info to List:
	var _canFX = true;
	with(_inst){
		with({
			"object_index" : object_index,
			"custom"       : (string_pos("Custom", object_get_name(object_index)) == 1),
			"name"         : variable_instance_get(self, "name"),
			"text"         : string_plural(string_replace_all(string_lower(call(scr.instance_get_name, self)), "@q", "")),
			"ammo"         : _time
		}){
			var _add = true;
			
			 // Update Old Entries:
			with(GameCont.annihilation_list){
				if(object_index == other.object_index && name == other.name){
					if(other.ammo > ammo){
						text = other.text;
						ammo = other.ammo;
					}
					_add = false;
				}
			}
			
			 // Reset:
			with(instances_matching_ne((custom ? instances_matching(object_index, "name", name) : object_index), "annihilation_check", null)){
				if(annihilation_check){
					annihilation_check = null;
				}
			}
			
			 // Add:
			if(_add){
				array_push(GameCont.annihilation_list, self);
			}
		}
		
		 // Effects:
		if(_canFX){
			_canFX = false;
			
			 // Text:
			with(instance_create(x, y - 8, PopupText)){
				text = call(scr.loc_format,
					"NTTE:Annihilation:Text",
					`%# @(color:${call(scr.area_get_back_color, "red")})ANNIHILATED!`,
					(("race" in other) ? call(scr.race_get_title, other.race) : call(scr.instance_get_name, other))
				);
			}
			
			 // Sound:
			sound_play_pitchvol(sndNothingSmallball, random_range(0.4, 0.6), 1.5);
			sound_play_pitchvol(sndNothingLowHP,     random_range(3.0, 4.0), 0.4);
		}
	}
	
	 // Activate / Refresh:
	if("annihilation_skill" not in GameCont || !instance_exists(GameCont.annihilation_skill)){
		GameCont.annihilation_skill = call(scr.obj_create, 0, 0, "OrchidSkill");
		with(GameCont.annihilation_skill){
			skill  = mod_current;
			type   = "portal";
			time   = _time;
			color1 = call(scr.area_get_back_color, "red");
			color2 = make_color_rgb(48, 40, 68);
			with(self){
				event_perform(ev_step, ev_step_normal);
			}
		}
	}
	else with(GameCont.annihilation_skill){
		time       = max(time,     _time);
		time_max   = max(time_max, _time);
		flash      = 3;
		star_scale = 4/5;
	}
	
	 // Kill These Dudes:
	step();
	
#define string_plural(_string)
	/*
		Returns the plural form of the given string, assuming that it ends with a singular noun
		Doesn't support wild stuff like 'person/people' cause english sucks wtf
	*/
	
	var _length = string_length(_string);
	
	if(_length > 0){
		var _lower = string_lower(_string);
		
		 // Wacky Exceptions:
		with(["deer", "fish", "sheep"]){
			if(string_delete(_lower, 1, string_length(_lower) - string_length(self)) == self){
				return _string;
			}
		}
		
		 // Pluralize:
		var _char  = string_char_at(_lower, _length);
		switch(_char){
			case "s":
			case "x":
			case "z":
			case "h":
				if(_char != "h" || array_find_index(["c", "s"], string_char_at(_lower, _length - 1)) >= 0){
					_string += "e";
				}
				break;
				
			case "y":
			case "o":
				if(array_find_index(["a", "e", "i", "o", "u"], string_char_at(_lower, _length - 1)) < 0){
					if(_char == "y"){
						_string = string_copy(_string, 1, _length - 1) + "i";
					}
					_string += "e";
				}
				break;
				
			case "f":
				if(string_char_at(_lower, _length - 1) == "l"){
					_string = string_copy(_string, 1, _length - 1) + "ve";
				}
				break;
				
			case "e":
				if(
					string_char_at(_lower, _length - 2) == "i" &&
					string_char_at(_lower, _length - 1) == "f"
				){
					_string = string_copy(_string, 1, _length - 2) + "ve";
				}
				break;
		}
		_string += "s";
	}
	
	return _string;
	
	
/// SCRIPTS
#macro  call                                                                                    script_ref_call
#macro  obj                                                                                     global.obj
#macro  scr                                                                                     global.scr
#macro  spr                                                                                     global.spr
#macro  snd                                                                                     global.snd
#macro  msk                                                                                     spr.msk
#macro  mus                                                                                     snd.mus
#macro  lag                                                                                     global.debug_lag
#macro  ntte                                                                                    global.ntte_vars
#macro  current_frame_active                                                                    ((current_frame + global.epsilon) % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);