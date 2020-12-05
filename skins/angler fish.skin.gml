#define init
	spr = mod_variable_get("mod", "teassets", "spr");
	snd = mod_variable_get("mod", "teassets", "snd");
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus

#define skin_race      return "fish";
#define skin_name      return ((argument_count <= 0 || argument0) ? "ABYSSAL" : skin_lock());
#define skin_lock      return "DEFEAT A @yGOLDEN ANGLER";
#define skin_unlock    return "FOR DEFEATING A @yGOLDEN ANGLER";
#define skin_ttip      return choose("SO BRIGHT OUT", "MISSED THE SUN", "SHAPED BY THE DEPTHS", "LOST YOUR MIND");
#define skin_avail     return unlock_get("skin:" + mod_current);
#define skin_portrait  return spr.FishAnglerPortrait;
#define skin_mapicon   return spr.FishAnglerMapIcon;

#define skin_button
	sprite_index = spr.FishAnglerLoadout;
	image_index  = skin_avail();
	
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
	return -1;
	
	
/// SCRIPTS
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define unlock_get(_unlock)                                                             return  mod_script_call_nc('mod', 'teassets', 'unlock_get', _unlock);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define area_get_name(_area, _subarea, _loop)                                           return  mod_script_call_nc('mod', 'telib', 'area_get_name', _area, _subarea, _loop);