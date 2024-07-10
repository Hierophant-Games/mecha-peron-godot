class_name Destroyable
extends Node

@export var animation_player: AnimationPlayer
@export var area_2d: Area2D

func _enter_tree():
	assert(owner is Node2D, "Owner must be Node2D")
	owner.set_meta("destroyable", self)

func destroy():
	owner.set_meta("destroyed", true)
	area_2d.queue_free()
	animation_player.play("destroy")
	await animation_player.animation_finished
	owner.queue_free()
