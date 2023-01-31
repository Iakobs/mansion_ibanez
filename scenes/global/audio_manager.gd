extends Node2D

onready var toggle: AudioStreamPlayer = $"%toggle"
onready var click: AudioStreamPlayer = $"%click"
onready var release: AudioStreamPlayer = $"%release"
onready var hover_or_focus: AudioStreamPlayer = $"%hover_or_focus"
onready var menu_music: AudioStreamPlayer = $"%menu_music"
onready var pause: AudioStreamPlayer = $"%pause"

func _ready() -> void:
	for button in get_tree().get_nodes_in_group("button"):
		connect_button(button)

func _on_button_toggled(_button_pressed: bool) -> void:
	toggle.play()

func _on_button_click() -> void:
	click.play()

func _on_button_release() -> void:
	release.play()

func _on_hover_or_focus() -> void:
	hover_or_focus.play()

func _on_id_focused(_index: int) -> void:
	hover_or_focus.play()

func connect_button(button: Button) -> void:
	connect_on_hover_or_focus(button)
	if button.toggle_mode:
		var _error := button.connect("toggled", self, "_on_button_toggled")
	else:
		connect_clik_and_release(button)
	
	if button is MenuButton or button is OptionButton:
		connect_popup_menu(button.get_popup())

func connect_clik_and_release(button: Button) -> void:
	var _error := button.connect("button_down", self, "_on_button_click")
	_error = button.connect("button_up", self, "_on_button_release")

func connect_on_hover_or_focus(control: Control) -> void:
	var _error := control.connect("focus_entered", self, "_on_hover_or_focus")
	_error = control.connect("mouse_entered", self, "_on_hover_or_focus")

func connect_popup_menu(popup: PopupMenu) -> void:
	var _error := popup.connect("id_focused", self, "_on_id_focused")
	_error = popup.connect("mouse_entered", self, "_on_hover_or_focus")
