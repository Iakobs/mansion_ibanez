extends Node

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
