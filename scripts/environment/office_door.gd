extends Node

@export var open_position: Vector3
@export var wall: Node3D
@export var movement_speed: float

var _initial_position: Vector3
var _player_in_area: bool = false
var _intro_ready: bool = false


func _ready():
	_initial_position = wall.position
	if not LevelLoader.intro_finished:
		$AnimationPlayer.play("intro_dialogue")


func _physics_process(delta: float):
	var target_position = open_position if _intro_ready else _initial_position
	wall.position = wall.position.move_toward(target_position, delta * movement_speed)


func _on_area_3d_body_entered(body: Node3D):
	var movement = body as PlayerMovement

	if movement == null:
		return
	
	if LevelLoader.intro_finished:
		return
	
	_player_in_area = true


func _on_area_3d_body_exited(body):
	pass
	#if body as PlayerMovement == null:
		#return
#
	#_player_in_area = false

func play_sweet_home():
	$SweetHome.play()


func _on_sweet_home_finished():
	if not _player_in_area:
		$SweetHome.play()
		return
	
	$Reznya.play()
	_intro_ready = true
	LevelLoader.intro_finished = true
