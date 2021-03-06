#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = spr.ClamShieldWep;
	global.sprWepHUD    = sprite_add_weapon("../sprites/weps/sprClamShieldHUD.png", 0, 6);
	global.sprWepLocked = sprTemp;
	
	 // LWO:
	global.lwoWep = {
		"wep"  : mod_current,
		"inst" : noone
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#define weapon_name        return (weapon_avail() ? "CLAM SHIELD" : "LOCKED");
#define weapon_text        return "ROYAL GUARD";
#define weapon_swap        return sndSwapHammer;
#define weapon_sprt(_wep)  return (weapon_avail() ? ((instance_is(self, hitme) && instance_exists(lq_defget(_wep, "inst", noone))) ? mskNone : global.sprWep) : global.sprWepLocked);
#define weapon_sprt_hud    return global.sprWepHUD;
#define weapon_area        return (weapon_avail() ? 6 : -1); // 3-1
#define weapon_type        return type_melee;
#define weapon_load        return 30; // 1 Second
#define weapon_auto        return false;
#define weapon_melee       return true;
#define weapon_avail       return unlock_get("pack:" + weapon_ntte_pack());
#define weapon_ntte_pack   return "coast";

#define weapon_fire(_wep)
	var _fire = weapon_fire_init(_wep);
	_wep = _fire.wep;
	
	 // Create Shield:
	if(!instance_exists(_wep.inst)){
		_wep.inst = projectile_create(x, y, "ClamShield", gunangle, 0);
		with(_wep.inst){
			wep = _wep;
		}
	}
	
	 // Shield Bash:
	var	_ox = 0,
		_oy = 0;
		
	if(instance_exists(_fire.creator)){
		_ox = _fire.creator.hspeed_raw;
		_oy = _fire.creator.vspeed_raw;
	}
	
	with(instances_matching(instances_matching(CustomSlash, "name", "ClamShield"), "wep", _wep)){
		var	_l = lerp(8, 14, skill_get(mut_long_arms)),
			_d = image_angle,
			_x = x + _ox + lengthdir_x(_l, _d),
			_y = y + _oy + lengthdir_y(_l, _d);
			
		with(other){
			 // Slash:
			projectile_create(_x, _y, "ClamShieldSlash", _d, lerp(2, 4.5, skill_get(mut_long_arms)));
			
			 // Sounds:
			var _pitch = 1 + orandom(0.2);
			sound_play_pitchvol(sndCrystalJuggernaut,	_pitch * 0.7, 0.7);
			sound_play_pitchvol(sndOasisExplosionSmall,	_pitch * 2.0, 0.7);
			sound_play_pitchvol(sndOasisExplosion,		_pitch * 4.0, 0.7);
			sound_play_pitch(sndOasisMelee,				_pitch);
			sound_play_pitch(sndHammer,					_pitch);
			
			 // Effects:
			repeat(2){
				with(instance_create(_x + orandom(2), _y + orandom(2), Dust)){
					speed += 2;
				}
			}
			weapon_post(-(4 + _l), 12, 0);
			motion_add(_d, 2);
			sleep(40);
		}
	}
	
#define step(_primary)
	var _wep = wep_get(_primary, "wep", mod_current);
	
	 // LWO Setup:
	if(!is_object(_wep)){
		_wep = { "wep" : _wep };
		wep_set(_primary, "wep", _wep);
	}
	for(var i = lq_size(global.lwoWep) - 1; i >= 0; i--){
		var _key = lq_get_key(global.lwoWep, i);
		if(_key not in _wep){
			lq_set(_wep, _key, lq_get_value(global.lwoWep, i));
		}
	}
	
	 // Create Shield:
	if(_primary || race == "steroids"){
		if(!instance_exists(_wep.inst)){
			_wep.inst = projectile_create(x, y, "ClamShield", gunangle, 0);
			with(_wep.inst){
				wep = _wep;
			}
		}
	}
	else if(instance_exists(CustomSlash)){
		var _inst = instances_matching(instances_matching(CustomSlash, "name", "ClamShield"), "wep", _wep);
		if(array_length(_inst)) with(_inst){
			instance_destroy();
		}
	}
	
	
/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define projectile_create(_x, _y, _obj, _dir, _spd)                                     return  mod_script_call_self('mod', 'telib', 'projectile_create', _x, _y, _obj, _dir, _spd);
#define weapon_fire_init(_wep)                                                          return  mod_script_call     ('mod', 'telib', 'weapon_fire_init', _wep);
#define weapon_ammo_fire(_wep)                                                          return  mod_script_call     ('mod', 'telib', 'weapon_ammo_fire', _wep);
#define weapon_ammo_hud(_wep)                                                           return  mod_script_call     ('mod', 'telib', 'weapon_ammo_hud', _wep);
#define weapon_get(_name, _wep)                                                         return  mod_script_call     ('mod', 'telib', 'weapon_get', _name, _wep);
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);