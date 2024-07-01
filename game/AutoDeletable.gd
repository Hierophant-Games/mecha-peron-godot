class_name AutoDeletable
extends Node

@export var deletion_threshold_modifier: Vector2 = Constants.DELETION_THRESHOLD_MODIFIER

func _enter_tree():
	assert(owner is Node2D, "Owner must be Node2D")

func _process(_delta):
	var pos = owner.get_global_transform_with_canvas().origin
	var viewport_rect: Rect2 = owner.get_viewport_rect()
	var grow_amount: Vector2 = viewport_rect.size * deletion_threshold_modifier - viewport_rect.size
	var threshold_rect = viewport_rect.grow_individual(grow_amount.x, grow_amount.y, grow_amount.x, grow_amount.y)
	
	if !threshold_rect.has_point(pos):
		print("autodeleting ", owner.name, " at ", pos)
		owner.queue_free()
