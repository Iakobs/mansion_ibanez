extends Spatial

export(float) var day_night_cycle_speed_ratio := 0.1
export(int) var starting_hour := 10

onready var animation_player: AnimationPlayer = $"%AnimationPlayer"

func _ready() -> void:
	Global.game_is_running = true
	animation_player.play("day_night_cycle", -1, day_night_cycle_speed_ratio)
	animation_player.advance(starting_hour / day_night_cycle_speed_ratio)

func _process(_delta: float) -> void:
	var current_day_night_cycle_position := animation_player.current_animation_position
	Global.in_game_decimal_hour = current_day_night_cycle_position

func _on_dead_zone_body_entered(body: PhysicsBody) -> void:
	if body.has_method("_on_dead_zone_entered"):
		body._on_dead_zone_entered()
	elif body.owner.has_method("_on_dead_zone_entered"):
		body.owner._on_dead_zone_entered()

func notify_dawn() -> void:
	Events.emit_signal("dawn")

func notify_day() -> void:
	Events.emit_signal("day")

func notify_sunset() -> void:
	Events.emit_signal("sunset")

func notify_night() -> void:
	Events.emit_signal("night")
