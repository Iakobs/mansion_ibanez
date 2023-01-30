class_name KeyBindingButton

extends MenuButton

const left_section_button_group := "left_section_button"
const right_section_button_group := "right_section_button"

var action: String

func _ready() -> void:
	_connect_signals()
	setup_button()
	fill_menu()

func _process(_delta: float) -> void:
	if is_hovered():
		call_deferred("grab_focus")

func _on_action_selected(menu_item_index: int) -> void:
	var new_action = get_popup().get_item_metadata(menu_item_index)
	change_action(new_action if new_action else "")

func _on_focus_entered(position: Position2D) -> void:
	var start_position_offset: Vector2
	if is_in_group(left_section_button_group):
		start_position_offset = Vector2(
			rect_size.x + 10,
			rect_size.y / 2
		)
	elif is_in_group(right_section_button_group):
		start_position_offset = Vector2(-10, rect_size.y / 2)
	
	var start_position := get_global_transform().origin + start_position_offset
	owner.line.add_point(start_position - owner.get_global_transform().origin)
	owner.line.add_point(position.get_global_transform().origin - owner.get_global_transform().origin)

func _on_focus_exited() -> void:
	owner.line.clear_points()

func _on_locale_changed() -> void:
	set_button_text(action)

func _connect_signals() -> void:
	var line_end_position: Position2D
	for child in get_children():
		if child is Position2D:
			line_end_position = child
	
	var _error := connect("focus_entered", self, "_on_focus_entered", [line_end_position])
	_error = connect("focus_exited", self, "_on_focus_exited")
	_error = get_popup().connect("index_pressed", self, "_on_action_selected")
	_error = Events.connect("locale_changed", self, "_on_locale_changed")

func setup_button() -> void:
	pass

func fill_menu() -> void:
	pass

func change_action(_new_action: String) -> void:
	pass

func set_button_text(text) -> void:
	if !text.empty():
		set_text(tr(text))
		self.action = text
	else:
		unassign()

func unassign() -> void:
	action = ""
	set_text("")
	set_flat(true)

class MyCustomSorter:
	static func sort(a, b):
		if a.translation < b.translation:
			return true
		return false
