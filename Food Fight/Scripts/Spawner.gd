extends Spatial

var bystander_speed = 8
export var max_wait_time = 5

var bystanders
var meshes


func _enter_tree():
	meshes = file_grabber.get_files("res://Models/BystanderMeshes/")
	randomize()
	set_timer()
	
func set_timer():
	$Timer.wait_time =  randi() % max_wait_time + 1
	$Timer.start()
	


func _on_Timer_timeout():
	spawn_bystander()
	set_timer()
	
func spawn_bystander():
	var bystander = load("res://Models/BystanderScenes/BystanderTemplate.tscn").instance()
	var random_mesh = meshes[randi() % meshes.size()]
	
	add_child(bystander)
	bystander.get_child(1).mesh = load(random_mesh)
	
	bystander.set_as_toplevel(true)
	bystander.set_transform($Forward.get_global_transform())
	bystander.set_linear_velocity($Forward.get_global_transform().basis[0].normalized() * bystander_speed)
