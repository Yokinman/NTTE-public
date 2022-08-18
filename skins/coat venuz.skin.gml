#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "venuz";
#define skin_name      return ((argument_count <= 0 || argument0) ? "COAT" : skin_lock());
#define skin_lock      return "BUY A COAT";
#define skin_unlock    return "FOR BUYING A COAT";
#define skin_ttip      return choose("GUNS THAT SEW THREADSES", "FRESH FIT", "IS THAT DESIGNER", "DROWNING IN STYLE");
#define skin_avail     return call(scr.unlock_get, "skin:" + mod_current);
#define skin_portrait  return skin_sprite(sprBigPortrait);
#define skin_mapicon   return skin_sprite(sprMapIcon);

#define skin_button
	sprite_index = skin_sprite(sprLoadoutSkin);
	image_index  = !skin_avail();
	
#define skin_sprite(_spr)
	switch(_spr){
		case sprMutant6Idle  : return spr.YVCoatIdle;
		case sprMutant6Walk  : return spr.YVCoatWalk;
		case sprMutant6Hurt  : return spr.YVCoatHurt;
		case sprMutant6Dead  : return spr.YVCoatDead;
		case sprMutant6GoSit : return spr.YVCoatGoSit;
		case sprMutant6Sit   : return spr.YVCoatSit;
		case sprBigPortrait  : return spr.YVCoatPortrait;
		case sprLoadoutSkin  : return spr.YVCoatLoadout;
		case sprMapIcon      : return spr.YVCoatMapIcon;
	}
	
#define skin_weapon_sprite(_wep, _spr)
	switch(_spr){
		case sprGoldARifle       : return spr.CoatAssaultRifle;
		case sprGoldBazooka      : return spr.CoatBazooka;
		case sprGoldCrossbow     : return spr.CoatCrossbow;
		case sprGoldDiscgun      : return spr.CoatDiscGun;
		case sprGoldNader        : return spr.CoatGrenadeLauncher;
		case sprGoldLaserGun     : return spr.CoatLaserPistol;
		case sprGoldMachinegun   : return spr.CoatMachinegun;
		case sprGoldNukeLauncher : return spr.CoatNukeLauncher;
		case sprGoldPlasmaGun    : return spr.CoatPlasmaGun;
		case sprGoldRevolver     : return spr.CoatRevolver;
		case sprGoldScrewdriver  : return spr.CoatScrewdriver;
		case sprGoldShotgun      : return spr.CoatShotgun;
		case sprGoldSlugger      : return spr.CoatSlugger;
		case sprGoldSplinterGun  : return spr.CoatSplinterGun;
		case sprGoldWrench       : return spr.CoatWrench;
		
		 // Projectiles:
		case sprBoltGold         : return spr.CoatBolt;
		case sprGoldDisc         : return spr.CoatDisc;
		case sprGoldGrenade      : return spr.CoatGrenade;
		case sprGoldNuke         : return spr.CoatNuke;
		case sprGoldRocket       : return spr.CoatRocket;
		
		 // Modded:
		default:
			if(_spr == spr.GoldTeleportGun) return spr.CoatTeleportGun;
			if(_spr == spr.GoldTrident    ) return spr.CoatTrident;
			if(_spr == spr.GoldTunneller  ) return spr.CoatTunneller;
	}
	return _spr;
	
#define skin_weapon_sprite_hud(_wep, _spr)
	if(_spr == spr.TunnellerHUD) return spr.CoatTunnellerHUD;
	return skin_weapon_sprite(_wep, _spr);
	
#define skin_weapon_swap(_wep, _swap)
	sound_play_pitchvol(choose(sndMenuASkin, sndMenuBSkin), 1.1, 1.2);
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