class_name KeyItemInfo
extends ItemInfo

@export var id: String

func _on_pickup(player: Player, item: Item):
	var should_pickup := player.weapon.current_ammo < player.weapon.max_ammo

	if not should_pickup:
		return

	player.keys.pickup_key(self)
	item.queue_free()
