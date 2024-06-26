extends Node

@export var key_id: String
@export var finish_door: bool
@export var always_open: bool
@export var open_position: Vector3
@export var wall: Node3D
@export var movement_speed: float

var _initial_position: Vector3
var _player_in_area: bool = false


func _ready():
	_initial_position = wall.position


func _physics_process(delta: float):
	var target_position = open_position if _player_in_area else _initial_position
	wall.position = wall.position.move_toward(target_position, delta * movement_speed)


func _on_area_3d_body_entered(body: Node3D):
	var movement = body as PlayerMovement

	if movement == null:
		return
	
	if finish_door:
		var enemies = get_tree().get_nodes_in_group("enemies")
		if len(enemies) == 0:
			_player_in_area = true
	elif always_open:
		_player_in_area = true
	elif movement.player.keys.has_key(key_id):
		_player_in_area = true


func _on_area_3d_body_exited(body):
	if body as PlayerMovement == null:
		return

	_player_in_area = false
