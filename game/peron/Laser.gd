class_name Laser
extends Area2D

var _isOn: bool = false

func _process(_delta):
	if !_isOn:
		return

	for area in get_overlapping_areas():
		assert(area.owner is Entity)
		var damageable: Damageable = area.owner.get_component("damageable")
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
