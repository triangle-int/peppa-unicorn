extends AnimatedSprite3D


func _on_attack():
	play("shoot")
	await animation_finished
	play("walk")


func _on_attacking_state_entered():
	play("walk")
