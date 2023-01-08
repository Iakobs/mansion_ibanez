extends Control

enum languages { CATALAN, SPANISH, ENGLISH }

func _on_language_option_item_selected(index):
	match index:
		languages.CATALAN:
			TranslationServer.set_locale("ca")
		languages.SPANISH:
			TranslationServer.set_locale("es")
		languages.ENGLISH:
			TranslationServer.set_locale("en")

func _on_back_button_pressed():
	hide()
