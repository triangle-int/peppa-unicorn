class_name Health
extends Node

signal on_died()
signal on_health_updated(health: int)

@export var start_health: int

var health: int

func _init():
	health = start_health

func deal_damage(damage: int):
	# TODO: Remove this
	print("Received %d damage" % damage)
	health -= damage

	if health <= 0:
		on_died.emit()
		return

	on_health_updated.emit(health)
