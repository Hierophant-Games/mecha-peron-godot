class_name LanguageSelection extends Control

func _ready() -> void:
	GlobalAudio.play_menu_music()

func _on_english_pressed() -> void:
	set_locale_and_fade("en")

func _on_spanish_pressed() -> void:
	set_locale_and_fade("es")

func set_locale_and_fade(locale: String) -> void:
	TranslationServer.set_locale(locale)
	$SceneFader.transition_to()
