extends Spatial

func _ready() -> void:
	pass

func _on_dead_zone_body_entered(body: PhysicsBody) -> void:
	if body.has_method("_on_dead_zone_entered"):
		body._on_dead_zone_entered()
	elif body.owner.has_method("_on_dead_zone_entered"):
		body.owner._on_dead_zone_entered()
