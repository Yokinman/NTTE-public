#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	
	 // Sprites:
	global.sprSkillHUD  = sprite_add("../sprites/skills/Lead Ribs/sprLeadRibsHUD.png",  1,  8,  8);
	
	/*
	global.minID = GameObject.id;
	*/
	
#macro spr global.spr

#define skill_name   return "LEAD RIBS";
#define skill_text   return "@sMORE @gRADS @sFROM @wENEMIES";
#define skill_tip    return "HIGHER THRESHOLD";
#define skill_icon   return global.sprSkillHUD;
#define skill_avail  return false;
	
/*#define skill_take
	global.minID = GameObject.id;*/
	
#define step
	 // More Rads!!!!!
	if(instance_exists(enemy)){
		var _inst = instances_matching(instances_matching_le(enemy, "my_health", 0), "leadribs_check", null);
		if(array_length(_inst)) with(_inst){
			leadribs_check = true;
			with(rad_drop(x, y, ceil(raddrop * 0.2 * skill_get(mod_current)), direction, speed / 4)){
				sprite_index = (instance_is(id, BigRad) ? spr.BigRadUpg : spr.RadUpg);
			}
		}
	}

	/*
	if(instance_exists(Rad) || instance_exists(BigRad)){
		var _inst = instances_matching_gt([Rad, BigRad], "id", global.minID);
		if(array_length(_inst) > 0){
			var _skill = skill_get(mod_current);
			with(_inst){
				
				 // 10x Support:
				if(chance(1, power(5, (1 / _skill)))){
					rad *= 2;
					sprite_index = (
						instance_is(id, BigRad)
						? spr.BigRadUpg
						: spr.RadUpg
					);
				}
			}
		}
	}
	
	 // Keep Up:
	global.minID = GameObject.id;
	*/
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc  ('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);