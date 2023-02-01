extends Node

var tween: SceneTreeTween

func shake_horizontal(control: Control, direction := 1, intensity := 1) -> void:
	if tween != null:
		return
	tween = control.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var _discard := tween.tween_property(
		control,
		"rect_position",
		control.rect_position,
		0.5).from(control.rect_position + Vector2(-2.5 * direction * intensity, 0))
	yield(tween, "finished")
	tween = null

func shake_vertical(control: Control, direction := 1, intensity := 1) -> void:
	if tween != null:
		return
	tween = control.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var _discard := tween.tween_property(
		control,
		"rect_position",
		control.rect_position,
		0.5).from(control.rect_position + Vector2(0, -2.5 * direction * intensity))
	yield(tween, "finished")
	tween = null
