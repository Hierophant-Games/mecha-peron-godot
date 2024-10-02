extends Node

@export var menu_music: AudioStream
@export var ingame_music: AudioStream

@onready var music_player := $MusicPlayer as AudioStreamPlayer
@onready var sound_player := $SoundPlayer as AudioStreamPlayer

func play_menu_music() -> void:
	_set_music_and_play(menu_music)

func play_ingame_music() -> void:
	_set_music_and_play(ingame_music)

func stop_music() -> void:
	music_player.stop()

func sfx(stream: AudioStream):
	sound_player.stream = stream
	sound_player.play()

func _set_music_and_play(new_stream: AudioStream) -> void:
	if music_player.stream != new_stream or !music_player.playing:
		music_player.stream = new_stream
		music_player.play()
