extends Node2D

export var starting_lives = 3

var coin_target = 10

var lives

var coins = 0

func _ready():
	Global.GameState = self
	lives = starting_lives
	update_GUI()
	
func update_GUI():
	Global.GUI.update_GUI(coins,lives)
	
func animate_GUI(animation):
	Global.GUI.animate(animation)
	
func hurt():	
	lives -= 1
	Global.Player.hurt()
	update_GUI()
	animate_GUI("HurtGui")
	
	if lives < 0:
		end_game()
		
func coin_up():
	coins += 1  
	var multiple_of_coin_target = (coins % coin_target) == 0
	if multiple_of_coin_target:	
		life_up()
		animate_GUI("LifePulse")
	update_GUI()
	animate_GUI("CoinPulse")
	
	
	
func life_up():
	lives +=1	
func end_game():
	get_tree().change_scene(Global.GameOver)

func victory():
	get_tree().change_scene(Global.Victory)

func _on_body_entered(body):
	victory()
