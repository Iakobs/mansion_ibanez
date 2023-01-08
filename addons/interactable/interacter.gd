class_name Interacter
extends Spatial

onready var interactable: Area = $"%interactable"

var inside_interactable := false
var action := ""
var status_icon: Texture
var action_icon: Texture

func _ready() -> void:
	if interactable:
		interactable.connect("area_entered", self, "_on_interactable_area_entered")
		interactable.connect("area_exited", self, "_on_interactable_area_exited")

func emit_interactable_event(event := "") -> void:
	Events.emit_signal(event, get_payload())

func get_payload() -> Dictionary:
	return {
		interacter = self, 
		name = to_string(), 
		action = action,
		status_icon = status_icon
	}

func _on_interactable_area_entered(_area: Area) -> void:
	inside_interactable = true
	emit_interactable_event("interactable_entered")

func _on_interactable_area_exited(_area: Area) -> void:
	inside_interactable = false
	emit_interactable_event("interactable_exited")
