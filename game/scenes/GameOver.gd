class_name GameOver
extends Control

signal try_again_pressed
signal main_menu_pressed

@onready var distance := $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/LabelDistance
@onready var destruction := $ColorRect/MarginContainer/VBoxContainer/VBoxContainer/LabelDestruction

func _on_try_again_button_pressed() -> void:
	try_again_pressed.emit()

func _on_main_menu_button_pressed() -> void:
	main_menu_pressed.emit()

func _on_visibility_changed() -> void:
	if visible:
		var formattedDistance := str(ScoreTracker.distanceTraveled).pad_decimals(2)
		distance.text = str(formattedDistance, " km")
		destruction.text = str("Total Destruction: ", ScoreTracker.score)
		$AnimationPlayer.play("appear")
