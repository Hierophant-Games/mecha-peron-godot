extends Control

@onready var cursor = preload("res://assets/cursor_3x.png")
@onready var crosshair = preload("res://assets/crosshair_3x.png")

func _ready() -> void:
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
		Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_CROSS)
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)

func _on_timer_timeout():
	$SceneFader.transition_to()
