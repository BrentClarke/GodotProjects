extends Area2D


func _on_jumpPad_body_entered(body):
	$AnimatedSprite.play("spring")
	Global.Player.boost() 
	$AudioStreamPlayer.play()


func _on_Timer_timeout():
	$AnimatedSprite.play("idle")
