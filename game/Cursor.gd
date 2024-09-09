extends Node

@onready var cursor := preload("res://assets/cursor_3x.png")
@onready var crosshair := preload("res://assets/crosshair_3x.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(crosshair, Input.CURSOR_CROSS)
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)

func _process(delta: float) -> void:
	if Input.get_current_cursor_shape() != Input.CURSOR_CROSS:
		return

	var direction := Input.get_vector("cursor_left", "cursor_right", "cursor_up", "cursor_down")
	var cursor_movement := direction * delta * Constants.CURSOR_SPEED
	var viewport := get_viewport()
	viewport.warp_mouse(viewport.get_mouse_position() + cursor_movement)
