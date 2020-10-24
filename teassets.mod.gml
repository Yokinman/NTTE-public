#define init
	ntte_version = 2.018;
	
	 // Debug Lag:
	lag = false;
	
	 // SPRITES //
	spr = {};
	spr_load = [[spr, 0]];
	with(spr){
		var m, p;
		
		 // Storage:
		msk             = {};
		shd             = {};
		BigTopDecal     = ds_map_create();
		msk.BigTopDecal = ds_map_create();
		TopTiny         = ds_map_create();
		MergeWep        = ds_map_create();
		MergeWepLoadout = ds_map_create();
		MergeWepText    = ds_map_create();
		
		 // Shine Overlay:
		p = "sprites/shine/";
		Shine8    = sprite_add(p + "sprShine8.png",    7,  4,  4); // Rads
		Shine10   = sprite_add(p + "sprShine10.png",   7,  5,  5); // Pickups
		Shine12   = sprite_add(p + "sprShine12.png",   7,  6,  6); // Big Rads
		Shine16   = sprite_add(p + "sprShine16.png",   7,  8,  8); // Normal Chests
		Shine20   = sprite_add(p + "sprShine20.png",   7, 10, 10); // Heavy Chests (Steroids)
		Shine24   = sprite_add(p + "sprShine24.png",   7, 12, 12); // Big Chests
		Shine64   = sprite_add(p + "sprShine64.png",   7, 32, 32); // Giant Chests (YV)
		ShineHurt = sprite_add(p + "sprShineHurt.png", 3,  0,  0); // Hurt Flash
		ShineSnow = sprite_add(p + "sprShineSnow.png", 1,  0,  0); // Snow Floors
		
		//#region MENU / HUD
			
			 // Menu:
			m = "menu/";
			p = m;
				
				 // Open Options:
				OptionNTTE = sprite(p + "sprOptionNTTE", 1, 32, 12);
				MenuNTTE   = sprite(p + "sprMenuNTTE",   1, 20,  9);
				
				 // Eyes Maggot Shadow:
				shd.EyesMenu = sprite(p + "shdEyesMenu", 24, 16, 18);
				
				 // Unlock Icons:
				p = m + "unlocks/";
				UnlockIcon = {
					"coast"  : sprite(p + "sprUnlockIconBeach",    2, 12, 12),
					"oasis"  : sprite(p + "sprUnlockIconBubble",   2, 12, 12),
					"trench" : sprite(p + "sprUnlockIconTech",     2, 12, 12),
					"lair"   : sprite(p + "sprUnlockIconSawblade", 2, 12, 12),
					"red"    : sprite(p + "sprUnlockIconRed",      2, 12, 12),
					"crown"  : sprite(p + "sprUnlockIconCrown",    2, 12, 12)
				};
				
			 // Loadout Crown System:
			p = "crowns/";
			CrownRandomLoadout = sprite(p + "Random/sprCrownRandomLoadout", 2, 16, 16);
			ClockParts         = sprite(p + "sprClockParts",                2,  1, 1);
			
			 // Mutation Reroll Icon:
			p = "skills/Reroll/";
			SkillRerollHUDSmall = sprite(p + "sprSkillRerollHUDSmall", 1, 4, 4);
			
		//#endregion
		
		//#region WEAPONS
		p = "weps/";
			
			 // Bone:
			Bone      = sprite(p + "sprBone",      1, 6, 6);
			BoneShard = sprite(p + "sprBoneShard", 1, 3, 2, shnWep);
			
			 // Trident:
			Trident            = sprite(p + "sprTrident",            1, 11,  6, shnWep);
			GoldTrident        = sprite(p + "sprGoldTrident",        1, 11,  6, shnWep);
			TridentLoadout     = sprite(p + "sprTridentLoadout",     1, 24, 24);
			GoldTridentLoadout = sprite(p + "sprGoldTridentLoadout", 1, 24, 24);
			msk.Trident        = sprite(p + "mskTrident",            1, 11,  6);
			
		//#endregion
		
		//#region PROJECTILES
		p = "projectiles/";
			
			 // Albino Gator:
			AlbinoBolt      = sprite(p + "sprAlbinoBolt",     1,  8, 4);
			AlbinoGrenade   = sprite(p + "sprAlbinoGrenade",  1,  4, 4);
			AlbinoSplinter  = sprite(p + "sprAlbinoSplinter", 1, -6, 3);
			
			 // Bat Discs:
			BatDisc      = sprite(p + "sprBatDisc",      2,  9,  9);
			BatDiscBig   = sprite(p + "sprBatDiscBig",   2, 14, 14);
			BigDiscTrail = sprite(p + "sprBigDiscTrail", 3, 12, 12);
			
			 // Bat Lightning:
			BatLightning    = sprite(p + "sprBatLightning",    4,  0,  1);
			BatLightningHit = sprite(p + "sprBatLightningHit", 4, 12, 12);
			
			 // Bone:
			BoneSlashLight     = sprite(p + "sprBoneSlashLight", 3, 16, 16);
			msk.BoneSlashLight = sprite(p + "mskBoneSlashLight", 3, 16, 16);
			BoneSlashHeavy     = sprite(p + "sprBoneSlashHeavy", 4, 24, 24);
			msk.BoneSlashHeavy = sprite(p + "mskBoneSlashHeavy", 4, 24, 24);
			BoneArrow          = sprite(p + "sprBoneArrow",      1, 10,  2);
			BoneArrowHeavy     = sprite(p + "sprBoneArrowHeavy", 1, 12,  3);
			with([msk.BoneSlashLight, msk.BoneSlashHeavy]){
				mask = [true, 0];
			}
			
			 // Bubble Bombs:
			BubbleBomb           = sprite(p + "sprBubbleBomb",           30, 12, 12);
			BubbleBombEnemy      = sprite(p + "sprBubbleBombEnemy",      30, 12, 12);
			BubbleExplosion      = sprite(p + "sprBubbleExplosion",       9, 24, 24);
			BubbleExplosionSmall = sprite(p + "sprBubbleExplosionSmall",  7, 12, 12);
			BubbleCharge         = sprite(p + "sprBubbleCharge",         12, 12, 12);
			BubbleBombBig        = sprite(p + "sprBubbleBombBig",        46, 16, 16);
			BubbleSlash          = sprite(p + "sprBubbleSlash",           3,  0, 24);
			
			 // Clam Shield:
			ClamShield          = sprite(p + "sprClamShield",      14,  0,  7);
			ClamShieldWep       = sprite(p + "sprClamShieldWep",    1,  8,  8, shn16);
			ClamShieldSlash     = sprite(p + "sprClamShieldSlash",  4, 12, 12);
			msk.ClamShieldSlash = sprite(p + "mskClamShieldSlash",  4, 12, 12);
			
			 // Crystal Heart:
			CrystalHeartBullet      = sprite(p + "sprCrystalHeartBullet",      2, 10, 10);
			CrystalHeartBulletHit   = sprite(p + "sprCrystalHeartBulletHit",   8, 16, 16);
			CrystalHeartBulletRing  = sprite(p + "sprCrystalHeartBulletRing",  2, 10, 10);
			CrystalHeartBulletTrail = sprite(p + "sprCrystalHeartBulletTrail", 4, 10, 10);
			
			 // Electroplasma:
			ElectroPlasma       = sprite(p + "sprElectroPlasma",       7, 12, 12);
			ElectroPlasmaBig    = sprite(p + "sprElectroPlasmaBig",    7, 12, 12);
			ElectroPlasmaTrail  = sprite(p + "sprElectroPlasmaTrail",  3,  4,  4);
			ElectroPlasmaImpact = sprite(p + "sprElectroPlasmaImpact", 7, 12, 12);
			ElectroPlasmaTether = sprite(p + "sprElectroPlasmaTether", 4,  0,  1);
			
			 // Entangler:
			EntanglerSlash = sprite(p + "sprEntanglerSlash", 3, 0, 24);
			
			 // Harpoon:
			Harpoon      = sprite(p + "sprHarpoon",      1, 4, 3, shnWep);
			HarpoonOpen  = sprite(p + "sprHarpoonOpen",  5, 4, 3);
			HarpoonFade  = sprite(p + "sprHarpoonFade",  5, 7, 3);
			NetNade      = sprite(p + "sprNetNade",      1, 3, 3);
			NetNadeBlink = sprite(p + "sprNetNadeBlink", 2, 3, 3);
			
			 // Mortar Plasma:
			MortarPlasma = sprite(p + "sprMortarPlasma", 8, 8, 8);
			
			 // Small Plasma Impact:
			EnemyPlasmaImpactSmall = sprite(p + "sprEnemyPlasmaImpactSmall", 7,  8,  8);
			PlasmaImpactSmall      = sprite(p + "sprPlasmaImpactSmall",      7,  8,  8);
			PopoPlasmaImpactSmall  = sprite(p + "sprPopoPlasmaImpactSmall",	 7,  8,  8);
			msk.PlasmaImpactSmall  = sprite(p + "mskPlasmaImpactSmall",      7, 16, 16);
			with(msk.PlasmaImpactSmall){
				mask = [true, 0];
			}
			
			 // Portal Bullet:
			PortalBullet          = sprite(p + "sprPortalBullet",          4, 12, 12);
			PortalBulletHit       = sprite(p + "sprPortalBulletHit",       4, 16, 16);
			PortalBulletSpawn     = sprite(p + "sprPortalBulletSpawn",     7, 26, 26);
			PortalBulletLightning = sprite(p + "sprPortalBulletLightning", 4, 0,  1);
			
			 // Quasar Beam:
			QuasarBeam      = sprite(p + "sprQuasarBeam",      2,  0, 16);
			QuasarBeamStart = sprite(p + "sprQuasarBeamStart", 2, 32, 16);
			QuasarBeamEnd   = sprite(p + "sprQuasarBeamEnd",   2,  0, 16);
			QuasarBeamHit   = sprite(p + "sprQuasarBeamHit",   6, 24, 24);
			QuasarBeamTrail = sprite(p + "sprQuasarBeamTrail", 3,  4,  4);
			msk.QuasarBeam  = sprite(p + "mskQuasarBeam",      1, 32, 16);
			
			 // Red:
			RedBullet          = sprite(p + "sprRedBullet",          2,  9,  9);
			RedBulletDisappear = sprite(p + "sprRedBulletDisappear", 5,  9,  9);
			RedExplosion       = sprite(p + "sprRedExplosion",       7, 16, 16);
			RedSlash           = sprite(p + "sprRedSlash",           3,  0, 24);
			RedShank           = sprite(p + "sprRedShank",           2, -5,  8);
			
			 // Small Green Explo:
			SmallGreenExplosion = sprite(p + "sprSmallGreenExplosion", 7, 12, 12);
			
			 // Energy Bat Slash:
			EnergyBatSlash     = sprite(p + "sprEnergyBatSlash", 3,  0,  24);
			//msk.EnergyBatSlash = sprite(p + "mskEnergyBatSlash", 4, 16, 24);
			
			 // Vector Plasma:
			EnemyVlasmaBullet = sprite(p + "sprEnemyVlasmaBullet", 5,  8,  8);
			VlasmaBullet      = sprite(p + "sprVlasmaBullet",      5,  8,  8);
			PopoVlasmaBullet  = sprite(p + "sprPopoVlasmaBullet",  5,  8,  8);
			EnemyVlasmaCannon = sprite(p + "sprEnemyVlasmaCannon", 5, 10, 10);
			VlasmaCannon      = sprite(p + "sprVlasmaCannon",      5, 10, 10);
			PopoVlasmaCannon  = sprite(p + "sprPopoVlasmaCannon",  5, 10, 10);
			
			 // Venom Pellets:
			VenomPelletAppear        = sprite(p + "sprVenomPelletAppear",        1, 8, 8);
			VenomPellet              = sprite(p + "sprVenomPellet",              2, 8, 8);
			VenomPelletDisappear     = sprite(p + "sprVenomPelletDisappear",     5, 8, 8);
			VenomPelletBack          = sprite(p + "sprVenomPelletBack",          2, 8, 8);
			VenomPelletBackDisappear = sprite(p + "sprVenomPelletBackDisappear", 5, 8, 8);
			
			 // Variants:
			EnemyBullet             = sprite(p + "sprEnemyBullet",             2,  7,  9);
			EnemyHeavyBullet        = sprite(p + "sprEnemyHeavyBullet",        2, 12, 12);
			EnemyHeavyBulletHit     = sprite(p + "sprEnemyHeavyBulletHit",     4, 12, 12);
			EnemySlug               = sprite(p + "sprEnemySlug",               2, 12, 12);
			EnemySlugHit            = sprite(p + "sprEnemySlugHit",            4, 16, 16);
			EnemySlugDisappear      = sprite(p + "sprEnemySlugDisappear",      6, 12, 12);
			EnemyHeavySlug          = sprite(p + "sprEnemyHeavySlug",          2, 16, 16);
			EnemyHeavySlugHit       = sprite(p + "sprEnemyHeavySlugHit",       4, 24, 24);
			EnemyHeavySlugDisappear = sprite(p + "sprEnemyHeavySlugDisappear", 6, 16, 16);
			EnemySuperFlak          = sprite(p + "sprEnemySuperFlak",          2, 12, 12);
			EnemySuperFlakHit       = sprite(p + "sprEnemySuperFlakHit",       9, 24, 24);
			EnemyPlasmaBall         = sprite(p + "sprEnemyPlasmaBall",         2, 12, 12);
			EnemyPlasmaBig          = sprite(p + "sprEnemyPlasmaBig",          2, 16, 16);
			EnemyPlasmaHuge         = sprite(p + "sprEnemyPlasmaHuge",         2, 24, 24);
			EnemyPlasmaImpact       = sprite(p + "sprEnemyPlasmaImpact",       7, 16, 16);
			EnemyPlasmaTrail        = sprite(p + "sprEnemyPlasmaTrail",        3,  4,  4);
			AllySniperBullet        = sprite(p + "sprAllySniperBullet",        2,  6,  8);
			AllyLaserCharge         = sprite(p + "sprAllyLaserCharge",         4,  3,  3);
			
		//#endregion
		
		//#region ALERTS
		p = "alerts/";
			
			 // Alert Indicators:
			AlertIndicator        = sprite(p + "sprAlertIndicator",        1, 1, 6);
			AlertIndicatorMystery = sprite(p + "sprAlertIndicatorMystery", 1, 2, 6);
			AlertIndicatorPopo    = sprite(p + "sprAlertIndicatorPopo",    1, 4, 4);
			AlertIndicatorOrchid  = sprite(p + "sprAlertIndicatorOrchid",  1, 4, 4);
			
			 // Alert Icons:
			AllyAlert        = sprite(p + "sprAllyAlert",        1, 7, 7);
			BanditAlert      = sprite(p + "sprBanditAlert",      1, 7, 7);
			FlyAlert         = sprite(p + "sprFlyAlert",         1, 7, 7);
			GatorAlert       = sprite(p + "sprGatorAlert",       1, 7, 7);
			GatorAlbinoAlert = sprite(p + "sprGatorAlbinoAlert", 1, 7, 7);
			PopoAlert        = sprite(p + "sprPopoAlert",        3, 8, 8);
			PopoEliteAlert   = sprite(p + "sprPopoEliteAlert",   3, 8, 8);
			PopoFreakAlert   = sprite(p + "sprPopoFreakAlert",   1, 8, 8);
			SealAlert        = sprite(p + "sprSealAlert",        1, 7, 7);
			SealArcticAlert  = sprite(p + "sprSealArcticAlert",  1, 7, 7);
			SkealAlert       = sprite(p + "sprSkealAlert",       1, 7, 7);
			SludgePoolAlert  = sprite(p + "sprSludgePoolAlert",  1, 7, 7);
			VanAlert         = sprite(p + "sprVanAlert",         1, 7, 7);
			
		//#endregion
		
		//#region ENEMIES
		m = "enemies/";
			
			 // Albino Gator:
			p = m + "AlbinoGator/";
			AlbinoGatorIdle = sprite(p + "sprAlbinoGatorIdle", 8, 16, 16);
			AlbinoGatorWalk = sprite(p + "sprAlbinoGatorWalk", 6, 16, 16);
			AlbinoGatorHurt = sprite(p + "sprAlbinoGatorHurt", 3, 16, 16);
			AlbinoGatorDead = sprite(p + "sprAlbinoGatorDead", 6, 16, 16);
			AlbinoGatorWeap = sprite(p + "sprAlbinoGatorWeap", 1,  7,  5, shnWep);
			
			 // Angler:
			p = m + "Angler/";
			AnglerIdle       = sprite(p + "sprAnglerIdle",    8, 32, 32);
			AnglerWalk       = sprite(p + "sprAnglerWalk",    8, 32, 32);
			AnglerHurt       = sprite(p + "sprAnglerHurt",    3, 32, 32);
			AnglerDead       = sprite(p + "sprAnglerDead",    7, 32, 32);
			AnglerAppear     = sprite(p + "sprAnglerAppear",  4, 32, 32);
			AnglerTrail      = sprite(p + "sprAnglerTrail",   8, 32, 32);
			AnglerLight      = sprite(p + "sprAnglerLight",   4, 80, 80);
			msk.AnglerHidden =[sprite(p + "mskAnglerHidden1", 1, 32, 32),
			                   sprite(p + "mskAnglerHidden2", 1, 32, 32)];
			
			 // Baby Gator:
			p = m + "BabyGator/";
			BabyGatorIdle = sprite(p + "sprBabyGatorIdle", 6, 12, 12);
			BabyGatorWalk = sprite(p + "sprBabyGatorWalk", 6, 12, 12);
			BabyGatorHurt = sprite(p + "sprBabyGatorHurt", 3, 12, 12);
			BabyGatorDead = sprite(p + "sprBabyGatorDead", 7, 12, 12);
			BabyGatorWeap = sprite(p + "sprBabyGatorWeap", 1,  0,  3, shnWep);
			
			 // Baby Scorpion:
			p = m + "BabyScorpion/";
			BabyScorpionIdle = sprite("enemies/BabyScorpion/sprBabyScorpionIdle", 4, 16, 16);
			BabyScorpionWalk = sprite("enemies/BabyScorpion/sprBabyScorpionWalk", 6, 16, 16);
			BabyScorpionHurt = sprite("enemies/BabyScorpion/sprBabyScorpionHurt", 3, 16, 16);
			BabyScorpionDead = sprite("enemies/BabyScorpion/sprBabyScorpionDead", 6, 16, 16);
			BabyScorpionFire = sprite("enemies/BabyScorpion/sprBabyScorpionFire", 6, 16, 16);
			
			 // Baby Scorpion (Gold):
			p = m + "BabyScorpionGold/";
			BabyScorpionGoldIdle = sprite("enemies/BabyScorpionGold/sprBabyScorpionGoldIdle", 4, 16, 16);
			BabyScorpionGoldWalk = sprite("enemies/BabyScorpionGold/sprBabyScorpionGoldWalk", 6, 16, 16);
			BabyScorpionGoldHurt = sprite("enemies/BabyScorpionGold/sprBabyScorpionGoldHurt", 3, 16, 16);
			BabyScorpionGoldDead = sprite("enemies/BabyScorpionGold/sprBabyScorpionGoldDead", 6, 16, 16);
			BabyScorpionGoldFire = sprite("enemies/BabyScorpionGold/sprBabyScorpionGoldFire", 6, 16, 16);
			
			 // Bandit Campers:
			p = m + "Camp/";
			BanditCamperIdle = sprite(p + "sprBanditCamperIdle", 4, 12, 12);
			BanditCamperWalk = sprite(p + "sprBanditCamperWalk", 6, 12, 12);
			BanditCamperHurt = sprite(p + "sprBanditCamperHurt", 3, 12, 12);
			BanditCamperDead = sprite(p + "sprBanditCamperDead", 6, 12, 12);
			BanditHikerIdle  = sprite(p + "sprBanditHikerIdle",  4, 12, 12);
			BanditHikerWalk  = sprite(p + "sprBanditHikerWalk",  6, 12, 12);
			BanditHikerHurt  = sprite(p + "sprBanditHikerHurt",  3, 12, 12);
			BanditHikerDead  = sprite(p + "sprBanditHikerDead",  6, 12, 12);
			
			 // Bat:
			p = m + "Bat/";
			BatWeap        = sprite(p + "sprBatWeap",     1,  2,  6, shnWep);
			BatIdle        = sprite(p + "sprBatIdle",    24, 16, 16);
			BatWalk        = sprite(p + "sprBatWalk",    12, 16, 16);
			BatHurt        = sprite(p + "sprBatHurt",     3, 16, 16);
			BatDead        = sprite(p + "sprBatDead",     6, 16, 16);
			BatYell        = sprite(p + "sprBatYell",     6, 16, 16);
			BatScreech     = sprite(p + "sprBatScreech",  8, 48, 48);
			msk.BatScreech = sprite(p + "mskBatScreech",  8, 48, 48);
			
			 // Bat Boss:
			p = m + "BatBoss/"
			BatBossIdle = sprite(p + "sprBigBatIdle",  12, 24, 24);
			BatBossWalk = sprite(p + "sprBigBatWalk",   8, 24, 24);
			BatBossHurt = sprite(p + "sprBigBatHurt",   3, 24, 24);
			BatBossDead = sprite(p + "sprBigBatDead",   6, 24, 24);
			BatBossYell = sprite(p + "sprBigBatYell",   6, 24, 24);
			BatBossWeap = sprite(p + "sprBatBossWeap",  1,  4,  8, shnWep);
			VenomFlak   = sprite(p + "sprVenomFlak",    2, 12, 12);
			
			 // Big Fish:
			p = m + "CoastBoss/";
			BigFishBecomeIdle = sprite(p + "sprBigFishBuild",      4, 40, 38);
			BigFishBecomeHurt = sprite(p + "sprBigFishBuildHurt",  4, 40, 38);
			BigFishSpwn       = sprite(p + "sprBigFishSpawn",     11, 32, 32);
			BigFishLeap       = sprite(p + "sprBigFishLeap",      11, 32, 32);
			BigFishSwim       = sprite(p + "sprBigFishSwim",       8, 24, 24);
			BigFishRise       = sprite(p + "sprBigFishRise",       5, 32, 32);
			BigFishSwimFrnt   = sprite(p + "sprBigFishSwimFront",  6,  0,  4);
			BigFishSwimBack   = sprite(p + "sprBigFishSwimBack",  11,  0,  5);
			
			 // Bone Gator:
			p = m + "BoneGator/";
			BoneGatorIdle = sprite(p + "sprBoneGatorIdle", 8, 12, 12);
			BoneGatorWalk = sprite(p + "sprBoneGatorWalk", 6, 12, 12);
			BoneGatorHurt = sprite(p + "sprBoneGatorHurt", 3, 12, 12);
			BoneGatorDead = sprite(p + "sprBoneGatorDead", 6, 12, 12);
			BoneGatorHeal = sprite(p + "sprBoneGatorHeal", 7,  8,  8);
			BoneGatorWeap = sprite(p + "sprBoneGatorWeap", 1,  2,  3);
			FlameSpark    = sprite(p + "sprFlameSpark",    7,  1,  1);
			
			 // Big Maggot Nest:
			p = m + "BigMaggotNest/";
			BigMaggotSpawnIdle = sprite(p + "sprBigMaggotNestIdle", 4, 32, 32);
			BigMaggotSpawnHurt = sprite(p + "sprBigMaggotNestHurt", 3, 32, 32);
			BigMaggotSpawnDead = sprite(p + "sprBigMaggotNestDead", 3, 32, 32);
			BigMaggotSpawnChrg = sprite(p + "sprBigMaggotNestChrg", 4, 32, 32);
			
			 // Blooming Bush Assassin:
			p = m + "BloomingAss/";
			BloomingAssassinHide = sprite(p + "sprBloomingAssassinHide", 41, 16, 16);
			BloomingAssassinIdle = sprite(p + "sprBloomingAssassinIdle",  6, 16, 16);
			BloomingAssassinWalk = sprite(p + "sprBloomingAssassinWalk",  6, 16, 16);
			BloomingAssassinHurt = sprite(p + "sprBloomingAssassinHurt",  3, 16, 16);
			BloomingAssassinDead = sprite(p + "sprBloomingAssassinDead",  6, 16, 16);
			
			 // Bone Raven:
			p = m + "BoneRaven/";
			BoneRavenIdle = sprite(p + "sprBoneRavenIdle", 33, 12, 12);
			BoneRavenWalk = sprite(p + "sprBoneRavenWalk",  7, 12, 12);
			BoneRavenHurt = sprite(p + "sprBoneRavenHurt",  3, 12, 12);
			BoneRavenDead = sprite(p + "sprBoneRavenDead", 11, 12, 12);
			BoneRavenLift = sprite(p + "sprBoneRavenLift",  5, 32, 32);
			BoneRavenLand = sprite(p + "sprBoneRavenLand",  4, 32, 32);
			BoneRavenFly  = sprite(p + "sprBoneRavenFly",   5, 32, 32);
			
			 // Cat:
			p = m + "Cat/";
			CatIdle      = sprite(p + "sprCatIdle",          4, 12, 12);
			CatWalk      = sprite(p + "sprCatWalk",          6, 12, 12);
			CatHurt      = sprite(p + "sprCatHurt",          3, 12, 12);
			CatDead      = sprite(p + "sprCatDead",          6, 12, 12);
			CatSit1      =[sprite(p + "sprCatGoSit",         3, 12, 12),
			               sprite(p + "sprCatGoSitSide",     3, 12, 12)];
			CatSit2      =[sprite(p + "sprCatSit",           6, 12, 12),
			               sprite(p + "sprCatSitSide",       6, 12, 12)];
			CatSnowIdle  = sprite(p + "sprCatSnowIdle",      4, 12, 12);
			CatSnowWalk  = sprite(p + "sprCatSnowWalk",      6, 12, 12);
			CatSnowHurt  = sprite(p + "sprCatSnowHurt",      3, 12, 12);
			CatSnowDead  = sprite(p + "sprCatSnowDead",      6, 12, 12);
			CatSnowSit1  =[sprite(p + "sprCatSnowGoSit",     3, 12, 12),
			               sprite(p + "sprCatSnowGoSitSide", 3, 12, 12)];
			CatSnowSit2  =[sprite(p + "sprCatSnowSit",       6, 12, 12),
			               sprite(p + "sprCatSnowSitSide",   6, 12, 12)];
			CatWeap  = sprite(p + "sprCatToxer",     1,  3,  4);
			AcidPuff = sprite(p + "sprAcidPuff",     4, 16, 16);
			
			 // Cat Boss:
			p = m + "CatBoss/";
			CatBossIdle     = sprite(p + "sprBigCatIdle",       12, 24, 24);
			CatBossWalk     = sprite(p + "sprBigCatWalk",        6, 24, 24);
			CatBossHurt     = sprite(p + "sprBigCatHurt",        3, 24, 24);
			CatBossDead     = sprite(p + "sprBigCatDead",        6, 24, 24);
			CatBossChrg     = sprite(p + "sprBigCatChrg",        2, 24, 24);
			CatBossFire     = sprite(p + "sprBigCatFire",        2, 24, 24);
			CatBossWeap     = sprite(p + "sprCatBossToxer",      2,  4,  7);
			CatBossWeapChrg = sprite(p + "sprCatBossToxerChrg", 12,  1,  7);
			BossHealFX      = sprite(p + "sprBossHealFX",       10,  9,  9);
			
			 // Crab Tank:
			CrabTankIdle = sprCrabIdle;
			CrabTankWalk = sprCrabWalk;
			CrabTankHurt = sprCrabHurt;
			CrabTankDead = sprCrabDead;
			
			 // Crystal Brain:
			p = m + "CrystalBrain/";
			CrystalBrainIdle          = sprite(p + "sprCrystalBrainIdle",           6, 24, 24);
			CrystalBrainHurt          = sprite(p + "sprCrystalBrainHurt",           3, 24, 24);
			CrystalBrainDead          = sprite(p + "sprCrystalBrainDead",           7, 24, 24);
			CrystalBrainAppear        = sprite(p + "sprCrystalBrainAppear",         4, 24, 24);
			CrystalBrainDisappear     = sprite(p + "sprCrystalBrainDisappear",      7, 24, 24);
			CrystalBrainChunk         = sprite(p + "sprCrystalBrainChunk",          4,  8,  8);
			CrystalBrainPart          = sprite(p + "sprCrystalBrainPart",           7, 24, 24);
			CrystalBrainEffect        = sprite(p + "sprCrystalBrainEffect",        10,  8,  8);
			CrystalBrainEffectAlly    = sprite(p + "sprCrystalBrainEffectAlly",    10,  8,  8);
			CrystalBrainEffectPopo    = sprite(p + "sprCrystalBrainEffectPopo",    10,  8,  8);
			CrystalBrainSurfMask      = sprite(p + "sprCrystalBrainSurfMask",       1,  0,  0);
			CrystalCloneOverlay       = sprite(p + "sprCrystalCloneOverlay",        8,  0,  0);
			CrystalCloneOverlayAlly   = sprite(p + "sprCrystalCloneOverlayAlly",    8,  0,  0);
			CrystalCloneOverlayPopo   = sprite(p + "sprCrystalCloneOverlayPopo",    8,  0,  0);
			CrystalCloneOverlayCorpse = sprite(p + "sprCrystalCloneOverlayCorpse",  8,  0,  0);
			CrystalCloneGun           = sprite_duplicate_ext(sprRevolver,   0, 1);
			CrystalCloneGunTB         = sprite_duplicate_ext(sprMachinegun, 0, 1);
			
			 // Crystal Heart:
			p = m + "CrystalHeart/";
			CrystalHeartIdle = sprite(p + "sprCrystalHeartIdle", 10, 24, 24);
			CrystalHeartHurt = sprite(p + "sprCrystalHeartHurt",  3, 24, 24);
			CrystalHeartDead = sprite(p + "sprCrystalHeartDead", 22, 24, 24);
			ChaosHeartIdle   = sprite(p + "sprChaosHeartIdle",   10, 24, 24);
			ChaosHeartHurt   = sprite(p + "sprChaosHeartHurt",    3, 24, 24);
			ChaosHeartDead   = sprite(p + "sprChaosHeartDead",   22, 24, 24);
			
			 // Diver:
			p = m + "Diver/";
			DiverIdle  = sprite(p + "sprDiverIdle",       4, 12, 12);
			DiverWalk  = sprite(p + "sprDiverWalk",       6, 12, 12);
			DiverHurt  = sprite(p + "sprDiverHurt",       3, 12, 12);
			DiverDead  = sprite(p + "sprDiverDead",       9, 16, 16);
			HarpoonGun = sprite(p + "sprDiverHarpoonGun", 1,  8,  8);
			
			 // Eel:
			p = m + "Eel/";
			EelIdle    =[sprite(p + "sprEelIdleBlue",    8, 16, 16),
			             sprite(p + "sprEelIdlePurple",  8, 16, 16),
			             sprite(p + "sprEelIdleGreen",   8, 16, 16)];
			EelHurt    =[sprite(p + "sprEelHurtBlue",    3, 16, 16),
			             sprite(p + "sprEelHurtPurple",  3, 16, 16),
			             sprite(p + "sprEelHurtGreen",   3, 16, 16)];
			EelDead    =[sprite(p + "sprEelDeadBlue",    9, 16, 16),
			             sprite(p + "sprEelDeadPurple",  9, 16, 16),
			             sprite(p + "sprEelDeadGreen",   9, 16, 16)];
			EelTell    =[sprite(p + "sprEelTellBlue",    8, 16, 16),
			             sprite(p + "sprEelTellPurple",  8, 16, 16),
			             sprite(p + "sprEelTellGreen",   8, 16, 16)];
			EeliteIdle = sprite(p + "sprEelIdleElite",   8, 16, 16);
			EeliteHurt = sprite(p + "sprEelHurtElite",   3, 16, 16);
			EeliteDead = sprite(p + "sprEelDeadElite",   9, 16, 16);
			WantEel    = sprite(p + "sprWantEel",       16, 16, 16);
			
			 // Fish Freaks:
			p = m + "FishFreak/";
			FishFreakIdle = sprite(p + "sprFishFreakIdle",  6, 12, 12);
			FishFreakWalk = sprite(p + "sprFishFreakWalk",  6, 12, 12);
			FishFreakHurt = sprite(p + "sprFishFreakHurt",  3, 12, 12);
			FishFreakDead = sprite(p + "sprFishFreakDead", 11, 12, 12);
			
			 // Gull:
			p = m + "Gull/";
			GullIdle  = sprite(p + "sprGullIdle",  4, 12, 12);
			GullWalk  = sprite(p + "sprGullWalk",  6, 12, 12);
			GullHurt  = sprite(p + "sprGullHurt",  3, 12, 12);
			GullDead  = sprite(p + "sprGullDead",  6, 16, 16);
			GullSword = sprite(p + "sprGullSword", 1,  6,  8);
			
			 // Hammerhead Fish:
			p = m + "Hammer/";
			HammerSharkIdle = sprite(p + "sprHammerSharkIdle",  6, 24, 24);
			HammerSharkHurt = sprite(p + "sprHammerSharkHurt",  3, 24, 24);
			HammerSharkDead = sprite(p + "sprHammerSharkDead", 10, 24, 24);
			HammerSharkChrg = sprite(p + "sprHammerSharkDash",  2, 24, 24);
			
			 // Jellyfish (0 = blue, 1 = purple, 2 = green, 3 = elite):
			p = m + "Jellyfish/";
			JellyFire      = sprite(p + "sprJellyfishFire",        6, 24, 24);
			JellyEliteFire = sprite(p + "sprJellyfishEliteFire",   6, 24, 24);
			JellyIdle      =[sprite(p + "sprJellyfishBlueIdle",    8, 24, 24),
			                 sprite(p + "sprJellyfishPurpleIdle",  8, 24, 24),
			                 sprite(p + "sprJellyfishGreenIdle",   8, 24, 24),
			                 sprite(p + "sprJellyfishEliteIdle",   8, 24, 24)];
			JellyHurt      =[sprite(p + "sprJellyfishBlueHurt",    3, 24, 24),
			                 sprite(p + "sprJellyfishPurpleHurt",  3, 24, 24),
			                 sprite(p + "sprJellyfishGreenHurt",   3, 24, 24),
			                 sprite(p + "sprJellyfishEliteHurt",   3, 24, 24)];
			JellyDead      =[sprite(p + "sprJellyfishBlueDead",   10, 24, 24),
			                 sprite(p + "sprJellyfishPurpleDead", 10, 24, 24),
			                 sprite(p + "sprJellyfishGreenDead",  10, 24, 24),
			                 sprite(p + "sprJellyfishEliteDead",  10, 24, 24)];
			
			 // Lair Turret Reskin:
			p = m + "LairTurret/";
			LairTurretIdle   = sprite(p + "sprLairTurretIdle",    1, 12, 12);
			LairTurretHurt   = sprite(p + "sprLairTurretHurt",    3, 12, 12);
			LairTurretDead   = sprite(p + "sprLairTurretDead",    6, 12, 12);
			LairTurretFire   = sprite(p + "sprLairTurretFire",    3, 12, 12);
			LairTurretAppear = sprite(p + "sprLairTurretAppear", 11, 12, 12);
			
			 // Miner Bandit:
			p = m + "MinerBandit/";
			MinerBanditIdle = sprite(p + "sprMinerBanditIdle", 4, 12, 12);
			MinerBanditWalk = sprite(p + "sprMinerBanditWalk", 6, 12, 12);
			MinerBanditHurt = sprite(p + "sprMinerBanditHurt", 3, 12, 12);
			MinerBanditDead = sprite(p + "sprMinerBanditDead", 6, 12, 12);
			
			 // Mortar:
			p = m + "Mortar/";
			MortarIdle = sprite(p + "sprMortarIdle",  4, 22, 24);
			MortarWalk = sprite(p + "sprMortarWalk",  8, 22, 24);
			MortarFire = sprite(p + "sprMortarFire", 16, 22, 24);
			MortarHurt = sprite(p + "sprMortarHurt",  3, 22, 24);
			MortarDead = sprite(p + "sprMortarDead", 14, 22, 24);
			
			 // Mortar (Cursed):
			p = m + "InvMortar/";
			InvMortarIdle = sprite(p + "sprInvMortarIdle",  4, 22, 24);
			InvMortarWalk = sprite(p + "sprInvMortarWalk",  8, 22, 24);
			InvMortarFire = sprite(p + "sprInvMortarFire", 16, 22, 24);
			InvMortarHurt = sprite(p + "sprInvMortarHurt",  3, 22, 24);
			InvMortarDead = sprite(p + "sprInvMortarDead", 14, 22, 24);
			
			 // Palanking:
			p = m + "Palanking/";
			PalankingBott  = sprite(p + "sprPalankingBase",   1, 40, 24);
			PalankingTaunt = sprite(p + "sprPalankingTaunt", 31, 40, 24);
			PalankingCall  = sprite(p + "sprPalankingCall",   9, 40, 24);
			PalankingIdle  = sprite(p + "sprPalankingIdle",  16, 40, 24);
			PalankingWalk  = sprite(p + "sprPalankingWalk",  16, 40, 24);
			PalankingHurt  = sprite(p + "sprPalankingHurt",   3, 40, 24);
			PalankingDead  = sprite(p + "sprPalankingDead",  11, 40, 24);
			PalankingBurp  = sprite(p + "sprPalankingBurp",   5, 40, 24);
			PalankingFire  = sprite(p + "sprPalankingFire",  11, 40, 24);
			PalankingFoam  = sprite(p + "sprPalankingFoam",   1, 40, 24);
			PalankingChunk = sprite(p + "sprPalankingChunk",  5, 16, 16);
			GroundSlash    = sprite(p + "sprGroundSlash",     3,  0, 21);
			PalankingSlash = sprite(p + "sprPalankingSlash",  3,  0, 29);
			msk.Palanking  = sprite(p + "mskPalanking",       1, 40, 24);
			with(msk.Palanking){
				mask = [false, 0];
			}
			
			 // Pelican:
			p = m + "Pelican/";
			PelicanIdle   = sprite(p + "sprPelicanIdle",   6, 24, 24);
			PelicanWalk   = sprite(p + "sprPelicanWalk",   6, 24, 24);
			PelicanHurt   = sprite(p + "sprPelicanHurt",   3, 24, 24);
			PelicanDead   = sprite(p + "sprPelicanDead",   6, 24, 24);
			PelicanHammer = sprite(p + "sprPelicanHammer", 1,  6,  8);
			
			 // Pit Squid:
			p = m + "Pitsquid/";
				
				 // Eyes:
				PitSquidCornea  = sprite(p + "sprPitsquidCornea", 1, 19, 19);
				PitSquidPupil   = sprite(p + "sprPitsquidPupil",  1, 19, 19);
				PitSquidEyelid  = sprite(p + "sprPitsquidEyelid", 3, 19, 19);
				
				 // Tentacles:
				TentacleIdle = sprite(p + "sprTentacleIdle", 8, 20, 28);
				TentacleHurt = sprite(p + "sprTentacleIdle", 8, 20, 28, shnHurt);
				TentacleDead = sprite(p + "sprTentacleDead", 4, 20, 28);
				TentacleSpwn = sprite(p + "sprTentacleSpwn", 6, 20, 28);
				TentacleTele = sprite(p + "sprTentacleTele", 6, 20, 28);
				
				 // Maw:
				PitSquidMawBite = sprite(p + "sprPitsquidMawBite", 14, 19, 19);
				PitSquidMawSpit = sprite(p + "sprPitsquidMawSpit", 10, 19, 19);
				
				 // Particles:
				p += "Particles/";
				PitSpark = [
					sprite(p + "sprPitSpark1", 5, 16, 16),
					sprite(p + "sprPitSpark2", 5, 16, 16),
					sprite(p + "sprPitSpark3", 5, 16, 16),
					sprite(p + "sprPitSpark4", 5, 16, 16),
					sprite(p + "sprPitSpark5", 5, 16, 16),
				];
				TentacleWheel    = sprite(p + "sprTentacleWheel",    2, 40, 40);
				SquidCharge      = sprite(p + "sprSquidCharge",      5, 24, 24);
				SquidBloodStreak = sprite(p + "sprSquidBloodStreak", 7,  0,  8);
				
			 // Popo Security:
			p = m + "PopoSecurity/";
			PopoSecurityIdle    = sprite(p + "sprPopoSecurityIdle",    11, 16, 16);
			PopoSecurityWalk    = sprite(p + "sprPopoSecurityWalk",    6,  16, 16);
			PopoSecurityHurt    = sprite(p + "sprPopoSecurityHurt",    3,  16, 16);
			PopoSecurityDead    = sprite(p + "sprPopoSecurityDead",    7,  16, 16);
			PopoSecurityCannon  = sprite(p + "sprPopoSecurityCannon",  1,  7,  8);
			PopoSecurityMinigun = sprite(p + "sprPopoSecurityMinigun", 1,  7,  8);
			
			 // Portal Guardian:
			p = m + "PortalGuardian/";
			PortalGuardianIdle      = sprite(p + "sprPortalGuardianIdle",      4, 16, 16);
			PortalGuardianHurt      = sprite(p + "sprPortalGuardianHurt",      3, 16, 16);
			PortalGuardianDead      = sprite(p + "sprPortalGuardianDead",      9, 32, 32);
			PortalGuardianAppear    = sprite(p + "sprPortalGuardianAppear",    5, 32, 32);
			PortalGuardianDisappear = sprite(p + "sprPortalGuardianDisappear", 4, 32, 32);
			
			 // Puffer:
			p = m + "Puffer/";
			PufferIdle       = sprite(p + "sprPufferIdle",    6, 15, 16);
			PufferHurt       = sprite(p + "sprPufferHurt",    3, 15, 16);
			PufferDead       = sprite(p + "sprPufferDead",   11, 15, 16);
			PufferChrg       = sprite(p + "sprPufferChrg",    9, 15, 16);
			PufferFire[0, 0] = sprite(p + "sprPufferBlow0",   2, 15, 16);
			PufferFire[0, 1] = sprite(p + "sprPufferBlowB0",  2, 15, 16);
			PufferFire[1, 0] = sprite(p + "sprPufferBlow1",   2, 15, 16);
			PufferFire[1, 1] = sprite(p + "sprPufferBlowB1",  2, 15, 16);
			PufferFire[2, 0] = sprite(p + "sprPufferBlow2",   2, 15, 16);
			PufferFire[2, 1] = sprite(p + "sprPufferBlowB2",  2, 15, 16);
			PufferFire[3, 0] = sprite(p + "sprPufferBlow3",   2, 15, 16);
			PufferFire[3, 1] = sprite(p + "sprPufferBlowB3",  2, 15, 16);
			
			 // Red Crystal Spider:
			p = m + "RedSpider/";
			RedSpiderIdle = sprite(p + "sprRedSpiderIdle", 8, 12, 12);
			RedSpiderWalk = sprite(p + "sprRedSpiderWalk", 6, 12, 12);
			RedSpiderHurt = sprite(p + "sprRedSpiderHurt", 3, 12, 12);
			RedSpiderDead = sprite(p + "sprRedSpiderDead", 7, 12, 12);
			
			 // Saw Trap:
			p = m + "SawTrap/";
			SawTrap       = sprite(p + "sprSawTrap",       1, 20, 20);
			SawTrapHurt   = sprite(p + "sprSawTrapHurt",   3, 20, 20);
			SawTrapDebris = sprite(p + "sprSawTrapDebris", 4,  8,  8);
			
			 // Seal:
			p = m + "Seal/";
			SealIdle = [];
			SealWalk = [];
			SealHurt = [];
			SealDead = [];
			SealSpwn = [];
			SealWeap = [];
			for(var i = 0; i <= 6; i++){
				var n = ((i <= 0) ? "" : string(i));
				SealIdle[i] = sprite(p + "sprSealIdle" + n, 6, 12, 12);
				SealWalk[i] = sprite(p + "sprSealWalk" + n, 6, 12, 12);
				SealHurt[i] = sprite(p + "sprSealHurt" + n, 3, 12, 12);
				SealDead[i] = sprite(p + "sprSealDead" + n, 6, 12, 12);
				SealSpwn[i] = sprite(p + "sprSealSpwn" + n, 6, 12, 12);
				SealWeap[i] = mskNone;
			}
			SealWeap[1] = sprite(p + "sprHookPole",    1, 18,  2);
			SealWeap[2] = sprite(p + "sprSabre",       1, -2,  1);
			SealWeap[3] = sprite(p + "sprBlunderbuss", 1,  7,  1);
			SealWeap[4] = sprite(p + "sprRepeater",    1,  6,  2);
			SealWeap[6] = sprBanditGun;
			SealDisc    = sprite(p + "sprSealDisc",    2,  7,  7);
			SkealIdle   = sprite(p + "sprSkealIdle",   6, 12, 12);
			SkealWalk   = sprite(p + "sprSkealWalk",   7, 12, 12);
			SkealHurt   = sprite(p + "sprSkealHurt",   3, 12, 12);
			SkealDead   = sprite(p + "sprSkealDead",  10, 16, 16);
			SkealSpwn   = sprite(p + "sprSkealSpwn",   8, 16, 16);
			
			 // Seal (Heavy):
			p = m + "SealHeavy/";
			SealHeavySpwn = sprite(p + "sprHeavySealSpwn",    6, 16, 17);
			SealHeavyIdle = sprite(p + "sprHeavySealIdle",   10, 16, 17);
			SealHeavyWalk = sprite(p + "sprHeavySealWalk",    8, 16, 17);
			SealHeavyHurt = sprite(p + "sprHeavySealHurt",    3, 16, 17);
			SealHeavyDead = sprite(p + "sprHeavySealDead",    7, 16, 17);
			SealHeavyTell = sprite(p + "sprHeavySealTell",    2, 16, 17);
			SealAnchor    = sprite(p + "sprHeavySealAnchor",  1,  0, 12);
			SealChain     = sprite(p + "sprChainSegment",     1,  0,  0);
			
			 // Silver Scorpion:
			p = m + "SilverScorpion/";
			SilverScorpionIdle = sprite(p + "sprSilverScorpionIdle", 14, 24, 24);
			SilverScorpionWalk = sprite(p + "sprSilverScorpionWalk", 6,  24, 24);
			SilverScorpionHurt = sprite(p + "sprSilverScorpionHurt", 3,  24, 24);
			SilverScorpionDead = sprite(p + "sprSilverScorpionDead", 6,  24, 24);
			SilverScorpionFire = sprite(p + "sprSilverScorpionFire", 2,  24, 24);
			SilverScorpionFlak = sprite(p + "sprSilverScorpionFlak", 4,  10, 10);
			
			 // Spiderling:
			p = m + "Spiderling/";
			SpiderlingIdle     = sprite(p + "sprSpiderlingIdle",     4, 8, 8);
			SpiderlingWalk     = sprite(p + "sprSpiderlingWalk",     4, 8, 8);
			SpiderlingHurt     = sprite(p + "sprSpiderlingHurt",     3, 8, 8);
			SpiderlingDead     = sprite(p + "sprSpiderlingDead",     7, 8, 8);
			SpiderlingHatch    = sprite(p + "sprSpiderlingHatch",    5, 8, 8);
			InvSpiderlingIdle  = sprite(p + "sprInvSpiderlingIdle",  4, 8, 8);
			InvSpiderlingWalk  = sprite(p + "sprInvSpiderlingWalk",  4, 8, 8);
			InvSpiderlingHurt  = sprite(p + "sprInvSpiderlingHurt",  3, 8, 8);
			InvSpiderlingDead  = sprite(p + "sprInvSpiderlingDead",  7, 8, 8);
			InvSpiderlingHatch = sprite(p + "sprInvSpiderlingHatch", 5, 8, 8);
			
			 // Traffic Crab:
			p = m + "Crab/";
			CrabIdle = sprite(p + "sprTrafficCrabIdle", 5, 24, 24);
			CrabWalk = sprite(p + "sprTrafficCrabWalk", 6, 24, 24);
			CrabHurt = sprite(p + "sprTrafficCrabHurt", 3, 24, 24);
			CrabDead = sprite(p + "sprTrafficCrabDead", 9, 24, 24);
			CrabFire = sprite(p + "sprTrafficCrabFire", 2, 24, 24);
			CrabHide = sprite(p + "sprTrafficCrabHide", 5, 24, 24);
			
			 // Yeti Crab:
			p = m + "YetiCrab/";
			YetiCrabIdle = sprite(p + "sprYetiCrab", 1, 12, 12);
			KingCrabIdle = sprite(p + "sprKingCrab", 1, 12, 12);
			
		//#endregion
		
		//#region CAMPFIRE
		m = "areas/Campfire/";
		p = m;
			
			 // Loading Screen:
			SpiralDebrisNothing = sprite(p + "sprSpiralDebrisNothing", 5, 24, 24);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Big Cactus:
				BigNightCactusIdle = sprite(p + "sprBigNightCactus",     1, 16, 16);
				BigNightCactusHurt = sprite(p + "sprBigNightCactus",     1, 16, 16, shnHurt);
				BigNightCactusDead = sprite(p + "sprBigNightCactusDead", 4, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region DESERT
		m = "areas/Desert/";
		p = m;
			
			 // Big Decal:
			BigTopDecal[?     area_desert] = sprite(p + "sprBigTopDecalDesert",         1, 32, 56);
			msk.BigTopDecal[? area_desert] = sprite(p + "../mskBigTopDecal",            1, 32, 12);
			BigTopDecalScorpion            = sprite(p + "sprBigTopDecalScorpion",       1, 32, 52);
			BigTopDecalScorpionDebris      = sprite(p + "sprBigTopDecalScorpionDebris", 8, 10, 10);
			
			 // Fly:
			FlySpin = sprite(p + "sprFlySpin", 16, 4, 4);
			
			 // Wall Rubble:
			Wall1BotRubble = sprite(p + "sprWall1BotRubble", 4, 0,  0);
			Wall1TopRubble = sprite(p + "sprWall1TopRubble", 4, 0,  0);
			Wall1OutRubble = sprite(p + "sprWall1OutRubble", 4, 4, 12);
			
			 // Wall Bro:
			WallBandit = sprite(p + "sprWallBandit", 9, 8, 8);
			
			 // Scorpion Floor:
			FloorScorpion     = sprite(p + "sprFloorScorpion",     2, 8, 8);
			SnowFloorScorpion = sprite(p + "sprSnowFloorScorpion", 1, 8, 8);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Camp:
				BanditCampfire     = sprite(p + "sprBanditCampfire",     1, 26, 26);
				BanditTentIdle     = sprite(p + "sprBanditTent",         1, 24, 24);
				BanditTentHurt     = sprite(p + "sprBanditTentHurt",     3, 24, 24);
				BanditTentDead     = sprite(p + "sprBanditTentDead",     3, 24, 24);
				BanditTentWallIdle = sprite(p + "sprBanditTentWall",     1, 24, 24);
				BanditTentWallHurt = sprite(p + "sprBanditTentWallHurt", 3, 24, 24);
				BanditTentWallDead = sprite(p + "sprBanditTentWallDead", 3, 24, 24);
				shd.BanditTent     = sprite(p + "shdBanditTent",         1, 24, 24);
				
				 // Big Cactus:
				BigCactusIdle = sprite(p + "sprBigCactus",     1, 16, 16);
				BigCactusHurt = sprite(p + "sprBigCactus",     1, 16, 16, shnHurt);
				BigCactusDead = sprite(p + "sprBigCactusDead", 4, 16, 16);
				
				 // Return of a Legend:
				CowSkullIdle = sprite(p + "sprCowSkull",     1, 24, 24);
				CowSkullHurt = sprite(p + "sprCowSkull",     1, 24, 24, shnHurt);
				CowSkullDead = sprite(p + "sprCowSkullDead", 3, 24, 24);
				
				 // Scorpion Rock:
				ScorpionRock         = sprite(p + "sprScorpionRock",     6, 16, 16);
				ScorpionRockAlly     = sprite(p + "sprScorpionRockAlly", 6, 16, 16);
				ScorpionRockHurt     = sprite(p + "sprScorpionRock",     6, 16, 16, shnHurt);
				ScorpionRockAllyHurt = sprite(p + "sprScorpionRockAlly", 6, 16, 16, shnHurt);
				ScorpionRockDead     = sprite(p + "sprScorpionRockDead", 3, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region SCRAPYARD
		m = "areas/Scrapyard/";
		p = m;
			
			 // Decals:
			BigTopDecal[? area_scrapyards] = sprite(p + "sprBigTopDecalScrapyard",  1, 32, 48);
			TopDecalScrapyardAlt           = sprite(p + "sprTopDecalScrapyardAlt",  1, 16, 16);
			NestDebris                     = sprite(p + "sprNestDebris",           16,  4,  4);
			
			 // Sludge Pool:
			SludgePool          = sprite(p + "sprSludgePool",      4,  0,  0);
			msk.SludgePool      = sprite(p + "mskSludgePool",      1, 32, 32);
			msk.SludgePoolSmall = sprite(p + "mskSludgePoolSmall", 1, 16, 16);
			
			 // Fire Pit Event:
			FirePitScorch = sprite(p + "sprFirePitScorch", 3, 16, 16);
			TrapSpin      = sprite(p + "sprTrapSpin",      8, 12, 12);
			
		//#endregion
		
		//#region CRYSTAL CAVES
		m = "areas/Caves/";
		p = m;
			
			 // Decals:
			BigTopDecal[?     area_caves       ] = sprite(p + "sprBigTopDecalCaves",       1, 32, 56);
			BigTopDecal[?     area_cursed_caves] = sprite(p + "sprBigTopDecalCursedCaves", 1, 32, 56);
			msk.BigTopDecal[? area_caves       ] = sprite(p + "../mskBigTopDecal",         1, 32, 16);
			msk.BigTopDecal[? area_cursed_caves] = msk.BigTopDecal[? area_caves];
			
			 // Wall Spiders:
			WallSpider          = sprite(p + "sprWallSpider",          2, 8, 8);
			WallSpiderBot       = sprite(p + "sprWallSpiderBot",       2, 0, 0);
			WallSpiderling      = sprite(p + "sprWallSpiderling",      4, 8, 8);
			WallSpiderlingTrans = sprite(p + "sprWallSpiderlingTrans", 4, 8, 8);
			
		//#endregion
		
		//#region FROZEN CITY
		m = "areas/City/";
		p = m;
			
			 // Seal Plaza:
			FloorSeal            = sprite(p + "sprFloorSeal",         4, 16, 16);
			SnowFloorSeal        = sprite(p + "sprFloorSeal",         4, 16, 16, shnSnow);
			FloorSealRoom        = sprite(p + "sprFloorSealRoom",     9, 16, 16);
			SnowFloorSealRoom    = sprite(p + "sprFloorSealRoom",     9, 16, 16, shnSnow);
			FloorSealRoomBig     = sprite(p + "sprFloorSealRoomBig", 25, 16, 16);
			SnowFloorSealRoomBig = sprite(p + "sprFloorSealRoomBig", 25, 16, 16, shnSnow);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Igloos:
				IglooFrontIdle = sprite(p + "sprIglooFront",     1, 24, 24);
				IglooFrontHurt = sprite(p + "sprIglooFrontHurt", 3, 24, 24);
				IglooFrontDead = sprite(p + "sprIglooFrontDead", 3, 24, 24);
				IglooSideIdle  = sprite(p + "sprIglooSide",      1, 24, 24);
				IglooSideHurt  = sprite(p + "sprIglooSideHurt",  3, 24, 24);
				IglooSideDead  = sprite(p + "sprIglooSideDead",  3, 24, 24);
				
				 // Palanking Statue:
				PalankingStatueIdle  =[sprite(p + "sprPalankingStatue1",     1, 32, 32),
				                       sprite(p + "sprPalankingStatue2",     1, 32, 32),
				                       sprite(p + "sprPalankingStatue3",     1, 32, 32),
				                       sprite(p + "sprPalankingStatue4",     1, 32, 32)];
				PalankingStatueHurt  =[sprite(p + "sprPalankingStatue1",     1, 32, 32, shnHurt),
				                       sprite(p + "sprPalankingStatue2",     1, 32, 32, shnHurt),
				                       sprite(p + "sprPalankingStatue3",     1, 32, 32, shnHurt),
				                       sprite(p + "sprPalankingStatue4",     1, 32, 32, shnHurt)];
				PalankingStatueDead  = sprite(p + "sprPalankingStatueDead",  3, 32, 32);
				PalankingStatueChunk = sprite(p + "sprPalankingStatueChunk", 5, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region LABS
		m = "areas/Labs/";
		p = m;
			
			 // Freak Chamber:
			Wall6BotTrans     = sprite(p + "sprWall6BotTrans",     4,  0,  0);
			FreakChamberAlarm = sprite(p + "sprFreakChamberAlarm", 4, 12, 12);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Mutant Vat:
				MutantVatIdle  = sprite(p + "sprMutantVat",      1, 32, 32);
				MutantVatHurt  = sprite(p + "sprMutantVatHurt",  3, 32, 32);
				MutantVatDead  = sprite(p + "sprMutantVatDead",  3, 32, 32);
				MutantVatBack  = sprite(p + "sprMutantVatBack",  6, 32, 32);
				MutantVatLid   = sprite(p + "sprMutantVatLid",   8, 24, 24);
				MutantVatGlass = sprite(p + "sprMutantVatGlass", 4, 6,  6);
				
				 // Button:
				ButtonIdle        = sprite(p + "sprButtonIdle",         1, 16, 16);
				ButtonHurt        = sprite(p + "sprButtonHurt",         3, 16, 16);
				ButtonPressedIdle = sprite(p + "sprButtonPressedIdle",  1, 16, 16);
				ButtonPressedHurt = sprite(p + "sprButtonPressedHurt",  3, 16, 16);
				ButtonDead        = sprite(p + "sprButtonDead",         4, 16, 16);
				ButtonDebris      = sprite(p + "sprButtonDebris",       1, 12, 12);
				ButtonRevive      = sprite(p + "sprButtonRevive",      12, 24, 48);
				ButtonReviveArea  = sprite(p + "sprButtonReviveArea",   8, 20, 20);
				PickupRevive      = sprite(p + "sprPickupRevive",      12, 24, 48);
				PickupReviveArea  = sprite(p + "sprPickupReviveArea",   8, 20, 20);
				
			//#endregion
			
		//#endregion
		
		//#region PALACE
		m = "areas/Palace/";
		p = m;
			
			 // Decals:
			BigTopDecal[?     area_palace] = sprite(p + "sprBigTopDecalPalace", 1, 32, 56);
			msk.BigTopDecal[? area_palace] = sprite(p + "../mskBigTopDecal",    1, 32, 16);
			
			 // Generator Shadows Woooo:
			shd.BigGenerator  = sprite(p + "shdBigGenerator",  1, 48-16, 32);
			shd.BigGeneratorR = sprite(p + "shdBigGeneratorR", 1, 48+16, 32);
			
			 // Inactive Throne Hitbox (Can walk on top, so cool broo):
			msk.NothingInactiveCool = sprite(p + "mskNothingInactiveCool", 1, 150, 100);
			with(msk.NothingInactiveCool){
				mask = [false, 0];
			}
			
			 // Better Game Over Sprite (Big sprite so that the on-hover text is more mandatory):
			NothingDeathCause = sprite(p + "sprNothingDeathCause", 1, 80, 80);
			
			 // Throne Shadow:
			shd.Nothing = sprite(p + "shdNothing", 1, 128, 100);
			
			 // Stairs:
			FloorPalaceStairs       = sprite(p + "sprFloorPalaceStairs",       3, 0, 0);
			FloorPalaceStairsCarpet = sprite(p + "sprFloorPalaceStairsCarpet", 6, 0, 0);
			
			 // Shrine Floors:
			FloorPalaceShrine          = sprite(p + "sprFloorPalaceShrine",          10, 2, 2);
			FloorPalaceShrineRoomSmall = sprite(p + "sprFloorPalaceShrineRoomSmall",  4, 0, 0);
			FloorPalaceShrineRoomLarge = sprite(p + "sprFloorPalaceShrineRoomLarge",  9, 0, 0);
			
			 // Tiny TopSmalls:
			TopTiny[? sprWall7Trans] = [
				[sprite(p + "sprTopTinyPalace", 8,  0,  0),
				 sprite(p + "sprTopTinyPalace", 8,  0, -8)],
				[sprite(p + "sprTopTinyPalace", 8, -8,  0),
				 sprite(p + "sprTopTinyPalace", 8, -8, -8)]
			];
			
			//#region PROPS
			p = m + "Props/";
				
				 // Palace Altar:
				PalaceAltarIdle   = sprite(p + "sprPalaceAltar",       1, 24, 24);
				PalaceAltarHurt   = sprite(p + "sprPalaceAltarHurt",   3, 24, 24);
				PalaceAltarDead   = sprite(p + "sprPalaceAltarDead",   4, 24, 24);
				PalaceAltarDebris = sprite(p + "sprPalaceAltarDebris", 5,  8,  8);
				
				GroundFlameGreen             = sprite(p + "sprGroundFlameGreen",             8, 4, 6);
				GroundFlameGreenBig          = sprite(p + "sprGroundFlameGreenBig",          8, 6, 8);
				GroundFlameGreenDisappear    = sprite(p + "sprGroundFlameGreenDisappear",    4, 4, 6);
				GroundFlameGreenBigDisappear = sprite(p + "sprGroundFlameGreenBigDisappear", 4, 6, 8);
				
				 // Pillar (Connects to the ground better):
				sprite_replace(sprNuclearPillar,     "sprites/" + p + "sprNuclearPillar.png",     11, 24, 32);
				sprite_replace(sprNuclearPillarHurt, "sprites/" + p + "sprNuclearPillarHurt.png",  3, 24, 32);
				sprite_replace(sprNuclearPillarDead, "sprites/" + p + "sprNuclearPillarDead.png",  3, 24, 32);
				
			//#endregion
			
		//#endregion
		
		//#region VAULT
		m = "areas/Vault/";
		p = m;
			
			 // Tiny TopSmalls:
			TopTiny[? sprWall100Trans] = [
				[sprite(p + "sprTopTinyVault", 12,  0,  0),
				 sprite(p + "sprTopTinyVault", 12,  0, -8)],
				[sprite(p + "sprTopTinyVault", 12, -8,  0),
				 sprite(p + "sprTopTinyVault", 12, -8, -8)]
			];
			
			 // Vault Flower Room:
			VaultFlowerFloor = sprite(p + "sprFloorVaultFlower", 9, 0, 0);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Vault Flower:
				VaultFlowerIdle         = sprite(p + "sprVaultFlower",              4, 24, 24);
				VaultFlowerHurt         = sprite(p + "sprVaultFlowerHurt",          3, 24, 24);
				VaultFlowerDead         = sprite(p + "sprVaultFlowerDead",          3, 24, 24);
				VaultFlowerWiltedIdle   = sprite(p + "sprVaultFlowerWilted",        1, 24, 24);
				VaultFlowerWiltedHurt   = sprite(p + "sprVaultFlowerWiltedHurt",    3, 24, 24);
				VaultFlowerWiltedDead   = sprite(p + "sprVaultFlowerWiltedDead",    3, 24, 24);
				VaultFlowerDebris       = sprite(p + "sprVaultFlowerDebris",       10,  4,  4);
				VaultFlowerWiltedDebris = sprite(p + "sprVaultFlowerWiltedDebris", 10,  4,  4);
				VaultFlowerSparkle      = sprite(p + "sprVaultFlowerSparkle",       4,  3,  3);
				
			//#endregion
			
		//#endregion
		
		//#region COAST
		m = "areas/Coast/";
		p = m;
			
			 // Floors:
			FloorCoast  = sprite(p + "sprFloorCoast",  4, 2, 2);
			FloorCoastB = sprite(p + "sprFloorCoastB", 3, 2, 2);
			DetailCoast = sprite(p + "sprDetailCoast", 6, 4, 4);
			
			 // Sea:
			CoastTrans  = sprite(p + "sprCoastTrans",  1, 0, 0);
			WaterStreak = sprite(p + "sprWaterStreak", 7, 8, 8);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Blooming Cactus:
				BloomingCactusIdle =[sprite(p + "sprBloomingCactus",      1, 12, 12),
				                     sprite(p + "sprBloomingCactus2",     1, 12, 12),
				                     sprite(p + "sprBloomingCactus3",     1, 12, 12)];
				BloomingCactusHurt =[sprite(p + "sprBloomingCactus",      1, 12, 12, shnHurt),
				                     sprite(p + "sprBloomingCactus2",     1, 12, 12, shnHurt),
				                     sprite(p + "sprBloomingCactus3",     1, 12, 12, shnHurt)];
				BloomingCactusDead =[sprite(p + "sprBloomingCactusDead",  4, 12, 12),
				                     sprite(p + "sprBloomingCactus2Dead", 4, 12, 12),
				                     sprite(p + "sprBloomingCactus3Dead", 4, 12, 12)];
				
				 // Big Blooming Cactus:
				BigBloomingCactusIdle = sprite(p + "sprBigBloomingCactus",     1, 16, 16);
				BigBloomingCactusHurt = sprite(p + "sprBigBloomingCactus",     1, 16, 16, shnHurt);
				BigBloomingCactusDead = sprite(p + "sprBigBloomingCactusDead", 4, 16, 16);
				
				 // Buried Car:
				BuriedCarIdle = sprite(p + "sprBuriedCar",     1, 16, 16);
				BuriedCarHurt = sprite(p + "sprBuriedCarHurt", 3, 16, 16);
				
				 // Bush:
				BloomingBushIdle = sprite(p + "sprBloomingBush",     1, 12, 12);
				BloomingBushHurt = sprite(p + "sprBloomingBushHurt", 3, 12, 12);
				BloomingBushDead = sprite(p + "sprBloomingBushDead", 3, 12, 12);
				
				 // Palm:
				PalmIdle     = sprite(p + "sprPalm",         1, 24, 40);
				PalmHurt     = sprite(p + "sprPalmHurt",     3, 24, 40);
				PalmDead     = sprite(p + "sprPalmDead",     4, 24, 40);
				PalmFortIdle = sprite(p + "sprPalmFort",     1, 32, 56);
				PalmFortHurt = sprite(p + "sprPalmFortHurt", 3, 32, 56);
				
				 // Sea/Seal Mine:
				SealMine     = sprite(p + "sprSeaMine", 1, 12, 12);
				SealMineHurt = sprite(p + "sprSeaMine", 1, 12, 12, shnHurt);
				
			p = m + "Decals/";
				
				 // Decal Water Rock Props:
				RockIdle  =[sprite(p + "sprRock1Idle", 1, 16, 16),
				            sprite(p + "sprRock2Idle", 1, 16, 16)];
				RockHurt  =[sprite(p + "sprRock1Idle", 1, 16, 16, shnHurt),
				            sprite(p + "sprRock2Idle", 1, 16, 16, shnHurt)];
				RockDead  =[sprite(p + "sprRock1Dead", 1, 16, 16),
				            sprite(p + "sprRock2Dead", 1, 16, 16)];
				RockBott  =[sprite(p + "sprRock1Bott", 1, 16, 16),
				            sprite(p + "sprRock2Bott", 1, 16, 16)];
				RockFoam  =[sprite(p + "sprRock1Foam", 1, 16, 16),
				            sprite(p + "sprRock2Foam", 1, 16, 16)];
				ShellIdle = sprite(p + "sprShellIdle", 1, 32, 32);
				ShellHurt = sprite(p + "sprShellIdle", 1, 32, 32, shnHurt);
				ShellDead = sprite(p + "sprShellDead", 6, 32, 32);
				ShellBott = sprite(p + "sprShellBott", 1, 32, 32);
				ShellFoam = sprite(p + "sprShellFoam", 1, 32, 32);
				
			//#endregion
			
			 // Strange Creature:
			CreatureIdle = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAACMAAAACgCAMAAADXNXIqAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQWkrGXVgQ/w4ALiVetS/rwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKuM2GgAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAADJxJREFUeF7t24ty20YSQFFlLcv//8VZYNCkAGLwIAYU0c45VSvSeM3dSRWqI1c+/gUASMYAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0DDAAQDoGGAAgHQMMAJCOAQYASMcAAwCkY4ABANIxwAAA6RhgAIB0WgaYj4k4eCERFuLghURYiIMXEmEhDl5IhIU4eCERFuLglUTZII5dSZQN4tiVRNkgjl1JlA3i2JVE2SCOXUmUDeLYlUTZII5dSZQN4tjZDj03kv6ZiINxyVtFSoSFOBiXvFWkRFiIg3HJW0VKhIU4GJe8VaREWIiDcclbRUqEhTgYl7xXtETZII7FFe8VLVE2iGNxxXtFS5QN4lhc8V7REmWDOBZXvFe0RNkgjsUV7xUtUTaIY3HFe0VLlA3iWFzxVpHyI33PPrBERFLVCxqfoa+NvjZX79sM1LdOXxt9bS7et5V3et9TT1tu+9+3N+6hvjb62ly9bzkw2nqX7JsE6luir42+Jst5o76T3y/7H7W+eeMdLI1x18/R10Zfm6v3LQcOSaVscMG+hw3UN6evjb4mi3mlbJp3Yt/eBy3WdWWxhRM/vYX62uhrc/2+pcC+bx54pb7aBuqb0tdGX5vFvC6tknde367HLO9eSasF/ugW6mujr83V+7rAyJkpJdXAa/Qtb+A/P5enr5G+Nrn7qnln9e14ykpdPe3mh7ZQXxt9ba7etxoYKVVX7/upCUtfG31t9K3YfsZKXWdhvAo/sYP62uhrc/m+1cCubznwRyaY9b7VDdTX0ddGX5v1vi5vue+M99/WIza2L0TP3Mt3UF8bfW3+jr7FQH36muhr83f0Rc1ce9/GE/ZtXy+KHr14B/W10dfm7+lbCNS3VwQ90LdXBD3Qt1cEPbhMX/Q8au5bf8BiXyw/8pYd1NdGX5u0ffOYq/dN/0PMb/qqYvURfXP62jzRV0vutfat3r/QF0s/qh9/5d/D6Wujr03SvoXAhcP6ZmLlB/oe6WvzV/UtHW7sW7u93hcL7/a6N7S+Nvra5Ox7NvDH+54M1PcoFt5J36NYeCd9D2LdvRr7Vu6u98Wy+/3zqh3U10Zfm5x9Twdeve9lb2h9bfS1ydkXiz6hrW/55iN9tdPdsZfsoL42+trk7NsIrOhuuXRft4H6vsWiT9A3Fos+Qd9IrPmE7p6WvsV7j+3f/Hy55QU7qK+NvjZJ+zYCK6f1TQyLLtF3o69N0r5hzUXn9y3deqyvEjjcc/oO6mujr03Svq3A+QXX6qttYP9DXyhLrtA30Ndmoa+suGJ+xXDkeN/CnYf3byHw7L+H09dGX5usfduB8XmXo+/sN7S+NvraZO0ra61Z6Dv+fqnfeHz/FgJPfgPqa6OvTdq+7cD4vNM3URZboa+nr03avrLWmtP76vctB240zk+3Blbpa6OvTdq+7cD4vLv1nRrY0Pd4Wt+Evj30tVns28pb7juaV71vdf9WC+dnb0fO3EB9bfS1ydvXBw7rLZid1jehbwd9bfL2dcv9cF/1tpXADfMrbjf90AZu0NfT1yZv36HA4UNfr6y1Ql9HX5u8fWWpFfNLbkeO9tVuW9m/frG1ysr/heGm7uO0HdTXRl+bzH0bgcMFE3HoGn1dRny5u92kr+iXKuvW6dPXaq2vX6ksWzdcMXG762Bf7a6NDSw/FszPdUc+fv3+3T3zp/4Blx8L5ue6I/pG9G1K3VcCY+25cn6iO3Khvnlgd0DfmL4t+tqs9lUSRubnuiNNfZW71vdv9a+5hguGz6+vP4Ovr4/fv399bAZ+FPGHFfrq9OkrtgOHmrnh/PDl6xZY+ro3zObSewOP95XA2+eor7wB9Q30bdBXd1Jfp7RU3E/2n5HX9zW8/yp3HeyLc4Nb3OCrvvZYd7pc+rr9i3MDfWuiaCrODfStiaKpODd4b181ME6FSWDp23jB7A/UV6NvQt+aSJqIU+GtfVE0FecGk7yh7+D7r3LXjg28+/j4VfTrx6HONK9XEuP5FVH352vH/umb06fv7pm+euDTfU8FPtk3BOq70zen75p9UTfNe75vJa9y1/7Aj/53y70+MI5V6jpfX5+fi423vO6qHfun75E+fSP7+yaBcej+m+eJW98ZgU/0lb8eL777qhu4s+/8F7S+GX2P/qt91fff8333vNrrZX7Hvr6y2j3wOy+Wmvi6qUZ+715/4Vn7VxbSV6EvFgp/W9+hwF+3m+pvl/C5HfjqvtoGRl1H311ZSF+FvlgovKSvrHPP+37/1V4wEdfnVfomefO+efC+/et1S5UB8Ptf3+p18W3QZY4bPz6+T3997tlAffoG+mqe6iuB/W94hyM7+iIwFnsIPLfvtoHfffXXc3wJfcRCX3dO3yN9i/RV7O+LvKfff+P3yziv+v6bBz+xgQ/6paY9XUyludPvYb/0ePf+dBef+w/4gb6evo6+irLWLDC+PYi+aWD3hnllX3k9T/u6JePLA30VZQ19h5U19B3VL9XljVbsp5X4OrX//TcPPhrYl0x3b/H1POgjHy9/4QbqG+gL+ibmfRuBfd8s8OV9D4ErfeUlPTmvT5++u3f3Pf/+q/TNgw8Fdq/WzjRoo6+/YHK+63vZBuq703ej767WdyTwtX3deuMFn+3rr9f3Td9u+u4a+qY9z+bV33/z4COBt7xJX/eH9cDZ9r1sA/V903ej76b09YGxVnEk8Mp9Lxyw9H3Td6cvRF9fdHckr9I3D34+cNi7XixV9H9YDXw42fd1yZs7qC/oC/rGzuo7FHjlvu4h+kb07aRv7Ky+I3mVvnnv04Gfn7dfEcVSRfnDauBU6esec/4G6pvQV6Vv2ncs8MJ9w4Cl70bfTvomTuo7lFfpm/c+G9jlnbF/pe8VG6hvSl+VvoeYg4Gb/wr3rr6YAPUFffvomzqp71jevG+e+2xg54T9i74XbGBH34i+Gn2PLU8GvmyA6XSPnQce7NucAPXV6YuFgr7dhrxpy7G8+ftlnns4MFYa2x9Y4rq39M+9oHv6dtE38l/qeyKwa/vs+173AoyFJvb39TvYbWD3mI1AfXX6KvTtsdi3P6+8Xsr75aFvXvt8YP/Y1v0rfaXw/A3UN6avRl9jYJ928b4SqG9M3w76xs7s25831FX65rUHAsujY6WpvYXd9pWHdF6wgcNza/TtoG/sb+2rpuzt6wuHp3R3rAee27c78HsH9X3Tt4O+sXP74nPTbYDpTPPmsUcDY6WpvYHlCeFFGxgrTenbQd/Y39rXFjgq1Deib5u+sf9U39684QmDaV8lNpbdbwiMpaaeCixf+h/rOxir7qdvIlbdT99ErLpfjr62wFJYProfV+0rgd3/9N3p26ZvIlbdb6Vvb979AeXnuK/aGgvvtRa4s/B+Xflc30B9c/r0fYt194q+emB8brndXT4v2He/UN+Evm36HsS6e0Xf8Pyp+tG5+3Xly7hvoTWW3ufzM+4aK833L+Vb1cbpBbHyPvpmYuV99M3Eyvuk7CsL3z7ja83G6QWx8j5NfXE+/rBXrLyPvplYeR99M7HyPin77quWLyvrb5xeG7Zi/WVx3btExbK47l2iYllc9y5RsSyue5eoWBbXvUtULIvr3iUqlsV17xIVy+K6d4mKZXHdu0TFsrjuXaJiWVz3LlGxLK57l6hYFte9S1Qsi+teauu3RQAAl2OAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAdAwwAEA6BhgAIB0DDACQjgEGAEjHAAMApGOAAQDSMcAAAOkYYACAZP799/9U6bLI9L+tDwAAAABJRU5ErkJggg==",
			14, 80, 80);
			CreatureHurt = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAeAAAACgCAMAAADjJU9/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAMAUExURQAAAAU9IAxsQXVgQ7iVetS/r////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHiDNaAAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGXRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4wLjE3M26fYwAABYhJREFUeF7tmomS2joURCF2+P8/nmhpBttos9GWpk/VC4MsXXf1GZNJXm4/ghoJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYnI8EP7ZgbSZuW7A2E0jmwVptrs2F0xDYMRZ0dt+CNewYC7IgmQdr2FGN0wPhMQV2jsG1hM5CNOjwFL3znZsGg3mwvzfx7v68GOh4QL4To+CuEBzqSLQ9X5v7FZgOcagjY/KVDoK2M+BkH5LPxu4B8fRWPCxf2RgoOwkOdyDanq8uUKCtEIc7MDBfyRT4ugAGNCZRX6i5X3o9xEPz5WfA1TUwoyWp+gzhx8PT5SEenC83AqIugzHNyNS3AaXtaW54eL7MBGj6AAxqRLQ+FLRhiOHx+dIDIOkjMKoJkf5QzoEBhifIlzwPRR+CYQ041V+MhoZnyJc6DkGfg3m1CfeHXopp9yfiKfIlDsNODTCxLnX6sz/FtjE8R774WbipA2bW5NLnX+CyXWpheJJ80aMwUwtMrcel/kINupX6hmfJFzsJL/XA3FpE+jtfII7UNjxNvshBWKkJJtch1t/lAiv/pdY8+cLn4KQumF2DaH/Jv/mzvF1+FljV8ET5JBgLkwu+nC94DEYqg+EViPeXbs/wvgMrNQXPlK+j4HqGEwXaNlIthgr0hyoanilf6BR8VAfjPybVny3jvaQXbsMO++/cHg+zXk3wVPn4BKf/D6u9vsMsmP4ej1svwZ3zzSS4bFe2QAPK2YFL/qJ9Xde/jnV1980XeHPgTYKp8gVOuXEtwPww2FMgON/fFvv5Zr7/DVjwoDyPazBToBng9uYFz5VvEsHYYcFKnDMF+voMuwZ37TlWex3zQ6C9v2tlwe3z9RRswT324JoHa3HKCzSlYKgpEGuh+kwx67LYDsMlPuurLbhHvt6CHbgRwCLAYoKyAl0dmwKxfEcTW9Zfgi2+6jM7834ny/ceGHdsDG72fjssxynrz/Eq8HkIRWx5/izzxPS47fB221wvETxZvlGCLcG7uQwpThSIkfYPkQ7fwa6wdcEXB0yHrpptfWZzXcGI1zTfSMFBkCJOeYFuHr6+321Tpr1Dfbu3B2yJu+tLXcFd8n2J4MVWZ34P2/VnfktL9ffWr93fSHC7fN8hGPUd+jDv0gUe+l2aCW6YbzrBWcPlBdoG7YvvzoImPPZdssDDRTPENJo1PFk+asGeZXl+BKIJj3uXLPCA6c+MqSnY0zbffIJzhs8WaOoL9Xe6QPuAlDzCk+XjF2yw39kfF+j6CzwiRybLN6HgjOErBQb685wr0P+YmzE8Wb5vEBx8QDzlBbofYWyD9QU3zTej4LThCwW6/sIFFjdoCvRjcoYny/flgssfET/D0lPw5/kCYdHySJAkDGopp16B9tX8lzaMu5bTNF8wK2oeB3LEQDGl/H52BSgvcPOaFjxXvkhWFF0KTu14rrsNCWeZy2FQTRnLglM7bKXPV3wZJHM5DO5cRtN8qW9GX30C7BsF+omDfaNAijjY15Tcp434z5FgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJJkeCyZFgciSYHAkmR4LJkWByJJgcCSZHgsmRYHIkmBwJpubn5x8Du/CP6ZKb1gAAAABJRU5ErkJggg==",
			3, 80, 80);
			CreatureBott = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4wYVETYBV3z5JQAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAAB+UlEQVR42u3bzU3DMBgGYAf10i1A6hQdgGmQmIUDq3BggGyBGCNHc2wrxX9tgxN4ngtIbZLP9usvrZSGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUGXYVLX7Y0y+No2D5RTA9uCsxT0CvIVx/tZcdA3gX1kIFg/nIHj0DOMgfPQM4oPZo2fzEUC6EkC6dkEBRAfk/3ZBAUQH5P92QQFEB0QAYeMB9DgUOiDdNTYiAaRb+EJY4nlAT8UIX4PdAqV8LTTEeMOGaT02hq39XGH5uU7PyTQerr3QboGdcAj748dMh80N6vzv+XFx5v/URJwfGxMdPibOHWZqCJU1hcz75841ZMYfMudN1Zi77pC4Rm6DpdYpJNbqJsvt8v3xbWW7+m6TtoKae47l8trT+LrOAJ6C+FLoPjGzU0Omm5V2bix0nZquGTO7vvacNV2oNObSfIUrulvuTlKq9TS+aXxfdwAvw/ic2cG5W1bs3AFramvpVqlbeGmNYqG+mjG2zmv6/dP4ud5bcHs4H6/odDHz+aj0Wa9l59/jC1CpEw8NXb1UW7pjT+N3xVo8Jc9fc/wmA3hbeEtfjNZf45prBwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACg5AeYQa0I8Pr3rQAAAABJRU5ErkJggg==",
			1, 80, 80);
			CreatureFoam = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOwAAADsABataJCQAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAIVSURBVHhe7dLBTsIAFERR/v+nMe6voBUGtGeSs7npok3f5Xq9wstkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGd/YrdXzvLmMT/AXVu/9U/9l9W1PkfEB7P+u/vdhGX/BzrW6gR/JeJCdd3UP35LxIDv36ibuyniQnXt1E3dlPMis7uKmjAeZ1V3clPEgs8/VbXwp4y/ZeVf3cFPGB/nLq+/hCTI+0Tus3osXyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhJWMsJIRVjLCSkZYyQgrGWElI6xkhI3r5QPGwQeqRTAO1AAAAABJRU5ErkJggg==",
			1, 80, 80);
			
		//#endregion
		
		//#region OASIS
		m = "areas/Oasis/";
		p = m;
			
			 // Big Bubble:
			BigBubble    = sprite(p + "sprBigBubble",    1, 24, 24);
			BigBubblePop = sprite(p + "sprBigBubblePop", 4, 24, 24);
			
			 // Decals:
			BigTopDecal[? area_oasis] = sprite(p + "sprBigTopDecalOasis", 1, 32, 52);
			BigTopDecal[? "oasis"] = BigTopDecal[? area_oasis];
			
			 // Ground Crack Effect:
			Crack = sprite_add_base64("iVBORw0KGgoAAAANSUhEUgAAAEAAAAAgCAYAAACinX6EAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAZdEVYdFNvZnR3YXJlAHBhaW50Lm5ldCA0LjAuMTczbp9jAAABk0lEQVRoQ+WVS3KDQAxEOUQ22ed0OUPujhEVTWk6PWK+sSgWrwwPI0/3YHvb9/3RUPkkqHwSVEbg4+f7eOHXZkJlBLAAr5CRsqh8FxLEwq6jE7avz+Plr6+BygiUChAkMKNUkAeVUbCBvOCIFqX3elAZCRr8WDYF3oezGFRGIgvFgqqzmOs4D6EyCmn3C+Eyb6+Z86uvApWt1H7fWsEw6diDlIBzLVQiElDBa8KKAmRmCsLCY9ASx3u89VFZ4j8LqArnYe8/jnG+QqWHhMXAzI0yXICgM34LYGvMTmqQIedg06p1Wgb7sBayIBMorSk7aUVD2zJmgQFG0blYQjroQXcc/Qi6UyzECOwz5DjJHlbsvIIBRsH5CpW1zN59y8ynwFsnlVfoI7SyAAGD9IJzLVS2sLIEmc0CtXC1PipbWVnC+S8Doaqp+JGmMgqy+PMp6Cmh8geaygjgzp1FYMgCV7tuofJd6I4reF0Qz0IL3n0lqIzAVRCvIHQeVEagt4BWqLwLM0qg8k6MlkDlnXh8AWPs2wudfCE+JW5sAwAAAABJRU5ErkJggg==",
			2, 16, 16);
			
		//#endregion
		
		//#region TRENCH
		m = "areas/Trench/";
		p = m;
			
			 // Decals:
			BigTopDecal[?     "trench"] = sprite(p + "sprBigTopDecalTrench", 1, 32, 52);
			msk.BigTopDecal[? "trench"] = sprite(p + "../mskBigTopDecal",    1, 32, 16);
			
			 // Floors:
			FloorTrench      = sprite(p + "sprFloorTrench",      4, 0, 0);
			FloorTrenchB     = sprite(p + "sprFloorTrenchB",     4, 2, 2);
			FloorTrenchExplo = sprite(p + "sprFloorTrenchExplo", 5, 1, 1);
			FloorTrenchBreak = sprite(p + "sprFloorTrenchBreak", 3, 8, 8);
			DetailTrench     = sprite(p + "sprDetailTrench",     6, 4, 4);
			
			 // Walls:
			WallTrenchBot   = sprite(p + "sprWallTrenchBot",   4,  0,  0);
			WallTrenchTop   = sprite(p + "sprWallTrenchTop",   8,  0,  0);
			WallTrenchOut   = sprite(p + "sprWallTrenchOut",   1,  4, 12);
			WallTrenchTrans = sprite(p + "sprWallTrenchTrans", 8,  0,  0);
			DebrisTrench    = sprite(p + "sprDebrisTrench",    4,  4,  4);
			
			 // Decals:
			TopDecalTrench     = sprite(p + "sprTopDecalTrench",      2, 19, 24);
			TopDecalTrenchMine = sprite(p + "sprTopDecalTrenchMine",  1, 16, 24);
			TrenchMineDead     = sprite(p + "sprTrenchMineDead",     12, 12, 36);
			
			 // Proto Statue:
			PStatTrenchIdle   = sprite(p + "sprPStatTrenchIdle",    1, 40, 40);
			PStatTrenchHurt   = sprite(p + "sprPStatTrenchHurt",    3, 40, 40);
			PStatTrenchLights = sprite(p + "sprPStatTrenchLights", 40, 40, 40);
			
			//#region PITS
			p = m + "Pit/";
				
				 // Normal:
				Pit    = sprite(p + "sprPit",    1, 2, 2);
				PitTop = sprite(p + "sprPitTop", 1, 2, 2);
				PitBot = sprite(p + "sprPitBot", 1, 2, 2);
				
				 // Small:
				PitSmall    = sprite(p + "sprPitSmall",    1, 3, 3);
				PitSmallTop = sprite(p + "sprPitSmallTop", 1, 3, 3);
				PitSmallBot = sprite(p + "sprPitSmallBot", 1, 3, 3);
				
			//#endregion
			
			//#region PROPS
			p = m + "Props/";
				
				 // Eel Skeleton (big fat eel edition):
				EelSkullIdle = sprite(p + "sprEelSkeleton",     1, 24, 24);
				EelSkullHurt = sprite(p + "sprEelSkeletonHurt", 3, 24, 24);
				EelSkullDead = sprite(p + "sprEelSkeletonDead", 3, 24, 24);
				
				 // Kelp:
				KelpIdle = sprite(p + "sprKelp",     6, 16, 22);
				KelpHurt = sprite(p + "sprKelpHurt", 3, 16, 22);
				KelpDead = sprite(p + "sprKelpDead", 8, 16, 22);
				
				 // Vent:
				VentIdle = sprite(p + "sprVent",     1, 12, 14);
				VentHurt = sprite(p + "sprVentHurt", 3, 12, 14);
				VentDead = sprite(p + "sprVentDead", 3, 12, 14);
				
			//#endregion
			
		//#endregion
		
		//#region SEWERS
		m = "areas/Sewers/";
		p = m;
			
			 // Decals:
			BigTopDecal[? area_sewers] = sprite(p + "sprBigTopDecalSewers", 8, 32, 56);
			
			 // Fix Decal Not Fully Covering Wall:
			sprite_replace(sprSewerDecal, "sprites/" + p + "sprWallDecalSewer.png", 1, 16, 24);
			
			 // Manhole:
			PizzaManhole = [
				sprite(p + "sprPizzaManhole0", 2, 16, 16),
				sprite(p + "sprPizzaManhole1", 2, 16, 16),
				sprite(p + "sprPizzaManhole2", 2, 16, 16)
			];
			
			 // Sewer Pool:
			SewerPool        = sprite(p + "sprSewerPool",     8,  0,  0);
			msk.SewerPool    = sprite(p + "mskSewerPool",     1, 32, 64);
			SewerPoolBig     = sprite(p + "sprSewerPoolBig", 25,  0,  0);
			msk.SewerPoolBig = sprite(p + "mskSewerPoolBig",  1, 80, 80);
			
			 // Secret:
			FloorSewerWeb   = sprite(p + "sprFloorSewerWeb",   1, 0, 0);
			FloorSewerDrain = sprite(p + "sprFloorSewerDrain", 1, 0, 0);
			
			//#region PROPS
			p = m + "Props/"
				
				 // Sewer Drain:
				SewerDrainIdle = sprite(p + "sprSewerDrain",     8, 32, 38);
				SewerDrainHurt = sprite(p + "sprSewerDrainHurt", 3, 32, 38);
				SewerDrainDead = sprite(p + "sprSewerDrainDead", 5, 32, 38);
				
				 // Homage:
				GatorStatueIdle = sprite(p + "sprGatorStatue",     1, 16, 16);
				GatorStatueHurt = sprite(p + "sprGatorStatue",     1, 16, 16, shnHurt);
				GatorStatueDead = sprite(p + "sprGatorStatueDead", 4, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region PIZZA SEWERS
		m = "areas/Pizza/";
		p = m;
			
			 // Decals:
			BigTopDecal[? area_pizza_sewers] = sprite(p + "sprBigTopDecalPizza", 1, 32, 56);
			BigTopDecal[? "pizza"] = BigTopDecal[? area_pizza_sewers];
			
			 // Fix Decal Not Fully Covering Wall:
			sprite_replace(sprPizzaSewerDecal, "sprites/" + p + "sprWallDecalPizza.png", 1, 16, 24);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Door:
				PizzaDoor       = sprite(p + "sprPizzaDoor",       10, 2, 0);
				PizzaDoorDebris = sprite(p + "sprPizzaDoorDebris",  4, 4, 4);
				
				 // Drain:
				PizzaDrainIdle = sprite(p + "sprPizzaDrain",     8, 32, 38);
				PizzaDrainHurt = sprite(p + "sprPizzaDrainHurt", 3, 32, 38);
				PizzaDrainDead = sprite(p + "sprPizzaDrainDead", 5, 32, 38);
				msk.PizzaDrain = sprite(p + "mskPizzaDrain",     1, 32, 38);
				
				 // Rubble:
				PizzaRubbleIdle = sprite(p + "sprPizzaRubble",     1, 16, 0);
				PizzaRubbleHurt = sprite(p + "sprPizzaRubbleHurt", 3, 16, 0);
				msk.PizzaRubble = sprite(p + "mskPizzaRubble",     1, 16, 0);
				
				 // TV:
				TVHurt = sprite(p + "sprTVHurt", 3, 24, 16);
				
			//#endregion
			
		//#endregion
		
		//#region LAIR
		m = "areas/Lair/";
		p = m;
			
			 // Floors:
			FloorLair      = sprite(p + "sprFloorLair",      4, 0, 0);
			FloorLairB     = sprite(p + "sprFloorLairB",     8, 0, 0);
			FloorLairExplo = sprite(p + "sprFloorLairExplo", 4, 1, 1);
			DetailLair     = sprite(p + "sprDetailLair",     6, 4, 4);
			
			 // Walls:
			WallLairBot   = sprite(p + "sprWallLairBot",   4,  0,  0);
			WallLairTop   = sprite(p + "sprWallLairTop",   4,  0,  0);
			WallLairOut   = sprite(p + "sprWallLairOut",   5,  4, 12);
			WallLairTrans = sprite(p + "sprWallLairTrans", 1,  0,  0);
			DebrisLair    = sprite(p + "sprDebrisLair",    4,  4,  4);
			
			 // Decals:
			TopDecalLair  = sprite(p + "sprTopDecalLair",  2, 16, 16);
			WallDecalLair = sprite(p + "sprWallDecalLair", 1, 16, 24);
			
			 // Manholes:
			Manhole               = sprite(p + "sprManhole",               12, 16, 48);
			ManholeOpen           = sprite(p + "sprManholeOpen",            1, 16, 16);
			BigManhole            = sprite(p + "sprBigManhole",             6, 32, 32);
			BigManholeOpen        = sprite(p + "sprBigManholeOpen",         1, 32, 32);
			BigManholeFloor       = sprite(p + "sprBigManholeFloor",        4,  0,  0);
			BigManholeDebris      = sprite(p + "sprBigManholeDebris",       4,  4,  4);
			BigManholeDebrisChunk = sprite(p + "sprBigManholeDebrisChunk",  3, 12, 12);
			with([ManholeOpen, BigManholeOpen]){
				mask = [false, 0];
			}
			
			//#region PROPS
			p = m + "Props/";
				
				 // Cabinet:
				CabinetIdle = sprite(p + "sprCabinet",     1, 12, 12);
				CabinetHurt = sprite(p + "sprCabinet",     1, 12, 12, shnHurt);
				CabinetDead = sprite(p + "sprCabinetDead", 3, 12, 12);
				Paper       = sprite(p + "sprPaper",       3,  5,  6);
				
				/// Chairs:
					
					 // Side:
					ChairSideIdle  = sprite(p + "sprChairSide",     1, 12, 12);
					ChairSideHurt  = sprite(p + "sprChairSide",     1, 12, 12, shnHurt);
					ChairSideDead  = sprite(p + "sprChairSideDead", 3, 12, 12);
					
					 // Front:
					ChairFrontIdle = sprite(p + "sprChairFront",     1, 12, 12);
					ChairFrontHurt = sprite(p + "sprChairFront",     1, 12, 12, shnHurt);
					ChairFrontDead = sprite(p + "sprChairFrontDead", 3, 12, 12);
					
				 // Couch:
				CouchIdle = sprite(p + "sprCouch",     1, 32, 32);
				CouchHurt = sprite(p + "sprCouch",     1, 32, 32, shnHurt);
				CouchDead = sprite(p + "sprCouchDead", 3, 32, 32);
				
				 // Door:
				CatDoor       = sprite(p + "sprCatDoor",       10, 2, 0);
				CatDoorDebris = sprite(p + "sprCatDoorDebris",  4, 4, 4);
				msk.CatDoor   = sprite(p + "mskCatDoor",        1, 4, 0);
				
				 // Rug:
				Rug = sprite(p + "sprRug", 2, 26, 26);
				
				 // Soda Machine:
				SodaMachineIdle = sprite(p + "sprSodaMachine",     1, 16, 16);
				SodaMachineHurt = sprite(p + "sprSodaMachine",     1, 16, 16, shnHurt);
				SodaMachineDead = sprite(p + "sprSodaMachineDead", 3, 16, 16);
				
				 // Table:
				TableIdle = sprite(p + "sprTable",     1, 16, 16);
				TableHurt = sprite(p + "sprTable",     1, 16, 16, shnHurt);
				TableDead = sprite(p + "sprTableDead", 3, 16, 16);
				
			//#endregion
			
		//#endregion
		
		//#region RED
		m = "areas/Crystal/";
		p = m;
			
			 // Floors:
			FloorRed      = sprite(p + "sprFloorCrystal",      1, 2, 2);
			FloorRedB     = sprite(p + "sprFloorCrystalB",     1, 2, 2);
			FloorRedExplo = sprite(p + "sprFloorCrystalExplo", 4, 1, 1);
			FloorRedRoom  = sprite(p + "sprFloorCrystalRoom",  4, 2, 2);
			DetailRed     = sprite(p + "sprDetailCrystal",     5, 4, 4);
			
			 // Walls:
			WallRedBot   = sprite(p + "sprWallCrystalBot",    2, 0,  0);
			WallRedTop   = sprite(p + "sprWallCrystalTop",    4, 0,  0);
			WallRedOut   = sprite(p + "sprWallCrystalOut",    1, 4, 12);
			WallRedTrans = sprite(p + "sprWallCrystalTrans",  4, 1,  1);
			WallRedFake  =[sprite(p + "sprWallCrystalFake1", 16, 0,  0),
			               sprite(p + "sprWallCrystalFake2", 16, 0,  0)];
			DebrisRed    = sprite(p + "sprDebrisCrystal",     4, 4,  4);
			with(WallRedTrans){
				mask = [false, 2, x, y, x + 15, y + 15, 1];
			}
			
			 // Fake Walls:
			WallFakeBot = sprite(p + "sprWallFakeBot", 16, 0, 0);
			WallFakeTop = sprite(p + "sprWallFakeTop",  1, 0, 8);
			WallFakeOut = sprite(p + "sprWallFakeOut",  1, 1, 9);
			
			 // Decals:
			WallDecalRed = sprite(p + "sprWallDecalCrystal", 1, 16, 24);
			
			 // Warp:
			Warp        = sprite(p + "sprWarp",        2, 16, 16);
			WarpOpen    = sprite(p + "sprWarpOpen",    2, 32, 32);
			WarpOpenOut = sprite(p + "sprWarpOpenOut", 4, 32, 32);
			
			 // Misc:
			RedDot          = sprite(p + "sprRedDot",           9,   7,   7);
			RedText         = sprite(p + "sprRedText",         12,  12,   4);
			Starfield       = sprite(p + "sprStarfield",        2, 256, 256);
			SpiralStarfield = sprite(p + "sprSpiralStarfield",  2,  32,  32);
			
			//#region PROPS
			p = m + "Props/";
				
				 // Red Crystals:
				CrystalPropRedIdle = sprite(p + "sprCrystalPropRed",     1, 12, 12);
				CrystalPropRedHurt = sprite(p + "sprCrystalPropRed",     1, 12, 12, shnHurt);
				CrystalPropRedDead = sprite(p + "sprCrystalPropRedDead", 4, 12, 12);
				
				 // White Crystals:
				CrystalPropWhiteIdle = sprite(p + "sprCrystalPropWhite",     1, 12, 12);
				CrystalPropWhiteHurt = sprite(p + "sprCrystalPropWhiteHurt", 3, 12, 12);
				CrystalPropWhiteDead = sprite(p + "sprCrystalPropWhiteDead", 4, 12, 12);
				
			//#endregion
			
		//#endregion
		
		//#region IDPD HQ
		m = "areas/HQ/";
		p = m;
			
			 // Floors:
			Floor106Small        = sprite(p + "sprFloor106Small",    4,  0,  0);
			FloorMiddleSmall     = sprite(p + "sprFloorMiddleSmall", 1, 32, 32);
			msk.FloorMiddleSmall = sprite(p + "mskFloorMiddleSmall", 1, 32, 32);
			with(msk.FloorMiddleSmall){
				mask = [false, 0];
			}
			
		//#endregion
		
		//#region CRIB
		m = "areas/Crib/";
		p = m;
			
			 // TV Shadow:
			shd.VenuzTV = sprite(p + "shdVenuzTV", 1, 129, 96);
			
		//#endregion
		
		//#region CHESTS/PICKUPS
		m = "chests/";
		p = m;
			
			 // Cursed Ammo Chests:
			CursedAmmoChest             = sprite(p + "sprCursedAmmoChest",              1,  8,  8, shn16);
			CursedAmmoChestOpen         = sprite(p + "sprCursedAmmoChestOpen",          1,  8,  8);
			CursedAmmoChestSteroids     = sprite(p + "sprCursedAmmoChestSteroids",      1, 12, 12, shn20);
			CursedAmmoChestSteroidsOpen = sprite(p + "sprCursedAmmoChestSteroidsOpen",  1, 12, 12);
			CursedMimicIdle             = sprite(p + "sprCursedMimicIdle",              1, 16, 16);
			CursedMimicFire             = sprite(p + "sprCursedMimicFire",              4, 16, 16);
			CursedMimicHurt             = sprite(p + "sprCursedMimicHurt",              3, 16, 16);
			CursedMimicDead             = sprite(p + "sprCursedMimicDead",              6, 16, 16);
			CursedMimicTell             = sprite(p + "sprCursedMimicTell",             12, 16, 16);
			
			 // Backpack:
			Backpack           = sprite(p + "sprBackpack",            1, 8, 8, shn16);
			BackpackCursed     = sprite(p + "sprBackpackCursed",      1, 8, 8, shn16);
			BackpackOpen       = sprite(p + "sprBackpackOpen",        1, 8, 8);
			BackpackCursedOpen = sprite(p + "sprBackpackCursedOpen",  1, 8, 8);
			BackpackDebris     = sprite(p + "sprBackpackDebris",     30, 6, 6);
			
			 // Deceased Backpacker:
			BackpackerIdle = [sprite(p + "sprBackpacker0", 1, 12, 12),
			                  sprite(p + "sprBackpacker1", 1, 12, 12),
			                  sprite(p + "sprBackpacker2", 1, 12, 12)];
			BackpackerHurt = [sprite(p + "sprBackpacker0", 1, 12, 12, shnHurt),
			                  sprite(p + "sprBackpacker1", 1, 12, 12, shnHurt),
			                  sprite(p + "sprBackpacker2", 1, 12, 12, shnHurt)];
			
			 // Bat/Cat Chests:
			BatChest              = sprite(p + "sprBatChest",              1, 10, 10, shn20);
			BatChestCursed        = sprite(p + "sprBatChestCursed",        1, 10, 10, shn20);
			BatChestBig           = sprite(p + "sprBatChestBig",           1, 12, 12, shn24);
			BatChestBigCursed     = sprite(p + "sprBatChestBigCursed",     1, 12, 12, shn24);
			CatChest              = sprite(p + "sprCatChest",              1, 10, 10, shn20);
			BatChestOpen          = sprite(p + "sprBatChestOpen",          1, 10, 10);
			BatChestCursedOpen    = sprite(p + "sprBatChestCursedOpen",    1, 10, 10);
			BatChestBigOpen       = sprite(p + "sprBatChestBigOpen",       1, 12, 12);
			BatChestBigCursedOpen = sprite(p + "sprBatChestBigCursedOpen", 1, 12, 12);
			CatChestOpen          = sprite(p + "sprCatChestOpen",          1, 10, 10);
			
			 // Cat Crates:
			WallCrateBot = sprite(p + "sprWallCrateBot", 2,  2,  2);
			WallCrateTop = sprite(p + "sprWallCrateTop", 4,  4,  4);
			WallCrateOut = sprite(p + "sprWallCrateTop", 4,  4, 12);
			FloorCrate   = sprite(p + "sprFloorCrate",   1, 18, 18);
			
			 // Bone:
			BonePickup    = [sprite(p + "sprBonePickup0",    1, 4, 4, shn8),
			                 sprite(p + "sprBonePickup1",    1, 4, 4, shn8),
			                 sprite(p + "sprBonePickup2",    1, 4, 4, shn8),
			                 sprite(p + "sprBonePickup3",    1, 4, 4, shn8)];
			BonePickupBig = [sprite(p + "sprBoneBigPickup0", 1, 8, 8, shn16),
			                 sprite(p + "sprBoneBigPickup1", 1, 8, 8, shn16)];
			
			 // Bonus Pickups:
			BonusFX                    = sprite(p + "sprBonusFX",                    13,  4, 12);
			BonusFXPickupOpen          = sprite(p + "sprBonusFXPickupOpen",           6,  8,  8);
			BonusFXPickupFade          = sprite(p + "sprBonusFXPickupFade",           5,  8,  8);
			BonusFXChestOpen           = sprite(p + "sprBonusFXChestOpen",            8, 16, 16);
			BonusHealFX                = sprite(p + "sprBonusHealFX",                 7,  8, 10);
			BonusHealBigFX             = sprite(p + "sprBonusHealBigFX",              8, 12, 24);
			BonusShell                 = sprite(p + "sprBonusShell",                  1,  1,  2);
			BonusShellHeavy            = sprite(p + "sprBonusShellHeavy",             1,  2,  3);
			BonusText                  = sprite(p + "sprBonusText",                  12,  0,  0);
			BonusAmmoPickup            = sprite(p + "sprBonusAmmoPickup",             1,  5,  5, shn10);
			BonusHealthPickup          = sprite(p + "sprBonusHealthPickup",           1,  5,  5, shn10);
			BonusAmmoChest             = sprite(p + "sprBonusAmmoChest",             15,  8,  8);
			BonusAmmoChestOpen         = sprite(p + "sprBonusAmmoChestOpen",          1,  8,  8);
			BonusAmmoChestSteroids     = sprite(p + "sprBonusAmmoChestSteroids",     15, 12, 12);
			BonusAmmoChestSteroidsOpen = sprite(p + "sprBonusAmmoChestSteroidsOpen",  1, 12, 12);
			BonusHealthChest           = sprite(p + "sprBonusHealthChest",           15,  8,  8);
			BonusHealthChestOpen       = sprite(p + "sprBonusHealthChestOpen",        1,  8,  8);
			BonusAmmoMimicIdle         = sprite(p + "sprBonusAmmoMimicIdle",          1, 16, 16);
			BonusAmmoMimicTell         = sprite(p + "sprBonusAmmoMimicTell",         12, 16, 16);
			BonusAmmoMimicHurt         = sprite(p + "sprBonusAmmoMimicHurt",          3, 16, 16);
			BonusAmmoMimicDead         = sprite(p + "sprBonusAmmoMimicDead",          6, 16, 16);
			BonusAmmoMimicFire         = sprite(p + "sprBonusAmmoMimicFire",          4, 16, 16);
			BonusHealthMimicIdle       = sprite(p + "sprBonusHealthMimicIdle",        1, 16, 16);
			BonusHealthMimicTell       = sprite(p + "sprBonusHealthMimicTell",       10, 16, 16);
			BonusHealthMimicHurt       = sprite(p + "sprBonusHealthMimicHurt",        3, 16, 16);
			BonusHealthMimicDead       = sprite(p + "sprBonusHealthMimicDead",        6, 16, 16);
			BonusHealthMimicFire       = sprite(p + "sprBonusHealthMimicFire",        4, 16, 16);
			
			 // Buried Vault:
			BuriedVaultChest       = sprite(p + "sprVaultChest",       1, 12, 12, shn24);
			BuriedVaultChestOpen   = sprite(p + "sprVaultChestOpen",   1, 12, 12);
			BuriedVaultChestDebris = sprite(p + "sprVaultChestDebris", 8, 12, 12);
			BuriedVaultChestBase   = sprite(p + "sprVaultChestBase",   3, 16, 12);
			ProtoChestMerge        = sprite(p + "sprProtoChestMerge",  6, 12, 12);
			
			 // Button Chests:
			ButtonChest        = sprite(p + "sprButtonChest",        1, 9, 9, shn20);
			ButtonChestDebris  = sprite(p + "sprButtonChestDebris",  2, 9, 9);
			ButtonPickup       = sprite(p + "sprButtonPickup",       1, 6, 6, shn12);
			ButtonPickupDebris = sprite(p + "sprButtonPickupDebris", 2, 6, 6);
			
			 // Red Ammo:
			RedAmmoChest     = sprite(p + "sprRedAmmoChest",     1, 8, 8, shn16);
			RedAmmoChestOpen = sprite(p + "sprRedAmmoChestOpen", 1, 8, 8);
			RedAmmoPickup    = sprite(p + "sprRedAmmoPickup",    1, 5, 5, shn10);
			RedAmmoHUD       = sprite(p + "sprRedAmmoHUD",       2, 1, 1);
			RedAmmoHUDAmmo   = sprite(p + "sprRedAmmoHUDAmmo",   2, 1, 2);
			RedAmmoHUDFill   = sprite(p + "sprRedAmmoHUDFill",   2, 0, 0);
			RedAmmoHUDCost   = sprite(p + "sprRedAmmoHUDCost",   2, 2, 2);
			
			 // Red Crystal Chest:
			RedChest     = sprite(p + "sprRedChest",     1, 8, 8, shn16);
			RedChestOpen = sprite(p + "sprRedChestOpen", 1, 8, 8);
			
			 // Orchid Chest:
			OrchidChest     = sprite(p + "sprOrchidChest",     1, 12, 8, shn24);
			OrchidChestOpen = sprite(p + "sprOrchidChestOpen", 1, 12, 8);
			
			 // Spirit Pickup:
			SpiritPickup = sprite(p + "sprSpiritPickup", 1, 5, 5, shn10);
			
			 // Hammerhead Pickup:
			HammerHeadPickup            = sprite(p + "sprHammerHeadPickup",            1,  5, 5, shn10);
			HammerHeadPickupEffect      = sprite(p + "sprHammerHeadPickupEffect",      3, 16, 8);
			HammerHeadPickupEffectSpawn = sprite(p + "sprHammerHeadPickupEffectSpawn", 9, 16, 8);
			
			 // Sunken Chest:
			SunkenChest     = sprite(p + "sprSunkenChest",     1, 12, 12, shn24);
			SunkenChestOpen = sprite(p + "sprSunkenChestOpen", 1, 12, 12);
			SunkenCoin      = sprite(p + "sprCoin",            1,  3,  3, shn8);
			SunkenCoinBig   = sprite(p + "sprCoinBig",         1,  3,  3, shn8);
			
		//#endregion
		
		//#region RACES
		m = "races/";
			
			var _list = {
				// [Name, Frames, X, Y, Has B Variant]
				
				"parrot" : {
					skin : 2,
					sprt : [
						["Loadout",       2, 16,  16, true],
						["Map",           1, 10,  10, true],
						["Portrait",      1, 20, 221, true],
						["Select",        2,  0,   0, false],
						["UltraIcon",     2, 12,  16, false],
						["UltraHUDA",     1,  8,   9, false],
						["UltraHUDB",     1,  8,   9, false],
						["Idle",          4, 12,  12, true],
						["Walk",          6, 12,  12, true],
						["Hurt",          3, 12,  12, true],
						["Dead",          6, 12,  12, true],
						["GoSit",         3, 12,  12, true],
						["Sit",           1, 12,  12, true],
						["MenuSelected", 10, 16,  16, false],
						["Feather",       1,  3,   4, true],
						["FeatherHUD",    1,  5,   5, false]
					]
				}/*,
					
				"???" : {
					skin : 2,
					sprt : [
						["Loadout",   2, 16,  16, true],
						["Map",       1, 10,  10, true],
						["Portrait",  1, 40, 243, true],
						["Select",    2,  0,   0, false],
						["UltraIcon", 2, 12,  16, false],
						["UltraHUDA", 1,  8,   9, false],
						["UltraHUDB", 1,  8,   9, false],
						["Idle",      8, 12,  12, true],
						["Walk",      6, 12,  12, true],
						["Hurt",      3, 12,  12, true],
						["Dead",      6, 12,  12, true],
						["GoSit",     3, 12,  12, true],
						["Sit",       1, 12,  12, true]
					]
				}*/
			};
			
			Race = {};
			
			for(var i = 0; i < lq_size(_list); i++){
				var	_race = lq_get_key(_list, i),
					_info = lq_get_value(_list, i);
					
				lq_set(Race, _race, []);
				
				for(var b = 0; b < _info.skin; b++){
					var	_sprt = {},
						n = string_upper(string_char_at(_race, 0)) + string_delete(_race, 1, 1);
						
					p = m + n + "/spr" + n;
					
					with(lq_get_value(_list, i).sprt){
						var	_name = self[0],
							_img  = self[1],
							_x    = self[2],
							_y    = self[3],
							_hasB = self[4];
							
						lq_set(_sprt, _name, sprite(p + ((_hasB && b > 0) ? chr(ord("A") + b) : "") + _name, _img, _x, _y));
					}
					
					array_push(lq_get(Race, _race), _sprt);
				}
			}
			
			 // Parrot Charm:
			p = m + "Parrot/";
			AllyReviveArea      = sprite(p + "sprAllyReviveArea",      4, 35, 45);
			AllyNecroReviveArea = sprite(p + "sprAllyNecroReviveArea", 4, 17, 20);
			
		//#endregion
		
		//#region SKINS
		m = "skins/";
			
			 // Red Crystal:
			p = m + "CrystalRed/";
			CrystalRedPortrait        = sprite(p + "sprCrystalRedPortrait",        1, 20, 229);
			CrystalRedIdle            = sprite(p + "sprCrystalRedIdle",            4, 12,  12);
			CrystalRedWalk            = sprite(p + "sprCrystalRedWalk",            6, 12,  12);
			CrystalRedHurt            = sprite(p + "sprCrystalRedHurt",            3, 12,  12);
			CrystalRedDead            = sprite(p + "sprCrystalRedDead",            6, 12,  12);
			CrystalRedGoSit           = sprite(p + "sprCrystalRedGoSit",           3, 12,  12);
			CrystalRedSit             = sprite(p + "sprCrystalRedSit",             1, 12,  12);
			CrystalRedLoadout         = sprite(p + "sprCrystalRedLoadout",         2, 16,  16);
			CrystalRedMapIcon         = sprite(p + "sprCrystalRedMapIcon",         1, 10,  10);
			CrystalRedShield          = sprite(p + "sprCrystalRedShield",          4, 32,  42);
			CrystalRedShieldDisappear = sprite(p + "sprCrystalRedShieldDisappear", 6, 32,  42);
			CrystalRedShieldIdleFront = sprite(p + "sprCrystalRedShieldIdleFront", 1, 32,  42);
			CrystalRedShieldWalkFront = sprite(p + "sprCrystalRedShieldWalkFront", 8, 32,  42);
			CrystalRedShieldIdleBack  = sprite(p + "sprCrystalRedShieldIdleBack",  1, 32,  42);
			CrystalRedShieldWalkBack  = sprite(p + "sprCrystalRedShieldWalkBack",  8, 32,  42);
			CrystalRedTrail           = sprite(p + "sprCrystalRedTrail",           5,  8,   8);
			
		//#endregion
		
		//#region PETS
		m = "pets/";
			
			 // General:
			PetArrow = sprite(m + "sprPetArrow", 1, 3,  0);
			PetLost  = sprite(m + "sprPetLost",  7, 8, 16);
			
			 // Scorpion:
			p = m + "Desert/";
			PetScorpionIcon   = sprite(p + "sprPetScorpionIcon",   1,  6,  6);
			PetScorpionIdle   = sprite(p + "sprPetScorpionIdle",   4, 16, 16);
			PetScorpionWalk   = sprite(p + "sprPetScorpionWalk",   6, 16, 16);
			PetScorpionHurt   = sprite(p + "sprPetScorpionHurt",   3, 16, 16);
			PetScorpionDead   = sprite(p + "sprPetScorpionDead",   6, 16, 16);
			PetScorpionFire   = sprite(p + "sprPetScorpionFire",   6, 16, 16);
			PetScorpionShield = sprite(p + "sprPetScorpionShield", 6, 16, 16);
			
			 // Parrot:
			p = m + "Coast/";
			PetParrotNote  = sprite(p + "sprPetParrotNote",   5,  4,  4);
			PetParrotIcon  = sprite(p + "sprPetParrotIcon",   1,  6,  6);
			PetParrotIdle  = sprite(p + "sprPetParrotIdle",   6, 12, 12);
			PetParrotWalk  = sprite(p + "sprPetParrotWalk",   6, 12, 14);
			PetParrotHurt  = sprite(p + "sprPetParrotDodge",  3, 12, 12);
			PetParrotBIcon = sprite(p + "sprPetParrotBIcon",  1,  6,  6);
			PetParrotBIdle = sprite(p + "sprPetParrotBIdle",  6, 12, 12);
			PetParrotBWalk = sprite(p + "sprPetParrotBWalk",  6, 12, 14);
			PetParrotBHurt = sprite(p + "sprPetParrotBDodge", 3, 12, 12);
			
			 // CoolGuy:
			p = m + "Pizza/";
			PetCoolGuyIcon = sprite(p + "sprPetCoolGuyIcon",  1,  6,  6);
			PetCoolGuyIdle = sprite(p + "sprPetCoolGuyIdle",  4, 12, 12);
			PetCoolGuyWalk = sprite(p + "sprPetCoolGuyWalk",  6, 12, 12);
			PetCoolGuyHurt = sprite(p + "sprPetCoolGuyDodge", 3, 12, 12);
			
			PetPeasIcon    = sprite(p + "sprPetPeasIcon",     1,  6,  6);
			PetPeasIdle    = sprite(p + "sprPetPeasIdle",     4, 12, 12);
			PetPeasWalk    = sprite(p + "sprPetPeasWalk",     6, 12, 12);
			PetPeasHurt    = sprite(p + "sprPetPeasDodge",    3, 12, 12);
			
			 // BabyShark:
			p = m + "Oasis/";
			PetSlaughterIcon  = sprite(p + "sprPetSlaughterIcon",   1,  6,  6);
			PetSlaughterIdle  = sprite(p + "sprPetSlaughterIdle",   4, 12, 12);
			PetSlaughterWalk  = sprite(p + "sprPetSlaughterWalk",   6, 12, 12);
			PetSlaughterHurt  = sprite(p + "sprPetSlaughterHurt",   3, 12, 12);
			PetSlaughterDead  = sprite(p + "sprPetSlaughterDead",  10, 24, 24);
			PetSlaughterSpwn  = sprite(p + "sprPetSlaughterSpwn",   7, 24, 24);
			PetSlaughterBite  = sprite(p + "sprPetSlaughterBite",   6, 12, 12);
			SlaughterBite     = sprite(p + "sprSlaughterBite",      6,  8, 12);
			SlaughterPropIdle = sprite(p + "sprSlaughterPropIdle",  1, 12, 12);
			SlaughterPropHurt = sprite(p + "sprSlaughterPropHurt",  3, 12, 12);
			SlaughterPropDead = sprite(p + "sprSlaughterPropDead",  3, 12, 12);
			
			 // Octopus:
			p = m + "Trench/";
			PetOctoIcon     = sprite(p + "sprPetOctoIcon",      1,  7,  7);
			PetOctoIdle     = sprite(p + "sprPetOctoIdle",     16, 12, 12);
			PetOctoHurt     = sprite(p + "sprPetOctoDodge",     3, 12, 12);
			PetOctoHide     = sprite(p + "sprPetOctoHide",     30, 12, 12);
			PetOctoHideIcon = sprite(p + "sprPetOctoHideIcon",  1,  7,  6);
			
			 // Salamander:
			p = m + "Scrapyards/";
			PetSalamanderIcon = sprite(p + "sprPetSalamanderIcon", 1,  6,  6);
			PetSalamanderIdle = sprite(p + "sprPetSalamanderIdle", 6, 16, 16);
			PetSalamanderWalk = sprite(p + "sprPetSalamanderWalk", 8, 16, 16);
			PetSalamanderHurt = sprite(p + "sprPetSalamanderHurt", 3, 16, 16);
			PetSalamanderChrg = sprite(p + "sprPetSalamanderChrg", 3, 16, 16);
			
			 // Golden Chest Mimic:
			p = m + "Mansion/";
			PetMimicIcon = sprite(p + "sprPetMimicIcon",   1,  6,  6);
			PetMimicIdle = sprite(p + "sprPetMimicIdle",  16, 16, 16);
			PetMimicWalk = sprite(p + "sprPetMimicWalk",   6, 16, 16);
			PetMimicHurt = sprite(p + "sprPetMimicDodge",  3, 16, 16);
			PetMimicOpen = sprite(p + "sprPetMimicOpen",   1, 16, 16);
			PetMimicHide = sprite(p + "sprPetMimicHide",   1, 16, 16);
			
			 // Spider
			p = m + "Caves/";
			PetSpiderIcon       = sprite(p + "sprPetSpiderIcon",        1,  6,  6);
			PetSpiderIdle       = sprite(p + "sprPetSpiderIdle",        8, 16, 16);
			PetSpiderWalk       = sprite(p + "sprPetSpiderWalk",        6, 16, 16);
			PetSpiderHurt       = sprite(p + "sprPetSpiderDodge",       3, 16, 16);
			PetSpiderWeb        = sprite(p + "sprPetSpiderWeb",         1,  0,  0);
			PetSpiderWebBits    = sprite(p + "sprWebBits",              5,  4,  4);
			PetSparkle          = sprite(p + "sprPetSparkle",           5,  8,  8);
			PetSpiderCursedIcon = sprite(p + "sprPetSpiderCursedIcon",  1,  6,  6);
			PetSpiderCursedIdle = sprite(p + "sprPetSpiderCursedIdle",  8, 16, 16);
			PetSpiderCursedWalk = sprite(p + "sprPetSpiderCursedWalk",  6, 16, 16);
			PetSpiderCursedHurt = sprite(p + "sprPetSpiderCursedDodge", 3, 16, 16);
			PetSpiderCursedKill = sprite(p + "sprPetSpiderCursedKill",  6, 16, 16);
			
			 // Prism:
			p = m + "Cursed Caves/";
			PetPrismIcon = sprite(p + "sprPetPrismIcon", 1,  6,  6);
			PetPrismIdle = sprite(p + "sprPetPrismIdle", 6, 12, 12);
			
			 // Mantis:
			p = m + "Vault/";
			PetOrchidIcon = sprite(p + "sprPetOrchidIcon",  1,  6,  6);
			PetOrchidIdle = sprite(p + "sprPetOrchidIdle", 28, 12, 12);
			PetOrchidWalk = sprite(p + "sprPetOrchidWalk",  6, 12, 12);
			PetOrchidHurt = sprite(p + "sprPetOrchidHurt",  3, 12, 12);
			PetOrchidBall = sprite(p + "sprPetOrchidBall",  2, 12, 12);
			
			 // Weapon Chest Mimic:
			p = m + "Weapon/";
			PetWeaponIcon       = sprite(p + "sprPetWeaponIcon",        1,  6,  6);
			PetWeaponChst       = sprite(p + "sprPetWeaponChst",        1,  8,  8);
			PetWeaponHide       = sprite(p + "sprPetWeaponHide",        8, 12, 12);
			PetWeaponSpwn       = sprite(p + "sprPetWeaponSpwn",       16, 12, 12);
			PetWeaponIdle       = sprite(p + "sprPetWeaponIdle",        8, 12, 12);
			PetWeaponWalk       = sprite(p + "sprPetWeaponWalk",        8, 12, 12);
			PetWeaponHurt       = sprite(p + "sprPetWeaponHurt",        3, 12, 12);
			PetWeaponDead       = sprite(p + "sprPetWeaponDead",        6, 12, 12);
			PetWeaponStat       = sprite(p + "sprPetWeaponStat",        1, 20,  5);
			PetWeaponIconCursed = sprite(p + "sprPetWeaponIconCursed",  1,  6,  6);
			PetWeaponChstCursed = sprite(p + "sprPetWeaponChstCursed",  1,  8,  8);
			PetWeaponHideCursed = sprite(p + "sprPetWeaponHideCursed",  8, 12, 12);
			PetWeaponSpwnCursed = sprite(p + "sprPetWeaponSpwnCursed", 16, 12, 12);
			PetWeaponIdleCursed = sprite(p + "sprPetWeaponIdleCursed",  8, 12, 12);
			PetWeaponWalkCursed = sprite(p + "sprPetWeaponWalkCursed",  8, 12, 12);
			PetWeaponHurtCursed = sprite(p + "sprPetWeaponHurtCursed",  3, 12, 12);
			PetWeaponDeadCursed = sprite(p + "sprPetWeaponDeadCursed",  6, 12, 12);
			
			 // Twins:
			p = m + "Red/";
			PetTwinsIcon        = sprite(p + "sprPetTwinsIcon",        1,  6,  6);
			PetTwinsStat        = sprite(p + "sprPetTwinsStat",        6, 12, 12);
			PetTwinsRed         = sprite(p + "sprPetTwinsRed",         6, 12, 12);
			PetTwinsRedIcon     = sprite(p + "sprPetTwinsRedIcon",     1,  6,  6);
			PetTwinsRedEffect   = sprite(p + "sprPetTwinsRedEffect",   6,  8,  8);
			PetTwinsWhite       = sprite(p + "sprPetTwinsWhite",       6, 12, 12);
			PetTwinsWhiteIcon   = sprite(p + "sprPetTwinsWhiteIcon",   1,  6,  6);
			PetTwinsWhiteEffect = sprite(p + "sprPetTwinsWhiteEffect", 6,  8,  8);
			CrystalWhiteTrail   = sprite(p + "sprCrystalWhiteTrail",   5,  8,  8);
			
		//#endregion
	}
	
	 // SOUNDS //
	snd = {};
	with(snd){
		var	m = "sounds/enemies/",
			p;
			
		 // Palanking:
		p = m + "Palanking/";
		PalankingHurt  = sound_add(p + "sndPalankingHurt.ogg");
		PalankingDead  = sound_add(p + "sndPalankingDead.ogg");
		PalankingCall  = sound_add(p + "sndPalankingCall.ogg");
		PalankingSwipe = sound_add(p + "sndPalankingSwipe.ogg");
		PalankingTaunt = sound_add(p + "sndPalankingTaunt.ogg");
		sound_volume(PalankingHurt, 0.6);
		
		 // SawTrap:
		p = m + "SawTrap/";
		SawTrap = sound_add(p + "sndSawTrap.ogg");
		
		 // Music:
		mus = {};
		with(mus){
			var p = "sounds/music/";
			amb = {};
			
			 // Areas:
			Coast  = sound_add(p + "musCoast.ogg");
			CoastB = sound_add(p + "musCoastB.ogg");
			Trench = sound_add(p + "musTrench.ogg");
			Lair   = sound_add(p + "musLair.ogg");
			Red    = sound_add(p + "musRed.ogg");
			
			 // Bosses:
			SealKing      = sound_add(p + "musSealKing.ogg");
			BigShots      = sound_add(p + "musBigShots.ogg");
			PitSquid      = sound_add(p + "musPitSquid.ogg");
			PitSquidIntro = sound_add(p + "musPitSquidIntro.ogg");
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
		save_ntte();
		save_auto = true;
		
		exit;
	}
	
	 // Surface, Shader, Script Binding Storage:
	global.surf = ds_map_create();
	global.shad = ds_map_create();
	global.bind = ds_map_create();
	
	 // Compile Mod Lists:
	ntte_mods = {
		"mod"   : [],
		"wep"   : [],
		"area"  : [],
		"race"  : [],
		"skin"  : [],
		"skill" : [],
		"crown" : []
	};
	if(fork()){
		var _find = [];
		
		file_find_all(".", _find, 1);
		while(array_length(_find) <= 0){
			wait 0;
		}
		
		with(_find){
			if(!is_dir && ext == ".gml"){
				var _split = string_split(name, ".");
				if(array_length(_split) >= 2){
					var	_type = _split[array_length(_split) - 2],
						_name = string_copy(name, 1, string_length(name) - string_length("." + _type + ext));
						
					if(_type == "weapon"){
						_type = "wep";
					}
					
					if(lq_exists(ntte_mods, _type)){
						array_push(lq_get(ntte_mods, _type), _name);
					}
				}
			}
		}
		
		exit;
	}
	
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
		
		 // Warnings:
		try{
			if(!null){
				trace_color("NT:TE | WARNING - NTT beta versions (9942+) may cause issues!", c_red);
			}
		}
		catch(_error){}
		if(room_speed > 30){
			trace_color("NT:TE | WARNING - Playing on higher than 30 FPS will likely cause lag!", c_red);
		}
		
		exit;
	}
	
#macro spr global.spr
#macro msk spr.msk
#macro snd global.snd
#macro mus snd.mus
#macro lag global.debug_lag

#macro ntte_mods    global.mods
#macro ntte_version global.version

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

#macro game_scale_nonsync game_screen_get_width_nonsync() / game_width

#macro  area_campfire     0
#macro  area_desert       1
#macro  area_sewers       2
#macro  area_scrapyards   3
#macro  area_caves        4
#macro  area_city         5
#macro  area_labs         6
#macro  area_palace       7
#macro  area_vault        100
#macro  area_oasis        101
#macro  area_pizza_sewers 102
#macro  area_mansion      103
#macro  area_cursed_caves 104
#macro  area_jungle       105
#macro  area_hq           106
#macro  area_crib         107

#define save_ntte()
	string_save(json_encode(save_data), save_path);
	
#define save_get(_name, _default)
	/*
		Returns the value stored at the given name in NTTE's save file
		Returns the given default value if nothing was found
		
		Ex:
			save_get("option:shaders")
			save_get("stat:pet:Baby.examplepet.mod:found")
	*/
	
	var	_path = string_split(_name, ":"),
		_save = save_data;
		
	with(_path){
		if(!lq_exists(_save, self)){
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
		if(mod_exists("mod", "telib")){
			var _unlockName = mod_script_call("mod", "telib", "unlock_get_name", _name);
			if(_unlockName != ""){
				var	_unlocked     = (!is_real(_value) || _value),
					_unlockText   = (_unlocked ? mod_script_call("mod", "telib", "unlock_get_text", _name) : "LOCKED"),
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
				with(mod_script_call("mod", "telib", "unlock_splat", _unlockName, _unlockText, _unlockSprite, _unlockSound)){
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
			w/h   - The width/height of the surface
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
			w/h   - The drawing width/height of the surface
			x/y   - The drawing position of the surface, you can set this manually
			
		Ex:
			with(surface_setup("Test", game_width, game_height, game_scale_nonsync)){
				x = view_xview_nonsync;
				y = view_yview_nonsync;
				
				 // Setup:
				if(reset){
					reset = false;
					surface_set_target(surf);
					draw_clear_alpha(0, 0);
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
	if(is_undefined(_surf)){
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
		with(_surf){
			if(fork()){
				while(true){
					 // Deactivate Unused Surfaces:
					if((time > 0 || free) && --time <= 0){
						time = 0;
						surface_destroy(surf);
						
						 // Remove From List:
						if(free){
							ds_map_delete(global.surf, name);
							break;
						}
					}
					
					 // Game Paused:
					else for(var i = 0; i < maxp; i++){
						if(button_pressed(i, "paus")){
							reset = true;
							break;
						}
					}
					
					wait 0;
				}
				exit;
			}
		}
	}
	
	 // Surface Setup:
	with(_surf){
		if(is_real(_w)) w = _w;
		if(is_real(_h)) h = _h;
		if(is_real(_scale)) scale = _scale;
		
		 // Create / Resize Surface:
		if(
			!surface_exists(surf)
			|| surface_get_width(surf)  != max(1, w * scale)
			|| surface_get_height(surf) != max(1, h * scale)
		){
			surface_destroy(surf);
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
						var	_w = _args[0],
							_h = _args[1];
							
						shader_set_fragment_constant_f(0, [1 / _w, 1 / _h]);
						break;
						
					case "SludgePool":
						var	_w     = _args[0],
							_h     = _args[1],
							_color = _args[2];
							
						shader_set_fragment_constant_f(0, [1 / _w, 1 / _h]);
						shader_set_fragment_constant_f(1, [color_get_red(_color) / 255, color_get_green(_color) / 255, color_get_blue(_color) / 255]);
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
	if(is_undefined(_shad)){
		_shad = {
			"name" : _name,
			"shad" : -1,
			"vert" : _vertex,
			"frag" : _fragment
		};
		global.shad[? _name] = _shad;
		
		 // Auto-Management:
		with(_shad){
			if(fork()){
				while(true){
					 // Create Shaders:
					if(option_get("shaders")){
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
					else if(shad != -1){
						shader_destroy(shad);
						shad = -1;
					}
					
					wait 0;
				}
				exit;
			}
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
	
#define script_bind(_name, _scriptObj, _scriptRef, _depth, _visible)
	/*
		Binds the given script to the given event
		Ensures that the script's controller object always exists, and deletes it when the parent mod is unloaded
		
		Args:
			name      - The name used to store the script binding
			scriptObj - The event type: CustomStep, CustomBeginStep, CustomEndStep, CustomDraw
			scriptRef - The script's reference to call
			depth     - The script's default depth
			visible   - The script's default visibility, basically "will this event run all the time"
			
		Ex:
			script_bind("draw_thing", CustomDraw, script_ref_create(draw_thing), true, -8)
	*/
	
	var _bind = {
		"name"    : _name,
		"object"  : _scriptObj,
		"script"  : _scriptRef,
		"depth"   : _depth,
		"visible" : _visible,
		"id"      : noone
	};
	
	 // Fetch Old Controller:
	if(ds_map_exists(global.bind, _name)){
		with(global.bind[? _name]){
			_bind.id = id;
			with(id){
				script = _bind.script;
				depth  = _bind.depth;
			}
		}
	}
	
	 // Make New Controller:
	if(!instance_exists(_bind.id)){
		_bind.id = instance_create(0, 0, _bind.object);
		with(_bind.id){
			script     = _bind.script;
			depth      = _bind.depth;
			visible    = _bind.visible;
			persistent = true;
		}
	}
	
	 // Store:
	global.bind[? _name] = _bind;
	
	return _bind;
	
#define sprite /// sprite(_path, _img, _x, _y, _shine = shnNone)
	var _path = argument[0], _img = argument[1], _x = argument[2], _y = argument[3];
var _shine = argument_count > 4 ? argument[4] : shnNone;
	
	spr_load = [[spr, 0]];
	
	return {
		path  : "sprites/" + _path,
		img   : _img,
		x     : _x,
		y     : _y,
		ext   : "png",
		mask  : [],
		shine : _shine
	};
	
#define step
	if(lag) trace_time();
	
	 // Sprite Loading:
	if(array_length(spr_load) > 0){
		repeat(spr_load_num){
			while(array_length(spr_load) > 0){
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
				if(!is_undefined(_load)){
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
		if(!instance_exists(id)){
			id = instance_create(0, 0, object);
			with(id){
				script     = other.script;
				depth      = other.depth;
				visible    = other.visible;
				persistent = true;
			}
		}
	}
	
	 // Locked Weapon Spriterize:
	with(ntte_mods.wep){
		var _name = self;
		if(mod_variable_get("weapon", _name, "sprWepLocked") == mskNone){
			var _spr = mod_variable_get("weapon", _name, "sprWep");
			if(sprite_get_number(_spr) != 1 || sprite_get_width(_spr) != 16 || sprite_get_height(_spr) != 16){
				with(other){
					mod_variable_set("weapon", _name, "sprWepLocked", wep_locked_sprite(_spr));
				}
			}
		}
	}
	
	 // Autosave:
	if(save_auto){
		with(instances_matching(GameCont, "ntte_autosave", null)){
			save_ntte();
			ntte_autosave = true;
		}
	}
	
	if(lag) trace_time(mod_current + "_step");
	
#define draw_pause
	 // Remind Player:
	if(option_get("reminders")){
		var	_vx       = view_xview_nonsync,
			_vy       = view_yview_nonsync,
			_gw       = game_width,
			_gh       = game_height,
			_timeTick = 1;
			
		with(global.remind){
			if(active){
				var	_x = (_gw / 2),
					_y = (_gh / 2) - 40;
					
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
							text_inst = instance_create(_x, _y, PopupText);
							with(text_inst){
								text     = other.text;
								friction = 0.1;
							}
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
						
						_x = game_width - 124;
						_y = game_height - 78;
					}
					
					else continue;
				}
				
				 // Draw Icon:
				with(other){
					draw_sprite(sprNew, 0, _vx + _x, _vy + _y + sin(current_frame / 10));
				}
			}
			
			 // Draw Text:
			if(instance_exists(text_inst)){
				_timeTick = 0.5;
				
				draw_set_font(fntM);
				draw_set_halign(fa_center);
				draw_set_valign(fa_top);
				with(instances_matching(text_inst, "visible", true)){
					draw_text_nt(_vx + x, _vy + y, text);
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
		draw_clear_alpha(0, 0);
		
		with(UberCont){
			for(var _img = 0; _img < _sprImg; _img++){
				var	_x = _sprW * _img,
					_y = 0;
					
				 // Normal Sprite:
				draw_sprite(_spr, _img, _x + _sprX, _y + _sprY);
				
				 // Overlay Shine:
				draw_set_color_write_enable(true, true, true, false);
				draw_sprite_stretched(_shine, _img, _x, _y, _sprW, _sprH);
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
	
#define weapon_merge_sprite(_stock, _front)
	/*
		Used to create merge weapon sprites
		Returns a new sprite made by combining the left half of the given stock sprite with the right half of the given front sprite
		Doing this here so that the sprite doesnt get unloaded with merge.wep
	*/
	
	var _sprName = sprite_get_name(_stock) + "|" + sprite_get_name(_front);
	
	if(ds_map_exists(spr.MergeWep, _sprName)){
		return spr.MergeWep[? _sprName];
	}
	
	 // Initial Setup:
	else if(sprite_exists(_stock) && sprite_exists(_front)){
		var	_spr   = [_stock, _front],
			_sprW  = array_create(array_length(_spr), 0),
			_sprH  = array_create(array_length(_spr), 0),
			_surfW = 0,
			_surfH = 0;
			
		for(var i = 0; i < array_length(_spr); i++){
			_sprW[i] = sprite_get_width(_spr[i]);
			_sprH[i] = sprite_get_height(_spr[i]);
			_surfW   = max(_surfW, _sprW[i]);
			_surfH   = max(_surfH, _sprH[i]);
		}
		
		with(surface_setup("sprMerge", _surfW, _surfH, 1)){
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			
			with(UberCont){
				for(var _b = 0; _b <= 1; _b++){
					var	_dx = 0,
						_dy = other.h / 3;
						
					for(var i = 0; i <= 1; i++){
						var	_cut = (ceil(_sprW[i] / 2) + 2) - ceil(_sprW[i] / 8),
							_l   = _cut * i,
							_w   = (i ? _sprW[i] - _cut : _cut),
							_t   = 0,
							_h   = _sprH[i],
							_x   = _dx,
							_y   = _dy - sprite_get_yoffset(_spr[i]);
							
						switch(_spr[i]){
							case sprAutoShotgun:
								_y += 1;
								break;
								
							case sprAutoCrossbow:
							case sprSuperCrossbow:
							case sprGatlingSlugger:
								_y -= 1;
								break;
								
							case sprToxicBow:
								_y -= 2;
								break;
						}
						
						if(_b == 0){
							draw_sprite_part_ext(_spr[i], 0, _cut - !i, _t, 1, _h, _x + (_cut - _l) - i, _y, 1, 1, c_black, 1);
						}
						else{
							draw_sprite_part_ext(_spr[i], 0, _l, _t, _w, _h, _x, _y, 1, 1, c_white, 1);
						}
						
						_dx += _cut;
					}
				}
			}
			
			 // Done:
			surface_reset_target();
			free = true;
			
			 // Add Sprite:
			surface_save(surf, name + ".png");
			spr.MergeWep[? _sprName] = sprite_add_weapon(name + ".png", 2, h / 3);
			
			return spr.MergeWep[? _sprName];
		}
	}
	
	return -1;
	
#define weapon_merge_sprite_loadout(_stock, _front)
	/*
		Used to create merged weapon loadout HUD sprites
		Returns a new sprite made by combining the left half of the given stock sprite with the right half of the given front sprite
		Doing this here so that the sprite doesnt get unloaded with merge.wep
	*/
	
	var _sprName = sprite_get_name(_stock) + "|" + sprite_get_name(_front);
	
	if(ds_map_exists(spr.MergeWepLoadout, _sprName)){
		return spr.MergeWepLoadout[? _sprName];
	}
	
	 // Initial Setup:
	else if(sprite_exists(_stock) && sprite_exists(_front) && _stock > 0 && _front > 0){
		var	_spr   = [_stock, _front],
			_sprW  = array_create(array_length(_spr), 0),
			_sprH  = array_create(array_length(_spr), 0),
			_surfW = 0,
			_surfH = 0;
			
		for(var i = 0; i < array_length(_spr); i++){
			_sprW[i] = sprite_get_width(_spr[i]);
			_sprH[i] = sprite_get_height(_spr[i]);
			_surfW   = max(_surfW, _sprW[i]);
			_surfH   = max(_surfH, _sprH[i]);
		}
		
		with(surface_setup("sprMergeLoadout", _surfW, _surfH, 1)){
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			
			draw_set_color(c_white);
			
			 // Draw Sprite Halves:
			for(var i = 0; i < array_length(_spr); i++){
				var	_uvs       = sprite_get_uvs(_spr[i], 0),
					_uvsExists = (_uvs[0] != 0 || _uvs[1] != 0 || _uvs[2] != 1 || _uvs[3] != 1),
					_x         = floor(w / 2) - sprite_get_xoffset(_spr[i]) + (_uvsExists ? _uvs[4] : sprite_get_bbox_left(_spr[i])),
					_y         = floor(h / 2) - sprite_get_yoffset(_spr[i]) + (_uvsExists ? _uvs[5] : sprite_get_bbox_top(_spr[i])),
					_w         = (_uvsExists ? (_sprW[i] * _uvs[6]) : (sprite_get_bbox_right(_spr[i]) - sprite_get_bbox_left(_spr[i]))),
					_h         = (_uvsExists ? (_sprH[i] * _uvs[7]) : (sprite_get_bbox_bottom(_spr[i]) - sprite_get_bbox_top(_spr[i]))),
					_cutDis    = _w / 3,
					_cutDir    = 20,
					_ox        = (_h / 2) * dtan(_cutDir);
					
				if(i == 1){
					_cutDis = _w - _cutDis;
				}
				_cutDis += 2;
				
				draw_primitive_begin_texture(pr_trianglestrip, sprite_get_texture(_spr[i], 0));
				
				with([ // [x, y]
					[0,             0 ],
					[_cutDis - _ox, 0 ],
					[0,             _h],
					[_cutDis + _ox, _h]
				]){
					var _pos = self;
					
					 // Flip:
					if(i == 1){
						_pos[0] = _w - _pos[0];
						_pos[1] = _h - _pos[1];
					}
					
					 // Draw Vertex:
					var	_dx = _pos[0] + _x,
						_dy = _pos[1] + _y;
						
					draw_vertex_texture(_dx, _dy, _pos[0] / _w, _pos[1] / _h);
				}
				
				draw_primitive_end();
			}
			
			 // Done:
			surface_reset_target();
			free = true;
			
			 // Add Sprite:
			surface_save(surf, name + ".png");
			spr.MergeWepLoadout[? _sprName] = sprite_add_weapon(name + ".png", w / 2, h / 2);
			
			return spr.MergeWepLoadout[? _sprName];
		}
	}
	
	return -1;
	
#define weapon_merge_subtext(_stock, _front)
	/*
		Used to create merged weapon pickup indicator banner sprites
		Returns a new sprite of the "Stock Name + Front Name" in fntSmall over a transparent banner
		Doing this here so that the sprite doesnt get unloaded with ntte.mod
	*/
	
	var _sprName = sprite_get_name(_stock) + "|" + sprite_get_name(_front);
	
	if(ds_map_exists(spr.MergeWepText, _sprName)){
		return spr.MergeWepText[? _sprName];
	}
	
	 // Initial Setup:
	else{
		draw_set_font(fntSmall);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		
		var	_text     = weapon_get_name(_stock) + " + " + weapon_get_name(_front),
			_topSpace = 2,
			_surfW    = string_width(_text) + 4,
			_surfH    = string_height(_text) + 2 + _topSpace;
			
		with(surface_setup("sprMergeText", _surfW, _surfH, 1)){
			surface_set_target(surf);
			draw_clear_alpha(0, 0);
			
			 // Background:
			var	_x1 = -1,
				_y1 = -1,
				_x2 = _x1 + w,
				_y2 = _y1 + h;
				
			draw_set_alpha(0.8);
			draw_set_color(c_black);
			draw_roundrect_ext(_x1, _y1 + _topSpace, _x2, _y2, 5, 5, false);
			draw_set_alpha(1);
			
			 // Text:
			draw_text_nt(floor(w / 2), floor((h + _topSpace) / 2), _text);
			
			 // Done:
			surface_reset_target();
			free = true;
			
			 // Add Sprite:
			surface_save(surf, name + ".png");
			spr.MergeWepText[? _sprName] = sprite_add(name + ".png", 1, w / 2, h / 2);
			
			return spr.MergeWepText[? _sprName];
		}
	}
	
	return -1;

#define wep_locked_sprite(_sprite)
	/*
		Used to automatically create locked weapon sprites
		Returns a new sprite made of the given sprite drawn in flat black with a white outline
	*/
	
	var	_sprX  = sprite_get_xoffset(_sprite) + 1,
		_sprY  = sprite_get_yoffset(_sprite) + 1,
		_surfW = sprite_get_width(_sprite)  + 2,
		_surfH = sprite_get_height(_sprite) + 2;
		
	with(surface_setup("sprLockedWep", _surfW, _surfH, 1)){
		surface_set_target(surf);
		draw_clear_alpha(0, 0);
		
		with(UberCont){
			 // Outline:
			draw_set_fog(true, c_white, 0, 0);
			for(var _d = 0; _d < 360; _d += 90){
				draw_sprite(_sprite, 0, _sprX + dcos(_d), _sprY + dsin(_d));
			}
			
			 // Main:
			draw_set_fog(true, c_black, 0, 0);
			draw_sprite(_sprite, 0, _sprX, _sprY);
			draw_set_fog(false, 0, 0, 0);
		}
		
		 // Done:
		surface_reset_target();
		free = true;
		
		 // Add Sprite:
		surface_save(surf, name + ".png");
		return sprite_add_weapon(name + ".png", _sprX, _sprY);
	}
	
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
		for(var _x = 0; _x < array_length(_sprList[0]); _x++){
			for(var _y = 0; _y < array_length(_sprList[1]); _y++){
				surface_set_target(surf);
				draw_clear_alpha(0, 0);
				
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
				_sprList[_x, _y] = sprite_add(
					name + ".png",
					_sprImg,
					(_sprX - 8) * _x,
					(_sprY - 8) * _y
				);
			}
		}
	}
	
	return _sprList;
	
#define cleanup
	 // Save Game:
	if(save_auto){
		save_ntte();
	}
	
	 // Clear Surfaces, Shaders, Script Bindings:
	with(ds_map_values(global.surf)) if(surf != -1) surface_destroy(surf);
	with(ds_map_values(global.shad)) if(shad != -1) shader_destroy(shad);
	with(ds_map_values(global.bind)) with(id) instance_destroy();
	ds_map_destroy(global.surf);
	ds_map_destroy(global.shad);
	ds_map_destroy(global.bind);
	
	 // No Crash:
	with(ntte_mods.race){
		with(instances_matching([CampChar, CharSelect], "race", self)){
			repeat(8) with(instance_create(random_range(bbox_left, bbox_right), random_range(bbox_top, bbox_bottom), Dust)){
				motion_add(random(360), random(random(8)));
			}
			instance_delete(id);
		}
	}