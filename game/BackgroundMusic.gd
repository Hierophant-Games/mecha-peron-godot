extends AudioStreamPlayer

@export var menu_music: AudioStream
@export var ingame_music: AudioStream

func play_menu_music():
	if stream != menu_music:
		stream = menu_music
		play()

func play_ingame_music():
	if stream != ingame_music:
		stream = ingame_music
		play()
