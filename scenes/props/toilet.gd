extends Spatial

onready var interactive_seat: Area = $"%interactive_seat"
onready var interactive_seat_lid: Area = $"%interactive_seat_lid"
onready var interactive_tank: Area = $"%interactive_tank"
onready var seat: MeshInstance = $"%seat"
onready var seat_lid: MeshInstance = $"%seat_lid"
onready var flush_button: MeshInstance = $"%flush_button"

var lid_closed := true
var seat_closed := true

func _ready() -> void:
	interactive_seat.monitoring = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("primary_action"):
		if interactive_tank.is_inside:
			pass
		if interactive_seat.is_inside or interactive_seat_lid.is_inside:
			if lid_closed:
				lid_open()

func lid_open() -> void:
	lid_closed = true
	var tween := seat_lid.create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	var _discard := tween.tween_property(
		seat_lid,
		"rotation_degrees:z",
		90.0,
		1.0
	)
