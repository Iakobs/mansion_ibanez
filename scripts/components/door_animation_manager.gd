class_name DoorAnimationManager
extends AnimationManager

export(String, "open", "open_garage") var selected_animation := "open"

func play(params := []) -> void:
	if has_method(selected_animation):
		callv(selected_animation, params)

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
	animation_finished("open", [reverse])

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
	animation_finished("open_garage", [reverse])

func unlock(
	mesh: MeshInstance, 
	destination: Position3D,
	scale_factor: Vector3,
	pushback: Vector3
) -> void:
	is_playing = true
	
	mesh.scale_object_local(scale_factor)
	var tween := mesh.create_tween()\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_OUT)
	var _discard := tween.tween_property(
		mesh, 
		"global_translation", 
		destination.global_translation + pushback,
		1.0)
	_discard = tween.tween_property(
		mesh,
		"rotation_degrees:z",
		-90.0,
		1.0).from(0.0)
	
	yield(tween, "finished")
	is_playing = false
	animation_finished("unlock", [mesh, destination])
