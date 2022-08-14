extends KinematicBody


var can_move = true
var motion = Vector3()
const UP = Vector3(0,1,0)
const GRAVITY = -9.8
const EPSILON = 0.000001
const p1Controls = {0:"ui_up", 1:"ui_down", 2:"ui_left", 3:"ui_right"}
const p2Controls = {0:"up_2", 1:"down_2", 2:"left_2", 3:"right_2"}

export var player_id = 1
export var speed = 17
export var Spawn_Point = Vector3(0,0,0)
var controls = {}



func _ready():
	Spawn_Point = self.get_translation()
	if player_id == 1:
		controls = p1Controls
	else:
		controls = p2Controls
	

func _physics_process(delta):
	if can_move:
		move()
		face_forward()
		animate()
		fall()
	
func move():
	
	if Input.is_action_pressed(controls[0]) and not Input.is_action_pressed(controls[1]):
		motion.z = -1
	elif Input.is_action_pressed(controls[1]) and not Input.is_action_pressed(controls[0]):
		motion.z = 1
	else:
		motion.z = 0
		
	if Input.is_action_pressed(controls[2]) and not Input.is_action_pressed(controls[3]):
		motion.x = -1
	elif Input.is_action_pressed(controls[3]) and not Input.is_action_pressed(controls[2]):
		motion.x = 1
	else:
		motion.x = 0
		
	move_and_slide(motion.normalized() * speed, UP)
	
	
func fall():
	if is_on_floor():
		motion.y = 0
	else: motion.y = GRAVITY
	
func animate():
	if motion.length() > EPSILON:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Arms Cross Walk")
	else:
		$AnimationPlayer.stop()
		
func face_forward():
	if not motion.x == 0 or not motion.z == 0:
		look_at(Vector3(-motion.x,0,-motion.z) * speed, UP)
		
func can_move(value):
	can_move = value
	
func reset():
	self.translation = Spawn_Point
	$Particles.emitting = false
	can_move(true)

func goal_scored(goal_id):
	if (goal_id == player_id):
		$Particles.emitting = true
		

