extends Node2D

const AirPlane = preload("res://game/enemies/Plane.tscn")

var current_speed = 0

enum { PRE_INTRO, INTRO, POST_INTRO }
var intro_state = PRE_INTRO

var plane = AirPlane.instance()

onready var main_layer = $Camera2D/ParallaxBackground/MainLayer
onready var front_layer = $Camera2D/ParallaxBackground/FrontLayer
onready var front_building_container = $Camera2D/ParallaxBackground/FrontLayer/FrontBuildingContainer
onready var peron: Peron = $Camera2D/ParallaxBackground/MainLayer/Peron as Peron
onready var camera = $Camera2D

func _ready():
	peron.walk()

	update_front_buildings()

func _process(delta):
	update_intro()

	peron.position.x += current_speed * delta

	if intro_state != POST_INTRO:
		return

	camera.position.x = peron.position.x
	input()
	update_front_buildings()

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

var shooting_laser = false

func input():
	var mouse_pressed = Input.is_mouse_button_pressed(BUTTON_LEFT)

	if shooting_laser:
		if mouse_pressed:
			rotate_laser()
		else:
			end_laser()

	if peron.is_attacking():
		return
	if Input.is_action_just_pressed("attack_fist"):
		peron.attack_fist()
	if Input.is_action_just_pressed("attack_arm"):
		attack_arm()
	if mouse_pressed:
		laser()

func _on_Peron_started_walking():
	current_speed = Constants.PERON_SPEED

func _on_Peron_stopped_walking():
	current_speed = 0

func attack_arm():
	peron.attack_arm()
	yield(peron, "arm_landed"); # waits for the signal
	print("here we should check for front building collisions")

func laser():
	shooting_laser = true
	peron.laser()
	rotate_laser()

func end_laser():
	shooting_laser = false
	peron.laser_reverse()

func rotate_laser():
	peron.point_laser(get_viewport().get_mouse_position())

func update_front_buildings():
	var scroll_scale = front_layer.motion_scale.x
	var screen_left = camera.position.x * scroll_scale
	var screen_right = screen_left + get_viewport_rect().size.x * scroll_scale

	front_building_container.update_building_pool(screen_left, screen_right)

func _on_AIDirector_enemy_needed(enemy_type, x):
	print("here should spawn %s at %d" % [enemy_type, x])
	match enemy_type:
		"plane":
			plane.position.x = get_viewport_rect().size.x + x
			main_layer.add_child(plane)
		"building":
			pass
		"cannon":
			pass
