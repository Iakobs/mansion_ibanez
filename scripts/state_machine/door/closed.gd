extends DoorState

func update(_delta: float) -> void:
	if not door.animation_manager.is_playing \
	and door.inside_interactable \
	and Input.is_action_just_released("left_click"):
		
		if door.is_locked:
			if PlayerStats.key_count > 0:
				door.is_locked = false
				PlayerStats.key_count -= 1
				Events.emit_signal("collectible_consumed")
				Events.emit_signal("interactable_updated", 
				{ 
					interactable = door, 
					locked = false 
				})
		else: 
			door.animation.call_func()
			yield(door.animation_manager, "animation_finished")
			door.action = tr("DOOR_ACTION_CLOSE")
			state_machine.transition_to("Opened")

func get_action() -> String:
	return tr("DOOR_ACTION_OPEN")
