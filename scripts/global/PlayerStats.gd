extends Node

var key_count: int
var looking_object: Dictionary
var touching_object: Dictionary
var touching_point: Vector3

func _ready() -> void:
	key_count = 0
	touching_object = {}
	looking_object = {}
	touching_point = Vector3.ZERO

func _process(_delta) -> void:
	pass
