extends Node

@export var player: PlayerMovement

@onready var health_label = $Health
@onready var ammo_label = $Ammo

var _player: Player

func _ready():
	_player = player.player
	_player.weapon.on_ammo_updated.connect(_on_ammo_updated)
	_player.health.on_health_updated.connect(_on_health_updated)

	_on_ammo_updated(_player.weapon.current_ammo_in_magazine, _player.weapon.current_ammo)
	_on_health_updated(_player.health.health)

func _on_ammo_updated(current_ammo_in_magazine: int, ammo: int):
	ammo_label.text = "%d / %d \n%d / %d" % [
		current_ammo_in_magazine,
		_player.weapon.max_ammo_in_magazine,
		ammo,
		_player.weapon.max_ammo
	]

func _on_health_updated(health: int):
	health_label.text = "%d / %d" % [health, _player.health.start_health]
