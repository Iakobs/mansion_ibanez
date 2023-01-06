class_name Door
extends Interacter

enum DoorPanelAngle { positive = 90, negative = -90 }

export(DoorPanelAngle) var door_panel_angle := DoorPanelAngle.positive
export(String, "x", "z") var doorknob_axis := "x"
export(bool) var is_locked := false

onready var door_panel: StaticBody = $"%door_panel"
onready var doorknob: Spatial = $"%doorknob"
onready var state_machine: StateMachine = $"%StateMachine"
onready var animation_manager: DoorAnimationManager = $"%DoorAnimationManager"
onready var unlock_area: Area = $"%unlock_area"
onready var key_lock_position: Position3D = $"%key_lock_position"

var clicking_is_active := true

func _ready() -> void:
	var _err := state_machine.connect("transitioned", self, "_on_door_status_change")
	_err = unlock_area.connect("body_entered", self, "_on_unlock_area_body_entered")

func _process(_delta: float) -> void:
	pass

func _on_interactable_area_entered(area: Area) -> void:
	._on_interactable_area_entered(area)
	check_clicking()

func _on_door_status_change(_state_name: String) -> void:
	emit_interactable_event("interactable_updated")

func _on_unlock_area_body_entered(body: PhysicsBody) -> void:
	if body.is_in_group("key") and is_locked\
	and state_machine.state == $StateMachine/Closed:
		unlock(body)

func emit_interactable_event(event := "") -> void:
	var _payload = get_payload()
	_payload["locked"] = is_locked
	Events.emit_signal(event, _payload)

func check_clicking() -> void:
	clicking_is_active = not (inside_interactable \
		and Input.is_action_pressed("primary_action"))

func _to_string() -> String:
	return tr("DOOR_NAME")

func unlock(body: PhysicsBody) -> void:
	body.owner.queue_free()
		
	if body.has_node("MeshInstance"):
		var duplicated_mesh := body.get_node("MeshInstance")\
			.duplicate(DUPLICATE_USE_INSTANCING) as MeshInstance
		add_child(duplicated_mesh)
		duplicated_mesh.global_translation = body.global_translation
		duplicated_mesh.global_rotation = Vector3.ZERO
		
		var direction_to_player := door_panel.global_translation\
			.direction_to(Global.player.global_translation)
		var facing_direction := Vector3.RIGHT if doorknob_axis == "x" else Vector3.FORWARD
		var is_player_in_front := direction_to_player.dot(facing_direction) > 0.0
		var in_front_rotation := PI if is_player_in_front else PI * 2
		var side_increment := deg2rad(-90.0) if doorknob_axis == "x" else 0.0
		duplicated_mesh.global_rotate(Vector3.UP, in_front_rotation + side_increment)
			
		var tween := create_tween()\
			.set_trans(Tween.TRANS_EXPO)\
			.set_ease(Tween.EASE_OUT)
		var _discard := tween.tween_property(
			duplicated_mesh, 
			"global_translation", 
			key_lock_position.global_translation,\
			1.0)
		_discard = tween.tween_property(
			duplicated_mesh,
			"rotation_degrees:z",
			-90.0,
			1.0).from(0.0)
		yield(tween, "finished")
		remove_child(duplicated_mesh)
		duplicated_mesh.queue_free()
	
	is_locked = false
	state_machine.transition_to("Opened")
