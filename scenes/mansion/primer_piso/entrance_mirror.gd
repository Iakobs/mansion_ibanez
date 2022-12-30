extends Spatial

onready var mirror: Spatial = $Mirror
onready var mirror_z_position := mirror.global_translation.z

func _on_mirror_line_body_exited(body: Spatial) -> void:
	var body_z_position := body.global_translation.z
	var body_is_in_mirror_side := body_z_position - mirror.global_translation.z > 0
	mirror.visible = body_is_in_mirror_side
