extends Spatial

func _on_interactable_area_entered(area):
	Events.emit_signal("interactable_entered")

func _on_interactable_area_exited(area):
	Events.emit_signal("interactable_exited")
