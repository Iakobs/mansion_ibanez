class_name ActionDefaultValues
extends Resource

export(Array, int) var keyboard_keys: Array setget set_keyboard_keys
export(int) var joypad_button_index: int = -1
export(int) var joypad_motion_axis: int = -1
export(Action.AxisValue) var joypad_motion_axis_value: int = -1
export(int) var mouse_button_index: int = -1

func set_keyboard_keys(value: Array) -> void:
	assert(value.size() <= 2)
	keyboard_keys = value
