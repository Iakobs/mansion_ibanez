extends DoorState

func enter(_payload := {}) -> void:
	door.change_action("ACTION_OPEN")

func exit() -> void:
	door.animation_manager.play()

func update(_delta: float) -> void:
	if not door.animation_manager.is_playing\
	and door.interactive_element.is_inside\
	and not door.is_locked\
	and Input.is_action_just_released("primary_action"):
		if door.clicking_is_active:
			state_machine.transition_to("Opened")
		else:
			door.clicking_is_active = true
