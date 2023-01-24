class_name KeyBindingButton

extends MenuButton

const joypad_button_group := "joypad_button"
const joypad_motion_group := "joypad_motion"
const left_section_button_group := "left_section_button"
const right_section_button_group := "right_section_button"

export(int) var index: int

func _ready() -> void:
	yield(owner, "ready")
	connect_signals()
	set_button_name()
	fill_menu()

func _process(_delta: float) -> void:
	if is_hovered():
		call_deferred("grab_focus")

func _on_action_selected(menu_item_index: int) -> void:
	var action = get_popup().get_item_metadata(menu_item_index)
	print("Action selected: ", action)

func _on_focus_entered(position: Position2D) -> void:
	var start_position_offset: Vector2
	
	if is_in_group(left_section_button_group):
		start_position_offset = Vector2(
			rect_size.x + 10,
			rect_size.y / 2
		)
	elif is_in_group(right_section_button_group):
		start_position_offset = Vector2(-10, rect_size.y / 2)
	
	var start_position := rect_global_position + start_position_offset
	owner.line.add_point(start_position)
	owner.line.add_point(position.global_position)

func _on_focus_exited() -> void:
	owner.line.clear_points()

func connect_signals() -> void:
	var line_end_position
	for child in get_children():
		if child is Position2D:
			line_end_position = child
			break
	
	var _error := connect("focus_entered", self, "_on_focus_entered", [line_end_position])
	_error = connect("focus_exited", self, "_on_focus_exited")
	_error = get_popup().connect("index_pressed", self, "_on_action_selected")

func set_button_name() -> void:
	if is_in_group(joypad_button_group):
		if owner.joypad_button_events.has(index):
			set_text(tr(owner.joypad_button_events[index].action))
		else:
			set_flat(true)
	elif is_in_group(joypad_motion_group):
		if owner.joypad_motion_events.has(index):
			set_text(tr(owner.joypad_motion_events[index].action).split(" ")[0])
		else:
			set_flat(true)

func fill_menu() -> void:
	var popup := get_popup()
	
	popup.add_item(tr("ACTION_UNASSIGN"))
	popup.add_separator(tr("ACTION_SEPARATOR"))
	
	var sorted_list := []
	
	if is_in_group(joypad_button_group):
		for action in owner.joypad_button_actions:
			sorted_list.append({ metadata = action, translation = tr(action) })
	elif is_in_group(joypad_motion_group):
		for action in owner.joypad_motion_actions:
			sorted_list.append({ metadata = action, translation = tr(action).split(" ")[0] })
	
	sorted_list.sort_custom(MyCustomSorter, "sort")
	var item_id := 1
	for item in sorted_list:
		popup.add_item(item.translation, item_id)
		popup.set_item_metadata(popup.get_item_index(item_id), item.metadata)
		item_id += 1

class MyCustomSorter:
	static func sort(a, b):
		if a.translation < b.translation:
			return true
		return false
