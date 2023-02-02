extends VBoxContainer

enum languages { ca = 0, es = 1, en = 2 }

onready var language_option: OptionButton = $"%language_option"

func _ready() -> void:
	var config_language := languages.get(SaveManager.get_locale()) as int
	language_option.select(config_language)

func _on_language_option_item_selected(index: int) -> void:
	var locale := languages.keys()[index] as String
	TranslationServer.set_locale(locale)
	Events.emit_signal("locale_changed")
	SaveManager.set_locale(locale)
