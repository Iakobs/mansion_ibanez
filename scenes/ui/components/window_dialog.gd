extends PopupDialog

export(String) var dialog: String

onready var label: Label = $"%Label"

func _on_about_to_show() -> void:
	label.text = tr(dialog)

func _on_popup_hide() -> void:
	queue_free()

func _on_button_pressed() -> void:
	hide()
