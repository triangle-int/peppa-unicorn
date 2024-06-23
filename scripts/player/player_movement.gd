class_name PlayerMovement
extends CharacterBody3D

@export var player: Player
@export var hook: PlayerHook

@export var floor_acceleration = 50.0
@export var air_acceleration = 20.0

## How fast player will lose their velocity on the ground
@export_range(0.0, 1.0, 0.01) var floor_friction = 0.1
## How fast player will lose their velocity in the air
@export_range(0.0, 1.0, 0.01) var air_friction = 0.02

@export var contr_direction_multiplier = 10.0

@export var jump_height = 1.5

@export var wall_jump_speed = 20.0
@export var wall_jump_angle = 30.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var _jump_velocity: float
var _wall_jump_done := false


func _ready():
	_jump_velocity = sqrt(2 * gravity * jump_height)

func _physics_process(delta):
	if hook.is_hooked():
		move_and_slide()
		return

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = _jump_velocity

	if Input.is_action_just_pressed("jump")\
	and is_on_wall()\
	and not is_on_floor()\
	and !_wall_jump_done:
		_wall_jump_done = true
		var normal = get_wall_normal()
		var jump_dir = normal.rotated(normal.cross(Vector3.UP).normalized(), deg_to_rad(wall_jump_angle))
		velocity.y = 0
		velocity += jump_dir * wall_jump_speed

	# Applying friction
	if is_on_floor():
		_wall_jump_done = false
		velocity.x *= 1 - floor_friction
		velocity.z *= 1 - floor_friction
	else: 
		velocity.x *= 1 - air_friction
		velocity.z *= 1 - air_friction

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var velocity_to_add = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if is_on_floor():
		velocity_to_add *= floor_acceleration * delta
	else:
		velocity_to_add *= air_acceleration * delta

	var contr_multiplier_x = 1.0
	if (velocity.x < 0 and velocity_to_add.x > 0) or (velocity.x > 0 and velocity_to_add.x < 0):
		contr_multiplier_x = contr_direction_multiplier
	var contr_multiplier_z = 1.0
	if (velocity.z < 0 and velocity_to_add.z > 0) or (velocity.z > 0 and velocity_to_add.z < 0):
		contr_multiplier_z = contr_direction_multiplier

	velocity.x += velocity_to_add.x * contr_multiplier_x
	velocity.z += velocity_to_add.z * contr_multiplier_z

	move_and_slide()

# This is absolutely horrific but this language doesn't allow interfaces
func deal_damage(damage: int):
	player.health.deal_damage(damage)
