extends Control

onready var name_label: Label = $"%Name"
onready var action_label: Label = $"%Action"

func _ready():
	visible = false

func show_display(name := "", action := "") -> void:
	name_label.text = name
	action_label.text = action
	visible = true

func hide_display() -> void:
	name_label.text = ""
	action_label.text = ""
	visible = false
