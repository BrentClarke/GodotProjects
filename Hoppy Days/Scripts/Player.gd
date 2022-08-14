extends KinematicBody2D


const SPEED = 750
const GRAVITY = 3600
const JUMP_SPEED = -1500
const BOOST_SPEED = 2
const UP = Vector2(0,-1)
export var world_limit = 3000
var motion = Vector2()

func _ready():
	Global.Player = self

func _physics_process(delta):
	update_motion(delta)
	
func update_motion(delta):
	fall(delta)
	run()
	jump()
	move_and_slide(motion, UP)
	
func _process(delta):
	update_animation(motion)
	
func update_animation(motion):
	$AnimatedSprite.updater(motion)

	
func fall(delta):
	if is_on_floor() or is_on_ceiling():
		motion.y = 0
	else:
		# gravity * delta * delta / gravity * delta squared is acceleration
		motion.y += GRAVITY * delta
		
	
		
	if position.y > world_limit:
		Global.GameState.end_game()
		
	motion.y = clamp(motion.y, (JUMP_SPEED * BOOST_SPEED), -JUMP_SPEED)
		


func run():
	if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		motion.x = SPEED
		
	elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		motion.x = -SPEED
		
	else:
		motion.x = 0
		
	
	
func jump():
	if Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down"):
		if is_on_floor():
			motion.y = JUMP_SPEED
			$AnimatedSprite.play("jump")	
			Global.JumpSFX.play()
		else:
			pass
			
func boost():
     motion.y = JUMP_SPEED * BOOST_SPEED
func hurt():
	$AnimatedSprite.play("hurt")	
	Global.PainSFX.play()
	motion.y = JUMP_SPEED
	
