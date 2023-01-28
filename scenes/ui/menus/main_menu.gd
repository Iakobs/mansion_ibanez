extends Control

onready var remap_menu: Control = $"%remap_menu"
onready var scroll_text_dialog: PopupDialog = $"%scroll_text_dialog"
onready var sure_popup: PopupDialog = $"%sure_popup"

onready var focus_button: Button = $"%start"

func _ready() -> void:
	focus_button.call_deferred("grab_focus")
	var _error := sure_popup.connect("yes_pressed", self, "_on_yes_sure_pressed")
	_error = sure_popup.connect("no_pressed", self, "_on_no_sure_pressed")

func _on_start_pressed() -> void:
	SceneChanger.load_scene("res://scenes/Game.tscn")

func _on_how_to_play_pressed() -> void:
	scroll_text_dialog.popup_centered()

func _on_quit_pressed() -> void:
	sure_popup.popup_centered()

func _on_yes_sure_pressed() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _on_no_sure_pressed() -> void:
	sure_popup.hide()

func _on_remap_menu_pressed() -> void:
	remap_menu.show()
