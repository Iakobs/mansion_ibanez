extends KinematicBody

export var gravity := -9.8
export var jump_speed := 4.0
export var max_speed := 5.0
export var sprint_max_speed := 7.0
export var acceleration := 4.5
export var sprint_acceleration := 18.0
export var deacceleration := 16.0
export var mouse_sensitivity := 0.1
export var joypad_sensitivity := 4.0
export var max_slope_angle := 50.0

export var sight_lenght := 100.0
export var arm_length := 1.55

var direction := Vector3()
var velocity := Vector3()
var is_sprinting := false

var looking_object: Dictionary
var touching_object: Dictionary
var scanned_layers = Global.LayerValues.WORLD + Global.LayerValues.INTERACTABLE

onready var rotation_helper: Spatial = $"%rotation_helper"
onready var camera: Camera = $"%camera"
onready var arm: Area = $"%Arm"

func _ready() -> void:
	arm.set_length(arm_length)
	Global.player = self
	Global.camera = camera
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta: float) -> void:
	calculate_objects()
	set_arm_lenght()

func _physics_process(delta: float) -> void:
	process_input()
	process_movement(delta)
	process_joypad()

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

func process_input() -> void:
	direction = Vector3()
	var camera_transform := camera.get_global_transform()
	
	direction += camera_transform.basis.x * Input.get_axis("player_left", "player_right")
	direction += camera_transform.basis.z * Input.get_axis("player_forwards", "player_backwards")
	
	is_sprinting = Input.is_action_pressed("player_sprint")
	
	if is_on_floor():
		if Input.is_action_just_pressed("player_jump"):
			velocity.y = jump_speed

func process_movement(delta: float) -> void:
	direction.y = 0
	direction = direction.normalized()
	
	velocity.y += delta * gravity
	
	var horizontal_velocity := velocity
	horizontal_velocity.y = 0
	
	var target := direction
	target *= sprint_max_speed if is_sprinting else max_speed
	
	var final_acceleration := get_acceleration(horizontal_velocity)
	
	horizontal_velocity = horizontal_velocity.linear_interpolate(target, final_acceleration * delta)
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, deg2rad(max_slope_angle))

func process_joypad() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	
	rotation_helper.rotate_x(deg2rad(Input.get_axis("look_up", "look_down") * joypad_sensitivity * -1))
	self.rotate_y(deg2rad(Input.get_axis("look_left", "look_right") * joypad_sensitivity * -1))
	
	var camera_rotation := rotation_helper.rotation_degrees
	camera_rotation.x = clamp(camera_rotation.x, -80, 80)
	rotation_helper.rotation_degrees = camera_rotation

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -1))
		self.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
		
		var camera_rotation := rotation_helper.rotation_degrees
		camera_rotation.x = clamp(camera_rotation.x, -80, 80)
		rotation_helper.rotation_degrees = camera_rotation

func get_acceleration(horizontal_velocity: Vector3) -> float:
	return sprint_acceleration if is_sprinting else acceleration\
		if direction.dot(horizontal_velocity) > 0\
		else deacceleration as float
