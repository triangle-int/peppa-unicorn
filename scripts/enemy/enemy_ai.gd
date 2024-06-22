extends Node

@export var state_chart: StateChart
@export var movement: EnemyMovement

var player_detected: Player

func _on_idle_state_physics_processing(delta):
	
	pass # Replace with function body.

func _on_walking_state_physics_processing(delta: float):
	if player_detected == null:
		# This should never happen right now but it can be useful
		# to stop following a player for some reason
		return

	movement.move_towards(delta, player_detected.global_position)

func _on_shooting_state_entered():
	pass # Replace with function body.
