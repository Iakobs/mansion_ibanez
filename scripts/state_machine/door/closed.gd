extends DoorState

func update(_delta: float) -> void:
	if not door.animation_manager.is_playing \
	and door.inside_interactable \
	and Input.is_action_just_released("primary_action"):
		
		if not door.clicking_is_active:
			door.clicking_is_active = true
			return
		
		if door.is_locked:
			pass
#			if PlayerStats.key_count > 0:
#				door.is_locked = false
#				Events.emit_signal("collectible_consumed",
#					{ collectibles = [Events.collectibles.key] })
#				Events.emit_signal("interactable_updated", 
#				{ 
#					interacter = door, 
#					locked = false 
#				})
		else: 
			door.animation_manager.play()
			yield(door.animation_manager, "animation_finished")
			door.action = tr("DOOR_ACTION_CLOSE")
			state_machine.transition_to("Opened")

func get_action() -> String:
	return tr("DOOR_ACTION_OPEN")
