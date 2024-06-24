extends Node

@export var health: Health


func _ready():
	# TODO : Fancy death screen
	health.on_died.connect(func(): call_deferred("_die"))


func _die():
	LevelLoader.reload_last_level()
