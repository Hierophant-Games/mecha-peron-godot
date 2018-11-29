extends Node2D

var current_speed = 0

enum { PRE_INTRO, INTRO, POST_INTRO }
var intro_state = PRE_INTRO

var fist = preload("res://game/Fist.tscn").instance()

onready var Constants = get_node("/root/Constants")
onready var peron = $Peron
onready var peron_fist_start = $Peron/FistStart
onready var camera = $Camera2D

func _ready():
	peron.walk()

func _process(delta):
	update_intro()
	
	peron.position.x += current_speed * delta
	
	if intro_state != POST_INTRO:
		return
	
	update_camera()
	input()

func update_intro():
	match intro_state:
		PRE_INTRO:
			if peron.position.x > 0:
				intro_state = INTRO
				Engine.time_scale = 1
				peron.idle()
			if Input.is_action_just_pressed("ui_accept"):
				Engine.time_scale = 4;
		INTRO:
			if Input.is_action_just_pressed("ui_accept"):
				intro_state = POST_INTRO
				Engine.time_scale = 1
				peron.walk()

func update_camera():
	camera.position.x = peron.position.x

func input():
	if peron.is_attacking():
		return
	if Input.is_action_just_pressed("attack_fist"):
		peron.attack_fist()
	if Input.is_action_just_pressed("attack_arm"):
		peron.attack_arm()

func _on_Peron_started_walking():
	current_speed = Constants.PERON_SPEED

func _on_Peron_stopped_walking():
	current_speed = 0

func _on_Peron_fist_launched():
	fist.position = peron_fist_start.global_position
	add_child(fist)

func _on_Peron_arm_landed():
	print("here we should check for front building collisions")
