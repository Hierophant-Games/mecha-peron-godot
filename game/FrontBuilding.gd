class_name FrontBuilding
extends Area2D

const FOREGROUND_BUILDING_TYPES_COUNT: int = 3
var dead = true
@onready var width: int
@onready var sprite = $Sprite2D

func _ready():
	var index = randi() % FOREGROUND_BUILDING_TYPES_COUNT
	sprite.texture = load("res://assets/foreground_building_" + str(index) + ".png")
	sprite.show()
	var height = sprite.texture.get_height()
	width = sprite.texture.get_width() / sprite.hframes
	sprite.position.y = -height * 0.5

	var collision = CollisionShape2D.new()
	self.add_child(collision)
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(width * 0.5, height * 0.5)
	collision.position = sprite.position
	collision.shape = shape
	
	set_collision_layer_value(2, true)

func destroy():
	set_collision_layer_value(2, false)
	$AnimationPlayer.play("destroy_building")
