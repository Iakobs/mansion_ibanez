extends Control

onready var keys_count: Label = $"%keys_count"

func _ready() -> void:
	keys_count.text = str(PlayerStats.key_count)
	Events.connect("collectible_collected", self, "on_collectible_collected")
	Events.connect("collectible_consumed", self, "on_collectible_consumed")

func on_collectible_collected(payload := {}) -> void:
	PlayerStats.key_count += 1
	update_keys_count()

func on_collectible_consumed(payload := {}) -> void:
	update_keys_count()

func update_keys_count() -> void:
	keys_count.text = str(PlayerStats.key_count)
