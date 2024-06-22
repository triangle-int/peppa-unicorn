extends Node3D

@export var state_chart: StateChart
@export var state_root: CompoundState
@export var movement: EnemyMovement
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
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position,
		player.global_position,
	)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)

	if result.is_empty():
		return false

	var player_movement = result.collider as PlayerMovement

	if player_movement == null:
		return false

	return player_movement.player == player

func _on_walking_state_physics_processing(delta: float):
	if player_detected == null:
		# This should never happen right now but it can be useful
		# to stop following a player for some reason
		return

	if (player_detected.global_position - global_position).length() < attack_range\
		and _is_player_in_sight(player_detected):
		state_chart.send_event("player_in_range")
		return

	movement.move_towards(delta, player_detected.global_position)

func _on_non_walking_state_physics_processing(delta: float):
	movement.stop_moving(delta)

func _on_shooting_state_entered():
	# TODO : Actual attack
	print("Attacking!")
	await get_tree().create_timer(1).timeout
	print("Finished!")
	state_chart.send_event("finished_shooting")

func _on_player_detection_area_body_entered(body: Node3D):
	var player_movement = body as PlayerMovement

	if player_movement != null:
		players_in_radius.push_back(player_movement.player)

func _on_player_detection_area_body_exited(body):
	var player_movement = body as PlayerMovement

	if player_movement != null:
		players_in_radius.erase(player_movement.player)
