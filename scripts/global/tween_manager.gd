extends Node

var tween_pool := {}

func shake_horizontal(control: Control, direction := 1, intensity := 1) -> void:
	var tween := get_tween_from_pool(control)
	if tween != null:
		return
	else:
		tween = control.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween_pool[control] = tween
		var _discard := tween.tween_property(
			control,
			"rect_position",
			control.rect_position,
			0.5).from(control.rect_position + Vector2(-2.5 * direction * intensity, 0))
		yield(tween, "finished")
		tween.kill()
		tween = null
		var _erased := tween_pool.erase(control)

func shake_vertical(control: Control, direction := 1, intensity := 1) -> void:
	var tween := get_tween_from_pool(control)
	if tween != null:
		return
	else:
		tween = control.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween_pool[control] = tween
		var _discard := tween.tween_property(
			control,
			"rect_position",
			control.rect_position,
			0.5).from(control.rect_position + Vector2(0, -2.5 * direction * intensity))
		yield(tween, "finished")
		tween.kill()
		tween = null
		var _erased := tween_pool.erase(control)

func get_tween_from_pool(control: Control) -> SceneTreeTween:
	return tween_pool.get(control)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		for key in tween_pool.keys():
			print("Removing tween")
			var tween := tween_pool[key] as SceneTreeTween
			tween.kill()
			var _erased := tween_pool.erase(key)
