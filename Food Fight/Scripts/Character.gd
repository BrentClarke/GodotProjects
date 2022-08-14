extends KinematicBody

const PROJECTILE_SPEED = 50

enum CHARACTER_TYPES {player, npc}

var ammo_types = file_grabber.get_files("res://Scenes/Ammo/ammo_models/")

var character_type = CHARACTER_TYPES.npc


#{0:"res://Scenes/Ammo/ammo_models/Burger.tscn", 1: "res://Scenes/Ammo/ammo_models/Cookie.tscn", 2: "res://Scenes/Ammo/ammo_models/Cupcake.tscn",
#3:"res://Scenes/Ammo/ammo_models/Donut.tscn", 4:"res://Scenes/Ammo/ammo_models/Hotdog.tscn", 5:"res://Scenes/Ammo/ammo_models/Icecream.tscn", 6:"res://Scenes/Ammo/ammo_models/Milkshake.tscn",
#7:"res://Scenes/Ammo/ammo_models/Soda.tscn"}

var can_fire = true

var lives = 3

func _process(delta):
	randomize()
	
func fire():
	if can_fire:
		var bullet = load(ammo_types[randi() % ammo_types.size()]).instance()
		add_child(bullet)
		bullet.set_as_toplevel(true)
		bullet.fired_by = character_type
		bullet.global_transform = $Forward.global_transform
		var character_forward = get_global_transform().basis[2].normalized()
		bullet.set_linear_velocity(character_forward * PROJECTILE_SPEED)
		bullet.add_collision_exception_with(self)
		can_fire = false
		$CanFire.start()

func _on_CanFire_timeout():
	can_fire = true
	
func hurt(hurt_by):
	if hurt_by != character_type:
		lives -=1
		$HurtFx.play()
		
	if character_type == CHARACTER_TYPES.player:
		get_tree().call_group("GUI", "remove_life")
	check_lives()
		

func check_lives():
		if lives < 1:
			if character_type == CHARACTER_TYPES.player:
				get_tree().change_scene("res://Levels/GameOver.tscn")
			
func die():
	queue_free()