extends Node

@export var jump_height = 4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var _jump_velocity: float


func _ready():
	_jump_velocity = sqrt(2 * gravity * jump_height)


func _on_area_3d_body_entered(body):
	body = body as CharacterBody3D

	if body == null:
		return

	body.velocity.y = _jump_velocity
