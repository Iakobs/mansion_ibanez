extends Control

onready var hand := $"%Hand"
onready var display := $"%interactable_info_display"

var reacter

func _ready():
	Events.connect("interactable_entered", self, "react")
	Events.connect("interactable_exited", self, "reset")
	Events.connect("interactable_updated", self, "update")

func react(payload := {}) -> void:
	reacter = payload.interactable
	hand.modulate = Color.red
	display.show_display(payload.name, payload.action)

func update(payload := {}) -> void:
	if payload.interactable == reacter:
		display.show_display(payload.name, payload.action)

func reset(payload := {}) -> void:
	if payload.interactable == reacter:
		reacter = null
		hand.modulate = Color.white
		display.hide_display()
