class_name PlayerHook
extends Node3D

@export var character: CharacterBody3D
@export var speed: float
@export var unhook_distance: float
@export var hook_angle: float

var _all_targets: Array[HookTarget]
var _current_target: HookTarget


func _on_body_entered(body: Node3D):
	if body as HookTarget == null:
		return

	_all_targets.push_back(body)


func _on_body_exited(body: Node3D):
	if body as HookTarget == null:
		return

	_all_targets.erase(body)


func _compare(_target1: HookTarget, _target2: HookTarget) -> bool:
	var dir1 = (_target1.global_position - global_position).normalized()
	var dir2 = (_target2.global_position - global_position).normalized()
	var dot1 = dir1.dot(-global_basis.z)
	var dot2 = dir2.dot(-global_basis.z)
	return dot1 > dot2


func _check_target(target: HookTarget):
	var direction = target.global_position - global_position
	return (
		direction.angle_to(-global_basis.z) < deg_to_rad(hook_angle)
		and direction.length() > unhook_distance
	)


func _input(event):
	if event.is_action_pressed("hook"):
		var targets = _all_targets.filter(_check_target)
		targets.sort_custom(_compare)

		for target in targets:
			var target_visible = (
				RayCast.cast(
					self, global_position, target.global_position, func(h): return h as HookTarget
				)
				!= null
			)

			if !target_visible:
				continue

			_current_target = target
			break
	if event.is_action_released("hook"):
		_current_target = null


func _physics_process(_delta: float):
	if !is_hooked():
		return

	var direction = _current_target.global_position - global_position
	character.velocity = direction.normalized() * speed

	if direction.length() <= unhook_distance:
		_current_target = null


func is_hooked() -> bool:
	return _current_target != null
