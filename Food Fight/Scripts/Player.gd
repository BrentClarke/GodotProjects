extends "res://Scripts/Character.gd"




#Movement Variables
var vel = Vector3()
var dir = Vector3()
var facing_direction = 0

const UP = Vector3(0,1,0)
const MAX_SPEED = 20
const ACCEL = 5
const DECEL = 13
const JUMP_SPEED = 15
const GRAVITY = -45

signal apply_customization
#Ammo Variables

export var max_ammo = 5
var ammo = 5
var in_refill_area = false
var can_refill = false
var is_throwing = false
var time
#Animation Constants

var frame = 0
const BLEND_MINIMUM = 1
const RUN_BLEND_AMOUNT = .4
const IDLE_BLEND_AMOUNT = .5
const RELOAD_BLEND_AMOUNT = .4
const THROW_BLEND_AMOUNT = .5
const ACTION_RESET_RATE = .25

onready var anim_tree = $PlayerArmature/AnimationTree
var move_state = 0 #0 idle, 1 is run
var action_state = 0 # -1 is throw, 0 is move, 1 is reload,


var gamestate
	

func _enter_tree():
	gamestate = get_parent()
	connect("apply_customization", gamestate, "apply_customization")
	emit_signal("apply_customization")
	
	
func _ready():	
	character_type = CHARACTER_TYPES.player
	
	set_refill_timer()
	update_GUI()
	
	
	

func _process(delta):
	move(delta)
	refill()
	animate()
	face_forward()
	update_refill()
	
	
	
func move(delta):
	var movement_dir = get_2d_movement()
	var camera_xform = $Camera.get_camera_transform()

	dir = Vector3(0,0,0)
	
	dir += camera_xform.basis.z.normalized() * movement_dir.y

	dir += camera_xform.basis.x.normalized() * movement_dir.x
	
	
	dir = move_vertically(dir, delta)
	vel = h_accel(dir, delta) 
	
	
		
	move_and_slide(vel, UP)
	



func get_2d_movement():
	var movement_vector = Vector2()
	if Input.is_action_pressed("forward") and not Input.is_action_pressed("back"):
		movement_vector.y = -1
		facing_direction = 0
	if Input.is_action_pressed("back") and not Input.is_action_pressed("forward"):
		movement_vector.y = 1
		facing_direction = PI
		
		
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		movement_vector.x = -1
		facing_direction = PI * 0.5
	if Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		
		movement_vector.x = 1
		facing_direction = PI * 1.5
		
		
	
	return movement_vector.normalized()


func move_vertically(dir, delta):
	
	if not is_on_floor():
		vel.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vel.y = JUMP_SPEED
	elif is_on_floor():
		vel.y = 0 
		
	dir.y = 0
	dir = dir.normalized()
	return dir
	
func h_accel(dir, delta):

	var vel_2D = vel
	vel_2D.y = 0
	
	var target = dir
	target *= MAX_SPEED
	
	var accel 
	
	if dir.dot(vel_2D) > 0:
		accel = ACCEL
	else:
		accel = DECEL
		
	vel_2D = vel_2D.linear_interpolate(target, accel * delta)
	
	vel.x = vel_2D.x
	vel.z = vel_2D.z
	
	return vel
	
func _input(event):
	if Input.is_action_just_pressed("Fire"):
		if ammo > 0 and can_fire:
			action_state = -1
			#anim_tree.set("parameters/Punch_Refill/blend_amount", -1)
			fire()
			ammo -= 1
			update_GUI()

	
func face_forward():
	$PlayerArmature.rotation.y = facing_direction

func animate():
	
	
	if vel.length() >= BLEND_MINIMUM:	
		move_state = (anim_tree.get("parameters/Idle_Walk/blend_amount") + RUN_BLEND_AMOUNT)
		
	elif vel.length() <= BLEND_MINIMUM:
		move_state = (anim_tree.get("parameters/Idle_Walk/blend_amount") - IDLE_BLEND_AMOUNT)
	
	move_state = clamp(move_state, 0.000,1.000)
	
	if can_refill and in_refill_area:
		action_state = (anim_tree.get("parameters/Punch_Refill/blend_amount") + RELOAD_BLEND_AMOUNT)

#	if is_throwing:
#		action_state = (anim_tree.get("parameters/Punch_Refill/blend_amount") - THROW_BLEND_AMOUNT)
		
	
	action_state = clamp(action_state, -1.000, 1.000)
	
	if action_state > .5:
		$CollisionShape.disabled = true
		$CollisionShape2.disabled = false
	else:
		$CollisionShape.disabled = false
		$CollisionShape2.disabled = true
		
	action_state = lerp(action_state, 0, ACTION_RESET_RATE)
	
	
	anim_tree.set("parameters/Idle_Walk/blend_amount", move_state)
	anim_tree.set("parameters/Punch_Refill/blend_amount", action_state)



func _on_RefillTimer_timeout():
	$Harp.play()
	ammo +=1
	update_GUI()
	
	
	
	
func check_ammo():
	if ammo < max_ammo:
		can_refill = true
		return true

func RefillArea_entered():
	in_refill_area = true
	
		
func RefillArea_exited():
	$Harp.stop()
	$RefillTimer.stop()
	clear_refill()
	in_refill_area = false
	
func update_GUI():
	get_tree().call_group("GUI", "update_ammo", ammo)
	
func refill():
	if (in_refill_area  and !$RefillTimer.get_time_left() > 0): 
		if check_ammo():
			$RefillTimer.start()
			
			anim_tree.set("parameters/Punch_Refill/blend_amount", 1)
			action_state = 1
			
		else:
			can_refill = false
			$Harp.stop()
				
			
func update_refill():
	time = $RefillTimer.wait_time - $RefillTimer.time_left
	if time < $RefillTimer.wait_time:
		get_tree().call_group("GUI", "update_refill", time)
		
func set_refill_timer():
	get_tree().call_group("GUI", "set_refill_timer",  $RefillTimer.wait_time)
	
func clear_refill():
	get_tree().call_group("GUI", "clear_refill")
	
func set_char_anim_tree():
	pass
	