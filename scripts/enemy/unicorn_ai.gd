extends Node3D

@export var state_chart: StateChart
@export var movement: EnemyMovement
@export var player_detection_area: Area3D
@export var weapon: EnemyWeapon
@export var attack_range: float

var player_detected: PlayerMovement


func _on_idle_state_physics_processing(_delta: float):
	var players = (
		player_detection_area
		. get_overlapping_bodies()
		. filter(func(node: Node3D): return node as PlayerMovement != null)
		. map(func(node: Node3D): return node as PlayerMovement)
	)

	for player in players:
		if !RayCast.is_player_in_sight(self, player):
			continue

		player_detected = player
		state_chart.send_event("player_in_sight")
		break


func _on_walking_state_physics_processing(delta: float):
	if player_detected == null:
		# This should never happen right now but it can be useful
		# to stop following a player for some reason
		return

	if (
		(player_detected.global_position - global_position).length() < attack_range
		and RayCast.is_player_in_sight(self, player_detected)
	):
		state_chart.send_event("player_in_range")
		return

	movement.move_towards(delta, player_detected.global_position)


func _on_non_walking_state_physics_processing(delta: float):
	movement.stop_moving(delta)


func _on_shooting_state_entered():
	weapon.shoot((player_detected.global_position - global_position).normalized())
	await weapon.finished_shooting
	state_chart.send_event("finished_shooting")
