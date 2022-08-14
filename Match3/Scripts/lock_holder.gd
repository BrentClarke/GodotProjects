extends Node2D


signal remove_lock

var lock_pieces = [];

var lock = preload("res://Scenes/lock.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func make_2d_array(width, height):
	var array = [];
	
	for i in width:
		
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;

func _on_grid_damage_lock(board_position):
	if lock_pieces[board_position.x][board_position.y] != null:
		lock_pieces[board_position.x][board_position.y].take_damage(1);
		if lock_pieces[board_position.x][board_position.y].health <= 0:
			lock_pieces[board_position.x][board_position.y].queue_free()
			lock_pieces[board_position.x][board_position.y] = null;
			emit_signal("remove_lock", board_position);


func _on_grid_make_locks(board_position, piece_offset, x_start, y_start, width, height):
	if lock_pieces.size() == 0:
		lock_pieces = make_2d_array(width, height)
	var current = lock.instance()
	add_child(current)
	current.position = Vector2(board_position.x * piece_offset +  x_start, -board_position.y * piece_offset +  y_start)
	lock_pieces[board_position.x][board_position.y] = current

