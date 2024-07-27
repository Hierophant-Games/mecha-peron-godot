class_name ShakeEffect
extends Node2D

var intensity := 0.05
var duration := 0.5

var _accum := 0.0

@onready var camera := get_tree().root.get_camera_2d()

func _process(delta: float) -> void:
	_accum += delta
	
	if _accum < duration:
		var displacement := get_viewport_rect().size * intensity
		var x := randf() * displacement.x * 2 - displacement.x
		var y := randf() * displacement.y * 2 - displacement.y
		camera.offset = Vector2(x, y)
	else:
		camera.offset = Vector2(0, 0)
		queue_free()
