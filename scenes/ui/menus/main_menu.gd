extends Control

onready var animated_options_menu: PanelContainer = $"animated_options_menu"
onready var sure_popup: PopupDialog = $"%sure_popup"
onready var scroll_text_dialog: PopupDialog = $"%scroll_text_dialog"
onready var start_button: Button = $"%start"
onready var config_button: Button = $"%config_button"

var options_menu_is_visible := false

func _ready() -> void:
	start_button.call_deferred("grab_focus")
	var _error := sure_popup.connect("yes_pressed", self, "_on_yes_sure_pressed")
	_error = sure_popup.connect("no_pressed", self, "_on_no_sure_pressed")

func _on_config_button_toggled(button_pressed):
	if button_pressed:
		animated_options_menu.animated_show()
	else:
		animated_options_menu.animated_hide()

func _on_start_pressed() -> void:
	SceneChanger.load_scene("res://scenes/Game.tscn")

func _on_how_to_play_pressed() -> void:
	scroll_text_dialog.popup_centered()

func _on_quit_pressed() -> void:
	sure_popup.popup_centered()

func _on_yes_sure_pressed():
	get_tree().quit()

func _on_no_sure_pressed():
	sure_popup.hide()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if animated_options_menu.visible:
			animated_options_menu.hide()
			config_button.call_deferred("grab_focus")
			config_button.set_pressed_no_signal(false)
			return
