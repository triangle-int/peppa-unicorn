extends Node

@export var panel: Control


func _input(event: InputEvent):
	if !event.is_action_pressed("pause"):
		return

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	panel.show()
	get_tree().paused = true


func _on_resume_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	panel.hide()
	get_tree().paused = false


func _on_restart_pressed():
	get_tree().paused = false
	LevelLoader.reload_last_level()
