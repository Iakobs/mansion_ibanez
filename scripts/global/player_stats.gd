extends Node

var key_count: int
var looking_object: Dictionary
var touching_object: Dictionary
var touching_point: Vector3

func _ready() -> void:
	var _err := Events.connect("collectible_collected", self, "_on_collectible_collected")
	_err = Events.connect("collectible_consumed", self, "_on_collectible_consumed")
	
	key_count = 0
	touching_object = {}
	looking_object = {}
	touching_point = Vector3.ZERO

func _on_collectible_collected(payload := {}) -> void:
	if Events.collectibles.key in payload.collectibles: key_count += 1

func _on_collectible_consumed(payload := {}) -> void:
	if Events.collectibles.key in payload.collectibles: key_count -= 1
