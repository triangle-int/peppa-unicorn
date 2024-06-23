extends Node

@export var target_level: int


func _on_body_entered(body: Node3D):
	if body as PlayerMovement == null:
		return

	call_deferred("_switch_level")

func _switch_level():
	LevelLoader.load_level(target_level)
