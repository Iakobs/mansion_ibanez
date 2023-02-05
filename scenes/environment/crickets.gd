extends Spatial

onready var sound: AudioStreamPlayer3D = $"%sound"
onready var sound_debug_mesh: MeshInstance = $"%sound_debug_mesh"
onready var locations: Spatial = $"%locations"

var location_spots := []

func _ready() -> void:
	sound_debug_mesh.visible = get_tree().debug_collisions_hint
	location_spots = locations.get_children()
	move_crickets()
	var _error := Events.connect("day", self, "_on_day")
	_error = Events.connect("night", self, "_on_night")

func _on_sound_area_body_entered(body: Node) -> void:
	if body == Global.player:
		move_crickets()

func _on_day() -> void:
	sound.stop()

func _on_night() -> void:
	sound.play()

func move_crickets() -> void:
	var next_position := get_next_position()
	sound.global_transform.origin = next_position.global_transform.origin

func get_next_position() -> Position3D:
	var next_position := location_spots.pop_front() as Position3D
	location_spots.push_back(next_position)
	return next_position
