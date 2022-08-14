extends "res://Scripts/Character.gd"

export var disguises = 3
export var disguise_duration = 5
export var disguise_slowdown = 0.25

var motion = Vector2()
var vision_change_on_cooldown = false;

var vision
enum mode {DARKVISION, NIGHTVISION}

var disguised = false
var velocity_multiplier = 1

func _ready():
	remove_from_group("NPCs")
	reveal()
	$Timer2.wait_time = disguise_duration
	Global.Player = self
	Global.DisguiseList.update_disguises(disguises)
	vision = mode.DARKVISION

func _process(delta):
	update_motion(delta)
	move_and_slide(motion * velocity_multiplier)
	$Label.rect_rotation = -rotation_degrees
	$Label.text = str($Timer2.time_left).pad_decimals(2)
	
func update_motion(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("ui_up") and not Input.is_action_pressed("ui_down") :
		motion.y = clamp((motion.y - SPEED), -MAX_SPEED, 0)
	elif Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up") :
		motion.y = clamp((motion.y + SPEED), 0, MAX_SPEED)
	else:
		motion.y = lerp(motion.y, 0, FRICTION)
	if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") :
		motion.x = clamp((motion.x - SPEED), -MAX_SPEED, 0)
	elif Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left") :
		motion.x = clamp((motion.x + SPEED), 0, MAX_SPEED)
	else: 
		motion.x = lerp(motion.x, 0, FRICTION)
		
		
func _input(event):
	if Input.is_action_just_pressed("ui_select") and not vision_change_on_cooldown:
		cycle_vision_mode()
		
	if Input.is_action_just_pressed("toggle_disguise") and not vision_change_on_cooldown:
		toggle_disguise()

func cycle_vision_mode():
	if vision == mode.DARKVISION:
		vision_change_on_cooldown = true
		$Timer.start()
		get_tree().call_group("interface", "NightVision_mode")
		vision = mode.NIGHTVISION
	elif vision == mode.NIGHTVISION:
		vision_change_on_cooldown = true
		$Timer.start()
		get_tree().call_group("interface", "DarkVision_mode")
		vision = mode.DARKVISION
#
#func toggle_flashlight():
#	if $Flashlight.enabled:
#		$Flashlight.enabled = false
#	else:
#		$Flashlight.enabled = true

func _on_Timer_timeout():
	vision_change_on_cooldown = false # Replace with function body.
	
	
func toggle_disguise():
	if disguised:
		reveal()
	elif disguises > 0 :
		disguise()
	
	
func disguise():
	disguised = true
	disguises -= 1
	Global.DisguiseList.update_disguises(disguises)
	$Sprite.texture = load(Global.box_sprite)
	$Light2D.texture = load(Global.box_sprite)
	$CollisionShape2D.shape = load(Global.box_collision)
	$CollisionShape2D.position.x = Global.box_collision_transform_x
	$LightOccluder2D.occluder = load(Global.box_occluder)
	collision_layer = 16
	velocity_multiplier = .25
	$Timer2.start()
	$Label.visible = true

func reveal():
	disguised = false
	$Sprite.texture = load(Global.player_sprite)
	$Light2D.texture = load(Global.player_sprite)
	$CollisionShape2D.shape = load(Global.player_collision)
	$CollisionShape2D.position.x = Global.player_collision_transform_x
	$LightOccluder2D.occluder = load(Global.player_occluder)
	collision_layer = 1
	velocity_multiplier = 1
	$Label.visible = false


func _on_Timer2_timeout():
	reveal()
	
func collect_briefcase():
	var loot = Node.new()
	loot.set_name("briefcase")
	add_child(loot)
	get_tree().call_group("interface", "collect_loot")
