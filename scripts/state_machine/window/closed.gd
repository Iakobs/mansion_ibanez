extends WindowState

func switch_monitoring() -> void:
	if window.interactable == window.right_interactable:
		window.left_interactable.monitoring = !window.left_interactable.monitoring
	else:
		window.right_interactable.monitoring = !window.right_interactable.monitoring

func update(_delta: float) -> void:
	if window.inside_interactable\
	and Input.is_action_just_pressed("left_click"):
		window.dragging = true
		switch_monitoring()
	
	if window.dragging\
	and Input.is_action_just_released("left_click"):
		window.dragging = false
		switch_monitoring()
	
	if window.dragging and window.sash:
		var to: float
		if window.rail_direction == "x":
			to = clamp(
				PlayerStats.touching_point.x,
				window.stop_end.global_translation.x,
				window.stop_start.global_translation.x)
			pass
		else:
			to = clamp(
				PlayerStats.touching_point.z,
				window.stop_end.global_translation.z,
				window.stop_start.global_translation.z)
			pass
		
		var tween = window.sash.create_tween()\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_IN_OUT)
		var _discard = tween.tween_property(
			window.sash, 
			"global_translation:{0}".format([window.rail_direction]), 
			to,
			0.075).from_current()
	
	tween_lock()
	
#	if not window.animation_manager.is_playing \
#	and window.inside_interactable \
#	and Input.is_action_just_released("left_click"):
#
#		if window.is_locked:
#			if PlayerStats.key_count > 0:
#				window.is_locked = false
#				PlayerStats.key_count -= 1
#				Events.emit_signal("collectible_consumed")
#				Events.emit_signal("interactable_updated", 
#				{ 
#					interactable = window, 
#					locked = false 
#				})
#		else: 
#			window.animation.call_func()
#			yield(window.animation_manager, "animation_finished")
#			window.action = tr("WINDOW_ACTION_CLOSE")
#			state_machine.transition_to("Opened")
	
	pass

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

func get_action() -> String:
	return tr("WINDOW_ACTION_OPEN")
