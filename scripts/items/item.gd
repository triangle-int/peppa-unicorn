extends Node
class_name Item

@export var info: ItemInfo


func _on_body_entered(body):
	var movement = body as PlayerMovement

	if movement == null:
		return

	info.pickup(movement.player, self)
