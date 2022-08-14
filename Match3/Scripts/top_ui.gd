extends TextureRect

onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
onready var counter_label = $MarginContainer/HBoxContainer/CounterLabel

var score =0;
var current_count = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_grid_update_score(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_grid_update_score(points):
	
	score += points
	
	score_label.text = String(score)


func _on_grid_update_counter(amount_to_change = -1):
	current_count += amount_to_change;
	counter_label.text = String(current_count);
