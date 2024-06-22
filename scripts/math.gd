class_name Math
extends Object

static func random_vector_in_unit_cone(direction: Vector3, angle: float) -> Vector3:
	var dir_z = direction
	var dir_x = dir_z.cross(Vector3.UP).normalized()
	var dir_y = dir_z.cross(dir_x)

	var z = randf_range(cos(angle), 1)
	var r = sqrt(1 - z ** 2)
	var rot = randf_range(0, 2 * PI)
	var x = r * cos(rot)
	var y = r * sin(rot)

	return z * dir_z + x * dir_x + y * dir_y
