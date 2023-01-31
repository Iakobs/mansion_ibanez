extends Node

# DeadZones
# warning-ignore:unused_signal
signal dead_zone_entered(body)

# Interactables
# warning-ignore:unused_signal
signal interactable_entered(payload)
# warning-ignore:unused_signal
signal interactable_exited(payload)
# warning-ignore:unused_signal
signal interactable_updated(payload)

# Collectibles
# warning-ignore:unused_signal
signal collectible_collected(payload)
# warning-ignore:unused_signal
signal collectible_consumed(payload)

enum collectibles {
	key
}

#UI
# warning-ignore:unused_signal
signal locale_changed
# warning-ignore:unused_signal
signal remap_submenu_requested
# warning-ignore:unused_signal
signal remap_submenu_closed
# warning-ignore:unused_signal
signal audio_submenu_requested
# warning-ignore:unused_signal
signal audio_submenu_closed
# warning-ignore:unused_signal
signal is_joystick_active(value)
