extends Interacter

func _ready() -> void:
	action = tr("PICKABLE_ACTION")

func _process(_delta: float) -> void:
	if inside_interactable and Input.is_action_just_released("left_click"):
		Events.emit_signal("collectible_collected")
		queue_free()

func _to_string() -> String:
	return tr("KEY_NAME")
