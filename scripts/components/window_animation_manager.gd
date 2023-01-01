class_name WindowAnimationManager
extends AnimationManager

var open_distance := 0.645
var lock_distance := -0.013

func open(reverse := false) -> void:
#	is_playing = true
#	var sash = owner.right_sash
#	var stop = owner.right_stop
#	var lock = owner.right_lock
#	if owner.interactable == owner.left_interactable:
#		sash = owner.left_sash
#		stop = owner.left_stop
#		lock = owner.right_lock
#
#	open_distance = sash.translation.z - stop.translation.z
#
#	var tween = get_tree().\
#		create_tween().\
#		set_trans(Tween.TRANS_QUART).\
#		set_ease(Tween.EASE_IN_OUT)
#
#	tween.tween_property(
#		sash, 
#		"translation:{0}".format([owner.rail_direction]), 
#		open_distance if reverse else open_distance * -1, 
#		1.5).from_current()
#	tween.parallel().tween_property(
#		lock, 
#		"translation:y",
#		lock_distance,
#		0.3).from_current()
#	tween.parallel().tween_property(
#		lock, 
#		"translation:y",
#		lock_distance * -1.0,
#		0.3).set_delay(1.9).from_current()
	
#	yield(tween, "finished")
#	is_playing = false
	emit_signal("animation_finished")
