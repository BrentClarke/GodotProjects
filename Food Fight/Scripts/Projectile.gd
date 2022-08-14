extends RigidBody


var sound = true

var dangerous = true

var fired_by

func _enter_tree():
	$Timer.start()
	$AudioStreamPlayer3D.play()
	
func _on_Timer_timeout():
	queue_free()
	
	

	

func _on_Projectile_body_shape_entered(body_id, body, body_shape, local_shape):
	$SmokeTrail.emitting = false
	$SmokeTrail.visible = false
	if sound:
		$AudioStreamPlayer3D2.play()
	if body.has_method("hurt") and dangerous:
		body.hurt(fired_by)
	dangerous = false
	$CollisionTimer.start()
	sound = false

func _on_CollisionTimer_timeout():
	queue_free()



func _on_Area_body_shape_exited(body_id, body, body_shape, area_shape):
	if body is KinematicBody:
		$SmokeTrail.emitting = true
