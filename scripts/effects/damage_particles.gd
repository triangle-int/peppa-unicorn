extends CPUParticles3D

@export var emit_time: float = 0.2


func _ready():
	var destroy_timeout = get_tree().create_timer(lifetime).timeout
	await get_tree().create_timer(emit_time).timeout
	emitting = false
	await destroy_timeout
	queue_free()
