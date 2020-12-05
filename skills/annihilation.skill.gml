#define init
	 // Sprites:
	global.sprSkillHUD = sprite_add("../sprites/skills/Annihilation/sprSkillAnnihilationHUD.png", 1, 9, 9);
	
#macro annihilation_list variable_instance_get(GameCont, "annihilation_list", [])

#define skill_name   return "ANNIHILATION";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;

#define skill_text
	var	_text = `@(color:${area_get_back_color("red")})DESTROY`,
		_list = [];
		
	 // Get Annihilated Enemies:
	with(annihilation_list){
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
		_text += array_join(_list, ((_max > 2) ? "," : "")) + "#@s";
		
		 // Duration:
		var _num = skill_get(mod_current);
		if(_num > 2){
			_text += `FOR THE NEXT @w${_num - 1} LEVELS`;
		}
		else if(_num > 1){
			_text += "THROUGH THE @wNEXT LEVEL";
		}
		else{
			_text += "UNTIL THE @wNEXT LEVEL";
		}
	}
	
	return _text;
	
#define skill_tip
	var _text = choose("GOODBYE", "SO LONG", "FAREWELL");
	
	if(array_length(annihilation_list) > 0){
		_text += ", " + `@(color:${area_get_back_color("red")})` + annihilation_list[irandom(array_length(annihilation_list) - 1)].text;
	}
	
	return _text;
	
#define skill_lose
	GameCont.annihilation_list = [];
	
#define step
	 // Reduce Counters Between Levels:
	if(instance_exists(GenCont)){
		var _inst = instances_matching(GenCont, "annihilation_check", null);
		if(array_length(_inst)) with(_inst){
			annihilation_check = true;
			
			var _num = 0;
			
			with(annihilation_list){
				if(ammo > 0 && --ammo <= 0){
					GameCont.annihilation_list = mod_script_call_nc("mod", "telib", "array_delete_value", annihilation_list, self);
				}
				_num = max(_num, ammo);
			}
			
			if(skill_get(mod_current) > 0){
				skill_set(mod_current, max(0, _num));
			}
		}
	}
	
	 // Kill:
	var _list = annihilation_list
	if(array_length(_list)) with(_list){
		with(instances_matching((custom ? instances_matching(object_index, "name", name) : object_index), "annihilation_check", null)){
			annihilation_check = true;
			
			 // Freeze:
			sleep_max(50);
			
			 // Less Rads:
			if("raddrop" in self){
				raddrop = round(raddrop / 2);
			}
			
			 // Annihilate:
			with(obj_create(x + orandom(1), y + orandom(1), "RedExplosion")){
				target = other;
				other.nexthurt = 0;
				damage = min(damage, max(10, other.my_health));
				event_perform(ev_collision, other.object_index);
			}
		}
	}
	
#define enemy_annihilate(_inst, _num)
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
			"text"         : string_plural(string_replace_all(string_lower(instance_get_name(self)), "@q", "")),
			"ammo"         : _num
		}){
			var _add = true;
				
			 // Update Old Entries:
			with(annihilation_list){
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
				array_push(annihilation_list, self);
			}
		}
		
		 // Effects:
		if(_canFX){
			_canFX = false;
			
			 // Text:
			with(instance_create(x, y - 8, PopupText)){
				text = `${instance_get_name(other)}# @(color:${area_get_back_color("red")})ANNIHILATED!`;
			}
			
			 // Sound:
			sound_play_pitchvol(sndNothingSmallball, random_range(0.4, 0.6), 1.5);
			sound_play_pitchvol(sndNothingLowHP,     random_range(3.0, 4.0), 0.4);
		}
	}
	
	 // Activate:
	if(skill_get(mod_current) >= 0 && skill_get(mod_current) < _num){
		skill_set(mod_current, _num);
	}
	
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
#macro  infinity																				1/0
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(n)                                                                      return  random_range(-n, n);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define area_get_back_color(_area)                                                      return  mod_script_call_nc('mod', 'telib', 'area_get_back_color', _area);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc('mod', 'telib', 'sleep_max', _milliseconds);
#define instance_get_name(_inst)                                                        return  mod_script_call_nc('mod', 'telib', 'instance_get_name', _inst);