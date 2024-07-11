class_name Destroyable
extends Node

signal destroy_invoked
@export var animation_player: AnimationPlayer
@export var area_2d: Area2D

func _enter_tree():
	assert(owner is Node2D, "Owner must be Node2D")
	owner.set_meta("destroyable", self)
	if owner.has_method("on_destroy_invoked"):
		destroy_invoked.connect(owner.on_destroy_invoked)

func destroy():
	owner.set_meta("destroyed", true)
	destroy_invoked.emit()
	area_2d.queue_free()
	animation_player.play("destroy")
	await animation_player.animation_finished
	owner.queue_free()
