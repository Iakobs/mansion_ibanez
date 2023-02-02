class_name ActionEvents
extends Resource

enum Keys {
	none = -1,
	space = 32,
	escape = 16777217,
	shift = 16777237,
	control = 16777238,
	alt = 16777240,
	left = 16777231,
	up = 16777232,
	right = 16777233,
	down = 16777234,
	a = 65,
	b = 66,
	c = 67,
	d = 68,
	e = 69,
	f = 70,
	g = 71,
	h = 72,
	i = 73,
	j = 74,
	k = 75,
	l = 76,
	m = 77,
	n = 78,
	o = 79,
	p = 80,
	q = 81,
	r = 82,
	s = 83,
	t = 84,
	u = 85,
	v = 86,
	w = 87,
	x = 88,
	y = 89,
	z = 90,
	number_0 = 48,
	number_1 = 49,
	number_2 = 50,
	number_3 = 51,
	number_4 = 52,
	number_5 = 53,
	number_6 = 54,
	number_7 = 55,
	number_8 = 56,
	number_9 = 57,
	keypad_0 = 16777350,
	keypad_1 = 16777351,
	keypad_2 = 16777352,
	keypad_3 = 16777353,
	keypad_4 = 16777354,
	keypad_5 = 16777355,
	keypad_6 = 16777356,
	keypad_7 = 16777357,
	keypad_8 = 16777358,
	keypad_9 = 16777359}
enum JoypadButton {
	none = -1,
	l1 = JOY_L,
	l2 = JOY_L2,
	left_stick_click = JOY_L3
	r1 = JOY_R,
	r2 = JOY_R2,
	righ_stick_click = JOY_R3,
	start = JOY_START,
	select = JOY_SELECT,
	dpad_up = JOY_DPAD_UP,
	dpad_down = JOY_DPAD_DOWN,
	dpad_left = JOY_DPAD_LEFT,
	dpad_right = JOY_DPAD_RIGHT,
	x = JOY_XBOX_X,
	y = JOY_XBOX_Y,
	a = JOY_XBOX_A
	b = JOY_XBOX_B}
enum Axis {
	none = -1,
	left_horizontal = JOY_AXIS_0,
	left_vertical = JOY_AXIS_1,
	right_horizontal = JOY_AXIS_2,
	right_vertical = JOY_AXIS_3}
enum AxisValue { none = 0, right_or_down = 1, left_or_up = -1 }
enum MouseButton {
	none = -1,
	left = BUTTON_LEFT,
	right = BUTTON_RIGHT,
	middle = BUTTON_MIDDLE }

export(Array, Keys) var keyboard_keys: Array setget set_keyboard_keys
export(JoypadButton) var joypad_button_index: int = JoypadButton.none
export(Axis) var joypad_motion_axis: int = Axis.none
export(AxisValue) var joypad_motion_axis_value: int = AxisValue.none
export(MouseButton) var mouse_button_index: int = MouseButton.none

func set_keyboard_keys(value: Array) -> void:
	assert(value.size() <= 2)
	keyboard_keys = value
