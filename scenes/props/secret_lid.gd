extends Interacter

onready var animation_player: AnimationPlayer = $"%AnimationPlayer"
onready var static_body: StaticBody = $"%StaticBody"
onready var rigid_body: RigidBody = $"%RigidBody"

func _process(delta: float) -> void:
	action = "ACTION_TOUCH"
	if Input.is_action_just_released("primary_action") and inside_interactable:
		animation_player.play("remove_lid")

func _to_string() -> String:
	return tr("SECRET_LID_NAME")
