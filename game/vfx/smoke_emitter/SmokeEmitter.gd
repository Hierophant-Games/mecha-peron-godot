@tool
class_name SmokeEmitter
extends CPUParticles2D

enum Type { NORMAL, BUILDING, PLANE }

@export var type := Type.NORMAL: set = _set_type

const CONFIG = [
	# NORMAL
	{
		color = Color("#967384"),
		ramp = null
	},
	# BUILDING
	{
		color = Color("#7f4f48"),
		ramp = null
	},
	# PLANE
	{
		color = Color("#967384"),
		ramp = preload("res://game/vfx/smoke_emitter/smoke_gradient.tres")
	},
]

func _set_type(value: Type):
	type = value
	apply_type()

func _ready():
	apply_type()

func apply_type():
	var smoke_config = CONFIG[type]
	modulate = smoke_config.color
	color_initial_ramp = smoke_config.ramp
