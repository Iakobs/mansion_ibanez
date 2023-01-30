extends Control

signal iterable_changed(element)

export(Array, Dictionary) var iterable: Array

var current_index := 0

onready var current_element_label: RichTextLabel = $"%current_element_label"
onready var go_left: Button = $"%go_left"
onready var go_right: Button = $"%go_right"

func _ready() -> void:
	display_current_index()

func _input(event: InputEvent) -> void:
	if current_element_label.has_focus():
		if event.is_action_pressed("ui_left"):
			go_left.emit_signal("pressed")
		if event.is_action_pressed("ui_right"):
			go_right.emit_signal("pressed")
	if event.is_action_pressed("ui_page_next"):
		go_right.emit_signal("pressed")
	if event.is_action_pressed("ui_page_previous"):
		go_left.emit_signal("pressed")

func _on_go_left_pressed() -> void:
	previous_element()

func _on_go_right_pressed() -> void:
	next_element()

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

func _on_focus_entered() -> void:
	current_element_label.call_deferred("grab_focus")

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		display_current_index()
