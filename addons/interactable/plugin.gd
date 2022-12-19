tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("interactable", "Area", preload("interactable.gd"), 
		preload("Area3D.svg"))

func _exit_tree():
	remove_custom_type("interactable")
