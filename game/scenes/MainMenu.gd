extends Control

@export_file("*.tscn") var play_scene: String
@export_file("*.tscn") var options_scene: String
@export_file("*.tscn") var credits_scene: String
@export_file("*.tscn") var help_scene: String

func _on_play_button_pressed():
	VFX.flash(Color.WHITE, 1.0)
	$SceneFader.transition_to(play_scene)

func _on_options_button_pressed():
	$SceneFader.transition_to(options_scene, false)

func _on_credits_button_pressed():
	$SceneFader.transition_to(credits_scene, false)

func _on_help_button_pressed():
	$SceneFader.transition_to(help_scene, false)
