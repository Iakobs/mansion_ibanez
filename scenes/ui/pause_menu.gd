extends Control

const PADDING_BUTON_TEXT := "  {0}  "

onready var continue_button: Button = $"%continue"
onready var quit_button: Button = $"%quit"
onready var sure_popup: PopupDialog = $"%sure_popup"
onready var sure_label: Label = $"%sure_label"
onready var yes_sure_button: Button = $"%yes_sure"
onready var no_sure_button: Button = $"%no_sure"

var paused := false

func _ready() -> void:
	continue_button.text = PADDING_BUTON_TEXT.format([tr("PAUSE_MENU_CONTINUE")])
	quit_button.text =  PADDING_BUTON_TEXT.format([tr("PAUSE_MENU_QUIT")])
	sure_label.text = tr("PAUSE_MENU_SURE_LABEL")
	yes_sure_button.text = tr("YES")
	no_sure_button.text = tr("NO")

func _on_continue_pressed() -> void:
	unpause()

func _on_quit_pressed() -> void:
	sure_popup.popup()

func _on_yes_sure_pressed():
	get_tree().quit()

func _on_no_sure_pressed():
	sure_popup.hide()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
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
