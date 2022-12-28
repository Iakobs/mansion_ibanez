extends DoorState

var playing_animation := false

func update(_delta: float) -> void:
	if not playing_animation \
	and door.inside_interactable \
	and Input.is_action_just_released("left_click"):
			open_animation(true)

func open_animation(reverse := false):
	playing_animation = true
	var door_final_angle = door.door_panel_angle
	if reverse:
		door_final_angle = 0
	var tween = get_tree().\
		create_tween().\
		set_trans(Tween.TRANS_QUART).\
		set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(door.door_panel, "rotation_degrees:y", float(door_final_angle), 1.5)
	tween.parallel().tween_property(
		door.doorknob, 
		"rotation_degrees:{0}".format([door.doorknob_axis]),
		-45.0,
		0.3)
	tween.parallel().tween_property(
		door.doorknob, 
		"rotation_degrees:{0}".format([door.doorknob_axis]),
		0.0,
		0.3).set_delay(1.0).from(-45.0)
	yield(tween, "finished")
	playing_animation = false
	state_machine.transition_to("Closed")
