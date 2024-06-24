extends AudioStreamPlayer3D

var played_in_this_frame = false

func _process(delta):
	played_in_this_frame = false

func _on_health_on_damaged(amount):
	if played_in_this_frame:
		return
	play()
	played_in_this_frame = true
