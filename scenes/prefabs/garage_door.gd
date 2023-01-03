class_name GarageDoor
extends Door

onready var upper_door_panel: StaticBody = $"%upper_door_panel"
onready var lower_door_panel: StaticBody = $"%lower_door_panel"
onready var upper_interactable: Area = $"%upper_interactable"
onready var lower_interactable: Area = $"%lower_interactable"

func _ready() -> void:
	var _err := upper_interactable.connect("area_entered", self, "_on_upper_interactable_area_entered")
	_err = upper_interactable.connect("area_exited", self, "_on_upper_interactable_area_exited")
	_err = lower_interactable.connect("area_entered", self, "_on_lower_interactable_area_entered")
	_err = lower_interactable.connect("area_exited", self, "_on_lower_interactable_area_exited")
	animation = funcref(animation_manager, "open_garage")

func _process(_delta: float) -> void:
	pass

func _on_upper_interactable_area_entered(_area: Area) -> void:
	interactable = upper_interactable
	inside_interactable = true
	check_clicking()
	emit_interactable_event("interactable_entered")

func _on_upper_interactable_area_exited(_area: Area) -> void:
	if interactable == upper_interactable:
		inside_interactable = false
		emit_interactable_event("interactable_exited")

func _on_lower_interactable_area_entered(_area: Area) -> void:
	interactable = lower_interactable
	inside_interactable = true
	check_clicking()
	emit_interactable_event("interactable_entered")

func _on_lower_interactable_area_exited(_area: Area) -> void:
	if interactable == lower_interactable:
		inside_interactable = false
		emit_interactable_event("interactable_exited")

func _to_string() -> String:
	return tr("GARAGE_DOOR_NAME")
