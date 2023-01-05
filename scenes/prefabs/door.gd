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
onready var unlock_area: Area = $"%unlock_area"

var clicking_is_active := true

func _ready() -> void:
	var _err := state_machine.connect("transitioned", self, "_on_door_status_change")
	_err = unlock_area.connect("body_entered", self, "_on_unlock_area_body_entered")
	action = state_machine.state.get_action()

func _process(_delta: float) -> void:
	pass

func _on_interactable_area_entered(area: Area) -> void:
	._on_interactable_area_entered(area)
	check_clicking()

func _on_door_status_change(_state_name: String) -> void:
	emit_interactable_event("interactable_updated")

func _on_unlock_area_body_entered(body: PhysicsBody) -> void:
	if body.is_in_group("key") and is_locked:
		is_locked = false
		body.owner.queue_free()
		emit_interactable_event("interactable_updated")

func emit_interactable_event(event := "") -> void:
	var _payload = get_payload()
	_payload["locked"] = is_locked
	Events.emit_signal(event, _payload)

func check_clicking() -> void:
	clicking_is_active = not (inside_interactable \
		and Input.is_action_pressed("primary_action"))

func _to_string() -> String:
	return tr("DOOR_NAME")
