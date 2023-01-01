class_name WindowState
extends State

var window: Window

func _ready():
	yield(owner, "ready")
	window = owner as Window
	assert(window != null)

func get_action() -> String:
	return ""
