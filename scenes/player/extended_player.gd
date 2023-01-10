extends Player

export var sight_lenght := 100.0
export var arm_length := 1.55

onready var camera: Camera = $"%Camera"
onready var arm: Area = $"%Arm"

var looking_object: Dictionary
var touching_object: Dictionary
var scanned_layers = Global.LayerValues.WORLD + Global.LayerValues.INTERACTABLE

func _ready() -> void:
	arm.set_length(arm_length)

func _process(_delta: float) -> void:
	calculate_objects()
	set_arm_lenght()

func calculate_objects() -> void:
	var to_looking_object := Global.ray_origin\
		+ camera.project_ray_normal(Global.mouse_position) * sight_lenght
	var to_touching_object := Global.ray_origin\
		+ camera.project_ray_normal(Global.mouse_position) * arm_length
	
	looking_object = camera.get_world().direct_space_state\
		.intersect_ray(
			Global.ray_origin, 
			to_looking_object, 
			[], scanned_layers, true, true)
	touching_object = camera.get_world().direct_space_state\
		.intersect_ray(
			Global.ray_origin, 
			to_touching_object, 
			[], scanned_layers, true, true)
	
	PlayerStats.looking_object = looking_object
	PlayerStats.touching_object = touching_object
	PlayerStats.touching_point = to_touching_object if touching_object.empty()\
		else touching_object.position

func set_arm_lenght() -> void:
	var distance_to_touching_object := Global.ray_origin\
		.distance_to(PlayerStats.touching_point)
	arm.set_length(distance_to_touching_object + 0.025)
