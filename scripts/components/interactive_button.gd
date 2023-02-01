class_name InteractiveButton

extends Node

var parent: Button
var initial_position := Vector2.INF
var tween: SceneTreeTween = null

func _enter_tree() -> void:
	parent = get_parent() as Button
	connect_button(parent)

func animate_button(direction := 1) -> void:
	if tween != null:
		return
	tween = parent.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var _discard := tween.tween_property(
		parent,
		"rect_position",
		parent.rect_position,
		0.5).from(parent.rect_position + Vector2(0, -2.5 * direction))
	yield(tween, "finished")
	tween = null

func _on_button_toggled(_button_pressed: bool) -> void:
	AudioManager.toggle.play()

func _on_button_click() -> void:
	AudioManager.click.play()
	call_deferred("animate_button", -1)

func _on_button_release() -> void:
	AudioManager.release.play()

func _on_hover_or_focus() -> void:
	AudioManager.hover_or_focus.play()
	call_deferred("animate_button")

func _on_lost_hover_or_focus() -> void:
	pass

func _on_id_focused(_index: int) -> void:
	AudioManager.hover_or_focus.play()

func _on_visibility_changed() -> void:
	if initial_position == Vector2.INF:
		initial_position = parent.rect_position

func connect_button(button: Button) -> void:
	connect_on_hover_or_focus(button)
	connect_visibility_changed(button)
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
	_error = control.connect("focus_exited", self, "_on_lost_hover_or_focus")
	_error = control.connect("mouse_exited", self, "_on_lost_hover_or_focus")

func connect_popup_menu(popup: PopupMenu) -> void:
	var _error := popup.connect("id_focused", self, "_on_id_focused")
	_error = popup.connect("mouse_entered", self, "_on_hover_or_focus")

func connect_visibility_changed(control: Control) -> void:
	var _error := control.connect("visibility_changed", self, "_on_visibility_changed")
