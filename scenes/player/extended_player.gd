extends Player

const SCANNED_LAYERS = Global.LayerValues.WORLD \
	+ Global.LayerValues.INTERACTABLE \
	+ Global.LayerValues.COLLECTIBLE

export var ray_length := 1.55

onready var crosshair: Control = $"%Crosshair"
onready var camera: Camera = $"%Camera"
onready var interacter_collision: CollisionShape = $"%CollisionShape"

var nearest_object_position := Vector3.INF
var distance_to_nearest_object: float

func _ready() -> void:
	interacter_collision.shape.length = ray_length

func _process(_delta: float) -> void:
	interacter_collision.shape.length = ray_length
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
		nearest_object_position = cast["position"]
		
		# Ray length to interact will be as long as the nearest object + small extra distance
		distance_to_nearest_object = from.distance_to(nearest_object_position)
		interacter_collision.shape.length = distance_to_nearest_object + 0.025
	else:
		nearest_object_position = Vector3.INF
	
	if Input.is_action_pressed("left_click"):
		PlayerStats.touching_point = nearest_object_position \
		if nearest_object_position != Vector3.INF else to
