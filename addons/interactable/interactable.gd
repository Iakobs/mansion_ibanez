tool
extends Area

export var override_shape := false
export var margin = 1.05

func _ready():
	set_collision_layers()
	set_collision_masks()
	if not override_shape: 
		try_to_add_automatic_collision()

func set_collision_layers():
	for bit in Global.LayerBits:
		var bit_value = Global.LayerBits[bit]
		if bit_value == Global.LayerBits.INTERACTABLE:
			set_collision_layer_bit(bit_value, true)
		else:
			set_collision_layer_bit(bit_value, false)

func set_collision_masks():
	for bit in Global.LayerBits:
		var bit_value = Global.LayerBits[bit]
		if bit_value == Global.LayerBits.PLAYER:
			set_collision_mask_bit(bit_value, true)
		else:
			set_collision_mask_bit(bit_value, false)

func try_to_add_automatic_collision():
	# Do nothing if the interactable already has a collision shape as a child
	if already_has_collision_child():
		return
	
	var collision_sibling = first_collision_sibling()
	if collision_sibling:
		var sibling_shape = collision_sibling.shape
		var optional_shape = null
		
		# Check if the sibling has any of these simple shapes and copy 
		# their extents plus a small margin to a new shape of the same type
		if sibling_shape:
			if sibling_shape is BoxShape:
				optional_shape = BoxShape.new()
				optional_shape.extents = sibling_shape.extents * margin
			elif sibling_shape is CapsuleShape:
				optional_shape = CapsuleShape.new()
				optional_shape.radius = sibling_shape.radius * margin
				optional_shape.height = sibling_shape.height * margin
			elif sibling_shape is CylinderShape:
				optional_shape = CylinderShape.new()
				optional_shape.radius = sibling_shape.radius * margin
				optional_shape.height = sibling_shape.height * margin
			elif sibling_shape is SphereShape:
				optional_shape = SphereShape.new()
				optional_shape.radius = sibling_shape.radius * margin

			# Create a new CollisionShape in the same position as the sibling,
			# set its shape and add it to the tree
			if optional_shape:
				var collision = CollisionShape.new()
				collision.transform = collision_sibling.transform
				collision.shape = optional_shape
				add_child(collision)
				collision.owner = self

func first_collision_sibling():
	for child in get_parent().get_children():
		if child is CollisionShape:
			return child
	return null

func already_has_collision_child():
	var result = false
	for child in get_children():
		if child is CollisionShape:
			result = true
			return
	return result
