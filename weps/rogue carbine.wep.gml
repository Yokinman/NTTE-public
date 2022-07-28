#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprRogueCarbine.png", 8, 3);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr

#define weapon_name        return "ROGUE CARBINE";
#define weapon_text        return "THERE'S NO TALKING TO THEM";
#define weapon_swap        return sndSwapMachinegun;
#define weapon_sprt        return global.sprWep;
#define weapon_area        return -1; // Don't Spawn
#define weapon_type        return type_bullet;
#define weapon_cost        return 4;
#define weapon_load        return 5; // 0.37 Seconds
#define weapon_burst       return 2;
#define weapon_burst_time  return 2; // 0.07 Seconds

#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Burst Fire:
	with(call(scr.projectile_create, x, y, "CustomBullet", gunangle + orandom(4 * accuracy), 16)){
		 // Visual:
		sprite_index = spr.IDPDHeavyBullet;
		spr_dead     = spr.IDPDHeavyBulletHit;
		
		 // Vars:
		damage = 7;
		force  = 12;
		gland  = weapon_get_cost(_wep) / call(scr.weapon_get, "burst", _wep);
		
		 // Merged Weapons Support:
		temerge_object = HeavyBullet;
	}
	
	 // Sounds:
	audio_sound_pitch(sound_play_gun(sndHeavyMachinegun, 0, 0.3), 1.4 + random(0.2));
	audio_sound_pitch(sound_play_gun(sndRogueRifle,      0, 0.3), 0.6 + random(0.5));
	audio_sound_pitch(sound_play_gun(sndGruntFire,       0, 0.3), 0.6 + random(0.2));
	audio_sound_pitch(sound_play_gun(sndIDPDNadeLoad,    0, 0.3), 2.4 + random(0.4));
	
	 // Effects:
	weapon_post(5, -7, 2);
	with(instance_create(x, y, Shell)) {
		sprite_index = sprHeavyShell;
		motion_add(other.gunangle + 180 + orandom(25), 2 + random(3));
	}
	
	
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
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  current_frame_active                                                                    ((current_frame + global.epsilon) % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define wep_get(_primary, _name, _default)                                              return  variable_instance_get(self, (_primary ? '' : 'b') + _name, _default);
#define wep_set(_primary, _name, _value)                                                        if(((_primary ? '' : 'b') + _name) in self) variable_instance_set(self, (_primary ? '' : 'b') + _name, _value);