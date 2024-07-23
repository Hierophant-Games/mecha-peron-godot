extends Control

@export_file("*.tscn") var back_scene: String

func _on_back_button_pressed():
	$SceneFader.transition_to(back_scene, false)
