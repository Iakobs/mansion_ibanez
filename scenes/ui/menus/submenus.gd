extends Control

onready var remap_menu: Control = $"%remap_menu"
onready var audio_menu: Control = $"%audio_menu"

var siblings := []

func _ready() -> void:
	var _error := Events.connect("remap_submenu_requested", self, "_on_remap_submenu_request")
	_error = Events.connect("remap_submenu_closed", self, "_on_remap_submenu_closed")
	_error = Events.connect("audio_submenu_requested", self, "_on_audio_submenu_request")
	_error = Events.connect("audio_submenu_closed", self, "_on_audio_submenu_closed")
	for sibling in get_parent().get_children():
		if sibling != self:
			siblings.append(sibling)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		handle_ui_cancel()
		get_tree().set_input_as_handled()

func _on_remap_submenu_request() -> void:
	change_siblings_visibility(false)
	remap_menu.show()

func _on_remap_submenu_closed() -> void:
	change_siblings_visibility()
	remap_menu.hide()

func _on_audio_submenu_request() -> void:
	change_siblings_visibility(false)
	audio_menu.show()

func _on_audio_submenu_closed() -> void:
	change_siblings_visibility()
	audio_menu.hide()

func handle_ui_cancel() -> void:
	for child in get_children():
		child.hide()
	change_siblings_visibility()

func change_siblings_visibility(visible := true) -> void:
	for sibling in siblings:
		if sibling is Popup:
			continue
		sibling.visible = visible
