extends CanvasLayer



func _on_TryAgain_pressed():
	get_tree().change_scene(Global.Level1)


func _on_Quit_pressed():
	get_tree().quit()