extends Player

const SCANNED_LAYERS = Global.LayerValues.WORLD + Global.LayerValues.INTERACTABLE

var ray_length := 1.0
var distance_to_nearest := 100.0

onready var crosshair: Control = $"%Crosshair"
onready var camera: Camera = $"%Camera"
onready var interacter_collision: CollisionShape = $"%CollisionShape"

func _process(_delta: float) -> void:
	set_ray_lenght()

func set_ray_lenght() -> void:
	var mouse_position := get_viewport().get_mouse_position()
	var from := camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_length
	
	# Cast a ray to check if we have any collision in the scanned layers in front of us
	var cast := camera.get_world().direct_space_state.intersect_ray(from, 
				to, [], SCANNED_LAYERS, true, true)
	# We have a collision
	if not cast.empty():
		var position = cast["position"]
		
		# Ray length to interact will be as long as the nearest object + small extra distance
		distance_to_nearest = from.distance_to(position)
		interacter_collision.shape.length = distance_to_nearest + 0.05
