extends Control

onready var key_count: Label = $"%key_count"

func _ready() -> void:
	key_count.text = str(PlayerStats.key_count)
	var _err := Events.connect("collectible_collected", self, "on_collectible_collected")
	_err = Events.connect("collectible_consumed", self, "on_collectible_consumed")

func on_collectible_collected(_payload := {}) -> void:
	update_keys_count()

func on_collectible_consumed(_payload := {}) -> void:
	update_keys_count()

func update_keys_count() -> void:
	key_count.text = str(PlayerStats.key_count)
