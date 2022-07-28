#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep            = spr.TeleportGun;
	global.sprWepGold        = spr.GoldTeleportGun
	global.sprWepLoadout     = spr.TeleportGunLoadout;
	global.sprWepGoldLoadout = spr.GoldTeleportGunLoadout;
	
	 // LWO:
	global.lwoWep = {
		"wep"      : mod_current,
		"gold"     : false,
		"inst"     : [],
		"gunangle" : 0
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name(_wep)     return ((weapon_gold(_wep) != 0) ? "GOLDEN " : "") + "TELEPORT GUN";
#define weapon_text(_wep)     return ((weapon_gold(_wep) != 0) ? "LUXURY TRAVEL" : "DON'T BLINK");
#define weapon_sprt(_wep)     return ((weapon_gold(_wep) == 0) ? global.sprWep : global.sprWepGold);
#define weapon_loadout(_wep)  return ((argument_count > 0 && weapon_gold(_wep) != 0) ? global.sprWepGoldLoadout : global.sprWepLoadout);
#define weapon_area(_wep)     return ((argument_count > 0 && weapon_gold(_wep) == 0) ? 7 : -1); // 3-2
#define weapon_gold(_wep)     return ((argument_count > 0 && lq_defget(_wep, "gold", false)) ? -1 : 0);
#define weapon_type           return type_melee;
#define weapon_load           return 10; // 0.33 Seconds
#define weapon_auto           return true;
#define weapon_melee          return false;

#define weapon_swap
	sound_play(sndCrystalTB);
	return sndSwapShotgun;
	
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
	
	 // Portal Bullet:
	with(call(scr.projectile_create, x, y, "PortalBullet", gunangle, random_range(11, 13))){
		mask    = mskPlasma;
		damage  = 25;
		spec    = _fire.spec;
		primary = _fire.primary;
		
		 // Fire Faster:
		if(_wep.gold){
			image_index += 2;
		}
		
		 // Remember Me:
		array_push(_wep.inst, self);
	}
	_wep.gunangle = gunangle;
	
	 // Sound:
	sound_play_hit(sndGuardianAppear, 0.2);
	var _snd = sound_play_hit(sndClick, 0);
	audio_sound_pitch(_snd, 1.5);
	audio_sound_gain(_snd, 0.7 * audio_sound_get_gain(_snd), 0);
	var _snd = sound_play_gun(sndCrystalTB, 0, 0.5);
	audio_sound_pitch(_snd, 0.6 + random(0.2));
	audio_sound_gain(_snd, 1.5 * audio_sound_get_gain(_snd), 0);
	if(_wep.gold){
		sound_play_pitchvol(sndSwapGold, 0.8 + random(0.2), 1.7);
	}
	
	 // Effects:
	weapon_post(5, -5, 2);
	
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