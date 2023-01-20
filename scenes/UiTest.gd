extends Control

onready var rich_text: RichTextLabel = $"%RichTextLabel"

func _ready() -> void:
	rich_text.get_v_scroll().custom_step = 50

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_page_down"):
		rich_text.get_v_scroll().value += 10
	elif Input.is_action_pressed("ui_page_up"):
		rich_text.get_v_scroll().value -= 10
