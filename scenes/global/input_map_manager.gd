extends Node

export(Array, Resource) var actions := []

var cache := {}

func clear_cache() -> void:
	cache = {}
	for action in actions:
		var events := []
		for event in InputMap.get_action_list(action.name):
			events.append(event)
		cache[action.name] = events

func reset_action(action: String, events: ActionEvents) -> void:
	InputMap.erase_action(action)
	InputMap.add_action(action)
	add_events_to_action(
		action,
		events)

func add_events_to_action(action: String, events: ActionEvents) -> void:
	add_keyboard_keys_to_action(action, events.keyboard_keys)
	add_joypad_button_to_action(action, events.joypad_button_index)
	add_joypad_motion_to_action(
		action, 
		events.joypad_motion_axis, 
		events.joypad_motion_axis_value)
	add_mouse_button_to_action(action, events.mouse_button_index)

func add_keyboard_keys_to_action(action: String, keyboard_keys: Array) -> void:
	if !keyboard_keys.empty():
		assert(keyboard_keys.size() <= 2)
		for scancode in keyboard_keys:
			var input_event := InputEventKey.new()
			input_event.scancode = scancode
			InputMap.action_add_event(action, input_event)
			clear_cache()

func add_joypad_button_to_action(action: String, button_index: int) -> void:
	if button_index > -1:
		var input_event := InputEventJoypadButton.new()
		input_event.button_index = button_index
		InputMap.action_add_event(action, input_event)
		clear_cache()

func add_joypad_motion_to_action(action: String, axis: int, axis_value: int) -> void:
	if axis > -1:
		var input_event := InputEventJoypadMotion.new()
		input_event.axis = axis
		input_event.axis_value = axis_value
		InputMap.action_add_event(action, input_event)
		clear_cache()

func add_mouse_button_to_action(action: String, button_index: int) -> void:
	if button_index > -1:
		var input_event := InputEventMouseButton.new()
		input_event.button_index = button_index
		InputMap.action_add_event(action, input_event)
		clear_cache()

func remove_event_from_action(action: String, event: InputEvent) -> void:
	if InputMap.has_action(action) and InputMap.action_has_event(action, event):
		InputMap.action_erase_event(action, event)
		clear_cache()

func get_actions() -> Array:
	return cache.keys()

func get_action_events(action: String) -> ActionEvents:
	var events := cache.get(action, []) as Array
	var action_events := null if events.empty() else ActionEvents.new()
	for event in events:
		if event is InputEventKey:
			action_events.keyboard_keys.append(event.scancode)
		if event is InputEventJoypadMotion:
			action_events.joypad_motion_axis = event.axis
			action_events.joypad_motion_axis_value = event.axis_value
		if event is InputEventJoypadButton:
			action_events.joypad_button_index = event.button_index
		if event is InputEventMouseButton:
			action_events.mouse_button_index = event.button_index
	return action_events

func get_axis_actions() -> Array:
	var result := []
	for action_resource in actions:
		var action := action_resource as Action
		if action.is_axis:
			result.append(action.name)
	
	return result

func get_action_from_joypad_button_event(event: InputEventJoypadButton) -> String:
	for action in cache.keys():
		for cached_event in cache[action]:
			if cached_event is InputEventJoypadButton\
			and cached_event.button_index == event.button_index:
				return action
	return ""

func get_action_from_joypad_motion_event(event: InputEventJoypadMotion) -> String:
	for action in cache.keys():
		for cached_event in cache[action]:
			if cached_event is InputEventJoypadMotion\
			and cached_event.axis == event.axis\
			and cached_event.axis_value == event.axis_value:
				return action
	return ""

func get_keyboard_keys_from_action(action: String) -> Array:
	var keys := []
	if action:
		for event in cache[action]:
			if event is InputEventKey:
				keys.append(event)
	return keys

func get_mouse_button_index_from_action(action: String) -> int:
	if action:
		for event in cache[action]:
			if event is InputEventMouseButton:
				return event.button_index
	return -1

func key_is_assigned(scancode: int) -> bool:
	for action in cache.keys():
		for event in cache[action]:
			if event is InputEventKey and event.scancode == scancode:
				return true
	return false
