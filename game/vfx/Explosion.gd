extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("explode")
	$AudioStreamPlayer.play()
	await $AnimationPlayer.animation_finished
	queue_free()
