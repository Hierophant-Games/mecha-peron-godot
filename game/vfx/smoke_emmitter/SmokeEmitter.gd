class_name SmokeEmitter
extends CPUParticles2D

enum Type { NORMAL, BUILDING, PLANE }
@export var type:= Type.NORMAL: set = _set_type

var normal_color: Color = Color.hex(0x967384ff)
var building_color: Color = Color.hex(0x7f4f48ff)

func _set_type(value: Type):
	match value:
		Type.NORMAL:
			modulate = normal_color
		Type.BUILDING:
			modulate = building_color
		Type.PLANE:
			modulate = normal_color
			color_initial_ramp = load("res://game/vfx/smoke_emmitter/smoke_gradient.tres")
	type = value
