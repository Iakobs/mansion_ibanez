extends Control

signal iterable_changed(element)

export(Array, Dictionary) var iterable: Array

var current_index := 0
var normal_style_resource := preload("res://resources/ui/button_normal.tres")
var hover_style_resource := preload("res://resources/ui/button_hover.tres")
var go_left_initial_position: Vector2
var go_right_initial_position: Vector2
var is_mouse_inside := false

onready var current_element_label: RichTextLabel = $"%current_element_label"
onready var go_left: Button = $"%go_left"
onready var go_right: Button = $"%go_right"

func _ready() -> void:
	display_current_index()
	var _error := Events.connect("is_joystick_active", self, "_on_joystick_active")
	_error = go_left.connect("mouse_entered", self, "_on_mouse_entered", [go_left])
	_error = go_left.connect("mouse_exited", self, "_on_mouse_exited", [go_left])
	_error = go_right.connect("mouse_entered", self, "_on_mouse_entered", [go_right])
	_error = go_right.connect("mouse_exited", self, "_on_mouse_exited", [go_right])
	AudioManager.connect_on_hover_or_focus(current_element_label)
	go_left_initial_position = go_left.rect_position
	go_right_initial_position = go_right.rect_position

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if event.is_action_pressed("ui_page_next"):
			go_right.emit_signal("pressed")
			current_element_label.call_deferred("grab_focus")
		if event.is_action_pressed("ui_page_previous"):
			go_left.emit_signal("pressed")
			current_element_label.call_deferred("grab_focus")
		return
	
	if is_mouse_inside:
		if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_page_previous"):
			go_left.emit_signal("pressed")
		if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_page_next"):
			go_right.emit_signal("pressed")
	elif current_element_label.has_focus():
		if event.is_action_pressed("ui_left"):
			go_left.emit_signal("pressed")
		if event.is_action_pressed("ui_right"):
			go_right.emit_signal("pressed")

func previous_element():
	if iterable:
		var new_index := current_index - 1
		if new_index < 0:
			new_index = iterable.size() - 1
		current_index = new_index
		display_current_index()
		emit_signal("iterable_changed", iterable[current_index].element)

func next_element():
	if iterable:
		var new_index := current_index + 1
		if new_index >= iterable.size():
			new_index = 0
		current_index = new_index
		display_current_index()
		emit_signal("iterable_changed", iterable[current_index].element)

func display_current_index() -> void:
	var text := tr(iterable[current_index].name) if iterable else ""
	current_element_label.bbcode_text = "[center]{0}[/center]".format([text])

func _on_mouse_entered(control: Control) -> void:
	control.modulate = Color("f9a300")

func _on_mouse_exited(control: Control) -> void:
	control.modulate = Color.white

func _on_go_left_pressed() -> void:
	TweenManager.shake_horizontal(go_left, -1, 4)
	AudioManager.toggle.play()
	previous_element()

func _on_go_right_pressed() -> void:
	TweenManager.shake_horizontal(go_right, 1, 4)
	AudioManager.toggle.play()
	next_element()

func _on_focus_entered() -> void:
	TweenManager.shake_vertical(current_element_label)
	current_element_label.call_deferred("grab_focus")

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		display_current_index()

func _on_current_element_label_mouse_entered() -> void:
	is_mouse_inside = true
	current_element_label.call_deferred("grab_focus")
	current_element_label.add_stylebox_override("normal", hover_style_resource)

func _on_current_element_label_mouse_exited() -> void:
	is_mouse_inside = false
	current_element_label.add_stylebox_override("normal", normal_style_resource)

func _on_joystick_active(value: bool) -> void:
	if value:
		go_left.icon = Global.page_previous_icon
		go_right.icon = Global.page_next_icon
	else:
		go_left.icon = Global.backward_icon
		go_right.icon = Global.forward_icon
