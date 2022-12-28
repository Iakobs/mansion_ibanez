extends Control

onready var hand := $"%Hand"
onready var display := $"%interactable_info_display"

var reacter

func _ready():
	Events.connect("interactable_entered", self, "react")
	Events.connect("interactable_exited", self, "reset")

func react(payload := {}):
	reacter = payload.interactable
	hand.modulate = Color.red
	display.show_display(payload.name, payload.action)

func reset(payload):
	if payload.interactable == reacter:
		reacter = null
		hand.modulate = Color.white
		display.hide_display()
