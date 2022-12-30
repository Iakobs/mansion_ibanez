class_name DoorState
extends State

var door

func _ready():
	yield(owner, "ready")
#	if owner is Door:
#		door = owner as Door
#	elif owner is GarageDoor:
#		door = owner as GarageDoor
	door = owner as Door if owner is Door else owner as GarageDoor
	assert(door != null)
