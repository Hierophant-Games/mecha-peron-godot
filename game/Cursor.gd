extends Sprite

onready var camera = get_node("../Camera2D")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	var vt = get_viewport_transform()
	var viewport_offset = vt.get_origin() / vt.get_scale()
	var mouse_pos = get_viewport().get_mouse_position()
	position = mouse_pos - viewport_offset
