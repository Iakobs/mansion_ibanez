extends Control

onready var interactable_name: Label = $"%interactable_name"
onready var interactable_icon: TextureRect = $"%interactable_icon"
onready var action_label: Label = $"%action_label"

func _ready():
	visible = false

func show_display(payload := {}) -> void:
	if "name" in payload: interactable_name.text = payload.name
	if "action" in payload: action_label.text = tr(payload.action)
	if "status_icon" in payload:
		interactable_icon.texture = payload.status_icon
	else:
		interactable_icon.texture = null
	visible = true

func hide_display() -> void:
	interactable_name.text = ""
	action_label.text = ""
	visible = false
