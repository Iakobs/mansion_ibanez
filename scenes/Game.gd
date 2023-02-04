extends Spatial

export(float) var day_night_cycle_speed_ratio := 0.1

onready var animation_player: AnimationPlayer = $"%AnimationPlayer"

func _ready() -> void:
	Global.game_is_running = true
	animation_player.play("day_night_cycle", -1, day_night_cycle_speed_ratio)
	animation_player.advance(10 / day_night_cycle_speed_ratio)

func _on_dead_zone_body_entered(body: PhysicsBody) -> void:
	if body.has_method("_on_dead_zone_entered"):
		body._on_dead_zone_entered()
	elif body.owner.has_method("_on_dead_zone_entered"):
		body.owner._on_dead_zone_entered()
