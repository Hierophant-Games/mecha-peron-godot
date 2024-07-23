extends Control

@export_file("*.tscn") var play_scene: String
@export_file("*.tscn") var credits_scene: String

func _on_play_button_pressed():
	$SceneFader.transition_to(play_scene)

func _on_options_button_pressed():
	print("Options not implemented yet")

func _on_credits_button_pressed():
	$SceneFader.transition_to(credits_scene, false)

func _on_help_button_pressed():
	print("Help not implemented yet")
