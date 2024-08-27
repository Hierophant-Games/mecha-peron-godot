extends Node


@export var music_volume := 0.75: set = set_music_volume
@export var sound_volume := 0.9: set = set_sound_volume
@export var voice_volume := 0.9: set = set_voice_volume

const FILENAME := "user://settings.cfg"

func _ready():
	load_config()

func set_music_volume(value: float):
	music_volume = value
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))
	save_config()
	
func set_sound_volume(value: float):
	sound_volume = value
	var sfx_bus_index = AudioServer.get_bus_index("Sfx")
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))
	save_config()
	
func set_voice_volume(value: float):
	voice_volume = value
	var voice_bus_index = AudioServer.get_bus_index("Voice")
	AudioServer.set_bus_volume_db(voice_bus_index, linear_to_db(value))
	save_config()

func load_config():
	var config := ConfigFile.new()
	if config.load(FILENAME) != OK:
		return
	music_volume = config.get_value("audio", "music_volume", music_volume)
	sound_volume = config.get_value("audio", "sound_volume", sound_volume)
	sound_volume = config.get_value("audio", "voice_volume", voice_volume)

func save_config():
	var config := ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sound_volume", sound_volume)
	config.set_value("audio", "voice_volume", voice_volume)
	config.save(FILENAME)
