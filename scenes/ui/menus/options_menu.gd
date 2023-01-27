extends Button

onready var options_popup: PanelContainer = $"%options_popup"

func _toggled(_button_pressed: bool) -> void:
	if options_popup.visible:
		options_popup.hide_panel()
	else:
		options_popup.show_at_position(get_global_transform().origin + rect_size)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if options_popup.visible:
			if pressed:
				options_popup.hide_panel()
				call_deferred("grab_focus")
				set_pressed_no_signal(false)
				get_tree().set_input_as_handled()
			else:
				options_popup.hide()
