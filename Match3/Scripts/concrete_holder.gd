extends Node2D

signal remove_concrete

var concrete_pieces = [];

var concrete = preload("res://Scenes/concrete.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func make_2d_array(width, height):
	var array = [];
	
	for i in width:
		
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;

func _on_grid_make_concrete(board_position, piece_offset, x_start, y_start, width, height):
	
	if concrete_pieces.size() == 0:
		concrete_pieces = make_2d_array(width, height)
	var current = concrete.instance()
	add_child(current)
	current.position = Vector2(board_position.x * piece_offset +  x_start, -board_position.y * piece_offset +  y_start)
	concrete_pieces[board_position.x][board_position.y] = current


func _on_grid_damage_concrete(board_position):
	if concrete_pieces[board_position.x][board_position.y] != null:
		concrete_pieces[board_position.x][board_position.y].take_damage(1);
		if concrete_pieces[board_position.x][board_position.y].health <= 0:
			concrete_pieces[board_position.x][board_position.y].queue_free()
			concrete_pieces[board_position.x][board_position.y] = null;
			emit_signal("remove_concrete", board_position);
