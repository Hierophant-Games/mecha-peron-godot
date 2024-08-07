extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	queue_free()
