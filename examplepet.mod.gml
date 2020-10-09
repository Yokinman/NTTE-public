#define init
	 // Sprites:
	global.sprBabyIcon = sprite_add("sprites/pets/Example/sprBabyIcon.png", 1,  6,  6);
	global.sprBabyIdle = sprite_add("sprites/pets/Example/sprBabyIdle.png", 4, 12, 12);
	global.sprBabyWalk = sprite_add("sprites/pets/Example/sprBabyWalk.png", 6, 12, 12);
	global.sprBabyHurt = sprite_add("sprites/pets/Example/sprBabyHurt.png", 3, 12, 12);
	
	/*
	ADDING A PET:
		Adding a pet is simple. Just create a mod file and paste in the "pet_create(x, y, name)" script.
		Once you've created your file, just pick a name for your pet and create scripts like the examples below.
		
	SPAWNING A PET:
		Spawning a pet is also simple. All the setup required is handled by
		pet_create in telib.mod.gml (case sensitive), so just call the script with 
		the proper arguments (see this mod's step event) and you're all done!
		
	USEFUL VARIABLES:
		pet             = The pet's name. Mainly controls the event names that NTTE looks for.
		spr_idle        = The pet's idle sprite.
		spr_walk        = The pet's walk sprite.
		spr_hurt        = The pet's hurt OR dodge sprite.
		spr_dead        = The pet's death sprite, only used if the pet takes damage.
		right           = Determines if the pet is facing left(-1) or right(1).
		leader          = The current leader (Player ID).
		can_take        = Determines if a player can take the pet. Set to false when a leader exists.
		can_path        = Determines if the pet can attempt to pathfind to their leader.
		path            = An array of points leading the pet to its leader.
		path_dir        = The direction to reach the next point on the path.
		path_wall       = An array of objects that the pet pathfinds around (Default - [Wall, InvisiWall]).
		maxhealth       = The pet's max HP, set this if you want the pet to take damage.
		walk            = Time in frames that the pet can move.
		walkspeed       = Walking acceleration.
		maxspeed        = Maximum walking speed.
		light           = Determines if NTTE should draw the pet's light on dark levels.
		light_radius    = A 2 element array representing the pet's light radius. [Inner, Outer]
		push            = How much the pet gets pushed around by the player/other pets.
		stat            = A lightweight object containing the pet's stats, you can add your own to it.
		alarm0          = Time in frames until the pet's _alrm0 script will be run again.
		
	SCRIPTS:
		(any script can be left undefined to use default pet behavior)
		
		<Name>_create - Runs once when the pet is created.
			Set sprites and important variables in here.
			
		<Name>_icon - Return the pet's icon sprite here.
			Icons are used for the map, offscreen pets, revivable pets, and the stats screen.
			You can also return an array of [spr,img,xoff,yoff,xscale,yscale,angle,blend,alpha].
			
		<Name>_ttip - Return loading screen tips here.
			Return a string or an array of strings for the game to randomly pick one.
			
		<Name>_stat - Return stats screen info here.
			If the name argument equals "" then you should return a sprite or title for the stats block.
			Otherwise you can return the stat's display name or an array containing [Display Name, Display Value].
			Arguments: (Name, Value)
			
		<Name>_anim - Runs every frame. Handles animations.
			Leave this alone unless you want to change how the pet sets its sprites.
			
		<Name>_step - Runs every frame. The pet's step event.
		
		<Name>_draw - Runs every frame. The pet's draw event.
			Arguments: (sprite, image, x, y, xscale, yscale, angle, blend, alpha)
			
		<Name>_alrm0 - Runs when the alarm0 timer reaches 0.
			Handles main movement patterns and behavior.
			Arguments: (Direction to leader, Distance to leader)
			
		<Name>_hurt - Runs when the pet comes in contact with damage.
			Leave this alone unless you want to change how the pet dodges/takes damage.
			Arguments: (Damage, Knockback amount, Knockback direction)
			
		<Name>_death - Runs on pet death, only used if the pet takes damage.
		
		<Name>_cleanup - Runs when the pet is permanently deleted.
			Use to free surfaces, destroy data structures, etc.
			
	SPRITES:
		If you're worried about consistency, the effect on the first frame of the pet
		dodge sprite is achieved by adding opaque white to the sprite on a layer with
		blending set to overlay.
	*/
	
#define step
	 // Spawn Pet:
	if(!instance_exists(GenCont) && instance_exists(RadChest)){
		with(instances_matching(RadChest, "has_baby", undefined)){
			has_baby = true;
			
			 // Here he comes:
			pet_create(x, y, "Baby");
		}
	}
	
#define Baby_create
	 // Visual:
	spr_idle     = global.sprBabyIdle;
	spr_walk     = global.sprBabyWalk;
	spr_hurt     = global.sprBabyHurt;
	spr_shadow   = shd16;
	spr_shadow_y = 5;
	
	 // Vars:
	walkspeed = 0.8;
	maxspeed  = 3;
	
	 // Stat:
	if("tears" not in stat){
		stat.tears = 0;
	}
	
#define Baby_icon
	return global.sprBabyIcon;
	
#define Baby_ttip
	return [
		"JUST A BABY",
		"DON'T MAKE THEM SAD"
	];
	
#define Baby_stat(_name, _value)
	switch(_name){
		case "":
			return global.sprBabyIdle;
			
		case "tears":
			return [_name, `@(color:${make_color_rgb(30, 160, 240)})${_value}`];
	}
	
#define Baby_step
	 // He's Crying:
	if(!instance_exists(leader) && random(10) < current_time_scale){
		instance_create(x, y, Sweat);
		
		 // Special Stat:
		stat.tears++;
	}
	
#define Baby_hurt(_hitdmg, _hitvel, _hitdir)
	 // Hurt/Dodge Sprite:
	sprite_index = spr_hurt;
	image_index  = 0;
	
	 // Effects:
	instance_create(x, y, Dust);
	motion_set(_hitdir, _hitvel);
	
#define Baby_draw(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp)
	draw_sprite_ext(_spr, _img, _x, _y, _xsc, _ysc, _ang, _col, _alp);
	
#define Baby_alrm0(_leaderDir, _leaderDis)
	alarm0 = 30 + random(30);
	/*
	Remember to reset the alarm, else the script won't run again. You can also set the alarm by
	returning a value, but doing this will end the script.
	*/
	
	if(instance_exists(leader)){
		 // Follow Leader:
		if(_leaderDis > 64 || collision_line(x, y, leader.x, leader.y, Wall, false, false)){
			 // Pathfinding:
			if(path_dir != null){
				direction = path_dir;
				walk = 5 + random(5);
			}
			
			 // Toward Leader:
			else{
				direction = _leaderDir;
				walk = 20 + random(20);
				/*
				Walking is handled automatically by NTTE's systems, so all you
				need to do is set walk to a positive number and set
				direction to where you want them to go.
				*/
			}
			
			 // Return a value to set the alarm and end the script:
			scrRight(direction);
			return walk + random(10);
		}
		
		 // Affection:
		else if(random(3) < 1){
			instance_create(x, y, HealFX);
			scrRight(_leaderDir);
		}
	}
	
	 // Wander:
	else{
		direction = random(360);
		walk = 20 + random(20);
		scrRight(direction);
		
		return walk + random(10);
	}
	
#define scrRight(_dir)
	/*
		A very handy script to have. Sets the pet's "right" variable according
		to a given angle. Put this wherever the pet will change directions.
	*/
	
	_dir = (_dir + 360) mod 360;
	if(_dir < 90 || _dir > 270) right = 1;
	if(_dir > 90 && _dir < 270) right = -1;
	
#define pet_create(_x, _y, _pet)
	return mod_script_call_nc("mod", "telib", "pet_create", _x, _y, _pet, "mod", mod_current);
	