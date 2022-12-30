class_name GarageDoor
extends Spatial

onready var upper_door_panel: StaticBody = $"%upper_door_panel"
onready var lower_door_panel: StaticBody = $"%lower_door_panel"
onready var upper_interactable: Area = $"%upper_interactable"
onready var lower_interactable: Area = $"%lower_interactable"
onready var state_machine: StateMachine = $"%StateMachine"
onready var animation_manager: DoorAnimationManager = $"%DoorAnimationManager"
onready var animation := funcref(animation_manager, "open_garage")

var interactable: Area
var inside_interactable := false

func _ready() -> void:
	upper_interactable.connect("area_entered", self, "_on_upper_interactable_area_entered")
	upper_interactable.connect("area_exited", self, "_on_upper_interactable_area_exited")
	lower_interactable.connect("area_entered", self, "_on_lower_interactable_area_entered")
	lower_interactable.connect("area_exited", self, "_on_lower_interactable_area_exited")
	state_machine.connect("transitioned", self, "_on_door_status_change")

func _process(_delta: float) -> void:
	state_machine._process(_delta)

func _on_upper_interactable_area_entered(_area: Area) -> void:
	interactable = upper_interactable
	inside_interactable = true
	emit_interactable_event("interactable_entered")

func _on_upper_interactable_area_exited(_area: Area) -> void:
	if interactable == upper_interactable:
		inside_interactable = false
		emit_interactable_event("interactable_exited")

func _on_lower_interactable_area_entered(_area: Area) -> void:
	interactable = lower_interactable
	inside_interactable = true
	emit_interactable_event("interactable_entered")

func _on_lower_interactable_area_exited(_area: Area) -> void:
	if interactable == lower_interactable:
		inside_interactable = false
		emit_interactable_event("interactable_exited")

func _on_door_status_change(_state_name: String) -> void:
	emit_interactable_event("interactable_updated")

func emit_interactable_event(event := "") -> void:
	Events.emit_signal(
		event, 
		{ 
			interactable = self, 
			name = to_string(), 
			action = get_action() 
		})

func _to_string() -> String:
	return tr("GARAGE_DOOR_NAME")

func get_action() -> String:
	return tr("DOOR_ACTION_OPEN") if state_machine.state.name == "Closed" \
		else tr("DOOR_ACTION_CLOSE")
