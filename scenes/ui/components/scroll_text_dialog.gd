extends PopupDialog

export var text := ""

onready var label: RichTextLabel = $"%label"

func _ready() -> void:
	label.get_v_scroll().custom_step = 50

func _on_scroll_text_dialog_about_to_show() -> void:
	label.bbcode_text = tr(text)

func _on_back_pressed() -> void:
	hide()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_page_down"):
		label.get_v_scroll().value += 10
	elif Input.is_action_pressed("ui_page_up"):
		label.get_v_scroll().value -= 10
