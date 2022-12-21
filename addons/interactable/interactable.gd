tool
extends Area

var margin = 1.04

func _get_configuration_warning():
	# Ensure all needed signals are connected
	if get_signal_connection_list("area_entered").empty():
		return "area_entered signal needs to be connected"
	if get_signal_connection_list("area_exited").empty():
		return "area_exited signal needs to be connected"
	return ""

func _ready():
	set_collision_layers()
	set_collision_masks()
	try_to_add_automatic_collision()

func try_to_add_automatic_collision():
	# Do nothing if the interactable already has a collision shape as a child
	for child in get_children():
		if child is CollisionShape:
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

func first_collision_sibling():
	for child in get_parent().get_children():
		if child is CollisionShape:
			return child
	return null

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
