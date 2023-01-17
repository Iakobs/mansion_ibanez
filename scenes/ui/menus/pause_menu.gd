extends Control

onready var animated_options_menu: PanelContainer = $"animated_options_menu"
onready var sure_popup: PopupDialog = $"%sure_popup"

var paused := false
var options_menu_is_visible := false

func _ready() -> void:
	var _error := sure_popup.connect("yes_pressed", self, "_on_yes_sure_pressed")
	_error = sure_popup.connect("no_pressed", self, "_on_no_sure_pressed")

func _on_continue_pressed() -> void:
	unpause()

func _on_quit_pressed() -> void:
	sure_popup.popup_centered()

func _on_config_button_pressed():
	if options_menu_is_visible:
		animated_options_menu.animated_hide()
	else:
		animated_options_menu.animated_show()
	options_menu_is_visible = !options_menu_is_visible

func _on_yes_sure_pressed():
	Global.game_is_running = false
	get_tree().paused = false
	SceneChanger.load_scene("res://scenes/ui/menus/main_menu.tscn")

func _on_no_sure_pressed():
	sure_popup.hide()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if options_menu_is_visible:
			animated_options_menu.hide()
			options_menu_is_visible = false
			return
		
		if not paused:
			pause()
		else:
			unpause()

func pause() -> void:
	paused = true
	get_tree().paused = paused
	show()
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

func unpause() -> void:
	paused = false
	get_tree().paused = paused
	hide()
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
