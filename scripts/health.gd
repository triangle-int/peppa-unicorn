class_name Health
extends Node

signal on_died()
signal on_health_updated(health: int)

@export var start_health: int

var health: int

func _ready():
	health = start_health
	on_health_updated.emit(health)

func deal_damage(damage: int):
	health -= damage

	if health <= 0:
		on_died.emit()
		return

	on_health_updated.emit(health)
