extends Node2D

export (int) var health

func _ready():
	pass # Replace with function body.


func take_damage(damage):
	print(health)
	health -= damage;
