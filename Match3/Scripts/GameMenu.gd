extends Control


func _ready():
	$Main.slide_in()




func _on_Main_play_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")


func _on_Main_settings_pressed():
	$Main.slide_out();
	$SettingsPanel.slide_in();


func _on_SettingsPanel_back_button():
	$SettingsPanel.slide_out();
	$Main.slide_in();
	


func _on_SettingsPanel_sound_change():
	pass # Replace with function body.
