class_name DoorState
extends State

var door: Door

func _ready():
	yield(owner, "ready")
	door = owner as Door
	assert(door)
