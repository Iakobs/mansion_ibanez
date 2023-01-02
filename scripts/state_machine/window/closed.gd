extends WindowState

var point_of_contact: float

func switch_monitoring() -> void:
	if window.interactable == window.right_interactable:
		window.left_interactable.monitoring = !window.left_interactable.monitoring
		window.left_interactable.monitorable = !window.left_interactable.monitorable
	else:
		window.right_interactable.monitoring = !window.right_interactable.monitoring
		window.right_interactable.monitorable = !window.right_interactable.monitorable

func update(_delta: float) -> void:
	if window.inside_interactable\
	and Input.is_action_just_pressed("left_click"):
		window.dragging = true
		switch_monitoring()
		
		if window.rail_direction == "x":
			point_of_contact = PlayerStats.touching_point.x - window.sash.global_translation.x
		else:	
			point_of_contact = PlayerStats.touching_point.z - window.sash.global_translation.z
		
	
	if window.dragging\
	and Input.is_action_just_released("left_click"):
		window.dragging = false
		switch_monitoring()

	if window.dragging and window.sash:
		var position: float
		var minimum: float
		var maximum: float

		if window.rail_direction == "x":
			position = PlayerStats.touching_point.x
			minimum = min(
				window.stop_end.global_translation.x, 
				window.stop_start.global_translation.x)
			maximum = max(
				window.stop_end.global_translation.x, 
				window.stop_start.global_translation.x)
		else:
			position = PlayerStats.touching_point.z
			minimum = min(
				window.stop_end.global_translation.z, 
				window.stop_start.global_translation.z)
			maximum = max(
				window.stop_end.global_translation.z, 
				window.stop_start.global_translation.z)

#		print("distance: %s" % distance_to_sash_center)
#		print("position: %s" % position)
		var to := clamp(position - point_of_contact, minimum, maximum)

		var tween = window.sash.create_tween()\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_IN_OUT)
		var _discard = tween.tween_property(
			window.sash, 
			"global_translation:{0}".format([window.rail_direction]), 
			to,
			0.075).from_current()

	tween_lock()

func tween_lock() -> void:
	if window.lock:
		if window.dragging:
			var tween := window.lock.create_tween()\
				.set_trans(Tween.TRANS_QUAD)\
				.set_ease(Tween.EASE_IN_OUT)
			var _discard = tween.tween_property(
				window.lock, 
				"translation:y", 
				window.lock_vertical_origin * 1.5,
				0.1)
		else:
			var tween := window.lock.create_tween()\
				.set_trans(Tween.TRANS_QUAD)\
				.set_ease(Tween.EASE_IN_OUT)
			var _discard = tween.tween_property(
				window.lock, 
				"translation:y", 
				window.lock_vertical_origin, 
				0.1)\
				.from_current()
