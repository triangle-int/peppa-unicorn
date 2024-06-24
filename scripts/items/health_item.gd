class_name HealthItemInfo
extends ItemInfo

@export var health: int = 50


func _on_pickup(player: Player, item: Item):
	var should_pickup := player.health.health < player.health.start_health

	if not should_pickup:
		return

	player.health.heal(health)
	item.queue_free()
