class_name Laser
extends Area2D

func on():
	$AnimationPlayer.play("on")
	show()

func off():
	$AnimationPlayer.play_backwards("on")
	await $AnimationPlayer.animation_finished
	hide()
