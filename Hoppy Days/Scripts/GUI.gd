extends CanvasLayer

func _ready():
	Global.GUI = self

func update_GUI(coins, lives):
	$Banner/HBoxContainer/CoinCount.text = str(coins)
	$Banner/HBoxContainer/LifeCount.text = str(lives)
	
func animate(animation):	
	$Banner/AnimationPlayer.play(animation)
	
func _process(delta):
	OS.set_window_title("fps | " + str(Engine.get_frames_per_second()))