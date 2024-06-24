extends Node3D

@export var state_chart: StateChart
@export var movement: EnemyMovement
@export var weapon: EnemyWeapon
@export var attack_range: float

var player_detected: Player
var players_in_radius: Array[Player]


func _on_idle_state_physics_processing(_delta: float):
	for player in players_in_radius:
		if !_is_player_in_sight(player):
			continue

		player_detected = player
		state_chart.send_event("player_in_sight")
		break


func _is_player_in_sight(player: Player) -> bool:
	var hit = RayCast.cast(
		self, global_position, player.global_position, func(obj): return obj as PlayerMovement
	)

	if hit == null:
		return false

	return hit.collider.player == player


func _on_walking_state_physics_processing(delta: float):
	if player_detected == null:
		# This should never happen right now but it can be useful
		# to stop following a player for some reason
		return

	if (
		(player_detected.global_position - global_position).length() < attack_range
		and _is_player_in_sight(player_detected)
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


func _on_player_detection_area_body_entered(body: Node3D):
	var player_movement = body as PlayerMovement

	if player_movement != null:
		players_in_radius.push_back(player_movement.player)


func _on_player_detection_area_body_exited(body):
	var player_movement = body as PlayerMovement

	if player_movement != null:
		players_in_radius.erase(player_movement.player)
