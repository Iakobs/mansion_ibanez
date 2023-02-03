extends Control

export(String) var action: String

onready var label: Label = $"%label"
onready var button_1: Control = $"%action_remap_button_1"
onready var button_2: Control = $"%action_remap_button_2"
onready var mouse_icon: TextureRect = $"%mouse_icon"

func _ready() -> void:
	button_1.action = action
	button_2.action = action
	mouse_icon.texture = null
	var _error := SaveManager.connect("value_reseted", self, "setup_buttons")

func setup_buttons() -> void:
	set_label_text()
	set_button_text()
	set_mouse_icon()

func set_label_text() -> void:
	label.text = "{0}: ".format([tr(action)])

func set_button_text() -> void:
	var keyboard_keys := InputMapManager.get_keyboard_keys_from_action(action)
	button_1.set_input_event(keyboard_keys[0] if keyboard_keys.size() > 0 else null)
	button_2.set_input_event(keyboard_keys[1] if keyboard_keys.size() > 1 else null)

func set_mouse_icon() -> void:
	var button_index := InputMapManager.get_mouse_button_index_from_action(action)
	if button_index == BUTTON_LEFT:
		mouse_icon.texture = Global.primary_action_icon
	if button_index == BUTTON_RIGHT:
		mouse_icon.texture = Global.secondary_action_icon

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		setup_buttons()
