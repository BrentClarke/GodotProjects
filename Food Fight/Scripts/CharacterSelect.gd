extends Spatial

var male
var female
var character_showing 
var materials = {}
var loaded_materials = {}
var max_size
var selected = 0
var customization


func _enter_tree():
	materials = file_grabber.get_files("res://Scenes/Customisation/PlayerMaterials/")
	
	
	
func _ready():
	customization = Customizaton
	max_size = materials.size() - 1
	male = $Armatures/ArmatureMale/PlayerMesh
	female = $Armatures/ArmatureFemale/PlayerMesh
	male.set_surface_material(0,load(materials[selected]))
	female.set_surface_material(0,load(materials[selected]))
	male.visible = true
	female.visible = false

func _process(delta):
	controls()
	
func toggle_sex():
	male.visible = !male.visible
	female.visible = !female.visible
	
	if (male.visible == female.visible):
		male.visible = true
		female.visible = false 
		

		
func change_material(selected):
	male.set_surface_material(0,load(materials[selected]))
	female.set_surface_material(0,load(materials[selected]))
	print(selected)
		
func controls():
		if Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down"):
			toggle_sex()
			
		if Input.is_action_just_pressed("ui_left"):
			selected -= 1
			if selected == -1:
				selected = max_size
			selected = clamp(selected,0,max_size)
			change_material(selected)
		elif Input.is_action_just_pressed("ui_right"):
			selected += 1
			if selected == 6:
				selected = 0
			selected = clamp(selected,0,max_size)
			change_material(selected)
			

		if Input.is_action_pressed("ui_accept"):
			selected()
			
			
			
func selected():
	if male.visible:
		customization.PlayerArmature = "res://Armatures/PlayerArmatureM.tscn"
	else:
		customization.PlayerArmature = "res://Armatures/PlayerArmatureF.tscn"

	Customizaton.PlayerMaterialString = materials[selected]

	get_tree().change_scene("res://Levels/Level1.tscn")

		
		
		