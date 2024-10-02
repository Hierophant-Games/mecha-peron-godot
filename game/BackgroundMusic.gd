extends AudioStreamPlayer

@export var menu_music: AudioStream
@export var ingame_music: AudioStream

func play_menu_music() -> void:
	set_stream_and_play(menu_music)

func play_ingame_music() -> void:
	set_stream_and_play(ingame_music)

func set_stream_and_play(new_stream: AudioStream) -> void:
	if stream != new_stream:
		stream = new_stream
		play()
