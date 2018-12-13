extends Node2D

signal started_walking
signal stopped_walking
signal fist_launched
signal arm_landed

var laser_anim = false

func is_attacking():
	return laser_anim \
		or $AnimationPlayer.current_animation == "attack_left_arm" \
		or $AnimationPlayer.current_animation == "attack_right_arm"

func play_and_set_next(anim):
	$AnimationPlayer.play(anim)
	$AnimationPlayer.animation_set_next("attack_left_arm", anim)
	$AnimationPlayer.animation_set_next("attack_right_arm", anim)

func walk():
	play_and_set_next("walk")
	
func idle():
	play_and_set_next("idle")
	
func attack_fist():
	$AnimationPlayer.play("attack_left_arm")

func attack_arm():
	$AnimationPlayer.play("attack_right_arm")

func laser():
	laser_anim = true
	$AnimationPlayer.play("laser")
	
func laser_reverse():
	laser_anim = false
	$AnimationPlayer.play_backwards("laser")
	yield($AnimationPlayer, "animation_finished")
	walk() # maybe should check idle?
	
func laser_off():
	laser_anim = false
	$AnimationPlayer.play("laser_off")

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "walk":
		emit_signal("started_walking")
	else:
		emit_signal("stopped_walking")

func anim_callback_fist_launched():
	emit_signal("fist_launched")

func anim_callback_arm_landed():
	emit_signal("arm_landed")
