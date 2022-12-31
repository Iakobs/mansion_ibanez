extends Control

onready var name_label: Label = $"%Name"
onready var action_label: Label = $"%Action"
onready var locked_icon: TextureRect = $"%Locked"
onready var locked_margin: MarginContainer = $"%LockedMargin"

func _ready():
	visible = false

func show_display(payload := {}) -> void:
	if "name" in payload: name_label.text = payload.name
	if "action" in payload: action_label.text = payload.action
	if "locked" in payload: 
		locked_icon.visible = payload.locked
		locked_margin.visible = payload.locked
	else:
		locked_icon.visible = false
		locked_margin.visible = false
	visible = true

func hide_display() -> void:
	name_label.text = ""
	action_label.text = ""
	visible = false
