extends Control

export(String) var label_text: String
export(AudioManager.audio_bus) var audio_bus: int

var previous_value: float
var normal_bg_resource := preload("res://resources/ui/button_hover.tres")
var focus_bg_resource := preload("res://resources/ui/focus_panel.tres")
var signal_1_resource := preload("res://assets/images/kenney_gameicons/PNG/White/1x/signal1.png")
var signal_2_resource := preload("res://assets/images/kenney_gameicons/PNG/White/1x/signal2.png")
var signal_3_resource := preload("res://assets/images/kenney_gameicons/PNG/White/1x/signal3.png")

onready var bus_name: Label = $"%bus_name"
onready var slider: HSlider = $"%slider"
onready var audio_amount_icon: TextureRect = $"%audio_amount_icon"

func _on_slider_value_changed(value: float) -> void:
	var relative_value := value / slider.max_value * 100
	if relative_value > 1:
		audio_amount_icon.texture = signal_1_resource
	if relative_value > 50:
		audio_amount_icon.texture = signal_2_resource
	if relative_value > 75:
		audio_amount_icon.texture = signal_3_resource
	
	if value == slider.min_value:
		audio_amount_icon.texture = null
		AudioServer.set_bus_mute(audio_bus, true)
	else:
		if AudioServer.is_bus_mute(audio_bus):
			AudioServer.set_bus_mute(audio_bus, false)
		AudioServer.set_bus_volume_db(audio_bus, linear2db(value))
	
	if value == 1.0:
		AudioManager.click.play()
		if slider.editable:
			var direction := 1 if previous_value > 1 else -1
			TweenManager.shake_horizontal(slider, direction, 4)
			slider.editable = false
			yield(get_tree().create_timer(0.5), "timeout")
			slider.editable = true
	else:
		AudioManager.toggle.play()
	
	previous_value = value

func _on_visibility_changed() -> void:
	bus_name.text = "{0}:".format([tr(label_text)])

func _on_slider_focus_entered() -> void:
	add_stylebox_override("panel", focus_bg_resource)
	AudioManager.hover_or_focus.play()
	TweenManager.shake_vertical(slider)

func _on_slider_focus_exited() -> void:
	add_stylebox_override("panel", normal_bg_resource)
