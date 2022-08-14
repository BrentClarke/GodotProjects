extends Spatial

var player_material 
var player_armature
var armature_node
var robots

func _ready():
	robots = 2
	#robots  = get_tree().get_root().find_node("Robots", true, false).get_children().size() 
	

func remove_enemy():
	print("remove enemy called in gamestate")
	robots -=1
	if robots < 1:
		get_tree().change_scene("res://Levels/Victory.tscn")

func apply_customization():
	print("apply_custmization called")
	#in customization - set defaults ffs or set xustomization to load first
	#preload our texture
	player_material = load(Customizaton.PlayerMaterialString)
	player_armature = load(Customizaton.PlayerArmature)
	
	armature_node = player_armature.instance()
	
	
	#insert armature below Collisionshape
	$Player.add_child_below_node ($Player/CollisionShape, armature_node , true )
	#set our texture on the armature
	$Player.get_child(3).get_child(0).set_surface_material(0, player_material)
	
	
	
	
	
	
	

		