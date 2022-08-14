extends Node2D

signal remove_slime
signal slime_damaged

var slime_pieces = [];

var slime = preload("res://Scenes/slime.tscn")


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

func _on_grid_make_slime(board_position, piece_offset, x_start, y_start, width, height):
	#print("make slime called")
	if slime_pieces.size() == 0:
		slime_pieces = make_2d_array(width, height)
	var current = slime.instance()
	add_child(current)
	current.position = Vector2(board_position.x * piece_offset +  x_start, -board_position.y * piece_offset +  y_start)
	slime_pieces[board_position.x][board_position.y] = current
	


func _on_grid_damage_slime(board_position):
	
	if slime_pieces[board_position.x][board_position.y] != null:
		
		slime_pieces[board_position.x][board_position.y].take_damage(1);
	
		emit_signal("slime_damaged");
		if slime_pieces[board_position.x][board_position.y].health <= 0:
			slime_pieces[board_position.x][board_position.y].queue_free()
			slime_pieces[board_position.x][board_position.y] = null;
			emit_signal("remove_slime", board_position);
