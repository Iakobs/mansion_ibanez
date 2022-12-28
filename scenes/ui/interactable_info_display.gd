extends Control

onready var name_label := $"%Name"
onready var action_label := $"%Action"

func _ready():
	visible = false

func show_display(name := "", action := ""):
	name_label.text = name
	action_label.text = action
	print("name {0}, action{1}".format([name, action]))
	visible = true

func hide_display():
	name_label.text = ""
	action_label.text = ""
	visible = false
