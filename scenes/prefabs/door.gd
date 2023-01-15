class_name Door
extends Interacter

enum DoorPanelAngle { positive = 90, negative = -90 }
enum DoorKnobAngle { positive = 1, negative = -1 }

export(DoorPanelAngle) var door_panel_angle := DoorPanelAngle.positive
export(String, "x", "z") var doorknob_axis := "x"
export(DoorKnobAngle) var doorknob_angle := DoorKnobAngle.positive
export(bool) var is_locked := false

onready var door_panel: StaticBody = $"%door_panel"
onready var doorknob: Spatial = $"%doorknob"
onready var unlock_area: Area = $"%unlock_area"
onready var key_lock_position: Position3D = $"%key_lock_position"

onready var state_machine: StateMachine = $"%StateMachine"
onready var animation_manager: DoorAnimationManager = $"%DoorAnimationManager"

var clicking_is_active := true
var player_is_in_front := false

func _ready() -> void:
	var _err := state_machine.connect("transitioned", self, "_on_door_state_change")
	_err = unlock_area.connect("body_entered", self, "_on_unlock_area_body_entered")
	_err = animation_manager.connect("animation_finished", self, "_on_animation_finished")

func _process(_delta: float) -> void:
	var direction_to_player := door_panel.global_translation\
		.direction_to(Global.player.global_translation) as Vector3
	var facing_front_direction := Vector3.RIGHT if doorknob_axis == "x" else Vector3.BACK
	player_is_in_front = direction_to_player.dot(facing_front_direction) > 0.0

func _on_interactable_area_entered(area: Area) -> void:
	._on_interactable_area_entered(area)
	check_clicking()

func _on_door_state_change(_state_name: String) -> void:
	emit_interactable_event("interactable_updated")

func _on_unlock_area_body_entered(body: PhysicsBody) -> void:
	if body.is_in_group("key") and is_locked\
	and state_machine.state == $StateMachine/Closed:
		unlock(body)

func _on_animation_finished(payload := {}) -> void:
	if payload.animation_name == "unlock" and is_locked:
		is_locked = false
		state_machine.transition_to("Opened")

func emit_interactable_event(event := "") -> void:
	var payload = get_payload()
	payload.status_icon = Global.locked_icon if is_locked else null
	Events.emit_signal(event, payload)

func check_clicking() -> void:
	clicking_is_active = not (inside_interactable \
		and Input.is_action_pressed("primary_action"))

func unlock(body: PhysicsBody) -> void:
	body.owner.queue_free()
	if body.has_node("MeshInstance"):
		animate_unlock(body)

func animate_unlock(body: PhysicsBody) -> void:
	var duplicated_mesh := body.get_node("MeshInstance")\
			.duplicate(DUPLICATE_USE_INSTANCING) as MeshInstance
	add_child(duplicated_mesh)
	
	prepare_mesh_position(duplicated_mesh, body)
	
	var scale_factor := Vector3.ONE * 0.5
	var pushback := Vector3(0.05, 0, 0) if doorknob_axis == "x" else Vector3(0, 0, 0.05)
	if not player_is_in_front: pushback *= -1
	
	animation_manager.unlock(duplicated_mesh, key_lock_position, scale_factor, pushback)
	yield(animation_manager, "animation_finished")
	
	remove_child(duplicated_mesh)
	duplicated_mesh.queue_free()

func prepare_mesh_position(mesh: MeshInstance, origin: PhysicsBody) -> void:
	mesh.global_translation = origin.global_translation
	mesh.global_rotation = Vector3.ZERO
	var facing_door_rotation_in_radians: float
	if doorknob_axis == "z":
		facing_door_rotation_in_radians = 0.0 if player_is_in_front else PI
	else:
		facing_door_rotation_in_radians = deg2rad(90.0) if player_is_in_front\
			else deg2rad(-90.0)
	mesh.global_rotate(Vector3.UP, facing_door_rotation_in_radians)

func _to_string() -> String:
	return tr("DOOR_NAME")
