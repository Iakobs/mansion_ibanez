extends Control

onready var hand = $hand

func _ready():
	Events.connect("interactable_entered", self, "react")
	Events.connect("interactable_exited", self, "reset")
	pass

func react():
	hand.modulate = Color.red

func reset():
	hand.modulate = Color.white
