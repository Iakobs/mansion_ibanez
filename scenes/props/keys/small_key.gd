extends Interacter

onready var rigid_body: RigidBody = $"%rigid_body"

func _ready() -> void:
	action = "ACTION_PICK"

func _to_string() -> String:
	return tr("KEY_NAME")

func _on_dead_zone_entered() -> void:
	rigid_body.global_translation = self.global_translation
