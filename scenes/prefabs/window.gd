class_name Window
extends Interacter

enum FacingDirection { positive, negative }

export(String, "x", "z") var rail_direction := "x"
export(FacingDirection) var facing_direction := FacingDirection.positive
export(bool) var is_locked := false

onready var right_sash: StaticBody = $"%right_sash"
onready var right_lock: Spatial = $"%right_lock"
onready var right_stop_start: Position3D = $"%right_stop_start"
onready var right_stop_end: Position3D = $"%right_stop_end"
onready var right_interactable: Area = $"%right_interactable"

onready var left_sash: StaticBody = $"%left_sash"
onready var left_lock: Spatial = $"%left_lock"
onready var left_stop_start: Position3D = $"%left_stop_start"
onready var left_stop_end: Position3D = $"%left_stop_end"
onready var left_interactable: Area = $"%left_interactable"

onready var state_machine: StateMachine = $"%StateMachine"

onready var lock_vertical_origin: float

var dragging := false
var player_is_in_front := false

var sash: StaticBody
var lock: Spatial
var stop_start: Position3D
var stop_end: Position3D

func _ready() -> void:
	var _err := right_interactable.connect("area_entered", self, "_on_right_interactable_area_entered")
	_err = right_interactable.connect("area_exited", self, "_on_right_interactable_area_exited")
	_err = left_interactable.connect("area_entered", self, "_on_left_interactable_area_entered")
	_err = left_interactable.connect("area_exited", self, "_on_left_interactable_area_exited")
	_err = state_machine.connect("transitioned", self, "_on_status_change")
	
	action = "ACTION_OPEN"
	lock_vertical_origin = right_lock.translation.y

func _on_right_interactable_area_entered(_area: Area) -> void:
	interactable = right_interactable
	sash = right_sash
	lock = right_lock
	stop_start = right_stop_start
	stop_end = right_stop_end
	calculate_player_position()
	if not player_is_in_front:
		inside_interactable = true
		emit_interactable_event("interactable_entered")

func _on_right_interactable_area_exited(_area: Area) -> void:
	if interactable == right_interactable:
		inside_interactable = false
		emit_interactable_event("interactable_exited")

func _on_left_interactable_area_entered(_area: Area) -> void:
	interactable = left_interactable
	sash = left_sash
	lock = left_lock
	stop_start = left_stop_start
	stop_end = left_stop_end
	calculate_player_position()
	if not player_is_in_front:
		inside_interactable = true
		emit_interactable_event("interactable_entered")

func _on_left_interactable_area_exited(_area: Area) -> void:
	if interactable == left_interactable:
		inside_interactable = false
		emit_interactable_event("interactable_exited")

func _on_status_change(_state_name: String) -> void:
	emit_interactable_event("interactable_updated")

func emit_interactable_event(event := "") -> void:
	var payload = get_payload()
	payload.status_icon = Global.locked_icon if is_locked else null
	Events.emit_signal(event, payload)

func calculate_player_position() -> void:
	var direction_to_player := sash.global_translation\
		.direction_to(Global.player.global_translation) as Vector3
	var facing_front_direction := Vector3.RIGHT if rail_direction == "z" else Vector3.BACK
	player_is_in_front = direction_to_player.dot(facing_front_direction) < 0.0

func _to_string() -> String:
	return tr("WINDOW_NAME")
