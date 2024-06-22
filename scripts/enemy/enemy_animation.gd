extends AnimatedSprite3D


func _on_walking_state_entered():
	play("walk")


func _on_shooting_state_entered():
	play("shoot")
