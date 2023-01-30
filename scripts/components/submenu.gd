class_name Submenu
extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var _error := connect("visibility_changed", self, "_on_visibility_changed")

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		Global.is_submenu_open = true
	else:
		Global.is_submenu_open = false
