class_name GarageDoor
extends Door

onready var upper_door_panel: StaticBody = $"%upper_door_panel"
onready var lower_door_panel: StaticBody = $"%lower_door_panel"
onready var upper_interactive_element: Area = $"%UpperInteractiveElement"
onready var lower_interactive_element: Area = $"%LowerInteractiveElement"

func _ready() -> void:
	upper_interactive_element.status_icon = Global.locked_icon if is_locked else null
	lower_interactive_element.status_icon = Global.locked_icon if is_locked else null
	var _err := upper_interactive_element\
		.connect("area_entered", self, "_on_upper_interactive_element_area_entered")
	_err = lower_interactive_element\
		.connect("area_entered", self, "_on_lower_interactive_element_area_entered")

func _process(_delta: float) -> void:
	pass

func _on_upper_interactive_element_area_entered(_area: Area) -> void:
	interactive_element = upper_interactive_element
	call_deferred("check_clicking")

func _on_lower_interactive_element_area_entered(_area: Area) -> void:
	interactive_element = lower_interactive_element
	call_deferred("check_clicking")

func change_action(new_action: String) -> void:
	upper_interactive_element.action = new_action
	lower_interactive_element.action = new_action

func finish_unlock() -> void:
	is_locked = false
	upper_interactive_element.status_icon = null
	lower_interactive_element.status_icon = null
