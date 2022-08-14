extends CanvasModulate


const DARKVISION = Color("31469a")
const NIGHTVISION = Color("319a55")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("interface")
	color = DARKVISION
	get_tree().call_group("labels", "hide")
	

func NightVision_mode():
	inform_npcs("NightVision_Mode")
	color = NIGHTVISION
	$AudioStreamPlayer.stream = load(Global.nightvision_on_sfx)
	play_sfx()
	get_tree().call_group("labels", "show")
	
func DarkVision_mode():
	inform_npcs("DarkVision_Mode")
	$AudioStreamPlayer.stream = load(Global.nightvision_off_sfx)
	play_sfx()
	color = DARKVISION
	get_tree().call_group("labels", "hide")
	
func play_sfx():
	$AudioStreamPlayer.play()
	
func inform_npcs(vision_mode):
	get_tree().call_group("NPCs", vision_mode)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
