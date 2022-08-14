extends ItemList

func _ready():
	Global.DisguiseList = self
	
func update_disguises(number):
	
	clear()
	for disguise in range(number):
		print("being called")
		add_icon_item(load(Global.box_sprite),false)	