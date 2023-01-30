extends Control

var container_resource := preload("res://scenes/ui/components/keyboard_keybinding_container.tscn")

onready var actions: VBoxContainer = $"%actions"

func _ready() -> void:
	for action in InputMapManager.cache.keys():
		var container := container_resource.instance() as Control
		container.action = action
		actions.add_child(container)
