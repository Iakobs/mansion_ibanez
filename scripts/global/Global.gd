extends Node

enum LayerValues {
	WORLD = 1, PLAYER = 2, INTERACTABLE = 4, COLLECTIBLE = 8
}
enum LayerBits {
	WORLD = 0, PLAYER = 1, INTERACTABLE = 2, COLLECTIBLE = 3
}

var door_collisions := []

var player: Spatial
var camera: Camera

var ray_origin: Vector3
var mouse_position: Vector2

var game_is_running := false

var is_submenu_open := false
var is_joystick_active := false

func _ready() -> void:
	pause_mode = PAUSE_MODE_PROCESS
	OS.window_maximized = true
#	for node in get_tree().get_nodes_in_group("doors"):
#		door_collisions.append_array(getAllCollisions(node))
#
#	for node in get_tree().get_nodes_in_group("camera"):
#		camera = node
#
#	for node in get_tree().get_nodes_in_group("player"):
#		player = node
#
#	assert(camera, "No camera was found!")
#	assert(player, "No player was found!")

func _process(_delta) -> void:
	if game_is_running:
		mouse_position = get_viewport().get_mouse_position()
		if camera:
			ray_origin = camera.project_ray_origin(mouse_position)

func switch_door_collisions() -> void:
	for door in door_collisions:
		door.disabled = !door.disabled

func getAllCollisions(node: Node, listOfAllNodesInTree := []) -> Array:
	if node is CollisionShape:
		listOfAllNodesInTree.append(node)
	for childNode in node.get_children():
		var _discarded = getAllCollisions(childNode, listOfAllNodesInTree)
	return listOfAllNodesInTree

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton\
	or (event is InputEventJoypadMotion and event.axis_value >= 0.5):
		if not is_joystick_active:
			is_joystick_active = true
			Events.emit_signal("is_joystick_active", is_joystick_active)
	if event is InputEventMouse or event is InputEventKey:
		if is_joystick_active:
			is_joystick_active = false
			Events.emit_signal("is_joystick_active", is_joystick_active)

func _unhandled_input(event: InputEvent) -> void:
	pass
#	if event.is_action_pressed("door_collisions"):
#		switch_door_collisions()

# Icons
var locked_icon := preload("res://assets/images/kenney_gameicons/PNG/White/1x/locked.png")
var primary_action_icon := preload("res://assets/images/kenney_gameicons_expansion/PNG/White/1x/mouseLeft.png")
var secondary_action_icon := preload("res://assets/images/kenney_gameicons_expansion/PNG/White/1x/mouseRight.png")
var mouse_icon := preload("res://assets/images/kenney_gameicons_expansion/PNG/White/1x/mouse.png")
var page_next_icon := preload("res://assets/images/kenney_gameicons/PNG/White/1x/buttonR1.png")
var page_previous_icon := preload("res://assets/images/kenney_gameicons/PNG/White/1x/buttonL1.png")
var backward_icon := preload("res://assets/images/kenney_gameicons/PNG/White/1x/backward.png")
var forward_icon := preload("res://assets/images/kenney_gameicons/PNG/White/1x/forward.png")
