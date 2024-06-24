extends Node3D

signal on_attack

@export var state_chart: StateChart
@export var movement: EnemyMovement
@export var player_detection_area: Area3D
@export var player_attack_area: Area3D

@export var attack_cooldown: float
@export var attack_damage: int

@export var charging_time: float
@export var charging_cooldown: float
@export var charging_damage: int
@export var charging_speed_modifier: float

var player_detected: PlayerMovement
var attack_on_cooldown := false


func _on_idle_state_physics_processing(delta: float):
	movement.stop_moving(delta)
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


func _on_attacking_state_physics_processing(delta: float):
	if player_detected == null:
		return

	movement.move_towards(delta, player_detected.global_position)


func _on_attacking_state_processing(_delta: float):
	if !player_attack_area.overlaps_body(player_detected):
		return

	_attack()


func _attack():
	if attack_on_cooldown:
		return

	var damage = charging_damage if $StateChart/Root/Attacking/Charging.active else attack_damage
	player_detected.deal_damage(damage)
	state_chart.send_event("stop_charging")

	attack_on_cooldown = true
	await get_tree().create_timer(attack_cooldown).timeout
	attack_on_cooldown = false


func _on_normal_state_entered():
	$"../Sprite3D".modulate = Color.WHITE
	await get_tree().create_timer(charging_cooldown).timeout
	state_chart.send_event("start_charging")


func _on_charging_state_entered():
	$"../Sprite3D".modulate = Color.ORANGE_RED
	movement.speed *= charging_speed_modifier
	await get_tree().create_timer(charging_time).timeout
	movement.speed /= charging_speed_modifier
	state_chart.send_event("stop_charging")
