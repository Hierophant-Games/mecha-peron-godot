extends Area2D

onready var Constants = get_node("/root/Constants")

var distance = 0
var vel_y = 0

# we need to reset these values each time the node is added to the scene
func _enter_tree():
	distance = 0
	vel_y = 0

func _process(delta):
	vel_y += Constants.FIST_GRAVITY * delta
	
	distance += Constants.FIST_SPEED * delta
	
	position.x += Constants.FIST_SPEED * delta
	position.y += vel_y * delta
	
	# we remove the node from the tree when it went outside the viewport
	if get_global_transform_with_canvas().origin.x > get_viewport_rect().size.x:
		get_parent().remove_child(self)
