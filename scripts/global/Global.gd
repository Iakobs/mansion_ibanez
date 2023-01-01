extends Node

enum LayerValues {
	WORLD = 1, PLAYER = 2, INTERACTABLE = 4, COLLECTIBLE = 8
}
enum LayerBits {
	WORLD = 0, PLAYER = 1, INTERACTABLE = 2, COLLECTIBLE = 3
}
enum Axis{ 
	X_POSITIVE, X_NEGATIVE, Y_POSITIVE, Y_NEGATIVE, Z_POSITIVE, Z_NEGATIVE 
}

var door_collisions := []

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("doors"):
		door_collisions.append_array(getAllCollisions(node))

func switch_door_collisions() -> void:
	for door in door_collisions:
		door.disabled = !door.disabled

func getAllCollisions(node: Node, listOfAllNodesInTree := []) -> Array:
	if node is CollisionShape:
		listOfAllNodesInTree.append(node)
	for childNode in node.get_children():
		var _discarded = getAllCollisions(childNode, listOfAllNodesInTree)
	return listOfAllNodesInTree

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("door_collisions"):
		switch_door_collisions()
