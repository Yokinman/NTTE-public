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
#define skin_lock      return "???";
#define skin_unlock    return "???";
#define skin_ttip      return "???";
#define skin_avail     return call(scr.unlock_get, "skin:" + mod_current) || 1;
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