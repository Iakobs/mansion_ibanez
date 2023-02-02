extends Node

signal value_reseted

const preferences_file_path := "user://preferences.cfg"

const preferences_section := "preferences"
const locale_key := "locale"
const master_volume_key := "master_volume"
const ui_volume_key := "ui_volume"
const fx_volume_key := "fx_volume"
const music_volume_key := "music_volume"

var config_file := ConfigFile.new()

func _ready() -> void:
	var error := config_file.load(preferences_file_path)
	
	if error == ERR_FILE_NOT_FOUND:
		store_default_values()
	elif error != OK:
		print("Error loading the config file!")
	
	set_sensible_defaults()

func set_locale(locale: String) -> void:
	config_file.set_value(preferences_section, locale_key, locale)
	var _error := config_file.save(preferences_file_path)

func get_locale() -> String:
	return config_file.get_value(preferences_section, locale_key)

func set_volume(bus_index: int, volume_db: float) -> void:
	var key := get_key_from_audio_bus_index(bus_index)
	config_file.set_value(preferences_section, key, volume_db)
	var _error := config_file.save(preferences_file_path)

func get_volume(bus_index: int) -> float:
	var key := get_key_from_audio_bus_index(bus_index)
	return config_file.get_value(preferences_section, key)

func reset_volume(bus_index: int) -> void:
	set_volume(bus_index, 0.0)
	AudioServer.set_bus_volume_db(bus_index, 0.0)
	emit_signal("value_reseted")

func get_key_from_audio_bus_index(index: int) -> String:
	match(index):
		AudioManager.audio_bus.Master:
			return master_volume_key
		AudioManager.audio_bus.UI:
			return ui_volume_key
		AudioManager.audio_bus.FX:
			return fx_volume_key
		AudioManager.audio_bus.Music:
			return music_volume_key
		_:
			return ""

func store_default_values() -> void:
	var system_locale := OS.get_locale_language()
	set_locale(system_locale)
	for index in AudioManager.audio_bus.values():
		reset_volume(index)

func set_sensible_defaults() -> void:
	TranslationServer.set_locale(SaveManager.get_locale())
	for index in AudioManager.audio_bus.values():
		AudioServer.set_bus_volume_db(index, get_volume(index))
