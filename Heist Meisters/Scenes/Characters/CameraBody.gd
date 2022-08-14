extends "res://Scripts/Character.gd"


#onready var Player = get_node("/root/Level1/Player")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var base = get_parent()
onready var Detection = PlayerDetection.new()
onready var fov = $Sprite/Flashlight

var speed = 0
var start = 0
var end = 0
var delay = 0


var direction = 1;
var can_move = true
# Called when the node enters the scene tree for the first time.
func _ready():
	speed = base.speed
	start= base.start
	end = base.end
	delay = base.delay
	$Timer.set_wait_time(delay)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotater()
	Detection.lightChange(self, fov)
	

func rotater():
	
	if $Sprite.rotation_degrees <= round(start):
		direction = 1
	elif $Sprite.rotation_degrees >= round(end) :
		direction = -1
    
	if ($Sprite.rotation_degrees <= start || $Sprite.rotation_degrees >= end):
		
		if $Timer.time_left:
			return;
			
		else: 
			can_move = false;
			$Timer.start();
		
	if can_move:
		$Sprite.rotation_degrees += (speed * direction)			
		

func _on_Timer_timeout():
	can_move = true;
	$Timer.stop()
	$Sprite.rotation_degrees += (speed * direction)
	
func NightVision_Mode():
	fov.enabled = false

func DarkVision_Mode():
	fov.enabled = true
