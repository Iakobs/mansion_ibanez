extends Area

onready var collision: CollisionShape = $"%CollisionShape"

func set_length(value: float) -> void:
	collision.shape.length = value
