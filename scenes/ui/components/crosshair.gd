extends Control

onready var hand: TextureRect = $"%Hand"
onready var display: Control = $"%interactable_info_display"

var interacter: Interacter
var hand_original_size: Vector2

func _ready() -> void:
	var _err := Events.connect("interactable_entered", self, "interact")
	_err = Events.connect("interactable_exited", self, "reset")
	_err = Events.connect("interactable_updated", self, "update")
	hand_original_size = hand.rect_scale

func _process(_delta: float) -> void:
	tween_hand()

func tween_hand() -> void:
	if Input.is_action_just_pressed("primary_action"):
		var tween := create_tween()\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_IN_OUT)
		var _discard = tween.tween_property(
			hand, 
			"rect_scale", 
			hand_original_size * 0.8,
			0.1)
	if Input.is_action_just_released("primary_action"):
		var tween := create_tween()\
			.set_trans(Tween.TRANS_QUAD)\
			.set_ease(Tween.EASE_IN_OUT)
		var _discard = tween.tween_property(
			hand, 
			"rect_scale", 
			hand_original_size, 
			0.1)\
			.from_current()

func interact(payload := {}) -> void:
	interacter = payload.interacter
	hand.modulate = Color.red
	display.show_display(payload)

func update(payload := {}) -> void:
	if payload.interacter == interacter:
		display.show_display(payload)

func reset(payload := {}) -> void:
	if payload.interacter == interacter:
		interacter = null
		hand.modulate = Color.white
		display.hide_display()
