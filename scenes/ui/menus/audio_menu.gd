extends Control

onready var focus_button: Button = $"%button_back"

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel") and not focus_button.has_focus():
		focus_button.call_deferred("grab_focus")
		get_tree().set_input_as_handled()

func _on_button_back_pressed() -> void:
	Events.emit_signal("audio_submenu_closed")

func _on_visibility_changed() -> void:
	if visible:
		focus_button.call_deferred("grab_focus")
