class_name RayCast
extends Object


class HitInfo:
	var collider: Object
	var result: Dictionary

	func _init(col: Object, res: Dictionary):
		collider = col
		result = res


static func cast(
	node: Node3D, origin: Vector3, target: Vector3, type_transform: Callable
) -> HitInfo:
	var space_state = node.get_world_3d().direct_space_state
	var query = (
		PhysicsRayQueryParameters3D
		. create(
			origin,
			target,
		)
	)
	var result = space_state.intersect_ray(query)

	if result.is_empty():
		return null

	var transformed = type_transform.call(result.collider)

	if transformed == null:
		return null

	return HitInfo.new(transformed, result)
