extends PopupDialog

export var text := ""

onready var label: Label = $"%label"

func _ready() -> void:
	label.text = text

func _on_back_pressed() -> void:
	hide()
