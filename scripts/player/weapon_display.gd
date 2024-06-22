extends AnimatedSprite2D


func _on_shooting_point_on_reload():
	play("reload")

func _on_shooting_point_on_shoot():
	play("shoot")
