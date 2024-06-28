extends Node2D

const AirPlane = preload("res://game/enemies/Plane.tscn")
const Bomb = preload("res://game/enemies/Bomb.tscn")
const EnemyBuilding = preload("res://game/enemies/EnemyBuilding.tscn")

var current_speed = 0

enum { PRE_INTRO, INTRO, POST_INTRO }
var intro_state = PRE_INTRO

@onready var main_layer = $Camera2D/ParallaxBackground/MainLayer
@onready var front_layer = $Camera2D/ParallaxBackground/FrontLayer
@onready var foreground = $Camera2D/ParallaxBackground/FrontLayer/Foreground
@onready var peron: Peron = $Camera2D/ParallaxBackground/MainLayer/Peron as Peron
@onready var camera = $Camera2D

func _ready():
	peron.walk()

func _process(delta):
	update_intro()
	update_foreground()

	peron.position.x += current_speed * delta

	if intro_state != POST_INTRO:
		return

	camera.position.x = peron.position.x
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

var shooting_laser = false

func input():
	var mouse_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

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

func laser():
	shooting_laser = true
	peron.laser()
	rotate_laser()

func end_laser():
	shooting_laser = false
	peron.laser_reverse()

func rotate_laser():
	peron.point_laser(get_viewport().get_mouse_position())

func update_foreground():
	var scroll_scale = front_layer.motion_scale.x
	var screen_left = camera.position.x * scroll_scale
	var screen_right = screen_left + get_viewport_rect().size.x * scroll_scale

	foreground.update_building_pool(screen_left, screen_right)

func _on_AIDirector_enemy_needed(enemy_type, x):
	match enemy_type:
		"plane":
			spawn_plane(x)
		"building":
			spawn_building(x)
		"cannon":
			spawn_cannon(x)

func spawn_plane(x: float):
	var plane: AirPlane = AirPlane.instantiate()
	plane.position.x = get_viewport_rect().size.x + x
	plane.player = peron
	var error_code = plane.connect("bomb_dropped", Callable(self, "_on_Plane_bomb_dropped"))
	if error_code != 0:
		print("ERROR: when connecting bomb_dropped signal", error_code)
	main_layer.add_child(plane)

func spawn_building(x: float):
	var enemy_building = EnemyBuilding.instantiate()
	enemy_building.position.y = get_viewport_rect().size.y
	enemy_building.position.x = get_viewport_rect().size.x + x
	main_layer.add_child(enemy_building)

func spawn_cannon(x: float):
	print("here should spawn cannon at %d" % [x])

func _on_Plane_bomb_dropped(position: Vector2):
	var bomb: Bomb = Bomb.instantiate()
	bomb.position = position
	main_layer.add_child(bomb)
