extends WindowState

func update(_delta: float) -> void:
	if not window.animation_manager.is_playing \
	and window.inside_interactable \
	and Input.is_action_just_released("left_click"):
		
		if window.is_locked:
			if PlayerStats.key_count > 0:
				window.is_locked = false
				PlayerStats.key_count -= 1
				Events.emit_signal("collectible_consumed")
				Events.emit_signal("interactable_updated", 
				{ 
					interactable = window, 
					locked = false 
				})
		else: 
			window.animation.call_func()
			yield(window.animation_manager, "animation_finished")
			window.action = tr("WINDOW_ACTION_CLOSE")
			state_machine.transition_to("Opened")

func get_action() -> String:
	return tr("WINDOW_ACTION_OPEN")
