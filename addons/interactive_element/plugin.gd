tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("InteractiveElementEvents", "res://addons/interactive_element/interactive_element_events.gd")

func _exit_tree():
	remove_autoload_singleton("InteractiveElementEvents")
