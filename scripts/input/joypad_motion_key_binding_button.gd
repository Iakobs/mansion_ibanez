extends KeyBindingButton

export(InputEventJoypadMotion) var input_event: InputEventJoypadMotion

func setup_button() -> void:
	var action_name := InputMapManager.get_action_from_joypad_motion_event(input_event)
	set_button_text(action_name)

func fill_menu() -> void:
	var popup := get_popup()
	
	popup.add_item(tr("ACTION_UNASSIGN"))
	popup.add_separator(tr("ACTION_SEPARATOR"))
	
	var sorted_list := []
	
	for action_name in InputMapManager.get_axis_actions():
		sorted_list.append({ metadata = action_name, translation = tr(action_name) })
	
	sorted_list.sort_custom(MyCustomSorter, "sort")
	var item_id := 1
	for item in sorted_list:
		popup.add_item(item.translation, item_id)
		popup.set_item_metadata(popup.get_item_index(item_id), item.metadata)
		item_id += 1

func change_action(new_action: String) -> void:
	if !new_action.empty():
		pass
	else:
		pass
#		InputMapManager.remove_event_from_action(action, input_event)
#		unassign()
