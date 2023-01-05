extends DoorState

func update(_delta: float) -> void:
	if not door.animation_manager.is_playing \
	and door.inside_interactable \
	and Input.is_action_just_released("primary_action"):
		
		if not door.clicking_is_active:
			door.clicking_is_active = true
			return
		
		door.animation_manager.play([true])
		yield(door.animation_manager, "animation_finished")
		door.action = tr("DOOR_ACTION_OPEN")
		state_machine.transition_to("Closed")

func get_action() -> String:
	return tr("DOOR_ACTION_CLOSE")
