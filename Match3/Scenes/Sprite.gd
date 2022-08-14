extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().my_texture != null:
		 get_node("Sprite").texture = get_parent().my_texture
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
