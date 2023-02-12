extends Spatial

onready var interactive_seat: Area = $"%interactive_seat"
onready var interactive_seat_lid: Area = $"%interactive_seat_lid"
onready var interactive_tank: Area = $"%interactive_tank"
onready var seat: MeshInstance = $"%seat"
onready var seat_lid: MeshInstance = $"%seat_lid"
onready var flush_button: MeshInstance = $"%flush_button"
onready var animation_player: AnimationPlayer = $"%AnimationPlayer"

var lid_closed := true

func _ready() -> void:
	switch_seat()

func _input(event: InputEvent) -> void:
	if event.is_action_released("primary_action") and interactive_seat_lid.is_inside:
		lid_closed = not lid_closed
		lid_open(lid_closed)
		interactive_seat_lid.action = "ACTION_OPEN" if lid_closed else "ACTION_CLOSE"
		interactive_seat_lid.emit("updated")
	
	if event.is_action_released("primary_action") and interactive_tank.is_inside:
		if not animation_player.is_playing():
			animation_player.play("flush")

func lid_open(reverse := false) -> void:
	var tween := seat_lid.create_tween()\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)
	var _discard := tween.tween_property(
		seat_lid,
		"rotation_degrees:z",
		0.0,
		1.0
	) if reverse else\
	tween.tween_property(
		seat_lid,
		"rotation_degrees:z",
		90.0,
		1.0
	)

func seat_open(reverse := false) -> void:
	var tween := seat.create_tween()\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)
	var _discard := tween.tween_property(
		seat,
		"rotation_degrees:z",
		0.0,
		1.0
	) if reverse else\
	tween.tween_property(
		seat,
		"rotation_degrees:z",
		90.0,
		1.0
	)

func switch_seat_lid() -> void:
	interactive_seat_lid.monitorable = not interactive_seat_lid.monitorable
	interactive_seat_lid.monitoring = not interactive_seat_lid.monitoring

func switch_seat() -> void:
	interactive_seat.monitorable = not interactive_seat.monitorable
	interactive_seat.monitoring = not interactive_seat.monitoring
