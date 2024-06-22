extends ItemInfo

@export var rounds: int = 10

func _on_pickup(player: Player, item: Item):
	var should_pickup := player.weapon.current_ammo < player.weapon.max_ammo

	if not should_pickup:
		return

	player.weapon.current_ammo = min(player.weapon.current_ammo + rounds, player.weapon.max_ammo)
	item.queue_free()
