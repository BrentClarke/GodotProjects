extends KinematicBody2D

class_name PlayerDetection

const RED =  Color(1,.25,.25)
const WHITE = Color(1,1,1)

const FOV_TOLERANCE = 22
const MAX_DETECTION_RANGE = 185

#onready var Player = Global.Player

func lightChange(NPC, flashlight):
		if Player_is_in_FOV_TOLERANCE(NPC) && Player_in_LOS(NPC):
			flashlight.color = RED
			Global.SuspicionMeter.player_seen()
		else:
			flashlight.color = WHITE
		
		
func Player_is_in_FOV_TOLERANCE(NPC):
	var NPC_facing_direction = Vector2(1,0).rotated(NPC.global_rotation)
	var direction_to_Player = (Global.Player.position - NPC.global_position).normalized()
	
	if abs(direction_to_Player.angle_to(NPC_facing_direction)) < deg2rad(FOV_TOLERANCE):
		return true
	else:
		return false

func Player_in_LOS(NPC):
	var space = NPC.get_world_2d().direct_space_state;
	var LOS_obstacle = space.intersect_ray(NPC.global_position, Global.Player.position, [self], collision_mask)
	
	
	var distance_to_player = Global.Player.global_position.distance_to(NPC.global_position)
	var Player_in_range = distance_to_player < MAX_DETECTION_RANGE 
	
	if not LOS_obstacle:
		return false
		
	if (LOS_obstacle.collider == Global.Player) and Player_in_range:
		return true
	else:
		return false


	


