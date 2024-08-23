class_name FrontBuilding
extends Area2D

var CannonScene := preload("res://game/enemies/Cannon.tscn")

var width: int
@onready var sprite := $Sprite2D as Sprite2D
@onready var collision := $CollisionShape2D as CollisionShape2D
var cannon: Cannon = null

func setup(texture: Texture2D, should_spawn_cannon: bool):
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
		add_child(cannon)
		cannon.position.y = sprite.position.y

func destroy():
	VFX.shake(0.01)
	monitorable = false
	if cannon != null:
		cannon.destroy()
	$AnimationPlayer.play("destroy_building")
	$AudioStreamPlayer.play()
	
	ScoreTracker.track_killed(ScoreTracker.EnemyType.BUILDING)
