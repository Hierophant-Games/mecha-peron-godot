class_name GameOver
extends Control

signal try_again_pressed
signal main_menu_pressed

func _on_try_again_button_pressed() -> void:
	try_again_pressed.emit()

func _on_main_menu_button_pressed() -> void:
	main_menu_pressed.emit()

func _on_visibility_changed() -> void:
	if visible:
		$AnimationPlayer.play("appear")
