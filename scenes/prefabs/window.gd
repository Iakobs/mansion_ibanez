class_name Window
extends Interacter

enum FacingDirection { positive, negative }

export(String, "x", "z") var rail_direction := "x"
export(FacingDirection) var facing_direction := FacingDirection.positive
export(bool) var is_locked := false

onready var right_sash: StaticBody = $"%right_sash"
onready var left_sash: StaticBody = $"%left_sash"
onready var right_lock: Spatial = $"%right_lock"
onready var left_lock: Spatial = $"%left_lock"
onready var right_interactable: Area = $"%right_interactable"
onready var left_interactable: Area = $"%left_interactable"
onready var right_stop_start: Position3D = $"%right_stop_start"
onready var right_stop_end: Position3D = $"%right_stop_end"
onready var left_stop_start: Position3D = $"%left_stop_start"
onready var left_stop_end: Position3D = $"%left_stop_end"

onready var state_machine: StateMachine = $"%StateMachine"
onready var animation_manager: WindowAnimationManager = $"%WindowAnimationManager"
onready var animation := funcref(animation_manager, "open")

var dragging := false

func _ready() -> void:
	var _err = right_interactable.connect("area_entered", self, "_on_right_interactable_area_entered")
	_err = right_interactable.connect("area_exited", self, "_on_right_interactable_area_exited")
	_err = left_interactable.connect("area_entered", self, "_on_left_interactable_area_entered")
	_err = left_interactable.connect("area_exited", self, "_on_left_interactable_area_exited")
	_err = state_machine.connect("transitioned", self, "_on_status_change")
	action = state_machine.state.get_action()

func _process(_delta: float) -> void:
#	state_machine._process(_delta)
	pass

func _unhandled_input(_event: InputEvent) -> void:
	pass

func _on_right_interactable_area_entered(_area: Area) -> void:
	interactable = right_interactable
	inside_interactable = true
	emit_interactable_event("interactable_entered")

func _on_right_interactable_area_exited(_area: Area) -> void:
	if interactable == right_interactable:
		inside_interactable = false
		emit_interactable_event("interactable_exited")

func _on_left_interactable_area_entered(_area: Area) -> void:
	interactable = left_interactable
	inside_interactable = true
	emit_interactable_event("interactable_entered")

func _on_left_interactable_area_exited(_area: Area) -> void:
	if interactable == left_interactable:
		inside_interactable = false
		emit_interactable_event("interactable_exited")

func _on_status_change(_state_name: String) -> void:
	emit_interactable_event("interactable_updated")

func emit_interactable_event(event := "") -> void:
	var _payload = get_payload()
	_payload["locked"] = is_locked
	Events.emit_signal(event, _payload)

func _to_string() -> String:
	return tr("WINDOW_NAME")
