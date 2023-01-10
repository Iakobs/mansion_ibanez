class_name AnimationManager
extends Node

signal animation_finished(payload)

var is_playing := false

func animation_finished(animation_name: String, args: Array) -> void:
	emit_signal("animation_finished", 
		{
			animation_name = animation_name,
			args = args
		})
