extends Control

onready var key_count: Label = $"%key_count"
onready var time: Label = $"%time"

func _ready() -> void:
	key_count.text = str(PlayerStats.key_count)
	var _err := Events.connect("collectible_collected", self, "on_collectible_collected")
	_err = Events.connect("collectible_consumed", self, "on_collectible_consumed")

func _process(_delta: float) -> void:
	time.text = Global.get_in_game_hour()

func on_collectible_collected(_payload := {}) -> void:
	update_keys_count()

func on_collectible_consumed(_payload := {}) -> void:
	update_keys_count()

func update_keys_count() -> void:
	key_count.text = str(PlayerStats.key_count)
