extends DoorState

func update(_delta: float) -> void:
	if not door.animation_manager.is_playing \
	and door.inside_interactable \
	and Input.is_action_just_released("left_click"):
		door.animation.call_func()
		yield(door.animation_manager, "animation_finished")
		state_machine.transition_to("Opened")
