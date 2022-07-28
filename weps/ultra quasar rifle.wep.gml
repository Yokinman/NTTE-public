#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Sprites:
	global.sprWep       = spr.UltraQuasarBlaster; // sprite_add_weapon("../sprites/weps/sprUltraQuasarBlaster.png", 20, 12);
	global.sprWepLocked = sprTemp;
	
	 // LWO:
	global.lwoWep = {
		"wep"  : mod_current,
		"beam" : noone
	};
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#define weapon_name         return (weapon_avail() ? "ULTRA QUASAR RIFLE" : "LOCKED");
#define weapon_text         return choose("THE GREEN SUN", "ROCKET POWERED RECOIL DAMPENING");
#define weapon_swap         return sndSwapEnergy;
#define weapon_sprt         return (weapon_avail() ? global.sprWep : global.sprWepLocked);
#define weapon_type         return type_energy;
#define weapon_cost(_wep)   return 6;
#define weapon_rads(_wep)   return 50;
#define weapon_load(_wep)   return 30; // 1 Second
#define weapon_auto         return true;
#define weapon_avail        return call(scr.unlock_get, "race:beetle");
#define weapon_ntte_pack    return (weapon_avail() ? "trench" : undefined);
#define weapon_ntte_quasar  return true;

#define weapon_area
	/*
		Ultra quasar rifle can only spawn from a level's initial weapon chests
	*/
	
	if(
		"ntte_can_spawn_ultra_quasar_rifle" in GameCont
		&& GameCont.ntte_can_spawn_ultra_quasar_rifle
		&& weapon_avail()
	){
		return 21; // L1 2-1
	}
	
	return -1;

#define weapon_ntte_eat(_wep)
	if(!instance_is(self, Portal)){
		
		 // I guess robots really can eat anything, wow:
		with(call(scr.projectile_create, x, y, "QuasarRing", gunangle)){
			image_yscale   = 0;
			sprite_index   = spr.UltraQuasarBeam;
			spr_trail	   = spr.UltraQuasarBeamTrail;
			follow_creator = true;
			ultra		   = true;
			scale_goal     = max(0.3, variable_instance_get(lq_defget(_wep, "beam", noone), "scale_goal", 0));
			ring_size      = 1.2 * power(1.2, skill_get(mut_throne_butt));
			shrink_delay   = 300;
		}
		
		 // Debris:
		var _spr = spr.UltraQuasarBlasterEat;
		for(var _img = 0; _img < sprite_get_number(_spr); _img++){
			with(instance_create(x, y, ScrapBossCorpse)){
				motion_set(random(360), 4 + random(4));
				sprite_index = _spr;
				image_index  = _img;
				image_angle  = random(360);
			}
		}
		
		 // Clear Walls:
		with(instance_create(x, y, PortalClear)){
			image_xscale = 2;
			image_yscale = image_xscale;
		}
		
		 // Sounds:
		sound_play_pitch(sndUltraLaserUpg, 0.4 + random(0.1));
		sound_play_pitch(sndPlasmaHugeUpg, 1.2 + random(0.2));
		sound_play(sndMutant8Thrn);
	}

#define weapon_fire(_wep)
	var _fire = call(scr.weapon_fire_init, _wep);
	_wep = _fire.wep;
	
	// var o = 30 * accuracy;
	// for(var i = -2; i <= 2; i++){
	// 	var d = gunangle + (o * i);
	// 	with(call(scr.projectile_create, x, y, "UltraQuasarBeam", d)){
	// 		image_yscale = 0;
	// 		scale_goal   = 0.8;
	// 		offset_dis   = 16;
	// 		offset_ang   = angle_difference(other.gunangle, d);
	// 		shrink_delay = 30;
	// 	}
	// }
	
	 // New Beam:
	if(!instance_exists(_wep.beam) || _wep.beam.creator != _fire.creator || (_fire.spec && _fire.primary)){
		with(call(scr.projectile_create, x, y, "UltraQuasarBeam", gunangle)){
		//	image_xscale = 0;
			image_yscale = 0;
			offset_dis   = 32;
		//	shrink_delay = 30;
		//	line_dis_max = 0;
		//	turn_factor  = 1/100;
			scale_goal   = 0.3 + (0.1 * skill_get(mut_laser_brain));
			_wep.beam = self;
		}
		
		 // Sound:
		var _brain = skill_get(mut_laser_brain);
		sound_play_pitch((_brain ? sndUltraLaserUpg : sndUltraLaser), 0.4 + random(0.1));
		sound_play_pitch((_brain ? sndPlasmaUpg     : sndPlasma),     1.2 + random(0.2));
	//	sound_play_pitchvol(sndExplosion, 1.5, 0.5);
		
		 // Effects:
		weapon_post(16, -16, 32);
		motion_add(gunangle + 180, 4);
		move_contact_solid(gunangle + 180, 4);
	}
	
	 // Charge Beam:
	else with(_wep.beam){
		var _scaleAdd = 1/15;
		scale_goal  = max(0.3, (floor((image_yscale / power(1.2, skill_get(mut_laser_brain))) / _scaleAdd) + global.epsilon + 1) * _scaleAdd);
		flash_frame = max(flash_frame, current_frame + 3);
		with(other){
			motion_add(gunangle + 180, 2);
		}
	}
	
	 // Keep Setting:
	with(_wep.beam){
		shrink_delay = weapon_get_load(_wep) + 1;
		primary      = _fire.primary;
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