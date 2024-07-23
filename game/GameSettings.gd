extends Node


@export var music_volume := 0.75: set = set_music_volume
@export var sound_volume := 0.9: set = set_sound_volume

const FILENAME := "user://settings.cfg"

func _ready():
	load_config()

func set_music_volume(value: float):
	music_volume = value
	save_config()
	
func set_sound_volume(value: float):
	sound_volume = value
	save_config()

func load_config():
	var config := ConfigFile.new()
	if config.load(FILENAME) != OK:
		return
	music_volume = config.get_value("audio", "music_volume", music_volume)
	sound_volume = config.get_value("audio", "sound_volume", sound_volume)

func save_config():
	var config := ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sound_volume", sound_volume)
	config.save(FILENAME)
