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

var in_game_decimal_hour := 0.00

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

func get_in_game_hour() -> String:
	var split_time := str(stepify(in_game_decimal_hour, 0.01)).split(".") 
	var hour := split_time[0]
	var decimal_minutes := get_decimal_minutes(split_time[1] if split_time.size() > 1 else "00")
	var minutes := get_minutes(decimal_minutes)
	return "{0}:{1}".format([hour, minutes])

func get_decimal_minutes(number: String) -> float:
	var build := "10.{0}".format([
		number if number.length() > 1 else
		number + "0"
	])
	return float(build)

func get_minutes(number: float) -> String:
	var split := str(stepify(number * 0.6, 0.01)).split(".")
	var formated := split[1] if split.size() > 1 else "00"
	return "{0}".format([
		formated if formated.length() == 2 else formated + "0"
	])

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
