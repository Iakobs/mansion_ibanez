extends KeyBindingButton



export(InputEventJoypadButton) var input_event: InputEventJoypadButton

func setup_button() -> void:
	var action_name := InputMapManager.get_action_from_joypad_button_event(input_event)
	set_button_text(action_name)

func fill_menu() -> void:
	var popup := get_popup()
	popup.clear()
	
	popup.add_item(tr("ACTION_UNASSIGN"))
	popup.add_separator(tr("ACTION_SEPARATOR"))
	
	var sorted_list := []
	
	for action_name in InputMapManager.get_actions():
		sorted_list.append({ metadata = action_name, translation = tr(action_name) })
	
	sorted_list.sort_custom(MyCustomSorter, "sort")
	var item_id := 1
	for item in sorted_list:
		popup.add_item(item.translation, item_id)
		popup.set_item_metadata(popup.get_item_index(item_id), item.metadata)
		item_id += 1

func change_action(new_action: String) -> void:
	if !new_action.empty():
		var action_events := InputMapManager.get_action_events(new_action)
		var action_in_use := (ActionEvents.JoypadButton.none != action_events.joypad_button_index) as bool
		if action_in_use:
			handle_action_already_in_use()
		else:
			action_events.joypad_button_index = input_event.button_index
			SaveManager.set_action(new_action, action_events)
			InputMapManager.add_events_to_action(new_action, action_events)
			assign(new_action)
	else:
		var old_action = action
		if not old_action.empty():
			InputMapManager.remove_event_from_action(old_action, input_event)
			var action_events := InputMapManager.get_action_events(old_action)
			SaveManager.set_action(old_action, action_events)
			unassign()
