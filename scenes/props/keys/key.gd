extends RigidBody

var inside_interactable := false

func _process(_delta: float) -> void:
	if inside_interactable and Input.is_action_just_released("left_click"):
		Events.emit_signal("collectible_collected")
		queue_free()

func _on_interactable_area_entered(_area: Area) -> void:
	inside_interactable = true
	emit_interactable_event("interactable_entered")

func _on_interactable_area_exited(_area: Area) -> void:
	inside_interactable = false
	emit_interactable_event("interactable_exited")

func emit_interactable_event(event := "") -> void:
	Events.emit_signal(
		event, 
		{ 
			interactable = self, 
			name = to_string(), 
			action = get_action()
		})

func _to_string() -> String:
	return tr("KEY_NAME")

func get_action() -> String:
	return tr("PICKABLE_ACTION")
