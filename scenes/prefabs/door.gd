extends Spatial

enum DoorPanelAngle { positive = 90, negative = -90 }

export(DoorPanelAngle) var door_panel_angle := DoorPanelAngle.positive
export(String, "x", "z") var doorknob_axis := "x"
export var is_open := false

onready var door_panel := $door_panel
onready var doorknob := $door_panel/doorknob
onready var interactable := $door_panel/interactable

var inside_interactable := false
var playing_animation := false

func _ready():
	interactable.connect("area_entered", self, "_on_interactable_area_entered")
	interactable.connect("area_exited", self, "_on_interactable_area_exited")

func _process(delta):
	if not playing_animation and inside_interactable and Input.is_action_just_released("left_click"):
		if is_open:
			open_animation(true)
		else:
			open_animation()
		is_open = !is_open

func _on_interactable_area_entered(area):
	inside_interactable = true
	Events.emit_signal("interactable_entered")

func _on_interactable_area_exited(area):
	inside_interactable = false
	Events.emit_signal("interactable_exited")

func open_animation(reverse := false):
	playing_animation = true
	var door_final_angle = door_panel_angle
	if reverse:
		door_final_angle = 0
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(door_panel, "rotation_degrees:y", float(door_final_angle), 1.5)
	tween.parallel().tween_property(
		doorknob, 
		"rotation_degrees:{0}".format([doorknob_axis]),
		-45.0,
		0.3)
	tween.parallel().tween_property(
		doorknob, 
		"rotation_degrees:{0}".format([doorknob_axis]),
		0.0,
		0.3).set_delay(1.0).from(-45.0)
	yield(tween, "finished")
	playing_animation = false
