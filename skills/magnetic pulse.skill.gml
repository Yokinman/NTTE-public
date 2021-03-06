#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprSkillHUD  = sprite_add("../sprites/skills/Magnetic Pulse/sprMagneticPulseHUD.png",  1,  8,  8);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define skill_name   return "MAGNETIC PULSE";
#define skill_text   return "@bIDPD @sHAVE @wHALF HEALTH";
#define skill_tip    return "SHORT CIRCUIT";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;

#define step
	if(instance_exists(enemy)){
		var _inst = instances_matching(enemy, "team", 3);
		if(array_length(_inst) > 0){
			with(_inst){
				if(my_health <= maxhealth / 2){
					my_health = 0;
				}
			}
		}
	}
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));