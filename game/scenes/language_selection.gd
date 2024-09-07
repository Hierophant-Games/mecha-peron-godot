class_name LanguageSelection extends Control

@onready var buttons: Array[Button] = [$HBoxContainer/Spanish, $HBoxContainer/English]

func _ready() -> void:
	Cursor.analog_cursor_enabled = false
	buttons[0].grab_focus()
	BackgroundMusic.play_menu_music()

func _process(delta: float) -> void:
	for button: Button in buttons:
		if button.is_hovered():
			button.grab_focus()
		if button.has_focus():
			button.set_modulate(Color.WHITE)
		else:
			button.set_modulate(Color("616161"))

func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")
	$SceneFader.transition_to()

func _on_spanish_pressed() -> void:
	TranslationServer.set_locale("es")
	$SceneFader.transition_to()
