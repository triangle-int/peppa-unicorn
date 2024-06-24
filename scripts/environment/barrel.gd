extends Node3D

@export var explosion_speed: float
@export var explosion_damage: float

var _affected_bodies: Array[CharacterBody3D]


func deal_damage(_damage: int):
	for body in _affected_bodies:
		var offset = body.global_position - global_position
		var length_squared = offset.length_squared()
		body.velocity = offset.normalized() * explosion_speed / length_squared
		body.deal_damage(ceili(explosion_damage / length_squared))

	queue_free()


func _on_area_3d_body_entered(body: Node3D):
	var character = body as CharacterBody3D

	if character == null or "deal_damage" not in body:
		return

	_affected_bodies.push_back(body)


func _on_area_3d_body_exited(body):
	_affected_bodies.erase(body as CharacterBody3D)
