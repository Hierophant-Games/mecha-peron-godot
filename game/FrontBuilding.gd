class_name FrontBuilding
extends Area2D

var width: int
@export var textures: Array[Texture2D]
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	sprite.texture = textures.pick_random()
	@warning_ignore("integer_division")
	width = sprite.texture.get_width() / sprite.hframes
	var height = sprite.texture.get_height()
	sprite.position.y = -height * 0.5

	collision.shape.extents = Vector2(width * 0.5, height * 0.5)
	collision.position = sprite.position

func destroy():
	monitorable = false
	$AnimationPlayer.play("destroy_building")
