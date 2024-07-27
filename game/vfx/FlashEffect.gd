class_name FlashEffect
extends Control

@export var color := Color.WHITE
@export var duration := 1.0

@onready var anim_player := $AnimationPlayer as AnimationPlayer
@onready var timer := $Timer as Timer

func _ready() -> void:
	var anim := anim_player.get_animation("fade")
	anim.track_set_key_value(0, 0, color)
	anim.track_set_key_value(0, 1, Color(color, 0.0))
	var anim_speed := anim.length / duration
	anim_player.play("fade", -1, anim_speed)
	
	timer.start(duration)

func _on_timer_timeout() -> void:
	queue_free()
