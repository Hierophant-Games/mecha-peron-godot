extends Node2D

class_name Peron

signal started_walking
signal stopped_walking
signal fist_launched
signal arm_landed

const Fist = preload("res://game/peron/Fist.tscn")
const Laser = preload("res://game/peron/Laser.tscn")

var fist: Fist = Fist.instance() as Fist
var left_laser: Laser = Laser.instance() as Laser
var right_laser: Laser = Laser.instance() as Laser

var laser_anim = false

func is_attacking():
	return laser_anim \
		or $AnimationPlayer.current_animation == "attack_left_arm" \
		or $AnimationPlayer.current_animation == "attack_right_arm"

func play_and_set_next(anim: String):
	$AnimationPlayer.play(anim)
	$AnimationPlayer.animation_set_next("attack_left_arm", anim)
	$AnimationPlayer.animation_set_next("attack_right_arm", anim)

func walk():
	play_and_set_next("walk")

func idle():
	play_and_set_next("idle")

func attack_fist():
	$AnimationPlayer.play("attack_left_arm")
	yield(self, "fist_launched") # waits for the signal
	fist.position = $FistStart.position
	add_child(fist)

func attack_arm():
	$AnimationPlayer.play("attack_right_arm")

func laser():
	laser_anim = true
	$AnimationPlayer.play("laser")
	left_laser.position = $LeftEye.position
	right_laser.position = $RightEye.position
	add_child(left_laser)
	add_child(right_laser)

func laser_reverse():
	laser_anim = false
	left_laser.remove()
	right_laser.remove()
	$AnimationPlayer.play_backwards("laser")
	yield($AnimationPlayer, "animation_finished")
	walk() # maybe should check idle?

func laser_off():
	laser_anim = false
	$AnimationPlayer.play("laser_off")

func point_laser(pos: Vector2):
	right_laser.look_at(pos)
	right_laser.rotation = clamp(right_laser.rotation, Constants.LASER_ROTATION_MIN, Constants.LASER_ROTATION_MAX)
	left_laser.rotation = right_laser.rotation

func _on_AnimationPlayer_animation_started(anim_name: String):
	if anim_name == "walk":
		emit_signal("started_walking")
	else:
		emit_signal("stopped_walking")

func anim_callback_fist_launched():
	emit_signal("fist_launched")

func anim_callback_arm_landed():
	var areas = $arm_hit.get_overlapping_areas()
	for area in areas:
		var building = area as FrontBuilding
		if building:
			building.destroy()
