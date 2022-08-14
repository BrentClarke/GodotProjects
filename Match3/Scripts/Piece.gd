extends Node2D


export (String) var color;
export (Texture) var row_texture
export (Texture) var column_texture
export (Texture) var adjacent_texture

var color_bomb_texture = preload("res://Pieces/Rainbow.png")


var is_row_bomb = false
var is_column_bomb = false
var is_adjacent_bomb = false
var is_color_bomb = false

#Testing purposes only
var blue_tex = preload("res://Pieces/Blue Piece.png")
var blue_row = preload("res://Pieces/Blue Row.png")
var blue_col = preload("res://Pieces/Blue Column.png")
var blue_adj = preload("res://Pieces/Blue Adjacent.png")

var Green_tex = preload("res://Pieces/Green Piece.png")
var Green_row = preload("res://Pieces/Green Row.png")
var Green_col = preload("res://Pieces/Green Column.png")
var Green_adj = preload("res://Pieces/Green Adjacent.png")

var Orange_tex = preload("res://Pieces/Orange Piece.png")
var Orange_row = preload("res://Pieces/Orange Row.png")
var Orange_col = preload("res://Pieces/Orange Column.png")
var Orange_adj = preload("res://Pieces/Orange Adjacent.png")

var Pink_tex = preload("res://Pieces/Pink Piece.png")
var Pink_row = preload("res://Pieces/Pink Row.png")
var Pink_col = preload("res://Pieces/Pink Column.png")
var Pink_adj = preload("res://Pieces/Pink Adjacent.png")

var Light_Green_tex = preload("res://Pieces/Light Green Piece.png")
var Light_Green_row = preload("res://Pieces/Light Green Row.png")
var Light_Green_col = preload("res://Pieces/Light Green Column.png")
var Light_Green_adj = preload("res://Pieces/Light Green Adjacent.png")

var Yellow_tex = preload("res://Pieces/Yellow Piece.png")
var Yellow_row = preload("res://Pieces/Yellow Row.png")
var Yellow_col = preload("res://Pieces/Yellow Column.png")
var Yellow_adj = preload("res://Pieces/Yellow Adjacent.png")

var possible_colors = ["blue","green", "orange", "yellow", "pink", "light_green"]
var plain_texture

func make_color(new_color):
	matched = false;
	color = new_color

	get_node("Sprite").set_texture(blue_tex)
	
	if new_color == "blue":
		plain_texture = blue_tex
		row_texture = blue_row
		column_texture = blue_col
		adjacent_texture = blue_adj
	elif new_color == "green":
		plain_texture = Green_tex
		row_texture = Green_row
		column_texture = Green_col
		adjacent_texture = Green_adj 
	elif new_color == "pink":
		plain_texture = Pink_tex
		row_texture = Pink_row
		column_texture = Pink_col
		adjacent_texture = Pink_adj 
	elif new_color == "orange":
		plain_texture = Orange_tex
		row_texture = Orange_row
		column_texture = Orange_col
		adjacent_texture = Orange_adj 
	elif new_color == "light_green":
		plain_texture = Light_Green_tex
		row_texture = Light_Green_row
		column_texture = Light_Green_col
		adjacent_texture = Light_Green_adj 
		
	elif new_color == "yellow":
		plain_texture = Yellow_tex
		row_texture = Yellow_row
		column_texture = Yellow_col
		adjacent_texture = Yellow_adj 
		
	if is_row_bomb: 
		make_row_bomb()
	if is_column_bomb:
		make_column_bomb()
	if is_color_bomb:
		make_color_bomb()
	if is_adjacent_bomb:
		make_adjacent_bomb()
	else:
		make_plain()
		
		


var move_tween;
var matched = false;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	plain_texture =$Sprite.texture
	move_tween = get_node("move_tween");

	
	

func move(target):
	
	move_tween.interpolate_property(self, "position", position, target, .3, Tween.TRANS_SINE, Tween.EASE_OUT);
	move_tween.start();

func dim():
	var sprite = get_node("Sprite");
	sprite.modulate = Color(1,1,1,.5);



#Sprites are modulated back to regular alpha 
#because these functions happen after they are dimmed first
	
	
func make_column_bomb():
	
	if(!is_row_bomb && !is_color_bomb):
		is_column_bomb = true;
		is_row_bomb = false;
		is_color_bomb = false;
		is_adjacent_bomb = false;
		
		$Sprite.texture = column_texture;
		$Sprite.modulate = Color(1,1,1,1);
		matched = false
	
func make_row_bomb():
	
	if(!is_column_bomb && !is_color_bomb):
		is_column_bomb = false;
		is_row_bomb = true;
		is_color_bomb = false;
		is_adjacent_bomb = false;
	
		$Sprite.texture = row_texture;
		$Sprite.modulate = Color(1,1,1,1);
		matched = false
	
func make_adjacent_bomb():
	
	if(!is_column_bomb && !is_row_bomb && !is_color_bomb):
		is_column_bomb = false;
		is_row_bomb = false;
		is_color_bomb = false;
		is_adjacent_bomb = true;
		
		$Sprite.texture = adjacent_texture;
		$Sprite.modulate = Color(1,1,1,1);
		matched = false
	
func make_color_bomb():
	is_color_bomb = true;
	is_column_bomb = false;
	is_row_bomb = false;	
	is_adjacent_bomb = false;
	
	$Sprite.texture = color_bomb_texture;
	$Sprite.modulate = Color(1,1,1,1);
	color = "color"
	matched = false;
	
func make_plain():
	is_column_bomb = false;
	is_row_bomb = false;
	is_color_bomb = false;
	is_adjacent_bomb = false;
	
	if color == "color":
		randomize()
		make_color(possible_colors[randi() % possible_colors.size()]);
	else:
		$Sprite.texture = plain_texture

