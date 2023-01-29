extends Button

onready var options_popup: PanelContainer = $"%options_popup"
onready var popup_origin: Position2D = $"%popup_origin"

var popup_clicking_area: Rect2
var button_clicking_area: Rect2

func _draw() -> void:
	if get_tree().debug_collisions_hint and pressed:
		draw_rect(popup_clicking_area, Color.yellow)
		draw_rect(button_clicking_area, Color.yellow)

func _ready() -> void:
	popup_origin.position = Vector2(
		rect_size.x - options_popup.min_horizontal_rect_size,
		rect_size.y + 25
	)
	popup_clicking_area = Rect2(
		popup_origin.position,
		Vector2(
			options_popup.min_horizontal_rect_size,
			options_popup.max_vertical_rect_size
		)
		)
	button_clicking_area = Rect2(
		Vector2.ZERO,
		rect_size
	)
	var _error := Events.connect("remap_submenu_requested", self, "_on_remap_submenu_request")

func _toggled(button_pressed: bool) -> void:
	if button_pressed:
		options_popup.show_at_position(popup_origin.global_position)
	else:
		hide_popup()

func _input(event: InputEvent) -> void:
	handle_ui_cancel()
	handle_clicking_outside_popup(event)

func _on_remap_submenu_request() -> void:
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

func handle_ui_cancel() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if options_popup.visible:
			if pressed:
				hide_popup()
				get_tree().set_input_as_handled()
			else:
				hide_popup(true)

func handle_clicking_outside_popup(event: InputEvent) -> void:
	var is_mouse_left_clicking_while_button_pressed = pressed\
		and event is InputEventMouseButton\
		and event.button_index == BUTTON_LEFT\
		and event.is_pressed()
	if is_mouse_left_clicking_while_button_pressed:
		var clicked_outside = not popup_clicking_area.has_point(get_local_mouse_position())\
			and not button_clicking_area.has_point(get_local_mouse_position())
		if clicked_outside:
			hide_popup(true)
