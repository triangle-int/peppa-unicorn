class_name Projectile
extends Node3D

const MAX_LIFETIME = 60

@export var speed: float
@export var damage: float

var direction: Vector3
var creator: Object
var lived: float = 0.0

func _on_area_3d_body_entered(body: Object):
	if body == creator:
		return

	if !("deal_damage" in body):
		queue_free()
		return

	body.deal_damage(damage)
	queue_free()

func _physics_process(delta: float):
	lived += delta

	if lived >= MAX_LIFETIME:
		queue_free()

	translate(direction * speed * delta)
