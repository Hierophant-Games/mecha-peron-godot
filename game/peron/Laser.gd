class_name Laser
extends Area2D

var _isOn: bool = false

func _process(_delta):
	for area in get_overlapping_areas():
		var damageable: Damageable = area.owner.get_meta("damageable")
		assert(damageable)
		damageable.damage()

func on():
	_isOn = true
	$AnimationPlayer.play("on")
	show()

func off():
	_isOn = false
	$AnimationPlayer.play_backwards("on")
	await $AnimationPlayer.animation_finished
	hide()
