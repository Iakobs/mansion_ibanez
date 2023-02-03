extends Control

onready var keyboard_section_scroll_container: ScrollContainer = $"%keyboard_section_scroll_container"
onready var controller_section_scroll_container: ScrollContainer = $"%controller_section_scroll_container"
onready var tab_container: TabContainer = $"%tab_container"
onready var focus_button: Button = $"%button_back"
onready var iterable_button: HBoxContainer = $"%iterable_button"

func _ready() -> void:
	keyboard_section_scroll_container.get_v_scrollbar().custom_step = 50
	controller_section_scroll_container.get_v_scrollbar().custom_step = 50
	var _error := iterable_button.connect("iterable_changed", self, "_on_iterable_changed")

func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel") and not focus_button.has_focus():
		focus_button.call_deferred("grab_focus")
		get_tree().set_input_as_handled()

func _on_iterable_changed(element) -> void:
	tab_container.current_tab = element

func _on_button_back_pressed() -> void:
	Events.emit_signal("remap_submenu_closed")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_page_down"):
		if keyboard_section_scroll_container.is_visible_in_tree():
			keyboard_section_scroll_container.get_v_scrollbar().value += 10
		if controller_section_scroll_container.is_visible_in_tree():
			controller_section_scroll_container.get_v_scrollbar().value += 10
	elif Input.is_action_pressed("ui_page_up"):
		if keyboard_section_scroll_container.is_visible_in_tree():
			keyboard_section_scroll_container.get_v_scrollbar().value -= 10
		if controller_section_scroll_container.is_visible_in_tree():
			controller_section_scroll_container.get_v_scrollbar().value -= 10

func _on_visibility_changed() -> void:
	if visible:
		focus_button.call_deferred("grab_focus")

func _on_button_reset_pressed() -> void:
	for action_resource in InputMapManager.actions:
		var action := action_resource as Action
		var default_events := action.default_values as ActionEvents
		SaveManager.reset_action(action.name, default_events)
