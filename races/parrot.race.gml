#define init
	mod_script_call("mod", "teassets", "ntte_init", script_ref_create(init));
	
	 // Charm:
	charm_object        = [hitme, becomenemy, ReviveArea, NecroReviveArea, RevivePopoFreak];
	charm_instance_list = [];
	charm_instance_vars = [];
	charm_bind_draw     = [];
	for(var i = -1; i < maxp; i++){
		array_push(charm_bind_draw, script_bind(CustomDraw, script_ref_create(charm_draw, [], i), 0, false));
	}
	shader_add("Charm",
		
		/* Vertex Shader */"
		struct VertexShaderInput
		{
			float2 vTexcoord : TEXCOORD0;
			float4 vPosition : POSITION;
		};
		
		struct VertexShaderOutput
		{
			float2 vTexcoord : TEXCOORD0;
			float4 vPosition : SV_POSITION;
		};
		
		uniform float4x4 matrix_world_view_projection;
		
		VertexShaderOutput main(VertexShaderInput INPUT)
		{
			VertexShaderOutput OUT;
			
			OUT.vTexcoord = INPUT.vTexcoord; // (x,y)
			OUT.vPosition = mul(matrix_world_view_projection, INPUT.vPosition); // (x,y,z,w)
			
			return OUT;
		}
		",
		
		/* Fragment/Pixel Shader */"
		struct PixelShaderInput
		{
			float2 vTexcoord : TEXCOORD0;
		};
		
		sampler2D s0;
		
		uniform float2 pixelSize;
		
		bool isEyeColor(float3 RGB)
		{
			bool isEye = false;
			
			if(RGB.r > RGB.g + RGB.b){
				float R = round(RGB.r * 255.0);
				float G = round(RGB.g * 255.0);
				float B = round(RGB.b * 255.0);
				if(
					R == 252.0 && G ==  56.0 && B ==  0.0 || //  Standard enemy eye color
					R == 199.0 && G ==   0.0 && B ==  0.0 || //  Freak eye color
					R ==  95.0 && G ==   0.0 && B ==  0.0 || //  Freak eye color
					R == 163.0 && G ==   5.0 && B ==  5.0 || //  Buff gator ammo
					R == 105.0 && G ==   3.0 && B ==  3.0 || //  Buff gator ammo
					R == 255.0 && G ==   0.0 && B ==  0.0 || //  Wolf eye color
					R == 165.0 && G ==   9.0 && B == 43.0 || //  Snowbot eye color
					R == 194.0 && G ==  42.0 && B ==  0.0 || //  Explo freak color
					R == 122.0 && G ==  27.0 && B ==  0.0 || //  Explo freak color
					R == 156.0 && G ==  20.0 && B == 31.0 || //  Turret eye color
					R == 255.0 && G == 134.0 && B == 47.0 || //  Turret eye color
					R ==  99.0 && G ==   9.0 && B == 17.0 || //  Turret color
					R == 112.0 && G ==   0.0 && B == 17.0 || //  Necromancer eye color
					R == 210.0 && G ==  32.0 && B == 71.0 || //  Jungle fly eye color
					R == 179.0 && G ==  27.0 && B == 60.0    //  Jungle fly eye color
				){
					isEye = true;
				}
			}
			
			return isEye;
		}
		
		float4 main(PixelShaderInput INPUT) : SV_TARGET
		{
			float4 RGBA = tex2D(s0, INPUT.vTexcoord);
			
			 // Red Eyes to Green:
			if(RGBA.r > RGBA.g + RGBA.b){
				if(
					isEyeColor(RGBA.rgb)
					|| isEyeColor(tex2D(s0, INPUT.vTexcoord - float2(pixelSize.x, 0.0)).rgb)
					|| isEyeColor(tex2D(s0, INPUT.vTexcoord + float2(pixelSize.x, 0.0)).rgb)
					|| isEyeColor(tex2D(s0, INPUT.vTexcoord - float2(0.0, pixelSize.y)).rgb)
					|| isEyeColor(tex2D(s0, INPUT.vTexcoord + float2(0.0, pixelSize.y)).rgb)
				){
					return RGBA.grba;
				}
			}
			
			 // Return Blank Pixel:
			return float4(0.0, 0.0, 0.0, 0.0);
		}
		"
		/*
			  R    G    B |   H    S    V |
			252,  56,   0 |  13, 100,  99 | Standard enemy eye color
			199,   0,   0 |   0, 100,  78 | Freak eye color
			 95,   0,   0 |   0, 100,  37 | Freak eye color
			163,   5,   5 |   0,  97,  64 | Buff gator ammo
			105,   3,   3 |   0,  97,  41 | Buff gator ammo
			255,   0,   0 |   0, 100, 100 | Wolf eye color
			165,   9,  43 | 347,  95,  65 | Snowbot eye color
			194,  42,   0 |  13, 100,  76 | Explo freak color
			122,  27,   0 |  13, 100,  48 | Explo freak color
			156,  20,  31 | 355,  87,  61 | Turret eye color
			 99,   9,  17 | 355,  91,  39 | Turret color
			112,   0,  17 | 351, 100,  44 | Necromancer eye color
			210,  32,  71 | 347,  85,  82 | Jungle fly eye color
			179,  27,  60 | 347,  85,  70 | Jungle fly eye color
			
			255, 164,  15 |  37,  94, 100 | Saladmander fire color
			255, 168,  61 |  33,  76  100 | Snowbot eye color
			255, 134,  47 |  25,  82, 100 | Turret eye color
			255, 160,  35 |  34,  86, 100 | Jungle fly eye/wing color
			///255, 228,  71 |  51,  72, 100 | Jungle fly wing color
		*/
	);
	
#define cleanup
	mod_script_call("mod", "teassets", "ntte_cleanup", script_ref_create(cleanup));
	
	 // Uncharm:
	charm_instance_raw(charm_instance_list, false);
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro charm_object        global.charm_object
#macro charm_instance_list global.charm_instance_list
#macro charm_instance_vars global.charm_instance_vars
#macro charm_bind_draw     global.charm_bind_draw
#macro charm_vars          {
		"charmed" : false, // Currently charmed, true/false
		"on_step" : [],    // Custom-type object's original step event
		"target"  : noone, // The charmed enemy's custom target
		"team"    : 2,     // Original team before charming
		"time"    : -1,    // Charm duration in frames
		"index"   : -1,    // Player who charmed
		"kill"    : false, // Kill when uncharmed
		"feather" : false  // Was charmed using feathers
	}
	
/// General
#define race_name              return "PARROT";
#define race_text              return "MANY FRIENDS#@rCHARM ENEMIES";
#define race_lock              return "REACH " + area_get_name("coast", 1, 0);
#define race_unlock            return "FOR REACHING COAST";
#define race_tb_text           return "@wPICKUPS @sGIVE @rFEATHERS@s";
#define race_portrait(_p, _b)  return race_sprite_raw("Portrait", _b);
#define race_mapicon(_p, _b)   return race_sprite_raw("Map",      _b);
#define race_avail             return unlock_get("race:" + mod_current);

#define race_ttip
	 // Ultra:
	if(GameCont.level >= 10 && chance(1, 5)){
		return choose(
			"MIGRATION FORMATION",
			"CHARMED, I'M SURE",
			"ADVENTURING PARTY",
			"FREE AS A BIRD"
		);
	}
	
	 // Normal:
	return choose(
		"HITCHHIKER",
		"BIRDBRAIN",
		"PARROT IS AN EXPERT TRAVELER",
		"WIND UNDER MY WINGS",
		"PARROT LIKES CAMPING",
		"MACAW WORKS TOO",
		"CHESTS GIVE @rFEATHERS@s"
	);
	
#define race_sprite(_spr)
	var _b = (("bskin" in self && is_real(bskin)) ? bskin : 0);
	
	switch(_spr){
		case sprMutant1Idle      : return race_sprite_raw("Idle",         _b);
		case sprMutant1Walk      : return race_sprite_raw("Walk",         _b);
		case sprMutant1Hurt      : return race_sprite_raw("Hurt",         _b);
		case sprMutant1Dead      : return race_sprite_raw("Dead",         _b);
		case sprMutant1GoSit     : return race_sprite_raw("GoSit",        _b);
		case sprMutant1Sit       : return race_sprite_raw("Sit",          _b);
		case sprFishMenu         : return race_sprite_raw("Idle",         _b);
		case sprFishMenuSelected : return race_sprite_raw("MenuSelected", _b);
		case sprFishMenuSelect   : return race_sprite_raw("Idle",         _b);
		case sprFishMenuDeselect : return race_sprite_raw("Idle",         _b);
		case sprChickenFeather   : return race_sprite_raw("Feather",      _b);
		case sprRogueAmmoHUD     : return race_sprite_raw("FeatherHUD",   _b);
	}
	
	return -1;
	
#define race_sound(_snd)
	var _sndNone = sndFootPlaSand5; // playing a sound that doesn't exist using sound_play_pitch/sound_play_pitchvol modifies sndSwapPistol's pitch/volume
	
	switch(_snd){
		case sndMutant1Wrld : return _sndNone;
		case sndMutant1Hurt : return sndRavenHit;
		case sndMutant1Dead : return sndAllyDead;
		case sndMutant1LowA : return _sndNone;
		case sndMutant1LowH : return _sndNone;
		case sndMutant1Chst : return _sndNone;
		case sndMutant1Valt : return _sndNone;
		case sndMutant1Crwn : return _sndNone;
		case sndMutant1Spch : return _sndNone;
		case sndMutant1IDPD : return _sndNone;
		case sndMutant1Cptn : return _sndNone;
		case sndMutant1Thrn : return _sndNone;
	}
	
	return -1;
	
#define race_sprite_raw(_spr, _skin)
	var s = lq_defget(spr.Race, mod_current, []);
	
	if(_skin >= 0 && _skin < array_length(s)){
		return lq_defget(s[_skin], _spr, -1);
	}
	
	return -1;
	

/// Menu
#define race_menu_select
	if(instance_is(self, CharSelect) || instance_is(other, CharSelect)){
		 // Yo:
		sound_play_pitchvol(sndMutant6Slct, 2, 0.6);
		
		 // Kun:
		if(fork()){
			wait 5 * current_time_scale;
			
			audio_sound_set_track_position(
				sound_play_pitchvol(sndMutant15Hurt, 2, 0.6),
				0.2
			);
			
			 // Extra singy noise:
			audio_sound_set_track_position(
				sound_play_pitchvol(sndMutant15Slct, 2.5, 0.2),
				0.2
			);
			
			exit;
		}
		
		return -1;
	}
	
	return sndRavenLift;

#define race_menu_confirm
	if(instance_is(self, Menu) || instance_is(other, Menu) || instance_is(other, UberCont)){
		 // Wah:
		sound_play_pitchvol(sndMutant6Slct, 2.4, 0.6);
		
		 // Tohohoho:
		if(fork()){
			wait 5 * current_time_scale;
			
			audio_sound_set_track_position(
				sound_play_pitchvol(sndMutant15Cnfm, 2.5, 0.5),
				0.4
			);
			
			exit;
		}
		
		return -1;
	}
	
	return sndRavenLand;

#define race_menu_button
	sprite_index = race_sprite_raw("Select", 0);
	image_index = !race_avail();
	
	
/// Skins
#define race_skins
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++){
		_playersActive += player_is_active(i);
	}
	
	 // Normal:
	if(_playersActive <= 1){
		return 2;
	}
	
	 // Co-op Bugginess:
	var _num = 0;
	while(_num == 0 || unlock_get(`skin:${mod_current}:${_num}`)){
		_num++;
	}
	return _num;
	
#define race_skin_avail(_skin)
	var _playersActive = 0;
	for(var i = 0; i < maxp; i++){
		_playersActive += player_is_active(i);
	}
	
	 // Normal:
	if(_playersActive <= 1){
		return (_skin == 0 || unlock_get(`skin:${mod_current}:${_skin}`));
	}
	
	 // Co-op Bugginess:
	return true;
	
#define race_skin_name(_skin)
	if(race_skin_avail(_skin)){
		return chr(65 + _skin) + " SKIN";
	}
	else{
		return race_skin_lock(_skin);
	}
	
#define race_skin_lock(_skin)
	switch(_skin){
		case 0 : return "EDIT THE SAVE FILE LMAO";
		case 1 : return "COMPLETE THE#AQUATIC ROUTE";
	}
	
#define race_skin_unlock(_skin)
	switch(_skin){
		case 1 : return "FOR BEATING THE AQUATIC ROUTE";
	}
	
#define race_skin_button(_skin)
	sprite_index = race_sprite_raw("Loadout", _skin);
	image_index = !race_skin_avail(_skin);
	
	
/// Ultras
#macro ult_feather 1
#macro ult_flock   2

#define race_ultra_name(_ultra)
	switch(_ultra){
		case ult_feather : return "BIRDS OF A FEATHER";
		case ult_flock   : return "FLOCK TOGETHER";
	}
	return "";
	
#define race_ultra_text(_ultra)
	switch(_ultra){
		case ult_feather : return "CAN CHARM MULTIPLE ENEMIES#@rFEATHERS @sLAST @wLONGER";
		case ult_flock   : return "@wINCOMING DAMAGE @sIS SPLIT#WITH @rFEATHERED @sENEMIES";
	}
	return "";
	
#define race_ultra_button(_ultra)
	sprite_index = race_sprite_raw("UltraIcon", 0);
	image_index = _ultra - 1; // why are ultras 1-based bro
	
#define race_ultra_icon(_ultra)
	return race_sprite_raw("UltraHUD" + chr(64 + _ultra), 0);
	
#define race_ultra_take(_ultra, _state)
	 // Ultra A Bonus - Full Ammo:
	if(_ultra == ult_feather){
		with(instances_matching(Player, "race", mod_current)){
			feather_ammo_get += feather_ammo_max * _state;
		}
	}
	
	 // Ultra Sound:
	if(_state != 0 && instance_exists(LevCont)){
		sound_play(sndBasicUltra);
		
		switch(_ultra){
			
			case ult_feather:
				
				 // Feathers:
				if(fork()){
					for(var i = 0; i < 8; i++){
						sound_play_pitchvol(sndSharpTeeth, 4 + sin(i / 3), 0.4);
						wait (1 + (2 * sin(i * 1.5))) * current_time_scale;
					}
					
					exit;
				}
				
				 // Charm:
				if(fork()){
					wait 7 * current_time_scale;
					
					var _snd = [sndBigBanditIntro, sndBigDogIntro, sndLilHunterAppear];
					for(var i = 0; i < array_length(_snd); i++){
						sound_play_pitchvol(_snd[i], 1.2, 0.8 - (i * 0.1));
						sound_play_pitch(sndBanditDie, 1.2 + (i * 0.4));
						wait 4 * current_time_scale;
					}
					
					exit;
				}
				
				break;
				
			case ult_flock:
				
				if(fork()){
					sound_play_pitch(sndCoopUltraA,     2.0);
					sound_play_pitch(sndHPPickupBig,    0.8);
					sound_play_pitch(sndHealthChestBig, 1.5);
					
					wait 10 * current_time_scale;
					
					 // They Dyin:
					var _snd = [sndBigMaggotDie, sndScorpionDie, sndBigBanditDie];
					for(var i = 0; i < array_length(_snd); i++){
						sound_play_pitchvol(_snd[i], 1.3, 1.4);
						wait 5 * current_time_scale;
					}
					
					exit;
				}
				
				break;
				
		}
	}
	
	
#define create
	 // Random lets you play locked characters: (Can remove once 9941+ gets stable build)
	if(!race_avail()){
		race = "fish";
		player_set_race(index, race);
		exit;
	}
	
	 // Sound:
	snd_wrld = race_sound(sndMutant1Wrld);
	snd_hurt = race_sound(sndMutant1Hurt);
	snd_dead = race_sound(sndMutant1Dead);
	snd_lowa = race_sound(sndMutant1LowA);
	snd_lowh = race_sound(sndMutant1LowH);
	snd_chst = race_sound(sndMutant1Chst);
	snd_valt = race_sound(sndMutant1Valt);
	snd_crwn = race_sound(sndMutant1Crwn);
	snd_spch = race_sound(sndMutant1Spch);
	snd_idpd = race_sound(sndMutant1IDPD);
	snd_cptn = race_sound(sndMutant1Cptn);
	snd_thrn = race_sound(sndMutant1Thrn);
	footkind = 1; // Organic
	
	 // Feather Related:
	feather_num      = 12;
	feather_num_mult = 1;
	feather_ammo     = 0;
	feather_ammo_max = 3 * feather_num;
	feather_ammo_get = 0;
	feather_ammo_hud = [];
	//feather_ammo_hud_flash = 0;
	
	 // Ultra B:
	ntte_charm_flock_hp         = my_health;
	ntte_charm_flock_hud        = 0;
	ntte_charm_flock_hud_hp     = 0;
	ntte_charm_flock_hud_hp_max = 0;
	ntte_charm_flock_hud_hp_lst = 0;
	
	 // Extra Pet Slot:
	ntte_pet_max = mod_variable_get("mod", "ntte", "pet_max") + 1;
	
#define game_start
	with(instances_matching(Player, "race", mod_current)){
		 // Starting Ammo:
		feather_ammo_get += feather_num;
		
		 // Starter Pet:
		if("ntte_pet" not in self){
			ntte_pet = [];
		}
		with(pet_spawn(x, y, "Parrot")){
			leader     = other;
			visible    = false;
			persistent = true;
			stat_found = false;
			array_push(other.ntte_pet, self);
			
			 // Skin:
			pet_set_skin(other.bskin);
		}
	}
	
#define step
	if(lag) trace_time();
	
	 // Starting Feather Ammo:
	while(feather_ammo_get > 0){
		feather_ammo_get--;
		with(obj_create(x + orandom(16), y + orandom(16), "ParrotFeather")){
			bskin        = other.bskin;
			creator      = other;
			target       = other;
			speed       *= 3;
			sprite_index = race_get_sprite(other.race, sprite_index);
		}
	}
	
	 /// ACTIVE : Charm
	if(canspec && player_active){
		var	_featherNum  = ((ultra_get(mod_current, ult_feather) > 0) ? feather_ammo_max : feather_num),
			_featherInst = (instance_exists(CustomObject) ? instances_matching(instances_matching(instances_matching(CustomObject, "name", "ParrotFeather"), "index", index), "creator", self, noone) : []),
			_activeHeld  = (button_check(index, "spec") || usespec > 0),
			_activePress = (_activeHeld && (button_pressed(index, "spec") || ((usespec > 0 || array_length(_featherInst)) && array_equals(_featherInst, instances_matching(_featherInst, "target", self)))));
			
		 // Retrieving Feathers:
		if(_activePress || !_activeHeld){
			 // Activate Pickup Feathers:
			if(_activePress && array_length(_featherInst) < _featherNum){
				if(instance_exists(CustomObject)){
					var _inst = instances_matching(instances_matching(instances_matching(instances_matching(CustomObject, "name", "ParrotFeather"), "index", -1), "creator", self), "target", self);
					_inst = array_slice(_inst, 0, min(_featherNum - array_length(_featherInst), array_length(_inst)));
					if(array_length(_inst)) with(_inst){
						index = other.index;
						array_push(_featherInst, self);
					}
				}
			}
			
			 // Retrieve:
			if(array_length(_featherInst)){
				with(_featherInst){
					if(stick){
						stick = false;
						stick_wait = 3;
						motion_add(random(360), 6);
						
						 // Uncharming:
						with(target){
							if("ntte_charm" in self && (ntte_charm.time >= 0 || ntte_charm.feather)){
								ntte_charm.time -= min(ntte_charm.time, other.stick_time);
								if(ntte_charm.time <= 0){
									charm_instance(self, false);
									
									 // Sound:
									audio_sound_set_track_position(
										sound_play_hit_ext(sndBigMaggotUnburrowSand, random_range(1.2, 1.4), 2.5),
										0.7
									);
									sound_play_pitchvol(sndPlantPower, random_range(1.3, 1.4), 1.2);
								}
							}
						}
					}
					target = creator;
				}
			}
		}
		
		 // Sending Feathers:
		if(_activeHeld){
			var _targetInst = (
				instance_exists(enemy)
				? instances_seen(instances_matching_ne(instances_matching_lt(instances_matching_ne([enemy, FrogEgg], "team", team), "size", 6), "mask_index", mskNone), 16, 16, index)
				: []
			);
			
			 // Get Targetable Feathers:
			if(array_length(_featherInst)){
				with(instances_matching_ne(_featherInst, "target", self)){
					var _targetPos = array_find_index(_targetInst, target);
					if(_targetPos >= 0){
						_targetInst[_targetPos] = noone;
					}
				}
				array_sort(_featherInst, false);
				_featherInst = instances_matching(_featherInst, "creator", self);
				_featherInst = array_slice(_featherInst, 0, min(_featherNum, array_length(_featherInst)));
			}
			
			 // Excrete New Feathers:
			if(_activePress && feather_ammo > 0 && array_length(_featherInst) < _featherNum){
				var	_tx  = x,
					_ty  = y,
					_num = 0;
					
				 // Spawn Some by Target:
				with(instance_nearest_bbox(mouse_x[index], mouse_y[index], _targetInst)){
					_tx = x;
					_ty = y;
				}
				
				 // Feathers:
				while(feather_ammo > 0 && array_length(_featherInst) < _featherNum){
					feather_ammo--;
					
					with(obj_create(
						(((_num % 3) == 1) ? _tx : x) + orandom(4),
						(((_num % 3) == 1) ? _ty : y) + orandom(4),
						"ParrotFeather"
					)){
						bskin        = other.bskin;
						index        = other.index;
						creator      = other;
						target       = other;
						sprite_index = race_get_sprite(other.race, sprite_index);
						array_push(_featherInst, self);
					}
					
					_num++;
				}
				
				 // Sound:
				if(_num > 0){
					sound_play_hit_ext(sndSharpTeeth, 3 + random(3), 0.4);
				}
			}
			
			 // Send Feathers to Target:
			if(array_length(_featherInst)){
				var	_targetX    = mouse_x[index],
					_targetY    = mouse_y[index],
					_targetList = [];
					
				 // Sort Targets by Distance:
				with(instances_matching_ne(_targetInst, "id", null)){
					array_push(_targetList, [self, distance_to_point(_targetX, _targetY)]);
				}
				array_sort_sub(_targetList, 1, true);
				
				 // Send to Target:
				_featherInst = instances_matching(_featherInst, "target", self);
				array_sort(_featherInst, false);
				for(var i = 0; i < _featherNum / feather_num; i++){
					var _target = (
						(i < array_length(_targetList))
						? _targetList[i, 0]
						: self
					);
					with(array_slice(
						_featherInst,
						i * feather_num,
						min(feather_num, array_length(_featherInst) - (i * feather_num))
					)){
						target     = _target;
						stick_wait = max(stick_wait, 3);
					}
				}
			}
			
			 // No Feathers:
			else if(button_pressed(index, "spec")){
				sound_play_hit_ext(sndMutant0Cnfm, 3 + orandom(0.2), 2);
			}
		}
	}
	
	 // Pitched snd_hurt:
	if(sprite_index == spr_hurt && image_index == image_speed_raw){
		var _sndMax = sound_play_pitchvol(0, 0, 0);
		sound_stop(_sndMax);
		for(var i = _sndMax - 1; i >= _sndMax - 10; i--){
			if(audio_get_name(i) == audio_get_name(snd_hurt)){
				audio_sound_pitch(i, 1.1 + random(0.4));
				audio_sound_gain(i, 1.2 * audio_sound_get_gain(i), 0);
				break;
			}
		}
	}
	
	 // Death Feathers:
	if(my_health <= 0 && candie && feather_ammo > 0){
		repeat(feather_ammo){
			with(instance_create(x, y, Feather)){
				bskin        = other.bskin;
				image_blend  = c_gray;
				sprite_index = race_get_sprite(other.race, sprite_index);
			}
		}
	}
	
	if(lag) trace_time(mod_current + "_step");
	
#define ntte_update(_newID)
	if(array_length(charm_instance_list)){
		 // Grab Charmed Objects:
		with(charm_object){
			if(instance_exists(self) && self.id > _newID){
				with(instances_matching_gt(self, "id", _newID)){
					 // 'instance_copy()' Fix:
					if("ntte_charm" in self && ntte_charm.charmed && array_find_index(charm_instance_list, self) < 0){
						ntte_charm = lq_clone(ntte_charm);
						array_push(charm_instance_list, self);
						array_push(charm_instance_vars, ntte_charm);
					}
					
					 // Inherit Charm from Creator:
					else if("creator" in self){
						var _hitme = (instance_is(self, hitme) || instance_is(self, becomenemy));
						with(charm_instance_list){
							if(other.creator == self || ("creator" in self && !instance_is(self, hitme) && other.creator == creator)){
								if(!_hitme || !instance_exists(self) || place_meeting(x, y, other)){
									var	_vars  = charm_instance_vars[array_find_index(charm_instance_list, self)],
										_charm = charm_instance(other, true);
										
									_charm.time    = _vars.time;
									_charm.index   = _vars.index;
									_charm.kill    = _vars.kill;
									_charm.feather = _vars.feather;
									
									if(_hitme){
										with(other){
											 // Kill When Uncharmed if Infinitely Spawned:
											if(instance_is(self, enemy) && !enemy_boss && kills <= 0){
												_charm.kill = true;
												raddrop = 0;
											}
											
											 // Featherize:
											if(_charm.feather && _charm.time >= 0){
												do{
													with(obj_create(x + orandom(24), y + orandom(24), "ParrotFeather")){
														target = other;
														index  = _charm.index;
														with(player_find(index)){
															other.bskin = bskin;
														}
														sprite_index = race_get_sprite(mod_current, sprite_index);
														_charm.time -= stick_time * 1.5;
													}
												}
												until(_charm.time <= 0);
												
												_charm.time = 15;
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		 // Allied Crystal Fixes:
		if(instance_exists(crystaltype)){
			 // Charge Particles:
			if(instance_exists(LaserCrystal) || instance_exists(InvLaserCrystal)){
				if(instance_exists(LaserCharge) && LaserCharge.id > _newID){
					var _instCharm = instances_matching_ne([LaserCrystal, InvLaserCrystal], "ntte_charm", null);
					if(array_length(_instCharm)){
						with(instances_matching_gt(LaserCharge, "id", _newID)){
							with(_instCharm){
								if(ntte_charm.charmed){
									var	_x1  = other.xstart,
										_y1  = other.ystart,
										_x2  = x,
										_y2  = y,
										_dis = point_distance(_x1, _y1, _x2, _y2),
										_dir = point_direction(_x1, _y1, _x2, _y2);
										
									if(_dis < 5 || (other.alarm0 == floor(1 + (_dis / other.speed)) && abs(angle_difference(other.direction, _dir)) < 0.1)){
										team_instance_sprite(team, other);
										break;
									}
								}
							}
						}
					}
				}
			}
			
			 // Lightning:
			if(instance_exists(LightningCrystal)){
				if(instance_exists(EnemyLightning) && EnemyLightning.id > _newID){
					var _instCharm = instances_matching_ne(LightningCrystal, "ntte_charm", null);
					if(array_length(_instCharm)){
						with(instances_matching(instances_matching_gt(EnemyLightning, "id", _newID), "sprite_index", sprEnemyLightning)){
							if(!instance_exists(creator)){
								with(instances_matching(_instCharm, "team", team)){
									if(ntte_charm.charmed && distance_to_object(other) < 56){
										other.sprite_index = sprLightning;
										break;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
#define ntte_begin_step
	 // Charm Draw Setup:
	with(charm_bind_draw){
		if(instance_exists(id)){
			id.visible = false;
		}
		script[3] = [];
	}
	
	 // Charm Main Code:
	if(array_length(charm_instance_list)){
		var	_instNum  = 0,
			_instList = array_clone(charm_instance_list),
			_varsList = array_clone(charm_instance_vars);
			
		with(_instList){
			var _vars = _varsList[_instNum++];
			if(_vars.charmed){
				if(instance_exists(self)){
					 // Main Code:
					if("ntte_charm_override" not in self || !ntte_charm_override){
						var	_lastDir  = direction,
							_isCustom = (string_pos("Custom", object_get_name(object_index)) == 1);
							
						 // Emergency Target:
						if(!instance_exists(_vars.target)){
							with(charm_target(_vars)){
								with(self[0]){
									x = other[1];
									y = other[2];
								}
							}
						}
						
						 // Increased Aggro:
						if(alarm1 > 0 && current_frame_active && instance_is(self, enemy)){
							var _aggroSpeed = ceil(((10 / max(1, size)) - 1) * max(1, current_time_scale));
							
							 // Boss Intro Over:
							if("intro" not in self || intro){
								 // Not Attacking:
								if(
									alarm2 < 0
									&& ("ammo" not in self || ammo <= 0)
									&& (sprite_index == spr_idle || sprite_index == spr_walk || sprite_index == spr_hurt)
									&& (!instance_exists(projectile)      || !array_length(instances_matching(projectile,      "creator", self)))
									&& (!instance_exists(ReviveArea)      || !array_length(instances_matching(ReviveArea,      "creator", self)))
									&& (!instance_exists(NecroReviveArea) || !array_length(instances_matching(NecroReviveArea, "creator", self)))
								){
									 // Not Shielding:
									if(!instance_exists(PopoShield) || !array_length(instances_matching(PopoShield, "creator", self))){
										alarm1 = max(alarm1 - _aggroSpeed, 1);
									}
								}
							}
						}
						
						 // Custom (Override Step Event):
						if(_isCustom){
							if(!array_length(_vars.on_step) && is_array(on_step)){
								_vars.on_step = on_step;
								on_step = script_ref_create(charm_obj_step);
							}
						}
						
						 // Normal (Run Alarms):
						else{
							var _minID = undefined;
							
							for(var _alarmNum = 0; _alarmNum <= 10; _alarmNum++){
								var _alarm = alarm_get(_alarmNum);
								if(_alarm > 0 && _alarm <= ceil(current_time_scale)){
									var _playerPos = charm_target(_vars);
									
									if(is_undefined(_minID)){
										_minID = instance_max;
									}
									
									 // Call Alarm Event:
									with(self){
										if(_alarmNum != 2 || instance_exists(target) || !instance_is(self, Gator)){ // Gator Fix
											try{
												alarm_set(_alarmNum, 0);
												event_perform(ev_alarm, _alarmNum);
											}
											catch(_error){
												trace_error(_error);
											}
										}
									}
									
									 // Return Moved Players:
									with(_playerPos){
										with(self[0]){
											x = other[1];
											y = other[2];
										}
									}
									
									 // 1 Frame Extra:
									if(instance_exists(self)){
										_alarm = alarm_get(_alarmNum);
										if(_alarm > 0){
											alarm_set(_alarmNum, _alarm + 1);
										}
									}
									else break;
								}
							}
							
							 // Grab Spawned Things:
							if(!is_undefined(_minID)){
								charm_grab(_vars, _minID);
							}
						}
						
						 // Enemy Stuff:
						if(instance_is(self, enemy)){
							 // Add to Charm Drawing:
							if(visible){
								with(charm_bind_draw[_vars.index + 1].id){
									array_push(script[3], other);
									if(!visible || other.depth - 1 < depth){
										visible = true;
										depth   = other.depth - 1;
									}
								}
							}
							
							 // Follow Leader:
							if(instance_exists(Player)){
								if("ammo" not in self || ammo <= 0){
									if(
										meleedamage <= 0
										|| "gunangle" in self
										|| ("walk" in self && walk > 0 && !instance_is(self, ExploFreak))
									){
										if(
											!instance_exists(_vars.target)
											|| collision_line(x, y, _vars.target.x, _vars.target.y, Wall, false, false)
											|| distance_to_object(_vars.target) > 80
											|| distance_to_object(Player) > 256
										){
											 // Player to Follow:
											var _follow = player_find(_vars.index);
											if(!instance_exists(_follow)){
												_follow = instance_nearest(x, y, Player);
											}
											
											 // Stay in Range:
											if(distance_to_object(_follow) > 32){
												motion_add_ct(point_direction(x, y, _follow.x, _follow.y), 1);
											}
										}
									}
								}
							}
							
							 // Contact Damage:
							if(place_meeting(x, y, enemy)){
								var _inst = instances_meeting(x, y, instances_matching_ne(enemy, "team", team));
								if(array_length(_inst)) with(_inst){
									if(place_meeting(x, y, other)) with(other){
										var	_lastFreeze   = UberCont.opt_freeze,
											_lastGamma    = skill_get(mut_gamma_guts),
											_lastNextHurt = (("nexthurt" in other) ? other.nexthurt : 0);
											
										 // Disable Freeze Frames:
										UberCont.opt_freeze = 0;
										
										 // Gamma Guts Fix (It breaks contact damage idk):
										skill_set(mut_gamma_guts, false);
										
										 // Speed Up 'canmelee' Reset:
										if(alarm11 > 0 && alarm11 < 26){
											with(self){
												event_perform(ev_alarm, 11);
											}
										}
										
										 // Collision:
										event_perform(ev_collision, Player);
										
										 // No I-Frames:
										if("nexthurt" in other){
											other.nexthurt = _lastNextHurt;
										}
										
										 // Reset Stuff:
										UberCont.opt_freeze = _lastFreeze;
										skill_set(mut_gamma_guts, _lastGamma);
									}
								}
							}
						}
						
						 // Object-Specifics:
						if(instance_exists(self) && !_isCustom){
							switch(object_index){
								
								case BigMaggot:
									
									if(
										alarm1 < 0
										&& instance_exists(_vars.target)
										&& !collision_line(x, y, _vars.target.x, _vars.target.y, Wall, false, false)
									){
										alarm1 = 900; // JW u did this to me
									}
									
									break;
									
								case MeleeBandit:
								case JungleAssassin:
									
									if(walk > 0){
										var _spd = ((object_index == JungleAssassin) ? 1 : 2) * current_time_scale;
										
										 // Fix Janky Movement:
										direction = _lastDir;
										
										 // Undo Player Following:
										if(instance_exists(Player)){
											var	_ox = lengthdir_x(_spd, _lastDir),
												_oy = lengthdir_y(_spd, _lastDir);
												
											if(place_free(x - _ox, y)) x -= _ox;
											if(place_free(x, y - _oy)) y -= _oy;
										}
										
										 // Move Towards Target:
										if(instance_exists(_vars.target)){
											mp_potential_step(_vars.target.x, _vars.target.y, _spd, false);
										}
									}
									
									break;
									
								case Sniper:
									
									 // Aim at Target:
									if(alarm2 > 5 && instance_exists(_vars.target)){
										gunangle = point_direction(x, y, _vars.target.x, _vars.target.y);
										script_bind_step(charm_sniper_gunangle, 0, self, gunangle);
									}
									
									break;
									
								case ScrapBoss:
									
									 // Move Towards Target:
									if(walk > 0 && instance_exists(_vars.target)){
										motion_add(point_direction(x, y, _vars.target.x, _vars.target.y), 0.5);
									}
									
									break;
									
								case ScrapBossMissile:
									
									 // Move Towards Target:
									if(sprite_index != spr_hurt && instance_exists(_vars.target)){
										motion_add_ct(point_direction(x, y, _vars.target.x, _vars.target.y), 0.2);
									}
									
									break;
									
								case LilHunterFly:
									
									 // Land on Enemies:
									if(sprite_index == sprLilHunterLand && z < -160){
										if(instance_exists(_vars.target)){
											x = _vars.target.x;
											y = _vars.target.y;
										}
									}
									
									break;
									
								case ExploFreak:
								case RhinoFreak:
									
									 // Move Towards Target:
									var _spd = current_time_scale;
									if(instance_exists(Player)){
										var	_ox = lengthdir_x(_spd, _lastDir),
											_oy = lengthdir_y(_spd, _lastDir);
											
										if(place_free(x - _ox, y)) x -= _ox;
										if(place_free(x, y - _oy)) y -= _oy;
									}
									if(instance_exists(_vars.target)){
										mp_potential_step(_vars.target.x, _vars.target.y, _spd, false);
									}
									
									break;
									
								case Shielder:
								case EliteShielder:
									
									 // Fix Shield Team:
									var _inst = instances_matching(PopoShield, "creator", self);
									if(array_length(_inst)) with(_inst){
										team = other.team;
									}
									
									break;
									
								case Inspector:
								case EliteInspector:
									
									 // Fix Telekinesis Pull:
									if(control == true){
										var _inst = instances_matching([Player, Ally], "team", team);
										if(array_length(_inst)){
											var _dis = (1 + (object_index == EliteInspector)) * current_time_scale;
											with(_inst){
												if(point_distance(x, y, other.x, other.y) < 160){
													var	_dir = point_direction(x, y, other.x, other.y),
														_ox  = lengthdir_x(_dis, _dir),
														_oy  = lengthdir_y(_dis, _dir);
														
													if(place_free(x + _ox, y)) x -= _ox;
													if(place_free(x, y + _oy)) y -= _oy;
												}
											}
										}
									}
									
									break;
									
								case EnemyHorror:
									
									 // Don't Shoot Beam at Player:
									if(ammo > 0 && instance_exists(_vars.target)){
										var _player = instance_nearest(x, y, Player);
										if(instance_exists(_player)){
											gunangle = point_direction(x, y, _player.x, _player.y);
											
											if(abs(angle_difference(point_direction(x, y, _vars.target.x, _vars.target.y), gunangle + gunoffset)) > 10){
												gunoffset = angle_difference(point_direction(x, y, _vars.target.x, _vars.target.y), gunangle) + orandom(10);
											}
										}
									}
									
									break;
									
							}
						}
					}
					
					 // Reset Step Event:
					else if(array_length(_vars.on_step)){
						on_step = _vars.on_step;
						_vars.on_step = [];
					}
					
					if(instance_is(self, hitme) || instance_is(self, becomenemy)){
						 // <3
						if(random(200) < current_time_scale){
							with(instance_create(x + orandom(8), y - random(8), AllyDamage)){
								sprite_index  = sprHealFX;
								image_xscale *= random_range(2/3, 1);
								image_yscale  = image_xscale;
								motion_add(other.direction, 1);
								speed /= 2;
							}
						}
						
						 // Level Over:
						if(_vars.kill && instance_is(self, enemy) && !array_length(instances_matching_ne(instances_matching_ne(enemy, "team", team), "object_index", Van))){
							charm_instance(self, false);
						}
						
						 // Charm Timer:
						else if(_vars.time >= 0){
							_vars.time -= min(_vars.time, current_time_scale);
							if(_vars.time <= 0 && instance_is(self, hitme)){
								charm_instance(self, false);
							}
						}
						
						 // Charm Bros Spawned on Death:
						switch(object_index){
							
							case BigMaggot:
							case MaggotSpawn:
							case JungleFly:
							case FiredMaggot:
							case RatkingRage:
							case InvSpider:
								
								if(
									my_health <= 0
									|| (object_index == FiredMaggot && place_meeting(x + hspeed_raw, y + vspeed_raw, Wall))
									|| (object_index == RatkingRage && walk > 0 && walk <= current_time_scale)
								){
									var _minID = instance_max;
									instance_destroy();
									with(instances_matching_gt(charm_object, "id", _minID)){
										creator = other;
									}
								}
								
								break;
								
						}
					}
					else if(!instance_exists(self)){
						_vars.charmed = false;
					}
				}
				else _vars.charmed = false;
			}
			
			 // Done:
			else{
				var _pos = array_find_index(charm_instance_list, self);
				charm_instance_list = array_delete(charm_instance_list, _pos);
				charm_instance_vars = array_delete(charm_instance_vars, _pos);
			}
		}
	}
	
#define ntte_end_step
	 /// ULTRA B : Flock Together / HP Link
	if(instance_exists(Player)){
		var _instParrot = instances_matching(Player, "race", mod_current);
		if(array_length(_instParrot)) with(_instParrot){
			if(ultra_get(mod_current, ult_flock) > 0 && array_length(charm_instance_list)){
				var _instHP = ds_list_create();
				
				 // Gather Charmed Bros:
				with(instances_matching_gt(charm_instance_list, "my_health", 0)){
					if(ntte_charm.charmed && ntte_charm.index == other.index){
						ds_list_add(_instHP, self);
					}
				}
				
				 // Steal Charmed Bro HP:
				var _num = ds_list_size(_instHP);
				if(_num > 0){
					if(sprite_index == spr_hurt && my_health < ntte_charm_flock_hp){
						ntte_charm_flock_hp = ceil(lerp(ntte_charm_flock_hp, my_health, 0.5));
						
						ds_list_shuffle(_instHP);
						
						var _damageRaw = (ntte_charm_flock_hp - my_health) / _num;
						
						for(var i = 0; i < _num; i++){
							var _damage = (
								((i / _num) < frac(_damageRaw))
								?  ceil(_damageRaw)
								: floor(_damageRaw)
							);
							if(_damage > 0){
								var _inst = _instHP[| i];
								my_health += min(_damage, max(0, _inst.my_health));
								projectile_hit_raw(_inst, _damage, true);
								if(!instance_exists(_inst) || _inst.my_health <= 0){
									ds_list_remove(_instHP, _inst);
								}
							}
						}
						
						//my_health = ntte_charm_flock_hp;
						//spiriteffect = max(spiriteffect, 6);
					}
					
					 // HUD Health:
					ntte_charm_flock_hud_hp     = 0;
					ntte_charm_flock_hud_hp_max = 0;
					with(ds_list_to_array(_instHP)){
						other.ntte_charm_flock_hud_hp     += my_health;
						other.ntte_charm_flock_hud_hp_max += maxhealth;
					}
				}
				else ntte_charm_flock_hud_hp = 0;
				
				ds_list_destroy(_instHP);
			}
			else ntte_charm_flock_hud_hp = 0;
			
			 // Save Health:
			ntte_charm_flock_hp = my_health;
			
			 // HUD Ghost Health:
			if(ntte_charm_flock_hud_hp != ntte_charm_flock_hud_hp_lst){
				var _add = 0.5 * current_time_scale;
				ntte_charm_flock_hud_hp_lst += clamp(ntte_charm_flock_hud_hp - ntte_charm_flock_hud_hp_lst, -_add, _add);
			}
			ntte_charm_flock_hud_hp_lst = clamp(ntte_charm_flock_hud_hp_lst, ntte_charm_flock_hud_hp, ntte_charm_flock_hud_hp_max);
			
			 // Expand HUD:
			var _hud = ((ntte_charm_flock_hud_hp > 0) ? 1 : 0);
			if(ntte_charm_flock_hud != _hud){
				if(abs(_hud - ntte_charm_flock_hud) > 0.01){
					_hud = lerp_ct(ntte_charm_flock_hud, _hud, 1/3);
				}
				ntte_charm_flock_hud = _hud;
			}
		}
	}
	
#define charm_instance_raw(_inst, _charm)
	/*
		Charms or uncharms the given instance(s) and returns a LWO containing their charm-related vars
		
		Ex:
			with(charm_instance(Bandit, true)){
				time = 300;
			}
	*/
	
	var _instVars = [];
	
	with(instances_matching_ne(_inst, "id", null)){
		if("ntte_charm" not in self){
			ntte_charm = charm_vars;
		}
		
		var _vars = ntte_charm;
		
		if(_charm ^^ _vars.charmed){
			 // Reset:
			if(_charm){
				var _varsDefault = charm_vars;
				for(var i = lq_size(_varsDefault) - 1; i >= 0; i--){
					lq_set(_vars, lq_get_key(_varsDefault, i), lq_get_value(_varsDefault, i));
				}
			}
			
			 // Become Enemy:
			var _lastObject = object_index;
			if(instance_is(self, becomenemy)){
				var	_lastMask       = mask_index,
					_lastSprite     = sprite_index,
					_lastImage      = image_index,
					_lastDepth      = depth,
					_lastVisible    = visible,
					_lastPersistent = persistent,
					_lastSolid      = solid;
					
				instance_change(enemy, false);
				
				mask_index   = _lastMask;
				sprite_index = _lastSprite;
				image_index  = _lastImage;
				depth        = _lastDepth;
				visible      = _lastVisible;
				persistent   = _lastPersistent;
				solid        = _lastSolid;
			}
			
			 // Set/Reset Team:
			if("team" in self){
				var _lastTeam = team;
				team = _vars.team;
				_vars.team = _lastTeam;
			}
			
			 // Charm:
			if(_charm){
				 // Override Step Event:
				if(string_pos("Custom", object_get_name(object_index)) == 1){
					if(!array_length(_vars.on_step) && is_array(on_step)){
						_vars.on_step = on_step;
						on_step = script_ref_create(charm_obj_step);
					}
				}
				
				 // Delay Alarms:
				else for(var i = 0; i <= 10; i++){
					if(alarm_get(i) > 0){
						alarm_set(i, alarm_get(i) + 1);
					}
				}
				
				 // Necromancer Charm:
				switch(sprite_index){
					case sprReviveArea      : sprite_index = spr.AllyReviveArea;      break;
					case sprNecroReviveArea : sprite_index = spr.AllyNecroReviveArea; break;
				}
				
				 // Add:
				if(array_find_index(charm_instance_list, self) < 0){
					array_push(charm_instance_list, self);
					array_push(charm_instance_vars, _vars);
				}
			}
			
			 // Uncharm:
			else{
				if(instance_is(self, hitme)){
					 // I-Frames:
					//nexthurt = current_frame + 12;
					
					 // Enemies:
					if(instance_is(self, enemy)){
						 // Untarget:
						target = noone;
						
						 // Delay Contact Damage:
						if(canmelee == true){
							alarm11  = 30;
							canmelee = false;
						}
					}
					
					 // Kill:
					if(_vars.kill){
						my_health = 0;
						sound_play_pitchvol(sndEnemyDie, 2 + orandom(0.3), 3);
					}
					
					 // Wake Up Alert:
					else{
						instance_create(x, bbox_top, AssassinNotice);
						sound_play_hit_ext(sndAssassinGetUp, random_range(1.2, 1.5), 1.2);
					}
					
					 // Effects:
					var _num = 10 * max((is_real(size) ? size : 0), 0.5);
					for(var _ang = direction; _ang < direction + 360; _ang += (360 / _num)){
						scrFX(x, y, [_ang, 3], Dust);
					}
				}
				
				 // Necromancer Charm:
				if(sprite_index == spr.AllyReviveArea){
					sprite_index = sprReviveArea;
				}
				else if(sprite_index == spr.AllyNecroReviveArea){
					sprite_index = sprNecroReviveArea;
				}
				
				 // Reset Step Event:
				if(array_length(_vars.on_step)){
					on_step = _vars.on_step;
					_vars.on_step = [];
				}
			}
			
			 // Unbecome Enemy:
			if(object_index != _lastObject){
				var	_lastMask       = mask_index,
					_lastSprite     = sprite_index,
					_lastImage      = image_index,
					_lastDepth      = depth,
					_lastVisible    = visible,
					_lastPersistent = persistent,
					_lastSolid      = solid;
					
				instance_change(_lastObject, false);
				
				mask_index   = _lastMask;
				sprite_index = _lastSprite;
				image_index  = _lastImage;
				depth        = _lastDepth;
				visible      = _lastVisible;
				persistent   = _lastPersistent;
				solid        = _lastSolid;
			}
			
			 // Teamerize Nearby Projectiles:
			if(instance_is(self, hitme)){
				var _searchDis = 32;
				motion_step(1);
				if(distance_to_object(projectile) <= _searchDis){
					with(instance_rectangle_bbox(
						bbox_left   - _searchDis,
						bbox_top    - _searchDis,
						bbox_right  + _searchDis,
						bbox_bottom + _searchDis,
						instances_matching(instances_matching(projectile, "team", _vars.team), "creator", self)
					)){
						motion_step(1);
						if(place_meeting(x, y, other)){
							team = other.team;
							if(sprite_get_team(sprite_index) != 3){
								team_instance_sprite(team, self);
								if(!instance_exists(self)){
									continue;
								}
							}
						}
						motion_step(-1);
					}
				}
				motion_step(-1);
			}
		}
		
		_vars.charmed = _charm;
		
		array_push(_instVars, _vars);
	}
	
	 // Return:
	if(array_length(_instVars)){
		return (
			(is_array(_inst) || array_length(_instVars) > 1)
			? _instVars
			: _instVars[0]
		);
	}
	
	return noone;
	
#define charm_target(_vars)
	/*
		Targets a nearby enemy and moves the player to their position
		Returns an array containing the moved players and their previous position, [id, x, y]
	*/
	
	var	_playerPos   = [],
		_targetCrash = (!instance_exists(Player) && instance_is(self, Grunt)); // References player-specific vars in its alarm event, causing a crash
		
	 // Targeting:
	if(
		!instance_exists(_vars.target)
		|| collision_line(x, y, _vars.target.x, _vars.target.y, Wall, false, false)
		|| !instance_is(_vars.target, hitme)
		|| _vars.target.team == variable_instance_get(self, "team")
		|| _vars.target.team == variable_instance_get(player_find(_vars.index), "team")
		|| _vars.target.mask_index == mskNone
	){
		_vars.target = noone;
		
		var _inst = instances_matching_ne(instances_matching_ne([enemy, Player, Sapling, Ally, SentryGun, CustomHitme], "team", 0), "mask_index", mskNone);
		if(array_length(_inst)){
			 // Team Check:
			if("team" in self){
				_inst = instances_matching_ne(_inst, "team", team);
			}
			if(player_is_active(_vars.index)){
				with(player_find(_vars.index)){
					_inst = instances_matching_ne(_inst, "team", team);
				}
			}
			
			 // Target Nearest:
			var _disMax = infinity;
			if(array_length(_inst)) with(_inst){
				var _dis = point_distance(x, y, other.x, other.y);
				if(_dis < _disMax){
					if(!instance_is(self, prop)){
						_disMax = _dis;
						_vars.target = self;
					}
				}
			}
		}
	}
	
	 // Move Players to Target (the key to this system):
	if("target" in self){
		if(!_targetCrash){
			target = _vars.target;
		}
		
		with(Player){
			array_push(_playerPos, [self, x, y]);
			
			if(instance_exists(_vars.target)){
				x = _vars.target.x;
				y = _vars.target.y;
			}
			
			else{
				var	_l = 10000,
					_d = random(360);
					
				x += lengthdir_x(_l, _d);
				y += lengthdir_y(_l, _d);
			}
		}
	}
	
	return _playerPos;
	
#define charm_grab(_vars, _minID)
	/*
		Finds any charmable instances above the given minimum ID to set 'creator' on unowned ones, and resprite any projectiles to the charmed enemy's team
	*/
	
	if(instance_exists(GameObject) && GameObject.id > _minID){
		 // Set Creator:
		var _inst = instances_matching(instances_matching_gt(charm_object, "id", _minID), "creator", null, noone);
		if(array_length(_inst)){
			var _creator = (
				("creator" in self && !instance_is(self, hitme))
				? creator
				: self
			);
			with(_inst){
				creator = _creator;
			}
		}
		
		 // Ally-ify Projectiles:
		if(instance_exists(projectile) || instance_exists(LaserCannon)){
			var _inst = instances_matching_gt([projectile, LaserCannon], "id", _minID);
			if(array_length(_inst)){
				if("creator" in self && !instance_is(self, hitme)){
					_inst = instances_matching(_inst, "creator", self, noone, creator);
				}
				else{
					_inst = instances_matching(_inst, "creator", self, noone);
				}
				if(array_length(_inst)) with(_inst){
					if(sprite_get_team(sprite_index) != 3){
						team_instance_sprite(team, self);
					}
				}
			}
		}
	}
	
#define charm_obj_step
	var _vars = ntte_charm;
	if(array_length(_vars.on_step) >= 3){
		var	_minID     = instance_max,
			_playerPos = charm_target(_vars);
			
		 // Call Step Event:
		if(fork()){
			on_step = _vars.on_step;
			_vars.on_step = [];
			script_ref_call(on_step);
			exit;
		}
		
		 // Return Moved Players:
		with(_playerPos){
			with(self[0]){
				x = other[1];
				y = other[2];
			}
		}
		
		 // Reset Step:
		if(instance_exists(self)){
			_vars.on_step = on_step;
			on_step = script_ref_create(charm_obj_step);
		}
		
		 // Grab Spawned Things:
		charm_grab(_vars, _minID);
	}
	
#define charm_draw(_inst, _index)
	/*
		Draws green eyes and outlines for charmed enemies
	*/
	
	if(array_length(_inst)){
		if(lag) trace_time();
		
		var _outline = option_get("outline:charm");
		
		if(_outline || option_get("shaders")){
			if(_index < 0){
				_index = player_find_local_nonsync();
			}
			
			var	_vx = view_xview_nonsync,
				_vy = view_yview_nonsync,
				_gw = game_width,
				_gh = game_height;
				
			with(surface_setup("CharmScreen", _gw, _gh, game_scale_nonsync)){
				x = _vx;
				y = _vy;
				
				 // Copy & Clear Screen:
				draw_set_blend_mode_ext(bm_one, bm_zero);
				surface_screenshot(surf);
				draw_set_blend_mode(bm_normal);
				draw_clear_alpha(c_black, 0);
				
				 // Call Enemy Draw Events:
				var _lastTimeScale = current_time_scale;
				current_time_scale = 1/1000000000000000;
				try{
					with(instances_seen(_inst, 24, 24, -1)){
						with(self){
							event_perform(ev_draw, 0);
						}
					}
				}
				catch(_error){
					trace(_error);
				}
				current_time_scale = _lastTimeScale;
				
				 // Copy Enemy Drawing:
				with(surface_setup("Charm", w, h, (_outline ? option_get("quality:main") : scale))){
					x = other.x;
					y = other.y;
					
					 // Copy Enemy Drawing:
					draw_set_blend_mode_ext(bm_one, bm_zero);
					surface_screenshot(surf);
					
					 // Unblend Color/Alpha:
					if(shader_setup("Unblend", surface_get_texture(surf), [1])){
						draw_surface_scale(surf, x, y, 1 / scale);
						shader_reset();
						surface_screenshot(surf);
					}
					else{
						draw_set_blend_mode_ext(bm_inv_src_alpha, bm_one); // Partial Unblend
						surface_screenshot(surf);
						draw_set_blend_mode_ext(bm_one, bm_zero);
					}
					
					 // Redraw Screen:
					with(other){
						draw_surface_scale(surf, x, y, 1 / scale);
					}
					draw_set_blend_mode(bm_normal);
					
					 // Outlines:
					if(_outline){
						surface_set_target(other.surf);
						
						 // Solid Color:
						draw_set_fog(true, player_get_color(_index), 0, 0);
						for(var _ang = 0; _ang < 360; _ang += 90){
							draw_surface_scale(
								surf,
								(x - other.x + dcos(_ang)) * other.scale,
								(y - other.y - dsin(_ang)) * other.scale,
								other.scale / scale
							);
						}
						draw_set_fog(false, 0, 0, 0);
						
						 // Cut Out Enemy:
						draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
						draw_surface_scale(surf, (x - other.x) * other.scale, (y - other.y) * other.scale, other.scale / scale);
						draw_set_blend_mode(bm_normal);
						
						surface_reset_target();
						
						 // Draw to Screen:
						with(other){
							draw_surface_scale(surf, x, y, 1 / scale);
						}
					}
					
					 // Eye Shader:
					if(shader_setup("Charm", surface_get_texture(surf), [w, h])){
						draw_surface_scale(surf, x, y, 1 / scale);
						shader_reset();
					}
				}
			}
		}
		
		if(lag) trace_time(script[2] + " " + string(_index));
	}
	
#define charm_sniper_gunangle(_inst, _direction)
	with(_inst){
		gunangle = _direction;
	}
	instance_destroy();
	
	
/// SCRIPTS
#macro  type_melee                                                                              0
#macro  type_bullet                                                                             1
#macro  type_shell                                                                              2
#macro  type_bolt                                                                               3
#macro  type_explosive                                                                          4
#macro  type_energy                                                                             5
#macro  area_campfire                                                                           0
#macro  area_desert                                                                             1
#macro  area_sewers                                                                             2
#macro  area_scrapyards                                                                         3
#macro  area_caves                                                                              4
#macro  area_city                                                                               5
#macro  area_labs                                                                               6
#macro  area_palace                                                                             7
#macro  area_vault                                                                              100
#macro  area_oasis                                                                              101
#macro  area_pizza_sewers                                                                       102
#macro  area_mansion                                                                            103
#macro  area_cursed_caves                                                                       104
#macro  area_jungle                                                                             105
#macro  area_hq                                                                                 106
#macro  area_crib                                                                               107
#macro  infinity                                                                                1/0
#macro  instance_max                                                                            instance_create(0, 0, DramaCamera)
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro  enemy_boss                                                                              ('boss' in self) ? boss : ('intro' in self || array_find_index([Nothing, Nothing2, BigFish, OasisBoss], object_index) >= 0)
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  target_visible                                                                          !collision_line(x, y, target.x, target.y, Wall, false, false)
#macro  target_direction                                                                        point_direction(x, y, target.x, target.y)
#macro  target_distance                                                                         point_distance(x, y, target.x, target.y)
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#macro  alarm0_run                                                                              alarm0 && !--alarm0 && !--alarm0 && (script_ref_call(on_alrm0) || !instance_exists(self))
#macro  alarm1_run                                                                              alarm1 && !--alarm1 && !--alarm1 && (script_ref_call(on_alrm1) || !instance_exists(self))
#macro  alarm2_run                                                                              alarm2 && !--alarm2 && !--alarm2 && (script_ref_call(on_alrm2) || !instance_exists(self))
#macro  alarm3_run                                                                              alarm3 && !--alarm3 && !--alarm3 && (script_ref_call(on_alrm3) || !instance_exists(self))
#macro  alarm4_run                                                                              alarm4 && !--alarm4 && !--alarm4 && (script_ref_call(on_alrm4) || !instance_exists(self))
#macro  alarm5_run                                                                              alarm5 && !--alarm5 && !--alarm5 && (script_ref_call(on_alrm5) || !instance_exists(self))
#macro  alarm6_run                                                                              alarm6 && !--alarm6 && !--alarm6 && (script_ref_call(on_alrm6) || !instance_exists(self))
#macro  alarm7_run                                                                              alarm7 && !--alarm7 && !--alarm7 && (script_ref_call(on_alrm7) || !instance_exists(self))
#macro  alarm8_run                                                                              alarm8 && !--alarm8 && !--alarm8 && (script_ref_call(on_alrm8) || !instance_exists(self))
#macro  alarm9_run                                                                              alarm9 && !--alarm9 && !--alarm9 && (script_ref_call(on_alrm9) || !instance_exists(self))
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < _numer * current_time_scale;
#define pround(_num, _precision)                                                        return  (_num == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_num == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_num == 0) ? _num :  ceil(_num / _precision) * _precision;
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define lerp_ct(_val1, _val2, _amount)                                                  return  lerp(_val2, _val1, power(1 - _amount, current_time_scale));
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define angle_lerp_ct(_ang1, _ang2, _num)                                               return  _ang2 + (angle_difference(_ang1, _ang2) * power(1 - _num, current_time_scale));
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_dir, _num)                                                                  direction = _dir; walk = _num; if(speed < friction_raw) speed = friction_raw;
#define enemy_face(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1;
#define enemy_look(_dir)                                                                        _dir = ((_dir % 360) + 360) % 360; if(_dir < 90 || _dir > 270) right = 1; else if(_dir > 90 && _dir < 270) right = -1; if('gunangle' in self) gunangle = _dir;
#define enemy_target(_x, _y)                                                                    target = (instance_exists(Player) ? instance_nearest(_x, _y, Player) : ((instance_exists(target) && target >= 0) ? target : noone)); return (target != noone);
#define save_get(_name, _default)                                                       return  mod_script_call_nc  ('mod', 'teassets', 'save_get', _name, _default);
#define save_set(_name, _value)                                                                 mod_script_call_nc  ('mod', 'teassets', 'save_set', _name, _value);
#define option_get(_name)                                                               return  mod_script_call_nc  ('mod', 'teassets', 'option_get', _name);
#define option_set(_name, _value)                                                               mod_script_call_nc  ('mod', 'teassets', 'option_set', _name, _value);
#define stat_get(_name)                                                                 return  mod_script_call_nc  ('mod', 'teassets', 'stat_get', _name);
#define stat_set(_name, _value)                                                                 mod_script_call_nc  ('mod', 'teassets', 'stat_set', _name, _value);
#define unlock_get(_name)                                                               return  mod_script_call_nc  ('mod', 'teassets', 'unlock_get', _name);
#define unlock_set(_name, _value)                                                       return  mod_script_call_nc  ('mod', 'teassets', 'unlock_set', _name, _value);
#define surface_setup(_name, _w, _h, _scale)                                            return  mod_script_call_nc  ('mod', 'teassets', 'surface_setup', _name, _w, _h, _scale);
#define shader_setup(_name, _texture, _args)                                            return  mod_script_call_nc  ('mod', 'teassets', 'shader_setup', _name, _texture, _args);
#define shader_add(_name, _vertex, _fragment)                                           return  mod_script_call_nc  ('mod', 'teassets', 'shader_add', _name, _vertex, _fragment);
#define script_bind(_scriptObj, _scriptRef, _depth, _visible)                           return  mod_script_call_nc  ('mod', 'teassets', 'script_bind', script_ref_create(script_bind), _scriptObj, (is_real(_scriptRef) ? script_ref_create(_scriptRef) : _scriptRef), _depth, _visible);
#define obj_create(_x, _y, _obj)                                                        return  (is_undefined(_obj) ? [] : mod_script_call_nc('mod', 'telib', 'obj_create', _x, _y, _obj));
#define top_create(_x, _y, _obj, _spawnDir, _spawnDis)                                  return  mod_script_call_nc  ('mod', 'telib', 'top_create', _x, _y, _obj, _spawnDir, _spawnDis);
#define projectile_create(_x, _y, _obj, _dir, _spd)                                     return  mod_script_call_self('mod', 'telib', 'projectile_create', _x, _y, _obj, _dir, _spd);
#define chest_create(_x, _y, _obj, _levelStart)                                         return  mod_script_call_nc  ('mod', 'telib', 'chest_create', _x, _y, _obj, _levelStart);
#define prompt_create(_text)                                                            return  mod_script_call_self('mod', 'telib', 'prompt_create', _text);
#define alert_create(_inst, _sprite)                                                    return  mod_script_call_self('mod', 'telib', 'alert_create', _inst, _sprite);
#define door_create(_x, _y, _dir)                                                       return  mod_script_call_nc  ('mod', 'telib', 'door_create', _x, _y, _dir);
#define trace_error(_error)                                                                     mod_script_call_nc  ('mod', 'telib', 'trace_error', _error);
#define view_shift(_index, _dir, _pan)                                                          mod_script_call_nc  ('mod', 'telib', 'view_shift', _index, _dir, _pan);
#define sleep_max(_milliseconds)                                                                mod_script_call_nc  ('mod', 'telib', 'sleep_max', _milliseconds);
#define instance_budge(_objAvoid, _disMax)                                              return  mod_script_call_self('mod', 'telib', 'instance_budge', _objAvoid, _disMax);
#define instance_random(_obj)                                                           return  mod_script_call_nc  ('mod', 'telib', 'instance_random', _obj);
#define instance_clone()                                                                return  mod_script_call_self('mod', 'telib', 'instance_clone');
#define instance_nearest_array(_x, _y, _inst)                                           return  mod_script_call_nc  ('mod', 'telib', 'instance_nearest_array', _x, _y, _inst);
#define instance_nearest_bbox(_x, _y, _inst)                                            return  mod_script_call_nc  ('mod', 'telib', 'instance_nearest_bbox', _x, _y, _inst);
#define instance_nearest_rectangle(_x1, _y1, _x2, _y2, _inst)                           return  mod_script_call_nc  ('mod', 'telib', 'instance_nearest_rectangle', _x1, _y1, _x2, _y2, _inst);
#define instance_rectangle(_x1, _y1, _x2, _y2, _obj)                                    return  mod_script_call_nc  ('mod', 'telib', 'instance_rectangle', _x1, _y1, _x2, _y2, _obj);
#define instance_rectangle_bbox(_x1, _y1, _x2, _y2, _obj)                               return  mod_script_call_nc  ('mod', 'telib', 'instance_rectangle_bbox', _x1, _y1, _x2, _y2, _obj);
#define instances_at(_x, _y, _obj)                                                      return  mod_script_call_nc  ('mod', 'telib', 'instances_at', _x, _y, _obj);
#define instances_seen(_obj, _bx, _by, _index)                                          return  mod_script_call_nc  ('mod', 'telib', 'instances_seen', _obj, _bx, _by, _index);
#define instances_seen_nonsync(_obj, _bx, _by)                                          return  mod_script_call_nc  ('mod', 'telib', 'instances_seen_nonsync', _obj, _bx, _by);
#define instances_meeting(_x, _y, _obj)                                                 return  mod_script_call_self('mod', 'telib', 'instances_meeting', _x, _y, _obj);
#define instance_get_name(_inst)                                                        return  mod_script_call_nc  ('mod', 'telib', 'instance_get_name', _inst);
#define variable_instance_get_list(_inst)                                               return  mod_script_call_nc  ('mod', 'telib', 'variable_instance_get_list', _inst);
#define variable_instance_set_list(_inst, _list)                                                mod_script_call_nc  ('mod', 'telib', 'variable_instance_set_list', _inst, _list);
#define draw_weapon(_spr, _img, _x, _y, _ang, _angMelee, _kick, _flip, _blend, _alpha)          mod_script_call_nc  ('mod', 'telib', 'draw_weapon', _spr, _img, _x, _y, _ang, _angMelee, _kick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc  ('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_surface_scale(_surf, _x, _y, _scale)                                               mod_script_call_nc  ('mod', 'telib', 'draw_surface_scale', _surf, _x, _y, _scale);
#define array_count(_array, _value)                                                     return  mod_script_call_nc  ('mod', 'telib', 'array_count', _array, _value);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc  ('mod', 'telib', 'array_combine', _array1, _array2);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc  ('mod', 'telib', 'array_delete', _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc  ('mod', 'telib', 'array_delete_value', _array, _value);
#define array_flip(_array)                                                              return  mod_script_call_nc  ('mod', 'telib', 'array_flip', _array);
#define array_shuffle(_array)                                                           return  mod_script_call_nc  ('mod', 'telib', 'array_shuffle', _array);
#define data_clone(_value, _depth)                                                      return  mod_script_call_nc  ('mod', 'telib', 'data_clone', _value, _depth);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc  ('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define enemy_hurt(_damage, _force, _direction)                                                 mod_script_call_self('mod', 'telib', 'enemy_hurt', _damage, _force, _direction);
#define boss_hp(_hp)                                                                    return  mod_script_call_nc  ('mod', 'telib', 'boss_hp', _hp);
#define boss_intro(_name)                                                               return  mod_script_call_nc  ('mod', 'telib', 'boss_intro', _name);
#define corpse_drop(_dir, _spd)                                                         return  mod_script_call_self('mod', 'telib', 'corpse_drop', _dir, _spd);
#define rad_drop(_x, _y, _raddrop, _dir, _spd)                                          return  mod_script_call_nc  ('mod', 'telib', 'rad_drop', _x, _y, _raddrop, _dir, _spd);
#define rad_path(_inst, _target)                                                        return  mod_script_call_nc  ('mod', 'telib', 'rad_path', _inst, _target);
#define area_set(_area, _subarea, _loops)                                               return  mod_script_call_nc  ('mod', 'telib', 'area_set', _area, _subarea, _loops);
#define area_get_name(_area, _subarea, _loops)                                          return  mod_script_call_nc  ('mod', 'telib', 'area_get_name', _area, _subarea, _loops);
#define area_get_sprite(_area, _spr)                                                    return  mod_script_call     ('mod', 'telib', 'area_get_sprite', _area, _spr);
#define area_get_subarea(_area)                                                         return  mod_script_call_nc  ('mod', 'telib', 'area_get_subarea', _area);
#define area_get_secret(_area)                                                          return  mod_script_call_nc  ('mod', 'telib', 'area_get_secret', _area);
#define area_get_underwater(_area)                                                      return  mod_script_call_nc  ('mod', 'telib', 'area_get_underwater', _area);
#define area_get_back_color(_area)                                                      return  mod_script_call_nc  ('mod', 'telib', 'area_get_back_color', _area);
#define area_generate(_area, _sub, _loops, _x, _y, _setArea, _overlapFloor, _scrSetup)  return  mod_script_call_nc  ('mod', 'telib', 'area_generate', _area, _sub, _loops, _x, _y, _setArea, _overlapFloor, _scrSetup);
#define floor_set(_x, _y, _state)                                                       return  mod_script_call_nc  ('mod', 'telib', 'floor_set', _x, _y, _state);
#define floor_set_style(_style, _area)                                                  return  mod_script_call_nc  ('mod', 'telib', 'floor_set_style', _style, _area);
#define floor_set_align(_alignX, _alignY, _alignW, _alignH)                             return  mod_script_call_nc  ('mod', 'telib', 'floor_set_align', _alignX, _alignY, _alignW, _alignH);
#define floor_reset_style()                                                             return  mod_script_call_nc  ('mod', 'telib', 'floor_reset_style');
#define floor_reset_align()                                                             return  mod_script_call_nc  ('mod', 'telib', 'floor_reset_align');
#define floor_fill(_x, _y, _w, _h, _type)                                               return  mod_script_call_nc  ('mod', 'telib', 'floor_fill', _x, _y, _w, _h, _type);
#define floor_room_start(_spawnX, _spawnY, _spawnDis, _spawnFloor)                      return  mod_script_call_nc  ('mod', 'telib', 'floor_room_start', _spawnX, _spawnY, _spawnDis, _spawnFloor);
#define floor_room_create(_x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis)         return  mod_script_call_nc  ('mod', 'telib', 'floor_room_create', _x, _y, _w, _h, _type, _dirStart, _dirOff, _floorDis);
#define floor_room(_spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis) return  mod_script_call_nc  ('mod', 'telib', 'floor_room', _spaX, _spaY, _spaDis, _spaFloor, _w, _h, _type, _dirOff, _floorDis);
#define floor_reveal(_x1, _y1, _x2, _y2, _time)                                         return  mod_script_call_nc  ('mod', 'telib', 'floor_reveal', _x1, _y1, _x2, _y2, _time);
#define floor_tunnel(_x1, _y1, _x2, _y2)                                                return  mod_script_call_nc  ('mod', 'telib', 'floor_tunnel', _x1, _y1, _x2, _y2);
#define floor_bones(_num, _chance, _linked)                                             return  mod_script_call_self('mod', 'telib', 'floor_bones', _num, _chance, _linked);
#define floor_walls()                                                                   return  mod_script_call_self('mod', 'telib', 'floor_walls');
#define wall_tops()                                                                     return  mod_script_call_self('mod', 'telib', 'wall_tops');
#define wall_clear(_x, _y)                                                              return  mod_script_call_self('mod', 'telib', 'wall_clear', _x, _y);
#define wall_delete(_x1, _y1, _x2, _y2)                                                         mod_script_call_nc  ('mod', 'telib', 'wall_delete', _x1, _y1, _x2, _y2);
#define sound_play_hit_ext(_snd, _pit, _vol)                                            return  mod_script_call_self('mod', 'telib', 'sound_play_hit_ext', _snd, _pit, _vol);
#define race_get_sprite(_race, _sprite)                                                 return  mod_script_call     ('mod', 'telib', 'race_get_sprite', _race, _sprite);
#define race_get_title(_race)                                                           return  mod_script_call_self('mod', 'telib', 'race_get_title', _race);
#define player_swap()                                                                   return  mod_script_call_self('mod', 'telib', 'player_swap');
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_wrap(_wep, _scrName, _scrRef)                                               return  mod_script_call_nc  ('mod', 'telib', 'wep_wrap', _wep, _scrName, _scrRef);
#define wep_skin(_wep, _race, _skin)                                                    return  mod_script_call_nc  ('mod', 'telib', 'wep_skin', _wep, _race, _skin);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc  ('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc  ('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call_self('mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define weapon_get(_name, _wep)                                                         return  mod_script_call     ('mod', 'telib', 'weapon_get', _name, _wep);
#define skill_get_icon(_skill)                                                          return  mod_script_call_self('mod', 'telib', 'skill_get_icon', _skill);
#define skill_get_avail(_skill)                                                         return  mod_script_call_self('mod', 'telib', 'skill_get_avail', _skill);
#define string_delete_nt(_string)                                                       return  mod_script_call_nc  ('mod', 'telib', 'string_delete_nt', _string);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc  ('mod', 'telib', 'path_create', _xstart, _ystart, _xtarget, _ytarget, _wall);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc  ('mod', 'telib', 'path_shrink', _path, _wall, _skipMax);
#define path_reaches(_path, _xtarget, _ytarget, _wall)                                  return  mod_script_call_nc  ('mod', 'telib', 'path_reaches', _path, _xtarget, _ytarget, _wall);
#define path_direction(_path, _x, _y, _wall)                                            return  mod_script_call_nc  ('mod', 'telib', 'path_direction', _path, _x, _y, _wall);
#define portal_poof()                                                                   return  mod_script_call_nc  ('mod', 'telib', 'portal_poof');
#define portal_pickups()                                                                return  mod_script_call_nc  ('mod', 'telib', 'portal_pickups');
#define pet_spawn(_x, _y, _name)                                                        return  mod_script_call_nc  ('mod', 'telib', 'pet_spawn', _x, _y, _name);
#define pet_get_name(_name, _modType, _modName, _skin)                                  return  mod_script_call_self('mod', 'telib', 'pet_get_name', _name, _modType, _modName, _skin);
#define pet_get_sprite(_name, _modType, _modName, _skin, _sprName)                      return  mod_script_call_self('mod', 'telib', 'pet_get_sprite', _name, _modType, _modName, _skin, _sprName);
#define pet_set_skin(_skin)                                                             return  mod_script_call_self('mod', 'telib', 'pet_set_skin', _skin);
#define team_get_sprite(_team, _sprite)                                                 return  mod_script_call_nc  ('mod', 'telib', 'team_get_sprite', _team, _sprite);
#define team_instance_sprite(_team, _inst)                                              return  mod_script_call_nc  ('mod', 'telib', 'team_instance_sprite', _team, _inst);
#define sprite_get_team(_sprite)                                                        return  mod_script_call_nc  ('mod', 'telib', 'sprite_get_team', _sprite);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call_self('mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_inst, _charm)                                                   return  mod_script_call_nc  ('mod', 'telib', 'charm_instance', _inst, _charm);
#define motion_step(_mult)                                                              return  mod_script_call_self('mod', 'telib', 'motion_step', _mult);
#define pool(_pool)                                                                     return  mod_script_call_nc  ('mod', 'telib', 'pool', _pool);