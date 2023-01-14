extends Interacter

onready var animation_player: AnimationPlayer = $"%AnimationPlayer"
onready var rigid_body: RigidBody = $"%RigidBody"

var opened := false

func _ready() -> void:
	action = "ACTION_TOUCH"

func _process(_delta: float) -> void:
	if not opened\
	and Input.is_action_just_released("primary_action")\
	and inside_interactable:
		opened = true
		animation_player.play("open_lid")

func _to_string() -> String:
	return tr("SECRET_LID_NAME")
