extends Player

const SCANNED_LAYERS = Global.LayerValues.WORLD + Global.LayerValues.INTERACTABLE

var ray_length = 1

onready var crosshair = $Camera/Crosshair
onready var camera = $Camera
onready var interacter = $Camera/Interacter
onready var interacter_collision: CollisionShape = $Camera/Interacter/CollisionShape

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	set_crosshair_position(mouse_position)
	ignore_walls_on_interact(mouse_position)

func set_crosshair_position(mouse_position):
	crosshair.set_global_position(mouse_position)

func ignore_walls_on_interact(mouse_position):
	var shape = interacter_collision.shape
	if shape is RayShape:
		ray_length = shape.length
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_length
	
	# Cast a ray to check if we have any collision in the scanned layers in front of us
	var cast = camera.get_world().direct_space_state.intersect_ray(from, 
				to, [], SCANNED_LAYERS, true, true)
	# We have a collision
	if not cast.empty():
		var collider = cast["collider"]
		# Allow collisions of the interactable layer
		if collider.get_collision_layer() == Global.LayerValues.INTERACTABLE:
			interacter_collision.disabled = false
		# Ignore all other collision layers
		else:
			interacter_collision.disabled = true

