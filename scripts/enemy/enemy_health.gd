extends Node3D

@export var health: Health
@export var movement: EnemyMovement
@export var damage_particles: PackedScene


func _ready():
	health.on_health_updated.connect(_on_damaged)
	health.on_died.connect(func(): movement.queue_free())

func _on_damaged(_health: int):
	var node = damage_particles.instantiate()
	get_tree().root.add_child(node)
	node.global_position = global_position
