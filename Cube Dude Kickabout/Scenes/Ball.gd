extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Spawn_Point = Vector3()
var PitchX = 0
var PitchZ = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Spawn_Point = self.translation
	PitchX = Global.PitchCollision.shape.extents.x +1
	PitchZ = Global.PitchCollision.shape.extents.z +1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	stay_in_bounds()
	

func _on_Ball_body_shape_entered(body_id, body, body_shape, local_shape):
	if body is KinematicBody and not $KickSound.is_playing():
		$KickSound.pitch_scale = randomizer()
		$KickSound.play()

func randomizer():
	randomize()
	return rand_range(1.00, 7.00)
	
func stay_in_bounds():
	
	if (self.translation.x > 0 and self.translation.x > PitchX):
			Global.Game.reset_pitch(self)
	elif (self.translation.x < 0 and self.translation.x <  -PitchX):
			Global.Game.reset_pitch(self)
	elif (self.translation.z > 0 and self.translation.x > PitchZ):
			Global.Game.reset_pitch(self)
	elif (self.translation.z < 0 and self.translation.x <  -PitchZ):
			Global.Game.reset_pitch(self)
	