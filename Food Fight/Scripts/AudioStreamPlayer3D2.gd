extends AudioStreamPlayer3D

func _enter_tree():
	randomize()
	pitch_scale = randf()*5.86+1.96