#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "eyes";
#define skin_name      return ((argument_count <= 0 || argument0) ? "BAT" : skin_lock());
#define skin_lock      return "REACH MAX @rCRIME @wBOUNTY";
#define skin_unlock    return "FOR REACHING MAX @rCRIME @wBOUNTY";
#define skin_ttip      return choose("THE DANGER", "TREAD LIGHTLY", "SAY MY NAME");
#define skin_avail     return call(scr.unlock_get, "skin:" + mod_current);
#define skin_portrait  return skin_sprite(sprBigPortrait);
#define skin_mapicon   return skin_sprite(sprMapIcon);

#define skin_button
	sprite_index = skin_sprite(sprLoadoutSkin);
	image_index  = !skin_avail();
	
#define skin_sprite(_spr)
	switch(_spr){
		case sprMutant3Idle  : return spr.EyesBatIdle;
		case sprMutant3Walk  : return spr.EyesBatWalk;
		case sprMutant3Hurt  : return spr.EyesBatHurt;
		case sprMutant3Dead  : return spr.EyesBatDead;
		case sprMutant3GoSit : return spr.EyesBatGoSit;
		case sprMutant3Sit   : return spr.EyesBatSit;
		case sprBigPortrait  : return spr.EyesBatPortrait;
		case sprLoadoutSkin  : return spr.EyesBatLoadout;
		case sprMapIcon      : return spr.EyesBatMapIcon;
	}
	
#define skin_weapon_sprite(_wep, _spr)
	switch(_spr){
		case sprGoldARifle       : return spr.BatAssaultRifle;
		case sprGoldBazooka      : return spr.BatBazooka;
		case sprGoldCrossbow     : return spr.BatCrossbow;
		case sprGoldDiscgun      : return spr.BatDiscGun;
		case sprGoldNader        : return spr.BatGrenadeLauncher;
		case sprGoldLaserGun     : return spr.BatLaserPistol;
		case sprGoldMachinegun   : return spr.BatMachinegun;
		case sprGoldNukeLauncher : return spr.BatNukeLauncher;
		case sprGoldPlasmaGun    : return spr.BatPlasmaGun;
		case sprGoldRevolver     : return spr.BatRevolver;
		case sprGoldScrewdriver  : return spr.BatScrewdriver;
		case sprGoldShotgun      : return spr.BatShotgun;
		case sprGoldSlugger      : return spr.BatSlugger;
		case sprGoldSplinterGun  : return spr.BatSplinterGun;
		case sprGoldWrench       : return spr.BatWrench;
		
		 // Projectiles:
		case sprBoltGold         : return spr.BatBolt;
		case sprGoldDisc         : return spr.BatDisk;
		case sprGoldGrenade      : return spr.BatGrenade;
		case sprGoldNuke         : return spr.BatNuke;
		case sprGoldRocket       : return spr.BatRocket;
		
		 // Modded:
		default:
			if(_spr == spr.GoldTeleportGun) return spr.BatTeleportGun;
			if(_spr == spr.GoldTrident    ) return spr.BatTrident;
			if(_spr == spr.GoldTunneller  ) return spr.BatTunneller;
	}
	return _spr;
	
#define skin_weapon_sprite_hud(_wep, _spr)
	if(_spr == spr.TunnellerHUD) return spr.BatTunnellerHUD;
	return skin_weapon_sprite(_wep, _spr);
	
#define skin_weapon_swap(_wep, _swap)
	sound_play_pitchvol(sndSwapHammer, 1.2, 2/3);
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