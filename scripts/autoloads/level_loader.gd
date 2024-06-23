extends Node

@export var levels: Array[PackedScene]

var _last_level: int

func load_level(level_index: int):
	var level = levels[level_index]
	_last_level = level_index
	get_tree().change_scene_to_packed(level)

func reload_last_level():
	load_level(_last_level)
