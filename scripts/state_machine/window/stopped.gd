extends WindowState

func enter(_payload := {}) -> void:
	window.dragging = false

func update(_delta: float) -> void:
	if window.inside_interactable\
	and Input.is_action_just_pressed("primary_action"):
		state_machine.transition_to("Dragging")
