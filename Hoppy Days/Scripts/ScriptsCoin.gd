extends AnimatedSprite

var taken = false

func _on_Area2D_body_entered(body):
	if !taken:
		taken = true
		Global.GameState.coin_up()
		$AnimationPlayer.play("die")
		$CoinSFX.play()
	else:
		pass

func die():
	queue_free()