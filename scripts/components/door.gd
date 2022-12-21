extends Spatial

func _on_interactable_area_entered(area):
	inside_interactable = true
	Events.emit_signal("interactable_entered")

func _on_interactable_area_exited(area):
	inside_interactable = false
	Events.emit_signal("interactable_exited")

var inside_interactable = false
var door_status = {
	opened = false
}

onready var animation_player = $AnimationPlayer

func _process(delta):
	if inside_interactable:
		if not animation_player.is_playing() and Input.is_action_just_released("left_click"):
			match door_status["opened"]:
				true:
					animation_player.play_backwards("door_open")
				false:
					animation_player.play("door_open")
			yield(animation_player, "animation_finished")
			door_status["opened"] = !door_status["opened"]
