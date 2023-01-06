extends DoorState

func enter(_payload := {}) -> void:
	door.action = tr("DOOR_ACTION_CLOSE")

func exit() -> void:
	door.animation_manager.play([true])

func update(_delta: float) -> void:
	if not door.animation_manager.is_playing \
	and door.inside_interactable \
	and Input.is_action_just_released("primary_action"):
		if door.clicking_is_active:
			state_machine.transition_to("Closed")
		else:
			door.clicking_is_active = true
