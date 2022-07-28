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