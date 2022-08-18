#define init
	ntte_version = 2.06;
	
	 // Debug Lag:
	lag = false;
	
	 // Custom Object Related:
	obj = {};
	with([
		"obj_create_event_ref_map",
		"obj_event_index_list_map",
		"obj_parent_map",
		"obj_search_bind_map",
		"event_obj_list_map",
		"depth_obj_draw_event_instance_map",
		"object_event_index_list_map"
	]){
		mod_variable_set("mod", mod_current, self, ds_map_create());
	}
	
	 // Custom Object Event Variable Names:
	global.event_varname_list = ["script", "on_step", "on_begin_step", "on_end_step", "on_draw", "on_destroy", "on_cleanup", "on_anim", "on_death", "on_hurt", "on_hit", "on_wall", "on_projectile", "on_grenade"];
	var _alarmIndex = 0;
	repeat(10){
		array_push(global.event_varname_list, `on_alrm${_alarmIndex++}`);
	}
	with([CustomObject, CustomHitme, CustomProp, CustomProjectile, CustomSlash, CustomEnemy, CustomScript, CustomBeginStep, CustomStep, CustomEndStep, CustomDraw]){
		var _eventIndexList = [];
		with(instance_create(0, 0, self)){
			var _eventIndex = 0;
			with(global.event_varname_list){
				var _eventVarName = self;
				if(_eventVarName in other || ("on_step" in other && string_pos(_eventVarName, "on_alrm") == 1)){
					array_push(_eventIndexList, _eventIndex);
				}
				_eventIndex++;
			}
			instance_delete(self);
		}
		global.object_event_index_list_map[? self] = _eventIndexList;
	}
	
	 // Script References:
	scr = {};
	with([save_get, save_set, option_get, option_set, stat_get, stat_set, unlock_get, unlock_set, surface_setup, shader_setup, shader_add, script_bind, ntte_bind_setup, ntte_unbind, loadout_wep_save, loadout_wep_reset, trace_error, weapon_sprite_list_merge, weapon_loadout_sprite_list_merge, prompt_subtext_get_sprite]){
		lq_set(scr, script_get_name(self), script_ref_create(self));
	}
	
	 // SPRITES //
	spr      = {};
	spr_path = "sprites/";
	spr_load = [[spr, 0]];
	global.sprite_loading_delay_frame = ds_map_create();
	with(spr){
		 // Storage:
		msk             = {};
		shd             = {};
		BigTopDecal     = ds_map_create();
		msk.BigTopDecal = ds_map_create();
		TopTiny         = ds_map_create();
		MergeWep        = ds_map_create();
		MergeWepLoadout = ds_map_create();
		PromptSubtext   = ds_map_create();
		
		 // Shine Overlay:
		spr_path_set("shine/");
		with([
			8,  // Rads
			10, // Pickups
			12, // Big Rads
			16, // Normal Chests
			20, // Heavy Chests (Steroids)
			24, // Big Chests
			64, // Giant Chests (YV)
		]){
			lq_set(spr, `Shine${self}`, sprite_add(spr_path + `sprShine${self}.png`, 7, self / 2, self / 2));
		}
		ShineHurt = sprite_add(spr_path + "sprShineHurt.png", 3, 0, 0); // Hurt Flash
		ShineSnow = sprite_add(spr_path + "sprShineSnow.png", 1, 0, 0); // Snow Floors
		
		//#region MENU / HUD
		
			 // Menu:
			spr_path_set("menu/");
			
				 // Open Options:
				OptionNTTE = spr_add("sprOptionNTTE", 1, 32, 12);
				MenuNTTE   = spr_add("sprMenuNTTE",   1, 20,  9);
				
				 // Eyes Maggot Shadow:
				shd.EyesMenu = spr_add("shdEyesMenu", 24, 16, 18);
				
				 // Alt Route Area Icons:
				RouteIcon = spr_add("sprRouteIcon", 2, 4, 4);
				
				 // White Icons:
				WhiteAmmoTypeIcon = spr_add("sprWhiteAmmoTypeIcon", 6, 8, 4);
				WhiteReloadIcon   = spr_add("sprWhiteReloadIcon",   1, 0, 4);
				
				 // Unlock Icons:
				spr_path_add("unlocks/");
				UnlockIcon = {
					"coast"  : spr_add("sprUnlockIconBeach",    2, 12, 12),
					"oasis"  : spr_add("sprUnlockIconBubble",   2, 12, 12),
					"trench" : spr_add("sprUnlockIconTech",     2, 12, 12),
					"lair"   : spr_add("sprUnlockIconSawblade", 2, 12, 12),
					"red"    : spr_add("sprUnlockIconRed",      2, 12, 12),
					"crown"  : spr_add("sprUnlockIconCrown",    2, 12, 12)
				};
				
			 // Loadout Crown System:
			spr_path_set("crowns/");
			CrownRandomLoadout = spr_add("Random/sprCrownRandomLoadout", 2, 16, 16);
			ClockParts         = spr_add("sprClockParts",                2,  1, 1);
			
			 // Mutation Reroll Icon:
			spr_path_set("skills/Reroll/");
			SkillRerollHUDSmall = spr_add("sprSkillRerollHUDSmall", 1, 4, 4);
			
		//#endregion
		
		//#region WEAPONS
		spr_path_set("weps/");
		
			 // Bone:
			Bone      = spr_add("sprBone",      1, 6, 6, shnWep);
			BoneShard = spr_add("sprBoneShard", 1, 3, 2, shnWep);
			
			 // Teleport Gun:
			TeleportGun            = spr_add("sprTeleportGun",            1,  4,  4, shnWep);
			GoldTeleportGun        = spr_add("sprGoldTeleportGun",        1,  4,  4, shnWep);
			TeleportGunLoadout     = spr_add("sprTeleportGunLoadout",     1, 24, 24, shnWep);
			GoldTeleportGunLoadout = spr_add("sprGoldTeleportGunLoadout", 1, 24, 24, shnWep);
			
			 // Trident:
			Trident            = spr_add("sprTrident",            1, 11,  6, shnWep);
			GoldTrident        = spr_add("sprGoldTrident",        1, 11,  6, shnWep);
			TridentLoadout     = spr_add("sprTridentLoadout",     1, 24, 24, shnWep);
			GoldTridentLoadout = spr_add("sprGoldTridentLoadout", 1, 24, 24, shnWep);
			msk.Trident        = spr_add("mskTrident",            1, 11,  6);
			
			 // Tunneller:
			Tunneller            = spr_add("sprTunneller",            1, 14,  6, shnWep);
			GoldTunneller        = spr_add("sprGoldTunneller",        1, 14,  6, shnWep);
			TunnellerLoadout     = spr_add("sprTunnellerLoadout",     1, 24, 24, shnWep);
			GoldTunnellerLoadout = spr_add("sprGoldTunnellerLoadout", 1, 24, 24, shnWep);
			TunnellerHUD         = spr_add("sprTunnellerHUD",         1,  0,  3, shnWep);
			TunnellerHUDRed      = spr_add("sprTunnellerHUD",         1,  0,  3);
			
			 // Ultra Quasar Blaster:
			UltraQuasarBlaster    = spr_add("sprUltraQuasarBlaster",    1,  20, 12, shnWep);
			UltraQuasarBlasterEat = spr_add("sprUltraQuasarBlasterEat", 12, 24, 24);
			
			 // Artifacts:
			var _artifactCount = 4;
			QuestArtifact = array_create(_artifactCount, -1);
			for(var _artifactIndex = 0; _artifactIndex < _artifactCount; _artifactIndex++){
				QuestArtifact[_artifactIndex] = sprite_add_weapon(spr_path + `sprArtifact${_artifactIndex}.png`, 3, 5);
			}
			MergeWep[? `${QuestArtifact[0]}:${QuestArtifact[1]}`] = sprite_add_weapon(spr_path + "sprArtifactSubMerge0.png", 3, 5);
			MergeWep[? `${QuestArtifact[2]}:${QuestArtifact[3]}`] = sprite_add_weapon(spr_path + "sprArtifactSubMerge1.png", 3, 5);
			MergeWep[? array_join(QuestArtifact, ":")           ] = sprite_add_weapon(spr_path + "sprArtifactMerge.png",     3, 5);
			
		//#endregion
		
		//#region PROJECTILES
		spr_path_set("projectiles/");
		
			 // Albino Gator:
			AlbinoBolt      = spr_add("sprAlbinoBolt",     1,  8, 4);
			AlbinoGrenade   = spr_add("sprAlbinoGrenade",  1,  4, 4);
			AlbinoSplinter  = spr_add("sprAlbinoSplinter", 1, -6, 3);
			
			 // Bat Discs:
			BatDisc      = spr_add("sprBatDisc",      2,  9,  9);
			BatDiscBig   = spr_add("sprBatDiscBig",   2, 14, 14);
			BigDiscTrail = spr_add("sprBigDiscTrail", 3, 12, 12);
			
			 // Bat Lightning:
			BatLightning    = spr_add("sprBatLightning",    4,  0,  1);
			BatLightningHit = spr_add("sprBatLightningHit", 4, 12, 12);
			
			 // Bone:
			BoneSlashLight     = spr_add("sprBoneSlashLight", 3, 16, 16);
			msk.BoneSlashLight = spr_add("mskBoneSlashLight", 3, 16, 16);
			BoneSlashHeavy     = spr_add("sprBoneSlashHeavy", 4, 24, 24);
			msk.BoneSlashHeavy = spr_add("mskBoneSlashHeavy", 4, 24, 24);
			BoneArrow          = spr_add("sprBoneArrow",      1, 10,  2);
			BoneArrowHeavy     = spr_add("sprBoneArrowHeavy", 1, 12,  3);
			with([msk.BoneSlashLight, msk.BoneSlashHeavy]){
				mask = [true, 0];
			}
			
			 // Bubble Bombs:
			BubbleBomb           = spr_add("sprBubbleBomb",           30, 12, 12);
			BubbleBombEnemy      = spr_add("sprBubbleBombEnemy",      30, 12, 12);
			BubbleExplosion      = spr_add("sprBubbleExplosion",       9, 24, 24);
			BubbleExplosionSmall = spr_add("sprBubbleExplosionSmall",  7, 12, 12);
			BubbleCharge         = spr_add("sprBubbleCharge",         12, 12, 12);
			BubbleBombBig        = spr_add("sprBubbleBombBig",        46, 16, 16);
			BubbleSlash          = spr_add("sprBubbleSlash",           3,  0, 24);
			
			 // Clam Shield:
			ClamShield          = spr_add("sprClamShield",      14,  0,  7);
			ClamShieldWep       = spr_add("sprClamShieldWep",    1,  8,  8, shn16);
			ClamShieldSlash     = spr_add("sprClamShieldSlash",  4, 12, 12);
			msk.ClamShieldSlash = spr_add("mskClamShieldSlash",  4, 12, 12);
			
			 // Crystal Heart:
			CrystalHeartBullet         = spr_add("sprCrystalHeartBullet",         2, 10, 10);
			CrystalHeartBulletHit      = spr_add("sprCrystalHeartBulletHit",      8, 16, 16);
			CrystalHeartBulletRing     = spr_add("sprCrystalHeartBulletRing",     2, 10, 10);
			CrystalHeartBulletTrail    = spr_add("sprCrystalHeartBulletTrail",    4, 10, 10);
			CrystalHeartBulletBig      = spr_add("sprCrystalHeartBulletBig",      2, 24, 24);
			CrystalHeartBulletBigRed   = spr_add("sprCrystalHeartBulletBigRed",   2, 24, 24);
			CrystalHeartBulletBigRing  = spr_add("sprCrystalHeartBulletBigRing",  2, 24, 24);
			CrystalHeartBulletBigTrail = spr_add("sprCrystalHeartBulletBigTrail", 4, 24, 24);
			
			 // Electroplasma:
			ElectroPlasma       = spr_add("sprElectroPlasma",       7, 12, 12);
			ElectroPlasmaBig    = spr_add("sprElectroPlasmaBig",    7, 12, 12);
			ElectroPlasmaTrail  = spr_add("sprElectroPlasmaTrail",  3,  4,  4);
			ElectroPlasmaImpact = spr_add("sprElectroPlasmaImpact", 7, 12, 12);
			ElectroPlasmaTether = spr_add("sprElectroPlasmaTether", 4,  0,  1);
			
			 // Harpoon:
			Harpoon      = spr_add("sprHarpoon",      1, 4, 3, shnWep);
			HarpoonOpen  = spr_add("sprHarpoonOpen",  5, 4, 3);
			HarpoonFade  = spr_add("sprHarpoonFade",  5, 7, 3);
			NetNade      = spr_add("sprNetNade",      1, 3, 3);
			NetNadeBlink = spr_add("sprNetNadeBlink", 2, 3, 3);
			
			 // Mortar Plasma:
			MortarPlasma = spr_add("sprMortarPlasma", 8, 8, 8);
			
			 // Small Plasma Impact:
			EnemyPlasmaImpactSmall = spr_add("sprEnemyPlasmaImpactSmall", 7,  8,  8);
			PlasmaImpactSmall      = spr_add("sprPlasmaImpactSmall",      7,  8,  8);
			PopoPlasmaImpactSmall  = spr_add("sprPopoPlasmaImpactSmall",	 7,  8,  8);
			msk.PlasmaImpactSmall  = spr_add("mskPlasmaImpactSmall",      7, 16, 16);
			with(msk.PlasmaImpactSmall){
				mask = [true, 0];
			}
			
			 // Portal Bullet:
			PortalBullet          = spr_add("sprPortalBullet",          4, 12, 12);
			PortalBulletHit       = spr_add("sprPortalBulletHit",       4, 16, 16);
			PortalBulletSpawn     = spr_add("sprPortalBulletSpawn",     7, 26, 26);
			PortalBulletLightning = spr_add("sprPortalBulletLightning", 4, 0,  1);
			
			 // Quasar Beam:
			QuasarBeam           = spr_add("sprQuasarBeam",           2,  0, 16);
			QuasarBeamStart      = spr_add("sprQuasarBeamStart",      2, 32, 16);
			QuasarBeamEnd        = spr_add("sprQuasarBeamEnd",        2,  0, 16);
			QuasarBeamHit        = spr_add("sprQuasarBeamHit",        6, 24, 24);
			QuasarBeamTrail      = spr_add("sprQuasarBeamTrail",      3,  4,  4);
			UltraQuasarBeam      = spr_add("sprUltraQuasarBeam",      2,  0, 32);
			UltraQuasarBeamStart = spr_add("sprUltraQuasarBeamStart", 2, 64, 32);
			UltraQuasarBeamEnd   = spr_add("sprUltraQuasarBeamEnd",   2,  0, 32);
			UltraQuasarBeamHit   = spr_add("sprUltraQuasarBeamHit",   6, 24, 24);
			UltraQuasarBeamTrail = spr_add("sprUltraQuasarBeamTrail", 3,  8,  8);
			UltraQuasarBeamFlame = spr_add("sprUltraQuasarBeamFlame", 3, 64, 32);
			msk.QuasarBeam       = spr_add("mskQuasarBeam",           1, 32, 16);
			msk.UltraQuasarBeam  = spr_add("mskUltraQuasarBeam",      1, 64, 32);
			
			 // Red:
			RedBullet          = spr_add("sprRedBullet",          2,  9,  9);
			RedBulletDisappear = spr_add("sprRedBulletDisappear", 5,  9,  9);
			RedExplosion       = spr_add("sprRedExplosion",       7, 16, 16);
			RedSlash           = spr_add("sprRedSlash",           3,  0, 24);
			RedHeavySlash      = spr_add("sprRedHeavySlash",      3,  0, 24);
			RedMegaSlash       = spr_add("sprRedMegaSlash",       3,  0, 36);
			RedShank           = spr_add("sprRedShank",           2, -5,  8);
			RedShankGold       = spr_add("sprRedShankGold",       2, -5,  8);
		//	EntanglerSlash     = spr_add("sprEntanglerSlash",     3,  0, 24);
			
			 // Small Green Explo:
			SmallGreenExplosion = spr_add("sprSmallGreenExplosion", 7, 12, 12);
			
			 // Sparkle Bullet:
			SparkleBullet = spr_add("sprSparkleBullet", 2, 10, 10);
			
			 // Energy Bat Slash:
			EnergyBatSlash       = spr_add("sprEnergyBatSlash",       3,  0, 24);
			EnemyEnergyBatSlash  = spr_add("sprEnemyEnergyBatSlash",  3,  0, 24);
			PopoEnergyBatSlash   = spr_add("sprPopoEnergyBatSlash",   3,  0, 24);
			PurpleEnergyBatSlash = spr_add("sprPurpleEnergyBatSlash", 3,  0, 24);
		//	msk.EnergyBatSlash   = spr_add("mskEnergyBatSlash",       4, 16, 24);
			
			 // Vector Plasma:
			EnemyVlasmaBullet = spr_add("sprEnemyVlasmaBullet", 5,  8,  8);
			VlasmaBullet      = spr_add("sprVlasmaBullet",      5,  8,  8);
			PopoVlasmaBullet  = spr_add("sprPopoVlasmaBullet",  5,  8,  8);
			EnemyVlasmaCannon = spr_add("sprEnemyVlasmaCannon", 5, 10, 10);
			VlasmaCannon      = spr_add("sprVlasmaCannon",      5, 10, 10);
			PopoVlasmaCannon  = spr_add("sprPopoVlasmaCannon",  5, 10, 10);
			
			 // Venom Pellets:
			VenomPelletAppear        = spr_add("sprVenomPelletAppear",        1, 8, 8);
			VenomPellet              = spr_add("sprVenomPellet",              2, 8, 8);
			VenomPelletDisappear     = spr_add("sprVenomPelletDisappear",     5, 8, 8);
			VenomPelletBack          = spr_add("sprVenomPelletBack",          2, 8, 8);
			VenomPelletBackDisappear = spr_add("sprVenomPelletBackDisappear", 5, 8, 8);
			
			 // Variants:
			EnemyBullet             = spr_add("sprEnemyBullet",             2,  7,  9);
			EnemyHeavyBullet        = spr_add("sprEnemyHeavyBullet",        2, 12, 12);
			EnemyHeavyBulletHit     = spr_add("sprEnemyHeavyBulletHit",     4, 12, 12);
			EnemySlug               = spr_add("sprEnemySlug",               2, 12, 12);
			EnemySlugHit            = spr_add("sprEnemySlugHit",            4, 16, 16);
			EnemySlugDisappear      = spr_add("sprEnemySlugDisappear",      6, 12, 12);
			EnemyHeavySlug          = spr_add("sprEnemyHeavySlug",          2, 16, 16);
			EnemyHeavySlugHit       = spr_add("sprEnemyHeavySlugHit",       4, 24, 24);
			EnemyHeavySlugDisappear = spr_add("sprEnemyHeavySlugDisappear", 6, 16, 16);
			EnemySuperFlak          = spr_add("sprEnemySuperFlak",          2, 12, 12);
			EnemySuperFlakHit       = spr_add("sprEnemySuperFlakHit",       9, 24, 24);
			EnemyPlasmaBall         = spr_add("sprEnemyPlasmaBall",         2, 12, 12);
			EnemyPlasmaBig          = spr_add("sprEnemyPlasmaBig",          2, 16, 16);
			EnemyPlasmaHuge         = spr_add("sprEnemyPlasmaHuge",         2, 24, 24);
			EnemyPlasmaImpact       = spr_add("sprEnemyPlasmaImpact",       7, 16, 16);
			EnemyPlasmaTrail        = spr_add("sprEnemyPlasmaTrail",        3,  4,  4);
			AllySniperBullet        = spr_add("sprAllySniperBullet",        2,  6,  8);
			AllyLaserCharge         = spr_add("sprAllyLaserCharge",         4,  3,  3);
			IDPDHeavyBullet         = spr_add("sprIDPDHeavyBullet",         2, 12, 12);
			IDPDHeavyBulletHit      = spr_add("sprIDPDHeavyBulletHit",      4, 12, 12);
			IDPDHorrorBullet        = spr_add("sprIDPDHorrorBullet",        2, 10,  8);
			PopoLaser               = spr_add("sprPopoLaser",               1,  2,  3);
			PopoLaserStart          = spr_add("sprPopoLaserStart",          8,  8,  6);
			PopoLaserEnd            = spr_add("sprPopoLaserEnd",            8, 10,  8);
			SmallLastBall           = spr_add("sprSmallLastBall",           4, 10, 10);
			
		//#endregion
		
		//#region ALERTS
		spr_path_set("alerts/");
		
			 // Alert Indicators:
			AlertIndicator        = spr_add("sprAlertIndicator",        1, 1, 6);
			AlertIndicatorMystery = spr_add("sprAlertIndicatorMystery", 1, 2, 6);
			AlertIndicatorPopo    = spr_add("sprAlertIndicatorPopo",    1, 4, 4);
			AlertIndicatorOrchid  = spr_add("sprAlertIndicatorOrchid",  1, 4, 4);
			
			 // Alert Icons:
			AllyAlert            = spr_add("sprAllyAlert",            1, 7,  7);
			BanditAlert          = spr_add("sprBanditAlert",          1, 7,  7);
			CrimeBountyAlert     = spr_add("sprCrimeBountyAlert",     2, 8, 10);
			CrimeBountyFillAlert = spr_add("sprCrimeBountyFillAlert", 4, 5,  0);
			FlyAlert             = spr_add("sprFlyAlert",             1, 7,  7);
			GatorAlert           = spr_add("sprGatorAlert",           1, 7,  7);
			GatorAlbinoAlert     = spr_add("sprGatorAlbinoAlert",     1, 7,  7);
			GatorPatchAlert      = spr_add("sprGatorPatchAlert",      1, 7,  7);
			PopoAlert            = spr_add("sprPopoAlert",            3, 8,  8);
			PopoEliteAlert       = spr_add("sprPopoEliteAlert",       3, 8,  8);
			PopoFreakAlert       = spr_add("sprPopoFreakAlert",       1, 8,  8);
			SealAlert            = spr_add("sprSealAlert",            1, 7,  7);
			SealArcticAlert      = spr_add("sprSealArcticAlert",      1, 7,  7);
			SkealAlert           = spr_add("sprSkealAlert",           1, 7,  7);
			SludgePoolAlert      = spr_add("sprSludgePoolAlert",      1, 7,  7);
			VanAlert             = spr_add("sprVanAlert",             1, 7,  7);
			
		//#endregion
		
		//#region ENEMIES
		spr_path_set("enemies/");
		
			 // Albino Gator:
			spr_path_add("AlbinoGator/");
			AlbinoGatorIdle = spr_add("sprAlbinoGatorIdle", 8, 16, 16);
			AlbinoGatorWalk = spr_add("sprAlbinoGatorWalk", 6, 16, 16);
			AlbinoGatorHurt = spr_add("sprAlbinoGatorHurt", 3, 16, 16);
			AlbinoGatorDead = spr_add("sprAlbinoGatorDead", 6, 16, 16);
			AlbinoGatorWeap = spr_add("sprAlbinoGatorWeap", 1,  7,  5, shnWep);
			spr_path_add("../");
			
			 // Angler:
			spr_path_add("Angler/");
			AnglerIdle       = spr_add("sprAnglerIdle",    8, 32, 32);
			AnglerWalk       = spr_add("sprAnglerWalk",    8, 32, 32);
			AnglerHurt       = spr_add("sprAnglerHurt",    3, 32, 32);
			AnglerDead       = spr_add("sprAnglerDead",    7, 32, 32);
			AnglerAppear     = spr_add("sprAnglerAppear",  4, 32, 32);
			AnglerTrail      = spr_add("sprAnglerTrail",   8, 32, 32);
			AnglerLight      = spr_add("sprAnglerLight",   4, 80, 80);
			msk.AnglerHidden =[spr_add("mskAnglerHidden1", 1, 32, 32),
			                   spr_add("mskAnglerHidden2", 1, 32, 32)];
			spr_path_add("../");
			
			 // Angler (Gold):
			spr_path_add("GoldAngler/");
			AnglerGoldIdle    = spr_add("sprGoldAnglerIdle",    8, 32, 32);
			AnglerGoldWalk    = spr_add("sprGoldAnglerWalk",    8, 32, 32);
			AnglerGoldHurt    = spr_add("sprGoldAnglerHurt",    3, 32, 32);
			AnglerGoldDead    = spr_add("sprGoldAnglerDead",    7, 32, 32);
			AnglerGoldAppear  = spr_add("sprGoldAnglerAppear",  4, 32, 32);
			AnglerGoldScreech = spr_add("sprGoldAnglerScreech", 8, 48, 48);
			spr_path_add("../");
			
			 // Baby Gator:
			spr_path_add("BabyGator/");
			BabyGatorIdle = spr_add("sprBabyGatorIdle", 6, 12, 12);
			BabyGatorWalk = spr_add("sprBabyGatorWalk", 6, 12, 12);
			BabyGatorHurt = spr_add("sprBabyGatorHurt", 3, 12, 12);
			BabyGatorDead = spr_add("sprBabyGatorDead", 7, 12, 12);
			BabyGatorWeap = spr_add("sprBabyGatorWeap", 1,  0,  3, shnWep);
			spr_path_add("../");
			
			 // Baby Scorpion:
			spr_path_add("BabyScorpion/");
			BabyScorpionIdle = spr_add("sprBabyScorpionIdle", 4, 16, 16);
			BabyScorpionWalk = spr_add("sprBabyScorpionWalk", 6, 16, 16);
			BabyScorpionHurt = spr_add("sprBabyScorpionHurt", 3, 16, 16);
			BabyScorpionDead = spr_add("sprBabyScorpionDead", 6, 16, 16);
			BabyScorpionFire = spr_add("sprBabyScorpionFire", 6, 16, 16);
			spr_path_add("../");
			
			 // Baby Scorpion (Gold):
			spr_path_add("BabyScorpionGold/");
			BabyScorpionGoldIdle = spr_add("sprBabyScorpionGoldIdle", 4, 16, 16);
			BabyScorpionGoldWalk = spr_add("sprBabyScorpionGoldWalk", 6, 16, 16);
			BabyScorpionGoldHurt = spr_add("sprBabyScorpionGoldHurt", 3, 16, 16);
			BabyScorpionGoldDead = spr_add("sprBabyScorpionGoldDead", 6, 16, 16);
			BabyScorpionGoldFire = spr_add("sprBabyScorpionGoldFire", 6, 16, 16);
			spr_path_add("../");
			
			 // Bandit Campers:
			spr_path_add("Camp/");
			BanditCamperIdle = spr_add("sprBanditCamperIdle", 4, 12, 12);
			BanditCamperWalk = spr_add("sprBanditCamperWalk", 6, 12, 12);
			BanditCamperHurt = spr_add("sprBanditCamperHurt", 3, 12, 12);
			BanditCamperDead = spr_add("sprBanditCamperDead", 6, 12, 12);
			BanditHikerIdle  = spr_add("sprBanditHikerIdle",  4, 12, 12);
			BanditHikerWalk  = spr_add("sprBanditHikerWalk",  6, 12, 12);
			BanditHikerHurt  = spr_add("sprBanditHikerHurt",  3, 12, 12);
			BanditHikerDead  = spr_add("sprBanditHikerDead",  6, 12, 12);
			spr_path_add("../");
			
			 // Bat:
			spr_path_add("Bat/");
			BatWeap        = spr_add("sprBatWeap",     1,  2,  6, shnWep);
			BatIdle        = spr_add("sprBatIdle",    24, 16, 16);
			BatWalk        = spr_add("sprBatWalk",    12, 16, 16);
			BatHurt        = spr_add("sprBatHurt",     3, 16, 16);
			BatDead        = spr_add("sprBatDead",     6, 16, 16);
			BatYell        = spr_add("sprBatYell",     6, 16, 16);
			BatScreech     = spr_add("sprBatScreech",  8, 48, 48);
			msk.BatScreech = spr_add("mskBatScreech",  8, 48, 48);
			spr_path_add("../");
			
			 // Bat Boss:
			spr_path_add("BatBoss/");
			BatBossIdle = spr_add("sprBigBatIdle",  12, 24, 24);
			BatBossWalk = spr_add("sprBigBatWalk",   8, 24, 24);
			BatBossHurt = spr_add("sprBigBatHurt",   3, 24, 24);
			BatBossDead = spr_add("sprBigBatDead",   6, 24, 24);
			BatBossYell = spr_add("sprBigBatYell",   6, 24, 24);
			BatBossWeap = spr_add("sprBatBossWeap",  1,  4,  8, shnWep);
			VenomFlak   = spr_add("sprVenomFlak",    2, 12, 12);
			spr_path_add("../");
			
			 // Big Fish:
			spr_path_add("CoastBoss/");
			BigFishBecomeIdle = spr_add("sprBigFishBuild",      4, 40, 38);
			BigFishBecomeHurt = spr_add("sprBigFishBuildHurt",  4, 40, 38);
			BigFishSpwn       = spr_add("sprBigFishSpawn",     11, 32, 32);
			BigFishLeap       = spr_add("sprBigFishLeap",      11, 32, 32);
			BigFishSwim       = spr_add("sprBigFishSwim",       8, 24, 24);
			BigFishRise       = spr_add("sprBigFishRise",       5, 32, 32);
			BigFishSwimFrnt   = spr_add("sprBigFishSwimFront",  6,  0,  4);
			BigFishSwimBack   = spr_add("sprBigFishSwimBack",  11,  0,  5);
			spr_path_add("../");
			
			 // Bone Gator:
			spr_path_add("BoneGator/");
			BoneGatorIdle = spr_add("sprBoneGatorIdle", 8, 12, 12);
			BoneGatorWalk = spr_add("sprBoneGatorWalk", 6, 12, 12);
			BoneGatorHurt = spr_add("sprBoneGatorHurt", 3, 12, 12);
			BoneGatorDead = spr_add("sprBoneGatorDead", 6, 12, 12);
			BoneGatorHeal = spr_add("sprBoneGatorHeal", 7,  8,  8);
			BoneGatorWeap = spr_add("sprBoneGatorWeap", 1,  2,  3);
			FlameSpark    = spr_add("sprFlameSpark",    7,  1,  1);
			spr_path_add("../");
			
			 // Big Maggot Nest:
			spr_path_add("BigMaggotNest/");
			BigMaggotSpawnIdle = spr_add("sprBigMaggotNestIdle", 4, 32, 32);
			BigMaggotSpawnHurt = spr_add("sprBigMaggotNestHurt", 3, 32, 32);
			BigMaggotSpawnDead = spr_add("sprBigMaggotNestDead", 3, 32, 32);
			BigMaggotSpawnChrg = spr_add("sprBigMaggotNestChrg", 4, 32, 32);
			spr_path_add("../");
			
			 // Blooming Bush Assassin:
			spr_path_add("BloomingAss/");
			BloomingAssassinHide = spr_add("sprBloomingAssassinHide", 41, 16, 16);
			BloomingAssassinIdle = spr_add("sprBloomingAssassinIdle",  6, 16, 16);
			BloomingAssassinWalk = spr_add("sprBloomingAssassinWalk",  6, 16, 16);
			BloomingAssassinHurt = spr_add("sprBloomingAssassinHurt",  3, 16, 16);
			BloomingAssassinDead = spr_add("sprBloomingAssassinDead",  6, 16, 16);
			spr_path_add("../");
			
			 // Bone Raven:
			spr_path_add("BoneRaven/");
			BoneRavenIdle = spr_add("sprBoneRavenIdle", 33, 12, 12);
			BoneRavenWalk = spr_add("sprBoneRavenWalk",  7, 12, 12);
			BoneRavenHurt = spr_add("sprBoneRavenHurt",  3, 12, 12);
			BoneRavenDead = spr_add("sprBoneRavenDead", 11, 12, 12);
			BoneRavenLift = spr_add("sprBoneRavenLift",  5, 32, 32);
			BoneRavenLand = spr_add("sprBoneRavenLand",  4, 32, 32);
			BoneRavenFly  = spr_add("sprBoneRavenFly",   5, 32, 32);
			spr_path_add("../");
			
			 // Cat:
			spr_path_add("Cat/");
			CatIdle      = spr_add("sprCatIdle",          4, 12, 12);
			CatWalk      = spr_add("sprCatWalk",          6, 12, 12);
			CatHurt      = spr_add("sprCatHurt",          3, 12, 12);
			CatDead      = spr_add("sprCatDead",          6, 12, 12);
			CatSit1      =[spr_add("sprCatGoSit",         3, 12, 12),
			               spr_add("sprCatGoSitSide",     3, 12, 12)];
			CatSit2      =[spr_add("sprCatSit",           6, 12, 12),
			               spr_add("sprCatSitSide",       6, 12, 12)];
			CatSnowIdle  = spr_add("sprCatSnowIdle",      4, 12, 12);
			CatSnowWalk  = spr_add("sprCatSnowWalk",      6, 12, 12);
			CatSnowHurt  = spr_add("sprCatSnowHurt",      3, 12, 12);
			CatSnowDead  = spr_add("sprCatSnowDead",      6, 12, 12);
			CatSnowSit1  =[spr_add("sprCatSnowGoSit",     3, 12, 12),
			               spr_add("sprCatSnowGoSitSide", 3, 12, 12)];
			CatSnowSit2  =[spr_add("sprCatSnowSit",       6, 12, 12),
			               spr_add("sprCatSnowSitSide",   6, 12, 12)];
			CatWeap      = spr_add("sprCatToxer",         1,  3,  4);
			AcidPuff     = spr_add("sprAcidPuff",         4, 16, 16);
			spr_path_add("../");
			
			 // Cat Boss:
			spr_path_add("CatBoss/");
			CatBossIdle     = spr_add("sprBigCatIdle",       12, 24, 24);
			CatBossWalk     = spr_add("sprBigCatWalk",        6, 24, 24);
			CatBossHurt     = spr_add("sprBigCatHurt",        3, 24, 24);
			CatBossDead     = spr_add("sprBigCatDead",        6, 24, 24);
			CatBossChrg     = spr_add("sprBigCatChrg",        2, 24, 24);
			CatBossFire     = spr_add("sprBigCatFire",        2, 24, 24);
			CatBossWeap     = spr_add("sprCatBossToxer",      2,  4,  7);
			CatBossWeapChrg = spr_add("sprCatBossToxerChrg", 12,  1,  7);
			BossHealFX      = spr_add("sprBossHealFX",       10,  9,  9);
			spr_path_add("../");
			
			 // Crab Tank:
			CrabTankIdle = sprCrabIdle;
			CrabTankWalk = sprCrabWalk;
			CrabTankHurt = sprCrabHurt;
			CrabTankDead = sprCrabDead;
			
			 // Crystal Bat:
			spr_path_add("CrystalBat/");
			CrystalBatIdle = spr_add("sprCrystalBatIdle", 6, 16, 16);
			CrystalBatHurt = spr_add("sprCrystalBatHurt", 3, 16, 16);
			CrystalBatDead = spr_add("sprCrystalBatDead", 8, 16, 16);
			CrystalBatTell = spr_add("sprCrystalBatTell", 2, 16, 16);
			CrystalBatDash = spr_add("sprCrystalBatDash", 4, 16, 16);
			spr_path_add("../");
			
			 // Crystal Bat (Cursed):
			spr_path_add("InvCrystalBat/");
			InvCrystalBatIdle = spr_add("sprInvCrystalBatIdle", 6, 16, 16);
			InvCrystalBatHurt = spr_add("sprInvCrystalBatHurt", 3, 16, 16);
			InvCrystalBatDead = spr_add("sprInvCrystalBatDead", 8, 16, 16);
			InvCrystalBatTell = spr_add("sprInvCrystalBatTell", 2, 16, 16);
			InvCrystalBatDash = spr_add("sprInvCrystalBatDash", 4, 16, 16);
			spr_path_add("../");
			
			 // Crystal Brain:
			spr_path_add("CrystalBrain/");
			CrystalBrainIdle          = spr_add("sprCrystalBrainIdle",           6, 24, 24);
			CrystalBrainHurt          = spr_add("sprCrystalBrainHurt",           3, 24, 24);
			CrystalBrainDead          = spr_add("sprCrystalBrainDead",           7, 24, 24);
			CrystalBrainAppear        = spr_add("sprCrystalBrainAppear",         4, 24, 24);
			CrystalBrainDisappear     = spr_add("sprCrystalBrainDisappear",      7, 24, 24);
			CrystalBrainChunk         = spr_add("sprCrystalBrainChunk",          4,  8,  8);
			CrystalBrainPart          = spr_add("sprCrystalBrainPart",           7, 24, 24);
			CrystalBrainEffect        = spr_add("sprCrystalBrainEffect",        10,  8,  8);
			CrystalBrainEffectAlly    = spr_add("sprCrystalBrainEffectAlly",    10,  8,  8);
			CrystalBrainEffectPopo    = spr_add("sprCrystalBrainEffectPopo",    10,  8,  8);
			CrystalBrainSurfMask      = spr_add("sprCrystalBrainSurfMask",       1,  0,  0);
			CrystalCloneOverlay       = spr_add("sprCrystalCloneOverlay",        8,  0,  0);
			CrystalCloneOverlayAlly   = spr_add("sprCrystalCloneOverlayAlly",    8,  0,  0);
			CrystalCloneOverlayPopo   = spr_add("sprCrystalCloneOverlayPopo",    8,  0,  0);
			CrystalCloneOverlayCorpse = spr_add("sprCrystalCloneOverlayCorpse",  8,  0,  0);
		//	CrystalCloneGun           = sprite_duplicate_ext(sprRevolver,   0, 1);
		//	CrystalCloneGunTB         = sprite_duplicate_ext(sprMachinegun, 0, 1);
			spr_path_add("../");
			
			 // Crystal Heart:
			spr_path_add("CrystalHeart/");
			CrystalHeartIdle = spr_add("sprCrystalHeartIdle", 10, 24, 24);
			CrystalHeartHurt = spr_add("sprCrystalHeartHurt",  3, 24, 24);
			CrystalHeartDead = spr_add("sprCrystalHeartDead", 22, 24, 24);
			ChaosHeartIdle   = spr_add("sprChaosHeartIdle",   10, 24, 24);
			ChaosHeartHurt   = spr_add("sprChaosHeartHurt",    3, 24, 24);
			ChaosHeartDead   = spr_add("sprChaosHeartDead",   22, 24, 24);
			spr_path_add("../");
			
			 // Diver:
			spr_path_add("Diver/");
			DiverIdle  = spr_add("sprDiverIdle",       4, 12, 12);
			DiverWalk  = spr_add("sprDiverWalk",       6, 12, 12);
			DiverHurt  = spr_add("sprDiverHurt",       3, 12, 12);
			DiverDead  = spr_add("sprDiverDead",       9, 24, 24);
			HarpoonGun = spr_add("sprDiverHarpoonGun", 1,  8,  8);
			spr_path_add("../");
			
			 // Eel:
			spr_path_add("Eel/");
			EelIdle    =[spr_add("sprEelIdleBlue",    8, 16, 16),
			             spr_add("sprEelIdlePurple",  8, 16, 16),
			             spr_add("sprEelIdleGreen",   8, 16, 16)];
			EelHurt    =[spr_add("sprEelHurtBlue",    3, 16, 16),
			             spr_add("sprEelHurtPurple",  3, 16, 16),
			             spr_add("sprEelHurtGreen",   3, 16, 16)];
			EelDead    =[spr_add("sprEelDeadBlue",    9, 16, 16),
			             spr_add("sprEelDeadPurple",  9, 16, 16),
			             spr_add("sprEelDeadGreen",   9, 16, 16)];
			EelTell    =[spr_add("sprEelTellBlue",    8, 16, 16),
			             spr_add("sprEelTellPurple",  8, 16, 16),
			             spr_add("sprEelTellGreen",   8, 16, 16)];
			EeliteIdle = spr_add("sprEelIdleElite",   8, 16, 16);
			EeliteHurt = spr_add("sprEelHurtElite",   3, 16, 16);
			EeliteDead = spr_add("sprEelDeadElite",   9, 16, 16);
			WantEel    = spr_add("sprWantEel",       16, 16, 16);
			spr_path_add("../");
			
			 // Fish Freaks:
			spr_path_add("FishFreak/");
			FishFreakIdle = spr_add("sprFishFreakIdle",  6, 12, 12);
			FishFreakWalk = spr_add("sprFishFreakWalk",  6, 12, 12);
			FishFreakHurt = spr_add("sprFishFreakHurt",  3, 12, 12);
			FishFreakDead = spr_add("sprFishFreakDead", 11, 12, 12);
			spr_path_add("../");
			
			 // Gull:
			spr_path_add("Gull/");
			GullIdle  = spr_add("sprGullIdle",  4, 12, 12);
			GullWalk  = spr_add("sprGullWalk",  6, 12, 12);
			GullHurt  = spr_add("sprGullHurt",  3, 12, 12);
			GullDead  = spr_add("sprGullDead",  6, 16, 16);
			GullSword = spr_add("sprGullSword", 1,  6,  8);
			spr_path_add("../");
			
			 // Hammerhead Fish:
			spr_path_add("Hammer/");
			HammerSharkIdle = spr_add("sprHammerSharkIdle",  6, 24, 24);
			HammerSharkHurt = spr_add("sprHammerSharkHurt",  3, 24, 24);
			HammerSharkDead = spr_add("sprHammerSharkDead", 10, 24, 24);
			HammerSharkChrg = spr_add("sprHammerSharkDash",  2, 24, 24);
			spr_path_add("../");
			
			 // Jellyfish (0 = blue, 1 = purple, 2 = green, 3 = elite):
			spr_path_add("Jellyfish/");
			JellyFire      = spr_add("sprJellyfishFire",        6, 24, 24);
			JellyEliteFire = spr_add("sprJellyfishEliteFire",   6, 24, 24);
			JellyIdle      =[spr_add("sprJellyfishBlueIdle",    8, 24, 24),
			                 spr_add("sprJellyfishPurpleIdle",  8, 24, 24),
			                 spr_add("sprJellyfishGreenIdle",   8, 24, 24),
			                 spr_add("sprJellyfishEliteIdle",   8, 24, 24)];
			JellyHurt      =[spr_add("sprJellyfishBlueHurt",    3, 24, 24),
			                 spr_add("sprJellyfishPurpleHurt",  3, 24, 24),
			                 spr_add("sprJellyfishGreenHurt",   3, 24, 24),
			                 spr_add("sprJellyfishEliteHurt",   3, 24, 24)];
			JellyDead      =[spr_add("sprJellyfishBlueDead",   10, 24, 24),
			                 spr_add("sprJellyfishPurpleDead", 10, 24, 24),
			                 spr_add("sprJellyfishGreenDead",  10, 24, 24),
			                 spr_add("sprJellyfishEliteDead",  10, 24, 24)];
			spr_path_add("../");
			
			 // Lair Turret Reskin:
			spr_path_add("LairTurret/");
			LairTurretIdle   = spr_add("sprLairTurretIdle",    1, 12, 12);
			LairTurretHurt   = spr_add("sprLairTurretHurt",    3, 12, 12);
			LairTurretDead   = spr_add("sprLairTurretDead",    6, 12, 12);
			LairTurretFire   = spr_add("sprLairTurretFire",    3, 12, 12);
			LairTurretAppear = spr_add("sprLairTurretAppear", 11, 12, 12);
			spr_path_add("../");
			
			 // Miner Bandit:
			spr_path_add("MinerBandit/");
			MinerBanditIdle = spr_add("sprMinerBanditIdle", 4, 12, 12);
			MinerBanditWalk = spr_add("sprMinerBanditWalk", 6, 12, 12);
			MinerBanditHurt = spr_add("sprMinerBanditHurt", 3, 12, 12);
			MinerBanditDead = spr_add("sprMinerBanditDead", 6, 12, 12);
			spr_path_add("../");
			
			 // Mortar:
			spr_path_add("Mortar/");
			MortarIdle = spr_add("sprMortarIdle",  4, 22, 24);
			MortarWalk = spr_add("sprMortarWalk",  8, 22, 24);
			MortarFire = spr_add("sprMortarFire", 16, 22, 24);
			MortarHurt = spr_add("sprMortarHurt",  3, 22, 24);
			MortarDead = spr_add("sprMortarDead", 14, 22, 24);
			spr_path_add("../");
			
			 // Mortar (Cursed):
			spr_path_add("InvMortar/");
			InvMortarIdle = spr_add("sprInvMortarIdle",  4, 22, 24);
			InvMortarWalk = spr_add("sprInvMortarWalk",  8, 22, 24);
			InvMortarFire = spr_add("sprInvMortarFire", 16, 22, 24);
			InvMortarHurt = spr_add("sprInvMortarHurt",  3, 22, 24);
			InvMortarDead = spr_add("sprInvMortarDead", 14, 22, 24);
			spr_path_add("../");
			
			 // Palanking:
			spr_path_add("Palanking/");
			PalankingBott  = spr_add("sprPalankingBase",   1, 40, 24);
			PalankingTaunt = spr_add("sprPalankingTaunt", 31, 40, 24);
			PalankingCall  = spr_add("sprPalankingCall",   9, 40, 24);
			PalankingIdle  = spr_add("sprPalankingIdle",  16, 40, 24);
			PalankingWalk  = spr_add("sprPalankingWalk",  16, 40, 24);
			PalankingHurt  = spr_add("sprPalankingHurt",   3, 40, 24);
			PalankingDead  = spr_add("sprPalankingDead",  11, 40, 24);
			PalankingBurp  = spr_add("sprPalankingBurp",   5, 40, 24);
			PalankingFire  = spr_add("sprPalankingFire",  11, 40, 24);
			PalankingFoam  = spr_add("sprPalankingFoam",   1, 40, 24);
			PalankingChunk = spr_add("sprPalankingChunk",  5, 16, 16);
			GroundSlash    = spr_add("sprGroundSlash",     3,  0, 21);
			PalankingSlash = spr_add("sprPalankingSlash",  3,  0, 29);
			msk.Palanking  = spr_add("mskPalanking",       1, 40, 24);
			with(msk.Palanking){
				mask = [false, 0];
			}
			spr_path_add("../");
			
			 // Patch Gator (Eyepatch Reskin):
			spr_path_add("PatchGator/");
			PatchGatorIdle = spr_add("sprPatchGatorIdle", 8, 12, 12);
			PatchGatorWalk = spr_add("sprPatchGatorWalk", 6, 12, 12);
			PatchGatorHurt = spr_add("sprPatchGatorHurt", 3, 12, 12);
			PatchGatorDead = spr_add("sprPatchGatorDead", 6, 12, 12);
			spr_path_add("../");
			
			 // Pelican:
			spr_path_add("Pelican/");
			PelicanIdle   = spr_add("sprPelicanIdle",   5, 24, 24);
			PelicanWalk   = spr_add("sprPelicanWalk",   8, 24, 24);
			PelicanHurt   = spr_add("sprPelicanHurt",   3, 24, 24);
			PelicanDead   = spr_add("sprPelicanDead",   6, 24, 24);
			PelicanChrg   = spr_add("sprPelicanChrg",   2, 24, 24);
			PelicanHammer = spr_add("sprPelicanHammer", 1,  6,  8, shnWep);
			spr_path_add("../");
			
			 // Pit Squid:
			spr_path_add("Pitsquid/");
			
				 // Eyes:
				PitSquidCornea  = spr_add("sprPitsquidCornea", 1, 19, 19);
				PitSquidPupil   = spr_add("sprPitsquidPupil",  1, 19, 19);
				PitSquidEyelid  = spr_add("sprPitsquidEyelid", 3, 19, 19);
				
				 // Tentacles:
				TentacleIdle = spr_add("sprTentacleIdle", 8, 20, 28);
				TentacleHurt = spr_add("sprTentacleHurt", 3, 20, 28);
				TentacleDead = spr_add("sprTentacleDead", 4, 20, 28);
				TentacleSpwn = spr_add("sprTentacleSpwn", 6, 20, 28);
				TentacleTele = spr_add("sprTentacleTele", 6, 20, 28);
				
				 // Maw:
				PitSquidMawBite = spr_add("sprPitsquidMawBite", 14, 19, 19);
				PitSquidMawSpit = spr_add("sprPitsquidMawSpit", 10, 19, 19);
				
				 // Particles:
				spr_path_add("Particles/");
				PitSpark = [
					spr_add("sprPitSpark1", 5, 16, 16),
					spr_add("sprPitSpark2", 5, 16, 16),
					spr_add("sprPitSpark3", 5, 16, 16),
					spr_add("sprPitSpark4", 5, 16, 16),
					spr_add("sprPitSpark5", 5, 16, 16),
				];
				TentacleWheel    = spr_add("sprTentacleWheel",    2, 40, 40);
				SquidCharge      = spr_add("sprSquidCharge",      5, 24, 24);
				SquidBloodStreak = spr_add("sprSquidBloodStreak", 7,  0,  8);
				spr_path_add("../");
				
			spr_path_add("../");
			
			 // Popo Security:
			spr_path_add("PopoSecurity/");
			PopoSecurityIdle    = spr_add("sprPopoSecurityIdle",    11, 16, 16);
			PopoSecurityWalk    = spr_add("sprPopoSecurityWalk",    6,  16, 16);
			PopoSecurityHurt    = spr_add("sprPopoSecurityHurt",    3,  16, 16);
			PopoSecurityDead    = spr_add("sprPopoSecurityDead",    7,  16, 16);
			PopoSecurityCannon  = spr_add("sprPopoSecurityCannon",  1,  7,  8);
			PopoSecurityMinigun = spr_add("sprPopoSecurityMinigun", 1,  7,  8);
			spr_path_add("../");
			
			 // Portal Guardian:
			spr_path_add("PortalGuardian/");
			PortalGuardianIdle      = spr_add("sprPortalGuardianIdle",       4, 16, 16);
			PortalGuardianHurt      = spr_add("sprPortalGuardianHurt",       3, 16, 16);
			PortalGuardianDead      = spr_add("sprPortalGuardianDead",       9, 32, 32);
			PortalGuardianAppear    = spr_add("sprPortalGuardianAppear",     5, 32, 32);
			PortalGuardianDisappear = spr_add("sprPortalGuardianDisappear",  4, 32, 32);
			PortalGuardianImplode   = spr_add("sprPortalGuardianImplode",   17, 32, 32);
			spr_path_add("../");
			
			 // Puffer:
			spr_path_add("Puffer/");
			PufferIdle       = spr_add("sprPufferIdle",    6, 15, 16);
			PufferHurt       = spr_add("sprPufferHurt",    3, 15, 16);
			PufferDead       = spr_add("sprPufferDead",   11, 15, 16);
			PufferChrg       = spr_add("sprPufferChrg",    9, 15, 16);
			PufferFire[0, 0] = spr_add("sprPufferBlow0",   2, 15, 16);
			PufferFire[0, 1] = spr_add("sprPufferBlowB0",  2, 15, 16);
			PufferFire[1, 0] = spr_add("sprPufferBlow1",   2, 15, 16);
			PufferFire[1, 1] = spr_add("sprPufferBlowB1",  2, 15, 16);
			PufferFire[2, 0] = spr_add("sprPufferBlow2",   2, 15, 16);
			PufferFire[2, 1] = spr_add("sprPufferBlowB2",  2, 15, 16);
			PufferFire[3, 0] = spr_add("sprPufferBlow3",   2, 15, 16);
			PufferFire[3, 1] = spr_add("sprPufferBlowB3",  2, 15, 16);
			spr_path_add("../");
			
			 // Red Crystal Spider:
			spr_path_add("RedSpider/");
			RedSpiderIdle = spr_add("sprRedSpiderIdle", 8, 12, 12);
			RedSpiderWalk = spr_add("sprRedSpiderWalk", 6, 12, 12);
			RedSpiderHurt = spr_add("sprRedSpiderHurt", 3, 12, 12);
			RedSpiderDead = spr_add("sprRedSpiderDead", 7, 12, 12);
			spr_path_add("../");
			
			 // Saw Trap:
			spr_path_add("SawTrap/");
			SawTrap       = spr_add("sprSawTrap",       1, 20, 20);
			SawTrapHurt   = spr_add("sprSawTrapHurt",   3, 20, 20);
			SawTrapDebris = spr_add("sprSawTrapDebris", 4,  8,  8);
			spr_path_add("../");
			
			 // Seal:
			spr_path_add("Seal/");
			SealIdle = [];
			SealWalk = [];
			SealHurt = [];
			SealDead = [];
			SealSpwn = [];
			SealWeap = [
				mskNone,
				spr_add("sprHookPole",    1, 18,  2),
				spr_add("sprSabre",       1, -2,  1),
				spr_add("sprBlunderbuss", 1,  7,  1),
				spr_add("sprRepeater",    1,  6,  2),
				sprBanditGun
			];
			for(var i = 0; i <= 6; i++){
				var _num = ((i == 0) ? "" : i);
				SealIdle[i] = spr_add(`sprSealIdle${_num}`, 6, 12, 12);
				SealWalk[i] = spr_add(`sprSealWalk${_num}`, 6, 12, 12);
				SealHurt[i] = spr_add(`sprSealHurt${_num}`, 3, 12, 12);
				SealDead[i] = spr_add(`sprSealDead${_num}`, 6, 12, 12);
				SealSpwn[i] = spr_add(`sprSealSpwn${_num}`, 6, 12, 12);
			}
			SealDisc    = spr_add("sprSealDisc",    2,  7,  7);
			SkealIdle   = spr_add("sprSkealIdle",   6, 12, 12);
			SkealWalk   = spr_add("sprSkealWalk",   7, 12, 12);
			SkealHurt   = spr_add("sprSkealHurt",   3, 12, 12);
			SkealDead   = spr_add("sprSkealDead",  10, 16, 16);
			SkealSpwn   = spr_add("sprSkealSpwn",   8, 16, 16);
			spr_path_add("../");
			
			 // Seal (Heavy):
			spr_path_add("SealHeavy/");
			SealHeavySpwn = spr_add("sprHeavySealSpwn",    6, 16, 17);
			SealHeavyIdle = spr_add("sprHeavySealIdle",   10, 16, 17);
			SealHeavyWalk = spr_add("sprHeavySealWalk",    8, 16, 17);
			SealHeavyHurt = spr_add("sprHeavySealHurt",    3, 16, 17);
			SealHeavyDead = spr_add("sprHeavySealDead",    7, 16, 17);
			SealHeavyTell = spr_add("sprHeavySealTell",    2, 16, 17);
			SealAnchor    = spr_add("sprHeavySealAnchor",  1,  0, 12);
			SealChain     = spr_add("sprChainSegment",     1,  0,  0);
			spr_path_add("../");
			
			 // Silver Scorpion:
			spr_path_add("SilverScorpion/");
			SilverScorpionIdle = spr_add("sprSilverScorpionIdle", 14, 24, 24);
			SilverScorpionWalk = spr_add("sprSilverScorpionWalk", 6,  24, 24);
			SilverScorpionHurt = spr_add("sprSilverScorpionHurt", 3,  24, 24);
			SilverScorpionDead = spr_add("sprSilverScorpionDead", 6,  24, 24);
			SilverScorpionFire = spr_add("sprSilverScorpionFire", 2,  24, 24);
			SilverScorpionFlak = spr_add("sprSilverScorpionFlak", 4,  10, 10);
			spr_path_add("../");
			
			 // Spiderling:
			spr_path_add("Spiderling/");
			SpiderlingIdle     = spr_add("sprSpiderlingIdle",     4, 8, 8);
			SpiderlingWalk     = spr_add("sprSpiderlingWalk",     4, 8, 8);
			SpiderlingHurt     = spr_add("sprSpiderlingHurt",     3, 8, 8);
			SpiderlingDead     = spr_add("sprSpiderlingDead",     7, 8, 8);
			SpiderlingHatch    = spr_add("sprSpiderlingHatch",    5, 8, 8);
			InvSpiderlingIdle  = spr_add("sprInvSpiderlingIdle",  4, 8, 8);
			InvSpiderlingWalk  = spr_add("sprInvSpiderlingWalk",  4, 8, 8);
			InvSpiderlingHurt  = spr_add("sprInvSpiderlingHurt",  3, 8, 8);
			InvSpiderlingDead  = spr_add("sprInvSpiderlingDead",  7, 8, 8);
			InvSpiderlingHatch = spr_add("sprInvSpiderlingHatch", 5, 8, 8);
			spr_path_add("../");
			
			 // Tesseract:
			spr_path_add("Tesseract/");
			TesseractIdle           = spr_add("sprTesseractEyeIdle",           8,  8,  8);
			TesseractHurt           = spr_add("sprTesseractEyeHurt",           3,  8,  8);
			TesseractFire           = spr_add("sprTesseractEyeFire",           4,  8,  8);
			TesseractTell           = spr_add("sprTesseractEyeTell",           6,  8,  8);
			TesseractLayer          =[spr_add("sprTesseractLayerBottom",       2, 48, 48),
			                          spr_add("sprTesseractLayerMiddle",       2, 48, 48),
			                          spr_add("sprTesseractLayerTop",          2, 48, 48)];
			TesseractDeathLayer     =[spr_add("sprTesseractDeathLayerBottom",  3, 48, 48),
			                          spr_add("sprTesseractDeathLayerMiddle",  6, 48, 48),
			                          spr_add("sprTesseractDeathLayerTop",    11, 48, 48)];
			TesseractDeathCause     = spr_add("sprTesseractDeathCause",        8, 48, 48);
			TesseractDeathCauseText = spr_add("sprTesseractDeathCauseText",   12, 36,  4);
			TesseractWeapon         = spr_add("sprTesseractWeapon",            1, 24, 24);
			TesseractStrike         = spr_add("sprTesseractStrike",            4, 26, 12);
			with(TesseractDeathLayer){
				mask = [true, 0];
			}
			spr_path_add("../");
			
			 // Traffic Crab:
			spr_path_add("Crab/");
			CrabIdle = spr_add("sprTrafficCrabIdle", 5, 24, 24);
			CrabWalk = spr_add("sprTrafficCrabWalk", 6, 24, 24);
			CrabHurt = spr_add("sprTrafficCrabHurt", 3, 24, 24);
			CrabDead = spr_add("sprTrafficCrabDead", 9, 24, 24);
			CrabFire = spr_add("sprTrafficCrabFire", 2, 24, 24);
			CrabHide = spr_add("sprTrafficCrabHide", 5, 24, 24);
			spr_path_add("../");
			
			 // Yeti Crab:
			spr_path_add("YetiCrab/");
			YetiCrabIdle = spr_add("sprYetiCrab", 1, 12, 12);
			KingCrabIdle = spr_add("sprKingCrab", 1, 12, 12);
			spr_path_add("../");
			
		//#endregion
		
		//#region CAMPFIRE
		spr_path_set("areas/Campfire/");
		
			 // Loading Screen:
			SpiralDebrisNothing = spr_add("sprSpiralDebrisNothing", 5, 24, 24);
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Big Cactus:
				BigNightCactusIdle = spr_add("sprBigNightCactus",     1, 16, 16);
				BigNightCactusHurt = spr_add("sprBigNightCactus",     1, 16, 16, shnHurt);
				BigNightCactusDead = spr_add("sprBigNightCactusDead", 4, 16, 16);
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region DESERT
		spr_path_set("areas/Desert/");
		
			 // Big Decal:
			BigTopDecal[?     area_desert] = spr_add("sprBigTopDecalDesert",         1, 32, 56);
			msk.BigTopDecal[? area_desert] = spr_add("../mskBigTopDecal",            1, 32, 12);
			BigTopDecalScorpion            = spr_add("sprBigTopDecalScorpion",       1, 32, 52);
			BigTopDecalScorpionDebris      = spr_add("sprBigTopDecalScorpionDebris", 8, 10, 10);
			
			 // Fly:
			FlySpin = spr_add("sprFlySpin", 16, 4, 4);
			
			 // Wall Rubble:
			Wall1BotRubble = spr_add("sprWall1BotRubble", 4, 0,  0);
			Wall1TopRubble = spr_add("sprWall1TopRubble", 4, 0,  0);
			Wall1OutRubble = spr_add("sprWall1OutRubble", 4, 4, 12);
			
			 // Wall Bro:
			WallBandit = spr_add("sprWallBandit", 9, 8, 8);
			
			 // Scorpion Floor:
			FloorScorpion     = spr_add("sprFloorScorpion",     2, 8, 8);
			SnowFloorScorpion = spr_add("sprSnowFloorScorpion", 1, 8, 8);
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Camp:
				BanditCampfire     = spr_add("sprBanditCampfire",     1, 26, 26);
				BanditTentIdle     = spr_add("sprBanditTent",         1, 24, 24);
				BanditTentHurt     = spr_add("sprBanditTentHurt",     3, 24, 24);
				BanditTentDead     = spr_add("sprBanditTentDead",     3, 24, 24);
				BanditTentWallIdle = spr_add("sprBanditTentWall",     1, 24, 24);
				BanditTentWallHurt = spr_add("sprBanditTentWallHurt", 3, 24, 24);
				BanditTentWallDead = spr_add("sprBanditTentWallDead", 3, 24, 24);
				shd.BanditTent     = spr_add("shdBanditTent",         1, 24, 24);
				
				 // Big Cactus:
				BigCactusIdle = spr_add("sprBigCactus",     1, 16, 16);
				BigCactusHurt = spr_add("sprBigCactus",     1, 16, 16, shnHurt);
				BigCactusDead = spr_add("sprBigCactusDead", 4, 16, 16);
				
				 // Return of a Legend:
				CowSkullIdle = spr_add("sprCowSkull",     1, 24, 24);
				CowSkullHurt = spr_add("sprCowSkull",     1, 24, 24, shnHurt);
				CowSkullDead = spr_add("sprCowSkullDead", 3, 24, 24);
				
				 // Scorpion Rock:
				ScorpionRock         = spr_add("sprScorpionRock",     6, 16, 16);
				ScorpionRockAlly     = spr_add("sprScorpionRockAlly", 6, 16, 16);
				ScorpionRockHurt     = spr_add("sprScorpionRock",     6, 16, 16, shnHurt);
				ScorpionRockAllyHurt = spr_add("sprScorpionRockAlly", 6, 16, 16, shnHurt);
				ScorpionRockDead     = spr_add("sprScorpionRockDead", 3, 16, 16);
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region SCRAPYARD
		spr_path_set("areas/Scrapyard/");
		
			 // Decals:
			BigTopDecal[? area_scrapyards] = spr_add("sprBigTopDecalScrapyard",  1, 32, 48);
			TopDecalScrapyardAlt           = spr_add("sprTopDecalScrapyardAlt",  1, 16, 16);
			NestDebris                     = spr_add("sprNestDebris",           16,  4,  4);
			
			 // Sludge Pool:
			SludgePool          = spr_add("sprSludgePool",      4,  0,  0);
			msk.SludgePool      = spr_add("mskSludgePool",      1, 32, 32);
			msk.SludgePoolSmall = spr_add("mskSludgePoolSmall", 1, 16, 16);
			
			 // Fire Pit Event:
			FirePitScorch = spr_add("sprFirePitScorch", 3, 16, 16);
			TrapSpin      = spr_add("sprTrapSpin",      8, 12, 12);
			
		//#endregion
		
		//#region CRYSTAL CAVES
		spr_path_set("areas/Caves/");
		
			 // Decals:
			BigTopDecal[?     area_caves       ] = spr_add("sprBigTopDecalCaves",       1, 32, 56);
			BigTopDecal[?     area_cursed_caves] = spr_add("sprBigTopDecalCursedCaves", 1, 32, 56);
			msk.BigTopDecal[? area_caves       ] = spr_add("../mskBigTopDecal",         1, 32, 16);
			msk.BigTopDecal[? area_cursed_caves] = msk.BigTopDecal[? area_caves];
			
			 // Wall Spiders:
			WallSpider          = spr_add("sprWallSpider",          2, 8, 8);
			WallSpiderBot       = spr_add("sprWallSpiderBot",       2, 0, 0);
			WallSpiderling      = spr_add("sprWallSpiderling",      4, 8, 8);
			WallSpiderlingTrans = spr_add("sprWallSpiderlingTrans", 4, 8, 8);
			
			 // Cave Hole:
			CaveHole	   = spr_add("sprCaveHole",		 1, 64, 64);
			CaveHoleCursed = spr_add("sprCaveHoleCursed", 1, 64, 64);
			msk.CaveHole   = spr_add("mskCaveHole",		 1, 64, 64);
			with(msk.CaveHole){
				mask = [false, 0];
			}
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Big Crystal Prop:
				BigCrystalPropIdle = spr_add("sprBigCrystalPropIdle", 1, 16, 16);
				BigCrystalPropHurt = spr_add("sprBigCrystalPropIdle", 1, 16, 16, shnHurt);
				BigCrystalPropDead = spr_add("sprBigCrystalPropDead", 4, 16, 16);
				
				 // Cursed Big Crystal Prop:
				InvBigCrystalPropIdle = spr_add("sprInvBigCrystalPropIdle", 1, 16, 16);
				InvBigCrystalPropHurt = spr_add("sprInvBigCrystalPropIdle", 1, 16, 16, shnHurt);
				InvBigCrystalPropDead = spr_add("sprInvBigCrystalPropDead", 4, 16, 16);
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region FROZEN CITY
		spr_path_set("areas/City/");
		
			 // FIX CRAP:
			sprite_replace(sprWall5Bot, spr_path + "sprWall5BotFix.png", 3);
			
			 // Seal Plaza:
			FloorSeal            = spr_add("sprFloorSeal",         4, 16, 16);
			SnowFloorSeal        = spr_add("sprFloorSeal",         4, 16, 16, shnSnow);
			FloorSealRoom        = spr_add("sprFloorSealRoom",     9, 16, 16);
			SnowFloorSealRoom    = spr_add("sprFloorSealRoom",     9, 16, 16, shnSnow);
			FloorSealRoomBig     = spr_add("sprFloorSealRoomBig", 25, 16, 16);
			SnowFloorSealRoomBig = spr_add("sprFloorSealRoomBig", 25, 16, 16, shnSnow);
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Igloos:
				IglooFrontIdle = spr_add("sprIglooFront",     1, 24, 24);
				IglooFrontHurt = spr_add("sprIglooFrontHurt", 3, 24, 24);
				IglooFrontDead = spr_add("sprIglooFrontDead", 3, 24, 24);
				IglooSideIdle  = spr_add("sprIglooSide",      1, 24, 24);
				IglooSideHurt  = spr_add("sprIglooSideHurt",  3, 24, 24);
				IglooSideDead  = spr_add("sprIglooSideDead",  3, 24, 24);
				
				 // Palanking Statue:
				PalankingStatueIdle  =[spr_add("sprPalankingStatue1",     1, 32, 32),
				                       spr_add("sprPalankingStatue2",     1, 32, 32),
				                       spr_add("sprPalankingStatue3",     1, 32, 32),
				                       spr_add("sprPalankingStatue4",     1, 32, 32)];
				PalankingStatueHurt  =[spr_add("sprPalankingStatue1",     1, 32, 32, shnHurt),
				                       spr_add("sprPalankingStatue2",     1, 32, 32, shnHurt),
				                       spr_add("sprPalankingStatue3",     1, 32, 32, shnHurt),
				                       spr_add("sprPalankingStatue4",     1, 32, 32, shnHurt)];
				PalankingStatueDead  = spr_add("sprPalankingStatueDead",  3, 32, 32);
				PalankingStatueChunk = spr_add("sprPalankingStatueChunk", 5, 16, 16);
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region LABS
		spr_path_set("areas/Labs/");
		
			 // Freak Chamber:
			Wall6BotTrans     = spr_add("sprWall6BotTrans",     4,  0,  0);
			FreakChamberAlarm = spr_add("sprFreakChamberAlarm", 4, 12, 12);
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Mutant Vat:
				MutantVatIdle  = spr_add("sprMutantVat",      1, 32, 32);
				MutantVatHurt  = spr_add("sprMutantVatHurt",  3, 32, 32);
				MutantVatDead  = spr_add("sprMutantVatDead",  3, 32, 32);
				MutantVatBack  = spr_add("sprMutantVatBack",  6, 32, 32);
				MutantVatLid   = spr_add("sprMutantVatLid",   8, 24, 24);
				MutantVatGlass = spr_add("sprMutantVatGlass", 4, 6,  6);
				
				 // Button:
				ButtonIdle        = spr_add("sprButtonIdle",         1, 16, 16);
				ButtonHurt        = spr_add("sprButtonHurt",         3, 16, 16);
				ButtonPressedIdle = spr_add("sprButtonPressedIdle",  1, 16, 16);
				ButtonPressedHurt = spr_add("sprButtonPressedHurt",  3, 16, 16);
				ButtonDead        = spr_add("sprButtonDead",         4, 16, 16);
				ButtonDebris      = spr_add("sprButtonDebris",       1, 12, 12);
				ButtonRevive      = spr_add("sprButtonRevive",      12, 24, 48);
				ButtonReviveArea  = spr_add("sprButtonReviveArea",   8, 20, 20);
				PickupRevive      = spr_add("sprPickupRevive",      12, 24, 48);
				PickupReviveArea  = spr_add("sprPickupReviveArea",   8, 20, 20);
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region PALACE
		spr_path_set("areas/Palace/");
		
			 // Decals:
			BigTopDecal[?     area_palace] = spr_add("sprBigTopDecalPalace", 1, 32, 56);
			msk.BigTopDecal[? area_palace] = spr_add("../mskBigTopDecal",    1, 32, 16);
			
			 // Generator Shadows Woooo:
			shd.BigGenerator  = spr_add("shdBigGenerator",  1, 48-16, 32);
			shd.BigGeneratorR = spr_add("shdBigGeneratorR", 1, 48+16, 32);
			
			 // Inactive Throne Hitbox (Can walk on top, so cool broo):
			msk.NothingInactiveCool = spr_add("mskNothingInactiveCool", 1, 150, 100);
			with(msk.NothingInactiveCool){
				mask = [false, 0];
			}
			
			 // Better Game Over Sprite (Big spr_add so that the on-hover text is more mandatory):
			NothingDeathCause = spr_add("sprNothingDeathCause", 1, 80, 80);
			
			 // Throne Shadow:
			shd.Nothing = spr_add("shdNothing", 1, 128, 100);
			
			 // Stairs:
			FloorPalaceStairs       = spr_add("sprFloorPalaceStairs",       3, 0, 0);
			FloorPalaceStairsCarpet = spr_add("sprFloorPalaceStairsCarpet", 6, 0, 0);
			
			 // Shrine Floors:
			FloorPalaceShrine          = spr_add("sprFloorPalaceShrine",          10, 2, 2);
			FloorPalaceShrineRoomSmall = spr_add("sprFloorPalaceShrineRoomSmall",  4, 0, 0);
			FloorPalaceShrineRoomLarge = spr_add("sprFloorPalaceShrineRoomLarge",  9, 0, 0);
			
			 // Tiny TopSmalls:
			TopTiny[? sprWall7Trans] = [
				[spr_add("sprTopTinyPalace", 8,  0,  0),
				 spr_add("sprTopTinyPalace", 8,  0, -8)],
				[spr_add("sprTopTinyPalace", 8, -8,  0),
				 spr_add("sprTopTinyPalace", 8, -8, -8)]
			];
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Palace Altar:
				PalaceAltarIdle   = spr_add("sprPalaceAltar",       1, 24, 24);
				PalaceAltarHurt   = spr_add("sprPalaceAltarHurt",   3, 24, 24);
				PalaceAltarDead   = spr_add("sprPalaceAltarDead",   4, 24, 24);
				PalaceAltarDebris = spr_add("sprPalaceAltarDebris", 5,  8,  8);
				
				GroundFlameGreen             = spr_add("sprGroundFlameGreen",             8, 4, 6);
				GroundFlameGreenBig          = spr_add("sprGroundFlameGreenBig",          8, 6, 8);
				GroundFlameGreenDisappear    = spr_add("sprGroundFlameGreenDisappear",    4, 4, 6);
				GroundFlameGreenBigDisappear = spr_add("sprGroundFlameGreenBigDisappear", 4, 6, 8);
				
				 // Pillar (Connects to the ground better):
				sprite_replace(sprNuclearPillar,     spr_path + "sprNuclearPillar.png",     11, 24, 32);
				sprite_replace(sprNuclearPillarHurt, spr_path + "sprNuclearPillarHurt.png",  3, 24, 32);
				sprite_replace(sprNuclearPillarDead, spr_path + "sprNuclearPillarDead.png",  3, 24, 32);
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region VAULT
		spr_path_set("areas/Vault/");
		
			 // Tiny TopSmalls:
			TopTiny[? sprWall100Trans] = [
				[spr_add("sprTopTinyVault", 12,  0,  0),
				 spr_add("sprTopTinyVault", 12,  0, -8)],
				[spr_add("sprTopTinyVault", 12, -8,  0),
				 spr_add("sprTopTinyVault", 12, -8, -8)]
			];
			
			 // Vault Flower Room:
			VaultFlowerFloor      = spr_add("sprFloorVaultFlower",      9, 0, 0);
			VaultFlowerFloorSmall = spr_add("sprFloorVaultFlowerSmall", 4, 0, 0);
			
			 // Quest Room Tiles:
			QuestFloor             = spr_add("sprFloorQuest",             4,  0,  0);
			QuestTeleporterFloor   = spr_add("sprQuestTeleporterFloor",   1,  0,  0);
			QuestTeleporterPad     = spr_add("sprQuestTeleporterPad",     4, 10, 10);
			QuestTeleporterSparkle = spr_add("sprQuestTeleporterSparkle", 5,  8,  8);
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Vault Flower:
				VaultFlowerIdle         = spr_add("sprVaultFlower",              4, 24, 24);
				VaultFlowerHurt         = spr_add("sprVaultFlowerHurt",          3, 24, 24);
				VaultFlowerDead         = spr_add("sprVaultFlowerDead",          3, 24, 24);
				VaultFlowerWiltedIdle   = spr_add("sprVaultFlowerWilted",        1, 24, 24);
				VaultFlowerWiltedHurt   = spr_add("sprVaultFlowerWiltedHurt",    3, 24, 24);
				VaultFlowerWiltedDead   = spr_add("sprVaultFlowerWiltedDead",    3, 24, 24);
				VaultFlowerDebris       = spr_add("sprVaultFlowerDebris",       10,  4,  4);
				VaultFlowerWiltedDebris = spr_add("sprVaultFlowerWiltedDebris", 10,  4,  4);
				VaultFlowerSparkle      = spr_add("sprVaultFlowerSparkle",       4,  3,  3);
				
				 // Quest Props:
				// QuestProp1Idle = spr_add("sprQuestProp1Idle", 1, 16, 16);
				// QuestProp1Hurt = spr_add("sprQuestProp1Idle", 1, 16, 16, shnHurt);
				// QuestProp1Dead = spr_add("sprQuestProp1Dead", 3, 16, 16);
				// QuestProp2Idle = spr_add("sprQuestProp2Idle", 1, 16, 16);
				// QuestProp2Hurt = spr_add("sprQuestProp2Hurt", 3, 16, 16);
				// QuestProp2Dead = spr_add("sprQuestProp2Dead", 3, 16, 16);
				// QuestProp3Idle = spr_add("sprQuestProp3Idle", 1, 16, 16);
				// QuestProp3Hurt = spr_add("sprQuestProp3Hurt", 1, 16, 16, shnHurt);
				// QuestProp3Dead = spr_add("sprQuestProp3Dead", 3, 16, 16);
				QuestPillar1Idle = spr_add("sprQuestPillar1Idle", 1, 16, 20);
				QuestPillar1Hurt = spr_add("sprQuestPillar1Idle", 1, 16, 20, shnHurt);
				QuestPillar1Dead = spr_add("sprQuestPillar1Dead", 4, 16, 20);
				QuestPillar2Idle = spr_add("sprQuestPillar2Idle", 1, 20, 24);
				QuestPillar2Hurt = spr_add("sprQuestPillar2Idle", 1, 20, 24, shnHurt);
				QuestPillar2Dead = spr_add("sprQuestPillar2Dead", 4, 20, 24);
				QuestTorchIdle   = spr_add("sprQuestTorchIdle",   5, 20, 28);
				QuestTorchHurt   = spr_add("sprQuestTorchHurt",   3, 20, 28);
				QuestTorchDead   = spr_add("sprQuestTorchDead",   6, 20, 28);
				
				 // Ghost Statue:
				GhostStatueIdle   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAMAAABg3Am1AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAASUExURQAAAH9kQ1RCLDInGq+PagAAAHxMDEMAAAAGdFJOU///////ALO/pL8AAAAJcEhZcwAADsMAAA7DAcdvqGQAAAEnSURBVEhL7ZPREoUgCEQF7f9/+e4STSlkNnMf22nSkCMgWbaX+oAVpUCBfBqUAyJ6R+T2UuUuRh6hKJQjmbFIU2ktTysHDiWrmUm1IYRYWm47lViYkOBp6VllAPe+zSlacKbV3VcBbo8gteoqQOcXEYww96wRGYBOVyptdbDxT+XmigrwQ8V1Hw+Vim5ZOqyiaA0OPrrgYX4iBEHWsY7xky0GwIwsUjjZEIGZw58AifA79Z+4OEgJpfopISUZqrh+4d4YgIIpawYM/U3q5qzRW3zIDBNALYJrj8Ci3IHq5opVFnzVFOChYN38znf/S40AU0K555vIHLAWnM9jSiPAvKYRgh5qwI7WtuMNwzQCryY9r8M/AWSwH/0wzACfXjQBlvQBz9q2H25QJL3vdkDHAAAAAElFTkSuQmCC",
				1,  24, 24);
				GhostStatueHurt   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAJAAAAAwCAYAAAD+WvNWAAAAAXNSR0IArs4c6QAAA25JREFUeJztnLFS4zAQhn9u7gnSeCbp3GQYu2DSQ+HU6dzR5j0yvAftdXTUUEDPUJBh0rgLM2nyCroC1kjCzmEjS5vTflWwHfmf1Wq1WokAgiAIgiAIgiAIgiAcCSeuG1RKKeMFJyfO3zEwyvpb9B9gcAcCjs6J1Go5BwCsqx1u7l+A43KiY9f/7kQ2oTV1RM2mY7VazhXeR7Tob8FLBDJeyD8aKQAoi9y4+DGSAf6j2av+3y4b+06kUUopxk6kVss5zrIp/tw+IEsTnGVTAECWJjQlKPB1Iu/6nRqiy1TF1Inq/OEQV9d3AE8n8q7fmRH65DnMnEhR2L9cXABAPYqB94RUh2FyGkT/r582APRzHmao1XJeG/55vcHzemM8cLm4QJYmdYcwI5h+Jw70v0BGX1c7rKudYWy9Q5g6URD9MoV9ombTMQBgcX76z4cZ5kFB9DtdhR076WRkjE49b6i2+8ZnOBFCvziQBRmdDE6jmavT2PjWL8t4E6UX4JqMznx7wLt+75VogK3zEAoAKJ/Qedq80UfR76qhny7hGTiToV8vxOnTgZ47fCSgRNT6f7SMd1H/CVxDUrPpGGWRf9k7AswpwJ4OyiKnUR61/t7e57rjA0QiVRY5qu3eWPZeXd+hLPLa4LePr0gnIwCfG5I0yuleoJyIhf6oC4lZmtTGtaFinI0+RYRe0nPQH7UD2Qam0dtGWeR2/tDYSb7goL9XHWiIvMXzMQ81m46RpQluH1+NUUhhXl/FUE1FW8XU1xfnp6i2ezxt3nwe82Cjv5MDDZ3wUvsDOlJ92IqMqrNazrGudo330snoYMgvi5zO2gDDORI7/dFVoikHqLb7xvDddcea2qDv2VOEa7jpjzYH6pNAtnVYWyI7JFz0RxeB7GMO6WTUKZHUnw3hONz0RxeBmnar28L+d67rHeJjRcZNf3QOpJOliZFw9vncdmTUBxz0RzeFNdFmvC7XqSO0f5/xRkj9UUcgF1GDUyExRBtRRyA7R+j7mTrBtzNx0B+1A+kbjQC+FODoXtt1ukd/Z2nidQrjoD/aKYyMSqO4qXrbtoqh5JPuNX13aLjoj9aBBDdEN4XRPG8X0Q4V1b5zz1f+w01/p02/oX48yuOPUhmHzm/uX5y8pyzyWv/Ah8uOXb8gCIIgCIIgCIIgCOH4C7CPysIjtKRSAAAAAElFTkSuQmCC", 
				3,  24, 24);
				GhostStatueDead   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAMAAAAAwCAYAAABHTnUeAAAAAXNSR0IArs4c6QAABBdJREFUeJztnT1OI0EQhZ9XewInSHY2iYVw5JzExGQ+AvdAe489AhnxkpATgSySyQaJZK4wG0ANNeVu/073NPT7JARjz8+r7qruqp6WAAghhBBCCCGEEEIIIeRHM+r7hk3TNJ0HjEa9P4OQvvgV+gE2IAhJiSCjs8vpOROQFAmeAm08kIFAEqJXZ9w33WEQkFQIXgO4YF1AUqG3kfgYp+ZMQIamlxmAIzr5rgySAhGSCr0EAFMZ8l3hDECyhgFAsmaQ9wAA0yaSBtHfBAN0fpIOJzviqUugCQaDtSc1fS726YOU7RhM/0k37Wv9f+Ag6Nhwe3MFAHgp3wEAdw/PvutScqhG674oztq/AaCsajy9vtlrqP+Um/T98mvAIHA2PgDcP64BANeX5+33wpbAAOI5VwMAi9kExXQMAB39wJcNxXTccSyP/th9MLj+34de8INoA1gc2za+5aI4a4PEjlLy/Z+//0Jo9bJazjvafGjbrP4hdAtD6896GXS1nGMxm3gdv5iO25HJh752WweGoqxqlFW9oUXQNvj0DaFbGFr/UQEQYu9P5P1EG8+yjixTrxzLjxxryqrujEqRaBaziTM9k2NrgwvRvphNgP2K0b5IQv9BKVBoJ5X7B6wHGuBj5JeGK6u6U2xZhh7hHXRsECSF2MeGyIFqSUp/djWAFLy28eW37gTb0DpPtZ3l67wQaBtsDXJRnG0U7xaX9pikpD/rGuClfEcxHW90gi/3tw2tzzHBEiWV0Csj9vNd+q12dRwtDUpBf3YzgJ5C7YjuOhfozhaujpHPiukYT69vWMwmeHp9axBoWdEViMfot7Z85tFBtWtdWsdQ+rOcAWTkF44tYF3TsHRCSFx1icsGvcICfKQUco7+LnYKlJL+nAKgub252lrUSqPqznB1gKs2iFRYti/t9LO1Rl2/6BzaBvz15Xn7vWjfteTbA8npzykAWrTDShrkGkW0U9vGlU6wn+uOCYkNOG2Dqxgvqxr3j+uOndZm63QhSUV/VjXA/ePaWXiVVd0WXnZlQp8j5wG764dQ2GXAXS+HxCb523VNzvoPKnRivawK9B6g0fm5HrnLqt4YOXSj2g6wuLZFfO5V6duO1gbf3hmNHVFd+iNqBxLUn1MAAFs6QK8t+5bn7DmCnRk+96UEdaDry/NWj9Xis2GXfpnVYgRAKvqzCwC989M2ps09XR3jQ3dYwAAAlA32hZHeOqB1Abv16/vkpD/LIhjw7y7U6BWhbcVVhNWTo9mlv5iOoxW+xxBaf3YzgGy/FWz+78o7txVtkXNowGGD6PDlzL6t24K1KSf9JwVAX44a+Z9qdDrg7uH5oGetlvPGNv7dw/NotZy3NsR0oEP1395cNcCXbvmc+gkhhBBCCCGEEEIIIeRH8h+PqYjF8m2k/AAAAABJRU5ErkJggg==", 
				4,  24, 24);
				GhostStatueDebris = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAASUExURQAAADInGlRCLH9kQ6+PagAAAMf8Z7sAAAAGdFJOU///////ALO/pL8AAAAJcEhZcwAADsMAAA7DAcdvqGQAAABdSURBVChTdY4BDsAgCAOhyP+/vLa4LTNZowYOKEYf+gEhObpBJjBITyivteBEF5llMdMBWK0CFQRRztyxgWsGnNGIHExmhB6OQevH1Gu4e4AJm14wP5f2xz46QPcF0EUDULbtW08AAAAASUVORK5CYII=",
				1,  8,  8);
				
				 // Ghost:
				GhostIdle   	   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAMAAAAAwCAYAAABHTnUeAAAAAXNSR0IArs4c6QAAA61JREFUeJzt2k9L22AcB/BvhkjH3ATpIbtMSBGk7GKhGyj23r4DtzcQ8bbbTsb7rsPiC1AQdm3vHR6m0MIYRVZa6C4LQwQ3DyKD7FCf7mnaVNl+NU/0+4GCPg3NN8nzNwlARERERERERERERERERERERERERERERERJY0n+mOc6ABDoZXY6ZfknF/DKHcldTQTzxyuO/A8m8aOb221sbrdRKtjwTy4CoH9wicD88brN/OIjwNNnz/H925cA6B3I1noGADA3O22dnl32tjO0N2L+eMWRX6wBeK6DbK6IZr0aAECpYA98X6n5AMwdkpk/XknPD8914LlOoBzuLgdhh7vLgec6wf7OhnFD8n3IHwQB84eIrAE818Hc7PRAWX7tYGi7/NoBNrfbaNargZ1OSexaxH3JD/R6Vub/S6QBZHNFnJ5dBqWCjaO9lX55+G/10Rc3JtDz6/T86v+k5wdgdP7r6g8gm39K4kea9Wqwud0GMHzSFb1FR20Tl3D+qN5HlTO/rDjrj0gDCFMBx12ISi0ziV2LYP543WZ+kQYwv/DS2lrP9Ick1ZrHKRVsY1bydyl/qWBHVhwd8/eINIBu6xOA4fD6UKVuY930AG/TXck/quGqY0hi/ts4/+JToPAJVweVXxvcTn1vmqgKk4T84yoM848m1gDsdMqq1Pz+nYiolnq0t4JKzUc2V7SA91K7/2/3JT8AbK1nmP+K6JPgxewSjpuNa29PLWaXrONmw5g5KHD1IKbcgec6zB+DuOqP6BTouNkI9HmcPp3QW/TVgkf0PSQJnusM3Y4LT+UAM/Oryj8qf/iavHj1wbgnwcBg/QlPh/TySq0hdv4n8jaoog9hpi28rtObd/Yy6w+YTLuHHkXPP2pubTo9f7hckugIkMuvWlvrmUDv7VXvr+bOAJDNFa1mvSq5azFRD5JMzu+5DnL5VdgPWwPl4SepKv/+zgZMyq8Ln3+VeVLnX7QB/PrR6PeWUT3lk5kpq1mvGjX/DAtPf3ReuWN5rnn560cfh14lSFJ+Xbju6COwdP0RnQK1uudjFzClgo2f57+NeQflX9xkkRmXpExvIgy9yzTqeN68+yq6U/E1wLiLkIQLpGdUF0S/J20qr9yxvHLHqtR8qE/SxFF3pB+EWXY6hVb3fGA0qNR8LMzPWHY6Bf/kQniXovr5X7/9PNDbV2o+7HTKqDs/Os91YKdTePxoykpa9isj6w4AtLrnSag7RERERERERERERERERERERHH7A706lY6CyEQOAAAAAElFTkSuQmCC", 
				4,  24, 24);
				GhostAppear 	   = sprite_add_base64("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", 
				12, 24, 24);
				GhostDisappear	   = sprite_add_base64("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",
				12, 24, 24);
				GhostHaloAppear	   = sprite_add_base64("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", 
				13, 24, 24);
				GhostHaloDisappear = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAYAAAAAwCAMAAAAvpF1MAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAPUExURQAAAP///8qmOoBoIgAAAHJ6AHYAAAAFdFJOU/////8A+7YOUwAAAAlwSFlzAAAOwwAADsMBx2+oZAAAAXZJREFUeF7tldkSgyAQBIPw/98cjo1HigrLoaNk+iESSyidZpeXI1AooBIj13aOK1BAb6Kd8ycUYBojSdN6fdQyr4D4W5JRGfcJdp4iYJFria+IWqvhOh4iYDFaA0/jIQLM/bdyI3MJqLR0h8dZAWBmPwNu7202Ad2BX20sK8AuESt/b4B/GxmNZUDcnUvkBCy+40a0H22jMXuisCoBn/Ni/GYesuJxkYwAu36AUUXq0xdfupqxyVcwpldWUwDNB/Z4Y2VyArYK0ATkH5eR00xYdQX0be6cDhTpiH2AsVwL8js0pqPaoLv8NQbC0jL0KB3PTPYQDl1C2x+s71gbxUlrf0sou9zE5AXUIPUSUNTM9nCCFSDXHlK9BOTGL3a+tF1uakYIqENcCXLzf7leADlAAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAAwFgKEAMBQAhgLAUAAYCgBDAWAoAIpzb5t6HZ+2Q2FEAAAAAElFTkSuQmCC", 
				8,  24, 24);
				/*
				GhostHurt		   = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAJAAAAAwCAYAAAD+WvNWAAAAAXNSR0IArs4c6QAAAs9JREFUeJzt2rFrE1EcB/DvE5EMgiAZbhMuCFIHUcjSQHYzdFPJH6BeEP8EyQtCcXFTkri4JSDOcQ90sIF2MhQkAbcMHYRS6FB4Ds1L7y6X9Agvee/s9zP17kLuy9279373SwEiIiIiIiIiIiIiIiIiIiIiug7UlO0cq5KBr2TgM/8Vbpj8Mhn4c/uyNIji+evNUaYGko38RgdQmBBC6L+VUippcLlu0C2h3hwBSH44XLeJ/GsZQO3dnbmZ5+6dW5CBn4kb0d7dAQD0+pPZPuZPJq7+SDoy8LH15Cmev/q8dNlqv3soJsdnkK2xqVMbEc4vA19Vyl7kuL4ZXj7H/OugR7ZK4duXN849yTqPDPxZzv3OttrvbEeyy8Bn/hAjS5gMfNSbo9RvXc9eflJePmfi1EZML6ZKenKL1b3IdqXsYXjwg/mnjCxhq75phQttm2TgK11sDrolAPMXXu8HLpcD2Rpf+/xrewvLMn3xwxe9WN2b7Y8/5a7ZZP6bJr5ECCGy1O+Ju3gSC7P8xerizxare5Eb4wKb+Y3MQF8/LkmcATp/peyhUvYWLgPaov222MxvZAb68/unia+xJil/o1YAEJ3uXRs4ms38rIFCwo23pGONWsG55SvMRn4jMxBw0SB8/f5XZuugaYNNAbrgjB4Pb7s4iGzlN9qJfrD1GC/efk81iBq1gnCpG6rzHw0P5/Iv6OoyPwzOQABSDx5XHQ0PI/0UvSQsWxpcYiO/0QH0P9HLgL4R+sYAlwWqyzaV32gR7UpneVWyNRaDbmmuAQe4WffE2chvdAZK20x0rf7Rwv94pS94rz+Z1RChJ5f5p4zNQPXmKNP1D4C5HyIzxkp+9oFC4sVmfNv1AWYjv7ElrFErCADw8jkk9YM6Hx6Jk9NzTI7PTJ3SNAEAB8O/0P0Urdef4P692+Lk9NxOsnSynp+IiIiIiIiIiIiIiMi0f6AZF5c7oztvAAAAAElFTkSuQmCC", 
				3,  24, 24);
				*/
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region COAST
		spr_path_set("areas/Coast/");
		
			 // Floors:
			FloorCoast  = spr_add("sprFloorCoast",  4, 2, 2);
			FloorCoastB = spr_add("sprFloorCoastB", 3, 2, 2);
			DetailCoast = spr_add("sprDetailCoast", 6, 4, 4);
			
			 // Sea:
			CoastTrans    = spr_add("sprCoastTrans",    1,   0, 0);
			WaterGradient = spr_add("sprWaterGradient", 1, 128, 0);
			WaterStreak   = spr_add("sprWaterStreak",   7,   8, 8);
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Blooming Cactus:
				BloomingCactusIdle =[spr_add("sprBloomingCactus",      1, 12, 12),
				                     spr_add("sprBloomingCactus2",     1, 12, 12),
				                     spr_add("sprBloomingCactus3",     1, 12, 12)];
				BloomingCactusHurt =[spr_add("sprBloomingCactus",      1, 12, 12, shnHurt),
				                     spr_add("sprBloomingCactus2",     1, 12, 12, shnHurt),
				                     spr_add("sprBloomingCactus3",     1, 12, 12, shnHurt)];
				BloomingCactusDead =[spr_add("sprBloomingCactusDead",  4, 12, 12),
				                     spr_add("sprBloomingCactus2Dead", 4, 12, 12),
				                     spr_add("sprBloomingCactus3Dead", 4, 12, 12)];
				
				 // Big Blooming Cactus:
				BigBloomingCactusIdle = spr_add("sprBigBloomingCactus",     1, 16, 16);
				BigBloomingCactusHurt = spr_add("sprBigBloomingCactus",     1, 16, 16, shnHurt);
				BigBloomingCactusDead = spr_add("sprBigBloomingCactusDead", 4, 16, 16);
				
				 // Buried Car:
				BuriedCarIdle = spr_add("sprBuriedCar",     1, 16, 16);
				BuriedCarHurt = spr_add("sprBuriedCarHurt", 3, 16, 16);
				
				 // Bush:
				BloomingBushIdle = spr_add("sprBloomingBush",     1, 12, 12);
				BloomingBushHurt = spr_add("sprBloomingBushHurt", 3, 12, 12);
				BloomingBushDead = spr_add("sprBloomingBushDead", 3, 12, 12);
				
				 // Palm:
				PalmIdle     = spr_add("sprPalm",         1, 24, 40);
				PalmHurt     = spr_add("sprPalmHurt",     3, 24, 40);
				PalmDead     = spr_add("sprPalmDead",     4, 24, 40);
				PalmFortIdle = spr_add("sprPalmFort",     1, 32, 56);
				PalmFortHurt = spr_add("sprPalmFortHurt", 3, 32, 56);
				
				 // Sea/Seal Mine:
				SealMine     = spr_add("sprSeaMine", 1, 12, 12);
				SealMineHurt = spr_add("sprSeaMine", 1, 12, 12, shnHurt);
				
			spr_path_add("../Decals/");
			
				 // Decal Water Rock Props:
				RockIdle  =[spr_add("sprRock1Idle", 1, 16, 16),
				            spr_add("sprRock2Idle", 1, 16, 16)];
				RockHurt  =[spr_add("sprRock1Idle", 1, 16, 16, shnHurt),
				            spr_add("sprRock2Idle", 1, 16, 16, shnHurt)];
				RockDead  =[spr_add("sprRock1Dead", 1, 16, 16),
				            spr_add("sprRock2Dead", 1, 16, 16)];
				RockBott  =[spr_add("sprRock1Bott", 1, 16, 16),
				            spr_add("sprRock2Bott", 1, 16, 16)];
				RockFoam  =[spr_add("sprRock1Foam", 1, 16, 16),
				            spr_add("sprRock2Foam", 1, 16, 16)];
				ShellIdle = spr_add("sprShellIdle", 1, 32, 32);
				ShellHurt = spr_add("sprShellIdle", 1, 32, 32, shnHurt);
				ShellDead = spr_add("sprShellDead", 6, 32, 32);
				ShellBott = spr_add("sprShellBott", 1, 32, 32);
				ShellFoam = spr_add("sprShellFoam", 1, 32, 32);
				
			spr_path_add("../");
			//#endregion
			
			 // Strange Creature:
			CreatureIdle = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAACMAAAACgCAMAAADXNXIqAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQWkrGXVgQ/w4ALiVetS/rwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKuM2GgAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAADJxJREFUeF7t24ty20YSQFFlLcv//8VZYNCkAGLwIAYU0c45VSvSeM3dSRWqI1c+/gUASMYAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0WgaYj4k4eCERFuLghURYiIMXEmEhDl5IhIU4eCERFuLglUTZII5dSZQN4tiVRNkgjl1JlA3i2JVE2SCOXUmUDeLYlUTZII5dSZQN4tjZDj03kv6ZiINxyVtFSoSFOBiXvFWkRFiIg3HJW0VKhIU4GJe8VaREWIiDcclbRUqEhTgYl7xXtETZII7FFe8VLVE2iGNxxXtFS5QN4lhc8V7REmWDOBZXvFe0RNkgjsUV7xUtUTaIY3HFe0VLlA3iWFzxVpHyI33PPrBERFLVCxqfoa+NvjZX79sM1LdOXxt9bS7et5V3et9TT1tu+9+3N+6hvjb62ly9bzkw2nqX7JsE6luir42+Jst5o76T3y/7H7W+eeMdLI1x18/R10Zfm6v3LQcOSaVscMG+hw3UN6evjb4mi3mlbJp3Yt/eBy3WdWWxhRM/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",
			14, 80, 80);
			CreatureHurt = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAeAAAACgCAMAAADjJU9/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQXVgQ7iVetS/r////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHiDNaAAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAABYhJREFUeF7tmomS2joURCF2+P8/nmhpBttos9GWpk/VC4MsXXf1GZNJXm4/ghoJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYnI8EP7ZgbSZuW7A2E0jmwVptrs2F0xDYMRZ0dt+CNewYC7IgmQdr2FGN0wPhMQV2jsG1hM5CNOjwFL3znZsGg3mwvzfx7v68GOh4QL4To+CuEBzqSLQ9X5v7FZgOcagjY/KVDoK2M+BkH5LPxu4B8fRWPCxf2RgoOwkOdyDanq8uUKCtEIc7MDBfyRT4ugAGNCZRX6i5X3o9xEPz5WfA1TUwoyWp+gzhx8PT5SEenC83AqIugzHNyNS3AaXtaW54eL7MBGj6AAxqRLQ+FLRhiOHx+dIDIOkjMKoJkf5QzoEBhifIlzwPRR+CYQ041V+MhoZnyJc6DkGfg3m1CfeHXopp9yfiKfIlDsNODTCxLnX6sz/FtjE8R774WbipA2bW5NLnX+CyXWpheJJ80aMwUwtMrcel/kINupX6hmfJFzsJL/XA3FpE+jtfII7UNjxNvshBWKkJJtch1t/lAiv/pdY8+cLn4KQumF2DaH/Jv/mzvF1+FljV8ET5JBgLkwu+nC94DEYqg+EViPeXbs/wvgMrNQXPlK+j4HqGEwXaNlIthgr0hyoanilf6BR8VAfjPybVny3jvaQXbsMO++/cHg+zXk3wVPn4BKf/D6u9vsMsmP4ej1svwZ3zzSS4bFe2QAPK2YFL/qJ9Xde/jnV1980XeHPgTYKp8gVOuXEtwPww2FMgON/fFvv5Zr7/DVjwoDyPazBToBng9uYFz5VvEsHYYcFKnDMF+voMuwZ37TlWex3zQ6C9v2tlwe3z9RRswT324JoHa3HKCzSlYKgpEGuh+kwx67LYDsMlPuurLbhHvt6CHbgRwCLAYoKyAl0dmwKxfEcTW9Zfgi2+6jM7834ny/ceGHdsDG72fjssxynrz/Eq8HkIRWx5/izzxPS47fB221wvETxZvlGCLcG7uQwpThSIkfYPkQ7fwa6wdcEXB0yHrpptfWZzXcGI1zTfSMFBkCJOeYFuHr6+321Tpr1Dfbu3B2yJu+tLXcFd8n2J4MVWZ34P2/VnfktL9ffWr93fSHC7fN8hGPUd+jDv0gUe+l2aCW6YbzrBWcPlBdoG7YvvzoImPPZdssDDRTPENJo1PFk+asGeZXl+BKIJj3uXLPCA6c+MqSnY0zbffIJzhs8WaOoL9Xe6QPuAlDzCk+XjF2yw39kfF+j6CzwiRybLN6HgjOErBQb685wr0P+YmzE8Wb5vEBx8QDzlBbofYWyD9QU3zTej4LThCwW6/sIFFjdoCvRjcoYny/flgssfET/D0lPw5/kCYdHySJAkDGopp16B9tX8lzaMu5bTNF8wK2oeB3LEQDGl/H52BSgvcPOaFjxXvkhWFF0KTu14rrsNCWeZy2FQTRnLglM7bKXPV3wZJHM5DO5cRtN8qW9GX30C7BsF+omDfaNAijjY15Tcp434z5FgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJpubn5x8Du/CP6ZKb1gAAAABJRU5ErkJggg==",
			3, 80, 80);
			CreatureBott = sprite_add_base64("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",
			1, 80, 80);
			CreatureFoam = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwAAADsABataJCQAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAIVSURBVHhe7dLBTsIAFERR/v+nMe6voBUGtGeSs7npok3f5Xq9wstkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGd/YrdXzvLmMT/AXVu/9U/9l9W1PkfEB7P+u/vdhGX/BzrW6gR/JeJCdd3UP35LxIDv36ibuyniQnXt1E3dlPMis7uKmjAeZ1V3clPEgs8/VbXwp4y/ZeVf3cFPGB/nLq+/hCTI+0Tus3osXyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhI3r5QPGwQeqRTAO1AAAAABJRU5ErkJggg==",
			1, 80, 80);
			
		//#endregion
		
		//#region OASIS
		spr_path_set("areas/Oasis/");
		
			 // Big Bubble:
			BigBubble    = spr_add("sprBigBubble",    1, 24, 24);
			BigBubblePop = spr_add("sprBigBubblePop", 4, 24, 24);
			
			 // Decals:
			BigTopDecal[? area_oasis] = spr_add("sprBigTopDecalOasis", 1, 32, 52);
			BigTopDecal[? "oasis"] = BigTopDecal[? area_oasis];
			
			 // Ground Crack Effect:
			Crack = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAAAgCAYAAACinX6EAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuMTczbp9jAAABk0lEQVRoQ+WVS3KDQAxEOUQ22ed0OUPujhEVTWk6PWK+sSgWrwwPI0/3YHvb9/3RUPkkqHwSVEbg4+f7eOHXZkJlBLAAr5CRsqh8FxLEwq6jE7avz+Plr6+BygiUChAkMKNUkAeVUbCBvOCIFqX3elAZCRr8WDYF3oezGFRGIgvFgqqzmOs4D6EyCmn3C+Eyb6+Z86uvApWt1H7fWsEw6diDlIBzLVQiElDBa8KKAmRmCsLCY9ASx3u89VFZ4j8LqArnYe8/jnG+QqWHhMXAzI0yXICgM34LYGvMTmqQIedg06p1Wgb7sBayIBMorSk7aUVD2zJmgQFG0blYQjroQXcc/Qi6UyzECOwz5DjJHlbsvIIBRsH5CpW1zN59y8ynwFsnlVfoI7SyAAGD9IJzLVS2sLIEmc0CtXC1PipbWVnC+S8Doaqp+JGmMgqy+PMp6Cmh8geaygjgzp1FYMgCV7tuofJd6I4reF0Qz0IL3n0lqIzAVRCvIHQeVEagt4BWqLwLM0qg8k6MlkDlnXh8AWPs2wudfCE+JW5sAwAAAABJRU5ErkJggg==",
			2, 16, 16);
			
		//#endregion
		
		//#region TRENCH
		spr_path_set("areas/Trench/");
		
			 // Decals:
			BigTopDecal[?     "trench"] = spr_add("sprBigTopDecalTrench", 1, 32, 52);
			msk.BigTopDecal[? "trench"] = spr_add("../mskBigTopDecal",    1, 32, 16);
			
			 // Floors:
			FloorTrench      = spr_add("sprFloorTrench",      4, 0, 0);
			FloorTrenchB     = spr_add("sprFloorTrenchB",     4, 2, 2);
			FloorTrenchExplo = spr_add("sprFloorTrenchExplo", 5, 1, 1);
			FloorTrenchBreak = spr_add("sprFloorTrenchBreak", 3, 8, 8);
			DetailTrench     = spr_add("sprDetailTrench",     6, 4, 4);
			
			 // Walls:
			WallTrenchBot   = spr_add("sprWallTrenchBot",   4,  0,  0);
			WallTrenchTop   = spr_add("sprWallTrenchTop",   8,  0,  0);
			WallTrenchOut   = spr_add("sprWallTrenchOut",   1,  4, 12);
			WallTrenchTrans = spr_add("sprWallTrenchTrans", 8,  0,  0);
			DebrisTrench    = spr_add("sprDebrisTrench",    4,  4,  4);
			
			 // Decals:
			TopDecalTrench     = spr_add("sprTopDecalTrench",      2, 19, 24);
			TopDecalTrenchMine = spr_add("sprTopDecalTrenchMine",  1, 16, 24);
			TrenchMineDead     = spr_add("sprTrenchMineDead",     12, 12, 36);
			
			 // Proto Statue:
			PStatTrenchIdle   = spr_add("sprPStatTrenchIdle",    1, 40, 40);
			PStatTrenchHurt   = spr_add("sprPStatTrenchHurt",    3, 40, 40);
			PStatTrenchLights = spr_add("sprPStatTrenchLights", 40, 40, 40);
			
			//#region PITS
			spr_path_add("Pit/");
			
				 // Normal:
				Pit    = spr_add("sprPit",    1, 2, 2);
				PitTop = spr_add("sprPitTop", 1, 2, 2);
				PitBot = spr_add("sprPitBot", 1, 2, 2);
				
				 // Small:
				PitSmall    = spr_add("sprPitSmall",    1, 3, 3);
				PitSmallTop = spr_add("sprPitSmallTop", 1, 3, 3);
				PitSmallBot = spr_add("sprPitSmallBot", 1, 3, 3);
				
			spr_path_add("../");
			//#endregion
			
			//#region PROPS
			spr_path_add("Props/");
				
				 // Eel Skeleton (big fat eel edition):
				EelSkullIdle = spr_add("sprEelSkeleton",     1, 24, 24);
				EelSkullHurt = spr_add("sprEelSkeletonHurt", 3, 24, 24);
				EelSkullDead = spr_add("sprEelSkeletonDead", 3, 24, 24);
				
				 // Kelp:
				KelpIdle = spr_add("sprKelp",     6, 16, 22);
				KelpHurt = spr_add("sprKelpHurt", 3, 16, 22);
				KelpDead = spr_add("sprKelpDead", 8, 16, 22);
				
				 // Vent:
				VentIdle = spr_add("sprVent",     1, 12, 14);
				VentHurt = spr_add("sprVentHurt", 3, 12, 14);
				VentDead = spr_add("sprVentDead", 3, 12, 14);
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region SEWERS
		spr_path_set("areas/Sewers/");
		
			 // Decals:
			BigTopDecal[? area_sewers] = spr_add("sprBigTopDecalSewers", 8, 32, 56);
			
			 // Fix Decal Not Fully Covering Wall:
			sprite_replace(sprSewerDecal, spr_path + "sprWallDecalSewer.png", 1, 16, 24);
			
			 // Floors:
			FloorSewerDirt      = spr_add("sprFloorSewerDirt",      4, 16, 16);
			FloorSewerLightDirt = spr_add("sprFloorSewerLightDirt", 4, 16, 16);
			FloorSewerDrain     = spr_add("sprFloorSewerDrain",     1,  0,  0);
			FloorSewerGrate     = spr_add("sprFloorSewerGrate",     8,  2,  2);
			FloorSewerWeb       = spr_add("sprFloorSewerWeb",       1,  0,  0);
			
			 // Manhole:
			PizzaManhole = [
				spr_add("sprPizzaManhole0", 2, 16, 16),
				spr_add("sprPizzaManhole1", 2, 16, 16),
				spr_add("sprPizzaManhole2", 2, 16, 16)
			];
			
			 // Sewer Pool:
			SewerPool        = spr_add("sprSewerPool",     8,  0,  0);
			msk.SewerPool    = spr_add("mskSewerPool",     1, 32, 64);
			SewerPoolBig     = spr_add("sprSewerPoolBig", 25,  0,  0);
			msk.SewerPoolBig = spr_add("mskSewerPoolBig",  1, 80, 80);
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Big Pipe:
				BigPipeBottom     = spr_add("sprBigPipeBottom", 1, 24, 32);
				BigPipeBottomHurt = spr_add("sprBigPipeBottom", 1, 24, 32, shnHurt);
				BigPipeTop        = spr_add("sprBigPipeTop",    1, 24, 32);
				BigPipeTopHurt    = spr_add("sprBigPipeTop",    1, 24, 32, shnHurt);
				BigPipeDead       = spr_add("sprBigPipeDead",   3, 24, 32);
				BigPipeHole       = spr_add("sprBigPipeHole",   1, 24, 32);
				msk.BigPipe       = spr_add("sprBigPipeTop",    1, 24, 24);
				with([BigPipeHole, msk.BigPipe]){
					mask = [false, 0];
				}
				
				 // Sewer Drain:
				SewerDrainIdle = spr_add("sprSewerDrain",     8, 32, 38);
				SewerDrainHurt = spr_add("sprSewerDrainHurt", 3, 32, 38);
				SewerDrainDead = spr_add("sprSewerDrainDead", 5, 32, 38);
				msk.SewerDrain = spr_add("mskSewerDrain",     1, 32, 38);
				
				 // Homage:
				GatorStatueIdle = spr_add("sprGatorStatue",     1, 16, 16);
				GatorStatueHurt = spr_add("sprGatorStatue",     1, 16, 16, shnHurt);
				GatorStatueDead = spr_add("sprGatorStatueDead", 4, 16, 16);
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region PIZZA SEWERS
		spr_path_set("areas/Pizza/");
		
			 // Decals:
			BigTopDecal[? area_pizza_sewers] = spr_add("sprBigTopDecalPizza", 1, 32, 56);
			BigTopDecal[? "pizza"] = BigTopDecal[? area_pizza_sewers];
			
			 // Fix Decal Not Fully Covering Wall:
			sprite_replace(sprPizzaSewerDecal, spr_path + "sprWallDecalPizza.png", 1, 16, 24);
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Door:
				PizzaDoor       = spr_add("sprPizzaDoor",       10, 2, 0);
				PizzaDoorDebris = spr_add("sprPizzaDoorDebris",  4, 4, 4);
				
				 // Drain:
				PizzaDrainIdle = spr_add("sprPizzaDrain",     8, 32, 38);
				PizzaDrainHurt = spr_add("sprPizzaDrainHurt", 3, 32, 38);
				PizzaDrainDead = spr_add("sprPizzaDrainDead", 5, 32, 38);
				
				 // Rubble:
				PizzaRubbleIdle = spr_add("sprPizzaRubble",     1, 16, 0);
				PizzaRubbleHurt = spr_add("sprPizzaRubbleHurt", 3, 16, 0);
				msk.PizzaRubble = spr_add("mskPizzaRubble",     1, 16, 0);
				
				 // TV:
				TVHurt = spr_add("sprTVHurt", 3, 24, 16);
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region LAIR
		spr_path_set("areas/Lair/");
		
			 // Floors:
			FloorLair      = spr_add("sprFloorLair",      4, 0, 0);
			FloorLairB     = spr_add("sprFloorLairB",     8, 0, 0);
			FloorLairExplo = spr_add("sprFloorLairExplo", 4, 1, 1);
			DetailLair     = spr_add("sprDetailLair",     6, 4, 4);
			
			 // Walls:
			WallLairBot   = spr_add("sprWallLairBot",   4,  0,  0);
			WallLairTop   = spr_add("sprWallLairTop",   4,  0,  0);
			WallLairOut   = spr_add("sprWallLairOut",   5,  4, 12);
			WallLairTrans = spr_add("sprWallLairTrans", 1,  0,  0);
			DebrisLair    = spr_add("sprDebrisLair",    4,  4,  4);
			
			 // Decals:
			TopDecalLair  = spr_add("sprTopDecalLair",  2, 16, 16);
			WallDecalLair = spr_add("sprWallDecalLair", 1, 16, 24);
			
			 // Manholes:
			Manhole               = spr_add("sprManhole",               12, 16, 48);
			ManholeOpen           = spr_add("sprManholeOpen",            1, 16, 16);
			BigManhole            = spr_add("sprBigManhole",             6, 32, 32);
			BigManholeOpen        = spr_add("sprBigManholeOpen",         1, 32, 32);
			BigManholeFloor       = spr_add("sprBigManholeFloor",        4,  0,  0);
			BigManholeDebris      = spr_add("sprBigManholeDebris",       4,  4,  4);
			BigManholeDebrisChunk = spr_add("sprBigManholeDebrisChunk",  3, 12, 12);
			with([ManholeOpen, BigManholeOpen]){
				mask = [false, 0];
			}
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Cabinet:
				CabinetIdle = spr_add("sprCabinet",     1, 12, 12);
				CabinetHurt = spr_add("sprCabinet",     1, 12, 12, shnHurt);
				CabinetDead = spr_add("sprCabinetDead", 3, 12, 12);
				Paper       = spr_add("sprPaper",       3,  5,  6);
				
				/// Chairs:
					
					 // Side:
					ChairSideIdle  = spr_add("sprChairSide",     1, 12, 12);
					ChairSideHurt  = spr_add("sprChairSide",     1, 12, 12, shnHurt);
					ChairSideDead  = spr_add("sprChairSideDead", 3, 12, 12);
					
					 // Front:
					ChairFrontIdle = spr_add("sprChairFront",     1, 12, 12);
					ChairFrontHurt = spr_add("sprChairFront",     1, 12, 12, shnHurt);
					ChairFrontDead = spr_add("sprChairFrontDead", 3, 12, 12);
					
				 // Couch:
				CouchIdle = spr_add("sprCouch",     1, 32, 32);
				CouchHurt = spr_add("sprCouch",     1, 32, 32, shnHurt);
				CouchDead = spr_add("sprCouchDead", 3, 32, 32);
				
				 // Door:
				CatDoor       = spr_add("sprCatDoor",       10, 2, 0);
				CatDoorDebris = spr_add("sprCatDoorDebris",  4, 4, 4);
				msk.CatDoor   = spr_add("mskCatDoor",        1, 4, 0);
				
				 // Rug:
				Rug = spr_add("sprRug", 2, 26, 26);
				
				 // Soda Machine:
				SodaMachineIdle = spr_add("sprSodaMachine",     1, 16, 16);
				SodaMachineHurt = spr_add("sprSodaMachine",     1, 16, 16, shnHurt);
				SodaMachineDead = spr_add("sprSodaMachineDead", 3, 16, 16);
				
				 // Table:
				TableIdle = spr_add("sprTable",     1, 16, 16);
				TableHurt = spr_add("sprTable",     1, 16, 16, shnHurt);
				TableDead = spr_add("sprTableDead", 3, 16, 16);
				
			spr_path_add("../");
			//#endregion
			
			 // Ceiling Lights:
			spr_path_add("Lights/");
			CatLight     = spr_add("sprCatLight",     1,  96, 16);
			CatLightBig  = spr_add("sprCatLightBig",  1, 128, 16);
			CatLightThin = spr_add("sprCatLightThin", 1,  72, 16);
			spr_path_add("../");
			
		//#endregion
		
		//#region RED
		spr_path_set("areas/Crystal/");
		
			 // Floors:
			FloorRed      = spr_add("sprFloorCrystal",      1, 2, 2);
			FloorRedB     = spr_add("sprFloorCrystalB",     1, 2, 2);
			FloorRedExplo = spr_add("sprFloorCrystalExplo", 4, 1, 1);
			FloorRedRoom  = spr_add("sprFloorCrystalRoom",  4, 2, 2);
			DetailRed     = spr_add("sprDetailCrystal",     5, 4, 4);
			
			 // Walls:
			WallRedBot   = spr_add("sprWallCrystalBot",    2, 0,  0);
			WallRedTop   = spr_add("sprWallCrystalTop",    4, 0,  0);
			WallRedOut   = spr_add("sprWallCrystalOut",    1, 4, 12);
			WallRedTrans = spr_add("sprWallCrystalTrans",  4, 1,  1);
			WallRedFake  =[spr_add("sprWallCrystalFake1", 16, 0,  0),
			               spr_add("sprWallCrystalFake2", 16, 0,  0)];
			DebrisRed    = spr_add("sprDebrisCrystal",     4, 4,  4);
			with(WallRedTrans){
				mask = [false, 2, x, y, x + 15, y + 15, 1];
			}
			
			 // Fake Walls:
			WallFakeBot = spr_add("sprWallFakeBot", 16, 0, 0);
			WallFakeTop = spr_add("sprWallFakeTop",  1, 0, 8);
			WallFakeOut = spr_add("sprWallFakeOut",  1, 1, 9);
			
			 // Decals:
			WallDecalRed = spr_add("sprWallDecalCrystal", 1, 16, 24);
			
			 // Warp:
			Warp        = spr_add("sprWarp",        2, 16, 16);
			WarpOpen    = spr_add("sprWarpOpen",    2, 32, 32);
			WarpOpenOut = spr_add("sprWarpOpenOut", 4, 32, 32);
			
			 // Misc:
			RedDot          = spr_add("sprRedDot",           9,   7,   7);
			RedText         = spr_add("sprRedText",         12,  12,   4);
			Starfield       = spr_add("sprStarfield",        2, 256, 256);
			SpiralStarfield = spr_add("sprSpiralStarfield",  2,  32,  32);
			
			//#region PROPS
			spr_path_add("Props/");
			
				 // Red Crystals:
				CrystalPropRedIdle = spr_add("sprCrystalPropRed",     1, 12, 12);
				CrystalPropRedHurt = spr_add("sprCrystalPropRed",     1, 12, 12, shnHurt);
				CrystalPropRedDead = spr_add("sprCrystalPropRedDead", 4, 12, 12);
				
				 // White Crystals:
				CrystalPropWhiteIdle = spr_add("sprCrystalPropWhite",     1, 12, 12);
				CrystalPropWhiteHurt = spr_add("sprCrystalPropWhiteHurt", 3, 12, 12);
				CrystalPropWhiteDead = spr_add("sprCrystalPropWhiteDead", 4, 12, 12);
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region IDPD HQ
		spr_path_set("areas/HQ/");
		
			 // Floors:
			Floor106Small        = spr_add("sprFloor106Small",    4,  0,  0);
			FloorMiddleSmall     = spr_add("sprFloorMiddleSmall", 1, 32, 32);
			msk.FloorMiddleSmall = spr_add("mskFloorMiddleSmall", 1, 32, 32);
			with(msk.FloorMiddleSmall){
				mask = [false, 0];
			}
			
		//#endregion
		
		//#region CRIB
		spr_path_set("areas/Crib/");
		
			 // TV Shadow:
			shd.VenuzTV = spr_add("shdVenuzTV", 1, 129, 96);
			
		//#endregion
		
		//#region CHESTS/PICKUPS
		spr_path_set("chests/");
		
			 // Ally Backpack:
			AllyBackpack     = spr_add("sprAllyBackpack",     1, 8, 8, shn16);
			AllyBackpackOpen = spr_add("sprAllyBackpackOpen", 1, 8, 8);
			
			 // Backpack:
			Backpack           = spr_add("sprBackpack",            1, 8, 8, shn16);
			BackpackCursed     = spr_add("sprBackpackCursed",      1, 8, 8, shn16);
			BackpackOpen       = spr_add("sprBackpackOpen",        1, 8, 8);
			BackpackCursedOpen = spr_add("sprBackpackCursedOpen",  1, 8, 8);
			BackpackDebris     = spr_add("sprBackpackDebris",     30, 6, 6);
			
			 // Backpacker (Deceased):
			BackpackerIdle = [spr_add("sprBackpacker0", 1, 12, 12),
			                  spr_add("sprBackpacker1", 1, 12, 12),
			                  spr_add("sprBackpacker2", 1, 12, 12)];
			BackpackerHurt = [spr_add("sprBackpacker0", 1, 12, 12, shnHurt),
			                  spr_add("sprBackpacker1", 1, 12, 12, shnHurt),
			                  spr_add("sprBackpacker2", 1, 12, 12, shnHurt)];
			
			 // Bat Chests:
			BatChest              = spr_add("sprBatChest",              1, 10, 10, shn20);
			BatChestCursed        = spr_add("sprBatChestCursed",        1, 10, 10, shn20);
			BatChestBig           = spr_add("sprBatChestBig",           1, 12, 12, shn24);
			BatChestBigCursed     = spr_add("sprBatChestBigCursed",     1, 12, 12, shn24);
			BatChestOpen          = spr_add("sprBatChestOpen",          1, 10, 10);
			BatChestCursedOpen    = spr_add("sprBatChestCursedOpen",    1, 10, 10);
			BatChestBigOpen       = spr_add("sprBatChestBigOpen",       1, 12, 12);
			BatChestBigCursedOpen = spr_add("sprBatChestBigCursedOpen", 1, 12, 12);
			
			 // Bone:
			BonePickup    = [];
			BonePickupBig = [];
			for(var i = 0; i < 4; i++){
				array_push(BonePickup, spr_add(`sprBonePickup${i}`, 1, 4, 4, shn8));
			}
			for(var i = 0; i < 2; i++){
				array_push(BonePickupBig, spr_add(`sprBoneBigPickup${i}`, 1, 8, 8, shn16));
			}
			
			 // Bonus Pickups:
			BonusFX                    = spr_add("sprBonusFX",                    13,  4, 12);
			BonusFXPickupOpen          = spr_add("sprBonusFXPickupOpen",           6,  8,  8);
			BonusFXPickupFade          = spr_add("sprBonusFXPickupFade",           5,  8,  8);
			BonusFXChestOpen           = spr_add("sprBonusFXChestOpen",            8, 16, 16);
			BonusHealFX                = spr_add("sprBonusHealFX",                 7,  8, 10);
			BonusHealBigFX             = spr_add("sprBonusHealBigFX",              8, 12, 24);
			BonusShell                 = spr_add("sprBonusShell",                  1,  1,  2);
			BonusShellHeavy            = spr_add("sprBonusShellHeavy",             1,  2,  3);
			BonusText                  = spr_add("sprBonusText",                  12,  0,  0);
			BonusHUDText               = spr_add("sprBonusHUDText",                1,  7,  3);
			BonusAmmoHUD               = spr_add("sprBonusAmmoHUD",                1,  2,  3);
			BonusAmmoHUDFill           = spr_add("sprBonusAmmoHUDFill",            7,  0,  0);
			BonusAmmoHUDFillDrain      = spr_add("sprBonusAmmoHUDFillDrain",       7,  0,  0);
			BonusHealthHUDFill         = spr_add("sprBonusHealthHUDFill",          7,  0,  0);
			BonusHealthHUDFillDrain    = spr_add("sprBonusHealthHUDFillDrain",     7,  0,  0);
			BonusAmmoPickup            = spr_add("sprBonusAmmoPickup",             1,  5,  5, shn10);
			BonusHealthPickup          = spr_add("sprBonusHealthPickup",           1,  5,  5, shn10);
			BonusAmmoChest             = spr_add("sprBonusAmmoChest",             15,  8,  8);
			BonusAmmoChestOpen         = spr_add("sprBonusAmmoChestOpen",          1,  8,  8);
			BonusAmmoChestSteroids     = spr_add("sprBonusAmmoChestSteroids",     15, 12, 12);
			BonusAmmoChestSteroidsOpen = spr_add("sprBonusAmmoChestSteroidsOpen",  1, 12, 12);
			BonusHealthChest           = spr_add("sprBonusHealthChest",           15,  8,  8);
			BonusHealthChestOpen       = spr_add("sprBonusHealthChestOpen",        1,  8,  8);
			BonusAmmoMimicIdle         = spr_add("sprBonusAmmoMimicIdle",          1, 16, 16);
			BonusAmmoMimicTell         = spr_add("sprBonusAmmoMimicTell",         12, 16, 16);
			BonusAmmoMimicHurt         = spr_add("sprBonusAmmoMimicHurt",          3, 16, 16);
			BonusAmmoMimicDead         = spr_add("sprBonusAmmoMimicDead",          6, 16, 16);
			BonusAmmoMimicFire         = spr_add("sprBonusAmmoMimicFire",          4, 16, 16);
			BonusHealthMimicIdle       = spr_add("sprBonusHealthMimicIdle",        1, 16, 16);
			BonusHealthMimicTell       = spr_add("sprBonusHealthMimicTell",       10, 16, 16);
			BonusHealthMimicHurt       = spr_add("sprBonusHealthMimicHurt",        3, 16, 16);
			BonusHealthMimicDead       = spr_add("sprBonusHealthMimicDead",        6, 16, 16);
			BonusHealthMimicFire       = spr_add("sprBonusHealthMimicFire",        4, 16, 16);
			
			 // Buried Vault:
			BuriedVaultChest       = spr_add("sprVaultChest",       1, 12, 12, shn24);
			BuriedVaultChestOpen   = spr_add("sprVaultChestOpen",   1, 12, 12);
			BuriedVaultChestDebris = spr_add("sprVaultChestDebris", 8, 12, 12);
			BuriedVaultChestBase   = spr_add("sprVaultChestBase",   3, 16, 12);
			ProtoChestMerge        = spr_add("sprProtoChestMerge",  6, 12, 12);
			
			 // Button Chests:
			ButtonChest        = spr_add("sprButtonChest",        1, 9, 9, shn20);
			ButtonChestDebris  = spr_add("sprButtonChestDebris",  2, 9, 9);
			ButtonPickup       = spr_add("sprButtonPickup",       1, 6, 6, shn12);
			ButtonPickupDebris = spr_add("sprButtonPickupDebris", 2, 6, 6);
			
			 // Cat Chest:
			CatChest     = spr_add("sprCatChest",     1, 10, 10, shn20);
			CatChestOpen = spr_add("sprCatChestOpen", 1, 10, 10);
			
			 // Cat Crates:
			WallCrateBot = spr_add("sprWallCrateBot", 2,  2,  2);
			WallCrateTop = spr_add("sprWallCrateTop", 4,  4,  4);
			WallCrateOut = spr_add("sprWallCrateTop", 4,  4, 12);
			FloorCrate   = spr_add("sprFloorCrate",   1, 18, 18);
			
			 // Cursed Ammo Chests:
			CursedAmmoChest             = spr_add("sprCursedAmmoChest",              1,  8,  8, shn16);
			CursedAmmoChestOpen         = spr_add("sprCursedAmmoChestOpen",          1,  8,  8);
			CursedAmmoChestSteroids     = spr_add("sprCursedAmmoChestSteroids",      1, 12, 12, shn20);
			CursedAmmoChestSteroidsOpen = spr_add("sprCursedAmmoChestSteroidsOpen",  1, 12, 12);
			CursedMimicIdle             = spr_add("sprCursedMimicIdle",              1, 16, 16);
			CursedMimicFire             = spr_add("sprCursedMimicFire",              4, 16, 16);
			CursedMimicHurt             = spr_add("sprCursedMimicHurt",              3, 16, 16);
			CursedMimicDead             = spr_add("sprCursedMimicDead",              6, 16, 16);
			CursedMimicTell             = spr_add("sprCursedMimicTell",             12, 16, 16);
			
			 // Orchid Chest:
			OrchidChest       = spr_add("sprOrchidChest",       1, 12, 8, shn24);
			OrchidChestWilted = spr_add("sprOrchidChestWilted", 1, 12, 8, shn24);
			OrchidChestOpen   = spr_add("sprOrchidChestOpen",   1, 12, 8);
			
			 // Rat Chest:
			RatChest      = spr_add("sprRatChest",      1, 10, 10, shn20);
			RatChestOpen  = spr_add("sprRatChestOpen",  1, 10, 10);
			RadSkillBall  = spr_add("sprRadSkillBall",  6, 16, 16);
			RadSkillTrail = spr_add("sprRadSkillTrail", 8, 16, 16);
			
			 // Red Ammo:
			RedAmmoChest       = spr_add("sprRedAmmoChest",       1, 8, 8, shn16);
			RedAmmoChestOpen   = spr_add("sprRedAmmoChestOpen",   1, 8, 8);
			RedAmmoPickup      = spr_add("sprRedAmmoPickup",      1, 5, 5, shn10);
			RedAmmoHUD         = spr_add("sprRedAmmoHUD",         2, 1, 1);
			RedAmmoHUDAmmo     = spr_add("sprRedAmmoHUDAmmo",     2, 1, 2);
			RedAmmoHUDFill     = spr_add("sprRedAmmoHUDFill",     2, 0, 0);
			RedAmmoHUDCost     = spr_add("sprRedAmmoHUDCost",     2, 2, 2);
			RedAmmoHUDGold     = spr_add("sprRedAmmoHUDGold",     2, 1, 1);
			RedAmmoHUDCostGold = spr_add("sprRedAmmoHUDCostGold", 2, 2, 2);
			
			 // Red Crystal Chest:
			RedChest           = spr_add("sprRedChest",           1,  8,  8, shn16);
			RedChestOpen       = spr_add("sprRedChestOpen",       1,  8,  8);
			RedSkillBall       = spr_add("sprRedSkillBall",       6, 16, 16);
			RedSkillBallTether = spr_add("sprRedSkillBallTether", 4,  0,  1);
			
			 // Rogue Backpack:
			RogueBackpack     = spr_add("sprRogueBackpack",     1, 8, 8, shn16);
			RogueBackpackOpen = spr_add("sprRogueBackpackOpen", 1, 8, 8);
			
			 // Spirit Pickup:
			SpiritPickup    = spr_add("sprSpiritPickup",    1, 5, 5, shn10);
			SpiritChest     = spr_add("sprSpiritChest",     1, 8, 8, shn16);
			SpiritChestOpen = spr_add("sprSpiritChestOpen", 1, 8, 8);
			
			 // Sunken Chest:
			SunkenChest     = spr_add("sprSunkenChest",     1, 12, 12, shn24);
			SunkenChestOpen = spr_add("sprSunkenChestOpen", 1, 12, 12);
			SunkenCoin      = spr_add("sprCoin",            1,  3,  3, shn8);
			SunkenCoinBig   = spr_add("sprCoinBig",         1,  3,  3, shn8);
			
			 // Hammerhead Pickup:
			HammerHeadPickup            = spr_add("sprHammerHeadPickup",            1,  5,  5, shn10);
			HammerHeadPickupEffect      = spr_add("sprHammerHeadPickupEffect",      3, 16,  8);
			HammerHeadPickupEffectSpawn = spr_add("sprHammerHeadPickupEffectSpawn", 9, 16,  8);
			HammerHeadChest             = spr_add("sprHammerHeadChest",             1,  8,  8, shn16);
			HammerHeadChestOpen         = spr_add("sprHammerHeadChestOpen",         1,  8,  8);
			HammerHeadChestEffect       = spr_add("sprHammerHeadChestEffect",       3, 16,  8);
			HammerHeadChestEffectSpawn  = spr_add("sprHammerHeadChestEffectSpawn",  9, 16,  8);
			
			 // Huge Weapon Chest:
			HugeWeaponChest     = spr_add("sprHugeWeaponChest",     1, 32, 32, shn64);
			HugeWeaponChestOpen = spr_add("sprHugeWeaponChestOpen", 1, 32, 32);
			HugeCursedChest     = spr_add("sprHugeCursedChest",     1, 32, 32, shn64);
			HugeCursedChestOpen = spr_add("sprHugeCursedChestOpen", 1, 32, 32);
			
			 // Lead Ribs Upgraded Rads:
			RadUpg    = spr_add("sprRadUpg",    1, 5, 5, shn10);
			BigRadUpg = spr_add("sprBigRadUpg", 1, 8, 8, shn16);
			
			 // Quest Chest:
			QuestChest		   = spr_add("sprQuestChest",         1, 12, 12, shn24);
			QuestChestOpen     = spr_add("sprQuestChestOpen",     1, 12, 12);
			HugeQuestChest	   = spr_add("sprHugeQuestChest",     1, 32, 32, shn64);
			HugeQuestChestOpen = spr_add("sprHugeQuestChestOpen", 1, 32, 32);
			QuestSparkle	   = spr_add("sprQuestSparkle",       4,  6,  6);
			ProtoChestFire     = spr_add("sprProtoChestFire",     8, 12, 12);
			
		//#endregion
		
		//#region RACES
		spr_path_set("races/");
		
			var _list = {
				// [Name, Frames, X, Y, Has B Variant]
				
				"parrot" : {
					skin : 2,
					sprt : [
						["Loadout",       2, 16],
						["Map",           1, 10],
						["Portrait",      1, 20, 221],
						["Select",        2,  0,   0, false],
						["UltraIcon",     2, 12,  16, false],
						["UltraHUDA",     1,  8,   9, false],
						["UltraHUDB",     1,  8,   9, false],
						["Idle",          4],
						["Walk",          6],
						["Hurt",          3],
						["Dead",          6],
						["GoSit",         3],
						["Sit",           1],
						["Menu",         40, 12,  12, false],
						["MenuSelect",    3, 12,  12, false],
						["MenuSelected", 30, 16,  16, false],
						["MenuDeselect",  4, 12,  12, false],
						["Feather",       1,  3,   4],
						["FeatherHUD",    8,  5]
					]
				},
				
				"beetle" : {
					skin : 2,
					sprt : [
						["Loadout",         2, 16],
						["Map",             1, 10],
						["Portrait",        1, 90, 243],
						["Select",          2,  0,   0, false],
						["UltraIcon",       2, 12,  16, false],
						["UltraHUDA",       1,  8,   9, false],
						["UltraHUDB",       1,  8,   9, false],
						["Idle",            4],
						["Walk",            8],
						["Hurt",            3],
						["Dead",           10],
						["GoSit",           3],
						["Sit",             1],
						["Menu",           48, 12,  12, false],
						["MenuSelect",     18, 12,  12, false],
						["MenuSelected",   26, 12,  12, false],
						["MenuDeselect",   18, 12,  12, false],
						["ThroneButtIcon",  1,  5,   5, false]
					]
				}/*,
				
				"???" : {
					skin : 2,
					sprt : [
						["Loadout",   2, 16],
						["Map",       1, 10],
						["Portrait",  1, 40, 243],
						["Select",    2,  0,   0, false],
						["UltraIcon", 2, 12,  16, false],
						["UltraHUDA", 1,  8,   9, false],
						["UltraHUDB", 1,  8,   9, false],
						["Idle",      8],
						["Walk",      6],
						["Hurt",      3],
						["Dead",      6],
						["GoSit",     3],
						["Sit",       1]
					]
				}*/
			};
			
			Race = {};
			
			for(var _raceIndex = 0; _raceIndex < lq_size(_list); _raceIndex++){
				var	_race               = lq_get_key(_list, _raceIndex),
					_raceInfo           = lq_get_value(_list, _raceIndex),
					_raceName           = string_upper(string_char_at(_race, 0)) + string_delete(_race, 1, 1),
					_raceSkinSprMapList = [];
					
				spr_path_add(_raceName + "/");
				
				for(var _skinIndex = 0; _skinIndex < _raceInfo.skin; _skinIndex++){
					var	_skinName   = ((_skinIndex == 0) ? "" : chr(ord("A") + _skinIndex)),
						_skinSprMap = {};
						
					with(_raceInfo.sprt){
						var	_name = self[0],
							_img  = self[1],
							_x    = ((array_length(self) > 2) ? self[2] : 12),
							_y    = ((array_length(self) > 3) ? self[3] : _x),
							_hasB = ((array_length(self) > 4) ? self[4] : true);
							
						lq_set(_skinSprMap, _name, spr_add("spr" + _raceName + (_hasB ? _skinName : "") + _name, _img, _x, _y));
					}
					
					array_push(_raceSkinSprMapList, _skinSprMap);
				}
				
				spr_path_add("../");
				
				lq_set(Race, _race, _raceSkinSprMapList);
			}
			
			 // Parrot:
			spr_path_add("Parrot/");
			shd.ParrotMenu      = spr_add("shdParrotMenu",          1, 16, 16);
			AllyReviveArea      = spr_add("sprAllyReviveArea",      4, 35, 45);
			AllyNecroReviveArea = spr_add("sprAllyNecroReviveArea", 4, 17, 20);
			spr_path_add("../");
			
		//#endregion
		
		//#region SKINS
		spr_path_set("skins/");
		
			 // Frog Icon ENHANCED:
			sprite_replace_image(sprLoadoutSkin, spr_path + "sprFrogLoadout.png", 28);
			
			//#region ANGLER FISH
			spr_path_add("FishAngler/");
			
				 // Player:
				FishAnglerIdle  = spr_add("sprFishAnglerIdle",  4, 12, 12);
				FishAnglerWalk  = spr_add("sprFishAnglerWalk",  6, 12, 12);
				FishAnglerHurt  = spr_add("sprFishAnglerHurt",  3, 12, 12);
				FishAnglerDead  = spr_add("sprFishAnglerDead",  6, 12, 12);
				FishAnglerGoSit = spr_add("sprFishAnglerGoSit", 3, 12, 12);
				FishAnglerSit   = spr_add("sprFishAnglerSit",   1, 12, 12);
				
				 // Menu:
				FishAnglerPortrait = spr_add("sprFishAnglerPortrait", 1, 40, 243);
				FishAnglerLoadout  = spr_add("sprFishAnglerLoadout",  2, 16,  16);
				FishAnglerMapIcon  = spr_add("sprFishAnglerMapIcon",  1, 10,  10);
				
				 // Eye Trail:
				FishAnglerTrail = spr_add("sprFishAnglerTrail", 6, 12, 12);
				
			spr_path_add("../");
			//#endregion
			
			//#region BAT EYES
			spr_path_add("EyesBat/");
			
				 // Player:
				EyesBatIdle  = spr_add("sprEyesBatIdle",  4, 12, 12);
				EyesBatWalk  = spr_add("sprEyesBatWalk",  6, 12, 16);
				EyesBatHurt  = spr_add("sprEyesBatHurt",  3, 12, 12);
				EyesBatDead  = spr_add("sprEyesBatDead",  6, 12, 12);
				EyesBatGoSit = spr_add("sprEyesBatGoSit", 3, 12, 12);
				EyesBatSit   = spr_add("sprEyesBatSit",   1, 12, 12);
				
				 // Menu:
				EyesBatPortrait = spr_add("sprEyesBatPortrait", 1, 40, 243);
				EyesBatLoadout  = spr_add("sprEyesBatLoadout",  2, 16,  16);
				EyesBatMapIcon  = spr_add("sprEyesBatMapIcon",  1, 10,  10);
				
			spr_path_add("../");
			//#endregion
			
			//#region BONUS ROBOT
			spr_path_add("RobotBonus/");
			
				 // Player:
				RobotBonusIdle  = spr_add("sprRobotBonusIdle",  15, 12, 12);
				RobotBonusWalk  = spr_add("sprRobotBonusWalk",   6, 12, 12);
				RobotBonusHurt  = spr_add("sprRobotBonusHurt",   3, 12, 12);
				RobotBonusDead  = spr_add("sprRobotBonusDead",   6, 12, 12);
				RobotBonusGoSit = spr_add("sprRobotBonusGoSit",  3, 12, 12);
				RobotBonusSit   = spr_add("sprRobotBonusSit",    1, 12, 12);
				
				 // Menu:
				RobotBonusPortrait = spr_add("sprRobotBonusPortrait", 1, 40, 243);
				RobotBonusLoadout  = spr_add("sprRobotBonusLoadout",  2, 16,  16);
				RobotBonusMapIcon  = spr_add("sprRobotBonusMapIcon",  1, 10,  10);
				
			spr_path_add("../");
			//#endregion
			
			//#region COAT Y.V.
			spr_path_add("YVCoat/");
			
				 // Coat:
				YVCoat = spr_add("sprYVCoat", 1, 12, 12);
				
				 // Player:
				YVCoatIdle  = spr_add("sprYVCoatIdle",  14, 12, 12);
				YVCoatWalk  = spr_add("sprYVCoatWalk",   6, 12, 12);
				YVCoatHurt  = spr_add("sprYVCoatHurt",   3, 12, 12);
				YVCoatDead  = spr_add("sprYVCoatDead",  19, 24, 24);
				YVCoatGoSit = spr_add("sprYVCoatGoSit",  3, 12, 12);
				YVCoatSit   = spr_add("sprYVCoatSit",    1, 12, 12);
				
				 // Menu:
				YVCoatPortrait = spr_add("sprYVCoatPortrait", 1, 40, 243);
				YVCoatLoadout  = spr_add("sprYVCoatLoadout",  2, 16,  16);
				YVCoatMapIcon  = spr_add("sprYVCoatMapIcon",  1, 10,  10);
				
			spr_path_add("../");
			//#endregion
			
			//#region COOL FROG
			spr_path_add("FrogCool/");
			
				 // Player:
				FrogCoolIdle  = spr_add("sprFrogCoolIdle",  6, 12, 12);
				FrogCoolWalk  = spr_add("sprFrogCoolWalk",  6, 12, 12);
				FrogCoolHurt  = spr_add("sprFrogCoolHurt",  3, 12, 12);
				FrogCoolDead  = spr_add("sprFrogCoolDead",  6, 24, 24);
				FrogCoolGoSit = spr_add("sprFrogCoolGoSit", 3, 12, 12);
				FrogCoolSit   = spr_add("sprFrogCoolSit",   6, 12, 12);
				
				 // Menu:
				FrogCoolPortrait = spr_add("sprFrogCoolPortrait", 1, 40, 243);
				FrogCoolLoadout  = spr_add("sprFrogCoolLoadout",  2, 16,  16);
				FrogCoolMapIcon  = spr_add("sprFrogCoolMapIcon",  1, 10,  10);
				
			spr_path_add("../");
			//#endregion
			
			//#region ORCHID PLANT
			spr_path_add("PlantOrchid/");
			
				 // Player:
				PlantOrchidIdle  = spr_add("sprPlantOrchidIdle",  4, 16, 16);
				PlantOrchidWalk  = spr_add("sprPlantOrchidWalk",  4, 16, 16);
				PlantOrchidHurt  = spr_add("sprPlantOrchidHurt",  3, 16, 16);
				PlantOrchidDead  = spr_add("sprPlantOrchidDead",  9, 16, 16);
				PlantOrchidGoSit = spr_add("sprPlantOrchidGoSit", 3, 16, 16);
				PlantOrchidSit   = spr_add("sprPlantOrchidSit",   1, 16, 16);
				
				 // Menu:
				PlantOrchidPortrait = spr_add("sprPlantOrchidPortrait", 1, 40, 243);
				PlantOrchidLoadout  = spr_add("sprPlantOrchidLoadout",  2, 16,  16);
				PlantOrchidMapIcon  = spr_add("sprPlantOrchidMapIcon",  1, 10,  10);
				
				 // Snare:
				PlantOrchidTangle     = spr_add("sprPlantOrchidTangle",     6, 24, 24);
				PlantOrchidTangleSeed = spr_add("sprPlantOrchidTangleSeed", 2,  4,  4);
				
			spr_path_add("../");
			//#endregion
			
			//#region RED CRYSTAL
			spr_path_add("CrystalRed/");
			
				 // Player:
				CrystalRedIdle  = spr_add("sprCrystalRedIdle",  4, 12, 12);
				CrystalRedWalk  = spr_add("sprCrystalRedWalk",  6, 12, 12);
				CrystalRedHurt  = spr_add("sprCrystalRedHurt",  3, 12, 12);
				CrystalRedDead  = spr_add("sprCrystalRedDead",  6, 12, 12);
				CrystalRedGoSit = spr_add("sprCrystalRedGoSit", 3, 12, 12);
				CrystalRedSit   = spr_add("sprCrystalRedSit",   1, 12, 12);
				
				 // Menu:
				CrystalRedPortrait = spr_add("sprCrystalRedPortrait", 1, 40, 243);
				CrystalRedLoadout  = spr_add("sprCrystalRedLoadout",  2, 16,  16);
				CrystalRedMapIcon  = spr_add("sprCrystalRedMapIcon",  1, 10,  10);
				
				 // Shield:
				CrystalRedShield          = spr_add("sprCrystalRedShield",          4, 32, 42);
				CrystalRedShieldDisappear = spr_add("sprCrystalRedShieldDisappear", 6, 32, 42);
				CrystalRedShieldIdleFront = spr_add("sprCrystalRedShieldIdleFront", 1, 32, 42);
				CrystalRedShieldWalkFront = spr_add("sprCrystalRedShieldWalkFront", 8, 32, 42);
				CrystalRedShieldIdleBack  = spr_add("sprCrystalRedShieldIdleBack",  1, 32, 42);
				CrystalRedShieldWalkBack  = spr_add("sprCrystalRedShieldWalkBack",  8, 32, 42);
				CrystalRedTrail           = spr_add("sprCrystalRedTrail",           5,  8,  8);
				
			spr_path_add("../");
			//#endregion
			
			//#region WEAPONS
			spr_path_add("Weapons/");
			
				 // Angler:
				spr_path_add("Angler/");
				AnglerAssaultRifle    = spr_add("sprAnglerAssaultRifle",    1,  4,  3, shnWep);
				AnglerBazooka         = spr_add("sprAnglerBazooka",         1, 10,  7, shnWep);
				AnglerCrossbow        = spr_add("sprAnglerCrossbow",        1,  2,  3, shnWep);
				AnglerDiscGun         = spr_add("sprAnglerDiscGun",         1, -2,  3, shnWep);
				AnglerGrenadeLauncher = spr_add("sprAnglerGrenadeLauncher", 1,  2,  3, shnWep);
				AnglerGuitar          = spr_add("sprAnglerGuitar",          1,  2,  7, shnWep);
				AnglerLaserPistol     = spr_add("sprAnglerLaserPistol",     1, -3,  3, shnWep);
				AnglerMachinegun      = spr_add("sprAnglerMachinegun",      1,  0,  2, shnWep);
				AnglerNukeLauncher    = spr_add("sprAnglerNukeLauncher",    1,  9, 10, shnWep);
				AnglerPlasmaGun       = spr_add("sprAnglerPlasmaGun",       1,  1,  4, shnWep);
				AnglerRevolver        = spr_add("sprAnglerRevolver",        1, -3,  2, shnWep);
				AnglerScrewdriver     = spr_add("sprAnglerScrewdriver",     1, -2,  3, shnWep);
				AnglerShotgun         = spr_add("sprAnglerShotgun",         1,  3,  3, shnWep);
				AnglerSlugger         = spr_add("sprAnglerSlugger",         1,  1,  3, shnWep);
				AnglerSplinterGun     = spr_add("sprAnglerSplinterGun",     1,  2,  3, shnWep);
				AnglerTeleportGun     = spr_add("sprAnglerTeleportGun",     1,  6,  6, shnWep);
				AnglerTrident         = spr_add("sprAnglerTrident",         1, 12,  7, shnWep);
				AnglerTunneller       = spr_add("sprAnglerTunneller",       1, 13,  6, shnWep);
				AnglerTunnellerHUD    = spr_add("sprAnglerTunneller",       1, 16,  6, shnWep);
				AnglerWrench          = spr_add("sprAnglerWrench",          1,  1,  4, shnWep);
				AnglerBolt            = spr_add("sprAnglerBolt",            2,  4,  8);
				AnglerDisc            = spr_add("sprAnglerDisc",            2,  7,  7);
				AnglerGrenade         = spr_add("sprAnglerGrenade",         1,  3,  3);
				AnglerNuke            = spr_add("sprAnglerNuke",            1,  8,  8);
				AnglerRocket          = spr_add("sprAnglerRocket",          1,  4,  4);
				spr_path_add("../");
				
				 // Bat:
				spr_path_add("Bat/");
				BatAssaultRifle    = spr_add("sprBatAssaultRifle",    1,  2, 3, shnWep);
				BatBazooka         = spr_add("sprBatBazooka",         1, 10, 5, shnWep);
				BatCrossbow        = spr_add("sprBatCrossbow",        1,  2, 3, shnWep);
				BatDiscGun         = spr_add("sprBatDiscGun",         1, -3, 4, shnWep);
				BatGrenadeLauncher = spr_add("sprBatGrenadeLauncher", 1,  2, 2, shnWep);
				BatLaserPistol     = spr_add("sprBatLaserPistol",     1, -2, 2, shnWep);
				BatMachinegun      = spr_add("sprBatMachinegun",      1,  1, 2, shnWep);
				BatNukeLauncher    = spr_add("sprBatNukeLauncher",    1,  7, 7, shnWep);
				BatPlasmaGun       = spr_add("sprBatPlasmaGun",       1,  3, 4, shnWep);
				BatRevolver        = spr_add("sprBatRevolver",        1, -3, 3, shnWep);
				BatScrewdriver     = spr_add("sprBatScrewdriver",     1, -1, 2, shnWep);
				BatShotgun         = spr_add("sprBatShotgun",         1,  5, 2, shnWep);
				BatSlugger         = spr_add("sprBatSlugger",         1,  2, 3, shnWep);
				BatSplinterGun     = spr_add("sprBatSplinterGun",     1,  2, 4, shnWep);
				BatTeleportGun     = spr_add("sprBatTeleportGun",     1,  7, 6, shnWep);
				BatTrident         = spr_add("sprBatTrident",         1, 12, 7, shnWep);
				BatTunneller       = spr_add("sprBatTunneller",       1, 14, 5, shnWep);
				BatTunnellerHUD    = spr_add("sprBatTunneller",       1, 18, 5, shnWep);
				BatWrench          = spr_add("sprBatWrench",          1,  1, 3, shnWep);
				BatBolt            = spr_add("sprBatBolt",            2,  4, 8);
				BatDisk            = spr_add("sprBatDisc",            2,  7, 7);
				BatGrenade         = spr_add("sprBatGrenade",         1,  3, 3);
				BatNuke            = spr_add("sprBatNuke",            1,  8, 8);
				BatRocket          = spr_add("sprBatRocket",          1,  4, 4);
				spr_path_add("../");
				
				 // Bonus:
				spr_path_add("Bonus/");
				BonusAssaultRifle    = spr_add("sprBonusAssaultRifle",    1,  4, 3, shnWep);
				BonusBazooka         = spr_add("sprBonusBazooka",         1, 11, 2, shnWep);
				BonusCrossbow        = spr_add("sprBonusCrossbow",        1,  2, 4, shnWep);
				BonusDiscGun         = spr_add("sprBonusDiscGun",         1, -4, 2, shnWep);
				BonusGrenadeLauncher = spr_add("sprBonusGrenadeLauncher", 1,  2, 2, shnWep);
				BonusLaserPistol     = spr_add("sprBonusLaserPistol",     1, -3, 2, shnWep);
				BonusMachinegun      = spr_add("sprBonusMachinegun",      1,  0, 1, shnWep);
				BonusNukeLauncher    = spr_add("sprBonusNukeLauncher",    1,  7, 6, shnWep);
				BonusPlasmaGun       = spr_add("sprBonusPlasmaGun",       1,  3, 4, shnWep);
				BonusRevolver        = spr_add("sprBonusRevolver",        1, -3, 2, shnWep);
				BonusScrewdriver     = spr_add("sprBonusScrewdriver",     1, -1, 1, shnWep);
				BonusShotgun         = spr_add("sprBonusShotgun",         1,  4, 2, shnWep);
				BonusSlugger         = spr_add("sprBonusSlugger",         1,  0, 2, shnWep);
				BonusSplinterGun     = spr_add("sprBonusSplinterGun",     1,  1, 3, shnWep);
				BonusTeleportGun     = spr_add("sprBonusTeleportGun",     1,  4, 4, shnWep);
				BonusTrident         = spr_add("sprBonusTrident",         1, 11, 7, shnWep);
				BonusTunneller       = spr_add("sprBonusTunneller",       1, 14, 8, shnWep);
				BonusTunnellerHUD    = spr_add("sprBonusTunneller",       1, 17, 8, shnWep);
				BonusWrench          = spr_add("sprBonusWrench",          1,  1, 3, shnWep);
				BonusBolt            = spr_add("sprBonusBolt",            2,  4, 8);
				BonusDisc            = spr_add("sprBonusDisc",            2,  6, 6);
				BonusGrenade         = spr_add("sprBonusGrenade",         1,  3, 3);
				BonusNuke            = spr_add("sprBonusNuke",            1,  8, 8);
				BonusRocket          = spr_add("sprBonusRocket",          1,  4, 4);
				spr_path_add("../");
				
				 // Coat:
				spr_path_add("Coat/");
				CoatAssaultRifle    = spr_add("sprCoatAssaultRifle",    1,  5,  4, shnWep);
				CoatBazooka         = spr_add("sprCoatBazooka",         1, 11,  5, shnWep);
				CoatCrossbow        = spr_add("sprCoatCrossbow",        1,  3,  3, shnWep);
				CoatDiscGun         = spr_add("sprCoatDiscGun",         1, -4,  2, shnWep);
				CoatGrenadeLauncher = spr_add("sprCoatGrenadeLauncher", 1,  1,  5, shnWep);
				CoatLaserPistol     = spr_add("sprCoatLaserPistol",     1, -3,  2, shnWep);
				CoatMachinegun      = spr_add("sprCoatMachinegun",      1,  1,  3, shnWep);
				CoatNukeLauncher    = spr_add("sprCoatNukeLauncher",    1,  8,  9, shnWep);
				CoatPlasmaGun       = spr_add("sprCoatPlasmaGun",       1,  3,  4, shnWep);
				CoatRevolver        = spr_add("sprCoatRevolver",        1, -4,  3, shnWep);
				CoatScrewdriver     = spr_add("sprCoatScrewdriver",     1,  0,  4, shnWep);
				CoatShotgun         = spr_add("sprCoatShotgun",         1,  3,  3, shnWep);
				CoatSlugger         = spr_add("sprCoatSlugger",         1,  1,  4, shnWep);
				CoatSplinterGun     = spr_add("sprCoatSplinterGun",     1,  2,  4, shnWep);
				CoatTeleportGun     = spr_add("sprCoatTeleportGun",     1,  6,  6, shnWep);
				CoatTrident         = spr_add("sprCoatTrident",         1, 11,  6, shnWep);
				CoatTunneller       = spr_add("sprCoatTunneller",       1, 16, 11, shnWep);
				CoatTunnellerHUD    = spr_add("sprCoatTunneller",       1, 22, 11, shnWep);
				CoatWrench          = spr_add("sprCoatWrench",          1,  1,  5, shnWep);
				CoatBolt            = spr_add("sprCoatBolt",            2,  4,  8);
				CoatDisc            = spr_add("sprCoatDisc",            2,  6,  6);
				CoatGrenade         = spr_add("sprCoatGrenade",         1,  3,  3);
				CoatNuke            = spr_add("sprCoatNuke",            1,  8,  8);
				CoatRocket          = spr_add("sprCoatRocket",          1,  4,  4);
				spr_path_add("../");
				
				 // Cool:
				spr_path_add("Cool/");
				CoolAssaultRifle    = spr_add("sprCoolAssaultRifle",    1,  2, 3, shnWep);
				CoolBazooka         = spr_add("sprCoolBazooka",         1, 11, 4, shnWep);
				CoolCrossbow        = spr_add("sprCoolCrossbow",        1,  2, 3, shnWep);
				CoolDiscGun         = spr_add("sprCoolDiscGun",         1, -4, 3, shnWep);
				CoolFrogPistol      = spr_add("sprCoolFrogPistol",      1, -3, 4, shnWep);
				CoolGrenadeLauncher = spr_add("sprCoolGrenadeLauncher", 1,  2, 2, shnWep);
				CoolLaserPistol     = spr_add("sprCoolLaserPistol",     1, -3, 3, shnWep);
				CoolMachinegun      = spr_add("sprCoolMachinegun",      1, -1, 1, shnWep);
				CoolNukeLauncher    = spr_add("sprCoolNukeLauncher",    1,  8, 6, shnWep);
				CoolPlasmaGun       = spr_add("sprCoolPlasmaGun",       1,  1, 4, shnWep);
				CoolRevolver        = spr_add("sprCoolRevolver",        1, -3, 2, shnWep);
				CoolScrewdriver     = spr_add("sprCoolScrewdriver",     1, -2, 2, shnWep);
				CoolShotgun         = spr_add("sprCoolShotgun",         1,  2, 2, shnWep);
				CoolSlugger         = spr_add("sprCoolSlugger",         1,  2, 2, shnWep);
				CoolSplinterGun     = spr_add("sprCoolSplinterGun",     1,  2, 3, shnWep);
				CoolTeleportGun     = spr_add("sprCoolTeleportGun",     1,  6, 6, shnWep);
				CoolTrident         = spr_add("sprCoolTrident",         1, 12, 8, shnWep);
				CoolTunneller       = spr_add("sprCoolTunneller",       1, 13, 4, shnWep);
				CoolTunnellerHUD    = spr_add("sprCoolTunneller",       1, 16, 4, shnWep);
				CoolWrench          = spr_add("sprCoolWrench",          1, -1, 3, shnWep);
				CoolBolt            = spr_add("sprCoolBolt",            2,  4, 8);
				CoolDisc            = spr_add("sprCoolDisc",            2,  7, 7);
				CoolGrenade         = spr_add("sprCoolGrenade",         1,  3, 3);
				CoolNuke            = spr_add("sprCoolNuke",            1,  8, 8);
				CoolRocket          = spr_add("sprCoolRocket",          1,  4, 4);
				spr_path_add("../");
				
				 // Orchid:
				spr_path_add("Orchid/");
				OrchidAssaultRifle    = spr_add("sprOrchidAssaultRifle",    1,  5, 4, shnWep);
				OrchidBazooka         = spr_add("sprOrchidBazooka",         1, 12, 5, shnWep);
				OrchidCrossbow        = spr_add("sprOrchidCrossbow",        1,  4, 4, shnWep);
				OrchidDiscGun         = spr_add("sprOrchidDiscGun",         1, -3, 4, shnWep);
				OrchidFrogPistol      = spr_add("sprOrchidFrogPistol",      1, -4, 4, shnWep);
				OrchidFrogPistolRusty = spr_add("sprOrchidFrogPistolRusty", 1, -4, 4, shnWep);
				OrchidGrenadeLauncher = spr_add("sprOrchidGrenadeLauncher", 1,  5, 5, shnWep);
				OrchidLaserPistol     = spr_add("sprOrchidLaserPistol",     1, -2, 2, shnWep);
				OrchidMachinegun      = spr_add("sprOrchidMachinegun",      1,  3, 3, shnWep);
				OrchidNukeLauncher    = spr_add("sprOrchidNukeLauncher",    1,  8, 8, shnWep);
				OrchidPlasmaGun       = spr_add("sprOrchidPlasmaGun",       1,  3, 4, shnWep);
				OrchidRevolver        = spr_add("sprOrchidRevolver",        1, -3, 2, shnWep);
				OrchidScrewdriver     = spr_add("sprOrchidScrewdriver",     1, -1, 3, shnWep);
				OrchidShotgun         = spr_add("sprOrchidShotgun",         1,  5, 3, shnWep);
				OrchidSlugger         = spr_add("sprOrchidSlugger",         1,  4, 4, shnWep);
				OrchidSplinterGun     = spr_add("sprOrchidSplinterGun",     1,  3, 4, shnWep);
				OrchidTeleportGun     = spr_add("sprOrchidTeleportGun",     1,  5, 6, shnWep);
				OrchidTrident         = spr_add("sprOrchidTrident",         1, 12, 7, shnWep);
				OrchidTunneller       = spr_add("sprOrchidTunneller",       1, 14, 9, shnWep);
				OrchidTunnellerHUD    = spr_add("sprOrchidTunneller",       1, 20, 9, shnWep);
				OrchidWrench          = spr_add("sprOrchidWrench",          1,  1, 4, shnWep);
				OrchidBolt            = spr_add("sprOrchidBolt",            2,  4, 8);
				OrchidDisc            = spr_add("sprOrchidDisc",            2,  6, 6);
				OrchidGrenade         = spr_add("sprOrchidGrenade",         1,  3, 3);
				OrchidNuke            = spr_add("sprOrchidNuke",            1,  8, 8);
				OrchidRocket          = spr_add("sprOrchidRocket",          1,  4, 4);
				spr_path_add("../");
				
				 // Red:
				spr_path_add("Red/");
				RedAssaultRifle    = spr_add("sprRedAssaultRifle",    1,  4, 3, shnWep);
				RedBazooka         = spr_add("sprRedBazooka",         1, 11, 2, shnWep);
				RedCrossbow        = spr_add("sprRedCrossbow",        1,  2, 5, shnWep);
				RedDiscGun         = spr_add("sprRedDiscGun",         1, -3, 4, shnWep);
				RedGrenadeLauncher = spr_add("sprRedGrenadeLauncher", 1,  1, 2, shnWep);
				RedLaserPistol     = spr_add("sprRedLaserPistol",     1, -2, 2, shnWep);
				RedMachinegun      = spr_add("sprRedMachinegun",      1,  1, 0, shnWep);
				RedNukeLauncher    = spr_add("sprRedNukeLauncher",    1,  7, 6, shnWep);
				RedPlasmaGun       = spr_add("sprRedPlasmaGun",       1,  3, 3, shnWep);
				RedRevolver        = spr_add("sprRedRevolver",        1, -2, 2, shnWep);
				RedScrewdriver     = spr_add("sprRedScrewdriver",     1, -2, 3, shnWep);
				RedShotgun         = spr_add("sprRedShotgun",         1,  4, 2, shnWep);
				RedSlugger         = spr_add("sprRedSlugger",         1,  2, 2, shnWep);
				RedSplinterGun     = spr_add("sprRedSplinterGun",     1,  2, 4, shnWep);
				RedTeleportGun     = spr_add("sprRedTeleportGun",     1,  6, 5, shnWep);
				RedTrident         = spr_add("sprRedTrident",         1, 12, 7, shnWep);
				RedTunneller       = spr_add("sprRedTunneller",       1, 14, 7, shnWep);
				RedTunnellerHUD    = spr_add("sprRedTunneller",       1, 18, 8, shnWep);
				RedWrench          = spr_add("sprRedWrench",          1,  1, 3, shnWep);
				RedBolt            = spr_add("sprRedBolt",            2,  4, 8);
				RedDisc            = spr_add("sprRedDisc",            2,  6, 6);
				RedGrenade         = spr_add("sprRedGrenade",         1,  3, 3);
				RedNuke            = spr_add("sprRedNuke",            1,  8, 8);
				RedRocket          = spr_add("sprRedRocket",          1,  4, 4);
				spr_path_add("../");
				
			spr_path_add("../");
			//#endregion
			
		//#endregion
		
		//#region PETS
		spr_path_set("pets/");
		
			 // General:
			PetArrow = spr_add("sprPetArrow", 1, 3,  0);
			PetLost  = spr_add("sprPetLost",  7, 8, 16);
			
			 // Scorpion:
			spr_path_add("Desert/");
			PetScorpionIcon   = spr_add("sprPetScorpionIcon",   1,  6,  6);
			PetScorpionIdle   = spr_add("sprPetScorpionIdle",   4, 16, 16);
			PetScorpionWalk   = spr_add("sprPetScorpionWalk",   6, 16, 16);
			PetScorpionHurt   = spr_add("sprPetScorpionHurt",   3, 16, 16);
			PetScorpionDead   = spr_add("sprPetScorpionDead",   6, 16, 16);
			PetScorpionFire   = spr_add("sprPetScorpionFire",   6, 16, 16);
			PetScorpionShield = spr_add("sprPetScorpionShield", 6, 16, 16);
			spr_path_add("../");
			
			 // Parrot:
			spr_path_add("Coast/");
			PetParrotNote  = spr_add("sprPetParrotNote",   5,  4,  4);
			PetParrotIcon  = spr_add("sprPetParrotIcon",   1,  6,  6);
			PetParrotIdle  = spr_add("sprPetParrotIdle",   6, 12, 12);
			PetParrotWalk  = spr_add("sprPetParrotWalk",   6, 12, 14);
			PetParrotHurt  = spr_add("sprPetParrotDodge",  3, 12, 12);
			PetParrotBIcon = spr_add("sprPetParrotBIcon",  1,  6,  6);
			PetParrotBIdle = spr_add("sprPetParrotBIdle",  6, 12, 12);
			PetParrotBWalk = spr_add("sprPetParrotBWalk",  6, 12, 14);
			PetParrotBHurt = spr_add("sprPetParrotBDodge", 3, 12, 12);
			spr_path_add("../");
			
			 // CoolGuy:
			spr_path_add("Pizza/");
			PetCoolGuyIcon = spr_add("sprPetCoolGuyIcon",  1,  6,  6);
			PetCoolGuyIdle = spr_add("sprPetCoolGuyIdle",  4, 12, 12);
			PetCoolGuyWalk = spr_add("sprPetCoolGuyWalk",  6, 12, 12);
			PetCoolGuyHurt = spr_add("sprPetCoolGuyDodge", 3, 12, 12);
			PetPeasIcon    = spr_add("sprPetPeasIcon",     1,  6,  6);
			PetPeasIdle    = spr_add("sprPetPeasIdle",     4, 12, 12);
			PetPeasWalk    = spr_add("sprPetPeasWalk",     6, 12, 12);
			PetPeasHurt    = spr_add("sprPetPeasDodge",    3, 12, 12);
			spr_path_add("../");
			
			 // BabyShark:
			spr_path_add("Oasis/");
			PetSlaughterIcon  = spr_add("sprPetSlaughterIcon",   1,  6,  6);
			PetSlaughterIdle  = spr_add("sprPetSlaughterIdle",   4, 12, 12);
			PetSlaughterWalk  = spr_add("sprPetSlaughterWalk",   6, 12, 12);
			PetSlaughterHurt  = spr_add("sprPetSlaughterHurt",   3, 12, 12);
			PetSlaughterDead  = spr_add("sprPetSlaughterDead",  10, 24, 24);
			PetSlaughterSpwn  = spr_add("sprPetSlaughterSpwn",   7, 24, 24);
			PetSlaughterBite  = spr_add("sprPetSlaughterBite",   6, 12, 12);
			SlaughterBite     = spr_add("sprSlaughterBite",      6,  8, 12);
			SlaughterPropIdle = spr_add("sprSlaughterPropIdle",  1, 12, 12);
			SlaughterPropHurt = spr_add("sprSlaughterPropHurt",  3, 12, 12);
			SlaughterPropDead = spr_add("sprSlaughterPropDead",  3, 12, 12);
			spr_path_add("../");
			
			 // Octopus:
			spr_path_add("Trench/");
			PetOctoIcon     = spr_add("sprPetOctoIcon",      1,  7,  7);
			PetOctoIdle     = spr_add("sprPetOctoIdle",     16, 12, 12);
			PetOctoHurt     = spr_add("sprPetOctoDodge",     3, 12, 12);
			PetOctoHide     = spr_add("sprPetOctoHide",     30, 12, 12);
			PetOctoHideIcon = spr_add("sprPetOctoHideIcon",  1,  7,  6);
			spr_path_add("../");
			
			 // Salamander:
			spr_path_add("Scrapyards/");
			PetSalamanderIcon = spr_add("sprPetSalamanderIcon", 1,  6,  6);
			PetSalamanderIdle = spr_add("sprPetSalamanderIdle", 6, 16, 16);
			PetSalamanderWalk = spr_add("sprPetSalamanderWalk", 8, 16, 16);
			PetSalamanderHurt = spr_add("sprPetSalamanderHurt", 3, 16, 16);
			PetSalamanderChrg = spr_add("sprPetSalamanderChrg", 3, 16, 16);
			spr_path_add("../");
			
			 // Golden Chest Mimic:
			spr_path_add("Mansion/");
			PetMimicIcon = spr_add("sprPetMimicIcon",   1,  6,  6);
			PetMimicIdle = spr_add("sprPetMimicIdle",  16, 16, 16);
			PetMimicWalk = spr_add("sprPetMimicWalk",   6, 16, 16);
			PetMimicHurt = spr_add("sprPetMimicDodge",  3, 16, 16);
			PetMimicOpen = spr_add("sprPetMimicOpen",   1, 16, 16);
			PetMimicHide = spr_add("sprPetMimicHide",   1, 16, 16);
			spr_path_add("../");
			
			 // Spider
			spr_path_add("Caves/");
			PetSpiderIcon       = spr_add("sprPetSpiderIcon",        1,  6,  6);
			PetSpiderIdle       = spr_add("sprPetSpiderIdle",        8, 16, 16);
			PetSpiderWalk       = spr_add("sprPetSpiderWalk",        6, 16, 16);
			PetSpiderHurt       = spr_add("sprPetSpiderDodge",       3, 16, 16);
			PetSpiderWeb        = spr_add("sprPetSpiderWeb",         1,  0,  0);
			PetSpiderWebBits    = spr_add("sprWebBits",              5,  4,  4);
			PetSparkle          = spr_add("sprPetSparkle",           5,  8,  8);
			PetSpiderCursedIcon = spr_add("sprPetSpiderCursedIcon",  1,  6,  6);
			PetSpiderCursedIdle = spr_add("sprPetSpiderCursedIdle",  8, 16, 16);
			PetSpiderCursedWalk = spr_add("sprPetSpiderCursedWalk",  6, 16, 16);
			PetSpiderCursedHurt = spr_add("sprPetSpiderCursedDodge", 3, 16, 16);
			PetSpiderCursedKill = spr_add("sprPetSpiderCursedKill",  6, 16, 16);
			spr_path_add("../");
			
			 // Prism:
			spr_path_add("Cursed Caves/");
			PetPrismIcon = spr_add("sprPetPrismIcon", 1,  6,  6);
			PetPrismIdle = spr_add("sprPetPrismIdle", 6, 12, 12);
			spr_path_add("../");
			
			 // Mantis:
			spr_path_add("Vault/");
			PetOrchidIcon = spr_add("sprPetOrchidIcon",  1,  6,  6);
			PetOrchidIdle = spr_add("sprPetOrchidIdle", 28, 12, 12);
			PetOrchidWalk = spr_add("sprPetOrchidWalk",  6, 12, 12);
			PetOrchidHurt = spr_add("sprPetOrchidHurt",  3, 12, 12);
			PetOrchidBall = spr_add("sprPetOrchidBall",  2, 12, 12);
			spr_path_add("../");
			
			 // Weapon Chest Mimic:
			spr_path_add("Weapon/");
			PetWeaponIcon       = spr_add("sprPetWeaponIcon",        1,  6,  6);
			PetWeaponChst       = spr_add("sprPetWeaponChst",        1,  8,  8);
			PetWeaponHide       = spr_add("sprPetWeaponHide",        8, 12, 12);
			PetWeaponSpwn       = spr_add("sprPetWeaponSpwn",       16, 12, 12);
			PetWeaponIdle       = spr_add("sprPetWeaponIdle",        8, 12, 12);
			PetWeaponWalk       = spr_add("sprPetWeaponWalk",        8, 12, 12);
			PetWeaponHurt       = spr_add("sprPetWeaponHurt",        3, 12, 12);
			PetWeaponDead       = spr_add("sprPetWeaponDead",        6, 12, 12);
			PetWeaponStat       = spr_add("sprPetWeaponStat",        1, 20,  5);
			PetWeaponCursedIcon = spr_add("sprPetWeaponIconCursed",  1,  6,  6);
			PetWeaponCursedChst = spr_add("sprPetWeaponChstCursed",  1,  8,  8);
			PetWeaponCursedHide = spr_add("sprPetWeaponHideCursed",  8, 12, 12);
			PetWeaponCursedSpwn = spr_add("sprPetWeaponSpwnCursed", 16, 12, 12);
			PetWeaponCursedIdle = spr_add("sprPetWeaponIdleCursed",  8, 12, 12);
			PetWeaponCursedWalk = spr_add("sprPetWeaponWalkCursed",  8, 12, 12);
			PetWeaponCursedHurt = spr_add("sprPetWeaponHurtCursed",  3, 12, 12);
			PetWeaponCursedDead = spr_add("sprPetWeaponDeadCursed",  6, 12, 12);
			spr_path_add("../");
			
			 // Twins:
			spr_path_add("Red/");
			PetTwinsIcon        = spr_add("sprPetTwinsIcon",        1,  6,  6);
			PetTwinsStat        = spr_add("sprPetTwinsStat",        6, 12, 12);
			PetTwinsRedIcon     = spr_add("sprPetTwinsRedIcon",     1,  6,  6);
			PetTwinsRed         = spr_add("sprPetTwinsRed",         6, 12, 12);
			PetTwinsRedEffect   = spr_add("sprPetTwinsRedEffect",   6,  8,  8);
			PetTwinsWhiteIcon   = spr_add("sprPetTwinsWhiteIcon",   1,  6,  6);
			PetTwinsWhite       = spr_add("sprPetTwinsWhite",       6, 12, 12);
			PetTwinsWhiteEffect = spr_add("sprPetTwinsWhiteEffect", 6,  8,  8);
			CrystalWhiteTrail   = spr_add("sprCrystalWhiteTrail",   5,  8,  8);
			spr_path_add("../");
			
			 // Cuz:
			spr_path_add("Crib/");
			PetCuzIcon = spr_add("sprPetCuzIcon", 1, 6, 6);
			spr_path_add("../");
			
			 // Guardian:
			spr_path_add("HQ/");
			PetGuardianIcon            = spr_add("sprPetGuardianIcon",            1,  6,  7);
			PetGuardianIdle            = spr_add("sprPetGuardianIdle",            4, 16, 16);
			PetGuardianHurt            = spr_add("sprPetGuardianHurt",            3, 16, 16);
			PetGuardianDashStart       = spr_add("sprPetGuardianDashStart",       3, 16, 16);
			PetGuardianDashCharge      = spr_add("sprPetGuardianDashCharge",      2, 16, 16);
			PetGuardianDash            = spr_add("sprPetGuardianDash",            2, 16, 16);
			PetGuardianDashEnd         = spr_add("sprPetGuardianDashEnd",         3, 16, 16);
			PetGuardianAppear          = spr_add("sprPetGuardianAppear",          7, 16, 16);
			PetGuardianDisappear       = spr_add("sprPetGuardianDisappear",       6, 16, 16);
			PetGuardianShield          = spr_add("sprPetGuardianShield",          6, 16, 16);
			PetGuardianShieldDisappear = spr_add("sprPetGuardianShieldDisappear", 6, 16, 16);
			spr_path_add("../");
			
		//#endregion
	}
	
	 // SOUNDS //
	snd = { "mus": { "amb": {} } };
	with(snd){
		 // SawTrap:
		SawTrap = sound_add("sounds/enemies/SawTrap/sndSawTrap.ogg");
		
		 // Palanking:
		with(["Hurt", "Dead", "Taunt", "Call", "Swipe"]){
			lq_set(other, `Palanking${self}`, sound_add(`sounds/enemies/Palanking/sndPalanking${self}.ogg`));
		}
		sound_volume(PalankingHurt, 0.6);
		
		 // Big Shots:
		with(["Hurt", "Dead", "Intro", "Taunt"]){
			lq_set(other, `BigBat${self}`, sound_add(`sounds/enemies/BigShots/sndBigBat${self}.ogg`));
			lq_set(other, `BigCat${self}`, sound_add(`sounds/enemies/BigShots/sndBigCat${self}.ogg`));
		}
		BigBatScreech = sound_add("sounds/enemies/BigShots/sndBigBatScreech.ogg");
		BigCatCharge  = sound_add("sounds/enemies/BigShots/sndBigCatCharge.ogg");
		BigShotsTaunt = sound_add("sounds/enemies/BigShots/sndBigShotsTaunt.ogg");
		
		 // Characters:
		with([
			"Slct",
			"Cnfm",
			"Wrld",
			"Hurt",
			"Dead",
			"LowA",
			"LowH",
			"Chst",
		//	"Valt",
			"Crwn",
			"Spch",
			"IDPD",
		//	"Cptn",
		//	"Thrn",
			"UltraA",
			"UltraB"
		]){
			with(["Beetle", "Parrot"]){
				lq_set(snd, self + other, sound_add(`sounds/races/${self}/snd${self + other}.ogg`));
			}
		}
		
		 // Music:
		with([
			 // Areas:
			"Coast",
			"CoastB",
			"Trench",
			"TrenchB",
			"Lair",
			"Red",
			
			 // Bosses:
			"SealKing",
			"BigShots",
			"BigShotsIntro",
			"PitSquid",
			"PitSquidIntro",
			"PitSquidIntroStart",
			"PitSquidIntroLoop",
			"Tesseract",
			"TesseractIntro"
		]){
			lq_set(mus, self, sound_add(`sounds/music/mus${self}.ogg`));
		}
	}
	
	 // SAVE FILE //
	save_data = {};
	save_auto = false;
	if(fork()){
		var _path = save_path;
		
		 // Defaulterize Options:
		with([
			["option:shaders",       true],
			["option:reminders",     true],
			["option:footprints",    true],
			["option:intros",        2],
			["option:outline:pets",  2],
			["option:outline:charm", 2],
			["option:quality:main",  1],
			["option:quality:minor", 1]
		]){
			save_set(self[0], self[1]);
		}
		
		 // Load Existing Save:
		file_load(_path);
		while(!file_loaded(_path)){
			wait 0;
		}
		if(file_exists(_path)){
			var _save = json_decode(string_load(_path));
			
			 // Copy Loaded Save's Values:
			if(is_object(_save)){
				for(var i = 0; i < lq_size(_save); i++){
					lq_set(save_data, lq_get_key(_save, i), lq_get_value(_save, i));
				}
				
				 // Update Legacy Merged Weapons:
				if(fork()){
					while(mod_exists("mod", "teloader")){
						wait 0;
					}
					var _saveUnlockLoadoutInfo = save_get("unlock:loadout:wep", undefined);
					if(_saveUnlockLoadoutInfo != undefined){
						for(var _saveUnlockLoadoutIndex = lq_size(_saveUnlockLoadoutInfo) - 1; _saveUnlockLoadoutIndex >= 0; _saveUnlockLoadoutIndex--){
							var	_saveUnlockLoadoutWepInfoKey = lq_get_key(_saveUnlockLoadoutInfo, _saveUnlockLoadoutIndex),
								_saveUnlockLoadoutWepInfo    = lq_get_value(_saveUnlockLoadoutInfo, _saveUnlockLoadoutIndex);
								
							for(var _saveUnlockLoadoutWepIndex = lq_size(_saveUnlockLoadoutWepInfo) - 1; _saveUnlockLoadoutWepIndex >= 0; _saveUnlockLoadoutWepIndex--){
								var	_saveUnlockLoadoutWepKey = lq_get_key(_saveUnlockLoadoutWepInfo, _saveUnlockLoadoutWepIndex),
									_saveUnlockLoadoutWep    = lq_get_value(_saveUnlockLoadoutWepInfo, _saveUnlockLoadoutWepIndex);
									
								if(
									call(scr.wep_raw, _saveUnlockLoadoutWep) == "merge"
									&& "base"  in _saveUnlockLoadoutWep
									&& "stock" in _saveUnlockLoadoutWep.base
									&& "front" in _saveUnlockLoadoutWep.base
								){
									save_set(
										`unlock:loadout:wep:${_saveUnlockLoadoutWepInfoKey}:${_saveUnlockLoadoutWepKey}`,
										call(scr.weapon_add_temerge, _saveUnlockLoadoutWep.base.stock, _saveUnlockLoadoutWep.base.front)
									);
								}
							}
						}
					}
					exit;
				}
			}
			
			 // Save File Corrupt:
			else{
				var _pathCorrupt = string_insert("CORRUPT", _path, string_pos(".", _path));
				string_save(string_load(_path), _pathCorrupt);
				if(fork()){
					while(mod_exists("mod", "teloader")){
						wait 0;
					}
					wait 1;
					trace_color(`NTTE | Something isn't right with your save file... creating a new one and moving old to '${_pathCorrupt}'.`, c_red);
					exit;
				}
			}
		}
		file_unload(_path);
		
		 // Re-Save:
		ntte_save();
		save_auto = true;
		
		exit;
	}
	
	 // Script Binding, Surface, Shader Storage:
	global.bind        = ds_map_create();
	global.bind_hold   = ds_map_create();
	global.surf        = ds_map_create();
	global.shad        = ds_map_create();
	global.shad_active = "";
	
	 // Mod Lists:
	ntte_mods = {
		"mod"    : [],
		"area"   : [],
		"race"   : [],
		"skin"   : [],
		"skill"  : [],
		"crown"  : [],
		"weapon" : []
	};
	ntte_mods_call = {
		"begin_step"   : [],
		"step"         : [],
		"end_step"     : [],
		"draw"         : [],
		"draw_shadows" : [],
		"draw_bloom"   : [],
		"draw_dark"    : []
	};
	
	 // Shared Mod Variables:
	ntte_vars = {
		"mods"      : ntte_mods,
		"mods_call" : ntte_mods_call,
		"version"   : ntte_version
	};
	
	 // Object Setup Script Binding:
	global.bind_setup             = ds_map_create();
	global.bind_setup_object_list = [];
	for(var i = 0; object_exists(i); i++){
		array_push(global.bind_setup_object_list, noone);
	}
	
	 // Cloned Starting Weapons:
	global.loadout_wep_clone = ds_list_create();
	
	 // Math Epsilon:
	for(var i = 0; i <= 16; i++){
		global.epsilon = power(10, -i);
		if(global.epsilon == 0){
			break;
		}
	}
	
	 // Projectile Sprite Team Variants:
	global.sprite_team_variant_table = [
		[["EnemyBullet",               EnemyBullet4  ], [sprBullet1,            Bullet1        ], [sprIDPDBullet,           IDPDBullet    ]], // Bullet
		[[sprEnemyBulletHit                          ], [sprBulletHit                          ], [sprIDPDBulletHit                       ]], // Bullet Hit
		[["EnemyHeavyBullet",          "CustomBullet"], [sprHeavyBullet,        HeavyBullet    ], ["IDPDHeavyBullet",       "CustomBullet"]], // Heavy Bullet
		[["EnemyHeavyBulletHit"                      ], [sprHeavyBulletHit                     ], ["IDPDHeavyBulletHit"                   ]], // Heavy Bullet Hit
		[[sprLHBouncer,                LHBouncer     ], [sprBouncerBullet,      BouncerBullet  ], [                                       ]], // Bouncer Bullet
		[[sprLHBouncer,                LHBouncer     ], [sprBouncerShell,       BouncerBullet  ], [                                       ]], // Bouncer Bullet 2
		[[sprEnemyBullet1,             EnemyBullet1  ], [sprAllyBullet,         AllyBullet     ], [                                       ]], // Bandit Bullet
		[[sprEnemyBulletHit                          ], [sprAllyBulletHit                      ], [sprIDPDBulletHit                       ]], // Bandit Bullet Hit
		[[sprEnemyBullet4,             EnemyBullet4  ], ["AllySniperBullet",    AllyBullet     ], [                                       ]], // Sniper Bullet
		[[sprEBullet3,                 EnemyBullet3  ], [sprBullet2,            Bullet2        ], [                                       ]], // Shell
		[[sprEBullet3Disappear,        EnemyBullet3  ], [sprBullet2Disappear,   Bullet2        ], [                                       ]], // Shell Disappear
		[["EnemySlug",                 "CustomShell" ], [sprSlugBullet,         Slug           ], [sprPopoSlug,             PopoSlug      ]], // Slug
		[["EnemySlugDisappear",        "CustomShell" ], [sprSlugDisappear,      Slug           ], [sprPopoSlugDisappear,    PopoSlug      ]], // Slug Disappear
		[["EnemySlugHit"                             ], [sprSlugHit                            ], [sprIDPDBulletHit                       ]], // Slug Hit
		[["EnemySlug",                 "CustomShell" ], [sprHyperSlug,          Slug           ], [sprPopoSlug,             PopoSlug      ]], // Hyper Slug
		[["EnemySlugDisappear",        "CustomShell" ], [sprHyperSlugDisappear, Slug           ], [sprPopoSlugDisappear,    PopoSlug      ]], // Hyper Slug Disappear
		[["EnemyHeavySlug",            "CustomShell" ], [sprHeavySlug,          HeavySlug      ], [                                       ]], // Heavy Slug
		[["EnemyHeavySlugDisappear",   "CustomShell" ], [sprHeavySlugDisappear, HeavySlug      ], [                                       ]], // Heavy Slug Disappear
		[["EnemyHeavySlugHit"                        ], [sprHeavySlugHit,                      ], [                                       ]], // Heavy Slug Hit
		[[sprEFlak,                    "CustomFlak"  ], [sprFlakBullet,         FlakBullet     ], [                                       ]], // Flak
		[[sprEFlakHit                                ], [sprFlakHit                            ], [                                       ]], // Flak Hit
		[["EnemySuperFlak",            "CustomFlak"  ], [sprSuperFlakBullet,    SuperFlakBullet], [                                       ]], // Super Flak
		[["EnemySuperFlakHit"                        ], [sprSuperFlakHit                       ], [                                       ]], // Super Flak Hit
		[[sprEFlak,                    EFlakBullet   ], [sprFlakBullet,         "CustomFlak"   ], [                                       ]], // Gator Flak
		[[sprTrapFire                                ], [sprWeaponFire                         ], [sprFireLilHunter                       ]], // Fire
		[[sprSalamanderBullet                        ], [sprDragonFire                         ], [sprFireLilHunter                       ]], // Fire 2
		[[sprTrapFire                                ], [sprCannonFire                         ], [sprFireLilHunter                       ]], // Fire 3
	//	[[sprFireBall                                ], [sprFireBall                           ], [                                       ]], // Fire Ball
	//	[[sprFireShell                               ], [sprFireShell                          ], [                                       ]], // Fire Shell
		[[sprEnemyLaser,               EnemyLaser    ], [sprLaser,              Laser          ], ["PopoLaser",             "PopoLaser"   ]], // Laser
		[[sprEnemyLaserStart                         ], [sprLaserStart                         ], ["PopoLaserStart"                       ]], // Laser Start
		[[sprEnemyLaserEnd                           ], [sprLaserEnd                           ], ["PopoLaserEnd"                         ]], // Laser End
		[[sprLaserCharge                             ], ["AllyLaserCharge"                     ], [sprIDPDPortalCharge                    ]], // Laser Particle
		[[sprEnemyLightning,           EnemyLightning], [sprLightning,          Lightning      ], [                                       ]], // Lightning
	//	[[sprLightningHit                            ], [sprLightningHit                       ], [                                       ]], // Lightning Hit
	//	[[sprLightningSpawn                          ], [sprLightningSpawn                     ], [                                       ]], // Lightning Particle
		[["EnemyPlasmaBall",           "CustomPlasma"], [sprPlasmaBall,         PlasmaBall     ], [sprPopoPlasma,           PopoPlasmaBall]], // Plasma
		[["EnemyPlasmaBig",            "CustomPlasma"], [sprPlasmaBallBig,      PlasmaBig      ], [                                       ]], // Plasma Big
		[["EnemyPlasmaHuge",           "CustomPlasma"], [sprPlasmaBallHuge,     PlasmaHuge     ], [                                       ]], // Plasma Huge
		[["EnemyPlasmaImpact"                        ], [sprPlasmaImpact                       ], [sprPopoPlasmaImpact                    ]], // Plasma Impact
		[["EnemyPlasmaImpactSmall"                   ], ["PlasmaImpactSmall"                   ], ["PopoPlasmaImpactSmall"                ]], // Plasma Impact Small
		[["EnemyPlasmaTrail"                         ], [sprPlasmaTrail                        ], [sprPopoPlasmaTrail                     ]], // Plasma Particle
		[["EnemyVlasmaBullet"                        ], ["VlasmaBullet"                        ], ["PopoVlasmaBullet"                     ]], // Vector Plasma
		[["EnemyVlasmaCannon"                        ], ["VlasmaCannon"                        ], ["PopoVlasmaCannon"                     ]], // Vector Plasma Cannon
		[[sprEnemySlash                              ], [sprSlash                              ], [sprEnemySlash                          ]]  // Slash
		// Devastator
		// Lightning Cannon
		// Hyper Slug (kinda)
	];
	
	 // Reminders:
	global.remind = [];
	if(fork()){
		while(mod_exists("mod", "teloader")){
			wait 0;
		}
		
		trace_color("NT:TE | Finished loading!", c_yellow);
		repeat(20 * (game_height / 240)) trace("");
		
		if(option_get("reminders")){
			global.remind = [
				{	"x"      : -85,
					"y"      : -2,
					"text"   : "Turn em on!",
					"object" : GameMenuButton,
					"active" : (!UberCont.opt_bossintros && save_get("option:intros", 1) >= 2)
					},
				{	"x"      : -85,
					"y"      : 29,
					"text"   : "Pump it up!",
					"object" : AudioMenuButton,
					"active" : (!UberCont.opt_bossintros)
					}
			];
			
			with(global.remind){
				text_inst = noone;
				time = 0;
			}
			
			 // Chat Reminder:
			var _text = "";
			if(global.remind[0].active){
				_text = "enable boss intros and music";
			}
			else{
				_text = "make sure music is on";
			}
			if(_text != ""){
				trace_color("NT:TE | For the full experience - " + _text + "!", c_yellow);
			}
		}
		
		 // FPS Warning:
		if(room_speed > 30){
			trace_color("NT:TE | WARNING - Playing on higher than 30 FPS will likely cause lag!", c_red);
		}
		
		exit;
	}
	
	 // Color/Alpha-Unblending Shader for Copying Drawn Stuff:
	try{
		if(!null){} // GMS1 only for now
	}
	catch(_error){
		shader_add("Unblend",
			
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
			
			uniform float blendPower;
			
			float4 main(PixelShaderInput INPUT) : SV_TARGET
			{
				float4 RGBA = tex2D(s0, INPUT.vTexcoord);
				if(RGBA.a > 0.0){
					float RGBFactor = pow(abs(RGBA.a), 1.0 - blendPower);
					return float4(
						RGBA.r / RGBFactor,
						RGBA.g / RGBFactor,
						RGBA.b / RGBFactor,
						pow(abs(RGBA.a), blendPower)
					);
				}
				return RGBA;
			}
			"
		);
	}
	
#define cleanup
	 // Reset Starting Weapons:
	loadout_wep_reset();
	//ds_list_destroy(global.loadout_wep_clone);
	
	 // Save Game:
	if(save_auto){
		ntte_save();
	}
	
	 // Clear Surfaces, Shaders, Script Bindings:
	with(ds_map_values(global.surf)) if(surface_exists(surf)) surface_destroy(surf);
	with(ds_map_values(global.shad)) if(shad != -1) shader_destroy(shad);
	with(ds_map_values(global.bind)) with(self) with(id) instance_destroy();
	with(ds_map_values(global.bind_hold)) with(self) if(instance_exists(self)) instance_destroy();
	
	 // No Crash:
	with(ntte_mods.race){
		with(instances_matching([CampChar, CharSelect], "race", self)){
			repeat(8) with(instance_create(random_range(bbox_left, bbox_right + 1), random_range(bbox_top, bbox_bottom + 1), Dust)){
				motion_add(random(360), random(random(8)));
			}
			instance_destroy();
		}
	}
	
#macro call script_ref_call

#macro obj global.obj
#macro scr global.scr
#macro spr global.spr
#macro snd global.snd
#macro msk spr.msk
#macro mus snd.mus
#macro lag global.debug_lag

#macro ntte_vars      global.vars
#macro ntte_mods      global.mods
#macro ntte_mods_call global.mods_call
#macro ntte_version   global.version

#macro spr_path     global.spr_path
#macro spr_load     global.spr_load
#macro spr_load_num 20 // How many sprites to load per frame

#macro shnNone false
#macro shnWep  true
#macro shn8    spr.Shine8
#macro shn10   spr.Shine10
#macro shn12   spr.Shine12
#macro shn16   spr.Shine16
#macro shn20   spr.Shine20
#macro shn24   spr.Shine24
#macro shn64   spr.Shine64
#macro shnHurt spr.ShineHurt
#macro shnSnow spr.ShineSnow

#macro save_data global.save
#macro save_auto global.save_auto
#macro save_path "save.sav"

#macro area_campfire     0
#macro area_desert       1
#macro area_sewers       2
#macro area_scrapyards   3
#macro area_caves        4
#macro area_city         5
#macro area_labs         6
#macro area_palace       7
#macro area_vault        100
#macro area_oasis        101
#macro area_pizza_sewers 102
#macro area_mansion      103
#macro area_cursed_caves 104
#macro area_jungle       105
#macro area_hq           106
#macro area_crib         107

#macro infinity
	/*
		Infinity
		!!! Not supported by some functions in GMS1 versions, like 'min' and 'max'
	*/
	
	1/0
	
#macro game_scale_nonsync
	/*
		The local screen's pixel scale
	*/
	
	game_screen_get_width_nonsync() / game_width
	
#define ntte_init(_ref)
	/*
		Called by NT:TE mods from their 'init' script to run general setup code
	*/
	
	var	_type = _ref[0],
		_name = _ref[1];
		
	 // Set Global Variables:
	with([
		["scr",       scr],
		["obj",       obj],
		["spr",       spr],
		["snd",       snd],
		["debug_lag", false],
		["ntte_vars", ntte_vars],
		["epsilon",   global.epsilon],
		["mod_type",  _type]
	]){
		mod_variable_set(_type, _name, self[0], self[1]);
	}
	
	 // Bind Object Setup Scripts:
	var _list = [];
	for(var _objectIndex = array_length(global.bind_setup_object_list) - 1; _objectIndex >= 0; _objectIndex--){
		if(mod_script_exists(_type, _name, "ntte_setup_" + object_get_name(_objectIndex))){
			array_push(_list, ntte_bind_setup(script_ref_create_ext(_type, _name, "ntte_setup_" + object_get_name(_objectIndex)), _objectIndex));
		}
	}
	global.bind_setup[? _name + "." + _type] = _list;
	
	 // Add to Mod List:
	if(_type in ntte_mods){
		var _list = lq_get(ntte_mods, _type);
		if(array_find_index(_list, _name) < 0){
			array_push(_list, _name);
		}
		
		 // Compile NT:TE Script References:
		if((_name + "." + _type) != "ntte.mod"){
			var _modList = [];
			for(var i = 0; i < lq_size(ntte_mods); i++){
				var _modType = lq_get_key(ntte_mods, i);
				with(lq_get_value(ntte_mods, i)){
					array_push(_modList, _modType + ":" + self);
				}
			}
			for(var i = lq_size(ntte_mods_call) - 1; i >= 0; i--){
				if(mod_script_exists(_type, _name, "ntte_" + lq_get_key(ntte_mods_call, i))){
					var	_refAdd  = [_type, _name],
						_refList = lq_get_value(ntte_mods_call, i);
						
					 // Ensure Consistency Between Mod Reloads:
					for(var j = 0; j < array_length(_refList); j++){
						var _refCur = _refList[j];
						if(array_find_index(_modList, array_join(_refAdd, ":")) < array_find_index(_modList, array_join(_refCur, ":"))){
							_refList[j] = _refAdd;
							_refAdd     = _refCur;
						}
					}
					
					 // Add:
					array_push(_refList, _refAdd);
				}
			}
		}
	}
	
	 // Mod-Specific:
	switch(_type){
		
		case "race":
		
			 // Loadout Fix:
			with(Loadout){
				instance_destroy();
				with(loadbutton){
					instance_destroy();
				}
			}
			
			break;
			
		case "weapon":
		
			 // Weapon Sprite Setup:
			if(fork()){
				wait 0;
				
				var _spr = mod_variable_get(_type, _name, "sprWep");
				
				if(is_real(_spr) && sprite_exists(_spr)){
					 // Wait for Sprite to Load:
					var	_waitMax = 90,
						_waitBox = [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)];
						
					while(_waitMax-- > 0 && array_equals(_waitBox, [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)])){
						wait 0;
					}
					
					 // Locked Weapons:
					if(mod_variable_get(_type, _name, "sprWepLocked") == sprTemp){
						var	_sprX = sprite_get_xoffset(_spr) + 1,
							_sprY = sprite_get_yoffset(_spr) + 1;
							
						with(surface_setup("sprWepLocked", sprite_get_width(_spr) + 2, sprite_get_height(_spr) + 2, 1)){
							surface_set_target(surf);
							draw_clear_alpha(c_black, 0);
							
							with(UberCont){
								 // Outline:
								draw_set_fog(true, c_white, 0, 0);
								for(var _d = 0; _d < 360; _d += 90){
									draw_sprite(_spr, 1, _sprX + dcos(_d), _sprY + dsin(_d));
								}
								
								 // Main:
								draw_set_fog(true, c_black, 0, 0);
								draw_sprite(_spr, 1, _sprX, _sprY);
								draw_set_fog(false, 0, 0, 0);
							}
							
							 // Done:
							surface_reset_target();
							surface_save(surf, name + ".png");
							mod_variable_set(_type, _name, "sprWepLocked", sprite_add_weapon(name + ".png", _sprX, _sprY));
							free = true;
						}
					}
					
					 // Manually Split Bat Disc Sprites:
					var _list = mod_variable_get(_type, _name, "sprWepImage");
					if(is_array(_list) && !array_length(_list)){
						var	_sprX = sprite_get_xoffset(_spr),
							_sprY = sprite_get_yoffset(_spr);
							
						with(surface_setup("sprWepImage", sprite_get_width(_spr), sprite_get_height(_spr), 1)){
							surface_set_target(surf);
							
							 // Load Each Frame as a Weapon Sprite:
							for(var i = 0; i < sprite_get_number(_spr); i++){
								draw_clear_alpha(c_black, 0);
								with(UberCont){
									draw_sprite(_spr, i, _sprX, _sprY);
								}
								surface_save(surf, name + ".png");
								array_push(_list, sprite_add_weapon(name + ".png", _sprX, _sprY));
							}
							
							 // Done:
							surface_reset_target();
							sprite_delete(_spr);
							free = true;
						}
						
						mod_variable_set(_type, _name, "sprWep", _list[array_length(_list) - 1]);
					}
				}
				
				exit;
			}
			
			break;
			
	}
	
#define ntte_cleanup(_ref)
	/*
		Called by NT:TE mods from their 'cleanup' script to execute general unload code
	*/
	
	var	_type = _ref[0],
		_name = _ref[1];
		
	 // Remove NT:TE Script References:
	for(var i = lq_size(ntte_mods_call) - 1; i >= 0; i--){
		var	_list    = lq_get_value(ntte_mods_call, i),
			_listNew = [];
			
		with(_list){
			if(self[0] != _type || self[1] != _name){
				array_push(_listNew, self);
			}
		}
		
		if(!array_equals(_list, _listNew)){
			lq_set(ntte_mods_call, lq_get_key(ntte_mods_call, i), _listNew);
		}
	}
	
	 // Unbind Scripts:
	var _bindKey = _name + ":" + _type;
	if(ds_map_exists(global.bind, _bindKey)){
		global.bind_hold[? _bindKey] = [];
		with(global.bind[? _bindKey]){
			with(id){
				script = [];
				array_push(global.bind_hold[? _bindKey], self);
			}
		}
		ds_map_delete(global.bind, _bindKey);
	}
	
	 // Unbind Object Setup Scripts:
	var _bindKey = _name + "." + _type;
	if(ds_map_exists(global.bind_setup, _bindKey)){
		with(global.bind_setup[? _bindKey]){
			ntte_unbind(self);
		}
		ds_map_delete(global.bind_setup, _bindKey);
	}
	
	 // Race Mod Loadout Fix:
	if(_type == "race"){
		with(Loadout){
			instance_destroy();
			with(loadbutton){
				instance_destroy();
			}
		}
	}
	
#define ntte_save()
	/*
		Sends NT:TE's save data to the save file
	*/
	
	string_save(json_encode(save_data), save_path);
	
#define save_get(_name, _default)
	/*
		Returns the value stored at the given name in NTTE's save file
		Returns the given default value if nothing was found
		
		Ex:
			save_get("option:shaders")
			save_get("stat:pet:Baby.examplepet.mod:found")
	*/
	
	var _save = save_data;
	
	with(string_split(_name, ":")){
		if(self not in _save){
			return _default;
		}
		_save = lq_get(_save, self);
	}
	
	return _save;
	
#define save_set(_name, _value)
	/*
		Stores the given value at the given name in NTTE's save file
		
		Ex:
			save_set("stat:time", save_get("stat:time") + 1)
			save_set("unlock:coolWeapon", true)
	*/
	
	var	_path = string_split(_name, ":"),
		_save = save_data;
		
	with(array_slice(_path, 0, array_length(_path) - 1)){
		if(!is_object(lq_get(_save, self))){
			lq_set(_save, self, {});
		}
		_save = lq_get(_save, self);
	}
	
	lq_set(_save, _path[array_length(_path) - 1], _value);
	
#define option_get(_name)
	/*
		Returns the value associated with a given option's name, which may be altered from the raw value for simpler usage
		Returns 1 if nothing was found
		
		Ex:
			option_get("shaders")
	*/
	
	var _value = save_get("option:" + _name, 1);
	
	 // Type-Specific Conditions:
	var _split = string_split(_name, ":");
	switch(_split[0]){
		case "intros": // Auto Intros
			if(_value >= 2){
				_value = (UberCont.opt_bossintros == true);
			}
			break;
			
		case "outline": // Auto Outlines
			if(_value >= 2){
				var _local = player_find_local_nonsync();
				_value = (
					player_is_active(_local)
					? player_get_outlines(_local)
					: false
				);
			}
			break;
			
		case "quality": // Surface Quality
			_value = lerp(1/3, game_scale_nonsync, _value);
			break;
	}
	
	return _value;
	
#define option_set(_name, _value)
	/*
		Sets the given option to the given value
		
		Ex:
			option_set("shaders", false)
	*/
	
	save_set("option:" + _name, _value);
	
#define stat_get(_name)
	/*
		Returns the value associated with a given stat's name
		Returns 0 if nothing was found
		
		Ex:
			stat_get("time")
	*/
	
	var _default = 0;
	
	 // Old Stat Names:
	switch(_name){
		case "race:parrot:best:area" : _default = stat_get("race:parrot:bestArea"); break;
		case "race:parrot:best:kill" : _default = stat_get("race:parrot:bestKill"); break;
		
		default:
			if(string_pos("found:", _name) == 1){
				_default = unlock_get(string_replace(_name, ":", "(") + ")");
			}
	}
	
	return save_get("stat:" + _name, _default);
	
#define stat_set(_name, _value)
	/*
		Sets the given stat to the given value
		
		Ex:
			stat_set("time", stat_get("time") + 1)
	*/
	
	save_set("stat:" + _name, _value);
	
#define unlock_get(_name)
	/*
		Returns the value associated with a given unlock's name
		Returns 'false' if nothing was found
		
		Ex:
			unlock_get("race:parrot")
	*/
	
	var _default = false;
	
	 // Old Unlock Names:
	switch(_name){
		case "race:parrot"         : _default = unlock_get("parrot");     break;
		case "skin:parrot:1"       : _default = unlock_get("parrotB");    break;
		case "pack:coast"          : _default = unlock_get("coastWep");   break;
		case "pack:oasis"          : _default = unlock_get("oasisWep");   break;
		case "pack:trench"         : _default = unlock_get("trenchWep");  break;
		case "pack:lair"           : _default = unlock_get("lairWep");    break;
		case "crown:crime"         : _default = unlock_get("lairCrown");  break;
		case "loadout:crown:crime" : _default = unlock_get("crownCrime"); break;
		case "wep:trident"         : _default = unlock_get("trident");    break;
		case "wep:scythe"          : _default = unlock_get("boneScythe"); break;
	}
	
	return save_get("unlock:" + _name, _default);
	
#define unlock_set(_name, _value)
	/*
		Sets the given unlock to the given value
		Plays unlock FX if the given value isn't already equal to the the unlock's value
		Returns 'true' if the unlock was set to a new value, 'false' otherwise
		
		Layout:
			pack    : Unlocks multiple things
			race    : Unlocks a character
			skin    : Unlocks a skin
			wep     : Unlocks a weapon
			crown   : Unlocks a crown (to appear in the crown vault)
			loadout : Unlocks an item on the loadout menu
			
		Ex:
			unlock_set("pack:lair",           true)
			unlock_set("race:parrot",         true)
			unlock_set("skin:red crystal",    true) // for skin mods
			unlock_set("skin:parrot:1",       true) // for race mods
			unlock_set("crown:crime",         false)
			unlock_set("loadout:crown:crime", false)
	*/
	
	if(unlock_get(_name) != _value){
		save_set("unlock:" + _name, _value);
		
		 // Unlock FX:
		if("unlock_get_name" in scr){
			var _unlockName = call(scr.unlock_get_name, _name);
			if(_unlockName != ""){
				var	_unlocked     = (!is_real(_value) || _value),
					_unlockText   = (_unlocked ? call(scr.unlock_get_text, _name) : "LOCKED"),
					_unlockSprite = -1,
					_unlockSound  = -1,
					_split        = string_split(_name, ":");
					
				 // Type-Specifics:
				if(array_length(_split) >= 2){
					switch(_split[0]){
						
						case "pack": // PACK
							
							sound_play(_unlocked ? sndGoldUnlock : sndCursedChest);
							
							break;
							
						case "race": // CHARACTER
							
							sound_play_pitchvol(_unlocked ? sndGoldUnlock : sndCursedChest, 0.9, 0.9);
							
							if(_unlocked){
								var _race = _split[1];
								_unlockSprite = mod_script_call("race", _race, "race_portrait", 0, 0);
								_unlockSound  = mod_script_call("race", _race, "race_menu_confirm");
							}
							
							break;
							
						case "skin": // SKIN
							
							sound_play(_unlocked ? sndMenuBSkin : sndMenuASkin);
							
							if(_unlocked){
								var	_race = "",
									_skin = _split[1];
								
								 // Race Mod:
								if(array_length(_split) > 2){
									_race         = _skin;
									_skin         = real(_split[2]);
									_unlockSprite = mod_script_call("race", _race, "race_portrait", 0, _skin);
								}
								
								 // Skin Mod:
								else if(mod_exists("skin", _skin)){
									_race         = mod_script_call("skin", _skin, "skin_race");
									_unlockSprite = mod_script_call("skin", _skin, "skin_portrait", 0);
								}
								
								 // Sound:
								_unlockSound = mod_script_call("race", _race, "race_menu_confirm");
							}
							
							break;
							
						case "loadout": // LOADOUT
							
							if(_split[1] == "wep"){
								sound_play(_unlocked ? sndGoldUnlock : sndCursedChest);
							}
							
							break;
							
					}
				}
				if(!is_real(_unlockSprite)) _unlockSprite = -1;
				if(!is_real(_unlockSound )) _unlockSound  = -1;
				
				 // Splat:
				with(call(scr.unlock_splat, _unlockName, _unlockText, _unlockSprite, _unlockSound)){
					 // Append "-SKIN" to GameOver Splat:
					if(array_length(_split) >= 2 && _split[1] == "skin"){
						with(_unlockSplat){
							nam[0] += "-SKIN";
						}
					}
					
					 // UNLOCKED:
					if(is_real(_value) && _value){
						nam[0] += " UNLOCKED";
					}
				}
			}
		}
		
		return true;
	}
	
	return false;
	
#define surface_setup(_name, _w, _h, _scale)
	/*
		Assigns a surface to the given name and stores it in 'global.surf' for future calls
		Automatically recreates the surface it doesn't exist or match the given width/height
		Destroys the surface if it hasn't been used for 30 frames, to free up memory
		Returns a LWO containing the surface itself and relevant vars
		
		Args:
			name  - The name used to store & retrieve the shader
			w, h  - The width/height of the surface
			        Use 'null' to not update the surface's width/height
			scale - The scale or quality of the surface
			        Use 'null' to not update the surface's scale
			
		Vars:
			name  - The name used to store & retrieve the surface
			surf  - The surface itself
			time  - # of frames until the surface is destroyed, not counting when the game is paused
			        Is set to 30 frames by default, set -1 to disable the timer
			free  - Set to 'true' if you aren't going to use this surface anymore (removes it from the list when 'time' hits 0)
			reset - Is set to 'true' when the surface is created or the game pauses
			scale - The scale or quality of the surface
			w, h  - The drawing width/height of the surface
			x, y  - The drawing position of the surface, you can set this manually
			
		Ex:
			with(surface_setup("Test", game_width, game_height, game_scale_nonsync)){
				x = view_xview_nonsync;
				y = view_yview_nonsync;
				
				 // Setup:
				if(reset){
					reset = false;
					surface_set_target(surf);
					draw_clear_alpha(c_black, 0);
					draw_circle((w / 2) * scale, (h / 2) * scale, 50 * scale, false);
					surface_reset_target();
				}
				
				 // Draw Surface:
				draw_surface_scale(surf, x, y, 1 / scale);
			}
	*/
	
	 // Retrieve Surface:
	if(!mod_variable_exists("mod", mod_current, "surf")){
		global.surf = ds_map_create();
	}
	var _surf = global.surf[? _name];
	
	 // Initialize Surface:
	if(_surf == undefined){
		_surf = {
			"name"  : _name,
			"surf"  : -1,
			"time"  : 0,
			"reset" : false,
			"free"  : false,
			"scale" : 1,
			"w"     : 1,
			"h"     : 1,
			"x"     : 0,
			"y"     : 0
		};
		global.surf[? _name] = _surf;
		
		 // Auto-Management:
		if(fork()){
			with(_surf){
				while(true){
					 // Deactivate Unused Surfaces:
					if((time > 0 || free) && --time <= 0){
						time = 0;
						if(surface_exists(surf)){
							surface_destroy(surf);
						}
						
						 // Remove From List:
						if(free){
							ds_map_delete(global.surf, name);
							break;
						}
					}
					
					 // Game Paused:
					else{ var i = 0; repeat(maxp){
						if(button_pressed(i++, "paus")){
							reset = true;
							break;
						}
					}}
					
					wait 0;
				}
			}
			exit;
		}
	}
	
	 // Surface Setup:
	with(_surf){
		if(is_real(_w    )) w     = _w;
		if(is_real(_h    )) h     = _h;
		if(is_real(_scale)) scale = _scale;
		
		 // Create / Resize Surface:
		if(
			!surface_exists(surf)
			|| surface_get_width(surf)  != max(1, w * scale)
			|| surface_get_height(surf) != max(1, h * scale)
		){
			if(surface_exists(surf)){
				surface_destroy(surf);
			}
			surf = surface_create(max(1, w * scale), max(1, h * scale));
			reset = true;
		}
		
		 // Active For 30 Frames:
		if(time >= 0){
			time = max(time, 30);
		}
	}
	
	return _surf;
	
#define shader_setup(_name, _texture, _args)
	/*
		Performs general and shader-specific setup code, and enables the given shader
		Returns 'true' if the shader exists and was enabled for drawing, 'false' otherwise
		Use 'shader_add()' to initialize the shader before calling this script
		
		Args:
			name    - The name used to store & retrieve the shader
			texture - The texture to stage for drawing with the shader
			args    - An array of arguments for shader-specific setup
			
		Ex:
			if(shader_setup("Charm", sprite_get_texture(_spr, _img), [])){
				draw_sprite(_spr, _img, x, y);
				shader_reset();
			}
	*/
	
	if(mod_variable_exists("mod", mod_current, "shad") && ds_map_exists(global.shad, _name)){
		if(global.shad_active == ""){
			global.shad_active = _name;
		}
		with(global.shad[? _name]){
			if(shad != -1){
				 // Enable Shader & Stage Texture:
				shader_set(shad);
				texture_set_stage(0, _texture);
				
				 // Matrix:
				shader_set_vertex_constant_f(0, matrix_multiply(matrix_multiply(matrix_get(matrix_world), matrix_get(matrix_view)), matrix_get(matrix_projection)));
				
				 // Shader-Specific:
				switch(name){
					case "Charm":
						shader_set_fragment_constant_f(0, [1 / _args[0], 1 / _args[1]]);
						break;
						
					case "SludgePool":
						var _color = _args[2];
						shader_set_fragment_constant_f(0, [1 / _args[0], 1 / _args[1]]);
						shader_set_fragment_constant_f(1, [color_get_red(_color) / 255, color_get_green(_color) / 255, color_get_blue(_color) / 255]);
						break;
						
					case "Unblend":
						shader_set_fragment_constant_f(0, [1 / power(2, _args[0])]);
						break;
				}
				
				return true;
			}
		}
	}
	
	return false;
	
#define shader_add(_name, _vertex, _fragment)
	/*
		Initializes and stores a shader in the global shader list
		To prevent crashes, the shader is not created until the 'Menu' object no longer exists and the player has shaders enabled in NTTE's options
		Returns a LWO containing the shader itself and relevant vars
		
		Args:
			name     - The name used to store & retrieve the shader
			vertex   - The shader's vertex code
			fragment - The shader's fragment code
			
		Vars:
			name - The name used to store & retrieve the shader
			shad - The shader itself
			vert - The shader's vertex code
			frag - The shader's fragment code
			
		Ex:
			shader_add("Charm", "VERTEX SHADER CODE", "FRAGMENT SHADER CODE");
	*/
	
	 // Retrieve Shader:
	if(!mod_variable_exists("mod", mod_current, "shad")){
		global.shad = ds_map_create();
	}
	var _shad = global.shad[? _name];
	
	 // Initialize Shader:
	if(_shad == undefined){
		var _beta = false;
		
		 // Partial Beta Fix:
		try{
			if(!null){
				_beta = true;
			}
		}
		catch(_error){}
		
		 // Add:
		_shad = {
			"name" : _name,
			"shad" : -1,
			"vert" : _vertex,
			"frag" : _fragment
		};
		global.shad[? _name] = _shad;
		
		 // Auto-Management:
		if(fork()){
			with(_shad){
				while(true){
					 // Create Shaders:
					if(option_get("shaders") && (!_beta || (global.shad_active == name && !instance_exists(Menu)))){
						if(shad == -1 && !instance_exists(Menu)){
							try{
								// GMS2
								shad = script_execute(
									shader_create,
									string_replace_all(string_replace_all(vert, "matrix_world_view_projection;", "_gm_Matrices[5];"), "matrix_world_view_projection", "transpose(_gm_Matrices[4])"),
									frag,
									shader_kind_hlsl
								);
							}
							catch(_error){
								// GMS1
								shad = shader_create(vert, frag);
							}
						}
					}
					
					 // Shaders Disabled:
					else{
						if(shad != -1){
							shader_destroy(shad);
							shad = -1;
						}
						if(global.shad_active == name){
							global.shad_active = "";
						}
					}
					
					wait 0;
				}
			}
			exit;
		}
	}
	
	 // Shader Reset:
	else with(_shad){
		if(shad != -1){
			shader_destroy(shad);
			shad = -1;
		}
		vert = _vertex;
		frag = _fragment;
	}
	
	return _shad;
	
#define script_bind(_modRef, _scriptObj, _scriptRef, _depth, _visible)
	/*
		Binds the given script to the given event
		Automatically ensures that the script object always exists, and deletes it when the parent mod is unloaded
		
		Args:
			scriptObj - The event type: CustomStep, CustomBeginStep, CustomEndStep, CustomDraw
			scriptRef - The script's reference to call
			depth     - The script's default depth
			visible   - The script's default visibility, basically "will this event run all the time"
			
		Ex:
			script_bind(script_ref_create(0), CustomDraw, script_ref_create(draw_thing, true), -8, true)
	*/
	
	var	_bindKey = _modRef[1] + ":" + _modRef[0],
		_bind    = {
			"object"  : _scriptObj,
			"script"  : _scriptRef,
			"depth"   : _depth,
			"visible" : _visible,
			"id"      : noone
		};
		
	 // Storage Setup:
	if(!ds_map_exists(global.bind, _bindKey)){
		global.bind[? _bindKey] = [];
	}
	
	 // Controller Setup / Retrieval:
	var	_bindHold    = (ds_map_exists(global.bind_hold, _bindKey) ? global.bind_hold[? _bindKey] : []),
		_bindHoldPos = array_length(global.bind[? _bindKey]);
		
	if(_bindHoldPos >= 0 && _bindHoldPos < array_length(_bindHold) && instance_exists(_bindHold[_bindHoldPos])){
		_bind.id = _bindHold[_bindHoldPos];
	}
	else{
		_bind.id = instance_create(0, 0, _bind.object);
		with(_bind.id){
			depth      = _bind.depth;
			visible    = _bind.visible;
			persistent = true;
		}
	}
	with(_bind.id){
		script = _bind.script;
	}
	
	 // Store:
	array_push(global.bind[? _bindKey], _bind);
	
	return _bind;
	
//#define ntte_bind_step(_scriptRef)
//	/*
//		
//	*/
//	
//	_scriptRef = array_clone(_scriptRef);
//	
//	
//	return _scriptRef;
//	
//#define ntte_bind_begin_step(_scriptRef)
//	/*
//		
//	*/
//	
//	_scriptRef = array_clone(_scriptRef);
//	
//	
//	return _scriptRef;
//	
//#define ntte_bind_end_step(_scriptRef)
//	/*
//		
//	*/
//	
//	_scriptRef = array_clone(_scriptRef);
//	
//	
//	return _scriptRef;
//	
//#define ntte_bind_draw(_scriptRef, _depth)
//	/*
//		
//	*/
//	
//	_scriptRef = array_clone(_scriptRef);
//	
//	
//	return _scriptRef;
//	
#define ntte_bind_setup(_scriptRef, _obj)
	/*
		Binds the given script reference to a setup event for the given object
		Calls the script with an array of newly created instances of that object
		The array can be empty, as other setup scripts may destroy the instances
	*/
	
	_scriptRef = array_clone(_scriptRef);
	
	var	_objectRefList   = global.bind_setup_object_list,
		_objectChildList = array_create(array_length(_objectRefList), noone);
		
	 // Link Objects to Their Children:
	for(var i = array_length(_objectChildList) - 1; i >= 0; i--){
		var _parent = object_get_parent(i);
		if(object_exists(_parent)){
			var _childList = _objectChildList[_parent];
			if(_childList == noone){
				_childList                = [];
				_objectChildList[_parent] = _childList;
			}
			array_push(_childList, i);
		}
	}
	
	 // Link Script Reference to Object(s) & Their Children:
	var	_objectIndex   = 0,
		_objectList    = (is_array(_obj) ? array_clone(_obj) : [_obj]),
		_objectListMax = array_length(_objectList);
		
	while(_objectIndex < _objectListMax){
		var	_object    = _objectList[_objectIndex++],
			_childList = _objectChildList[_object],
			_refList   = _objectRefList[_object];
			
		 // Add Children to List:
		if(_childList != noone){
			with(_childList){
				if(array_find_index(_objectList, self) < 0){
					array_push(_objectList, self);
					_objectListMax++;
				}
			}
		}
		
		 // Store Script Reference:
		if(_refList == noone){
			_refList                = [];
			_objectRefList[_object] = _refList;
		}
		array_push(_refList, _scriptRef);
	}
	
	return _scriptRef;
	
#define ntte_unbind(_ref)
	/*
		Unbinds the given NT:TE script reference from its event
	*/
	
	var _objectIndex = 0;
	
	with(global.bind_setup_object_list){
		if(self != noone){
			var _refList = call(scr.array_delete_value, self, _ref);
			global.bind_setup_object_list[_objectIndex] = (
				array_length(_refList)
				? _refList
				: noone
			);
		}
		_objectIndex++;
	}
	
#define spr_path_set(_path)
	spr_path = "sprites/";
	spr_path_add(_path);
	
#define spr_path_add(_path)
	var	_pathIndex    = 0,
		_pathSplit    = string_split(_path, "/"),
		_sprPathSplit = string_split(spr_path, "/");
		
	repeat(array_length(_pathSplit)){
		var _pathItem = _pathSplit[_pathIndex];
		if(_pathItem == ".."){
			_sprPathSplit = array_slice(_sprPathSplit, 0, array_length(_sprPathSplit) - 1);
			_sprPathSplit[array_length(_sprPathSplit) - 1] = "";
		}
		else{
			_sprPathSplit[array_length(_sprPathSplit) - 1] += _pathItem;
			if(_pathIndex < array_length(_pathSplit) - 1){
				array_push(_sprPathSplit, "");
			}
		}
		_pathIndex++;
	}
	
	spr_path = array_join(_sprPathSplit, "/");
	
#define spr_add /// spr_add(_path, _img, _x, _y, _shine = shnNone)
	var _path = argument[0], _img = argument[1], _x = argument[2], _y = argument[3];
var _shine = argument_count > 4 ? argument[4] : shnNone;
	
	spr_load = [[spr, 0]];
	
	return {
		"path"  : spr_path + _path,
		"img"   : _img,
		"x"     : _x,
		"y"     : _y,
		"ext"   : "png",
		"mask"  : [],
		"shine" : _shine
	};
	
#define trace_error(_error)
	//trace(_error);
	//trace_color(" ^ Screenshot that error and post it on NT:TE's itch.io page, thanks!", c_yellow);
	
#define game_start
	 // Autosave:
	if(save_auto){
		ntte_save();
	}
	
	 // Reset Active Shader (Beta Fix):
	global.shad_active = "";
	
#define step
	if(lag) trace_time();
	
	 // Sprite Loading:
	if(array_length(spr_load)){
		repeat(spr_load_num){
			while(array_length(spr_load)){
				var	_num   = array_length(spr_load) - 1,
					_load  = null,
					_list  = spr_load[_num, 0],
					_index = spr_load[_num, 1];
					
				spr_load[_num, 1]++;
				
				 // Grab Value:
				if(is_array(_list)){
					if(_index < array_length(_list)){
						_load = _list[_index];
					}
				}
				else if(is_object(_list)){
					if(_index < lq_size(_list)){
						_load = lq_get_value(_list, _index);
					}
				}
				else if(ds_map_valid(_list)){
					if(_index < ds_map_size(_list)){
						_load = ds_map_values(_list)[_index];
					}
				}
				
				 // Process Value:
				if(_load != undefined){
					 // Load Sprites:
					if(is_object(_load) && "path" in _load){
						var	_spr    = mskNone,
							_img    = lq_defget(_load, "img",   1),
							_x      = lq_defget(_load, "x",     0),
							_y      = lq_defget(_load, "y",     0),
							_ext    = lq_defget(_load, "ext",   "png"),
							_mask   = lq_defget(_load, "mask",  []),
							_shine  = lq_defget(_load, "shine", shnNone),
							_path   = _load.path + "." + _ext;
							
						if(fork()){
							switch(_shine){
								case shnWep: // Basic Shine
									_spr = sprite_add_weapon(_path, _x, _y);
									break;
									
								default:
									_spr = sprite_add(_path, _img, _x, _y);
									
									 // Semi-Manual Shine (sprite_add_weapon is wack with taller sprites)
									if(_shine != shnNone && sprite_exists(_shine)){
										 // Wait for Sprite to Load:
										var	_waitMax = 90,
											_waitBox = [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)];
											
										while(_waitMax-- > 0 && array_equals(_waitBox, [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)])){
											wait 0;
										}
										
										 // Add Shine:
										var _lastSpr = _spr;
										_spr = sprite_shine(_spr, _shine);
										sprite_delete(_lastSpr);
									}
							}
							
							 // Store Sprite:
							if(is_array(_list)){
								_list[_index] = _spr;
							}
							else if(is_object(_list)){
								lq_set(_list, lq_get_key(_list, _index), _spr);
							}
							else if(ds_map_valid(_list)){
								_list[? ds_map_keys(_list)[_index]] = _spr;
							}
							
							 // Precise Hitboxes:
							if(array_length(_mask) > 0){
								 // Wait for Sprite to Load:
								var	_waitMax = 90,
									_waitBox = [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)];
									
								while(_waitMax-- > 0 && array_equals(_waitBox, [sprite_get_bbox_left(_spr), sprite_get_bbox_top(_spr), sprite_get_bbox_right(_spr), sprite_get_bbox_bottom(_spr)])){
									wait 0;
								}
								
								 // Collision Time:
								while(array_length(_mask) < 9){
									array_push(_mask, 0);
								}
								sprite_collision_mask(_spr, _mask[0], _mask[1], _mask[2], _mask[3], _mask[4], _mask[5], _mask[7], _mask[8]);
							}
							
							exit;
						}
						
						break;
					}
					
					 // Search Deeper:
					else array_push(spr_load, [_load, 0]);
				}
				
				 // Go Back:
				else spr_load = array_slice(spr_load, 0, _num);
			}
		}
	}
	
	 // Ensure Script Bindings Exist:
	with(ds_map_values(global.bind)){
		with(self){
			if(!instance_exists(id)){
				id = instance_create(0, 0, object);
				with(id){
					script     = other.script;
					depth      = other.depth;
					visible    = other.visible;
					persistent = true;
					if(depth == object_get_depth(SubTopCont)){
						if(fork()){
							wait 0;
							with(SubTopCont){
								instance_create(0, 0, SubTopCont);
								instance_destroy();
							}
							exit;
						}
					}
				}
			}
		}
	}
	
	 // Autosave (Return to Character Select):
	if(save_auto){
		with(instances_matching([Menu, GenCont], "ntte_autosave", null)){
			ntte_autosave = true;
			ntte_save();
		}
	}
	
	if(lag) trace_time(mod_current + "_step");
	
#define draw_pause
	 // Remind Player:
	if(option_get("reminders")){
		var _timeTick = 1;
		with(global.remind){
			if(active){
				var	_x = (game_width  / 2),
					_y = (game_height / 2) - 40;
					
				 // Reminding:
				if(instance_exists(object)){
					_x += x;
					_y += y;
					
					if(time > 0){
						time -= _timeTick * current_time_scale;
						_timeTick = 0;
						
						 // Done:
						if(time <= 0){
							active = false;
							
							 // Text:
							text_inst          = instance_create(_x, _y, PopupText);
							text_inst.text     = text;
							text_inst.friction = 0.1;
						}
					}
				}
				
				 // Lead Player to Button:
				else{
					time = 20;
					
					 // Settings Screen:
					if(instance_exists(OptionMenuButton)){
						_x -= 38;
						switch(object){
							case VisualsMenuButton:
								_y += 24;
								break;
								
							case GameMenuButton:
								_y += 48;
								break;
								
							case ControlMenuButton:
								_x -= 26;
								_y += 72;
								break;
						}
					}
					
					 // Main Pause Screen:
					else if(instance_number(PauseButton) > 2){
						var _break = false;
						with(PauseButton){
							if(alarm_get(0) > 0){
								_break = true;
							}
						}
						if(_break) break;
						
						_x = game_width  - 124;
						_y = game_height - 78;
					}
					
					else continue;
				}
				
				 // Draw Icon:
				with(other){
					draw_sprite(sprNew, 0, view_xview_nonsync + _x, view_yview_nonsync + _y + sin(current_frame / 10));
				}
			}
			
			 // Draw Text:
			if(instance_exists(text_inst)){
				_timeTick = 0.5;
				
				draw_set_font(fntM);
				draw_set_halign(fa_center);
				draw_set_valign(fa_top);
				with(instances_matching(text_inst, "visible", true)){
					draw_text_nt(view_xview_nonsync + x, view_yview_nonsync + y, text);
				}
			}
		}
	}
	
#define sprite_shine(_spr, _shine)
	/*
		Returns a new sprite made by overlaying the given shine sprite on top of the other given normal sprite
	*/
	
	var	_sprX   = sprite_get_xoffset(_spr),
		_sprY   = sprite_get_yoffset(_spr),
		_sprW   = sprite_get_width(_spr),
		_sprH   = sprite_get_height(_spr),
		_sprImg = max(sprite_get_number(_spr), sprite_get_number(_shine)),
		_shineW = sprite_get_width(_shine),
		_shineH = sprite_get_height(_shine);
		
	_sprX += max(0, floor((_shineW - _sprW) / 2));
	_sprY += max(0, floor((_shineH - _sprH) / 2));
	
	_sprW = max(_sprW, _shineW);
	_sprH = max(_sprH, _shineH);
	
	with(surface_setup("sprShine", _sprW * _sprImg, _sprH, 1)){
		surface_set_target(surf);
		draw_clear_alpha(c_black, 0);
		
		with(UberCont){
			for(var _img = 0; _img < _sprImg; _img++){
				var _x = _sprW * _img;
				
				 // Normal Sprite:
				draw_sprite(_spr, _img, _x + _sprX, _sprY);
				
				 // Overlay Shine:
				draw_set_color_write_enable(true, true, true, false);
				draw_sprite_stretched(_shine, _img, _x, 0, _sprW, _sprH);
				draw_set_color_write_enable(true, true, true, true);
			}
		}
		
		 // Done:
		surface_reset_target();
		free = true;
		
		 // Add Sprite:
		surface_save(surf, name + ".png");
		return sprite_add(name + ".png", _sprImg, _sprX, _sprY);
	}
	
#define weapon_sprite_list_merge(_wepSpriteList)
	/*
		Returns a sprite of slices from the given weapon sprites combined sequentially
	*/
	
	var	_mergeWepSpriteName = array_join(_wepSpriteList, ":"),
		_mergeWepSprite     = ds_map_find_value(spr.MergeWep, _mergeWepSpriteName);
		
	 // Initial Setup:
	if(_mergeWepSprite == undefined || !sprite_exists(_mergeWepSprite)){
		if(array_length(_wepSpriteList) == 1){
			return _wepSpriteList[0];
		}
		
		var	_mergeStockSlice        = undefined,
			_mergeFrontSlice        = undefined,
			_mergeWepSpriteY1       =  infinity,
			_mergeWepSpriteY2       = -infinity,
			_mergeWepSpriteWidth    = 0,
			_mergeWepSpriteImageNum = 0,
			_mergeWepSpriteList     = ds_map_values(spr.MergeWep),
			_mergeWepSpriteKeyList  = ds_map_keys(spr.MergeWep);
			
		 // Ensure Sprites Are Loaded:
		with(_wepSpriteList){
			var _sprite = self;
			if(
				   sprite_get_number(_sprite)      == 1
				&& sprite_get_width(_sprite)       == 16
				&& sprite_get_height(_sprite)      == 16
				&& sprite_get_bbox_left(_sprite)   == 15
				&& sprite_get_bbox_top(_sprite)    == 15
				&& sprite_get_bbox_right(_sprite)  == 0
				&& sprite_get_bbox_bottom(_sprite) == 0
			){
				var _spriteLoadingDelayFrame = ds_map_find_value(global.sprite_loading_delay_frame, _sprite);
				if(_spriteLoadingDelayFrame == undefined){
					_spriteLoadingDelayFrame = current_frame + 30;
					global.sprite_loading_delay_frame[? _sprite] = _spriteLoadingDelayFrame;
				}
				if(_spriteLoadingDelayFrame > current_frame){
					return mskNone;
				}
			}
		}
		
		 // Unmerge Merged Sprites:
		while(true){
			var _newWepSpriteList = [];
			with(_wepSpriteList){
				var _mergeWepSpriteIndex = array_find_index(_mergeWepSpriteList, self);
				if(_mergeWepSpriteIndex >= 0){
					with(string_split(_mergeWepSpriteKeyList[_mergeWepSpriteIndex], ":")){
						array_push(_newWepSpriteList, real(self));
					}
				}
				else array_push(_newWepSpriteList, self);
			}
			if(array_equals(_wepSpriteList, _newWepSpriteList)){
				break;
			}
			else{
				_wepSpriteList = _newWepSpriteList;
			}
		}
		_mergeWepSprite = ds_map_find_value(spr.MergeWep, array_join(_wepSpriteList, ":"));
		
		 // Generate Sprite:
		if(_mergeWepSprite == undefined || !sprite_exists(_mergeWepSprite)){
			 // Setup Sprite Slices:
			var	_wepSpriteNum   = 0,
				_wepSpriteCount = array_length(_wepSpriteList);
				
			with(_wepSpriteList){
				var _mergeSlice = {
					"sprite_index"   : self,
					"sprite_width"   : sprite_get_width(self),
					"sprite_height"  : sprite_get_height(self),
					"sprite_xoffset" : sprite_get_xoffset(self),
					"sprite_yoffset" : sprite_get_yoffset(self),
					"sprite_bbox_y1" : sprite_get_bbox_top(self)        - sprite_get_yoffset(self),
					"sprite_bbox_y2" : sprite_get_bbox_bottom(self) + 1 - sprite_get_yoffset(self),
					"image_number"   : sprite_get_number(self),
					"x1"             : 0,
					"x2"             : 0,
					"next_slice"     : undefined
				};
				
				 // Manual Adjustments:
				switch(self){
					case sprToxicBow:
						_mergeSlice.sprite_yoffset += 2;
						break;
						
					case sprSuperCrossbow:
					case sprGatlingSlugger:
						_mergeSlice.sprite_yoffset += 1;
						break;
						
					case sprAutoShotgun:
					case sprPartyGun:
						_mergeSlice.sprite_yoffset -= 1;
						break;
						
					case mskNone:
						_mergeSlice.sprite_height  = 1;
						_mergeSlice.sprite_yoffset = 0;
						_mergeSlice.sprite_bbox_y1 = infinity;
						_mergeSlice.sprite_bbox_y2 = infinity * ((_wepSpriteNum > 0) ? 1 : -1);
						_mergeSlice.x2             = 3;
						break;
				}
				
				 // Determine Slice Dimensions:
				if(self != mskNone){
					var	_sliceX1 = sprite_get_bbox_left(self) + 1,
						_sliceX3 = sprite_get_bbox_right(self),
						_sliceX2 = round(lerp(_sliceX1, _sliceX3, 0.4));
						
					for(var _sliceSide = 0; _sliceSide <= 1; _sliceSide++){
						var _sliceX = 0;
						if(_wepSpriteNum == (_wepSpriteCount - 1) * _sliceSide){
							_sliceX = _mergeSlice.sprite_width * _sliceSide;
						}
						else{
							var _sliceAmount = (_wepSpriteNum / _wepSpriteCount) + (_sliceSide / min(2, _wepSpriteCount));
							_sliceX = ceil(lerp(
								lerp(
									_sliceX1,
									_sliceX2,
									clamp(2 * _sliceAmount, 0, 1)
								),
								_sliceX3,
								clamp(2 * (_sliceAmount - 0.5), 0, 1)
							));
						}
						lq_set(_mergeSlice, `x${_sliceSide + 1}`, _sliceX);
					}
				}
				
				 // Merged Sprite Dimensions:
				var _mergeSliceSpriteY1 = -_mergeSlice.sprite_yoffset,
					_mergeSliceSpriteY2 = _mergeSliceSpriteY1 + _mergeSlice.sprite_height;
					
				if(_mergeSliceSpriteY1 < _mergeWepSpriteY1) _mergeWepSpriteY1 = _mergeSliceSpriteY1;
				if(_mergeSliceSpriteY2 > _mergeWepSpriteY2) _mergeWepSpriteY2 = _mergeSliceSpriteY2;
				
				_mergeWepSpriteWidth += _mergeSlice.x2 - _mergeSlice.x1;
				
				 // Merged Sprite Frame Count:
				if(_mergeSlice.image_number > _mergeWepSpriteImageNum){
					_mergeWepSpriteImageNum = _mergeSlice.image_number;
				}
				
				 // Add to List:
				if(_mergeFrontSlice == undefined){
					_mergeStockSlice = _mergeSlice;
				}
				else{
					_mergeFrontSlice.next_slice = _mergeSlice;
				}
				_mergeFrontSlice = _mergeSlice;
				_wepSpriteNum++;
			}
			
			 // Create Merged Sprite:
			var	_mergeWepSpriteHeight  = _mergeWepSpriteY2 - _mergeWepSpriteY1,
				_mergeWepSpriteXOffset = _mergeStockSlice.sprite_xoffset,
				_mergeWepSpriteYOffset = -_mergeWepSpriteY1;
				
			with(surface_setup(
				"sprMerge",
				_mergeWepSpriteWidth * _mergeWepSpriteImageNum,
				_mergeWepSpriteHeight,
				1
			)){
				free = true;
				
				surface_set_target(surf);
				draw_clear_alpha(c_black, 0);
				
					for(var _outline = 1; _outline >= 0; _outline--){
						for(var _mergeWepSpriteImage = 0; _mergeWepSpriteImage < _mergeWepSpriteImageNum; _mergeWepSpriteImage++){
							var	_slice        = _mergeStockSlice,
								_sliceXOffset = _mergeWepSpriteWidth * _mergeWepSpriteImage,
								_lastSlice    = undefined;
								
							while(_slice != undefined){
								var	_nextSlice = _slice.next_slice,
									_isFlash   = (_mergeWepSpriteImage == min(1, _mergeWepSpriteImageNum - 1)),
									_spr       = _slice.sprite_index,
									_img       = (_isFlash ? 1 : (_slice.image_number * (_mergeWepSpriteImage / _mergeWepSpriteImageNum))),
									_l         = _slice.x1,
									_r         = _slice.x2,
									_w         = _r - _l,
									_t         = 0,
									_h         = _slice.sprite_height,
									_x         = _sliceXOffset,
									_y         = _mergeWepSpriteYOffset - _slice.sprite_yoffset;
									
								with(UberCont){
									if(_outline == 1){
										if(!_isFlash){
											draw_set_fog(true, c_black, 0, 0);
										}
										if(_lastSlice != undefined){
											draw_sprite_part(_spr, _img, _l, _t, 1, ((_slice.sprite_bbox_y2 < _lastSlice.sprite_bbox_y2) ? ceil(_h / 2) : _h), _x - 1, _y);
										//	if(_slice.sprite_bbox_y1 <= _lastSlice.sprite_bbox_y1) draw_sprite_part(_spr, _img, _l, _t,                1,  ceil(_h / 2), _x - 1, _y);
										//	if(_slice.sprite_bbox_y2 >= _lastSlice.sprite_bbox_y2) draw_sprite_part(_spr, _img, _l, _t + ceil(_h / 2), 1, floor(_h / 2), _x - 1, _y + ceil(_h / 2));
										}
										if(_nextSlice != undefined){
											draw_sprite_part(_spr, _img, _r - 1, _t, 1, ((_slice.sprite_bbox_y2 <= _nextSlice.sprite_bbox_y2) ? ceil(_h / 2) : _h), _x + _w, _y);
										//	if(_slice.sprite_bbox_y1 < _nextSlice.sprite_bbox_y1) draw_sprite_part(_spr, _img, _r - 1, _t,                1,  ceil(_h / 2), _x + _w, _y);
										//	if(_slice.sprite_bbox_y2 > _nextSlice.sprite_bbox_y2) draw_sprite_part(_spr, _img, _r - 1, _t + ceil(_h / 2), 1, floor(_h / 2), _x + _w, _y + ceil(_h / 2));
										}
										if(!_isFlash){
											draw_set_fog(false, 0, 0, 0);
										}
									}
									else draw_sprite_part(_spr, _img, _l, _t, _w, _h, _x, _y);
								}
								
								_sliceXOffset += _w;
								
								_lastSlice = _slice;
								_slice     = _nextSlice;
							}
						}
					}
					
					 // Compressed Weapon:
					if(array_length(_wepSpriteList) == 2 && _wepSpriteList[0] == _wepSpriteList[1]){
						draw_set_color(c_black);
						draw_set_alpha(0.2);
						draw_set_color_write_enable(true, true, true, false);
						draw_rectangle(0, 0, _mergeWepSpriteWidth, _mergeWepSpriteHeight, false);
						draw_set_color_write_enable(true, true, true, true);
						draw_set_alpha(1);
					}
					
				surface_reset_target();
				
				 // Add Sprite:
				surface_save(surf, name + ".png");
				_mergeWepSprite = sprite_add(
					name + ".png",
					_mergeWepSpriteImageNum,
					_mergeWepSpriteXOffset,
					_mergeWepSpriteYOffset
				);
			}
		}
		
		 // Store Sprite:
		spr.MergeWep[? _mergeWepSpriteName            ] = _mergeWepSprite;
		spr.MergeWep[? array_join(_wepSpriteList, ":")] = _mergeWepSprite;
	}
	
	return _mergeWepSprite;
	
#define weapon_loadout_sprite_list_merge(_wepLoadoutSpriteList)
	/*
		Returns a sprite of slices from the given weapon loadout sprites combined sequentially
	*/
	
	var	_mergeWepLoadoutSpriteName = array_join(_wepLoadoutSpriteList, ":"),
		_mergeWepLoadoutSprite     = ds_map_find_value(spr.MergeWepLoadout, _mergeWepLoadoutSpriteName);
		
	 // Initial Setup:
	if(_mergeWepLoadoutSprite == undefined || !sprite_exists(_mergeWepLoadoutSprite)){
		var	_loadoutSpriteAngle            = 15,
			_loadoutSpriteXFactor          = 1 / dcos(_loadoutSpriteAngle),
			_mergeStockSlice               = undefined,
			_mergeFrontSlice               = undefined,
			_mergeSliceXOffset             = 0,
			_mergeSliceYOffset             = 0,
			_mergeWepLoadoutSpriteX1       =  infinity,
			_mergeWepLoadoutSpriteY1       =  infinity,
			_mergeWepLoadoutSpriteX2       = -infinity,
			_mergeWepLoadoutSpriteY2       = -infinity,
			_mergeWepLoadoutSpriteImageNum = 0,
			_mergeWepLoadoutSpriteList     = ds_map_values(spr.MergeWepLoadout),
			_mergeWepLoadoutSpriteKeyList  = ds_map_keys(spr.MergeWepLoadout);
			
		 // Ensure Sprites Are Loaded:
		with(_wepLoadoutSpriteList){
			var _sprite = self;
			if(
				   sprite_get_number(_sprite)      == 1
				&& sprite_get_width(_sprite)       == 16
				&& sprite_get_height(_sprite)      == 16
				&& sprite_get_bbox_left(_sprite)   == 15
				&& sprite_get_bbox_top(_sprite)    == 15
				&& sprite_get_bbox_right(_sprite)  == 0
				&& sprite_get_bbox_bottom(_sprite) == 0
			){
				var _spriteLoadingDelayFrame = ds_map_find_value(global.sprite_loading_delay_frame, _sprite);
				if(_spriteLoadingDelayFrame == undefined){
					_spriteLoadingDelayFrame = current_frame + 30;
					global.sprite_loading_delay_frame[? _sprite] = _spriteLoadingDelayFrame;
				}
				if(_spriteLoadingDelayFrame > current_frame){
					return mskNone;
				}
			}
		}
		
		 // Unmerge Sprites:
		while(true){
			var _newWepLoadoutSpriteList = [];
			with(_wepLoadoutSpriteList){
				var _mergeWepLoadoutSpriteIndex = array_find_index(_mergeWepLoadoutSpriteList, self);
				if(_mergeWepLoadoutSpriteIndex >= 0){
					with(string_split(_mergeWepLoadoutSpriteKeyList[_mergeWepLoadoutSpriteIndex], ":")){
						array_push(_newWepLoadoutSpriteList, real(self));
					}
				}
				else array_push(_newWepLoadoutSpriteList, self);
			}
			if(array_equals(_wepLoadoutSpriteList, _newWepLoadoutSpriteList)){
				break;
			}
			else{
				_wepLoadoutSpriteList = _newWepLoadoutSpriteList;
			}
		}
		_mergeWepLoadoutSprite = ds_map_find_value(spr.MergeWepLoadout, array_join(_wepLoadoutSpriteList, ":"));
		
		 // Generate Sprite:
		if(_mergeWepLoadoutSprite == undefined || !sprite_exists(_mergeWepLoadoutSprite)){
			 // Setup Sprite Slices:
			var	_wepLoadoutSpriteNum   = 0,
				_wepLoadoutSpriteCount = array_length(_wepLoadoutSpriteList);
				
			with(_wepLoadoutSpriteList){
				var _mergeSlice = {
					"sprite_index"   : self,
					"sprite_width"   : sprite_get_width(self),
					"sprite_height"  : sprite_get_height(self),
					"sprite_xoffset" : sprite_get_xoffset(self),
					"sprite_yoffset" : sprite_get_yoffset(self),
					"image_number"   : sprite_get_number(self),
					"sprite_length1" : 0,
					"sprite_length2" : 0,
					"length1"        : 0,
					"length2"        : 0,
					"next_slice"     : undefined
				};
				
				 // Determine Slice Dimensions:
				if(self != mskNone){
					var	_sliceDis1 = floor(((sprite_get_bbox_left(_mergeSlice.sprite_index)  + 2) - _mergeSlice.sprite_xoffset) * _loadoutSpriteXFactor) - 4,
						_sliceDis3 =  ceil(((sprite_get_bbox_right(_mergeSlice.sprite_index) - 1) - _mergeSlice.sprite_xoffset) * _loadoutSpriteXFactor) - 4,
						_sliceDis2 = /*round*/(lerp(_sliceDis1, _sliceDis3, 0.4));
						
					_mergeSlice.sprite_length1 = _sliceDis1;
					_mergeSlice.sprite_length2 = _sliceDis3;
					
					for(var _sliceSide = 0; _sliceSide <= 1; _sliceSide++){
						var _sliceDis = 0;
						if(_wepLoadoutSpriteNum == (_wepLoadoutSpriteCount - 1) * _sliceSide){
							_sliceDis = (
								(_sliceSide == 0)
								? _sliceDis1
								: _sliceDis3
							);
						}
						else{
							var _sliceAmount = (_wepLoadoutSpriteNum / _wepLoadoutSpriteCount) + (_sliceSide / min(2, _wepLoadoutSpriteCount));
							_sliceDis = /*ceil*/(lerp(
								lerp(
									_sliceDis1,
									_sliceDis2,
									clamp(2 * _sliceAmount, 0, 1)
								),
								_sliceDis3,
								clamp(2 * (_sliceAmount - 0.5), 0, 1)
							));
						}
						lq_set(_mergeSlice, `length${_sliceSide + 1}`, _sliceDis);
					}
				}
				else{
					_mergeSlice.sprite_width   = 1;
					_mergeSlice.sprite_height  = 1;
					_mergeSlice.sprite_xoffset = 0;
					_mergeSlice.sprite_yoffset = 0;
					_mergeSlice.length1        = -11;
					_mergeSlice.length2        = -5;
					_mergeSlice.sprite_length1 = _mergeSlice.length1;
					_mergeSlice.sprite_length2 = _mergeSlice.length2;
				}
				
				 // Merged Sprite Dimensions:
				var	_mergeSliceSpriteX1 =  ceil(_mergeSliceXOffset) - _mergeSlice.sprite_xoffset,
					_mergeSliceSpriteY1 = floor(_mergeSliceYOffset) - _mergeSlice.sprite_yoffset,
					_mergeSliceSpriteX2 = _mergeSliceSpriteX1 + _mergeSlice.sprite_width,
					_mergeSliceSpriteY2 = _mergeSliceSpriteY1 + _mergeSlice.sprite_height;
					
				if(_mergeSliceSpriteX1 < _mergeWepLoadoutSpriteX1) _mergeWepLoadoutSpriteX1 = _mergeSliceSpriteX1;
				if(_mergeSliceSpriteY1 < _mergeWepLoadoutSpriteY1) _mergeWepLoadoutSpriteY1 = _mergeSliceSpriteY1;
				if(_mergeSliceSpriteX2 > _mergeWepLoadoutSpriteX2) _mergeWepLoadoutSpriteX2 = _mergeSliceSpriteX2;
				if(_mergeSliceSpriteY2 > _mergeWepLoadoutSpriteY2) _mergeWepLoadoutSpriteY2 = _mergeSliceSpriteY2;
				
				_mergeSliceXOffset += lengthdir_x(_mergeSlice.length2 - _mergeSlice.length1, _loadoutSpriteAngle);
				_mergeSliceYOffset += lengthdir_y(_mergeSlice.length2 - _mergeSlice.length1, _loadoutSpriteAngle);
				
				 // Merged Sprite Frame Count:
				if(_mergeSlice.image_number > _mergeWepLoadoutSpriteImageNum){
					_mergeWepLoadoutSpriteImageNum = _mergeSlice.image_number;
				}
				
				 // Add to List:
				if(_mergeFrontSlice == undefined){
					_mergeStockSlice = _mergeSlice;
				}
				else{
					_mergeFrontSlice.next_slice = _mergeSlice;
				}
				_mergeFrontSlice = _mergeSlice;
				_wepLoadoutSpriteNum++;
			}
			
			 // Create Merged Sprite:
			var	_mergeWepLoadoutSpriteWidth   = _mergeWepLoadoutSpriteX2 - _mergeWepLoadoutSpriteX1,
				_mergeWepLoadoutSpriteHeight  = _mergeWepLoadoutSpriteY2 - _mergeWepLoadoutSpriteY1,
				_mergeWepLoadoutSpriteXOffset = -_mergeWepLoadoutSpriteX1,
				_mergeWepLoadoutSpriteYOffset = -_mergeWepLoadoutSpriteY1;
			
			with(surface_setup(
				"sprMergeLoadout",
				_mergeWepLoadoutSpriteWidth * _mergeWepLoadoutSpriteImageNum,
				_mergeWepLoadoutSpriteHeight,
				1
			)){
				free = true;
				
				surface_set_target(surf);
				draw_clear_alpha(c_black, 0);
				surface_reset_target();
				
				for(var _mergeWepLoadoutSpriteImage = 0; _mergeWepLoadoutSpriteImage < _mergeWepLoadoutSpriteImageNum; _mergeWepLoadoutSpriteImage++){
					var	_slice        = _mergeStockSlice,
						_sliceXOffset = _mergeWepLoadoutSpriteXOffset + lengthdir_x(_slice.length1, _loadoutSpriteAngle) + (_mergeWepLoadoutSpriteWidth * _mergeWepLoadoutSpriteImage),
						_sliceYOffset = _mergeWepLoadoutSpriteYOffset + lengthdir_y(_slice.length1, _loadoutSpriteAngle);
						
					while(_slice != undefined){
						var	_nextSlice = _slice.next_slice,
							_spr       = _slice.sprite_index,
							_sprImg    = _slice.image_number * (_mergeWepLoadoutSpriteImage / _mergeWepLoadoutSpriteImageNum),
							_sprX      = _slice.sprite_xoffset,
							_sprY      = _slice.sprite_yoffset;
							
						with(UberCont){
							var	_maskSurface  = surface_create(_slice.sprite_width, _slice.sprite_height),
								_sliceSurface = surface_create(_slice.sprite_width, _slice.sprite_height);
								
							 // Draw Sprite to Surface:
							surface_set_target(_sliceSurface);
							draw_clear_alpha(c_black, 0);
							switch(_spr){
								case sprGoldScrewdriverLoadout:
									draw_sprite_ext(_spr, _sprImg, _sprX, _sprY, 1, 1, _loadoutSpriteAngle - 45, c_white, 1);
									break;
									
								default:
									draw_sprite(_spr, _sprImg, _sprX, _sprY);
							}
							surface_reset_target();
							
							 // Trim Sprite's Head:
							if(_slice.length2 < _slice.sprite_length2){
								 // Create Trim Mask:
								surface_set_target(_maskSurface);
								draw_clear_alpha(c_black, 0);
								draw_circle(
									_sprX +  ceil(lengthdir_x(_slice.sprite_length2, _loadoutSpriteAngle)),
									_sprY + floor(lengthdir_y(_slice.sprite_length2, _loadoutSpriteAngle)),
									ceil(_slice.length2 - _slice.sprite_length2),
									false
								);
								draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
								draw_set_alpha(0.5);
								draw_circle(
									_sprX +  ceil(lengthdir_x(_slice.length2 - 10, _loadoutSpriteAngle)),
									_sprY + floor(lengthdir_y(_slice.length2 - 10, _loadoutSpriteAngle)),
									6 + 10,
									false
								);
								draw_set_alpha(1);
								draw_set_blend_mode(bm_normal);
								surface_reset_target();
								
								 // Trim:
								surface_set_target(_sliceSurface);
								draw_set_blend_mode_ext(bm_zero, bm_inv_src_alpha);
								draw_surface(_maskSurface, 0, 0);
								draw_set_blend_mode(bm_normal);
								surface_reset_target();
							}
							
							 // Trim Sprite's Back:
							if(_slice.length1 > _slice.sprite_length1){
								 // Create Trim Mask:
								surface_set_target(_maskSurface);
								draw_clear_alpha(c_black, 0);
								draw_circle(
									_sprX +  ceil(lengthdir_x(_slice.length2, _loadoutSpriteAngle)),
									_sprY + floor(lengthdir_y(_slice.length2, _loadoutSpriteAngle)),
									ceil(_slice.length2 - _slice.length1),
									false
								);
								surface_reset_target();
								
								 // Trim:
								surface_set_target(_sliceSurface);
								draw_set_blend_mode_ext(bm_zero, bm_src_alpha);
								draw_surface(_maskSurface, 0, 0);
								draw_set_blend_mode(bm_normal);
								surface_reset_target();
							}
							
							 // Draw Sliced Sprite:
							surface_set_target(other.surf);
							draw_surface(
								_sliceSurface,
								 ceil(_sliceXOffset - lengthdir_x(_slice.length1, _loadoutSpriteAngle)) - _sprX,
								floor(_sliceYOffset - lengthdir_y(_slice.length1, _loadoutSpriteAngle)) - _sprY
							);
							surface_reset_target();
							
							 // Destroy Surfaces:
							surface_destroy(_maskSurface);
							surface_destroy(_sliceSurface);
						}
						
						 // Next Slice:
						_sliceXOffset += lengthdir_x(_slice.length2 - _slice.length1, _loadoutSpriteAngle);
						_sliceYOffset += lengthdir_y(_slice.length2 - _slice.length1, _loadoutSpriteAngle);
						_slice = _nextSlice;
					}
				}
				
				 // Add Sprite:
				surface_save(surf, name + ".png");
				_mergeWepLoadoutSprite = sprite_add(
					name + ".png",
					_mergeWepLoadoutSpriteImageNum,
					_mergeWepLoadoutSpriteXOffset,
					_mergeWepLoadoutSpriteYOffset
				);
			}
		}
		
		 // Store Sprite:
		spr.MergeWepLoadout[? _mergeWepLoadoutSpriteName            ] = _mergeWepLoadoutSprite;
		spr.MergeWepLoadout[? array_join(_wepLoadoutSpriteList, ":")] = _mergeWepLoadoutSprite;
	}
	
	return _mergeWepLoadoutSprite;
	
#define prompt_subtext_get_sprite(_promptSubtext)
	/*
		Returns a sprite of the given string as a subtext banner for use in prompt names, like weapon pickups
	*/
	
	var _promptSubtextSprite = ds_map_find_value(spr.PromptSubtext, _promptSubtext);
	
	 // Initial Setup:
	if(_promptSubtextSprite == undefined || !sprite_exists(_promptSubtextSprite)){
		draw_set_font(fntSmall);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		
		var	_topSpace         = 2,
			_rawPromptSubtext = call(scr.string_delete_nt, _promptSubtext);
			
		with(surface_setup(
			"sprPromptSubtext",
			string_width(_rawPromptSubtext) + 4,
			string_height(_rawPromptSubtext) + 2 + _topSpace,
			1
		)){
			free = true;
			
			surface_set_target(surf);
			draw_clear_alpha(c_black, 0);
			
				 // Background:
				draw_set_alpha(0.8);
				draw_set_color(c_black);
				draw_roundrect_ext(-1, -1 + _topSpace, w - 1, h - 1, 5, 5, false);
				draw_set_alpha(1);
				
				 // Text:
				draw_text_nt(floor(w / 2), floor((h + _topSpace) / 2), _promptSubtext);
				
			surface_reset_target();
			
			 // Add Sprite:
			surface_save(surf, name + ".png");
			_promptSubtextSprite = sprite_add(name + ".png", 1, w / 2, h / 2);
			
			 // Store Sprite:
			spr.PromptSubtext[? _promptSubtext] = _promptSubtextSprite;
		}
	}
	
	return _promptSubtextSprite;
	
#define sprite_add_toptiny(_spr)
	/*
		Returns a new "TopTiny" corner tile sprite list created from the given TopSmall sprite
	*/
	
	var	_sprList = [[0, 0], [0, 0]],
		_sprImg  = sprite_get_number(_spr),
		_sprW    = sprite_get_width(_spr),
		_sprH    = sprite_get_height(_spr),
		_sprX    = sprite_get_xoffset(_spr),
		_sprY    = sprite_get_yoffset(_spr);
		
	with(surface_setup("sprTopTiny", (_sprW / 2) * _sprImg, (_sprH / 2), 1)){
		free = true;
		
		for(var _x = 0; _x < 2; _x++){
			for(var _y = 0; _y < 2; _y++){
				surface_set_target(surf);
				draw_clear_alpha(c_black, 0);
				
				with(UberCont){
					for(var _img = 0; _img < _sprImg; _img++){
						draw_sprite_part(
							_spr,
							_img,
							(_sprW / 2) * (1 - _x),
							(_sprH / 2) * (1 - _y),
							(_sprW / 2),
							(_sprH / 2),
							(_sprW / 2) * _img,
							0
						);
					}
				}
				
				surface_reset_target();
				
				 // Add Sprite:
				surface_save(surf, name + ".png");
				_sprList[@ _x][@ _y] = sprite_add(
					name + ".png",
					_sprImg,
					(_sprX - 8) * _x,
					(_sprY - 8) * _y
				);
			}
		}
	}
	
	return _sprList;
	
#define loadout_wep_save(_race, _name)
	/*
		Saves a LWO starting weapon's variables to restore them later on mod unload/game_start
	*/
	
	var _wep = unlock_get(`loadout:wep:${_race}:${_name}`);
	
	if(is_object(_wep)){
		ds_list_add(global.loadout_wep_clone, [_race, _name, _wep, call(scr.data_clone, _wep)]);
	}
	
#define loadout_wep_reset()
	/*
		Restores all of a LWO starting weapon's original variables
	*/
	
	with(ds_list_to_array(global.loadout_wep_clone)){
		var	_race    = self[0],
			_name    = self[1],
			_wep     = self[2],
			_wepSave = unlock_get(`loadout:wep:${_race}:${_name}`);
			
		if(_wep == _wepSave){
			save_set(`unlock:loadout:wep:${_race}:${_name}`, self[3]);
		}
	}
	
	ds_list_clear(global.loadout_wep_clone);