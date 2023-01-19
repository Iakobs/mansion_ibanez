extends PanelContainer

enum languages { ca = 0, es = 1, en = 2 }

onready var content: Control = $"%content"
onready var language_option: OptionButton = $"%language_option"

var tween: SceneTreeTween
var cancel_showing_content := false

func _ready() -> void:
	hide()
	content.hide()
	var config_language := languages.get(ConfigManager.get_locale()) as int
	language_option.select(config_language)

func _on_content_ready() -> void:
	if cancel_showing_content:
		return
	
	if !content.visible:
		content.show()

func _on_language_option_item_selected(index: int) -> void:
	var locale := languages.keys()[index] as String
	TranslationServer.set_locale(locale)
	ConfigManager.set_locale(locale)

func animated_show() -> void:
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

func animated_hide() -> void:
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
