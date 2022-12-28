extends DoorState

func update(_delta: float) -> void:
	if not door.is_animation_playing() \
	and door.inside_interactable \
	and Input.is_action_just_released("left_click"):
		door.animation_manager.open_animation()
		yield(door.animation_manager, "animation_finished")
		state_machine.transition_to("Opened")
