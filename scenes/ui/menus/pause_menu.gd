extends Control

onready var options_menu: Button = $"%options_menu"
onready var sure_popup: PopupDialog = $"%sure_popup"
onready var continue_button: Button = $"%continue"

var paused := false

func _ready() -> void:
	unpause()
	var _error := sure_popup.connect("yes_pressed", self, "_on_yes_sure_pressed")
	_error = sure_popup.connect("no_pressed", self, "_on_no_sure_pressed")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not paused:
			pause()
		else:
			unpause()
		get_tree().set_input_as_handled()

func _on_continue_pressed() -> void:
	unpause()

func _on_quit_pressed() -> void:
	sure_popup.popup_centered()

func _on_yes_sure_pressed():
	Global.game_is_running = false
	get_tree().paused = false
	SceneChanger.load_scene("res://scenes/ui/menus/main_menu.tscn")

func _on_no_sure_pressed():
	sure_popup.hide()

func pause() -> void:
	paused = true
	get_tree().paused = paused
	show()
	continue_button.call_deferred("grab_focus")
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

func unpause() -> void:
	paused = false
	get_tree().paused = paused
	hide()
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
