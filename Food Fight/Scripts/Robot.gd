extends "res://Scripts/Character.gd"

signal remove_enemy

func _ready():
	$RobotArmature/AnimationPlayer.get_animation("Robot_Running").set_loop(true)
	$PositionAnimation.play("Movement")
	character_type = CHARACTER_TYPES.npc
	var gamestate = get_parent().get_parent()
	connect("remove_enemy", gamestate, "remove_enemy")
	


func _physics_process(delta):
	if $RayCast.is_colliding() and can_fire:
		fire()
		can_fire = false
		$CanFire.start() 
		
		
func hurt(hurtby):
	print(lives)
	var idx = lives - 1
	if lives < 2:
		emit_signal("remove_enemy")
		print("remove_enemy signal emittred")
		var life = $Lives.get_child(idx).get_child(0)
		life.play("Lose_Life")
		.die()
	else:
		var life = $Lives.get_child(idx).get_child(0)
		life.play("Lose_Life")
	.hurt(hurtby)
	
	
	
	

	


	