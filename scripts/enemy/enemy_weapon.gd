class_name EnemyWeapon
extends Node3D

signal finished_shooting()

@export var movement: EnemyMovement
@export var projectile_scene: PackedScene


func shoot(direction: Vector3):
	var projectile = projectile_scene.instantiate() as Projectile
	projectile.direction = direction
	projectile.creator = movement

	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position

	await get_tree().create_timer(1).timeout
	finished_shooting.emit()
