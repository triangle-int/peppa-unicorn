class_name PlayerKeys
extends Node

# TODO : UI that shows found keys' images
signal keys_updated(keys: Array[KeyItemInfo])

var _picked_keys: Array[KeyItemInfo]


func pickup_key(key: KeyItemInfo):
	_picked_keys.push_back(key)
	keys_updated.emit(_picked_keys)

func has_key(key_id: String) -> bool:
	return _picked_keys.any(func(key): return key.id == key_id)
