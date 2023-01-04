extends RigidBody

export(float) var floating_margin := 0.25

onready var collision_shape: CollisionShape = $"%collision_shape"
onready var interacter: Interacter = $"%Interacter"

var dragging := false
var tween

func _ready() -> void:
	pass

func pickup() -> void:
	if not dragging:
		mode = MODE_STATIC
		dragging = true
		switch_collisions()

func drop() -> void:
	if dragging:
		mode = MODE_RIGID
		dragging = false
		switch_collisions()

#func _process(_delta) -> void:
#	if interacter.inside_interactable:
#		if Input.is_action_just_pressed("left_click"):
#			pickup()
#		elif Input.is_action_just_released("left_click"):
#			drop()

func _physics_process(_delta: float) -> void:
	if interacter.inside_interactable:
		if Input.is_action_just_pressed("left_click"):
			pickup()
		elif Input.is_action_just_released("left_click"):
			drop()
	
	if dragging:
		var floating_distance = Global.ray_origin\
			.distance_to(PlayerStats.touching_point) - floating_margin
		var floating_point = Global.ray_origin \
			+ Global.camera.project_ray_normal(Global.mouse_position) * floating_distance
#		global_rotation.y = Global.camera.global_rotation.y
		global_transform.origin = floating_point - Vector3(0, 0, 0)

#func _integrate_forces(_state: PhysicsDirectBodyState) -> void:
#	if Input.is_action_just_pressed("left_click")\
#	and interacter.inside_interactable:
#		mode = MODE_STATIC
#		dragging = true
#		switch_collisions()
#		tween = create_tween()\
#			.set_trans(Tween.TRANS_ELASTIC)\
#			.set_ease(Tween.EASE_OUT)
#		var _discard = tween.tween_property(
#			self,
#			"global_rotation:x",
#			0.0,
#			1.5)
#		_discard = tween.parallel()\
#		.tween_property(
#			self,
#			"global_rotation:z",
#			0.0,
#			1.5)
	
#	if dragging:
#		var floating_distance = Global.ray_origin\
#			.distance_to(PlayerStats.touching_point) - floating_margin
#		var floating_point = Global.ray_origin \
#			+ Global.camera.project_ray_normal(Global.mouse_position) * floating_distance
#		global_rotation.y = Global.camera.global_rotation.y
#		global_translation = floating_point - Vector3(0, 0, 0)

#	if Input.is_action_just_released("left_click")\
#	and dragging:
##		if tween: tween.kill()
#		mode = MODE_RIGID
#		dragging = false
#		switch_collisions()
#		var vector := Vector3(
#			Input.get_last_mouse_speed().x,
#			Input.get_last_mouse_speed().y,
#			0
#		)
#		apply_central_impulse(vector)

func switch_collisions() -> void:
	var interatable_active = !interacter.interactable\
		.get_collision_layer_bit(Global.LayerBits.INTERACTABLE)
	interacter.interactable.set_collision_layer_bit(
		Global.LayerBits.INTERACTABLE, interatable_active)
