extends Control

onready var controller_section_scroll_container: ScrollContainer = $"%controller_section_scroll_container"

func _ready() -> void:
	controller_section_scroll_container.get_v_scrollbar().custom_step = 50

func _on_button_back_pressed() -> void:
	Events.emit_signal("remap_submenu_closed")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_page_down"):
		controller_section_scroll_container.get_v_scrollbar().value += 10
	elif Input.is_action_pressed("ui_page_up"):
		controller_section_scroll_container.get_v_scrollbar().value -= 10
