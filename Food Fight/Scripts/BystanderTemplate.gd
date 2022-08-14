extends RigidBody


	
func _enter_tree():
	$OutOfBoundsTimer.start()

func _on_HurtTimer_timeout():
	queue_free()


func _on_OutOfBoundsTimer_timeout():
	bounds_check()

func hurt(hurt_by):
	$AudioStreamPlayer3D.play()
	$HurtTimer.start()

func bounds_check():
	if abs(self.get_translation().x) > 15 ||  abs(self.get_translation().y) > 7: 
		queue_free()
	$OutOfBoundsTimer.start()