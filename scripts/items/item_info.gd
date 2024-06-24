class_name ItemInfo
extends Resource

@export var icon: Texture2D
@export var name: String


func pickup(player: Player, item: Item):
	_on_pickup(player, item)


func _on_pickup(_player: Player, _item: Item):
	pass
