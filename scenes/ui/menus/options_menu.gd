extends Button

onready var options_popup: PanelContainer = $"%options_popup"

func _toggled(button_pressed: bool) -> void:
	if button_pressed:
		options_popup.show_at_position(get_global_transform().origin + rect_size)
	else:
		hide_popup()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if options_popup.visible:
			if pressed:
				hide_popup()
				get_tree().set_input_as_handled()
			else:
				hide_popup(true)
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT\
	and pressed:
		var is_mouse_clicking_outside := not Rect2(Vector2(), rect_size)\
			.has_point(get_local_mouse_position())
		if is_mouse_clicking_outside:
			hide_popup(true)

func hide_popup(inmediately := false):
	if inmediately:
		options_popup.hide()
	else:
		options_popup.hide_panel()
	return_control_to_self()

func return_control_to_self():
	call_deferred("grab_focus")
	if pressed:
		set_pressed_no_signal(false)
