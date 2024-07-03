class_name Cannon
extends Node2D

func _ready():
	$CannonSprite.show()
	$ExplosionSprite.hide()

func _process(_delta):
	pass

func destroy():
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	queue_free()
