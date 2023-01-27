extends Control

onready var line: Line2D = $"%line"
onready var first_button: Button = $"%button_6"

func _ready() -> void:
	first_button.call_deferred("grab_focus")

func _on_line_draw() -> void:
	if !line.points.empty():
		line.draw_circle(line.points[0], 7.5, Color("f9a300"))
		line.draw_circle(line.points[1], 7.5, Color("f9a300"))
