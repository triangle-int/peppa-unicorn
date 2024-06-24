class_name KeyItemInfo
extends ItemInfo

@export var id: String


func _on_pickup(player: Player, item: Item):
	player.keys.pickup_key(self)
	item.queue_free()
