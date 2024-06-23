class_name PlayerShooting
extends Node3D

const RAY_LENGTH = 1000

signal on_ammo_updated(current_ammo_in_magazine: int, ammo: int)
signal on_reload
signal on_shoot

@export var rounds_per_shot: int = 12
@export var max_ammo_in_magazine: int = 2
@export var max_ammo: int = 32
@export var start_ammo: int = 8
@export var spread_angle: float = 6
@export var damage: int = 5

var current_ammo_in_magazine: int
var current_ammo: int


func _init():
	update_ammo(start_ammo)
	update_ammo_in_magazine(max_ammo_in_magazine)

func _input(event: InputEvent):
	if event.is_action_pressed("shoot"):
		shoot()

	if event.is_action_pressed("reload"):
		reload()

func shoot():
	if not $ShootTimer.is_stopped():
		return

	if current_ammo_in_magazine <= 0:
		# TODO : IDK do something that indicates that there's 0 ammo
		return

	update_ammo_in_magazine(current_ammo_in_magazine - 1)
	var forward = -global_transform.basis.z

	on_shoot.emit()
	$ShootTimer.start()
	
	for i in range(rounds_per_shot):
		var direction = Math.random_vector_in_unit_cone(forward, deg_to_rad(spread_angle))
		# DebugDraw3D.draw_ray(global_position, direction, 10, Color.RED, 5)
		var hit = RayCast.cast(
			self,
			global_position,
			global_position + direction * RAY_LENGTH,
			func(obj): return obj if "deal_damage" in obj else null
		)

		if hit != null:
			hit.collider.deal_damage(damage)

func update_ammo(ammo: int):
	current_ammo = ammo
	on_ammo_updated.emit(current_ammo_in_magazine, current_ammo)

func update_ammo_in_magazine(ammo: int):
	current_ammo_in_magazine = ammo
	on_ammo_updated.emit(current_ammo_in_magazine, current_ammo)

func reload():
	if current_ammo <= 0 or current_ammo_in_magazine >= max_ammo_in_magazine:
		return

	on_reload.emit()
	$ReloadTimer.start()
	await $ReloadTimer.timeout

	var added = min(max_ammo_in_magazine - current_ammo_in_magazine, current_ammo)
	update_ammo(current_ammo - added)
	update_ammo_in_magazine(current_ammo_in_magazine + added)
