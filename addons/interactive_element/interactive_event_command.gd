class_name InteractiveEventCommand
extends Resource

var interactive_element: Node
var interactive_element_name: String
var action: String
var status_icon: Texture
var action_icon: Texture

func _init(
	interactive_element: Node,
	interactive_element_name: String,
	action: String,
	status_icon: Texture,
	action_icon: Texture
) -> void:
	self.interactive_element = interactive_element
	self.interactive_element_name = interactive_element_name
	self.action = action
	self.status_icon = status_icon
	self.action_icon = action_icon
