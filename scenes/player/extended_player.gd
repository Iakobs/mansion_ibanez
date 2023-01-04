extends Player

const SCANNED_LAYERS = Global.LayerValues.WORLD \
	+ Global.LayerValues.INTERACTABLE

export var arm_length := 1.55
export var sight_lenght := 100.0

onready var crosshair: Control = $"%Crosshair"
onready var camera: Camera = $"%Camera"
onready var interacter_collision: CollisionShape = $"%CollisionShape"

var touching_object: Dictionary
var looking_object: Dictionary setget ,get_looking_object

func get_looking_object() -> Dictionary:
	if not looking_object.empty():
		return looking_object
	else:
		return {}

func _ready() -> void:
	interacter_collision.shape.length = arm_length

func _process(_delta: float) -> void:
	calculate_objects()
	set_arm_lenght()

func calculate_objects() -> void:
	var to_looking_object = Global.ray_origin \
		+ camera.project_ray_normal(Global.mouse_position) * sight_lenght
	var to_touching_object = Global.ray_origin \
		+ camera.project_ray_normal(Global.mouse_position) * arm_length
	
	looking_object = camera.get_world().direct_space_state\
		.intersect_ray(
			Global.ray_origin, 
			to_looking_object, 
			[], SCANNED_LAYERS, true, true)
	touching_object = camera.get_world().direct_space_state\
		.intersect_ray(
			Global.ray_origin, 
			to_touching_object, 
			[], SCANNED_LAYERS, true, true)
	
	PlayerStats.looking_object = looking_object
	PlayerStats.touching_object = touching_object
	PlayerStats.touching_point = to_touching_object if touching_object.empty() \
		else touching_object.position

func set_arm_lenght() -> void:
	if not touching_object.empty():
		var touching_object_position := touching_object.position as Vector3
		var distance_to_touching_object := Global.ray_origin\
			.distance_to(touching_object_position)
		
		interacter_collision.shape.length = distance_to_touching_object + 0.025
	else:
		interacter_collision.shape.length = arm_length
