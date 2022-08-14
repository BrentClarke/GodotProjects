extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Ball = []

export var max_score = 1;

var P1Score = 0
var P2Score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.P1ScoreLabel.bbcode_text = ("[center]" + str(P1Score))
	Global.P2ScoreLabel.bbcode_text = ("[center]" + str(P2Score))
	Global.Game = self
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GoalDetection_body_entered(body, goal_id):
	print("Player " + str(goal_id) + " has scored " + body.get_name())
	#body will always be the ball.
	Ball = body
	body.get_node("AirHorn").play()
	body.axis_lock_linear_x = true
	body.axis_lock_linear_y = true
	body.axis_lock_linear_z = true
	get_tree().call_group("Players","can_move", false)
	get_tree().call_group("Celebrants", "goal_scored", goal_id)
	incrementScore(goal_id)
	if not $Timer.is_stopped():
		$Timer.start()
	
	
	
func reset_pitch(Ball):
	Ball.translation = Ball.Spawn_Point
	get_tree().call_group("Celebrants","reset")
	$Camera.current = true
	Ball.axis_lock_linear_x = false
	Ball.axis_lock_linear_y = false
	Ball.axis_lock_linear_z = false
	
	
func incrementScore(goal_id):
	
	if (goal_id == 1):
		P1Score += 1
		Global.P1ScoreLabel.bbcode_text = ("[center]" + str(P1Score))
	elif(goal_id == 2):
		P2Score += 1
		Global.P2ScoreLabel.bbcode_text = ("[center]" + str(P2Score))
		
	if (P1Score == max_score || P2Score == max_score):
		end_game(goal_id)


	


func _on_Timer_timeout():
	$Timer.stop()
	reset_pitch(Ball)
	
func end_game(goal_id):
	
	$Timer.queue_free()
	Global.BGM.stream = Global.PauseMusic
	Global.BGM.play()
	Global.Winner.bbcode_text = "[center]Player " + str(goal_id) + " Wins!!!"
	Global.GameOverPopup.popup()


func _on_Retry_pressed():
	Global.BGM.stream = Global.GameMusic
	get_tree().reload_current_scene()


func _on_Quit_pressed():
	get_tree().quit()
