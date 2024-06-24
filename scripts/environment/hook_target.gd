class_name HookTarget
extends Node3D


func _on_activation_area_body_entered(body):
	var player = body as PlayerMovement
	if player != null:
		var hook = player.player.hook
		hook.all_targets.push_back(self)


func _on_activation_area_body_exited(body):
	var player = body as PlayerMovement
	if player != null:
		var hook = player.player.hook
		hook.all_targets.erase(self)


func select():
	$Sprite3D.scale = Vector3.ONE * 5.0
	$Sprite3D.frame = 1


func unselect():
	$Sprite3D.scale = Vector3.ONE * 2.5
	$Sprite3D.frame = 0
