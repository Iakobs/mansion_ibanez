extends Spatial

onready var animation_player: AnimationPlayer = $"%AnimationPlayer"
onready var rigid_body: RigidBody = $"%RigidBody"
onready var interactive_element: Area = $"%InteractiveElement"

var opened := false

func _process(_delta: float) -> void:
	if not opened\
	and Input.is_action_just_released("primary_action")\
	and interactive_element.is_inside:
		opened = true
		animation_player.play("open_lid")
