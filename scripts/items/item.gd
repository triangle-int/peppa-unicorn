class_name Item
extends Node3D

@export var info: ItemInfo
@export var height_amplitude = 0.5
@export var frequency = 0.6

@onready var start_y = position.y

func _on_body_entered(body):
	var movement = body as PlayerMovement

	if movement == null:
		return

	info.pickup(movement.player, self)


func _process(delta):
	position.y = start_y + sin(Time.get_ticks_msec() / 1000.0 * frequency) * height_amplitude
