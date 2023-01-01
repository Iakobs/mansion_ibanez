extends Spatial

#func _on_lef_window_entered(area):
#	inside_left_window = true
#	Events.emit_signal("interactable_entered")
#
#func _on_left_window_exited(area):
#	inside_left_window = false
#	Events.emit_signal("interactable_exited")
#
#func _on_right_window_entered(area):
#	inside_right_window = true
#	Events.emit_signal("interactable_entered")
#
#func _on_right_window_exited(area):
#	inside_right_window = false
#	Events.emit_signal("interactable_exited")
#
#var inside_left_window = false
#var inside_right_window = false
#var left_window_status = {
#	opened = false
#}
#var right_window_status = {
#	opened = false
#}
#
#onready var animation_player = $AnimationPlayer
#
#func _process(delta):
#	if not animation_player.is_playing() and Input.is_action_just_released("left_click"):
#		if inside_left_window:
#			var this_window_is_opened = left_window_status.opened
#			var other_window_is_opened = right_window_status.opened
#			var can_be_opened = !this_window_is_opened and !other_window_is_opened
#			var can_be_closed = this_window_is_opened
#			if can_be_opened:
#				animation_player.play("left_window_open")
#			elif can_be_closed:
#				animation_player.play_backwards("left_window_open")
#			yield(animation_player, "animation_finished")
#			left_window_status.opened = !left_window_status.opened
#		elif inside_right_window:
#			var this_window_is_opened = right_window_status.opened
#			var other_window_is_opened = left_window_status.opened
#			var can_be_opened = !this_window_is_opened and !other_window_is_opened
#			var can_be_closed = this_window_is_opened
#			if can_be_opened:
#				animation_player.play("right_window_open")
#			elif can_be_closed:
#				animation_player.play_backwards("right_window_open")
#			yield(animation_player, "animation_finished")
#			right_window_status.opened = !right_window_status.opened
