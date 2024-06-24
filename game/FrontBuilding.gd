extends Area2D

class_name FrontBuilding
signal killed

const FOREGROUND_BUILDING_TYPES_COUNT: int = 3
var dead = true
var width
onready var sprite = $Sprite

func _ready():
	setup_random_building()
	reset()

func setup_random_building():
	var index = randi() % FOREGROUND_BUILDING_TYPES_COUNT
	sprite.texture = load(str("res://assets/foreground_building_", index, ".png"))
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

func reset():
	set_deferred("collision_layer", 4) #layer 3 -> bit 2 value 4
	$AnimationPlayer.play("reset")
	sprite.frame = 0

func kill():
	reset()
	dead = true
	emit_signal("killed", self)

func destroy():
	set_deferred("collision_layer", 0)
	$AnimationPlayer.play("destroy_building")
