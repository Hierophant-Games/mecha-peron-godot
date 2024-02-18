extends Sprite

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	position = get_viewport().get_mouse_position()
