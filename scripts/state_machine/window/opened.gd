extends WindowState

func update(_delta: float) -> void:
	if not window.animation_manager.is_playing \
	and window.inside_interactable \
	and Input.is_action_just_released("left_click"):
		window.animation.call_func(true)
		yield(window.animation_manager, "animation_finished")
		window.action = tr("WINDOW_ACTION_OPEN")
		state_machine.transition_to("Closed")

func get_action() -> String:
	return tr("WINDOW_ACTION_CLOSE")
