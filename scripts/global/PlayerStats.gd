extends Node

var key_count: int
var touching_object: Dictionary
var looking_object: Dictionary

func _ready() -> void:
	key_count = 0
	touching_object = {}
	looking_object = {}

func _process(_delta) -> void:
	pass
