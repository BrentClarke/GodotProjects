extends CanvasLayer

func _input(event):
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$Popup.hide()
		else:
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Popup.show()


func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = !OS.window_fullscreen



func _on_Quit_pressed():
	get_tree().quit()