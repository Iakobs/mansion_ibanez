extends PopupDialog

signal yes_pressed
signal no_pressed

func _on_yes_sure_pressed():
	emit_signal("yes_pressed")

func _on_no_sure_pressed():
	emit_signal("no_pressed")
