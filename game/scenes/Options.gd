extends Control

@export_file("*.tscn") var back_scene: String

@onready var music_slider := $MarginContainer/VBoxContainer/MusicSettings/Slider as HSlider
@onready var sound_slider := $MarginContainer/VBoxContainer/SoundSettings/Slider as HSlider

func _ready():
	music_slider.value = GameSettings.music_volume
	sound_slider.value = GameSettings.sound_volume

func _on_back_button_pressed():
	$SceneFader.transition_to(back_scene, false)

func _on_music_slider_value_changed(value):
	GameSettings.music_volume = value

func _on_sound_slider_value_changed(value):
	GameSettings.sound_volume = value
