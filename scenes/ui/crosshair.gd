extends Control

onready var hand: TextureRect = $"%Hand"
onready var display: Control = $"%interactable_info_display"

var interactable

func _ready() -> void:
	Events.connect("interactable_entered", self, "interact")
	Events.connect("interactable_exited", self, "reset")
	Events.connect("interactable_updated", self, "update")

func interact(payload := {}) -> void:
	interactable = payload.interactable
	hand.modulate = Color.red
	display.show_display(payload.name, payload.action)

func update(payload := {}) -> void:
	if payload.interactable == interactable:
		display.show_display(payload.name, payload.action)

func reset(payload := {}) -> void:
	if payload.interactable == interactable:
		interactable = null
		hand.modulate = Color.white
		display.hide_display()
