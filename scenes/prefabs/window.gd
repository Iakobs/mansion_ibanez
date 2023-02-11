class_name Window
extends Spatial

enum FacingDirection { positive, negative }

export(String, "x", "z") var rail_direction := "x"
export(FacingDirection) var facing_direction := FacingDirection.positive
export(bool) var is_locked := false

onready var right_sash: StaticBody = $"%right_sash"
onready var right_lock: Spatial = $"%right_lock"
onready var right_stop_start: Position3D = $"%right_stop_start"
onready var right_stop_end: Position3D = $"%right_stop_end"
onready var right_interactive_element: InteractiveElement = $"%right_interactive_element"

onready var left_sash: StaticBody = $"%left_sash"
onready var left_lock: Spatial = $"%left_lock"
onready var left_stop_start: Position3D = $"%left_stop_start"
onready var left_stop_end: Position3D = $"%left_stop_end"
onready var left_interactive_element: InteractiveElement = $"%left_interactive_element"

onready var state_machine: StateMachine = $"%StateMachine"

onready var lock_vertical_origin: float

var dragging := false
var active_interactive_element: InteractiveElement

var sash: StaticBody
var lock: Spatial
var stop_start: Position3D
var stop_end: Position3D

func _ready() -> void:
	var _err := InteractiveElementEvents.connect("entered", self, "_on_interactive_element_entered")
	_err = InteractiveElementEvents.connect("exited", self, "_on_interactive_element_exited")
	
	lock_vertical_origin = right_lock.translation.y

func _process(_delta: float) -> void:
	calculate_player_position()

func _on_interactive_element_entered(command: InteractiveEventCommand) -> void:
	if command.interactive_element == right_interactive_element and not dragging:
		active_interactive_element = right_interactive_element
		sash = right_sash
		lock = right_lock
		stop_start = right_stop_start
		stop_end = right_stop_end
	if command.interactive_element == left_interactive_element and not dragging:
		active_interactive_element = left_interactive_element
		sash = left_sash
		lock = left_lock
		stop_start = left_stop_start
		stop_end = left_stop_end

func _on_interactive_element_exited(command: InteractiveEventCommand) -> void:
	if command.interactive_element == right_interactive_element\
	and active_interactive_element == right_interactive_element:
		active_interactive_element = null
	if command.interactive_element == left_interactive_element\
	and active_interactive_element == left_interactive_element:
		active_interactive_element = null

func _on_right_interactive_element_area_entered(_area: Area) -> void:
	active_interactive_element = right_interactive_element
	sash = right_sash
	lock = right_lock
	stop_start = right_stop_start
	stop_end = right_stop_end

func _on_left_interactive_element_area_entered(_area: Area) -> void:
	active_interactive_element = left_interactive_element
	sash = left_sash
	lock = left_lock
	stop_start = left_stop_start
	stop_end = left_stop_end

func is_inside() -> bool:
	return active_interactive_element.is_inside\
	if active_interactive_element else false

func calculate_player_position() -> void:
	if sash:
		var direction_to_player := sash.global_translation\
			.direction_to(Global.player.global_translation) as Vector3
		var facing_front_direction := Vector3.RIGHT if rail_direction == "z" else Vector3.BACK
		var player_to_window_position := direction_to_player.dot(facing_front_direction)
		var player_is_in_front := player_to_window_position < 0.0\
			if facing_direction == FacingDirection.positive\
			else player_to_window_position > 0.0
		right_interactive_element.monitoring = not player_is_in_front
		left_interactive_element.monitoring = not player_is_in_front
