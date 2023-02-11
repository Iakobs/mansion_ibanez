class_name InteractiveElement
extends Area

export(String) var element_name := "Element"
export(String) var action := "Action"
export(Texture) var status_icon: Texture
export(Texture) var action_icon: Texture

var is_inside := false

func _ready() -> void:
	set_collision_layers()
	set_collision_masks()
	var _error := connect("area_entered", self, "_on_area_entered")
	_error = connect("area_exited", self, "_on_area_exited")

func emit(event := "", command := InteractiveEventCommand.new(
	self,
	element_name,
	action,
	status_icon,
	action_icon
)) -> void:
	InteractiveElementEvents.emit_signal(event, command)

func _on_area_entered(_area: Area) -> void:
	is_inside = true
	emit("entered")

func _on_area_exited(_area: Area) -> void:
	is_inside = false
	emit("exited")

func set_collision_layers() -> void:
	for bit in Global.LayerBits:
		var bit_value = Global.LayerBits[bit]
		if bit_value == Global.LayerBits.INTERACTABLE:
			set_collision_layer_bit(bit_value, true)
		else:
			set_collision_layer_bit(bit_value, false)

func set_collision_masks() -> void:
	for bit in Global.LayerBits:
		var bit_value = Global.LayerBits[bit]
		if bit_value == Global.LayerBits.PLAYER:
			set_collision_mask_bit(bit_value, true)
		else:
			set_collision_mask_bit(bit_value, false)
