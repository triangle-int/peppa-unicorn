class_name PlayerShooting
extends Node3D

const RAY_LENGTH = 1000

signal on_ammo_updated(ammo: int)

@export var rounds_per_shot: int = 12
@export var max_ammo_in_magazine: int = 2
@export var max_ammo: int = 32
@export var start_ammo: int = 8
@export var spread_angle: float = 30

var current_ammo: int


func _init():
	update_ammo(start_ammo)

func _input(event: InputEvent):
	if !event.is_action_pressed("shoot"):
		return

	shoot()

func shoot():
	if current_ammo <= 0:
		# TODO : IDK do something that indicates that there's 0 ammo
		return

	update_ammo(current_ammo - 1)
	var forward = -global_transform.basis.z

	for i in range(rounds_per_shot):
		var direction = Math.random_vector_in_unit_cone(forward, deg_to_rad(spread_angle))
		DebugDraw3D.draw_ray(global_position, direction, 10, Color.RED, INF)
		var hit = RayCast.cast(
			self,
			global_position,
			global_position + direction * RAY_LENGTH,
			func(obj): return obj as Damageable
		)

		if hit != null:
			hit.collider.deal_damage(1)

func update_ammo(ammo: int):
	current_ammo = ammo
	on_ammo_updated.emit(current_ammo)
