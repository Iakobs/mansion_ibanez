extends Spatial

export(float) var floating_margin := 0.25
export(PackedScene) var static_scene: PackedScene
export(PackedScene) var rigid_scene: PackedScene

onready var origin_mesh: MeshInstance = $"%origin_mesh"

var static_member: Spatial
var rigid_member: Spatial

var active_member: Spatial
var dragging := false
var tween: SceneTreeTween

func _ready() -> void:
	var _error := connect("tree_exiting", self, "_on_exiting_tree")
	origin_mesh.visible = false
	
	static_member = static_scene.instance() as Spatial
	rigid_member = rigid_scene.instance() as Spatial
	assert(static_member != null)
	assert(rigid_member != null)
	
	add_child_and_set_owner(rigid_member)

func _on_exiting_tree() -> void:
	if active_member: active_member = null
	if rigid_member: rigid_member.queue_free()
	if static_member: static_member.queue_free()
	if tween: tween.kill()

func _process(_delta:float) -> void:
	if Input.is_action_just_pressed("primary_action")\
	and rigid_member.inside_interactable:
		pickup()
	elif Input.is_action_just_released("primary_action")\
	and dragging:
		drop()
	
	if dragging:
		var floating_distance = Global.ray_origin\
			.distance_to(PlayerStats.touching_point) - floating_margin
		var floating_point = Global.ray_origin \
			+ Global.camera.project_ray_normal(Global.mouse_position) * floating_distance
		active_member.global_rotation.y = Global.camera.global_rotation.y
		active_member.global_translation = floating_point

func _on_dead_zone_entered() -> void:
	print("Returned!")
	active_member.global_translation = self.global_translation

func pickup() -> void:
	if not dragging:
		switch_member()
		dragging = true
		tween = active_member.create_tween()\
			.set_trans(Tween.TRANS_ELASTIC)\
			.set_ease(Tween.EASE_OUT)
		var _discard = tween.tween_property(
			active_member,
			"global_rotation:x",
			0.0,
			1.5)
		_discard = tween.parallel()\
		.tween_property(
			active_member,
			"global_rotation:z",
			0.0,
			1.5)

func drop() -> void:
	if dragging:
		switch_member()
		dragging = false
		if tween: tween.kill()

func add_child_and_set_owner(node: Node) -> void:
	active_member = node
	add_child(node)
	node.owner = self

func switch_member() -> void:
	if active_member == rigid_member:
		replace_member(rigid_member, static_member)
	elif active_member == static_member:
		replace_member(static_member, rigid_member)

func replace_member(from: Spatial, to: Spatial) -> void:
	add_child_and_set_owner(to)
	to.global_transform = from.global_transform
	remove_child(from)
	
	

