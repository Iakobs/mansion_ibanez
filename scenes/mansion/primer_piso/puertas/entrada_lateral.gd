extends Spatial

var inside_interactable = false
var door_status = {
	opened = false
}

onready var animation_player = $AnimationPlayer

func _on_interactable_area_entered(area):
	inside_interactable = true
	Events.emit_signal("interactable_entered")

func _on_interactable_area_exited(area):
	inside_interactable = false
	Events.emit_signal("interactable_exited")

func _process(delta):
	if inside_interactable:
		if not animation_player.is_playing() and Input.is_action_just_released("left_click"):
			match door_status["opened"]:
				true:
					animation_player.play_backwards("open")
				false:
					animation_player.play("open")
			yield(animation_player, "animation_finished")
			door_status["opened"] = !door_status["opened"]
