extends Player

const SCANNED_LAYERS = Global.LayerValues.WORLD + Global.LayerValues.INTERACTABLE

var ray_length = 1
var distance_to_nearest = 100

onready var crosshair = $Camera/Crosshair
onready var camera: Camera = $Camera
onready var interacter: Area = $Camera/Interacter
onready var interacter_collision: CollisionShape = $Camera/Interacter/CollisionShape

func _process(delta):
	var mouse_position = get_viewport().get_mouse_position()
	set_crosshair_position(mouse_position)
	set_ray_lenght(mouse_position)

func set_crosshair_position(mouse_position):
	crosshair.set_global_position(mouse_position)

func set_ray_lenght(mouse_position):
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * ray_length
	
	# Cast a ray to check if we have any collision in the scanned layers in front of us
	var cast = camera.get_world().direct_space_state.intersect_ray(from, 
				to, [], SCANNED_LAYERS, true, true)
	# We have a collision
	if not cast.empty():
		var collider = cast["collider"]
		var position = cast["position"]
		
		# Ray length to interact will be as long as the nearest object + small extra distance
		distance_to_nearest = from.distance_to(position)
		interacter_collision.shape.length = distance_to_nearest + 0.05

func _on_Interacter_area_entered(area: Area):
	var distance_to_area = interacter.global_translation.distance_to(area.global_translation)
	print("distance to area %s" % distance_to_area)

func _on_Interacter_body_entered(body: PhysicsBody):
	if body.get_collision_layer_bit(Global.LayerBits.WORLD):
		print("player is touching an body")
