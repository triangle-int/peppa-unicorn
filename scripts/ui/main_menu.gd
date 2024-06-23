extends Node

@export var first_level: int


func _on_start_button_pressed():
	LevelLoader.load_level(first_level)
