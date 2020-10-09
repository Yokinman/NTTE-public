#define init
	// weap - "Flavor" & "Stats" variables default to this weapon's values
	
	/// Flavor
	// name - Name
	// text - Loading Tip
	// sprt - Sprite
	// swap - Swap Sound
	
	/// Stats
	// area - Spawn Difficulty
	// type - Ammo Type
	// load - Reload
	// cost - Ammo Cost
	// rads - Rad Cost
	// auto - Automatic
	// mele - Melee Weapon
	// gold - Gold Weapon
	// blod - Blood Weapon (Take ceil(ammo / 2) damage)
	// lasr - Laser Sight
	
	/// Firing
	// proj - Object to Shoot (Use lwo to set vars, like sprite_index or damage)
	// sped - Speed [Min Speed, Max Speed]
	// sprd - Spread
	// fixd - Fixed Spread
	// amnt - Number of Projectiles Per Shot
	// shot - Number of Burst Shots
	// time - Delay Between Burst Shots
	// wait - Initial Delay
	// move - Offset Towards Direction / move_contact_solid(direction, #)
	// soun - Fire Sound
	// kick - Weapon Kick
	// push - Knockback
	// shif - Screenshift
	// shak - Screenshake
	
	/// Special
	// cont - Script reference, plays code for fire controller's step,draw,init (See laser cannon)
	// flag - Array of strings that apply unique mechanics (Wave Gun, Smart Gun, etc.)
	
	spr = mod_variable_get("mod", "teassets", "spr");
	
	wepList = [wepDefault];
	
	wep_add([
		{	"weap" : wep_revolver,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 4,
			"soun" : sndPistol,
			"kick" : 2,
			"shif" : -6,
			"shak" : 4
		},
		{	"weap" : wep_triple_machinegun,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 3,
			"fixd" : 15,
			"amnt" : 3,
			"soun" : sndTripleMachinegun,
			"kick" : 6,
			"shif" : -8,
			"shak" : 4
		},
		{	"weap" : wep_wrench,
			"proj" : {
				object_index : Slash,
				damage : 8
			},
			"sped" : 2,
			"soun" : sndWrench,
			"kick" : -4,
			"push" : -6,
			"shif" : 12,
			"shak" : 1
		},
		{	"weap" : wep_machinegun,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 6,
			"soun" : sndMachinegun,
			"kick" : 2,
			"shif" : -6,
			"shak" : 3
		},
		{	"weap" : wep_shotgun,
			"proj" : Bullet2,
			"sped" : [12, 18],
			"sprd" : 20,
			"amnt" : 7,
			"soun" : sndShotgun,
			"kick" : 6,
			"shif" : -12,
			"shak" : 8
		},
		{	"weap" : wep_crossbow,
			"proj" : Bolt,
			"sped" : 24,
			"soun" : sndCrossbow,
			"kick" : 4,
			"shif" : -40,
			"shak" : 4
		},
		{	"weap" : wep_grenade_launcher,
			"proj" : Grenade,
			"sped" : 10,
			"sprd" : 3,
			"soun" : sndGrenade,
			"kick" : 5,
			"shif" : -10,
			"shak" : 2
		},
		{	"weap" : wep_double_shotgun,
			"proj" : Bullet2,
			"sped" : [12, 18],
			"sprd" : 30,
			"amnt" : 14,
			"soun" : sndDoubleShotgun,
			"kick" : 8,
			"push" : 2,
			"shif" : -16,
			"shak" : 16
		},
		{	"weap" : wep_minigun,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 13,
			"soun" : sndMinigun,
			"kick" : 4,
			"push" : 0.4,
			"shif" : -7,
			"shak" : 3
		},
		{	"weap" : wep_auto_shotgun,
			"proj" : Bullet2,
			"sped" : [12, 18],
			"sprd" : 15,
			"amnt" : 6,
			"soun" : sndShotgun,
			"kick" : 5,
			"shif" : -12,
			"shak" : 8
		},
		{	"weap" : wep_auto_crossbow,
			"proj" : Bolt,
			"sped" : 24,
			"sprd" : 5,
			"soun" : sndCrossbow,
			"kick" : 4,
			"shif" : -40,
			"shak" : 5
		},
		{	"weap" : wep_super_crossbow,
			"proj" : Bolt,
			"sped" : 24,
			"fixd" : 5,
			"amnt" : 5,
			"soun" : sndSuperCrossbow,
			"kick" : 8,
			"push" : 1,
			"shif" : -60,
			"shak" : 14
		},
		{	"weap" : wep_shovel,
			"proj" : {
				object_index : Slash,
				sprite_index : sprHeavySlash,
				damage : 16
			},
			"sped" : 2,
			"fixd" : 60,
			"amnt" : 3,
			"soun" : sndShovel,
			"kick" : -4,
			"push" : -6,
			"shif" : 24,
			"shak" : 1
		},
		{	"weap" : wep_bazooka,
			"proj" : Rocket,
			"sped" : 2,
			"sprd" : 2,
			"soun" : sndRocket,
			"kick" : 10,
			"shif" : -30,
			"shak" : 4
		},
		{	"weap" : wep_sticky_launcher,
			"proj" : {
				object_index : Grenade,
				sprite_index : sprStickyGrenade,
				sticky : true
			},
			"sped" : 11,
			"sprd" : 3,
			"soun" : sndGrenade,
			"kick" : 5,
			"shif" : -10,
			"shak" : 2
		},
		{	"weap" : wep_smg,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 16,
			"soun" : sndPistol,
			"kick" : 2,
			"shif" : -6,
			"shak" : 3
		},
		{	"weap" : wep_assault_rifle,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 2,
			"shot" : 3,
			"time" : 2,
			"soun" : sndMachinegun,
			"kick" : 4,
			"shif" : -6,
			"shak" : 3
		},
		{	"weap" : wep_disc_gun,
			"proj" : Disc,
			"sped" : 5,
			"sprd" : 5,
			"soun" : sndDiscgun,
			"kick" : 4,
			"shif" : -10,
			"shak" : 6
		},
		{	"weap" : wep_laser_pistol,
			"proj" : Laser,
			"sped" : 20,
			"sprd" : 1,
			"soun" : sndLaser,
			"kick" : 2,
			"shif" : -3,
			"shak" : 2
		},
		{	"weap" : wep_laser_rifle,
			"proj" : Laser,
			"sped" : 20,
			"sprd" : 3,
			"soun" : sndLaser,
			"kick" : 5,
			"shif" : -3,
			"shak" : 2
		},
		{	"weap" : wep_slugger,
			"proj" : Slug,
			"sped" : 16,
			"sprd" : 5,
			"soun" : sndSlugger,
			"kick" : 8,
			"shif" : -14,
			"shak" : 10
		},
		{	"weap" : wep_gatling_slugger,
			"proj" : Slug,
			"sped" : 18,
			"sprd" : 6,
			"soun" : sndSlugger,
			"kick" : 8,
			"shif" : -10,
			"shak" : 10
		},
		{	"weap" : wep_assault_slugger,
			"proj" : Slug,
			"sped" : 18,
			"sprd" : 4,
			"shot" : 3,
			"time" : 3,
			"soun" : sndSlugger,
			"kick" : 8,
			"shif" : -8,
			"shak" : 6
		},
		{	"weap" : wep_energy_sword,
			"proj" : EnergySlash,
			"sped" : 2,
			"soun" : sndEnergySword,
			"kick" : -4,
			"push" : -7,
			"shif" : 24,
			"shak" : 1
		},
		{	"weap" : wep_super_slugger,
			"proj" : Slug,
			"sped" : 18,
			"sprd" : 4,
			"fixd" : 10,
			"amnt" : 5,
			"soun" : sndSuperSlugger,
			"kick" : 8,
			"push" : 3,
			"shif" : -10,
			"shak" : 15
		},
		{	"weap" : wep_hyper_rifle,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 2,
			"shot" : 5,
			"time" : 1,
			"soun" : sndHyperRifle,
			"kick" : 4,
			"shif" : -6,
			"shak" : 3
		},
		{	"weap" : wep_screwdriver,
			"proj" : Shank,
			"sped" : 3,
			"sprd" : 5,
			"soun" : sndScrewdriver,
			"kick" : -8,
			"push" : -4,
			"shif" : 12,
			"shak" : 1
		},
		{	"weap" : wep_laser_minigun,
			"proj" : Laser,
			"sped" : 20,
			"sprd" : 12,
			"soun" : sndLaser,
			"kick" : 8,
			"push" : 0.6,
			"shif" : -5,
			"shak" : 2
		},
		{	"weap" : wep_blood_launcher,
			"blod" : true,
			"proj" : BloodGrenade,
			"sped" : 10,
			"sprd" : 6,
			"soun" : sndBloodLauncher,
			"kick" : 4,
			"shif" : -5,
			"shak" : 3
		},
		{	"weap" : wep_splinter_gun,
			"proj" : Splinter,
			"sped" : [20, 24],
			"sprd" : 10,
			"amnt" : 5,
			"soun" : sndSplinterGun,
			"kick" : 3,
			"shif" : -15,
			"shak" : 3
		},
		{	"weap" : wep_toxic_bow,
			"proj" : ToxicBolt,
			"sped" : 22,
			"soun" : sndCrossbow,
			"kick" : 4,
			"shif" : -40,
			"shak" : 5
		},
		{	"weap" : wep_sentry_gun,
			"proj" : SentryGun,
			"sped" : 6,
			"soun" : sndGrenade,
			"kick" : -10,
			"shif" : 5
		},
		{	"weap" : wep_wave_gun,
			"proj" : Bullet2,
			"sped" : 16,
			"sprd" : 2,
			"fixd" : 32,
			"amnt" : 2,
			"shot" : 8,
			"time" : 1,
			"soun" : [
				{ snd : sndWaveGun, shot : 0 },
				sndShotgun
			],
			"kick" : 7,
			"shif" : -2,
			"shak" : 2,
			"flag" : "wave"
		},
		{	"weap" : wep_plasma_gun,
			"proj" : PlasmaBall,
			"sped" : 2,
			"sprd" : 4,
			"soun" : sndPlasma,
			"kick" : 5,
			"push" : 3,
			"shif" : -3,
			"shak" : 3
		},
		{	"weap" : wep_plasma_cannon,
			"proj" : PlasmaBig,
			"sped" : 2,
			"sprd" : 2,
			"soun" : sndPlasmaBig,
			"kick" : 10,
			"push" : 6,
			"shif" : -8,
			"shak" : 8
		},
		{	"weap" : wep_energy_hammer,
			"proj" : EnergyHammerSlash,
			"sped" : 1,
			"soun" : sndEnergyHammer,
			"kick" : -3,
			"push" : -7,
			"shif" : 32,
			"shak" : 2
		},
		{	"weap" : wep_jackhammer,
			"proj" : Shank,
			"sped" : 4,
			"sprd" : 15,
			"shot" : 12,
			"time" : 1,
			"soun" : sndJackHammer,
			"kick" : -8,
			"shif" : 6,
			"shak" : 1
		},
		{	"weap" : wep_flak_cannon,
			"proj" : FlakBullet,
			"sped" : [11, 13],
			"sprd" : 5,
			"soun" : sndFlakCannon,
			"kick" : 7,
			"shif" : -32,
			"shak" : 4
		},
		{	"weap" : wep_golden_revolver,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 4,
			"soun" : sndGoldPistol,
			"kick" : 4,
			"shif" : -8,
			"shak" : 5
		},
		{	"weap" : wep_golden_wrench,
			"proj" : {
				object_index : Slash,
				damage : 8
			},
			"sped" : 2,
			"soun" : sndGoldWrench,
			"kick" : -6,
			"push" : -6,
			"shif" : 16,
			"shak" : 2
		},
		{	"weap" : wep_golden_machinegun,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 4,
			"soun" : sndGoldMachinegun,
			"kick" : 4,
			"shif" : -8,
			"shak" : 4
		},
		{	"weap" : wep_golden_shotgun,
			"proj" : Bullet2,
			"sped" : [12, 18],
			"sprd" : 20,
			"amnt" : 8,
			"soun" : sndGoldShotgun,
			"kick" : 8,
			"shif" : -16,
			"shak" : 10
		},
		{	"weap" : wep_golden_crossbow,
			"proj" : {
				object_index : Bolt,
				sprite_index : sprBoltGold
			},
			"sped" : 24,
			"soun" : sndGoldCrossbow,
			"kick" : 6,
			"shif" : -44,
			"shak" : 6
		},
		{	"weap" : wep_golden_grenade_launcher,
			"proj" : {
				object_index : Grenade,
				sprite_index : sprGoldGrenade
			},
			"sped" : 12,
			"soun" : sndGoldGrenade,
			"kick" : 7,
			"shif" : -12,
			"shak" : 4
		},
		{	"weap" : wep_golden_laser_pistol,
			"proj" : Laser,
			"sped" : 20,
			"soun" : sndGoldLaser,
			"kick" : 4,
			"shif" : -6,
			"shak" : 4
		},
		{	"weap" : wep_chicken_sword,
			"proj" : {
				object_index : Slash,
				damage : 6
			},
			"sped" : 2,
			"soun" : sndChickenSword,
			"kick" : -6,
			"push" : -8,
			"shif" : -8,
			"shak" : 1
		},
		{	"weap" : wep_nuke_launcher,
			"proj" : Nuke,
			"sped" : 2,
			"sprd" : 2,
			"soun" : sndNukeFire,
			"kick" : 10,
			"shif" : -40,
			"shak" : 8
		},
		{	"weap" : wep_ion_cannon,
			"proj" : {
				object_index : IonBurst,
				delay : 30
			},
			"soun" : sndLaser,
			"kick" : 3,
			"shak" : 6
		},
		{	"weap" : wep_quadruple_machinegun,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 3,
			"fixd" : 12,
			"amnt" : 4,
			"soun" : sndQuadMachinegun,
			"kick" : 8,
			"shif" : -10,
			"shak" : 6
		},
		{	"weap" : wep_flamethrower,
			"proj" : Flame,
			"sped" : [6, 8],
			"sprd" : 5,
			"amnt" : 2,
			"shot" : 12,
			"time" : 1,
			"move" : 14,
			"soun" : [
				{ snd : sndFlamerLoop, loop : true, loop_strt : sndFlamerStart, loop_stop : sndFlamerStop },
			],
			"kick" : 2,
			"shif" : -3,
			"shak" : 1
		},
		{	"weap" : wep_dragon,
			"proj" : Flame,
			"sped" : [9, 12],
			"sprd" : 5,
			"fixd" : 8,
			"amnt" : 3,
			"shot" : 7,
			"time" : 1,
			"move" : 14,
			"soun" : [
				{ snd : sndDragonLoop, loop : true, loop_strt : sndDragonStart, loop_stop : sndDragonStop },
			],
			"kick" : 4,
			"shif" : -3,
			"shak" : 1
		},
		{	"weap" : wep_flare_gun,
			"proj" : Flare,
			"sped" : 9,
			"sprd" : 7,
			"soun" : sndFlare,
			"kick" : 5,
			"shif" : -10,
			"shak" : 5
		},
		{	"weap" : wep_energy_screwdriver,
			"proj" : EnergyShank,
			"sped" : 3,
			"sprd" : 5,
			"soun" : sndEnergyScrewdriver,
			"kick" : -8,
			"push" : -5,
			"shif" : 12,
			"shak" : 2
		},
		{	"weap" : wep_hyper_launcher,
			"proj" : HyperGrenade,
			"sped" : 12,
			"sprd" : 2,
			"soun" : sndHyperLauncher,
			"kick" : 8,
			"shif" : -20,
			"shak" : 4
		},
		{	"weap" : wep_laser_cannon,
			"proj" : Laser,
			"sped" : 20,
			"shot" : 5,
			"time" : 1,
			"wait" : 15,
			"move" : 16,
			"soun" : sndLaserCannon,
			"kick" : 5,
			"shif" : -3,
			"shak" : 2,
			"cont" : cont_laser_cannon
		},
		{	"weap" : wep_rusty_revolver,
			"proj" : Bullet1,
			"sped" : 16,
			"soun" : sndRustyRevolver,
			"kick" : 4,
			"shif" : -8,
			"shak" : 5
		},
		{	"weap" : wep_lightning_pistol,
			"proj" : Lightning,
			"sped" : 7,
			"sprd" : 15,
			"soun" : sndLightningPistol,
			"kick" : 4,
			"shif" : -3,
			"shak" : 5
		},
		{	"weap" : wep_lightning_rifle,
			"proj" : Lightning,
			"sped" : 13.5,
			"sprd" : 3,
			"soun" : sndLightningRifle,
			"kick" : 8,
			"shif" : -6,
			"shak" : 8
		},
		{	"weap" : wep_lightning_shotgun,
			"proj" : Lightning,
			"sped" : [4.5, 6],
			"sprd" : 90,
			"amnt" : 8,
			"soun" : sndLightningShotgun,
			"kick" : 5,
			"shif" : -4,
			"shak" : 10
		},
		{	"weap" : wep_super_flak_cannon,
			"proj" : SuperFlakBullet,
			"sped" : [10, 11],
			"sprd" : 4,
			"soun" : sndSuperFlakCannon,
			"kick" : 9,
			"shif" : -48,
			"shak" : 8
		},
		{	"weap" : wep_sawed_off_shotgun,
			"proj" : Bullet2,
			"sped" : [12, 17],
			"sprd" : 45,
			"amnt" : 20,
			"soun" : sndSawedOffShotgun,
			"kick" : 8,
			"push" : 3.5,
			"shif" : -16,
			"shak" : 18
		},
		{	"weap" : wep_splinter_pistol,
			"proj" : Splinter,
			"sped" : [16, 24],
			"sprd" : 4,
			"amnt" : 4,
			"soun" : sndSplinterPistol,
			"kick" : 3,
			"shif" : -10,
			"shak" : 2
		},
		{	"weap" : wep_super_splinter_gun,
			"proj" : Splinter,
			"sped" : [16, 24],
			"sprd" : 16,
			"amnt" : 2,
			"shot" : 6,
			"time" : 1,
			"soun" : [
				{ snd : sndSuperSplinterGun, shot : 0 },
				sndSplinterGun
			],
			"kick" : 9,
			"shif" : -7,
			"shak" : 3
		},
		{	"weap" : wep_lightning_smg,
			"proj" : Lightning,
			"sped" : 7,
			"sprd" : 30,
			"soun" : sndLightningPistol,
			"kick" : 5,
			"shif" : -4,
			"shak" : 5
		},
		{	"weap" : wep_smart_gun,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 5,
			"soun" : sndSmartgun,
			"kick" : 5,
			"shak" : 5,
			"flag" : "smart"
		},
		{	"weap" : wep_heavy_crossbow,
			"proj" : HeavyBolt,
			"sped" : 16,
			"soun" : sndHeavyCrossbow,
			"kick" : 6,
			"shif" : -50,
			"shak" : 5
		},
		{	"weap" : wep_blood_hammer,
			"blod" : true,
			"proj" : BloodSlash,
			"sped" : 2,
			"soun" : sndBloodHammer,
			"kick" : -5,
			"push" : -6,
			"shif" : 14,
			"shak" : 1
		},
		{	"weap" : wep_lightning_cannon,
			"proj" : LightningBall,
			"sped" : 3,
			"sprd" : 5,
			"soun" : sndLightningCannon,
			"kick" : 6,
			"push" : 6,
			"shif" : -6,
			"shak" : 9
		},
		{	"weap" : wep_pop_gun,
			"proj" : Bullet2,
			"sped" : 16,
			"sprd" : 4,
			"soun" : sndPopgun,
			"kick" : 2,
			"shif" : -4,
			"shak" : 2
		},
		{	"weap" : wep_plasma_rifle,
			"proj" : PlasmaBall,
			"sped" : 2,
			"sprd" : 6,
			"soun" : sndPlasmaRifle,
			"kick" : 7,
			"push" : 3,
			"shif" : -4,
			"shak" : 3
		},
		{	"weap" : wep_pop_rifle,
			"proj" : Bullet2,
			"sped" : 16,
			"sprd" : 8,
			"shot" : 3,
			"time" : 2,
			"soun" : sndPopgun,
			"kick" : 2,
			"shif" : -4,
			"shak" : 2
		},
		{	"weap" : wep_toxic_launcher,
			"proj" : {
				object_index : ToxicGrenade,
				sticky : true
			},
			"sped" : 9,
			"sprd" : 3,
			"soun" : sndToxicLauncher,
			"kick" : 4,
			"shif" : -10,
			"shak" : 2
		},
		{	"weap" : wep_flame_cannon,
			"proj" : FlameBall,
			"sped" : 3,
			"sprd" : 5,
			"soun" : sndFlameCannon,
			"kick" : 6,
			"push" : 6,
			"shif" : -6,
			"shak" : 9
		},
		{	"weap" : wep_lightning_hammer,
			"proj" : LightningSlash,
			"sped" : 2,
			"soun" : sndLightningHammer,
			"kick" : -5,
			"push" : -6,
			"shif" : 12,
			"shak" : 4
		},
		{	"weap" : wep_flame_shotgun,
			"proj" : FlameShell,
			"sped" : [12, 18],
			"sprd" : 15,
			"amnt" : 6,
			"soun" : sndFireShotgun,
			"kick" : 6,
			"shif" : -12,
			"shak" : 7
		},
		{	"weap" : wep_double_flame_shotgun,
			"proj" : FlameShell,
			"sped" : [12, 18],
			"sprd" : 25,
			"amnt" : 14,
			"soun" : sndDoubleFireShotgun,
			"kick" : 6,
			"shif" : -22,
			"shak" : 12
		},
		{	"weap" : wep_auto_flame_shotgun,
			"proj" : FlameShell,
			"sped" : [12, 18],
			"sprd" : 10,
			"amnt" : 5,
			"soun" : sndFireShotgun,
			"kick" : 5,
			"shif" : -12,
			"shak" : 7
		},
		{	"weap" : wep_cluster_launcher,
			"proj" : ClusterNade,
			"sped" : 10,
			"sprd" : 4,
			"soun" : sndClusterLauncher,
			"kick" : 6,
			"shif" : -12,
			"shak" : 1
		},
		{	"weap" : wep_grenade_shotgun,
			"proj" : MiniNade,
			"sped" : [10, 15],
			"sprd" : 17,
			"amnt" : 4,
			"soun" : sndGrenadeShotgun,
			"kick" : 5,
			"shif" : -40,
			"shak" : 8
		},
		{	"weap" : wep_grenade_rifle,
			"proj" : MiniNade,
			"sped" : [13, 15],
			"sprd" : 4,
			"shot" : 3,
			"time" : 1,
			"soun" : sndGrenadeRifle,
			"kick" : 5,
			"shif" : -6,
			"shak" : 1
		},
		{	"weap" : wep_rogue_rifle,
			"proj" : {
				object_index : Bullet1,
				sprite_index : sprIDPDBullet
			},
			"sped" : 16,
			"sprd" : 5,
			"shot" : 2,
			"time" : 2,
			"soun" : -1,
			"kick" : 5,
			"shif" : -6,
			"shak" : 2
		},
		{	"weap" : wep_party_gun,
			"proj" : ConfettiBall,
			"sped" : 8,
			"sprd" : 15,
			"soun" : sndConfettiGun,
			"kick" : 2,
			"shif" : -3,
			"shak" : 3
		},
		{	"weap" : wep_double_minigun,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 9.5,
			"fixd" : 9.5,
			"amnt" : 2,
			"soun" : sndDoubleMinigun,
			"kick" : 7,
			"push" : 0.7,
			"shif" : -12,
			"shak" : 6
		},
		{	"weap" : wep_gatling_bazooka,
			"proj" : Rocket,
			"sped" : 2,
			"sprd" : 6,
			"soun" : sndRocket,
			"kick" : 9,
			"shif" : -30,
			"shak" : 4
		},
		{	"weap" : wep_auto_grenade_shotgun,
			"proj" : MiniNade,
			"sped" : [11, 15],
			"sprd" : 14,
			"amnt" : 3,
			"soun" : sndGrenadeShotgun,
			"kick" : 4,
			"shif" : -33,
			"shak" : 6
		},
		{	"weap" : wep_ultra_revolver,
			"proj" : UltraBullet,
			"sped" : 24,
			"sprd" : 3,
			"soun" : sndUltraPistol,
			"kick" : 4,
			"shif" : -12,
			"shak" : 6
		},
		{	"weap" : wep_ultra_laser_pistol,
			"proj" : Laser,
			"sped" : 20,
			"sprd" : 1,
			"fixd" : 8,
			"amnt" : 5,
			"soun" : sndUltraLaser,
			"kick" : 7,
			"shif" : -12,
			"shak" : 10
		},
		{	"weap" : wep_sledgehammer,
			"proj" : {
				object_index : Slash,
				sprite_index : sprHeavySlash,
				damage : 24
			},
			"sped" : 2,
			"soun" : sndHammer,
			"kick" : -4,
			"push" : -6,
			"shif" : 15,
			"shak" : 1
		},
		{	"weap" : wep_heavy_revolver,
			"proj" : HeavyBullet,
			"sped" : 16,
			"sprd" : 1,
			"soun" : sndHeavyRevoler,
			"kick" : 6,
			"shif" : -7,
			"shak" : 5
		},
		{	"weap" : wep_heavy_machinegun,
			"proj" : HeavyBullet,
			"sped" : 16,
			"sprd" : 3,
			"soun" : sndHeavyMachinegun,
			"kick" : 6,
			"shif" : -7,
			"shak" : 4
		},
		{	"weap" : wep_heavy_slugger,
			"proj" : HeavySlug,
			"sped" : 13,
			"sprd" : 4,
			"soun" : sndHeavySlugger,
			"kick" : 10,
			"shif" : -34,
			"shak" : 14
		},
		{	"weap" : wep_ultra_shovel,
			"proj" : {
				object_index : Slash,
				sprite_index : sprUltraSlash,
				damage : 30
			},
			"sped" : 2,
			"fixd" : 60,
			"amnt" : 3,
			"soun" : sndUltraShovel,
			"kick" : -6,
			"push" : -8,
			"shif" : 28,
			"shak" : 1
		},
		{	"weap" : wep_ultra_shotgun,
			"proj" : UltraShell,
			"sped" : [12, 18],
			"sprd" : 22,
			"amnt" : 9,
			"soun" : sndUltraShotgun,
			"kick" : 8,
			"shif" : -14,
			"shak" : 10
		},
		{	"weap" : wep_ultra_crossbow,
			"proj" : UltraBolt,
			"sped" : 20,
			"soun" : sndUltraCrossbow,
			"kick" : 7,
			"shif" : -44,
			"shak" : 5
		},
		{	"weap" : wep_ultra_grenade_launcher,
			"proj" : UltraGrenade,
			"sped" : 10,
			"sprd" : 5,
			"soun" : sndUltraGrenade,
			"kick" : 8,
			"shif" : -12,
			"shak" : 3
		},
		{	"weap" : wep_plasma_minigun,
			"proj" : PlasmaBall,
			"sped" : 1,
			"sprd" : 10,
			"soun" : sndPlasmaMinigun,
			"kick" : 8,
			"push" : 2,
			"shif" : -5,
			"shak" : 3
		},
		{	"weap" : wep_devastator,
			"proj" : Devastator,
			"sped" : 16,
			"sprd" : 3,
			"soun" : sndDevastator,
			"kick" : 8,
			"push" : 5,
			"shif" : -30,
			"shak" : 10
		},
		{	"weap" : wep_golden_plasma_gun,
			"proj" : PlasmaBall,
			"sped" : 3,
			"sprd" : 4,
			"soun" : sndGoldPlasma,
			"kick" : 5,
			"push" : 3,
			"shif" : -3,
			"shak" : 5
		},
		{	"weap" : wep_golden_slugger,
			"proj" : Slug,
			"sped" : 16,
			"sprd" : 5,
			"soun" : sndGoldSlugger,
			"kick" : 8,
			"shif" : -14,
			"shak" : 12
		},
		{	"weap" : wep_golden_splinter_gun,
			"proj" : Splinter,
			"sped" : [20, 24],
			"sprd" : 10,
			"amnt" : 6,
			"soun" : sndGoldSplinterGun,
			"kick" : 3,
			"shif" : -15,
			"shak" : 5
		},
		{	"weap" : wep_golden_screwdriver,
			"proj" : Shank,
			"sped" : 3,
			"sprd" : 5,
			"soun" : sndGoldScrewdriver,
			"kick" : -8,
			"push" : -4,
			"shif" : 12,
			"shak" : 2
		},
		{	"weap" : wep_golden_bazooka,
			"proj" : {
				object_index : Rocket,
				sprite_index : sprGoldRocket
			},
			"sped" : 2,
			"sprd" : 2,
			"soun" : sndGoldRocket,
			"kick" : 10,
			"shif" : -30,
			"shak" : 6
		},
		{	"weap" : wep_golden_assault_rifle,
			"proj" : Bullet1,
			"sped" : 16,
			"sprd" : 2,
			"shot" : 3,
			"time" : 2,
			"soun" : sndGoldMachinegun,
			"kick" : 4,
			"shif" : -6,
			"shak" : 5
		},
		{	"weap" : wep_super_disc_gun,
			"proj" : Disc,
			"sped" : 5,
			"sprd" : 2,
			"fixd" : 7,
			"amnt" : 5,
			"soun" : sndSuperDiscGun,
			"kick" : 6,
			"shif" : -16,
			"shak" : 6
		},
		{	"weap" : wep_heavy_auto_crossbow,
			"proj" : HeavyBolt,
			"sped" : 16,
			"sprd" : 6,
			"soun" : sndHeavyCrossbow,
			"kick" : 6,
			"shif" : -50,
			"shak" : 5
		},
		{	"weap" : wep_heavy_assault_rifle,
			"proj" : HeavyBullet,
			"sped" : 16,
			"sprd" : 1,
			"shot" : 3,
			"time" : 2,
			"soun" : sndHeavyMachinegun,
			"kick" : 6,
			"shif" : -7,
			"shak" : 3
		},
		{	"weap" : wep_blood_cannon,
			"blod" : true,
			"proj" : BloodBall,
			"sped" : 5,
			"sprd" : 5,
			"soun" : sndBloodCannon,
			"kick" : 6,
			"shif" : -9,
			"shak" : 6
		},
		{	"weap" : wep_dog_spin_attack,
			"soun" : sndBigDogSpin,
			"flag" : "dogspin"
		},
		{	"weap" : wep_dog_missile
		},
		{	"weap" : wep_incinerator,
			"proj" : FlameShell,
			"sped" : 16,
			"sprd" : 5,
			"fixd" : 18,
			"amnt" : 3,
			"soun" : sndIncinerator,
			"kick" : 7,
			"shif" : -9,
			"shak" : 4
		},
		{	"weap" : wep_super_plasma_cannon,
			"proj" : PlasmaHuge,
			"sped" : 1.5,
			"sprd" : 1,
			"soun" : sndPlasmaHuge,
			"kick" : 10,
			"push" : 16,
			"shif" : -40,
			"shak" : 15
		},
		{	"weap" : wep_seeker_pistol,
			"proj" : Seeker,
			"sped" : 8,
			"sprd" : 30,
			"amnt" : 2,
			"soun" : sndSeekerPistol,
			"kick" : 4,
			"shif" : -12,
			"shak" : 2
		},
		{	"weap" : wep_seeker_shotgun,
			"proj" : Seeker,
			"sped" : 8,
			"sprd" : 70,
			"amnt" : 6,
			"soun" : sndSeekerShotgun,
			"kick" : 8,
			"shif" : -16,
			"shak" : 6
		},
		{	"weap" : wep_eraser,
			"proj" : Bullet2,
			"sped" : [10, 18],
			"sprd" : 1,
			"amnt" : 16,
			"soun" : sndEraser,
			"kick" : 8,
			"push" : 2,
			"shif" : -18,
			"shak" : 8
		},
		{	"weap" : wep_guitar,
			"proj" : GuitarSlash,
			"sped" : 2,
			"soun" : sndGuitar,
			"kick" : -5,
			"push" : -6,
			"shif" : 13,
			"shak" : 1
		},
		{	"weap" : wep_bouncer_smg,
			"proj" : BouncerBullet,
			"sped" : 6,
			"sprd" : 20,
			"soun" : sndBouncerSmg,
			"kick" : 2,
			"shif" : -5,
			"shak" : 2
		},
		{	"weap" : wep_bouncer_shotgun,
			"proj" : BouncerBullet,
			"sped" : 6,
			"sprd" : 3,
			"fixd" : 10,
			"amnt" : 7,
			"soun" : sndBouncerShotgun,
			"kick" : 5,
			"shif" : -7,
			"shak" : 7
		},
		{	"weap" : wep_hyper_slugger,
			"proj" : HyperSlug,
			"sped" : 12,
			"sprd" : 2,
			"soun" : sndHyperSlugger,
			"kick" : 10,
			"shif" : -16,
			"shak" : 11
		},
		{	"weap" : wep_super_bazooka,
			"proj" : Rocket,
			"sped" : 2,
			"fixd" : 6,
			"amnt" : 5,
			"soun" : sndSuperBazooka,
			"kick" : 12,
			"push" : 1,
			"shif" : -60,
			"shak" : 20
		},
		{	"weap" : wep_frog_pistol,
			"proj" : EnemyBullet2,
			"sped" : [10, 14],
			"sprd" : 6,
			"amnt" : 3,
			"soun" : sndFrogPistol,
			"kick" : 2,
			"shif" : -4,
			"shak" : 4
		},
		{	"weap" : wep_black_sword,
			"proj" : {
				object_index : Slash,
				damage : 12
			},
			"sped" : 2,
			"soun" : sndBlackSword,
			"kick" : -7,
			"push" : -8,
			"shif" : -9,
			"shak" : 1,
			"flag" : "blacksword"
		},
		{	"weap" : wep_golden_nuke_launcher,
			"proj" : {
				object_index : Nuke,
				sprite_index : sprGoldNuke
			},
			"sped" : 2,
			"sprd" : 2,
			"soun" : sndGoldNukeFire,
			"kick" : 10,
			"shif" : -40,
			"shak" : 10
		},
		{	"weap" : wep_golden_disc_gun,
			"proj" : {
				object_index : Disc,
				sprite_index : sprGoldDisc
			},
			"sped" : 8,
			"sprd" : 3,
			"soun" : sndGoldDiscgun,
			"kick" : 5,
			"shif" : -12,
			"shak" : 4
		},
		{	"weap" : wep_heavy_grenade_launcher,
			"proj" : HeavyNade,
			"sped" : [10, 11],
			"sprd" : 4,
			"soun" : sndHeavyNader,
			"kick" : 8,
			"shif" : -12,
			"shak" : 2
		},
		{	"weap" : wep_gun_gun,
			"proj" : ThrownWep,
			"sped" : 16,
			"soun" : sndGunGun,
			"kick" : 6,
			"shif" : -30,
			"shak" : 8,
			"flag" : "gungun"
		},
		{	"weap" : wep_eggplant
		},
		{	"weap" : wep_golden_frog_pistol,
			"proj" : EnemyBullet2,
			"sped" : [10, 14],
			"sprd" : 6,
			"amnt" : 3,
			"soun" : sndGoldFrogPistol,
			"kick" : 2,
			"shif" : -4,
			"shak" : 4
		}
	]);
	
	 // Set Flagged Projectile Control Scripts:
	flagProjCont = [];
	flagprojcont_set("bouncer",		proj_bouncer);
	flagprojcont_set("disc",		proj_disc);
	flagprojcont_set("lightning",	proj_lightning);
	flagprojcont_set("plasma",		proj_plasma);
	flagprojcont_set("seeker",		proj_seeker);
	flagprojcont_set("nade",		proj_explo);
	flagprojcont_set("mininade",	proj_explosmall);
	flagprojcont_set("heavynade",	proj_exploheavy);
	flagprojcont_set("bloodnade",	proj_exploblood);
	flagprojcont_set("stickynade",	proj_explostick);
	flagprojcont_set("ultranade",	proj_suck);
	flagprojcont_set("ultrabow",	proj_wallbreak);
	flagprojcont_set("rocket",		proj_rocket);
	flagprojcont_set("nuke",		proj_nuke);
	flagprojcont_set("flare",		proj_flare);
	flagprojcont_set("flame",		proj_flame);
	flagprojcont_set("toxic",		proj_toxic);
	flagprojcont_set("cluster",		proj_cluster);
	flagprojcont_set("hyper",		proj_hyper);
	
#macro spr global.spr
#macro msk spr.msk

#macro wepList global.wep_list
#macro wepDefault {
		"weap" : wep_none,
		"name" : "",
		"text" : "",
		"sprt" : mskNone,
		"icon" : 0,
		"swap" : sndSwapPistol,
		"area" : -1,
		"type" : 0,
		"load" : 1,
		"cost" : 0,
		"rads" : 0,
		"auto" : false,
		"mele" : false,
		"gold" : false,
		"blod" : false,
		"lasr" : false,
		"proj" : { object_index : -1 },
		"sped" : [0, 0],
		"sprd" : 0,
		"fixd" : 0,
		"amnt" : 1,
		"shot" : 1,
		"time" : 0,
		"wait" : 0,
		"move" : 0,
		"soun" : [],
		"kick" : 0,
		"push" : 0,
		"shif" : 0,
		"shak" : 0,
		"flag" : [],
		"cont" : script_ref_create(cont_basic)
	}
	
#macro flagProjCont global.flag_cont
#macro flagProjPref "nttemergeproj_"

#define wep_add(_wep)
	var _default = wepDefault;
	with(_wep){
		 // Default to Weapon Stats:
		if("weap" in self){
			if("name" not in self) name = weapon_get_name(weap);
			if("text" not in self) text = weapon_get_text(weap);
			if("sprt" not in self) sprt = weapon_get_sprt(weap);
			if("swap" not in self) swap = weapon_get_swap(weap);
			if("area" not in self) area = weapon_get_area(weap);
			if("type" not in self) type = weapon_get_type(weap);
			if("load" not in self) load = weapon_get_load(weap);
			if("cost" not in self) cost = weapon_get_cost(weap);
			if("rads" not in self) rads = weapon_get_rads(weap);
			if("auto" not in self) auto = weapon_get_auto(weap);
			if("mele" not in self) mele = weapon_is_melee(weap);
			if("gold" not in self) gold = weapon_get_gold(weap);
			if("lasr" not in self) lasr = weapon_get_laser_sight(weap);
			if("icon" not in self) icon = mod_script_call_nc("mod", "telib", "weapon_get_loadout", weap);
		}
		
		 // Default:
		for(var i = 0; i < lq_size(_default); i++){
			var _key = lq_get_key(_default, i);
			if(_key not in self){
				lq_set(self, _key, lq_get_value(_default, i));
			}
		}
		
		 // Object:
		if(!is_object(proj)){
			proj = { object_index : proj };
		}
		if("object_index" not in proj){
			proj.object_index = -1;
		}
		
		 // Speed:
		if(!is_array(sped) || array_length(sped) < 2){
			sped = [sped, sped];
		}
		
		 // Sounds:
		if(!is_array(soun)) soun = [soun];
		for(var i = 0; i < array_length(soun); i++){
			if(!is_object(soun[i])) soun[i] = { snd : soun[i] };
			var s = soun[i];
			
			if("snd"       not in s) s.snd = -1;
			if("pit"       not in s) s.pit = [0.9, 1.1];
			if("vol"       not in s) s.vol = 1;
			if("shot"      not in s) s.shot = -1;
			if("loop"      not in s) s.loop = false;
			if("loop_strt" not in s) s.loop_strt = -1;
			if("loop_stop" not in s) s.loop_stop = -1;
			if("loop_indx" not in s) s.loop_indx = -1;
		}
		
		 // Flags:
		if(!is_array(flag)) flag = [flag];
		
		 // Controller Script:
		if(!is_array(cont)) cont = script_ref_create(cont);
		if(array_length(cont) < 3){
			cont = script_ref_create(cont_basic);
		}
		
		 // Add:
		array_push(wepList, self);
	}
	
#define weapon_merge_decide(_hardMin, _hardMax)
	return weapon_merge_decide_raw(_hardMin, _hardMax, -1, -1, false);
	
#define weapon_merge_decide_raw(_hardMin, _hardMax, _stock, _front, _gold)
	/*
		Returns a 2-element array containing the [stock, front] weapons, for use with 'weapon_merge'
		Returns an empty array if a weapon combination couldn't be found
		
		Args:
			hardMin/hardMax - The difficulty range to get weapons from
			stock/front     - For manually presetting the stock/front weapon, leave -1 to remain automatic
			                  These can also be arrays, representing a list of weapons to not pick
			gold            - Only use golden weapons, true/false
			
		Ex:
			weapon_merge_decide_raw(0, 1 + GameCont.hard, -1, -1, false)
			weapon_merge_decide_raw(3, GameCont.hard, wep_shotgun, [wep, bwep], false)
	*/
	
	var	_stockAvoid = [],
		_frontAvoid = [];
		
	if(!is_object(_stock)){
		if(is_array(_stock)){
			_stockAvoid = _stock;
			_stock = -1;
		}
		else with(wepList){
			if(weap == _stock){
				_stock = self;
				break;
			}
		}
	}
	if(!is_object(_front)){
		if(is_array(_front)){
			_frontAvoid = _front;
			_front = -1;
		}
		else with(wepList){
			if(weap == _front){
				_front = self;
				break;
			}
		}
	}
	
	 // Hardmode:
	_hardMax += ceil((GameCont.hard - (UberCont.hardmode * 13)) / (1 + (UberCont.hardmode * 2))) - GameCont.hard;
	
	 // Robot:
	for(var i = 0; i < maxp; i++){
		if(player_get_race(i) == "robot"){
			_hardMax++;
		}
	}
	_hardMin += 5 * ultra_get("robot", 1);
	
	 // Just in Case:
	_hardMax = max(0, _hardMax);
	_hardMin = min(_hardMin, _hardMax);
	
	 // Get Potential Candidates:
	var _pickList = [];
	with(wepList){
		var _add = true;
		if(
			mele
			|| (_gold xor (gold != 0)) // ^^ is kinda ugly bro
			|| ((area < _hardMin || area > _hardMax) && !(_gold && array_exists([wep_golden_wrench, wep_golden_machinegun, wep_golden_shotgun, wep_golden_crossbow, wep_golden_grenade_launcher, wep_golden_laser_pistol], weap)))
		){
			_add = false;
		}
		else switch(weap){
			case wep_super_disc_gun       : if(variable_instance_get(other, "curse", 0) <= 0) _add = false; break;
			case wep_golden_nuke_launcher : if(!UberCont.hardmode)                            _add = false; break;
			case wep_golden_disc_gun      : if(!UberCont.hardmode)                            _add = false; break;
			case wep_gun_gun              : if(crown_current != crwn_guns)                    _add = false; break;
			
			 // Bro no melee allowed:
			case wep_jackhammer:
				_add = false;
				break;
		}
		
		if(_add) array_push(_pickList, self);
	}
	
	 // Randomly Select Weps from List:
	var	_min  = 0,
		_max  = array_length(_pickList),
		_part = [];
		
	array_shuffle(_pickList);
	
	for(var _s = _min; _s < _max; _s++){
		for(var _f = _min; _f < _max; _f++){
			var	_stockPart = (is_object(_stock) ? _stock : _pickList[_s]),
				_frontPart = (is_object(_front) ? _front : _pickList[_f]),
				_stockWeap = lq_defget(_stockPart, "weap", _stockPart),
				_frontWeap = lq_defget(_frontPart, "weap", _frontPart);
				
			if(_stockWeap != _frontWeap){
				if(!array_exists(_stockAvoid, _stockWeap) && !array_exists(_frontAvoid, _frontWeap)){
					_part = [_stockPart, _frontPart];
					
					 // Difficulty Check:
					if(1 + max(1, lq_defget(_stockPart, "area", 0)) + max(1, lq_defget(_frontPart, "area", 0)) <= _hardMax){
						return _part;
					}
				}
			}
			
			if(is_object(_front)) break;
		}
		
		if(is_object(_stock)) break;
	}
	
	return _part;
	
#define weapon_merge(_stock, _front)
	var _part = [_stock, _front];
	
	 // Look for Weapon in the Mergeable Weapon List:
	for(var i = 0; i < array_length(_part); i++){
		var w = _part[i];
		if(!is_object(w) && fork()){
			 // Wep ID Search:
			if(is_string(w) && w == string_digits(w)){
				w = real(w);
			}
			if(w != -1) with(wepList){
				if(weap == w){
					_part[i] = self;
					exit;
				}
			}
			
			 // Name Search:
			w = _part[i];
			if(is_string(w)){
				w = string_upper(string_trim(w));
				
				 // Normal:
				with(wepList){
					var n = string_upper(name);
					if(n == w || n == _part[i]){
						_part[i] = self;
						exit;
					}
				}
				
				 // Search w/ Underscores -> Spaces:
				w = string_replace_all(w, "_", " ");
				with(wepList){
					var n = string_upper(name);
					if(n == w || n == _part[i]){
						_part[i] = self;
						exit;
					}
				}
			}
			
			_part[i] = wepDefault;
			exit;
		}
	}
	
	return { wep : mod_current, base : weapon_merge_raw(_part[0], _part[1]) };
	
#define weapon_merge_raw(_stock, _front)
	var _wep = data_clone(_front, 1);
	
	with(_wep){
		stock = _stock.weap;
		front = _front.weap;
		weap  = -1;
		swap  = _front.swap;
		area  = -1;
		type  = _front.type;
		auto  = (((_front.auto && _front.load < 10) || _front.auto < 0) ? _front.auto : _stock.auto);
		mele  = ((_front.mele != 0) ? _front.mele : _stock.mele);
		gold  = ((_front.gold != 0) ? _front.gold : _stock.gold);
		blod  = ((_front.blod != 0) ? _front.blod : _stock.blod);
		lasr  = ((_front.lasr != 0) ? _front.lasr : _stock.lasr);
		
		var	_stockObjRaw      = _stock.proj.object_index,
			_frontObjRaw      = _front.proj.object_index,
			_stockObj         = _stockObjRaw,
			_frontObj         = _frontObjRaw,
			_isMelee          = object_is_melee(_frontObj),
			_stockProjCostRaw = max(_stock.cost, 1) / (_stock.amnt * _stock.shot),
			_frontProjCostRaw = max(_front.cost, 1) / (_front.amnt * _front.shot),
			_stockProjCost    = _stockProjCostRaw,
			_frontProjCost    = _frontProjCostRaw,
			_stockAmnt        = _stock.amnt,
			_frontAmnt        = _front.amnt,
			_stockSped        = array_clone(_stock.sped),
			_frontSped        = array_clone(_front.sped);
			
		 // Projectile-Specific Changes:
		switch(_stockObjRaw){
			case Disc:
			case Flare:
			case Grenade:
			case MiniNade:
			case HeavyNade:
			case ClusterNade:
			case ToxicGrenade:
			case BloodGrenade:
			case UltraGrenade:
			case Lightning:
				_stockProjCost /= _stockProjCostRaw;
				if(_front.type == 1) _stockProjCost /= 3;
				break;
				
			case Slug:
			case HeavySlug:
				_stockProjCost *= 1.5;
				break;
				
			case FlakBullet:
			case SuperFlakBullet: // Pretend Flak == Shotgun
				_stockObj = Bullet2;
				_stockAmnt = 16;
				_stockProjCostRaw = _stock.cost / _stockAmnt;
				_stockProjCost = _stockProjCostRaw;
				break;
				
			case Devastator:
				_stockProjCost = max(_frontProjCost * 3, _stockProjCost);
				break;
				
			case Flame:
				_stockAmnt = ceil(_stockAmnt / 2);
				break;
		}
		switch(_frontObjRaw){
			case Laser:
				if(_stock.type != 1 && _stockObjRaw != Disc && _stockObjRaw != Grenade && !object_is_ancestor(_stockObjRaw, Grenade)){
					_frontProjCost /= 2;
					if(_stockObjRaw == Laser) _stockProjCost /= 2;
				}
				break;
			
			case Flame:
				_frontProjCost = 1;
				break;
		}
		
		 // Slow Bullets:
		if(_stock.type == 1 && (_front.type != 1 || _frontSped[1] < _stockSped[1])){
			_stockSped[0] *= 2/3;
			_stockSped[1] *= 2/3;
		}
		
		 // Devalue Bullets:
		if(_front.type == 1){
			_frontProjCost = max(1, _frontProjCost);
			if(_stockProjCostRaw < _frontProjCostRaw / 2) _frontProjCost /= 2;
			else _frontProjCost /= 3;
			
			if(_stock.type == 1){
				_stockProjCost = max(1, _stockProjCost);
				if(_frontProjCostRaw < _stockProjCostRaw / 2) _stockProjCost /= 2;
				else _stockProjCost /= 3;
			}
		}
		
		 // Speed:
		if(_stockSped[0] == _stockSped[1]){
			sped = [
				lerp(_stockSped[0], _frontSped[0], 1/2),
				lerp(_stockSped[1], _frontSped[1], 1/2)
			];
		}
		else{
			sped = [
				lerp(_stockSped[0], _frontSped[0], 1/5),
				lerp(_stockSped[1], _frontSped[1], 4/5)
			];
		}
		array_sort(sped, true);
		
		/// Projectile Amount:
			
			 // Flamethrowers:
			if(_stockObjRaw == Flame){
				amnt = _frontAmnt * _stockAmnt;
			}
			
			 // Normal:
			else{
				 // Determine Fraction of Stock Projectiles to Keep:
				var f = (_stockProjCost / (_frontProjCost * (array_exists(_front.flag, "wave") ? _front.shot : 1)));
				if(f < 1){
					var	_costLevel = 3.333 * sqrt(max(0, _stockProjCostRaw - 1/6)),
						p = _frontProjCostRaw * (array_exists(_front.flag, "wave") ? _front.shot : 1);
						
					if(p < 4){
						f = 1 + (p / (2 * (1 + _costLevel)));
					}
					else{
						f = max(1, (p + 40) / (16 * (1 + (_costLevel / 2))));
					}
					f = 1 / f;
					
					// !!! Use graphing program to visualize ^
				}
				amnt = ceil(_stockAmnt * f);
				
				 // Bro moment:
				if(_front.weap == wep_super_splinter_gun){
					amnt /= _front.shot;
				}
				
				 // Maintain at least 2 projectiles if stock weapon shoots >1 projectiles (Mainly for stuff like Wave Gun):
				if(_stockAmnt > 1) amnt = max(2, amnt);
				
				 // Front Bonus:
				if(_stockAmnt > 1 && _frontAmnt > 1 && (_stockObj == _frontObj || _frontProjCost == _stockProjCostRaw)){
					amnt += _frontAmnt - 1;
					// Triple Machinegun + Quadruple Machinegun = Sextuple Machinegun, Shotgun + Double Shotgun = Sawed-Off Shotgun, etc.
				}
				else{
					amnt *= min(_frontAmnt, _front.cost);
					// Double Shotgun doubles shots, Triple Machinegun triples shots, Super Crossbow quintuples shots, etc. 
				}
			}
			
			amnt = ceil(max(0, amnt)); // Just in case
			
		/// Burst Shots:
			
			 // Uses same equation as projectile amount calculations ^
			shot = _stock.shot;
			if(shot > 1){
				var	_costLevel = 3.333 * sqrt(max(0, _stockProjCost - 1/6)),
					p = _frontProjCost;
					
				if(p < 4){
					shot /= 1 + (p / (2 * (1 + _costLevel)));
				}
				else{
					shot /= max(1, (p + 40) / (16 * (1 + (_costLevel / 2))));
				}
			}
			shot += _front.shot - 1;
			
			 // Maintain at least 2 projectiles if stock weapon shoots >1 projectiles (Mainly for stuff like Wave Gun):
			if(_stock.shot > 1) shot = max(shot, 2);
			
			 // Special Interaction:
			switch(_stockObjRaw){
				case SuperFlakBullet:
					shot += ceil(5 / _front.cost);
					break;
					
				case Flame:
					if(_frontObjRaw != Flame){
						shot /= 1 + _front.amnt;
					}
					break;
			}
			
			shot = ceil(max(0, shot)); // Just in case
			
		 // Burst Delay:
		if(_stock.time > 0 && _front.time > 0){
			time = floor(lerp(_stock.time, _front.time, 0.5));
		}
		else time = max(_stock.time, _front.time);
		
		 // Initial Delay:
		lq_set(self, "wait", max(lq_get(_stock, "wait"), lq_get(_front, "wait")));
		
		 // Fixed Spread:
		if(_front.amnt <= 1 && _stockObj == _frontObj){ // Average Mode
			fixd = (_stock.fixd + _front.fixd) / 2;
		}
		else{ // Scale Mode
			fixd = ((_front.fixd + _stock.fixd) * (_stock.amnt + _front.amnt)) / amnt;
		}
		
		 // Normal Spread:
		sprd = lerp(_stock.sprd, _front.sprd, 0.2);
		
		 // Reload:
		if(_stock.load < 10 && _front.load < 10){ // Fast Mode
			load = ((_stock.load + _front.load) / 3) * ((1 + max(0, (amnt * max(1, shot / 2)) - _stock.amnt)) / _front.amnt);
		}
		else{ // Normal Mode
			load = 0;
			var a = _front.load / (_front.amnt * _front.shot * min(_frontProjCostRaw, 1));
			repeat(amnt * shot * min(_frontProjCostRaw, 1)){
				load += a;
				a *= 1 - (0.05 * min(a, 10));
			}
			
			 // Burst Weapon Nerf:
			if(load < _stock.load || load < _front.load){
				load += (_front.shot - 1) * time;
			}
			
			 // Fast Stock:
			load *= min(1, (_stock.load * ((_stock.type != 1) ? 0.5 : 1.5)) / min(_front.load, 10));
		}
		load = max(1, round(load));
		
		 // Ammo Cost:
		var _limit = max(2, (16 / _frontProjCostRaw) * ((_front.type == 1) ? 5 : 1));
		if(_frontObjRaw == Laser) _limit /= 2;
		cost = _frontProjCostRaw * min(amnt * shot, sqrt(_limit * amnt * shot));
		
		if(_stock.type == 1){ // Pop Rifle-type stuff
			cost += min(0, _stock.cost - (min(_stock.amnt, _stock.cost) * _stock.shot));
		}
		
		cost = clamp(cost, 1, ((type == 1) ? 555 : 99));
		cost = round(cost);
		
		 // Rad Cost:
		rads = (_stock.rads / (_stock.amnt * _stock.shot)) / 2;
		var a = (_front.rads / (_front.amnt * _front.shot));
		repeat(amnt * shot){
			rads += a;
			a *= 0.8;
		}
		rads = ceil(rads);
		rads = min(rads, 600);
		
		 // Spawn Offset:
		move = max(_stock.move, _front.move);
		
		 // Weapon Kick:
		if(abs(_stock.kick) > abs(_front.kick)) kick = _stock.kick;
		else kick = _front.kick;
		
		 // Knockback:
		push = _front.push;
		
		 // Screenshift:
		if(min(cost, amnt) > 1){
			shif = 0;
			var a = _front.shif;
			repeat(min(cost, amnt)){
				shif += a;
				a /= 3;
			}
		}
		else{
			if(abs(_stock.shif) > abs(_front.shif)) shif = _stock.shif;
			else shif = _front.shif;
		}
		
		 // Screenshake:
		shak = 0;//max(_stock.shak, _front.shak);
		var a = _front.shak;
		repeat(min(cost, amnt)){
			shak += a;
			a /= 1 + (push / 5);
		}
		
		 // Sound:
		soun = array_combine(
			data_clone(_stock.soun, infinity),
			data_clone(_front.soun, infinity)
		);
		with(soun){
			vol = 2/3;
		}
		
		/// Name:
			var	_stockName = string_split(string_upper(_stock.name), " "),
				_frontName = string_split(string_upper(_front.name), " "),
				_stockSuffixStart = 0,
				_stockSuffix = ["RIFLE", "MACHINEGUN", "SMG", "MINIGUN", "SHOTGUN", "BOW", "LAUNCHER", "BAZOOKA", "CANNON"],
				_delete = ["GUN", "PISTOL"];
				
			 // Assault Bazooka > Assault Bazooka Rifle:
			if(array_exists(_stockName, "ASSAULT") || array_exists(_stockName, "ROGUE")){
				array_push(_delete, "RIFLE");
			}
			
			 // Remove Redundant Stock Suffixes:
			with(_delete){
				_stockName = array_delete_value(_stockName, self);
			}
			
			 // Start Name w/ Pre-Suffix Stock Name:
			var _name = [];
			if(array_exists(_stockName, "GOLDEN") || array_exists(_frontName, "GOLDEN")){
				array_push(_name, "GOLDEN");
				_stockName = array_delete_value(_stockName, "GOLDEN");
				_frontName = array_delete_value(_frontName, "GOLDEN");
			}
			with(_stockName){
				if(array_exists(_stockSuffix, self)) break;
				array_push(_name, self);
				_stockSuffixStart++;
			}
			
			 // Remove Redundant Front Suffixes if Suffixes Exist in Stock Name:
			if(_stockSuffixStart < array_length(_stockName)){
				with(_delete){
					_frontName = array_delete_value(_frontName, self);
				}
			}
			
			 // Front Name:
			_name = array_combine(_name, _frontName);
			
			 // Add Any Remaining Stock Suffixes:
			for(var i = _stockSuffixStart; i < array_length(_stockName); i++){
				array_push(_name, _stockName[i]);
			}
			
			 // End:
			name = array_join(_name, " ");
			
		/// Loading Tip:
			if(_front.text != ""){
				text = "";
				if(_stock.text != ""){
					text = string_split(_stock.text, " ")[0] + " ";
				}
				text += _front.text;
			}
			else text = _stock.text;
			text = string_lower(text);
			
			 // Swap Projectile References:
			var n = object_get_name(_frontObjRaw);
			switch(n){
				case "Bullet1":	n = "bullet";	break;
				case "Bullet2":	n = "shell";	break;
				
				default:
					 // Auto-Space:
					for(var i = 2; i <= string_length(n); i++){
						var c = string_char_at(n, i);
						if(c == string_upper(c)){
							n = string_insert(" ", n, i++);
						}
					}
					n = string_split(string_lower(n), " ")[0];
			}
			var _swap = [];
			if(_frontObjRaw != Bullet1) array_push(_swap, "bullet");
			if(_frontObjRaw != Bolt) array_push(_swap, "bolt");
			if(_frontObjRaw != Laser) array_push(_swap, "laser");
			if(_frontObjRaw != Grenade){
				array_push(_swap, "grenade");
				array_push(_swap, "nade");
			}
			with(_swap) other.text = string_replace_all(other.text, self, n);
			
		 // Initialize Sprites:
		sprt = -1;
		icon = -1;
		mod_script_call_nc("mod", "teassets", "weapon_merge_sprite", _stock.sprt, _front.sprt);
		mod_script_call_nc("mod", "teassets", "weapon_merge_sprite_loadout", _stock.icon, _front.icon);
		
		 // Flags:
		flag = array_combine(_stock.flag, _front.flag);
		
		 // Controller:
		if(!array_equals(_stock.cont, script_ref_create(cont_basic))){
			cont = _stock.cont;
		}
		else cont = _front.cont;
		
		 // Projectile-Specific:
		var _flagProj = [];
		switch(_stockObjRaw){
			case BouncerBullet:
				array_push(_flagProj, "bouncer");
				break;
				
			case Disc:
				array_push(_flagProj, "disc");
				break;
				
			case Laser:
				if(_frontObj != Laser){
					array_push(flag, "laser");
					if(_stock.shot <= 1){
						time = 0;
						var n = min(_front.cost, _front.amnt);
						shot *= (amnt / n);
						amnt = n;
					}
				}
				break;
				
			case Lightning:
			case LightningBall:
				array_push(_flagProj, "lightning");
				break;
				
			case PlasmaBall:
			case PlasmaBig:
			case PlasmaHuge:
				array_push(_flagProj, "plasma");
				break;
				
			case Seeker:
				array_push(_flagProj, "seeker");
				break;
				
			case Grenade:
			case MiniNade:
			case HeavyNade:
			case ToxicGrenade:
			case BloodGrenade:
			case UltraGrenade:
			case ClusterNade:
			case BloodBall:
				if(_stockObjRaw != _frontObjRaw || lq_defget(_stock.proj, "sticky", false) != lq_defget(_front.proj, "sticky", false)){
					switch(_stockObjRaw){
						case MiniNade:
							array_push(_flagProj, "mininade");
							break;
							
						case UltraGrenade:
							array_push(_flagProj, "ultranade");
						case HeavyNade:
							array_push(_flagProj, "heavynade");
							break;
							
						case ToxicGrenade:
							array_push(_flagProj, "nade");
							array_push(_flagProj, "toxic");
							break;
							
						case BloodBall:
						case BloodGrenade:
							array_push(_flagProj, "bloodnade");
							break;
							
						case ClusterNade:
							array_push(_flagProj, "cluster");
							break;
							
						default:
							if(lq_defget(_stock.proj, "sticky", false)){
								array_push(_flagProj, "stickynade");
							}
							else{
								array_push(_flagProj, "nade");
							}
					}
					
					 // Extra Ammo Cost:
					cost += round(
						power(
							(amnt * shot) / power(_frontProjCostRaw, 1/2),
							max(1, _frontProjCostRaw) / 3
						)
						* max(1, _stockProjCostRaw)
					);
					
					 // Extra Reload:
					load += round((amnt * shot * (1 + _frontProjCostRaw)) / 2);
				}
				break;
				
			case Rocket:
				array_push(_flagProj, "rocket");
				break;
				
			case Nuke:
				array_push(_flagProj, "nuke");
				break;
				
			case Flare:
			case FlameBall:
				array_push(_flagProj, "flare");
				array_push(_flagProj, "flame");
				break;
				
			case FlameShell:
				array_push(_flagProj, "flame");
				break;
				
			case ToxicBolt:
				array_push(_flagProj, "toxic");
				break;
				
			case FlakBullet:
			case SuperFlakBullet:
				array_push(flag, "flak");
				break;
				
			case HyperSlug:
			case HyperGrenade:
				array_push(_flagProj, "hyper");
				if(_frontObj == Lightning){
					cost *= 2;
				}
				break;
				
			case UltraBullet:
				load = ceil(load / 2.5);
				sped[0] *= 1.2;
				sped[1] *= 1.2;
				break;
				
			case UltraBolt:
				array_push(_flagProj, "ultrabow");
				break;
				
			case Devastator:
				sped[0] /= 2;
				break;
				
			case Flame:
				if(_frontObjRaw != Flame){
					array_push(_flagProj, "flame");
					if(_stock.load <= _stock.shot * max(1, _stock.time)){
						 // Spread:
						sprd *= 3;
						
						 // Reload/Delay:
						time = round(sqrt(_front.load / (_front.shot * (1 + _front.time))));
						load = (shot * time) * (_stock.load / (_stock.shot * _stock.time));
						
						 // Spawn Offset:
						move = lerp(_stock.move, _front.move, 0.5);
						
						 // Post-fire:
						kick = _front.kick;
						shak = _front.shak;
						shif = _stock.shif;
					}
				}
				break;
		}
		switch(_frontObjRaw){
			case Disc:
				sped[0] *= 2/3;
				sped[1] *= 2/3;
				break;
				
			case Flame:
				if(!array_exists(flag, "laser")){
					time = _stock.time;
					amnt *= _front.shot;
					fixd /= _front.shot;
					shot = _stock.shot;
					
					switch(_stockObjRaw){
						case SuperFlakBullet:
							shot += ceil(5 / _front.cost);
							break;
							
						case PlasmaBall:
						case PlasmaBig:
						case PlasmaHuge:
							if(array_exists([PlasmaBall, PlasmaBig, PlasmaHuge], _stockObjRaw)){
								sped[0] *= 4/3;
								sped[1] *= 4/3;
							}
							break;
					}
				}
				break;
		}
		with(_flagProj) lq_set(other.proj, flagProjPref + self, null);
		
		 // Gun Gun:
		var	_ggStock = (array_exists(_stock.flag, "gungun") && _stockObjRaw == ThrownWep),
			_ggFront = (array_exists(_front.flag, "gungun") && _frontObjRaw == ThrownWep);
			
		if(_ggStock || _ggFront){
			var	a = data_clone((_ggStock ? _stock : _front), infinity),
				b = data_clone((_ggStock ? _front : _stock), infinity);
				
			 // Ammo Cost:
			cost = 1 + (sqrt(b.cost) * 19 * ((type == 1) ? 5 : 1));
			cost = clamp(cost, 1, ((type == 1) ? 555 : 99));
			cost = round(cost);
			rads = min(b.rads * 5, 600);
			
			 // Projectile:
			proj = lq_clone(a.proj);
			proj.wep = array_create(2, -1);
			proj.wep[_ggFront ? 0 : 1] = b;
			
			 // Speed:
			sped = [
				max(b.sped[0], lerp(a.sped[0], b.sped[0], 0.5)),
				max(b.sped[1], lerp(a.sped[1], b.sped[1], 0.5))
			];
			
			 // Other:
			name = _stock.name + " " + _front.name;
			swap = a.swap;
			area = a.area;
			type = b.type;
			auto = b.auto;
			load = b.load * 3;
			sprd = b.sprd;
			fixd = b.fixd;
			amnt = a.amnt;
			shot = a.shot;
			time = a.time;
			lq_set(self, "wait", lq_get(b, "wait"));
			move = b.move;
			kick = b.kick;
			push = a.push;
			shif = b.shif;
			shak = b.shak;
			cont = b.cont;
			flag = array_combine(a.flag, b.flag);
		}
		
		//- Flak,           projectile flakball (Burst shots become super flak)
		//- Disc,           no friction + bouncy for a limited time + can hurt player
		//- Bouncer,        can bounce once
		//- Seeker,         homing
		//- Grenade,        explodes on destruction
		//- Stick Nade,     • stick to enemies 
		//- Heavy Nade,     • heavy explosions
		//- Blood Nade,     • blood explosions
		//- Cluster,        create mini nades on destruction
		//- Rocket,         infinite acceleration until wall collision
		//- Nuke,           infinite acceleration + homes towards cursor
		//- Blood,          can hurt self for ammo
		//- Flare,          flame trail
		//- Laser,          burst shots fire instantly and hitscan with increasing distance
		//- Lightning,      follows a lightning-like path
		//-?Plasma,         no friction until hit a wall? plasma explosion?
		// ?Plasma Cannon,  kind of flak but without friction???
		//- Devastator,     shoots a lot of projectiles with highly variable speed
		//- Ultra Crossbow, can break limited walls
		//- Ultra Nader,    attract enemies
		//- Flame,          create flame on destruction (flameshell)
		//- Toxic,          create toxic gas on destruction
		//- Hyper,          hitscan
		//- Flamethrower,   make weapon spew projectiles continuously, decrease shots so that its just really ammo expensive
	}
	
	return _wep;
	
	
#define flagprojcont_set(_flag, _scrt)
	if(is_real(_scrt)) _scrt = script_ref_create(_scrt);
	array_push(flagProjCont, {
		"flag" : flagProjPref + _flag,
		"scrt" : _scrt,
		"inst" : [],
		"vars" : []
	});
	
#define flagprojcont_get(_flag)
	return lq_get(flagProjCont, _flag);
	
#define wep_stat(_wep, _stat)
	return lq_defget(lq_defget(_wep, "base", wepDefault), _stat, lq_defget(wepDefault, _stat, -1));
	
#define weapon_name(_wep)         return wep_stat(_wep, "name");
#define weapon_text(_wep)         return wep_stat(_wep, "text");
#define weapon_swap(_wep)         return wep_stat(_wep, "swap");
#define weapon_area(_wep)         return -1;
#define weapon_gold(_wep)         return ((wep_stat(_wep, "gold") != 0) ? -1 : 0);
#define weapon_type(_wep)         return wep_stat(_wep, "type");
#define weapon_cost(_wep)         return wep_stat(_wep, "cost");
#define weapon_rads(_wep)         return wep_stat(_wep, "rads");
#define weapon_load(_wep)         return wep_stat(_wep, "load");
#define weapon_auto(_wep)         return wep_stat(_wep, "auto");
#define weapon_melee(_wep)        return wep_stat(_wep, "mele");
#define weapon_laser_sight(_wep)  return wep_stat(_wep, "lasr");
#define weapon_blood(_wep)        return (wep_stat(_wep, "blod") ? max(floor(weapon_get_cost(_wep) / 2), 1) : 0);

#define weapon_sprt(_wep)
	var _spr = wep_stat(_wep, "sprt");
	
	 // Setup Sprite:
	if(!sprite_exists(_spr)){
		var	_stock = weapon_get_sprt(wep_stat(_wep, "stock")),
			_front = weapon_get_sprt(wep_stat(_wep, "front"));
			
		_spr = mod_script_call("mod", "teassets", "weapon_merge_sprite", _stock, _front);
	}
	
	return (sprite_exists(_spr) ? _spr : mskNone);
	
#define weapon_loadout
	var	_wep = ((argument_count > 0) ? argument0 : mod_current),
		_spr = wep_stat(_wep, "icon");
		
	 // Setup Loadout Sprite:
	if(!sprite_exists(_spr)){
		var	_stock = mod_script_call("mod", "telib", "weapon_get_loadout", wep_stat(_wep, "stock")),
			_front = mod_script_call("mod", "telib", "weapon_get_loadout", wep_stat(_wep, "front"));
			
		_spr = mod_script_call("mod", "teassets", "weapon_merge_sprite_loadout", _stock, _front);
	}
	
	return (sprite_exists(_spr) ? _spr : 0);
	
#define weapon_fire(_wep)
	if(is_object(_wep)){
		var _fire = mod_script_call("mod", "telib", "weapon_fire_init", _wep);
		_wep = _fire.wep;
		
		GunCont(lq_defget(_wep, "base", wepDefault), x, y, team, _fire.creator, gunangle, accuracy);
	}
	
#define GunCont(_wep, _x, _y, _team, _creator, _gunangle, _accuracy)
	with(instance_create(_x, _y, CustomObject)){
		name = "GunCont";
		
		 // Vars:
		wep      = _wep;
		creator  = _creator;
		gunangle = _gunangle;
		accuracy = _accuracy;
		team     = _team;
		shot     = 0;
		time     = lq_get(_wep, "wait");
		bloom    = true;
		
		 // Events:
		on_step    = GunCont_step;
		on_draw    = GunCont_draw;
		on_destroy = GunCont_destroy;
		on_cleanup = GunCont_destroy;
		
		 // Call Init Event:
		var _scr = _wep.cont;
		mod_script_call(_scr[0], _scr[1], _scr[2], contInit);
		
		if(instance_exists(self)){
			 // Smart Gun:
			if(array_exists(_wep.flag, "smart")){
				if(array_length(instances_matching(instances_matching(CustomBeginStep, "name", "step_smartaim"), "creator", _creator)) <= 0){
					with(script_bind_begin_step(step_smartaim, 0)){
						name = script[2];
						creator = _creator;
						time = 0;
					}
				}
				with(instances_matching(instances_matching(CustomBeginStep, "name", "step_smartaim"), "creator", _creator)){
					time = max(_wep.load, lq_get(_wep, "wait") + (_wep.shot * _wep.time));
					step_smartaim();
				}
			}
			
			 // Call Step:
			GunCont_step();
		}
		
		if(instance_exists(self)) return id;
	}
	return noone;
	
#define GunCont_step
	var	_wep     = wep,
		_flag    = _wep.flag,
		_amnt    = _wep.amnt,
		_shotMax = _wep.shot,
		_timeMax = _wep.time;
		
	 // Crown of Death:
	if(crown_current == crwn_death && _wep.proj.object_index == MiniNade){
		if(_shotMax > 1) _shotMax++;
		else _amnt++;
	}
	
	if((instance_exists(creator) || creator == noone) && (time > 0 || shot < _shotMax)){
		 // Follow Creator:
		if(instance_exists(creator)){
			x = creator.x;
			y = creator.y;
			if("gunangle" in creator) gunangle = creator.gunangle;
			if("accuracy" in creator) accuracy = creator.accuracy;
			if("team" in creator) team = creator.team;
		}
		
		 // Step:
		var _scr = _wep.cont;
		mod_script_call(_scr[0], _scr[1], _scr[2], contStep);
		
		 // Firing:
		var	_x        = x,
			_y        = y,
			_angle    = gunangle,
			_accuracy = accuracy,
			_creator  = creator,
			_team     = team,
			_proj     = _wep.proj,
			_obj      = _proj.object_index,
			_isMelee  = object_is_melee(_obj),
			_flakBall = [],
			_laserMov = 0,
			_laserDir = [];
			
		while(time <= 0 && shot < _shotMax){
			var _shot = shot;
			
			 // Flak Mode - >1 Shots Become Super Flak
			if(array_exists(_flag, "flak")){
				_timeMax = 0;
			}
			
			 // Fire:
			if(object_exists(_obj)){
				var _flak = [];
				
				for(var i = 0; i < _amnt; i++){
					 // Speed:
					var _spd = random_range(_wep.sped[0], _wep.sped[1]);
					
					 // Center Projectile Bonus Speed (Shovels, Flamethrowers):
					if((_isMelee || _obj == Flame) && _amnt > 2){
						if(i == floor((_amnt - 1) / 2) || i == ceil((_amnt - 1) / 2)){
							_spd++;
						}
					}
					
					 // Fixed Spread:
					var _fix = _wep.fixd * (i - ((_amnt - 1) / 2));
					if(array_exists(_flag, "wave")){
						_fix -= ((_wep.fixd * sign(_fix)) / 2) * (1 - sin((7 * (1 - (_shot / (_shotMax - 1)))) / 2));
					}
					
					 // Offset, Long Arms:
					var _dis = 0;
					if(_isMelee){
						_dis += ((_isMelee == 2) ? 10 : (20 - abs(_fix / 12))) * skill_get(mut_long_arms);
					}
					
					 // Create Projectile:
					var _dir = _angle + ((_fix + orandom(_wep.sprd)) * _accuracy);
					with(projectile_create(_x + lengthdir_x(_dis, _dir), _y + lengthdir_y(_dis, _dir), _obj, _dir, _spd)){
						 // Offset:
						if(_wep.move != 0){
							x += hspeed;
							y += vspeed;
							move_contact_solid(direction, _wep.move);
							x -= hspeed;
							y -= vspeed;
							xprevious = x;
							yprevious = y;
							xstart = x;
							ystart = y;
						}
						
						 // Wep-Specific:
						for(var j = 0; j < lq_size(_proj); j++){
							var _name = lq_get_key(_proj, j);
							
							if(!array_exists(
								["id", "object_index", "bbox_bottom", "bbox_top", "bbox_right", "bbox_left", "image_number", "sprite_yoffset", "sprite_xoffset", "sprite_height", "sprite_width"],
								_name
							)){
								var _valu = lq_get_value(_proj, j);
								variable_instance_set(self, _name, _valu);
							}
						}
						
						 // Lasery Hitscan:
						if(array_exists(_flag, "laser") && !instance_is(self, Lightning)){
							if(array_length(_laserDir) <= i){
								_laserDir[i] = _dir;
							}
							if(_laserMov > 0){
								var a = angle_difference(_laserDir[i], direction);
								direction += a / 1.5;
								image_angle += a / 1.5;
								
								var	d = _laserDir[i],
									t = _laserMov;
									
								while(true){
									 // Collision:
									if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
										t = 0;
									}
									if(place_meeting(x + hspeed_raw, y + vspeed_raw, hitme)){
										with(instances_meeting(x, y, instances_matching_ne(hitme, "team", team))){
											if(place_meeting(x, y, other)){
												if(chance(1, 4)) t = 0;
											}
										}
									}
									
									 // Move:
									if(t > 0){
										var l = min(t, max(speed_raw, 4));
										x += lengthdir_x(l, d);
										y += lengthdir_y(l, d);
										t -= l;
									}
									else break;
								}
								xprevious = x;
								yprevious = y;
								xstart = x;
								ystart = y;
								
								with(instance_create(x, y, EatRad)){
									motion_add(other.direction + 180, 1);
									depth = other.depth - 1;
								}
							}
							if(chance(3, _amnt)){
								var o = random(random(speed));
								with(instance_create(x + lengthdir_x(o, direction) + orandom(12), y + lengthdir_y(o, direction) + orandom(12), PlasmaTrail)){
									motion_add(other.direction, 1);
									motion_add(random(360), 1);
								}
							}
						}
						
						 // Long Arms:
						if(_isMelee){
							speed += 3 * skill_get(mut_long_arms);
						}
						
						 // Black Sword:
						if(array_exists(_flag, "blacksword")){
							if(instance_exists(creator) && creator.my_health <= 0){
								if(_isMelee == 1) sprite_index = sprMegaSlash;
								damage = max(damage, 80);
							}
						}
						
						 // Gun Gun:
						if(array_exists(_flag, "gungun")){	
							instance_create(_x + hspeed, _y + vspeed, GunGun);
							
							if("wep" in self){
								var	_hardMin = 0,
									_hardMax = GameCont.hard + 10 + (2 * variable_instance_get(creator, "curse", 0));
									
								 // Merged:
								if(is_array(wep)){
									var _part = weapon_merge_decide_raw(_hardMin, _hardMax, wep[0], wep[1], (lq_defget(wep[0], "gold", 0) != 0 || lq_defget(wep[1], "gold", 0) != 0));
									if(array_length(_part) >= 2){
										wep = weapon_merge(_part[0], _part[1]);
									}
									
									 // Default:
									else wep = wep_screwdriver;
								}
								
								 // Normal:
								else wep = weapon_decide(_hardMin, _hardMax, false, null);
								
								 // Spriterize:
								sprite_index = weapon_get_sprt(wep);
							}
							
							if("rotspeed" in self){
								rotspeed /= 1 + (0.2 * abs(16 - speed));
							}
						}
						
						 // Cannon:
						if(array_exists(_flag, "flak")){
							if(_amnt < 16) direction = (i + orandom(0.5)) * (360 / _amnt);
							else direction = random(360);
							image_angle = direction;
							array_push(_flak, id);
						}
						
						 // Non-Cannon:
						else proj_post(_flag);
					}
				}
				
				 // Flak Ball:
				if(array_length(_flak) > 0){
					with(projectile_create(x, y, "MergeFlak", _angle + orandom(_wep.sprd * _accuracy), random_range(11, 13))){
						inst = _flak;
						flag = _flag;
						event_perform(ev_step, ev_step_normal);
						array_push(_flakBall, self);
					}
				}
			}
			if(array_exists(_flag, "laser") && _obj != Lightning){
				_laserMov += sprite_get_width(object_get_sprite(_obj)) * ((_obj == Flame) ? 0.4 : 1);
			}
			
			 // Dog Spin Attack:
			if(array_exists(_flag, "dogspin")){
				with(creator) if(race == "bigdog"){
					alarm2 = 15;
					dogammo = 15;
					image_index = 0;
					sprite_index = sprScrapBossCharge;
				}
			}
			
			 // Post-Fire Effects:
			if(_timeMax > 0 || shot == 0){
				 // Sound:
				with(_wep.soun){
					if(shot < 0 || shot == _shot || (is_array(shot) && array_exists(shot, _shot))){
						var	_snd = (is_array(snd) ? snd[irandom(array_length(snd) - 1)] : snd),
							_pit = (is_array(pit) ? random_range(pit[0], pit[1]) : pit),
							_vol = (is_array(vol) ? random_range(vol[0], vol[1]) : vol);
							
						switch(_snd){
							 // Laser Brain:
							case sndLaser:
							case sndLaserCannon:
							case sndGoldLaser:
							case sndUltraLaser:
							case sndPlasma:
							case sndPlasmaRifle:
							case sndPlasmaMinigun:
							case sndPlasmaBig:
							case sndPlasmaHuge:
							case sndLightningPistol:
							case sndLightningRifle:
							case sndLightningShotgun:
							case sndLightningCannon:
							case sndEnergyScrewdriver:
							case sndEnergySword:
							case sndEnergyHammer:
							case sndDevastator:
								if(skill_get(mut_laser_brain)){
									_snd = asset_get_index(sound_get_name(_snd) + "Upg");
								}
								break;
								
							 // Black Sword:
							case sndBlackSword:
								if(array_exists(_flag, "blacksword")){
									if(instance_exists(_creator) && _creator.my_health <= 0){
										_snd = sndBlackSwordMega;
									}
								}
								break;
						}
						
						if(loop){
							if(loop_indx == -1){
								sound_play(loop_strt);
								loop_indx = audio_play_sound(snd, 0, true);
							}
						}
						else sound_play_pitchvol(_snd, _pit, _vol);
					}
				}
				
				with(creator){
					//if("wepangle" in self) wepangle *= -1;
					
					 // Kick, Shift, Shake, Knockback:
					if(instance_is(self, Player)){
						weapon_post(_wep.kick, _wep.shif, _wep.shak);
					}
					else if("wkick" in self){
						wkick = _wep.kick;
					}
					hspeed -= lengthdir_x(_wep.push, _angle);
					vspeed -= lengthdir_y(_wep.push, _angle);
				}
			}
			
			time = _timeMax;
			shot++;
		}
		
		 // Super Flak Ball:
		var n = array_length(_flakBall);
		for(var i = 0; i < n; i++){
			with(_flakBall[i]){
				direction += i * (360 / n);
				image_angle = direction;
			}
		}
		if(n > 1){
			with(projectile_create(x, y, "MergeFlak", _angle + orandom(_wep.sprd * _accuracy), random_range(11, 13))){
				inst = _flakBall;
				flag = _flag;
				event_perform(ev_step, ev_step_normal);
			}
		}
		
		time -= current_time_scale;
	}
	else instance_destroy();
	
#define GunCont_draw
	image_alpha = abs(image_alpha);
	
	 // Call Draw Event:
	var _scr = wep.cont;
	mod_script_call(_scr[0], _scr[1], _scr[2], contDraw);
	
	image_alpha = -abs(image_alpha);
	
#define GunCont_destroy
	var _wep = wep;
	
	 // Stop Sound Loops:
	if(array_length(instances_matching(instances_matching(object_index, "name", name), "wep", _wep)) <= 1){
		with(_wep.soun) if(loop_indx != -1){
			if(loop) sound_play(loop_stop);
			audio_stop_sound(loop_indx);
			loop_indx = -1;
		}
	}
	
	
#macro contInit 0
#macro contStep 1
#macro contDraw 2

#define cont_basic(_event)
	// ...
	
#define cont_laser_cannon(_event)
	var _wep = wep;
	switch(_event){
		case contInit:
			sound_play_pitch(sndLaserCannonCharge, 1 + orandom(0.1));
			
			 // Visual:
			sprite_index = sprPlasmaBall;
			image_xscale = 0.2;
			image_yscale = 0.2;
			image_speed = 0;
			
			 // Laser Brain:
			shot -= round(_wep.shot * 0.4 * skill_get(mut_laser_brain));
			
			break;
			
		case contStep:
			 // Charge:
			image_xscale += 0.02 * current_time_scale;
			image_yscale += 0.02 * current_time_scale;
			if(time <= 0){
				var f = max(4 - (0.4 * _wep.shot), 1.05);
				image_xscale /= 1.2;
				image_yscale /= 1.2;
			}
			
			 // Damage:
			for(var i = 0; i < _wep.amnt; i++){
				var	_dir = gunangle + (_wep.fixd * (i - ((_wep.amnt - 1) / 2))),
					_ox = lengthdir_x(_wep.move, _dir),
					_oy = lengthdir_y(_wep.move, _dir),
					_x = x + lengthdir_x(_wep.move, _dir),
					_y = y + lengthdir_y(_wep.move, _dir);
					
				if(place_meeting(_x, _y, hitme)){
					with(instances_meeting(_x, _y, instances_matching_ne(hitme, "team", team))){
						if(place_meeting(x - _ox, y - _oy, other)){
							with(other){
								if(projectile_canhit_melee(other)){
									projectile_hit(other, 2, 3, point_direction(_x, _y, other.x, other.y));
									view_shake_at(x, y, 2);
									sleep(5);
								}
							}
						}
					}
				}
			}
			
			break;
			
		case contDraw:
			 // Draw w/ Offset:
			for(var i = 0; i < _wep.amnt; i++){
				var	_dir = gunangle + (_wep.fixd * (i - ((_wep.amnt - 1) / 2))),
					_x = x + lengthdir_x(_wep.move, _dir),
					_y = y + lengthdir_y(_wep.move, _dir);
					
				draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
				
				if(_wep.fixd == 0) break;
			}
			
			break;
	}
	
	
#define step_smartaim
	if(time > 0 && instance_exists(creator)){
		time -= current_time_scale;
		
		 // Auto Aim:
		with(creator){
			var	_x = (instance_is(self, Player) ? mouse_x[index] : x),
				_y = (instance_is(self, Player) ? mouse_y[index] : y),
				_team = variable_instance_get(self, "team", 0),
				_nearest = instance_nearest_array(_x, _y, instances_matching_ne(instances_matching_ne([Player, Sapling, Ally, enemy, CustomHitme], "team", _team, 0), "mask_index", mskNone, sprVoid));
				
			if(instance_exists(_nearest)){
				if("gunangle" in self){
					gunangle = point_direction(x, y, _nearest.x, _nearest.y);
				}
				if(instance_is(self, Player)){
					canaim = false;
				}
			}
		}
	}
	else{
		if(instance_is(creator, Player)){
			with(creator) canaim = true;
		}
		instance_destroy();
	}
	
#define proj_post(_flag)
	var _inst = self;
	
	 // Lasers:
	if(instance_is(self, Laser)){
		speed = 0;
		event_perform(ev_alarm, 0);
	}
	
	 // Lightning (Manual Growth):
	if(instance_is(self, Lightning)){
		ammo = ceil(speed * 2);
		if((flagProjPref + "nuke") in self){
			ammo *= 2;
		}
		if((flagProjPref + "rocket") in self){
			ammo *= 2.5;
		}
		if((flagProjPref + "hyper") in self){
			ammo *= 2;
		}
		
		 // Grow:
		_inst = lightning_grow(
			(flagProjPref + "seeker" ) in self,
			(flagProjPref + "nuke"   ) in self && "index" in creator,
			(flagProjPref + "disc"   ) in self,
			(flagProjPref + "bouncer") in self,
			array_exists(_flag, "laser")
		);
		
		 // Visual:
		visible = false;
		with(instance_create(x, y, LightningSpawn)){
			image_angle = other.image_angle;
			creator = other;
		}
	}
	
	 // Nukes:
	if(instance_is(self, Nuke) && "index" in creator){
		index = creator.index;
	}
	
	 // Bind Flagged Projectile Controller Script:
	with(flagProjCont){
		var s = scrt;
		with(_inst) if(other.flag in self){
			var o = {};
			variable_instance_set(id, other.flag, o);
			
			var _cancel = mod_script_call_self(s[0], s[1], s[2], proj_create, o);
			if(instance_exists(self) && is_real(_cancel) && _cancel){
				variable_instance_set(id, other.flag, null);
			}
		}
	}
	if(array_length(instances_matching(CustomScript, "name", "flagprojcont_step")) <= 0){
		with(script_bind_step(flagprojcont_step, 0)){
			name = script[2];
			list = flagProjCont;
			event_perform(ev_step, ev_step_normal);
		}
	}
	
#define flagprojcont_step
	with(list){
		var	_scrtTyp = scrt[0],
			_scrtMod = scrt[1],
			_scrtNam = scrt[2],
			_flag    = flag,
			_inst    = inst,
			_vars    = vars;
			
		 // Add New:
		var _instNew = instances_matching_ne(projectile, _flag, null);
		if(array_length(_instNew)) with(_instNew){
			if(array_find_index(_inst, id) < 0){
				var o = lq_clone(variable_instance_get(id, _flag));
				variable_instance_set(id, _flag, o);
				array_push(_inst, id);
				array_push(_vars, o);
			}
			else break;
		}
		
		 // Main:
		var	i = 0;
		if(array_length(_inst)) with(_inst){
			var _end = true;
			
			 // Call Projectile Events:
			if(instance_exists(self)){
				_end = mod_script_call_self(_scrtTyp, _scrtMod, _scrtNam, proj_step, _vars[i]);
			}
			else mod_script_call_nc(_scrtTyp, _scrtMod, _scrtNam, proj_destroy, _vars[i]);
			
			 // End:
			if(_end){
				_inst = array_delete(_inst, i);
				_vars = array_delete(_vars, i);
				if(instance_exists(self)) variable_instance_set(id, _flag, null);
			}
			else i++;
		}
		
		inst = _inst;
		vars = _vars;
	}
	
#macro proj_create	0
#macro proj_step	1
#macro proj_destroy	2

#define proj_bouncer(_event, o)
	switch(_event){
		case proj_create:
			o.bounce = 1;
			break;
			
		case proj_step:
			if(speed > 0){
				speed += friction_raw * 0.5;
				
				 // Wall Bounce:
				if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
					var d = direction;
					if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
					if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
					image_angle += (direction - d);
					
					 // Effects:
					sound_play(sndBouncerBounce);
					instance_create(x, y, Dust);
					
					 // End:
					if(--o.bounce <= 0) return true;
				}
			}
			
			 // Laser Interaction:
			else if(object_index == Laser){
				if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
					var _inst = instance_copy(false);
					with(_inst){
						var	h = lengthdir_x(2, image_angle),
							v = lengthdir_y(2, image_angle);
							
						x -= h;
						y -= v;
						xstart = x;
						ystart = y;
						
						if(place_meeting(x + h, y, Wall)) h *= -1;
						else if(place_meeting(x, y + v, Wall)) v *= -1;
						else{
							if(chance(1, 2)) h *= -1;
							else v *= -1;
						}
						
						image_angle = point_direction(0, 0, h, v);
						image_xscale = 1;
						
						 // FX:
						instance_create(x, y, Dust);
						sound_play(sndBouncerBounce);
						
						 // Pew:
						event_perform(ev_alarm, 0);
					}
					
					 // End:
					if(--o.bounce <= 0) return true;
				}
			}
			break;
	}
	
#define proj_disc(_event, o)
	switch(_event){
		case proj_create:
			if(object_index == Disc) return true; // No discs
			
			 // Resprite:
			var _name = instance_get_name(self);
			with(team_instance_sprite(1, self)){
				o.time = 50;
				o.team_change = (speed > 0);
				
				 // Auto-Hitid:
				if(hitid == -1){
					hitid = [
						((sprite_index == sprEnemyLaser) ? sprEnemyLaserStart : sprite_index),
						_name
					];
				}
			}
			break;
			
		case proj_step:
			if(speed > 0){
				 // Trail:
				with(instance_create(x, y, DiscTrail)){
					image_angle  = other.image_angle;
					image_xscale = other.sprite_height / 32;
					image_yscale = image_xscale;
				}
				
				var _spd = 2/3;
				if(o.time > 0){
					o.time -= current_time_scale;
					
					 // Disable Friction:
					speed += friction_raw;
					
					 // Wall Bounce:
					if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
						var d = direction;
						if(place_meeting(x + hspeed_raw, y, Wall)) hspeed_raw *= -1;
						if(place_meeting(x, y + vspeed_raw, Wall)) vspeed_raw *= -1;
						if(direction == d){
							direction = pround(d - 45, 90) + 45 + 180;
							direction -= angle_difference(d + 180, direction);
						}
						image_angle += (direction - d);
						
						 // Effects:
						sound_play_hit(sndDiscBounce, 0.3);
						with(instance_create(x, y, DiscBounce)){
							image_angle = other.image_angle;
						}
					}
					
					 // Movement:
					var	h = hspeed_raw * _spd,
						v = vspeed_raw * _spd;
						
					if(!place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
						x += h;
						y += v;
					}
					else{
						if(!place_meeting(x + hspeed_raw, y, Wall)) x += h;
						if(!place_meeting(x, y + vspeed_raw, Wall)) y += v;
					}
					x -= hspeed_raw;
					y -= vspeed_raw;
				}
				else{
					x -= hspeed_raw * (1 - _spd);
					y -= vspeed_raw * (1 - _spd);
				}
			}
			else if(object_index == Laser || object_index == EnemyLaser){
				if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
					var _inst = instance_copy(false);
					with(_inst){
						var	h = lengthdir_x(2, image_angle),
							v = lengthdir_y(2, image_angle);
							
						x -= h;
						y -= v;
						xstart = x;
						ystart = y;
						
						if(place_meeting(x + h, y, Wall)) h *= -1;
						else if(place_meeting(x, y + v, Wall)) v *= -1;
						else{
							if(chance(1, 2)) h *= -1;
							else v *= -1;
						}
						
						image_angle = point_direction(0, 0, h, v);
						image_xscale = 1;
						
						 // Scary laser:
						team = -1;
						
						 // Effects:
						sound_play_hit(sndDiscBounce, 0.3);
						with(instance_create(x, y, DiscBounce)){
							image_angle = other.image_angle;
						}
						
						 // Pew:
						event_perform(ev_alarm, 0);
					}
					
					 // End:
					return true;
				}
			}
			
			 // Become Unfriendly:
			if(o.team_change && !place_meeting(x, y, creator)){
				o.team_change = false;
				team = -1;
			}
			
			break;
	}
	
#define proj_lightning(_event, o)
	switch(_event){
		case proj_create:
			if(instance_is(self, Lightning)) return true;
			
			 // Vars:
			o.time = 1;
			o.last = noone;
			o.lastx = x;
			o.lasty = y;
			o.ammo = max(6, speed / 2);
			
			 // Start FX:
			with(instance_create(x, y, LightningSpawn)){
				image_angle = other.image_angle;
			}
			break;
			
		case proj_step:
			if(o.time > 0){
				o.time -= current_time_scale;
				if(o.time <= 0){
					if(speed > 0 && o.ammo > 0/* && (instance_exists(o.last) || o.last == noone)*/){
						o.time = (8 + random(4)) / speed;
						o.ammo--;
						
						var	_target = instance_nearest(x + hspeed_raw, y + vspeed_raw, enemy),
							_oldDir = direction;
							
						direction += orandom(15);
						if(instance_exists(_target) && point_distance(x, y, _target.x, _target.y) < 120){
							var _oldSpd = speed;
							speed = 4;
							motion_add(point_direction(x, y, _target.x, _target.y), 1);
							speed = _oldSpd;
						}
						image_angle += (direction - _oldDir);
						
						 // Lightning Trail:
						/*with(projectile_create(x, y, Lightning, point_direction(x, y, o.lastx, o.lasty), 0)){
							image_xscale = point_distance(x, y, o.lastx, o.lasty) / 2;
							image_speed *= 0.8;
							o.lastx = x;
							o.lasty = y;
							if(instance_exists(o.last)){
								image_index = o.last.image_index * 1.06;
							}
							else visible = false;
							o.last = id;
						}*/
						with(instance_create(x + orandom(1), y + orandom(1), BulletHit)){
							sprite_index = sprLightning;
							image_angle  = other.direction;
							image_speed  = max(0.4, other.speed / 12) + random(0.1);
							image_xscale = (other.speed_raw / 2) * ceil(o.time / current_time_scale);
							image_yscale = 0.2 + random(random(1));
							image_alpha  = random_range(3, 4);
							depth        = other.depth;
						}
						
						o.lastx = x;
						o.lasty = y;
					}
					
					 // End:
					else{
						proj_lightning(proj_destroy, o);
						return true;
					}
				}
			}
			else return true;
			break;
			
		case proj_destroy:
			instance_create(o.lastx, o.lasty, LightningHit);
			//sound_play(sndLightningHit);
			break;
	}
	
#define proj_plasma(_event, o)
	switch(_event){
		case proj_create:
			 // No:
			if(array_find_index([PlasmaBall, PlasmaBig, PlasmaHuge], object_index)){
				return true;
			}
			
			o.minspeed = max(0, speed - 1);
			break;
			
		case proj_step:
			if(speed > o.minspeed){
				if(friction_raw > 0 && !place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
					speed += friction_raw;
				}
				
				 // Trail:
				if(object_index != Flame && chance_ct(speed, 48)){
					instance_create(x + orandom(sprite_height / 4), y + orandom(sprite_height / 4), PlasmaTrail);
				}
			}
			else return true;
			break;
	}
	
#define proj_seeker(_event, o)
	switch(_event){
		case proj_create:
			if(object_index == Seeker) return true; // No seekers
			
			o.trail = !array_exists([Bolt, ToxicBolt, HeavyBolt, Splinter, UltraBolt], object_index);
			o.trail_clone = !array_exists([Disc, Grenade, BloodGrenade, ToxicGrenade, ClusterNade, MiniNade, HeavyNade, Rocket, Nuke, UltraGrenade, ConfettiBall], object_index);
			
			 // Disable Nuke:
			if(object_index == Nuke) index = -1;
			break;
			
		case proj_step:
			if(speed > 0){
				 // Homing:
				var	n = instance_nearest_array(x, y, instances_matching_ne(instances_matching_ne([enemy, Player, Sapling, Ally, SentryGun, CustomHitme], "team", team, 0), "mask_index", mskNone, sprVoid)),
					a = orandom(speed / 4) * current_time_scale;
					
				if(instance_exists(n) && instance_seen(x, y, n)){
					var	_ang = angle_difference(point_direction(x, y, n.x, n.y), direction),
						_turnSpeed = abs(_ang / (2 + abs(_ang / 5)));
						
					a += clamp(_ang, -_turnSpeed, _turnSpeed);
				}
				
				direction += a;
				image_angle += a;
				
				 // Trail:
				if(o.trail){
					with(instance_create(x, y, BoltTrail)){
						image_angle  = other.direction;
						image_xscale = other.speed;
						if(o.trail_clone){
							sprite_index  = other.sprite_index;
							image_index   = other.image_index;
							image_xscale /= (other.sprite_width / 2) + 1;
							image_yscale  = other.image_yscale / 2;
							image_blend   = other.image_blend;
							image_speed   = 0;
						}
						else switch(other.object_index){
							case BloodGrenade:
								image_blend = make_color_rgb(174, 58, 45);
								break;
								
							case ToxicGrenade:
							case UltraGrenade:
								image_blend = make_color_rgb(190, 253, 8);
								break;
								
							case ConfettiBall:
								image_blend = other.mycol;
								break;
						}
					}
				}
			}
			
			 // Laser Interaction:
			else if(object_index == Laser){
				var n = instance_nearest_array(x, y, instances_matching_ne(instances_matching_ne([enemy, Player, Sapling, Ally, SentryGun, CustomHitme], "team", team, 0), "mskNone", mskNone, sprVoid));
				if(instance_exists(n) && !collision_line(xstart, ystart, n.x, n.y, Wall, false, false)){
					var	_dis = 8 * current_time_scale,
						_dir = point_direction(x, y, n.x, n.y);
						
					x += lengthdir_x(_dis, _dir);
					y += lengthdir_y(_dis, _dir);
					image_angle = point_direction(xstart, ystart, x, y);
					image_xscale = point_distance(xstart, ystart, x, y) / 2;
				}
			}
			break;
	}
	
#define proj_explo(_event, o)
	switch(_event){
		case proj_create:
			 // Explo Var Setup:
			var	_type = 0,
				_time = 240 / speed;
				
			switch(object_index){
				case Bolt:
				case ToxicBolt:
				case Splinter:
				case HeavyBolt:
				case UltraBolt:
					_time *= 2;
					break;
					
				case Grenade:
				case ToxicGrenade:
				case HeavyNade:
				case UltraGrenade:
				case ClusterNade:
					_time = 0;
					break;
					
				case FlakBullet:
					_type = 1;
					break;
					
				case FlameBall:
				case Devastator:
					_type = 2;
					break;
			}
			
			if(_type <= 0){
				if(damage >= 25) _type = 2;
				else if(damage >= 10) _type = 1;
			}
			
			o.type = _type;
			o.time = _time;
			o.xplo = 0;
			o.num = 1;
			o.x = x;
			o.y = y;
			
			 // Nerf Lightning:
			if(instance_is(self, Lightning)){
				 // Color:
				image_blend = make_color_rgb(255, 80, 30);
				with(instances_matching([LightningSpawn, LightningHit], "creator", id)){
					image_blend = other.image_blend;
				}
				
				 // Nerf:
				if(ammo <= 0) o.time = 1;
				else return true;
			}
			break;
			
		case proj_step:
			var l = speed + ((object_index == Laser) ? -8 : 0);
			o.x = x + lengthdir_x(l, direction);
			o.y = y + lengthdir_y(l, direction);
			
			 // Explode:
			if(
				(typ != 0 && place_meeting(x, y, Explosion)) ||
				(image_index >= 3 && array_exists([sprBullet2Disappear, sprSlugDisappear, sprHeavySlugDisappear, sprHyperSlugDisappear, sprUltraShellDisappear], sprite_index))
			){
				o.time = current_time_scale;
			}
			if(o.time > 0){
				o.time -= current_time_scale;
				if(o.time <= 0) instance_destroy();
				
				 // Blinkin:
				else if(o.time < 15){
					var	d = pround(depth, 0.1),
						c = instances_matching(instances_matching(CustomDraw, "name", "proj_explo_draw"), "depth_mark", d);
						
					if(array_length(c)) with(c){
						if(!array_exists(inst, other)) array_push(inst, other);
					}
					else with(script_bind_draw(proj_explo_draw, d - 0.001)){
						name = script[2];
						inst = [other];
						depth_mark = d;
					}
				}
			}
			break;
			
		case proj_destroy: // Explosions
			with(o){
				var	_num    = num,
					_dis    = ((_num > 1) ? 16 : 0),
					_dirAng = random(360);
					
				for(var i = 0; i < _num; i++){
					var	_obj       = ((xplo == 1) ? GreenExplosion        : ((xplo == 2) ? MeatExplosion : Explosion)),
						_objSmall  = ((xplo == 1) ? "SmallGreenExplosion" : ((xplo == 2) ? MeatExplosion : SmallExplosion)),
						_boom      = false,
						_boomSmall = [],
						_snd       = -1,
						_pit       = 1 + orandom(0.1),
						_vol       = 3,
						_dir       = (360 * (i / _num)) + _dirAng,
						_x         = x + lengthdir_x(_dis, _dir),
						_y         = y + lengthdir_y(_dis, _dir);
						
					if(_num > 1 && type >= 1){
						array_push(
							_boomSmall,
							instance_create(x + lengthdir_x(_dis / 2, _dir), y + lengthdir_y(_dis / 2, _dir), _objSmall)
						);
					}
					
					switch(type){
						case 1:
							_snd  = sndExplosion;
							_boom = true;
							break;
							
						case 2:
							_snd  = sndExplosionL;
							_boom = true;
							
							var _ang = random(360);
							for(var _a = _ang; _a < _ang + 360; _a += (360 / 3)){
								var	_l = 4,
									_d = _a + orandom(10);
									
								array_push(_boomSmall, obj_create(_x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), _objSmall));
							}
							break;
							
						default:
							_snd = sndExplosionS;
							if(xplo == 2){
								_snd = sndBloodLauncherExplo;
								_pit = 1.4 + orandom(0.2);
								_vol = 1.5;
							}
							array_push(_boomSmall, obj_create(_x, _y, _objSmall));
							break;
					}
					
					 // Create/Set Explosion Vars:
					if(_boom){
						switch(xplo){
							case 1:
								with(instance_create(_x, _y, _obj)){
									hitid = 99;
								}
								break;
								
							case 2:
								_snd = sndBloodLauncherExplo;
								
								var	_ang = random(360),
									_l   = 24;
									
								for(var _d = _ang; _d < _ang + 360; _d += (360 / 3)){
									with(instance_create(x, y, BloodStreak)){
										image_angle = _d;
									}
									array_push(
										_boomSmall,
										instance_create(_x + lengthdir_x(_l, _d), _y + lengthdir_y(_l, _d), _obj)
									);
								}
								break;
								
							default:
								with(instance_create(_x, _y, _obj)){
									hitid = 55;
								}
						}
					}
					with(_boomSmall){
						if(hitid == -1){
							switch(other.xplo){
								case 2:
									hitid = [sprite_index, "BLOOD EXPLOSION"];
									break;
									
								default:
									hitid = 56;
							}
						}
						if(distance_to_object(PlasmaImpact) <= 0){
							with(instance_nearest(x, y, PlasmaImpact)){
								depth++;
								depth--;
							}
						}
					}
					
					 // Sound:
					with(instance_create(_x, _y, GameObject)){
						sound_play_hit_ext(_snd, _pit, _vol);
						instance_destroy();
					}
				}
			}
			break;
	}
	
#define proj_explo_draw
	if(array_length(inst)){
		with(inst){
			if(instance_exists(self)){
				 // Nade Blink:
				draw_set_fog(true, ((current_frame * 0.4) % 2) ? c_white : c_black, 0, 0);
				draw_self();
			}
			else other.inst = array_delete_value(other.inst, self);
		}
		draw_set_fog(false, 0, 0, 0);
	}
	
	 // Nothing left to draw:
	else instance_destroy();
	
#define proj_explosmall(_event, o)
	if(proj_explo(_event, o)) return true;
	if(_event == proj_create){
		//o.type = max(o.type - 1, 0);
		o.time *= random_range(0.5, 1);
	}
	
#define proj_exploheavy(_event, o)
	if(proj_explo(_event, o)){
		if(instance_is(self, Lightning)){
			image_blend = merge_color(c_black, c_lime, 0.8);
			with(instances_matching([LightningSpawn, LightningHit], "creator", id)){
				image_blend = other.image_blend;
			}
		}
		return true;
	}
	if(_event == proj_create) o.xplo = 1;
	
#define proj_exploblood(_event, o)
	if(proj_explo(_event, o)){
		if(instance_is(self, Lightning)){
			image_blend = make_color_rgb(220, 30, 0);
			with(instances_matching([LightningSpawn, LightningHit], "creator", id)){
				image_blend = other.image_blend;
			}
		}
		return true;
	}
	if(_event == proj_create) o.xplo = 2;
	
#define proj_explostick(_event, o)
	switch(_event){
		case proj_create:
			if(proj_explo(_event, o)) return true;
			o.stic_inst = noone;
			o.stic_inst_x = orandom(2);
			o.stic_inst_y = orandom(2);
			o.stic_mask = null;
			o.time *= 2;
			
		case proj_step:
			 // Try to Stick:
			if(!instance_exists(o.stic_inst)){
				if(o.stic_mask != null){
					mask_index = o.stic_mask;
					o.stic_mask = null;
				}
				
				if(speed > 0){
					var	_x = x + hspeed_raw,
						_y = y + vspeed_raw;
						
					if(place_meeting(_x, _y, Wall)){
						sound_play_hit(sndGrenadeStickWall, 0.1);
						with(instances_meeting(_x, _y, Wall)){
							o.stic_inst = id;
							break;
						}
						if(instance_exists(o.stic_inst)){
							o.stic_inst_x = (x + (hspeed / 2)) - o.stic_inst.x;
							o.stic_inst_y = (y + (vspeed / 2)) - o.stic_inst.y;
						}
					}
					
					var	_border = 16,
						_inst   = instance_rectangle_bbox(
							bbox_left   + hspeed_raw - _border,
							bbox_top    + vspeed_raw - _border,
							bbox_right  + hspeed_raw + _border,
							bbox_bottom + vspeed_raw + _border,
							instances_matching_ne(hitme, "team", team)
						);
						
					if(array_length(_inst)) with(_inst){
						if(place_meeting(x + hspeed_raw - other.hspeed_raw, y + vspeed_raw - other.vspeed_raw, other)){
							if(my_health > 1) with(other){
								var f = force / 3;
								if(instance_is(other, prop) || other.team == 0) f = 0;
								projectile_hit(other, min(damage, other.my_health - 1), f, direction);
							}
							sound_play_hit(sndGrenadeStickWall, 0.1);
							o.stic_inst = id;
							break;
						}
					}
				}
			}
			
			 // Sticking on Dude:
			if(instance_exists(o.stic_inst)){
				if(o.stic_mask == null && object_index != Disc){
					o.stic_mask = mask_index;
					mask_index = mskNone;
				}
				
				x += ((o.stic_inst.x + o.stic_inst_x) - x) * 0.5 * current_time_scale;
				y += ((o.stic_inst.y + o.stic_inst_y) - y) * 0.5 * current_time_scale;
				
				speed += friction_raw;
				x -= hspeed_raw;
				y -= vspeed_raw;
				
				depth = o.stic_inst.depth - 1;
			}
			
			 // Normal Step:
			if(o.stic_mask != null) mask_index = o.stic_mask;
			if(proj_explo(_event, o)) return true;
			if(o.stic_mask != null && instance_exists(self)) mask_index = mskNone;
			break;
			
		case proj_destroy:
			o.num = 3;
			proj_explo(_event, o);
	}
	
#define proj_suck(_event, o)
	switch(_event){
		case proj_create:
			 // Delay:
			o.delay = 8 - (speed / 4);
			if(speed <= 0) o.delay = 1;
			
			 // Nerf Lightning:
			if(instance_is(self, Lightning) && ammo > 1){
				return true;
			}
			break;
			
		case proj_step:
			if(o.delay > 0){
				o.delay -= current_time_scale;
				if(o.delay <= 0) sound_play_hit(sndUltraGrenadeSuck, 0.1);
			}
			else{
				 // Suckin Nearby Enemies:
				var r = 96;
				with(instance_rectangle(x - r, y - r, x + r, y + r, instances_matching_ne([Player, Sapling, Ally, enemy, CustomHitme], "team", 0))){
					if(point_distance(x, y, other.x, other.y) < r){
						var	l = (instance_is(other, Laser) ? 2 : 1),
							d = point_direction(x, y, other.x, other.y),
							_x = x + lengthdir_x(l, d),
							_y = y + lengthdir_y(l, d);
							
						if(!place_meeting(_x, y, Wall)) x = _x;
						if(!place_meeting(x, _y, Wall)) y = _y;
					}
				}
				
				 // FX:
				if(chance_ct(1, 2)){
					var	l = random(r / 2),
						d = random(360);
						
					with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), EatRad)){
						hspeed = other.hspeed / 2;
						vspeed = other.vspeed / 2;
						motion_add(d + 180, random(4));
						image_speed *= random_range(0.5, 1);
						if(chance(1, 4)) sprite_index = sprEatBigRad;
					}
				}
			}
			break;
	}
	
#define proj_wallbreak(_event, o)
	switch(_event){
		case proj_create:
			o.walls = ceil(damage / 12);
			break;
			
		case proj_step:
			if(place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
				 // Sort Walls by Distance:
				var _wall = [];
				with(instances_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
					array_push(_wall, [id, point_distance(x + 8, y + 8, other.x, other.y)]);
				}
				array_sort_sub(_wall, 1, true);
				
				 // Break Walls:
				with(_wall){
					with(self[0]){
						instance_create(x, y, FloorExplo);
						instance_destroy();
					}
					
					 // Slow:
					other.speed -= min(other.speed, 1);
					
					 // End:
					if(--o.walls <= 0) return true;
				}
			}
			break;
	}
	
#define proj_rocket(_event, o)
	switch(_event){
		case proj_create:
			 // No:
			if(speed <= 0 || object_index == Rocket){
				return true;
			}
			
			 // Just in Case:
			speed = max(speed, friction * 10);
			
			 // Vars:
			o.sped = 0;
			o.goal = ((friction > 0) ? 12 : min(speed * 2, 12));
			o.delay = ((friction >= 0.4) ? floor((speed - 6) / friction) : (8 - (speed / 4)));
			
			 // Nuke:
			if(object_index == Nuke) index = -1;
			
			 // Don't Use Normal Speed Increase:
			if(array_exists([PlasmaBall, PlasmaBig, PlasmaHuge], object_index)){
				o.sped = -1;
				o.goal = 8;
			}
			
			 // Flame Trail:
			if(object_index != Nuke && object_index != Flame){
				if(array_length(instances_matching(CustomDraw, "name", "proj_rocket_trail")) <= 0){
					with(script_bind_draw(proj_rocket_trail, -0.1)){
						name = script[2];
						inst = [];
					}
				}
				with(instances_matching(CustomDraw, "name", "proj_rocket_trail")){
					array_push(inst, other);
				}
			}
			break;
			
		case proj_step:
			if(o.delay > 0) o.delay -= current_time_scale;
			else{
				 // Acceleration:
				speed += friction_raw;
				if(o.sped < 0){
					speed = min(speed + (0.5 * current_time_scale), o.goal);
				}
				else{
					if(o.sped < o.goal){
						o.sped += 0.5 * current_time_scale;
					}
					x += lengthdir_x(o.sped, direction);
					y += lengthdir_y(o.sped, direction);
				}
				
				 // Stop on Collision:
				if(place_meeting(x + hspeed, y + vspeed, Wall) || place_meeting(x + hspeed, y + vspeed, instance_nearest_array(x + hspeed, y + vspeed, instances_matching_ne(hitme, "team", team)))){
					return true;
				}
			}
			break;
	}
	
#define proj_rocket_trail
	if(array_length(inst)) with(inst){
		if(instance_exists(self)){
			var	_spr = ((sprite_get_height(sprite_index) > 16) ? sprNukeFlame : sprRocketFlame),
				_img = ((current_frame + id) * 0.4),
				_xsc = image_xscale * (speed / 12),
				_ysc = image_yscale * min(speed / 6, 1),
				_ang = direction,
				_col = image_blend,
				_alp = image_alpha,
				_off = ((sprite_index == sprSplinter) ? -8 : max((sprite_get_width(sprite_index) - 16) / 4, 0)) * image_xscale,
				_x = x - lengthdir_x(_off, _ang),
				_y = y - lengthdir_y(_off, _ang);
				
			draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
			
			 // Bloom:
			if(instance_exists(SubTopCont)){
				draw_set_blend_mode(bm_add);
				draw_sprite_ext(_spr, _img, _x, _y, 2 * _xsc, 2 * _ysc, _ang, _col, 0.1 * _alp);
				draw_set_blend_mode(bm_normal);
			}
			
			 // Smoke:
			if(speed > 0 && chance_ct(1, 200 / ((2 * (speed + damage)) + 1))){
				with(instance_create(_x - (2 * hspeed), _y - (2 * vspeed), Smoke)){
					depth = max(depth, other.depth - 0.05);
					image_xscale *= other.image_xscale;
					image_yscale *= other.image_xscale;
				}
			}
		}
		else other.inst = array_delete_value(other.inst, self);
	}
	
	 // Nothing left to draw:
	else instance_destroy();
	
#define proj_nuke(_event, o)
	switch(_event){
		case proj_create:
			 // Just in Case:
			speed = max(speed, friction * 10);
			
			 // Vars:
			o.delay = ((friction >= 0.4) ? floor((speed - 6) / friction) : (8 - (speed / 4)));
			o.index = variable_instance_get(creator, "index", -1);
			if(object_index == Laser) o.delay = 0;
			
			 // Flame Trail:
			if(object_index != Rocket && object_index != Flame){
				if(array_length(instances_matching(CustomDraw, "name", "proj_rocket_trail")) <= 0){
					with(script_bind_draw(proj_rocket_trail, -0.1)){
						name = script[2];
						inst = [];
					}
				}
				with(instances_matching(CustomDraw, "name", "proj_rocket_trail")){
					array_push(inst, other);
				}
			}
			break;
			
		case proj_step:
			if(o.delay > 0) o.delay -= current_time_scale;
			else{
				if(speed > 0){
					 // Follow Mouse:
					if(player_is_active(o.index)){
						var	_diff = angle_difference(point_direction(x, y, mouse_x[o.index], mouse_y[o.index]), direction),
							_turn = (_diff / 12) * power(abs(dsin(_diff)), 1) * current_time_scale;
							
						direction += _turn;
						image_angle += _turn;
						x -= hspeed_raw * power(abs(dsin(_diff / 4)), 24 / speed);
						y -= vspeed_raw * power(abs(dsin(_diff / 4)), 24 / speed);
					}
					speed += friction_raw;
				}
				
				 // Laser Interaction:
				else if(object_index == Laser && "gunangle" in creator){
					 // Follow Creator:
					xstart += ((creator.x - xstart) / 3) * current_time_scale;
					ystart += ((creator.y - ystart) / 3) * current_time_scale;
					
					 // Turn:
					var _turnSpeed = 4 * current_time_scale;
					image_angle += clamp(angle_difference(creator.gunangle, image_angle), -_turnSpeed, _turnSpeed);
					x = xstart + lengthdir_x(image_xscale * 2, image_angle);
					y = ystart + lengthdir_y(image_xscale * 2, image_angle);
					
					 // Crappy Wall Collision:
					var l = 12;
					if(collision_line(xstart, ystart, x - lengthdir_x(l, image_angle), y - lengthdir_y(l, image_angle), Wall, false, false)){
						var _dis = 32;
						x -= lengthdir_x(_dis, image_angle);
						y -= lengthdir_y(_dis, image_angle);
						image_xscale = point_distance(x, y, xstart, ystart) / 2;
					}
				}
			}
			break;
	}
	
#define proj_flare(_event, o)
	switch(_event){
		case proj_step:
			switch(object_index){
				case Laser:
					var d = image_angle + 180;
					for(var l = 0; l < (image_xscale * 2); l += 8){
						if(chance_ct(1, max(l / 16, 4))){
							projectile_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Flame, image_angle + orandom(20), random(3));
						}
					}
					break;
					
				case Lightning:
					if(chance_ct(1, 5)){
						projectile_create(x, y, Flame, image_angle + orandom(10), random(3));
					}
					break;
					
				default:
					if(current_frame % damage >= 1){
						var d = direction;
						for(var l = 0; l < speed_raw; l += 8){
							with(projectile_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), Flame, random(360), 1)){
								 // Dissipate Faster:
								image_index = max(0, (image_number - 1) - (1 + other.damage));
								
								 // Scale Up:
								var h = other.sprite_height;
								if(instance_is(other, Devastator)) h *= 1.5;
								image_xscale *= (h / 16);
								if(h >= 6) image_xscale = max(1, image_xscale);
								image_yscale = image_xscale;
							}
						}
					}
			}
			break;
	}
	
#define proj_flame(_event, o)
	switch(_event){
		case proj_create:
			var d = damage;
			switch(object_index){
				case FlakBullet:
				case Devastator:
					d += 20;
					break;
					
				case Laser:
				case PlasmaBall:
				case PlasmaBig:
				case PlasmaHuge:
					d *= 2;
					break;
			}
			
			o.amnt = ceil(d / 2);
			o.team = team;
			o.x = x;
			o.y = y;
			o.hspeed = hspeed;
			o.vspeed = vspeed;
			
			 // Nerf Lightning:
			if(instance_is(self, Lightning)){
				 // Color:
				sprite_index = sprEnemyLightning;
				image_blend = merge_color(c_yellow, c_gray, random(0.2));
				with(instances_matching([LightningSpawn, LightningHit], "creator", id)){
					image_blend = make_color_rgb(255, 60, 20);
				}
				
				 // Nerf:
				if(ammo <= 0) proj_flame(proj_destroy, o);
				return true;
			}
			break;
			
		case proj_step:
			var l = ((object_index == Laser) ? -12 : 4);
			o.x = x + lengthdir_x(l, direction);
			o.y = y + lengthdir_y(l, direction);
			o.hspeed = hspeed;
			o.vspeed = vspeed;
			o.team = team;
			
			 // Shell Early Release:
			if(image_index >= 3 && array_exists([sprBullet2Disappear, sprSlugDisappear, sprHeavySlugDisappear, sprHyperSlugDisappear, sprUltraShellDisappear], sprite_index)){
				proj_flame(proj_destroy, o);
				return true;
			}
			break;
			
		case proj_destroy:
			if(o.amnt > 0){
				 // Flame:
				repeat(o.amnt){
					var	_dir = random(360),
						_spd = 0;
						
					if(o.amnt > 3){
						_spd = 2 + random((o.amnt * 0.2) / max(1, o.amnt / 20));
					}
					
					with(projectile_create(o.x + orandom(4), o.y + orandom(4), Flame, _dir, _spd)){
						team = o.team;
						hspeed += o.hspeed / 6;
						vspeed += o.vspeed / 6;
						if(distance_to_object(Explosion) <= 0){
							speed += random(4);
						}
					}
				}
				
				 // Smoke:
				repeat(o.amnt / 2){
					with(instance_create(o.x, o.y, Smoke)){
						motion_add(random(360), random(sqrt(o.amnt)));
					}
				}
				
				 // Sound:
				if(o.amnt > 3){
					with(instance_create(o.x, o.y, GameObject)){
						sound_play_hit(sndFlareExplode, 0.4);
						instance_destroy();
					}
				}
			}
			break;
	}
	
#define proj_toxic(_event, o)
	switch(_event){
		case proj_create:
			var d = damage;
			switch(object_index){
				case FlakBullet:
				case Devastator:
					d += 20;
					break;
					
				case Laser:
				case PlasmaBall:
				case PlasmaBig:
				case PlasmaHuge:
					d *= 2;
					break;
			}
			
			o.amnt = ((d > 20) ? d : max(1, round(d * 2/3)));
			o.x = x;
			o.y = y;
			
			if(instance_is(self, Lightning)){
				image_blend = merge_color(c_lime, c_white, random(0.2));
				if(chance(1, 3)){
					with(instance_create(x + orandom(12), y + orandom(12), FireFly)){
						image_blend = merge_color(c_lime, c_green, random(1));
						image_speed *= random_range(0.5, 1.5);
					}
				}
				if(ammo <= 0) proj_toxic(proj_destroy, o);
				return true;
			}
			break;
			
		case proj_step:
			var l = ((object_index == Laser) ? -12 : 0);
			if(!place_meeting(x + hspeed_raw, y + vspeed_raw, Wall)){
				l += speed;
			}
			o.x = x + lengthdir_x(l, direction);
			o.y = y + lengthdir_y(l, direction);
			
			 // Shell Early Release:
			if(image_index >= 3 && array_exists([sprBullet2Disappear, sprSlugDisappear, sprHeavySlugDisappear, sprHyperSlugDisappear, sprUltraShellDisappear], sprite_index)){
				proj_toxic(proj_destroy, o);
				return true;
			}
			break;
			
		case proj_destroy:
			with(o) if(amnt > 0){
				 // Gas:
				repeat(amnt) instance_create(x, y, ToxicGas);
				
				 // Smoke:
				repeat(amnt / 3){
					with(instance_create(x, y, Smoke)){
						motion_add(random(360), random(sqrt(other.amnt) / 2));
					}
				}
				
				 // Sound:
				with(instance_create(x, y, GameObject)){
					sound_play_hit(sndToxicBoltGas, 0.1);
					instance_destroy();
				}
			}
			break;
	}
	
#define proj_cluster(_event, o)
	switch(_event){
		case proj_create:
			var d = damage;
			switch(object_index){
				case FlakBullet:
				case Devastator:
					d += 20;
					break;
					
				case PlasmaBall:
				case PlasmaBig:
				case PlasmaHuge:
					d *= 2;
					break;
			}
			
			o.amnt = ceil(d / 3) + (crown_current == crwn_death);
			o.team = team;
			o.x = x;
			o.y = y;
			o.hspeed = hspeed;
			o.vspeed = vspeed;
			
			 // Nerf Lightning:
			if(instance_is(self, Lightning) && ammo > 0){
				return true;
			}
			break;
			
		case proj_step:
			var l = ((object_index == Laser) ? -8 : 0);
			o.x = x + lengthdir_x(l, direction);
			o.y = y + lengthdir_y(l, direction);
			o.hspeed = hspeed;
			o.vspeed = vspeed;
			o.team = team;
			
			 // Shell Early Release:
			if(image_index >= 3 && array_exists([sprBullet2Disappear, sprSlugDisappear, sprHeavySlugDisappear, sprHyperSlugDisappear, sprUltraShellDisappear], sprite_index)){
				proj_cluster(proj_destroy, o);
				return true;
			}
			break;
			
		case proj_destroy:
			 // Nades:
			repeat(o.amnt){
				var	_dir = random(360),
					_spd = 2 + random(min(8, o.amnt / 2));
					
				with(projectile_create(o.x, o.y, MiniNade, _dir, _spd)){
					team = o.team;
					hspeed += o.hspeed / 2;
					vspeed += o.vspeed / 2;
					depth = -1.5;
					x += hspeed;
					y += vspeed;
					
					 // Open FX:
					sound_play_hit(sndClusterOpen, 0.2);
					with(instance_create(x, y, Smoke)){
						motion_add(direction, random(2));
						depth = other.depth - 1;
						growspeed /= 2;
					}
				}
			}
			break;
	}
	
#define proj_hyper(_event, o)
	switch(_event){
		case proj_step:
			if(speed <= 0) return true;
			if(can_hyper(x + hspeed, y + vspeed)){
				var	_tries = 100,
					_lastx = x,
					_lasty = y;
					
				while(_tries-- > 0 && speed > min(friction * 12, 8)){
					 // Step:
					event_perform(ev_step, ev_step_begin);
					if(!instance_exists(self)) break;
					event_perform(ev_step, ev_step_normal);
					if(!instance_exists(self)) break;
					
					 // Telekinesis:
					if(instance_is(self, projectile) || instance_is(self, enemy)){
						with(instances_matching_ne(instances_matching(Player, "race", "eyes"), "team", team)){
							if(canspec && button_check(index, "spec")){
								if(point_seen(other.x, other.y, index)){
									with(other){
										var	_dis = 1 + skill_get(mut_throne_butt),
											_dir = point_direction(other.x, other.y, x, y);
											
										if(instance_is(self, enemy)) _dir += 180;
										
										var	_x = x + lengthdir_x(_dis, _dir),
											_y = y + lengthdir_y(_dis, _dir);
											
										if(place_free(_x, y)) x = _x;
										if(place_free(x, _y)) y = _y;
									}
								}
							}
						}
					}
					
					 // Animate:
					image_index += image_speed;
					if(image_index >= image_number){
						event_perform(ev_other, ev_animation_end);
						if(!instance_exists(self)) break;
					}
					
					 // Alarms:
					for(var i = 0; i < 12; i++){
						var v = alarm_get(i);
						if(v > 0){
							alarm_set(i, --v);
							if(v <= 0){
								alarm_set(i, -1);
								event_perform(ev_alarm, i);
								if(!instance_exists(self)) break;
							}
						}
					}
					if(!instance_exists(self)) break;
					
					 // Movement:
					x += hspeed;
					y += vspeed;
					speed -= clamp(speed, -friction, friction);
					_lastx = x;
					_lasty = y;
					
					 // Collisions & Stuff:
					if(!can_hyper(x, y)) break;
					
					 // End Step:
					event_perform(ev_step, ev_step_end);
					if(!instance_exists(self)) break;
					
					xprevious = x;
					yprevious = y;
					
					 // Trail:
					if(chance_ct(1, (10 / speed) + 2)){
						with(instance_create(x, y, Smoke)){
							motion_add(other.direction, 1);
						}
					}
				}
				
				if(instance_exists(self)){
					x = xprevious;
					y = yprevious;
				}
			}
			break;
	}
	
#define can_hyper(_x, _y)
	 // Not in Level:
	if(place_meeting(_x, _y, Wall) || place_meeting(_x, _y, TopSmall)){
		return false;
	}
	
	 // Potential Hit:
	if(place_meeting(x, y, hitme)){
		if(array_length(instances_matching_gt(instances_meeting(_x, _y, instances_matching_ne(hitme, "team", team)), "my_health", 0)) > 0){
			return false;
		}
	}
	
	 // Potential Deflection:
	if(place_meeting(_x, _y, projectile) || place_meeting(_x, _y, CrystalShield) || place_meeting(_x, _y, PopoShield)){
		 // General Melee:
		var _slash = [Slash, GuitarSlash, EnergySlash, EnergyHammerSlash, BloodSlash, LightningSlash, CustomSlash, Shank, EnergyShank, HorrorBullet, PopoExplosion, MeatExplosion];
		if(array_length(instances_matching_ne(instances_meeting(x, y, _slash), "object_index", object_index)) > 0){
			return false;
		}
		
		 // Shields:
		var _shield = [CrystalShield, PopoShield];
		if(array_length(instances_meeting(_x, _y, _shield)) > 0){
			return false;
		}
	}
	
	return true;
	
#define lightning_grow(_seeker, _nuke, _disc, _bouncer, _laser)
	ammo--;
	
	 // Home Towards Nearest Enemy:
	var	l = 80,
		d = direction,
		_target = instance_nearest(x + lengthdir_x(l, d), y + lengthdir_y(l, d), enemy),
		_lx = x,
		_ly = y;
		
	speed = 4;
	direction = image_angle + orandom(15);
	
	if(instance_exists(_target) && point_distance(x, y, _target.x, _target.y) < 120){
		motion_add(point_direction(x, y, _target.x, _target.y), 1);
	}
	if(_seeker && instance_seen(x, y, _target)){
		motion_add(point_direction(x, y, _target.x, _target.y), 1);
	}
	if(_nuke){
		motion_add(point_direction(x, y, mouse_x[creator.index], mouse_y[creator.index]), 1);
	}
	if(_laser){
		direction += angle_difference(image_angle, direction) * 3/4;
		if(chance(1, 10)){
			with(instance_create(x + orandom(12), y + orandom(12), PlasmaTrail)){
				motion_add(other.direction, 1);
				motion_add(random(360), 1);
			}
		}
	}
	
	image_angle = direction;
	speed = 0;
	
	 // Stretch:
	var	_move = 8 + random(4),
		d = direction;
		
	while(_move > 0){
		var	l = min(_move, 4),
			_x = x + lengthdir_x(l, d),
			_y = y + lengthdir_y(l, d);
			
		if(!place_meeting(_x, _y, Wall)){
			x = _x;
			y = _y;
			_move -= l;
		}
		else break;
	}
	image_xscale = -point_distance(x, y, _lx, _ly) / 2;
	
	 // Bounce:
	if(place_meeting(x, y, Wall)){
		x = _lx;
		y = _ly;
		direction += 180;
		if(_disc){
			sound_play_hit(sndDiscBounce, 0.3);
			with(instance_create(x, y, DiscBounce)){
				image_angle = other.direction;
			}
		}
		if(_bouncer){
			sound_play(sndBouncerBounce);
			instance_create(x, y, Dust);
		}
	}
	
	 // Disc:
	if(_disc && distance_to_object(creator) > 16){
		team = -1;
		hitid = [sprLightningHit, "LIGHTNING"];
	}
	
	 // Grow:
	var _inst = [id];
	if(ammo > 0){
		image_index += 0.4 / ammo;
		with(instance_copy(false)){
			image_xscale = 1;
			image_angle = direction;
			_inst = array_combine(_inst, lightning_grow(_seeker, _nuke, _disc, _bouncer, _laser));
		}
	}
	
	 // End:
	else{
		var	l = image_xscale / 2,
			d = image_angle;
			
		with(instance_create(x + lengthdir_x(l, d), y + lengthdir_y(l, d), LightningHit)){
			creator = other;
		}
	}
	
	return _inst;
	
#define object_is_melee(_obj)
	return ((string_pos("Slash", object_get_name(_obj)) >= 1) ? 1 : ((string_pos("Shank", object_get_name(_obj)) >= 1) ? 2 : 0));
	
	
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
#macro  current_frame_active                                                                    (current_frame % 1) < current_time_scale
#macro  anim_end                                                                                (image_index + image_speed_raw >= image_number || image_index + image_speed_raw < 0)
#macro  enemy_sprite                                                                            (sprite_index != spr_hurt || anim_end) ? ((speed <= 0) ? spr_idle : spr_walk) : sprite_index
#macro  enemy_boss                                                                              (('boss' in self) ? boss : ('intro' in self)) || array_exists([Nothing, Nothing2, BigFish, OasisBoss], object_index)
#macro  player_active                                                                           visible && !instance_exists(GenCont) && !instance_exists(LevCont) && !instance_exists(SitDown) && !instance_exists(PlayerSit)
#macro  game_scale_nonsync                                                                      game_screen_get_width_nonsync() / game_width
#macro  bbox_width                                                                              (bbox_right + 1) - bbox_left
#macro  bbox_height                                                                             (bbox_bottom + 1) - bbox_top
#macro  bbox_center_x                                                                           (bbox_left + bbox_right + 1) / 2
#macro  bbox_center_y                                                                           (bbox_top + bbox_bottom + 1) / 2
#macro  FloorNormal                                                                             instances_matching(Floor, 'object_index', Floor)
#macro  alarm0_run                                                                              alarm0 >= 0 && --alarm0 == 0 && (script_ref_call(on_alrm0) || !instance_exists(self))
#macro  alarm1_run                                                                              alarm1 >= 0 && --alarm1 == 0 && (script_ref_call(on_alrm1) || !instance_exists(self))
#macro  alarm2_run                                                                              alarm2 >= 0 && --alarm2 == 0 && (script_ref_call(on_alrm2) || !instance_exists(self))
#macro  alarm3_run                                                                              alarm3 >= 0 && --alarm3 == 0 && (script_ref_call(on_alrm3) || !instance_exists(self))
#macro  alarm4_run                                                                              alarm4 >= 0 && --alarm4 == 0 && (script_ref_call(on_alrm4) || !instance_exists(self))
#macro  alarm5_run                                                                              alarm5 >= 0 && --alarm5 == 0 && (script_ref_call(on_alrm5) || !instance_exists(self))
#macro  alarm6_run                                                                              alarm6 >= 0 && --alarm6 == 0 && (script_ref_call(on_alrm6) || !instance_exists(self))
#macro  alarm7_run                                                                              alarm7 >= 0 && --alarm7 == 0 && (script_ref_call(on_alrm7) || !instance_exists(self))
#macro  alarm8_run                                                                              alarm8 >= 0 && --alarm8 == 0 && (script_ref_call(on_alrm8) || !instance_exists(self))
#macro  alarm9_run                                                                              alarm9 >= 0 && --alarm9 == 0 && (script_ref_call(on_alrm9) || !instance_exists(self))
#define orandom(_num)                                                                   return  random_range(-_num, _num);
#define chance(_numer, _denom)                                                          return  random(_denom) < _numer;
#define chance_ct(_numer, _denom)                                                       return  random(_denom) < (_numer * current_time_scale);
#define pround(_num, _precision)                                                        return  (_num == 0) ? _num : round(_num / _precision) * _precision;
#define pfloor(_num, _precision)                                                        return  (_num == 0) ? _num : floor(_num / _precision) * _precision;
#define pceil(_num, _precision)                                                         return  (_num == 0) ? _num :  ceil(_num / _precision) * _precision;
#define in_range(_num, _lower, _upper)                                                  return  (_num >= _lower && _num <= _upper);
#define frame_active(_interval)                                                         return  (current_frame % _interval) < current_time_scale;
#define angle_lerp(_ang1, _ang2, _num)                                                  return  _ang1 + (angle_difference(_ang2, _ang1) * _num);
#define draw_self_enemy()                                                                       image_xscale *= right; draw_self(); image_xscale /= right;
#define enemy_walk(_add, _max)                                                                  if(walk > 0){ walk -= current_time_scale; motion_add_ct(direction, _add); } if(speed > _max) speed = _max;
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
#define script_bind(_name, _scriptObj, _scriptRef, _depth, _visible)                    return  mod_script_call_nc  ('mod', 'teassets', 'script_bind', _name, _scriptObj, _scriptRef, _depth, _visible);
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
#define instance_seen(_x, _y, _obj)                                                     return  mod_script_call_nc  ('mod', 'telib', 'instance_seen', _x, _y, _obj);
#define instance_near(_x, _y, _obj, _dis)                                               return  mod_script_call_nc  ('mod', 'telib', 'instance_near', _x, _y, _obj, _dis);
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
#define draw_weapon(_sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha)            mod_script_call_nc  ('mod', 'telib', 'draw_weapon', _sprite, _x, _y, _ang, _meleeAng, _wkick, _flip, _blend, _alpha);
#define draw_lasersight(_x, _y, _dir, _maxDistance, _width)                             return  mod_script_call_nc  ('mod', 'telib', 'draw_lasersight', _x, _y, _dir, _maxDistance, _width);
#define draw_surface_scale(_surf, _x, _y, _scale)                                               mod_script_call_nc  ('mod', 'telib', 'draw_surface_scale', _surf, _x, _y, _scale);
#define array_exists(_array, _value)                                                    return  mod_script_call_nc  ('mod', 'telib', 'array_exists', _array, _value);
#define array_count(_array, _value)                                                     return  mod_script_call_nc  ('mod', 'telib', 'array_count', _array, _value);
#define array_combine(_array1, _array2)                                                 return  mod_script_call_nc  ('mod', 'telib', 'array_combine', _array1, _array2);
#define array_delete(_array, _index)                                                    return  mod_script_call_nc  ('mod', 'telib', 'array_delete', _array, _index);
#define array_delete_value(_array, _value)                                              return  mod_script_call_nc  ('mod', 'telib', 'array_delete_value', _array, _value);
#define array_flip(_array)                                                              return  mod_script_call_nc  ('mod', 'telib', 'array_flip', _array);
#define array_shuffle(_array)                                                           return  mod_script_call_nc  ('mod', 'telib', 'array_shuffle', _array);
#define data_clone(_value, _depth)                                                      return  mod_script_call_nc  ('mod', 'telib', 'data_clone', _value, _depth);
#define scrFX(_x, _y, _motion, _obj)                                                    return  mod_script_call_nc  ('mod', 'telib', 'scrFX', _x, _y, _motion, _obj);
#define scrRight(_dir)                                                                          mod_script_call_self('mod', 'telib', 'scrRight', _dir);
#define scrWalk(_dir, _walk)                                                                    mod_script_call_self('mod', 'telib', 'scrWalk', _dir, _walk);
#define scrAim(_dir)                                                                            mod_script_call_self('mod', 'telib', 'scrAim', _dir);
#define enemy_hurt(_hitdmg, _hitvel, _hitdir)                                                   mod_script_call_self('mod', 'telib', 'enemy_hurt', _hitdmg, _hitvel, _hitdir);
#define enemy_target(_x, _y)                                                            return  mod_script_call_self('mod', 'telib', 'enemy_target', _x, _y);
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
#define area_border(_y, _area, _color)                                                  return  mod_script_call_nc  ('mod', 'telib', 'area_border', _y, _area, _color);
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
#define player_create(_x, _y, _index)                                                   return  mod_script_call_nc  ('mod', 'telib', 'player_create', _x, _y, _index);
#define player_swap()                                                                   return  mod_script_call_self('mod', 'telib', 'player_swap');
#define wep_raw(_wep)                                                                   return  mod_script_call_nc  ('mod', 'telib', 'wep_raw', _wep);
#define wep_merge(_stock, _front)                                                       return  mod_script_call_nc  ('mod', 'telib', 'wep_merge', _stock, _front);
#define wep_merge_decide(_hardMin, _hardMax)                                            return  mod_script_call_nc  ('mod', 'telib', 'wep_merge_decide', _hardMin, _hardMax);
#define weapon_decide(_hardMin, _hardMax, _gold, _noWep)                                return  mod_script_call_self('mod', 'telib', 'weapon_decide', _hardMin, _hardMax, _gold, _noWep);
#define weapon_get_red(_wep)                                                            return  mod_script_call_self('mod', 'telib', 'weapon_get_red', _wep);
#define skill_get_icon(_skill)                                                          return  mod_script_call_self('mod', 'telib', 'skill_get_icon', _skill);
#define skill_get_avail(_skill)                                                         return  mod_script_call_self('mod', 'telib', 'skill_get_avail', _skill);
#define string_delete_nt(_string)                                                       return  mod_script_call_nc  ('mod', 'telib', 'string_delete_nt', _string);
#define path_create(_xstart, _ystart, _xtarget, _ytarget, _wall)                        return  mod_script_call_nc  ('mod', 'telib', 'path_create', _xstart, _ystart, _xtarget, _ytarget, _wall);
#define path_shrink(_path, _wall, _skipMax)                                             return  mod_script_call_nc  ('mod', 'telib', 'path_shrink', _path, _wall, _skipMax);
#define path_reaches(_path, _xtarget, _ytarget, _wall)                                  return  mod_script_call_nc  ('mod', 'telib', 'path_reaches', _path, _xtarget, _ytarget, _wall);
#define path_direction(_path, _x, _y, _wall)                                            return  mod_script_call_nc  ('mod', 'telib', 'path_direction', _path, _x, _y, _wall);
#define path_draw(_path)                                                                return  mod_script_call_self('mod', 'telib', 'path_draw', _path);
#define portal_poof()                                                                   return  mod_script_call_nc  ('mod', 'telib', 'portal_poof');
#define portal_pickups()                                                                return  mod_script_call_nc  ('mod', 'telib', 'portal_pickups');
#define pet_spawn(_x, _y, _name)                                                        return  mod_script_call_nc  ('mod', 'telib', 'pet_spawn', _x, _y, _name);
#define pet_get_icon(_modType, _modName, _name)                                         return  mod_script_call_self('mod', 'telib', 'pet_get_icon', _modType, _modName, _name);
#define team_get_sprite(_team, _sprite)                                                 return  mod_script_call_nc  ('mod', 'telib', 'team_get_sprite', _team, _sprite);
#define team_instance_sprite(_team, _inst)                                              return  mod_script_call_nc  ('mod', 'telib', 'team_instance_sprite', _team, _inst);
#define sprite_get_team(_sprite)                                                        return  mod_script_call_nc  ('mod', 'telib', 'sprite_get_team', _sprite);
#define lightning_connect(_x1, _y1, _x2, _y2, _arc, _enemy)                             return  mod_script_call_self('mod', 'telib', 'lightning_connect', _x1, _y1, _x2, _y2, _arc, _enemy);
#define charm_instance(_inst, _charm)                                                   return  mod_script_call_nc  ('mod', 'telib', 'charm_instance', _inst, _charm);
#define motion_step(_mult)                                                              return  mod_script_call_self('mod', 'telib', 'motion_step', _mult);
#define pool(_pool)                                                                     return  mod_script_call_nc  ('mod', 'telib', 'pool', _pool);