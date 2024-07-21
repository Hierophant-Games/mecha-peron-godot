extends Control

@export_file("*.tscn") var play_scene: String

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton

func _ready():
	play_button.grab_focus()

func _process(_delta: float):
	fix_hover_focus(play_button.get_parent())

## Prevent showing the hovered button and the focused button at the same time
## Simply grab focus when hovering a button
func fix_hover_focus(container: Control):
	for button: Button in container.get_children():
		if button.is_hovered():
			button.grab_focus()

func _on_play_button_pressed():
	$SceneFader.transition_to(play_scene)

func _on_options_button_pressed():
	print("Options not implemented yet")

func _on_credits_button_pressed():
	print("Credits not implemented yet")

func _on_help_button_pressed():
	print("Help not implemented yet")
