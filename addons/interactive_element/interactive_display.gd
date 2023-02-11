extends Control

var interactive_element: Node
var crosshair_original_size: Vector2

onready var crosshair: TextureRect = $"%crosshair"
onready var display: MarginContainer = $"%display"
onready var element_name: Label = $"%element_name"
onready var status_icon: TextureRect = $"%status_icon"
onready var action_name: Label = $"%action_name"
onready var action_icon: TextureRect = $"%action_icon"

func _ready() -> void:
	crosshair_original_size = crosshair.rect_scale
	display.visible = false
	var _error := InteractiveElementEvents.connect(
		"entered",
		self,
		"_on_interactive_element_entered")
	_error = InteractiveElementEvents.connect(
		"exited",
		self,
		"_on_interactive_element_exited")
	_error = InteractiveElementEvents.connect(
		"updated",
		self,
		"_on_interactive_element_updated")

func _on_interactive_element_entered(command: InteractiveEventCommand) -> void:
	interactive_element = command.interactive_element
	crosshair.modulate = Color.red
	update_display(command)
	display.visible = true

func _on_interactive_element_exited(command: InteractiveEventCommand) -> void:
	if command.interactive_element == interactive_element:
		interactive_element = null
		crosshair.modulate = Color.white
		display.visible = false

func _on_interactive_element_updated(command: InteractiveEventCommand) -> void:
	update_display(command)

func update_display(command: InteractiveEventCommand) -> void:
	element_name.text = command.interactive_element_name
	action_name.text = tr(command.action)
	status_icon.texture = command.status_icon
	action_icon.texture = command.action_icon

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		var tween := create_tween()\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_IN_OUT)
		var _discard = tween.tween_property(
			crosshair, 
			"rect_scale", 
			crosshair_original_size * 0.8,
			0.1)
	if event.is_action_released("primary_action"):
		var tween := create_tween()\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_IN_OUT)
		var _discard = tween.tween_property(
			crosshair, 
			"rect_scale", 
			crosshair_original_size, 
			0.1)\
			.from_current()
