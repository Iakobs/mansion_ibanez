extends Control

export(Array) var joypad_button_actions := [
	"player_jump", "player_sprint", "primary_action", "pause",
	"player_left", "player_right", "player_forwards", "player_backwards",
	"look_left", "look_right", "look_up", "look_down",
]
export(Array) var joypad_motion_actions := [
	"look_left", "player_left"
]

onready var line: Line2D = $"%line"
onready var first_button: Button = $"%button_6"

var joypad_button_events := {}
var joypad_motion_events := {}

func _ready() -> void:
	set_button_names()
	first_button.call_deferred("grab_focus")

func set_button_names() -> void:
	for action in joypad_button_actions:
#		print("Action: ", action)
		for event in InputMap.get_action_list(action):
			if event is InputEventJoypadButton:
				joypad_button_events[event.button_index] = { event = event, action = action }
			elif event is InputEventJoypadMotion:
				joypad_motion_events[event.axis] = { event = event, action = action }
#			print("Event: ", event.as_text())

func _on_line_draw() -> void:
	if !line.points.empty():
		line.draw_circle(line.points[0], 7.5, Color("f9a300"))
		line.draw_circle(line.points[1], 7.5, Color("f9a300"))
