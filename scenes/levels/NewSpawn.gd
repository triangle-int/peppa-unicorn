extends Node3D


func _ready():
	if LevelLoader.intro_finished:
		$"../../Slayer".global_position = global_position
		$"../../Slayer".global_rotation = global_rotation
