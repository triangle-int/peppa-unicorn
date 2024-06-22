class_name EnemyMovement
extends CharacterBody3D

@export var speed: float = 5.0
@export var acceleration: float = 20.0

@export var agent: NavigationAgent3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()

func move_towards(delta: float, target: Vector3):
	agent.target_position = target
	var direction = agent.get_next_path_position() - global_position
	direction.y = 0
	direction = direction.normalized()

	velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
