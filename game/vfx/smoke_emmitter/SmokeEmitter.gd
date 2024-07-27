class_name SmokeEmitter
extends CPUParticles2D

enum Type { normal, building, plane }
@export var type:= Type.normal: set = _set_type

var normal_color: Color = Color.hex(0x967384ff)
var building_color: Color = Color.hex(0x7f4f48ff)

func _ready():
	texture = load("res://assets/smoke.png")

func _set_type(value: Type):
	match value:
		Type.normal:
			modulate = normal_color
		Type.building:
			modulate = building_color
		Type.plane:
			modulate = normal_color
			color_initial_ramp = load("res://game/vfx/smoke_emmitter/smoke_gradient.tres")
	type = value
