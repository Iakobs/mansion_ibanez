extends Control

export(Array) var actions := [
	"player_jump", "player_sprint", "primary_action", "pause",
	"player_left", "player_right", "player_forwards", "player_backwards",
	"look_left", "look_right", "look_up", "look_down",
]

onready var line: Line2D = $"%line"

onready var button_0: Button = $"%button_0"
onready var button_1: Button = $"%button_1"
onready var button_2: Button = $"%button_2"
onready var button_3: Button = $"%button_3"
onready var button_4: Button = $"%button_4"
onready var button_5: Button = $"%button_5"
onready var button_6: Button = $"%button_6"
onready var button_7: Button = $"%button_7"
onready var button_8: Button = $"%button_8"
onready var button_9: Button = $"%button_9"
onready var button_10: Button = $"%button_10"
onready var button_11: Button = $"%button_11"
onready var button_12: Button = $"%button_12"
onready var button_13: Button = $"%button_13"
onready var button_14: Button = $"%button_14"
onready var button_15: Button = $"%button_15"
onready var button_left_joystick: Button = $"%button_left_joystick"
onready var button_right_joystick: Button = $"%button_right_joystick"

onready var button_0_position: Position2D = $"%button_0_position"
onready var button_1_position: Position2D = $"%button_1_position"
onready var button_2_position: Position2D = $"%button_2_position"
onready var button_3_position: Position2D = $"%button_3_position"
onready var button_4_position: Position2D = $"%button_4_position"
onready var button_5_position: Position2D = $"%button_5_position"
onready var button_6_position: Position2D = $"%button_6_position"
onready var button_7_position: Position2D = $"%button_7_position"
onready var button_8_position: Position2D = $"%button_8_position"
onready var button_9_position: Position2D = $"%button_9_position"
onready var button_10_position: Position2D = $"%button_10_position"
onready var button_11_position: Position2D = $"%button_11_position"
onready var button_12_position: Position2D = $"%button_12_position"
onready var button_13_position: Position2D = $"%button_13_position"
onready var button_14_position: Position2D = $"%button_14_position"
onready var button_15_position: Position2D = $"%button_15_position"
onready var button_left_joystick_position: Position2D = $"%button_left_joystick_position"
onready var button_right_joystick_position: Position2D = $"%button_right_joystick_position"

onready var buttons := {
	button_0 = { button = button_0, position = button_0_position },
	button_1 = { button = button_1, position = button_1_position},
	button_2 = { button = button_2, position = button_2_position},
	button_3 = { button = button_3, position = button_3_position},
	button_4 = { button = button_4, position = button_4_position},
	button_5 = { button = button_5, position = button_5_position},
	button_6 = { button = button_6, position = button_6_position},
	button_7 = { button = button_7, position = button_7_position},
	button_8 = { button = button_8, position = button_8_position},
	button_9 = { button = button_9, position = button_9_position},
	button_10 = { button = button_10, position = button_10_position},
	button_11 = { button = button_11, position = button_11_position},
	button_12 = { button = button_12, position = button_12_position},
	button_13 = { button = button_13, position = button_13_position},
	button_14 = { button = button_14, position = button_14_position},
	button_15 = { button = button_15, position = button_15_position},
	axis_0 = { button = button_left_joystick, position = button_left_joystick_position},
	axis_1 = { button = button_left_joystick, position = button_left_joystick_position},
	axis_2 = { button = button_right_joystick, position = button_right_joystick_position},
	axis_3 = { button = button_right_joystick, position = button_right_joystick_position},
}

func _ready() -> void:
	connect_buttons()
	set_button_names()
	
	button_6.grab_focus()

func connect_buttons():
	for button_data in buttons.values():
		var button := button_data.button as Button
		var position := button_data.position as Position2D
		if !button.is_connected("focus_entered", self, "_on_focus_entered"):
			var _error := button.connect("focus_entered", self, "_on_focus_entered", [button, position])
		if !button.is_connected("focus_exited", self, "_on_focus_exited"):
			var _error := button.connect("focus_exited", self, "_on_focus_exited")

func set_button_names():
	for action in InputMap.get_actions():
		if action in actions:
#			print("Action: ", action)
			for event in InputMap.get_action_list(action):
				if event is InputEventJoypadButton:
					var button := buttons["button_{0}".format([event.button_index])].button as Button
					button.set_text(tr(action))
				elif event is InputEventJoypadMotion:
					var button := buttons["axis_{0}".format([event.axis])].button as Button
					button.set_text(tr(action).split(" ")[0])
#				print("Event: ", event.as_text())

func _on_focus_entered(button: Button, position: Position2D) -> void:
	var start_position_offset: Vector2
	
	if button.is_in_group("left_section_button"):
		start_position_offset = Vector2(
			button.rect_size.x + 10,
			button.rect_size.y / 2
		)
	elif button.is_in_group("right_section_button"):
		start_position_offset = Vector2(-10, button.rect_size.y / 2)
	
	var start_position := button.rect_global_position + start_position_offset
	line.add_point(start_position)
	line.add_point(position.global_position)

func _on_focus_exited() -> void:
	line.clear_points()

func _on_line_draw() -> void:
	line.draw_circle(line.points[0], 7.5, Color("f9a300"))
	line.draw_circle(line.points[1], 7.5, Color("f9a300"))
