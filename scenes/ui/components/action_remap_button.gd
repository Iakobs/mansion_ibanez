extends Control

var import_icon := preload("res://assets/images/kenney_gameicons/PNG/White/1x/import.png")
var trash_icon := preload("res://assets/images/kenney_gameicons/PNG/White/1x/trashcan.png")
var trash_open_icon := preload("res://assets/images/kenney_gameicons/PNG/White/1x/trashcanOpen.png")
var window_dialog_resource := preload("res://scenes/ui/components/window_dialog.tscn")

var action: String
var input_event: InputEventKey setget set_input_event

onready var unassign_button: Button = $"%unassign_button"
onready var assign_button: Button = $"%assign_button"

func _ready() -> void:
	set_process_input(false)
	var _error := connect("visibility_changed", self, "_on_visibility_changed")
	_error = assign_button.connect("toggled", self, "_on_assign_button_toggled")
	if is_in_group("left"):
		unassign_button.focus_neighbour_left = unassign_button.get_path()
	elif is_in_group("right"):
		assign_button.focus_neighbour_right = assign_button.get_path()

func _on_assign_button_toggled(button_pressed: bool) -> void:
	set_process_input(button_pressed)
	if button_pressed:
		assign_button.text = ""
		assign_button.icon = import_icon
	else:
		assign_button.icon = null
		update_text()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode in ActionEvents.Keys.values():
			if InputMapManager.key_is_assigned(event.scancode):
				toast("LABEL_KEY_IN_USE")
			else:
				set_input_event(event)
				var action_events := InputMapManager.get_action_events(action)
				action_events.keyboard_keys.append(input_event.scancode)
				InputMapManager.add_events_to_action(action, action_events)
				SaveManager.set_action(action, action_events)
		else:
			toast("LABEL_KEY_NOT_ALLOWED")
		
		assign_button.pressed = false
		get_tree().set_input_as_handled()

func _on_unassign_focus_or_hover_entered() -> void:
	unassign_button.icon = trash_open_icon

func _on_unassign_focus_or_hover_exited() -> void:
	unassign_button.icon = trash_icon

func _on_visibility_changed() -> void:
	assign_button.icon = null
	if assign_button.pressed:
		assign_button.pressed = false

func set_input_event(event: InputEventKey) -> void:
	input_event = event
	update_text()

func update_text() -> void:
	assign_button.text = input_event.as_text() if input_event else ""

func toast(message: String) -> void:
	var dialog := window_dialog_resource.instance()
	dialog.dialog = message
	add_child(dialog)
	dialog.popup_centered()

func _on_unassign_button_pressed() -> void:
	if input_event:
		InputMapManager.remove_event_from_action(action, input_event)
		var action_events := InputMapManager.get_action_events(action)
		SaveManager.set_action(action, action_events)
		set_input_event(null)
