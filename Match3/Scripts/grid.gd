extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#State Machine
var state;
enum {wait, move, win, lose}
var turns = 1
#swap back

var piece_one = null
var piece_two = null
var last_place = Vector2.ZERO
var last_direction = Vector2.ZERO
var move_checked = false;


var horizontal_matches = []
var vertical_matches = []

#Game Window variables
export (int) var width;
export (int) var height;
export (int) var x_start;
export (int) var y_start;
export (int) var piece_offset; #offset (pixels)
export (int) var refill_offset = 5; #y_offset (grid)

#Scoring Variables
signal update_score
export (int) var piece_value
var streak = 1

# Collectable /Sinker Stuff

export (PackedScene) var sinker_piece
export (bool) var sinkers_in_scene
export (int) var max_sinkers
var current_sinkers = 0

#Counter Variables

signal update_counter
export (int) var current_counter_value
export (bool) var is_moves;
signal game_over;
#Obstacle stuff

export (PoolVector2Array) var empty_spaces;
export (PoolVector2Array) var ice_spaces;
export (PoolVector2Array) var lock_spaces;
export (PoolVector2Array) var concrete_spaces;
export (PoolVector2Array) var slime_spaces;
var damaged_slime = false;
var slime_made = false;

#Obstacle Signal
signal make_ice
signal damage_ice
signal make_locks
signal damage_lock
signal make_concrete
signal damage_concrete
signal make_slime
signal damage_slime

var debug_click = null

var possible_pieces = [
	
	preload("res://Scenes/blue_piece.tscn"),
	preload("res://Scenes/yellow_piece.tscn"),
	preload("res://Scenes/pink_piece.tscn"),
	preload("res://Scenes/green_piece.tscn"),
	preload("res://Scenes/light_green_piece.tscn"),
	preload("res://Scenes/orange_piece.tscn")
	];
	
#Effects

var destroy_particle_effect = preload("res://Scenes/DestroyParticle.tscn")
var explosion_animation = preload("res://Scenes/ExplosionAnimation.tscn")
var color_array = []



var all_pieces = [];
var current_matches = [];


#Touch Variables

var first_touch = Vector2(0,0);
var final_touch = Vector2(0,0);
var grid_position = Vector2(0,0);
var swiping = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	all_pieces = make_2d_array();
	
	if sinkers_in_scene:
		spawn_sinkers(max_sinkers)
	spawn_pieces();
	
	spawn_ice();
	spawn_locks();
	spawn_concrete();
	
	spawn_slime();
	
	custom_play();
	generate_color_array();
	
	state = move;
	emit_signal("update_counter",current_counter_value)
	if !is_moves:
		$Timer.start()
	

func custom_play():
	#empty_spaces = [];
	#slime_spaces = []
	#concrete_spaces = [];
	#lock_spaces = [];
	#ice_spaces = [];	
	#all_pieces[width-2][height -4].make_color_bomb();
	#all_pieces[width-1][height -4].makeblue();
#	all_pieces[width-2][height -4].makeblue();
#	all_pieces[width-4][height -4].makeblue();
#	all_pieces[width-3][height -5].makeblue();
#	all_pieces[width-3][height -6].makeblue();
	pass
	

	
func restricted_fill(place):
	
	if is_in_array(empty_spaces,place):
		return true
	if is_in_array(concrete_spaces, place):
		return true
	if is_in_array(slime_spaces, place):
		return true
		
	return false
	
func restricted_movement(place):
	for i in lock_spaces:
		if i == place:
			#print("movement check " , place)
			return true
	return false
	
func is_in_array(array,item):
	for i in array.size():
		if array[i] == item:
			return true
	
	return false 
	
func make_2d_array():
	var array = [];
	
	for i in width:
		array.append([]);
		for j in height:
			array[i].append(null);
	return array;
	
func spawn_pieces():
	
	for i in width:
		for j in height:
			#choose a random number and store it
			if !restricted_fill(Vector2(i,j)) && all_pieces[i][j] == null:
				var rand = floor(rand_range(0, possible_pieces.size()));
				var piece = possible_pieces[rand].instance();
				var loops = 0;
				#check to ensure no mataches on spawn
				while(match_at(i,j, piece.color) && loops < 100):
					rand = floor(rand_range(0, possible_pieces.size()));
					piece = possible_pieces[rand].instance();
					loops+=1;
				
				add_child(piece);
				piece.position = grid_to_pixel(i, j);
				all_pieces[i][j] = piece;
			
func is_piece_sinker(column, row):
	if all_pieces[column][row] != null:
		if all_pieces[column][row].color == "None":
			return true
		return false
		
func spawn_ice():
	for i in ice_spaces.size():
		emit_signal("make_ice", ice_spaces[i], piece_offset, x_start, y_start, width, height);

func spawn_locks():
	for i in lock_spaces.size():
		emit_signal("make_locks", lock_spaces[i], piece_offset, x_start, y_start, width, height);
		
func spawn_concrete():
	for i in concrete_spaces.size():
		emit_signal("make_concrete", concrete_spaces[i], piece_offset, x_start, y_start, width, height);
		
func spawn_slime():
	for i in slime_spaces.size():
		emit_signal("make_slime", slime_spaces[i], piece_offset, x_start, y_start, width, height);
		
func spawn_sinkers(number_to_spawn):
	var count = 0
	#randomize()
	for i in number_to_spawn:
		var column = floor(rand_range(0, width))
		while all_pieces[column][height - 1] != null or restricted_fill(Vector2(column, height - 1)):
			column = floor(rand_range(0, width))
			count += 1
		var current = sinker_piece.instance()
		add_child(current)
		current.position = grid_to_pixel(column, height - 1)
		all_pieces[column][height - 1] = current
		current_sinkers += 1
	

	
	
func grid_to_pixel(columnX,rowY):
	
	var new_x = x_start + piece_offset * columnX;
	var new_y = y_start - piece_offset * rowY;
	return Vector2(new_x,new_y);
	
func pixel_to_grid(pixel_x,pixel_y):
	var new_x = round((pixel_x - x_start) / piece_offset);
	var new_y = round((pixel_y - y_start) / -piece_offset);
	return Vector2(new_x, new_y);
	
func is_in_grid(grid_position):
	
	if grid_position.x >= 0 && grid_position.x < width:
		if grid_position.y >=0 && grid_position.y < height:
			return true;
	
	return false;
func match_at(columnX, rowY, color):
	var i = columnX;
	var j = rowY;
	#check for match to the left
	if i > 1:
		if all_pieces[i - 1][j] != null && all_pieces[i - 2][j] != null:
			if all_pieces[i - 1][j].color == color && all_pieces[i - 2][j].color == color:
				return true;
		
	#check for match down	
	if j > 1:
		if all_pieces[i][j - 1] != null && all_pieces[i][j - 2] != null:
			if all_pieces[i][j - 1].color == color && all_pieces[i][j - 2].color == color:
				return true;	


func touch_input():
	if Input.is_action_just_pressed("ui_touch") && !swiping:
		if(is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y))):
			first_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y);
			swiping = true;
		
	if Input.is_action_just_released("ui_touch") && swiping:				
		if(is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)) && swiping):
			swiping = false;
			final_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y);
			touch_difference(first_touch,final_touch);


		
func debug_input():
	if Input.is_action_just_pressed("ui_debug_click"):
			debug_click = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y);
			var my_piece = all_pieces[debug_click.x][debug_click.y]
			if my_piece != null:
				print ("Column: ", debug_click.x)
				print ("Row: ", debug_click.y)
				print ("Color :", all_pieces[debug_click.x][debug_click.y].color)
				print ("Matched :", all_pieces[debug_click.x][debug_click.y].matched)
	
	if debug_click != null:  
		if Input.is_key_pressed(KEY_A):
			print ("b pressed")
			if all_pieces[debug_click.x][debug_click.y] != null:
					all_pieces[debug_click.x][debug_click.y].make_adjacent_bomb()
		if Input.is_key_pressed(KEY_C):
			print ("c pressed")
			if all_pieces[debug_click.x][debug_click.y] != null:
					all_pieces[debug_click.x][debug_click.y].make_column_bomb()
		if Input.is_key_pressed(KEY_R):
			print ("r pressed")
			if all_pieces[debug_click.x][debug_click.y] != null:
					all_pieces[debug_click.x][debug_click.y].make_row_bomb()
		if Input.is_key_pressed(KEY_K):
			print ("k pressed")
			if all_pieces[debug_click.x][debug_click.y] != null:
					all_pieces[debug_click.x][debug_click.y].make_color_bomb()
		if Input.is_key_pressed(KEY_1):			
			if all_pieces[debug_click.x][debug_click.y] != null:
					all_pieces[debug_click.x][debug_click.y].make_color("green")
		if Input.is_key_pressed(KEY_2):			
			if all_pieces[debug_click.x][debug_click.y] != null:
					all_pieces[debug_click.x][debug_click.y].make_color("blue")
		if Input.is_key_pressed(KEY_3):			
			if all_pieces[debug_click.x][debug_click.y] != null:
					all_pieces[debug_click.x][debug_click.y].make_color("pink")
		if Input.is_key_pressed(KEY_4):			
			if all_pieces[debug_click.x][debug_click.y] != null:
					all_pieces[debug_click.x][debug_click.y].make_color("orange")
		if Input.is_key_pressed(KEY_5):			
					if all_pieces[debug_click.x][debug_click.y] != null:
							all_pieces[debug_click.x][debug_click.y].make_color("light_green")
		if Input.is_key_pressed(KEY_6):			
					if all_pieces[debug_click.x][debug_click.y] != null:
							all_pieces[debug_click.x][debug_click.y].make_color("yellow")
		if Input.is_key_pressed(KEY_Z):	
			#Clear bombs
					for i in width:
						for j in height:
							if all_pieces[i][j] != null:
								all_pieces[i][j].make_plain()		
				
		
				
func swap_pieces(column, row, direction):
	#print("Starting piece pixels ", row, column);
	var first_piece = all_pieces[column][row];
	var other_piece = all_pieces[column + direction.x][row + direction.y];
	
	if(first_piece != null && other_piece != null):
	
		if !restricted_movement(Vector2(column,row)) && !restricted_movement(Vector2(column,row) + direction) :
			store_info(first_piece, other_piece, Vector2(column, row), direction);
			all_pieces[column][row] = other_piece;
			all_pieces[column + direction.x][row + direction.y] = first_piece;
			first_piece.move(grid_to_pixel(column+ direction.x, row + direction.y)) ;
			other_piece.move(grid_to_pixel(column, row));
			
			if !move_checked:
				
				find_matches();
	
func store_info(first_piece, other_piece, place, direction):
	
	piece_one = first_piece;
	piece_two = other_piece;
	last_place = place;
	last_direction = direction;
	
	pass;

func swap_back():
	state = wait
	if piece_one != null && piece_two != null:
		swap_pieces(last_place.x,last_place.y, last_direction);
	move_checked = false
	
	
	state = move
	pass
	
#choose which piece gets moved and where it has to go
func touch_difference(grid_2, grid_1):
	
	var difference = grid_2 - grid_1;
	
	
	#Directions
	#Left or Right
	if abs(difference.x) > abs( difference.y):
		
		if difference.x > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2.RIGHT);	
		elif difference.x < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2.LEFT);
	#Up or Down
	elif abs(difference.y) > abs( difference.x):	
		if difference.y > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2.DOWN);
		elif difference.y < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2.UP);
			
func clean_matches():
	for index in current_matches.size():
		var x = current_matches[index].x
		var y = current_matches[index].y
		if all_pieces[x][y] == null:
			current_matches[index].remove
		
func find_bombs():
	# BUG clean_matches is because sometimes with adjacent obstacles or 
	#null spaces the game would freeze
	#I have to test this on debug mode is implemenented
	#clean_matches();
	for i in current_matches.size():		
		var current_column = current_matches[i].x
		var current_row = current_matches[i].y
		var col_matched = 0;
		var row_matched = 0;
		var current_color;
		if all_pieces[current_column][current_row] != null:
			current_color = all_pieces[current_column][current_row].color
			#Chaining stuff (but bombs are only created on swip)
			#var col_bomb_piece;
			#var row_bomb_piece;
			#var color_start_piece;
			#var color_bomb_piece;
			
			for j in current_matches.size():
				
				var this_column = current_matches[j].x
				var this_row = current_matches[j].y
				var this_color
				
				#BUG check
				
				if all_pieces[this_column][this_row] != null:
					this_color = all_pieces[this_column][this_row].color
					if this_column == current_column && current_color == this_color:
						#if col_matched == 0:
						#	col_bomb_piece == all_pieces[current_column][current_row]
						#	
						col_matched += 1;
						
						#if col_matched >= 5:
						#	color_bomb_piece == col_bomb_piece;
					if this_row == current_row && current_color == this_color:
						#if row_matched == 0:
						#	row_bomb_piece == all_pieces[current_column][current_row]
						row_matched += 1;
						#if col_matched >= 5:
						#	color_bomb_piece == row_bomb_piece;
				
				
		if  col_matched == 5 || row_matched == 5:
			
			#print("color bomb")
			make_bomb(3, current_color)
			continue
			#make_bomb(4, current_color, color_bomb_piece);
			
		elif  col_matched >=3 && row_matched >= 3:
			#adjacent bomb
			#print("adj bomb")
			make_bomb(0, current_color)
			continue
		elif row_matched == 4:
			#row bomb
			#print("row bomb")
			make_bomb(1, current_color)
			continue
			
		elif col_matched == 4:
			#column bomb
			#print("column bomb")
			make_bomb(2, current_color)
			continue
					
	
				

func make_bomb(bomb_type, color):
	for i in current_matches.size():
		var current_column = current_matches[i].x
		var current_row = current_matches[i].y
		
		if all_pieces[current_column][current_row] != null:
			#Set pieces to not matched so they don't get destroyed
			if all_pieces[current_column][current_row] == piece_one && piece_one.color == color:
				print("Piece One Bomb", current_column, ",", current_row)
				piece_one.matched = false;
				change_bomb(bomb_type, all_pieces[current_column][current_row]);
			elif all_pieces[current_column][current_row] == piece_two && piece_two.color == color:
				print("Piece Two Bomb", current_column, ",", current_row)
				piece_two.matched = false;
				change_bomb(bomb_type, all_pieces[current_column][current_row]);
			
func change_bomb(bomb_type,piece):
		
		if piece != null:
			if bomb_type == 0:
				piece.make_adjacent_bomb();
			elif bomb_type == 1:
				piece.make_row_bomb();
			elif bomb_type == 2:
				piece.make_column_bomb();
			elif bomb_type == 3:
				piece.make_color_bomb();
			
		
func find_matches():
	
	
	for i in height:
		horizontal_matches.append( ["Row: " + str(i)])
	
	#print("findmatches called")
	for i in width:
		for j in height:
			if !is_piece_null(i, j) && !is_piece_null(i,j):
				var current_color = all_pieces[i][j].color;
				if i > 0 && i < width -1:
					if !is_piece_null(i -1,j) && !is_piece_null(i + 1,j):
						if all_pieces[i - 1][j].color == current_color && all_pieces[i + 1][j].color == current_color:							
							match_and_dim(all_pieces[i - 1][j])
							match_and_dim(all_pieces[i][j])
							match_and_dim(all_pieces[i + 1][j])
						
							add_to_array(Vector2(i - 1, j))
							add_to_array(Vector2(i,j))
							add_to_array(Vector2(i + 1, j))
							
							add_to_array(Vector2(i - 1, j),horizontal_matches[j])
							add_to_array(Vector2(i,j), horizontal_matches[j])
							add_to_array(Vector2(i + 1, j), horizontal_matches[j])
								
							
				if j > 0 && j < height -1:
					if !is_piece_null(i, j-1) && !is_piece_null(i,j + 1):
						if all_pieces[i][j -1].color == current_color && all_pieces[i][j + 1].color == current_color:
							match_and_dim(all_pieces[i][j - 1])
							match_and_dim(all_pieces[i][j])
							match_and_dim(all_pieces[i][j + 1])
							
							add_to_array(Vector2(i, j-1))
							add_to_array(Vector2(i,j))
							add_to_array(Vector2(i, j + 1))
	
	
	
	#print (current_matches);
	
	get_bombed_pieces();
	get_parent().get_node("destroy_timer").start();
	
func check_concrete(column, row):
	
	#Check Right
	if column < width - 1:
		emit_signal("damage_concrete", Vector2(column + 1, row));
	#Check Left
	if column > 0:
		emit_signal("damage_concrete", Vector2(column - 1, row));
	#Check Up
	if row < height -1:
		emit_signal("damage_concrete", Vector2(column, row + 1));
	#Check Down
	if row > 0:
		emit_signal("damage_concrete", Vector2(column, row - 1));
		
func check_slime(column, row):
	#Check Right
	if column < width - 1:
		#print("slime right")
		emit_signal("damage_slime", Vector2(column + 1, row));
	#Check Left
	if column > 0:
		#print("slime right")
		emit_signal("damage_slime", Vector2(column - 1, row));
		
	#Check Up
	if row < height -1:
		#print("slime up")
		emit_signal("damage_slime", Vector2(column, row + 1));
	#Check Down
	if row > 0:
		#print("slime down")
		emit_signal("damage_slime", Vector2(column, row - 1));
	

func damage_special(column,row):
	if ice_spaces.size() > 0:
		emit_signal("damage_ice", Vector2(column,row))
	if lock_spaces.size() > 0:
		emit_signal("damage_lock", Vector2(column,row))
	if concrete_spaces.size() > 0:
		check_concrete(column,row);
	if slime_spaces.size() > 0:
		check_slime(column,row);

func is_piece_null(column, row):
	if all_pieces[column][row] ==  null:
		return true
	return false
	
func match_and_dim(item):
	item.matched = true;
	item.dim()

func add_to_array(value, array_to_add = current_matches):
	if !array_to_add.has(value):
		array_to_add.append(value)
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(state == move):
		touch_input();
		debug_input();


func destroy_matched():
	find_bombs()
	var was_matched = false
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				
				if all_pieces[i][j].matched:
					damage_special(i,j)
					was_matched = true;
					make_effect(explosion_animation,i,j)
					make_effect(destroy_particle_effect,i,j)
					all_pieces[i][j].queue_free();
					all_pieces[i][j] = null;
					
					emit_signal("update_score", piece_value * streak)
					
	move_checked = true;
					
	if(!was_matched): 
		swap_back()
		
	else:
		get_parent().get_node("collapse_timer").start();
	current_matches = []

func make_effect(effect, column, row):
	var current = effect.instance();
	current.position = grid_to_pixel(column,row)
	add_child(current)
	

	
func collapse_columns():
	
	#print("collapse columns called");
	for i in width:
		for j in height:
			if all_pieces[i][j] == null && !restricted_fill(Vector2(i,j)):
				for k in range(j + 1, height):
					if all_pieces[i][k] != null:
						all_pieces[i][k].move(grid_to_pixel(i,j));
						all_pieces[i][j] = all_pieces[i][k]
						all_pieces[i][k] = null;
						break;
	get_parent().get_node("refill_timer").start();

func refill_columns():
	streak += 1;
	state = wait
	
	for i in width:
		for j in height:
			#choose a random number and store it
			if all_pieces[i][j] == null && !restricted_fill(Vector2(i,j)): 
				refill_offset = height + 1 - j;
				var rand = floor(rand_range(0, possible_pieces.size()));
				var piece = possible_pieces[rand].instance();
				var loops = 0;
				#check to ensure no mataches on spawn
				while(match_at(i,j, piece.color) && loops < 100):
					rand = floor(rand_range(0, possible_pieces.size()));
					piece = possible_pieces[rand].instance();
					loops+=1;
				
				add_child(piece);
				
				piece.position = grid_to_pixel(i, j + refill_offset);
				piece.move(grid_to_pixel(i, j));
				all_pieces[i][j] = piece;
	after_refill();

func after_refill():
	
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				if match_at(i,j,all_pieces[i][j].color):
					find_matches();
					get_parent().get_node("destroy_timer").start();
					return;
	if !damaged_slime:
		generate_slime()
	damaged_slime = false;
	move_checked = false;
	streak = 1;
	state = move
	print("turn: ", turns, " horizontal matches: ", clean_hMatch_array())
	turns += 1	
	horizontal_matches = []
	if is_moves:
		current_counter_value -=1
		emit_signal("update_counter")
		if current_counter_value <=0:
			declare_game_over()

func clean_hMatch_array():
		var clean_match_array = []
		for i in range(0, width):
			if horizontal_matches[i] != null:	
				if horizontal_matches[i].size() > 1:
					clean_match_array.append(horizontal_matches[i])
				
		return clean_match_array;
func generate_slime():
	#print("Generate slime called")
	 #make sure there are slime pieces on the board
	#print(slime_made)
	if slime_spaces.size() > 0:
		
		var tracker = 0
		while !slime_made && tracker <100:
			# check a random slime
			var random_num = floor(rand_range(0, slime_spaces.size() ));
			var neighbor = find_normal_neighbor(slime_spaces[random_num])
			#print(neighbor)
			if neighbor != null:
					#turn neighbor into a slime
				all_pieces[neighbor.x][neighbor.y].queue_free();
				all_pieces[neighbor.x][neighbor.y] = null;
				slime_spaces.append(neighbor);
				
				emit_signal("make_slime", neighbor, piece_offset, x_start, y_start, width, height);
				slime_made = true;
				
				
			
			tracker += 1;
	slime_made = false;
				
			
	
func find_normal_neighbor(piece):
	var column = piece.x 
	var row = piece.y

	if is_in_grid(Vector2(column + 1, row)):
		if all_pieces[column +1][row] != null and !is_piece_sinker(column + 1, row):
			return Vector2(column + 1, row)
			
	if is_in_grid(Vector2(column - 1, row)):
		if all_pieces[column -1][row] != null and !is_piece_sinker(column - 1, row):
			return Vector2(column - 1, row)
		
		#up is y neegative so theis is checking down	
	if is_in_grid(Vector2(column, row + 1)):
		if all_pieces[column][row + 1]  != null and !is_piece_sinker(column, row + 1):
			return Vector2(column, row + 1)
			
	#up is y neegative so theis is checking up		
	if is_in_grid(Vector2(column, row - 1)):
		if all_pieces[column][row -1]  != null and !is_piece_sinker(column, row - 1):
			return Vector2(column, row - 1)
	return null

func match_all_in_column(column):
	for i in height:
		if all_pieces[column][i] != null and !is_piece_sinker(column, i):
			all_pieces[column][i].matched = true;

func match_all_in_row(row):
		for i in width:
			if all_pieces[i][row] != null and !is_piece_sinker(i, row):
				all_pieces[i][row].matched =true;
				
func match_all_of_color(color):
	for i in width:
		for j in height:
			if all_pieces[i][j] != null: 
				if all_pieces[i][j].color == color:
					match_and_dim(all_pieces[i][j]);
					
func find_adjacent_pieces(column, row):
	for i in range(-1,2):
		for j in range(-1,2):
			if is_in_grid(Vector2(column + i, row +j)):
				if all_pieces[column+i][row+j] != null:
					all_pieces[column+i][row+j].matched = true

func generate_color_array():
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				var current_color = all_pieces[i][j].color
				if !color_array.has(current_color):
					color_array.append(current_color)	
					
func get_bombed_pieces():
	
	if (piece_one != null  && piece_two != null):
		#double color bomb
		if piece_one.is_color_bomb && piece_two.is_color_bomb:
			generate_color_array();
			randomize()
			#pick 2 random colors and remove them
			streak += 3
			var rand = floor(rand_range(0, color_array.size() -1))
			match_all_of_color(color_array[rand])
			print(color_array[rand])
			color_array.remove(rand)
			rand = floor(rand_range(0, color_array.size() -1))
			match_all_of_color(color_array[rand])
			print(color_array[rand])
			match_and_dim(piece_one)
			match_and_dim(piece_two)
			
		#if piece_one.is_color_bomb && piece_two.is_color_bomb:
			
		#single color bomb more control but less points
		elif piece_one.is_color_bomb:
			streak += 1
			piece_one.matched = true
			match_all_of_color(piece_two.color)
		
		elif piece_two.is_color_bomb:
			streak += 1
			piece_two.matched = true
			match_all_of_color(piece_one.color)
		
	for i in width:
		for j in height:
			if all_pieces[i][j] != null and !is_piece_sinker(i,j): 
				if all_pieces[i][j].matched:
					if all_pieces[i][j].is_column_bomb:
						match_all_in_column(i);
					elif all_pieces[i][j].is_row_bomb:
						match_all_in_row(j);
					elif all_pieces[i][j].is_adjacent_bomb:
						find_adjacent_pieces(i,j);
					
func clear_board():
	for i in width:
		for j in height:
			if all_pieces[i][j]!= null && !is_piece_sinker(i,j):
				match_and_dim(all_pieces[i][j])
				add_to_array(Vector2(i,j))						
					
					

func _on_destroy_timer_timeout():
	destroy_matched();


func _on_collapse_timer_timeout():
	collapse_columns();


func _on_refill_timer_timeout():
	refill_columns();
	
	

func _on_lock_holder_remove_lock(place):
		for i in range(lock_spaces.size() -1, -1, -1):
			if lock_spaces[i] == place:
				lock_spaces.remove(i)
		


func _on_concrete_holder_remove_concrete(place):
	for i in range(concrete_spaces.size() -1, -1, -1):
			if concrete_spaces[i] == place:
				concrete_spaces.remove(i)
		


func _on_slime_holder_remove_slime(place):
	
	for i in range(slime_spaces.size() -1, -1, -1):
			if slime_spaces[i] == place:
				slime_spaces.remove(i)


func _on_slime_holder_slime_damaged():
	 damaged_slime = true;
		


func _on_Timer_timeout():
	current_counter_value -= 1;
	emit_signal("update_counter");
	if current_counter_value <= 0:
		$Timer.stop()
		declare_game_over();
	
func declare_game_over():
	state = wait
	emit_signal("game_over")
	print("Game Over")

func destroy_sinkers():
	for i in width:
		for j in height:
			if all_pieces[i][j].color == "None":
				all_pieces[i][j].matched = true
				current_sinkers -= 1;
