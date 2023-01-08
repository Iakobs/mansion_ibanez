class_name Key
extends Interacter

func _ready() -> void:
	action = tr("ACTION_PICK")

func _process(_delta: float) -> void:
	if inside_interactable and Input.is_action_just_released("primary_action"):
		Events.emit_signal("collectible_collected",
			{ collectibles = [Events.collectibles.key] })
		queue_free()

func _to_string() -> String:
	return tr("KEY_NAME")
