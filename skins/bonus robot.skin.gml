#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "robot";
#define skin_name      return ((argument_count <= 0 || argument0) ? "BONUS" : skin_lock());
#define skin_lock      return "PLAY 8 HOURS OF NT:TE";
#define skin_unlock    return "FOR PLAYING 8 HOURS OF NT:TE";
#define skin_ttip      return choose("RECYCLE", "MK 600", "YOU ARE TERMINATED");
#define skin_avail     return call(scr.unlock_get, "skin:" + mod_current);
#define skin_portrait  return skin_sprite(sprBigPortrait);
#define skin_mapicon   return skin_sprite(sprMapIcon);

#define skin_button
	sprite_index = skin_sprite(sprLoadoutSkin);
	image_index  = !skin_avail();
	
#define skin_sprite(_spr)
	switch(_spr){
		case sprMutant8Idle  : return spr.RobotBonusIdle;
		case sprMutant8Walk  : return spr.RobotBonusWalk;
		case sprMutant8Hurt  : return spr.RobotBonusHurt;
		case sprMutant8Dead  : return spr.RobotBonusDead;
		case sprMutant8GoSit : return spr.RobotBonusGoSit;
		case sprMutant8Sit   : return spr.RobotBonusSit;
		case sprBigPortrait  : return spr.RobotBonusPortrait;
		case sprLoadoutSkin  : return spr.RobotBonusLoadout;
		case sprMapIcon      : return spr.RobotBonusMapIcon;
	}
	
#define skin_weapon_sprite(_wep, _spr)
	switch(_spr){
		case sprGoldARifle       : return spr.BonusAssaultRifle;
		case sprGoldBazooka      : return spr.BonusBazooka;
		case sprGoldCrossbow     : return spr.BonusCrossbow;
		case sprGoldDiscgun      : return spr.BonusDiscGun;
		case sprGoldNader        : return spr.BonusGrenadeLauncher;
		case sprGoldLaserGun     : return spr.BonusLaserPistol;
		case sprGoldMachinegun   : return spr.BonusMachinegun;
		case sprGoldNukeLauncher : return spr.BonusNukeLauncher;
		case sprGoldPlasmaGun    : return spr.BonusPlasmaGun;
		case sprGoldRevolver     : return spr.BonusRevolver;
		case sprGoldScrewdriver  : return spr.BonusScrewdriver;
		case sprGoldShotgun      : return spr.BonusShotgun;
		case sprGoldSlugger      : return spr.BonusSlugger;
		case sprGoldSplinterGun  : return spr.BonusSplinterGun;
		case sprGoldWrench       : return spr.BonusWrench;
		
		 // Projectiles:
		case sprBoltGold         : return spr.BonusBolt;
		case sprGoldDisc         : return spr.BonusDisc;
		case sprGoldGrenade      : return spr.BonusGrenade;
		case sprGoldNuke         : return spr.BonusNuke;
		case sprGoldRocket       : return spr.BonusRocket;
		
		 // Modded:
		default:
			if(_spr == spr.GoldTeleportGun) return spr.BonusTeleportGun;
			if(_spr == spr.GoldTrident    ) return spr.BonusTrident;
			if(_spr == spr.GoldTunneller  ) return spr.BonusTunneller;
	}
	return _spr;
	
#define skin_weapon_sprite_hud(_wep, _spr)
	if(_spr == spr.TunnellerHUD) return spr.BonusTunnellerHUD;
	return skin_weapon_sprite(_wep, _spr);
	
#define skin_weapon_swap(_wep, _swap)
	sound_play_pitchvol(sndSwapEnergy, 1.2, 0.8);
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