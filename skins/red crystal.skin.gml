#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "crystal";
#define skin_name      return ((argument_count <= 0 || argument0) ? "RED" : skin_lock());
#define skin_lock      return "REACH "        + call(scr.area_get_name, "red", 1, 0);
#define skin_unlock    return "FOR REACHING " + call(scr.area_get_name, "red", 1, 0);
#define skin_ttip      return choose("NEVER MORE ALIVE", "FAMILY CAN WAIT");
#define skin_avail     return call(scr.unlock_get, "skin:" + mod_current);
#define skin_portrait  return skin_sprite(sprBigPortrait);
#define skin_mapicon   return skin_sprite(sprMapIcon);

#define skin_button
	sprite_index = skin_sprite(sprLoadoutSkin);
	image_index  = !skin_avail();
	
#define skin_sprite(_spr)
	switch(_spr){
		case sprMutant2Idle            : return spr.CrystalRedIdle;
		case sprMutant2Walk            : return spr.CrystalRedWalk;
		case sprMutant2Hurt            : return spr.CrystalRedHurt;
		case sprMutant2Dead            : return spr.CrystalRedDead;
		case sprMutant2GoSit           : return spr.CrystalRedGoSit;
		case sprMutant2Sit             : return spr.CrystalRedSit;
		case sprBigPortrait            : return spr.CrystalRedPortrait;
		case sprLoadoutSkin            : return spr.CrystalRedLoadout;
		case sprMapIcon                : return spr.CrystalRedMapIcon;
		case sprShield                 : return spr.CrystalRedShield;
		case sprShieldDisappear        : return spr.CrystalRedShieldDisappear;
		case sprCrystalShieldIdleFront : return spr.CrystalRedShieldIdleFront;
		case sprCrystalShieldWalkFront : return spr.CrystalRedShieldWalkFront;
		case sprCrystalShieldIdleBack  : return spr.CrystalRedShieldIdleBack;
		case sprCrystalShieldWalkBack  : return spr.CrystalRedShieldWalkBack;
		case sprCrystTrail             : return spr.CrystalRedTrail;
	}
	
#define skin_weapon_sprite(_wep, _spr)
	switch(_spr){
		case sprGoldARifle       : return spr.RedAssaultRifle;
		case sprGoldBazooka      : return spr.RedBazooka;
		case sprGoldCrossbow     : return spr.RedCrossbow;
		case sprGoldDiscgun      : return spr.RedDiscGun;
		case sprGoldNader        : return spr.RedGrenadeLauncher;
		case sprGoldLaserGun     : return spr.RedLaserPistol;
		case sprGoldMachinegun   : return spr.RedMachinegun;
		case sprGoldNukeLauncher : return spr.RedNukeLauncher;
		case sprGoldPlasmaGun    : return spr.RedPlasmaGun;
		case sprGoldRevolver     : return spr.RedRevolver;
		case sprGoldScrewdriver  : return spr.RedScrewdriver;
		case sprGoldShotgun      : return spr.RedShotgun;
		case sprGoldSlugger      : return spr.RedSlugger;
		case sprGoldSplinterGun  : return spr.RedSplinterGun;
		case sprGoldWrench       : return spr.RedWrench;
		
		 // Projectiles:
		case sprBoltGold         : return spr.RedBolt;
		case sprGoldDisc         : return spr.RedDisc;
		case sprGoldGrenade      : return spr.RedGrenade;
		case sprGoldNuke         : return spr.RedNuke;
		case sprGoldRocket       : return spr.RedRocket;
		
		 // Modded:
		default:
			if(_spr == spr.GoldTeleportGun) return spr.RedTeleportGun;
			if(_spr == spr.GoldTrident    ) return spr.RedTrident;
			if(_spr == spr.GoldTunneller  ) return spr.RedTunneller;
	}
	return _spr;
	
#define skin_weapon_sprite_hud(_wep, _spr)
	if(_spr == spr.TunnellerHUD) return spr.RedTunnellerHUD;
	return skin_weapon_sprite(_wep, _spr);
	
#define skin_weapon_swap(_wep, _swap)
	sound_set_track_position(
		sound_play_pitchvol(sndHyperCrystalChargeExplo, 0.6, 0.5),
		1.55
	);
	return _swap;
	
	
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