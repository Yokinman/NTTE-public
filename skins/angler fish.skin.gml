#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "fish";
#define skin_name      return ((argument_count <= 0 || argument0) ? "ABYSSAL" : skin_lock());
#define skin_lock      return "DEFEAT A @yGOLDEN ANGLER";
#define skin_unlock    return "FOR DEFEATING A @yGOLDEN ANGLER";
#define skin_ttip      return choose("SO BRIGHT OUT", "MISSED THE SUN", "SHAPED BY THE DEPTHS", "LOST YOUR MIND");
#define skin_avail     return call(scr.unlock_get, "skin:" + mod_current);
#define skin_portrait  return skin_sprite(sprBigPortrait);
#define skin_mapicon   return skin_sprite(sprMapIcon);

#define skin_button
	sprite_index = skin_sprite(sprLoadoutSkin);
	image_index  = !skin_avail();
	
#define skin_sprite(_spr)
	switch(_spr){
		case sprMutant1Idle  : return spr.FishAnglerIdle;
		case sprMutant1Walk  : return spr.FishAnglerWalk;
		case sprMutant1Hurt  : return spr.FishAnglerHurt;
		case sprMutant1Dead  : return spr.FishAnglerDead;
		case sprMutant1GoSit : return spr.FishAnglerGoSit;
		case sprMutant1Sit   : return spr.FishAnglerSit;
		case sprBigPortrait  : return spr.FishAnglerPortrait;
		case sprLoadoutSkin  : return spr.FishAnglerLoadout;
		case sprMapIcon      : return spr.FishAnglerMapIcon;
	}
	
#define skin_weapon_sprite(_wep, _spr)
	switch(_spr){
		case sprGoldARifle       : return spr.AnglerAssaultRifle;
		case sprGoldBazooka      : return spr.AnglerBazooka;
		case sprGoldCrossbow     : return spr.AnglerCrossbow;
		case sprGoldDiscgun      : return spr.AnglerDiscGun;
		case sprGoldNader        : return spr.AnglerGrenadeLauncher;
		case sprGoldLaserGun     : return spr.AnglerLaserPistol;
		case sprGoldMachinegun   : return spr.AnglerMachinegun;
		case sprGoldNukeLauncher : return spr.AnglerNukeLauncher;
		case sprGoldPlasmaGun    : return spr.AnglerPlasmaGun;
		case sprGoldRevolver     : return spr.AnglerRevolver;
		case sprGoldScrewdriver  : return spr.AnglerScrewdriver;
		case sprGoldShotgun      : return spr.AnglerShotgun;
		case sprGoldSlugger      : return spr.AnglerSlugger;
		case sprGoldSplinterGun  : return spr.AnglerSplinterGun;
		case sprGoldWrench       : return spr.AnglerWrench;
		case sprGuitar           : return spr.AnglerGuitar;
		
		 // Projectiles:
		case sprBoltGold         : return spr.AnglerBolt;
		case sprGoldDisc         : return spr.AnglerDisc;
		case sprGoldGrenade      : return spr.AnglerGrenade;
		case sprGoldNuke         : return spr.AnglerNuke;
		case sprGoldRocket       : return spr.AnglerRocket;
		
		 // Modded:
		default:
			if(_spr == spr.GoldTeleportGun) return spr.AnglerTeleportGun;
			if(_spr == spr.GoldTrident    ) return spr.AnglerTrident;
			if(_spr == spr.GoldTunneller  ) return spr.AnglerTunneller;
	}
	return _spr;
	
#define skin_weapon_sprite_hud(_wep, _spr)
	if(_spr == spr.TunnellerHUD) return spr.AnglerTunnellerHUD;
	return skin_weapon_sprite(_wep, _spr);
	
#define skin_weapon_swap(_wep, _swap)
	sound_play_pitchvol(sndOasisMelee, 0.75, 1.2);
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