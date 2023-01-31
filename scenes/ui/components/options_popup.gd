extends PanelContainer

var tween: SceneTreeTween
var cancel_showing_content := false
var mouse_is_inside := false
var min_horizontal_rect_size := 411.0
var max_vertical_rect_size := 679.0

onready var content: VBoxContainer = $"%content"
onready var focus_button: Button = $"%language_option"

func _ready() -> void:
	set_as_toplevel(true)

func _on_remap_button_pressed() -> void:
	Events.emit_signal("remap_submenu_requested")

func _on_audio_button_pressed() -> void:
	Events.emit_signal("audio_submenu_requested")

func _on_content_ready() -> void:
	if cancel_showing_content:
		return
	if !content.visible:
		content.show()
		focus_button.call_deferred("grab_focus")

func show_at_position(position: Vector2) -> void:
	rect_position = position
	cancel_showing_content = false
	if tween:
		tween.kill()
	
	tween = create_tween()\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
	var _discard := tween.tween_property(
		self,
		"rect_size",
		Vector2(min_horizontal_rect_size, max_vertical_rect_size),
		1.0).from(Vector2(min_horizontal_rect_size, 0))
	show()
	if content: content.hide()
	var _error := get_tree().create_timer(1.0)\
		.connect("timeout", self, "_on_content_ready")

func hide_panel() -> void:
	cancel_showing_content = true
	if tween:
		tween.kill()
	
	content.hide()
	tween = create_tween()\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_IN)
	var _discard := tween.tween_property(
		self,
		"rect_size",
		Vector2(min_horizontal_rect_size, 0),
		0.5).from(Vector2(min_horizontal_rect_size, max_vertical_rect_size))
	yield(tween, "finished")
	hide()
	cancel_showing_content = false
