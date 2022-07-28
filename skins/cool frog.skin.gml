#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "frog";
#define skin_name      return ((argument_count <= 0 || argument0) ? "COOL" : skin_lock());
#define skin_lock      return `REACH @q@(color:${make_color_rgb(255, 110, 25)})COMBO x100`;
#define skin_unlock    return `REACHED @q@(color:${make_color_rgb(255, 110, 25)})COMBO x100`;
#define skin_avail     return call(scr.unlock_get, "skin:" + mod_current);
#define skin_portrait  return skin_sprite(sprBigPortrait);
#define skin_mapicon   return skin_sprite(sprMapIcon);

#define skin_ttip
	return (
		(chance(1, 5) && GameCont.level >= 10)
		? choose(
			"SLIME TIME",
			"TOO MUCH PIZZA",
			"MAKE SURE YOU FLUSH",
			"WANNA SEE A FROG?",
			`@q@(color:${choose(make_color_rgb(255, 230, 70), make_color_rgb(50, 210, 255), make_color_rgb(255, 110, 25), make_color_rgb(255, 110, 150))})COMBO x${GameCont.kills}`
		)
		: choose(
			"JUST A COOL FROG",
			"WHAT THE COOL",
			"TOO COOL FOR SCHOOL",
			"STRAIGHT FROM THE SEWERS",
			"ROCKIN' THE SHADES",
			"FROGGING AROUND",
			(
				array_length(instances_matching(obj.Pet, "pet", "CoolGuy"))
				? `@(color:${make_color_rgb(255, 110, 150)})FUNKY`
				: ""
			)
		)
	);
	
#define skin_button
	sprite_index = skin_sprite(sprLoadoutSkin);
	image_index  = !skin_avail();
	
#define skin_sprite(_spr)
	switch(_spr){
		case sprMutant15Idle    : return spr.FrogCoolIdle;
		case sprMutant15Walk    : return spr.FrogCoolWalk;
		case sprMutant15Hurt    : return spr.FrogCoolHurt;
		case sprMutant15Dead    : return spr.FrogCoolDead;
		case sprMutant15GoSit   : return spr.FrogCoolGoSit;
		case sprMutant15Sit     : return spr.FrogCoolSit;
		case sprBigPortrait     : return spr.FrogCoolPortrait;
		case sprLoadoutSkin     : return spr.FrogCoolLoadout;
		case sprMapIcon         : return spr.FrogCoolMapIcon;
		case sprHorrorBullet    : return spr.IDPDHorrorBullet;
		case sprHorrorBulletHit : return sprIDPDBulletHit;
		case sprHorrorHit       : return sprIDPDBulletHit;
	}
	
#define skin_weapon_sprite(_wep, _spr)
	switch(_spr){
		case sprGoldARifle       : return spr.CoolAssaultRifle;
		case sprGoldBazooka      : return spr.CoolBazooka;
		case sprGoldCrossbow     : return spr.CoolCrossbow;
		case sprGoldDiscgun      : return spr.CoolDiscGun;
		case sprGoldFrogBlaster  : return spr.CoolFrogPistol;
		case sprGoldNader        : return spr.CoolGrenadeLauncher;
		case sprGoldLaserGun     : return spr.CoolLaserPistol;
		case sprGoldMachinegun   : return spr.CoolMachinegun;
		case sprGoldNukeLauncher : return spr.CoolNukeLauncher;
		case sprGoldPlasmaGun    : return spr.CoolPlasmaGun;
		case sprGoldRevolver     : return spr.CoolRevolver;
		case sprGoldScrewdriver  : return spr.CoolScrewdriver;
		case sprGoldShotgun      : return spr.CoolShotgun;
		case sprGoldSlugger      : return spr.CoolSlugger;
		case sprGoldSplinterGun  : return spr.CoolSplinterGun;
		case sprGoldWrench       : return spr.CoolWrench;
		
		 // Projectiles:
		case sprBoltGold         : return spr.CoolBolt;
		case sprGoldDisc         : return spr.CoolDisc;
		case sprGoldGrenade      : return spr.CoolGrenade;
		case sprGoldNuke         : return spr.CoolNuke;
		case sprGoldRocket       : return spr.CoolRocket;
		
		 // Modded:
		default:
			if(_spr == spr.GoldTeleportGun) return spr.CoolTeleportGun;
			if(_spr == spr.GoldTrident    ) return spr.CoolTrident;
			if(_spr == spr.GoldTunneller  ) return spr.CoolTunneller;
	}
	return _spr;
	
#define skin_weapon_sprite_hud(_wep, _spr)
	if(_spr == spr.TunnellerHUD) return spr.CoolTunnellerHUD;
	return skin_weapon_sprite(_wep, _spr);
	
	
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