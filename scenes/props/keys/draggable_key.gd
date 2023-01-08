extends Interacter

func _ready() -> void:
	action = "ACTION_PICK"

func _to_string() -> String:
	return tr("KEY_NAME")
