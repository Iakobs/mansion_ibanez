extends Node

class_name CollisionSwitcher

var collisions = []

func _ready():
	collisions = getAllCollisions()

func switch_collisions():
	for collision in collisions:
		collision.disabled = !collision.disabled
			
func getAllCollisions(var node = get_parent(), var listOfAllNodesInTree = []):
	if node is CollisionShape:
		listOfAllNodesInTree.append(node)
	for childNode in node.get_children():
		getAllCollisions(childNode, listOfAllNodesInTree)
	return listOfAllNodesInTree
