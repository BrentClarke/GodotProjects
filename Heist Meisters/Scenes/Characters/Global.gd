
extends Node
#warnings-disable
var Player
var navigation
var destinations
var SuspicionMeter
var DisguiseList
# Asset Links - MUST BE CHANGED MANUALLY

var nightvision_on_sfx = "res://SFX/nightvision.wav"
var nightvision_off_sfx = "res://SFX/nightvision_off.wav"

var red_light = "res://GFX/Interface/PNG/dotRed.png"
var green_light = "res://GFX/Interface/PNG/dotGreen.png"

var player_sprite = "res://GFX/PNG/Hitman 1/hitman1_stand.png"
var player_collision = "res://Scenes/Characters/PlayerCollision.tres"
var player_collision_transform_x = -2.151
var player_occluder = "res://Scenes/Characters/PlayerOccluder.tres"

var box_sprite = "res://GFX/PNG/Tiles/tile_129.png"
var box_collision = "res://Scenes/Characters/box_collision.tres"
var box_collision_transform_x = 0
var box_occluder = "res://Scenes/Characters/BoxOccluder.tres"

var briefcase_sprite = "res://GFX/Loot/suitcase.png"

# Scene links
var Level1 = "res://Scenes/Levels/Level 1.tscn"
var TutorialMessages = "res://Scenes/Levels/TutorialMessages.json"
var GameOverScreen = "res://Scenes/Characters/GameOverScreen.tscn"
var VictoryScreen = "res://Scenes/Characters/VictoryScreen.tscn"