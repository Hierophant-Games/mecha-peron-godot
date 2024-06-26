extends Node

class_name AutoDeletable

export var deletion_threshold: float

func _enter_tree():
	assert(owner is Node2D, "Owner must be Node2D")

func _process(_delta):
	if owner.position.abs() > Vector2(Constants.DELETION_THRESHOLD_X, Constants.DELETION_THRESHOLD_Y):
		owner.queue_free()
