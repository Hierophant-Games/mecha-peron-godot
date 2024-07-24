class_name FrontBuilding
extends Area2D

var CannonScene = preload("res://game/enemies/Cannon.tscn")

var width: int
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
var cannon: Cannon = null

func setup(texture: Texture2D, should_spawn_cannon: bool, target: Area2D, main_layer: WeakRef):
	sprite.texture = texture
	
	@warning_ignore("integer_division")
	width = sprite.texture.get_width() / sprite.hframes
	var height = sprite.texture.get_height()
	collision.shape.extents = Vector2(width * 0.5, height)
	collision.position = sprite.position
	
	# offset sprite to make anchor top-left
	sprite.position.y = -height
	sprite.position.x -= width * 0.5
	
	if should_spawn_cannon:
		cannon = CannonScene.instantiate()
		cannon.main_layer = main_layer
		cannon.target = target
		add_child(cannon)
		cannon.position.y = sprite.position.y

func destroy():
	monitorable = false
	if cannon != null:
		cannon.destroy()
	$AnimationPlayer.play("destroy_building")
