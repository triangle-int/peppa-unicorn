extends Node

@export var health: Health


func _ready():
	# TODO : Fancy death screen
	health.on_died.connect(func(): LevelLoader.reload_last_level())
