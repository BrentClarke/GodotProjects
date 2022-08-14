extends SpotLight

const UP = Vector3(0,1,0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func goal_scored(goal_id):
	var target = get_tree().get_root().find_node("Cubedude", true, false)
	if (goal_id == 2):
		target = get_tree().get_root().find_node("Cubedude2",true, false)
	show()
	look_at(target.translation, UP)
	
func reset():
	hide()