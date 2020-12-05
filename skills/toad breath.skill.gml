#define init
	 // Sprites:
	global.sprSkillHUD  = sprite_add("../sprites/skills/Toad Breath/sprToadBreathHUD.png",  1,  8,  8);
	
#define skill_name   return "TOAD BREATH";
#define skill_text   return "@wIMMUNITY @sTO @gTOXIC GAS"; // #@sTOXIC GAS @wHEALS" // maybe??;
#define skill_tip    return "CORROSION";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;

#define step
	if(instance_exists(Player)){
		with(Player){
			notoxic = true;
			
			 // Push Toxic Gas:
			if(instance_exists(ToxicGas) && place_meeting(x, y, ToxicGas)){
				
				var _inst = instances_meeting(x, y, ToxicGas);
				if(array_length(_inst) > 0){
					
					with(_inst) if(place_meeting(x, y, other)){
						if(x != xstart && y != ystart){
							var _maxSpeed = max(other.speed, speed);
							
							motion_add_ct(
								lerp(point_direction(other.x, other.y, x, y), other.direction, 3/4),
								lerp(speed, other.speed, 1/3) * random_range(1/3, 2/3)
							);
							
							if(speed > _maxSpeed){
								speed = _maxSpeed;
							}
						}
					}
				}
			}
			
			 // Effects:
			if(chance_ct(1, 150)){
				with(instance_create(x, y, Breath)){
					image_alpha  = 1;
					image_blend  = make_color_rgb(108, 195, 4);
					image_xscale = other.right;
				}
			}
		}
	}
	
#define skill_lose
	with(Player){
		
		 // Probably a terrible way to do this but:
		if(race != "frog"){
			notoxic = false;
		}
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call_self('mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc  ('mod', 'telib', 'sleep_max', _milliseconds);