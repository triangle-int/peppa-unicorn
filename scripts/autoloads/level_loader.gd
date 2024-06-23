extends Node

@export var levels: Array[PackedScene]

func load_level(level_index: int):
	var level = levels[level_index]
	get_tree().change_scene_to_packed(level)
