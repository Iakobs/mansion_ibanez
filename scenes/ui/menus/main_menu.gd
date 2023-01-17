extends Control

onready var animated_options_menu: PanelContainer = $"animated_options_menu"
onready var sure_popup: PopupDialog = $"%sure_popup"
onready var scroll_text_dialog: PopupDialog = $"%scroll_text_dialog"
onready var start_button: Button = $"%start"

var options_menu_is_visible := false

func _ready() -> void:
	start_button.grab_focus()
	var _error := sure_popup.connect("yes_pressed", self, "_on_yes_sure_pressed")
	_error = sure_popup.connect("no_pressed", self, "_on_no_sure_pressed")

func _on_config_button_pressed() -> void:
	if options_menu_is_visible:
		animated_options_menu.animated_hide()
	else:
		animated_options_menu.animated_show()
	options_menu_is_visible = !options_menu_is_visible

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
		if options_menu_is_visible:
			animated_options_menu.hide()
			options_menu_is_visible = false
			return
