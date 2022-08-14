extends CanvasLayer

func update_ammo(ammo):
	$CenterContainer/Label.text = str(ammo)
	
func update_refill(time):
	$CenterContainer/TextureProgress.value = time

func clear_refill():
	$CenterContainer/TextureProgress.value = 0
	
func remove_life():
	$ItemList.remove_item(0)
	
func set_refill_timer(wait_time):
	$CenterContainer/TextureProgress.max_value = wait_time