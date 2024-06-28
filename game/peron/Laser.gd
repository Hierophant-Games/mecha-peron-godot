extends Area2D

class_name Laser

func _enter_tree():
	$AnimationPlayer.play("on")

func remove():
	$AnimationPlayer.play_backwards("on")
	await $AnimationPlayer.animation_finished
	var parent = get_parent()
	if parent:
		parent.remove_child(self)
