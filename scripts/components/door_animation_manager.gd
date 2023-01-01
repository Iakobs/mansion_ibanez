class_name DoorAnimationManager
extends AnimationManager

func open(reverse := false) -> void:
	is_playing = true
	var door_final_angle := 0.0 if reverse else float(owner.door_panel_angle)
	var tween = get_tree().\
		create_tween().\
		set_trans(Tween.TRANS_QUART).\
		set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(owner.door_panel, "rotation_degrees:y", door_final_angle, 1.5)
	tween.parallel().tween_property(
		owner.doorknob, 
		"rotation_degrees:{0}".format([owner.doorknob_axis]),
		-45.0,
		0.3)
	tween.parallel().tween_property(
		owner.doorknob, 
		"rotation_degrees:{0}".format([owner.doorknob_axis]),
		0.0,
		0.3).set_delay(1.0).from(-45.0)
	yield(tween, "finished")
	is_playing = false
	emit_signal("animation_finished")

func open_garage(reverse := false) -> void:
	is_playing = true
	var upper_door_final_angle := 0.0 if reverse else -85.0
	var lower_door_final_angle := 0.0 if reverse else 170.0
	var tween = get_tree().\
		create_tween().\
		set_trans(Tween.TRANS_QUART).\
		set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		owner.upper_door_panel, 
		"rotation_degrees:x", 
		upper_door_final_angle,
		3.0)
	tween.parallel().tween_property(
		owner.lower_door_panel, 
		"rotation_degrees:x", 
		lower_door_final_angle, 
		3.0)
	yield(tween, "finished")
	is_playing = false
	emit_signal("animation_finished")
