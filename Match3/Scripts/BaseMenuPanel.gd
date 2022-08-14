extends CanvasLayer


func slide_in():
	$AnimationPlayer.play("AnimationSlideIn");
	
func slide_out():
	$AnimationPlayer.play_backwards("AnimationSlideIn");
