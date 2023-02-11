extends WindowState

var point_of_contact: float

func enter(_payload := {}) -> void:
	window.dragging = true
	move_lock()
	find_point_of_contact()

func exit() -> void:
	move_lock(true)

func update(_delta: float) -> void:
	if not window.is_locked:
		drag_window()
	
	if Input.is_action_just_released("primary_action")\
	or not window.is_inside():
		state_machine.transition_to("Stopped")

func drag_window() -> void:
	if window.sash:
		var looking_position := PlayerStats.looking_object["position"] as Vector3
		var from: float
		var minimum: float
		var maximum: float

		if window.rail_direction == "x":
			from = looking_position.x - point_of_contact
			minimum = min(
				window.stop_start.global_translation.x,
				window.stop_end.global_translation.x)
			maximum = max(
				window.stop_start.global_translation.x,
				window.stop_end.global_translation.x)
		else:
			from = looking_position.z - point_of_contact
			minimum = min(
				window.stop_start.global_translation.z,
				window.stop_end.global_translation.z)
			maximum = max(
				window.stop_start.global_translation.z,
				window.stop_end.global_translation.z)
		
		var to := clamp(from, minimum, maximum)
		if window.rail_direction == "x":
			window.sash.global_translation.x = to
		else:
			window.sash.global_translation.z = to

func move_lock(reverse := false) -> void:
	if window.lock:
		if not reverse:
			var tween := window.lock.create_tween()\
				.set_trans(Tween.TRANS_QUAD)\
				.set_ease(Tween.EASE_IN_OUT)
			var _discard = tween.tween_property(
				window.lock,
				"translation:y",
				window.lock_vertical_origin * 1.5,
				0.1)
		else :
			var tween := window.lock.create_tween()\
				.set_trans(Tween.TRANS_QUAD)\
				.set_ease(Tween.EASE_IN_OUT)
			var _discard = tween.tween_property(
				window.lock,
				"translation:y",
				window.lock_vertical_origin,
				0.1)\
				.from_current()

func find_point_of_contact() -> void:
	var looking_position := PlayerStats.looking_object["position"] as Vector3
	if window.rail_direction == "x":
		point_of_contact = looking_position.x \
			- window.sash.global_translation.x
	else:
		point_of_contact = looking_position.z \
			- window.sash.global_translation.z
