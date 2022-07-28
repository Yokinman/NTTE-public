#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep = sprite_add_weapon("../sprites/weps/sprSuperTeleportGun.png", 6, 8);
	
	 // LWO:
	global.lwoWep = {
		"wep"      : mod_current,
		"inst"     : [],
		"gunangle" : 0
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name   return "SUPER TELEPORT GUN";
#define weapon_text   return "POSITION INDETERMINABLE";
#define weapon_sprt   return global.sprWep;
#define weapon_type   return type_melee;
#define weapon_load   return 45; // 1.5 Seconds
#define weapon_auto   return true;
#define weapon_melee  return false;

#define weapon_swap
	sound_play(sndCrystalTB);
	return sndSwapShotgun;
	
#define weapon_area
	 // Cursed Chest Exclusive:
	if(("curse" in self && curse > 0) || ("curse" in other && other.curse > 0)){
		return 13; // 5-2
	}
	
	return -1;
	
#define weapon_ntte_eat
	 // Unleash da Portal:
	if(!instance_is(self, Portal)){
		with(call(scr.projectile_create, x, y, "PortalBullet", random(360), 20)){
			event_perform(ev_other, ev_animation_end);
			move_contact_solid(direction, random_range(32, 160));
			instance_destroy();
		}
		
		 // Effects:
		view_shake_at(x, y, 30);
		sound_play_pitch(sndGuardianDead, 0.6);
	}
	
#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	 // Portal Bullets:
	var _num = 4;
	for(var _off = -1; _off <= 1; _off += 2 / (_num - 1)){
		with(call(scr.projectile_create, x, y, "PortalBullet", gunangle + (15 * _off * accuracy), random_range(11, 13))){
			mask    = mskPlasma;
			damage  = 25;
			spec    = _fire.spec;
			primary = _fire.primary;
			offset  = 20 - (2 * abs(_off));
			
			 // Remember Me:
			array_push(_wep.inst, self);
		}
	}
	_wep.gunangle = gunangle;
	
	 // Sound:
	sound_play_hit(sndGuardianAppear, 0.2);
	var _snd = sound_play_hit(sndCrystalJuggernaut, 0);
	audio_sound_pitch(_snd, 1.2 + random(0.2));
	audio_sound_gain(_snd, 1.3 * audio_sound_get_gain(_snd), 0);
	var _snd = sound_play_gun(sndCrystalTB, 0, -0.5);
	audio_sound_pitch(_snd, 0.4 + random(0.2));
	audio_sound_gain(_snd, 1.5 * audio_sound_get_gain(_snd), 0);
	
	 // Effects:
	weapon_post(6, -12, 8);
	
	
#define step(_primary)
	var _wep = call(scr.weapon_step_init, _primary);
	
	 // Portal Bullet Control:
	_wep.inst = instances_matching_ne(_wep.inst, "id");
	if(array_length(_wep.inst)){
		 // Dynamic Reload:
		wep_set(_primary, "reload",    max(wep_get(_primary, "reload", 0), weapon_get_load(_wep)));
		wep_set(_primary, "can_shoot", false);
		
		 // Aiming:
		if(gunangle != _wep.gunangle){
			var _turn = angle_difference(gunangle, _wep.gunangle);
			with(_wep.inst){
				if(hold){
					direction   += _turn;
					image_angle += _turn;
				}
			}
		}
	}
	_wep.gunangle = gunangle;
	
	
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