extends Node

const config_file_path := "user://preferences.cfg"

const preferences_section := "preferences"
const locale_key := "locale"

var config_file := ConfigFile.new()

func _ready() -> void:
	var error := config_file.load(config_file_path)
	
	if error == ERR_FILE_NOT_FOUND:
		print("Locale: %s" % TranslationServer.get_locale())
		set_default_values()
	elif error != OK:
		print("Error loading the config file!")

func set_locale(locale: String) -> void:
	config_file.set_value(preferences_section, locale_key, locale)
	var _error := config_file.save(config_file_path)

func get_locale() -> String:
	return config_file.get_value(preferences_section, locale_key)

func set_default_values() -> void:
	var system_locale := OS.get_locale_language()
	set_locale(system_locale)
