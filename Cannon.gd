class_name Cannon
extends Node2D

var attack_timer: float = 0
var destroyed: bool = false

func _ready():
	$CannonSprite.show()
	$ExplosionSprite.hide()

func _process(_delta):
	if destroyed:
		return

	# decide whether shooting or idling
	attack_timer += _delta
	var ready_to_shoot: bool = attack_timer >= Constants.CANNON_ATTACK_DELAY
	var prefix = "shoot" if ready_to_shoot else "idle"	
	
	# get required context
	var viewport_x_pos = get_global_transform_with_canvas().origin.x
	var viewport_rect_end_x = get_viewport_rect().end.x
	
	# decide angle and play
	if viewport_x_pos > (viewport_rect_end_x * 0.66):
		$AnimationPlayer.play(prefix + "_left")
	elif viewport_x_pos > (viewport_rect_end_x * 0.33):
		$AnimationPlayer.play(prefix + "_top_left")
	else:
		$AnimationPlayer.play(prefix + "_top")

func destroy():
	destroyed = true
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	queue_free()


func _on_animation_player_animation_finished(anim_name: String):
	# if shooting is done, reset timer
	if anim_name.begins_with("shoot"):
		attack_timer = 0