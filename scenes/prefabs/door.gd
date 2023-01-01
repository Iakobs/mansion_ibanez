class_name Door
extends Interacter

enum DoorPanelAngle { positive = 90, negative = -90 }

export(DoorPanelAngle) var door_panel_angle := DoorPanelAngle.positive
export(String, "x", "z") var doorknob_axis := "x"
export(bool) var is_locked := false

onready var door_panel: StaticBody = $"%door_panel"
onready var doorknob: Spatial = $"%doorknob"
onready var state_machine: StateMachine = $"%StateMachine"
onready var animation_manager: DoorAnimationManager = $"%DoorAnimationManager"
onready var animation := funcref(animation_manager, "open")

func _ready() -> void:
	var _err = state_machine.connect("transitioned", self, "_on_door_status_change")
	action = state_machine.state.get_action()

func _process(delta: float) -> void:
	state_machine._process(delta)

func _on_door_status_change(_state_name: String) -> void:
	emit_interactable_event("interactable_updated")

func emit_interactable_event(event := "") -> void:
	var _payload = get_payload()
	_payload["locked"] = is_locked
	Events.emit_signal(event, _payload)

func _to_string() -> String:
	return tr("DOOR_NAME")
