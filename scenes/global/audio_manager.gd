extends Node2D

onready var toggle: AudioStreamPlayer = $"%toggle"
onready var click: AudioStreamPlayer = $"%click"
onready var release: AudioStreamPlayer = $"%release"
onready var hover_or_focus: AudioStreamPlayer = $"%hover_or_focus"
onready var menu_music: AudioStreamPlayer = $"%menu_music"
onready var pause: AudioStreamPlayer = $"%pause"

func _on_hover_or_focus() -> void:
	hover_or_focus.play()

func connect_on_hover_or_focus(control: Control) -> void:
	var _error := control.connect("focus_entered", self, "_on_hover_or_focus")
	_error = control.connect("mouse_entered", self, "_on_hover_or_focus")
