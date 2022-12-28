class_name Door
extends Spatial

enum DoorPanelAngle { positive = 90, negative = -90 }

export(DoorPanelAngle) var door_panel_angle := DoorPanelAngle.positive
export(String, "x", "z") var doorknob_axis := "x"

onready var door_panel := $"%door_panel"
onready var doorknob := $"%doorknob"
onready var interactable := $"%interactable"
onready var state_machine := $"%StateMachine"

var inside_interactable := false

func _ready() -> void:
	interactable.connect("area_entered", self, "_on_interactable_area_entered")
	interactable.connect("area_exited", self, "_on_interactable_area_exited")
	state_machine.connect("transitioned", self, "_on_door_status_change")

func _process(delta) -> void:
	state_machine._process(delta)

func _on_door_status_change(state_name: String) -> void:
	emit_interactable_entered()

func _on_interactable_area_entered(_area: Area) -> void:
	inside_interactable = true
	emit_interactable_entered()

func _on_interactable_area_exited(_area: Area) -> void:
	inside_interactable = false
	Events.emit_signal("interactable_exited", { interactable = self })

func emit_interactable_entered() -> void:
	Events.emit_signal(
		"interactable_entered", 
		{ 
			interactable = self, 
			name = to_string(), 
			action = get_action() 
		})

func get_action() -> String:
	return "Open" if state_machine.state.name == "Closed" else "Close"

func _to_string() -> String:
	return "Door"
