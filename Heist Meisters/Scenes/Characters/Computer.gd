extends Area2D

var can_click = false
var combination

export var combination_length = 4
export var lock_group = "Unset"

onready var combination_generator = get_tree().get_root().find_node("CombinationGenerator",true, false)

signal combination

func _ready():
	generate_combination()
	$Light2D.enabled = false
	emit_signal("combination", combination, lock_group)
	$Label.rect_rotation = rotation_degrees - 90
	$Label.text = lock_group
	
	
func generate_combination():
	
	combination = combination_generator.generate(combination_length)
	set_popup_text()

func _on_Computer_body_entered(body):
	print("hi")
	can_click = true
	print(can_click)
	

func _on_Computer_body_exited(body):
	print("bye")
	can_click = false
	print(can_click)
	$Light2D.enabled = false
	$CanvasLayer/ComputerPopup.hide()

func _input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_click:
		print("click")
		$CanvasLayer/ComputerPopup.popup_centered()
		$Light2D.enabled = true
		
func set_popup_text():
	$CanvasLayer/ComputerPopup.set_text(combination)
