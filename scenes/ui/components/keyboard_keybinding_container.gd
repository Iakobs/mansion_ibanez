extends Control

export(String) var action: String

onready var label: Label = $"%label"
onready var button_1: Button = $"%button_1"
onready var button_2: Button = $"%button_2"
onready var mouse_icon: TextureRect = $"%mouse_icon"

func _ready() -> void:
	button_1.focus_neighbour_left = button_1.get_path()
	button_2.focus_neighbour_right = button_2.get_path()

func set_label_text() -> void:
	label.text = "{0}: ".format([tr(action)])

func set_button_text() -> void:
	var keyboard_keys := InputMapManager.get_keyboard_keys_from_action(action)
	button_1.text = keyboard_keys[0] if keyboard_keys.size() > 0 else ""
	button_2.text = keyboard_keys[1] if keyboard_keys.size() > 1 else ""

func set_mouse_icon() -> void:
	var button_index := InputMapManager.get_mouse_button_index_from_action(action)
	if button_index == BUTTON_LEFT:
		mouse_icon.texture = Global.primary_action_icon
	if button_index == BUTTON_RIGHT:
		mouse_icon.texture = Global.secondary_action_icon

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		set_label_text()
		set_button_text()
		set_mouse_icon()
