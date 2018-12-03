extends Node2D

signal killed

var dead = true
var width

func _ready():
	# all building types are hidden by default, show 1 randomly
	var i = randi() % get_child_count()
	var sprite = get_children()[i]
	sprite.show()
	width = sprite.texture.get_width() / sprite.hframes

func kill():
	dead = true
	emit_signal("killed", self)