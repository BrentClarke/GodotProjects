extends DirectionalLight

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	light_energy = 1.5
	
func goal_scored(goal_id):
	$AnimationPlayer.play("Dimmer")