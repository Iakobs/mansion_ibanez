extends PanelContainer

var tween: SceneTreeTween
var cancel_showing_content := false

onready var content: VBoxContainer = $"%content"
onready var focus_button: Button = $"%language_option"

func _ready() -> void:
	set_as_toplevel(true)

func _process(_delta: float) -> void:
	pass

func _on_remap_button_pressed() -> void:
	pass # Replace with function body.

func _on_content_ready() -> void:
	if cancel_showing_content:
		return
	if !content.visible:
		content.show()

func show_at_position(position: Vector2) -> void:
	focus_button.call_deferred("grab_focus")
	rect_position = position + Vector2(-rect_min_size.x, 25)
	cancel_showing_content = false
	if tween:
		tween.kill()
	
	tween = create_tween()\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
	var _discard := tween.tween_property(
		self,
		"rect_size",
		Vector2(411, 679),
		1.0).from(Vector2(411, 0))
	show()
	if content: content.hide()
	var _error := get_tree().create_timer(0.5)\
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
		Vector2(411, 0),
		0.5).from(Vector2(411, 679))
	yield(tween, "finished")
	hide()
	cancel_showing_content = false
