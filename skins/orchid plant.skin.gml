#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "plant";
#define skin_name      return ((argument_count <= 0 || argument0) ? "GILDED" : skin_lock());
#define skin_lock      return "REROLL ???";
#define skin_unlock    return "FOR REROLLING HEAVY HEART";
#define skin_ttip      return choose("YOU LOOK SO GOOD", "MILLION DOLLAR SMILE", "SHINY LIKE A LIMOUSINE", "ALL THAT TWINKLES IS GOLD", "PUMP YOUR VEINS WITH GUSHING GOLD");
#define skin_avail     return call(scr.unlock_get, "skin:" + mod_current);
#define skin_portrait  return skin_sprite(sprBigPortrait);
#define skin_mapicon   return skin_sprite(sprMapIcon);

#define skin_button
	sprite_index = skin_sprite(sprLoadoutSkin);
	image_index  = !skin_avail();
	
#define skin_sprite(_spr)
	switch(_spr){
		case sprMutant5Idle  : return spr.PlantOrchidIdle;
		case sprMutant5Walk  : return spr.PlantOrchidWalk;
		case sprMutant5Hurt  : return spr.PlantOrchidHurt;
		case sprMutant5Dead  : return spr.PlantOrchidDead;
		case sprMutant5GoSit : return spr.PlantOrchidGoSit;
		case sprMutant5Sit   : return spr.PlantOrchidSit;
		case sprBigPortrait  : return spr.PlantOrchidPortrait;
		case sprLoadoutSkin  : return spr.PlantOrchidLoadout;
		case sprMapIcon      : return spr.PlantOrchidMapIcon;
		case sprTangle       : return spr.PlantOrchidTangle;
		case sprTangleSeed   : return spr.PlantOrchidTangleSeed;
	}
	
#define skin_weapon_sprite(_wep, _spr)
	switch(_spr){
		case sprGoldARifle       : return spr.OrchidAssaultRifle;
		case sprGoldBazooka      : return spr.OrchidBazooka;
		case sprGoldCrossbow     : return spr.OrchidCrossbow;
		case sprGoldDiscgun      : return spr.OrchidDiscGun;
		case sprGoldFrogBlaster  : return spr.OrchidFrogPistol;
		case sprFrogBlaster      : return spr.OrchidFrogPistolRusty;
		case sprGoldNader        : return spr.OrchidGrenadeLauncher;
		case sprGoldLaserGun     : return spr.OrchidLaserPistol;
		case sprGoldMachinegun   : return spr.OrchidMachinegun;
		case sprGoldNukeLauncher : return spr.OrchidNukeLauncher;
		case sprGoldPlasmaGun    : return spr.OrchidPlasmaGun;
		case sprGoldRevolver     : return spr.OrchidRevolver;
		case sprGoldScrewdriver  : return spr.OrchidScrewdriver;
		case sprGoldShotgun      : return spr.OrchidShotgun;
		case sprGoldSlugger      : return spr.OrchidSlugger;
		case sprGoldSplinterGun  : return spr.OrchidSplinterGun;
		case sprGoldWrench       : return spr.OrchidWrench;
		
		 // Projectiles:
		case sprBoltGold         : return spr.OrchidBolt;
		case sprGoldDisc         : return spr.OrchidDisc;
		case sprGoldGrenade      : return spr.OrchidGrenade;
		case sprGoldNuke         : return spr.OrchidNuke;
		case sprGoldRocket       : return spr.OrchidRocket;
		
		 // Modded:
		default:
			if(_spr == spr.GoldTeleportGun) return spr.OrchidTeleportGun;
			if(_spr == spr.GoldTrident    ) return spr.OrchidTrident;
			if(_spr == spr.GoldTunneller  ) return spr.OrchidTunneller;
	}
	return _spr;
	
#define skin_weapon_sprite_hud(_wep, _spr)
	if(_spr == spr.TunnellerHUD) return spr.OrchidTunnellerHUD;
	return skin_weapon_sprite(_wep, _spr);
	
#define skin_weapon_swap(_wep, _swap)
	sound_play_pitchvol(sndMoneyPileBreak, 1.2, 1.45);
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